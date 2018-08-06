function [AM, tout, DataTime, ErrorFlag] = gettv(Family, Field, varargin)
% [AM, tout, DataTime, ErrorFlag] = gettv(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

[AM, tout, DataTime, ErrorFlag] =  getpv(Family, 'In', varargin{:});


