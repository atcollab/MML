function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName)
%BUILDLOCOFITPARAMETERS - Spear3 LOCO fit parameters
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

RemoveHBPMDeviceList = [];
RemoveVBPMDeviceList = [];



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
        if all(MachineConfig.SFM.Setpoint.Data == 0)
            fprintf('   Turning SFM family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SFM')';
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
        if all(MachineConfig.SDM.Setpoint.Data == 0)
            fprintf('   Turning SDM family off in the LOCO model.\n');
            ATIndex = findcells(RINGData.Lattice,'FamName','SDM')';
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
LocoFlags.Threshold = 3e-4;
% LocoFlags.OutlierFactor = 10;
% LocoFlags.SVmethod = 1e-2;
LocoFlags.HorizontalDispersionWeight = 1;
LocoFlags.VerticalDispersionWeight = 4;
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


% Corrector magnets to disable
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

fprintf('   Using default fit parameters:\n');
THERING = RINGData.Lattice;
isf  =  findcells(THERING,'FamName','SF');
isd  =  findcells(THERING,'FamName','SD');
isfi =  findcells(THERING,'FamName','SFM');
isdi =  findcells(THERING,'FamName','SDM');
isAT  = sort([isf isd isfi isdi]);
isext = [4 7 11 19 26 30 33 40 43 47 54 62 66 69];    %indices of 14 skew sextupole (on basis of 1-72 in SPEAR 3)
isATon = isAT(isext);  

% *********** Setup FitParameters for LOCO ********************
FitParameters = [];

QFI = findcells(THERING,'FamName','QF');
QDI = findcells(THERING,'FamName','QD');
QFCI = findcells(THERING,'FamName','QFC');
QDXI = findcells(THERING,'FamName','QDX');
QFXI = findcells(THERING,'FamName','QFX');
QDYI = findcells(THERING,'FamName','QDY');
QFYI = findcells(THERING,'FamName','QFY');
QDZI = findcells(THERING,'FamName','QDZ');
QFZI = findcells(THERING,'FamName','QFZ');
Q9SI = findcells(THERING,'FamName','Q9S');

QFValues = getcellstruct(THERING,'K',[ QFI(1:2) QFI(3) QFI(7:length(QFI))] );
QDValues = getcellstruct(THERING,'K',[ QDI(1:2) QDI(3) QDI(7:length(QDI))] );
QFCValues = getcellstruct(THERING,'K',QFCI(1));
QDXValues = getcellstruct(THERING,'K',[ QDXI(1) QDXI(2) QDXI(3)] );
QFXValues = getcellstruct(THERING,'K',[ QFXI(1) QFXI(2) QFXI(3)] );
QDYValues = getcellstruct(THERING,'K',[ QDYI(1) QDYI(2) QDYI(3)] );
QFYValues = getcellstruct(THERING,'K',[ QFYI(1) QFYI(2) QFYI(3)] );
QDZValues = getcellstruct(THERING,'K',[ QDZI(1) QDZI(2) QDZI(3)] );
QFZValues = getcellstruct(THERING,'K',[ QFZI(1) QFZI(2) QFZI(3)] );
Q9SValues = getcellstruct(THERING,'K',[ Q9SI(1) Q9SI(3) Q9SI(4)] );


% BNDI = findcells(THERING,'FamName','BEND');
% BDMI = findcells(THERING,'FamName','BDM');
% KBND = THERING{BNDI(1)}.K;
% KBDM = THERING{BDMI(1)}.K;

SQValues = getcellstruct(THERING, 'PolynomA', isATon, 2);

fprintf('   Using default fit parameters:\n');
fprintf('   1. Individual fit on all Quadrupole (QF, QD, QFC, QFX, QDX, QFY, QDY, QFZ, QDZ, Q9S)\n');
fprintf('   2. Fit skew quadrupoles\n');
FitParameters.Values = [QFValues; QDValues; QFCValues; QDXValues; QFXValues; QDYValues; QFYValues; QDZValues; QFZValues; Q9SValues; SQValues];
% FitParameters.Values =[QFValues; QDValues; QFCValues; QDXValues; QFXValues; QDYValues; QFYValues; QDZValues; QFZValues; KBND; KBDM; SQValues];

FitParameters.Params = cell(size(FitParameters.Values));
pos = 0;
for i = 1:2
    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice,QFI(i),'K');
end
pos = pos + 2;

FitParameters.Params{pos+1} = mkparamgroup(RINGData.Lattice,QFI(3:6),'K');
pos = pos + 1;
for i = 7:length(QFI)
    FitParameters.Params{pos+i-6} = mkparamgroup(RINGData.Lattice,QFI(i),'K');
end
pos = pos + length(QFI)-6;

for i = 1:2
    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice,QDI(i),'K');
end
pos = pos + 2;

FitParameters.Params{pos+1} = mkparamgroup(RINGData.Lattice,QDI(3:6),'K');
pos = pos + 1;

for i = 7:length(QDI)
    FitParameters.Params{pos+i-6} = mkparamgroup(RINGData.Lattice,QDI(i),'K');
end
pos = pos + length(QDI)-6;

FitParameters.Params{pos+1}  = mkparamgroup(RINGData.Lattice, QFCI,'K');
FitParameters.Params{pos+2}  = mkparamgroup(RINGData.Lattice,[QDXI(1) QDXI(4)],'K');
FitParameters.Params{pos+3}  = mkparamgroup(RINGData.Lattice,QDXI(2),'K');
FitParameters.Params{pos+4}  = mkparamgroup(RINGData.Lattice,QDXI(3),'K');
FitParameters.Params{pos+5}  = mkparamgroup(RINGData.Lattice,[QFXI(1) QFXI(4)],'K');
FitParameters.Params{pos+6}  = mkparamgroup(RINGData.Lattice,QFXI(2),'K');
FitParameters.Params{pos+7}  = mkparamgroup(RINGData.Lattice,QFXI(3),'K');
FitParameters.Params{pos+8}  = mkparamgroup(RINGData.Lattice,[QDYI(1) QDYI(4)],'K');
FitParameters.Params{pos+9}  = mkparamgroup(RINGData.Lattice,QDYI(2),'K');
FitParameters.Params{pos+10}  = mkparamgroup(RINGData.Lattice,QDYI(3),'K');
FitParameters.Params{pos+11}  = mkparamgroup(RINGData.Lattice,[QFYI(1) QFYI(4)],'K');
FitParameters.Params{pos+12}  = mkparamgroup(RINGData.Lattice,QFYI(2),'K');
FitParameters.Params{pos+13}  = mkparamgroup(RINGData.Lattice,QFYI(3),'K');
FitParameters.Params{pos+14} = mkparamgroup(RINGData.Lattice,[QDZI(1) QDZI(4)],'K');
FitParameters.Params{pos+15} = mkparamgroup(RINGData.Lattice,QDZI(2),'K');
FitParameters.Params{pos+16} = mkparamgroup(RINGData.Lattice,QDZI(3),'K');
FitParameters.Params{pos+17} = mkparamgroup(RINGData.Lattice,[QFZI(1) QFZI(4)],'K');
FitParameters.Params{pos+18} = mkparamgroup(RINGData.Lattice,QFZI(2),'K');
FitParameters.Params{pos+19} = mkparamgroup(RINGData.Lattice,QFZI(3),'K');
FitParameters.Params{pos+20} = mkparamgroup(RINGData.Lattice,[Q9SI(1) Q9SI(2)],'K');  %split quadrupole
FitParameters.Params{pos+21} = mkparamgroup(RINGData.Lattice,Q9SI(3),'K');
FitParameters.Params{pos+22} = mkparamgroup(RINGData.Lattice,[Q9SI(4) Q9SI(5)],'K');  %split quadrupole
pos = pos + 22;
% FitParameters.Params{pos+1} = mkparamgroup(RINGData.Lattice,BNDI,'K');
% FitParameters.Params{pos+2} = mkparamgroup(RINGData.Lattice,BDMI,'K');
% pos = pos + 2;
for i = 1:length(isext)
    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice, isATon(i), 's');
end
pos = pos + length(isext);



%%%%%%%%%%%%%%%%%%%%%
% Parameter Weights %
%%%%%%%%%%%%%%%%%%%%%

% For each cell of FitParameters.Weight.Value, a rows is added to the A matrix
% Index of the row of A:  FitParameters.Weight.Index{i}
% Value of the weight:    FitParameters.Weight.Value{i} / mean(Mstd)

%FlagAddConstr = 0;   % No Weights
FlagAddConstr = 1;    % Constraint the norm of quads
%FlagAddConstr = 2;   % Constraint the norm of quads and skew quads
switch FlagAddConstr
    case 0
        % No Weights
        if isfield(FitParameters, 'Weight')
            FitParameters = rmfield(FitParameters, 'Weight');
        end
    case 1
        quadindex  = [53, 54, 56, 57, 70, 71, 72];
        quadweight = [1, 1, 1, 1, 1, 1, 1]*0.05;
        for ii = 1:72
            FitParameters.Weight.Index{ii,1} = ii;
            FitParameters.Weight.Value{ii,1} = 0.01;
        end
        for ii = 1:length(quadindex)
            FitParameters.Weight.Value{quadindex(ii)} = quadweight(ii);
        end
    case 2
        NumFitPara = length(FitParameters.Values);
        quadindex  = [53, 54, 56, 57, 70, 71, 72];
        quadweight = [1, 1, 1, 1, 1, 1, 1]*0.05;
        
        for ii = 1:72
            FitParameters.Weight.Index{ii,1} = ii;
            FitParameters.Weight.Value{ii,1} = .01;
        end
        for ii = 73:NumFitPara
            FitParameters.Weight.Index{ii,1} = ii;
            FitParameters.Weight.Value{ii,1} = .02;
        end
        for ii = 1:length(quadindex)
            FitParameters.Weight.Value{quadindex(ii)} = quadweight(ii);
        end
end

    

% Starting point for the deltas (automatic delta determination does not work if starting value is 0)
FitParameters.Deltas = 0.0001 * ones(size(FitParameters.Values));


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


