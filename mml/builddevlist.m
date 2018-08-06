function [DeviceList, Index] = builddevlist(Family, Elem)  
%BUILDDEVLIST - Make a full device list from devices in one sector
%  [DeviceList, Index] = builddevlist(Family, Elem) 
%
%  INPUTS
%  1. Family - Family name
%  2. Elem - Element number in sector {Default: all} 
%
%  OUPUTS
%  1. DeviceList
%  2. Index
%
%
%  NOTES
%  1. DeviceList and Index are the device list and index w.r.t. family2dev(Family)

%  Written by Greg Portmann

if nargin == 0
   error('Must have at least one input (''Family'')!');
end

DeviceListTotal = family2dev(Family);

if nargin == 1
    DeviceList = DeviceListTotal;
    return
end


DeviceList = [];
Index = [];
for i = 1:size(DeviceListTotal,1)
    if any(Elem==DeviceListTotal(i,2))
        DeviceList = [DeviceList; DeviceListTotal(i,:)];
        Index = [Index; i];
    end
end



