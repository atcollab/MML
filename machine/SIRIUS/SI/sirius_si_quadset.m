function ErrorFlag = sirius_si_quadset(Family, Field, AM, DeviceList, WaitFlag)
%SIRIUS_QUADGET - Decompose values of magnet excitation of individual quadrupoles into families and shunts power supply values.
%
%Hist�ria
%
%2015-09-09

if size(AM,1) ~= size(DeviceList,1)
    if size(AM,1) == 1 && size(AM,2) == 1
        AM = ones(size(DeviceList,1),1) * AM;
    elseif size(AM,1) == 1 && size(AM,2) == size(DeviceList,1)
        AM = AM.';
    else
        error('Setpoint size must be equal the device list size or be a scalar.');
    end
end

ShuntPS  = getfamilydata(Family, 'ShuntPS');
FamilyPS = getfamilydata(Family, 'FamilyPS');

AllDevices = family2dev(Family);
if size(DeviceList,1) ~= size(AllDevices,1)
    FamilyValues = getpv(FamilyPS, Field, DeviceList);
    ShuntValues   = AM - FamilyValues;
    setpv(ShuntPS, Field, ShuntValues, DeviceList);
else
    FamilyValues = mean(AM)*ones(size(AllDevices,1), 1);
    ShuntValues  = AM - FamilyValues;
    setpv(FamilyPS, Field, FamilyValues);
    setpv(ShuntPS, Field, ShuntValues, DeviceList);
end

if ~isempty(WaitFlag) && WaitFlag>0,  pause(WaitFlag); end

ErrorFlag = 0;

return;
