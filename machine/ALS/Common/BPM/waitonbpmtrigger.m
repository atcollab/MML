function waitonbpmtrigger(varargin)

WaitFlag = 1;
RecorderType = 'All';
SoftwareTrigger = 0;

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
        elseif strcmpi(varargin{i}, 'Software')
            SoftwareTrigger = 0;
            varargin(i) = [];
        end
    end
end

if isempty(varargin)
    DevList = family2dev('BPM');
else
    DevList = varargin{1};
    varargin(1) = [];
end

% Arm
if strcmpi(RecorderType, 'ADC') || strcmpi(RecorderType, 'All')
    setpv('BPM', 'ADC_Arm');
end
if strcmpi(RecorderType, 'TBT') || strcmpi(RecorderType, 'All')
    setpv('BPM', 'TBT_Arm');
end
if strcmpi(RecorderType, 'FA') || strcmpi(RecorderType, 'All')
    setpv('BPM', 'FA_Arm');
end


if WaitFlag
    pause(.25);
    
    ArmedFlag = 1;
    while ArmedFlag
        a = 0;
        b = 0;
        c = 0;
        for i = 1:length(Prefix)
            if strcmpi(RecorderType, 'ADC') || strcmpi(RecorderType, 'All')
                a(i,1) = getpvonline([Prefix{i},':wfr:ADC:armed'], 'double');
            end
            if strcmpi(RecorderType, 'TBT') || strcmpi(RecorderType, 'All')
                b(i,1) = getpvonline([Prefix{i},':wfr:TBT:armed'], 'double');
            end
            if strcmpi(RecorderType, 'FA') || strcmpi(RecorderType, 'All')
                c(i,1) = getpvonline([Prefix{i},':wfr:FA:armed'], 'double');
            end
        end
        ArmedFlag = any([a; b; c]);
    end
end



% Prefix{1} = 'SR01C:BPM4';
% setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
% setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
% setpvonline([Prefix{i},':wfr:FA:arm'],  1);
