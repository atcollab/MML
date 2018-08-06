function setlocodata(CommandInput, FileName, varargin)
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
%                    This uses the LOCO AT model!!! And sets all lattice
%                    machines fit in the LOCO run to the model.
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
        fprintf('   setlocodata canceled\n');
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
        % If empty, the user will be prompted
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
        %setfamilydata(SP.SQSF.Setpoint.Data, 'SQSF', 'Offset', SP.SQSF.Setpoint.DeviceList);
        %setfamilydata(SP.SQSD.Setpoint.Data, 'SQSD', 'Offset', SP.SQSD.Setpoint.DeviceList);

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
        %RINGData.Lattice = THERING;   % Uncomment to use present lattice.  But this will only  
        %                                work if the number and order of the elements are the same. 
        for i = 1:length(FitParameters(end).Params)
            RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
        end
        THERING = RINGData.Lattice;


        % Since the lattice may have changed
        updateatindex;


        % Set the model gains (this added GCR field to lattice)
        setlocodata('SetGains', FileName);


        %     setlocodata('SetModel', FileName);
        %
        %     % Set anything else not set in SetModel
        %     fprintf('   Setting QF, QD, QFA, QDA, SQSF, SQSD in the AT model.\n');
        %
        %     % Lattice Magnets
        %     QFloco = FitParameters(end).Values(1:24);
        %     QDloco = FitParameters(end).Values(25:48);
        %     QFAloco = FitParameters(end).Values([49 50 51 52]);
        %     QDAloco = FitParameters(end).Values([53 54 55 56 57 58]);
        %
        %     setsp('QF', QFloco, 'Physics', 'Model');
        %     setsp('QD', QDloco, 'Physics', 'Model');
        %     setsp('QDA', QDAloco, 'Physics', 'Model');
        %
        %     setsp('QFA', QFAloco(1), 'Physics', 'Model');
        %     setsp('QFA', QFAloco(2), [ 4 1;  4 2], 'Physics', 'Model');
        %     setsp('QFA', QFAloco(3), [ 8 1;  8 2], 'Physics', 'Model');
        %     setsp('QFA', QFAloco(4), [12 1; 12 2], 'Physics', 'Model');
        %
        %
        %     % Skew quadrupoles
        %     if length(FitParameters(end).Values) >= 131
        %         SQSFloco = FitParameters(end).Values(60:83);
        %         SQSDloco = FitParameters(end).Values(84:107);
        %         SQQFloco = FitParameters(end).Values(108:131);
        %
        %         setsp('SQSF', SQSFloco, family2dev('SQSF',0), 'Physics', 'Model');
        %         setsp('SQSD', SQSDloco, family2dev('SQSD',0), 'Physics', 'Model');
        %
        %         % Set the skew quad at QF
        %         setpvmodel('QF', 'SkewQuad', SQQFloco);
        %
        %
        %     elseif length(FitParameters(end).Values) >= 107
        %         SQSFloco = FitParameters(end).Values(60:83);
        %         SQSDloco = FitParameters(end).Values(84:107);
        %
        %         setsp('SQSF', SQSFloco, family2dev('SQSF',0), 'Physics', 'Model');
        %         setsp('SQSD', SQSDloco, family2dev('SQSD',0), 'Physics', 'Model');
        %
        %     elseif length(FitParameters(end).Values) >= 83
        %         % Skew quad power supply locations (Post 5-12-2005)
        %         %sflist = [1 5 6 9 10 11 12 13 14 17 21]';
        %         %sdlist = [3 5 6 7  9 10 11 12 13 14 15 19 23]';
        %
        %         SQSFloco = FitParameters(end).Values(60:71);
        %         SQSDloco = FitParameters(end).Values(72:83);
        %
        %         setsp('SQSF', SQSFloco, 'Physics', 'Model');
        %         setsp('SQSD', SQSDloco, 'Physics', 'Model');
        %     end
        %
        %     % SB Fit
        %     if length(FitParameters(end).Values) >= 137
        %         % Set the Super BEND fits for K and skewquad
        %         SB_K        = FitParameters(end).Values(132:134);
        %         SB_SkeqQuad = FitParameters(end).Values(135:137);
        %
        %         setpvmodel('BEND', 'K', SB_K, [4 2;8 2;12 2]);
        %         setpvmodel('BEND', 'SkewQuad', SB_SkeqQuad, [4 2;8 2;12 2]);
        %     end


    case 'symmetrize'

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

        % Save THERING and restore on exit so that this function does not change the model
        THERINGsave = THERING;

        % Make sure the design or goal AT model is active
        %AO_ATModel = getfamilydata('ATModel');
        %[DirectoryName, ATModel, Ext] = fileparts(which(AO_ATModel));
        %[ATModel, DirectoryName] = uigetfile('*.*', 'AT Model (Cancel to use the present model)?', [DirectoryName, filesep, ATModel, Ext]);
        %if ATModel == 0
        %    if isempty(THERING)
        %        fprintf('   No AT model found.  Buildlocoinput canceled.\n');
        %        return;
        %    end
        %else
        %    run([DirectoryName, ATModel]);
        %    updateatindex;
        %end


        %%%%%%%%%%%%%%%%%%%%%%
        % Use the Loco Model %
        %%%%%%%%%%%%%%%%%%%%%%

        % If errors detected by this LOCO file are not applied to the accelerator,
        % ie, the machine lattice file is the same as it was when the LOCO data was
        % taken, then put the LOCO output settings in the model.
        fprintf('   Symmetrizing the lattice based on LOCO file %s.\n', FileName);

        if length(FitParameters(end).Values)==81
            % Magnet fits
            QFloco   = FitParameters(end).Values(1:24);
            QDloco   = FitParameters(end).Values(25:48);
            QFAloco  = FitParameters(end).Values([49 50]);
            QDAloco  = FitParameters(end).Values([51 52 53 54 55 56]);
            BENDloco = FitParameters(end).Values(57);

            QFloco0   = FitParameters(1).Values(1:24);
            QDloco0   = FitParameters(1).Values(25:48);
            QFAloco0  = FitParameters(1).Values([49 50]);
            QDAloco0  = FitParameters(1).Values([51 52 53 54 55 56]);
            BENDloco0 = FitParameters(1).Values(57);
            if length(FitParameters(end).Values) >= 81
                SQSFloco = FitParameters(end).Values(58:68);
                SQSDloco = FitParameters(end).Values(69:81);

                SQSFloco0 = FitParameters(1).Values(58:68);
                SQSDloco0 = FitParameters(1).Values(69:81);
            end
        else
            % Magnet fits
            QFloco   = FitParameters(end).Values(1:24);
            QDloco   = FitParameters(end).Values(25:48);
            QFAloco  = FitParameters(end).Values([49 50 51 52]);
            QDAloco  = FitParameters(end).Values([53 54 55 56 57 58]);
            BENDloco = FitParameters(end).Values(59);

            QFloco0   = FitParameters(1).Values(1:24);
            QDloco0   = FitParameters(1).Values(25:48);
            QFAloco0  = FitParameters(1).Values([49 50 51 52]);
            QDAloco0  = FitParameters(1).Values([53 54 55 56 57 58]);
            BENDloco0 = FitParameters(1).Values(59);
            if length(FitParameters(end).Values) >= 83
                SQSFloco = FitParameters(end).Values(60:70);
                SQSDloco = FitParameters(end).Values(71:83);

                SQSFloco0 = FitParameters(1).Values(60:70);
                SQSDloco0 = FitParameters(1).Values(71:83);
            end
        end
        

        % Lattice magnets at the start of the LOCO run
        QF   = LocoMeasData.MachineConfig.QF.Setpoint.Data;
        QD   = LocoMeasData.MachineConfig.QD.Setpoint.Data;
        QFA  = LocoMeasData.MachineConfig.QFA.Setpoint.Data;
        QDA  = LocoMeasData.MachineConfig.QDA.Setpoint.Data;
        SF   = LocoMeasData.MachineConfig.SF.Setpoint.Data;
        SD   = LocoMeasData.MachineConfig.SD.Setpoint.Data;
        BEND = LocoMeasData.MachineConfig.BEND.Setpoint.Data;

        % Save the starting setpoints
        QFold  = getsp('QF');
        QDold  = getsp('QD');
        QFAold = getsp('QFA');
        QDAold = getsp('QDA');
        SFold  = getsp('SF');
        SDold  = getsp('SD');


        if length(varargin) >= 1
            CommandInput = varargin{1};
        else
            ModeCell = {...
                '1. Re-fit the AT model', ...
                '2. Use a precomputed table lookup of model fits', ...
                '3. Use LOCO iteration 0 for the goal', ...
                '4. Use the present AT model for the goal', ...
                '5. Hold the mean of all quadrupole families constant'};
            [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString', ...
                {'Since the ALS BEND has a gradient it must be accounted for:', ...
                '(#1 or #2 is recommended if the BEND K-value was fit in the LOCO run)'}, ...
                'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [400 90], 'InitialValue', 1);
            if OKFlag ~= 1
                fprintf('   setlocodata canceled\n');
                return
            end
        end

        switch ModeNumber
            case 4       % Use present AT model as the goal
                fprintf('   Using the present AT model to set the quadrupoles.\n');
                QFgoal  = getsp('QF',  'Physics', 'Model');
                QDgoal  = getsp('QD',  'Physics', 'Model');
                if length(FitParameters(end).Values) == 81
                    QFAgoal = getsp('QFA', [1 1; 4 1], 'Physics', 'Model');
                else
                    QFAgoal = getsp('QFA', [1 1; 4 1; 8 1; 12 1], 'Physics', 'Model');
                end
                QDAgoal = getsp('QDA', 'Physics', 'Model');

            case {3,5}   % Use iteration zero as the goal / Hold the Magnet Mean Constant
                fprintf('   Using LOCO iteration zero as the goal.\n');
                QFgoal  = QFloco0;
                QDgoal  = QDloco0;
                QFAgoal = QFAloco0;
                QDAgoal = QDAloco0;

                QFnew  = QF  .* QFgoal  ./ QFloco;
                QDnew  = QD  .* QDgoal  ./ QDloco;
                QDAnew = QDA .* QDAgoal ./ QDAloco;
                QFAnew([(1:6) 9:14 17:22]) = QFA([(1:6) 9:14 17:22]) .* QFAgoal(1) / QFAloco(1);
                if length(FitParameters(end).Values) == 81
                    QFAnew([ 7  8 15 16 23 24])            = QFA([ 7  8 15 16 23 24])            .* QFAgoal(2) / QFAloco(2);
                else
                    QFAnew([ 7  8])            = QFA([ 7  8])            .* QFAgoal(2) / QFAloco(2);
                    QFAnew([15 16])            = QFA([15 16])            .* QFAgoal(3) / QFAloco(3);
                    QFAnew([23 24])            = QFA([23 24])            .* QFAgoal(4) / QFAloco(4);
                end
                
            case 2       % Use table lookup of fit values (Christoph Method)
                ModeCell = {'Zero dispersion','3.0 cm dispersion (distributed)','4.5 cm dispersion (distributed)','6.0 cm dispersion (distributed)'};
                [DispFlag, OKFlag] = listdlg('Name','ALS - setlocodata','PromptString','Which Lattice (all are nuy=9.2)?', ...
                    'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [250 80], 'InitialValue', 4);
                if OKFlag ~= 1
                    fprintf('   setlocodata canceled\n');
                    return
                end

                if DispFlag == 4
                    disp('   Using k-values for 6 cm distributed dispersion lattice, nuy = 9.20');
                    kQF=	[2.238359		2.237111	2.234898];
                    kQFS=	[2.221083    2.219784	2.217484];
                    kQD=	[-2.520238	   -2.511045	-2.494778];
                    kQDS=	[-2.492566	   -2.483259	-2.466793];
                    kQFA=	[2.953949	    2.954352	2.955062];
                    kQFAS=	[3.120093	 3.120815	3.122088];
                    kQDA=	[-1.775702	   -1.779475	-1.786132];
                    kBEND=	[-0.7765	-0.7782		-0.7812];
                elseif DispFlag == 3
                    disp('   Using k-values for 4.5 cm dispersion lattice, nuy = 9.20');
                    kQF=     [2.2463    2.2450    2.2428];
                    kQFS=    [2.2289    2.2276    2.2253];
                    kQD=     [-2.5211   -2.5119   -2.4956];
                    kQDS=    [-2.4937   -2.4844   -2.4679];
                    kQFA=    [2.9378    2.9382    2.9389];
                    kQFAS=   [3.1037    3.1044    3.1057];
                    kQDA=    [-1.7801   -1.7838   -1.7905];
                    kBEND=   [-0.7765   -0.7782   -0.7812];
                elseif DispFlag == 2
                    disp('   Using k-values for 3 cm dispersion lattice, nuy = 9.20');
                    kQF=	[2.254162	2.252912	2.250697];
                    kQFS=	[2.236773	2.235473	2.233169];
                    kQD=	[-2.521891	-2.512693	-2.496420];
                    kQDS=	[-2.494757	-2.485447	-2.468974];
                    kQFA=	[2.921608	2.922034	2.922786];
                    kQFAS=	[3.087254	3.088000	3.089313];
                    kQDA=	[-1.784401	-1.788186   -1.794865];
                    kBEND=	[-0.7765	-0.7782		-0.7812];
                elseif DispFlag == 1
                    disp('   Using k-values for zero dispersion lattice, nuy = 9.20');
                    kQF=	[2.273460	2.272206	2.269984];
                    kQFS=	[2.255941	2.254637    2.252326];
                    kQD=	[-2.524850	-2.515648	-2.499365];
                    kQDS=	[-2.498326	-2.489011	-2.472530];
                    kQFA=	[2.885778	2.886233	2.887035];
                    kQFAS=	[3.050999	3.051772	3.053134];
                    kQDA=	[-1.794464	-1.798261	-1.804965];
                    kBEND=	[-0.7765	-0.7782		-0.7812];
                else
                    error('Unknown lattice option');
                end

                % Interpolate in k-value table to find the k-values based on LOCO fit bend magnet gradient
                QFgoal([1:6 9:14 17:22],1)  = interp1(kBEND, kQF,  BENDloco, 'linear', 'extrap');
                QFgoal([7:8 15:16 23:24],1) = interp1(kBEND, kQFS, BENDloco, 'linear', 'extrap');
                QDgoal([1:6 9:14 17:22],1)  = interp1(kBEND, kQD,  BENDloco, 'linear', 'extrap');
                QDgoal([7:8 15:16 23:24],1) = interp1(kBEND, kQDS, BENDloco, 'linear', 'extrap');
                QDAgoal([1:6],1)            = interp1(kBEND, kQDA, BENDloco, 'linear', 'extrap');
                QFAgoal(1,1)                = interp1(kBEND, kQFA, BENDloco, 'linear', 'extrap');
                if length(FitParameters(end).Values) == 81
                    QFAgoal([2],1)          = interp1(kBEND, kQFAS,BENDloco, 'linear', 'extrap');
                else
                    QFAgoal([2 3 4],1)          = interp1(kBEND, kQFAS,BENDloco, 'linear', 'extrap');
                end
                
            case 1      % Compute a New AT Fit
                % AT fit method
                if  strcmpi(getfamilydata('OperationalMode'), '1.5 GeV, Isochronous Sections')
                    error('A isochronous sections merit function needs to be written');
                    %MeritFun = @alsfitisochronous;
                elseif strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, Low Tune')
                    YGoalInput = {'14.25/4';'14.25/3';'8.20/3';'0.0';'0.0';'0.060';'0.0'};
                    MeritFun = @alsfitnuy9;
                else
                    YGoalInput = {'14.25/4';'14.25/3';'9.20/3';'0.0';'0.0';'0.060';'0.0'};
                    MeritFun = @alsfitnuy9;
                    %    MeritFun = @alsfitnuy9;
                    %    % Goal condition for alsfitnuy9
                    %    % Tune after 3 sectors should be 14.25/4
                    %    ygoal(1,1) = 14.25/4;
                    %    % Horizontal & vertical tune after 4 sectors should be 14.25/3 and 9.2/3
                    %    ygoal(2,1) = 14.25/3;
                    %    ygoal(3,1) =  9.20/3;
                    %    % Alpha x/y at injection is zero
                    %    ygoal(4,1) = 0;
                    %    ygoal(5,1) = 0;
                    %    % Horizontal Eta at injection .060 meters
                    %    ygoal(6,1) = .060;
                    %    % Horizontal Eta-prime at injection is zero
                    %    ygoal(7,1) = 0;
                end

                prompt = {
                    'Horizontal Tune after 3 sectors'
                    'Horizontal Tune after 4 sectors'
                    'Vertical Tune after 4 sectors'
                    'Horizontal Alpha at injection'
                    'Vertical Alpha at injection'
                    'Horizontal Eta at injection'
                    'Horizontal Eta-Prime at injection'
                    };
                %for i = 1:7;
                %    YGoalInput{i} = num2str(ygoal(i));
                %end
                Options.Interpreter = 'tex';
                answer = inputdlg(prompt, 'Goal for Fitting Model', 1, YGoalInput, Options);
                if isempty(answer)
                    return
                else
                    for i = 1:7;
                        ygoal(i,1) = str2num(answer{i});
                    end
                end

                % Radiation must be off for accurate tune measurements
                [PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld] = setradiation('Off');


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Set normal bend K-value (no change to superbends) %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %BENDloco = BENDloco0  % To remove the LOCO BEND fit FitParameters(1).Values(59);
                BENDDeviceList = family2dev('BEND');
                iIndex = findrowindex([4 2;8 2;12 2], BENDDeviceList);
                BENDDeviceList(iIndex,:) = [];
                setpvmodel('BEND', 'K', BENDloco, BENDDeviceList);

                % Remove stuff that might get set in a calibrated model (like in setoperationalmode)
                % (This could be dangerous because one might want to do the fit with these parameters set
                % but at least I warn.  It might be better to reload the design model)
                KBendModel = getpvmodel('BEND', 'K', [4 2;8 2;12 2;]);
                if ~all(KBendModel==0)
                    fprintf('   Setting the K-value of the superbends to zero.\n');
                    setpvmodel('BEND', 'K', 0, [4 2;8 2;12 2;]);
                end
                SkewBendModel = getpvmodel('BEND', 'SkewQuad', [4 2;8 2;12 2;]);
                if ~all(SkewBendModel==0)
                    fprintf('   Setting the skew quad component of the BEND zero.\n');
                    setpvmodel('BEND', 'SkewQuad', 0);
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % The starting point of the model must be the starting LOCO model %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Skew quadrupoles
                if length(FitParameters(end).Values) >= 83
                    if any(SQSFloco0~=0)
                        fprintf('   Warning: the start point in the model for SQSF is not zero.\n');
                    end
                    if any(SQSDloco0~=0)
                        fprintf('   Warning: the start point in the model for SQSD is not zero.\n');
                    end

                    setsp('SQSF', SQSFloco0, 'Physics', 'Model');
                    setsp('SQSD', SQSDloco0, 'Physics', 'Model');
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
                    QFloco0(1);
                    QFloco0(7);
                    QDloco0(1);
                    QDloco0(7);
                    QFAloco0(1);
                    QFAloco0(2);
                    QDAloco0(1); ];

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
                    [x, y] = alslocofit(MeritFun, [], ygoal);
                    %[x, y, ygoal] = alslocofit(MeritFun);

                    fprintf('          Fit Results   Starting Point\n');
                    fprintf('   BEND =%12.8f    %12.8f  (non-superbend sectors)\n', getpvmodel('BEND', 'K', [1 1]), BENDloco0);
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

                    CorrectFlag = questdlg('Run the fit again, apply correctrion to the aaccelerator, or cancel?','SETLOCODATA(''SetMachine'')','Refit','Apply','Cancel', 'Cancel');
                    if strcmpi(CorrectFlag, 'Cancel') || isempty(CorrectFlag)
                        % Restore the old AT model
                        THERING = THERINGsave;
                        fprintf('\n');
                        fprintf('   AT model restored.\n');
                        fprintf('   Magnet lattice not changed.\n');
                        return
                    end
                    fprintf('\n');
                end

                % Restore the AT model or make this the new AT model setpoints???
                %fprintf('   The AT model is being left in the with the new fit parameters.\n');
                %fprintf('   Changing the AT model to these new setting may be wise.\n');

                % Restore passmethods for radiation on/off (gets done later)
                %setpassmethod(ATIndexOld, PassMethodOld);

                QFgoal([(1:6) 9:14 17:22],1) = x(1);
                QFgoal([7 8 15 16 23 24],1)  = x(2);
                QDgoal([(1:6) 9:14 17:22],1) = x(3);
                QDgoal([7 8 15 16 23 24],1)  = x(4);
                if length(FitParameters(end).Values) == 81
                    QFAgoal = [x(5); x(6);];
                else
                    QFAgoal = [x(5); x(6); x(6); x(6);];
                end
                QDAgoal = [x(7)];
                
%                 % Compute LOCO change
%                 QFnew  = QF  .* QFloco0  ./ QFloco;
%                 QDnew  = QD  .* QDloco0  ./ QDloco;
%                 QDAnew = QDA .* QDAloco0 ./ QDAloco;
% 
%                 QFAnew([(1:6) 9:14 17:22]) = QFA([(1:6) 9:14 17:22]) * QFAloco0(1) / QFAloco(1);
%                 QFAnew([ 7  8])            = QFA([ 7  8])            * QFAloco0(2) / QFAloco(2);
%                 QFAnew([15 16])            = QFA([15 16])            * QFAloco0(3) / QFAloco(3);
%                 QFAnew([23 24])            = QFA([23 24])            * QFAloco0(4) / QFAloco(4);
%                 QFAnew = QFAnew';
% 
%                 % Scale by model change (LOCO zero'th iteration to the ideal model)
%                 QFnew([(1:6) 9:14 17:22]) = QFnew([(1:6) 9:14 17:22]) * x(1) / x0(1);
%                 QFnew([7 8 15 16 23 24])  = QFnew([7 8 15 16 23 24])  * x(2) / x0(2);
%                 QDnew([(1:6) 9:14 17:22]) = QDnew([(1:6) 9:14 17:22]) * x(3) / x0(3);
%                 QDnew([7 8 15 16 23 24])  = QDnew([7 8 15 16 23 24])  * x(4) / x0(4);
% 
%                 QFAnew([(1:6) 9:14 17:22]) = QFAnew([(1:6) 9:14 17:22]) * x(5) / x0(5);
%                 QFAnew([ 7  8]) = QFAnew([ 7  8]) * x(6) / x0(6);
%                 QFAnew([15 16]) = QFAnew([15 16]) * x(6) / x0(6);
%                 QFAnew([23 24]) = QFAnew([23 24]) * x(6) / x0(6);
% 
%                 QDAnew = QDAnew * x(7) / x0(7);

            otherwise
                fprintf('   Unknown method.  No change made to the lattice.\n');
                return;
        end


        % Compute the currents from goal k-values
        QFnew  = QF  .* QFgoal  ./ QFloco;
        QDnew  = QD  .* QDgoal  ./ QDloco;
        QDAnew = QDA .* QDAgoal ./ QDAloco;
        QFAnew([(1:6) 9:14 17:22],1) = QFA([(1:6) 9:14 17:22]) .* QFAgoal(1) / QFAloco(1);
        if length(FitParameters(end).Values) == 81
            QFAnew([ 7  8 15 16 23 24],1)            = QFA([ 7  8 15 16 23 24])            .* QFAgoal(2) / QFAloco(2);
        else
            QFAnew([ 7  8],1)            = QFA([ 7  8])            .* QFAgoal(2) / QFAloco(2);
            QFAnew([15 16],1)            = QFA([15 16])            .* QFAgoal(3) / QFAloco(3);
            QFAnew([23 24],1)            = QFA([23 24])            .* QFAgoal(4) / QFAloco(4);
        end
        
        if ModeNumber == 5
            % Adjust each family to keep the mean constant
            QFnew  = QFnew  * mean(QF)  / mean(QFnew);
            QDnew  = QDnew  * mean(QD)  / mean(QDnew);
            QDAnew = QDAnew * mean(QDA) / mean(QDAnew);
            QFAnew = QFAnew * mean(QFA) / mean(QFAnew);
        end


        if any(SF~=getsp(LocoMeasData.MachineConfig.SF.Setpoint, 'numeric'))
            fprintf('   Warning: SF magnet setpoint is not the same as when the LOCO data set was taken.\n');
        end
        if any(SD~=getsp(LocoMeasData.MachineConfig.SD.Setpoint, 'numeric'))
            fprintf('   Warning: SD magnet setpoint is not the same as when the LOCO data set was taken.\n');
        end
        %setsp('SF', SF, [], 0);
        %setsp('SD', SD, [], 0);

        if any(BEND~=getsp('BEND'))
            fprintf('   Warning: BEND magnet setpoints are not the same as when the LOCO data set was taken.\n');
        end


        % plot results of comparison with nominal lattice
        subfig(1,2,1);
        subplot(4,1,1);
        bar(QF./QFnew-1);
        xaxis([.5 24.5]);
        title(sprintf('k(QF) = %6.4f, k(QF_{4,8,12}) = %6.4f',mean(QFnew([1:6 9:14 17:22])), mean(QFnew([7:8 15:16 23:24]))));
        grid on;
        ylabel('\DeltaQF/QF_{nominal}');
        %title('Change in Quadrupole Strength');

        subplot(4,1,2);
        bar(QD./QDnew-1);
        xaxis([.5 24.5]);
        title(sprintf('k(QD) = %6.4f, k(QD_{4,8,12}) = %6.4f',mean(QDnew([1:6 9:14 17:22])), mean(QDnew([7:8 15:16 23:24]))));
        grid on
        ylabel('\DeltaQD/QD_{nominal}');

        subplot(4,1,3);
        bar([7:8 15:16 23:24],QDA./QDAnew-1);
        %xaxis([0 25])
        title(sprintf('k(QDA) = %6.4f',mean(QDAnew)));
        grid on
        ylabel('\DeltaQDA./QDA_{nominal}');

        subplot(4,1,4);
       % QFA
       % QFAnew
        bar([1 7 15 23], QFA([1 7 15 23])./QFAnew([1 7 15 23])-1);
        %axis([0 5 -0.015 0.015]);
        title(sprintf('k(QFA) = %6.4f, k(QFA_{4,8,12}) = %6.4f, k(BEND) = %6.4f',QFA(1), mean(QFA([7:8 15:16 23:24])),mean(BEND)));
        grid on;
        ylabel('\DeltaQFA/QFA_{nominal}');
        orient tall;

        % figure
        % subplot(2,1,1)
        % bar(BPMx/mean(BPMx) - 1)
        % yaxis([-0.5 0.5]);
        % grid on
        % title('Relative Horizontal BPM Gains')
        %
        % subplot(2,1,2)
        % bar(BPMy/mean(BPMy) - 1)
        % yaxis([-0.5 0.5]);
        % grid on
        % title('Relative Vertical BPM Gains')
        %
        % figure
        % subplot(2,1,1)
        % bar(HKick')
        % grid on
        % title('Horizontal Corrector Kicks')
        %
        % subplot(2,1,2)
        % bar(VKick')
        % grid on
        % title('Vertical Corrector Kicks')


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the setpoint change %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CorrFlag = questdlg(str2mat('Do you want to set corrected quadrupole values?'),sprintf('%.1f GeV symmetry correction',getenergy),'Yes','No','No');
        if strcmp(CorrFlag,'Yes')
            fprintf('   Applying corrected quadrupole settings!\n');
            setsp('QF',  QFnew,  [], 0);
            setsp('QD',  QDnew,  [], 0);
            setsp('QFA', QFAnew, [], 0);
            setsp('QDA', QDAnew, [], 0);

            % Make the setpoint change in steps
            %N = 5;
            %for i = 1:N
            %    setsp('QF',  QF  - (i/N) * (QF  - QFnew) , [], 0);
            %    setsp('QD',  QD  - (i/N) * (QD  - QDnew) , [], 0);
            %    setsp('QFA', QFA - (i/N) * (QFA - QFAnew), [], 0);
            %    setsp('QDA', QDA - (i/N) * (QDA - QDAnew), [], 0);
            %    % Correct the orbit
            %    % setorbit({x.Data, y.Data}, {x,y}, {hcm,vcm}, 1, 1e-2);
            %    % pause(1);
            %end
        else
            % Restore the old AT model
            THERING = THERINGsave;
            fprintf('   Magnet lattice not changed.\n');
            return;
        end


        CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCODATA(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
        if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
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

        % Restore the old AT model
        THERING = THERINGsave;



    case 'correctcoupling'

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


        [Total, Wave, Bump, Factor_Wave, Factor_Bump, LatticeFlag] = calcdispersionwave('Physics');

        % Load the LOCO data
        load(FileName);

        fprintf('   Correcting the coupling based on LOCO file %s.\n', FileName);
        fprintf('   It is assumed that the SQSF are in FitParameters.Values(60:70)\n');
        fprintf('                      and SQSD are in FitParameters.Values(71:83)\n');

        % Find the skew quadrupole fits
        if length(FitParameters(end).Values) < 81
            error('Did not find the skew quads fit parameters.');
        elseif length(FitParameters(end).Values) > 83
            fprintf('   There are more than 83 fit parameters, hopefully the skew quads fits are still 60:83\n');
            fprintf('   If all 24 skew quadrupoles were fit this function will fail!\n');

            %sflist = [1 5 6 9 10 11 12 13 14 17 21];
            %sdlist = [3 5 6 7  9 10 11 12 13 14 15 19 23];
            %SQSF = FitParameters(end).Values(60:83);
            %SQSD = FitParameters(end).Values(84:107);
            %SQSF = SQSF(sflist);
            %SQSD = SQSD(sdlist);
        end

        % Starting setpoints
        SQSF00 = getsp('SQSF','Struct');
        SQSD00 = getsp('SQSD','Struct');
        SQSHF00 = getsp('SQSHF','Struct');

        if length(FitParameters(end).Values) == 81
            SQSFcoupling = FitParameters(end).Values(58:68);
            SQSDcoupling = FitParameters(end).Values(69:81);
            SQSHFcoupling = zeros(size(SQSHF00.Data));
        elseif length(FitParameters(end).Values) == 82
            SQSFcoupling = FitParameters(end).Values(59:69);
            SQSDcoupling = FitParameters(end).Values(70:82);
            SQSHFcoupling = zeros(size(SQSHF00.Data));
        elseif length(FitParameters(end).Values) ==103
            SQSFcoupling = [0;FitParameters(end).Values(59:68)];
            SQSDcoupling = FitParameters(end).Values(69:81);
            SQSHFcoupling = [ FitParameters(end).Values(102);FitParameters(end).Values(82:101);FitParameters(end).Values(103)];
        elseif length(FitParameters(end).Values) ==104
            SQSFcoupling = FitParameters(end).Values(59:69);
            SQSDcoupling = FitParameters(end).Values(70:82);
            SQSHFcoupling = [ FitParameters(end).Values(103);FitParameters(end).Values(83:102);FitParameters(end).Values(104)];
        else
            SQSFcoupling = FitParameters(end).Values(60:70);
            SQSDcoupling = FitParameters(end).Values(71:83);
            SQSHFcoupling = zeros(size(SQSHF00.Data));
        end


        % Combine the coupling correction with the eta wave and bump
        SQSF = Wave(1);  % Just for fields
        SQSF.Data = -1*SQSFcoupling + Wave(1).Data + Bump(1).Data;
        SQSD = Wave(2);  % Just for fields
        SQSD.Data = -1*SQSDcoupling + Wave(2).Data + Bump(2).Data;
        SQSHF = Wave(3);  % Just for fields
        SQSHF.Data = -1*SQSHFcoupling + Wave(3).Data + Bump(3).Data;

        SQSFhw = physics2hw(SQSF);
        SQSDhw = physics2hw(SQSD);
        SQSHFhw = physics2hw(SQSHF);

        % Add the starting point for the skew quadrupoles when the LOCO data was measured
        MachineConfig = LocoMeasData.MachineConfig;
        SQSFhw0 = physics2hw(MachineConfig.SQSF.Setpoint);  % Probably alread in hardware units
        SQSDhw0 = physics2hw(MachineConfig.SQSD.Setpoint);  % Probably alread in hardware units
        SQSHFhw0 = physics2hw(MachineConfig.SQSHF.Setpoint);  % Probably alread in hardware units

        SQSFhwTotal = SQSFhw0; % Just for fields
        SQSDhwTotal = SQSDhw0; % Just for fields
        SQSHFhwTotal = SQSHFhw0; % Just for fields
        SQSFhwTotal.Data = SQSFhw.Data + SQSFhw0.Data;
        SQSDhwTotal.Data = SQSDhw.Data + SQSDhw0.Data;
        SQSHFhwTotal.Data = SQSHFhw.Data + SQSHFhw0.Data;

        % Convert to hardware units for viewing
        Wavehw = physics2hw(Wave);
        Bumphw = physics2hw(Bump);
        SQSFCoupling = SQSFhw.Data - Wavehw(1).Data - Bumphw(1).Data;
        SQSDCoupling = SQSDhw.Data - Wavehw(2).Data - Bumphw(2).Data;
        SQSHFCoupling = SQSHFhw.Data - Wavehw(3).Data - Bumphw(3).Data;

        % Plot
        clf reset
        subplot(3,1,1);
        plot([-1*SQSFCoupling, Wavehw(1).Data, Bumphw(1).Data, Wavehw(1).Data+Bumphw(1).Data, SQSFhw.Data, SQSFhwTotal.Data], '.-');
        hold on;
        plot( maxsp('SQSF'), '.-k');
        plot(-maxsp('SQSF'), '.-k');
        hold off;
        xlabel('SQSF Number');
        ylabel('SQSF [Amps]');
        title(sprintf('Coupling Fit, Eta Wave (%.2f), and Eta Bump (%.2f)', Factor_Wave, Factor_Bump));
        axis tight;
        yaxis([-21 21]);

        subplot(3,1,2);
        plot([-1*SQSDCoupling, Wavehw(2).Data, Bumphw(2).Data, Wavehw(2).Data+Bumphw(2).Data, SQSDhw.Data, SQSDhwTotal.Data], '.-');
        hold on;
        plot( maxsp('SQSD'), '.-k');
        plot(-maxsp('SQSD'), '.-k');
        hold off;
        xlabel('SQSD Number');
        ylabel('SQSD [Amps]');
        axis tight
        yaxis([-21 21]);

        subplot(3,1,3);
        plot([-1*SQSHFCoupling, Wavehw(3).Data, Bumphw(3).Data, Wavehw(3).Data+Bumphw(3).Data, SQSHFhw.Data, SQSHFhwTotal.Data], '.-');
        hold on;
        plot( maxsp('SQSHF'), '.-k');
        legend('1. Skew Quad Fit', '2. Eta Wave', '3. Eta Bump', '4. Eta Wave + Eta Bump', '5. \Delta Skew (-1+2+3)', '6. New Setpoints', '7. Maximum Setpoint', 0);
        plot(-maxsp('SQSHF'), '.-k');
        hold off;
        xlabel('SQSHF Number');
        ylabel('SQSHF [Amps]');
        axis tight;
        yaxis([-50 50]);
        
        % Maximum setpoint check
        if any(abs(SQSFhwTotal.Data)>maxsp('SQSF'))
            error('At least one of the SQSF would go beyond it''s limit ... aborting');
        end

        if any(abs(SQSDhwTotal.Data)>maxsp('SQSD'))
            error('At least one of the SQSD would go beyond it''s limit ... aborting');
        end

        if any(abs(SQSHFhwTotal.Data)>maxsp('SQSHF'))
            error('At least one of the SQSHF would go beyond it''s limit ... aborting');
        end
        
        % Make the setpoint change
        CorrFlag = questdlg(str2mat('Do you want to set skew correction?'),sprintf('%.1f GeV Coupling Correction',getenergy),'Yes','No','No');
        if strcmp(CorrFlag,'No')
            disp('   No skew correction made.');
        else
            disp('   Setting SQSF & SQSD families.');
            setpv(SQSFhwTotal);
            setpv(SQSDhwTotal);
            setpv(SQSHFhwTotal);

            % Keep the change?
            CorrectFlag = questdlg('Keep the new skew quadrupole setpoints or return to the old values?','SETLOCODATA(''SetCoupling'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
            if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
                fprintf('   Changing the skew quadrupole magnets back to the original setpoints.\n');
                setpv(SQSF00);
                setpv(SQSD00);
                setpv(SQSHF00);
            end
        end

    otherwise
        error('   SETLOCODATA command not known.');
end

