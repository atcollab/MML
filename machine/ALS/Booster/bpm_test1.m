%% Init
%bpminit;


%% Info
clear
Prefix = getfamilydata('BPM','BaseName');
NBPM = length(Prefix);



%% Trigger and wait for a shot

setpv('BPM','ADC_Arm', 1);
setpv('BPM','TBT_Arm', 1);
setpv('BPM','FA_Arm',  1);

% Wait for trigger
TriggerAll = 1;
while TriggerAll == 1
    pause(.25);
    for i = 1:length(Prefix)
        armed(i,1) = getpvonline([Prefix{i},':wfr:ADC:armed'], 'double');
    end
    TriggerAll = any(armed);
end
pause(.5);


%% Get data
clear ADC ENV TBT FA
for i = 1:length(Prefix)
    Prefix{i}
    ADC{i} = bpm_getadc(Prefix{i});
    ENV{i} = bpm_getenv(Prefix{i});
    TBT{i} = bpm_gettbt(Prefix{i});
    FA{i}  = bpm_getfa(Prefix{i});
end
%save BR_Test1


%% plot data
for i = 1:length(Prefix)
    %i = 2;
    Prefix{i}
    ADC = bpm_getadc(Prefix{i});
    ENV = bpm_getenv(Prefix{i});
    TBT = bpm_gettbt(Prefix{i});
    FA  = bpm_getfa(Prefix{i});
%     
%     % Remove the no beam data
%     N = 50000;
%     ADC.A(1:N) = [];
%     ADC.B(1:N) = [];
%     ADC.C(1:N) = [];
%     ADC.D(1:N) = [];
%     ADC.N = ADC.N - N;

    % Plot
    bpm_adc2psd(ADC, ENV, 1);
    bpm_plottbt(TBT, 101);
    bpm_plotfa(FA, 201);
    
    drawnow;
    
    if i < length(Prefix)
        pause
    end
end


%% First turn should be 1202

% load BR_Test1
figure(2);
clf reset
%nn = 1195:1210;
nn = 1:1210;
for i = 1:length(Prefix)
    ii(i) = min(find(TBT{i}.S>1e5));
    plot(TBT{i}.S(nn));
    hold on 
end





