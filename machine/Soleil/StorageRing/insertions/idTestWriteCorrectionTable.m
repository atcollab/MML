dev = 'ANS-C08/EI/M-HU80.2';

rep = tango_read_attribute2(dev,'parallelModeCHE')
matCHE0 = rep.value;
rep = tango_read_attribute2(dev,'parallelModeCVE')
matCVE0 = rep.value;
rep = tango_read_attribute2(dev,'parallelModeCHS')
matCHS0 = rep.value;
rep = tango_read_attribute2(dev,'parallelModeCVS')
matCVS0 = rep.value;
%%

vPhase = [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40];
vGap = [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150, 250];

mCHE_with_arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCHE_HU80_TEMPO_upd_p0);
mCVE_with_arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCVE_HU80_TEMPO_upd_p0);
mCHS_with_arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCHS_HU80_TEMPO_upd_p0);
mCVS_with_arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCVS_HU80_TEMPO_upd_p0);

tango_write_attribute2(dev,'parallelModeCHE', mCHE_with_arg);
tango_write_attribute2(dev,'parallelModeCVE', mCVE_with_arg);
tango_write_attribute2(dev,'parallelModeCHS', mCHS_with_arg);
tango_write_attribute2(dev,'parallelModeCVS', mCVS_with_arg);


%matCHE = matCHE0;
%matCHE(2:end,2:end) = 0;
%matCHE(2:end,1) = [15.5 20 25 30 40 50 80 110];
%matCVE = matCHE;
%matCHS = matCHE;
%matCVS = matCHE;

%id = 1;
%matCHE(2:end,6) = [CX_G15_5(id); CX_G20(id); CX_G25(id); CX_G30(id); CX_G40(id); CX_G50(id); CX_G80(id); CX_G110(id)]
%matCVE(2:end,6) = [CZ_G15_5(id); CZ_G20(id); CZ_G25(id); CZ_G30(id); CZ_G40(id); CZ_G50(id); CZ_G80(id); CZ_G110(id)]

%id = 2;
%matCHS(2:end,6) = [CX_G15_5(id); CX_G20(id); CX_G25(id); CX_G30(id); CX_G40(id); CX_G50(id); CX_G80(id); CX_G110(id)]
%matCVS(2:end,6) = [CZ_G15_5(id); CZ_G20(id); CZ_G25(id); CZ_G30(id); CZ_G40(id); CZ_G50(id); CZ_G80(id); CZ_G110(id)]
