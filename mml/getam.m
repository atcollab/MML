function [AM, tout, DataTime, ErrorFlag] = getam(varargin)
%GETAM - Gets monitor channels
%  If using family name, device list method,
%  [AM, tout, DataTime] = getam(Family, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
%  If using data structure,
%  [AM, tout, DataTime] = getam(DataStructure, t, FreshDataFlag, TimeOutPeriod)
%
%  Channel names can still be use but the output may or may not be an monitor. 
%  [AM, tout, DataTime] = getam(ChannelName, t, FreshDataFlag, TimeOutPeriod)
%
%  INPUTS & OUTPUTS
%  See getpv.  getam is an alias to getpv with the Field='Monitor'.
%
%  See also getpv, getsp, setsp, setpv

%  Written by Greg Portmann


if nargout < 3
    [AM, tout] = getpv(varargin{:});
else
    [AM, tout, DataTime, ErrorFlag] = getpv(varargin{:});
end



% if nargin == 0
%     error('Must have at least one input (Family, Data Structure or Channel Name).');
% end
% 
% if iscell(Family)
% [AM, tout, DataTime, ErrorFlag] = getpv(Family, varargin{:});
% else
% [FamilyIndex, AO] = isfamily(Family);
% 
% if nargout < 3
%     if FamilyIndex
%         % Family name method
%         [AM, tout] = getpv(AO, 'Monitor', varargin{:});
%     else
%         % ChannelName method
%         [AM, tout] = getpv(Family, '', varargin{:});
%     end
% else
%     if FamilyIndex
%         % Family name method
%         [AM, tout, DataTime, ErrorFlag] = getpv(AO, 'Monitor', varargin{:});
%     else
%         % ChannelName method
%         [AM, tout, DataTime, ErrorFlag] = getpv(Family, '', varargin{:});
%     end
% end
% end

