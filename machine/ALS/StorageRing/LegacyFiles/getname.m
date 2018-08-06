function [ChannelNames, ErrorFlag] = getname(varargin);
%  [ChannelNames, ErrorFlag] = getname(Family, Field, DeviceList)
%
%  Inputs:  Family name
%           DeviceList ([Sector Device #] or [element #]) {default: whole family}
%
%  Outputs: ChannelName = Channel name corresponding to the Family and DeviceList
%
%  NOTE: Just an alias to family2channel
%
%  Written by Greg Portmann


[ChannelNames, ErrorFlag] = family2channel(varargin{:});



% [ChannelNames, ErrorFlag] = getname(Family, DeviceList, TypeFlag)
%
% Inputs:  Family name
%          DeviceList ([Sector Device #] or [element #]) {default: whole family}
%          TypeFlag = 'AM' or 0  -> Monitor  channel name  {default, if exists, else setpoint}
%                     'AC' or 1  -> Setpoint channel name
%
% Outputs: ChannelName = Channel name corresponding to the Family and DeviceList
%
% Written by Greg Portmann
%
%
% if nargin < 2
%     DeviceList = family2dev(Family);
% end
% 
% if nargin < 3
%     TypeFlag = 0;
% end
% 
% if TypeFlag == 0
%     [ChannelNames, ErrorFlag] = family2channel(Family, 'Monitor', DeviceList);
% elseif TypeFlag == 1
%     [ChannelNames, ErrorFlag] = family2channel(Family, 'Setpoint', DeviceList);
% else
%     error('TypeFlag can only be 0 or 1');
% end