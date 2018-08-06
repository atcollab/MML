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
    ModeCell = {'Nominal - Set Gain=1 & Rolls=0 in the model', 'SetGains - Set gains/rolls from a LOCO file','Symmetrize - Symmetry correction of the lattice', 'CorrectCoupling - Coupling correction of the lattice', 'SetModel - Set the model from a LOCO file','LOCO2Model - Set the model from a LOCO file (also does a SetGains)', 'See "help setlocodata" for more details'};
    [ModeNumber, OKFlag] = listdlg('Name','PLS','PromptString', ...
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


% Device list
BPMxDeviceList = family2dev('BPMx');
BPMxDeviceListTotal = family2dev('BPMx',0);

BPMyDeviceList = family2dev('BPMy');
BPMyDeviceListTotal = family2dev('BPMy',0);

HCMDeviceList = family2dev('HCM');
HCMDeviceListTotal = family2dev('HCM',0);
VCMDeviceList = family2dev('VCM');
VCMDeviceListTotal = family2dev('VCM',0);


if any(strcmpi(CommandInput, 'Nominal'))
    fprintf('   Using nominal BPM and corrector gains (1) and rolls (0).\n');

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;

    % Zero or one the gains and rolls
    AO.BPMx.Gain = ones(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Gain = ones(size(BPMyDeviceListTotal,1),1);
    AO.BPMx.Roll = zeros(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Roll = zeros(size(BPMyDeviceListTotal,1),1);
    AO.BPMx.Crunch = zeros(size(BPMxDeviceListTotal,1),1);
    AO.BPMy.Crunch = zeros(size(BPMyDeviceListTotal,1),1);

    AO.HCM.Gain = ones(size(HCMDeviceListTotal,1),1);
    AO.VCM.Gain = ones(size(VCMDeviceListTotal,1),1);
    AO.HCM.Roll = zeros(size(HCMDeviceListTotal,1),1);
    AO.VCM.Roll = zeros(size(VCMDeviceListTotal,1),1);

    % Magnet gains set to unity (rolls are set in the AT model)
    AO.QF1.Gain = ones(size(family2dev('QF1',0),1),1);
    AO.QD1.Gain = ones(size(family2dev('QD1',0),1),1);
    AO.QF2.Gain = ones(size(family2dev('QF2',0),1),1);
    AO.QD2.Gain = ones(size(family2dev('QD2',0),1),1);
    AO.SF.Gain = ones(size(family2dev('SF',0),1),1);
    AO.SD.Gain = ones(size(family2dev('SD',0),1),1);


    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield('BPMx', 'GCR', [AO.BPMx.Gain AO.BPMy.Gain AO.BPMx.Crunch AO.BPMx.Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield('HCM', 'Roll', 0*AO.HCM.Roll, HCMDeviceListTotal, 1, 2);
    setatfield('VCM', 'Roll', 0*AO.VCM.Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield('HCM', 'Roll', AO.HCM.Roll, HCMDeviceListTotal, 1, 1);
    setatfield('VCM', 'Roll', AO.VCM.Roll, VCMDeviceListTotal, 1, 2);

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetGains'))
    
    % Set the model gains
    setlocodata('Nominal');

    AO = getao;


    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
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
    BPMxDeviceList = LocoMeasData.HBPM.DeviceList;
    BPMyDeviceList = LocoMeasData.VBPM.DeviceList;
    HCMDeviceList  = LocoMeasData.HCM.DeviceList;
    VCMDeviceList  = LocoMeasData.VCM.DeviceList;


    % Should get the device list from the LOCO file???
    RemoveBPMDeviceList = [];
    i = findrowindex(RemoveBPMDeviceList, BPMyDeviceList);
    BPMxDeviceList(i,:) = [];
    BPMyDeviceList(i,:) = [];


    % Get the full list
    i = findrowindex(BPMxDeviceList, BPMxDeviceListTotal);
    Xgain = getgain('BPMx', BPMxDeviceListTotal);
    Ygain = getgain('BPMy', BPMyDeviceListTotal);

    % Change to Gain, Roll, Crunch system
    for j = 1:length(BPMData(end).HBPMGain)
        MLOCO = [BPMData(end).HBPMGain(j)     BPMData(end).HBPMCoupling(j)
            BPMData(end).VBPMCoupling(j) BPMData(end).VBPMGain(j) ];

        [AO.BPMx.Gain(i(j),:), AO.BPMy.Gain(i(j),:), AO.BPMx.Crunch(i(j),:), AO.BPMx.Roll(i(j),:)] = loco2gcr(MLOCO);
    end
    AO.BPMy.Roll   = AO.BPMx.Roll;
    AO.BPMy.Crunch = AO.BPMx.Crunch;


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

    HCMGainOldLOCO = LocoMeasData.HCMGain .* cos(LocoMeasData.HCMRoll);

    HCMGainLOCO     = HCMGainOldLOCO .* CMData(end).HCMKicks ./ CMData(1).HCMKicks;
    HCMCouplingLOCO = CMData(end).HCMCoupling;

    %AO.HCM.Roll(i) = atan2(-HCMCouplingLOCO, HCMGainLOCO);
    AO.HCM.Roll(i) = atan(HCMCouplingLOCO ./ abs(HCMGainLOCO));
    AO.HCM.Gain(i) = sign(HCMGainLOCO) .* sqrt(HCMCouplingLOCO.^2 + HCMGainLOCO.^2);


    % VCM
    i = findrowindex(VCMDeviceList, VCMDeviceListTotal);

    VCMGainOldLOCO = LocoMeasData.VCMGain .* cos(LocoMeasData.VCMRoll);

    VCMGainLOCO     = VCMGainOldLOCO .* CMData(end).VCMKicks ./ CMData(1).VCMKicks;
    VCMCouplingLOCO = CMData(end).VCMCoupling;

    %AO.VCM.Roll(i) = atan2(-VCMCouplingLOCO, VCMGainLOCO);
    AO.VCM.Roll(i) = atan(-VCMCouplingLOCO ./ abs(VCMGainLOCO));
    AO.VCM.Gain(i) = sign(VCMGainLOCO) .* sqrt(VCMCouplingLOCO.^2 + VCMGainLOCO.^2);
   
    % Set the roll, crunch to the AT model to be used by getpvmodel, setpvmodel, etc
    setatfield('BPMx', 'GCR', [AO.BPMx.Gain AO.BPMy.Gain AO.BPMx.Crunch AO.BPMx.Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield('HCM', 'Roll', 0*AO.HCM.Roll, HCMDeviceListTotal, 1, 2);
    setatfield('VCM', 'Roll', 0*AO.VCM.Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield('HCM', 'Roll', AO.HCM.Roll, HCMDeviceListTotal, 1, 1);
    setatfield('VCM', 'Roll', AO.VCM.Roll, VCMDeviceListTotal, 1, 2);


    % Should set the magnet rolls in the AT model???

    setao(AO);


elseif any(strcmpi(CommandInput, 'SetModel'))

    % Some LOCO errors are applied to the accelerator 'SetMachine' and some
    % go to the model.  If errors detected by LOCO are not applied to the accelerator,
    % then include them in the AT and Middle Layer model.

    % The assumption is that setlocodata('SetMachine') has already been run.
    % So quads and skew quads have been changed in the accelerator to match
    % the LOCO run.

    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
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

    fprintf('   Setting AT model BEND, SF, and SD.\n');

    % Set normal bend K-value
    BENDfit = FitParameters(end).Values(49:66);
    BENDDeviceList = family2dev('BEND');
%     iIndex = findrowindex([4 2;8 2;12 2], BENDDeviceList);
%     BENDDeviceList(iIndex,:) = [];
    setpvmodel('BEND', 'K', BENDfit, BENDDeviceList);


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


elseif any(strcmpi(CommandInput, 'CorrectCoupling'))

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
    
    if length(FitParameters(end).Values) > 66
        Skewfit  = FitParameters(end).Values(67:78);
        Skewfit0 = FitParameters(1).Values(67:78);
    else
        error('No skew quad fit parameters found');
    end

    % Make sure the starting point for the skew quadrupoles is the same 
    % as when the LOCO data was taken. 
%     MachineConfig = LocoMeasData.MachineConfig;
%     setpv(MachineConfig.SkewQuad.Setpoint);
%     setpv(MachineConfig.SkewQuad.Setpoint);

    % Apply the negative of the fit in hardware units
    SkewQuadhw = physics2hw('SkewQuad', 'Setpoint', -Skewfit);

    stepsp('SkewQuad', SkewQuadhw);


elseif any(strcmpi(CommandInput, 'Symmetrize'))

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


    %%%%%%%%%%%%%%%%%%%%%%
    % Use the Loco Model %
    %%%%%%%%%%%%%%%%%%%%%%

    % If errors detected by this LOCO file are not applied to the accelerator,
    % ie, the machine lattice file is the same as it was when the LOCO data was
    % taken, then put the LOCO output settings in the model.

    fprintf('   Symmetrizing the lattice based on LOCO file %s.\n', FileName);

    % Magnet fits
    QF1fit = FitParameters(end).Values( 1:12);
    QD1fit = FitParameters(end).Values(13:24);
    QF2fit = FitParameters(end).Values(25:36);
    QD2fit = FitParameters(end).Values(37:48);
%     SFfit = FitParameters(end).Values(67);
%     SDfit = FitParameters(end).Values(68);

    QF1fit0 = FitParameters(1).Values( 1:12);
    QD1fit0 = FitParameters(1).Values(13:24);
    QF2fit0 = FitParameters(1).Values(25:36);
    QD2fit0 = FitParameters(1).Values(37:48);
%     SFfit0 = FitParameters(1).Values(67);
%     SDfit0 = FitParameters(1).Values(68);

%     if length(FitParameters(end).Values) > 39
%         Skewfit  = FitParameters(end).Values(40:43);
%         Skewfit0 = FitParameters(1).Values(40:43);
%     end

    % Lattice magnets at the start of the LOCO run
    QF1 = LocoMeasData.MachineConfig.QF1.Setpoint.Data;
    QD1 = LocoMeasData.MachineConfig.QD1.Setpoint.Data;
    QF2 = LocoMeasData.MachineConfig.QF2.Setpoint.Data;
    QD2 = LocoMeasData.MachineConfig.QD2.Setpoint.Data;
%     SF = LocoMeasData.MachineConfig.SF.Setpoint.Data;
%     SD = LocoMeasData.MachineConfig.SD.Setpoint.Data;

    % Save the old setpoints
    QF1old = getsp('QF1');
    QD1old = getsp('QD1');
    QF2old = getsp('QF2');
    QD2old = getsp('QD2');
%     SFold = getsp('SF');
%     SDold = getsp('SD');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make the setpoint change %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    QF1new = QF1  .* QF1fit0 ./ QF1fit;
    QD1new = QD1  .* QD1fit0 ./ QD1fit;
    QF2new = QF2  .* QF2fit0 ./ QF2fit;
    QD2new = QD2  .* QD2fit0 ./ QD2fit;
%     SFnew = SF  .* SFfit0 ./ SFfit;
%     SDnew = SD  .* SDfit0 ./ SDfit;

    setsp('QF1',  QF1new, [], 0);
    setsp('QD1',  QD1new, [], 0);
    setsp('QF2',  QF2new, [], 0);
    setsp('QD2',  QD2new, [], 0);
%     setsp('SF',  SFnew, [], 0);
%     setsp('SD',  SDnew, [], 0);

    CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCOGAINS(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
        fprintf('\n');
        % Make the setpoint change
        fprintf('   Changing the lattice magnets back to the original setpoints.\n');
        setsp('QF1',  QF1old, [], 0);
        setsp('QD1',  QD1old, [], 0);
        setsp('QF2',  QF2old, [], 0);
        setsp('QD2',  QD2old, [], 0);
%         setsp('SF',  SFold, [], 0);
%         setsp('SD',  SDold, [], 0);
    else
        % Set the model gains ???
        setlocodata('SetGains', FileName);
    end

else

    error('   Command not known.');

end
