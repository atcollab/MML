function FileName = bpm_meas_staticgain(AFE, Rev, PrefixInput)
% Static Gain Calibration - Matlab script for measurement of static gain 0 to 31 dB range.

% NOTES
% * Possible issue with AFE 13


% If linac or ltb mode, change to sr mode, linac & ltb have no FA data!!!
% 1. Parameters.csv -> like SR
% 2. rtTable.csv    -> like SR
% 3. ptTable.csv    -> like SR
% To make a TL BPM just change Parameters.csv to single pass with stripline geometry


% If the NSLS2 BPM isn't locked:
%
% Terminal setup
% Baud 115200
% Parity None
% (Linux device something like /dev/tty50)
%
% NSLS-II Setup from the Console
% ad9510 0400
% ad9510 0500
% ad9510 064d
% ad9510 0877

addpath_nsls2_pilot_tone;

if nargin < 2
   error('AFE number and Rev are required inputs.');
end

[DFE, IP, Prefix, File] = bpm_afeinfo(AFE, Rev);

if nargin >= 3 && ~isempty(PrefixInput)
    Prefix = PrefixInput;
end



% Start time
TimeStampStart = now;
fprintf('\nMeasurement Started at %s\n', datestr(TimeStampStart,31));
DirStart = pwd;
if Rev == 2
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2');
elseif Rev == 4
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev4');
else
    error('Unknown rev number.');
end


% BPM Attn = 18
% PT  Attn =  0
% Port 1 into ChA (ADC3) = 8018117   In BPM mode: ChD ADC0
% Port 2 into ChA (ADC3) = 7987105   In BPM mode: ChB ADC1
% Port 3 into ChA (ADC3) = 7819769   In BPM mode: ChC ADC2
% Port 4 into ChA (ADC3) = 7874896   In BPM mode: ChA ADC3
% m = [
%     8018117
%     7987105
%     7819769
%     7874896
%     ];
% g = m/min(m)
%     1.0254
%     1.0214
%     1.0000
%     1.0070
% 1./g
SplitterGain = [
    0.9753
    0.9790
    1.0000
    0.9930];
% setpvonline([Prefix,':ADC0:gainTrim '], SplitterGain(1));
% setpvonline([Prefix,':ADC1:gainTrim '], SplitterGain(2));
% setpvonline([Prefix,':ADC2:gainTrim '], SplitterGain(3));
% setpvonline([Prefix,':ADC3:gainTrim '], SplitterGain(4));
% gainTrim,, gainFactor


% NSLS2 PT Amplitude
if Rev == 2
    % Attn Table  -- Ext Amp, with 6dB in chassis
    %  BPM     PT
    %    0    127    23k ADC Counts
    %   23      0    20k ADC Counts
    %   31      0     8k ADC Counts
    Attn = [[124:-4:0]; [0:31]];
    
elseif Rev == 4
    % 1. PT_Attn =  0 of 127, ADCmax =  6k @ BPM_Attn = 31 of 31
    % 2. PT_Attn =  0 of 127, ADCmax = 20k @ BPM_Attn = 19 of 31
    % 3. PT_Attn = 77 of 127, ADCmax = 20k @ BPM_Attn =  0 of 31
    %
    % Attn Table  -- No amp, without 6dB in chassis
    %  BPM   PT
    %   0    80
    %   1    76
    %    ...
    %  19     4
    %  20     0
    %     ...
    %  31     0
    Attn = [[80:-4:0 zeros(1,11)]; [0:20 21:31]];
end


% First the Attenuation table must be Unity!!!
bpm_writefile_attn(AFE, Rev, 'Unity');


% Pilot tone setup
NSLS2_Setup.PT.State = 1;         % Pilot tone on (1) or off (0)
NSLS2_Setup.PT.Attn = 127;        % 0 to 127
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
setpvonline([Prefix,':ADC0:gainTrim'], 1);
setpvonline([Prefix,':ADC1:gainTrim'], 1);
setpvonline([Prefix,':ADC2:gainTrim'], 1);
setpvonline([Prefix,':ADC3:gainTrim'], 1);

%NAttn = 1;
ENV = bpm_getenv(Prefix);

rfMagPV = [
    [Prefix,':ADC0:rfMag']
    [Prefix,':ADC1:rfMag']
    [Prefix,':ADC2:rfMag']
    [Prefix,':ADC3:rfMag']
];

pause(3);   % Just so the tone & BPM are in steady state 

for i = 1:size(Attn,2)
    fprintf('%2d. PT Attn %3d   BPM Attn %2d   %s\n', i, Attn(1,i), Attn(2,i), datestr(now, 31));
    
    % Set pilot tone magnitude (attenuator for NSLS2 PT)
    tcp_write_reg(34, Attn(1,i));
    
    % BPM Attn - if different
    if getpvonline([Prefix,':attenuation']) ~= Attn(2,i)
        setpvonline([Prefix,':attenuation'], Attn(2,i));
        pause(3);    % ???
    end
    
    % Arm and Soft trigger
    %setpvonline([Prefix,':wfr:ADC:arm'], 1);
    %pause(.2);
    %setpvonline([Prefix,':wfr:softTrigger'], 1);
    %pause(2);    % ???
    
    % Get data
    %ENV{1,i} = bpm_getenv(Prefix);
    %ADC{1,i} = bpm_getadc(Prefix);
    
    % Get all a once and add averaging !!!
    %rfMag(1,i) = getpvonline([Prefix,':ADC0:rfMag']);
    %rfMag(2,i) = getpvonline([Prefix,':ADC1:rfMag']);
    %rfMag(3,i) = getpvonline([Prefix,':ADC2:rfMag']);
    %rfMag(4,i) = getpvonline([Prefix,':ADC3:rfMag']);
    a = getpvonline(rfMagPV, 0:.1:2);
    rfMag(:,i) = mean(a,2);
    
    % Get data at attenuator +1
    if Attn(2,i)+1 <= 31
        % BPM Attn
        setpvonline([Prefix,':attenuation'], Attn(2,i)+1);
        pause(3);    % ???
        
        % Arm and Soft trigger
        %setpvonline([Prefix,':wfr:ADC:arm'], 1);
        %pause(.2);
        %setpvonline([Prefix,':wfr:softTrigger'], 1);
        %pause(2);    % ???
        
        % Get data
        %ENV{2,i} = bpm_getenv(Prefix);
        %ADC{2,i} = bpm_getadc(Prefix);
        a = getpvonline(rfMagPV, 0:.1:2);
        rfMagP1(:,i) = mean(a,2);
    end
    
    
    % PSD input setup
    %  TurnsPerFFT = 160;
    %  Setup.Attn = ENV{1,i}.AFE.Attenuation;
    %  Setup.Xgain = 16.;  % Arc BPM
    %  Setup.Ygain = 16.;  % Arc BPM
    %  Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
    %  Setup.PSD.NaveMax = 200                                    ;
    %  Setup.PSD.WindowFlag = 0;
    %  Setup.PSD.Shift = 36;
    %  Setup.PSD.FigNum = FigNum;
    %
    %  PSD{1,i} = bpm_adc2psd(ADC{1,1}, ENV{1,i}, Setup);  % PSD
    %  PSD{2,i} = bpm_adc2psd(ADC{2,1}, ENV{2,i}, Setup);  % PSD
    %
    %  TP(1,i) = sqrt(PSD{1,i}.Paa(PSD{1,i}.nHarmTP)    * PSD{1,i}.T1);
    %  RF(1,i) = sqrt(PSD{1,i}.Paa(PSD{1,i}.nHarmOrbit) * PSD{1,i}.T1);
    %
    %  P1(1,i) = sqrt(PSD{1,i}.Paa_int(PSD{1,i}.nHarmOrbit+2)-PSD{1,i}.Paa_int(PSD{1,i}.nHarmOrbit-2));
    %  P1(2,i) = sqrt(PSD{1,i}.Pbb_int(PSD{1,i}.nHarmOrbit+2)-PSD{1,i}.Pbb_int(PSD{1,i}.nHarmOrbit-2));
    %  P1(3,i) = sqrt(PSD{1,i}.Pcc_int(PSD{1,i}.nHarmOrbit+2)-PSD{1,i}.Pcc_int(PSD{1,i}.nHarmOrbit-2));
    %  P1(4,i) = sqrt(PSD{1,i}.Pdd_int(PSD{1,i}.nHarmOrbit+2)-PSD{1,i}.Pdd_int(PSD{1,i}.nHarmOrbit-2));
    %
    %  P2(1,i) = sqrt(PSD{2,i}.Paa_int(PSD{2,i}.nHarmOrbit+2)-PSD{2,i}.Paa_int(PSD{2,i}.nHarmOrbit-2));
    %  P2(2,i) = sqrt(PSD{2,i}.Pbb_int(PSD{2,i}.nHarmOrbit+2)-PSD{2,i}.Pbb_int(PSD{2,i}.nHarmOrbit-2));
    %  P2(3,i) = sqrt(PSD{2,i}.Pcc_int(PSD{2,i}.nHarmOrbit+2)-PSD{2,i}.Pcc_int(PSD{2,i}.nHarmOrbit-2));
    %  P2(4,i) = sqrt(PSD{2,i}.Pdd_int(PSD{2,i}.nHarmOrbit+2)-PSD{2,i}.Pdd_int(PSD{2,i}.nHarmOrbit-2));
    %
    %  PP1(1,i) = sqrt(PSD{1,i}.Paa(PSD{1,i}.nHarmOrbit) * PSD{1,i}.T1 * PSD{1,i}.f0);
    %  PP1(2,i) = sqrt(PSD{1,i}.Pbb(PSD{1,i}.nHarmOrbit) * PSD{1,i}.T1 * PSD{1,i}.f0);
    %  PP1(3,i) = sqrt(PSD{1,i}.Pcc(PSD{1,i}.nHarmOrbit) * PSD{1,i}.T1 * PSD{1,i}.f0);
    %  PP1(4,i) = sqrt(PSD{1,i}.Pdd(PSD{1,i}.nHarmOrbit) * PSD{1,i}.T1 * PSD{1,i}.f0);
    %
    %  PP2(1,i) = sqrt(PSD{2,i}.Paa(PSD{2,i}.nHarmOrbit) * PSD{2,i}.T1 * PSD{1,i}.f0);
    %  PP2(2,i) = sqrt(PSD{2,i}.Pbb(PSD{2,i}.nHarmOrbit) * PSD{2,i}.T1 * PSD{1,i}.f0);
    %  PP2(3,i) = sqrt(PSD{2,i}.Pcc(PSD{2,i}.nHarmOrbit) * PSD{2,i}.T1 * PSD{1,i}.f0);
    %  PP2(4,i) = sqrt(PSD{2,i}.Pdd(PSD{2,i}.nHarmOrbit) * PSD{2,i}.T1 * PSD{1,i}.f0);
    %
    %  AttnDB(1,i) = 20*log10(P1(1,i)/P2(1,i));
    %  AttnDB(2,i) = 20*log10(P1(2,i)/P2(2,i));
    %  AttnDB(3,i) = 20*log10(P1(3,i)/P2(3,i));
    %  AttnDB(4,i) = 20*log10(P1(4,i)/P2(4,i));
    %
    %  imax(1,i) = max(P1(:,i));
end


% Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(34, 100);

TimeStamp = now;
if Rev == 2
    AFE_SN = sprintf('AFE2_Rev2_SN%03d', AFE);
else
    AFE_SN = sprintf('AFE2_Rev4_SN%03d', AFE);
end
FileName = appendtimestamp(['Attenuation_', AFE_SN], TimeStamp);


% First compensate for the splitter 
for i = 1:size(rfMag,1)
    sMag(i,:)   = SplitterGain(i) * rfMag(i,:);
    sMagP1(i,:) = SplitterGain(i) * rfMagP1(i,:);
end

% %%
% sMag(:,1)
% g = sMag(:,1)/min(sMag(:,1))
% g1 = 1./g
% 
% [g1.*sMag(:,1) g1.*sMag(:,2)]


% Gain from absolute 
for i = 1:size(sMag,2)
    g = sMag(:,i)/min(sMag(:,i));
    Gain(:,i) = 1./g;
    Err(:,i) = Gain(:,i) .* sMag(:,i);
end

DirStart = pwd;
FileNameCSV = [FileName, '.csv'];
fid = fopen(FileNameCSV, 'w');
for i = 1:size(Gain,2)
    fprintf(fid, '%.5f,%.5f,%.4f,%.4f\n', Gain(:,i)');
end
fprintf('   Data saved to %s\n', FileName);
fclose(fid);
clear a ans
save(FileName);
cd(DirStart);




% Gain
% 
% return
% 
% 
% %% Gain from differance 
% for i = 1:size(sMagP1,2)
%     m1 = sMag(:,i) / min(sMag(:,i));
%     m2 = sMagP1(:,i) / min(sMagP1(:,i));
%     
%     dgain(:,i) = m1./m2;
%     
%     %d = sMag(:,i) - sMagP1(:,i)
% end
% 
% %%
% 
% 
% gain(:,1:5)
% dgain(:,1:5)
% gg = [gain(:,1) dgain(:,1:4).*gain(:,1:4)]
% 
% gg 
% 
% 
% 
% %% Test that the gain produces the Splitter output
% 
% i = 1;
% setpvonline([Prefix,':ADC0:gainTrim '], gain(1,i));
% setpvonline([Prefix,':ADC1:gainTrim '], gain(2,i));
% setpvonline([Prefix,':ADC2:gainTrim '], gain(3,i));
% setpvonline([Prefix,':ADC3:gainTrim '], gain(4,i));
% 
% %%
% 
% SplitterGain
% 
% m(1,1) = getpvonline([Prefix,':ADC0:rfMag']);
% m(2,1) = getpvonline([Prefix,':ADC1:rfMag']);
% m(3,1) = getpvonline([Prefix,':ADC2:rfMag']);
% m(4,1) = getpvonline([Prefix,':ADC3:rfMag']);
% 
% g = m(:,1)/min(m);
% g = 1./g
% 
% 
% %%
% [MagMax,ii] = max(Mag1(:,1:7))
% for i = 1:4
%     Err1(i,:) = Mag1(i,:) ./ MagMax;
% end
% G1 = 1 ./ Err1

% % Issues
% % * GainTableByRow includes the Splitter with is not likely in the beam path
% % * GainTableColShift is by Column, I could remove the time dependance by doing two point differences
%
% %GainTableByRow = [(0:31)' Gain*2^15-1];
% GainTableByRow = round(GainTableByRow);
%
% %
% for i = 1:4
%     Gain0(:,i) = Gain(:,i) / Gain(1,i);
% end
% Gain0 = Gain0 / max(max(Gain0));
% Gain0 = 2^15 * Gain0 - 1;
% GainTableColShift = [GainTableByRow(:,1) round(Gain0)];
%
% TimeStampEnd = now;
% %FileName = sprintf('%s_ADC_Calibration', Prefix);
% %FileName = 'SR02C_BPM8_ADC_Calibration1';
% if NAttn == 1
%     if exist('SN000_ADC_Calibration1.mat','file') == 0
%         FileName = 'SN000_ADC_Calibration1';
%     elseif exist('SN000_ADC_Calibration2.mat','file') == 0
%         FileName = 'SN000_ADC_Calibration2';
%     elseif exist('SN000_ADC_Calibration3.mat','file') == 0
%         FileName = 'SN000_ADC_Calibration3';
%     else
%         FileName = 'SN000_ADC_Calibration4';
%     end
% else
%     FileName = 'SN000_ADC_Calibration_Delta';
% end
% %FileName = appendtimestamp(FileName,TimeStampStart);
% %FileName(strfind(FileName,'{')) = [];
% %FileName(strfind(FileName,'}')) = [];
% %FileName(strfind(FileName,':')) = [];
% %save(FileName, 'Setup', 'ENV', 'ADC', 'PSD', 'Gain', 'GainTable', 'Prefix');
% save(FileName);
% fprintf('Data saved to %s\n', FileName);
%
% fid = fopen([FileName,'Col.csv'], 'w');
% for i = 1:size(GainTableColShift,1)
%     fprintf(fid, '%d,%d,%d,%d,%d\n,', GainTableColShift(i,:));
% end
% fprintf(fid, '#\n');
% fclose(fid);
%
% fid = fopen([FileName,'Row.csv'], 'w');
% for i = 1:size(GainTableByRow,1)
%     fprintf(fid, '%d,%d,%d,%d,%d,\n', GainTableByRow(i,:));
% end
% fprintf(fid, '#\n');
% fclose(fid);
%
% fprintf('Measurement ended at %s   (%.1f minutes)\n\n', datestr(TimeStampEnd,31), 24*60*(TimeStampEnd-TimeStampStart));
%
% cd(DirStart);
%
%
% %%
% if NAttn >= 2
%
%     ChDB = abs([A_AttnDB B_AttnDB C_AttnDB D_AttnDB]);
%     Attn = cumsum(ChDB);
%     figure(1);
%     clf reset
%     plot(ChDB)
% end
%
%
%
% %%
% % clear Paa Pbb Pcc Pdd A_AttnDB B_AttnDB C_AttnDB D_AttnDB
% % for i = 0:28
% %     Paa(i+1,:) = [sqrt(PSD{2,i}.Paa(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1) sqrt(PSD{2,i}.Paa(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1)];
% %     Pbb(i+1,:) = [sqrt(PSD{2,i}.Pbb(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1) sqrt(PSD{2,i}.Pbb(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1)];
% %     Pcc(i+1,:) = [sqrt(PSD{2,i}.Pcc(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1) sqrt(PSD{2,i}.Pcc(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1)];
% %     Pdd(i+1,:) = [sqrt(PSD{2,i}.Pdd(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1) sqrt(PSD{2,i}.Pdd(PSD{2,i}.nHarmOrbit)*PSD{2,i}.T1)];
% %
% %     A_AttnDB(i+1,1) = 20*log10(Paa(1,i)/Paa(i+1,1));
% %     B_AttnDB(i+1,1) = 20*log10(Pbb(1,i)/Pbb(i+1,1));
% %     C_AttnDB(i+1,1) = 20*log10(Pcc(1,i)/Pcc(i+1,1));
% %     D_AttnDB(i+1,1) = 20*log10(Pdd(1,i)/Pdd(i+1,1));
% % end
% %
% % [A_AttnDB B_AttnDB C_AttnDB D_AttnDB]
% %
%
%
% %% Make a unity table
% % a = (2^15-1) * ones(32,1);
% % GainTableUnity = [(0:31)' a a a a];
% %
% % fid = fopen('AttnGain32767.txt', 'w');
% % for i = 1:size(GainTableUnity,1)
% %     fprintf(fid, '%d,%d,%d,%d,%d,\n', GainTableUnity(i,:));
% % end
% % fprintf(fid, '#\n');
% % fclose(fid);
