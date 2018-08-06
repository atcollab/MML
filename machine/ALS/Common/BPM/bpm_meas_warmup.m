% Static Gain Calibration - Matlab script for measurement of static gain 0 to 31 dB range.


clear

AFE = 33;
%Prefix = 'SR01C:BPM4';
%Prefix = 'BTS:BPM5';
Prefix = 'Test:BPM1';

addpath_nsls2_pilot_tone;
 
% Start time
TimeStampStart = now;
fprintf('\nMeasurement Started at %s\n', datestr(TimeStampStart,31));

DirStart = pwd;
%gotodirectory('/home/als/physdata/BPM/Warmup/AFE2_Rev4');
gotodirectory('/home/als/physdata/BPM/Warmup/AFE2_Rev2');

% if linac or ltb mode, change to sr mode, linac & ltb have no FA data!!!

SplitterGain = [
    0.9753
    0.9790
    1.0000
    0.9930];

% NSLS2 PT Amplitude
% 1. PT_Attn =  0 of 127, ADCmax =  6k @ BPM_Attn = 31 of 31
% 2. PT_Attn =  0 of 127, ADCmax = 20k @ BPM_Attn = 19 of 31
% 3. PT_Attn = 77 of 127, ADCmax = 20k @ BPM_Attn =  0 of 31
%
% Attn Table
%  BPM   PT
%   0    80
%   1    76
%    ...
%  19     4
%  20     0
%     ...
%  31     0

%Attn = [[80:-4:0 zeros(1,11)]; [0:20 21:31]];  % Rev4 or mod Rev2
Attn = [[116:-4:0 zeros(1,2)]; [0:20 21:31]];   % Rev2

% Pilot tone setup
NSLS2_Setup.PT.State = 1;        % Pilot tone on (1) or off (0)
NSLS2_Setup.PT.Attn = 80;        % 0 to 127
%NSLS2_Setup.PT.FrequencyCode = '-1/2';
NSLS2_Setup.PT.FrequencyCode = '0.0';
%NSLS2_Setup.PT.FrequencyCode = '+1/2';
setpilottone(NSLS2_Setup.PT);


% Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(34, NSLS2_Setup.PT.Attn);


% Setup the BPM
bpm_setenv(Prefix, Attn(2,1), 0);

setpvonline([Prefix,':adcGain'], 0);          % 0->1 1->1.5

% Gain Trim
setpvonline([Prefix,':ADC0:gainTrim'], 1);
setpvonline([Prefix,':ADC1:gainTrim'], 1);
setpvonline([Prefix,':ADC2:gainTrim'], 1);
setpvonline([Prefix,':ADC3:gainTrim'], 1);

% Disarm
setpvonline([Prefix,':wfr:ADC:arm'], 0);
setpvonline([Prefix,':wfr:TBT:arm'], 0);
setpvonline([Prefix,':wfr:FA:arm'],  0);
pause(.01);

% Waveform length
% 77*12988 = 1000076
setpvonline([Prefix,':wfr:ADC:acqCount'], 1000076);  % ADC max 1,048,576
setpvonline([Prefix,':wfr:TBT:acqCount'],  100000);  % ADC max 100,000?
setpvonline([Prefix,':wfr:FA:acqCount'],    50000);  % ADC max 10,000

setpvonline([Prefix,':wfr:ADC:pretrigCount'], 3080);  % Not changeable
setpvonline([Prefix,':wfr:TBT:pretrigCount'], 10000);
setpvonline([Prefix,':wfr:FA:pretrigCount'],  10000);

setpvonline([Prefix,':EVR:delay0'], 1);
setpvonline([Prefix,':EVR:delay4'], 1);
setpvonline([Prefix,':EVR:delay5'], 1);
setpvonline([Prefix,':EVR:delay6'], 1);
setpvonline([Prefix,':EVR:delay7'], 1);

% Trigger mask -> Software
setpvonline([Prefix,':wfr:ADC:triggerMask'], hex2dec('1'));
setpvonline([Prefix,':wfr:TBT:triggerMask'], hex2dec('1'));
setpvonline([Prefix,':wfr:FA:triggerMask'],  hex2dec('1'));

% Disable PT
setpvonline([Prefix,':autotrim:enable'], 0);
bpm_writefile_attn(AFE, 'Unity');
setpvonline([Prefix,':ADC0:gainTrim'], 1);
setpvonline([Prefix,':ADC1:gainTrim'], 1);
setpvonline([Prefix,':ADC2:gainTrim'], 1);
setpvonline([Prefix,':ADC3:gainTrim'], 1);

NAttn = 1;
TurnsPerFFT = 160;
FigNum = 1;

ENV = bpm_getenv(Prefix);

rfMagPV = [
    [Prefix,':ADC0:rfMag']
    [Prefix,':ADC1:rfMag']
    [Prefix,':ADC2:rfMag']
    [Prefix,':ADC3:rfMag']
    [Prefix,':SA:X      ']
    [Prefix,':SA:Y      ']    
%    [Prefix,':SA:Q      ']
%    [Prefix,':SA:S      ']    
];


i = 1;
% Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(34, Attn(1,i));

% BPM Attn
setpvonline([Prefix,':attenuation'], Attn(2,i));
pause(3);    % ???


for i = 1:6*60*60
    a = getpvonline(rfMagPV, 0:.1:1);
    rfMagMean(:,i) = mean(a(1:4,:), 2);
    rfMagMax(:,i)  = max(a(1:4,:), [], 2);
    rfMagMin(:,i)  = min(a(1:4,:), [], 2);

    xMean(:,i) = mean(a(5,:));
    xMax(:,i)  = max(a(5,:));
    xMin(:,i)  = min(a(5,:));

    yMean(:,i) = mean(a(6,:));
    yMax(:,i)  = max(a(6,:));
    yMin(:,i)  = min(a(6,:));

    t(1,i) = now;
    fprintf('%3d.   %d   %d   %d   %d   %s\n', i, rfMagMin(:,i), datestr(now, 31));
end

TimeStamp = now;
%AFE_SN = sprintf('AFE2_Rev4_SN%03d', AFE);
AFE_SN = sprintf('AFE2_Rev2_SN%03d', AFE);
FileName = appendtimestamp(['Warmup_', AFE_SN], TimeStamp);

save(FileName);


figure(1);
clf reset
h(5) = subplot(2,1,1);
plot(xMean(1,:), 'b');
hold on
plot(xMax(1,:), 'g');
plot(xMin(1,:), 'r');
h(6) = subplot(2,1,2);
plot(yMean(1,:), 'b');
hold on
plot(yMax(1,:), 'g');
plot(yMin(1,:), 'r');

return


%%

clear
%FileName = 'Warmup_AFE2_Rev4_SN002_2015-10-27_22-57-08.mat';
%FileName = 'Warmup_AFE2_Rev4_SN011_2015-10-19_08-58-05.mat' 
%FileName = 'Warmup_AFE2_Rev4_SN013_2015-10-19_16-33-07.mat'    % VCXO jumps
%FileName = 'Warmup_AFE2_Rev4_SN013_2015-10-19_22-28-26.mat'    % VCXO jumps & ADC0 wobble
%FileName = 'Warmup_AFE2_Rev4_SN014_2015-10-19_00-25-53.mat' 
%FileName = 'Warmup_AFE2_Rev4_SN015_2015-10-18_23-53-29.mat'    % VCXO jump
%FileName = 'Warmup_AFE2_Rev4_SN018_2015-10-18_22-56-23.mat'

%FileName = 'Warmup_AFE2_Rev2_SN004_2015-11-02_20-24-02.mat';
%FileName = 'Warmup_AFE2_Rev2_SN004_2015-11-03_08-35-02.mat';

%FileName = 'Warmup_AFE2_Rev2_SN007_2015-11-03_20-38-34.mat';
%FileName = 'Warmup_AFE2_Rev2_SN022_2015-11-04_11-57-00.mat';

load(FileName);


%%
try
    tt = 24*(t - t(1));
catch
    tt = 0:(size(rfMagMean,2)-1);
end

figure(11);
clf reset
clear h
for i = 1:4
    h(i) = subplot(4,1,i);
    plot(tt, rfMagMean(i,:), 'b');
    hold on
    plot(tt, rfMagMax(i,:), 'g');
    plot(tt, rfMagMin(i,:), 'r');
end
subplot(4,1,1);
title(FileName(8:22), 'Interpret', 'None');


try
figure(12);
clf reset
h(5) = subplot(2,1,1);
plot(tt, xMean(1,:), 'b');
hold on
plot(tt, xMax(1,:), 'g');
plot(tt, xMin(1,:), 'r');
title(FileName(8:22), 'Interpret', 'None');

h(6) = subplot(2,1,2);
plot(tt, yMean(1,:), 'b');
hold on
plot(tt, yMax(1,:), 'g');
plot(tt, yMin(1,:), 'r');
catch
end

linkaxes(h, 'x');






