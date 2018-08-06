function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName, QuadFit, SkewFit)
%BUILDLOCOFITPARAMETERS - Build the LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName, QuadFit, SkewFit)
%
%  QuadFit - 0 - No quadrupole parameter fit parameters
%            1 - Fit quadrupoles by power supply
%            2 - Fit quadrupoles by magnet
%
%  SkewFit - 0 - No coupling fit parameters
%            1 - Fit by power supply
%            2 - Fit at all sextupole magnets
%
%  EXAMPLES
%  1. Typical LOCO run for user setup
%     buildlocofitparameters('', 1, 1);
%  2. LOCO run to find actual calibration settings
%     buildlocofitparameters('', 2, 2);


%%%%%%%%%%%%%%
% Input file %
%%%%%%%%%%%%%%
if nargin == 0 || isempty(FileName)
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a LOCO input file');
    if FilterIndex == 0
        return;
    end
    FileName = [DirectoryName, FileName];
end

load(FileName);


% Quads
if nargin < 2
    ModeCell = {'No parameter setup', 'Fit quadrupoles by power supply','Fit quadrupoles by magnet'};
    [QuadFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Fit Parameter Selection:','(Not including skew quadrupoles)'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [435 110], 'InitialValue', 2);
    QuadFit = QuadFit - 1;
    drawnow;
    if OKFlag ~= 1
        QuadFit = 1;
    end
end

% Skew quads
if nargin < 3
    ModeCell = {
        'Do Not Fit Coupling Terms'
        'Fit By Power Supply'
        'Fit at All Sextupole Magnets'
        };
    [SkewFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 1);
    SkewFit = SkewFit - 1;
    if OKFlag ~= 1
        SkewFit = 1;  % Default
    end
end

% End of input checking



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
            ATIndex = family2atindex('SF');
            ATIndex = ATIndex(:);
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n');
            ATIndex = family2atindex('SD');
            ATIndex = ATIndex(:);
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end

        % Skew quadrupoles
        %if all(LocoMeasData.MachineConfig.CSQ.Setpoint.Data == 0)
        %    fprintf('   CSQ family was at zero when the response matrix was taken.\n');
        %end
    end
catch
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

% CMData.FitKicks    = 'Yes';
% CMData.FitCoupling = 'No';
%
% BPMData.FitGains    = 'Yes';
% BPMData.FitCoupling = 'No';

%LocoFlags.Method.Name = 'Scaled Levenberg-Marquardt';
%LocoFlags.Method.Name = 'Gauss-Newton';


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

FitParameters = [];
FitParameters.Values = [];
FitParameters.Deltas = [];


% Quadrupole component fits
N = 0;
switch QuadFit
    case 0 % No fit

    case 1
        % Quadrupole K-values by Power Supply
        Families = {'QF1','QD1','QF2','QD2'};
        fprintf('\n   Quadrupole parameter fits by power supply\n');

        for iFamily = 1:length(Families)
            Family = Families{iFamily};
            AT_Index = family2atindex(Family);
            [Names, j, k] = unique(family2channel(Family), 'rows');
            for loop = 1:length(j)
                N = N + 1;
                ATi = AT_Index(find(loop==k),:);
                ATi = ATi(:);
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice, ATi, 'K');
                FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice, 'K', AT_Index(j(loop),1))];
                FitParameters.Deltas = [FitParameters.Deltas; NaN];
            end
        end

    case 2 % Fit by magnet
        % Quadrupole K-values by magnet
        Families = {'QF1','QD1','QF2','QD2'};
        fprintf('\n   Quadrupole parameter fits by magnet\n');

        for iFamily = 1:length(Families)
            Family = Families{iFamily};
            AT_Index = family2atindex(Family);
            for loop = 1:size(AT_Index,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice, AT_Index(loop,:), 'K');
                FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice, 'K', AT_Index(loop,1))];
                FitParameters.Deltas = [FitParameters.Deltas; NaN];
            end
        end
end



% Coupling & skew quadrupole fits
switch SkewFit
    case 0 % No fit
        fprintf('   No coupling fits.\n\n');

    case 1 
        % Fit skew quads by power supply
        fprintf('\n   Skew quadrupole fits by power supply\n');
        
        AT_Index = family2atindex('SkewQuad');
        for loop = 1:length(AT_Index)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice, AT_Index(loop,:), 's');
            FitParameters.Values = [FitParameters.Values; 0];
            FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2];  % automatic delta determination does not work if starting value is 0
        end

    case 2  
        % Fit skew quads at all sextupoles
        fprintf('\n   Fit skew quadrupole at all the sextupoles\n');

        AT_Index = [family2atindex('SF'); family2atindex('SD');];
        for loop = 1:size(AT_Index,1)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice, AT_Index(loop,:),'s');
            FitParameters.Values = [FitParameters.Values; 0];
            FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2];  % automatic delta determination does not work if starting value is 0
        end

    otherwise
        fprintf('   No coupling fits.\n\n');
end

fprintf('\n');


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


