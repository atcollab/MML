function [mCorRespX, mCorRespZ] = idCalcCorRespMatr_old(idName, gap, dirMeas, arCorCurVals)

[arElecBeamMeasCHE, arElecBeamMeasBkgrCHE] = idReadCorElecBeamMeasData(idName, gap, 'CHE');
[arElecBeamMeasCVE, arElecBeamMeasBkgrCVE] = idReadCorElecBeamMeasData(idName, gap, 'CVE');
[arElecBeamMeasCHS, arElecBeamMeasBkgrCHS] = idReadCorElecBeamMeasData(idName, gap, 'CHS');
[arElecBeamMeasCVS, arElecBeamMeasBkgrCVS] = idReadCorElecBeamMeasData(idName, gap, 'CVS');

dirStart = pwd;
if strcmp(dirMeas, '')
    dirMeas = getfamilydata('Directory',idName);
end

cd(dirMeas);
stMeas = load(char(arElecBeamMeasCHE(1)));
cd(dirStart);

numCurVals = length(arCorCurVals);
numBPMs = length(stMeas.X);
mCorRespX = zeros(numBPMs, 2);
mCorRespZ = zeros(numBPMs, 2);

arStMeasCHE = cell(1, numCurVals);
arStMeasCVE = cell(1, numCurVals);
arStMeasCHS = cell(1, numCurVals);
arStMeasCVS = cell(1, numCurVals);
arStMeasBkgrCHE = cell(1, numCurVals);
arStMeasBkgrCVE = cell(1, numCurVals);
arStMeasBkgrCHS = cell(1, numCurVals);
arStMeasBkgrCVS = cell(1, numCurVals);

cd(dirMeas);
for j = 1:numCurVals
	arStMeasCHE{j} = load(char(arElecBeamMeasCHE(j)));
    arStMeasCVE{j} = load(char(arElecBeamMeasCVE(j)));
    arStMeasCHS{j} = load(char(arElecBeamMeasCHS(j)));
	arStMeasCVS{j} = load(char(arElecBeamMeasCVS(j)));
    arStMeasBkgrCHE{j} = load(char(arElecBeamMeasBkgrCHE(j)));
    arStMeasBkgrCVE{j} = load(char(arElecBeamMeasBkgrCVE(j)));
    arStMeasBkgrCHS{j} = load(char(arElecBeamMeasBkgrCHS(j)));
	arStMeasBkgrCVS{j} = load(char(arElecBeamMeasBkgrCVS(j)));
end
cd(dirStart);

arAuxCHE = zeros(numCurVals, 1);
arAuxCVE = zeros(numCurVals, 1);
arAuxCHS = zeros(numCurVals, 1);
arAuxCVS = zeros(numCurVals, 1);

for i = 1:numBPMs
    for j = 1:numCurVals
        stMeasCHE = arStMeasCHE{j};
        stMeasCVE = arStMeasCVE{j};
        stMeasCHS = arStMeasCHS{j};
        stMeasCVS = arStMeasCVS{j};
        stMeasBkgrCHE = arStMeasBkgrCHE{j};
        stMeasBkgrCVE = arStMeasBkgrCVE{j};
        stMeasBkgrCHS = arStMeasBkgrCHS{j};
        stMeasBkgrCVS = arStMeasBkgrCVS{j};

        arAuxCHE(j) = stMeasCHE.X(i) - stMeasBkgrCHE.X(i);
        arAuxCVE(j) = stMeasCVE.Z(i) - stMeasBkgrCVE.Z(i);
        arAuxCHS(j) = stMeasCHS.X(i) - stMeasBkgrCHS.X(i);
        arAuxCVS(j) = stMeasCVS.Z(i) - stMeasBkgrCVS.Z(i);
    end
    mCorRespX(i, 1) = idLeastSqLineTilt(arCorCurVals, arAuxCHE);
    mCorRespX(i, 2) = idLeastSqLineTilt(arCorCurVals, arAuxCHS);
    mCorRespZ(i, 1) = idLeastSqLineTilt(arCorCurVals, arAuxCVE);
    mCorRespZ(i, 2) = idLeastSqLineTilt(arCorCurVals, arAuxCVS);
end
