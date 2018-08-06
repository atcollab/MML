function [AM, tout, DataTime, ErrorFlag] = sirius_bo_bendget(Family, Field, DeviceList, t)
%SIRIUS_BO_BENDGET - Combine reading of bend families power supplies.

% Starting time
t0 = clock;

PowerSupplies = getfamilydata(Family, 'PowerSupplies');
bend_a = PowerSupplies(1,:);
bend_b = PowerSupplies(2,:);

FamilyValueA = getpv(bend_a, Field, DeviceList, 'Hardware');
FamilyValueB = getpv(bend_b, Field, DeviceList, 'Hardware');

AM = FamilyValueA;

tout = etime(clock, t0);
DataTime = [];
ErrorFlag = 0;