function [C, Leff, MagnetType, A] = magnetcoefficients(MagnetCoreType, Amps, InputType)
%MAGNETCOEFFICIENTS - Retrieves coefficient for conversion between Physics and Hardware units
%[C, Leff, MagnetType, A] = magnetcoefficients(MagnetCoreType)
%
% INPUTS
% 1. MagnetCoreType - Family name or type of magnet
%
% OUTPUTS
% 1. C vector coefficients for the polynomial expansion of the magnet field
%    based on magnet measurements
% 2. Leff - Effective length ie, which is used in AT
% 3. MagnetType
% 4. A - vector coefficients for the polynomial expansion of the curviline
%        integral of the magnet field based on magnet measurements
%
% C and A are vector coefficients for the polynomial expansion of the magnet field
% based on magnet measurements.
%
% The amp2k and k2amp functions convert between the two types of units.
%   amp2k returns BLeff, B'Leff, or B"Leff scaled by Brho if A-coefficients are used.
%   amp2k returns B    , B'    , or B"     scaled by Brho if C-coefficients are used.
%
% The A coefficients are direct from magnet measurements with a DC term:
%   a8*I^8+a7*I^7+a6*I^6+a5*I^5+a4*I^4+a3*I^3+a2*I^2+a1*I+a0 = B*Leff or B'*Leff or B"*Leff
%   A = [a8 a7 a6 a5 a4 a3 a2 a1 a0]
%
% C coefficients have been scaled to field (AT units, except correctors) and includes a DC term:
%   c8 * I^8+ c7 * I^7+ c6 * I^6 + c5 * I^5 + c4 * I^4 + c3 * I^3 + c2 * I^2 + c1*I + c0 = B or B' or B"
%   C = A/Leff
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
% See Also amp2k, k2amp

%
% Written by M. Yoon 4/8/03
% Adapted By Laurent S. Nadolski
%

% NOTE: Make sure the sign on the 'C' coefficients is reversed where positive current generates negative K-values
% Or use Tango K value set to -1


if nargin < 1
    error('MagnetCoreType input required');
end

if nargin < 2
    Amps = 230;  % not sure!!!
end

if nargin < 3
    InputType = 'Amps';
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

    case 'BEND'
        % B = 1.4214 T for I = 580 A
        Leff = 1.383684;
        a7= 0.0;
        a6=-0.0;
        a5= 0.0;
        a4=-0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1.4214*Leff/580; % BL/I @ 3 GeV
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'BEND';

    case {'QF1','QF2','QF3'}
        % k=2 for I = 180 A @ 3 GeV

        % Find the current from the given polynomial for B'Leff
        Leff=0.29;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.0/180*getbrho(3)*Leff; % kL/I*Brho
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'QF4'}
        % k=2 for I = 180 A

        % Find the current from the given polynomial for B'Leff
        Leff=0.230;


        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.0/180*getbrho(3)*Leff; % kL/I*Brho
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';
  
    case {'QF5', 'QF8'}
        % k=2 for I = 180 A

        % Find the current from the given polynomial for B'Leff
        Leff=0.31;


        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.0/180*getbrho(3)*Leff; % kL/I*Brho
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';
        
  case {'QF6','QF7'}
       % k=2.2 for I = 215 A

        % Find the current from the given polynomial for B'Leff
        Leff=0.53;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.2/215*getbrho(3)*Leff; % k = 2.2 for 215 A @ 3 GeV
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'QD1'}
        % Find the current from the given polynomial for B'Leff
        Leff=0.23;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.0/180*getbrho(3)*Leff; % kL/I*Brho
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'QD2','QD3'}

        % Find the current from the given polynomial for B'Leff
        Leff=0.29;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  2.0/180*getbrho(3)*Leff; % kL/I*Brho
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'SD1','SD2', 'SD3', 'SD5'}        
        % Find the current from the given polynomial for B''Leff
        Leff=0.15/2; 
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  5.0/200*getbrho(3); % ML = 5 for 200 A @ 3 GeV
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case {'SD4'}        
        % Find the current from the given polynomial for B''Leff
        Leff=0.22/2; 
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  5.0/200*getbrho(3); % ML = 5 for 200 A @ 3 GeV
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case {'SF1', 'SF4'}
        % Find the current from the given polynomial for B''Leff
        Leff=0.15/2; 
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  5.0/200*getbrho(3); % ML = 5 for 200 A @ 3 GeV
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case {'SF2', 'SF3'}
        % Find the current from the given polynomial for B''Leff
        Leff=0.22/2; 
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  5.0/200*getbrho(3); % ML = 5 for 200 A @ 3 GeV
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case 'QT'    % 160 mm dans sextupole
        Leff = 1e-8;
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1.0;
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'QT';

    case {'HCM'}    % 16 cm horizontal corrector
        Leff = 0.16; % To be changed for ALBA if thick correctors
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1e-3 * getbrho(3) / 10; % 10A for 1 mrad
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'COR';
   
    case {'VCM'}    % 16 cm vertical corrector       
        Leff = 0.16; % To be changed for ALBA if thick correctors
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1e-3 * getbrho(3) / 10; % 10A for 1 mrad
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'COR';

 
    otherwise
        error(sprintf('MagnetCoreType %s is not unknown', MagnetCoreType));
        k = 0;
        MagnetType = '';
        return
end

% compute B-field = int(Bdl)/Leff
C = A / Leff;

MagnetType = upper(MagnetType);


% Power Series Denominator (Factoral) be AT compatible
if strcmpi(MagnetType,'SEXT')
    C = C / 2;
end
if strcmpi(MagnetType,'OCTO')
    C = C / 6;
end
