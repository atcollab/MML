
[resFileNames, resErrorFlag]=idMeasElecBeamVsUndParam('HU640_DESIRS', {{'currentPS1', [0,600,-600,0], 0.1}}, {{'currentPS1', 0, 0.1}}, 1, 0, 'COD_PS1', 1)
[mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables('HU640_DESIRS', resFileNames.params, resFileNames.filenames_meas_bkg, '', '', -1)


idMeasElecBeamUnd('HU640_DESIRS', 0, '/home/operateur/GrpGMI/HU640_DESIRS/PS1_0_0_0', 1)
idMeasElecBeamUnd('HU640_DESIRS', 0, '/home/operateur/GrpGMI/HU640_DESIRS/PS1_600_0_0', 1)
Result=HU640_CalculateCorrCur('/home/operateur/GrpGMI/HU640_DESIRS/PS1_600_0_0.mat', '/home/operateur/GrpGMI/HU640_DESIRS/PS1_0_0_0.mat')