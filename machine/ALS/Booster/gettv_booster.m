function [AM, tout, DataTime, ErrorFlag] = getx_booster(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getx_booster(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

ChannelName = family2channel(Family, Field, DeviceList);
[AM, tout, DataTime, ErrorFlag] = getpv(ChannelName, varargin{:});


