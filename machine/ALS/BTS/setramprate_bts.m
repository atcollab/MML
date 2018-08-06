function ErrorFlag = setramprate_bts(Family, varargin)
%SETRAMPRATE_BTS - Sets the power supply ramp rate
%  Error = setramprate_bts(Family, RampRate, DeviceList)

%  Written by Greg Portmann


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
    if length(varargin) >= 1
        RampRate = varargin{1};
        varargin(1) = [];
    else
        error('Must have at least 2 inputs (Family and RampRate).');
    end
    if length(varargin) >= 1
        DeviceList = varargin{1};
        varargin(1) = [];
    else
        DeviceList = [];
    end
else
    error('Must have at least 2 inputs (Family and RampRate).');
end


ScanField  = getpv(family2channel(Family, 'Setpoint', DeviceList), 'SCAN', 'char');

% This is cheap and may not always work
ScanRate = str2num(ScanField(:,1:2));
if isempty(ScanRate)
    error('Trouble finding the scan rate for the BEND setpoint channel.');
end

DeltaPerRecordProcess = RampRate .* ScanRate;

ErrorFlag = setpv(family2channel(Family, 'RampRate', DeviceList), DeltaPerRecordProcess);

