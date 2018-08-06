
%% One time init
bpminit


%% 

% Unarm
setpv('BPM','ADC_Arm', 0);
setpv('BPM','TBT_Arm', 0);
setpv('BPM','FA_Arm',  0);
pause(.5);


% Single pass or Soft
if 1
    % Single pass (self) or soft triggered
    setpv('BPM','ADC_TriggerMask',  bin2dec('00000101'));
    setpv('BPM','TBT_TriggerMask',  bin2dec('00000101'));
    setpv('BPM','FA_TriggerMask',   bin2dec('00000101'));
    
    setpv('BPM','EVR_Inj_Mask',     bin2dec('00000000'));
    setpv('BPM','EVR_PreExt_Mask',  bin2dec('00000000'));
    setpv('BPM','EVR_PostExt_Mask', bin2dec('00000000'));
    setpv('BPM','EVR_BPM_Mask',     bin2dec('00000000'));
    setpv('BPM','EVR_HB_Mask',      bin2dec('00000000'));
    
elseif 1

    % Injection pre-trigger
    setpv('BPM','ADC_TriggerMask',  bin2dec('00010000'));
    setpv('BPM','TBT_TriggerMask',  bin2dec('00010000'));
    setpv('BPM','FA_TriggerMask',   bin2dec('00010000'));
    
    setpv('BPM','EVR_Inj_Mask',     bin2dec('00010000'));
    setpv('BPM','EVR_PreExt_Mask',  bin2dec('00000000'));
    setpv('BPM','EVR_PostExt_Mask', bin2dec('00000000'));
    setpv('BPM','EVR_BPM_Mask',     bin2dec('00000000'));
    setpv('BPM','EVR_HB_Mask',      bin2dec('00000000'));
    
else
    % Extraction pre-trigger
    setpv('BPM','ADC_TriggerMask',  bin2dec('00010000'));
    setpv('BPM','TBT_TriggerMask',  bin2dec('00010000'));
    setpv('BPM','FA_TriggerMask',   bin2dec('00010000'));
    
    setpv('BPM','EVR_Inj_Mask',     bin2dec('00000000'));
    setpv('BPM','EVR_PreExt_Mask',  bin2dec('00010000'));
    setpv('BPM','EVR_PostExt_Mask', bin2dec('00000000'));
    setpv('BPM','EVR_BPM_Mask',     bin2dec('00000000'));
    setpv('BPM','EVR_HB_Mask',      bin2dec('00000000'));
end

% Smaller ADC buffers
%setpvonline([Prefix{i},':wfr:ADC:acqCount'], 3080+40*10000);
%setpvonline([Prefix{i},':wfr:TBT:acqCount'], 40+10000);
%setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 40);
%pause(.2);


%for i = 1:length(Prefix)
%    ENV{i,1} = bpm_getenv(Prefix{i});
%end

% Arm
setpv('BPM','ADC_Arm', 1);
setpv('BPM','TBT_Arm', 1);



%% Get & Plot

Prefix = getfamilydata('BPM','BaseName');

% setpv('BPM','ADC_Arm', 1);
% setpv('BPM','TBT_Arm', 0);
% setpv('BPM','FA_Arm',  0);


% Wait for trigger
% :wfr:ADC:armed
%pause(3);

% ADC_A = getpv('BPM','ADC_A');
% ADC_B = getpv('BPM','ADC_B');
% ADC_C = getpv('BPM','ADC_C');
% ADC_D = getpv('BPM','ADC_D');

for i = 1:length(Prefix)
    ADC{i,1} = bpm_getadc(Prefix{i});
    %TBT{i,1} = bpm_gettbt(Prefix{i});
end

figure(1);
clf reset
for i = 1:length(Prefix)
    subplot(length(Prefix),1,i);
    plot([ADC{i}.A ADC{i}.B ADC{i}.C ADC{i}.D]);
    title(sprintf('%s  %s (%d ns)',Prefix{i}, datestr(ADC{i}.Ts(1), 'yyyy-mm-dd HH:MM:SS.FFF'), imag(ADC{i}.TsA(1))));
    ylabel('RMS [um]');
end




return


%ADC.Ts = linktime2datenum([ADC.TsA; ADC.TsB; ADC.TsC; ADC.TsD]);




%% Run

BCM = getbcm('Struct');

for j = 1:10
    setpv('BPM','ADC_Arm', 1);
    setpv('BPM','TBT_Arm', 0);
    setpv('BPM','FA_Arm',  0);

    
    % Wait for trigger
    % :wfr:ADC:armed
    pause(3);
    
    
    for i = 1:length(Prefix)
        ADC{i,j} = bpm_getadc(Prefix{i});
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















