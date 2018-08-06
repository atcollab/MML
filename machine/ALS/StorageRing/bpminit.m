function bpminit(varargin)
%BPMINIT - This function initializes the new BPMs
%  
%  [Attn?]  = bpminit(RFAttn, Flags)
%
%  INPUTS
%  1. Attenuation
%  2. Flags - 'Attn Only'
%
%  OUTPUTS
%  1. None
%
%  NOTE
%  1. All inputs are optional
%
%  EXAMPLE
%  1. bpminit('Attn Only');
%
%  See also hwinit, cellcontrollerinit, bpm_setenv

%  Written by Greg Portmann

% To do:
% Even out the BPM gain variation with the Attn


% [1 4] for  BPM development
% [2 1] being used by TFB/LFB (basically perminently)
% [3 2] has a low channel D -> Fixed Oct 2014 (button change)
% [4 1] has a low channel C -> Fixed Oct 2014, but the issue returned (I think this was fixed?)
% [9 7] has a low channel B -> Fixed Oct 2014 (button change)

NewTimingSystemFlag = 1;

% Get inputs (sort out the flags first)
AttnOnlyFlag = 0;
InjectionFlag = 0;
RFAttn = [];
RMSFlag = 0;  % Typically for single bunch

RFAttn500 = 15;

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor
    else
        if ischar(varargin{i})
            if any(strcmpi(varargin{i},{'Attn Only','AttnOnly','Attn'}))
                AttnOnlyFlag = 1;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Full Setup','FullSetup'}))
                AttnOnlyFlag = 0;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'RMS','SingleBunch'}))
                RMSFlag = 1;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'User Beam','UserBeam'}))
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                    RFAttn = 5;
                else
                    RFAttn = RFAttn500;
                end
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'500 mA','500mA'}))
                RFAttn = RFAttn500;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'200 mA','200mA'}))
                RFAttn = 5;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Low Current','LowCurrent'}))
                RFAttn = 0;
                varargin(i) = [];
            else
                % Ignor unknown strings
                varargin(i) = [];
            end
        end
    end
end 

if length(varargin) >= 1
    RFAttn = varargin{1};
    varargin(i) = [];
end


Prefix = getfamilydata('BPM','BaseName');
% Status = getpv('BPM','Status');
% Prefix([17])=[];


if AttnOnlyFlag
    for i = 1:length(Prefix)
        bpm_setenv(Prefix, RFAttn, InjectionFlag, AttnOnlyFlag)
    end
    return;
end


% Full initialization

fprintf('    DCCT = %.1f mA\n', getdcct);

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
% RMSFlag  1 -> RMS   0 -> I-Q
% The selfTrigger:level PV seems also to be a squelch level in RMS mode.
% I'm going to remove the squelch (and unfortunately the trigger) for small current injection studies.
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':buttonDSP'], RMSFlag);
end
if RMSFlag
    for i = 1:length(Prefix)
        setpvonline([Prefix{i},':selfTrigger:level'], 1);
    end
else
    for i = 1:length(Prefix)
        setpvonline([Prefix{i},':selfTrigger:level'], 200);
    end
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
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('00000011'));
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('00000011'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('00000011'));
        
        % Event triggers
        setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event68trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00010000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00001000'));
        
        % Bump threshold
        setpvonline([Prefix{i},':lossOfBeamThreshold'], 8000);
    end
elseif 1
    % Extraction pre-trigger
    for i = 1:length(Prefix)        
        % Trigger mask
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], bin2dec('01000001')); 
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], bin2dec('01000001'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('01000001'));
        
        % Event triggers
        setpvonline([Prefix{i},':EVR:event22trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('10000000'));
        setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('01000000'));
        setpvonline([Prefix{i},':EVR:event68trig'],  bin2dec('00100000'));
        setpvonline([Prefix{i},':EVR:event70trig'],  bin2dec('00010000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
    end
elseif 0
    % Event 122 -> ~1 Hz
    for i = 1:length(Prefix)
        % Trigger mask
        setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('80'));
        setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('80'));
        setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('80'));
        
        %  Event triggers
        % New timing system
        setpvonline([Prefix{i},':EVR:event36trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event68trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event48trig'],  bin2dec('00000000'));
        setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('10000000'));
    end
end


% Test mode: add the orbit clock to the LSB of the ADD waveform
LSBChange = 0;   % 0->No Change   1->Add to LSB
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:ADC:DataMode'], LSBChange);
end

% setting delay0, even to the same value, will briefly cause the PLL to loose lock
setdelay0_local;
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


% Special FA init to capture EPBI trips 
bpminit_fa;


% Manually trigger
% for i = 1:length(Prefix)
%     setpvonline([Prefix{i},':wfr:softTrigger'], 1);
% end
% pause(6);


function setdelay0_local
Prefix = {
    'SR01C:BPM2'
    'SR01C:BPM7'
    'SR01C:BPM8'
    'SR02C:BPM2'
    'SR02C:BPM7'
    'SR03C:BPM2'
    'SR03C:BPM7'
    'SR03C:BPM8'
    'SR04C:BPM1'
    'SR04C:BPM2'
    'SR04C:BPM7'
    'SR04C:BPM8'
    'SR05C:BPM1'
    'SR05C:BPM2'
    'SR05C:BPM7'
    'SR05C:BPM8'
    'SR06C:BPM1'
    'SR06C:BPM2'
    'SR06C:BPM7'
    'SR06C:BPM8'
    'SR07C:BPM1'
    'SR07C:BPM2'
    'SR07C:BPM7'
    'SR07C:BPM8'
    'SR08C:BPM1'
    'SR08C:BPM2'
    'SR08C:BPM7'
    'SR08C:BPM8'
    'SR09C:BPM1'
    'SR09C:BPM2'
    'SR09C:BPM7'
    'SR09C:BPM8'
    'SR10C:BPM1'
    'SR10C:BPM2'
    'SR10C:BPM7'
    'SR10C:BPM8'
    'SR11C:BPM1'
    'SR11C:BPM2'
    'SR11C:BPM7'
    'SR11C:BPM8'
    'SR12C:BPM1'
    'SR12C:BPM2'
    'SR12C:BPM7'};

if 0
    fprintf('   BPM delay0 set to 1.\n');
    Delay0 = ones(length(Prefix),1);
    
elseif 1
    Delay0 = [
         1     9+82*0 
         2    10+82*0
         3    11+82*0
         4    10+82*0
         5    12+82*0
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
    Delay0 = Delay0(:,2);
    
    Delay0 = Delay0 + 10;
    
elseif 0
    fprintf('   BPM delay0 set based on single bunch, cam kicker measurements which centers a turn on bucket 308 (Jan 26, 2015).\n');
    Delay0 = [
        9
        11
        11
        12
        13
        27
        29
        30
        45
        45
        47
        48
        41
        42
        43
        44
        47
        47
        49
        50
        34
        34
        35
        36
        51
        51
        52
        52
        57
        57
        59
        60
        65
        64
        65
        67
        18
        18
        19
        20
        14
        15
        17
        ];
    
elseif 0
    fprintf('   BPM delay0 set based on single bunch, cam kicker measurements which centers a turn on bucket 318 (Dec 16, 2014).\n');
    Delay0 = [
        65
        65
        68
        68
        69
        1
        2
        3
        20
        20
        20
        22
        16
        14
        17
        18
        20
        22
        22
        24
        8
        8
        9
        10
        24
        24
        26
        27
        42
        43
        42
        45
        48
        48
        49
        50
        74
        73
        74
        75
        71
        71
        72];
    
else
    Delay0 = [
        66
        68
        69
        69
        70
        2
        3
        5
        21
        20
        21
        22
        16
        16
        17
        19
        22
        22
        22
        24
        9
        8
        9
        10
        25
        24
        25
        26
        43
        43
        44
        44
        50
        50
        51
        53
        74
        74
        74
        78
        72
        72
        72];
end

for i = 1:length(Prefix)
    setpvonline([Prefix{i},':EVR:delay0'], Delay0(i));
end



% Prefix = {
%  %   'SR01C:BPM1'
%     'SR01C:BPM2'
%  %   'SR01C:BPM4'
%  %   'SR01C:BPM6'
%     'SR01C:BPM7'
%     'SR01C:BPM8'
%     'SR02C:BPM2'
%     'SR02C:BPM7'
%     'SR03C:BPM2'
%     'SR03C:BPM7'
%     'SR03C:BPM8'
%     'SR04C:BPM1'
%     'SR04C:BPM2'
%     'SR04C:BPM7'
%     'SR04C:BPM8'
%     'SR05C:BPM1'
%     'SR05C:BPM2'
%     'SR05C:BPM7'
%     'SR05C:BPM8'
%     'SR06C:BPM1'
%     'SR06C:BPM2'
%     'SR06C:BPM7'
%     'SR06C:BPM8'
%     'SR07C:BPM1'
%     'SR07C:BPM2'
%     'SR07C:BPM7'
%     'SR07C:BPM8'
%     'SR08C:BPM1'
%     'SR08C:BPM2'
%     'SR08C:BPM7'
%     'SR08C:BPM8'
%     'SR09C:BPM1'
%     'SR09C:BPM2'
%     'SR09C:BPM7'
%     'SR09C:BPM8'
%     'SR10C:BPM1'
%     'SR10C:BPM2'
%     'SR10C:BPM7'
%     'SR10C:BPM8'
%     'SR11C:BPM1'
%     'SR11C:BPM2'
%     'SR11C:BPM7'
%     'SR11C:BPM8'
%     'SR12C:BPM1'
%     'SR12C:BPM2'
%     'SR12C:BPM7'
%     };

