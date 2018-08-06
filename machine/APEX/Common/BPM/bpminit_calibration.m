function bpminit_calibration(Prefix, RFAttn, InjectionFlag)


%% Init for calibation
if nargin < 1
    Prefix = {'Test:BPM1'};    %getfamilydata('BPM','BaseName');
end
if nargin < 2
    RFAttn = 4;
end
if nargin < 3
    InjectionFlag = 1;
end

bpm_setenv(Prefix{1}, RFAttn, InjectionFlag);


for i = 1:length(Prefix)
    bpm_setenv(Prefix{i}, RFAttn, InjectionFlag);
    
    SoftwareVersion = getpvonline([Prefix{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix{i},':firmwareRev'], 'char');
    
    fprintf('   %s:  Software Ver %s  Firmare Ver %s\n', Prefix{i}, SoftwareVersion, FirmwareVersion);
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


if 1  % Default
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
elseif 1
    % Extraction pre-trigger
    for i = 1:length(Prefix)
        % Trigger mask
        %setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('20'));
        %setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('20'));
        %setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('20'));
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('01000000'));
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('01000000'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('01000000'));
        
        % Event triggers
        setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
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
% setdelay0_local;
% pause(1);

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
pause(1);

% Manually trigger
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:softTrigger'], 1);
end
pause(1);  

fprintf('   bpminit_calibration complete.\n');







