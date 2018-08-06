function [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck(FileName)
%LOCOFILECHECK - Consistence check for the LOCO input file
%  [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck(FileName)
%            or
%  [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData})
%                                      
%  Checks the LOCO inputs and adds the defauls is inputs are missing.

%  Written by Greg Portmann


% Default parameters
Defaults_Lambda = .001;                 % For Levenberg-Marquardt method
Defaults_MaxIter = 10;                  % For Levenberg-Marquardt method
Defaults_Threshold = 1e-6;
Defaults_OutlierFactor = 5;
Defaults_HorizontalDispersionWeight = 1;
Defaults_VerticalDispersionWeight = 1;
Defaults_AutoCorrectDelta  = 'Yes';
Defaults_ResponseMatrixCalculator = 'Linear';          % 'Linear' or 'Full'
Defaults_ClosedOrbitType = 'FixedPathLength';          % 'FixedPathLength' or 'FixedMomentum';
Defaults_ResponseMatrixMeasurement = 'BiDirectional';  % 'OneWay' or 'BiDirectional'
Defaults_DispersionMeasurement     = 'BiDirectional';  % 'OneWay' or 'BiDirectional'  
Defaults_Normalize = 'Yes';
Defaults_Coupling ='No';
Defaults_Dispersion = 'Yes';
Defaults_FitHCMEnergyShift = 'No';
Defaults_FitVCMEnergyShift = 'No';
Defaults_FitRFFrequency = 'No';
Defaults_CMFitKicks  = 'Yes';
Defaults_CMFitCoupling = 'No';
Defaults_BPMFitGains = 'Yes';
Defaults_BPMFitCoupling = 'No';
Defaults_SinglePrecision = 'No';
Defaults_CalculateSigma = 'Yes';


if nargin == 0
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a LOCO input file');
    if FilterIndex == 0
        return;
    end
    FileName = [DirectoryName, FileName];
end


if iscell(FileName)
    BPMData       = FileName{1};
    CMData        = FileName{2};
    LocoMeasData  = FileName{3};
    LocoModel     = FileName{4};
    FitParameters = FileName{5};
    LocoFlags     = FileName{6};
    RINGData      = FileName{7};
elseif ischar(FileName)    
    try
        load(FileName);
    catch
        error('File does not exist or is not a *.mat file type.\n');
    end    
else
    error('Input problem');
end


% Make sure LocoModel exists (this is mainly for locogui)
if ~exist('LocoModel','var')
    LocoModel(length(CMData)) = struct('M',[], 'OutlierIndex',[], 'Eta',[], 'EtaOutlierIndex',[], 'ChiSquare',[]);
end
if isempty(LocoModel)
    clear LocoModel
    LocoModel(length(CMData)) = struct('M',[], 'OutlierIndex',[], 'Eta',[], 'EtaOutlierIndex',[], 'ChiSquare',[]);
end


% Make sure LocoFlags exists and is not empty
if ~exist('LocoFlags','var')
    LocoFlags.Threshold = Defaults_Threshold;
    % The rest will be created in the for loop
end
if isempty(LocoFlags)
    LocoFlags.Threshold = Defaults_Threshold;
    % The rest will be created in the for loop
end


% Make sure FitParameters exists and is not empty
if ~exist('FitParameters','var')
    FitParameters = [];
end
%if isempty(FitParameters)
%    FitParameters.Values = [];
%end


% Make sure CMData exists and is not empty
if ~exist('CMData','var')
    error('CMData must exist.');
end
if isempty(CMData)
    error('CMData can not be empty.');
end


% Make sure BPMData exists and is not empty
if ~exist('BPMData','var')
    error('BPMData must exist.');
end
if isempty(BPMData)
    error('BPMData can not be empty.');
end


% Measured data checks
if ~exist('LocoMeasData','var')
    error(' LocoMeasData variable does not exist.');
end  
if ~isfield(LocoMeasData, 'M');
    error('The response matrix (LocoMeasData.M) must exist.');
end
if isempty(LocoMeasData.M);
    error('The response matrix (LocoMeasData.M) must exist.');
end

if ~isfield(LocoMeasData, 'BPMSTD');
    error('The response matrix stardard deviations (LocoMeasData.BPMSTD) must exist.');
end
if isempty(LocoMeasData.BPMSTD);
    error('The response matrix stardard deviations (LocoMeasData.BPMSTD) must exist.');
end
LocoMeasData.BPMSTD = LocoMeasData.BPMSTD(:);

if ~isfield(LocoMeasData, 'DeltaRF');
    LocoMeasData.DeltaRF = [];
end
if isempty(LocoMeasData.DeltaRF);
    fprintf('   Measured delta RF (LocoMeasData.DeltaRF) does not exist.  It is required when using the fix momentum response matrix calculator and when including dispersion.\n');
end

if ~isfield(LocoMeasData, 'Eta');
    LocoMeasData.Eta = [];
end
if isempty(LocoMeasData.Eta);
    fprintf('   Measured dispersion (LocoMeasData.Eta) does not exist.  It is required when using the fix momentum response matrix calculator and when including dispersion.\n');
end
LocoMeasData.Eta = LocoMeasData.Eta(:);

if ~isfield(LocoMeasData, 'RF');
    LocoMeasData.RF = [];
end
if isempty(LocoMeasData.RF);
    fprintf('   Measured RF frequency (LocoMeasData.RF) does not exist.  It is required when using the fixed momentum response matrix calculator.\n');
end


% Check every iteration
for i = 1:length(CMData)
    
    % LocoFlags checks
    
    if ~isfield(LocoFlags(i),'Method') || ~isfield(LocoFlags(i).Method, 'Name')
        LocoFlags(i).Method.Name = 'Gauss-Newton';  % Backward compatible (LocoFlags(i).Method)
    else
        if isempty(LocoFlags(i).Method.Name)
            if ~isfield(FitParameters(i), 'Weight')
                LocoFlags(i).Method.Name =  'Gauss-Newton With Cost Function';
            else
                LocoFlags(i).Method.Name =  'Gauss-Newton';
            end
        end
    end
    if strcmpi(LocoFlags(i).Method.Name, 'Gradient')
        LocoFlags(i).Method.Name = 'Gauss-Newton'; % Backward compatible name change
    end
    if strcmpi(LocoFlags(i).Method.Name, 'Scalar Levenberg-Marquardt')
        LocoFlags(i).Method.Name = 'Scaled Levenberg-Marquardt'; % Temporary name change issue
    end
    if ~any(strcmpi(LocoFlags(i).Method.Name, {'Gauss-Newton','Gauss-Newton With Cost Function','Levenberg-Marquardt', 'Scaled Levenberg-Marquardt'}))
        error('LocoFlags.Method not defined properly.');
    end

    if isfield(LocoFlags(i), 'Method') && isfield(LocoFlags(i).Method, 'MaxIter') && LocoFlags(i).Method.MaxIter < 1
        LocoFlags(i).Method.MaxIter = 1;
    end
    
    if any(strcmpi(LocoFlags(i).Method.Name, {'Levenberg-Marquardt', 'Scaled Levenberg-Marquardt'}))
        if ~isfield(LocoFlags(i).Method, 'Lambda')
            LocoFlags(i).Method.Lambda = Defaults_Lambda;
        end
        if isempty(LocoFlags(i).Method.Lambda)
            LocoFlags(i).Method.Lambda = Defaults_Lambda;
        end
        if ~isfield(LocoFlags(i).Method, 'MaxIter')
            LocoFlags(i).Method.MaxIter = Defaults_MaxIter;
        end
        if isempty(LocoFlags(i).Method.MaxIter)
            LocoFlags(i).Method.MaxIter = Defaults_MaxIter;
        end
        LocoFlags(i).Method.MaxIter = ceil(LocoFlags(i).Method.MaxIter);
    end


    if ~isfield(LocoFlags(i), 'OutlierFactor') || isempty(LocoFlags(i).OutlierFactor)
        LocoFlags(i).OutlierFactor  = Defaults_OutlierFactor;
    end

    if ~isfield(LocoFlags(i), 'Threshold') || isempty(LocoFlags(i).Threshold)
        LocoFlags(i).Threshold  = Defaults_Threshold;
    end
    if ~isfield(LocoFlags(i), 'SVmethod')
        LocoFlags(i).SVmethod  = LocoFlags(i).Threshold;
    end
    
    if ~isfield(LocoFlags(i), 'HorizontalDispersionWeight') || isempty(LocoFlags(i).HorizontalDispersionWeight)
        LocoFlags(i).HorizontalDispersionWeight = Defaults_HorizontalDispersionWeight;
    end

    if ~isfield(LocoFlags(i), 'VerticalDispersionWeight') || isempty(LocoFlags(i).VerticalDispersionWeight)
        LocoFlags(i).VerticalDispersionWeight = Defaults_VerticalDispersionWeight;
    end
        
    if ~isfield(LocoFlags(i), 'AutoCorrectDelta') || isempty(LocoFlags(i).AutoCorrectDelta)
        LocoFlags(i).AutoCorrectDelta  = Defaults_AutoCorrectDelta;
    end
    
    if ~isfield(LocoFlags(i), 'Coupling') || isempty(LocoFlags(i).Coupling)
        LocoFlags(i).Coupling  = Defaults_Coupling;
    end
    
    % Normalization
    if isfield(LocoFlags(i), 'Normalize') && (~isfield(LocoFlags(i), 'Normalization') || ~isfield(LocoFlags(i).Normalization, 'Flag')) % To be backward compatible
        LocoFlags(i).Normalization.Flag = LocoFlags(i).Normalize;
    end
    if ~isfield(LocoFlags(i), 'Normalization') || ~isfield(LocoFlags(i).Normalization, 'Flag') || isempty(LocoFlags(i).Normalization.Flag)
        LocoFlags(i).Normalization.Flag = Defaults_Normalize;
    end
    
    if ~isfield(LocoFlags(i), 'Dispersion')|| isempty(LocoFlags(i).Dispersion)
        LocoFlags(i).Dispersion = Defaults_Dispersion;
    end
    
    if ~isfield(LocoFlags(i), 'ResponseMatrixCalculator')
        % First check old field name
        if isfield(LocoFlags(i), 'ResponseMatrixCalculatorFlag1')
            for j = 1:length(LocoFlags)
                LocoFlags(j).ResponseMatrixCalculator = LocoFlags(j).ResponseMatrixCalculatorFlag1;
            end
        else
            LocoFlags(i).ResponseMatrixCalculator = Defaults_ResponseMatrixCalculator;
        end
    end
    if isempty(LocoFlags(i).ResponseMatrixCalculator)
        LocoFlags(i).ResponseMatrixCalculator = Defaults_ResponseMatrixCalculator;
    end
    
    if ~isfield(LocoFlags(i), 'ClosedOrbitType')
        % First check old field name
        if isfield(LocoFlags(i), 'ResponseMatrixCalculatorFlag2')
            for j = 1:length(LocoFlags)
                LocoFlags(j).ClosedOrbitType = LocoFlags(j).ResponseMatrixCalculatorFlag2;
            end
        else
            LocoFlags(i).ClosedOrbitType = Defaults_ClosedOrbitType;
        end
    end
    if isempty(LocoFlags(i).ClosedOrbitType)
        LocoFlags(i).ClosedOrbitType = Defaults_ClosedOrbitType;
    end
    
    if ~isfield(LocoFlags(i), 'ResponseMatrixMeasurement')
        LocoFlags(i).ResponseMatrixMeasurement = Defaults_ResponseMatrixMeasurement;
    end
    if isempty(LocoFlags(i).ResponseMatrixMeasurement)
        LocoFlags(i).ResponseMatrixMeasurement = Defaults_ResponseMatrixMeasurement;
    end
    
    if ~isfield(LocoFlags(i), 'DispersionMeasurement')
        LocoFlags(i).DispersionMeasurement = Defaults_DispersionMeasurement;
    end
    if isempty(LocoFlags(i).DispersionMeasurement)
        LocoFlags(i).DispersionMeasurement = Defaults_DispersionMeasurement;
    end

    if ~isfield(LocoFlags(i), 'SinglePrecision')
        LocoFlags(i).SinglePrecision = Defaults_SinglePrecision;
    end
    if isempty(LocoFlags(i).SinglePrecision)
        LocoFlags(i).SinglePrecision = Defaults_SinglePrecision;
    end

    if ~isfield(LocoFlags(i), 'CalculateSigma')
        LocoFlags(i).CalculateSigma = Defaults_CalculateSigma;
    end
    if isempty(LocoFlags(i).CalculateSigma)
        LocoFlags(i).CalculateSigma = Defaults_CalculateSigma;
    end

    if ~isfield(LocoFlags(i), 'SVDDataFileName')
        LocoFlags(i).SVDDataFileName = '';
    end
    if isempty(LocoFlags(i).SVDDataFileName)
        LocoFlags(i).SVDDataFileName = '';
    end

    if ~isfield(CMData(i), 'FitHCMEnergyShift')
        CMData(i).FitHCMEnergyShift = Defaults_FitHCMEnergyShift;
    end
    if isempty(CMData(i).FitHCMEnergyShift)
        CMData(i).FitHCMEnergyShift = Defaults_FitHCMEnergyShift;
    end

    if ~isfield(CMData(i), 'FitVCMEnergyShift')
        CMData(i).FitVCMEnergyShift = Defaults_FitVCMEnergyShift;
    end
    if isempty(CMData(i).FitHCMEnergyShift)
        CMData(i).FitVCMEnergyShift = Defaults_FitVCMEnergyShift;
    end


    % FitParameters checks
    if ~isempty(FitParameters)
        % Only check the FitParameters if the whole thing is not empty
        if ~isfield(FitParameters(i), 'Values')
            %error('FitParameters.Values must exist.');
            FitParameters(i).Values = [];
        else
            % Column vector
            FitParameters(i).Values = FitParameters(i).Values(:);
        end
        %if isempty(FitParameters(i).Values)
        %    error('FitParameters.Values cannot be empty.');
        %end

        if ~isfield(FitParameters(i),'ValuesSTD')
            FitParameters(i).ValuesSTD = [];
        end

        if ~isfield(FitParameters(i), 'Deltas')
            FitParameters(i).Deltas = NaN * ones(size(FitParameters(i).Values));
        else
            % Column vector
            FitParameters(i).Deltas = FitParameters(i).Deltas(:);
        end
        if isempty(FitParameters(i).Deltas)
            FitParameters(i).Deltas = NaN * ones(size(FitParameters(i).Values));
        end

        if ~isfield(FitParameters(i), 'Params')
            FitParameters(i).Params = NaN * ones(size(FitParameters(i).Values));
        end
        if isempty(FitParameters(i).Params)
            FitParameters(i).Params = NaN * ones(size(FitParameters(i).Values));
        end

        if ~isfield(FitParameters(i), 'FitRFFrequency')
            FitParameters(i).FitRFFrequency  = Defaults_FitRFFrequency;
        end
        if isempty(FitParameters(i).FitRFFrequency)
            FitParameters(i).FitRFFrequency  = Defaults_FitRFFrequency;
        end

        if ~isfield(FitParameters(i), 'DeltaRF')
            %error('Model delta RF (FitParameters.DeltaRF) needs to exist.');
            %FitParameters(i).DeltaRF = NaN;
            FitParameters.DeltaRF = LocoMeasData.DeltaRF;
            fprintf('   The model delta RF (FitParameters.DeltaRF) does not exist so it is being set to LocoMeasData.DeltaRF.\n');
        else
            if isempty(FitParameters(i).DeltaRF)
                %error('Model delta RF (FitParameters.DeltaRF) needs to exist.');
                %FitParameters(i).DeltaRF = NaN;
                FitParameters.DeltaRF = LocoMeasData.DeltaRF;
                fprintf('   The model delta RF (FitParameters.DeltaRF) does not exist so it is being set to LocoMeasData.DeltaRF.\n');
            end
        end
        if isempty(FitParameters(i).DeltaRF);
            fprintf('   FitParameter.DeltaRF is empty so don''t use anything that requires dispersion.\n');
        end

        if ~isfield(FitParameters(i),'DeltaRFSTD')
            FitParameters(i).DeltaRFSTD = [];
        end
        
        % Add a place holder for Chi2
        if ~isfield(FitParameters(i),'Chi2')
            FitParameters(i).Chi2 = [];
        end
        
        % Vector length checks
        if length(FitParameters(i).Params) ~= length(FitParameters(i).Values)
            fprintf('   The number of fit parameters (FitParameters(%d).Params) must equal the number of\n', i);
            fprintf('   fit values (FitParameters(%d).Values).\n', i);
            error(' ');
        end
        if length(FitParameters(i).Params) ~= length(FitParameters(i).Deltas)
            fprintf('   The number of fit parameters (FitParameters(%d).Params) must equal the number fit\n', i);
            fprintf('   deltas (FitParameters(%d).LocoDeltas).  Or leave LocoDeltas field blank.\n', i);
            error(' ');
        end
        
        % FitParameters.Weight & FitParameters.Cost moved to LocoFlags(i).Method.Cost.FitParameters
        if isfield(FitParameters(i),'Weight') && isfield(FitParameters(i).Weight,'Value') && ~isempty(FitParameters(i).Weight.Value)
            MeanMstd = mean(LocoMeasData.BPMSTD) / 1000;  % Since LOCO is meters internally
            for j = 1:length(FitParameters(i).Weight.Value)
                LocoFlags(i).Method.Cost.FitParameters(j,1) = FitParameters(i).Weight.Value{j}/MeanMstd;
            end
        end
        if isfield(FitParameters(i),'Cost') && isfield(FitParameters(i).Cost,'Values') && ~isempty(FitParameters(i).Cost.Values)
            LocoFlags(i).Method.Cost.FitParameters = FitParameters(i).Cost.Values(:);
        end
    end


    % BPMData checks
    %if ~isfield(BPMData(i), 'FamName')
    %    error('BPMData field FamName must exist.');
    %end    
    %if isempty(BPMData(i).FamName)
    %    error('BPMData field FamName must exist.');
    %end
    
    if ~isfield(BPMData(i), 'HBPMIndex')
        error('BPMData field HBPMIndex must exist.');
    end
    if isempty(BPMData(i).HBPMIndex)
        error('BPMData field HBPMIndex must exist.');
    end
    BPMData(i).HBPMIndex = BPMData(i).HBPMIndex(:);
    
    if ~isfield(BPMData(i), 'VBPMIndex')
        error('BPMData field VBPMIndex must exist.');
    end
    if isempty(BPMData(i).VBPMIndex)
        error('BPMData field VBPMIndex must exist.');
    end
    BPMData(i).VBPMIndex = BPMData(i).VBPMIndex(:);

    if ~isfield(BPMData(i), 'FitGains')
        BPMData(i).FitGains = Defaults_BPMFitGains;
    end
    if isempty(BPMData(i).FitGains)
        BPMData(i).FitGains = Defaults_BPMFitGains;
    end
    if ~isfield(BPMData(i), 'FitCoupling')
        BPMData(i).FitCoupling = Defaults_BPMFitCoupling;
    end
    if isempty(BPMData(i).FitCoupling)
        BPMData(i).FitCoupling = Defaults_BPMFitCoupling;
    end
    
    if ~isfield(BPMData(i), 'HBPMGoodDataIndex')
        BPMData(i).HBPMGoodDataIndex = 1:length(BPMData(i).HBPMIndex);
    end
    BPMData(i).HBPMGoodDataIndex = BPMData(i).HBPMGoodDataIndex(:)';
    
    if ~isfield(BPMData(i), 'VBPMGoodDataIndex')
        BPMData(i).VBPMGoodDataIndex = 1:length(BPMData(i).VBPMIndex);
    end
    BPMData(i).VBPMGoodDataIndex = BPMData(i).VBPMGoodDataIndex(:)';

    if ~isfield(BPMData(i),'HBPMGain')
        BPMData(i).HBPMGain = ones(length(BPMData(i).HBPMIndex),1);
    end
    if isempty(BPMData(i).HBPMGain)
        BPMData(i).HBPMGain = ones(length(BPMData(i).HBPMIndex),1);
    end
    BPMData(i).HBPMGain = BPMData(i).HBPMGain(:);
    
    if ~isfield(BPMData(i),'VBPMGain')
        BPMData(i).VBPMGain = ones(length(BPMData(i).VBPMIndex),1);
    end
    if isempty(BPMData(i).VBPMGain)
        BPMData(i).VBPMGain = ones(length(BPMData(i).VBPMIndex),1);
    end
    BPMData(i).VBPMGain = BPMData(i).VBPMGain(:);
    
    if ~isfield(BPMData(i),'HBPMGainSTD')
        BPMData(i).HBPMGainSTD = NaN * ones(length(BPMData(i).HBPMIndex),1);
    end
    if isempty(BPMData(i).HBPMGainSTD)
        BPMData(i).HBPMGainSTD = NaN * ones(length(BPMData(i).HBPMIndex),1);
    end
    BPMData(i).HBPMGainSTD = BPMData(i).HBPMGainSTD(:);
    
    if ~isfield(BPMData(i),'VBPMGainSTD')
        BPMData(i).VBPMGainSTD = NaN * ones(length(BPMData(i).VBPMIndex),1);
    end
    if isempty(BPMData(i).VBPMGainSTD)
        BPMData(i).VBPMGainSTD = NaN * ones(length(BPMData(i).VBPMIndex),1);
    end
    BPMData(i).VBPMGainSTD = BPMData(i).VBPMGainSTD(:);

    if ~isfield(BPMData(i),'HBPMCoupling')
        BPMData(i).HBPMCoupling = zeros(length(BPMData(i).HBPMIndex),1);
    end
    if isempty(BPMData(i).HBPMCoupling)
        BPMData(i).HBPMCoupling = zeros(length(BPMData(i).HBPMIndex),1);
    end
    BPMData(i).HBPMCoupling = BPMData(i).HBPMCoupling(:);
    
    if ~isfield(BPMData(i),'VBPMCoupling')
        BPMData(i).VBPMCoupling = zeros(length(BPMData(i).VBPMIndex),1);
    end
    if isempty(BPMData(i).VBPMCoupling)
        BPMData(i).VBPMCoupling = zeros(length(BPMData(i).VBPMIndex),1);
    end
    BPMData(i).VBPMCoupling = BPMData(i).VBPMCoupling(:);

    if ~isfield(BPMData(i),'HBPMCouplingSTD')
        BPMData(i).HBPMCouplingSTD = NaN * ones(length(BPMData(i).HBPMIndex),1);
    end
    if isempty(BPMData(i).HBPMCouplingSTD)
        BPMData(i).HBPMCouplingSTD = NaN * ones(length(BPMData(i).HBPMIndex),1);
    end
    BPMData(i).HBPMCouplingSTD = BPMData(i).HBPMCouplingSTD(:);

    if ~isfield(BPMData(i),'VBPMCouplingSTD')
        BPMData(i).VBPMCouplingSTD = NaN * ones(length(BPMData(i).VBPMIndex),1);
    end
    if isempty(BPMData(i).VBPMCouplingSTD)
        BPMData(i).VBPMCouplingSTD = NaN * ones(length(BPMData(i).VBPMIndex),1);
    end
    BPMData(i).VBPMCouplingSTD = BPMData(i).VBPMCouplingSTD(:);
    
    if ~isfield(BPMData(i),'Cost')
        BPMData(i).Cost = [];
    end

    
    % CMData checks
    %if ~isfield(CMData(i), 'FamName')
    %    error('CMData field FamName must exist.');
    %end    
    %if isempty(CMData(i).FamName)
    %    error('CMData field FamName must exist.');
    %end   
        
    if ~isfield(CMData(i), 'HCMIndex')
        error('CMData field HCMIndex must exist.');
    end
    if isempty(CMData(i).HCMIndex)
        error('CMData field HCMIndex must exist.');
    end
    CMData(i).HCMIndex = CMData(i).HCMIndex(:);

    if ~isfield(CMData(i), 'VCMIndex')
        error('CMData field VCMIndex must exist.');
    end
    if isempty(CMData(i).VCMIndex)
        error('CMData field VCMIndex must exist.');
    end
    CMData(i).VCMIndex = CMData(i).VCMIndex(:);
    
    if ~isfield(CMData(i), 'HCMGoodDataIndex')
        CMData(i).HCMGoodDataIndex = 1:length(CMData(i).HCMIndex);
    end
    if isempty(CMData(i).HCMGoodDataIndex)
        fprintf('   CMData(%d).HCMGoodDataIndex is empty (ie, no horizonal correctors are being used)\n',i);
    end
    CMData(i).HCMGoodDataIndex = CMData(i).HCMGoodDataIndex(:)';
    
    if ~isfield(CMData(i), 'VCMGoodDataIndex')
        CMData(i).VCMGoodDataIndex = 1:length(CMData(i).VCMIndex);
    end
    if isempty(CMData(i).VCMGoodDataIndex)
        fprintf('   CMData(%d).VCMGoodDataIndex is empty (ie, no vertical correctors are being used)\n',i);
    end
    CMData(i).VCMGoodDataIndex = CMData(i).VCMGoodDataIndex(:)';
    
    if ~isfield(CMData(i), 'FitKicks')
        CMData(i).FitKicks  = Defaults_CMFitKicks;
    end
    if isempty(CMData(i).FitKicks)
        CMData(i).FitKicks  = Defaults_CMFitKicks;
    end

    if ~isfield(CMData(i), 'FitCoupling')
        CMData(i).FitCoupling  = Defaults_CMFitCoupling;
    end 
    if isempty(CMData(i).FitCoupling)
        CMData(i).FitCoupling  = Defaults_CMFitCoupling;
    end 

    if ~isfield(CMData(i),'HCMKicks')
        CMData(i).HCMKicks = ones(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMKicks)
        CMData(i).HCMKicks = ones(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMKicks = CMData(i).HCMKicks(:);

    if ~isfield(CMData(i),'VCMKicks')
        CMData(i).VCMKicks = ones(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).VCMKicks)
        CMData(i).VCMKicks = ones(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMKicks = CMData(i).VCMKicks(:);
    
    if ~isfield(CMData(i),'HCMEnergyShift')
        CMData(i).HCMEnergyShift = zeros(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMEnergyShift)
        CMData(i).HCMEnergyShift = zeros(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMEnergyShift = CMData(i).HCMEnergyShift(:);
    
    if ~isfield(CMData(i),'VCMEnergyShift')
        CMData(i).VCMEnergyShift = zeros(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).VCMEnergyShift)
        CMData(i).VCMEnergyShift = zeros(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMEnergyShift = CMData(i).VCMEnergyShift(:);

    if ~isfield(CMData(i),'HCMEnergyShiftSTD')
        CMData(i).HCMEnergyShiftSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMEnergyShiftSTD)
        CMData(i).HCMEnergyShiftSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMEnergyShiftSTD = CMData(i).HCMEnergyShiftSTD(:);

    if ~isfield(CMData(i),'VCMEnergyShiftSTD')
        CMData(i).VCMEnergyShiftSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).HCMEnergyShiftSTD)
        CMData(i).VCMEnergyShiftSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMEnergyShiftSTD = CMData(i).VCMEnergyShiftSTD(:);

    if ~isfield(CMData(i),'HCMCoupling')
        CMData(i).HCMCoupling = zeros(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMCoupling)
        CMData(i).HCMCoupling = zeros(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMCoupling = CMData(i).HCMCoupling(:);

    if ~isfield(CMData(i),'VCMCoupling')
        CMData(i).VCMCoupling = zeros(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).VCMCoupling)
        CMData(i).VCMCoupling = zeros(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMCoupling = CMData(i).VCMCoupling(:);

    if ~isfield(CMData(i),'HCMKicksSTD')
        CMData(i).HCMKicksSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMKicksSTD)
        CMData(i).HCMKicksSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMKicksSTD =CMData(i).HCMKicksSTD(:);

    if ~isfield(CMData(i),'VCMKicksSTD')
        CMData(i).VCMKicksSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).VCMKicksSTD)
        CMData(i).VCMKicksSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMKicksSTD =CMData(i).VCMKicksSTD(:);

    if ~isfield(CMData(i),'HCMCouplingSTD')
        CMData(i).HCMCouplingSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    if isempty(CMData(i).HCMCouplingSTD)
        CMData(i).HCMCouplingSTD = NaN * ones(length(CMData(i).HCMIndex),1);
    end
    CMData(i).HCMCouplingSTD = CMData(i).HCMCouplingSTD(:);
    
    if ~isfield(CMData(i),'VCMCouplingSTD')
        CMData(i).VCMCouplingSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    if isempty(CMData(i).VCMCouplingSTD)
        CMData(i).VCMCouplingSTD = NaN * ones(length(CMData(i).VCMIndex),1);
    end
    CMData(i).VCMCouplingSTD = CMData(i).VCMCouplingSTD(:);
    
    if ~isfield(CMData(i),'Cost')
        CMData(i).Cost = [];
    end

        
    % LocoModel checks
    if ~isfield(LocoModel(i),'M')
        LocoModel(i).M = [];
    end
    
    if ~isfield(LocoModel(i),'Eta')
        LocoModel(i).Eta = [];
    end
    LocoModel(i).Eta = LocoModel(i).Eta(:);

    % LocoModel.SValues moved to LocoFlags.Method
    if isfield(LocoModel(i),'SValues')
        LocoFlags(i).Method.SV = LocoModel(i).SValues;
    end
    if isfield(LocoModel(i),'SValuesIndex')
        LocoFlags(i).Method.SVIndex = LocoModel(i).SValuesIndex;
    end
    
    if ~isfield(LocoModel(i),'OutlierIndex')
        LocoModel(i).OutlierIndex = [];
    end
    
    if ~isfield(LocoModel(i),'EtaOutlierIndex')
        LocoModel(i).EtaOutlierIndex = [];
    end
    
    if ~isfield(LocoModel(i),'ChiSquare')
        LocoModel(i).ChiSquare = [];
    end
    
     
    % Checks response matrix size
    if size(LocoMeasData.M,1) ~= length(BPMData(i).HBPMIndex)+length(BPMData(i).VBPMIndex) 
        fprintf('\n   LocoMeasData.M is size %d x %d\n', size(LocoMeasData.M)) 
        fprintf('   NHBPM + NVBPM = %d + %d = %d\n', length(BPMData(i).HBPMIndex), length(BPMData(i).VBPMIndex), length(BPMData(i).HBPMIndex)+length(BPMData(i).VBPMIndex));
        fprintf('   NHCM  +  NVCM = %d + %d = %d\n', length(CMData(i).HCMIndex), length(CMData(i).VCMIndex), length(CMData(i).HCMIndex)+length(CMData(i).VCMIndex));
        fprintf('   The number of rows in the response matrix (LocoMeasData.M) must equal the\n');
        fprintf('   number of BPMs in BPMData(%d) (length(BPMData.HBPMIndex)+length(BPMData.VBPMIndex))\n', i);
        fprintf('   NOTE: the HBPMGoodDataIndex, VBPMGoodDataIndex, HCMGoodDataIndex, VCMGoodDataIndex do not matter.\n\n');
        error(' ');
    end
    
    if size(LocoMeasData.M,2) ~= length(CMData(i).HCMIndex)+length(CMData(i).VCMIndex) 
        fprintf('\n   LocoMeasData.M is size %d x %d\n', size(LocoMeasData.M)) 
        fprintf('   NHBPM + NVBPM = %d + %d = %d\n', length(BPMData(i).HBPMIndex), length(BPMData(i).VBPMIndex), length(BPMData(i).HBPMIndex)+length(BPMData(i).VBPMIndex));
        fprintf('   NHCM  +  NVCM = %d + %d = %d\n', length(CMData(i).HCMIndex), length(CMData(i).VCMIndex), length(CMData(i).HCMIndex)+length(CMData(i).VCMIndex));
        fprintf('   The number of columns in the response matrix (LocoMeasData.M) must equal the\n');
        fprintf('   number of correctors in CMData(%d) (length(CMData.HCMIndex)+length(CMData.VCMIndex))\n', i);
        fprintf('   NOTE: the HBPMGoodDataIndex, VBPMGoodDataIndex, HCMGoodDataIndex, VCMGoodDataIndex do not matter.\n\n');
        error(' ');
    end
       
    
    % Checks to add:
    % 1.  yes/no questions must be a yes or no answer
    % 2.  Indexing in the vectors must be in range
    
end


% LocoModel.Normalize moved to LocoFlags.Normalization.Flag
if isfield(LocoFlags,'Normalize')
    LocoFlags = rmfield(LocoFlags,'Normalize');
end

% LocoModel.SValues moved to LocoFlags.Method
if isfield(LocoModel,'SValues')
    LocoModel = rmfield(LocoModel,'SValues');
end
if isfield(LocoModel,'SValuesIndex')
    LocoModel = rmfield(LocoModel,'SValuesIndex');
end

% FitParameters.Weight & FitParameters.Cost moved to LocoFlags(i).Method.Cost.FitParameters
if isfield(FitParameters,'Weight')
    FitParameters = rmfield(FitParameters,'Weight');
end
if isfield(FitParameters,'Cost')
    FitParameters = rmfield(FitParameters,'Cost');
end


% BPMSTD cannot be zero (only check good BPMs)
%i = find(LocoMeasData.BPMSTD == 0);
% Index = [BPMData.HBPMGoodDataIndex BPMData.VBPMGoodDataIndex]; 
% i = find(LocoMeasData.BPMSTD(Index) == 0); 
% if ~isempty(i);
%     fprintf('   %d of BPM standard deviations (LocoMeasData.BPMSTD) are zero.\n',length(i));
% end


try
    iBPM = 1:size(LocoMeasData.HBPM.DeviceList,1);
    iBPM = iBPM(BPMData(end).HBPMGoodDataIndex);
    i = find(LocoMeasData.BPMSTD(iBPM) == 0);
    if ~isempty(i);
        if length(i) < 15
            for j = 1:length(i)
                fprintf('   Zero standard deviation in horizontal BPM %d or device [%d,%d]  (LocoMeasData.BPMSTD)\n', iBPM(i(j)), LocoMeasData.HBPM.DeviceList(iBPM(i(j)),:));
            end
        else
            fprintf('   %d of the horizontal BPM standard deviations (LocoMeasData.BPMSTD) are zero.\n', length(i));
        end
        
        % Remove from the good data index
        fprintf('   %d horizontal BPM removed from the HBPMGoodDataIndex.\n\n', length(i));
        iBPM = (1:size(LocoMeasData.HBPM.DeviceList,1))';
        i = find(LocoMeasData.BPMSTD(iBPM) == 0);
        k = findrowindex(i, BPMData(end).HBPMGoodDataIndex(:));
        BPMData(end).HBPMGoodDataIndex(k) = [];
    end

    NHBPM = size(LocoMeasData.HBPM.DeviceList,1);
    iBPM = NHBPM + (1:size(LocoMeasData.VBPM.DeviceList,1));
    iBPM = iBPM(BPMData(end).VBPMGoodDataIndex);
    i = find(LocoMeasData.BPMSTD(iBPM) == 0);
    if ~isempty(i);
        if length(i) < 15
            for j = 1:length(i)
                fprintf('   Zero standard deviation in vertical BPM %d or device [%d,%d]  (LocoMeasData.BPMSTD)\n', iBPM(i(j))-NHBPM, LocoMeasData.VBPM.DeviceList(iBPM(i(j))-NHBPM,:));
            end
        else
            fprintf('   %d of the vertical BPM standard deviations (LocoMeasData.BPMSTD) are zero.\n', length(i));
        end

        % Remove from the good data index
        fprintf('   %d vertical BPM removed from the VBPMGoodDataIndex.\n\n', length(i));
        iBPM = NHBPM + (1:size(LocoMeasData.VBPM.DeviceList,1))';
        i = find(LocoMeasData.BPMSTD(iBPM) == 0);
        k = findrowindex(i, BPMData(end).VBPMGoodDataIndex(:));
        BPMData(end).VBPMGoodDataIndex(k) = [];
    end
catch
    i = find(LocoMeasData.BPMSTD == 0);
    if ~isempty(i);
        fprintf('   %d BPM standard deviations (LocoMeasData.BPMSTD) are zero.\n   A problem occurred trying to remove them.\n', length(i));
    end
end


% Remove old variable names
if isfield(LocoFlags, 'ResponseMatrixCalculatorFlag1')
    LocoFlags = rmfield(LocoFlags,'ResponseMatrixCalculatorFlag1');
end
if isfield(LocoFlags, 'ResponseMatrixCalculatorFlag2')
    LocoFlags = rmfield(LocoFlags,'ResponseMatrixCalculatorFlag2');
end


% Save
if ischar(FileName)
    pause(.1);
    save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
end
