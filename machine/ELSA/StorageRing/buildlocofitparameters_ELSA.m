function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters_ELSA(FileName, QuadFit, SkewFit)
%BUILDLOCOFITPARAMETERS - ELSA LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName, QuadFit, SkewFit)
%
%  QuadFit - 0 - No quadrupole parameter fit parameters
%            1 - Fit magnets by power supply
%            2 - Fit QF, QD by magnet & the normal BEND by power supply
%            3 - Fit by magnet
%            
%  SkewFit - 0 - No coupling fit parameters
%            1 - Fit skews at SF & SD magnets


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


% Quads & Sexts
if nargin < 2
    ModeCell = {'No parameter setup' 
        'Fit magnets by power supply' 
        'Fit QF, QD by magnet' 
        'Fit BENDS by magnet'
        'Fit QF, QD by magnet & the BEND by power supply' 
        'Fit QF, QD & BEND by magnet'};
    [QuadFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Quadrupole components (not including skew quadrupoles or sextupoles)','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [435 110], 'InitialValue', 1);
    QuadFit = QuadFit - 1;
    drawnow;
    if OKFlag ~= 1
        QuadFit = 1;
    end
end


ModeCell = {'No parameter setup'
    'Fit SF, SD by magnet'
    };
[QuadAtSextFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Quadrupole components at SF, SD magnets?:','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125]);
QuadAtSextFit = QuadAtSextFit - 1;
if OKFlag ~= 1
    QuadAtSextFit = 1;
end
drawnow;


% Skew quads
if nargin < 3
%     ModeCell = {
%         'Do not fit coupling terms' 
%         'Fit all QF & QD magnets'
%         'Fit all SF & SD magnets' 
%         'Fit all QF, QD, SF und SD magnets'};
%     [SkewFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 1);
%     SkewFit = SkewFit - 1;
%     if OKFlag ~= 1
%         SkewFit = 1;  % Default
%     end
    
      ModeCell = {'Do not fit coupling terms'
          'Fit SF, SD by magnet'
          'Fit QF, QD by magnet'
          'Fit BENDS by magnet'
          };
      [SkewFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection: (multiple selection possible):'}, 'SelectionMode','multiple', 'ListString', ModeCell, 'ListSize', [350 125]);
      SkewFit = SkewFit - 1;
      if OKFlag ~= 1
          SkewFit = 1;  % Default
      end
      drawnow;
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
            ATIndex = findcells(RINGData.Lattice,'FamName','SF')';
            for i = 1:length(ATIndex)
                RINGData.Lattice{ATIndex(i)}.PolynomB(3) = 0;
            end
        end
        if all(LocoMeasData.MachineConfig.SD.Setpoint.Data == 0)
            fprintf('   Turning SD family off in the LOCO model.\n\n');
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
        fprintf('   No fit of quadrupole components in QF, QD or BEND magnets.\n\n')
    case 1 % Fit by Power Supply
        
        % QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFI),1)];
        
        % QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];

        % All normal bend magnet K-values fit as a group
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        
    case 2 % Fit QF, QD by magnet
        
        % QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFI),1)];
        
        
        % QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];
        
 
    case 3 % Fit BENDS by magnet
        
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(BENDI),1)];
        
        
    case 4 % Fit QF, QD by magnet & the BEND by power supply
        
        % QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFI),1)];
        
        
        % QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];

        % Normal bend magnet K-values fit as a group
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');
        N = N + 1;
        FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI,'K');
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI(1))];
        FitParameters.Deltas = [FitParameters.Deltas; NaN];

        
    case 5 %'Fit QF, QD & BEND by magnet'
        % QF K-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QFI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QFI),1)];
        
        % QD K-values
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',QDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(QDI),1)];
                
        % Normal bend magnet K-values
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; getcellstruct(RINGData.Lattice,'K',BENDI)];
        FitParameters.Deltas = [FitParameters.Deltas; NaN * ones(length(BENDI),1)];
        
        
    otherwise
        fprintf('   No fit of quadrupole components in QF, QD or BEND magnets.\n\n')        
end



% ... and K-values for SF, SD MAGNETS

for n=1:length(QuadAtSextFit)
    if QuadAtSextFit(n)==0
       fprintf('   No fit of quadrupole components at sextupole magnets.\n\n')

    elseif QuadAtSextFit(n)==1
       
        % SF K-values
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        % SD K-values
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'K');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
    else
        fprintf('   No fit of quadrupole components at sextupole magnets.\n\n')
    end
end



% Coupling & skew quadrupole fits


for n=1:length(SkewFit)
    
    if SkewFit(n)==0
       fprintf('   No coupling fits.\n\n');
       FitSkewQuad = 0;
       
       
    elseif SkewFit(n)==1
        
        % Skew quadrupoles are in the sextupoles
        FitSkewQuad = 1;
        
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        SDI = findcells(RINGData.Lattice,'FamName','SD');       
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
                
        
    elseif SkewFit(n)==2
        FitSkewQuad = 1;
        
        % QF & QD s-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(QFI),1)]; % automatic delta determination does not work if starting value is 0
        
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(QDI),1)]; % automatic delta determination does not work if starting value is 0
        
        
    elseif SkewFit(n)==3
        FitSkewQuad = 1;
        
        % BEND s-values
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'s');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(BENDI),1)];
        
    else
        fprintf('   No coupling fits.\n\n');
        FitSkewQuad = 0;
    end
end


if FitSkewQuad == 1;
    CMData.FitCoupling   = 'Yes';
    BPMData.FitCoupling  = 'Yes';
    LocoFlags.Coupling   = 'Yes';
end



% Sextupole component fits

      ModeCell = {'Do not fit sextupole components'
          'Fit SF, SD by magnet'
          'Fit QF, QD by magnet'
          'Fit BENDS by magnet (for consideration of the magnetized chamber ribs)'
          };
      [SextFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Sextupole component Fits?','Fit Parameter Selection: (multiple selection possible):'}, 'SelectionMode','multiple', 'ListString', ModeCell, 'ListSize', [400 125]);
      SextFit = SextFit - 1;
      if OKFlag ~= 1
          SextFit = 1;  % Default
      end
      drawnow;
      

for n=1:length(SextFit)
    
    if SextFit(n)==0
       fprintf('   No sextpole component fits.\n\n');
       
       
    elseif SextFit(n)==1
        
        % SF & SD k2-values
        
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'k2');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        SDI = findcells(RINGData.Lattice,'FamName','SD');       
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'k2');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
                
        
    elseif SextFit(n)==2
        
        % QF & QD k2-values
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'k2');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(QFI),1)]; % automatic delta determination does not work if starting value is 0
        
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'k2');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(QDI),1)]; % automatic delta determination does not work if starting value is 0
        
        
    elseif SextFit(n)==3
        
        % BEND k2-values
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'k2');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 0.5e-2 * ones(length(BENDI),1)];
        

    else
        fprintf('   No sextupole component fits.\n\n');
    end
end



% Roll fits of all type of magnets

ModeCell = {'No parameter setup'
    'Fit BENDS by magnet'
    'Fit QF, QD by magnet'
    'Fit SF, SD by magnet'
    };
[RollFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Rolls of various magnets?','Fit Parameter Selection: (multiple selection possible):'}, 'SelectionMode','multiple', 'ListString', ModeCell, 'ListSize', [350 125]);
if OKFlag ~= 1
    RollFit = 1;
end
drawnow;


for n=1:length(RollFit)
    if RollFit(n)==1
       fprintf('   No fit of magnet rolls.\n\n')
       
       
    elseif RollFit(n)==2
        
        % Fit BEND ROLLS by magnets
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(BENDI),1)];
        
        
    elseif RollFit(n)==3
        
        % Fit QF ROLLS by magnets
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFI),1)];
        
        % Fit QD ROLLS by magnets
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDI),1)];
        
        
    elseif RollFit(n)==4
       
        % Fit SF ROLLS by magnets
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        % Fit SD ROLLS by magnets  
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'tilt');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
                
      
% No roll fitting for corrector magnets! It's calculated by >> setlocodata 
% out of the values "gain" and "coupling".
      
    else
       fprintf('   No fit of magnet rolls.\n\n')        
    end
end



% Shift fits of all type of magnets in x direction

ModeCell = {'No parameter setup'
    'Fit BENDS by magnet'
    'Fit QF, QD by magnet'
    'Fit SF, SD by magnet'
    };
[ShiftxFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Shifts in x direction of various magnets?','Fit Parameter Selection: (multiple selection possible):'}, 'SelectionMode','multiple', 'ListString', ModeCell, 'ListSize', [350 125]);
if OKFlag ~= 1
    ShiftxFit = 1;
end
drawnow;


for n=1:length(ShiftxFit)
    if ShiftxFit(n)==1
       fprintf('   No fit of magnet shifts in horizontal direction.\n\n')
       
       
    elseif ShiftxFit(n)==2
        
        % Fit BEND SHIFTS_X by magnets
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'shiftx');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(BENDI),1)];
        
        
    elseif ShiftxFit(n)==3
        
        % Fit QF SHIFTS_X by magnets
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'shiftx');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFI),1)];
        
        % Fit QD SHIFTS_X by magnets
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'shiftx');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDI),1)];
        
        
    elseif ShiftxFit(n)==4
       
        % Fit SF SHIFTS_X by magnets
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'shiftx');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        % Fit SD ROLLS by magnets  
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'shiftx');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
                
        
    else
       fprintf('   No fit of magnet shifts in horizontal direction.\n\n')        
    end
end




% Shift fits of all type of magnets in y direction

ModeCell = {'No parameter setup'
    'Fit BENDS by magnet'
    'Fit QF, QD by magnet'
    'Fit SF, SD by magnet'
    };
[ShiftyFit, OKFlag] = listdlg('Name','BUILDLOCOINPUT','PromptString',{'Shifts in y direction of various magnets?','Fit Parameter Selection: (multiple selection possible):'}, 'SelectionMode','multiple', 'ListString', ModeCell, 'ListSize', [350 125]);
if OKFlag ~= 1
    ShiftyFit = 1;
end
drawnow;


for n=1:length(ShiftyFit)
    if ShiftyFit(n)==1
       fprintf('   No fit of magnet shifts in vertical direction.\n\n')
       
       
    elseif ShiftyFit(n)==2
        
        % Fit BEND SHIFTS_Y by magnets
        BENDI = findcells(RINGData.Lattice,'FamName','BEND');        
        for loop=1:length(BENDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,BENDI(loop),'shifty');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(BENDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(BENDI),1)];
        
        
    elseif ShiftyFit(n)==3
        
        % Fit QF SHIFTS_Y by magnets
        QFI = findcells(RINGData.Lattice,'FamName','QF');
        for loop=1:length(QFI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QFI(loop),'shifty');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QFI),1)];
        
        % Fit QD SHIFTS_Y by magnets
        QDI = findcells(RINGData.Lattice,'FamName','QD');
        for loop=1:length(QDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,QDI(loop),'shifty');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(QDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(QDI),1)];
        
        
    elseif ShiftyFit(n)==4
       
        % Fit SF SHIFTS_Y by magnets
        SFI = findcells(RINGData.Lattice,'FamName','SF');
        for loop=1:length(SFI)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SFI(loop),'shifty');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SFI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SFI),1)];  % automatic delta determination does not work if starting value is 0
        
        % Fit SD SHIFTS_Y by magnets  
        SDI = findcells(RINGData.Lattice,'FamName','SD');
        for loop=1:length(SDI)
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup_ELSA(RINGData.Lattice,SDI(loop),'shifty');
        end
        FitParameters.Values = [FitParameters.Values; zeros(length(SDI),1)];
        FitParameters.Deltas = [FitParameters.Deltas; 1e-6*ones(length(SDI),1)];  % automatic delta determination does not work if starting value is 0
               
      
    else
       fprintf('   No fit of magnet shifts in vertical direction.\n\n')        
    end
end



fprintf('\n');


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


