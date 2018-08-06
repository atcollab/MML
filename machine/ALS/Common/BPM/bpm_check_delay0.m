%% ADC

Prefix = getfamilydata('BPM','BaseName');
%Prefix = {'SR01C:BPM2'};
%Prefix = Prefix(5);


% Test mode: add the orbit clock to the LSB of the ADC waveform
LSBChange = 1;   % 0->No Change   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
    
    % Max ADC pretrigger is 3080
    setpvonline([Prefix{i},':wfr:ADC:pretrigCount'], 3080);
end
pause(1);

if 1
    for i = 1:length(Prefix)
        if isstoragering
            % Trigger setup:  Event 122 -> ~1 Hz
            % Trigger mask
            setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('80'));
            setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('80'));
            setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('80'));
            
            % Event triggers
            %setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('00000000'));
            %setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('00000000'));
            %setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('00000000'));
            %setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00000000'));
            %setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('10000000'));
            
        else
            % Trigger setup:  Self-trigger
            % Trigger mask
            %setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('00000101'));
            %setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('00000101'));
            %setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('00000101'));
            
            % Event triggers
            %setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('10000000'));
            %setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('01000000'));
            %setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('00100000'));
            %setpvonline([Prefix{i},':EVR:event66trig'],  bin2dec('00000000'));
            %setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00010000'));
            %setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
        end
    end
end
pause(1.5);

% Arm
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    %setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    %asetpvonline([Prefix{i},':wfr:FA:arm'],  1);
end
pause(.5);

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



%% Plot

clear Delay0Offset
for i = 1:length(Prefix)
    ENV = bpm_getenv(Prefix{i});
    ADC = bpm_getadc(Prefix{i});
    
    % Remove the no beam data
    N = 50000;
    ADC.A(1:N) = [];
    ADC.B(1:N) = [];
    ADC.C(1:N) = [];
    ADC.D(1:N) = [];
    ADC.N = ADC.N - N;
    
    [PSD, Setup] = bpm_adc2psd(ADC, ENV, 201);
    Delay0Offset(i,1) = Setup.Delay0Offset;
    drawnow;
    
    if i < length(Prefix)
        pause
    end
end


%% Reset test mode
LSBChange = 0;   % 0->No Chanbge   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
end


return




%% TBT

FigNum = 201;
Prefix = getfamilydata('BPM','BaseName');
for i = 1:length(Prefix)
    TBT = bpm_gettbt(Prefix{i}, [], FigNum);
    figure(202)
    axis(1.0e+05 * [ 0.2652    0.2658   -2.9976    3.4984]);
    pause;
end



%%

clear
n = 26440:26829;
Prefix = getfamilydata('BPM','BaseName');
for i = 1:length(Prefix)
    TBT{i} = bpm_gettbt(Prefix{i}, [], 0);
    TBT{i}.A = TBT{i}.A(n);
    TBT{i}.B = TBT{i}.B(n);
    TBT{i}.C = TBT{i}.C(n);
    TBT{i}.D = TBT{i}.D(n);
    TBT{i}.X = TBT{i}.X(n);
    TBT{i}.Y = TBT{i}.Y(n);
    TBT{i}.Q = TBT{i}.Q(n);
    TBT{i}.S = TBT{i}.S(n);
end

save TBT_2015-02-06_Set1


%%

clear
load TBT_2015-02-06_Set1


Delay0 = [
    1     9
    2    10
    3    11
    4    10
    5    12
    6    27
    7    29
    8    29
    9    45
    10    45
    11    47
    12    48
    13    41
    14    41
    15    43
    16    44
    17    46
    18    47
    19    49
    20    49
    21    35
    22    34
    23    36
    24    36
    25    51
    26    51
    27    52
    28    54
    29    68
    30    66
    31    70
    32    71
    33    75
    34    74
    35    77
    36    77
    37    18
    38    18
    39    19
    40    19
    41    14
    42    15
    43    17
    ];


FigNum = 201;

figure(FigNum);
clf reset

figure(FigNum+1);
clf reset

figure(FigNum+2);
clf reset

n = 5:200;
for i = 1:length(Prefix)
    figure(FigNum);
    c = nxtcolor;
    plot(TBT{i}.S(n) - TBT{i}.S(n(1)), 'Color', c);
    hold on
    
    figure(FigNum+1);
    c = nxtcolor;
    plot(TBT{1}.S(n) - TBT{1}.S(n(1)), 'r');
    hold on;
    %plot(TBT{31}.S(n) - TBT{31}.S(n(1)), 'g');
    plot(TBT{i}.S(n) - TBT{i}.S(n(1)), 'b');
    hold off;
    xaxis([35 80]);
    title(sprintf('%d.  %s   %d', i, Prefix{i}, Delay0(i,2)));
    
    figure(FigNum+2);
    c = nxtcolor;
    plot(TBT{1}.X(n) - TBT{1}.X(n(1)), 'r');
    hold on;
    %plot(TBT{31}.X(n) - TBT{31}.X(n(1)), 'g');
    plot(TBT{i}.X(n) - TBT{i}.X(n(1)), 'b');
    hold off;
    xaxis([35 80]);
    title(sprintf('%d.  %s   %d', i, Prefix{i}, Delay0(i,2)));

    pause;
end



