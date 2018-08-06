function ChiSquare = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, ConvertUnitsFlag, IterNumber)
%LOCOCALCCHI2 - Calculate the contribution to chi^2 of each fit parameter in LOCO
%  ChiSquare = lococalcchi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData, ConvertUnitsFlag, IterNumber)
%  ChiSquare = lococalcchi2(LOCOFileName, ConvertUnitsFlag, IterNumber)

%  INPUTS
%  1. LOCOFileName - LOCO file name
%        or
%  1-7.  LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData
%  Optional Inputs:
%  a. ConvertUnitsFlag - True  convert to the LOCO units {Default}
%                        False don't convert (inputs have already been converted)
%  b. IterationNumber - LOCO iteration number (0,1, ...) {Default: last iteration}



IterNumber = [];
ChiSquare = [];

if nargin < 8
    ConvertUnitsFlag = 1;
end

% Input #1 can be a LOCO file
if nargin==0
    [FileName, PathName] = uigetfile('*.mat', 'Select A LOCO File', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
    if isequal(FileName,0) || isequal(PathName,0)
        return
    end
    LOCOFileName= [PathName, FileName];
    load(LOCOFileName);
    
elseif ischar(LocoModel) || isempty(LocoModel)
    if nargin >= 2
        ConvertUnitsFlag = LocoMeasData;
    end
    if nargin >= 3
        IterNumber = BPMData;
    end
    if isempty(LocoModel)
        [FileName, PathName] = uigetfile('*.mat', 'Select A LOCO File', [getfamilydata('Directory','DataRoot'), 'LOCO', filesep]);
        if isequal(FileName,0) || isequal(PathName,0)
            return
        end
        LOCOFileName= [PathName, FileName];
        load(LOCOFileName);
    elseif LocoModel(1) == '.'
        [FileName, PathName] = uigetfile('*.mat', 'Select A LOCO File');
        if isequal(FileName,0) || isequal(PathName,0)
            return
        end
        LOCOFileName= [PathName, FileName];
        load(LOCOFileName);
    else
        load(LocoModel);
    end
end


if isempty(IterNumber)
    IterNumber = length(BPMData);
else
    IterNumber  = IterNumber + 1;
end


% Chi^2 of the last iteration?
BPMData       = BPMData(IterNumber);
CMData        = CMData(IterNumber);
LocoModel     = LocoModel(IterNumber);
FitParameters = FitParameters(IterNumber);
LocoFlags     = LocoFlags(IterNumber);

    
% Get the flags
LocoParams = FitParameters.Params;
LocoValues = FitParameters.Values;
LocoDeltas = FitParameters.Deltas;
SVmethod             = LocoFlags.SVmethod;
AutoCorrectDeltaFlag = LocoFlags.AutoCorrectDelta;
CouplingFlag         = LocoFlags.Coupling;
%NormalizeFlag        = LocoFlags.Normalization.Flag;
OutlierFactor        = LocoFlags.OutlierFactor;


% UNITS CONVERSIONS (to be combatible with tracking code)
if ConvertUnitsFlag
    % Convert corrector kicks used in the response matrix to radians
    CMData.HCMKicks = CMData.HCMKicks(:) / 1000;   % milliradian to radians (column vector)
    CMData.VCMKicks = CMData.VCMKicks(:) / 1000;   % milliradian to radians (column vector)

    % Convert the measured response matrix to meters
    LocoMeasData.M = LocoMeasData.M / 1000;

    % Convert the BPMSTD to meters and make the same size as a response matrix
    LocoMeasData.BPMSTD = LocoMeasData.BPMSTD / 1000;    % mm to meters

    % Convert orbit for "dispersion" in meters in column vector format
    LocoMeasData.Eta = LocoMeasData.Eta(:) / 1000;       % mm to meters
end
% END UNITS CONVERTSION


Mstd = LocoMeasData.BPMSTD * ones(1,size(LocoMeasData.M,2));


% Use the entire family of BPMs in the model response matrix, then index later (not much difference computationally)
BPMIndexShortX = BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex);
BPMIndexShortY = length(BPMData.BPMIndex)+BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex);
BPMIndexShort = [BPMIndexShortX(:)' BPMIndexShortY(:)'];
NHBPM = length(BPMData.HBPMGoodDataIndex);
NVBPM = length(BPMData.VBPMGoodDataIndex);
NBPM  = NHBPM + NVBPM;
NHCM = length(CMData.HCMGoodDataIndex);
NVCM = length(CMData.VCMGoodDataIndex);


% Remove unwanted data from the Mmeas and Mstd
Mmeas = LocoMeasData.M([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 
Mstd  =           Mstd([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

% If including dispersion then Mstd and Mmeas must include disperion term
if strcmpi((LocoFlags.Dispersion),'yes')
    Xstd = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
    Ystd = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
    
    if isempty(LocoMeasData.Eta)
        error('Measured dispersion (LocoMeasData.Eta) can not be empty when including dispersion');
    end
    EtaX = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
    EtaY = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
    
    LocoFlags.HorizontalDispersionWeight = abs(LocoFlags.HorizontalDispersionWeight);
    LocoFlags.VerticalDispersionWeight   = abs(LocoFlags.VerticalDispersionWeight);

    % Should remove the dispersion if both weights are zero
    if LocoFlags.HorizontalDispersionWeight == 0
        LocoFlags.HorizontalDispersionWeight = eps;
    end
    if LocoFlags.VerticalDispersionWeight == 0
        LocoFlags.VerticalDispersionWeight = eps;
    end
    
    % Weight the dispersion
    Mstd  = [Mstd  [Xstd/LocoFlags.HorizontalDispersionWeight; Ystd/LocoFlags.VerticalDispersionWeight]];
    Mmeas = [Mmeas [EtaX; EtaY]];
end


% Convert to a column vector
Mstd  = Mstd(:);
Mmeas = Mmeas(:);


% Build the corrector magnet data structures to be used with locoresponsematrix
CMDataRM.FamName = CMData.FamName;
CMDataRM.HCMIndex = CMData.HCMIndex(CMData.HCMGoodDataIndex);
CMDataRM.VCMIndex = CMData.VCMIndex(CMData.VCMGoodDataIndex);
CMDataRM.HCMKicks = CMData.HCMKicks(CMData.HCMGoodDataIndex);
CMDataRM.VCMKicks = CMData.VCMKicks(CMData.VCMGoodDataIndex);
CMDataRM.HCMCoupling = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
CMDataRM.VCMCoupling = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
CMDataRM.HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
CMDataRM.VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);

% Compute the new model response matrix with dispersion for saving
%fprintf('   Computing final response matrix (after fit) (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
CMDataRM.HCMKicks    = CMData.HCMKicks(CMData.HCMGoodDataIndex);
CMDataRM.VCMKicks    = CMData.VCMKicks(CMData.VCMGoodDataIndex);
CMDataRM.HCMCoupling = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
CMDataRM.VCMCoupling = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
warning off;
lastwarn('');

%modify RINGData
LocoValues = LocoValues(:);      % Force a column vector
for i = 1:length(LocoParams)
    % Compute the response matrix with the parameter change
    RINGData = locosetlatticeparam(RINGData, LocoParams{i}, LocoValues(i));
end

if isempty(FitParameters.DeltaRF)
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
else
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
end
warning on;
%fprintf('%f seconds. \n',toc);
% if ~isempty(lastwarn)
%     fprintf('\n   Warning computing the final response matrix:\n         %s\n', lastwarn);
%     fprintf(  '   Check the final values of the fits to make sure they are in a reasonable range for\n');
%     fprintf(  '   this accelerator.  Check the input data and/or reduce the number of singular values.\n\n');
% end

% To remove the off-diagonal part of the A matrix find the index vector, iNoCoupling, of rows to keep
if strcmpi((CouplingFlag),'no')
    CF = [ ones(NHBPM,NHCM) zeros(NHBPM,NVCM);
          zeros(NVBPM,NHCM)  ones(NVBPM,NVCM)];

    % Keep the dispersion
    if strcmpi((LocoFlags.Dispersion),'yes')
        % Keep the horizontal and vertical part of the "dispersion" orbit 
        CF = [CF [2*ones(NHBPM,1); 3*ones(NVBPM,1)]];    % Make zeros to ignor dispersion
    end
        
    CF = CF(:);
    iNoCoupling = find(CF > 0);               % Rows of A to keep when ignoring coupling
    %iHorizontalDispersion = find(CF == 2);   % Rows of A corresponding to horizontal dispersion
    %iVerticalDispersion = find(CF == 3);     % Rows of A corresponding to vertical dispersion
    clear CF
else
    if strcmpi((LocoFlags.Dispersion),'yes')
        iNoCoupling = (1:(NVBPM+NHBPM)*(NHCM+NVCM+1))';
    else
        iNoCoupling = (1:(NVBPM+NHBPM)*(NHCM+NVCM))';
    end
end

% Rotate Mmodel and remove BPMs not in the measured response matrix
C11 = ones(length(BPMData.BPMIndex),1);
C11(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);

C12 = zeros(length(BPMData.BPMIndex),1);
C12(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);

C21 = zeros(length(BPMData.BPMIndex),1);
C21(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);

C22 = ones(length(BPMData.BPMIndex),1);
C22(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

C = [diag(C11) diag(C12)
     diag(C21) diag(C22)];
clear C11 C12 C21 C22  

Mmodel = C * Mmodel;
Mmodel = Mmodel(BPMIndexShort, :); 


% Compute chi-squared based on new model
Mmeas = LocoMeasData.M;
Mmeas = Mmeas([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

Mstd = LocoMeasData.BPMSTD * ones(1,size(LocoMeasData.M,2));
Mstd = Mstd ([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

Xstd = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
Ystd = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);


% When using the fixed momentum response matrix calculator, the merit function becomes:
%              Merit = Mmeas_ij - Mmod_ij - Dp/p_j * eta_i 
%              where eta_i is the measured eta (not the model eta)
% This is done by changing Mmodel to (Mmodel_ij + Dp/p_j * eta_i)
%if strcmpi((CMData.FitHCMEnergyShift),'yes') | strcmpi((CMData.FitVCMEnergyShift),'yes')    
if strcmpi((LocoFlags.ClosedOrbitType), 'fixedmomentum')
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
    
    if ~exist('AlphaMCF')
        AlphaMCF = locomcf(RINGData);
        EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
        EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    end

    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
    
    for i = 1:length(VCMEnergyShift)
        Mmodel(:,NHCM+i) = Mmodel(:,NHCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
end

Mstd  = Mstd(:);
Mmeas = Mmeas(:);
if strcmpi((LocoFlags.Dispersion),'yes')  
    EtaX = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
    EtaY = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
    
    Mstd  = [Mstd;  [Xstd; Ystd]];
    Mmeas = [Mmeas; [EtaX; EtaY]];
else
    if ~isempty(FitParameters.DeltaRF)
        Mmodel = Mmodel(:,1:end-1);
    end
end
Mmodel = Mmodel(:);

% Combine the Mmodel outliers and the Eta outliers
if strcmpi((LocoFlags.Dispersion),'yes')
    iOutliers = [LocoModel.OutlierIndex(:); LocoModel.EtaOutlierIndex(:) + ((NHBPM+NVBPM)*(NHCM+NVCM))];
else
    iOutliers = LocoModel.OutlierIndex(:);
end

% Outliers are referenced to the coupled model
% Mark the outliers with NaN
Mmeas(iOutliers)  = NaN; 
Mmodel(iOutliers) = NaN; 
Mstd(iOutliers)   = NaN;

% Remove coupling rows
if strcmpi((CouplingFlag),'no')
    Mmodel = Mmodel(iNoCoupling); 
    Mmeas = Mmeas(iNoCoupling); 
    Mstd = Mstd(iNoCoupling); 
end

% Remove the outliers
Mmeas(find(isnan(Mmeas))) = []; 
Mmodel(find(isnan(Mmodel))) = []; 
Mstd(find(isnan(Mstd))) = [];


NumberOfFitParameters = 0; 
%count the number of fit paramters
% Horizontal BPM gains
if strcmpi((BPMData.FitGains),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(BPMData.HBPMGoodDataIndex);
end

% Horizontal BPM coupling
if strcmpi((BPMData.FitCoupling),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(BPMData.HBPMGoodDataIndex);
end

% Vertical BPM coupling
if strcmpi((BPMData.FitCoupling),'yes')
   NumberOfFitParameters = NumberOfFitParameters + length(BPMData.VBPMGoodDataIndex);
end

% Vertical BPM gains
if strcmpi((BPMData.FitGains),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(BPMData.VBPMGoodDataIndex);
end

% Corrector magnet gains
if strcmpi((CMData.FitKicks),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(CMData.HCMGoodDataIndex);
end

if strcmpi((CMData.FitKicks),'yes')
   NumberOfFitParameters = NumberOfFitParameters + length(CMData.VCMGoodDataIndex);
end

% Corrector magnet coupling
if strcmpi((CMData.FitCoupling),'yes')    
    NumberOfFitParameters = NumberOfFitParameters + length(CMData.HCMGoodDataIndex);
end

if strcmpi((CMData.FitCoupling),'yes')    
    NumberOfFitParameters = NumberOfFitParameters + length(CMData.VCMGoodDataIndex);
end

% Corrector magnet energy shifts
if strcmpi((CMData.FitHCMEnergyShift),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(CMData.HCMGoodDataIndex);
end
if strcmpi((CMData.FitVCMEnergyShift),'yes')
    NumberOfFitParameters = NumberOfFitParameters + length(CMData.VCMGoodDataIndex);
end

% RF Frequency parameter fit
if strcmpi((FitParameters.FitRFFrequency),'yes')
    NumberOfFitParameters = NumberOfFitParameters + 1;
end

% The rest of the parameter fits
NumberOfFitParameters = NumberOfFitParameters + length(FitParameters.Values);


%ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / length(Mstd);
ChiSquare = sum(((Mmeas - Mmodel) ./ Mstd) .^ 2) / (length(Mstd)-NumberOfFitParameters);   % mean e'*e = sigma*(n-k)
% fprintf('   Chi-square/D.O.F. = %f (N=%d, K=%d) (computed from final response matrix)\n\n', ChiSquare, length(Mstd), NumberOfFitParameters);


