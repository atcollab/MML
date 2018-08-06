function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%BUILDLOCOFITPARAMETERS - CLS LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%
%  NOTES
%  1. buildlocoinput calls buildlocofitparameters
%  2. After a file is build with buildlocoinput the fit parameters can be changed with buildlocofitparameters.
%  3. If LOCO has already been run, then only the starting iteration with be saved.



%%%%%%%%%%%%%%
% Input file %
%%%%%%%%%%%%%%
if nargin == 0
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a LOCO input file');
    if FilterIndex == 0
        return;
    end
    FileName = [DirectoryName, FileName];
end

load(FileName);



%%%%%%%%%%%%%%%%%%%%%%
% Remove bad devices %
%%%%%%%%%%%%%%%%%%%%%%
RemoveHCMDeviceList = [];
RemoveVCMDeviceList = [];

RemoveHBPMDeviceList = [];
RemoveVBPMDeviceList = [];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function only works on the first iteration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('BPMData','var') && length(BPMData)>1
    BPMData = BPMData(1);
end
if exist('CMData','var') && length(CMData)>1
    CMData = CMData(1);
end
if exist('FitParameters','var') && length(FitParameters)>1
    FitParameters = FitParameters(1);
end
if exist('LocoFlags','var') && length(LocoFlags)>1
    LocoFlags = LocoFlags(1);
end
if exist('LocoModel','var') && length(LocoModel)>1
    LocoModel = LocoModel(1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure the start point in loaded in the AT model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(FitParameters)
    for i = 1:length(FitParameters.Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tune up a few parameters based on the MachineConfig %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    if isfield(LocoMeasData, 'MachineConfig')
        % Sextupoles
        if all(LocoMeasData.MachineConfig.SF.Setpoint.Data == 0)
            fprintf('   Turning SF family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SF')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SD')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
    end
catch
    % Old getmachineconfig
    try
        if isfield(LocoMeasData, 'MachineConfig')
            % Sextupoles
            if all(LocoMeasData.MachineConfig.SF.Data == 0)
                fprintf('   Turning SF family off in the LOCO model.\n');
                ATIndex = findcells(RINGData.Lattice,'FamName','SF')';
                for i = 1:length(ATIndex)
                    RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
                end
            end
            if all(LocoMeasData.MachineConfig.SD.Data == 0)
                fprintf('   Turning SD family off in the LOCO model.\n');
                ATIndex = findcells(RINGData.Lattice,'FamName','SD')';
                for i = 1:length(ATIndex)
                    RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
                end
            end
        end
    catch
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags to change from the default %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags.Threshold = 1e-5;
% LocoFlags.OutlierFactor = 10;
% LocoFlags.SVmethod = 1e-2;
% LocoFlags.HorizontalDispersionWeight = 12.5;
% LocoFlags.VerticalDispersionWeight = 12.5;
% LocoFlags.AutoCorrectDelta = 'Yes';
% LocoFlags.Coupling = 'No';
% LocoFlags.Dispersion = 'No';
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';

LocoFlags.Method.Name = 'Gauss-Newton With Cost Function';


% CMs to disable
j = findrowindex(RemoveHCMDeviceList, LocoMeasData.HCM.DeviceList);
if ~isempty(j)
    CMData.HCMGoodDataIndex(j) = [];
end

j = findrowindex(RemoveVCMDeviceList, LocoMeasData.VCM.DeviceList);
if ~isempty(j)
    CMData.VCMGoodDataIndex(j) = [];
end


% BPMs to disable
j = findrowindex(RemoveHBPMDeviceList, LocoMeasData.HBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.HBPMGoodDataIndex(:));
    BPMData.HBPMGoodDataIndex(irm) = [];
end

j = findrowindex(RemoveVBPMDeviceList, LocoMeasData.VBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.VBPMGoodDataIndex(:));
    BPMData.VBPMGoodDataIndex(irm) = [];
end



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


% Costs
MeanMstd = mean(LocoMeasData.BPMSTD) / 1000;  % Since LOCO is meters internally
QFAWeight      = .005  / MeanMstd;
QFBWeight      = .005  / MeanMstd;
QFCWeight      = .01   / MeanMstd;
BENDWeight     = .003  / MeanMstd;
BENDRollWeight = .001  / MeanMstd;
SQSFWeight     = .001  / MeanMstd;
SQSDWeight     = .001  / MeanMstd;
SQQFAWeight    = .0005 / MeanMstd;

if isfield(LocoFlags.Method, 'Cost')
    LocoFlags.Method = rmfield(LocoFlags.Method, 'Cost');
end


FitParameters = [];
DeltaScaleFactor = .01;
N = 0;

QFAI = findcells(RINGData.Lattice,'FamName','QFA');
QFBI = findcells(RINGData.Lattice,'FamName','QFB');
QFCI = findcells(RINGData.Lattice,'FamName','QFC');

QFAValues = getcellstruct(RINGData.Lattice,'K',QFAI);
QFBValues = getcellstruct(RINGData.Lattice,'K',QFBI);
QFCValues = getcellstruct(RINGData.Lattice,'K',QFCI);


ModeCell = {'By Family (3)','By Power Supply (72)','QFA & QFB By Power Supply, QFC In pairs (60)','No Parameter Setup for Quadrupoles'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Quadrupole K-Value Fit?',' ', 'Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 3);
drawnow;

switch ButtonName
    case 1
        % Fit By Family
        fprintf('  %3d - %3d k at QFA (1)\n', N+1, N+1);
        fprintf('  %3d - %3d k at QFB (1)\n', N+2, N+2);
        fprintf('  %3d - %3d k at QFC (1)\n', N+3, N+3);

        N = N + 1;
        FitParameters.Values(N,1) = mean(QFAValues);
        FitParameters.Params{N,1} = mkparamgroup(RINGData.Lattice,QFAI,'K');

        N = N + 1;
        FitParameters.Values(N,1) = mean(QFBValues);
        FitParameters.Params{N,1} = mkparamgroup(RINGData.Lattice,QFBI,'K');

        N = N + 1;
        FitParameters.Values(N,1) = mean(QFCValues);
        FitParameters.Params{N,1} = mkparamgroup(RINGData.Lattice,QFCI,'K');
        
        FitParameters.Deltas = DeltaScaleFactor * FitParameters.Values;
        %FitParameters.Deltas = NaN * FitParameters.Values;
        
    case 2
        % Fit By Power Supply
        fprintf('  %3d - %3d k at QFA (24)\n', N+1,    N+24);
        fprintf('  %3d - %3d k at QFB (24)\n', N+1+24, N+24+24);
        fprintf('  %3d - %3d k at QFC (24)\n', N+1+48, N+48+24);

        % Individual magnets        
        for i = 1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(i),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFAWeight;
        end

        for i = 1:length(QFBI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFBI(i),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFBWeight;
        end

        for i = 1:length(QFCI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFCI(i),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFCWeight;
        end

        FitParameters.Values =[QFAValues; QFBValues; QFCValues;];

        FitParameters.Deltas = DeltaScaleFactor * FitParameters.Values;
        %FitParameters.Deltas = NaN * FitParameters.Values;
    
    case 3
        % Fit QFA & QFB Power Supply, QFC in Pairs
        fprintf('  %3d - %3d k at QFA (24)\n', N+1,    N+24);
        fprintf('  %3d - %3d k at QFB (24)\n', N+1+24, N+24+24);
        fprintf('  %3d - %3d k at QFC (12)\n', N+1+48, N+48+12);

        % Individual magnets
        for i = 1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(i),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFAWeight;
        end

        for i = 1:length(QFBI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFBI(i),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFBWeight;
        end

        for i = 1:length(QFCI)/2
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,[QFCI(2*i-1) QFCI(2*i)],'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = QFCWeight;
        end

        FitParameters.Values =[QFAValues; QFBValues; QFCValues(1:2:end);];

        FitParameters.Deltas = DeltaScaleFactor * FitParameters.Values;
        %FitParameters.Deltas = NaN * FitParameters.Values;
        
    otherwise
        LocoFlags = [];
        FitParameters.Params = [];
        FitParameters.Values = [];
        FitParameters.Deltas = [];
        fprintf('   Quadrupoles k-values will not be fit.\n');
end


% BEND
BENDI = findcells(RINGData.Lattice, 'FamName', 'BEND');
%KBEND = RINGData.Lattice{BENDI(1)}.K;
KBEND = getcellstruct(RINGData.Lattice, 'K', BENDI);
NBEND = length(BENDI) / 24;

ButtonName = questdlg('LOCO fit parameter for BEND?','FIT PARAMETERS','Fit BEND By Family','Fit Individual BEND Magnets','No BEND Fit','Fit BEND By Family');
drawnow;
switch ButtonName
    case 'Fit BEND By Family'
        fprintf('  %3d - %3d k at BEND (1)\n', N+1, N+1);
        N = N + 1;
        FitParameters.Values(N) = KBEND(1);
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI(1),'K');
        FitParameters.Deltas = [FitParameters.Deltas; DeltaScaleFactor*KBEND(1)];
        %FitParameters.Deltas = [FitParameters.Deltas; NaN*KBEND(1)]     
        LocoFlags.Method.Cost.FitParameters(N,1) = BENDWeight;
    case 'Fit Individual BEND Magnets'
        fprintf('  %3d - %3d k at BEND (1)\n', N+1, N+1+length(BENDI));
        FitParameters.Values =[FitParameters.Values; KBEND(:)];
        for i = 1:length(BENDI)/NBEND
            N = N + 1;
            iBEND = NBEND*(i-1)+1:NBEND*(i-1)+NBEND;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI(iBEND),'K');
            LocoFlags.Method.Cost.FitParameters(N,1) = BENDWeight;
        end
        FitParameters.Deltas = [FitParameters.Deltas; DeltaScaleFactor*KBEND];
        %FitParameters.Deltas = [FitParameters.Deltas; NaN*KBEND
    otherwise
        fprintf('   BEND not fit.\n');
end

% ButtonName = questdlg('Fit Rolls at the BEND?','FIT PARAMETERS','No','Yes','No');
% drawnow;
% switch ButtonName
%     case 'Yes'
%         fprintf('  %3d - %3d Rolls at the BEND (24)\n', N+1, N+24);
%         for i = 1:length(BENDI)/NBEND
%             N = N + 1;
%             FitParameters.Values(N) = 0;
%             iBEND = NBEND*(i-1)+1:NBEND*(i-1)+NBEND;
%             FitParameters.Params{N} = mkparamgroup(RINGData.Lattice, BENDI(iBEND), 'tilt');
%             FitParameters.Deltas(N) = 1e-5;
%             LocoFlags.Method.Cost.FitParameters(N,1) = BENDRollWeight;
%         end
%     otherwise
%         fprintf('   BEND rolls not fit.\n');
% end


Nfit_NoWithSkeqQuads = length(FitParameters.Values);


% Skew quadrupole fits
% isf  =  findcells(RINGData.Lattice,'FamName','SF');
% isd  =  findcells(RINGData.Lattice,'FamName','SD');
% isAT  =  sort([isf isd]);
% isext=[1 34];    %indices of 12 skew sextupole (on basis of 1-36 in CLS)
% isATon=isAT(isext);
% SQValues = getcellstruct(RINGData.Lattice,'PolynomA',isATon);

ModeCell = {'Fit at all SF & SD Magnets (36)', 'Fit All SF, SD, & QFA Magnets (60)', 'Do Not Fit Skew Quadrupoles'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 1);
drawnow;
if OKFlag ~= 1
    ButtonName = 3;  % Default
end
switch ButtonName
    case 1 % 'Fit All SF & SD Magnets (36)'
        fprintf('  %3d - %3d Skew at SF (12)\n', N+1,    N+12);
        fprintf('  %3d - %3d Skew at SD (24)\n', N+1+12, N+12+24);

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        SDI = findcells(RINGData.Lattice,'FamName','SD');

        for loop=1:12
            if length(SFI) == 12
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
            elseif length(SFI) == 24
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error setting the SF skew parameter group.');
            end
            LocoFlags.Method.Cost.FitParameters(N,1) = SQSFWeight;
        end
        FitParameters.Values = [FitParameters.Values; zeros(12,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(12,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:24
            if length(SDI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
            elseif length(SDI) == 48
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
            else
                error('   Error setting the SD skew parameter group.');
            end
            LocoFlags.Method.Cost.FitParameters(N,1) = SQSDWeight;
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

        CMData.FitCoupling   = 'Yes';
        BPMData.FitCoupling  = 'Yes';
        LocoFlags.Coupling   = 'Yes';

    case 2 % 'Fit All SF, SD, & QFA Magnets (60)'
        fprintf('  %3d - %3d Skew at SF  (12)\n', N+1,    N+12);
        fprintf('  %3d - %3d Skew at SD  (24)\n', N+1+12, N+12+24);
        fprintf('  %3d - %3d Skew at QFA (24)\n', N+1+36, N+36+24);

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');

        for loop=1:12
            if length(SFI) == 12
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
            elseif length(SFI) == 24
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error setting the SF skew parameter group.');
            end
            LocoFlags.Method.Cost.FitParameters(N,1) = SQSFWeight;
        end
        FitParameters.Values = [FitParameters.Values; zeros(12,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(12,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:24
            if length(SDI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
            elseif length(SDI) == 48
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
            else
                error('   Error setting the SD skew parameter group.');
            end
            LocoFlags.Method.Cost.FitParameters(N,1) = SQSDWeight;
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:24
            if length(QFAI) == 24
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(loop),'s');
            elseif length(QFAI) == 48
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI([N1 N2]),'s');
            else
                error('   Error setting the QFA skew parameter group.');
            end
            LocoFlags.Method.Cost.FitParameters(N,1) = SQQFAWeight;
        end
        FitParameters.Values = [FitParameters.Values; zeros(24,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(24,1)];  % automatic delta determination does not work if starting value is 0

        CMData.FitCoupling   = 'Yes';
        BPMData.FitCoupling  = 'Yes';
        LocoFlags.Coupling   = 'Yes';
        
    otherwise
        % No coupling
        fprintf('   No skew quadrupole fits.\n');
        CMData.FitCoupling   = 'No';
        BPMData.FitCoupling  = 'No';
        LocoFlags.Coupling   = 'No';
end



% %%%%%%%%%%%%%%%%%%%%%
% % Parameter Weights %
% %%%%%%%%%%%%%%%%%%%%%
% 
% % For each cell of LocoFlags.Method.Cost.Values, a rows is added to the A matrix
% % Values of the cost fuction:    LocoFlags.Method.Cost.FitParameters{i} / mean(Mstd)???
% 
% ModeCell = {'No Parameter Weigths', 'Add Parameter Weights'};
% [ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString','Weights?', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [200 100], 'InitialValue', 2);
% drawnow;
% if OKFlag ~= 1
%     ButtonName = 2;  % Default
% end
% switch ButtonName
%     case 1
%         fprintf('   No weights\n');
%         if isfield(FitParameters, 'Weight')
%             FitParameters = rmfield(FitParameters, 'Weight');
%         end
%     case 2
%         fprintf('   Weights added to parameter fits\n');
%         %for ii = 1:Nfit_NoWithSkeqQuads
%         for ii = 1:length(FitParameters.Values)
%             LocoFlags.Method.Cost.FitParameters(ii) = .01;
%         end
% end



% RF parameter fit setup (There is a flag to actually do the fit)
if isempty(LocoMeasData.DeltaRF)
    FitParameters.DeltaRF = 500;  % It's good to have something here so that LOCO will compute a model dispersion
else
    FitParameters.DeltaRF = LocoMeasData.DeltaRF;
end


% File check
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});


% Save
save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');

fprintf('\n');

