%% Plot

clear

FigNum = 1;

Prefix = 'SR01C:BPM8';

% Arm, trigger and wait
tic
bpm_trigger('armextraction', Prefix);
toc

DCCT = getdcct;
Xrms10k = getpv([Prefix,':SA:RMS:wide:X']);
Xrms200 = getpv([Prefix,':SA:RMS:narrow:X']);
Yrms10k = getpv([Prefix,':SA:RMS:wide:Y']);
Yrms200 = getpv([Prefix,':SA:RMS:narrow:Y']);

ENV = bpm_getenv(Prefix); 
ADC = bpm_getadc(Prefix);
TBT = bpm_gettbt(Prefix);
FA  = bpm_getfa(Prefix);


[PSD.ADC, Setup] = bpm_adc2psd(ADC, ENV, FigNum);
bpm_plottbt(TBT, FigNum+10);
bpm_plotfa(FA, FigNum+20);


FileName = sprintf('%s_10p5mA',Prefix);
FileName(strfind(FileName,':')) = '_';
save(FileName);

% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
% Setup.xy.nHarmOrbit = 21;
% Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
% Setup.xy.NAvg = 1;
% Setup.xy.NPoints = 77 * 100000;  % *11 *7
% Setup.xy.NAdvance = 10*77;  % 7 11 77;   % in ADC counts
% Setup.xy.FigNum = Setup.PSD.FigNum + 3;
% Setup.xy.Shift = 0;
% PSD.Orbit = bpm_adc2xy(ADC, Setup, ENV);

% 
%     figure(FigNum);
%     Color = nxtcolor;
%     h(1) = subplot(2,1,1)
%     plot(OrbitA{i}.xcal, 'Color', Color);
%     hold on
%     
%     h(2) = subplot(2,1,2)
%     plot(OrbitA{i}.ycal, 'Color', Color);
%     hold on
%     
%     figure(102);
%     h(3) = subplot(2,1,1)
%     plot(OrbitA{i}.x, 'Color', Color);
%     hold on
%     
%     h(4) = subplot(2,1,2)
%     plot(OrbitA{i}.y, 'Color', Color);
%     hold on
%     
%     figure(103);
%     h(5) = subplot(2,1,1)
%     plot(OrbitA{i}.PTx, 'Color', Color);
%     hold on
%     
%     h(6) = subplot(2,1,2)
%     plot(OrbitA{i}.PTy, 'Color', Color);
%     hold on
%     
%     figure(104);
%     h(7) = subplot(3,1,1);
%     plot(OrbitA{i}.PTBrms ./ OrbitA{i}.PTArms, 'Color', Color);
%     hold on
%     h(8) = subplot(3,1,2);
%     plot(OrbitA{i}.PTCrms ./ OrbitA{i}.PTArms, 'Color', Color);
%     hold on
%     h(9) = subplot(3,1,3);
%     plot(OrbitA{i}.PTDrms ./ OrbitA{i}.PTArms, 'Color', Color);
%     hold on
%     
    

%%

% Prefix = 'SR01C:BPM3';





