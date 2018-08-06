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


% Family Setup
BPMxFamily = 'BPMx';
BPMyFamily = 'BPMy';

HCMFamily = 'HCM';
VCMFamily = 'VCM';


% BPMs to remove 
RemoveBPMDeviceList = [];
RemoveHCMDeviceList = [];
RemoveVCMDeviceList = [];


if nargin == 0
    [OutputFileName, DirectoryName] = uiputfile('*.mat', 'New LOCO Input File Name?');
    if OutputFileName == 0
        return
    end
    OutputFileName = [DirectoryName OutputFileName];
end

DirStart = [getfamilydata('Directory', 'DataRoot'), filesep, 'LOCO', filesep];



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
[ATModel, DirectoryName] = uigetfile('*.*', 'AT Model (Cancel to use the present model)?', [DirectoryName, filesep, ATModel, Ext]);
if ATModel == 0
    if isempty(THERING)
        fprintf('   No AT model found.  Buildlocoinput canceled.\n');
        return;
    end
else
    if strcmpi(ATModel(end-3:end), '.mat')
        load([DirectoryName, ATModel]);
    else
        run([DirectoryName, ATModel]);
    end
end

% To start with nominal gains (1) and coupling (0)
%ButtonName = questdlg('Gains and Coupling?','LOCO STARTING POINT','Use Present Setting','Nominal Gain=1, Coupling=0','Use Present Setting');
%switch ButtonName,
%    case 'Nominal Gain=1, Coupling=0'
        setlocodata('Nominal');
%        fprintf('   May need to run setoperationmode (or alsinit) to restore the proper gains & rolls.\n');
%end


% Cavity and radiation should be off for response and dispersion generation
setcavity off;
setradiation off;

% Set the model energy
setenergymodel(getfamilydata('Energy'));

RINGData.Lattice = THERING;
RINGData.CavityFrequency  = getrf('Model','Physics');
RINGData.CavityHarmNumber = getfamilydata('HarmonicNumber');



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
drawnow;
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
        
        Rmat(1,1) = getrespmat(BPMxFamily, [], HCMFamily, [], [BPMRespDirectory BPMRespFile], 'Hardware', 'Struct', 'NoEnergyScaling');
        Rmat(1,2) = getrespmat(BPMxFamily, [], VCMFamily, [], [BPMRespDirectory BPMRespFile], 'Hardware', 'Struct', 'NoEnergyScaling');
        Rmat(2,1) = getrespmat(BPMyFamily, [], HCMFamily, [], [BPMRespDirectory BPMRespFile], 'Hardware', 'Struct', 'NoEnergyScaling');
        Rmat(2,2) = getrespmat(BPMyFamily, [], VCMFamily, [], [BPMRespDirectory BPMRespFile], 'Hardware', 'Struct', 'NoEnergyScaling');
        
    case 'Use Default'
        Rmat(1,1) = getrespmat(BPMxFamily, [], HCMFamily, [], 'Hardware', 'Struct', 'NoEnergyScaling');
        Rmat(1,2) = getrespmat(BPMxFamily, [], VCMFamily, [], 'Hardware', 'Struct', 'NoEnergyScaling');
        Rmat(2,1) = getrespmat(BPMyFamily, [], HCMFamily, [], 'Hardware', 'Struct', 'NoEnergyScaling');
       [Rmat(2,2), FileName] = getrespmat(BPMyFamily, [], VCMFamily, [], 'Hardware', 'Struct', 'NoEnergyScaling');
        
        % Variable MachineConfig is the lattice at the time when the response matrix was generated
        load(FileName,'MachineConfig');
        
    case 'Measure'
        Rmat = measbpmresp('Struct', 'Hardware');

        % Variable MachineConfig is the lattice at the time when the response matrix was generated
        MachineConfig = getmachineconfig;
        
    otherwise
        fprintf('   LOCO input not built.\n');
        return
end


% BPM remove list  
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


% CM remove list  
i = findrowindex(RemoveHCMDeviceList, Rmat(1,1).Actuator.DeviceList);
Rmat(1,1).Data(:,i) = [];
Rmat(1,1).ActuatorDelta(i,:) = [];
Rmat(1,1).Actuator.DeviceList(i,:) = [];
Rmat(1,1).Actuator.Data(i,:) = [];
Rmat(1,1).Actuator.Status(i,:) = [];

i = findrowindex(RemoveVCMDeviceList, Rmat(1,2).Actuator.DeviceList);
Rmat(1,2).Data(:,i) = [];
Rmat(1,2).ActuatorDelta(i,:) = [];
Rmat(1,2).Actuator.DeviceList(i,:) = [];
Rmat(1,2).Actuator.Data(i,:) = [];
Rmat(1,2).Actuator.Status(i,:) = [];

i = findrowindex(RemoveHCMDeviceList, Rmat(2,1).Actuator.DeviceList);
Rmat(2,1).Data(:,i) = [];
Rmat(2,1).ActuatorDelta(i,:) = [];
Rmat(2,1).Actuator.DeviceList(i,:) = [];
Rmat(2,1).Actuator.Data(i,:) = [];
Rmat(2,1).Actuator.Status(i,:) = [];

i = findrowindex(RemoveVCMDeviceList, Rmat(2,2).Actuator.DeviceList);
Rmat(2,2).Data(:,i) = [];
Rmat(2,2).ActuatorDelta(i,:) = [];
Rmat(2,2).Actuator.DeviceList(i,:) = [];
Rmat(2,2).Actuator.Data(i,:) = [];
Rmat(2,2).Actuator.Status(i,:) = [];


% LOCO uses mm, not micron/amp
R11 = (ones(size(Rmat(1,1).Data,1),1) * Rmat(1,1).ActuatorDelta(:)') .* Rmat(1,1).Data / 1000;
R12 = (ones(size(Rmat(1,2).Data,1),1) * Rmat(1,2).ActuatorDelta(:)') .* Rmat(1,2).Data / 1000;
R21 = (ones(size(Rmat(2,1).Data,1),1) * Rmat(2,1).ActuatorDelta(:)') .* Rmat(2,1).Data / 1000;
R22 = (ones(size(Rmat(2,2).Data,1),1) * Rmat(2,2).ActuatorDelta(:)') .* Rmat(2,2).Data / 1000;


% Add energy to the RINGData (not needed for LOCO)
RINGData.Energy = Rmat(1,1).GeV;

% Build non-structure response matrix
LocoMeasData.M = [R11 R12; R21 R22];   % [mm]
LocoMeasData.DeltaAmps = [Rmat(1,1).ActuatorDelta(:); Rmat(2,2).ActuatorDelta(:)];

% Extra variables to add to the measured structure
LocoMeasData.MachineConfig = MachineConfig;
LocoMeasData.BPMx = Rmat(1,1).Monitor;
LocoMeasData.BPMy = Rmat(2,2).Monitor;
LocoMeasData.HCM = Rmat(1,1).Actuator;
LocoMeasData.VCM = Rmat(2,2).Actuator;

% Needed for computing the new gain
LocoMeasData.HCMGain = getgain(HCMFamily, Rmat(1,1).Actuator.DeviceList);
LocoMeasData.VCMGain = getgain(VCMFamily, Rmat(2,2).Actuator.DeviceList);
LocoMeasData.HCMRoll = getroll(HCMFamily, Rmat(1,1).Actuator.DeviceList);
LocoMeasData.VCMRoll = getroll(VCMFamily, Rmat(2,2).Actuator.DeviceList);


% % Sextupoles
% if all(MachineConfig.SF.Setpoint.Data == 0)
%     fprintf('   Turning SF family off in the LOCO model.\n');
%     ATIndex = findcells(RINGData.Lattice,'FamName','SFF')';
%     for i = 1:length(ATIndex)
%         RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
%     end
% end
% if all(MachineConfig.SD.Setpoint.Data == 0)
%     fprintf('   Turning SD family off in the LOCO model.\n');
%     ATIndex = findcells(RINGData.Lattice,'FamName','SDD')';
%     for i = 1:length(ATIndex)
%         RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
%     end
% end
% 
% 
% % Skew quadrupoles
% if all(MachineConfig.SQSF.Setpoint.Data == 0)
%     fprintf('   SQSF family was at zero when the response matrix was taken.\n');
% end
% if all(MachineConfig.SQSD.Setpoint.Data == 0)
%     fprintf('   SQSD family was at zero when the response matrix was taken.\n');
% end


if ~exist('RINGData','var')
    % Kick strength in milliradian
    HCMKicks = 1000 * hw2physics(HCMFamily, 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
    VCMKicks = 1000 * hw2physics(VCMFamily, 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);
    fprintf('   Note: Without an AT model BPMData and CMData variables cannot be determined.\n');
    fprintf('         Variables HCMKicks and VCMKicks will be saved to the data file.\n');
    save(OutputFileName, 'LocoMeasData', 'LocoModel', 'HCMKicks', 'VCMKicks');
    return
end



%%%%%%%%%%%%%%%%%%%%%%%
% GET DISPERSION INFO %
%%%%%%%%%%%%%%%%%%%%%%%
ButtonName = questdlg('LOCO Dispersion & RF Frequency?','DISPERSION','Use Default','Measure','Get From File','Get From File');
drawnow;
switch ButtonName
    case 'Use Default'
        DISPx = getdisp(BPMxFamily, Rmat(1,1).Monitor.DeviceList, 'Struct', 'Hardware');
        DISPy = getdisp(BPMyFamily, Rmat(2,2).Monitor.DeviceList, 'Struct', 'Hardware');
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

        DISPx = getrespmat(BPMxFamily, Rmat(1,1).Monitor.DeviceList, 'RF', [], [DISPDirectory DISPFile], 'Struct', 'Hardware', 'NoEnergyScaling');
        RF = DISPx.Actuator.Data;
        DeltaRF = DISPx.ActuatorDelta;
        DISPx = DeltaRF * DISPx.Data;
        DISPy = DeltaRF * getrespmat(BPMyFamily, Rmat(2,2).Monitor.DeviceList, 'RF', [], [DISPDirectory DISPFile], 'Hardware', 'NoEnergyScaling');
        
    case 'Measure'
        [Dx, Dy] = measdisp(BPMxFamily, Rmat(1,1).Monitor.DeviceList, BPMyFamily, Rmat(2,2).Monitor.DeviceList, 'Struct', 'Archive', 'Hardware');
        RF = Dx.Actuator.Data;
        DeltaRF = Dx.ActuatorDelta;
        DISPx = DeltaRF * Dx.Data;
        DISPy = DeltaRF * Dy.Data;
end

%LocoMeasData.RF      = 1e6 * RF;             % [Hz]
%LocoMeasData.DeltaRF = 1e6 * DeltaRF;        % [Hz]
LocoMeasData.RF      = hw2physics('RF', 'Setpoint', RF);        % [Hz]
LocoMeasData.DeltaRF = hw2physics('RF', 'Setpoint', DeltaRF);   % [Hz]
LocoMeasData.Eta = [DISPx(:); DISPy(:)]/1000;     % [mm]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% GET BPM STANDARD DEVIATION INFO %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ButtonName = questdlg('LOCO BPM Sigma?','BPM SIGMA','Use Default','Measure','Get From File','Get From File');
drawnow;
switch ButtonName,
    case 'Get From File'
        [BPMSigmaFile, BPMSigmaDirectory] = uigetfile('*.mat','Select a BPM Sigma File', DirStart);
        drawnow;
        if BPMSigmaFile == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        DirStart = BPMSigmaDirectory;

        %BPMxSTD = getdata(BPMxFamily, Rmat(1,1).Monitor.DeviceList, [BPMSigmaDirectory BPMSigmaFile], 'Hardware');
        %BPMySTD = getdata(BPMyFamily, Rmat(2,2).Monitor.DeviceList, [BPMSigmaDirectory BPMSigmaFile], 'Hardware');
        BPMxSTD = getsigma(BPMxFamily, Rmat(1,1).Monitor.DeviceList, [], [BPMSigmaDirectory BPMSigmaFile], 'Hardware');
        BPMySTD = getsigma(BPMyFamily, Rmat(2,2).Monitor.DeviceList, [], [BPMSigmaDirectory BPMSigmaFile], 'Hardware');
        
    case 'Use Default'
        BPMxSTD = getsigma(BPMxFamily, Rmat(1,1).Monitor.DeviceList, 'Hardware');
        BPMySTD = getsigma(BPMyFamily, Rmat(2,2).Monitor.DeviceList, 'Hardware');

    case 'Measure'
        [BPMx, BPMy, tout, DCCT, BPMxSTD, BPMySTD] = monbpm(0:.5:60*3, BPMxFamily, Rmat(1,1).Monitor.DeviceList, BPMyFamily, Rmat(2,2).Monitor.DeviceList, 'Archive', 'Hardware');
end

% sqrt(2) is needed because LOCO standard deviation is for difference orbits
LocoMeasData.BPMSTD = sqrt(2) * [BPMxSTD(:); BPMySTD(:)] / 1000;    % [mm]  



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


BPMData.FamName = 'BPM';
BPMData.FitGains    = 'Yes';
BPMData.FitCoupling = 'Yes';

% Get the AT index from the AO
BPM1Index = family2atindex(Rmat(1,1).Monitor.FamilyName, Rmat(1,1).Monitor.DeviceList);    % Must match the response matrix
BPM2Index = family2atindex(Rmat(2,2).Monitor.FamilyName, Rmat(2,2).Monitor.DeviceList);    % Must match the response matrix
BPMData.FamName = THERING{BPM1Index(1)};

BPMData.BPMIndex = unique([BPM1Index(:); BPM2Index(:)]);
BPMData.HBPMIndex = findrowindex(BPM1Index, BPMData.BPMIndex);          % Must match the response matrix
BPMData.VBPMIndex = findrowindex(BPM2Index, BPMData.BPMIndex);          % Must match the response matrix


% Starting with nominal gains
BPMData.HBPMGain = ones(length(BPMData.HBPMIndex), 1);
BPMData.VBPMGain = ones(length(BPMData.VBPMIndex), 1);



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
CMData.HCMKicks = 1000 * hw2physics(HCMFamily, 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
CMData.VCMKicks = 1000 * hw2physics(VCMFamily, 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);

% The kicks need to be adjusted for roll (model coordinates)
CMData.HCMKicks = CMData.HCMKicks .* cos(getroll(HCMFamily,Rmat(1,1).Actuator.DeviceList));
CMData.VCMKicks = CMData.VCMKicks .* cos(getroll(VCMFamily,Rmat(2,2).Actuator.DeviceList));

% Coupling term: Cloco/Gloco  = gain(ML)*sin(Roll)/(gain(ML)*cos(Roll)) = tan(Roll)
%CMData.HCMCoupling =  getgain(HCMFamily, Rmat(1,1).Actuator.DeviceList) .* sin(getroll(HCMFamily,Rmat(1,1).Actuator.DeviceList));
%CMData.VCMCoupling = -getgain(VCMFamily, Rmat(2,2).Actuator.DeviceList) .* sin(getroll(VCMFamily,Rmat(2,2).Actuator.DeviceList));
CMData.HCMCoupling =  tan(getroll(HCMFamily,Rmat(1,1).Actuator.DeviceList));
CMData.VCMCoupling = -tan(getroll(VCMFamily,Rmat(2,2).Actuator.DeviceList));



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

% Individual magnets
% For each parameter which is fit in the model a numerical response matrix
% gradient needs to be determined.  The FitParameters data structure determines what
% parameter in the model get varied and how are they grouped.  For no parameter fits, set
% FitParameters.Params to an empty vector.
%     FitParameters.Params = parameter group definition (cell array for AT)
%     FitParameters.Values = Starting value for the parameter fit
%     FitParameters.Deltas = change in parameter value used to compute the gradient (NaN forces loco to choose, see auto-correct delta flag below)
%     FitParameters.FitRFFrequency = ('Yes'/'No') Fit the RF frequency?
%     FitParameters.DeltaRF = Change in RF frequency when measuring "dispersion".
%                             If the RF frequency is being fit the output is stored here.
%
% The FitParameters structure also contains the standard deviations of the fits:
%     LocoValuesSTD
%     FitParameters.DeltaRFSTD
%
% Note: FitParameters.DeltaRF is used when including dispersion in the response matrix.
%       LocoMeasData.DeltaRF is not used directly in loco.  Usually one would set
%       FitParameters.DeltaRF = LocoMeasData.DeltaRF as a starting point for the RF frequency.


ModeCell = {'Fit magnets by family','Fit by magnet','No parameter setup'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Fit Parameter Selection:','(Not including skew quadrupoles)'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125]);
if OKFlag ~= 1
    ButtonName = 1;
end
%ButtonName = questdlg('Which LOCO fit parameter?','FIT PARAMETERS','Fit by Family','Fit All QFAs, the rest by PS','Fit by Magnet','No Parameter Setup','Fit by Power Supply');
drawnow;
FitParameters = [];
N = 0;
switch ButtonName
    case 1 %'Fit by Family'    
        
        N = N + 1;
        ATIndex = findcells(THERING,'FamName','QF');
        FitParameters.Params{N} = mkparamgroup(THERING, ATIndex, 'K');
        FitParameters.Values = getcellstruct(THERING, 'K', ATIndex(1));
        FitParameters.Deltas = NaN;

        N = N + 1;
        ATIndex = findcells(THERING,'FamName','QFI');
        FitParameters.Params{N} = mkparamgroup(THERING, ATIndex, 'K');
        FitParameters.Values(N,1) = getcellstruct(THERING, 'K', ATIndex(1));
        FitParameters.Deltas(N,1) = NaN;

        N = N + 1;
        ATIndex = findcells(THERING,'FamName','QD');
        FitParameters.Params{N} = mkparamgroup(THERING, ATIndex, 'K');
        FitParameters.Values(N,1) = getcellstruct(THERING, 'K', ATIndex(1));
        FitParameters.Deltas(N,1) = NaN;

        N = N + 1;
        ATIndex = findcells(THERING,'FamName','QDI');
        FitParameters.Params{N} = mkparamgroup(THERING, ATIndex, 'K');
        FitParameters.Values(N,1) = getcellstruct(THERING, 'K', ATIndex(1));
        FitParameters.Deltas(N,1) = NaN;

        % Add an error
        FitParameters.Values = FitParameters.Values .* [1.005;.995;.995;1.005];
        
    case 2 %'Fit by Magnet'
        
        % 24 QF K-values
        QFI = findcells(THERING,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(THERING,QFI(loop),'K');
        end
        FitParameters.Values = getcellstruct(THERING,'K',QFI);
        FitParameters.Deltas = NaN * ones(length(QFI),1);

        
        % 24 QD K-values
        QDI = findcells(THERING,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(THERING,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(THERING,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];
end

fprintf('\n');


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
