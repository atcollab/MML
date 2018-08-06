function varargout = locodata(FileName, IterationNumber, varargin)
%LOCODATA - Extracts data from a LOCO file
% Data = locodata(FileName, IterationNumber, DataType, Source)
% [Data1, Data2, ... ] = locodata(FileName, IterationNumber, DataType1, Source1, DataType2, Source2, ...)
%
% or FileName can be replaced with the cell: {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}
%
% IterationNumber = 0,1,2, ...
%
% DataType:  'RINGData'
%            'ATModel' or 'THERING'  = the AT lattice cell array (typically called THERING)
%            'RF'                    = RF frequency in the model        'Meas' or 'Model'
%            'DeltaRF'               = Change in RF for dispersion measurement
%            'FitDeltaRF'            = Fit change in RF for dispersion measurement
%            'HarmonicNumber'        = Harmonic number in the model
%
%            'ResponseMatrix'        = Response matrix [mm]             'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift'
%            'ResponseMatrixXX'      = Response matrix (HCM to HBPM)    'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift'
%            'ResponseMatrixXY'      = Response matrix (VCM to HBPM)    'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift'
%            'ResponseMatrixYX'      = Response matrix (HCM to VBPM)    'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift'
%            'ResponseMatrixYY'      = Response matrix (VCM to VBPM)    'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift'
%
%            'Eta'                   = Dispersion function              'Meas' or 'Model'
%            'EtaX'                  = Dispersion function (horizontal) 'Meas' or 'Model'
%            'EtaY'                  = Dispersion function (vertical)   'Meas' or 'Model'
%
%            'BPMstd'                = Measured BPM errors
%            'HBPMstd'               = Measured BPM errors (horizontal)
%            'VBPMstd'               = Measured BPM errors (vertical)
%
%            'HBPMgain'
%            'HBPMgainstd'
%            'VBPMgain'
%            'VBPMgainstd'
%
%            'HBPMcoupling'
%            'HBPMcouplingstd'
%            'VBPMcoupling'
%            'VBPMcouplingstd'
%
%            'HCMkick'
%            'HCMkickstd'
%            'VCMkick'
%            'VCMkickstd'
%
%            'HCMcoupling'
%            'HCMcouplingstd'
%            'VCMcoupling'
%            'VCMcouplingstd'
%
%            'HCMenergyshift'
%            'HCMenergyshiftstd'
%            'VCMenergyshift'
%            'VCMenergyshiftstd'
%
%            'FitValues'
%            'FitValuesstd'
%            'FitValuesDeltas'
%            'FitDeltaRF'
%            'FitDeltaRFstd'
%
%            'ChiSquare'             = Chi squared for the fit
%            'ErrorDistribution'     = (Measured - Model) response matrix error / standard deviation of the BPMs 
%            'OutlierIndex'          = Index of outliers for the response matrix part of the merit function 
%            'OutlierMatrix'         = Matrix of size(response matrix) with outliers marked with ones 
%            'EtaOutlierIndex'       = Index of the outliers for the dispersion part of the merit function
%
%            'Tune'                  = Tune vector
%            'Beta'                  = Beta at all BPMs  [Position, HBeta, VBeta]
%            'HBeta'                 = Beta at horizontal BPMs
%            'VBeta'                 = Beta at vertical   BPMs
%
% Source = extra arguments, like 'Meas', 'Model', 'Model+EnergyShift', or 'Meas-EnergyShift' (not always required) (default: 'Meas')
%          Note: for multiple outputs, the source field must exist even if it is not used.
%
% Note 1: DataType and Source are not case sensitive
% Note 2: Each call to locodata requires a file load so it is best to all data will one call
%
% Written by Greg Portmann


if nargin < 3
    error('Requires at least 3 inputs (see help locodata).');
end

if isempty(FileName)
    return
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
        fprintf('   File does not exist or is not a *.mat file type.\n');
        for i = 1:nargout
            varargout{i} = [];
        end
        return
    end
else
    error('Input problem');
end


% Find the right iteration
if length(BPMData) > 1
    IterationNumber = IterationNumber + 1;
    if IterationNumber > length(BPMData)
        error('IterationNumber great than the number of iterations');
    end
    BPMData = BPMData(IterationNumber);
    CMData = CMData(IterationNumber);
    LocoModel = LocoModel(IterationNumber);
    LocoFlags = LocoFlags(IterationNumber);
    FitParameters = FitParameters(IterationNumber);
end


NHBPM = length(BPMData.HBPMGoodDataIndex);
NVBPM = length(BPMData.VBPMGoodDataIndex);
NBPM  = NHBPM + NVBPM;
NHCM = length(CMData.HCMGoodDataIndex);
NVCM = length(CMData.VCMGoodDataIndex);

for i = 1:ceil(length(varargin)/2)
    
    DataType = lower(varargin{2*i-1});
    if length(varargin) >= 2*i
        Source = lower(varargin{2*i});
    else
        Source = 'meas';
    end
    
    switch DataType
        
        case 'ringdata'
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            Data = RINGData;
            
        case {'atmodel','thering'}
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            Data = RINGData.Lattice;
            
        case {'atmodelglobal'}
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            global THERING
            THERING = RINGData.Lattice;

            % To be compatible with the middle layer look for a updateatindex function
            if exist('updateatindex') == 2 && ~isempty(getappdata(0, 'AcceleratorObjects'))
                fprintf('   Running updateatindex to sync the middlelayer with THERING\n');
                fprintf('   The middlelayer energy might need to be set with setenergymodel(GeV).\n');
                updateatindex;
            end

            if ceil(length(varargin)/2) == 1
                return
            else
                Data =[];
            end      
                        
        case 'rf'
            if strcmpi(Source, 'meas')
                Data = LocoMeasData.RF;
            elseif strcmpi(Source, 'model')
                Data = RINGData.CavityFrequency;
            else
                fprintf('   DataType=RF, Source is unknown\n');
                Data = [];
            end
            
        case 'deltarf'
            Data = LocoMeasData.DeltaRF;
            
        case 'harmonicnumber'
            Data = RINGData.CavityHarmNumber;

        case {'responsematrix','responsematrixxx','responsematrixxy','responsematrixyx','responsematrixyy','responsematrixperkick','responsematrixxxperkick','responsematrixxyperkick','responsematrixyxperkick','responsematrixyyperkick'}
            
            if any(strcmpi(Source, {'meas','meas-energyshift'}))
                %if strcmp(lower(LocoFlags.ClosedOrbitType), 'fixedmomentum')
                %    Source = 'meas+energyshift';
                %else
                %    Source = 'meas';
                %end
                
                % Measured response matrix
                M = LocoMeasData.M([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 
                
                % Divide by the corrector current [mm/Amps]
                %for iBPM = 1:size(M,1)
                %    M(iBPM,:) = M(iBPM,:) ./ LocoMeasData.DeltaAmps(:)';
                %end

                % Convert to mm/milliradian or meter/radian
                if findstr(DataType,'perkick')
                    % Divide by the magnitude of the kick
                    %TotalKick = CMData.HCMKicks;
                    TotalKick = sign(CMData.HCMKicks) .* sqrt(CMData.HCMKicks.^2 + (CMData.HCMKicks.*CMData.HCMCoupling).^2);                   
                    for iloop = 1:length(CMData.HCMKicks)
                        M(:,iloop) = M(:,iloop) / TotalKick(iloop);
                    end

                    %TotalKick = CMData.VCMKicks;
                    TotalKick = sign(CMData.VCMKicks) .* sqrt(CMData.VCMKicks.^2 + (CMData.VCMKicks.*CMData.VCMCoupling).^2);
                    for iloop = 1:length(CMData.VCMKicks)
                        M(:,length(CMData.HCMKicks)+iloop) = M(:,length(CMData.HCMKicks)+iloop) / TotalKick(iloop);
                    end
                end
                
                if strcmpi(Source, 'meas-energyshift')
                    % Change measured by subtracting dispersion proportional to the energy shifts
                    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
                    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
                    
                    % Set the lattice model
                    for j = 1:length(FitParameters.Params)
                        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
                    end
                    
                    AlphaMCF = locomcf(RINGData);
                    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                    
                    for j = 1:length(HCMEnergyShift)
                        M(:,j) = M(:,j) - HCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                    end
                    
                    for j = 1:length(VCMEnergyShift)
                        M(:,NHCM+j) = M(:,NHCM+j) - VCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                    end
                end
            else
                % Model response matrix
                
                %if strcmp(lower(LocoFlags.ClosedOrbitType), 'fixedmomentum')
                %    Source = 'meas-energyshift';
                %else
                %    Source = 'meas';
                %end
                
                if isempty(LocoModel.M)
                    fprintf('   No model response matrix available.\n');
                    Data = [];
                end
                
                M = LocoModel.M;
                
                
                % Divide by the corrector current [mm/Amps]
                %if strcmpi(varargin{end},'mm/Amp')
                %    for iBPM = 1:size(M,1)
                %        M(iBPM,:) = M(iBPM,:) ./ LocoMeasData.DeltaAmps(:)';
                %    end
                %end

                % Convert to mm/milliradian or meter/radian
                if findstr(DataType,'perkick')
                    % Divide by the magnitude of the kick
                    %TotalKick = CMData.HCMKicks;
                    TotalKick = sign(CMData.HCMKicks) .* sqrt(CMData.HCMKicks.^2 + (CMData.HCMKicks.*CMData.HCMCoupling).^2);
                    for iloop = 1:length(CMData.HCMKicks)
                        M(:,iloop) = M(:,iloop) / TotalKick(iloop);
                    end

                    %TotalKick = CMData.VCMKicks;
                    TotalKick = sign(CMData.VCMKicks) .* sqrt(CMData.VCMKicks.^2 + (CMData.VCMKicks.*CMData.VCMCoupling).^2);
                    for iloop = 1:length(CMData.VCMKicks)
                        M(:,length(CMData.HCMKicks)+iloop) = M(:,length(CMData.HCMKicks)+iloop) / TotalKick(iloop);
                    end
                end
                
                if strcmpi(Source, 'model+energyshift')
                    % Change model by adding dispersion proportional to the energy shifts
                    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
                    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
                    
                    % Set the lattice model
                    for j = 1:length(FitParameters.Params)
                        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
                    end

                    AlphaMCF = locomcf(RINGData);
                    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                    
                    for j = 1:length(HCMEnergyShift)
                        M(:,j) = M(:,j) + HCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                    end
                    
                    for j = 1:length(VCMEnergyShift)
                        M(:,NHCM+j) = M(:,NHCM+j) + VCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                    end
                end
            end
            
            if any(strcmpi(DataType, {'responsematrixxx', 'responsematrixxxperkick'}))
                Data = M([1:NHBPM], [1:NHCM]); 
            elseif any(strcmpi(DataType, {'responsematrixxy','responsematrixxyperkick'}))
                Data = M([1:NHBPM], [NHCM+(1:NVCM)]); 
            elseif any(strcmpi(DataType, {'responsematrixyx','responsematrixyxperkick'}))
                Data = M([NHBPM+(1:NVBPM)], [1:NHCM]); 
            elseif any(strcmpi(DataType, {'responsematrixyy','responsematrixyyperkick'}))
                Data = M([NHBPM+(1:NVBPM)], [NHCM+(1:NVCM)]); 
            else
                Data = M;
            end

        case 'outlierindex'        
            Data = LocoModel.OutlierIndex;
            
        case 'outliermatrix'        
            % Mark the outliers with ones
            Data = zeros(NHBPM+NVBPM, NHCM+NVCM);
            Data = Data(:);
            Data(LocoModel.OutlierIndex) = 1;        
            Data = reshape(Data, NHBPM+NVBPM, NHCM+NVCM);
            
        case 'hbpmgain'
            Data = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);
        case 'vbpmgain'
            Data = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

        case 'hbpmgainstd'
            Data = BPMData.HBPMGainSTD(BPMData.HBPMGoodDataIndex);
        case 'vbpmgainstd'
            Data = BPMData.VBPMGainSTD(BPMData.VBPMGoodDataIndex);
            
        case 'hbpmcoupling'
            Data = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);
        case 'vbpmcoupling'
            Data = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);
            
        case 'hbpmcouplingstd'
            Data = BPMData.HBPMCouplingSTD(BPMData.HBPMGoodDataIndex);
        case 'vbpmcouplingstd'
            Data = BPMData.VBPMCouplingSTD(BPMData.VBPMGoodDataIndex);
            
        case 'bpmstd'
            Data = LocoMeasData.BPMSTD([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex]);
            
        case 'hbpmstd'
            Data = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
            
        case 'vbpmstd'
            Data = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
            
        case 'hcmkick'
            Data = CMData.HCMKicks(CMData.HCMGoodDataIndex);
        case 'vcmkick'
            Data = CMData.VCMKicks(CMData.VCMGoodDataIndex);
            
        case 'hcmkickstd'
            Data = CMData.HCMKicksSTD(CMData.HCMGoodDataIndex);
        case 'vcmkickstd'
            Data = CMData.VCMKicksSTD(CMData.VCMGoodDataIndex);
            
        case 'hcmcoupling'
            Data = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
        case 'vcmcoupling'
            Data = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
            
        case 'hcmcouplingstd'
            Data = CMData.HCMCouplingSTD(CMData.HCMGoodDataIndex);
        case 'vcmcouplingstd'
            Data = CMData.VCMCouplingSTD(CMData.VCMGoodDataIndex);
            
        case 'hcmenergyshift'
            Data = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
        case 'vcmenergyshift'
            Data = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);

        case 'hcmenergyshiftstd'
            Data = CMData.HCMEnergyShiftSTD(CMData.HCMGoodDataIndex);
        case 'vcmenergyshiftstd'
            Data = CMData.VCMEnergyShiftSTD(CMData.VCMGoodDataIndex);

        case 'fitvalues'
            Data = FitParameters.Values;
        case 'fitvaluesstd'
            Data = FitParameters.ValuesSTD;
        case 'fitvaluesdeltas'
            Data = FitParameters.Deltas;
        case 'fitdeltarf'
            Data = FitParameters.DeltaRF;
        case 'fitdeltarfstd'
            Data = FitParameters.DeltaRFSTD;
            
        case 'eta'
            if strcmpi(Source, 'meas')
                Data = LocoMeasData.Eta([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex]);
            else
                Data = LocoModel.Eta;                 
            end
            
        case 'etax'
            if strcmpi(Source, 'meas')
                Data = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
            else
                Data = LocoModel.Eta(1:NHBPM);                 
            end
            
        case 'etay'
            if strcmpi(Source, 'meas')
                Data = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
            else
                Data = LocoModel.Eta(NHBPM+(1:NVBPM));                 
            end
            
        case 'etaoutlierindex'
            Data = LocoModel.EtaOutlierIndex;
            
        case 'chisquare'
            Data = LocoModel.ChiSquare;
            
        case 'errordistribution'
            
            [Mmeas, Mmodel, EtaMeas, EtaModel, BPMstd]  = locodata(FileName, IterationNumber-1, 'responsematrix','Meas', 'responsematrix','Model', 'Eta','Meas', 'Eta','Model', 'BPMstd','Meas');            
            Mstd = BPMstd * ones(1,size(Mmodel,2));
            
            % Change Mmodel by the energy shifts
            if strcmpi(LocoFlags.ClosedOrbitType, 'fixedmomentum')
                HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
                VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
                
                % Set the lattice model
                for j = 1:length(FitParameters.Params)
                    RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
                end

                AlphaMCF = locomcf(RINGData);
                EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
                
                for j = 1:length(HCMEnergyShift)
                    Mmodel(:,j) = Mmodel(:,j) + HCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                end
                
                for j = 1:length(VCMEnergyShift)
                    Mmodel(:,NHCM+j) = Mmodel(:,NHCM+j) + VCMEnergyShift(j) * [EtaXmcf; EtaYmcf];
                end
            end
            
            % Remove coupling rows
            if strcmpi(LocoFlags.Coupling,'no')
                MmodelXX = Mmodel(1:NHBPM,1:NHCM);
                MmodelYY = Mmodel(NHBPM+1:NHBPM+NVBPM,NHCM+1:NHCM+NVCM);
                Mmodel = [MmodelXX(:); MmodelYY(:)];
            
                MmeasXX = Mmeas(1:NHBPM,1:NHCM);
                MmeasYY = Mmeas(NHBPM+1:NHBPM+NVBPM,NHCM+1:NHCM+NVCM);
                Mmeas = [MmeasXX(:); MmeasYY(:)];

                MstdXX = Mstd(1:NHBPM,1:NHCM);
                MstdYY = Mstd(NHBPM+1:NHBPM+NVBPM,NHCM+1:NHCM+NVCM);
                Mstd = [MstdXX(:); MstdYY(:)];                    
                
                % Change the outlier index to no coupling
                tmp = zeros(NHBPM+NVBPM, NHCM+NVCM);
                tmp = tmp(:);
                tmp(LocoModel.OutlierIndex) = 1;        
                tmp = reshape(tmp, NHBPM+NVBPM, NHCM+NVCM);
                tmpXX = tmp(1:NHBPM,1:NHCM);
                tmpYY = tmp(NHBPM+1:NHBPM+NVBPM, NHCM+1:NHCM+NVCM);
                tmp = [tmpXX(:); tmpYY(:)];
                iOutliers = find(tmp == 1);
                
                Mmeas(iOutliers) = []; 
                Mmodel(iOutliers) = []; 
                Mstd(iOutliers) = [];
            else
                Mmodel = Mmodel(:);
                Mmeas = Mmeas(:);
                Mstd = Mstd(:);
                
                % Outliers
                iOutliers = LocoModel.OutlierIndex;
                Mmeas(iOutliers) = []; 
                Mmodel(iOutliers) = []; 
                Mstd(iOutliers) = [];
            end
            
            
            % Include dispersion
            if strcmpi(LocoFlags.Dispersion,'yes')
                iOutliers = LocoModel.EtaOutlierIndex;
                EtaModel(iOutliers) = []; 
                EtaMeas(iOutliers) = []; 
                BPMstd(iOutliers) = [];
                
                Mmodel = [Mmodel; EtaModel];
                Mmeas = [Mmeas; EtaMeas];
                Mstd = [Mstd; BPMstd];
            end
            
            %Data =   Mmeas - Mmodel;
            Data =  (Mmeas - Mmodel) ./ Mstd;
            %Data = ((Mmeas - Mmodel) ./ Mstd) .^ 2;
            
            %ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / length(Mstd)
            %ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / (length(Mstd)-NumberOfFitParameters)
            
        case 'beta'
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            
            Index = 1:length(RINGData.Lattice);
            %Index = BPMData.BPMIndex;
            [TD, Tune] = twissring(RINGData.Lattice, 0, Index);
            BETA = cat(1,TD.beta);
            Spos = cat(1,TD.SPos);
            Data = [BETA(:,1) BETA(:,2) Spos(:)];
            
        case 'hbeta'
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            
            Index = 1:length(RINGData.Lattice);
            %Index = BPMData.BPMIndex;
            %Index = BPMData.BPMIndex(BPMData.HBPMIndex);
            %Index = BPMData.BPMIndex(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex));
            [TD, Tune] = twissring(RINGData.Lattice,0,Index);
            BETA = cat(1,TD.beta);
            %Sx  = cat(1,TD.SPos);
            Data = BETA(:,1);
            
        case 'vbeta'
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            
            Index = 1:length(RINGData.Lattice);
            %Index = BPMData.BPMIndex(BPMData.VBPMIndex);
            %Index = BPMData.BPMIndex(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex));
            [TD, Tune] = twissring(RINGData.Lattice, 0, Index);
            BETA = cat(1,TD.beta);
            %Sy  = cat(1,TD.SPos);
            Data = BETA(:,2);
            
        case 'tune'
            % Set the lattice model
            for j = 1:length(FitParameters.Params)
                RINGData = locosetlatticeparam(RINGData, FitParameters.Params{j}, FitParameters.Values(j));
            end
            
            [TD, Tune] = twissring(RINGData.Lattice, 0, 1:length(RINGData.Lattice));
            %[LD, Tune] = linopt(RINGData.Lattice, 0);
            Data = Tune(:);
            
        otherwise
            fprintf('   DataType unknown\n');
            Data = [];
    end
    
    varargout{i} = Data;
end

