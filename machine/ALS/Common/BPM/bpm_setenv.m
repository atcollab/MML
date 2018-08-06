function bpm_setenv(Prefix, RFAttn, InjectionFlag, AttnOnlyFlag)


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

RFAttn500 = 14;

if nargin < 1 || isempty(Prefix)
    Prefix = 'SR01C:BPM4';
end
if nargin < 2  || isempty(RFAttn)
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') % && (RFAttn < 11)
        % Two bunch mode has much higher peak signals for the same average current
        RFAttn = 4;
    else
        % Needs work!!!
        if getdcct < .95
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
        elseif getdcct < 190
            RFAttn = 5;
        elseif getdcct < 300
            %RFAttn = 6;          % Just so operators doing orbit correction at 200 and never again doesn't cause saturation at 500mA 
            RFAttn = RFAttn500;
        elseif getdcct < 350
            %RFAttn = 8;          % Just so operators doing orbit correction at 200 and never again doesn't cause saturation at 500mA 
            RFAttn = RFAttn500;
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

if nargin < 4  || isempty(AttnOnlyFlag)
    AttnOnlyFlag = 0;
end

if ischar(Prefix)
    bpm_setenv1(Prefix, RFAttn, InjectionFlag, AttnOnlyFlag)
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        bpm_setenv1(Prefix{i}, RFAttn, InjectionFlag, AttnOnlyFlag)
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList, AttnOnlyFlag);
    for i = 1:length(Prefix)
        bpm_setenv1(Prefix{i}, RFAttn, InjectionFlag, AttnOnlyFlag)
    end
end



function bpm_setenv1(Prefix, RFAttn, InjectionFlag, AttnOnlyFlag)

% 2^filterShift number of samples to average over for the gain calculation
FilterShift = 1;


% Attenuation tweaks
if RFAttn ~= 0
    % if length(Prefix)>=10 && (strcmpi(Prefix, 'SR10C:BPM1') || strcmpi(Prefix, 'SR01C:BPM2') || strcmpi(Prefix, 'SR11C:BPM8') || strcmpi(Prefix, 'SR11C:BPM1'))
    %     % Lower signal for some reason
    %     RFAttn = RFAttn - 2;
    % end
    % if length(Prefix)>=10 && (strcmpi(Prefix, 'SR02C:BPM2') || strcmpi(Prefix, 'SR05C:BPM3') || strcmpi(Prefix, 'SR06C:BPM2') || strcmpi(Prefix, 'SR08C:BPM2') || strcmpi(Prefix, 'SR10C:BPM2'))
    %     % Lower signal for some reason
    %     RFAttn = RFAttn - 1;
    % end
    % if length(Prefix)>=10 && (strcmpi(Prefix, 'SR01C:BPM6') || strcmpi(Prefix, 'SR01C:BPM8') || strcmpi(Prefix, 'SR03C:BPM7') || strcmpi(Prefix, 'SR03C:BPM8') || strcmpi(Prefix, 'SR09C:BPM7'))
    %     % Higher signal for some reason
    %     RFAttn = RFAttn + 1;
    % end
    % if length(Prefix)>=10 && (strcmpi(Prefix, 'SR03C:BPM2'))
    %     % Higher siglab for some reason
    %     RFAttn = RFAttn + 2;
    % end
    if length(Prefix)>=10 && (strcmpi(Prefix, 'SR01C:BPM1') || strcmpi(Prefix, 'SR01C:BPM3') || strcmpi(Prefix, 'SR01C:BPM4'))
        % Splitter for noise measurement (CTS)
        RFAttn = RFAttn - 8;
    end
    if length(Prefix)>=10 && strcmpi(Prefix, 'SR01C:BPM5')
        % Splitter for noise measurement (Lorch)
        RFAttn = RFAttn - 7;
    end
     
    %if length(Prefix)>=10 && (strcmpi(Prefix, 'BTS:BPM6'))
    %    % Modified 2 amplifiers (all modified BPMs will eventually go into the injector)
    %    RFAttn = RFAttn - 6;
    %    fprintf('        Decreasing %s attenuation by 6 (%d)\n', Prefix, RFAttn);
    %end
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

if AttnOnlyFlag
    return
end

% bpmTest:004:lossOfBeamThreshold
% bpmTest:004:autotrim:enable
% bpmTest:004:autotrim:status
% setpvonline([Prefix,':pilotToneSelect'], 0);  % 0->low 1->high
%setpvonline([Prefix,':autotrim:control'], 0);    % Disable PT
%setpvonline([Prefix,':autotrim:threshold.DRVL'], 50000);
setpvonline([Prefix,':autotrim:threshold'],     100000);

% 2^filterShift number of samples to average over for the gain calculation
%setpvonline([Prefix,':autotrim:filterShift'], FilterShift);       % Presenly not used

setpvonline([Prefix,':adcGain'], 0);          % 0->1 1->1.5

% Gain Trim???
a = 1;
setpvonline([Prefix,':ADC0:gainTrim'], a); 
setpvonline([Prefix,':ADC1:gainTrim'], a); 
setpvonline([Prefix,':ADC2:gainTrim'], a); 
setpvonline([Prefix,':ADC3:gainTrim'], a); 

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
setpvonline([Prefix,':wfr:ADC:triggerMask'], bin2dec('10000101'));  %hex2dec('3'));
setpvonline([Prefix,':wfr:TBT:triggerMask'], bin2dec('10000101'));  %hex2dec('3'));
setpvonline([Prefix,':wfr:FA:triggerMask'],  bin2dec('10000101'));  %hex2dec('3'));

% Event triggers
setpvonline([Prefix,':EVR:event22trig'],  bin2dec('10000000'));
setpvonline([Prefix,':EVR:event36trig'],  bin2dec('00000000'));
setpvonline([Prefix,':EVR:event48trig'],  bin2dec('01000000'));  % note: 66 is before 48 since septum is "slow"
setpvonline([Prefix,':EVR:event68trig'],  bin2dec('00000000'));
setpvonline([Prefix,':EVR:event70trig'],  bin2dec('00100000'));
setpvonline([Prefix,':EVR:event122trig'], bin2dec('00010000'));

% Arm
setpvonline([Prefix,':wfr:ADC:arm'], 1);
setpvonline([Prefix,':wfr:TBT:arm'], 1);
setpvonline([Prefix,':wfr:FA:arm'],  1);

%fprintf('   Setup for %s complete.\n',Prefix);
%setpvonline([Prefix,':softwareRev.PROC'], 1);
%setpvonline([Prefix,':firmwareRev.PROC'], 1);


