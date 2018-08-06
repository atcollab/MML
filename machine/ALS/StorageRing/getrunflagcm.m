function [RunFlag, Delta, Tol] = getrunflagcm(Family, Field, DeviceList)
%GETRUNFLAGCM - Returns the run flag for the HCM & VCM families
% [RunFlag, Delta, Tol] = getrunflagcm(Family, Field, DeviceList)
%
% Tolerance check for including the summing junctions for correctors.


if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

if nargin < 3
    DeviceList = [];
end

SP  = getpv(Family, 'Setpoint', DeviceList);
SP1 = getpv(Family, 'Trim', DeviceList);
SP2 = getpv(Family, 'FF1', DeviceList);
SP3 = getpv(Family, 'FF2', DeviceList);

FFMultiplier = getpv(Family, 'FFMultiplier', DeviceList);
FFMultiplier(isnan(FFMultiplier)) = 1;


SP(isnan(SP)) = 0;
SP1(isnan(SP1)) = 0;
SP2(isnan(SP2)) = 0;
SP3(isnan(SP3)) = 0;
%SP = SP + SP1 + SP2 + SP3;
SP = SP + SP1 + FFMultiplier.*(SP2 + SP3); % Note: fast feedback is not included here.

if isempty(SP)
    RunFlag = [];
    Delta = [];
    Tol = [];
    return;
end


% Base runflag on sum(SP)-AM
% The tolerances are stored in the 'Setpoint' field
Tol = family2tol(Family, 'Setpoint', DeviceList);
if isempty(Tol)
    RunFlag = [];
    Delta = [];
    return;
end

AM  = getpv(Family, 'Monitor' , DeviceList);
if isempty(AM)
    RunFlag = [];
    Delta = [];
    return;
end


% Use the "real" Setpoint & Monitor values
SP = raw2real(Family, 'Setpoint', SP, DeviceList);
AM = raw2real(Family, 'Monitor',  AM, DeviceList);


RunFlag = abs(SP-AM) > Tol;
Delta = SP-AM;