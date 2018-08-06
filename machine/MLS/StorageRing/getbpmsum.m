function [BPM, tout, DataTime, ErrorFlag] = getbpmsum(varargin)
%GETBPMSUM - Returns the BPM button voltage sum
%  Sum = getbpmsum(Family, Field, DeviceList)
%  Sum = getbpmsum(Family, DeviceList)
%  Sum = getbpmsum(DeviceList)


ErrorFlag = 0;

if nargin < 1
    DeviceList = family2dev('BPMx');
else


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

end % nargin < 1

% Get the data
[BPM, tout, DataTime, ErrorFlag] = getbpmbuf('Sum', DeviceList);



