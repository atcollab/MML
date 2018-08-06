%% Plot

%clear

FigNum = 1;

if 0
    cd /home/physdata/BPM/AFE4/2014-08-13
    % FileNamePrefix = 'SR01CBPM4_ADC_1Bunch_Set';
    FileNamePrefix = 'SR01CBPM7_ADC_1Bunch_Set';
    % FileNamePrefix = 'SR01CBPM8_ADC_1Bunch_Set';
    % FileNamePrefix = 'SR03CBPM8_ADC_1Bunch_Set';

    % 1 to 386 single bunch owl shift
    N = 386
elseif 0
    % 2-bunch user ops
    cd /home/physdata/BPM/AFE4/2014-08-17
    FileNamePrefix = 'SR01CBPM4_ADC_1Bunch_Set';
    N = 1000;
elseif 1
    % 500mA, User Ops, New Software
    cd /home/physdata/BPM/AFE5Proto_ALSDFE/2014-09-16
    FileNamePrefix = 'Test_PTOff_Set1';
    N = 1000;
end

Paa = [];
Pbb = [];
Pcc = [];
Pdd = [];
ADCmax = [];


for iFile = 1:N
    FileName = sprintf('%s%d', FileNamePrefix, iFile);
    load(FileName);
    
    DataTime(iFile) = ENV.DataTime;
    DCCT(iFile)     = ENV.DCCT;
    RF(iFile)       = ENV.RF0;
    
    PSDs{iFile} = PSD;  % bpm_adc2psd(ADC, Setup, ENV);  % PSD
    Paa = [Paa PSDs{iFile}.Paa];
    Pbb = [Pbb PSDs{iFile}.Pbb];
    Pcc = [Pcc PSDs{iFile}.Pcc];
    Pdd = [Pdd PSDs{iFile}.Pdd];
    
    ADCmax = [ADCmax [max(abs(ADC.cha)); max(abs(ADC.chb)); max(abs(ADC.chc)); max(abs(ADC.chd))]];
    
    %Orbits{iFile} = bpm_adc2xy(ADC, Setup, ENV);    
    
    iFile
end

PSD = PSDs;
clear PSDs 
t = (DataTime - DataTime(1)) * 24;

%save('calc_arrays', 'Orbit', 'PSD', 'Setup', 'ENV');
%save([FileName, '_OrbitCalc'], 'Orbit', 'PSD', 'Setup', 'ENV');

return


% Setup.PT.State = 1;
% Setup.PT.Attn = 70;
% Setup.PT.FrequencyCode = '-1/2';
% tmp=bpm_adc2psd(ADC, Setup, ENV);


%%
NFig = 101;

N_Time = length(DataTime);

figure(NFig+1);
clf reset
plot(t(1:N_Time), DCCT(1:N_Time));
xlabel('Time [Hours]');
ylabel('DCCT [mA]');
title(sprintf('%s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)));
axis tight
yaxis([0 20]);


figure(NFig+2);
clf reset
plot(t(1:N_Time), ADCmax(:,1:N_Time));
xlabel('Time [Hours]');
ylabel('Max ADC Counts');
title(sprintf('%s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)));
axis tight
%yaxis([0 20]);


figure(NFig+3);
clf reset
plot(t(1:N_Time), [ ...
    sqrt(PSD{1}.f0*PSD{1}.T1*Paa(PSD{1}.nHarm(21),1:N_Time));
    sqrt(PSD{1}.f0*PSD{1}.T1*Pbb(PSD{1}.nHarm(21),1:N_Time));
    sqrt(PSD{1}.f0*PSD{1}.T1*Pcc(PSD{1}.nHarm(21),1:N_Time));
    sqrt(PSD{1}.f0*PSD{1}.T1*Pdd(PSD{1}.nHarm(21),1:N_Time));    
    ]);
xlabel('Time [Hours]');
ylabel('ADC @ RF [Counts]');
title(sprintf('%s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)));
axis tight

% N = 1 / (PSD{1}.f0*PSD{1}.T1)
clear  x y
j = 0;
for i = 0 %-1:1
    j = j + 1;
    Arms = sqrt(PSD{1}.f0*PSD{1}.T1*Paa(PSD{1}.nHarm(21+i),1:N_Time));
    Brms = sqrt(PSD{1}.f0*PSD{1}.T1*Pbb(PSD{1}.nHarm(21+i),1:N_Time));
    Crms = sqrt(PSD{1}.f0*PSD{1}.T1*Pcc(PSD{1}.nHarm(21+i),1:N_Time));
    Drms = sqrt(PSD{1}.f0*PSD{1}.T1*Pdd(PSD{1}.nHarm(21+i),1:N_Time));
    
    x(j,:) = Setup.Xgain * (Arms-Brms-Crms+Drms) ./ (Arms+Brms+Crms+Drms); % mm
    y(j,:) = Setup.Ygain * (Arms+Brms-Crms-Drms) ./ (Arms+Brms+Crms+Drms); % mm
    
    x(j,:) = x(j,:) - x(j,1);
    y(j,:) = y(j,:) - y(j,1);
end

nPT = 3121;
Arms = sqrt(PSD{1}.f0*PSD{1}.T1*Paa(nPT,1:N_Time));
Brms = sqrt(PSD{1}.f0*PSD{1}.T1*Pbb(nPT,1:N_Time));
Crms = sqrt(PSD{1}.f0*PSD{1}.T1*Pcc(nPT,1:N_Time));
Drms = sqrt(PSD{1}.f0*PSD{1}.T1*Pdd(nPT,1:N_Time));

PTx = Setup.Xgain * (Arms-Brms-Crms+Drms) ./ (Arms+Brms+Crms+Drms); % mm
PTy = Setup.Ygain * (Arms+Brms-Crms-Drms) ./ (Arms+Brms+Crms+Drms); % mm

figure(NFig+4);
clf reset
subplot(2,1,1);
plot(t(1:N_Time), x);
ylabel('x [mm]');
title(sprintf('%s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)));
axis tight
subplot(2,1,2);
plot(t(1:N_Time), y);
xlabel('Time [Hours]');
ylabel('y [mm]');
axis tight


figure(NFig+5);
clf reset
%subplot(3,1,1);
%plot(t(1:N_Time),  [Arms; Brms; Crms; Drms]);
%ylabel('ADCrms @ PT [Counts]');
%axis tight
subplot(2,1,1);
plot(t(1:N_Time), PTx);
ylabel('PT x [mm]');
title(sprintf('%s %s - Pilot Tone',FileNamePrefix(1:5), FileNamePrefix(6:9)));
subplot(2,1,2);
plot(t(1:N_Time), PTy);
xlabel('Time [Hours]');
ylabel('PT y [mm]');
axis tight


figure(NFig+6);
clf reset
subplot(2,1,1);
plot(t(1:N_Time), 1000*(x-x(1)));
hold on
plot(t(1:N_Time), 1000*(PTx-PTx(1)),'g');
ylabel('x [\mum]');
title(sprintf('%s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)));
axis tight
subplot(2,1,2);
plot(t(1:N_Time), 1000*(y-y(1)));
hold on
plot(t(1:N_Time), 1000*(PTy-PTy(1)),'g');
xlabel('Time [Hours]');
ylabel('y [\mum]');
axis tight



%% surf

N_Time = length(DataTime);

f = PSD{1}.f/1e6;
%t = 1:size(Paa,2);
t = 24*(DataTime(1:N_Time) - DataTime(1));

if 1
    i1 = 2;
    i2 = length(f);
else
    i1 = max(find(f<29));
    i2 = min(find(f>32));
end

meshgrid(f(i1:i2), t);

AZ = -140;
EL =   70;

figure(21);
clf reset
h = subplot(2,2,1);
surf(t(1:N_Time), f(i1:i2), log10(Paa(i1:i2,1:N_Time)));
shading interp
view(AZ,EL);
xlabel('Time [Hours]');
ylabel('Paa [Counts^2/Hz]');
axis tight

h = subplot(2,2,2);
surf(t(1:N_Time), f(i1:i2), log10(Pbb(i1:i2,1:N_Time)));
shading interp
view(AZ,EL);
xlabel('Time [Hours]');
ylabel('Pbb [Counts^2/Hz]');
axis tight

h = subplot(2,2,4);
surf(t(1:N_Time), f(i1:i2), log10(Pcc(i1:i2,1:N_Time)));
shading interp
view(AZ,EL);
xlabel('Time [Hours]');
ylabel('Pcc [Counts^2/Hz]');
axis tight

h = subplot(2,2,3);
surf(t(1:N_Time), f(i1:i2), log10(Pdd(i1:i2,1:N_Time)));
shading interp
view(AZ,EL);
xlabel('Time [Hours]');
ylabel('Pdd [Counts^2/Hz]');
axis tight

addlabel(.5, 1, sprintf('Power Spectrum for Each Channel  --  %s %s',FileNamePrefix(1:5), FileNamePrefix(6:9)), 14);




%%

SumOffset = 1.2620e+04;

ArmsMax = [];
ArmsMin = [];
BrmsMax = [];
BrmsMin = [];
CrmsMax = [];
CrmsMin = [];
DrmsMax = [];
DrmsMin = [];

XrmsMax = [];
XrmsMin = [];

YrmsMax = [];
YrmsMin = [];

N_Time = 1400;  %1470;

for i = 1:1:N_Time
    ArmsMax = [ArmsMax max(Orbit{i}.Arms)];
    ArmsMin = [ArmsMin min(Orbit{i}.Arms)];
    BrmsMax = [BrmsMax max(Orbit{i}.Brms)];
    BrmsMin = [BrmsMin min(Orbit{i}.Brms)];
    CrmsMax = [CrmsMax max(Orbit{i}.Crms)];
    CrmsMin = [CrmsMin min(Orbit{i}.Crms)];
    DrmsMax = [DrmsMax max(Orbit{i}.Drms)];
    DrmsMin = [DrmsMin min(Orbit{i}.Drms)];
    %t = [t PSD{i}.]

    Arms = Orbit{i}.Arms + SumOffset - 0*1600;
    Brms = Orbit{i}.Brms + SumOffset + 0*1600;
    Crms = Orbit{i}.Crms + SumOffset;
    Drms = Orbit{i}.Drms + SumOffset;
    
    x{i} = Setup.Xgain * (Arms-Brms-Crms+Drms) ./ (Arms+Brms+Crms+Drms); % mm
    y{i} = Setup.Ygain * (Arms+Brms-Crms-Drms) ./ (Arms+Brms+Crms+Drms); % mm
    
    XrmsMax = [XrmsMax max(x{i})];
    XrmsMin = [XrmsMin min(x{i})];
    YrmsMax = [YrmsMax max(y{i})];
    YrmsMin = [YrmsMin min(y{i})];
end

f = PSD{1}.f/1e6;

t = 24*(DataTime(1:N_Time) - DataTime(1));

h = [];

figure(2);
clf reset

% h = subplot(1,1,1);
% plot(t, [ArmsMax; ArmsMin],'b');
% hold on
% plot(t, [BrmsMax; BrmsMin],'g');
% plot(t, [CrmsMax; CrmsMin],'r');
% plot(t, [DrmsMax; DrmsMin],'c');
% hold off

h(length(h)+1) = subplot(4,1,1);
plot(t, [ArmsMax; ArmsMin]);
axis tight;
ylabel('Arms [Counts]');
xlabel('Time [Hours]');
title('RMS of the RF Spectral Line with Inputs Capped');
h(length(h)+1) = subplot(4,1,2);
plot(t, [BrmsMax; BrmsMin]);
axis tight;
ylabel('Brms [Counts]');
xlabel('Time [Hours]');
h(length(h)+1) = subplot(4,1,3);
plot(t, [CrmsMax; CrmsMin]);
axis tight;
ylabel('Crms [Counts]');
xlabel('Time [Hours]');
h(length(h)+1) = subplot(4,1,4);
plot(t, [DrmsMax; DrmsMin]);
axis tight;
ylabel('Drms [Counts]');
xlabel('Time [Hours]');

figure(4);
clf reset
h(length(h)+1) = subplot(2,1,1);
plot(t, [XrmsMax; XrmsMin]);
axis tight;
ylabel('X [mm]');
xlabel('Time [Hours]');
title('Artificially added 12.6k counts to each channel then offset in x by 1mm');
h(length(h)+1) = subplot(2,1,2);
plot(t, [YrmsMax; YrmsMin]);
axis tight;
ylabel('Y [mm]');
xlabel('Time [Hours]');

linkaxes(h, 'x');



%%

clear

for i = 1:21 %21
    FileName = sprintf('ALS_NoSplit_UserOps_Test1_PTOn_A_Set%d', i);
    load(FileName);
    ADC.cha(1:end-1) = ADC.cha(2:end);
    ADC.chd(1:end-1) = ADC.chd(2:end);
    
    % Many turn averaging
    %Setup.xy.nHarmOrbit = 15:26;
    Setup.xy.nHarmOrbit = 21;
    Setup.xy.NTurnsPerFFT = 150;
    Setup.xy.NAvg = 1;
    Setup.xy.NPoints = 100*77;
    Setup.xy.NAdvance = 11;  %77;   % in ADC counts
    Setup.xy.FigNum = 1;
    Setup.xy.Shift = 0;
    
    OrbitA{i} = bpm_adc2xy(ADC, Setup, ENV);
end



%%
for i = 1:21 %21
    FileName = sprintf('ALS_NoSplit_UserOps_Test1_PTOn_A_Set%d', i);
    load(FileName);
    DCCT(i)   = ENV.DCCT;
    RF(i)     = ENV.RF0;
    Attn(i)   = Setup.Attn;
    PTAttn(i) = Setup.PT.Attn;
end

save CalcOrbitA OrbitA DCCT RF Attn PTAttn Setup


figure(101);
clf reset
figure(102);
clf reset
figure(103);
clf reset
figure(104);
clf reset
clear h

for i = 1:length(OrbitA)
    
    figure(101);
    Color = nxtcolor;
    h(1) = subplot(2,1,1)
    plot(OrbitA{i}.xcal, 'Color', Color);
    hold on
    
    h(2) = subplot(2,1,2)
    plot(OrbitA{i}.ycal, 'Color', Color);
    hold on
    
    figure(102);
    h(3) = subplot(2,1,1)
    plot(OrbitA{i}.x, 'Color', Color);
    hold on
    
    h(4) = subplot(2,1,2)
    plot(OrbitA{i}.y, 'Color', Color);
    hold on
    
    figure(103);
    h(5) = subplot(2,1,1)
    plot(OrbitA{i}.PTx, 'Color', Color);
    hold on
    
    h(6) = subplot(2,1,2)
    plot(OrbitA{i}.PTy, 'Color', Color);
    hold on
    
    figure(104);
    h(7) = subplot(3,1,1);
    plot(OrbitA{i}.PTBrms ./ OrbitA{i}.PTArms, 'Color', Color);
    hold on
    h(8) = subplot(3,1,2);
    plot(OrbitA{i}.PTCrms ./ OrbitA{i}.PTArms, 'Color', Color);
    hold on
    h(9) = subplot(3,1,3);
    plot(OrbitA{i}.PTDrms ./ OrbitA{i}.PTArms, 'Color', Color);
    hold on
    
    
end



