function [mCorRespX, mCorRespZ] = idCalcCorRespMatr(idName, gap, dirMeas)
% Modified by Fabien on December 4th : the correctors current values are
% not an argument of the function anymore. See idCalcCorRespMatr_old in
% case of problem!


[arElecBeamMeasCHE, arElecBeamMeasBkgrCHE, vCurValsCHE] = idReadCorElecBeamMeasData(idName, gap, 'CHE');
[arElecBeamMeasCVE, arElecBeamMeasBkgrCVE, vCurValsCVE] = idReadCorElecBeamMeasData(idName, gap, 'CVE');
[arElecBeamMeasCHS, arElecBeamMeasBkgrCHS, vCurValsCHS] = idReadCorElecBeamMeasData(idName, gap, 'CHS');
[arElecBeamMeasCVS, arElecBeamMeasBkgrCVS, vCurValsCVS] = idReadCorElecBeamMeasData(idName, gap, 'CVS');

dirStart = pwd;
if strcmp(dirMeas, '')
    dirMeas = getfamilydata('Directory',idName);
end

cd(dirMeas);
stMeas = load(char(arElecBeamMeasCHE(1)));
cd(dirStart);

numCurValsCHE = length(vCurValsCHE);
numCurValsCVE = length(vCurValsCVE);
numCurValsCHS = length(vCurValsCHS);
numCurValsCVS = length(vCurValsCVS);
numBPMs = length(stMeas.X);
mCorRespX = zeros(numBPMs, 2);
mCorRespZ = zeros(numBPMs, 2);

arStMeasCHE = cell(1, numCurValsCHE);
arStMeasCVE = cell(1, numCurValsCVE);
arStMeasCHS = cell(1, numCurValsCHS);
arStMeasCVS = cell(1, numCurValsCVS);
arStMeasBkgrCHE = cell(1, numCurValsCHE);
arStMeasBkgrCVE = cell(1, numCurValsCVE);
arStMeasBkgrCHS = cell(1, numCurValsCHS);
arStMeasBkgrCVS = cell(1, numCurValsCVS);

cd(dirMeas);
for j = 1:numCurValsCHE
	arStMeasCHE{j} = load(char(arElecBeamMeasCHE(j)));
    arStMeasBkgrCHE{j} = load(char(arElecBeamMeasBkgrCHE(j)));
end
for j = 1:numCurValsCVE
    arStMeasCVE{j} = load(char(arElecBeamMeasCVE(j)));
    arStMeasBkgrCVE{j} = load(char(arElecBeamMeasBkgrCVE(j)));
end
for j = 1:numCurValsCHS
    arStMeasCHS{j} = load(char(arElecBeamMeasCHS(j)));
	arStMeasBkgrCHS{j} = load(char(arElecBeamMeasBkgrCHS(j)));
end
for j = 1:numCurValsCVS
    arStMeasCVS{j} = load(char(arElecBeamMeasCVS(j)));
	arStMeasBkgrCVS{j} = load(char(arElecBeamMeasBkgrCVS(j)));
end
cd(dirStart);

arAuxCHE = zeros(numCurValsCHE, 1);
arAuxCVE = zeros(numCurValsCVE, 1);
arAuxCHS = zeros(numCurValsCHS, 1);
arAuxCVS = zeros(numCurValsCVS, 1);

for i = 1:numBPMs
    for j = 1:numCurValsCHE
        stMeasCHE = arStMeasCHE{j};
        stMeasBkgrCHE = arStMeasBkgrCHE{j};
        arAuxCHE(j) = stMeasCHE.X(i) - stMeasBkgrCHE.X(i);
    end
    for j = 1:numCurValsCVE
        stMeasCVE = arStMeasCVE{j};
        stMeasBkgrCVE = arStMeasBkgrCVE{j};
        arAuxCVE(j) = stMeasCVE.Z(i) - stMeasBkgrCVE.Z(i);
    end
    for j = 1:numCurValsCHS
        stMeasCHS = arStMeasCHS{j};
        stMeasBkgrCHS = arStMeasBkgrCHS{j};
        arAuxCHS(j) = stMeasCHS.X(i) - stMeasBkgrCHS.X(i);
    end
    for j = 1:numCurValsCVS
        stMeasCVS = arStMeasCVS{j};
        stMeasBkgrCVS = arStMeasBkgrCVS{j};
        arAuxCVS(j) = stMeasCVS.Z(i) - stMeasBkgrCVS.Z(i);
    end
    
    mCorRespX(i, 1) = idLeastSqLineTilt(vCurValsCHE, arAuxCHE);
    mCorRespX(i, 2) = idLeastSqLineTilt(vCurValsCHS, arAuxCHS);
    mCorRespZ(i, 1) = idLeastSqLineTilt(vCurValsCVE, arAuxCVE);
    mCorRespZ(i, 2) = idLeastSqLineTilt(vCurValsCVS, arAuxCVS);
end


