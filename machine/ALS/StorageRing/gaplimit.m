function [GAPmin, GAPmax] = gaplimit(DeviceList)
% [GapMin, GapMax] = gaplimit(DeviceList)
%
%   DeviceList - Insertion device list


if nargin == 0
	DeviceList = [];
end
if isempty(DeviceList)
	DeviceList = family2dev('ID');
end
if size(DeviceList,2) == 1
    %DeviceList = elem2dev('ID', DeviceList);
    DeviceList = [DeviceList ones(size(DeviceList))];
end

GAPmin = minsp('ID', DeviceList);
GAPmax = maxsp('ID', DeviceList);




