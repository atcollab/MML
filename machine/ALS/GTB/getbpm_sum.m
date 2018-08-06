function [AM, tout, DataTime, ErrorFlag] = getbpm_sum(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getbpm_sum(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%


[AM1, tout, DataTime, ErrorFlag] = getpv('BPMx', 'Button1', DeviceList, varargin{:});
[AM2, tout, DataTime, ErrorFlag] = getpv('BPMx', 'Button2', DeviceList, varargin{:});
[AM3, tout, DataTime, ErrorFlag] = getpv('BPMx', 'Button3', DeviceList, varargin{:});
[AM4, tout, DataTime, ErrorFlag] = getpv('BPMx', 'Button4', DeviceList, varargin{:});

AM = AM1 + AM2 + AM3 + AM4;