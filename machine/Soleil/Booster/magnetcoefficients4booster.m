function [C, Leff, MagnetType, A] = magnetcoefficients4booster(MagnetCoreType)
%MAGNETCOEFFICIENTS - Retrieves coefficient dor converion between Physics and Hardware units
%[C, Leff, MagnetType, A] = magnetcoefficients(MagnetCoreType)
%
% INPUTS
% 1. MagnetCoreType - Family name or type of magnet
%
% OUTPUTS
% 1. C vector coefficients for the polynomial expansion of the magnet field
%    based on magnet measurements
% 2. Leff - Effective length
% 3. MagnetType
% 4. A - vector coefficients for the polynomial expansion of the magnet field
%        based on magnet measurements
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
%   For SOLEIL:   BEND
%                 Q1 - Q10 S1 - S10, 
%                 QT, HCOR, VCOR, FHCOR, FVCOR 
%
% Leff is the effective length of the magnet

%
% Written by M. Yoon 4/8/03
% Modified By Laurent Nadolski

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

%%%%
switch upper(deblank(MagnetCoreType))
    
    case 'BEND'    % 1052.43 mm 
        i0= 525.0; % 525 A <--> (1.71 T) <--> 2.75 GeV
        Leff=1.05243;
        a7= 0.0;
        a6=-0.0;
        a5= 0.0;
        a4=-0.0;
        a3= 0.0;
        a2=-0.0;
        a1= 0.0;
        a0= 1.71*Leff/i0;
        
        c8 = -a7/(i0^7);           %negative signs added for defocusing
        c7 = -a6/(i0^6);
        c6 = -a5/(i0^5);
        c5 = -a4/(i0^4);
        c4 = -a3/(i0^3);
        c3 = -a2/(i0^2);
        c2 =  a1/i0;
        c1 =  a0;
        c0 =  0.0;
        MagnetType = 'BEND'; 
                
    case {'QF','QD'}   % 320 mm quadrupole
        % Find the current from the given polynomial for B'Leff
        Leff=0.320;
        i0=  260;
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  0.0;
        a0=  2.15*Leff*getbrho/i0; % K= 2.15 m-2 <--> 260 A 
        
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
        
    case {'SF','SD'}    % 160 mm focusing sextupole
    % Find the current from the given polynomial for B''Leff
        a7=  0.0;
        a6=  0.0;
        a5= -0.0;
        a4=  0.0;
        a3= -0.0;
        a2=  0.0;
        a1=  0.0;
        a0=  4.1327e+06;
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
        Leff=0.160;
                    
    case {'HCOR'}    % 16 cm horizontal corrector
        % Magnet Spec: Theta = 0.8e-3 radians @ 2.75 GeV and 10 amps
        % Theta = BLeff / Brho    [radians]
        % Therefore,
        %       Theta = ((BLeff/Amp)/ Brho) * I 
        %       BLeff/Amp = 0.8e-3 * getbrho(2.75) / 10
        %       B*Leff = a0 * I   => a0 = 0.8e-3 * getbrho(2.75) / 10
        %
        % The C coefficients are w.r.t B
        %       B = c0 + c1*I = (0 + a0*I)/Leff 
        % However, AT uses Theta in radians so the A coefficients  
        % must be used for correctors with the middle layer with 
        % the addition of the DC term
        
        % Find the current from the given polynomial for BLeff and B
        % NOTE: AT used BLeff (A) for correctors
        Leff = .16;
        imax = 10;
        cormax = 0.8e-3 ; % 0.8 mrad for imax = 10 A
        MagnetType = 'COR';       
        A = [0 cormax*getbrho(2.75)/imax]; 
        C = [0 A 0] / Leff;
        return
        
    case {'VCOR'}    % 16 cm vertical corrector
        % Find the current from the given polynomial for BLeff and B
        Leff = .16;
        imax = 10;
        cormax = 0.8e-3 ; % 0.8 mrad for imax = 10 A
        MagnetType = 'COR';       
        A = [0 cormax*getbrho(2.75)/imax]; 
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
