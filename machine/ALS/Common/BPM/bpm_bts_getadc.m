function [d, ADC0, ErrorFlag] = bpm_bts_getadc(Prefix, WaitFlag)

if nargin < 1 || isempty(Prefix)
    Prefix = 'BTS:BPM5';
end
if nargin < 2 || isempty(WaitFlag)
    WaitFlag = 1;
end

ErrorFlag = 0;

% Starting
[d.ADC.A, t, TsA] = getpvonline([Prefix,':wfr:ADC:A'], 'waveform', 1);
[d.ADC.B, t, TsB] = getpvonline([Prefix,':wfr:ADC:B'], 'waveform', 1);
[d.ADC.C, t, TsC] = getpvonline([Prefix,':wfr:ADC:C'], 'waveform', 1);
[d.ADC.D, t, TsD] = getpvonline([Prefix,':wfr:ADC:D'], 'waveform', 1);
ADC.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);


% Arm (if changing a setup value, disarm first!)
setpvonline([Prefix,':wfr:ADC:arm'], 1);
pause(.1);

% ADC.SA.X = getpvonline([Prefix,':SA:X']);
% ADC.SA.Y = getpvonline([Prefix,':SA:Y']);
% ADC.SA.Q = getpvonline([Prefix,':SA:Q']);
% ADC.SA.S = getpvonline([Prefix,':SA:S']);

% Wait on armed PV
t0 = clock;
ArmADC = getpvonline([Prefix,':wfr:ADC:armed'], 'double');
while any(ArmADC)
    pause(.25);
    ArmADC = getpvonline([Prefix,':wfr:ADC:armed'], 'double');
    fprintf('   Waiting  (%s)  (%s)  (%s)  (%s)   local %s\n',  datestr(ADC.Ts(1),31), datestr(ADC.Ts(2),31), datestr(ADC.Ts(3),31), datestr(ADC.Ts(4),31), datestr(now,31));
end

% Wait on the waveform time stamp
i = 0;
fprintf('   ADC %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(ADC.Ts(1),31), datestr(ADC.Ts(2),31), datestr(ADC.Ts(3),31), datestr(ADC.Ts(4),31), datestr(now,31));
ADC0 = ADC;

for i = 1:60
    [d.ADC.A, t, TsA] = getpvonline([Prefix,':wfr:ADC:A'], 'waveform', 100);
    [d.ADC.B, t, TsB] = getpvonline([Prefix,':wfr:ADC:B'], 'waveform', 100);
    [d.ADC.C, t, TsC] = getpvonline([Prefix,':wfr:ADC:C'], 'waveform', 100);
    [d.ADC.D, t, TsD] = getpvonline([Prefix,':wfr:ADC:D'], 'waveform', 100);
    ADC.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);
    fprintf('   ADC %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(ADC.Ts(1),31), datestr(ADC.Ts(2),31), datestr(ADC.Ts(3),31), datestr(ADC.Ts(4),31), datestr(now,31));
    
    if all(abs(ADC.Ts - ADC0.Ts) > .05/24/3600)
        break
    end
    pause(.25);
end

if i == 60
    error('Error waiting for waveform buffers to change time.');
end

% Just start over
d.ADC = bpm_getadc(Prefix);
d.SA  = bpm_getsa(Prefix, 0, 0);


%d.ADC.A = d.ADC.A(:);
%d.ADC.B = d.ADC.B(:);
%d.ADC.C = d.ADC.C(:);
%d.ADC.D = d.ADC.D(:);
% 
% d.SA.X = getpvonline([Prefix,':SA:X']);
% d.SA.Y = getpvonline([Prefix,':SA:Y']);
% d.SA.Q = getpvonline([Prefix,':SA:Q']);
% d.SA.S = getpvonline([Prefix,':SA:S']);
% 
% d.ADC.rfMag0 = getpvonline([Prefix,':ADC0:rfMag']);
% d.ADC.rfMag1 = getpvonline([Prefix,':ADC1:rfMag']);
% d.ADC.rfMag2 = getpvonline([Prefix,':ADC2:rfMag']);
% d.ADC.rfMag3 = getpvonline([Prefix,':ADC3:rfMag']);

d.LTB.ICT = getpv('LTB:ICT1');
d.BTS.ICT = getpv('BTS:ICT1');
d.BTS.ICT = getpv('BTS:ICT2');













