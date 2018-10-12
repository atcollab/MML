function varargout = setkicker(varargin)

% SETKICKER('ON'/'OFF',[DeviceList])
%
% 15-05-2007 Eugene: Changed from original that used mca to just using
% setpv and getpv.
% 11-05-2010 Eugene: Updated and removed SEP and SEI control. Should not be
% here.

if nargin > 0 && ischar(varargin{1})
    cmd = varargin{1};
else
    error('Usage : setkicker (on/off)');
end
if nargin > 1 && isnumeric(varargin{2})
    devlist = varargin{2};
else
    devlist = getlist('KICK');
end

pvname = getfamilydata('KICK','Setpoint','ChannelNames',devlist);
pvname = strrep(cellstr(pvname),'VOLTAGE_SP','OFF_ON_CMD');

% pvname = {...
%     'SR14KPS01:OFF_ON_CMD';
%     'SR01KPS01:OFF_ON_CMD';
%     'SR01KPS02:OFF_ON_CMD';
%     'SR02KPS01:OFF_ON_CMD';};

switch lower(cmd)
    case 'on'
        kval = 2';
        checkstr = 'off';
    case 'off'
        kval = 1;
        checkstr = 'on';
    otherwise
        error(sprintf('Unknown option: %s',cmd));
end

if any(getsp('KICK',devlist) > 200)
    % Turn trigger off first before turning on or off the kickers
    oldtrigstate = getpv('TS01EVG01:INJECTION_TRIGGER_ENABLE_CMD');
    setpv('TS01EVG01:INJECTION_TRIGGER_ENABLE_CMD',0); % 0 to stop and 1 to start
    pause(2); % wait some time and to make sure that the trigger has stopped
end

try
    setpv(pvname,kval);
    pause(0.2);
    % check if any haven't been turned off/on and reapply the command.
    % Should not need to do more than twice. 11-05-2010 Eugene
    if any(strcmpi(lcaGet(strrep(cellstr(pvname),'OFF_ON_CMD','OFF_ON_STATUS')),checkstr))
        setpv(pvname,kval);
    end
catch
    return
end

if any(getsp('KICK',devlist) > 200)
    pause(1);
    setpv('TS01EVG01:INJECTION_TRIGGER_ENABLE_CMD',oldtrigstate);
end