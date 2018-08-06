function FailFlag = srramp(varargin)
%SRRAMP - Ramp the storage ring energy
%  ErrorFlag = srramp(EnergyStop, NStepsPerGeV)
%  Ramp from the present energy to EnergyStop
%  The ramp files are built by buildramptable.
%
%  INPUTS
%  1. EnergyStop   - Ramp to energy [GeV]
%                    For string inputs: 'Lower' or 'Injection'  -> Ramp to lower hysteresis lattice
%                                       'Upper' or 'Production' -> Ramp to upper hysteresis lattice
%  2. NStepsPerGeV - Number of steps per GeV {Default: 1500}
%  3. Extra Input Flags:
%     'NoSuperBend'  - Don't ramp the superbend magnets
%
%     'LinearByEnergy'       - Linear scaling of setpoints by energy
%                              (good for small energy changes or ramping magnets to zero)
%     'LinearToLowerLattice' - Ramp by linear scaling of lower lattice
%                              (Typically for ramping magnets from zero to the lower lattice)
%     'LinearToUpperLattice' - Ramp by linear scaling of upper lattice
%                              (Typically for ramping magnets from zero to the upper lattice)
%
%     'MeasureTune' - Stop to measure tunes along the ramp
%
%  OUTPUTS
%  1. ErrorFlag - The only graceful error condition is on superbend temperature before the ramp starts
%
%  See also getenergy


% 2001-11-26, T.Scarvie
% modified srramp so that it automatically halves the ramprate (down to 0.15 A/s minimum)
%      if any of the superbend coil temps go above 4.65K
%
% 2002-05-04, C. Steier
% trim DACs for correctors are set to 0 before ramping.
%
% 2003-03-16, C. Steier
% Modified parameters for ramprate reduction to allow reasonable operation with failed
% cryocooler. Also programmed work-around for bug in BSC power supplies. If ramprate is
% set to 0.2 A/s the BSC power supply PLC ramps much slower than requested. Work around:
% Whenever the ramprate would be 0.2 A/s it is automatically reduced further to 0.15 A/s.
%
% 2004-05-14, C. Steier
% Modified parameters for ramprate reduction. Previous parameters were slightly too
% cautious. Increased initial slow ramprate to 0.4 A/s and modified temperature
% thresholds (also added new cases). In addition the code now checks every 5 ramp
% steps whether temperatures are too high.
%
% 2005-11-13, G. Portmann
% Changed to use the new middle layer functionality
%
% 2008-11-11, G. Portmann
% Changed to handle 1.9 GeV injection better.  And turning on/off magnets.


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

% Input flags
SET_BY_CHANNELNAME = 1;
FailFlag = 0;
SuperBendFlag = 'Yes';
DisplayFlag = 1;
MeasTunesFlag = 0;
MasterRampFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LinearByEnergy')
        MasterRampFlag = 3;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LinearToLowerLattice')
        MasterRampFlag = 4;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LinearToUpperLattice')
        MasterRampFlag = 5;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'Measure Tune', 'MeasureTune', 'MeasTune'}))
        MeasTunesFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'Super Bend', 'SuperBend', 'Super Bends', 'SuperBends', 'SB'}))
        SuperBendFlag = 'Yes';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'No Super Bend', 'No SuperBend', 'NoSuperBend', 'No Super Bends', 'No SuperBends', 'NoSuperBends', 'NoSB'}))
        SuperBendFlag = 'No';
        varargin(i) = [];
    end
end


% RampFlag = 0 ->  Don't ramp 
%            1 ->  Linear ramp between production and injection lattices
%            2 ->  Use the hysteresis tables
%            3 ->  Scale by energy
%            4 ->  Linear ramp to lower lattice
%            5 ->  Linear ramp to upper lattice
if MasterRampFlag == 3
    % MasterRampFlag = 3 does a linear scaling of all magnets based on energy.
    % It does not change the RF frequency or the motor chicanes.
    RFRampFlag = 0;
    HCMCHICANEMRampFlag = 0;
    HCMCHICANERampFlag  = 3;
    CorrectorRampFlag = 3;
    SQRampFlag = 3;
    QFQDRampFlag = 3;
    SFSDRampFlag = 3;
    TuneAdjFlag = 0;
elseif MasterRampFlag == 4 || MasterRampFlag == 5
    % MasterRampFlag = 4/5 ramps to the lower/upper lattice by scaling of all magnets from the present 
    % lattice to the lower/upper lattice.  It does not change the RF frequency or the motor chicanes.
    RFRampFlag = 0;
    HCMCHICANEMRampFlag = 0;
    HCMCHICANERampFlag  = 4;
    CorrectorRampFlag = 4;
    SQRampFlag = 4;
    QFQDRampFlag = 4;
    SFSDRampFlag = 4;
    TuneAdjFlag = 0;
else
    OperationalMode = getfamilydata('OperationalMode');
    RFRampFlag = 0;
    HCMCHICANEMRampFlag = 0;
    HCMCHICANERampFlag  = 0;
    CorrectorRampFlag = 1;
    SQRampFlag = 1;
    if strcmp(OperationalMode, '1.9 GeV, Two-Bunch')
        TuneAdjFlag = 2;
        QFQDRampFlag = 2;
        SFSDRampFlag = 2;
    elseif strcmp(OperationalMode, '1.3 GeV')
        TuneAdjFlag = 1;
        QFQDRampFlag = 2;
        SFSDRampFlag = 2;
    else
        TuneAdjFlag = 2;
        QFQDRampFlag = 2;
        SFSDRampFlag = 2;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the upper and lower hysteresis lattices %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (It actually doesn't matter which table is loaded since LowerLattice & UpperLattice are the same)
load([getfamilydata('Directory','OpsData'), 'alsrampup.mat']);
UpperLattice = RampTable.UpperLattice.Setpoint;
LowerLattice = RampTable.LowerLattice.Setpoint;
GeVTable = RampTable.GeV;


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Energies of importance %
%%%%%%%%%%%%%%%%%%%%%%%%%%
EnergyMode  = getfamilydata('Energy');
EnergyUpper = max(RampTable.GeV);
EnergyLower = min(RampTable.GeV);

% Stop energy
EnergyStop = [];
if length(varargin) >= 1
    if ischar(varargin{1})
        if strcmpi(varargin{1},'Upper')
            EnergyStop = EnergyUpper;
        elseif strcmpi(varargin{1}, 'Lower')
            EnergyStop = EnergyLower;
        elseif strcmpi(varargin{1}, 'Production')
            EnergyStop = getfamilydata('Energy');
        elseif strcmpi(varargin{1}, 'Injection')
            EnergyStop = getfamilydata('InjectionEnergy');
        else
            error('Conversion for the string input for EnergyStop not known.');
        end
    else
        EnergyStop = varargin{1};
    end
end

% EnergyStart
if strcmpi(SuperBendFlag, 'No')
    EnergyStart = getenergy('Present');  % same as bend2gev (the hysteresis branch should already be set properly)
else
    % Base energy on the superbend since ramp speed is very important for the superbend
    EnergyBEND  = bend2gev('BEND','Setpoint',getsp('BEND',[1 1]),[1 1]);
    EnergySBEND = bend2gev('BEND','Setpoint',getsp('BEND',[4 2;8 2;12 2]),[4 2;8 2;12 2]);
    EnergyStartMin = min([EnergyBEND; EnergySBEND]);
    EnergyStartMax = max([EnergyBEND; EnergySBEND]);
    if EnergyStartMin == EnergyStartMax
        EnergyStart = EnergyStartMin;
    else
        if isempty(EnergyStop)
            error('The start energies cannot be defined since the bend and superbend are at defering energies.');
        else
            if abs(EnergyStop-EnergyBEND) > max(abs(EnergyStop-EnergySBEND))
                EnergyStart = EnergyBEND;
            else
                [tmp, i] = max(abs(EnergyStop-EnergySBEND));
                EnergyStart = EnergySBEND(i);
            end
        end
    end
end

% Default EnergyStop
if isempty(EnergyStop)
    if isempty(EnergyStart)
        error('The start and stop energies cannot be defined.');
    else
        if EnergyStart > 1.7
            EnergyStop = EnergyLower;
        else
            EnergyStop = EnergyUpper;
        end
    end
end

% Number of steps per GeV
NStepsPerGeV = [];
if length(varargin) >= 2
    NStepsPerGeV = varargin{2};
end
if isempty(NStepsPerGeV)
    if MasterRampFlag == 4 || MasterRampFlag == 5
        % No stored beam, hence less steps
        NStepsPerGeV = 1000;
    else
        NStepsPerGeV = 1500;
    end
end


if MeasTunesFlag
    fid = fopen([getfamilydata('Directory','OpsData'), 'ramp_tune_measurement.m'], 'a');
end


% Sanity check
if abs(EnergyStop-EnergyStart) < 1e-6
    fprintf('   The storage ring is at the requested energy already.\n');
    return;
end


%%%%%%%%%%%%%%%%
% Ramp vectors %
%%%%%%%%%%%%%%%%
NSteps = ceil(NStepsPerGeV * abs(EnergyStop-EnergyStart));
EVector = linspace(EnergyStart, EnergyStop, NSteps);


%%%%%%%%%%%%%%%%%%%%%%
% Tune Ramping Setup %
%%%%%%%%%%%%%%%%%%%%%%
if TuneAdjFlag
    % Tune response matrix
    Mtune = gettuneresp({'QF','QD'}, {[],[]}, EnergyUpper);    %[0.1944 -0.0286;-0.1182 0.1526];
end
if TuneAdjFlag == 1
    GoldenTune = getgolden('TUNE');

    % Extra tune table
    if QFQDRampFlag == 2
        if (EnergyStop>EnergyStart)
            try
                load([getfamilydata('Directory','OpsData'), 'rampup_tune_table.mat']);
                disp('   Loading measured tune tables for dynamic correction of ramping');
            catch
                fprintf('\n\n   Ramp up tune table not found (rampup_tune_table.mat).\n\n');
                tune_meas_ramp.energy   = [EnergyStart EnergyStop];
                tune_meas_ramp.tunefilt = [0.25 0.2;0.25 0.2];
            end
            %if strcmp(OperationalMode, '1.9 GeV, Inject at 1.23') || strcmp(SR_Mode, '1.9 GeV, Inject at 1.353')
            %    load '/home/physdata/matlab/srdata/powersupplies/sr_ramp_tune_excursion/rampup_tune_table_4.mat'
            %elseif strcmp(OperationalMode, '1.9 GeV, Two-Bunch')
            %    load '/home/physdata/matlab/srdata/powersupplies/sr_ramp_tune_excursion/rampup_tune_table_5.mat' % middle of horizontal tune modifier raised by 0.01
            %end
        else
            try
                load([getfamilydata('Directory','OpsData'), 'rampdown_tune_table.mat']);
                disp('   Loading measured tune tables for dynamic correction of ramping');
            catch
                fprintf('\n\n   Ramp up tune table not found (rampdown_tune_table.mat).\n\n');
                tune_meas_ramp.energy   = [EnergyStart EnergyStop];
                tune_meas_ramp.tunefilt = [GoldenTune'; GoldenTune'];
            end
            %if strcmp(OperationalMode, '1.9 GeV, Inject at 1.23') || strcmp(SR_Mode, '1.9 GeV, Inject at 1.353')
            %    load '/home/physdata/matlab/srdata/powersupplies/sr_ramp_tune_excursion/rampdown_tune_table_2.mat'
            %elseif strcmp(OperationalMode, '1.9 GeV, Two-Bunch')
            %    load '/home/physdata/matlab/srdata/powersupplies/sr_ramp_tune_excursion/rampdown_tune_table_3.mat'
            %end
        end
    else
        tune_meas_ramp.energy   = [EnergyStart EnergyStop];
        tune_meas_ramp.tunefilt = [GoldenTune'; GoldenTune'];
    end
elseif TuneAdjFlag == 2
    TuneAdjCurve = abs((EVector-EnergyLower).*(EVector-EnergyUpper));
    TuneAdjCurve = TuneAdjCurve / max(TuneAdjCurve);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the starting lattice configuration & convert to physics units %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ConfigSetpointStart = getmachineconfig;

% Remove families not needed in the ramp
ConfigSetpointStart = RemoveSomeFamilies(ConfigSetpointStart, SuperBendFlag);
ConfigSetpointStart = RemoveSomeFields(ConfigSetpointStart);

UpperLattice = RemoveSomeFamilies(UpperLattice, SuperBendFlag);
UpperLattice = RemoveSomeFields(UpperLattice);

LowerLattice = RemoveSomeFamilies(LowerLattice, SuperBendFlag);
LowerLattice = RemoveSomeFields(LowerLattice);

ConfigFamilies = fieldnames(ConfigSetpointStart);

% Build the ramping structures
BEND = ConfigSetpointStart.BEND.Setpoint;
QFA  = ConfigSetpointStart.QFA.Setpoint;
QDA  = ConfigSetpointStart.QDA.Setpoint;
QF   = ConfigSetpointStart.QF.Setpoint;
QD   = ConfigSetpointStart.QD.Setpoint;
SF   = ConfigSetpointStart.SF.Setpoint;
SD   = ConfigSetpointStart.SD.Setpoint;
SQSF = ConfigSetpointStart.SQSF.Setpoint;
SQSD = ConfigSetpointStart.SQSD.Setpoint;
HCM  = ConfigSetpointStart.HCM.Setpoint;
VCM  = ConfigSetpointStart.VCM.Setpoint;
%VCBSC = ConfigSetpointStart.VCBSC.Setpoint;
HCMCHICANE  = ConfigSetpointStart.HCMCHICANE.Setpoint;
if isfield(ConfigSetpointStart,'HCMCHICANEM') && HCMCHICANEMRampFlag
    fprintf('   The motor chicane is being removed from the ramp.\n');
    HCMCHICANEM = ConfigSetpointStart.HCMCHICANEM.Setpoint;
else
    % Turn off if it wasn't already off
    HCMCHICANEMRampFlag = 0;
end


% If the upper lattice has more correctors from the starting lattice remove them
i = findrowindex(UpperLattice.HCM.Setpoint.DeviceList, HCM.DeviceList);
UpperLattice.HCM.Setpoint.Data = UpperLattice.HCM.Setpoint.Data(i,:);
UpperLattice.HCM.Setpoint.Status = UpperLattice.HCM.Setpoint.Status(i,:);
UpperLattice.HCM.Setpoint.DeviceList = UpperLattice.HCM.Setpoint.DeviceList(i,:);

i = findrowindex(UpperLattice.VCM.Setpoint.DeviceList, VCM.DeviceList);
UpperLattice.VCM.Setpoint.Data = UpperLattice.VCM.Setpoint.Data(i,:);
UpperLattice.VCM.Setpoint.Status = UpperLattice.VCM.Setpoint.Status(i,:);
UpperLattice.VCM.Setpoint.DeviceList = UpperLattice.VCM.Setpoint.DeviceList(i,:);


% Compute the starting lattice in physics units (hopefully the hysteresis branch is already set properly)
if MasterRampFlag < 3
    for j = 1:length(ConfigFamilies)
        ConfigSetpointPhysics.(ConfigFamilies{j}).Setpoint = hw2physics(ConfigSetpointStart.(ConfigFamilies{j}).Setpoint, EnergyStart);
    end
end

% Set the hysteresis branch for the ramp direction (this determines the tabled used in hw2physics & physics2hw)
if EnergyStop > EnergyStart
    setfamilydata('Lower', 'HysteresisBranch');
    Branch = 1;
else
    setfamilydata('Upper', 'HysteresisBranch');
    Branch = 2;
end

% Get the entire setpoint table in hardware units
if MasterRampFlag < 3
    tic;
    fprintf('   Computing the ramp tables ... ');
    for j = 1:length(ConfigFamilies)
        HardwareTable.(ConfigFamilies{j}).Setpoint = physics2hw(ConfigSetpointPhysics.(ConfigFamilies{j}).Setpoint, EVector);
    end
    fprintf('(%.2f seconds) \n', toc);
end


% Reduce the device list to only power supplies
% DeviceListTable = ConfigSetpointStart.BEND.Setpoint.DeviceList;
% i = findrowindex(DeviceListTable, BEND.DeviceList);
% BEND.Data       = BEND.Data(i);
% BEND.DeviceList = BEND.DeviceList(i,:);
% BEND.Status     = BEND.Status(i);
% 
% DeviceListTable = ConfigSetpointStart.QFA.Setpoint.DeviceList;
% i = findrowindex(DeviceListTable, QFA.DeviceList);
% QFA.Data       = QFA.Data(i);
% QFA.DeviceList = QFA.DeviceList(i,:);
% QFA.Status     = QFA.Status(i);
% 
% DeviceListTable = ConfigSetpointStart.SF.Setpoint.DeviceList;
% i = findrowindex(DeviceListTable, SF.DeviceList);
% SF.Data       = SF.Data(i);
% SF.DeviceList = SF.DeviceList(i,:);
% SF.Status     = SF.Status(i);
% 
% DeviceListTable = ConfigSetpointStart.SD.Setpoint.DeviceList;
% i = findrowindex(DeviceListTable, SD.DeviceList);
% SD.Data       = SD.Data(i);
% SD.DeviceList = SD.DeviceList(i,:);
% SD.Status     = SD.Status(i);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Final sets and checks before ramping %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmpi(SuperBendFlag, 'Yes')
    % Check superbend temperatures and set ramp rate limits
    [SBENDRampRate, MinPeriod] = SetRampRateLimitsStart(LowerLattice, UpperLattice, GeVTable, NStepsPerGeV);
    FailFlag = CheckSuperBendTemperature(SBENDRampRate);
    if FailFlag
        return;
    end    
else
    MinPeriod = .1;
end


% Zero the orbit feedback channels (not sure this is the right thing to do?)
setpv('HCM', 'Trim', 0, [], 0);
setpv('VCM', 'Trim', 0, [], 0);


% Skew quadrupoles
if SQRampFlag == 0
    if EnergyStop < EnergyStart
        fprintf('   Setting skew quadrupoles to the lower hysteresis lattice setpoint.\n');
        setpv(LowerLattice.SQSD.Setpoint, 0);
        setpv(LowerLattice.SQSF.Setpoint, 0);
    end
end


% Open the amplitude loops of the harmonic cavities to avoid problems while ramping (especially loss of longitudinal lock)
fprintf('   Opening amplitude loop on third harmonic cavities.\n');
try
    setpv('SR02C___C1MLOP_BC00',0);
    setpv('SR02C___C2MLOP_BC00',0);
    setpv('SR02C___C3MLOP_BC00',0);
catch
    fprintf('\n** There was a problem opening one of the THC loops!\n** Ramping will continue but please ensure that they are open manually.\n\n');
    soundtada;
end


%%%%%%%%%%%%%%%%%%
% Start the ramp %
%%%%%%%%%%%%%%%%%%
t00 = clock;
fprintf('   Starting the ramp from %.4f GeV to %.4f GeV in %d steps\n', EnergyStart, EnergyStop, NSteps);


if SET_BY_CHANNELNAME
    % Using channel names is faster
    %RF_CHANNELS   = family2channel('RF', 'Setpoint', [1 1]);
    BEND_CHANNELS = family2channel('BEND', 'Setpoint', BEND.DeviceList);
    QFA_CHANNELS  = family2channel('QFA', 'Setpoint', QFA.DeviceList);
    QDA_CHANNELS  = family2channel('QDA', 'Setpoint', QDA.DeviceList);
    QF_CHANNELS   = family2channel('QF', 'Setpoint', QF.DeviceList);
    QD_CHANNELS   = family2channel('QD', 'Setpoint', QD.DeviceList);
    SF_CHANNELS   = family2channel('SF', 'Setpoint', SF.DeviceList);
    SD_CHANNELS   = family2channel('SD', 'Setpoint', SD.DeviceList);
    SQSF_CHANNELS = family2channel('SQSF', 'Setpoint', SQSF.DeviceList);
    SQSD_CHANNELS = family2channel('SQSD', 'Setpoint', SQSD.DeviceList);
    HCM_CHANNELS  = family2channel('HCM', 'Setpoint', HCM.DeviceList);
    VCM_CHANNELS  = family2channel('VCM', 'Setpoint', VCM.DeviceList);
    %VCBSC_CHANNELS = family2channel('VCBSC', 'Setpoint', VCBSC.DeviceList);
    HCMCHICANE_CHANNELS  = family2channel('HCMCHICANE', 'Setpoint', HCMCHICANE.DeviceList);
    if HCMCHICANEMRampFlag == 1
        HCMCHICANEM_CHANNELS = family2channel('HCMCHICANEM', 'Setpoint', HCMCHICANEM.DeviceList);
    end
end


for i = 1:length(EVector)    
    t0 = clock;

    % Check superbend coil temps - if higher than Templimit, halve the ramprate
    if strcmpi(SuperBendFlag, 'Yes') && (i==1 || rem((i-1),5)==0)
        [SBENDRampRate, MinPeriod] = SetRampRateLimits(LowerLattice, UpperLattice, SBENDRampRate, MinPeriod, GeVTable, NStepsPerGeV);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the setpoints for each magnet family %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    % Fraction complete
    m = (EVector(i)-EVector(1)) / (EVector(end)-EVector(1));

    % Correctors
    if CorrectorRampFlag == 1
        % Linear ramp between the lower and upper lattices
        HCM.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.HCM.Setpoint.Data UpperLattice.HCM.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
        VCM.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.VCM.Setpoint.Data UpperLattice.VCM.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
        %VCBSC.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.VCBSC.Setpoint.Data UpperLattice.VCBSC.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
    elseif CorrectorRampFlag == 2
        % Compute the magnets using the hysteresis tables (which is probably energy scaling for a corrector)
        HCM.Data = HardwareTable.HCM.Setpoint.Data(:,i);
        VCM.Data = HardwareTable.VCM.Setpoint.Data(:,i);
        %VCBSC = HardwareTable.VCBSC.Setpoint.Data(:,i);
        
        %HCM = physics2hw(ConfigSetpointPhysics.HCM.Setpoint, EVector(i));
        %VCM = physics2hw(ConfigSetpointPhysics.VCM.Setpoint, EVector(i));
        %VCBSC = physics2hw(ConfigSetpointPhysics.VCBSC.Setpoint, EVector(i));
    elseif CorrectorRampFlag == 3
        % Linear scaling with energy
        HCM.Data = ConfigSetpointStart.HCM.Setpoint.Data * EVector(i) / EnergyStart;
        VCM.Data = ConfigSetpointStart.VCM.Setpoint.Data * EVector(i) / EnergyStart;
        %VCBSC.Data = ConfigSetpointStart.VCBSC.Setpoint.Data * EVector(i) / EnergyStart;
    elseif CorrectorRampFlag == 4
        % Linear scaling to the lower lattice
        HCM.Data = m * (LowerLattice.HCM.Setpoint.Data - ConfigSetpointStart.HCM.Setpoint.Data) + ConfigSetpointStart.HCM.Setpoint.Data;
        VCM.Data = m * (LowerLattice.VCM.Setpoint.Data - ConfigSetpointStart.VCM.Setpoint.Data) + ConfigSetpointStart.VCM.Setpoint.Data;
    end

    
    % QF & QD
    if QFQDRampFlag == 1
        % Linear ramp between the lower and upper lattices
        QF.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.QF.Setpoint.Data UpperLattice.QF.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
        QD.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.QD.Setpoint.Data UpperLattice.QD.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
    elseif QFQDRampFlag ==2
        % Compute the magnets using the hysteresis tables
        QF.Data = HardwareTable.QF.Setpoint.Data(:,i);
        QD.Data = HardwareTable.QD.Setpoint.Data(:,i);

        %QF = physics2hw(ConfigSetpointPhysics.QF.Setpoint, EVector(i));
        %QD = physics2hw(ConfigSetpointPhysics.QD.Setpoint, EVector(i));
    elseif QFQDRampFlag == 3
        % Linear scaling with energy
        QF.Data = ConfigSetpointStart.QF.Setpoint.Data * EVector(i) / EnergyStart;
        QD.Data = ConfigSetpointStart.QD.Setpoint.Data * EVector(i) / EnergyStart;
    elseif QFQDRampFlag == 4
        % Linear scaling to the lower lattice
        QF.Data = m * (LowerLattice.QF.Setpoint.Data - ConfigSetpointStart.QF.Setpoint.Data) + ConfigSetpointStart.QF.Setpoint.Data;
        QD.Data = m * (LowerLattice.QD.Setpoint.Data - ConfigSetpointStart.QD.Setpoint.Data) + ConfigSetpointStart.QD.Setpoint.Data;
    else
        % No change
        QF = ConfigSetpointStart.QF.Setpoint;
        QD = ConfigSetpointStart.QD.Setpoint;
    end
    
    if TuneAdjFlag == 1
        % Adjust ramp to profile the tunes during the ramp
        if EnergyStop >= EnergyStart
            dnu = [0.025; 0.010];
        elseif EnergyStop < EnergyStart
            dnu = [0.050; 0.020];
        end

        % Normalized based on the delta energy change
        ScaleFactor = (EVector-EnergyLower).*(EVector-EnergyUpper);
        ScaleFactor = ScaleFactor / max(max(abs(ScaleFactor)));
        QFQDcorr = -1 * inv(Mtune) * EVector(i)/EnergyUpper * ...
            (dnu * ScaleFactor(i) + interp1(tune_meas_ramp.energy, tune_meas_ramp.tunefilt, EVector(i), 'spline', 'extrap')' - [.25; .2]);  % GoldenTune
           %(dnu * ScaleFactor(i)); this line used when trying to debug 2-bunch ramp tune problems - 8-19-07 - T.Scarvie

        QF.Data = QF.Data + QFQDcorr(1);
        QD.Data = QD.Data + QFQDcorr(2);

    elseif TuneAdjFlag == 2
        % Adjust ramp profile to separate the tunes during the ramp (modify ramp table with a quadratic function)
        if strcmp(OperationalMode, '1.9 GeV, Two-Bunch')
            if EnergyStop >= EnergyStart
                % Up
                %dnu = [0.000; -0.015];
                dnu = [0.040;  0.030];
            elseif EnergyStop < EnergyStart
                % Down
                %dnu = [0.000; -0.030];
                dnu = [0.010;  -0.010];
                dnu = [0.010;   0.000];
            end
        elseif strcmp(OperationalMode, '1.5 GeV, Inject at 1.353')
            if EnergyStop >= EnergyStart
                % Up
                dnu = [-0.03; 0.01];
            elseif EnergyStop < EnergyStart
                % Down
                dnu = [0.0; 0.03];
            end
        else
            if EnergyStop >= EnergyStart
                % Up
                dnu = [0.025; 0.01];
            elseif EnergyStop < EnergyStart
                % Down
                dnu = [0.05; 0.02];
            end
        end
        
        % 1.522 to 1.9 ramping (ie, the .035 scale factor)
        %QFQDcorr = inv(Mtune) * [
        %    (-dnu(1)/0.035)*(EVector(i)-EnergyLower)*(EVector(i)-EnergyUpper)
        %    (-dnu(2)/0.035)*(EVector(i)-EnergyLower)*(EVector(i)-EnergyUpper) ];

        % 1.32 to 1.9 GeV ramping
        %QFQDcorr = inv(Mtune) * [
        %    (-dnu(1)/0.109)*(EVector(i)-EnergyLower)*(EVector(i)-EnergyUpper)
        %    (-dnu(2)/0.109)*(EVector(i)-EnergyLower)*(EVector(i)-EnergyUpper) ];

        QFQDcorr = inv(Mtune) * dnu * TuneAdjCurve(i);
        
        QF.Data = QF.Data + QFQDcorr(1);
        QD.Data = QD.Data + QFQDcorr(2);
    end
    

    if MasterRampFlag == 3
        % Linear scaling with energy
        BEND.Data = ConfigSetpointStart.BEND.Setpoint.Data * EVector(i) / EnergyStart;
        QFA.Data = ConfigSetpointStart.QFA.Setpoint.Data   * EVector(i) / EnergyStart;
        QDA.Data = ConfigSetpointStart.QDA.Setpoint.Data   * EVector(i) / EnergyStart;

    elseif MasterRampFlag == 4
        % Linear scaling to the lower lattice
        BEND.Data = m * (LowerLattice.BEND.Setpoint.Data - ConfigSetpointStart.BEND.Setpoint.Data) + ConfigSetpointStart.BEND.Setpoint.Data;
        QFA.Data  = m * (LowerLattice.QFA.Setpoint.Data  - ConfigSetpointStart.QFA.Setpoint.Data)  + ConfigSetpointStart.QFA.Setpoint.Data;
        QDA.Data  = m * (LowerLattice.QDA.Setpoint.Data  - ConfigSetpointStart.QDA.Setpoint.Data)  + ConfigSetpointStart.QDA.Setpoint.Data;

    elseif MasterRampFlag == 5
        % Linear scaling to the upper lattice
        BEND.Data = m * (UpperLattice.BEND.Setpoint.Data - ConfigSetpointStart.BEND.Setpoint.Data) + ConfigSetpointStart.BEND.Setpoint.Data;
        QFA.Data  = m * (UpperLattice.QFA.Setpoint.Data  - ConfigSetpointStart.QFA.Setpoint.Data)  + ConfigSetpointStart.QFA.Setpoint.Data;
        QDA.Data  = m * (UpperLattice.QDA.Setpoint.Data  - ConfigSetpointStart.QDA.Setpoint.Data)  + ConfigSetpointStart.QDA.Setpoint.Data;

    else
        % Compute BEND, QFA & QDA magnets using the hysteresis tables
        BEND.Data = HardwareTable.BEND.Setpoint.Data(:,i);
        %BEND.Data(2) = HardwareTable.BEND.Setpoint.Data(2,1)+(gev2bsc_lowe(EVector(i),Branch)-gev2bsc_lowe(EVector(1),Branch))/(gev2bsc_lowe(EVector(end),Branch)-gev2bsc_lowe(EVector(1),Branch))*(HardwareTable.BEND.Setpoint.Data(2,end)-HardwareTable.BEND.Setpoint.Data(2,1));
        %BEND.Data(3) = HardwareTable.BEND.Setpoint.Data(3,1)+(gev2bsc_lowe(EVector(i),Branch)-gev2bsc_lowe(EVector(1),Branch))/(gev2bsc_lowe(EVector(end),Branch)-gev2bsc_lowe(EVector(1),Branch))*(HardwareTable.BEND.Setpoint.Data(3,end)-HardwareTable.BEND.Setpoint.Data(3,1));
        %BEND.Data(4) = HardwareTable.BEND.Setpoint.Data(4,1)+(gev2bsc_lowe(EVector(i),Branch)-gev2bsc_lowe(EVector(1),Branch))/(gev2bsc_lowe(EVector(end),Branch)-gev2bsc_lowe(EVector(1),Branch))*(HardwareTable.BEND.Setpoint.Data(4,end)-HardwareTable.BEND.Setpoint.Data(4,1));
        QFA.Data = HardwareTable.QFA.Setpoint.Data(:,i);
        QDA.Data = HardwareTable.QDA.Setpoint.Data(:,i);
        %BEND = physics2hw(ConfigSetpointPhysics.BEND.Setpoint, EVector(i));
        %QFA  = physics2hw(ConfigSetpointPhysics.QFA.Setpoint,  EVector(i));
        %QDA  = physics2hw(ConfigSetpointPhysics.QDA.Setpoint,  EVector(i));
    end

    % SQSF & SQSD
    if SQRampFlag == 1
        % Linear ramp between the lower and upper lattices
        SQSF.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.SQSF.Setpoint.Data UpperLattice.SQSF.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
        SQSD.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.SQSD.Setpoint.Data UpperLattice.SQSD.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
    elseif SQRampFlag ==2
        % Compute the magnets using the hysteresis tables
        SQSF.Data = HardwareTable.SQSF.Setpoint.Data(:,i);
        SQSD.Data = HardwareTable.SQSD.Setpoint.Data(:,i);
    elseif SQRampFlag == 3
        % Linear scaling with energy
        SQSF.Data = ConfigSetpointStart.SQSF.Setpoint.Data * EVector(i) / EnergyStart;
        SQSD.Data = ConfigSetpointStart.SQSD.Setpoint.Data * EVector(i) / EnergyStart;
    elseif SQRampFlag == 4
        % Linear scaling to the lower lattice
        SQSF.Data = m * (LowerLattice.SQSF.Setpoint.Data - ConfigSetpointStart.SQSF.Setpoint.Data) + ConfigSetpointStart.SQSF.Setpoint.Data;
        SQSD.Data = m * (LowerLattice.SQSD.Setpoint.Data - ConfigSetpointStart.SQSD.Setpoint.Data) + ConfigSetpointStart.SQSD.Setpoint.Data;
    else
        % No change
        SQSF = ConfigSetpointStart.SQSF.Setpoint;
        SQSD = ConfigSetpointStart.SQSD.Setpoint;
    end

    
    % SF & SD
    if SFSDRampFlag == 1
        % Linear ramp between the lower and upper lattices
        SF.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.SF.Setpoint.Data UpperLattice.SF.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
        SD.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.SD.Setpoint.Data UpperLattice.SD.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
    elseif SFSDRampFlag ==2
        % Compute the magnets using the hysteresis tables
        if strcmp(OperationalMode, '1.9 GeV, Two-Bunch')
            %ScaleFactorS = (EVector-EnergyLower).*(EVector-EnergyUpper);
            %ScaleFactorS = (abs(ScaleFactorS) / max(max(abs(ScaleFactorS))));
            %SFSDcorr = 1.5 * EVector(i)/EnergyUpper * [14.1;8.8] * ScaleFactorS(i);
            SFSDcorr = [0;0];
        else
            SFSDcorr = [0;0];
        end
        SF.Data = HardwareTable.SF.Setpoint.Data(:,i)+SFSDcorr(1);
        SD.Data = HardwareTable.SD.Setpoint.Data(:,i)+SFSDcorr(2);
        %SF = physics2hw(ConfigSetpointPhysics.SF.Setpoint, EVector(i));
        %SD = physics2hw(ConfigSetpointPhysics.SD.Setpoint, EVector(i));
    elseif SFSDRampFlag == 3
        % Linear scaling with energy
        SF.Data = ConfigSetpointStart.SF.Setpoint.Data * EVector(i) / EnergyStart;
        SD.Data = ConfigSetpointStart.SD.Setpoint.Data * EVector(i) / EnergyStart;
    elseif SFSDRampFlag == 4
        % Linear scaling to the lower lattice
        SF.Data = m * (LowerLattice.SF.Setpoint.Data - ConfigSetpointStart.SF.Setpoint.Data) + ConfigSetpointStart.SF.Setpoint.Data;
        SD.Data = m * (LowerLattice.SD.Setpoint.Data - ConfigSetpointStart.SD.Setpoint.Data) + ConfigSetpointStart.SD.Setpoint.Data;
    else
        % No change
        SF = ConfigSetpointStart.SF.Setpoint;
        SD = ConfigSetpointStart.SD.Setpoint;
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set all magnets without waiting for rampflag %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if SET_BY_CHANNELNAME
        if EnergyStop < EnergyStart
            % BEND first if ramping down
            setpvonline(BEND_CHANNELS, BEND.Data);
        end
        setpvonline(  QF_CHANNELS, QF.Data);
        setpvonline(  QD_CHANNELS, QD.Data);
        setpvonline( QFA_CHANNELS, QFA.Data);
        setpvonline( QDA_CHANNELS, QDA.Data);
        setpvonline(  SF_CHANNELS, SF.Data);
        setpvonline(  SD_CHANNELS, SD.Data);
        setpvonline(SQSF_CHANNELS, SQSF.Data);
        setpvonline(SQSD_CHANNELS, SQSD.Data);
    else
        if EnergyStop < EnergyStart
            % BEND first if ramping down
            setpv(BEND, 0);
        end
        setpv(QF,  0);
        setpv(QD,  0);
        setpv(QFA, 0);
        setpv(QDA, 0);
        setpv(SF,  0);
        setpv(SD,  0);
        setpv(SQSF,0);
        setpv(SQSD,0);
    end
    
    % Alternatively set HCM, VCM and chicanes to save CPU cycles
    if rem(i,2) == 0 || i == length(EVector)
        if ~SET_BY_CHANNELNAME
            setpv(HCM, 0);
        else
            setpvonline(HCM_CHANNELS, HCM.Data);
        end
        
        if HCMCHICANERampFlag == 1
            % Linear ramp between the lower and upper lattices
            HCMCHICANE.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.HCMCHICANE.Setpoint.Data UpperLattice.HCMCHICANE.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
            setpv(HCMCHICANE, 0);
        elseif HCMCHICANERampFlag == 2
            % Compute the magnets using the hysteresis tables
            HCMCHICANE.Data = HardwareTable.HCMCHICANE.Setpoint.Data(:,i);
            %HCMCHICANE = physics2hw(ConfigSetpointPhysics.HCMCHICANE.Setpoint, EVector(i));
            setpv(HCMCHICANE, 0);
        elseif HCMCHICANERampFlag == 3
            % Linear scaling with energy
            HCMCHICANE.Data = ConfigSetpointStart.HCMCHICANE.Setpoint.Data * EVector(i) / EnergyStart;
        elseif HCMCHICANERampFlag == 4
            % Linear scaling of the lower lattice
            HCMCHICANE.Data = LowerLattice.HCMCHICANE.Setpoint.Data * EVector(i) / EnergyLower;
        end

        if HCMCHICANEMRampFlag == 1
            % Linear ramp between production and injection lattices
            HCMCHICANEM.Data = interp1([EnergyLower EnergyUpper]', [LowerLattice.HCMCHICANEM.Setpoint.Data UpperLattice.HCMCHICANEM.Setpoint.Data]', EVector(i), 'linear', 'extrap')';
            setpv(HCMCHICANEM, 0);
        elseif HCMCHICANEMRampFlag ==2
            % Compute the magnets using the hysteresis tables
            error('Motor chicane hysteresis tables are not programmed yet!');
            %HCMCHICANEM.Data = HardwareTable.HCMCHICANEM.Setpoint.Data(:,i);
            %%HCMCHICANEM = physics2hw(ConfigSetpointPhysics.HCMCHICANEM.Setpoint, EVector(i));
            %setpv(HCMCHICANEM, 0);
        end
    end
    if rem(i+1,2) == 0 || i == length(EVector)
        if ~SET_BY_CHANNELNAME
            setpv(VCM, 0);
            %setpv(VCBSC, 0);
        else
            setpvonline(VCM_CHANNELS, VCM.Data);
            %setpvonline(VCBSC_CHANNELS, VCBSC.Data);
        end
    end

    
    % Set the RF every 10th step
    if RFRampFlag
        if rem(i,10) == 0 || i == length(EVector)
            RFnew = interp1([EnergyLower; EnergyUpper], [LowerLattice.RF.Setpoint.Data; UpperLattice.RF.Setpoint.Data], EVector(i))';
            if isnan(RFnew)
                % No change
                RFnew = getpv(ConfigSetpoint.RF.Setpoint, 'Numeric');
            end
            setsp('RF', RFnew);
        end
    end
    
    
    % BEND last if ramping up
    if EnergyStop >= EnergyStart
        if SET_BY_CHANNELNAME
            setpvonline(BEND_CHANNELS, BEND.Data);
        else
            setpv(BEND, 0);
        end
    end

    
    % Delay for magnet ramping
    LoopPeriod = etime(clock,t0);
    
    if any(MasterRampFlag == [3 4 5])
        % Linear ramp will not have beam, so speed it up some
        WaitTime = .75*MinPeriod - LoopPeriod;
    else
        WaitTime = MinPeriod - LoopPeriod;
    end
    if WaitTime < .025
        WaitTime = .025;  % Minimum sleep after sets so that CA doesn't get too thrashed
    end
    pause(WaitTime);


    %%%%%%%%%%%%%%%%%%%%%%%% 
    % Display some results %
    %%%%%%%%%%%%%%%%%%%%%%%%
    if MeasTunesFlag && getdcct>2 && (rem(i,ceil(NSteps/15))==0  || i==length(EVector) || i==1)
        % Measure the tunes
        pause(10);
        tunes = gettune;
        fprintf(     '%4d %6.4f %6.5f %6.5f %5.2f\n', i, EVector(i), tunes(1), tunes(2), getdcct);
        fprintf(fid, '%4d %6.4f %6.5f %6.5f %5.2f\n', i, EVector(i), tunes(1), tunes(2), getdcct);
        % fprintf('%5.3f GeV, nu_x=%5.4f, nu_y=%5.4f\n', EVector(i), tunes(1), tunes(2));
    end
    if rem(i,ceil(NSteps/15))==0  || i==length(EVector) || i==1
        % Standard printout
        if length(BEND.Data) == 1
            fprintf('   %3d. %5.3f GeV,%6.1f mA, Time=%6.1f sec, BEND=%5.1f, QFA=%5.1f,%5.1f,%5.1f,%5.1f, SD=%5.1f, SF=%5.1f amps, T=%.3f sec\n', i, EVector(i), getdcct, etime(clock,t00), BEND.Data(1), QFA.Data(1), QFA.Data(2), QFA.Data(3), QFA.Data(4), SD.Data(1), SF.Data(1), LoopPeriod);
            %fprintf('   %3d. %5.3f GeV,%6.1f mA, Time=%6.1f sec, BEND=%5.1f, QFA=%5.1f,%5.1f,%5.1f,%5.1f, SD=%5.1f, SF not ramped, T=%.3f sec\n', i, EVector(i), getdcct, etime(clock,t00), BEND.Data(1), QFA.Data(1), QFA.Data(2), QFA.Data(3), QFA.Data(4), SD.Data(1), LoopPeriod);
        else
            fprintf('   %3d. %5.3f GeV,%6.1f mA, Time=%6.1f sec, BEND=%5.1f, BSC=%5.1f, QFA=%5.1f,%5.1f,%5.1f,%5.1f, SD=%5.1f, SF=%5.1f amps, T=%.3f sec\n', i, EVector(i), getdcct, etime(clock,t00), BEND.Data(1), BEND.Data(2), QFA.Data(1), QFA.Data(2), QFA.Data(3), QFA.Data(4), SD.Data(1), SF.Data(1), LoopPeriod);
        end
        pause(0);
    end
end


% Close the file
if MeasTunesFlag
    fclose(fid);
end


% Skew quadrupoles
if SQRampFlag == 0
    if EnergyStop > EnergyStart
        fprintf('   Setting skew quadrupoles to the upper hysteresis lattice setpoint.\n');
        setpv(UpperLattice.SQSD.Setpoint, 0);
        setpv(UpperLattice.SQSF.Setpoint, 0);
    end
end

fprintf('   Ramp from %.3f to %.3f GeV is complete.\n', EnergyStart, EnergyStop);


% Set magnet time constants and ramp rates back to their old/non superbend values (fast cycling and ramping)
setpv('BEND', 'RampRate', 10.5, [1 1]);
setpv('BEND', 'RampRate',  0.4, [4 2;8 2;12 2]);
setpv('QFA',  'RampRate',  5.9);
setpv('QDA',  'RampRate',  1.0);
setpv('SF',   'RampRate',  2.0);
setpv('SD',   'RampRate',  2.0);   % restored 4-25-12 after SD SCR was fixed - T.Scarvie 
%setpv('SD',   'RampRate',  .75);  % 2012-04-10 slowed down at Chris Pappas's request (GJP)
setpv('QF',   'RampRate',  1.0);
setpv('QD',   'RampRate',  1.0);

setpv('BEND', 'TimeConstant', 0);
setpv('QFA',  'TimeConstant', 0);
setpv('QDA',  'TimeConstant', 0);
setpv('SF',   'TimeConstant', 0);
setpv('SD',   'TimeConstant', 0);
setpv('QF',   'TimeConstant', 0);
setpv('QD',   'TimeConstant', 0);




%%%%%%%%%%%%%%%
% Subroutines %
%%%%%%%%%%%%%%%


function FailFlag = CheckSuperBendTemperature(SBENDRampRate)
% Check & warning about superbend temperatures

FailFlag = 0;

% Superbend temperature limits
if SBENDRampRate < .3
    Templimit = 4.8;
elseif SBENDRampRate < .4
    Templimit = 4.75;
elseif SBENDRampRate < .5
    Templimit = 4.7;
elseif SBENDRampRate < .7
    Templimit = 4.6;
else
    Templimit = 4.5;
end

[BSCcoiltemps, BSCcoilnames] = getsuperbendtemperatures;

if any(BSCcoiltemps > Templimit)
    bscnum = find(BSCcoiltemps > Templimit);
    soundtada;
    fprintf('   The temperature of one of the superbend magnets is too high.\n');
    for i=1:length(bscnum)
        fprintf('   The Coil Temperature of %s is %.2f K.  It should be below %.2f K.\n', BSCcoilnames{bscnum(i)}, BSCcoiltemps(bscnum(i)), Templimit);
    end
    fprintf('   A reduced ramp rate will be used for the energy ramp.  However, if a temperature\n');
    fprintf('   warning persists, there may be a problem with one of the superbends!\n');
    BSCTempFlag = questdlg(sprintf('One of the BS Coil temperatures is %.2f K!\nIt should be below %.2f K\n\nAre you sure you want to continue with the ramp?', max(BSCcoiltemps), Templimit),'SR Ramp', 'Yes', 'No', 'No');
    if strcmp(BSCTempFlag,'No')
        fprintf('\n   **************************\n');
        fprintf(  '   **     Ramp  Aborted    **\n');
        fprintf(  '   **************************\n\n');
        FailFlag = 1;
        return
    end
end




function [SBENDRampRate, MinPeriod] = SetRampRateLimitsStart(LowerLattice, UpperLattice, GeVTable, NStepsPerGeV)

OperationalMode = getfamilydata('OperationalMode');

if strcmp(OperationalMode, '1.9 GeV, Two-Bunch') 
    maxSBramprate = 0.8;
else
    maxSBramprate = 0.8;
end

% Initial superbend ramp rate limit is stored the middle layer
SBENDRampRate = getfamilydata('BSCRampRate');
if isnan(SBENDRampRate) || isempty(SBENDRampRate)
    SBENDRampRate = 0.4;
end
if SBENDRampRate > maxSBramprate
    SBENDRampRate = maxSBramprate;
elseif SBENDRampRate < 0.2
    SBENDRampRate = 0.2;
end


% Base the ramp rate on the full injection to production lattice
i = findrowindex([4 2], UpperLattice.BEND.Setpoint.DeviceList);
SBENDDelta = abs(UpperLattice.BEND.Setpoint.Data(i)-LowerLattice.BEND.Setpoint.Data(i));

NSteps = ceil(NStepsPerGeV * abs(max(GeVTable)-min(GeVTable)));

MinPeriod = SBENDDelta / (NSteps-1) / SBENDRampRate * 0.435 / 0.391;  % ~.2
fprintf('   Superbend: RampRate = %g A/s   MinPeriod = %g seconds \n', SBENDRampRate, MinPeriod);


BENDDelta = abs(UpperLattice.BEND.Setpoint.Data(1) - LowerLattice.BEND.Setpoint.Data(1));
QFADelta  = abs(UpperLattice.QFA.Setpoint.Data     - LowerLattice.QFA.Setpoint.Data);
QDADelta  = abs(UpperLattice.QDA.Setpoint.Data     - LowerLattice.QDA.Setpoint.Data);
SFDelta   = abs(UpperLattice.SF.Setpoint.Data      - LowerLattice.SF.Setpoint.Data);
SDDelta   = abs(UpperLattice.SD.Setpoint.Data      - LowerLattice.SD.Setpoint.Data);

BENDramprate = BENDDelta / (NSteps-1) / MinPeriod * 1.1;
QFAramprate  = QFADelta  / (NSteps-1) / MinPeriod * 1.1;
QDAramprate  = QDADelta  / (NSteps-1) / MinPeriod * 1.1;
SFramprate   = SFDelta   / (NSteps-1) / MinPeriod * 1.5;
SDramprate   = SDDelta   / (NSteps-1) / MinPeriod * 1.5;

setpv('BEND', 'RampRate', SBENDRampRate,  [4 2;8 2;12 2]);
setpv('BEND', 'RampRate', BENDramprate, UpperLattice.BEND.Setpoint.DeviceList(1,:));
setpv('QFA',  'RampRate', QFAramprate,  UpperLattice.QFA.Setpoint.DeviceList);
setpv('QDA',  'RampRate', QDAramprate,  UpperLattice.QDA.Setpoint.DeviceList);
setpv('SF',   'RampRate', SFramprate,   UpperLattice.SF.Setpoint.DeviceList);
setpv('SD',   'RampRate', SDramprate,   UpperLattice.SD.Setpoint.DeviceList);
setpv('QF',   'RampRate',  1.0);
setpv('QD',   'RampRate',  1.0);

setpv('BEND', 'TimeConstant', 0);
setpv('QFA',  'TimeConstant', 0);
setpv('QDA',  'TimeConstant', 0);
setpv('SF',   'TimeConstant', 0);
setpv('SD',   'TimeConstant', 0);




function [SBENDRampRate, MinPeriod] = SetRampRateLimits(LowerLattice, UpperLattice, SBENDRampRate, MinPeriod, GeVTable, NStepsPerGeV)
% BSC temperature checking

% Temperature ranges based on superbend setpoint
BSC = getpv('BSC','Setpoint',[4 2]);
if BSC < 175
    % Note: 1.52 GeV is 216.2 amps in the superbends
    if BSC < 50
        % Force .8 A/s
        setpv('BEND', 'RampRate', 0.8, [4 2; 8 2; 12 2], 0);
    elseif BSC < 100
        % Force .6 A/s
        setpv('BEND', 'RampRate', 0.6, [4 2; 8 2; 12 2], 0);
    elseif BSC < 175
        % Force .4 A/s
        setpv('BEND', 'RampRate', 0.4, [4 2; 8 2; 12 2], 0);
    end
    setpv('BEND', 'RampRate', 10.5, [1 1], 0);
    setpv('QFA',  'RampRate',  5.9, [], 0);
    setpv('QDA',  'RampRate',  1.0, [], 0);
    setpv('QF',   'RampRate',  1.0, [], 0);
    setpv('QD',   'RampRate',  1.0, [], 0);
    setpv('SF',   'RampRate',  2.0, [], 0);
    setpv('SD',   'RampRate',  2.0, [], 0); 
    return;
        
elseif BSC < 250
    %  I<250A, add 0.2 to temp checks
   if SBENDRampRate < .3
      Templimit = 5.0;
   elseif SBENDRampRate < .4
      Templimit = 4.96;
   elseif SBENDRampRate < .6
      Templimit = 4.9;
   else
      Templimit = 4.85;
   end
else
   if SBENDRampRate < .3
      Templimit = 4.8;
   elseif SBENDRampRate < .4
      Templimit = 4.76;
   elseif SBENDRampRate < .65
      Templimit = 4.7;
   else
      Templimit = 4.65;
   end
end

[BSCcoiltemps, BSCcoilnames] = getsuperbendtemperatures;

if any(BSCcoiltemps > Templimit)

    if SBENDRampRate > 0.5
        SBENDRampRate = SBENDRampRate - 0.2;
    else
        SBENDRampRate = SBENDRampRate/2;
    end
    
    % For smaller currents (below ~1.5 GeV) don't limit the ramprate as much
    if max(getsp('BEND',[4 2;8 2;12 2])) < 2
        % For smaller currents don't limit the ramprate as much
        SBENDRampRate = 1;
    elseif max(getsp('BEND',[4 2;8 2;12 2])) < 100
        SBENDRampRate = 0.4;
    elseif max(getsp('BEND',[4 2;8 2;12 2])) < 175
        % For smaller currents don't limit the ramprate as much
        SBENDRampRate = 0.3;
    elseif max(getsp('BEND',[4 2;8 2;12 2])) < 220
        % For smaller currents don't limit the ramprate as much
        SBENDRampRate = 0.3;
    else
        % Smallest 
        %SBENDRampRate = 0.15;
        SBENDRampRate = 0.3;
    end

    % There is something magic about 0.2A/s that doesn't work well
    if SBENDRampRate == 0.2
        SBENDRampRate = 0.15;
    end
    
    fprintf('\n   One of the superbend temperatures is too high (%f K).  Reducing the ramp speed to %.2f A/s for safety.\n', max(BSCcoiltemps), SBENDRampRate);

    % Base the ramp rate on the full injection to production lattice
    i = findrowindex([4 2], UpperLattice.BEND.Setpoint.DeviceList);
    SBENDDelta = abs(UpperLattice.BEND.Setpoint.Data(i)-LowerLattice.BEND.Setpoint.Data(i));

    NSteps = ceil(NStepsPerGeV * abs(max(GeVTable)-min(GeVTable)));
    MinPeriod = SBENDDelta / (NSteps-1) / SBENDRampRate * 0.435 / 0.391;
    
    fprintf('   Superbend: RampRate = %g A/s   MinPeriod = %g seconds \n\n', SBENDRampRate, MinPeriod);
    
    BENDDelta = abs(UpperLattice.BEND.Setpoint.Data(1) - LowerLattice.BEND.Setpoint.Data(1));
    QFADelta  = abs(UpperLattice.QFA.Setpoint.Data     - LowerLattice.QFA.Setpoint.Data);
    QDADelta  = abs(UpperLattice.QDA.Setpoint.Data     - LowerLattice.QDA.Setpoint.Data);
    SFDelta   = abs(UpperLattice.SF.Setpoint.Data      - LowerLattice.SF.Setpoint.Data);
    SDDelta   = abs(UpperLattice.SD.Setpoint.Data      - LowerLattice.SD.Setpoint.Data);

    BENDramprate = BENDDelta / (NSteps-1) / MinPeriod * 1.6;  % Was 1.1, Bend was falling behind on the cycle (GJP - 2008-11-26)
    QFAramprate  = QFADelta  / (NSteps-1) / MinPeriod * 1.1;
    QDAramprate  = QDADelta  / (NSteps-1) / MinPeriod * 1.1;
    SFramprate   = SFDelta   / (NSteps-1) / MinPeriod * 1.5;
    SDramprate   = SDDelta   / (NSteps-1) / MinPeriod * 1.5;

    setpv('BEND', 'RampRate', SBENDRampRate,  [4 2;8 2;12 2]);
    setpv('BEND', 'RampRate', BENDramprate, UpperLattice.BEND.Setpoint.DeviceList(1,:));
    setpv('QFA',  'RampRate', QFAramprate,  UpperLattice.QFA.Setpoint.DeviceList);
    setpv('QDA',  'RampRate', QDAramprate,  UpperLattice.QDA.Setpoint.DeviceList);
    setpv('SF',   'RampRate', SFramprate,   UpperLattice.SF.Setpoint.DeviceList);
    setpv('SD',   'RampRate', SDramprate,   UpperLattice.SD.Setpoint.DeviceList);
end



function Lattice = RemoveSomeFamilies(Lattice, SuperBendFlag)
if nargin < 2
    SuperBendFlag = '';
end
if isempty(SuperBendFlag)
    SuperBendFlag = 'Yes';
end


% Remove families
RemoveFamilyNames = {'INSIDESCRAPER','BOTTOMSCRAPER','TOPSCRAPER','HCMCHICANEM','VCMCHICANE','SHF','SHD','SQSHF','SQEPU','GeV','DCCT','RF'};
j = find(isfield(Lattice, RemoveFamilyNames));
Lattice = rmfield(Lattice, RemoveFamilyNames(j));


% Switch from a magnet device list to a power supply list
i = findrowindex([1 1;4 2; 8 2; 12 2], Lattice.QFA.Setpoint.DeviceList);
Lattice.QFA.Setpoint.Data       = Lattice.QFA.Setpoint.Data(i);
Lattice.QFA.Setpoint.DeviceList = Lattice.QFA.Setpoint.DeviceList(i,:);
Lattice.QFA.Setpoint.Status     = Lattice.QFA.Setpoint.Status(i);
if isfield(Lattice.QFA.Setpoint, 'DataTime')
    Lattice.QFA.Setpoint.DataTime = Lattice.QFA.Setpoint.DataTime(i);
end

Lattice.SF.Setpoint.Data       = Lattice.SF.Setpoint.Data(1);
Lattice.SF.Setpoint.DeviceList = Lattice.SF.Setpoint.DeviceList(1,:);
Lattice.SF.Setpoint.Status     = Lattice.SF.Setpoint.Status(i);
if isfield(Lattice.SF.Setpoint, 'DataTime')
    Lattice.SF.Setpoint.DataTime = Lattice.SF.Setpoint.DataTime(i);
end

Lattice.SD.Setpoint.Data       = Lattice.SD.Setpoint.Data(1);
Lattice.SD.Setpoint.DeviceList = Lattice.SD.Setpoint.DeviceList(1,:);
Lattice.SD.Setpoint.Status     = Lattice.SD.Setpoint.Status(i);
if isfield(Lattice.SD.Setpoint, 'DataTime')
    Lattice.SD.Setpoint.DataTime = Lattice.SD.Setpoint.DataTime(i);
end


% Include the superbend magnets?
if ~strcmpi(SuperBendFlag, 'Yes')
    % No superbends
    i = findrowindex([1 1], Lattice.BEND.Setpoint.DeviceList);
else
    % Ramp the superbends
    i = findrowindex([1 1;4 2; 8 2; 12 2], Lattice.BEND.Setpoint.DeviceList);
end
Lattice.BEND.Setpoint.Data       = Lattice.BEND.Setpoint.Data(i);
Lattice.BEND.Setpoint.DeviceList = Lattice.BEND.Setpoint.DeviceList(i,:);
Lattice.BEND.Setpoint.Status     = Lattice.BEND.Setpoint.Status(i);
if isfield(Lattice.BEND.Setpoint, 'DataTime')
    Lattice.BEND.Setpoint.DataTime = Lattice.BEND.Setpoint.DataTime(i);
end



function Lattice  = RemoveSomeFields(Lattice)
% Remove fields
RemoveFieldNames = {'RampRate','TimeConstant','DAC','Trim','FF1','FF2'};
Fields = fieldnames(Lattice);
for i = 1:length(Fields)
    j = isfield(Lattice.(Fields{i}), RemoveFieldNames);
    Lattice.(Fields{i}) = rmfield(Lattice.(Fields{i}), RemoveFieldNames(j));
end

