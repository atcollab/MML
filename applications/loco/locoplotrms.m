function locoplotrms(FileName, IterationNumber, PlotType)
%LOCOPLOTRMS - Plots the RMS of the LOCO fits 
%  locoplotrms({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, IterationNumber, PlotType)
%      or 
%  locoplotrms(FileName, IterationNumber, PlotType)
%
%  INPUTS
%  1. FileName = data file name
%  2. IterationNumber = 0, 1, 2, etc
%  3. PlotType = 1 - Horizontal BPM by BPM (row)
%                2 - Horizontal RMS by corrector magnet (column)
%                3 - Vertical   RMS by BPM (row)
%                4 - Vertical   RMS by corrector magnet (column)
%           or
%  1. BPMData
%  2. CMData
%  3. LocoMeasData
%  4. LocoModel
%  5. FitParameters
%  6. LocoFlags
%  7. RINGData
%
%  NOTE
%  1. If outliers exist, then plots with and without outliers will be shown.
%
%  Written by Greg Portmann


if ~nargin==3
    error('Requires 3 inputs (see help locoplotrms).');
end

if isempty(FileName)
    return;
end

if iscell(FileName)
    BPMData       = FileName{1};
    CMData        = FileName{2};
    LocoMeasData  = FileName{3};
    LocoModel     = FileName{4};
    FitParameters = FileName{5};
    LocoFlags     = FileName{6};
    RINGData      = FileName{7};
elseif isstr(FileName)    
    try
        load(FileName);
    catch
        fprintf('   LOCOPLOT:  File does not exist or is not a *.mat file type.\n'); return;
    end    
else
    error('Input problem');
end

if length(BPMData) > 1
    IterationNumber = IterationNumber + 1;
    if IterationNumber > length(BPMData)
        fprintf('   LOCOPLOTRMS:  The data file only has %d iterations.  Hence, the input InterationNumber cannot be %d.\n', length(BPMData)-1, IterationNumber-1);
        return
    end
    
    BPMData = BPMData(IterationNumber);
    CMData = CMData(IterationNumber);
    LocoModel = LocoModel(IterationNumber);
    FitParameters = FitParameters(IterationNumber);
    LocoFlags = LocoFlags(IterationNumber);
end


if isstr(BPMData)
    FileName = BPMData;
    IterationNumber = CMData;
    PlotType = LocoMeasData;
    
    if isempty(FileName)
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
        
    IterationNumber = IterationNumber + 1;
    BPMData = BPMData(IterationNumber);
    CMData = CMData(IterationNumber);
    LocoModel = LocoModel(IterationNumber);
    LocoFlags = LocoFlags(IterationNumber);
else
    % Inputs should be scalar structures, if not take the last term
    BPMData = BPMData(end);
    CMData = CMData(end);
    LocoModel = LocoModel(end);
    LocoFlags = LocoFlags(end);
end

if isempty(LocoModel.M)
    fprintf('   No model available.\n');
    return
end

Mmodel = LocoModel.M;
Outliers = LocoModel.OutlierIndex;
ChiSquare = LocoModel.ChiSquare;
Mmeas = LocoMeasData.M;

% Remove unwanted data from the Mmeas and BPMSTD
BPMstd = LocoMeasData.BPMSTD([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex]);
Mstd = BPMstd * ones(1,size(Mmodel,2));
Mmeas = Mmeas([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

NHBPM = length(BPMData.HBPMGoodDataIndex);
NVBPM = length(BPMData.VBPMGoodDataIndex);
NBPM  = NHBPM + NVBPM;
NHCM = length(CMData.HCMGoodDataIndex);
NVCM = length(CMData.VCMGoodDataIndex);


% Add energy shifts for fixed momentum
if strcmp(lower(LocoFlags.ClosedOrbitType), 'fixedmomentum')
    % Add the dispersion term (measured) to the model response matrix
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
    
    % Set the lattice model
    for j = 1:length(FitParameters.Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
    end
    AlphaMCF = locomcf(RINGData);
    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    
    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
    
    for i = 1:length(VCMEnergyShift)
        Mmodel(:,NHCM+i) = Mmodel(:,NHCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
end

M = Mmeas(:)-Mmodel(:); 

% RMS response matrix error
M = reshape((M ./ Mstd(:)) .^ 2, NHBPM+NVBPM, NHCM+NVCM);

M11 = M(1:NHBPM     ,      1:NHCM     );
M12 = M(1:NHBPM     , NHCM+1:NHCM+NVCM);
M21 = M(NHBPM+1:NBPM,      1:NHCM     );
M22 = M(NHBPM+1:NBPM, NHCM+1:NHCM+NVCM);

BPMRMSxx = sqrt(sum(M11') / NHCM);  
BPMRMSyy = sqrt(sum(M22') / NVCM);

HCMRMS = sqrt(sum(M11) / NHBPM);  
VCMRMS = sqrt(sum(M22) / NVBPM);


switch PlotType
case 1
    plot(BPMData.HBPMGoodDataIndex, BPMRMSxx,'b');
    title('Horizontal Response Matrix RMS by Row');
    ylabel('\fontsize{10}\surd\Sigma(Mmeas-Mmodel)^2/\sigma^2(BPMx)/NHCM');
    xlabel('Horizontal BPM Number');
    axis tight
    
case 2
    plot(CMData.HCMGoodDataIndex, HCMRMS,'b');
    title('Horizontal Response Matrix RMS by Column');
    ylabel('\fontsize{10}\surd\Sigma(Mmeas-Mmodel)^2/\sigma^2(BPMx)/NHBPM');
    xlabel('Horizontal Corrector Number');
    axis tight

case 3
    plot(BPMData.VBPMGoodDataIndex, BPMRMSyy,'b');
    title('Vertical Response Matrix RMS by Row');
    ylabel('\fontsize{10}\surd\Sigma(Mmeas-Mmodel)^2/\sigma^2(BPMy)/NVCM');
    xlabel('Vertical BPM Number');
    axis tight
    
case 4
    plot(CMData.VCMGoodDataIndex, VCMRMS,'b');
    title('Vertical Response Matrix RMS by Column');
    ylabel('\fontsize{10}\surd\Sigma(Mmeas-Mmodel)^2/\sigma^2(BPMy)/NVBPM');
    xlabel('Vertical Corrector Number');
    axis tight
end


% Add plot without outliers
Outliers = LocoModel.OutlierIndex;
if ~isempty(Outliers)
    M = M(:);
    M(Outliers) = 0; 
    
    % RMS response matrix error
    M = reshape(M, NHBPM+NVBPM, NHCM+NVCM);
    
    M11 = M(1:NHBPM     ,      1:NHCM     );
    M12 = M(1:NHBPM     , NHCM+1:NHCM+NVCM);
    M21 = M(NHBPM+1:NBPM,      1:NHCM     );
    M22 = M(NHBPM+1:NBPM, NHCM+1:NHCM+NVCM);
    
    BPMRMSxx = sqrt(sum(M11') / NHCM);  
    BPMRMSyy = sqrt(sum(M22') / NVCM);
    
    HCMRMS = sqrt(sum(M11) / NHBPM);  
    VCMRMS = sqrt(sum(M22) / NVBPM);
        
    switch PlotType
    case 1
        hold on;
        plot(BPMData.HBPMGoodDataIndex, BPMRMSxx, '--r');
        hold off;
        axis tight
        legend('Full Data Set','Outliers Removed',0);
    case 2
        hold on;
        plot(CMData.HCMGoodDataIndex, HCMRMS, '--r');
        hold off;
        axis tight
        legend('Full Data Set','Outliers Removed',0);
    case 3
        hold on;
        plot(BPMData.VBPMGoodDataIndex, BPMRMSyy, '--r');
        hold off;
        axis tight
        legend('Full Data Set','Outliers Removed',0);
    case 4
        hold on;
        plot(CMData.VCMGoodDataIndex, VCMRMS, '--r');
        hold off;
        axis tight
        legend('Full Data Set','Outliers Removed',0);
    end
end
