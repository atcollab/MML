function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%BUILDLOCOFITPARAMETERS - ASP LOCO fit parameters
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
% RemoveHBPMDeviceList = [
%     1     1
%     3     6
%     5     7
%     6     7];
RemoveVBPMDeviceList = RemoveHBPMDeviceList;



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
        if all(MachineConfig.SFA.Setpoint.Data == 0)
            fprintf('   Turning SFA family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SFA')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(MachineConfig.SFB.Setpoint.Data == 0)
            fprintf('   Turning SFB family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SFB')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(MachineConfig.SDA.Setpoint.Data == 0)
            fprintf('   Turning SDA family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SDA')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(MachineConfig.SDB.Setpoint.Data == 0)
            fprintf('   Turning SDB family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SDB')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
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
% LocoFlags.Coupling = 'No';
% LocoFlags.Dispersion = 'No';
% LocoFlags.VerticalDispersionWeight = 12.5;
% LocoFlags.AutoCorrectDelta = 'Yes';
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';



% CMs to disable
j = findrowindex(RemoveHCMDeviceList, LocoMeasData.HCM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),CMData.HCMGoodDataIndex(:));
    CMData.HCMGoodDataIndex(irm) = [];
end

j = findrowindex(RemoveVCMDeviceList, LocoMeasData.VCM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),CMData.VCMGoodDataIndex(:));
    CMData.VCMGoodDataIndex(irm) = [];
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
FitParameters = [];

ModeCell = {...
    'Fit QFA, QFB, QDA, & BEND by Family', ...
    'Fit QFA, QFB, & QDA by Magnet and BEND by Family', ...
    'Fit QFA & QDA by Magnet and QFB & BEND by Family', ...
    'Fit QFA, QDA, & QFB by Magnet and BEND by Family (ie, Fit by Power Supply)', ...
    'No Parameter Setup'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString','Fit Parameter Selection:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [500 125]);
drawnow;
if OKFlag ~= 1
    ButtonName = 3;
end
N = 0;

switch ButtonName
    case 1

        fprintf('\n   Fit the K-Value of QFA, QFB, QDA, & the BEND by family.\n');

        % QFA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFA');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',iAT(1));
        FitParameters.Deltas = NaN;

        % QDA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QDA');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        % QFB K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFB');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        % Bend K-values fit
        iAT = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];


    case 2

        fprintf('\n   Fit the K-Value of QFA, QFB, QDA by magnet & the BEND by family.\n');

        % QFA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',iAT);
        FitParameters.Deltas = NaN * ones(length(iAT),1);

        % QDA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QDA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(iAT),1)];

        % QFB K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFB');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(iAT),1)];

        % Bend K-values fit as a one parameter
        iAT = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

    case 3

        fprintf('\n   Fit the K-Value of QFA & QDA by magnet and QFB & BEND by family.\n');

        % QFA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',iAT);
        FitParameters.Deltas = NaN * ones(length(iAT),1);

        % QDA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QDA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(iAT),1)];

        % QFB K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFB');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        % Bend K-values fit as a one parameter
        iAT = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

    case 4

        fprintf('\n   Fit the K-Value of QFA, QDA, & QFB by magnet and BEND by family.\n');

        % QFA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = getcellstruct(RINGData.Lattice,'K',iAT);
        FitParameters.Deltas = NaN * ones(length(iAT),1);

        % QDA K-values
        iAT = findcells(RINGData.Lattice,'FamName','QDA');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(iAT),1)];

        % QFB K-values
        iAT = findcells(RINGData.Lattice,'FamName','QFB');
        for loop=1:length(iAT)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(iAT),1)];

        % Bend K-values fit as a one parameter
        iAT = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,iAT,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',iAT(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];
end


Nfit_NoWithSkeqQuads = length(FitParameters.Values);


%%%%%%%%%%%%%%%%%%%%%%%%
% Skew quadrupole fits %
%%%%%%%%%%%%%%%%%%%%%%%%

ModeCell = {...
    'Fit By Power Supply (Not programmed yet!!!)', ...
    'Fit Skew Quadrupoles at SFA and SFB Magnets (42 fits)', ...
    'Do Not Fit Skew Quadrupoles'};
%    'Fit Skew Quadrupoles at SFA, SDA, SFB, & SDB Magnets (98 fits)', ...
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 125]);
drawnow;
if OKFlag ~= 1
    ButtonName = 3;  % Default
end

switch ButtonName
    case 1 % 'Fit By Power Supply'

        error('Fitting skew quadrupoles by power supply needs to be programmed!!!');

    case 2
        % Skew quadrupoles are in the sextupoles
        %fprintf('   Fit All SFA, SDA, SFB, & SDB  Magnets (98 fits)\n');
        fprintf('   Fit All SFA and SFB  Magnets (42 fits)\n');
        
        SFI = findcells(RINGData.Lattice,'FamName','SFA');
        for loop=1:28
            if length(SFI) == 28
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
            elseif length(SFI) == 2*28
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error fits skews quadrupoles at the SFA magnets.');
            end
        end
        FitParameters.Values = [FitParameters.Values;       zeros(28,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(28,1)];  % automatic delta determination does not work if starting value is 0

%         SDI = findcells(RINGData.Lattice,'FamName','SDA');
%         for loop=1:28
%             if length(SDI) == 28
%                 N = N + 1;
%                 FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
%             elseif length(SDI) == 2*28
%                 % Split sextupoles
%                 N1 = 2*loop-1;
%                 N2 = 2*loop;
%                 N = N + 1;
%                 FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
%             else
%                 error('   Error fits skews quadrupoles at the SDA magnets.');
%             end
%         end
%         FitParameters.Values = [FitParameters.Values;       zeros(28,1)];
%         FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(28,1)];  % automatic delta determination does not work if starting value is 0


        SFI = findcells(RINGData.Lattice,'FamName','SFB');
        for loop=1:14
            if length(SFI) == 14
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
            elseif length(SFI) == 2*14
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error fits skews quadrupoles at the SFB magnets.');
            end
        end
        FitParameters.Values = [FitParameters.Values;       zeros(14,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(14,1)];  % automatic delta determination does not work if starting value is 0

%         SDI = findcells(RINGData.Lattice,'FamName','SDB');
%         for loop=1:28
%             if length(SDI) == 28
%                 N = N + 1;
%                 FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
%             elseif length(SDI) == 2*28
%                 % Split sextupoles
%                 N1 = 2*loop-1;
%                 N2 = 2*loop;
%                 N = N + 1;
%                 FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
%             else
%                 error('   Error fits skews quadrupoles at the SDB magnets.');
%             end
%         end
%         FitParameters.Values = [FitParameters.Values;       zeros(28,1)];
%         FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(28,1)];  % automatic delta determination does not work if starting value is 0
        
    otherwise

    % No coupling
    CMData.FitCoupling   = 'No';
    BPMData.FitCoupling  = 'No';
    LocoFlags.Coupling   = 'No';
    
end


%%%%%%%%%%%%%%%%%%%%%
% Parameter Weights %
%%%%%%%%%%%%%%%%%%%%%

% For each cell of FitParameters.Weight.Value, a rows is added to the A matrix
% Index of the row of A:  FitParameters.Weight.Index{i}
% Value of the weight:    FitParameters.Weight.Value{i} / mean(Mstd)

ModeCell = {'No Parameter Weigths', 'Add Parameter Weights'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString','Weights?', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [200 100], 'InitialValue', 1);
if OKFlag ~= 1
    ButtonName = 1;  % Default
end

switch ButtonName
    case 1
        % No Weights
        if isfield(FitParameters, 'Weight')
            FitParameters = rmfield(FitParameters, 'Weight');
        end
    case 2
        for ii = 1:Nfit_NoWithSkeqQuads
            FitParameters.Weight.Index{ii,1} = ii;
            FitParameters.Weight.Value{ii,1} = .1;
        end
end


% Starting point for the deltas (automatic delta determination does not work if starting value is 0)
%FitParameters.Deltas = 0.0001 * ones(size(FitParameters.Values));


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


