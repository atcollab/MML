function bpm_meas_psd_sa_staticgain_test(AFE, Rev, Prefix)

if nargin < 1
    AFE = 41;
    error('Input 1 (AFE Number) required.');
end
if nargin < 2
    Rev = 2;
end

RFAttn = 4;
InjectionFlag = 1;


DirStart = pwd;
if Rev == 2
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2');
elseif Rev == 4
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev4');
else
    error('Unknown rev number.');
end


[DFE, IP, PrefixInfoFile, File] = bpm_afeinfo(AFE, Rev);
if nargin < 3 || isempty(Prefix)
    %Prefix = {'Test:BPM1'};    %getfamilydata('BPM','BaseName');
    Prefix = {PrefixInfoFile};
elseif ~iscell(Prefix)
    Prefix = {Prefix};
end
fprintf('   Test and calibrate AFE #%d  DFE #%d  (%s) started %s.\n', AFE, DFE, Prefix{1}, datestr(now, 31));

bpminit_calibration(Prefix, RFAttn, InjectionFlag);


% First the Attenuation table must be Unity!!!
bpm_writefile_attn(AFE, Rev, 'Unity');

% Tone setup
addpath_nsls2_pilot_tone;
NSLS2_Setup.PT.State = 1;         % Pilot tone on (1) or off (0)
NSLS2_Setup.PT.Attn = 100;        % 0 to 127
%NSLS2_Setup.PT.FrequencyCode = '-1/2';
NSLS2_Setup.PT.FrequencyCode = '0.0';
%NSLS2_Setup.PT.FrequencyCode = '+1/2';
setpilottone(NSLS2_Setup.PT);
pause(1);


%%%%%%%%%%
% PT Off %
%%%%%%%%%%
tcp_write_reg(34, 127);  % Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(2, 0);     % Set pilot 1->on, 0->off

for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(.5);

% Arm
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end
pause(5);  % Just so the NSLS2 tone is ready

% Manually trigger
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:softTrigger'], 1);
end
pause(4);

i = 1;
ENV = bpm_getenv(Prefix{i});
ADC_Tone_Off = bpm_getadc(Prefix{i});
bpm_adc2psd(ADC_Tone_Off, ENV, 101);



%%%%%%%%%
% PT On %
%%%%%%%%%
tcp_write_reg(34, NSLS2_Setup.PT.Attn);  % Set pilot tone magnitude (attenuator for NSLS2 PT)
tcp_write_reg(2, 1);                     % Set pilot 1->on, 0->off

for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(.5);

% Arm
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end
pause(5);  % Just so the NSLS2 tone is ready

% Manually trigger
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:softTrigger'], 1);
end
pause(4);

i = 1;
ADC = bpm_getadc(Prefix{i});
bpm_adc2psd(ADC, ENV, 111);


TimeStamp = now;
if Rev == 2
    AFE_SN = sprintf('AFE2_Rev2_SN%03d', AFE);
else
    AFE_SN = sprintf('AFE2_Rev4_SN%03d', AFE);
end
FileName = appendtimestamp(['TurnOnData_', AFE_SN], TimeStamp);

save(FileName, 'AFE', 'DFE', 'Prefix', 'FileName', 'IP', 'ENV', 'ADC', 'ADC_Tone_Off');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Monitor SA while warming up %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%t = 0:.1:  10*60;
%t = 0:.1:1*60*60;
t = 0:.1:2*60*60;
%t = 0:.1:3*60*60;
fprintf('   Getting SA data for %.1f minutes\n', t(end)/60);
SA = bpm_getsa(Prefix{i}, t, 1);
save(FileName, 'AFE', 'DFE', 'Prefix', 'FileName', 'IP', 'ENV', 'ADC', 'ADC_Tone_Off', 'SA');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measure the calibration table %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileNameAttn = bpm_meas_staticgain(AFE, Rev, Prefix{i});


% Write the attenuation table to the BPM
bpm_writefile_attn(AFE, Rev, [FileNameAttn, '.csv']);
pause(1);



%%%%%%%%%%%%%%%%%%%%%%%
% Test the attn table %
%%%%%%%%%%%%%%%%%%%%%%%
fprintf('   Testing the attn table.\n');
x=[];y=[];s=[];a=[];b=[];c=[];d=[];attn=[];
tcp_write_reg(34, 103);  %  was 100
for j = 0:31
    setpvonline([Prefix{i},':attenuation'], j);
    fprintf('   Attn = %d\n', j);
    pause(2);    % ???
    
    x(j+1) = getpvonline([Prefix{i},':SA:X']);
    y(j+1) = getpvonline([Prefix{i},':SA:Y']);
    s(j+1) = getpvonline([Prefix{i},':SA:S']);
    a(j+1) = getpvonline([Prefix{i},':ADC3:rfMag']);
    b(j+1) = getpvonline([Prefix{i},':ADC1:rfMag']);
    c(j+1) = getpvonline([Prefix{i},':ADC2:rfMag']);
    d(j+1) = getpvonline([Prefix{i},':ADC0:rfMag']);
    attn(j+1) = getpvonline([Prefix{i},':attenuation']);
end


figure(120);
clf reset
subplot(3,1,1);
plot(attn, x);
ylabel('x [mm]');
subplot(3,1,2);
plot(attn, y);
ylabel('y [mm]');
subplot(3,1,3);
plot(attn, [a;b;c;d]);
ylabel('A B C D');
xlabel('Attenuator');

save(FileName, 'AFE', 'DFE', 'FileName', 'FileNameAttn', 'IP', 'ENV', 'ADC', 'ADC_Tone_Off', 'SA', 'x', 'y', 's', 'a', 'b', 'c', 'd', 'attn');

cd(DirStart);

fprintf('   Test data         saved to  %s.csv\n', FileName);
fprintf('   Calibration table saved to %s.mat\n', FileNameAttn);
fprintf('   Measure, test, save -> Complete.\n\n');







