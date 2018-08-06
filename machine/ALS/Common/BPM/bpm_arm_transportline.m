function DeltaDCCT = bpm_arm_transportline(varargin)

WaitFlag = 1;
RecorderType = 'ADC';

% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif isnumeric(varargin{i})
        % Ignor numeric
    elseif ischar(varargin{i})
        if strcmpi(varargin{i}, 'Wait')
            WaitFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i}, 'NoWait')
            WaitFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i}, 'All')
            RecorderType = 'All';
            varargin(i) = [];
        elseif strcmpi(varargin{i}, 'ADC')
            RecorderType = 'ADC';
            varargin(i) = [];
        elseif strcmpi(varargin{i}, 'TBT')
            RecorderType = 'TBT';
            varargin(i) = [];
        elseif strcmpi(varargin{i}, 'FA')
            RecorderType = 'FA';
            varargin(i) = [];
        end
    end
end

if isempty(varargin)
    Prefix = getfamilydata('BPM','BaseName');
else
    Prefix = varargin{1};
    varargin(1) = [];
end

if ~iscell(Prefix)
    Prefix = mat2cell(Prefix);
end

for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
end

DeltaDCCT = NaN;

DCCT1 = getpvonline('cmm:beam_current');

if WaitFlag
    ArmedFlag = 1;
    while ArmedFlag
        DCCT0 = DCCT1;
        DCCT1 = getpvonline('cmm:beam_current');
        pause(.5);
        a = 0;
        for i = 1:length(Prefix)
            a(i,1) = getpvonline([Prefix{i},':wfr:ADC:armed'], 'double');
        end
        
        % BTS BPM5 is not working
        %ArmedFlag = any(a);
        if length(Prefix)>5 && sum(a)<=1
            ArmedFlag = 0;
        else
            ArmedFlag = sum(a);
        end
        
        if getpv('SR01C___TIMING_AC11') == 0
            BucketNumber = getpvonline('SR01C___TIMING_AC08');
        else
            BucketNumber = getpvonline('SR01C___TIMING_AM14');
        end

        DCCT2 = getpvonline('cmm:beam_current');
        fprintf('   Waiting for trigger.  SR DCCT = %.1f  Bucket = %d   GunWidth = %d\r', DCCT2, BucketNumber, getpvonline('GTL_____TIMING_AC02'));
    end
end

pause(.1);

DCCT2 = getpvonline('cmm:beam_current');
if DCCT2 == DCCT1
    % Go a sample back if they are the same
    DeltaDCCT = DCCT2 - DCCT0;
else
    DeltaDCCT = DCCT2 - DCCT1;
end

fprintf('   Waiting for trigger.  SR DCCT = %.1f  Bucket = %d   GunWidth = %d   DeltaSRDCCT = %.2f\n', DCCT2, BucketNumber, getpvonline('GTL_____TIMING_AC02'), DeltaDCCT);


% Prefix{1} = 'SR01C:BPM4';
% setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
% setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
% setpvonline([Prefix{i},':wfr:FA:arm'],  1);
