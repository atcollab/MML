function ValueRaw = real2raw_gtb(Family, Field, ValueReal, DeviceList)
%REAL2RAW_GTB - Converts control system values to hardware calibrated values
%  ValueRaw = raw2real_gtb(Family, Field, ValueReal, DeviceList)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. ValueReal - Calibrated value
%  4. DeviceList - Device list (Value and DeviceList must have the same number of rows)
%
%  OUTPUTS
%  1. AM - Calibrated AM value
%  2. ValueRaw - Controls system value
%
%  See also raw2real_gtb, at2gtb, gtb2at

%  Written by Greg Portmann


if nargin < 3
    error('At least 3 input required');
end

if isempty(Field)
    Field = 'Setpoint';
end

if nargin < 4
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if size(ValueReal,1) == 1 && length(DeviceList) > 1
    ValueReal = ones(size(DeviceList,1),1) * ValueReal;
elseif size(ValueReal,1) ~= size(DeviceList,1)
    error('Rows in ValueReal must equal rows in DeviceList or be a scalar');
end

if all(isnan(ValueReal))
    ValueRaw = ValueReal;
    return
end

% Only true for monitors (at the moment)
if strcmpi(Field, 'Monitor')

% Get the tables
SP_Table = getfamilydata(Family, 'Setpoint', 'SP_Table', DeviceList);
AM_Table = getfamilydata(Family, 'Setpoint', 'AM_Table', DeviceList);

for i = 1:size(ValueReal,1)
    for j = 1:size(ValueReal,2)
        if all(diff(AM_Table(i,:))==0)
            % Bad table (LTB_HC7 is fixed AM)
            ValueRaw(i,j) = ValueReal(i,j);
        else
            ValueRaw(i,j) = interp1(SP_Table(i,:), AM_Table(i,:), ValueReal(i,j), 'linear', 'extrap');
        end
    end
end

else
    error('raw2real_gtb is only for the monitor field.');
end
