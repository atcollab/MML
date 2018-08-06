%function ADC = bpm_adc_plot1

Prefix = getfamilydata('BPM','BaseName');
NBPM = length(Prefix);


% Set Trigger Mask???


% Arm
pause(1);
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    %setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    %setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end


% Wait on armed PV
ArmADC = 1; ArmTBT = 1; ArmFA = 1;
while any([ArmADC ArmTBT ArmFA])
    [TargetBucket, NumberGunBunches, Ts, TargetBucketPV] = gettargetbucket;
    pause(.25);
    ArmADC = 1;
    for i = 1:NBPM
        ArmADC(1,i) = getpvonline([Prefix{i},':wfr:ADC:armed'], 'double');
    end
    ArmTBT = 0; %getpvonline([Prefix,':wfr:TBT:armed'], 'double');
    ArmFA  = 0; %getpvonline([Prefix,':wfr:FA:armed' ], 'double');
    fprintf('   Waiting for trigger.  SR DCCT = %.1f\n', getpvonline('cmm:beam_current'));
end

pause(.25);


figure;
clf reset
for i = 1:NBPM
    ADC{i,1} = bpm_getadc(Prefix{i});
    
    subplot(NBPM, 1, i);
    plot([ADC{i}.A ADC{i}.B ADC{i}.C ADC{i}.D]);
    axis tight
    title(sprintf('%s  ADC,  Attn:%d,   %d Gun Bunches', Prefix{i}, getpvonline([Prefix{i},':attenuation']),NumberGunBunches));
end
xaxiss([3060 3165]);
xlabel(sprintf('Sample Number (%.3f nsec/sample, %.1f MHz)', 1e9/ADC{1}.ADCfs/1e6, ADC{1}.ADCfs));
addlabel(1, 0, sprintf('%d Gun Bunches (%s)', NumberGunBunches, datestr(Ts,31)));
