

% Delay [0 to Decimation-1] [0 to 76 for ALS SR]
% 'LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_MONITOR'
% 'LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_SP'

% Length [1 to Decimation] [1 to 77 for ALS SR]
% 'LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_MONITOR'
% 'LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_SP'
% 

MAF_Length = 50;  % 38

clear RMSx RMSy MAX_VA MAX_VB MAX_VC MAX_VD MAX_A MAX_B MAX_C MAX_D

% NN = 0:76;
%NN = 1:3:77;
NN = 5:1:30;

% Set length
setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_SP', MAF_Length);


for i = NN
    disp(['-----',num2str(NN)]);
    setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_SP', i-1);
    pause(3);
    
    [DD_AM, SP] = getlibera('DD1',[12 5]);
    RMSx(1,i) = std(DD_AM.DD_X_MONITOR/1e6);
    RMSy(1,i) = std(DD_AM.DD_Y_MONITOR/1e6);
    MAX_VA(1,i) = max(DD_AM.DD_VA_MONITOR);
    MAX_VB(1,i) = max(DD_AM.DD_VB_MONITOR);
    MAX_VC(1,i) = max(DD_AM.DD_VC_MONITOR);
    MAX_VD(1,i) = max(DD_AM.DD_VD_MONITOR);
  
    [DD_ADC, SP] = getlibera('ADC',[12 5]);
    MAX_A(1,i) = max(DD_ADC.ADC_A_MONITOR);
    MAX_B(1,i) = max(DD_ADC.ADC_B_MONITOR);
    MAX_C(1,i) = max(DD_ADC.ADC_C_MONITOR);
    MAX_D(1,i) = max(DD_ADC.ADC_D_MONITOR);
end


% Reset
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_SP', 76);
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_SP',  0);

% % Optimum for length 20
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_SP', 20);
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_SP',  48);
% 
% % Optimum for length 38
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFLENGTH_SP', 38);
% setpv('LIBERA_0AB2:ENV:ENV_DDC_MAFDELAY_SP',  29);


figure;
subplot(4,1,1);
plot(NN, RMSx(NN));
title(['MAF Length = ', num2str(MAF_Length)]);
ylabel('RMSx');

subplot(4,1,2);
plot(NN, RMSy(NN));
ylabel('RMSy');

subplot(4,1,3);
plot(NN, MAX_VA(NN));
ylabel('Max VA');

subplot(4,1,4);
plot(NN, MAX_VB(NN));
ylabel('Max VB');
xlabel('MAF Delay');




