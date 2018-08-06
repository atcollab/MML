%% Plot

clear

FigNum = 1;

if 0
    cd /data/bpm/AFE3_FPGA39/2013-11-07
    % FileName = 'ALS_AllInputs50ohms_NoSROC_PTOff_Set1';
    % FileName = 'ALS_AllInputs50ohms_PTOff_Set1';
    % FileName = 'ALS_InputsTerminatedto50ohms_PTOff_Set1';
    FileName = 'ALS_InputsTerminatedto50ohms_PTOff_Set2';
    
    % FileName = 'ALS_NoSplit_UserOps_FOFBOn_PTCableOn_PTOff_Set1';
    % FileName = 'ALS_NoSplit_UserOps_FOFBOn_Small_PTOff_Set1';
    
    % FileName = 'ALS_NoSplit_UserOps_FOFBOn_PTCableOff_PTOff_Set1';
    % FileName = 'ALS_Split_UserOps_Attn12_FOFBOn_PTOff_Set1';
    
    % FileName = 'ALS_NoSplit_UserOps_FOFBOn_Big_PTOff_Set1';
    % FileName = 'ALS_Split_UserOps_Attn12_FOFBOn_Big_PTOff_Set1';

    %  ALS_Split_UserOps_Attn0_FOFBOn_PTOff_Set1';
    %  ALS_Split_UserOps_Attn42_FOFBOn_PTOff_Set1';
    %  ALS_Split_UserOps_Attn52_FOFBOn_PTOff_Set1';
    
elseif 0
    %  1 to 281 -> cover on, 
    %  282 to   -> cover off
    cd /data/bpm/AFE3_FPGA39/2013-11-14
    FileName = 'ALS_PilotTone_Test_PTOn_B_Set1';
    FileName = 'ALS_PilotTone_Test_PTOn_B_Set300';
     
elseif 0
    cd /data/bpm/AFE3_FPGA39/2013-11-11
    
    %load ALS_InputsTerminatedto50ohms_PTOffand3p5_Attn0_Set1
    %load ALS_InputsTerminatedto50ohms_PTOffand3p5_Attn60_Set1
    %load ALS_InputsTerminatedto50ohms_PTOffand3p5_Attn120_Set1
    
    %FileName = 'ALS_Split_50mA_Set1';
    FileName = 'ALS_NoSplit_50mA_Set2';
    
    %FileName = 'ALS_Split2_500mA_Scan_PTOn_A_Set4';
    %FileName = 'ALS_NoSplit_UserOps_Test1_PTOn_A_Set11';
    %FileName = 'ALS_Split2_50mA_Test_PTOn_B_Set7';

elseif 0
    cd /data/bpm/AFE3_FPGA39/2013-11-15
    
    %FileName = 'ALS_CoverOn_50ohmTermination_PTOff_Set1';
    %FileName = 'ALS_CovOn_CombineandSplit_PTOff_Set1';

    %FileName = 'ALS_CoverOff_50ohmTermination_PTOff_Set1';
    FileName = 'ALS_CoverOff_CombineandSplit_PTOff_Set1';
    
elseif 0
    cd /data/bpm/AFE3_FPGA39/2013-11-26
    
    %FileName = 'ALS_50ohmTermination_PTOff_Set1';
    %FigNum = 11;

    %FileName = 'ALS_RSGeneratedRF_NotLocked_PTOff_Set1';
    %FileName = 'ALS_RSGeneratedRF_PTOff_Set1';
    %FileName = 'ALS_Split_500mA_PTOff_Set1';
    
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_FOFBOff_PTOff_Set1';
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_PTOff_Set1';
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_PTOff_Set2';
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_PTOff_Set3';
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_PTOff_Set4';
    %FileName = 'ALS_NoSplit_500mA_Attn40_Big_PTOff_Set5';
    
    FileName = 'ALS_NoSplit_500mA_Attn40_PTOff_Set1';
    FigNum = 21;
    
    %FileName = 'ALS_NoSplit_NoBeam_Attn0_PTOff_Set1';
    %FigNum = 1;
    
    FileName = 'ALS_NoSplit_NoBeam_Attn40_PTOff_Set1';
    FigNum = 11;

    FileNames = {
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set1';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set2';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set3';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set4';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set5';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set6';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set7';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set8';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set9';
        'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set10';
        };

elseif 0
    cd /data/bpm/AFE3_FPGA39/2013-12-05    
    FigNum = 101;
    FileName = 'ALS_NoSplit_UnstableBeam_Attn40_PTOff_Set1';

elseif 0
    cd /data/bpm/AFE3_FPGA39/2013-12-23
    FigNum = 201;
    % FigNum = 101; FileName = 'ALS_52mA_PTOff_Set1';
    % FigNum = 201; FileName = 'ALS_50mA_BergozOff_PTOff_Set1';
    % FigNum = 301; FileName = 'ALS_46mA_BergozOn_PTOff_Set1';
    FigNum = 401; FileName = 'ALS_46mA_BergozOn_Big_PTOff_Set1';
elseif 0
    cd /data/bpm/AFE4/2014-04-18
    FigNum = 101; FileName = 'Test_PTOn_A_Set1';
elseif 1
    % 500mA, User Ops, New Software
    cd /home/physdata/BPM/AFE5Proto_ALSDFE/2014-09-16
    FileName = 'Test_PTOff_Set1';
end

load(FileName);

Setup.Xgain = 16.13;
Setup.Ygain = 16.29;

% Fix a DFE issue with AFE2 and 3?
%ADC.cha(1:end-1) = ADC.cha(2:end);
%ADC.chd(1:end-1) = ADC.chd(2:end);


% PSD setup
TurnsPerFFT = 1;
Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
Setup.PSD.NaveMax = 350;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 0;
Setup.PSD.FigNum = FigNum;
Setup.FileName = FileName;

PSD = bpm_adc2psd(ADC, Setup, ENV);


% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 77 * 100000;  % *11 *7
Setup.xy.NAdvance = 10*77;  % 7 11 77;   % in ADC counts
Setup.xy.FigNum = Setup.PSD.FigNum + 3;
Setup.xy.Shift = 0;

Orbit = bpm_adc2xy(ADC, Setup, ENV);


%  x/y PSD
%clear
%load ALS_Split_UserOps_Attn12_FOFBOn_PTOff_Set1xy150;      FigNum = 40;
%load ALS_NoSplit_UserOps_FOFBOn_Big_PTOff_Set1xy150;        FigNum = 20;  % 1 or 150
%load ALS_Split_UserOps_Attn12_FOFBOn_Big_PTOff_Set1xy150;  FigNum = 10;  % 1 or 150
%load ALS_NoSplit_UserOps_FOFBOn_Big_PTOff_Set1_OrbitCalc

Orbit = bpm_xy2psd(Orbit, Setup, ENV);

save([FileName, '_OrbitCalc'], 'Orbit', 'PSD', 'Setup', 'ENV');


%%

clear
FileNames = {
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set1';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set2';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set3';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set4';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set5';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set6';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set7';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set8';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set9';
    'ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_Set10';
    };

for i = 1:length(FileNames)
    i
    FileName = FileNames{i}
    load(FileName);
    
    % Fix a DFE issue
    ADC.cha(1:end-1) = ADC.cha(2:end);
    ADC.chd(1:end-1) = ADC.chd(2:end);
    
    
    % PSD setup
    TurnsPerFFT = 150;
    Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
    Setup.PSD.NaveMax = 350;
    Setup.PSD.WindowFlag = 0;
    Setup.PSD.Shift = 0;
    Setup.PSD.FigNum = 1;
    Setup.FileName = FileName;
    
    PSD{i} = bpm_adc2psd(ADC, Setup, ENV);
    
    
    % x,y calculation setup
    %Setup.xy.nHarmOrbit = 15:26;
    Setup.xy.nHarmOrbit = 21;
    Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
    Setup.xy.NAvg = 1;
    Setup.xy.NPoints = 77 * 20000000000;  % *11 *7
    Setup.xy.NAdvance = 10*77;  % 7 11 77;   % in ADC counts
    Setup.xy.FigNum = Setup.PSD.FigNum + 3;
    Setup.xy.Shift = 0;
    
    Orbit{i} = bpm_adc2xy(ADC,      Setup, ENV);
    Orbit{i} = bpm_xy2psd(Orbit{i}, Setup, ENV);
end

save('ALS_NoSplit_500mA_Attn40_Big_FOFBOn_PTOff_OrbitCalc', 'Orbit', 'PSD', 'Setup', 'ENV');


%%

for i = 1:length(FileNames)
    Pxx(i,:) = Orbit{i}.PSD.Pxx;
    Pyy(i,:) = Orbit{i}.PSD.Pyy;
end

Pxxm = mean(Pxx, 1);
Pyym = mean(Pyy, 1);

figure(101);
clf reset
%semilogy(Orbit{1}.PSD.f, Orbit{1}.PSD.Pxx, 'r');
semilogy(Orbit{1}.PSD.f, Pyym, 'r');
hold on
semilogy(Orbit{1}.PSD.f, Pxxm, 'b');


%% Bergox

%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-11-27 16:52:12" --irm %d --duration 60.0 --MATLAB', IRM);

%load irm84

figure(500)
h = subplot(2,1,1);
plot(d.t, d.ADC(:,1)' / 3276.8);
h(2) = subplot(2,1,2);
plot(d.t, d.ADC(:,3)' / 3276.8);
linkaxes(h, 'x');



%% plot (same as bpm_adc2xy)

clear

%load ALS_PilotTone_Test_PTOn_B_Set1_OrbitCalc
%load ALS_Split2_500mA_Scan_PTOn_A_Set4OrbitCalc
%load ALS_CoverOff_CombineandSplit_PTOff_Set1_OrbitCalc
%load ALS_CoverOff_50ohmTermination_PTOff_Set1_OrbitCalc

%load ALS_NoSplit_UserOps_FOFBOn_Big_PTOff_Set1_OrbitCalc
load ALS_Split_UserOps_Attn12_FOFBOn_PTOff_Set1_OrbitCalc

bpm_xy_plot(Orbit, Setup, ENV);


%%

FontSize = 12;

cd /data/bpm/AFE3_FPGA39/2013-11-07
load ALS_InputsTerminatedto50ohms_PTOffand3p5_Attn0_Set1xy

Orbit.Arms = Orbit.Arms + SumOffset - 1600;
Orbit.Brms = Orbit.Brms + SumOffset + 1600;
Orbit.Crms = Orbit.Crms + SumOffset;
Orbit.Drms = Orbit.Drms + SumOffset;

SumOffset = 1.2620e+04;
x = Setup.Xgain * (Orbit.Arms-Orbit.Brms-Orbit.Crms+Orbit.Drms) ./ (Orbit.Arms+Orbit.Brms+Orbit.Crms+Orbit.Drms); % mm
y = Setup.Ygain * (Orbit.Arms+Orbit.Brms-Orbit.Crms-Orbit.Drms) ./ (Orbit.Arms+Orbit.Brms+Orbit.Crms+Orbit.Drms); % mm


figure(Setup.PSD.FigNum + 11);
clf reset
h = subplot(2,1,1);
plot(Orbit.TurnNumber, 1000*(x-mean(x)), '-b');
xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
ylabel('Horizontal [\mum]', 'FontSize', FontSize);
%title(sprintf('Pilot Tone Horizontal Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(PTx), NTurnsPerFFT, NAvg), 'FontSize', FontSize);
%axis tight
%a = axis;
%axis([0 a(2:4)]);

h(2) = subplot(2,1,2);
plot(Orbit.TurnNumber, 1000*y, '-b');
ylabel('Vertical [\mum]', 'FontSize', FontSize);
xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%title(sprintf('Pilot Tone Vertical Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(PTy), NTurnsPerFFT, NAvg), 'FontSize', FontSize);
axis tight
%a = axis;
%axis([0 a(2:4)]);



%% RF leakage - 2 button example 


% Measured RMS in counts
a20k = 1.2620e+04;  % With beam, attn set to get about 20k counts
a0   = 0.3643;      % 50 cap on the 4 inputs to the BPM  (.1 to .8 range)

% Equal RF offset in both channels isn't a issue (unless it's huge)
% 1600 count difference is about a 2mm offset
a = a20k - 1600;
b = a20k + 1600;
Orbit1 = 16 * (b-a) / (a + b);
Orbit2 = 16 * (b-a) / (a + b + 2*a0);
dOrbitRFLeakage = 1000 * (Orbit2 - Orbit1)

% Worst case -> RF leakage changes differentially between the channels
WorstCase = 1000 * 16 * (.8 - .1) / (2*a20k - a0)



%%

clear

%  1 to 281 -> cover on,
%  282 to   -> cover off

cd /data/bpm/AFE3_FPGA39/2013-11-14
load calc_arrays

for i = 1:1500
    FileName = sprintf('ALS_PilotTone_Test_PTOn_B_Set%d', i);
    load(FileName);
    ADC.cha(1:end-1) = ADC.cha(2:end);
    ADC.chd(1:end-1) = ADC.chd(2:end);
    
    % PSD setup
    Setup.PSD.Nfft = 77*150;
    Setup.PSD.NaveMax = 350;
    Setup.PSD.WindowFlag = 0;
    Setup.PSD.Shift = 0;
    
    Setup.PSD.FigNum = 0;
    Setup.FileName = FileName;
    
    PSD{i} = bpm_adc2psd(ADC, Setup, ENV);
    
    DataTime(i) = ENV.DataTime;
    RF(i) = ENV.RF0;
    DCCT(i) = ENV.DCCT;
    RF(i) = ENV.RF0;
    
    % x,y calculation setup
    %Setup.xy.nHarmOrbit = 15:26;
    Setup.xy.nHarmOrbit = 21;
    Setup.xy.NTurnsPerFFT = 150;
    Setup.xy.NAvg = 1;
    Setup.xy.NPoints = 5000*7;
    Setup.xy.NAdvance = 11;  %77;   % in ADC counts
    Setup.xy.FigNum = 0;
    Setup.xy.Shift = 0;
    
    Orbit{i} = bpm_adc2xy(ADC, Setup, ENV);
    i
end

save('calc_arrays', 'Orbit', 'PSD', 'Setup', 'ENV');



%% Add to it

%clear
%load calc_arrays

for i = 1:1500
    FileName = sprintf('ALS_PilotTone_Test_PTOn_B_Set%d', i);
    load(FileName);

    DataTime(i) = ENV.DataTime;
    RF(i) = ENV.RF0;
    DCCT(i) = ENV.DCCT;
    RF(i) = ENV.RF0;
    i
end

%save('calc_arrays', 'Orbit', 'PSD', 'Setup', 'ENV');


%%

%clear
%load calc_arrays

Paa = [];
Pbb = [];
Pcc = [];
Pdd = [];
t = [];
N_Time = 1500;  %1470;
for i = 1:1:N_Time
    Paa = [Paa PSD{i}.Paa];
    Pbb = [Pbb PSD{i}.Pbb];
    Pcc = [Pcc PSD{i}.Pcc];
    Pdd = [Pdd PSD{i}.Pdd];
end

%% (Cont.)

N_Time = 1400;  %1470;

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

AZ = 250;
EL =  60;

figure(11);
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

addlabel(.5, 1, 'Power Spectrum for Each Channel', 14);


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



