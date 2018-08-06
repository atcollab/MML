function resErrorFlag = idSetUndParamSeq(idName, idParamVals)
%Expected: idParamVals = {'phase', -40, 40, 1, 0.01}

resErrorFlag = 0;
resUnd = 0;

paramName = idParamVals{1};
paramStart = idParamVals{2};
paramEnd = idParamVals{3};
paramStepApprox = idParamVals{4};
paramAbsTol = idParamVals{5};

numParamVals = abs(round((paramEnd - paramStart)/paramStepApprox)) + 1;
paramStep = 0;
if(numParamVals > 1)
    paramStep = (paramEnd - paramStart)/(numParamVals - 1);
end

curParamVal = paramStart;
for k = 1:numParamVals
	resUnd = idSetUndParamSync(idName, paramName, curParamVal, paramAbsTol);
	if(resUnd ~= 0)
        fprintf('Execution terminated since Undulator Parameter can not be set\n');
        resErrorFlag = -1; return;
    end
    curParamVal = curParamVal + paramStep;
end