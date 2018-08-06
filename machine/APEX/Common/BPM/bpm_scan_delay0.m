%  This program finds the BPM delay 0 using the pseudo single bunch kicker set to every other turn
%
%
%
%


%% Setup 
clear

Prefix = getfamilydata('BPM','BaseName');

for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(.5);


% Event 122 -> ~1 Hz
NTurns = 1000;
for i = 1:length(Prefix)
    % Trigger mask
    setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('80'));
    setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('80'));
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('80'));
    
    % Event triggers
    setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('10000000'));
    
    % Small ADC buffers
    setpvonline([Prefix{i},':wfr:ADC:acqCount'], 3080+40*77);
    setpvonline([Prefix{i},':wfr:TBT:acqCount'], 40+NTurns);
    setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 40);
end

pause(.2);


for i = 1:length(Prefix)
    ENV{i,1} = bpm_getenv(Prefix{i});
end



%% Run

BCM = getbcm('Struct');

Delay0 = 1:82;

for j = 1:length(Delay0)
    for i = 1:length(Prefix)
        % Arm
        setpvonline([Prefix{i},':EVR:delay0'], Delay0(j));
    end
    pause(1);
    Delay0(j)
    
    for i = 1:length(Prefix)
        % Arm
        setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
        setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
        % setpvonline([Prefix{i},':wfr:FA:arm'],  1);
    end
    
    % Wait for trigger
    % :wfr:ADC:armed
    pause(2);
    
    for i = 1:length(Prefix)
        ADC{i,j} = bpm_getadc(Prefix{i});
        TBT{i,j} = bpm_gettbt(Prefix{i});
    end
end

save Scan_Delay0_Set2




%% Plot

for i = 1:length(Prefix)
    for j = 1:length(Delay0)
        ystd(i,j) = std(TBT{i,j}.Y);
    end
end

figure(1);
clf reset

for i = 1:length(Prefix)
    subplot(4,1,1);
    plot(Delay0, 1000*ystd(i,:));
    title(Prefix{i});
    ylabel('RMS [um]');
    xlabel('Delay0 [8 ns per step]');
        
    subplot(4,1,2);
    [a,jmin] = min(1000*ystd(i,:));
    plot(TBT{i,jmin}.Y(1:15));
    title(sprintf('%s  min at %d', Prefix{i}, jmin));
    
    subplot(4,1,3);
    [a, jmax] = max(1000*ystd(i,:));
    plot(TBT{i,jmax}.Y(1:15));
    title(sprintf('%s  max at %d', Prefix{i}, jmax));

    % 41 is half the range but the min is to the left of the max 
    %if jmin-41 > 0
    %    % Best case
    %    jgoal = jmin-41;
     if jmin-30 > 0
        jgoal = jmin-30;
    elseif jmin+41 <= 82
        jgoal = jmin+41;
    else
        error('Can''t happen.');
    end
    subplot(4,1,4);
    plot(TBT{i,jgoal}.Y(1:15));
    title(sprintf('%s  jgoal at index %d  Delay0 = %d', Prefix{i}, jgoal, Delay0(jgoal)));
    
 %   setpvonline([Prefix{i},':EVR:delay0'], Delay0(jgoal));
    
    i
    pause;
    
    Delay0_Setpoint(i,1) = Delay0(jgoal);
end















