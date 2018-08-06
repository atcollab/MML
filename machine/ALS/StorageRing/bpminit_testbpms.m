function bpminit_testbpms(RFAttn, varargin)
%BPMINIT - This function initializes the new NSLS-II style BPMs

% [1 4] for NSLS-2 development
% [2 1] being used by TFB/LFB (basically perminently)
% [3 2] has a low channel D -> Fixed Oct 2014
% [4 1] has a low channel C -> Fixed Oct 2014, but the issue has returned
% [9 7] has a low channel B -> Fixed Oct 2014


if nargin < 1
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') % && (RFAttn < 11)
        % Two bunch mode has much higher peak signals for the same average current
        RFAttn = 0;
    else
        RFAttn = 13;
    end
end


Prefix = getfamilydata('BPMTest','BaseName');
% Prefix{1} = 'SR01C:BPM1';
% Prefix{2} = 'SR01C:BPM3';
% Prefix{3} = 'SR01C:BPM4';
% Prefix{4} = 'SR01C:BPM5';


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
pause(.5);


% I-Q or RMS calculation
RMSFlag = 0;  % 1 -> RMS   0 -> I-Q
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':buttonDSP'], RMSFlag);
end


for i = 1:length(Prefix)
    if 0
        % Small buffers
        setpvonline([Prefix{i},':wfr:ADC:acqCount'], 77*(40+40));
        setpvonline([Prefix{i},':wfr:TBT:acqCount'],     40+40);
        setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 40);
    elseif 0
        % Medium buffers
        setpvonline([Prefix{i},':wfr:ADC:acqCount'], 77*(40+10000));
        setpvonline([Prefix{i},':wfr:TBT:acqCount'],     40+50000);
        setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 40);
    elseif 1
        % Large buffers
        setpvonline([Prefix{i},':wfr:ADC:acqCount'], 77*(40+1000000));
       %setpvonline([Prefix{i},':wfr:ADC:acqCount'], 77*(40+1000));
       %setpvonline([Prefix{i},':wfr:TBT:acqCount'],     40+40000);   %  100k is the max???
        setpvonline([Prefix{i},':wfr:TBT:acqCount'],     40+100000);   %  100k is the max???
        setpvonline([Prefix{i},':wfr:TBT:pretrigCount'], 1040);
    end
end


if 0  % Default
    % Software trigger and beam dump (should be the default from bpm_setenv)
    for i = 1:length(Prefix)
        % Trigger mask
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('03'));
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('03'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('03'));
        
        % Event triggers
        setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('10000000'));
        setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00010000'));
        
        % Bump threshold
        setpvonline([Prefix{i},':lossOfBeamThreshold'], 8000);
    end
elseif 0
    % Extraction pre-trigger & software
    for i = 1:length(Prefix)
        % Trigger mask
        %setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('20'));
        %setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('20'));
        %setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('20'));
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('01000001'));
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('01000001'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('01000001'));
        
        % Event triggers
        setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('10000000'));
        setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event15trig'],  bin2dec('00010000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
    end
elseif 0
    % Event 122 -> ~1 Hz
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
    end
end


% Test mode: add the orbit clock to the LSB of the ADD waveform
LSBChange = 0;   % 0->No Change   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
end

% setting delay0, even to the same value, will briefly cause the PLL to loose lock
%setdelay0_local;
pause(1);

% Clear the Sync latch
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':faultClear'], 1);
end

% Arm
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
    setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
    setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end


