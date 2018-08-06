function bpminit(RFAttn, varargin)
%BPMINIT - This function initializes the new BPMs

NewTimingSystemFlag = 1;

if nargin < 1
    RFAttn = 10;
end

Prefix = getfamilydata('BPM','BaseName');

try
    fprintf('   Setting GTB BPM offsets.\n');
    
    Offset = -1 * [
        4.7723   -1.7139
        -2.8160    2.2563
        -1.1175    0.8222
        -1.0830    0.3725
        1.0310    3.3586
        1.9303    1.4741
        -0.4897    1.5242
        2.6766    2.4623
        1.2129    1.9443
        0.7223   -1.7867
        ];
    
    xn = family2channel('BPMx');
    yn = family2channel('BPMy');
    
    for i = 1:length(xn)
        setpv(xn{i}, 'EOFF', Offset(i,1));
        setpv(yn{i}, 'EOFF', Offset(i,2));
    end
catch
    fprintf(2, '   Error setting BPM attenuation.\n');
end


% Factory defaults
for i = 1:length(Prefix)
    bpm_setenv(Prefix{i}, RFAttn);
    
    SoftwareVersion = getpvonline([Prefix{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix{i},':firmwareRev'], 'char');
    
    fprintf('  %3d.  Setup for %s complete.  Software Ver %s  Firmare Ver %s\n', i, Prefix{i}, SoftwareVersion, FirmwareVersion);
end


for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(2.5);


% I-Q or RMS calculation
RMSFlag = 1;  % 1 -> RMS   0 -> I-Q
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':buttonDSP'], RMSFlag);
end

% Attenuation
%Attn1 = 21 - 12;
%Attn = [Attn1+6 Attn1 Attn1 Attn1-9 Attn1 Attn1-12];
%Attn = getpv('BPM','Attn');
Attn = RFAttn * ones(length(Prefix),1);
Attn(1) =  0;
Attn(2) =  5;
Attn(3) = 10;
Attn(4) = 27;
Attn([5 6 7 8 9 10]) = [30 27 27 26 26 27];

setpv('BPM', 'Attn', Attn);
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':attenuation'], Attn(i));
    %     BTS:BPM2:EVR:delay1
    %     BTS:BPM2:selfTrigger:level
    %     BTS:BPM2:wfr:ADC:DataMode
    %     BTS:BPM2:attenuation
    %     BTS:BPM2:autotrim:threshold
    
    % 2^filterShift number of samples to average over for the gain calculation
    %setpvonline([Prefix{i},':autotrim:filterShift'], 0);
end


% Waveform recorder setup
% Trigger: software and single pass
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:pretrigCount'], 12);
    setpvonline([Prefix{i},':wfr:ADC:acqCount'],    100);
    setpvonline([Prefix{i},':wfr:TBT:pretrigCount'],  0);
    setpvonline([Prefix{i},':wfr:TBT:acqCount'],    1000);
    setpvonline([Prefix{i},':wfr:FA:pretrigCount'],   0);
    setpvonline([Prefix{i},':wfr:FA:acqCount'],    100);

    % Trigger mask
    setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('10000001'));  %hex2dec('05'));
    setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('10000001'));  %hex2dec('05'));
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('10000001'));  %hex2dec('05'));
        
    % Event triggers
    if NewTimingSystemFlag
        % New timing system
        setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('10000000'));
        setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event68trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00010000'));
    else
        % Old timing system
        setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('10000000'));
        setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00010000'));
    end

    % Bump threshold
    % setpvonline([Prefix{i},':lossOfBeamThreshold'], 8000);
end


% Test mode: add the orbit clock to the LSB of the ADD waveform
LSBChange = 0;   % 0->No Change   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
end

% setting delay0, even to the same value, will briefly cause the PLL to loose lock
%setdelay0_local;
%pause(1);

% Clear the Sync latch
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':faultClear'], 1);
end

% Arm
pause(1);
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end



% Manually trigger
% for i = 1:length(Prefix)
%     setpvonline([Prefix{i},':wfr:softTrigger'], 1);
% end
% pause(6);

