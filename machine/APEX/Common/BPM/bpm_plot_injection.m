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


% Extraction pre-trigger
for i = 1:length(Prefix)
    % Trigger mask
    setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('10'));
    setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('10'));
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('10'));
    
    % Event triggers
    setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('00010000'));
    setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
end

% Smaller ADC buffers
setpvonline([Prefix{i},':wfr:ADC:acqCount'], 3080+40*10000);
setpvonline([Prefix{i},':wfr:TBT:acqCount'], 40+10000);
setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 40);
pause(.2);


for i = 1:length(Prefix)
    ENV{i,1} = bpm_getenv(Prefix{i});
end



%% Run

BCM = getbcm('Struct');

for j = 1:10
    
    for i = 1:length(Prefix)
        % Arm
        %setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
        setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
        % setpvonline([Prefix{i},':wfr:FA:arm'],  1);
    end
    
    % Wait for trigger
    % :wfr:ADC:armed
    pause(3);
    
    
    for i = 1:length(Prefix)
        %ADC{i,j} = bpm_getadc(Prefix{i});
        TBT{i,j} = bpm_gettbt(Prefix{i});
    end
    
end


%% Plot


for i = 1:length(Prefix)
    fprintf('%s  %s\n', Prefix{i}, TBT{i,j}.TsStr(1,:));
end



%%

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

    if jmin-41 > 0
        jgoal = jmin-41;
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
    %pause;
    
    Delay0_Setpoint(i,1) = Delay0(jgoal);
end















