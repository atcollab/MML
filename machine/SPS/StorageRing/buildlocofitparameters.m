function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%BUILDLOCOFITPARAMETERS - SPS LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName)



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

RemoveHBPMDeviceList = [18 19];
RemoveVBPMDeviceList = [18 19];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is only works on the first iteration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        if all(MachineConfig.SF.Setpoint.Data == 0)
            fprintf('   Turning SF family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SF')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SD')';
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
% LocoFlags.VerticalDispersionWeight = 12.5;
% LocoFlags.AutoCorrectDelta = 'Yes';
% LocoFlags.Coupling = 'No';
% LocoFlags.Dispersion = 'No';
LocoFlags.DispersionMeasurement = 'BiDirectional';  % 'OneWay' or 'BiDirectional'  
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';
LocoFlags.Method.Name = 'Scalar Levenberg-Marquardt';

% CMData.FitKicks    = 'Yes';
% CMData.FitCoupling = 'No';
% 
% BPMData.FitGains    = 'Yes';
% BPMData.FitCoupling = 'No';


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


ModeCell = {'Fit Quadrupoles by New Power Supply','Fit Quadrupoles by Magnet','Fit Quadrupoles by Magnet and Fit Quadrupole tilt','Fit Quadrupole by Magnet and Fit Bending magnet tilt',...
            'No Parameter Setup'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString','Fit Parameter Selection:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 2);
if OKFlag ~= 1
    ButtonName = 2;
end
drawnow;
FitParameters = [];
N = 0;
switch ButtonName
    case 1 %'Fit by Power Supply'

        fprintf('\n   Quadrupole Parameter Fits (strength) by Power Supply (12 Parameters)\n');

        Families = {'QF','QD','QFA','QDA','QF11_MPW','QD21_MPW','QF31_MPW','QF18_MPW','QD28_MPW','QF38_MPW','QF1_SWLS','QD2_SWLS'};

        for i = 1:length(Families)
            % K-values
            Family = Families{i};
            ATIndex = family2atindex(Family);
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex,'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(1,1));
            FitParameters.Deltas(N,1) = NaN;
        end

    case 2 %'Fit by Magnet'

        fprintf('\n   Quadrupole Parameter Fits(strength) by Magnet (28 Parameters)\n');

       Families = {'QF11_MPW','QF','QF1_SWLS','QF18_MPW','QD21_MPW','QD','QD2_SWLS','QD28_MPW','QF31_MPW','QFA','QF38_MPW','QDA'};
        for i = 1:length(Families)
            Family = Families{i};

            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end

    case 3 %Fit by Magnet and fit Quadrupole tilt
        fprintf('\n   Quadrupole Parameter Fits(strength,tilt) by Magnet (56 Parameters)\n');
        
        Families = {'QF','QD','QFA','QDA'};
        for i = 1:length(Families)
            Family = Families{i};
            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end
        for i = 1:length(Families)
            Family = Families{i};

            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'tilt');
                FitParameters.Values(N,1) = 0;
                FitParameters.Deltas(N,1) = 0.5e-3;
            end
        end
        
    case 4 %Fit by Magnet and fit all magnet tilt
        fprintf('\n   Quadrupole Parameter Fits(strength,tilt) by Magnet and Bending parameter(tilt) Fit (64 Parameters)\n');
        
        Families = {'QF','QD','QFA','QDA'};
        for i = 1:length(Families)
            Family = Families{i};
            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end
        for i = 1:length(Families)
            Family = Families{i};

            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'tilt');
                FitParameters.Values(N,1) = 0;
                FitParameters.Deltas(N,1) = 0.5e-3;
            end
        end
        
        Family = 'BEND';
        % K-values
        ATIndex = family2atindex(Family);
        for loop = 1:size(ATIndex,1)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop),'tilt');
            FitParameters.Values(N,1) = 0;
            FitParameters.Deltas(N,1) = 0.5e-2;
        end
end


% Skew quadrupole fits
% isf  =  findcells(RINGData.Lattice,'FamName','SF');
% isd  =  findcells(RINGData.Lattice,'FamName','SD');
% isAT  =  sort([isf isd]);
% isext=[1 34];    %indices of 12 skew sextupole (on basis of 1-36 in CLS)
% isATon=isAT(isext);
% SQValues = getcellstruct(RINGData.Lattice,'PolynomA',isATon);

ModeCell = {'Fit at all SF & SD Magnets (16)', 'Fit All SF, SD, & QF Magnets (24)', 'Fit Rolls at All Magnets', 'Fit normal and skew quadrupoles at sextupole magnets (32)','Do Not Fit Skew Quadrupoles'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 1);
drawnow;
if OKFlag ~= 1
    ButtonName = 3;  % Default
end
switch ButtonName
    case 1 % 'Fit All SF & SD Magnets (16)'
        fprintf('  %3d - %3d Skew at SF (8)\n', N+1,    N+8);
        fprintf('  %3d - %3d Skew at SD (8)\n', N+1+8, N+8+8);

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        SDI = findcells(RINGData.Lattice,'FamName','SD');

        for loop=1:8
            if length(SFI) == 8
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
                % Tip edit
                %FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'PolynomA',SFI(loop));
            elseif length(SFI) == 16
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
                %Tip edit
                %FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'PolynomA',SFI(loop));           
            else
                error('   Error setting the SF skew parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(8,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(8,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:8
            if length(SDI) == 8
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
            elseif length(SDI) == 16
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
            else
                error('   Error setting the SD skew parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(8,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(8,1)];  % automatic delta determination does not work if starting value is 0

        CMData.FitCoupling   = 'Yes';
        BPMData.FitCoupling  = 'Yes';
        LocoFlags.Coupling   = 'Yes';

    case 2 % 'Fit All SF, SD, & QF Magnets'
        fprintf('  %3d - %3d Skew at SF  (8)\n', N+1,    N+8);
        fprintf('  %3d - %3d Skew at SD  (8)\n', N+1+8,  N+8+8);
        fprintf('  %3d - %3d Skew at QF  (8)\n', N+1+16, N+16+8);

        % Skew quadrupoles are in the sextupoles
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        QFI = findcells(RINGData.Lattice,'FamName','QF');

        for loop=1:8
            if length(SFI) == 8
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'s');
            elseif length(SFI) == 16
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI([N1 N2]),'s');
            else
                error('   Error setting the SF skew parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(8,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(8,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:8
            if length(SDI) == 8
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'s');
            elseif length(SDI) == 16
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI([N1 N2]),'s');
            else
                error('   Error setting the SD skew parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(8,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(8,1)];  % automatic delta determination does not work if starting value is 0

        for loop=1:8
            if length(QFI) == 8
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'s');
            elseif length(QFI) == 16
                % Split sextupoles
                N1 = 2*loop-1;
                N2 = 2*loop;
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI([N1 N2]),'s');
            else
                error('   Error setting the QFA skew parameter group.');
            end
        end
        FitParameters.Values = [FitParameters.Values; zeros(8,1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5 * ones(8,1)];  % automatic delta determination does not work if starting value is 0

        CMData.FitCoupling   = 'Yes';
        BPMData.FitCoupling  = 'Yes';
        LocoFlags.Coupling   = 'Yes';

    case 3 % 'Fit normal and skew quadrupoles at sextupole magnets
        Families = {'SF','SD'};

        for i = 1:length(Families)
            Family = Families{i};

            % S-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = 0;
                FitParameters.Deltas(N,1) = 0.5e-2;
            end
        end
        for i = 1:length(Families)
            Family = Families{i};

            % S-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'s');
                FitParameters.Values(N,1) = 0;
                FitParameters.Deltas(N,1) = 0.5e-2;
            end
        end
        
        CMData.FitCoupling   = 'Yes';
        BPMData.FitCoupling  = 'Yes';
        LocoFlags.Coupling   = 'Yes';
        
    case 4 % 'Fit Rolls at All Magnets'
        
        % 8 QF Rolls
        fprintf('  %3d - %3d QF Roll (8)\n', N+1, N+8);
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFI),1)];

        % 8 QD Rolls
        fprintf('  %3d - %3d QD Roll (8)\n', N+1, N+8);
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDI),1)];

        % 8 QFA Rolls
        fprintf('  %3d - %3d QFA Roll (8)\n', N+1, N+8);
        QFAI = findcells(RINGData.Lattice,'FamName','QFA');
        for loop=1:length(QFAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QFAI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFAI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFAI),1)];

        % 4 QDA Rolls
        fprintf('  %3d - %3d QDA Roll (4)\n', N+1, N+4);
        QDAI = findcells(RINGData.Lattice,'FamName','QDA');
        for loop=1:length(QDAI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,QDAI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDAI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDAI),1)];

        % 8 BEND Rolls
        fprintf('  %3d - %3d BEND Roll (8)\n', N+1, N+8);
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,BENDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(BENDI),1)];

        
%         % 8 SF Rolls
%         fprintf('  %3d - %3d SF Roll (8)\n', N+1, N+8);
%         SFI = findcells(RINGData.Lattice,'FamName','SF');
%         for loop=1:length(SFI)
%             N = N + 1;
%             FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SFI(loop),'tilt');
%         end
%         FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
%         FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SFI),1)];
% 
%         % 8 SD Rolls
%         fprintf('  %3d - %3d SD Roll (8)\n', N+1, N+8);
%         SDI = findcells(RINGData.Lattice,'FamName','SD');
%         for loop=1:length(SDI)
%             N = N + 1;
%             FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,SDI(loop),'tilt');
%         end
%         FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
%         FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SDI),1)];

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


