function [LocoMeasData, BPMData, CMData, RINGData] = buildlocoinput(OutputFileName)
%BUILDLOCOINPUT - combines response matrix, BPM standard deviation, and 
%                 dispersion files (or measurements) in to LOCO input file
%
%  [LocoMeasData, BPMData, CMData, RINGData] = buildlocoinput(OutputFileName)
%
%  Written by Greg Portmann


% % In order to iterate loco uses arrays of structures all the fields in the structure must be present
% LocoFlags = struct('SVmethod',[], 'Dispersion',[], 'Coupling',[], 'Normalize',[], 'Linear',[], 'SVDDataFileName',[]);
% LocoModel = struct('M',[], 'OutlierIndex',[], 'Eta',[], 'EtaOutlierIndex',[], 'SValues',[], 'SValuesIndex',[], 'ChiSquare',[]);
% BPMData = struct('FamName',[], 'BPMIndex',[], 'HBPMIndex',[], 'VBPMIndex',[], 'HBPMGoodDataIndex',[], 'VBPMGoodDataIndex',[], 'HBPMGain',[], 'VBPMGain',[], 'HBPMCoupling',[], 'VBPMCoupling',[], 'HBPMGainSTD',[], 'VBPMGainSTD',[],'HBPMCouplingSTD',[],'VBPMCouplingSTD',[],'FitGains',[],'FitCoupling',[]);
% CMData = struct('FamName',[], 'HCMIndex',[], 'VCMIndex',[], 'HCMGoodDataIndex',[], 'VCMGoodDataIndex',[], 'HCMKicks',[], 'VCMKicks',[], 'HCMCoupling',[], 'VCMCoupling',[], 'HCMKicksSTD',[], 'VCMKicksSTD',[],'HCMCouplingSTD',[],'VCMCouplingSTD',[],'FitKicks',[],'FitCoupling',[]);
% FitParameters = struct('Params',[], 'Values',[], 'ValuesSTD',[], 'Deltas',[], 'DeltaRF',[], 'FitRFFrequency',[], 'DeltaRFSTD',[]);


if nargin == 0
    [OutputFileName, DirectoryName] = uiputfile('*.mat', 'New LOCO Output File Name?');
    if OutputFileName == 0
        return
    end
    OutputFileName = [DirectoryName OutputFileName];
end


BPMData.FitGains         = 'No';
BPMData.FitCoupling      = 'No';

CMData.FitKicks          = 'No';
CMData.FitCoupling       = 'No';
CMData.FitHCMEnergyShift = 'No';
CMData.FitVCMEnergyShift = 'No';


% 1. AT MODEL
% An AT model of the accelerator must be available as THERING
AO_ATModel = getfamilydata('ATModel');
ATModelString = inputdlg('What AT Model (Cancel to ignor)?','AT MODEL', 1, {AO_ATModel});
if isempty(ATModelString)
    fprintf('   AT Model Ignored\n');
else
    % AT Model   
    global THERING
    ATModelString = ATModelString{1};
    feval(ATModelString);
    
    cavityoff    % Cavity must to off for dispersion function to work properly (and so GLOBVAL is not used).
    RINGData.Lattice = THERING;
    RINGData.CavityFrequency = 52.8875e6;
    RINGData.CavityHarmNumber = 30;
    
    if ~strcmpi(ATModelString, AO_ATModel)
        fprintf('   \nYou might need to rerun the AT model (%s) when this function completes\n', AO_ATModel);
    end
end


% 2. MEASURED DATA STRUCTURE
% LocoMeasData.M          [mm]
% LocoMeasData.BPMSTD     [mm]
% LocoMeasData.DeltaAmps  [Amps] (Optional)
% LocoMeasData.Eta        [mm] 
% LocoMeasData.RF         [Hz]
% LocoMeasData.DeltaRF    [Hz]



%%%%%%%%%%%%%%%%%%%%%%%
% GET DISPERSION INFO %
%%%%%%%%%%%%%%%%%%%%%%%
ButtonName = questdlg('LOCO Dispersion & RF Frequency?','DISPERSION','Measure','Get From File','Get From File');
switch ButtonName
    case 'Get From File'
        [DISPFile, DISPDirectory, FilterIndex] = uigetfile('*.mat','Select a Dispersion File', getfamilydata('Directory', 'DataRoot'));
        if FilterIndex == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        DISPx = getrespmat('BPMx', [], 'RF', [], [DISPDirectory DISPFile], 'Struct');
        RF = DISPx.Actuator.Data;
        DeltaRF = DISPx.ActuatorDelta;
        DISPx = DeltaRF * DISPx.Data;
        DISPy = DeltaRF * getrespmat('BPMy', [], 'RF', [], [DISPDirectory DISPFile]);
        
    case 'Measure'
        [Dx, Dy] = measdisp('Struct','Archive');
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
        [BPMRespFile, BPMRespDirectory] = uigetfile('*.mat','Select a BPM Sigma File', getfamilydata('Directory', 'DataRoot'));
        if BPMRespFile == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        %BPMxSTD = getdata('BPMx', [], [BPMRespDirectory BPMRespFile]);
        %BPMySTD = getdata('BPMy', [], [BPMRespDirectory BPMRespFile]);
        BPMxSTD = getsigma('BPMx', [], [], [BPMRespDirectory BPMRespFile]);
        BPMySTD = getsigma('BPMy', [], [], [BPMRespDirectory BPMRespFile]);
        
    case 'Use Default'
        BPMxSTD = getsigma('BPMx');
        BPMySTD = getsigma('BPMy');
        
    case 'Measure'
        [BPMx, BPMy, tout, DCCT, BPMxSTD, BPMySTD] = monbpm('Archive');
end

% sqrt(2) is needed because LOCO standard deviation is for difference orbits
LocoMeasData.BPMSTD = sqrt(2) * [BPMxSTD(:); BPMySTD(:)];    % [mm]  



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
        [BPMRespFile, BPMRespDirectory, FilterIndex] = uigetfile('*.mat','Select a BPM Response Matrix File', getfamilydata('Directory', 'DataRoot'));
        if FilterIndex == 0
            fprintf('   makelocoinputdata aborted\n');
            return
        end
        Rmat(1,1) = getrespmat('BPMx', [], 'HCM', [], [BPMRespDirectory BPMRespFile],'Struct');
        Rmat(1,2) = getrespmat('BPMx', [], 'VCM', [], [BPMRespDirectory BPMRespFile],'Struct');
        Rmat(2,1) = getrespmat('BPMy', [], 'HCM', [], [BPMRespDirectory BPMRespFile],'Struct');
        Rmat(2,2) = getrespmat('BPMy', [], 'VCM', [], [BPMRespDirectory BPMRespFile],'Struct');
        
    case 'Use Default'
        Rmat(1,1) = getrespmat('BPMx', [], 'HCM', [],'Struct');
        Rmat(1,2) = getrespmat('BPMx', [], 'VCM', [],'Struct');
        Rmat(2,1) = getrespmat('BPMy', [], 'HCM', [],'Struct');
        Rmat(2,2) = getrespmat('BPMy', [], 'VCM', [],'Struct');
        
    case 'Measure'
        Rmat = measbpmresp('Struct');
end

% LOCO uses mm, not mm/amp
R11 = (ones(size(Rmat(1,1).Data,1),1) * Rmat(1,1).ActuatorDelta(:)') .* Rmat(1,1).Data;
R12 = (ones(size(Rmat(1,2).Data,1),1) * Rmat(1,2).ActuatorDelta(:)') .* Rmat(1,2).Data;
R21 = (ones(size(Rmat(2,1).Data,1),1) * Rmat(2,1).ActuatorDelta(:)') .* Rmat(2,1).Data;
R22 = (ones(size(Rmat(2,2).Data,1),1) * Rmat(2,2).ActuatorDelta(:)') .* Rmat(2,2).Data;

LocoMeasData.M = [R11 R12; R21 R22];   % [mm]
LocoMeasData.DeltaAmps = [Rmat(1,1).ActuatorDelta(:); Rmat(2,2).ActuatorDelta(:)];


if ~exist('RINGData','var')
    % Kick strength in milliradian
    HCMKicks = 1000 * hw2physics('HCM', 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
    VCMKicks = 1000 * hw2physics('VCM', 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);
    fprintf('   Note: Without an AT model BPMData and CMData variables cannot be determined.\n');
    fprintf('         Variables HCMKicks and VCMKicks will be saved to the data file.\n');
    
    LocoModel = [];
    save(OutputFileName, 'LocoMeasData', 'LocoModel', 'HCMKicks', 'VCMKicks');
    return
end



% 3. BPM AND CORRECTOR MAGNET STRUCTURES
% FamName and BPMIndex tells the findorbitrespm function which BPMs are needed in the response matrix 
% HBPMIndex/VBPMIndex is the sub-index of BPMIndex which correspond to the measured response matrix
% BPMData.HBPMGain = starting value for the horizontal BPM gains (default: ones)
% BPMData.VBPMGain = starting value for the vertical   BPM gains (default: ones)
% BPMData.BPMCoupling = starting value for the horizontal BPM coupling (default: zeros)
% BPMData.BPMCoupling = starting value for the vertical   BPM coupling (default: zeros)
% BPMData.FitGains    = 'Yes'/'No' to fitting the BPM gain     (set in locogui)
% BPMData.FitCoupling = 'Yes'/'No' to fitting the BPM coupling (set in locogui)
% Note that gains and coupling are used all the time (fit or not!)

if 1
    % Get the AT indexes from the AT model
    % The model should have the same number of devices as the total device list in the AO.
    % Then index based on the DeviceList saved with the response matrix
    BPMData.FamName = 'BPM';
    BPMData.BPMIndex = findcells(THERING, 'FamName', BPMData.FamName)';
    tempindex = BPMData.BPMIndex;
    
    BPMxListTotal0 = family2dev(Rmat(1,1).Monitor.FamilyName,0);
    %     BPMxListTotal = getlist(Rmat(1,1).Monitor.FamilyName);
    BPMxListTotal = Rmat(1,1).Monitor.DeviceList;
    subindex = findrowindex([BPMxListTotal; ...
            zeros(length(BPMxListTotal0)-length(BPMxListTotal),2)],BPMxListTotal0); 
    
    %Temporary clooge: BPM [12 4] has been disconnected from Bergoz,
    %and [12 5] attached to that channel.  (Safranek, 1/10/04)
    % BPMData.BPMIndex(73) = BPMData.BPMIndex(74);
    
    BPMData.BPMIndex = BPMData.BPMIndex(subindex);
    
    %     % temporary bug fix: The last Bergoz BPM is actually not [18 7] as
    %     % control system claims, but really [18 6] - found this 2003/12/22
    %     % using LOCO (CAS, JAS)
    %     BPMData.BPMIndex(end) = tempindex(end-1);
    
    if length(BPMData.BPMIndex) == size(BPMxListTotal,1)
        %BPMData.HBPMIndex = 1:length(BPMData.BPMIndex); 
        
        % Only include the good BPMs (Status = 1)
        BPMData.HBPMIndex = findrowindex(Rmat(1,1).Monitor.DeviceList, BPMxListTotal); 
    else
        error('BPM family in the AT model has more BPMs then the actual accelerator (horizontally)');
    end     
    
    %     BPMyListTotal = getlist(Rmat(2,2).Monitor.FamilyName);
    BPMyListTotal = Rmat(2,2).Monitor.DeviceList;
    
    if length(BPMData.BPMIndex) == size(BPMyListTotal,1)
        %BPMData.VBPMIndex = 1:length(BPMData.BPMIndex);
        
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

% Starting with an old LOCO gain is probably better ???
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

if 1
    % Get the AT indexes from the AT model
    % The model should have the same number of devices as the total device list in the AO.
    % Then index based on the DeviceList saved with the response matrix
    CMData.FamName  = 'COR';
    CMData.HCMIndex = findcells(THERING, 'FamName', 'HCOR')';  % Must match the response matrix
    CMData.VCMIndex = findcells(THERING, 'FamName', 'VCOR')';  % Must match the response matrix
    
    HCMListTotal0 = family2dev('HCM',0);
    HCMListTotal = getlist(Rmat(1,1).Actuator.FamilyName);
    subindex = findrowindex(HCMListTotal0, HCMListTotal); 
    subindex = findrowindex([HCMListTotal; ...
            zeros(length(HCMListTotal0)-length(HCMListTotal),2)],HCMListTotal0); 
    
    CMData.HCMIndex = CMData.HCMIndex(subindex);
    
    %     if length(CMData.HCMIndex) == size(HCMListTotal,1)
    %         % Only include the good HCMs (Status = 1)
    %         CMData.HCMIndex = findrowindex(Rmat(1,1).Actuator.DeviceList, HCMListTotal); 
    %     else
    %         error('Cor family in the AT model has more correctors then the actual accelerator (horizontally)');
    %     end
    
    VCMListTotal0 = family2dev('VCM',0);
    VCMListTotal = getlist(Rmat(2,2).Actuator.FamilyName);
    subindex = findrowindex([VCMListTotal; ...
            zeros(length(VCMListTotal0)-length(VCMListTotal),2)],VCMListTotal0); 
    
    CMData.VCMIndex = CMData.VCMIndex(subindex);
    
    
    %     if length(CMData.VCMIndex) == size(VCMListTotal,1)
    %         % Only include the good VCMs (Status = 1)
    %         CMData.VCMIndex = findrowindex(Rmat(2,2).Actuator.DeviceList, VCMListTotal); 
    %     else
    %         error('Cor family in the AT model has more correctors then the actual accelerator (vertically)');
    %     end     
    
else
    % Get the AT indexes from the AO
    CMData.HCMIndex = family2atindex(Rmat(1,1).Actuator.FamilyName, Rmat(1,1).Actuator.DeviceList);    % Must match the response matrix
    CMData.VCMIndex = family2atindex(Rmat(2,2).Actuator.FamilyName, Rmat(2,2).Actuator.DeviceList);    % Must match the response matrix
    CMData.FamName = THERING{CMData.HCMIndex(1)};
end

% Kick strength in milliradian
CMData.HCMKicks = 1000 * hw2physics('HCM', 'Setpoint', Rmat(1,1).ActuatorDelta, Rmat(1,1).Actuator.DeviceList);  
CMData.VCMKicks = 1000 * hw2physics('VCM', 'Setpoint', Rmat(2,2).ActuatorDelta, Rmat(2,2).Actuator.DeviceList);


% FitParameters needs to be created
LocoModel = [];   % Clear the model because the RINGData, BPMData, or CMData may be different 
save(OutputFileName, 'LocoMeasData', 'BPMData', 'CMData', 'RINGData', 'LocoModel');


% Final file check (FitParameters cannot be empty for locofilecheck to work)
% FitParameters = [];
% LocoFlags = [];  % LocoFlags can be created or just take the defaults with locogui (or locofilecheck)  
% [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
% save(OutputFileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData');
% %save(OutputFileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
