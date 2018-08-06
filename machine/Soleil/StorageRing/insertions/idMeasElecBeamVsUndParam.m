function [resFileNamesStruct, resErrorFlag] = idMeasElecBeamVsUndParam(idName, undParams, undParamsBkg, freqBkgMeas, inclPerturbMeas, fileNameCore, dispData)
% Measure e-beam COD at different undulator parameters (gap, phase or currents in main coils)
% if(freqBkgMeas == 1) - measure bakground once each time after passing the in-most loop
% if(freqBkgMeas == n) - measure bakground once after passing n nested loops

resFileNames = {};
resErrorFlag = 0;
numUndParams = length(undParams);
resUnd = 0;

%"Nested For" algorithm
curParamName = undParams{1}{1};
curParamValues = undParams{1}{2};
curParamAbsTol = undParams{1}{3};
numCurParamValues = length(curParamValues);

nextFileNameCoreBase = strcat(fileNameCore, '_');
nextFileNameCoreBase = strcat(nextFileNameCoreBase, curParamName);

for j = 1:numCurParamValues
    
	curParamValue = curParamValues(j);
    
    strParamValue = sprintf('%f', curParamValue);
    strParamValue = strrep(strParamValue, '.', '_');
    lenOrigStrParamValue = length(strParamValue);
    numTrailZeros = 0; %removing trailing zeros
    for k = 1:lenOrigStrParamValue
        if strcmp(strParamValue(lenOrigStrParamValue - k + 1), '0')
            numTrailZeros = numTrailZeros + 1;
        else
            if (numTrailZeros > 0) && strcmp(strParamValue(lenOrigStrParamValue - k + 1), '_')
                numTrailZeros = numTrailZeros + 1;
            end
            break;
        end
    end
    if(numTrailZeros > 0)
        strParamValueFin = '';
        for k = 1:lenOrigStrParamValue - numTrailZeros
            strParamValueFin = strcat(strParamValueFin, strParamValue(k));
        end
    end
    nextFileNameCore = strcat(nextFileNameCoreBase, strParamValueFin);
    
    %%%%%%%%%%%Change Undulator parameter (gap, phase or current)
	resUnd = idSetUndParamSync(idName, curParamName, curParamValue, curParamAbsTol);
    if(resUnd ~= 0)
        fprintf('Execution terminated since Undulator Parameter can not be set\n');
        resErrorFlag = -1; return;
    end
    
	if(numUndParams > 1)
        %Preparing arguments for nested call
        nextUndParams = {};
        for k = 1:(numUndParams - 1)
            for i = 1:3
                nextUndParams{k}{i} = undParams{k + 1}{i};
            end
            nextUndParams{k}{4} = 'nested'; %marking the set of params as for the nested call
        end
        
        %%%%%%%%%%%Do nested call
        [resNextFileNamesStruct, resNextErrorFlag] = idMeasElecBeamVsUndParam(idName, nextUndParams, undParamsBkg, freqBkgMeas, inclPerturbMeas, nextFileNameCore, dispData);
        resNextFileNames = resNextFileNamesStruct.filelist;
        numNextFileNames = length(resNextFileNames);
        
        if(resNextErrorFlag ~= 0)
            fprintf('Execution terminated because of error in the inner loop\n');
            resErrorFlag = resNextErrorFlag; return;
        end

        numCurFileNames = length(resFileNames);
        for k = 1:numNextFileNames
        	resFileNames{numCurFileNames + k} = resNextFileNames{k};
        end

    else
        %%%%%%%%%%%Measure e-beam COD
        outStruct = idMeasElecBeamUnd(idName, inclPerturbMeas, nextFileNameCore, dispData);
        numCurFileNames = length(resFileNames);
        resFileNames{numCurFileNames + 1} = outStruct.file;
	end
end
resFileNamesStruct.filelist = resFileNames;

numUndParamsBkg = length(undParamsBkg);
if((numUndParams == freqBkgMeas) && (numUndParamsBkg > 0)) %Measure Background if necessary
    %numUndParamsBkg = length(undParamsBkg);

    if(numUndParamsBkg > 0)
    	nextFileNameCore = strcat(fileNameCore, '_bkg');
    	undParamsBeforeBkgMeas = {};
        for k = 1:numUndParamsBkg
            curParamName = undParamsBkg{k}{1};
            curParamValue = undParamsBkg{k}{2};
            curParamAbsTol = undParamsBkg{k}{3};
            undParamsBeforeBkgMeas{k} = idGetUndParam(idName, curParamName);
            
            %%%%%%%%%%%Change Undulator parameter (gap, phase or current) to prepare for background measurement
            resUnd = idSetUndParamSync(idName, curParamName, curParamValue, curParamAbsTol);
            if(resUnd ~= 0)
                fprintf('Execution terminated since Undulator Parameter can not be set\n');
                resErrorFlag = -1; return;
            end
        end

        %%%%%%%%%%%Measure e-beam COD background
        outStruct = idMeasElecBeamUnd(idName, inclPerturbMeas, nextFileNameCore, dispData);
        numCurFileNames = length(resFileNames);
        resFileNames{numCurFileNames + 1} = outStruct.file;
        resFileNamesStruct.filelist = resFileNames;

        %Returning to the state before background measurement, only in the case of nested call
        if(length(undParams{1}) > 3)
            if strcmp(undParams{1}{4}, 'nested')
                for k = 1:numUndParamsBkg
                    curParamName = undParamsBkg{k}{1};
                    curParamAbsTol = undParamsBkg{k}{3};
                    curParamValue = undParamsBeforeBkgMeas{k};
            
                    %%%%%%%%%%%Change Undulator parameter (gap, phase or current) - return to the last state before background measurement
                    resUnd = idSetUndParamSync(idName, curParamName, curParamValue, curParamAbsTol);
                    if(resUnd ~= 0)
                        fprintf('Execution terminated since Undulator Parameter can not be set\n');
                        resErrorFlag = -1; return;
                    end
                end
            end
        end
    end
end

if((length(undParams{1}) <= 3) || (strcmp(undParams{1}{4}, 'nested') == 0)) %i.e. this is not a nested call
%iall job is done, writing and saving the summary structure

	lastParamAr = undParams{numUndParams}{2};
	perMeasBkg = length(lastParamAr);
	if(freqBkgMeas > 1)
        for k = 1:(numUndParams - 1)
            perMeasBkg = perMeasBkg*length(undParams{numUndParams - k}{2});
        end
	end

    resFileNamesStruct.filelist = resFileNames;
	resFileNamesStruct.params = undParams;
	resFileNamesStruct.filenames_meas_bkg = idAuxPrepFileNameListMeasAndBkg(resFileNames, perMeasBkg);
    
	fileNameCoreSummary = strcat(fileNameCore, '_summary');
	idSaveStruct(resFileNamesStruct, fileNameCoreSummary, idName, 0);
end