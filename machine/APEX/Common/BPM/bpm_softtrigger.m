function ErrorFlag = bpm_softtrigger(Prefix, WaitFlag)

if nargin < 1 || isempty(Prefix)
    Prefix = 'SR01C:BPM4';
end
if nargin < 2 || isempty(WaitFlag)
    WaitFlag = 1;
end

ErrorFlag = 0;

% Starting
[ADC.cha, t, TsA] = getpvonline([Prefix,':wfr:ADC:A'], 'waveform', 1);
[ADC.chb, t, TsB] = getpvonline([Prefix,':wfr:ADC:B'], 'waveform', 1);
[ADC.chc, t, TsC] = getpvonline([Prefix,':wfr:ADC:C'], 'waveform', 1);
[ADC.chd, t, TsD] = getpvonline([Prefix,':wfr:ADC:D'], 'waveform', 1);
ADC.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);

[TBT.cha, t, TsA] = getpvonline([Prefix,':wfr:TBT:c3'], 'waveform', 1);
[TBT.chb, t, TsB] = getpvonline([Prefix,':wfr:TBT:c1'], 'waveform', 1);
[TBT.chc, t, TsC] = getpvonline([Prefix,':wfr:TBT:c2'], 'waveform', 1);
[TBT.chd, t, TsD] = getpvonline([Prefix,':wfr:TBT:c0'], 'waveform', 1);
TBT.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);

[FA.cha, t, TsA] = getpvonline([Prefix,':wfr:FA:c3'], 'waveform', 1);
[FA.chb, t, TsB] = getpvonline([Prefix,':wfr:FA:c1'], 'waveform', 1);
[FA.chc, t, TsC] = getpvonline([Prefix,':wfr:FA:c2'], 'waveform', 1);
[FA.chd, t, TsD] = getpvonline([Prefix,':wfr:FA:c0'], 'waveform', 1);
FA.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);


% Arm (if changing a setup value, disarm first!)
setpvonline([Prefix,':wfr:ADC:arm'], 1);
setpvonline([Prefix,':wfr:TBT:arm'], 1);
setpvonline([Prefix,':wfr:FA:arm'],  1);
pause(1.1);

% Trigger (will be MRF in the future)
setpvonline([Prefix,':wfr:softTrigger'], 1);
pause(.1);

ArmADC = getpvonline([Prefix,':wfr:ADC:armed'], 'double');
ArmTBT = getpvonline([Prefix,':wfr:TBT:armed'], 'double');
ArmFA  = getpvonline([Prefix,':wfr:FA:armed' ], 'double');

% Wait on armed PV
while any([ArmADC ArmTBT ArmFA])
    pause(.1);
    ArmADC = getpvonline([Prefix,':wfr:ADC:armed'], 'double');
    ArmTBT = getpvonline([Prefix,':wfr:TBT:armed'], 'double');
    ArmFA  = getpvonline([Prefix,':wfr:FA:armed' ], 'double');
end

% Wait on the waveform time stamp
i = 0;
fprintf('   ADC %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(ADC.Ts(1),31), datestr(ADC.Ts(2),31), datestr(ADC.Ts(3),31), datestr(ADC.Ts(4),31), datestr(now,31));
ADC0 = ADC;
fprintf('   TBT %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(TBT.Ts(1),31), datestr(TBT.Ts(2),31), datestr(TBT.Ts(3),31), datestr(TBT.Ts(4),31), datestr(now,31));
TBT0 = TBT;
fprintf('   FA  %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n\n', i, datestr(FA.Ts(1),31), datestr(FA.Ts(2),31), datestr(FA.Ts(3),31), datestr(FA.Ts(4),31), datestr(now,31));
FA0 = FA;

for i = 1:8
    [ADC.cha, t, TsA] = getpvonline([Prefix,':wfr:ADC:A'], 'waveform', 1);
    [ADC.chb, t, TsB] = getpvonline([Prefix,':wfr:ADC:B'], 'waveform', 1);
    [ADC.chc, t, TsC] = getpvonline([Prefix,':wfr:ADC:C'], 'waveform', 1);
    [ADC.chd, t, TsD] = getpvonline([Prefix,':wfr:ADC:D'], 'waveform', 1);
    ADC.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);
    fprintf('   ADC %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(ADC.Ts(1),31), datestr(ADC.Ts(2),31), datestr(ADC.Ts(3),31), datestr(ADC.Ts(4),31), datestr(now,31));
    
    [TBT.cha, t, TsA] = getpvonline([Prefix,':wfr:TBT:c3'], 'waveform', 1);
    [TBT.chb, t, TsB] = getpvonline([Prefix,':wfr:TBT:c1'], 'waveform', 1);
    [TBT.chc, t, TsC] = getpvonline([Prefix,':wfr:TBT:c2'], 'waveform', 1);
    [TBT.chd, t, TsD] = getpvonline([Prefix,':wfr:TBT:c0'], 'waveform', 1);
    TBT.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);
    fprintf('   TBT %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(TBT.Ts(1),31), datestr(TBT.Ts(2),31), datestr(TBT.Ts(3),31), datestr(TBT.Ts(4),31), datestr(now,31));
    
    [FA.cha, t, TsA] = getpvonline([Prefix,':wfr:FA:c3'], 'waveform', 1);
    [FA.chb, t, TsB] = getpvonline([Prefix,':wfr:FA:c1'], 'waveform', 1);
    [FA.chc, t, TsC] = getpvonline([Prefix,':wfr:FA:c2'], 'waveform', 1);
    [FA.chd, t, TsD] = getpvonline([Prefix,':wfr:FA:c0'], 'waveform', 1);
    FA.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);
    fprintf('   FA  %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n\n', i, datestr(FA.Ts(1),31), datestr(FA.Ts(2),31), datestr(FA.Ts(3),31), datestr(FA.Ts(4),31), datestr(now,31));
    
    % Bug -> sometimes the timestamp changes earilier
   %if all(ADC.Ts > ADC0.Ts + .05/24/3600) && all(TBT.Ts > TBT0.Ts + .1/24/3600) && all(FA.Ts > FA0.Ts + .1/24/3600)
    if all(abs(ADC.Ts - ADC0.Ts) > .05/24/3600) && all(abs(TBT.Ts - TBT0.Ts) > .1/24/3600) && all(abs(FA.Ts - FA0.Ts) > .1/24/3600)
        break
    end
    pause(.1);
end

if i == 8
 %   error('Error waiting for waveform buffers to change time.');
end

% Extra delay
pause(.2);


