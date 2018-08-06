function [SP, tout, DataTime, ErrorFlag] = getsp(Family, varargin)
%GETSP - Gets setpoint channels
%  If using family name, device list method,
%  [SP, tout, DataTime] = getsp(Family, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
%  If using data structure,
%  [SP, tout, DataTime] = getsp(DataStructure, t, FreshDataFlag, TimeOutPeriod)
%
%  Channel names can still be use but the output may or may not be an setpoint. 
%  [SP, tout, DataTime] = getsp(ChannelName, t, FreshDataFlag, TimeOutPeriod)
%
%  INPUTS & OUTPUTS
%  See getpv.  getsp is an alias to getpv with Field='Setpoint'.
%
%  See also getam, setsp, getpv, setpv

%  Written by Greg Portmann


% if nargout < 3
%     [SP, tout] = getpv(varargin{:});
% else
%     [SP, tout, DataTime, ErrorFlag] = getpv(varargin{:});
% end


if nargin == 0
    error('Must have at least one input (Family, Data Structure or Channel Name).');
end

if iscell(Family)
    [SP, tout, DataTime, ErrorFlag] = getpv(Family, 'Setpoint', varargin{:});
else
    FamilyIndex = isfamily(Family);

    if nargout < 3
        if FamilyIndex
            % Family name method
            [SP, tout] = getpv(Family, 'Setpoint', varargin{:});
        else
            % ChannelName method
            [SP, tout] = getpv(Family, '', varargin{:});
        end
    else
        if FamilyIndex
            % Family name method
            [SP, tout, DataTime, ErrorFlag] = getpv(Family, 'Setpoint', varargin{:});
        else
            % ChannelName method
            [SP, tout, DataTime, ErrorFlag] = getpv(Family, '', varargin{:});
        end
    end
end

