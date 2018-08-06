%function ADC = bpm_waterfall

Prefix = getfamilydata('BPM','BaseName');
NBPM = length(Prefix);


% Set Trigger Mask???

% Normalize the sum by calibration data???

figure(1);
clf reset
figure(2);
clf reset

xg = getgolden('BPM','X');
yg = getgolden('BPM','Y');

for j = 1:200  % Number of shots
    
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
        [TargetBucket(1,j), NumberGunBunches(1,j), Ts(1,j), TargetBucketPV] = gettargetbucket;
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
    
    x(:,j) = getpv('BPM', 'X') - xg;
    y(:,j) = getpv('BPM', 'Y') - yg;
    q(:,j) = getpv('BPM', 'Q');
    s(:,j) = getpv('BPM', 'S');

    figure(1);
    for i = 1:NBPM                
        ADC{i,j} = bpm_getadc(Prefix{i});
        
        subplot(NBPM, 1, i);
        plot([ADC{i,j}.A ADC{i,j}.B ADC{i,j}.C ADC{i,j}.D]);
        axis tight
        title(sprintf('%s  ADC,  Attn:%d,   %d Gun Bunches', Prefix{i}, getpvonline([Prefix{i},':attenuation'])));
    end    
    xlabel(sprintf('Sample Number (%.3f nsec/sample, %.1f MHz)', 1e9/ADC{1,j}.ADCfs/1e6, ADC{1,j}.ADCfs));
   % addlabel(1, 0, sprintf('%d Gun Bunches (%s)', NumberGunBunches(1,j), datestr(Ts(1,j),31)));
    
    if j > 3
        figure(2);
        subplot(3, 1, 1);
        surf(x);
        axis tight
        subplot(3, 1, 2);
        surf(y);
        axis tight
        subplot(3, 1, 3);
        surf(s);
        axis tight
    end
end
