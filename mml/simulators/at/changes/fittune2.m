function varargout =  fittune2(newtunes, quadfam1, quadfam2, varargin);
% fittune2 uses two families of qaudrupoles to fit linear tunes.
%
% modified 2000-09-26, Christoph Steier 
% to use both the k-value and PolynomB(2) in oder to make this routine
% work both for the LinearPass and SymplecticPass cases.
%
% modified 2000-11-07, Christoph Steier
% use smaller stepsize for differentiation, use fprintf to print
% status information, fit tune iteratively
%

% Must declare THERING as global in order for the function to modify Quad values 
global THERING
delta = 1e-5; % step size for numeric differentiation

% find indexes of the 2 quadrupole families use for fitting
Q1I = findcells(THERING,'FamName',quadfam1);
Q2I = findcells(THERING,'FamName',quadfam2);

InitialK1 = getcellstruct(THERING,'K',Q1I);
InitialK2 = getcellstruct(THERING,'K',Q2I);
InitialPolB1 = getcellstruct(THERING,'PolynomB',Q1I,2);
InitialPolB2 = getcellstruct(THERING,'PolynomB',Q2I,2);

% Compute initial tunes before fitting 
[ LD, InitialTunes] = linopt(THERING,0);
fprintf('Tunes before FitTune2: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));

TempTunes = InitialTunes;
TempK1 = InitialK1;
TempK2 = InitialK2;
TempPolB1 = InitialPolB1;
TempPolB2 = InitialPolB2;

fprintf('distance from goal: %g\n',max(abs(TempTunes(:)-newtunes(:))));

while any(abs(TempTunes(:)-newtunes(:))>1e-7)

% Take Derivative
THERING = setcellstruct(THERING,'K',Q1I,TempK1+delta);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1+delta,2);
[LD , Tunes_dK1 ] = linopt(THERING,0);
THERING = setcellstruct(THERING,'K',Q1I,TempK1);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);
THERING = setcellstruct(THERING,'K',Q2I,TempK2+delta);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2+delta,2);
[LD , Tunes_dK2 ] = linopt(THERING,0);
THERING = setcellstruct(THERING,'K',Q2I,TempK2);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);

%Construct the Jacobian
J = ([Tunes_dK1(:) Tunes_dK2(:)] - [TempTunes(:) TempTunes(:)])/delta;
Jinv = inv(J);

dnu = (newtunes(:) - TempTunes(:));
dK = Jinv*dnu;

TempK1 = TempK1+dK(1);
TempK2 = TempK2+dK(2);
TempPolB1 = TempPolB1+dK(1);
TempPolB2 = TempPolB2+dK(2);

THERING = setcellstruct(THERING,'K',Q1I,TempK1);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);
THERING = setcellstruct(THERING,'K',Q2I,TempK2);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);

[ LD, TempTunes] = linopt(THERING,0);

fprintf('distance from goal: %g\n',max(abs(TempTunes(:)-newtunes(:))));

end

fprintf('Tunes after FitTune2: nu_x=%g, nu_y=%g\n',TempTunes(1),TempTunes(2));

