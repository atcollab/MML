function  [RampRate, tout, DataTime, ErrorFlag] = getramprate_bts(Family, Field, DeviceList, varargin)

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

if nargin < 3
    DeviceList = [];
end

ScanField  = getpv(family2channel(Family, 'Setpoint', DeviceList), 'SCAN', 'char');

% This is cheap and may not always work
ScanRate = str2num(ScanField(:,1:2));
if isempty(ScanRate)
    error('Trouble finding the scan rate for the BEND setpoint channel.');
end

[DeltaPerRecordProcess, tout, DataTime, ErrorFlag] = getpv(family2channel(Family, 'RampRate', DeviceList));

RampRate = DeltaPerRecordProcess ./ ScanRate;
