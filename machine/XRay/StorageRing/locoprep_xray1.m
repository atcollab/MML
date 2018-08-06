% ************ Setup RINGData for LOCO *****************
% Note that This M file has not finished yet!

xlatsurv


L0 =   findspos(THERING,length(THERING)+1);
C0 =   299792458; % speed of light [m/s]

RINGData.Lattice = THERING;
RINGData.CavityHarmNumber = 30;
RINGData.CavityFrequency = RINGData.CavityHarmNumber*C0/L0;

% *********** LocoMeasData for LOCO ********************
load LocoMeasData

% *********** Setup BPMData for LOCO ********************

% All are X-Y bpms
AllBPMI  = sort([findcells(THERING,'FamName','BPM')]);
HBPMI  = sort([findcells(THERING,'FamName','BPM')]);
VBPMI  = sort([findcells(THERING,'FamName','BPM')]);


BPMData.FamName = '';
BPMData.BPMIndex = AllBPMI;
BPMData.HBPMIndex = 1:length(AllBPMI);
BPMData.VBPMIndex =  1:length(AllBPMI);
BPMData.HBPMGoodDataIndex = 1:length(AllBPMI);
BPMData.VBPMGoodDataIndex = 1:length(AllBPMI);


% *********** Setup CMData for LOCO ********************
% Corrector names for this lattice are X[1-8]C#
% Xring correctors used by loco are 51 hor and 39 ver
% Correctors with # 2 or 17 are horizontal only
% Xring LOCO does not use BLW

HCORI=[];
VCORI=[];
for i = 1:length(THERING)
     name=THERING{i}.FamName;
    if  ( (length(name)>2) & (name(1)=='X') & (name(3)=='C') )
        if (name(length(name))~='2') & (name(length(name))~='7')
            VCORI=[VCORI i];
        end    
        HCORI=[HCORI i];
    end
end 


CMData.FamName  = '';
CMData.HCMIndex = HCORI;  % Must match the response matrix
CMData.VCMIndex = VCORI;

% 0.13 is just a starting guess
CMData.HCMKicks = 0.13*ones(length(CMData.HCMIndex),1);    % Must match the response matrix [milliradian] 
CMData.VCMKicks = 0.13*ones(length(CMData.VCMIndex),1);    % Must match the response matrix [milliradian]
CMData.HCMGoodDataIndex = 1:length(CMData.HCMIndex);    % Referenced to HCMIndex
CMData.VCMGoodDataIndex = 1:length(CMData.VCMIndex);    % Referenced to VCMIndex


% *********** Setup FitParameters for LOCO ********************

FitParameters = [];

QAI = findcells(THERING,'FamName','QA');
QBI = findcells(THERING,'FamName','QB');
QCI = findcells(THERING,'FamName','QC');
QDI = findcells(THERING,'FamName','QD');


% This assumes that QAs QBs and QCs are all the same, QDs have 8 values
% QAValues = getcellstruct(THERING,'K',QAI(1:length(QAI)));
% QBValues = getcellstruct(THERING,'K',QBI(1:length(QBI)));
% QCValues = getcellstruct(THERING,'K',QCI(1:length(QCI)));
  QDValues = getcellstruct(THERING,'K',QDI(1:length(QDI)));

FitParameters.Values =[THERING{QAI(1)}.K; THERING{QBI(1)}.K; THERING{QCI(1)}.K;QDValues];

FitParameters.Params = cell(size(FitParameters.Values));
FitParameters.Params{1} = mkparamgroup(RINGData.Lattice,QAI,'K');
FitParameters.Params{2} = mkparamgroup(RINGData.Lattice,QBI,'K');
FitParameters.Params{3} = mkparamgroup(RINGData.Lattice,QCI,'K');

%pos = 0;
%for i = 1:length(QAI)
%    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice,[QAI(i)],'K');
%end
%pos = pos + length(QAI);
%for i = 1:length(QBI)
%5    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice,[QBI(i)],'K');
%end
%pos = pos + length(QBI);
%for i = 1:length(QCI)
%    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice,[QCI(i)],'K');
%end
%pos = pos + length(QCI);
pos = 3;
for i = 2:length(QDI)
     if (i~=4)
    FitParameters.Params{pos+i-1} = mkparamgroup(RINGData.Lattice,[QDI(i)],'K');
    else
    pos=pos-1;
end
end
pos = pos + length(QDI);

FitParameters.Deltas = 0.0003*ones(size(FitParameters.Values));

FitParameters.DeltaRF = LocoMeasData.DeltaRF;

save('xraylocoinput0', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData'); 











