function [RunFlag, Delta, Tol] = getrunflagquad(Family, Field, DeviceList)
%GETRUNFLAGQUAD - Returns the run flag for the QF & QD families
% [RunFlag, Delta, Tol] = getrunflagquad(Family, Field, DeviceList)
%
% Tolerance check for including the summing junctions for quadrupoles.


if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

if nargin < 3
    DeviceList = [];
end

SP  = getpv(Family, 'Setpoint', DeviceList);
SP1 = getpv(Family, 'FF', DeviceList);

FFMultiplier = getpv(Family, 'FFMultiplier', DeviceList);

SP(isnan(SP)) = 0;
SP1(isnan(SP1)) = 0;
SP = SP + FFMultiplier .* SP1;

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

