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
%     'EtaWave'    - Set a dispersion wave.
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
    [ModeNumber, OKFlag] = listdlg('Name','Soleil','PromptString', ...
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
    fprintf('   Using nominal BPM and corrector Gain=1 and Roll=0\n');

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

    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if isequal(FileName,0) || isequal(DirectoryName,0)
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

    error('   Function not complete.  Look at the ALS setlocodata for an example.');

elseif any(strcmpi(CommandInput, 'SetMachine'))

    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if isequal(FileName,0) || isequal(DirectoryName,0)
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    % Load the LOCO data
    load(FileName);


    
    error('You need to edit here with your parameter setting program!')
    
    le = length(FitParameters);
    
    QFscale(1:6) = FitParameters(1).Values(1)/FitParameters(le).Values(1);
    QFscale(7:28) = FitParameters(1).Values(2:23)./FitParameters(le).Values(2:23);
    QDscale(1:6) = FitParameters(1).Values(24)/FitParameters(le).Values(24);
    QDscale(7:28) = FitParameters(1).Values(25:46)./FitParameters(le).Values(25:46);
    QFCscale = FitParameters(1).Values(47)/FitParameters(le).Values(47);
    QDXscale = FitParameters(1).Values(48)/FitParameters(le).Values(48);
    QFXscale = FitParameters(1).Values(49)/FitParameters(le).Values(49);
    QDYscale = FitParameters(1).Values(50)/FitParameters(le).Values(50);
    QFYscale = FitParameters(1).Values(51)/FitParameters(le).Values(51);
    QDZscale = FitParameters(1).Values(52)/FitParameters(le).Values(52);
    QFZscale = FitParameters(1).Values(53)/FitParameters(le).Values(53);

    QFnew  = QFscale'.*getsp('QF');  % I would base it on the LOCO data setpoint!!!
    QDnew  = QDscale'.*getsp('QD');
    QFCnew = QFCscale*getsp('QFC');
    QDXnew = QDXscale*getsp('QDX');
    QFXnew = QFXscale*getsp('QFX');
    QDYnew = QDYscale*getsp('QDY');
    QFYnew = QFYscale*getsp('QFY');
    QDZnew = QDZscale*getsp('QDZ');
    QFZnew = QFZscale*getsp('QFZ');


    setsp('QF', QFnew);
    setsp('QD', QDnew);
    setsp('QFC', QFCnew);

    setsp('QFX', QFXnew);
    setsp('QFY', QFYnew);
    setsp('QFZ', QFZnew);

    setsp('QDX', QDXnew);
    setsp('QDY', QDYnew);
    setsp('QDZ', QDZnew);


elseif any(strcmpi(CommandInput, 'CorrectCoupling'))

    if isempty(FileName) || strcmp(FileName, '.')
        if isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        else
            [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
        end
        drawnow;
        if isequal(FileName,0) || isequal(DirectoryName,0)
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end

    
    % Load the LOCO data
    load(FileName);

    NQT = size(family2dev('QT'),1); 
    fprintf('   Correcting the coupling based on LOCO file %s.\n', FileName);
    fprintf('   It is assumed that the QT are in FitParameters.Values(end-%d:end)\n', NQT-1);

    QT = FitParameters(end).Values(end-(NQT-1):end);

    % Starting point for the skew quadrupoles when LOCO data was measured
    MachineConfig = LocoMeasData.MachineConfig;
    setpv(MachineConfig.QT.Setpoint);

    QThw = physics2hw('QT', 'Setpoint', -QT);

    % Maximum setpoint check
    if any(abs(MachineConfig.QT.Setpoint.Data+QThw)>maxsp('QT'))
        error('At least one of the QT would go beyond it''s limit ... aborting coupling correction');
    end

    % Make the setpoint change
    stepsp('QT', QThw);

    % Keep the change?
    CorrectFlag = questdlg('Keep the new skew quadrupole setpoints or return to the old values?','SETLOCOGAINS(''CorrectCoupling'')','Keep this lattice','Restore Old Lattice','Keep this lattice');
    if strcmpi(CorrectFlag, 'Restore Old Lattice') || isempty(CorrectFlag)
        fprintf('   Changing the skew quadrupole magnets back to the original setpoints.\n');
        stepsp('QT', QThw);
    end


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
        if isequal(FileName,0) || isequal(DirectoryName,0)
            fprintf('   setlocodata canceled\n');
            return
        end
        FileName = [DirectoryName FileName];
    end


    % Load the LOCO data
    load(FileName);


    % Use loco file for the lattice and the fit parameter
    % Using everything in the loco lattice may not be what you want!
    global THERING
    %RINGData.Lattice = THERING;
    for i = 1:length(FitParameters(end).Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters(end).Params{i}, FitParameters(end).Values(i));
    end
    THERING = RINGData.Lattice;


    % Since the lattice may have changed
    %updateatindex;


    % Set the model gains (this added GCR field to lattice)
    setlocodata('SetGains', FileName);

else

    error('   ');

end
