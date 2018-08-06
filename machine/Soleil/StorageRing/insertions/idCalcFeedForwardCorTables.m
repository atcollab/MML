function [mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables(idName, idParams, fileNamesMeasCOD, dirMeasCOD, dirMeasCorResp, arIndsBPMsToSkip)
%Calculate Feed-Forward Correction Tables vs Undulator Parameters for 2 Horizontal and 2 Vertical correctors.
%NOTE: Horizontal correctors are those displacing electron orbit in Horizontal direction (by means of Vertical magnetic field)

mCHE = []; mCVE = []; mCHS = []; mCVS = [];

numUndParams = length(idParams);
if((numUndParams < 0) || (numUndParams > 2))
    
    %if()
    %end
    
    sprintf('Number of ID parameters for the correction tables should be 1 or 2');
    return;
end

numValsUndParam1 = length(idParams{1}{2});
undParamName1 = idParams{1}{1};

numValsUndParam2 = 1;
undParamName2 = '';
if(numUndParams > 1)
    numValsUndParam2 = length(idParams{2}{2});
    undParamName2 = idParams{2}{1};
end

if((numValsUndParam2 <= 1) && (strcmp(undParamName2, '') ~= 0))
    numValsUndParam2 = 1;
    undParamName2 = 'dummy';
end

mCHE = zeros(numValsUndParam2, numValsUndParam1);
mCVE = zeros(numValsUndParam2, numValsUndParam1);
mCHS = zeros(numValsUndParam2, numValsUndParam1);
mCVS = zeros(numValsUndParam2, numValsUndParam1);

mCorRespX = zeros(120, 2);
mCorRespZ = zeros(120, 2);

corEfficiencyDependsOnUndParam = 1;
if((strcmp(undParamName1, 'gap') == 0) && (strcmp(undParamName2, 'gap') == 0))
	[mCorRespX, mCorRespZ] = idCalcCorRespMatr(idName, 0, dirMeasCorResp);
	corEfficiencyDependsOnUndParam = 0;
elseif((strcmp(undParamName1, 'gap') ~= 0) && (strcmp(undParamName2, '') ~= 0))
	[mCorRespX, mCorRespZ] = idCalcCorRespMatr(idName, 0, dirMeasCorResp);
    mCorRespXgl = zeros(120, 2);
    mCorRespZgl = zeros(120, 2);
	[mCorRespXgl, mCorRespZgl] = idCalcCorRespMatr(idName, 250, dirMeasCorResp);
    corEfficiencyDependsOnUndParam = 0;
    for i = 1:length(mCorRespX)
        if((mCorRespXgl(i,1) ~= mCorRespX(i,1)) || (mCorRespXgl(i,2) ~= mCorRespX(i,2)))
            corEfficiencyDependsOnUndParam = 1;
            break;
        end
        if((mCorRespZgl(i,1) ~= mCorRespZ(i,1)) || (mCorRespZgl(i,2) ~= mCorRespZ(i,2)))
            corEfficiencyDependsOnUndParam = 1;
            break;
        end
    end
end

indMeasCOD = 1; 
for i = 1:numValsUndParam1
    undParam1 = idParams{1}{2}(i);
    if(corEfficiencyDependsOnUndParam)
        if(strcmp(undParamName1, 'gap'))
            [mCorRespX, mCorRespZ] = idCalcCorRespMatr(idName, undParam1, dirMeasCorResp);
        end
    end

    for j = 1:numValsUndParam2
        undParam2 = 0;
        if(numUndParams > 1)
            undParam2 = idParams{2}{2}(j);
        end
        if(corEfficiencyDependsOnUndParam)
            if(strcmp(undParamName2, 'gap'))
                [mCorRespX, mCorRespZ] = idCalcCorRespMatr(idName, undParam2, dirMeasCorResp);
            end
        end

        fileNameMeasMain = char(fileNamesMeasCOD{indMeasCOD}{1});
        fileNameMeasBkg = char(fileNamesMeasCOD{indMeasCOD}{2});

        dirStart = pwd;
        if strcmp(dirMeasCOD, '')
            dirMeasCOD = getfamilydata('Directory',idName);
        end
        cd(dirMeasCOD);
        stMeasMain = load(fileNameMeasMain);
        stMeasBkg = load(fileNameMeasBkg);
        cd(dirStart);

        vCODx = stMeasMain.X - stMeasBkg.X;
        curCorX = idLeastSqLinFit(mCorRespX, vCODx, arIndsBPMsToSkip);

        vCODz = stMeasMain.Z - stMeasBkg.Z;
        curCorZ = idLeastSqLinFit(mCorRespZ, vCODz, arIndsBPMsToSkip);

        mCHE(j, i) = -curCorX(1);
        mCVE(j, i) = -curCorZ(1);
        mCHS(j, i) = -curCorX(2);
        mCVS(j, i) = -curCorZ(2);
        indMeasCOD = indMeasCOD + 1;
    end
end

if(numUndParams > 1)
    fprintf('VERTICAL dimension in tables (i.e. row no. is variable; column no. is const) corresponds to variation of  %s\n', undParamName2);
    fprintf('HORIZONTAL dimension in tables (i.e. row no. is const; column no. is variable) corresponds to variation of  %s\n', undParamName1);
end
