function [AM, tout, DataTime, ErrorFlag] = getrf_sps(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getrf_als(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
ChannelName = family2channel(Family, Field, DeviceList);
[AM, tout, DataTime, ErrorFlag] = getpv(ChannelName, 'Double', varargin{:});

% Control system units are in .1 hz
AM = AM / 10;   % Hz
AM = AM / 1e6;  % MHz

