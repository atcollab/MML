function outStruct = idMeasElecBeamUnd(idName, inclPerturbMeas, fileNameCore, dispData)

outStruct.X = 0;
outStruct = idMeasElecBeam(outStruct, inclPerturbMeas, dispData);
if strcmp(idName, '') == 0
    outStruct = idReadUndState(outStruct, idName, dispData);
end
if strcmp(fileNameCore, '') == 0
    outStruct.file = idSaveStruct(outStruct, fileNameCore, idName, dispData);
end
