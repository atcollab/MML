function bpminit(RFAttn, varargin)
%BPMINIT - This function initializes the new BPMs

if nargin < 1
    RFAttn = 3;
end

Prefix = getfamilydata('BPM','BaseName');

for i = 1:length(Prefix)
    bpm_setenv(Prefix{i}, RFAttn);
    
    SoftwareVersion = getpvonline([Prefix{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix{i},':firmwareRev'], 'char');
    
    fprintf('  %3d.  Setup for %s complete.  Software Ver %s  Firmare Ver %s\n', i, Prefix{i}, SoftwareVersion, FirmwareVersion);
end

% Set delay0 (even to the same value will briefly cause the PLL to loose lock)
% Measured: 2017-04-28, 2017-12-02
% Set the TBT pretrigger to make turn 1202 the first turn  (29*1202=34858 for ADC data, actually 34702 about 5 turns earlier)
% Note: 29 ADC samples / turn
Delay0 = [
     1     1     2    30    0
     2     1     3    30-3  1
     3     1     4    27    1
     4     1     6    28    1
     5     1     8    29    1
     6     2     2    26-8  2
     7     2     3    30-9  2
     8     2     4    20    2
     9     2     6    20+3  2
    10     2     8    25+1  1
    11     3     2    26+2  0
    12     3     3    30-5  0
    13     3     4    28-2  0
    14     3     6    26    0
    15     3     8    27    0
    16     4     2    27    0
    17     4     3    30-3  0
    18     4     4    28    0
    19     4     6    27    0
    20     4     8    29    0
    ];

for i = 1:length(Prefix)
    BaseName = getfamilydata('BPM','BaseName', Delay0(i,2:3));
    fprintf('   %2d.  BPM(%d,%d)   %s  Delay0 = %g\n', i, Delay0(i,2:3), BaseName{1}, Delay0(i,4));
    setpvonline([Prefix{i},':EVR:delay0'], Delay0(i,4));
end

for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(.5);


% I-Q or RMS calculation
RMSFlag = 0;  % 1 -> RMS   0 -> I-Q
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':buttonDSP'], RMSFlag);
end

% Attenuation
%Attn = getpv('BPM','Attn');
Attn = RFAttn * ones(length(Prefix),1);

setpv('BPM', 'Attn', Attn);
for i = 1:length(Prefix)
        setpvonline([Prefix{i},':attenuation'], Attn(i));    
%     BTS:BPM2:EVR:delay1
%     BTS:BPM2:selfTrigger:level
%     BTS:BPM2:wfr:ADC:DataMode
%     BTS:BPM2:attenuation
%     BTS:BPM2:autotrim:threshold
%     BTS:BPM2:autotrim:filterShift
end


% Waveform recorder setup
% Trigger: software and single pass
for i = 1:length(Prefix)
    % Large buffers
    setpvonline([Prefix{i},':wfr:ADC:pretrigCount'], 29*Delay0(i,5));
    setpvonline([Prefix{i},':wfr:ADC:acqCount'],  77*(40+1000000));
    
    setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], Delay0(i,5));  % 1040
    setpvonline([Prefix{i},':wfr:TBT:acqCount'],  2097152);   %   maximum value (2^21 = 2097152) 
    
    setpvonline([Prefix{i},':wfr:FA:pretrigCount'], 500);
    setpvonline([Prefix{i},':wfr:FA:acqCount'],    6000);
    
    % Trigger mask
    setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('10000001'));  %hex2dec('05'));
    setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('10000001'));  %hex2dec('05'));
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('10000001'));  %hex2dec('05'));
    
    % Event triggers
    setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('10000000'));
    setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('01000000'));
    setpvonline([Prefix{i},':EVR:event68trig'],  bin2dec('00100000'));
    setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00010000'));
        
    % Event delay
    %setpvonline([Prefix{i},':EVR:delay4'], 1000);

    % Bump threshold
    % setpvonline([Prefix{i},':lossOfBeamThreshold'], 8000);
end


% Test mode: add the orbit clock to the LSB of the ADC waveform
LSBChange = 0;   % 0->No Change   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
end


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

