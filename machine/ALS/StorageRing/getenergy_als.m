function [AM, tout, DataTime, ErrorFlag] = getenergy_als(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getenergy_als(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%


[AM, tout, DataTime, ErrorFlag] = getpv('BEND', Field, DeviceList, varargin{:});

AM = bend2gev('BEND', Field, AM);


