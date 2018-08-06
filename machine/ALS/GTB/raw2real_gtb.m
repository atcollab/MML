function ValueReal = raw2real_gtb(Family, Field, ValueRaw, DeviceList)
%RAW2REAL_GTB - Converts control system ValueRaws to hardware calibrated values
%  ValueReal = raw2real_gtb(Family, Field, ValueRaw, DeviceList)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. ValueRaw - Controls system value
%  4. DeviceList - Device list (Value and DeviceList must have the same number of rows)
%
%  OUTPUTS
%  1. ValueReal - Calibrated value
%
%  See also real2raw_gtb, at2gtb, gtb2at

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

if size(ValueRaw,1) == 1 && length(DeviceList) > 1
    ValueRaw = ones(size(DeviceList,1),1) * ValueRaw;
elseif size(ValueRaw,1) ~= size(DeviceList,1)
    error('Rows in ValueRaw must equal rows in DeviceList or be a scalar');
end

if all(isnan(ValueRaw))
    ValueReal = ValueRaw;
    return
end

% Only true for monitors (at the moment)
if strcmpi(Field, 'Monitor')

% Get the tables
SP_Table = getfamilydata(Family, 'Setpoint', 'SP_Table', DeviceList);
AM_Table = getfamilydata(Family, 'Setpoint', 'AM_Table', DeviceList);

for i = 1:size(ValueRaw,1)
    for j = 1:size(ValueRaw,2)
        %if all(diff(AM_Table(i,:))==0)
        %    % Bad table (LTB_HC7 is fixed AM)
        %    ValueReal(i,j) = ValueRaw(i,j);
        %else
            ValueReal(i,j) = interp1(AM_Table(i,:), SP_Table(i,:), ValueRaw(i,j), 'linear', 'extrap');
        %end
    end
end

else
    error('raw2real_gtb is only for the monitor field.');
end
