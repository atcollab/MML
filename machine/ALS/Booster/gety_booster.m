function [AM, tout, DataTime, ErrorFlag] = getx_booster(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getx_booster(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

AM = NaN * ones(size(DeviceList,1),1);
tout = 0;
DataTime = NaN;
ErrorFlag = 0;


%[AM, tout, DataTime, ErrorFlag] = getpv('SR01C___FREQB__AM00', varargin{:});


