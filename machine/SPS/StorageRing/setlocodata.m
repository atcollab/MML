function setlocodata(CommandInput, FileName)
%SETLOCODATA - Applies the LOCO output data to the the accelerator, MML setup, and AT model
%  setlocodata(CommandInput, FileName)
%
%  INPUTS
%  1. CommandInput
%     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%     'SetGains'   - Set gains/coupling from a LOCO file.
%     'Symmetrize' - Symmetry correction of the lattice based on a LOCO file.
%     'CorrectCoupling' - Coupling correction of the lattice based on a LOCO file.
%                         Option to add and dispersion wave and bump.
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

%  Written by Greg Portmann


global THERING

if nargin < 1
    CommandInput = '';
end

if isempty(CommandInput)
    %CommandInput = 'Default';
    ModeCell = {'Nominal - Set Gain=1 & Rolls=0 in the model', 'SetGains - Set gains/rolls from a LOCO file','Symmetrize - Symmetry correction of the lattice', 'CorrectCoupling - Coupling correction of the lattice', 'SetModel - Set the model from a LOCO file','LOCO2Model - Set the model from a LOCO file (also does a SetGains)', 'see "help setlocodata" for more details'};
    [ModeNumber, OKFlag] = listdlg('Name',getfamilydata('Machine'),'PromptString', ...
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
    if any(strcmpi(CommandInput,{'SetGains','SetModel'}))
        % Default (Golden) LOCO file (if empty, the user will be prompted)
        FileName = getfamilydata('OpsData','LOCOFile');
    else
        FileName = '';
    end
end


% Default families
HBPMFamily = gethbpmfamily;
VBPMFamily = getvbpmfamily;
HCMFamily  = gethcmfamily;
VCMFamily  = getvcmfamily;


% Device list
HBPMDeviceList      = family2dev(HBPMFamily);
HBPMDeviceListTotal = family2dev(HBPMFamily,0);
VBPMDeviceList      = family2dev(VBPMFamily);
VBPMDeviceListTotal = family2dev(VBPMFamily,0);

HCMDeviceList      = family2dev(HCMFamily);
HCMDeviceListTotal = family2dev(HCMFamily,0);
VCMDeviceList      = family2dev(VCMFamily);
VCMDeviceListTotal = family2dev(VCMFamily,0);

switch CommandInput
    case 'Nominal'
        fprintf('   Using nominal BPM and corrector gains (1) and rolls (0).\n');

        % To speed things up, put Gains/Rolls/etc in the AO
        AO = getao;

        % Zero or one the gains and rolls
        AO.(HBPMFamily).Gain   =  ones(size(HBPMDeviceListTotal,1),1);
        AO.(VBPMFamily).Gain   =  ones(size(VBPMDeviceListTotal,1),1);
        AO.(HBPMFamily).Roll   = zeros(size(HBPMDeviceListTotal,1),1);
        AO.(VBPMFamily).Roll   = zeros(size(VBPMDeviceListTotal,1),1);
        AO.(HBPMFamily).Crunch = zeros(size(HBPMDeviceListTotal,1),1);
        AO.(VBPMFamily).Crunch = zeros(size(VBPMDeviceListTotal,1),1);

        % Set the gain, roll, & crunch to the AT model to be used by getpvmodel, setpvmodel, etc
        setatfield(HBPMFamily, 'GCR', [AO.(HBPMFamily).Gain AO.(VBPMFamily).Gain AO.(HBPMFamily).Crunch AO.(HBPMFamily).Roll], HBPMDeviceListTotal);


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


    case 'SetGains'

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
            HBPMDeviceList = LocoMeasData.HBPM.DeviceList;
            VBPMDeviceList = LocoMeasData.VBPM.DeviceList;
            HCMDeviceList  = LocoMeasData.HCM.DeviceList;
            VCMDeviceList  = LocoMeasData.VCM.DeviceList;
        catch
            % Legacy
            HBPMDeviceList = LocoMeasData.(HBPMFamily).DeviceList;
            VBPMDeviceList = LocoMeasData.(VBPMFamily).DeviceList;
            HCMDeviceList  = LocoMeasData.(HCMFamily).DeviceList;
            VCMDeviceList  = LocoMeasData.(VCMFamily).DeviceList;
        end
        

        % Change to Gain, Roll, Crunch system (Need to add a logic for single view BPMs???)
        i = findrowindex(HBPMDeviceList, HBPMDeviceListTotal);
        for j = 1:length(BPMData(end).HBPMGain)
            MLOCO = [BPMData(end).HBPMGain(j)     BPMData(end).HBPMCoupling(j)
                     BPMData(end).VBPMCoupling(j) BPMData(end).VBPMGain(j) ];

            [AO.(HBPMFamily).Gain(i(j),:), AO.(VBPMFamily).Gain(i(j),:), AO.(HBPMFamily).Crunch(i(j),:), AO.(HBPMFamily).Roll(i(j),:)] = loco2gcr(MLOCO); 
        end
        AO.(VBPMFamily).Roll   = AO.(HBPMFamily).Roll;
        AO.(VBPMFamily).Crunch = AO.(HBPMFamily).Crunch;

        if ~isreal(AO.(HBPMFamily).Gain)
            error('Horizontal BPM gain is complex.');
        end
        if ~isreal(AO.(VBPMFamily).Gain)
            error('Vertical BPM gain is complex.');
        end
        if ~isreal(AO.(HBPMFamily).Crunch)
            error('BPM Crunch is complex.');
        end
        if ~isreal(AO.(HBPMFamily).Roll)
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
        HCMCouplingLOCO = HCMGainLOCO    .* CMData(end).HCMCoupling;

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
        setatfield(HBPMFamily, 'GCR', [AO.(HBPMFamily).Gain AO.(VBPMFamily).Gain AO.(HBPMFamily).Crunch AO.(HBPMFamily).Roll], HBPMDeviceListTotal);

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


    case 'SetModel'

        % Some LOCO errors are applied to the accelerator 'SetMachine' and some
        % go to the model.  If errors detected by LOCO are not applied to the accelerator,
        % then include them in the AT and Middle Layer model.

        % The assumption is that setlocodata('SetMachine') has already been run.
        % So QF, QD, QFA, QFB have been changed in the accelerator to match the LOCO run.

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


        % Set the model gains
        setlocodata('SetGains', FileName);


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


    case 'LOCO2Model'

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


    case 'Symmetrize'

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

        % Which run iteration to use
        le = length(FitParameters);

        % Scale factors
        QFscale  = FitParameters(1).Values(1:8)   ./ FitParameters(le).Values(1:8)
        QDscale  = FitParameters(1).Values(9:16)  ./ FitParameters(le).Values(9:16);
        QFAscale = FitParameters(1).Values(17:24) ./ FitParameters(le).Values(17:24);
        QDAscale = FitParameters(1).Values(25:28) ./ FitParameters(le).Values(25:28);

        % Scale the present magnet value by the scale factor
        %QFnew  = QFscale(:)  .* getsp('QF');
        %QDnew  = QDscale(:)  .* getsp('QD');
        %QFAnew = QFAscale(:) .* getsp('QFA');
        %QDAnew = QDAscale(:) .* getsp('QDA');

        % Scale the magnet value when the LOCO run was done by the scale factor
        QFnew  = QFscale(:)  .* LocoMeasData.MachineConfig.QF.Setpoint.Data
        QDnew  = QDscale(:)  .* LocoMeasData.MachineConfig.QD.Setpoint.Data
        QFAnew = QFAscale(:) .* LocoMeasData.MachineConfig.QFA.Setpoint.Data
        QDAnew = QDAscale(:) .* LocoMeasData.MachineConfig.QDA.Setpoint.Data


        fprintf('   Setting the quadrupole values\n');
        QFold  = getsp('QF');
        QDold  = getsp('QD');
        QFAold = getsp('QFA');
        QDAold = getsp('QDA');
        setsp('QF',  QFnew);
        setsp('QD',  QDnew);
        setsp('QFA', QFAnew);
        setsp('QDA', QDAnew);


        CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCODATA(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
        if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
            fprintf('   Changing the lattice magnets back to the original setpoints.\n');
            setsp('QF',  QFold,  [], 0);
            setsp('QD',  QDold,  [], 0);
            setsp('QFA', QFAold, [], 0);
            setsp('QDA', QDAold, [], 0);
        end


    case 'CorrectCoupling'

        error('   Function not complete.  Look at the ALS setlocodata for an example.');

    otherwise
        error('   setlocodata command unknown.');
end



