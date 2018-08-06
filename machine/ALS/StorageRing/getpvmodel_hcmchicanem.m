function [AM, ErrorFlag] = getpvmodel_hcmchicanem(Family, Field, DeviceList)
% [AM, tout, DataTime, ErrorFlag] = getpvmodel_hcmchicanem(Family, Field, DeviceList)



if nargin < 1
    error('Must have at least 1 input (Family).');
end

if nargin < 3
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

ErrorFlag = 0;

AM = 80 * ones(size(DeviceList,1),1);
