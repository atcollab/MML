function bpminit(RFAttn, varargin)
%BPMINIT - This function initializes the new BPMs

if nargin < 1
    RFAttn = 0;
end

Prefix = getfamilydata('BPM','BaseName');

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
Attn = 0 * ones(length(Prefix),1);

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
    setpvonline([Prefix{i},':wfr:ADC:pretrigCount'], 50);
    setpvonline([Prefix{i},':wfr:ADC:acqCount'],    150);
    setpvonline([Prefix{i},':wfr:TBT:pretrigCount'],  0);
    setpvonline([Prefix{i},':wfr:TBT:acqCount'],   1000);
    setpvonline([Prefix{i},':wfr:FA:pretrigCount'],   0);
    setpvonline([Prefix{i},':wfr:FA:acqCount'],     100);

    % Trigger mask
    setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('05'));
    setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('05'));
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('05'));
    
    % Event triggers
    setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
    setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
    
    % Bump threshold
    % setpvonline([Prefix{i},':lossOfBeamThreshold'], 8000);
    
    % Self trigger level
    setpvonline([Prefix{i},':selfTrigger:level'], 200);
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

