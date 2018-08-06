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
    [ModeNumber, OKFlag] = listdlg('Name','CLS','PromptString', ...
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
        % Default (Golden) LOCO file
        FileName = getfamilydata('OpsData','LOCOFile');
    else
        % If empty, the user will be prompted if needed.
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


switch lower(CommandInput)
    case 'nominal'
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


    case 'setgains'

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


    case 'setmodel'

        % Some LOCO errors are applied to the accelerator 'SetMachine' and some
        % go to the model.  If errors detected by LOCO are not applied to the accelerator,
        % then include them in the AT and Middle Layer model.

        % The assumption is that setlocodata('SetMachine') has already been run.
        % So QF, QD, QFA, QDA, SQSF, SQSD have changed in the accelerator to match
        % the LOCO run.

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

        error('Change setlocodata to get the proper BEND fit value!');

        % Set normal bend K-value
        fprintf('   Setting the normal BEND K-Values in the AT model to %f.\n', FitParameters(end).Values(59));
        BENDloco = FitParameters(end).Values(59);
        BENDDeviceList = family2dev('BEND');
        iIndex = findrowindex([4 2;8 2;12 2], BENDDeviceList);
        BENDDeviceList(iIndex,:) = [];
        setpvmodel('BEND', 'K', BENDloco, BENDDeviceList);


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
        %setfamilydata(SP.SkewQuad.Setpoint.Data, 'SQSF', 'Offset', SP.SQSF.Setpoint.DeviceList);

        %global THERING
        %RINGData.Lattice = THERING;
        %for i = 1:length(FitParameters(end).Params)
        %    RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
        %end
        %THERING = RINGData.Lattice;


    case 'loco2model'

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


    case 'symmetrize'

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
        % taken, then put the LOCO output settings in the model (LOCO2Model).

        fprintf('   Symmetrizing the lattice based on LOCO file %s.\n', FileName);

        % Magnet fits
        Q1fit = FitParameters(end).Values( 1:12);
        Q2fit = FitParameters(end).Values(13:24);
        Q3fit = FitParameters(end).Values(25:36);
        Q4fit = FitParameters(end).Values(37);
        Q5fit = FitParameters(end).Values(38);
        Q6fit = FitParameters(end).Values(39);

        % Magnet fits
        Q1model = FitParameters(1).Values( 1:12);
        Q2model = FitParameters(1).Values(13:24);
        Q3model = FitParameters(1).Values(25:36);
        Q4model = FitParameters(1).Values(37);
        Q5model = FitParameters(1).Values(38);
        Q6model = FitParameters(1).Values(39);

        % Lattice magnets at the start of the LOCO run
        Q1 = LocoMeasData.MachineConfig.Q1.Setpoint.Data(1:2:end);
        Q2 = LocoMeasData.MachineConfig.Q2.Setpoint.Data(1:2:end);
        Q3 = LocoMeasData.MachineConfig.Q3.Setpoint.Data(1:2:end);
        Q4 = LocoMeasData.MachineConfig.Q4.Setpoint.Data(1:2:end);
        Q5 = LocoMeasData.MachineConfig.Q5.Setpoint.Data(1:2:end);
        Q6 = LocoMeasData.MachineConfig.Q6.Setpoint.Data(1:2:end);

        % New setpoints
        % Note: this will make the tunes equal to the model tunes
        Q1new = (Q1model./Q1fit) .* Q1;
        Q2new = (Q2model./Q2fit) .* Q2;
        Q3new = (Q3model./Q3fit) .* Q3;
        Q4new = (Q4model./Q4fit) .* Q4;
        Q5new = (Q5model./Q5fit) .* Q5;
        Q6new = (Q6model./Q6fit) .* Q6;

        % Make the setpoint change
        Family = 'Q1';
        Dev = family2dev(Family);
        setsp(Family, Q1new, Dev(1:2:end,:));

        Family = 'Q2';
        Dev = family2dev(Family);
        setsp(Family, Q2new, Dev(1:2:end,:));

        Family = 'Q3';
        Dev = family2dev(Family);
        setsp(Family, Q3new, Dev(1:2:end,:));

        Family = 'Q4';
        Dev = family2dev(Family);
        setsp(Family, Q4new, Dev(1:2:end,:));

        Family = 'Q5';
        Dev = family2dev(Family);
        setsp(Family, Q5new, Dev(1:2:end,:));

        Family = 'Q6';
        Dev = family2dev(Family);
        setsp(Family, Q6new, Dev(1:2:end,:));


    case 'correctcoupling'

        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
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

        if length(FitParameters(end).Values) > 39
            Skewfit  = FitParameters(end).Values(40:43);
            Skewfit0 = FitParameters(1).Values(40:43);
        else
            error('No skew quad fit parameters found');
        end

        % Make sure the starting point for the skew quadrupoles is the same
        % as when the LOCO data was taken.
        MachineConfig = LocoMeasData.MachineConfig;
        setpv(MachineConfig.SkewQuad.Setpoint);

        % Apply the negative of the fit in hardware units
        SkewQuadhw = physics2hw('SkewQuad', 'Setpoint', -Skewfit);

        stepsp('SkewQuad', SkewQuadhw);

    otherwise
        error('   SETLOCODATA command not known.');
end


