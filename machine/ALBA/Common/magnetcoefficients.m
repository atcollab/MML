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
        % Moyenne des longueurs magn�tiques mesur�es = 1055.548mm
        % Décalage en champ entre le dip�le de référence et les
        % dip�les de l'Anneau = DB/B= +1.8e-03.
        % On part de l'�talonnage B(I) effectu� sur le dip�le de
        % r�f�rence dans la zone de courant 516 - 558 A
        % les coefficients du fit doivent �tre affect�s du facteur
        % (1-1.8e-3) pour passer du dip�le de r�f�rence � l'Anneau
        % et du facteur Leff pour passer � l'int�grale de champ.
        %

        % B=1.7063474 T correspond � 2.75 GeV
        % ?  longueur magnétique du model : Leff = 1.052433;

        Leff=1.052433;
        a7= 0.0;
        a6=-0.0;
        a5= 0.0;
        a4=-0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1.0;
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];


        MagnetType = 'BEND';

    case {'QF1', 'QF2', 'QF3', 'QF4', 'QF5', 'QF6', 'QF7', 'QF8'}
        % Etalonnage GL(I) sur 90 - 150 A quadrup�le court
        % le courant remont� est n�gatif car Q1 et Q6 d�focalisants
        % il faut donc un k < 0. Les coefficients du fit a0, a2,
        % a4,...sont multipli�s par -1.

        % Correction des coefficients des QC de + 3 10-3 (manque
        % capteur BMS)

        % Find the current from the given polynomial for B'Leff
        Leff=0.320;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  1.0;
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'QD1', 'QD2', 'QD3'}
        % Etalonnage GL(I) sur 90 - 150 A quadrup�le court
        % le courant remont� est n�gatif car Q1 et Q6 d�focalisants
        % il faut donc un k < 0. Les coefficients du fit a0, a2,
        % a4,...sont multipli�s par -1.

        % Correction des coefficients des QC de + 3 10-3 (manque
        % capteur BMS)

        % Find the current from the given polynomial for B'Leff
        Leff=0.320;

        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  1.0;
        a0=  0.0;

        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'quad';

    case {'SF1', 'SF2', 'SF3', 'SF4'}
        % l= 160 mm focalisants
        % Etalonnage HL(I) sur 40 - 160 A
        % Find the current from the given polynomial for B''Leff
        Leff=1e-8; % modeled as thin length;
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  1.0;
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case {'SD1', 'SD2', 'SD3', 'SD4', 'SD5'}
        % l= 160 mm focalisants
        % Etalonnage HL(I) sur 40 - 160 A
        % Find the current from the given polynomial for B''Leff
        Leff=1e-8; % modeled as thin length;
        a7=  0.0;
        a6=  0.0;
        a5=  0.0;
        a4=  0.0;
        a3=  0.0;
        a2=  0.0;
        a1=  1.0;
        a0=  0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0]*2;
        MagnetType = 'SEXT';

    case 'QT'    % 160 mm dans sextupole
        % Etalonnage: moyenne sur les 32 sextup�les incluant un QT.
        % Efficacite = 3 G.m/A @ R=32mm; soit 93.83 G/A
        % Le signe du courant est donn� par le DeviceServer (Tango)
        % Find the currAO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = magnetcoefficients(AO.(ifam).FamilyName );
        Leff = 1e-8;
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 93.83E-4;
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'QT';

    case {'HCM'}    % 16 cm horizontal corrector
        % Etalonnage: moyenne sur les 56 sextup�les incluant un CORH.
        % Efficacit� = 8.143 G.m/A
        % Le signe du courant est donn� par le DeviceServer (Tango)
        % Find the currAO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = magnetcoefficients(AO.(ifam).FamilyName );
        Leff = 0.16;
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1;
        a0= 0.0;
        A = [a7 a6 a5 a4 a3 a2 a1 a0];

        MagnetType = 'COR';

    case {'VCM'}    % 16 cm vertical corrector
        % Etalonnage: moyenne sur les 56 sextup�les incluant un CORV.
        % Efficacit� = 4.642 G.m/A
        % Le signe du courant est donn� par le DeviceServer (Tango)
        % Find the currAO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = magnetcoefficients(AO.(ifam).FamilyName );
        Leff = 0.16;
        a7= 0.0;
        a6= 0.0;
        a5= 0.0;
        a4= 0.0;
        a3= 0.0;
        a2= 0.0;
        a1= 1;
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

