function xraylocoprepfam

% Get buildlocoinput data
[LOCOFile, LOCODirectory, FilterIndex] = uigetfile('*.mat','Select a LOCO input data file');
if FilterIndex == 0
    fprintf('   makelocoinputdata aborted\n');
    return
end

load([LOCODirectory LOCOFile]);

% Reset to iteration zero
BPMData = BPMData(1);   
CMData = CMData(1);   
%LocoFlags = LocoFlags(1);
LocoModel = []; 


% *********** Setup FitParameters for LOCO ********************

FitParameters = [];
global THERING
BENDI = findcells(THERING, 'FamName', 'BEND');

QAI = findcells(THERING, 'FamName', 'QA');
QBI = findcells(THERING, 'FamName', 'QB');
QCI = findcells(THERING, 'FamName', 'QC');
QDI = findcells(THERING, 'FamName', 'QD');

SQI = findcells(THERING, 'FamName', 'SQ');

SFI = findcells(THERING, 'FamName', 'SF');
SDI = findcells(THERING, 'FamName', 'SD');


% This assumes that QAs QBs and QCs are all the same, QDs have 8 values
BENDValues = getcellstruct(THERING, 'K', BENDI(1:length(BENDI)));

QAValues = getcellstruct(THERING, 'K', QAI(1:length(QAI)));
QBValues = getcellstruct(THERING, 'K', QBI(1:length(QBI)));
QCValues = getcellstruct(THERING, 'K', QCI(1:length(QCI)));
QDValues = getcellstruct(THERING, 'K', QDI(1:length(QDI)));

SFValues = getcellstruct(THERING, 'PolynomB', SFI(1:length(SFI)), 2);
SDValues = getcellstruct(THERING, 'PolynomB', SDI(1:length(SDI)), 2);

SQValues = getcellstruct(THERING, 'PolynomA', SQI(1:length(SQI)), 2);

if 1
    % By family + all QD's
   % FitParameters.Values = [BENDValues(1); QAValues; QBValues; QCValues; QDValues];
    FitParameters.Values = [QAValues(1); QBValues(1); QCValues(1); QDValues(1)];
%    FitParameters.Values = [QAValues(1); QBValues(1); QCValues(1); QDValues; SQValues];
%    FitParameters.Values = [QAValues(1); QBValues(1); QCValues(1); QDValues(1); SFValues; SDValues];
%    FitParameters.Values = [QAValues; QBValues; QCValues; QDValues; SFValues; SDValues];
%    
    FitParameters.Params = cell(size(FitParameters.Values));
    %FitParameters.Params{1} = mkparamgroup(RINGData.Lattice, BENDI, 'K');
    FitParameters.Params{1} = mkparamgroup(RINGData.Lattice, QAI, 'K');
    FitParameters.Params{2} = mkparamgroup(RINGData.Lattice, QBI, 'K');
    FitParameters.Params{3} = mkparamgroup(RINGData.Lattice, QCI, 'K');
    FitParameters.Params{4} = mkparamgroup(RINGData.Lattice, QDI, 'K');

%     pos = 1;
%     for i = 1:length(QAI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [QAI(i)], 'K');
%     end    
%     for i = 1:length(QBI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [QBI(i)], 'K');
%     end    
%     for i = 1:length(QCI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [QCI(i)], 'K');
%     end    
 %    pos = 3;
%     for i = 1:length(QDI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [QDI(i)], 'K');
%     end    
%    pos = 4;
%     for i = 1:length(SFI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [SFI(i)], 'K');
%     end    
%     for i = 1:length(SDI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [SDI(i)], 'K');
%     end    
%     for i = 1:length(SFI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [SFI(i)], 'KS1');
%     end    
%     for i = 1:length(SDI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [SDI(i)], 'KS1');
%     end    
%     for i = 1:length(SQI)
%         pos = pos + 1;
%         FitParameters.Params{pos} = mkparamgroup(RINGData.Lattice, [SQI(i)], 'S');
%     end    
else
    % Individual
    %pos = 0;
    %for i = 1:length(QAI)
    %    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice, [QAI(i)], 'K');
    %end
    %pos = pos + length(QAI);
    %for i = 1:length(QBI)
    %5    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice, [QBI(i)], 'K');
    %end
    %pos = pos + length(QBI);
    %for i = 1:length(QCI)
    %    FitParameters.Params{pos+i} = mkparamgroup(RINGData.Lattice, [QCI(i)], 'K');
    %end
    %pos = pos + length(QCI);
    pos = 3;
    for i = 2:length(QDI)
        if (i~=4)
            FitParameters.Params{pos+i-1} = mkparamgroup(RINGData.Lattice, [QDI(i)], 'K');
        else
            pos=pos-1;
        end
    end
    pos = pos + length(QDI);
end

FitParameters.Deltas = 0.0003*ones(size(FitParameters.Values));
FitParameters.DeltaRF = LocoMeasData.DeltaRF;

LocoFlags = [];
save([LOCODirectory LOCOFile], 'FitParameters', 'BPMData', 'CMData', 'LocoFlags', 'RINGData', 'LocoMeasData'); 