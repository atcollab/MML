function bpm_setenv(Prefix, RFAttn, InjectionFlag)


% Info for SIOC
% #!/bin/csh
% module load libevent
% module load gsl
% cd /vxboot/siocbpm/head/iocBoot/iocbpmsr01c_008
% exec ./st.cmd

% If not locked:
%
% Terminal setup
% Baud 115200
% Parity None
% (Linux device something like /dev/tty50)
%
% NSLS-II Setup from the Console
% ad9510 0400
% ad9510 0500
% ad9510 064d
% ad9510 0877


% 10 20 40 80 use trigger delay ?

RFAttn500 = 13;

if nargin < 1 || isempty(Prefix)
    Prefix = 'SR01C:BPM4';
end
if nargin < 2  || isempty(RFAttn)
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') % && (RFAttn < 11)
        % Two bunch mode has much higher peak signals for the same average current
        RFAttn = 0;
    else
        % Needs work!!!
        if getdcct < .2
            RFAttn = RFAttn500;
        elseif getdcct < 5
            RFAttn = -11;   % 1-bunch
        elseif getdcct < 6
            RFAttn = -10;   % 1-bunch
        elseif getdcct < 10
            RFAttn = 3-11;   % 1-bunch
        elseif getdcct < 40
            %RFAttn = -5;    % Multibunch, cam
            RFAttn = -12;    % Multibunch, no cam
            % RFAttn = 1;    % 2-bunch
        elseif getdcct < 45
            %RFAttn = ;     % Multibunch, cam
            RFAttn = -12;   % Multibunch, no cam
            % RFAttn = ;    % 2-bunch
        elseif getdcct < 50
            RFAttn = 2-11;
        elseif getdcct < 70
            RFAttn = 3-11;
        elseif getdcct < 100
            RFAttn = 8-11;
        elseif getdcct < 150
            RFAttn = 4;
        elseif getdcct < 300
            RFAttn = 6;
        elseif getdcct < 350
            RFAttn = 8;
        elseif getdcct < 510
            RFAttn = RFAttn500;
        else
            RFAttn = RFAttn500;
        end
    end
end


if nargin < 3  || isempty(InjectionFlag)
    InjectionFlag = 0;
end

if ischar(Prefix)
    bpm_setenv1(Prefix, RFAttn, InjectionFlag)
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        bpm_setenv1(Prefix{i}, RFAttn, InjectionFlag)
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        bpm_setenv1(Prefix{i}, RFAttn, InjectionFlag)
    end
end



function bpm_setenv1(Prefix, RFAttn, InjectionFlag)

% Attenuation tweaks
if RFAttn ~= 0
    %if length(Prefix)>=10 && (strcmpi(Prefix, 'SR01C:BPM2') || strcmpi(Prefix, 'SR01C:BPM7') || strcmpi(Prefix, 'SR01C:BPM8') || strcmpi(Prefix, 'SR02C:BPM2') || strcmpi(Prefix, 'SR12C:BPM1') || strcmpi(Prefix, 'SR12C:BPM2') || strcmpi(Prefix, 'SR06C:BPM1') || strcmpi(Prefix, 'SR10C:BPM7') || strcmpi(Prefix, 'SR11C:BPM1') || strcmpi(Prefix, 'SR11C:BPM2') || strcmpi(Prefix, 'SR11C:BPM7') || strcmpi(Prefix, 'SR11C:BPM8') || strcmpi(Prefix, 'SR12C:BPM7'))
    %    % New AFE2 Rev4 (2 amplifiers)
    %    RFAttn = RFAttn - 11;  % 9 2bunch & 11 - multibunch 
    %    %fprintf('        Decreasing %s attenuation by 6 (%d)\n', Prefix, RFAttn);
    %end
    %if length(Prefix)>=10 && (strcmpi(Prefix, 'SR02C:BPM7') || strcmpi(Prefix, 'SR03C:BPM2') || strcmpi(Prefix, 'SR03C:BPM7') || strcmpi(Prefix, 'SR03C:BPM8') || strcmpi(Prefix, 'SR04C:BPM1') || strcmpi(Prefix, 'SR04C:BPM2') || strcmpi(Prefix, 'SR04C:BPM7') || strcmpi(Prefix, 'SR04C:BPM8') || strcmpi(Prefix, 'SR05C:BPM1') || strcmpi(Prefix, 'SR05C:BPM2') || strcmpi(Prefix, 'SR05C:BPM7') || strcmpi(Prefix, 'SR07C:BPM1') || strcmpi(Prefix, 'SR07C:BPM2') || strcmpi(Prefix, 'SR07C:BPM7'))
    %    % New AFE2 Rev4 (2 amplifiers)
    %    RFAttn = RFAttn - 11;  % 9 2bunch & 11 - multibunch 
    %    %fprintf('        Decreasing %s attenuation by 6 (%d)\n', Prefix, RFAttn);
    %end
    
    if length(Prefix)>=5 && (strcmpi(Prefix(1:2), 'SR'))
        RFAttn = RFAttn - 0;
    end
    
    if length(Prefix)>=10 && (strcmpi(Prefix, 'BTS:BPM6'))
        % Modified 2 amplifiers (all modified BPMs will eventually go into the injector)
            RFAttn = RFAttn - 6;
        %fprintf('        Decreasing %s attenuation by 6 (%d)\n', Prefix, RFAttn);
    end
    if length(Prefix)>=10 && (strcmpi(Prefix, 'SR01C:BPM4') || strcmpi(Prefix, 'SR01C:BPM5'))
        % Splitter - Combiner for noise measurement
        %RFAttn = RFAttn - 4;
    end
    %if length(Prefix)>=10 && (strcmpi(Prefix(10), '1') || strcmpi(Prefix(10), '2') || strcmpi(Prefix(10), '7') || strcmpi(Prefix(10), '8') || strcmpi(Prefix, 'SR01C:BPM4') || strcmpi(Prefix, 'SR01C:BPM5') || strcmpi(Prefix, 'SR01C:BPM6'))
    %    % 3 dB pad + Combiner in the tunnel (instead of 6 dB pad)
    %    RFAttn = RFAttn + 3;
    %    %fprintf('        Increasing %s attenuation by 2 (%d)\n', Prefix, RFAttn);
    %end
end
RFAttn = round(RFAttn);
if RFAttn < 0
    RFAttn = 0;
elseif RFAttn > 31
    RFAttn = 31;
end
if ~isempty(RFAttn)
    setpvonline([Prefix,':attenuation'], RFAttn);
end

% bpmTest:004:lossOfBeamThreshold
% bpmTest:004:autotrim:enable
% bpmTest:004:autotrim:status
% bpmTest:004:autotrim:threshold
% setpvonline([Prefix,':pilotToneSelect'], 0);  % 0->low 1->high

setpvonline([Prefix,':autotrim:threshold'], 1e6);

setpvonline([Prefix,':adcGain'], 0);          % 0->1 1->1.5

% Gain Trim???
setpvonline([Prefix,':ADC0:gainTrim'], 1); 
setpvonline([Prefix,':ADC1:gainTrim'], 1); 
setpvonline([Prefix,':ADC2:gainTrim'], 1); 
setpvonline([Prefix,':ADC3:gainTrim'], 1); 

% Disarm
setpvonline([Prefix,':wfr:ADC:arm'], 0);
setpvonline([Prefix,':wfr:TBT:arm'], 0);
setpvonline([Prefix,':wfr:FA:arm'],  0);
pause(.01);

% Waveform length
% 77*12988 = 1000076
setpvonline([Prefix,':wfr:ADC:acqCount'], 1000076);  % ADC max 1,048,576
setpvonline([Prefix,':wfr:TBT:acqCount'],  100000);  % ADC max 100,000?
setpvonline([Prefix,':wfr:FA:acqCount'],    50000);  % ADC max 10,000

setpvonline([Prefix,':wfr:ADC:pretrigCount'], 3080);  % Not changeable
setpvonline([Prefix,':wfr:TBT:pretrigCount'], 10000);
setpvonline([Prefix,':wfr:FA:pretrigCount'],  10000);

setpvonline([Prefix,':lossOfBeamThreshold'], 4000);   % 5000 had some false triggers

%setpvonline([Prefix,':EVR:delay0'], 1);

setpvonline([Prefix,':EVR:delay4'], 1);
setpvonline([Prefix,':EVR:delay5'], 1);
setpvonline([Prefix,':EVR:delay6'], 1);
setpvonline([Prefix,':EVR:delay7'], 1);

% Default trigger mask
setpvonline([Prefix,':wfr:ADC:triggerMask'], hex2dec('3'));
setpvonline([Prefix,':wfr:TBT:triggerMask'], hex2dec('3'));
setpvonline([Prefix,':wfr:FA:triggerMask'],  hex2dec('3'));


% Event triggers
setpvonline([Prefix,':EVR:event11trig'],  bin2dec('10000000'));
setpvonline([Prefix,':EVR:event12trig'],  bin2dec('01000000'));
setpvonline([Prefix,':EVR:event13trig'],  bin2dec('00100000'));
setpvonline([Prefix,':EVR:event122trig'], bin2dec('00010000'));


% Arm
setpvonline([Prefix,':wfr:ADC:arm'], 1);
setpvonline([Prefix,':wfr:TBT:arm'], 1);
setpvonline([Prefix,':wfr:FA:arm'],  1);


%fprintf('   Setup for %s complete.\n',Prefix);
%setpvonline([Prefix,':softwareRev.PROC'], 1);
%setpvonline([Prefix,':firmwareRev.PROC'], 1);


