function [C, Leff, MagnetType, A] = magnetcoefficients(MagnetCoreType)
% [C, Leff, MagnetType, A] = magnetcoefficients(MagnetCoreType)
% 
% C and A are vector coefficients for the polynomial expansion of the magnet field
% based on magnet measurements.  
% 
% The amp2k and k2amp functions convert between the two types of units. 
%   amp2k returns BLeff, B'Leff, or B"Leff scaled by Brho if A-coefficients are used. 
%   amp2k returns B    , B'    , or B"     scaled by Brho if C-coefficients are used. 
%
% The A coefficients are direct from magnet measurements:
%   (a7/I0)*I^8+(a6/I0)*I^7+(a5/I0)*I^6+(a4/I0)*I^5+(a3/I0)*I^4+(a2/I0)*I^3+(a1/I0)*I^2+a0*I = B*Leff or B'*Leff or B"*Leff
%   A = [a7 a6 a5 a4 a3 a2 a1 a0]
%
% C coefficients have been scaled to field (AT units, except correctors) and includes a DC term:
%   c8 * I^8+ c7 * I^7+ c6 * I^6 + c5 * I^5 + c4 * I^4 + c3 * I^3 + c2 * I^2 + c1*I + c0 = B or B' or B"
%   C = [c8 c7 c6 c5 c4 c3 c2 c1 c0]
%
% For dipole:      k = B / Brho      (for AT: KickAngle = BLeff / Brho)
% For quadrupole:  k = B'/ Brho
% For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%                  (all coefficients all divided by 2 for sextupoles)
%
% MagnetCoreType is the magnet measurements name for the magnet core (string, string matrix, or cell)
%   For Spear3:   BEND, BDM
%                 QD, QF, QDX, QDY, QDZ, QFZ, QFC, QFY, QFX, SkewQuad
%                 SFM, SDM, SF, SD
%                 HCM, VCM
%
% Leff is the effective length of the magnet
%
% Written by M. Yoon 4/8/03


% NOTE: The skew quad magnets need to be updated
% NOTE: The skew quad magnet is distributed on two types of core,
%       therefore might need to pass in device list
%       same could be true with quadshunt (current switched into many types of cores)
% NOTE: All 'C' coefficients divided by Leff at bottom of program: C/Leff
% NOTE: Make sure the sign on the 'C' coefficients is reversed where positive current generates negative K-values


if nargin < 1
    error('MagnetCoreType input required');
end


% For a string matrix
if iscell(MagnetCoreType)
    for i = 1:size(MagnetCoreType,1)
        for j = 1:size(MagnetCoreType,2)
            [C{i,j}, Leff{i,j}, MagnetType{i,j}, A{i,j}] = magnetcoefficients(MagnetCoreType{i});
        end
    end
    return
end

% For a string matrix
if size(MagnetCoreType,1) > 1
    C=[]; Leff=[]; MagnetType=[]; A=[];
    for i = 1:size(MagnetCoreType,1)
        [C1, Leff1, MagnetType1, A1] = magnetcoefficients(MagnetCoreType(i,:));
        C(i,:) = C1;
        Leff(i,:) = Leff1;
        MagnetType = strvcat(MagnetType, MagnetType1);
        A(i,:) = A1;
    end
    return
end


switch upper(deblank(MagnetCoreType))
    
    case 'BEND'    % 145 cm dipole
        a7= 0.0137956;
        a6=-0.0625519;
        a5= 0.1156769;
        a4=-0.1141570;
        a3= 0.0652128;
        a2=-0.0216472;
        a1= 0.0038866;
        a0= 0.0028901;
        i0= 700.0;
        
        c8 = -a7/(i0^7);           %negative signs added for defocusing
        c7 = -a6/(i0^6);
        c6 = -a5/(i0^5);
        c5 = -a4/(i0^4);
        c4 = -a3/(i0^3);
        c3 = -a2/(i0^2);
        c2 = -a1/i0;
        c1 = -a0;
        c0 =  0.0;
        MagnetType = 'bend';   %  or Quad ????
        Leff=1.5048;
        
 
        % Why the 2.54842790129284 scale factor?????
        K2BendingAngle = 2.54842790129284 *  -0.58596106939159;  % ScaleFactor * BendAngle / K
        c8 = c8 * K2BendingAngle;    
        c7 = c7 * K2BendingAngle;
        c6 = c6 * K2BendingAngle;
        c5 = c5 * K2BendingAngle;
        c4 = c4 * K2BendingAngle;
        c3 = c3 * K2BendingAngle;
        c2 = c2 * K2BendingAngle;
        c1 = c1 * K2BendingAngle;
        c0 = c0 * K2BendingAngle;

  
    case 'BDM'    % 109 cm dipole
        a7= 0.02897777;
        a6=-0.13177140;
        a5= 0.24886798;
        a4=-0.25373053;
        a3= 0.15088883;
        a2=-0.05232964;
        a1= 0.00979594;
        a0= 0.00165748;
        i0= 700.0;

        c8 = -a7/(i0^7);
        c7 = -a6/(i0^6);
        c6 = -a5/(i0^5);
        c5 = -a4/(i0^4);
        c4 = -a3/(i0^3);
        c3 = -a2/(i0^2);
        c2 = -a1/i0;
        c1 = -a0;
        c0 = 0;
        MagnetType = 'bend';
        Leff=1.14329;

        % Why the 2.54842790129284 scale factor?????
        K2BendingAngle = 2.54842790129284 * -0.43947079695140;   % ScaleFactor * BendAngle / K
        c8 = c8 * K2BendingAngle;    
        c7 = c7 * K2BendingAngle;
        c6 = c6 * K2BendingAngle;
        c5 = c5 * K2BendingAngle;
        c4 = c4 * K2BendingAngle;
        c3 = c3 * K2BendingAngle;
        c2 = c2 * K2BendingAngle;
        c1 = c1 * K2BendingAngle;
        c0 = c0 * K2BendingAngle;
        
    case 'QD'    % 15 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        a7= 0.0;
        a6= 0.0;
        a5= 0.0000714;
        a4=-0.0010063;
        a3= 0.0041290;
        a2=-0.0072642;
        a1= 0.0056763;
        a0= 0.0400229;
        i0= 30.0;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 =-a5/(i0^5);           %negative signs added for defocusing
        c5 =-a4/(i0^4);
        c4 =-a3/(i0^3);
        c3 =-a2/(i0^2);
        c2 =-a1/i0;
        c1 =-a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.1634591;
        
    case {'QF','QFZ'}   % 34 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0003188;
        a4=  0.0023622;
        a3= -0.0068241;
        a2=  0.0094207;
        a1= -0.0061664;
        a0=  0.0914316;
        i0=  30.0;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 = a5/(i0^5);
        c5 = a4/(i0^4);
        c4 = a3/(i0^3);
        c3 = a2/(i0^2);
        c2 = a1/i0;
        c1 = a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.3533895;
        
    case {'QDX','QDY','QDZ'}   % 34 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0003188;
        a4=  0.0023622;
        a3= -0.0068241;
        a2=  0.0094207;
        a1= -0.0061664;
        a0=  0.0914316;
        i0=  30.0;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 =-a5/(i0^5);           %negative signs added for defocusing
        c5 =-a4/(i0^4);
        c4 =-a3/(i0^3);
        c3 =-a2/(i0^2);
        c2 =-a1/i0;
        c1 =-a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.3533895;
        
    case {'QFC','QFY'}    % 50 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0004134;
        a4=  0.0031409;
        a3= -0.0092872;
        a2=  0.0130952;
        a1= -0.0087242;
        a0=  0.1325335;
        i0=  30.;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 = a5/(i0^5);
        c5 = a4/(i0^4);
        c4 = a3/(i0^3);
        c3 = a2/(i0^2);
        c2 = a1/i0;
        c1 = a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.5123803;
        
    case 'QFX'    % 60 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.000237;
        a4=  0.001695;
        a3= -0.004792;
        a2=  0.006476;
        a1= -0.004082;
        a0=  0.156269;
        i0=  30.0;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 = a5/(i0^5);
        c5 = a4/(i0^4);
        c4 = a3/(i0^3);
        c3 = a2/(i0^2);
        c2 = a1/i0;
        c1 = a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.6105311;
        
    case {'SFM','SF'}    % 21 cm focusing sextupole
    % Find the current from the given polynomial for B''Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0107727;
        a4=  0.0459790;
        a3= -0.0720837;
        a2=  0.0471957;
        a1= -0.0106293;
        a0=  0.6128320;
        i0=  100.0;

        c8 = 0.0;
        c7 = 0.0;
        c6 = a5/(i0^5);
        c5 = a4/(i0^4);
        c4 = a3/(i0^3);
        c3 = a2/(i0^2);
        c2 = a1/i0;
        c1 = a0;
        c0 = 0.0;
    MagnetType = 'sext';
    Leff=0.2315;
    
    case {'SDM'}    % 21 cm defocusing sextupole
    % Find the current from the given polynomial for B''Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0107727;
        a4=  0.0459790;
        a3= -0.0720837;
        a2=  0.0471957;
        a1= -0.0106293;
        a0=  0.6128320;
        i0=  100.0;

        c8 = -0.0;
        c7 = -0.0;
        c6 = -a5/(i0^5);           %negative signs added for defocusing
        c5 = -a4/(i0^4);
        c4 = -a3/(i0^3);
        c3 = -a2/(i0^2);
        c2 = -a1/i0;
        c1 = -a0;
        c0 =  0.0;
    MagnetType = 'sext';
    Leff=0.2315;
                
    case 'SD'    % 25 cm defocusing sextupole
% Find the current from the given polynomial for B"Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0112668;
        a4=  0.0493422;
        a3= -0.0794635;
        a2=  0.0535139;
        a1= -0.0124097;
        a0=  0.7228901;
        i0=  100.;

        c8 = -0.0;
        c7 = -0.0;
        c6 = -a5/(i0^5);           %negative signs added for defocusing
        c5 = -a4/(i0^4);
        c4 = -a3/(i0^3);
        c3 = -a2/(i0^2);
        c2 = -a1/i0;
        c1 = -a0;
        c0 = -0.0;
    MagnetType = 'sext';
    Leff=0.2730;
        
    case 'SkewQuad'    % 21 cm or 25 cm sextupole
        % Find the current from the given polynomial for B'Leff
        
        % These are not correct.  They are a copy of QD
        a7= 0.0;
        a6= 0.0;
        a5= 0.0000714;
        a4=-0.0010063;
        a3= 0.0041290;
        a2=-0.0072642;
        a1= 0.0056763;
        a0= 0.0400229;
        i0= 30.;
        
        c8 = 0.0;
        c7 = 0.0;
        c6 = a5/(i0^5);
        c5 = a4/(i0^4);
        c4 = a3/(i0^3);
        c3 = a2/(i0^2);
        c2 = a1/i0;
        c1 = a0;
        c0 = 0.0;
        MagnetType = 'quad';
        Leff=0.1634591;
        
    case 'HCM'    % 15 cm horizontal corrector
        % Magnet Spec: Theta = 1.5e-3 radians @ 3 GeV and 30 amps
        % Theta = BLeff / Brho    [radians]
        % Therefore,
        %       Theta = ((BLeff/Amp)/ Brho) * I 
        %       BLeff/Amp = 1.5e-3 * getbrho(3) / 30
        %       B*Leff = a0 * I   => a0 = 1.5e-3 * getbrho(3) / 30
        %
        % The C coefficients are w.r.t B
        %       B = c0 + c1*I = (0 + a0*I)/Leff 
        % However, AT uses Theta in radians so the A coefficients  
        % must be used for correctors with the middle layer with 
        % the addition of the DC term
        
        % Find the current from the given polynomial for BLeff and B
        % NOTE: AT used BLeff (A) for correctors
        Leff = .15;
        i0 = 30;
        MagnetType = 'COR';       
        A = [0 (1.5e-3*getbrho(3)/30)];
        C = [0 A 0] / Leff;
        return
        
    case 'VCM'    % 15 cm vertical corrector
        % Find the current from the given polynomial for BLeff and B
        Leff = .15;
        i0 = 30;
        MagnetType = 'COR';       
        A = [0 (.75e-3*getbrho(3)/30)];
        C = [0 A 0] / Leff;
        return
    
otherwise 
        error(sprintf('MagnetCoreType %s is not unknown', MagnetCoreType));
        %k = 0;
        %MagnetType = '';
        %return
end

A = [a7 a6 a5 a4 a3 a2 a1 a0];
C = [c8 c7 c6 c5 c4 c3 c2 c1 c0] / Leff;

MagnetType = upper(MagnetType);


% Power Series Denominator (Factoral) be AT compatible
if strcmpi(MagnetType,'SEXT')
    C = C / 2;
end
if strcmpi(MagnetType,'OCTO')
    C = C / 6;
end
