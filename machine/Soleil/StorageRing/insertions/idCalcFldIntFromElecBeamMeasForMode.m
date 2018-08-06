function [arI1x, arI2x, arI1z, arI2z] = idCalcFldIntFromElecBeamMeasForMode(folder, mode, numMeas, mCODx, mCODz, idLen, idKickOfst, elecEn_GeV)

%mCOD = idCreateModelOrbDistMatr('x', ElecBeamModel, 8, 1.3325, idLen, idKickOfst);

arI1x = zeros(1, numMeas);
arI2x = zeros(1, numMeas);
arI1z = zeros(1, numMeas);
arI2z = zeros(1, numMeas);

for i = 1:numMeas
    [MeasMain, MeasBkgr] = idReadMeasElecBeamData(folder, mode, i);
    [arI1x(i), arI2x(i), arI1z(i), arI2z(i)] = idCalcFldIntFromElecBeamMeas(MeasMain, MeasBkgr, mCODx, mCODz, idLen, idKickOfst, elecEn_GeV);
end
