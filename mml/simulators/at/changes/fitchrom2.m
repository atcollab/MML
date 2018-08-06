function varargout =  fitchrom2(newchrom, sextfam1, sextfam2, varargin);
%  fitchrom2 uses two families of sextupoles to fit linear chromaticity.
%
% 2000-09-26 modified by Christoph Steier
% increased the step size for changing the sextupoles and added one iteration
% to get reasonable results for the ALS
%
% modified 2000-11-07, Christoph Steier
% use fprintf to print
% status information, fit chromaticity iteratively

% warning('This is a temporary solution - it is very slow A.T.')
% Must declare THERING as global in order for the function to modify Sextupole values 
global THERING

deltaSrel = 1e-5; % step size for numeric differentiation
deltaP = 1e-6;

% find indexes of the 2 quadrupole families use for fitting
S1I = findcells(THERING,'FamName',sextfam1);
S2I = findcells(THERING,'FamName',sextfam2);  

InitialS1 = getcellstruct(THERING,'PolynomB',S1I,3);
InitialS2 = getcellstruct(THERING,'PolynomB',S2I,3);

% Compute initial tunes and chromaticities before fitting 

[ LD, InitialTunes] = linopt(THERING,0);
[ LDdP, ITdP] =linopt(THERING,deltaP);

InitialChrom = (ITdP-InitialTunes)/deltaP;

fprintf('Chromaticity before FitChrom2: xi_x=%g, xi_y=%g\n',InitialChrom(1),InitialChrom(2));

TempTunes = InitialTunes;
TempChrom = InitialChrom;
TempS1 = InitialS1; 
TempS2 = InitialS2;

fprintf('distance from goal: %g\n',max(abs(TempChrom(:)-newchrom(:))));

while any(abs(TempChrom(:)-newchrom(:))>1e-7)
    
    if max(abs(TempChrom(:)-newchrom(:))) < 1e-4
        deltaSrel = 1e-6; % step size for numeric differentiation
        deltaP = 1e-6;
    end
    
    deltaS=deltaSrel*max([TempS1;TempS2]);
    
	% Take Derivative
	THERING = setcellstruct(THERING,'PolynomB',S1I,TempS1+deltaS,3);
	[LD , Tunes_dS1 ] = linopt(THERING,0);
	[LD , Tunes_dS1dP ] = linopt(THERING,deltaP);

	THERING = setcellstruct(THERING,'PolynomB',S1I,TempS1,3);
	THERING = setcellstruct(THERING,'PolynomB',S2I,TempS2+deltaS,3);
	[LD , Tunes_dS2 ] = linopt(THERING,0);
	[LD , Tunes_dS2dP ] = linopt(THERING,deltaP);
	THERING = setcellstruct(THERING,'PolynomB',S2I,TempS2,3);

	%Construct the Jacobian
	Chrom_dS1 = (Tunes_dS1dP-Tunes_dS1)/deltaP;
	Chrom_dS2 = (Tunes_dS2dP-Tunes_dS2)/deltaP;

	J = ([Chrom_dS1(:) Chrom_dS2(:)] - [TempChrom(:) TempChrom(:)])/deltaS;
	Jinv = inv(J);

	dchrom = (newchrom(:) - TempChrom(:));
	dS = Jinv*dchrom;

	TempS1 = TempS1+dS(1);
	TempS2 = TempS2+dS(2);

	THERING = setcellstruct(THERING,'PolynomB',S1I,TempS1,3);
	THERING = setcellstruct(THERING,'PolynomB',S2I,TempS2,3);

	[ LD, TempTunesdP] = linopt(THERING,deltaP);
	[ LD, TempTunes] = linopt(THERING,0);
	TempChrom = (TempTunesdP-TempTunes)/deltaP;

   	fprintf('distance from goal: %g\n',max(abs(TempChrom(:)-newchrom(:))));

end

fprintf('Chromaticity after FitChrom2: xi_x=%g, xi_y=%g\n',TempChrom(1),TempChrom(2));
