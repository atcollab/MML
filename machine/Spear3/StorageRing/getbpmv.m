function [BPM, ErrorFlag] = getbpmv(varargin)
%GETBPMV - Returns the button voltages
%  Volts = getbpmv(Family, Field, DeviceList)
%  Volts = getbpmv(Family, DeviceList)
%  Volts = getbpmv(DeviceList)
%
%  Each column corresponds to Button 1, Button 2, Button 3, Button 4
%  See getbpmspear for the algorithm


ErrorFlag = 0;


% Parse the inputs
if length(varargin) >= 1
    Family = varargin{1};
else
    Family = '';
end
if length(varargin) >= 2
    Field = varargin{2};
else
    Field = '';        
end
if length(varargin) >= 3
    DeviceList = varargin{3};
else
    DeviceList = [];
end
if isnumeric(Field)
    DeviceList = Field;
end
if isnumeric(Family)
    DeviceList = Family;
end


% Get the data
BPM = getbpmspear('Voltage', DeviceList);



