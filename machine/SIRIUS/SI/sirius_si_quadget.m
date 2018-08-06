function [AM, tout, DataTime, ErrorFlag] = sirius_si_quadget(Family, Field, DeviceList)
%SIRIUS_QUADGET - Combine reading of quadrupole shunts and families power supplies to return values for individual quadrupoles.

% Starting time
t0 = clock;

FamilyPS = getfamilydata(Family, 'FamilyPS');
ShuntPS  = getfamilydata(Family, 'ShuntPS');

FamilyValues = getpv(FamilyPS, Field, DeviceList);
ShuntValues  = getpv(ShuntPS, Field, DeviceList); 

AM = FamilyValues + ShuntValues;
  
tout = etime(clock, t0);
DataTime = [];
ErrorFlag = 0;