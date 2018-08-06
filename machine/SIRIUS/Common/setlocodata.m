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

BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;
HCMFamily = gethcmfamily; 
VCMFamily = getvcmfamily; 

% Device list
BPMxDeviceList = family2dev(BPMxFamily);
BPMxDeviceListTotal = family2dev(BPMxFamily,0);

BPMyDeviceList = family2dev(BPMyFamily);
BPMyDeviceListTotal = family2dev(BPMyFamily,0);

HCMDeviceList = family2dev(HCMFamily);
HCMDeviceListTotal = family2dev(HCMFamily,0);
VCMDeviceList = family2dev(VCMFamily);
VCMDeviceListTotal = family2dev(VCMFamily,0);


if any(strcmpi(CommandInput, 'Nominal'))
    fprintf('   Using nominal BPM and corrector gains (1) and rolls (0).\n');

    % To speed things up, put Gains/Rolls/etc in the AO
    AO = getao;

    % Zero or one the gains and rolls
    AO.(BPMxFamily).Gain = ones(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Gain = ones(size(BPMyDeviceListTotal,1),1);
    AO.(BPMxFamily).Roll = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Roll = zeros(size(BPMyDeviceListTotal,1),1);
    AO.(BPMxFamily).Crunch = zeros(size(BPMxDeviceListTotal,1),1);
    AO.(BPMyFamily).Crunch = zeros(size(BPMyDeviceListTotal,1),1);

    AO.(HCMFamily).Gain = ones(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Gain = ones(size(VCMDeviceListTotal,1),1);
    AO.(HCMFamily).Roll = zeros(size(HCMDeviceListTotal,1),1);
    AO.(VCMFamily).Roll = zeros(size(VCMDeviceListTotal,1),1);

    % Magnet gains set to unity (rolls are set in the AT model)
    mlist = findmemberof('QUAD');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        AO.(FName).Gain = ones(size(family2dev(FName,0),1),1);
    end
    mlist = findmemberof('SEXT');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        AO.(FName).Gain = ones(size(family2dev(FName,0),1),1);
    end
    %AO.QF.Gain = ones(size(family2dev('QF',0),1),1);
    %AO.QD.Gain = ones(size(family2dev('QD',0),1),1);
    %AO.QFC.Gain = ones(size(family2dev('QFC',0),1),1);
    %AO.SF.Gain = ones(size(family2dev('SF',0),1),1);
    %AO.SD.Gain = ones(size(family2dev('SD',0),1),1);


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
    % RemoveBPMDeviceList = [3 11; 3 12; 10 11; 10 12];
    RemoveBPMDeviceList = [];
    i = findrowindex(RemoveBPMDeviceList, BPMyDeviceList);
    BPMxDeviceList(i,:) = [];
    BPMyDeviceList(i,:) = [];


    % Get the full list
    i = findrowindex(BPMxDeviceList, BPMxDeviceListTotal);
    Xgain = getgain(BPMxFamily, BPMxDeviceListTotal);
    Ygain = getgain(BPMyFamily, BPMyDeviceListTotal);

    % Change to Gain, Roll, Crunch system
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
    setatfield(BPMxFamily, 'GCR', [AO.(BPMxFamily).Gain AO.(BPMyFamily).Gain AO.(BPMxFamily).Crunch AO.(BPMxFamily).Roll], BPMxDeviceListTotal);

    % Set the gains to the AT model to be used by getpvmodel, setpvmodel, etc
    % Make sure the Roll field is 1x2 even for single plane correctors

    % First set the cross planes to zero
    setatfield(HCMFamily, 'Roll', 0*AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 2);
    setatfield(VCMFamily, 'Roll', 0*AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 1);

    % Then set the roll field
    setatfield(HCMFamily, 'Roll', AO.(HCMFamily).Roll, HCMDeviceListTotal, 1, 1);
    setatfield(VCMFamily, 'Roll', AO.(VCMFamily).Roll, VCMDeviceListTotal, 1, 2);


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

    RINGData.Lattice = THERING;
    for i = 1:length(FitParameters(end).Params)
       RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
    end
    THERING = RINGData.Lattice;

elseif any(strcmpi(CommandInput, 'LOCO2Model'))



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
    
    if length(FitParameters(end).Values) > 39
        Skewfit  = FitParameters(end).Values(40:43);
        Skewfit0 = FitParameters(1).Values(40:43);
    else
        error('No skew quad fit parameters found');
    end

    % Make sure the starting point for the skew quadrupoles is the same 
    % as when the LOCO data was taken. 
%     MachineConfig = LocoMeasData.MachineConfig;
%     setpv(MachineConfig.SkewQuad.Setpoint);
%     setpv(MachineConfig.SkewQuad.Setpoint);

    % Apply the negative of the fit in hardware units
    SkewQuadFamily = findmemberof('SkewQuad');
    SkewQuadhw = physics2hw(SkewQuadFamily, 'Setpoint', -Skewfit);

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

    % Note: I'm ignoring the k-value of the BEND here.  If you want to include it send me a email.
    
    % Magnet fits
    QUADFit  = FitParameters(end).Values;
    QUADFit0 = FitParameters(1).Values;
    
    % Lattice magnets at the start of the LOCO run
    QUAD = [];
    mlist = findmemberof('QUAD');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        QUAD = [QUAD; LocoMeasData.MachineConfig.(FName).Setpoint.Data];
    end
    SEXT = [];
    mlist = findmemberof('SEXT');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        SEXT = [SEXT; LocoMeasData.MachineConfig.(FName).Setpoint.Data];
    end
    
    % Save the old setpoints
    QUADOld = [];
    mlist = findmemberof('QUAD');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        QUADOld = [QUADOld; getsp(FName)];
    end 
    SEXTOld = [];
    mlist = findmemberof('SEXT');
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        SEXTOld = [SEXTOld; getsp(FName)];
    end 

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make the setpoint change %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    QUADNew = QUAD .* QUADFit0 ./ QUADFit;
    
    mlist = findmemberof('QUAD');
    idx = 1;
    for i=1:size(mlist,1)
        FName = char(mlist(i,:));
        data_size = length(LocoMeasData.MachineConfig.(FName).Setpoint.Data);
        setsp(FName, QUADNew(idx:(idx+data_size-1)));
        idx = idx + data_size;
    end 
       
    CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCOGAINS(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
        fprintf('\n');
        % Make the setpoint change
        fprintf('   Changing the lattice magnets back to the original setpoints.\n');
        mlist = findmemberof('QUAD');
        idx = 1;
        for i=1:size(mlist,1)
            FName = char(mlist(i,:));
            data_size = length(LocoMeasData.MachineConfig.(FName).Setpoint.Data);
            setsp(FName, QUADOld(idx:(idx+data_size-1)));
            idx = idx + data_size;
        end 
    else
        % Set the model gains ???
        setlocodata('SetGains', FileName);
    end
    
  
    
    %{
    % Magnet fits
    QFfit  = FitParameters(end).Values( 1:24);
    QDfit  = FitParameters(end).Values(25:48);
    QFCfit = FitParameters(end).Values(49:72);

    QFfit0  = FitParameters(1).Values( 1:24);
    QDfit0  = FitParameters(1).Values(25:48);
    QFCfit0 = FitParameters(1).Values(49:72);

    % Lattice magnets at the start of the LOCO run
    QF  = LocoMeasData.MachineConfig.QF.Setpoint.Data;
    QD  = LocoMeasData.MachineConfig.QD.Setpoint.Data;
    QFC = LocoMeasData.MachineConfig.QFC.Setpoint.Data;
    SF  = LocoMeasData.MachineConfig.SF.Setpoint.Data;
    SD  = LocoMeasData.MachineConfig.SD.Setpoint.Data;

    % Save the old setpoints
    QFold  = getsp('QF');
    QDold  = getsp('QD');
    QFCold = getsp('QFC');
    SFold  = getsp('SF');
    SDold  = getsp('SD');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make the setpoint change %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    QFnew  = QF  .* QFfit0  ./ QFfit;
    QDnew  = QD  .* QDfit0  ./ QDfit;
    QFCnew = QFC .* QFCfit0 ./ QFCfit;

    setsp('QF',  QFnew,  [], 0);
    setsp('QD',  QDnew,  [], 0);
    setsp('QFC', QFCnew, [], 0);

    CorrectFlag = questdlg('Keep the new setpoints or return to the old lattice?','SETLOCOGAINS(''SetMachine'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
        fprintf('\n');
        % Make the setpoint change
        fprintf('   Changing the lattice magnets back to the original setpoints.\n');
        setsp('QF',  QFold,  [], 0);
        setsp('QD',  QDold,  [], 0);
        setsp('QFC', QFCold, [], 0);
    else
        % Set the model gains ???
        setlocodata('SetGains', FileName);
    end
    
    %}
    

else

    error('   Command not known.');

end
