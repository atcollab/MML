cvG15_5_X = idLeastSqLinFit(G15_5_mCorRespX, -G15_5_X, -1);
cvG15_5_Z = idLeastSqLinFit(G15_5_mCorRespZ, -G15_5_Z, -1);

cvG20_X = idLeastSqLinFit(G20_mCorRespX, -G20_X, -1)
cvG20_Z = idLeastSqLinFit(G20_mCorRespZ, -G20_Z, -1)

cvG25_X = idLeastSqLinFit(G25_mCorRespX, -G25_X, -1)
cvG25_Z = idLeastSqLinFit(G25_mCorRespZ, -G25_Z, -1)

cvG30_X = idLeastSqLinFit(G30_mCorRespX, -G30_X, -1)
cvG30_Z = idLeastSqLinFit(G30_mCorRespZ, -G30_Z, -1)

cvG50_X = idLeastSqLinFit(G50_mCorRespX, -G50_X, -1)
cvG50_Z = idLeastSqLinFit(G50_mCorRespZ, -G50_Z, -1)

cvG80_X = idLeastSqLinFit(G80_mCorRespX, -G80_X, -1)
cvG80_Z = idLeastSqLinFit(G80_mCorRespZ, -G80_Z, -1)

cvG110_X = idLeastSqLinFit(G110_mCorRespX, -G110_X, -1)
cvG110_Z = idLeastSqLinFit(G110_mCorRespZ, -G110_Z, -1)

% 	curCh01 = 0.5*(-curToSetCVE - curToSetCHE);
% 	curCh02 = 0.5*(-curToSetCVE + curToSetCHE);
% 	curCh03 = 0.5*(-curToSetCVS - curToSetCHS);
% 	curCh04 = 0.5*(-curToSetCVS + curToSetCHS);

tab1=zeros(9,10);
tab1(1,:)=[0 -0.4018 -0.3 -0.2 -0.1 0  0.1 0.2 0.3 0.4018]'*1e6;
tab1(:,1)=[0 110 80 50 30 25 20 18 15.5]*1e4;
tab2=tab1;
tab3=tab1;
tab4=tab1;

curToSetCVE = [cvG15_5_Z(1) cvG15_5_Z(1) cvG20_Z(1) cvG25_Z(1) cvG30_Z(1) cvG50_Z(1) cvG80_Z(1) cvG110_Z(1)];
curToSetCHE = [cvG15_5_X(1) cvG15_5_X(1) cvG20_X(1) cvG25_X(1) cvG30_X(1) cvG50_X(1) cvG80_X(1) cvG110_X(1)];
curToSetCVS = [cvG15_5_Z(2) cvG15_5_Z(2) cvG20_Z(2) cvG25_Z(2) cvG30_Z(2) cvG50_Z(2) cvG80_Z(2) cvG110_Z(2)];
curToSetCHS = [cvG15_5_X(2) cvG15_5_X(2) cvG20_X(2) cvG25_X(2) cvG30_X(2) cvG50_X(2) cvG80_X(2) cvG110_X(2)];

tab1(end:-1:2,6) = 0.5*(-curToSetCVE - curToSetCHE);
tab2(end:-1:2,6) = 0.5*(-curToSetCVE + curToSetCHE);
tab3(end:-1:2,6) = 0.5*(-curToSetCVS - curToSetCHS);
tab4(end:-1:2,6) = 0.5*(-curToSetCVS + curToSetCHS);

dev='ANS-C08/EI/M-HU80.2';
tab1t = tab1';
tango_write_attribute2(dev,'correction1ParallelMode',tab1);
temp = tango_read_attribute2(dev,'correction1ParallelMode'); tab1r = temp.value


tango_write_attribute2(dev,'correction2ParallelMode',tab2);

tango_write_attribute2(dev,'correction3ParallelMode',tab3);

tango_write_attribute2(dev,'correction4ParallelMode',tab4);
