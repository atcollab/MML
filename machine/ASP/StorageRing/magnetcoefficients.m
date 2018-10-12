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
% Rohan, Eugene: 10/02/2009: changed sign for SKQ based on measurements.

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
% Path defined in aoinit.m
load(fullfile(getmmlroot('IgnoreTheAD'),'machine','ASP','StorageRing','magnet_calibration_curves','B_vs_I_data.mat'));
% load('B_vs_I_data.mat')

switch upper(deblank(MagnetCoreType))

    case 'BEND'

        MagnetType = 'bend';
        Leff=1.726;
        
        I = BIdata.DIP.I;
        Energy = BIdata.DIP.Energy;
        
        % Scaling used here is based on spin depolarisation measurements
        % that put the SR energy at 3.0134 GeV when the dipole was set to
        % 614.968 Amps (RF freq 499 674 670 Hz). 27/07/2010 Eugene
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = Energy*1.024754;
        
    case 'QDA'

        MagnetType = 'quad';
        Leff=0.18+0.0084;
        
        % The below is negative because defocusing quadrupoles must return
        % negative k values.
        I = BIdata.QD.I_gen;
        B = -BIdata.QD.dBdx/Leff;

        % Scaling factor for B empirically determined by comparing model
        % predictions with measured. Eugene 21-07-2010
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
%         C(1,length(I)+1:end) = B*0.995540071082187/0.995537735778454;
        C(1,length(I)+1:end) = B*0.997549129779699;
        
    case {'QFA','QFB'}        
        
        MagnetType = 'quad';
        Leff=0.355+0.0084;
        
        I = BIdata.QF.I_gen;
        B = BIdata.QF.dBdx/Leff;
        
        % Scaling factor for B empirically determined by comparing model
        % predictions with measured. Eugene 21-07-2010
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
%         C(1,length(I)+1:end) = B*1.016228140568382/0.995267695340687;
        C(1,length(I)+1:end) = B*1.016867410211431;

    case {'SFA','SFB'}
        
        MagnetType = 'sext';
        Leff=0.2;
        
        % Power Series Denominator (Factoral) be AT compatible. For
        % sextupole its 2! = 2.
        I = BIdata.SVR.I_gen;
         
        B = BIdata.SVR.d2Bdx2/Leff/2;
        
        % Scaling factor for B empirically determined by comparing model
        % predictions with measured chromaticities. Eugene 21-07-2010
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B*0.998;0.995;

    case {'SDA','SDB'}

        MagnetType = 'sext';
        Leff=0.2;

        % Power Series Denominator (Factoral) be AT compatible. For
        % sextupole its 2! = 2.
        % The B field is negative below because SD magnets should return
        % negative K values.
        I = BIdata.SVR.I_gen;
        B = -BIdata.SVR.d2Bdx2/Leff/2;

        % Scaling factor for B empirically determined by comparing model
        % predictions with measured chromaticities. Eugene 21-07-2010
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = B*0.998;0.995;
        
    case 'SKQ'
        % There are no magnetic measurment for this configuration on the
        % sextupoles therefore we will use the calculations done by Jack
        % Tanabe in the original design documents M009.doc. The
        % specification was to design a skew gradient field of 0.035 T/m
        % and requires 47.6 AmpTurns.  With a coil configuration of 12
        % turns this corresponds to ~4 Amps. Therefore we will assume a
        % linear relationship from zero.

        % Rohan, Eugene 10/02/2009: Changed the sign as a positive current
        % corresponds to a negative skew component. See operations elog
        % entries. (eg.
        % http://asapp01/elog/servlet/XMLlist?file=/operationselog/data/2008/30/26.07&xsl=/elogbook/xsl/elog.xsl&picture=true#2008-07-26T12:00:25)
        %
        
        MagnetType = 'quad';
        Leff=0.2;
        
        I = [-8:8];
        %B = 0.035/(47.6/12)*I;
        B = -0.02*I;
        
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
        BLeff = BIdata.HCM.Bharmon(1)*1.1; % 23/11/2009 ET: 1.1 added to fix the gain issues
        
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
        BL = (BLeff/i0)*I*1.06; % 23/11/2009 ET: 1.06 added to fix the gain issues
        
        C = zeros(1,2*length(I));
        C(1,1:length(I)) = I;
        C(1,length(I)+1:end) = BL;
        
    otherwise
        error(sprintf('MagnetCoreType %s is not unknown', MagnetCoreType));
end

MagnetType = upper(MagnetType);
