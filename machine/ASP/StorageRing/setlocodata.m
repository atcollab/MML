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
%                    This sets all lattice machines fit in the LOCO run to
%                    the model.
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
    [ModeNumber, OKFlag] = listdlg('Name','ASP','PromptString', ...
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
    elseif ModeNumber == 7
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
    disp('NOMINAL')

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

    
    % Magnet gains set to unity (rolls are set in the AT model)  (This is not really needed)
    AO.QFA.Gain = ones(size(family2dev('QFA',0),1),1);
    AO.QDA.Gain = ones(size(family2dev('QDA',0),1),1);
    AO.QFB.Gain = ones(size(family2dev('QFB',0),1),1);
 
    AO.SFA.Gain = ones(size(family2dev('SFA',0),1),1);
    AO.SFB.Gain = ones(size(family2dev('SFB',0),1),1);
    AO.SDA.Gain = ones(size(family2dev('SDA',0),1),1);
    AO.SDB.Gain = ones(size(family2dev('SDB',0),1),1);
    
    setao(AO);
    

elseif any(strcmpi(CommandInput, 'SetGains'))

    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    % Set the model gains
    setlocodata('Nominal');

    AO = getao;

    % Load the LOCO data
    fprintf('   Setting BPM and corrector gains and rolls based on %s.\n', FileName);
    load(FileName);


    % Get the device list from the LOCO file
    try
        BPMxDeviceList = LocoMeasData.HBPM.DeviceList;
        BPMyDeviceList = LocoMeasData.VBPM.DeviceList;
        HCMDeviceList  = LocoMeasData.HCM.DeviceList;
        VCMDeviceList  = LocoMeasData.VCM.DeviceList;
    catch
        % Legacy
        BPMxDeviceList = LocoMeasData.(BPMxFamily).DeviceList;
        BPMyDeviceList = LocoMeasData.(BPMyFamily).DeviceList;
        HCMDeviceList  = LocoMeasData.(HCMFamily).DeviceList;
        VCMDeviceList  = LocoMeasData.(VCMFamily).DeviceList;
    end
    

    % Change to Gain, Roll, Crunch system (Need to add a logic for single view BPMs???)
    i = findrowindex(BPMxDeviceList, BPMxDeviceListTotal);
    for j = 1:length(BPMData(end).HBPMGain)
        MLOCO = [BPMData(end).HBPMGain(j)     BPMData(end).HBPMCoupling(j)
                 BPMData(end).VBPMCoupling(j) BPMData(end).VBPMGain(j) ];

        [AO.(BPMxFamily).Gain(i(j),:), AO.(BPMyFamily).Gain(i(j),:), AO.(BPMxFamily).Crunch(i(j),:), AO.(BPMxFamily).Roll(i(j),:)] = loco2gcr(MLOCO);
    end
    AO.(BPMyFamily).Roll   = AO.(BPMxFamily).Roll;
    AO.(BPMyFamily).Crunch = AO.(BPMxFamily).Crunch;

    if ~isreal(AO.(BPMxFamily).Gain)
        error('Horizontal BPM gain is complex.');
    end
    if ~isreal(AO.(BPMyFamily).Gain)
        error('Vertical BPM gain is complex.');
    end
    if ~isreal(AO.(BPMxFamily).Crunch)
        error('BPM Crunch is complex.');
    end
    if ~isreal(AO.(BPMxFamily).Roll)
        error('BPM roll is complex.');
    end
    
    
    
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

    % Some LOCO errors are applied to the accelerator 'Symmetrize' and some
    % go to the model.  If errors detected by LOCO are not applied to the accelerator,
    % then include them in the AT and Middle Layer model.
    
    error('   Option not programmed yet');


elseif any(strcmpi(CommandInput, 'LOCO2Model'))

    % LOCO is usually used to correct the model.  If the LOCO fit parameters are
    % not applied to the accelerator, then the entire model needs to be updated.
    % Ie, the machine lattice file is the same as it was when the LOCO data was
    % taken, then put the LOCO output settings in the model.
    
    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end


    % Load the LOCO data
    load(FileName);

    
    % Use loco file for the lattice and the fit parameter
    % Using the loco lattice may not be what you want???
    global THERING
    %RINGData.Lattice = THERING;
    for i = 1:length(FitParameters(end).Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
    end
    THERING = RINGData.Lattice;

    
    % Since the lattice may have changed
    updateatindex;
    

    % Set the model gains (this added GCR field to lattice)
    setlocodata('SetGains', FileName);
   

elseif any(strcmpi(CommandInput, 'CorrectCoupling'))

    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if FileName == 0
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end
    
    
    
    error('   Option not programmed yet');


    
    % Load the LOCO data
    load(FileName);

    fprintf('   Correcting the coupling based on LOCO file %s.\n', FileName);

    % Find the skew quadrupole fits  ???????????
    if length(FitParameters(end).Values) < 83
        error('Did not find the skew quads fit parameters.');
    elseif length(FitParameters(end).Values) > 83
        fprintf('   There are more than 83 fit parameters, hopefully the skew quads fits are still 60:83\n');
        fprintf('   If all 24 skew quadrupoles were fit this function will fail!\n');
    end

    SQK = FitParameters(end).Values(60:70);  % ??????????

    % Starting point for the skew quadrupoles
    MachineConfig = LocoMeasData.MachineConfig;
    setpv(MachineConfig.SQK.Setpoint);

    % Since the skew power supplies are wired backwards, just apply the fit directly
    SQSFhw = physics2hw('SQSF', 'Setpoint', SQSF);

    % Maximum setpoint check
    if any(abs(MachineConfig.SQK.Setpoint.Data+SQKhw)>maxsp('SQK'))
        error('At least one of the SQSF would go beyond it''s limit ... aborting');
    end


    % Make the setpoint change
    stepsp('SQK', SQKhw);

    % Keep the change?
    CorrectFlag = questdlg('Keep the new skew quadrupole setpoints or return to the old values?','SETLOCOGAINS(''SetCoupling'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') | isempty(CorrectFlag)
        fprintf('   Changing the skew quadrupole magnets back to the original setpoints.\n');
        stepsp('SQK', -SQKhw);
    end


elseif any(strcmpi(CommandInput, 'Symmetrize'))

    error('   Option not programmed yet');

else

    error('   SETLOCODATA command not known.');

end

