function setlocodata(CommandInput, FileName)
%SETLOCODATA - Applies the LOCO calibration data to both the middle layer & the accelerator
%  setlocodata(CommandInput, FileName)
%
%  INPUTS
%  1. CommandInput
%     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%     'SetGains'   - Set gains/coupling from a LOCO file.
%     'Symmetrize' - Symmetry correction of the lattice based on a LOCO file.
%     'CorrectCoupling' - Coupling correction of the lattice based on a LOCO file.
%     'SetModel'   - Set the model from a LOCO file.  But it only changes
%                    the part of the model that does not get corrected
%                    in 'Symmetrize' (also does a SetGains).
%     'LOCO2Model' - Set the model from a LOCO file (also does a 'SetGains').
%                    This sets all lattice machines fit in the LOCO run to the model.
%  2. FileName - LOCO file name {Default: getfamilydata('OpsData', 'LOCOFile')}
%                '' to browse for a file
%
%  NOTES
%  How one uses this function depends on how LOCO was setup.
%  1. Use setlocodata('Nominal') if no model calibration information is known.
%  2. The most typical situation is to apply:
%         setlocodata('Symmetrize') to the accelerator
%         setlocodata('SetModel')   to the middle layer (usually done in setoperationalmode)
%  3. If a LOCO run was done on the present lattice with no changes made to lattice
%     after LOCO run, then setting all the LOCO fits to the model makes sense.
%         setlocodata('LOCO2Model')
%  4. This function obviously has machine dependent parts.
%
%  Written by Greg Portmann


global THERING

if nargin < 1
    %CommandInput = 'Default';
    ModeCell = {'Nominal - Set Gain=1 & Rolls=0 in the model', 'SetGains - Set gains/rolls from a LOCO file','Symmetrize - Symmetry correction of the lattice', 'CorrectCoupling - Coupling correction of the lattice', 'SetModel - Set the model from a LOCO file','LOCO2Model - Set the model from a LOCO file (also does a SetGains)', 'see "help setlocodata" for more details'};
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString', ...
        'Select the proper set LOCO data command:', ...
        'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [500 200]);
    if OKFlag ~= 1
        fprintf('   setlocodata cancelled\n');
        return
    end
    if ModeNumber == 1
        CommandInput = 'Nominal';
    elseif ModeNumber == 2
        CommandInput = 'SetGains';
    elseif ModeNumber == 3
        CommandInput = 'Symmetrize';
    elseif ModeNumber == 4
        CommandInput = 'CorrectCoupling';
    elseif ModeNumber == 5
        CommandInput = 'SetModel';
    elseif ModeNumber == 6
        CommandInput = 'LOCO2Model';
    elseif ModeNumber == 8
        help setlocodata;
        return
    end
end

if nargin < 2
    % Default (Golden) LOCO file
    % If empty, the user will be prompted if needed.
    FileName = getfamilydata('OpsData','LOCOFile');
end


%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Defaults %
%%%%%%%%%%%%%%%%%%%%%%%
BPMxFamily = findmemberof('BPMx');
if isempty(BPMxFamily)
    BPMxFamily = 'BPMx';
else
    BPMxFamily = BPMxFamily{1};
end

BPMyFamily = findmemberof('BPMy');
if isempty(BPMyFamily)
    BPMyFamily = 'BPMy';
else
    BPMyFamily = BPMyFamily{1};
end

HCMFamily = findmemberof('HCM');
if isempty(HCMFamily)
    HCMFamily = 'HCM';
else
    HCMFamily = HCMFamily{1};
end

VCMFamily = findmemberof('VCM');
if isempty(VCMFamily)
    VCMFamily = 'VCM';
else
    VCMFamily = VCMFamily{1};
end


% Device list for the entire family
BPMxDeviceListTotal = family2dev(BPMxFamily, 0);
BPMyDeviceListTotal = family2dev(BPMyFamily, 0);
HCMDeviceListTotal  = family2dev(HCMFamily, 0);
VCMDeviceListTotal  = family2dev(VCMFamily, 0);

% % Active devices
% BPMxDeviceList = family2dev(BPMxFamily);
% BPMyDeviceList = family2dev(BPMyFamily);
% HCMDeviceList  = family2dev(HCMFamily);
% VCMDeviceList  = family2dev(VCMFamily);


if any(strcmpi(CommandInput, 'Nominal'))
    fprintf('   Using nominal BPM and corrector gains (1) and rolls (0).\n');

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;

    % Zero or one the gains and rolls
    AO.(BPMxFamily).Gain   =  ones(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Gain   =  ones(size(BPMyDeviceListTotal,1),1);
    AO.(BPMxFamily).Roll   = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Roll   = zeros(size(BPMyDeviceListTotal,1),1);
    AO.(BPMxFamily).Crunch = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Crunch = zeros(size(BPMyDeviceListTotal,1),1);

    % Set the gain, roll, & crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield(BPMxFamily, 'GCR', [AO.(BPMxFamily).Gain AO.(BPMyFamily).Gain AO.(BPMxFamily).Crunch AO.(BPMxFamily).Roll], BPMxDeviceListTotal);


    % Corrector magnet gains/rolls
    AO.(HCMFamily).Gain =  ones(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Gain =  ones(size(VCMDeviceListTotal,1),1);
    AO.(HCMFamily).Roll = zeros(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Roll = zeros(size(VCMDeviceListTotal,1),1);

    % Set the AT model as well since they are used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors
    % First set the cross planes to zero
    setatfield(HCMFamily, 'Roll', 0*AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 2);
    setatfield(VCMFamily, 'Roll', 0*AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield(HCMFamily, 'Roll', AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 1);
    setatfield(VCMFamily, 'Roll', AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 2);

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetGains'))

    % Set the model gains
    setlocodata('Nominal');

    AO = getao;

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    % Load the LOCO data
    fprintf('   Setting BPM and corrector gains and rolls based on %s.\n', FileName);
    load(FileName);


    % Get the device list from the LOCO file
    BPMxDeviceList = LocoMeasData.(BPMxFamily).DeviceList;
    BPMyDeviceList = LocoMeasData.(BPMyFamily).DeviceList;
    HCMDeviceList  = LocoMeasData.(HCMFamily).DeviceList;
    VCMDeviceList  = LocoMeasData.(VCMFamily).DeviceList;


    % Change to Gain, Roll, Crunch system (Need to add a logic for single view BPMs???)
    i = findrowindex(BPMxDeviceList, BPMxDeviceListTotal);
    for j = 1:length(BPMData(end).HBPMGain)
        MLOCO = [BPMData(end).HBPMGain(j)     BPMData(end).HBPMCoupling(j)
            BPMData(end).VBPMCoupling(j) BPMData(end).VBPMGain(j) ];

        [AO.(BPMxFamily).Gain(i(j),:), AO.(BPMyFamily).Gain(i(j),:), AO.(BPMxFamily).Crunch(i(j),:), AO.(BPMxFamily).Roll(i(j),:)] = loco2gcr(MLOCO);
    end
    AO.(BPMyFamily).Roll   = AO.(BPMxFamily).Roll;
    AO.(BPMyFamily).Crunch = AO.(BPMxFamily).Crunch;


    %%%%%%%%%%%%%%
    % Correctors %
    %%%%%%%%%%%%%%

    % Kick strength (LOCO is in milliradian)
    % LOCO is run with the original gain in hw2physics (stored in LocoMeasData.VCMGain/LocoMeasData.HCMGain).
    % The new gain must combine the new CM gain and the one used in buildlocoinput.
    % hw2physics:  Rad = G * amps   (original)
    % LOCO gain:   Gloco = KickNew/KickStart
    % New hw2physics gain: Gloco * G

    % HCM
    i = findrowindex(HCMDeviceList, HCMDeviceListTotal);

    HCMGainOldLOCO  = LocoMeasData.HCMGain .* cos(LocoMeasData.HCMRoll);
    HCMGainLOCO     = HCMGainOldLOCO .* CMData(end).HCMKicks ./ CMData(1).HCMKicks;
    HCMCouplingLOCO = HCMGainLOCO .* CMData(end).HCMCoupling;

    %AO.(HCMFamily).Roll(i) = atan2(-HCMCouplingLOCO, HCMGainLOCO);
    AO.(HCMFamily).Roll(i) = atan(HCMCouplingLOCO ./ abs(HCMGainLOCO));
    AO.(HCMFamily).Gain(i) = sign(HCMGainLOCO) .* sqrt(HCMCouplingLOCO.^2 + HCMGainLOCO.^2);


    % VCM
    i = findrowindex(VCMDeviceList, VCMDeviceListTotal);

    VCMGainOldLOCO  = LocoMeasData.VCMGain .* cos(LocoMeasData.VCMRoll);
    VCMGainLOCO     = VCMGainOldLOCO .* CMData(end).VCMKicks ./ CMData(1).VCMKicks;
    VCMCouplingLOCO = VCMGainLOCO .* CMData(end).VCMCoupling;

    %AO.(VCMFamily).Roll(i) = atan2(-VCMCouplingLOCO, VCMGainLOCO);
    AO.(VCMFamily).Roll(i) = atan(-VCMCouplingLOCO ./ abs(VCMGainLOCO));
    AO.(VCMFamily).Gain(i) = sign(VCMGainLOCO) .* sqrt(VCMCouplingLOCO.^2 + VCMGainLOCO.^2);


    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield(BPMxFamily, 'GCR', [AO.(BPMxFamily).Gain AO.(BPMyFamily).Gain AO.(BPMxFamily).Crunch AO.(BPMxFamily).Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield(HCMFamily, 'Roll', 0*AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 2);
    setatfield(VCMFamily, 'Roll', 0*AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield(HCMFamily, 'Roll', AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 1);
    setatfield(VCMFamily, 'Roll', AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 2);


    % If other magnet fits were done (like roll), it should be add to the AT model as well

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetModel'))

    % Some LOCO errors are applied to the accelerator 'SetMachine' and some
    % go to the model.  If errors detected by LOCO are not applied to the accelerator,
    % then include them in the AT and Middle Layer model.

    % The assumption is that setlocodata('SetMachine') has already been run.
    % So QF, QD, QFA, QDA, SQ have changed in the accelerator to match the LOCO run.

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end


    % Load the LOCO data
    load(FileName);


    % Set the model gains
    setlocodata('SetGains', FileName);


    % Set normal bend K-value
    fprintf('   Setting the normal BEND K-Values in the AT model to %f.\n', FitParameters(end).Values(59));
    BENDfit = FitParameters(end).Values(59);
    BENDDeviceList = family2dev('BEND');
    iIndex = findrowindex([4 2;8 2;12 2], BENDDeviceList);
    BENDDeviceList(iIndex,:) = [];
    setpvmodel('BEND', 'K', BENDfit, BENDDeviceList);


    % Sextupoles (set to the values in the machine save since they are not fit)
    if all(LocoMeasData.MachineConfig.SF.Setpoint.Data == 0)
        fprintf('   Setting SF to zero in the AT model.\n');
        setsp('SF', 0, 'Physics', 'Model');
    else
        %setpv(LocoMeasData.MachineConfig.SF.Setpoint, 'Model');
    end
    if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
        fprintf('   Setting SD to zero in the AT model.\n');
        setsp('SD', 0, 'Physics', 'Model');
    else
        %setpv(LocoMeasData.MachineConfig.SD.Setpoint, 'Model');
    end


    % Set the skew quad offset to the production setpoint since this value
    % was chosen to make the machine match the model to zero.
    %SP = getproductionlattice;
    %setfamilydata(SP.SQ.Setpoint.Data, 'SQ', 'Offset', SP.SQ.Setpoint.DeviceList);

    %global THERING
    %RINGData.Lattice = THERING;
    %for i = 1:length(FitParameters(end).Params)
    %    RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
    %end
    %THERING = RINGData.Lattice;


elseif any(strcmpi(CommandInput, 'LOCO2Model'))

    % LOCO is usually used to correct the model.  If the LOCO fit parameters are
    % not applied to the accelerator, then the entire model needs to be updated.
    % Ie, the machine lattice file is the same as it was when the LOCO data was
    % taken, then put the LOCO output settings in the model.

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end


    % Load the LOCO data
    load(FileName);


    % Set the model gains
    setlocodata('SetGains', FileName);

    
    % Use loco function to make the parameter changes
    global THERING
    RINGData.Lattice = THERING;
    for i = 1:length(FitParameters(end).Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
    end
    THERING = RINGData.Lattice;
   

elseif any(strcmpi(CommandInput, 'CorrectCoupling'))

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    % Load the LOCO data
    load(FileName);

    fprintf('   Correcting the coupling based on LOCO file %s.\n', FileName);

    % Find the skew quadrupole fits
    SQ = FitParameters(end).Values(nnnnn:mmmmm);  % ???

    % Starting point for the skew quadrupoles
    MachineConfig = LocoMeasData.MachineConfig;
    setpv(MachineConfig.SQ.Setpoint);

    SQhw = physics2hw('SQ', 'Setpoint', SQ);

    % Maximum setpoint check
    if any(abs(MachineConfig.SQ.Setpoint.Data+SQhw)>maxsp('SQ'))
        error('At least one of the SQ would go beyond it''s limit ... aborting');
    end

    
    % Make the setpoint change
    stepsp('SQSF', -SQhw);

    % Keep the change?
    CorrectFlag = questdlg('Keep the new skew quadrupole setpoints or return to the old values?','SETLOCOGAINS(''SetCoupling'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') | isempty(CorrectFlag)
        fprintf('   Changing the skew quadrupole magnets back to the original setpoints.\n');
        stepsp('SQSF', SQhw);
    end


elseif any(strcmpi(CommandInput, 'Symmetrize'))

    
    error('This needs some work to be used on the xray ring.');
    
    
    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    % Load the LOCO data
    load(FileName);


    %%%%%%%%%%%%%%%%%%%%%%
    % Use the Loco Model %
    %%%%%%%%%%%%%%%%%%%%%%

    % If errors detected by this LOCO file are not applied to the accelerator,
    % ie, the machine lattice file is the same as it was when the LOCO data was
    % taken, then put the LOCO output settings in the model.

    fprintf('   Symmetrizing the lattice based on LOCO file %s.\n', FileName);

    % Magnet fits
    QFfit = FitParameters(end).Values(1:24);
    QDfit = FitParameters(end).Values(25:48);
    QFAfit = FitParameters(end).Values([49 50 51 52]);
    QDAfit = FitParameters(end).Values([53 54 55 56 57 58]);
    BENDfit = FitParameters(end).Values(59);

    QFfit0 = FitParameters(1).Values(1:24);
    QDfit0 = FitParameters(1).Values(25:48);
    QFAfit0 = FitParameters(1).Values([49 50 51 52]);
    QDAfit0 = FitParameters(1).Values([53 54 55 56 57 58]);
    BENDfit0 = FitParameters(1).Values(59);

    if length(FitParameters(end).Values) >= 83
        SQSFfit = FitParameters(end).Values(60:70);
        SQSDfit = FitParameters(end).Values(71:83);

        SQSFfit0 = FitParameters(1).Values(60:70);
        SQSDfit0 = FitParameters(1).Values(71:83);
    end

    % Lattice magnets at the start of the LOCO run
    QF  = LocoMeasData.MachineConfig.QF.Setpoint.Data;
    QD  = LocoMeasData.MachineConfig.QD.Setpoint.Data;
    QFA = LocoMeasData.MachineConfig.QFA.Setpoint.Data;
    QDA = LocoMeasData.MachineConfig.QDA.Setpoint.Data;
    SF  = LocoMeasData.MachineConfig.SF.Setpoint.Data;
    SD  = LocoMeasData.MachineConfig.SD.Setpoint.Data;
    BEND= LocoMeasData.MachineConfig.BEND.Setpoint.Data;

    % Save the old setpoints
    QFold = getsp('QF');
    QDold = getsp('QD');
    QFAold = getsp('QFA');
    QDAold = getsp('QDA');
    SFold = getsp('SF');
    SDold = getsp('SD');


    ModeCell = {'Re-fit the AT model based on the LOCO BEND k-value', 'Use the present AT Model', 'Hold the Magnet Mean Constant'};
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString', ...
        strvcat('To account for the LOCO fit k-value for the normal BEND family', ...
        strvcat('either the AT model needs to be re-fit, the present AT model', ...
        strvcat('BEND already matches the LOCO fit BEND, or the mean of all', ...
        strvcat('quadrupole families can to be held constant.', ...
        strvcat('(Computing the AT fit is recommended if the BEND was fit in LOCO.)',' '))))), ...
        'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [400 90]);
    if OKFlag ~= 1
        fprintf('   setlocodata cancelled\n');
        return
    end
    if ModeNumber == 1
        CommandInput = 'Compute a New AT Fit';
    elseif ModeNumber == 2
        CommandInput = 'Use the present AT Model';
    elseif ModeNumber == 3
        CommandInput = 'Hold the Magnet Mean Constant';
    end

    % CommandInput = questdlg( ...
    % strvcat('To account for the new k-value for the normal BEND family,', ...
    %     strvcat('either the model needs to be accurate, fit, or the mean of', ...
    %     strvcat('all quadrupole families needs to be held constant.', ...
    %     strvcat(' ',strvcat('(Computing the AT fit is recommended.)',' '))))), ...
    %     'SETLOCOGAINS', ...
    %     'Compute a New AT Fit', ...
    %     'Use the present AT Model', ...
    %     'Hold the Magnet Mean Constant', ...
    %     'Cancel', ...
    %     'Compute a New AT Fit');
    switch CommandInput
        case {'Compute a New AT Fit', 'Use the present AT Model'}


            if strcmp(CommandInput, 'Compute a New AT Fit')

                % AT fit method
                if strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, High Tune') | ...
                        strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') | ...
                        strcmpi(getfamilydata('OperationalMode'), '1.5 GeV, High Tune')
                    MeritFun = @alsfitnuy9;
                elseif  strcmpi(getfamilydata('OperationalMode'), '1.5 GeV, Isochronous Sections')
                    error('A isochronous sections merit function needs to be writen');
                    %MeritFun = @alsfitisochronous;
                elseif strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, Low Tune')
                    error('A low tune merit function needs to be writen');
                else
                    disp('Using the high tune merit function.  I''m not sure that''s what you want!!!!');
                    MeritFun = @alsfitnuy9;
                end


                % Radiation must be off for accurate tune measurements
                [PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld] = setradiation('Off');


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Set normal bend K-value (no change to superbends) %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %BENDfit = BENDfit0  % To remove the LOCO BEND fit FitParameters(1).Values(59);
                BENDDeviceList = family2dev('BEND');
                iIndex = findrowindex([4 2;8 2;12 2], BENDDeviceList);
                BENDDeviceList(iIndex,:) = [];
                setpvmodel('BEND', 'K', BENDfit, BENDDeviceList);


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % The starting point of the model must be the starting LOCO model %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Skew quadrupoles
                if length(FitParameters(end).Values) >= 83
                    if any(SQSFfit0~=0)
                        fprintf('   Warning: the start point in the model for SQSF is not zero.\n');
                    end
                    if any(SQSDfit0~=0)
                        fprintf('   Warning: the start point in the model for SQSD is not zero.\n');
                    end

                    setsp('SQSF', SQSFfit0, 'Physics', 'Model');
                    setsp('SQSD', SQSDfit0, 'Physics', 'Model');
                else
                    setsp('SQSF', 0, 'Physics', 'Model');
                    setsp('SQSD', 0, 'Physics', 'Model');
                end

                % Sextupoles (set to the values in the machine save since they are not fit)
                if all(LocoMeasData.MachineConfig.SF.Setpoint.Data == 0)
                    setsp('SF', 0, 'Physics', 'Model');
                else
                    setpv(LocoMeasData.MachineConfig.SF.Setpoint, 'Model');
                end
                if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
                    setsp('SD', 0, 'Physics', 'Model');
                else
                    setpv(LocoMeasData.MachineConfig.SD.Setpoint, 'Model');
                end


                x0 = [
                    QFfit0(1);
                    QFfit0(7);
                    QDfit0(1);
                    QDfit0(7);
                    QFAfit0(1);
                    QFAfit0(2);
                    QDAfit0(1); ];

                %x = [
                %    getsp('QF',  [1 1], 'Physics', 'Model');
                %    getsp('QF',  [4 1], 'Physics', 'Model');
                %    getsp('QD',  [1 1], 'Physics', 'Model');
                %    getsp('QD',  [4 1], 'Physics', 'Model');
                %    getsp('QFA', [1 1], 'Physics', 'Model');
                %    getsp('QFA', [4 1], 'Physics', 'Model');
                %    getsp('QDA', [4 1], 'Physics', 'Model') ];

                % Set the model and get the starting error and goal
                y0 = MeritFun(x0);


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Fit the AT model with the new bend setpoint %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                CorrectFlag = 'Refit';
                while strcmp(CorrectFlag,'Refit')
                    % Run AT model fit
                    [x, y, ygoal] = alslocofit(MeritFun);

                    fprintf('          Fit Results   Starting Point\n');
                    fprintf('   BEND =%12.8f    %12.8f  (non-superbend sectors)\n', getpvmodel('BEND', 'K', [1 1]), BENDfit0);
                    fprintf('   SF   =               %13.8f \n', getsp('SF', [1 1], 'Model', 'Physics'));
                    fprintf('   SD   =               %13.8f \n', getsp('SD', [1 1], 'Model', 'Physics'));
                    d = family2dev('SQSF');
                    if all(getsp('SQSF','model') == getsp('SQSF',d(1,:),'model'))
                        fprintf('   SQSF =               %13.8f \n', getsp('SQSF',d(1,:),'model'));
                    else
                        fprintf('   SQSF are at different setpoints\n');
                    end
                    d = family2dev('SQSD');
                    if all(getsp('SQSD','model') == getsp('SQSD',d(1,:),'model'))
                        fprintf('   SQSD =               %13.8f \n', getsp('SQSD',d(1,:),'model'));
                    else
                        fprintf('   SQSD are at different setpoints\n');
                    end

                    fprintf('   QF   =%12.8f    %12.8f  (non-superbend sectors)\n',      x(1), x0(1));
                    fprintf('   QF   =%12.8f    %12.8f  (superbend sectors 4, 8, 12)\n', x(2), x0(2));
                    fprintf('   QD   =%12.8f    %12.8f  (non-superbend sectors)\n',      x(3), x0(3));
                    fprintf('   QD   =%12.8f    %12.8f  (superbend sectors 4, 8, 12)\n', x(4), x0(4));
                    fprintf('   QFA  =%12.8f    %12.8f  (non-superbend sectors)\n',      x(5), x0(5));
                    fprintf('   QFA  =%12.8f    %12.8f  (superbend sectors 4, 8, 12)\n', x(6), x0(6));
                    fprintf('   QDA  =%12.8f    %12.8f                              \n', x(7), x0(7));

                    CorrectFlag = questdlg('Run the fit again, apply correctrion to the aaccelerator, or cancel?','SETLOCOGAINS(''SetMachine'')','Refit','Apply','Cancel', 'Cancel');
                    if strcmpi(CorrectFlag, 'Cancel') | isempty(CorrectFlag)
                        fprintf('\n');
                        fprintf('   The AT model may need to be reset.\n');
                        fprintf('   setlocodata(''SetMachine'') canceled.\n\n');
                        return
                    end
                    fprintf('\n');
                end


                % Restore the AT model or make this the new AT model setpoints???
                fprintf('   The AT model is being left in the witht the new fit parameters.\n');
                fprintf('   Changing the AT model to these new setting may be wise.\n');


                % Restore passmethods for radiation on/off
                setpassmethod(ATIndexOld, PassMethodOld);

            else

                fprintf('   Using the present AT model to set the quadrupoles.');

                x0 = [
                    QFfit0(1);
                    QFfit0(7);
                    QDfit0(1);
                    QDfit0(7);
                    QFAfit0(1);
                    QFAfit0(2);
                    QDAfit0(1); ];

                x = [
                    getsp('QF',  [1 1], 'Physics', 'Model');
                    getsp('QF',  [4 1], 'Physics', 'Model');
                    getsp('QD',  [1 1], 'Physics', 'Model');
                    getsp('QD',  [4 1], 'Physics', 'Model');
                    getsp('QFA', [1 1], 'Physics', 'Model');
                    getsp('QFA', [4 1], 'Physics', 'Model');
                    getsp('QDA', [4 1], 'Physics', 'Model') ];
            end


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Make the setpoint change %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Compute LOCO change
            QFnew = QF .* QFfit0 ./ QFfit;
            QDnew = QD .* QDfit0 ./ QDfit;

            QFAnew([(1:6) 9:14 17:22]) = QFA([(1:6) 9:14 17:22]) * QFAfit0(1) / QFAfit(1);
            QFAnew([ 7  8]) = QFA([ 7  8]) * QFAfit0(2) / QFAfit(2);
            QFAnew([15 16]) = QFA([15 16]) * QFAfit0(3) / QFAfit(3);
            QFAnew([23 24]) = QFA([23 24]) * QFAfit0(4) / QFAfit(4);
            QFAnew = QFAnew';

            QDAnew = QDA .* QDAfit0 ./ QDAfit;

            % Scale by model change (LOCO zero'th iteration to the ideal model)
            QFnew([(1:6) 9:14 17:22]) = QFnew([(1:6) 9:14 17:22]) * x(1) / x0(1);
            QFnew([7 8 15 16 23 24])  = QFnew([7 8 15 16 23 24])  * x(2) / x0(2);
            QDnew([(1:6) 9:14 17:22]) = QDnew([(1:6) 9:14 17:22]) * x(3) / x0(3);
            QDnew([7 8 15 16 23 24])  = QDnew([7 8 15 16 23 24])  * x(4) / x0(4);

            QFAnew([(1:6) 9:14 17:22]) = QFAnew([(1:6) 9:14 17:22]) * x(5) / x0(5);
            QFAnew([ 7  8]) = QFAnew([ 7  8]) * x(6) / x0(6);
            QFAnew([15 16]) = QFAnew([15 16]) * x(6) / x0(6);
            QFAnew([23 24]) = QFAnew([23 24]) * x(6) / x0(6);

            QDAnew = QDAnew * x(7) / x0(7);


            % Make the setpoint change
            fprintf('   Changing the lattice magnets.\n');
            setsp('QF',  QFnew,  [], 0);
            setsp('QD',  QDnew,  [], 0);
            setsp('QFA', QFAnew, [], 0);
            setsp('QDA', QDAnew, [], 0);


            if any(SF~=getsp('SF'))
                fprintf('   Warning: SF magnet setpoint is not the same as when the LOCO data set was taken.\n');
            end
            if any(SD~=getsp('SD'))
                fprintf('   Warning: SD magnet setpoint is not the same as when the LOCO data set was taken.\n');
            end
            %setsp('SF', SF, [], 0);
            %setsp('SD', SD, [], 0);

            if any(BEND~=getsp('BEND'))
                fprintf('   Warning: BEND magnet setpoints are not the same as when the LOCO data set was taken.\n');
            end


        case 'Fix Magnet Mean'

            % Constant Mean - This method works ok but needs iterations.

            % Compute LOCO predicted setpoints
            QFnew = QF  .* QFfit0  ./ QFfit;
            QDnew = QD  .* QDfit0  ./ QDfit;
            QDAnew= QDA .* QDAfit0 ./ QDAfit;

            QFA1new  = QFA1  * QFAfit0(1) / QFAfit(1);
            QFA4new  = QFA4  * QFAfit0(2) / QFAfit(2);
            QFA8new  = QFA8  * QFAfit0(3) / QFAfit(3);
            QFA12new = QFA12 * QFAfit0(4) / QFAfit(4);
            QFAnew   = [
                QFA1new  * ones(6,1)
                QFA4new  * ones(2,1)
                QFA1new  * ones(6,1)
                QFA8new  * ones(2,1)
                QFA1new  * ones(6,1)
                QFA12new * ones(2,1)
                ];

            % Adjust each family to keep the mean constant
            QFnew  = QFnew  * mean(QF)  / mean(QFnew);
            QDnew  = QDnew  * mean(QD)  / mean(QDnew);
            QDAnew = QDAnew * mean(QDA) / mean(QDAnew);
            QFAnew = QFAnew * mean(QFA) / mean(QFAnew);

            % Make the setpoint change
            N = 1;
            for i = 1:N
                setsp('QF',  QF  - (i/N) * (QF  - QFnew) , [], 0);
                setsp('QD',  QD  - (i/N) * (QD  - QDnew) , [], 0);
                setsp('QFA', QFA - (i/N) * (QFA - QFAnew), [], 0);
                setsp('QDA', QDA - (i/N) * (QDA - QDAnew), [], 0);

                % setorbit({x.Data, y.Data}, {x,y}, {hcm,vcm}, 1, 1e-2);
                % pause(1);
            end


        case 'Ignor Bend Change'

            QFnew = QF  .* QFfit0 ./ QFfit;
            QDnew = QD  .* QDfit0 ./ QDfit;
            QDAnew= QDA .* QDAfit0 ./ QDAfit;
            QFA1new  = QFA1  * QFAfit0(1) / QFAfit(1);
            QFA4new  = QFA4  * QFAfit0(2) / QFAfit(2);
            QFA8new  = QFA8  * QFAfit0(3) / QFAfit(3);
            QFA12new = QFA12 * QFAfit0(4) / QFAfit(4);

            setsp('QF',  QFnew, [], 0);
            setsp('QD',  QDnew, [], 0);
            setsp('QDA', QDAnew, [], 0);

            setsp('QFA', QFA1new, [1 1], 0);
            setsp('QFA', QFA4new, [4 1], 0);
            setsp('QFA', QFA8new, [8 1], 0);
            setsp('QFA', QFA12new , [12 1], 0);

        otherwise

            fprintf('   No change made to the lattice.\n');
            return;
    end


    CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCOGAINS(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') | isempty(CorrectFlag)
        fprintf('\n');
        % Make the setpoint change
        fprintf('   Changing the lattice magnets back to the original setpoints.\n');
        setsp('QF',  QFold, [], 0);
        setsp('QD',  QDold, [], 0);
        setsp('QFA', QFAold, [], 0);
        setsp('QDA', QDAold, [], 0);

        %setsp('SF', SFold, [], 0);
        %setsp('SD', SDold, [], 0);
    else
        % Set the model to proper gains and bend K value
        setlocodata('SetModel', FileName);
    end


else

    error('   SETLOCODATA command not known.');

end

