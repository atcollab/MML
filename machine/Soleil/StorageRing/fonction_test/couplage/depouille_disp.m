%   measdisp(200,'Physics','Archive') % DeltaRF = 200 Hz

S = load('-mat','/home/matlabML/measdata/Ringdata/Dispersion/Couplage/Disp_couplage_2007-03-11_17-47-30.mat')

CT = 0.01* [    -0.7000   -3.1700   -2.6800   -3.0200   -0.1500   -3.2000   -4.0300    2.7100   -3.3500   -0.6200   -2.4000    1.0000   -2.4000   -1.1600   -2.4100    0.8100   -1.4600   -2.8500   -4.2300...
    0.9200   -0.9600   -3.4100    0.3100    1.4600   -4.9700   -3.1100   -1.5700   -3.3600   -5.6000   -4.7800    3.2300   -4.9300   -4.2700   -3.5100   -6.6700   -2.3700   -3.2000   -0.3800   -3.5000...
   -3.8600   -4.0300    0.0800   -2.9000   -5.0300   -3.0300    1.5300   -6.5200   -4.3900   -1.7500    1.0700   -5.1400   -3.1300   -4.5200   -1.4500   -1.9800    3.4100    0.9100   -2.3100   -0.0800...
   -0.5400    1.2200   -3.3600   -2.9100   -3.5900   -3.6500   -4.5700   -2.5200    2.2800   -2.4200   -1.1400   -4.4900    2.2900   -5.9800   -4.2700   -3.1300   -0.1500   -4.5700   -4.8700   -2.9700...
    1.1400    0.9100   -2.2000   -0.3800   -2.9600   -1.2900   -0.3800   -0.2300   -0.3800   -0.4900   -3.5700   -0.3500   -1.4700   -1.4800   -1.6800   -3.5300   -0.6300   -4.1500    1.5400   -2.3200...
   -1.7300   -2.0200    3.1500   -0.6100   -3.9200   -3.8300    1.9500   -1.8900    2.5400   -2.3900    1.0500   -0.3500   -1.6100   -3.3000    1.7100    0.6200    0.1500   -2.2500   -0.080    -0.080  -3.1900]
% crosstalk mesuré par groupe diag avril 2007
% attention premier BPM mml = [1 2] d'ou  la permutation du premier crosstalk (-3.19%)
figure(6);plot(CT,'k-o')

deltax = S.Xm{1}-S.Xp{1};
deltaz = S.Xm{2}-S.Xp{2};

deltax = S.Xm{1}-S.Xp{1};
deltaz_corr = (S.Xm{2}-S.Xm{1}.*CT')-(S.Xp{2}-S.Xp{1}.*CT');

figure(10) ; hold on ;plot(getspos('BPMx'),deltaz./deltax,'co-')
hold on ;plot(getspos('BPMx'),deltaz_corr./deltax,'ro-')
title('CROSS TALK des delta d''orbites -  Gain BPM = -28 dBm ')
ylabel('rapport delta d''orbite (-)')
legend('DeltaRf = 100 Hz','200Hz','50 Hz','500 Hz')

figure(11) ; hold on ; plot(getspos('BPMx'),4*deltaz,'go-')
title('delta d''orbites z - DELTA RF = 200 Hz - Gain BPM = -28 dBm ')
ylabel('delta d''orbite (mm)')