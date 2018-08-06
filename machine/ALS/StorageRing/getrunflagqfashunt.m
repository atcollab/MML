function [RunFlag, Delta, Tol] = getrunflagcm(Family, Field, DeviceList)
% [RunFlag, Delta] = getrunflagqfashunt(Family, Field, DeviceList)
%
% Written by Greg Portmann

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

if nargin < 3
    DeviceList = [];
end

BC = getpv(Family, Field,      DeviceList);
BM = getpv(Family, Field(1:6), DeviceList);
if isempty(BC)
    return;
end

RunFlag = any(BC ~= BM);
Delta = BC-BM;
Tol = .1;