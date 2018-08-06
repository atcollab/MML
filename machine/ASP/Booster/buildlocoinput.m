function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(OutputFileName)
%BUILDLOCOINPUT - Combines response matrix, BPM standard deviation, and 
%                 dispersion files (or measurements) into a LOCO input file
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(OutputFileName)
%
%  Written by Greg Portmann


% % In order to iterate loco uses arrays of structures all the fields in the structure must be present
% LocoFlags = struct('SVmethod',[], 'Dispersion',[], 'Coupling',[], 'Normalize',[], 'Linear',[], 'SVDDataFileName',[]);
% LocoModel = struct('M',[], 'OutlierIndex',[], 'Eta',[], 'EtaOutlierIndex',[], 'SValues',[], 'SValuesIndex',[], 'ChiSquare',[]);
% BPMData = struct('FamName',[], 'BPMIndex',[], 'HBPMIndex',[], 'VBPMIndex',[], 'HBPMGoodDataIndex',[], 'VBPMGoodDataIndex',[], 'HBPMGain',[], 'VBPMGain',[], 'HBPMCoupling',[], 'VBPMCoupling',[], 'HBPMGainSTD',[], 'VBPMGainSTD',[],'HBPMCouplingSTD',[],'VBPMCouplingSTD',[],'FitGains',[],'FitCoupling',[]);
% CMData = struct('FamName',[], 'HCMIndex',[], 'VCMIndex',[], 'HCMGoodDataIndex',[], 'VCMGoodDataIndex',[], 'HCMKicks',[], 'VCMKicks',[], 'HCMCoupling',[], 'VCMCoupling',[], 'HCMKicksSTD',[], 'VCMKicksSTD',[],'HCMCouplingSTD',[],'VCMCouplingSTD',[],'FitKicks',[],'FitCoupling',[]);
% FitParameters = struct('Params',[], 'Values',[], 'ValuesSTD',[], 'Deltas',[], 'DeltaRF',[], 'FitRFFrequency',[], 'DeltaRFSTD',[]);


% BPMs to remove 
RemoveBPMDeviceList = [];


if nargin == 0
    [OutputFileName, DirectoryName] = uiputfile('*.mat', 'New LOCO Output File Name?');
    if OutputFileName == 0
        return
    end
    OutputFileName = [DirectoryName OutputFileName];
end

DirStart = getfamilydata('Directory', 'DataRoot');


% To start with nominal gains (1) and coupling (0)
ButtonName = questdlg('Gains and Coupling?','LOCO STARTING POINT','Use Present Setting','Nominal Gain=1, Coupling=0','Use Present Setting');
switch ButtonName,
    case 'Nominal Gain=1, Coupling=0'
        setlocogains('Nominal');
end


% 0. Clear the LocoModel
LocoModel = [];


% 1. AT MODEL
% An AT model of the accelerator must be available as THERING

% Save AT variables THERING and GLOBVAL so that this function does not change them
global THERING
THERINGsave = THERING;

AO_ATModel = getfamilydata('ATModel');
% ATModel = inputdlg('What AT Model (Cancel to ignor)?','AT MODEL', 1, {AO_ATModel});
[DirectoryName, ATModel, Ext] = fileparts(which(AO_ATModel));
[ATModel, DirectoryName] = uigetfile('*.*', 'AT Model?', [DirectoryName, filesep, ATModel, Ext]);
if ATModel == 0
    return;
else
    run([DirectoryName, ATModel]);

    % Cavity and radiation should be off for response and dispersion generation
    setcavity off;
    setradiation off;

    % Set the model energy
    setenergymodel(getfamilydata('Energy'));

    RINGData.Lattice = THERING;
    RINGData.CavityFrequency  = getrf('Model','Physics'); 
    %RINGData.CavityHarmNumber = 360;
    RINGData.CavityHarmNumber = getfamilydata('HarmonicNumber');
end


% 2. MEASURED DATA STRUCTURE
% LocoMeasData.M          [mm]
% LocoMeasData.BPMSTD     [mm]
% LocoMeasData.DeltaAmps  [Amps] (Optional)
% LocoMeasData.Eta        [mm] 
% LocoMeasData.RF         [Hz]
% LocoMeasData.DeltaRF    [Hz]


%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% GET RESPONSE MATRIX INFO %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rmat(BPM,COR)
% Rmat(1,1).Data=xx;  %Kick x, look x
% Rmat(2,1).Data=yx;  %Kick x, look y
% Rmat(1,2).Data=xy;  %Kick y, look x
% Rmat(2,2).Data=yy;  %Kick y, look y

ButtonName = questdlg('LOCO response matrix?','RESPONSE MATRIX','Use Default','Measure','Get From File','Get From File');
switch ButtonName,
    case 'Get From File'
        [BPMRespFile, BPMRespDirectory] = uigetfile('*.mat','Select a BPM Response Matrix File', DirStart);
        if BPMRespFile == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        DirStart = BPMRespDirectory;

        % Variable MachineConfig is the lattice at the time when the response matrix was generated
        load([BPMRespDirectory BPMRespFile],'MachineConfig');
        
        Rmat(1,1) = getrespmat('BPMx', [], 'HCM', [], [BPMRespDirectory BPMRespFile],'Struct', 'NoEnergyScaling');
        Rmat(1,2) = getrespmat('BPMx', [], 'VCM', [], [BPMRespDirectory BPMRespFile],'Struct', 'NoEnergyScaling');
        Rmat(2,1) = getrespmat('BPMy', [], 'HCM', [], [BPMRespDirectory BPMRespFile],'Struct', 'NoEnergyScaling');
        Rmat(2,2) = getrespmat('BPMy', [], 'VCM', [], [BPMRespDirectory BPMRespFile],'Struct', 'NoEnergyScaling');
        
    case 'Use Default'
        Rmat(1,1) = getrespmat('BPMx', [], 'HCM', [],'Struct', 'NoEnergyScaling');
        Rmat(1,2) = getrespmat('BPMx', [], 'VCM', [],'Struct', 'NoEnergyScaling');
        Rmat(2,1) = getrespmat('BPMy', [], 'HCM', [],'Struct', 'NoEnergyScaling');
        [Rmat(2,2), FileName] = getrespmat('BPMy', [], 'VCM', [],'Struct', 'NoEnergyScaling');
        
        % Variable MachineConfig is the lattice at the time when the response matrix was generated
        load(FileName,'MachineConfig');
        
    case 'Measure'
        Rmat = measbpmresp('Struct');

        % Variable MachineConfig is the lattice at the time when the response matrix was generated
        MachineConfig = getmachineconfig;
        
    otherwise
        fprintf('   LOCO input not built.\n');
        return
end


i = findrowindex(RemoveBPMDeviceList, Rmat(1,1).Monitor.DeviceList);
Rmat(1,1).Data(i,:) = [];
Rmat(1,1).Monitor1(i,:) = [];
Rmat(1,1).Monitor2(i,:) = [];
Rmat(1,1).Monitor.DeviceList(i,:) = [];
Rmat(1,1).Monitor.Data(i,:) = [];
Rmat(1,1).Monitor.Status(i,:) = [];

i = findrowindex(RemoveBPMDeviceList, Rmat(1,2).Monitor.DeviceList);
Rmat(1,2).Data(i,:) = [];
Rmat(1,2).Monitor1(i,:) = [];
Rmat(1,2).Monitor2(i,:) = [];
Rmat(1,2).Monitor.DeviceList(i,:) = [];
Rmat(1,2).Monitor.Data(i,:) = [];
Rmat(1,2).Monitor.Status(i,:) = [];

i = findrowindex(RemoveBPMDeviceList, Rmat(2,1).Monitor.DeviceList);
Rmat(2,1).Data(i,:) = [];
Rmat(2,1).Monitor1(i,:) = [];
Rmat(2,1).Monitor2(i,:) = [];
Rmat(2,1).Monitor.DeviceList(i,:) = [];
Rmat(2,1).Monitor.Data(i,:) = [];
Rmat(2,1).Monitor.Status(i,:) = [];

i = findrowindex(RemoveBPMDeviceList, Rmat(2,2).Monitor.DeviceList);
Rmat(2,2).Data(i,:) = [];
Rmat(2,2).Monitor1(i,:) = [];
Rmat(2,2).Monitor2(i,:) = [];
Rmat(2,2).Monitor.DeviceList(i,:) = [];
Rmat(2,2).Monitor.Data(i,:) = [];
Rmat(2,2).Monitor.Status(i,:) = [];


% LOCO uses mm, not mm/amp
R11 = (ones(size(Rmat(1,1).Data,1),1) * Rmat(1,1).ActuatorDelta(:)') .* Rmat(1,1).Data;
R12 = (ones(size(Rmat(1,2).Data,1),1) * Rmat(1,2).ActuatorDelta(:)') .* Rmat(1,2).Data;
R21 = (ones(size(Rmat(2,1).Data,1),1) * Rmat(2,1).ActuatorDelta(:)') .* Rmat(2,1).Data;
R22 = (ones(size(Rmat(2,2).Data,1),1) * Rmat(2,2).ActuatorDelta(:)') .* Rmat(2,2).Data;


% Build non-structure response matrix
LocoMeasData.M = [R11 R12; R21 R22];   % [mm]
LocoMeasData.DeltaAmps = [Rmat(1,1).ActuatorDelta(:); Rmat(2,2).ActuatorDelta(:)];


% Extra variables to add to the measured structure
LocoMeasData.MachineConfig  = MachineConfig;
LocoMeasData.BPMx = Rmat(1,1).Monitor;
LocoMeasData.BPMy = Rmat(2,2).Monitor;
LocoMeasData.HCM = Rmat(1,1).Actuator;
LocoMeasData.VCM = Rmat(2,2).Actuator;

% Needed for computing the new gain
LocoMeasData.HCMGain = getgain('HCM', Rmat(1,1).Actuator.DeviceList);
LocoMeasData.VCMGain = getgain('VCM', Rmat(2,2).Actuator.DeviceList);
LocoMeasData.HCMRoll = getroll('HCM', Rmat(1,1).Actuator.DeviceList);
LocoMeasData.VCMRoll = getroll('VCM', Rmat(2,2).Actuator.DeviceList);


% Sextupoles
if all(MachineConfig.SF.Setpoint.Data == 0)
    fprintf('   Turning SF family off in the LOCO model.\n');
    ATIndex = findcells(RINGData.Lattice,'FamName','SFF')';
    for i = 1:length(ATIndex)
        RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
    end
end
if all(MachineConfig.SD.Setpoint.Data == 0)
    fprintf('   Turning SD family off in the LOCO model.\n');
    ATIndex = findcells(RINGData.Lattice,'FamName','SDD')';
    for i = 1:length(ATIndex)
        RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
    end
end


if ~exist('RINGData','var')
    % Kick strength in milliradian
    HCMKicks = 1000 * hw2physics('HCM', 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
    VCMKicks = 1000 * hw2physics('VCM', 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);
    fprintf('   Note: Without an AT model BPMData and CMData variables cannot be determined.\n');
    fprintf('         Variables HCMKicks and VCMKicks will be saved to the data file.\n');
    save(OutputFileName, 'LocoMeasData', 'LocoModel', 'HCMKicks', 'VCMKicks');
    return
end



%%%%%%%%%%%%%%%%%%%%%%%
% GET DISPERSION INFO %
%%%%%%%%%%%%%%%%%%%%%%%
ButtonName = questdlg('LOCO Dispersion & RF Frequency?','DISPERSION','Use Default','Measure','Get From File','Get From File');
switch ButtonName
    case 'Use Default'
        DISPx = getdisp('BPMx', [],'Struct', 'Hardware');
        DISPy = getdisp('BPMy', [],'Struct', 'Hardware');
        RF = DISPx.Actuator.Data;
        DeltaRF = DISPx.ActuatorDelta;
        DISPx = DeltaRF * DISPx.Data;
        DISPy = DeltaRF * DISPy.Data;

    case 'Get From File'
        [DISPFile, DISPDirectory] = uigetfile('*.mat','Select a Dispersion File', DirStart);
        if DISPFile == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        DirStart = DISPDirectory;

        DISPx = getrespmat('BPMx', Rmat(1,1).Monitor.DeviceList, 'RF', [], [DISPDirectory DISPFile], 'Struct', 'Hardware', 'NoEnergyScaling');
        RF = DISPx.Actuator.Data;
        DeltaRF = DISPx.ActuatorDelta;
        DISPx = DeltaRF * DISPx.Data;
        DISPy = DeltaRF * getrespmat('BPMy', Rmat(2,2).Monitor.DeviceList, 'RF', [], [DISPDirectory DISPFile], 'Hardware', 'NoEnergyScaling');
        
    case 'Measure'
        [Dx, Dy] = measdisp('BPMx', Rmat(1,1).Monitor.DeviceList, 'BPMy', Rmat(2,2).Monitor.DeviceList, 'Struct', 'Archive', 'Hardware');
        RF = Dx.Actuator.Data;
        DeltaRF = Dx.ActuatorDelta;
        DISPx = DeltaRF * Dx.Data;
        DISPy = DeltaRF * Dy.Data;
end

LocoMeasData.RF      = 1e6 * RF;             % [Hz]
LocoMeasData.DeltaRF = 1e6 * DeltaRF;        % [Hz]
LocoMeasData.Eta = [DISPx(:); DISPy(:)];     % [mm]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% GET BPM STANDARD DEVIATION INFO %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ButtonName = questdlg('LOCO BPM Sigma?','BPM SIGMA','Use Default','Measure','Get From File','Get From File');
switch ButtonName,
    case 'Get From File'
        [BPMSigmaFile, BPMSigmaDirectory] = uigetfile('*.mat','Select a BPM Sigma File', DirStart);
        if BPMRespFile == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        DirStart = BPMSigmaDirectory;

        %BPMxSTD = getdata('BPMx', Rmat(1,1).Monitor.DeviceList, [BPMSigmaDirectory BPMSigmaFile]);
        %BPMySTD = getdata('BPMy', Rmat(2,2).Monitor.DeviceList, [BPMSigmaDirectory BPMSigmaFile]);
        BPMxSTD = getsigma('BPMx', Rmat(1,1).Monitor.DeviceList, [], [BPMSigmaDirectory BPMSigmaFile]);
        BPMySTD = getsigma('BPMy', Rmat(2,2).Monitor.DeviceList, [], [BPMSigmaDirectory BPMSigmaFile]);
        
    case 'Use Default'
        BPMxSTD = getsigma('BPMx', Rmat(1,1).Monitor.DeviceList);
        BPMySTD = getsigma('BPMy', Rmat(2,2).Monitor.DeviceList);

    case 'Measure'
        [BPMx, BPMy, tout, DCCT, BPMxSTD, BPMySTD] = monbpm(0:.5:60*3, 'BPMx', Rmat(1,1).Monitor.DeviceList, 'BPMy', Rmat(2,2).Monitor.DeviceList, 'Archive');
end

% sqrt(2) is needed because LOCO standard deviation is for difference orbits
LocoMeasData.BPMSTD = sqrt(2) * [BPMxSTD(:); BPMySTD(:)];    % [mm]  



% 3. BPM AND CORRECTOR MAGNET STRUCTURES
% FamName and BPMIndex tells the findorbitrespm function which BPMs are needed in the response matrix 
% HBPMIndex/VBPMIndex is the sub-index of BPMIndex which correspond to the measured response matrix
% BPMData.HBPMGain = starting value for the horizontal BPM gains (default: ones)
% BPMData.VBPMGain = starting value for the vertical   BPM gains (default: ones)
% BPMData.HBPMCoupling = starting value for the horizontal BPM coupling (default: zeros)
% BPMData.VBPMCoupling = starting value for the vertical   BPM coupling (default: zeros)
% BPMData.FitGains    = 'Yes'/'No' to fitting the BPM gain     (set in locogui)
% BPMData.FitCoupling = 'Yes'/'No' to fitting the BPM coupling (set in locogui)
% Note that gains and coupling are used all the time (fit or not!)

if 1
    % Get the AT indexes from the AT model
    % The model should have the same number of devices as the total device list in the AO.
    % Then index based on the DeviceList saved with the response matrix
    BPMData.FamName = 'BPM';
    BPMData.FitGains    = 'Yes';
    BPMData.FitCoupling = 'Yes';
    BPMData.BPMIndex = findcells(THERING, 'FamName', BPMData.FamName)';
    tempindex = BPMData.BPMIndex;
    
    BPMxListTotal0 = family2dev(Rmat(1,1).Monitor.FamilyName,0);
    %BPMxListTotal = getlist(Rmat(1,1).Monitor.FamilyName);
    BPMxListTotal = Rmat(1,1).Monitor.DeviceList;
    subindex = findrowindex([BPMxListTotal; zeros(length(BPMxListTotal0)-length(BPMxListTotal),2)],BPMxListTotal0); 
        
    BPMData.BPMIndex = BPMData.BPMIndex(subindex);    
    if length(BPMData.BPMIndex) == size(BPMxListTotal,1)
        %BPMData.HBPMIndex = 1:length(BPMData.BPMIndex); 
        
        % Only include the good BPMs (Status = 1)
        BPMData.HBPMIndex = findrowindex(Rmat(1,1).Monitor.DeviceList, BPMxListTotal); 
    else
        error('BPM family in the AT model has more BPMs then the actual accelerator (horizontally)');
    end     
    
    BPMyListTotal = Rmat(2,2).Monitor.DeviceList;
    
    if length(BPMData.BPMIndex) == size(BPMyListTotal,1)
        % Only include the good BPMs (Status = 1)
        BPMData.VBPMIndex = findrowindex(Rmat(2,2).Monitor.DeviceList, BPMyListTotal); 
    else
        error('BPM family in the AT model has more BPMs then the actual accelerator (vertically)');
    end     
    
else
    % Get the AT indexes from the AO
    BPM1Index = family2atindex(Rmat(1,1).Monitor.FamilyName, Rmat(1,1).Monitor.DeviceList);    % Must match the response matrix
    BPM2Index = family2atindex(Rmat(2,2).Monitor.FamilyName, Rmat(2,2).Monitor.DeviceList);    % Must match the response matrix
    BPMData.FamName = THERING{BPM1Index(1)};
    
    BPMData.BPMIndex = unique([BPM1Index(:); BPM2Index(:)]);
    BPMData.HBPMIndex = intersect(BPM1Index, BPMData.BPMIndex);          % Must match the response matrix
    BPMData.VBPMIndex = intersect(BPM2Index, BPMData.BPMIndex);          % Must match the response matrixelse
    % Get the AT index from the AO
    BPM1Index = family2atindex(Rmat(1,1).Monitor.FamilyName, Rmat(1,1).Monitor.DeviceList);    % Must match the response matrix
    BPM2Index = family2atindex(Rmat(2,2).Monitor.FamilyName, Rmat(2,2).Monitor.DeviceList);    % Must match the response matrix
    BPMData.FamName = THERING{BPM1Index(1)};
    
    BPMData.BPMIndex = unique([BPM1Index(:); BPM2Index(:)]);
    BPMData.HBPMIndex = intersect(BPM1Index, BPMData.BPMIndex);          % Must match the response matrix
    BPMData.VBPMIndex = intersect(BPM2Index, BPMData.BPMIndex);          % Must match the response matrix
end

if 1
    % Starting with an present GCR
    for i = 1:length(Rmat(1,1).Monitor.DeviceList)
        m = gcr2loco(getgain('BPMx', Rmat(1,1).Monitor.DeviceList(i,:)), getgain('BPMy', Rmat(1,1).Monitor.DeviceList(i,:)), getcrunch('BPMx', Rmat(1,1).Monitor.DeviceList(i,:)), getroll('BPMx', Rmat(1,1).Monitor.DeviceList(i,:)));
        BPMData.HBPMGain(i,1) = m(1,1);
        BPMData.HBPMCoupling(i,1) = m(1,2);
    end

    for i = 1:length(Rmat(2,2).Monitor.DeviceList)
        m = gcr2loco(getgain('BPMx', Rmat(2,2).Monitor.DeviceList(i,:)), getgain('BPMy', Rmat(2,2).Monitor.DeviceList(i,:)), getcrunch('BPMy', Rmat(2,2).Monitor.DeviceList(i,:)), getroll('BPMy', Rmat(2,2).Monitor.DeviceList(i,:)));
        BPMData.VBPMGain(i,1) = m(2,2);
        BPMData.VBPMCoupling(i,1) = m(2,1);
    end
else
    % Starting with nominal gains
    BPMData.HBPMGain = ones(length(BPMData.HBPMIndex), 1);
    BPMData.VBPMGain = ones(length(BPMData.VBPMIndex), 1);
end



% FamName and HCMIndex/VCMIndex tells the findorbitrespm function which corrector magnets are in the response matrix
% CMData.FitKicks = 'Yes'/'No' to fitting the corrector magnet gain (set in locogui)
% CMData.FitCoupling = 'Yes'/'No' to fitting the corrector magnet coupling (set in locogui)
% CMData.HCMKicks = starting value for the horizontal kicks in milliradian
% CMData.VCMKicks = starting value for the vertical   kicks in milliradian
% CMData.HCMCoupling = starting value for the horizontal coupling (default: zeros)
% CMData.VCMCoupling = starting value for the vertical   coupling (default: zeros)
% Note:  The kick strength should match the measured response matrix as best as possible
% Note:  The kicks and Coupling are used all the time (fit or not!)

% Get the AT indexes from the AT model
CMData.FitKicks    = 'Yes';
CMData.FitCoupling = 'Yes';
CMData.FitHCMEnergyShift = 'No';
CMData.FitVCMEnergyShift = 'No';

% Get the AT indexes from the AO
CMData.HCMIndex = family2atindex(Rmat(1,1).Actuator.FamilyName, Rmat(1,1).Actuator.DeviceList);    % Must match the response matrix
CMData.VCMIndex = family2atindex(Rmat(2,2).Actuator.FamilyName, Rmat(2,2).Actuator.DeviceList);    % Must match the response matrix
CMData.FamName = THERING{CMData.HCMIndex(1)}.FamName;

% Kick strength in milliradian
CMData.HCMKicks = 1000 * hw2physics('HCM', 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
CMData.VCMKicks = 1000 * hw2physics('VCM', 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);

% The kicks need to be adjusted for roll (model coordinates)
CMData.HCMKicks = CMData.HCMKicks .* cos(getroll('HCM',Rmat(1,1).Actuator.DeviceList));
CMData.VCMKicks = CMData.VCMKicks .* cos(getroll('VCM',Rmat(2,2).Actuator.DeviceList));

% Coupling term
CMData.HCMCoupling =  getgain('HCM', Rmat(1,1).Actuator.DeviceList) .* sin(getroll('HCM',Rmat(1,1).Actuator.DeviceList));
CMData.VCMCoupling = -getgain('VCM', Rmat(2,2).Actuator.DeviceList) .* sin(getroll('VCM',Rmat(2,2).Actuator.DeviceList));



%%%%%%%%%%%%%
% LocoFlags %
%%%%%%%%%%%%%
% LocoFlags can be created or just take the defaults with locogui (or locofilecheck) 
% LocoFlags = [];   
LocoFlags.Threshold = 1e-006;
LocoFlags.OutlierFactor = 10;
LocoFlags.SVmethod = 1e-005;
LocoFlags.HorizontalDispersionWeight = 12.5;
LocoFlags.VerticalDispersionWeight = 12.5;
LocoFlags.AutoCorrectDelta = 'Yes';
LocoFlags.Coupling = 'Yes';
LocoFlags.Normalize = 'Yes';
LocoFlags.Dispersion = 'Yes';
LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';



%%%%%%%%%%%%%%%%%
% FitParameters %
%%%%%%%%%%%%%%%%%
FitParameters = [];

ButtonName = questdlg('Which LOCO fit parameter?','FIT PARAMETERS','Fit By Family','Fit Individual Magnets','No Parameter Setup','Fit Individual Magnets');
switch ButtonName
    case 'Fit By Family'
        error('Fit By Family not programmed')

    case 'Fit Individual Magnets'
        error('Fit By Family not programmed')

    otherwise
        FitParameters = [];
end


% Starting point for the deltas (automatic delta determination does not work if starting value is 0)
%FitParameters.Deltas = 0.0001 * ones(size(FitParameters.Values));


% RF parameter fit setup (There is a flag to actually do the fit)
FitParameters.DeltaRF = LocoMeasData.DeltaRF;


% File check
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});


% Save
save(OutputFileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');


% Restore the old AT model
THERING = THERINGsave;
