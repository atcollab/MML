function [AM, tout, DataTime, ErrorFlag] = getrf_als(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getrf_als(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%


% 2017-01-27 Greg Portmann
% Changed to using the Keysight counter in LI09


%[AM, tout, DataTime, ErrorFlag] = getpv('SR01C___FREQBHPAM00', varargin{:});
%AM = AM + 499.642; %the high precision channel above is SR01C___FREQB__AM00 - 499.642 (defined in the EPICS PV)

% Counter in LI09 [readback in Hz]
[AM, tout, DataTime, ErrorFlag] = getpv('MOCounter:FREQUENCY', varargin{:});
AM = AM / 1e6;

