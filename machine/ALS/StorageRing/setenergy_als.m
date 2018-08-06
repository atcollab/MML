function ErrorFlag = setenergy_als(Family, Field, GeV, DeviceList, WaitFlag);
%  ErrorFlag = setenergy_als(Family, Field, GeV, DeviceList, WaitFlag);
%
%  Note: only the GeV input is used

if nargin < 3
    error('At least 3 input required.');
end

[ConfigSetpointEnd, ConfigSetpointStart] = setenergy(GeV, 1, 0);
ErrorFlag = 0;

