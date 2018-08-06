function outStruct = idCalcFldIntFromElecBeamMeasForUndSOLEIL_1(idName, dirMeasData, fileNameMeasMain, fileNameMeasBkgr, dirModel, arIndsBPMsToSkip)

%Calculates effective first and second horizontal and vertical field
%integrals of SOLEIL undulators from COD 
%for one measurement of the COD (read from the files: fileNameMeasMain, fileNameMeasBkgr)

GeomParUnd = idGetGeomParamForUndSOLEIL(idName);

ElecBeamModelData = idReadElecBeamModel(dirModel);
mCODx = idCreateModelOrbDistMatr('x', ElecBeamModelData, GeomParUnd);
mCODz = idCreateModelOrbDistMatr('z', ElecBeamModelData, GeomParUnd);

dirStart = pwd;
if strcmp(dirMeasData, '') == 0
	cd(dirMeasData);
end
ElecBeamMeasMain = load(char(fileNameMeasMain));
ElecBeamMeasBkgr = load(char(fileNameMeasBkgr));
cd(dirStart);

[outStruct.I1X, outStruct.I2X, outStruct.I1Z, outStruct.I2Z] = idCalcFldIntFromElecBeamMeas(ElecBeamMeasMain, ElecBeamMeasBkgr, mCODx, mCODz, arIndsBPMsToSkip, GeomParUnd.idLen, GeomParUnd.idKickOfst, ElecBeamModelData.E);

outStruct.DX_Meas = ElecBeamMeasMain.X - ElecBeamMeasBkgr.X;
outStruct.DZ_Meas = ElecBeamMeasMain.Z - ElecBeamMeasBkgr.Z;
outStruct.KicksX = idLeastSqLinFit(mCODx, outStruct.DX_Meas, arIndsBPMsToSkip);
outStruct.KicksZ = idLeastSqLinFit(mCODz, outStruct.DZ_Meas, arIndsBPMsToSkip);
outStruct.DX_Fit = mCODx*outStruct.KicksX;
outStruct.DZ_Fit = mCODz*outStruct.KicksZ;



