function [C, Leff, MagnetType] = magnetcoefficients(MagnetCoreType)
% [C, Leff, MagnetType] = magnetcoefficients(MagnetCoreType)
% 
% C is a curve for the particular magnet and is a 2 column vector. The
% first column contains the current values at which the magnet was tested
% and the second colum the measured B, B' or B" values.
%
% Unlike Spear3 that use polynomials we will use a simple curve defined
% over a specific domain. To do the calculations, simple linear
% interpolation will only be used.
%
% The amp2k and k2amp functions convert between the two types of units. 
%   amp2k returns B    , B'    , or B"     scaled by Brho. 
%
% For dipole:      k = B / Brho      (for AT: KickAngle = BLeff / Brho)
% For quadrupole:  k = B'/ Brho
% For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%                  (all coefficients all divided by 2 for sextupoles)
%
% MagnetCoreType is the magnet measurements name for the magnet core (string, string matrix, or cell)
%   For ASP:      BEND
%                 QFA, QFB, QDA, SKQ
%                 SFA, SFB, SDA, SDB
%                 HCM, VCM
%
% Leff is the effective length of the magnet. In most cases this will be
% the same as the model length.
%
% Original structure set up using polynomials by M. Yoon 4/8/03
% Modified for ASP by E. Tan 31/05/2006

% Todo
% * What to do about Leff and how should it help in this instance?

if nargin < 1
    error('MagnetCoreType input required');
end


% For a string matrix
if iscell(MagnetCoreType)
    for i = 1:size(MagnetCoreType,1)
        for j = 1:size(MagnetCoreType,2)
            [C{i,j}, Leff{i,j}, MagnetType{i,j}] = magnetcoefficients(MagnetCoreType{i});
        end
    end
    return
end

% For a string matrix
if size(MagnetCoreType,1) > 1
    C=[]; Leff=[]; MagnetType=[];
    for i = 1:size(MagnetCoreType,1)
        [C1, Leff1, MagnetType1] = magnetcoefficients(MagnetCoreType(i,:));
        C(i,:) = C1;
        Leff(i,:) = Leff1;
        MagnetType = strvcat(MagnetType, MagnetType1);
    end
    return
end


% Directory containing the magnet calibration curves. At the moment the
% data is brought from various sources and processed in with the script
% read_BI_into_mat.m. The script draws data that has been generated from
% magnetic measurements (for quads, sextupoles and correctors) and tracking
% studies (for dipoles based on 2D field maps). See script files for more
% details. Variable saved should be BIdata.
filepath = fileparts([mfilename('fullpath')]);
load([filepath filesep 'magnet_calibration_curves' filesep 'B_vs_I_data.mat'])

switch upper(deblank(MagnetCoreType))

    case 'BEND'

        MagnetType = 'bend';
        Leff=1.726;
        
        I = BIdata.DIP.I;
        Energy = BIdata.DIP.Energy;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = Energy;
        
    case 'QDA'

        MagnetType = 'quad';
        Leff=0.18;
        CorrectionFactor = 1.01898761594704;
        
        % The below is negative because defocusing quadrupoles must return
        % negative k values.
        I = BIdata.QD.I_gen;
        B = -BIdata.QD.dBdx/Leff;

        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B;
        
    case {'QFA','QFB'}
        
        MagnetType = 'quad';
        Leff=0.355;
        
        I = BIdata.QF.I_gen;
        B = BIdata.QF.dBdx/Leff;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B;

    case {'SFA','SFB'}
        
        MagnetType = 'sext';
        Leff=0.2;
        
        % Power Series Denominator (Factoral) be AT compatible. For
        % sextupole its 2! = 2.
        I = BIdata.SVR.I_gen;
         
        B = BIdata.SVR.d2Bdx2/Leff/2;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B;

    case {'SDA','SDB'}

        MagnetType = 'sext';
        Leff=0.2;

        % Power Series Denominator (Factoral) be AT compatible. For
        % sextupole its 2! = 2.
        % The B field is negative below because SD magnets should return
        % negative K values.
        I = BIdata.SVR.I_gen;
        B = -BIdata.SVR.d2Bdx2/Leff/2;

        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B;
        
    case 'SKQ'
        % There are no magnetic measurment for this configuration on the
        % sextupoles therefore we will use the calculations done by Jack
        % Tanabe in the original design documents M009.doc. The
        % specification was to design a skew gradient field of 0.035 T/m
        % and requires 47.6 AmpTurns.  With a coil configuration of 12
        % turns this corresponds to ~4 Amps. Therefore we will assume a
        % linear relationship from zero.

        MagnetType = 'quad';
        Leff=0.2;
        
        I = [-8:8];
        B = 0.035/(47.6/12)*I;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B;

    case 'HCM'    % horizontal corrector trim coils in SH magnets
        % Magnet Spec: Theta = 1.0e-3 radians @ 3 GeV and 75.3 amps
        % Theta = BLeff / Brho    [radians]
        % Therefore,
        %       Theta = ((BLeff/Amp)/ Brho) * I
        %       BLeff/Amp = 1.0e-3 * getbrho(3) / 30
        %       B*Leff = a0 * I   => a0 = 1.5e-3 * getbrho(3) / 30
        %
        % The C coefficients are w.r.t B
        %       B = c0 + c1*I = (0 + a0*I)/Leff
        % However, AT uses Theta in radians so the A coefficients
        % must be used for correctors with the middle layer with
        % the addition of the DC term

        % Find the current from the given polynomial for BLeff and B
        % NOTE: AT used BLeff (A) for correctors
        Leff = 0.2;
        MagnetType = 'COR';
        
        i0 = BIdata.HCM.I;
        BLeff = BIdata.HCM.Bharmon(1);
        
        I = [-90:10:90];
        BL = (BLeff/i0)*I;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = BL;

    case 'VCM'    % vertical corrector trim coils in SD magnets
        % Magnet Spec: Theta = 1.0e-3 radians @ 3 GeV and 130 amps
        % Find the current from the given polynomial for BLeff and B
        Leff = 0.2;
        MagnetType = 'COR';
        
        i0 = BIdata.VCM.I;
        BLeff = BIdata.VCM.Bharmon(1);
        
        I = [-120:10:120];
        BL = (BLeff/i0)*I;
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = BL;
        
    otherwise
        error(sprintf('MagnetCoreType %s is not unknown', MagnetCoreType));
end

MagnetType = upper(MagnetType);
