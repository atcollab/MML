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

    case 'BEND'    % 110 cm dipole
        c7=0.0;
        c6=0.0;
        c5=0.0;
        c4=0.0;
        c3=0.0;
        c2=0.0;
        c1=0.001783;
        c0=0.009846;
        Leff=1.1;
        MagnetType = 'bend';

    case 'Q1'    % 24 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=-0.00089480;
        c0=-0.00005407;
        Leff=0.24;
        MagnetType = 'quad';

    case 'Q2'    % 53 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.002088;
        c0=-0.0008875;
        Leff=0.53;
        MagnetType = 'quad';

    case 'Q3'    % 35 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=-0.001346;
        c0= 0.0001671;
        Leff=0.35;
        MagnetType = 'quad';

    case 'Q4'    % 35 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=-0.0003161;
        c0=-0.00001679;
        Leff=0.35;
        MagnetType = 'quad';

    case 'Q5'    % 53 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.0004899;
        c0=-0.00007151;
        Leff=0.53;
        MagnetType = 'quad';

    case 'Q6'    % 24 cm quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=-0.0002098;
        c0=-0.0001638;
        Leff=0.24;
        MagnetType = 'quad';

     case 'SkewQuad'    % skew quadrupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.000357;
        c0=0.;
        Leff=0.18;
        MagnetType = 'SkewQuad';

    case 'SF'    % 20 cm sextupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.0001511;
        c0=-0.00006671;
        mag='sext';
        Leff=0.2;
        MagnetType = 'sext';

    case 'SD'    % 20 cm sextupole
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=-0.0001521;
        c0=0.00001565;
        Leff=0.2;
        MagnetType = 'sext';

    case 'HCM'    % 23.2 cm horizontal corrector
        % Magnet Spec: Theta = 1.5e-3 radians @ 2.5 GeV and 90 amps  ?????
        % Theta = BLeff / Brho    [radians]
        % Therefore,
        %       Theta = ((BLeff/Amp)/ Brho) * I
        %       BLeff/Amp = 1.5e-3 * getbrho(3) / 30
        %       B*Leff = a0 * I   => a0 = 1.5e-3 * getbrho(3) / 30
        %
        % The C coefficients are w.r.t B
        %       B = c0 + c1*I = (0 + a0*I)/Leff
        % Leff = .232;
        % i0 = 90;
        % MagnetType = 'cor';
        % C = [0 (1.5e-3???*getbrho(2.5)/90) 0];
        
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.000349;     % Linear term
        c0=0; %-0.00009796;  % Offset
        Leff=0.232;
        MagnetType = 'COR';
        A = [0 c1];
        C = [0 A 0] / Leff;
        return

    case 'VCM'    % 23.2 cm horizontal corrector
        % Find the current from the given polynomial for B'Leff
        c7=0.;
        c6=0.;
        c5=0.;
        c4=0.;
        c3=0.;
        c2=0.;
        c1=0.0001744;    % Linear term
        c0=0; %-0.00002926;  % Offset
        Leff=0.232;
        MagnetType = 'COR';
        A = [0 c1];
        C = [0 A 0] / Leff;
        return

    otherwise
        disp('Warning: Family not found in magnetcoefficients');
        Leff=0;
        MagnetType = '';
        C=[];
        return

end


C = [c7 c6 c5 c4 c3 c2 c1 c0] / Leff;

MagnetType = upper(MagnetType);


% Power Series Denominator (Factoral) be AT compatible  (not sure about this???)
if strcmpi(MagnetType,'QUAD')
    C = C / 0.03;
end
if strcmpi(MagnetType,'SkewQuad')
    C = C / 0.03;
end
if strcmpi(MagnetType,'SEXT')
%    C = C * 2*Leff/0.03/0.03;
    C = C /0.03/0.03;
end


% % Power Series Denominator (Factoral) be AT compatible
% if strcmpi(MagnetType,'SEXT')
%     C = C / 2;
% end
% if strcmpi(MagnetType,'OCTO')
%     C = C / 6;
% end
