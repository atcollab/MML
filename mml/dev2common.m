function [Output, Error] = dev2common(Family, DeviceList)
%DEV2COMMON - Converts a device list to a common name list
%  [CommonNames, Error] = dev2common(Family, DeviceList)
%
%  INPUTS
%  1. Family - Family Name
%  2. DeviceList - Device list
%
%  OUTPUTS
%  1. CommonNames - List of common names (string, matrix, cell array)
%  2. ErrorFlag - True if the common names could not be found
%
%  NOTES
%  1. If Element list is empty, the entire family list will be returned.
%  2. If the device is not found it will be removed from the list.
%
%  See also common2dev

%  Written by Jeff Corbett


Error = 0;
Output = [];

if nargin == 0
    error('Dev2Common:  one input required.');
end

if nargin == 1
    [DeviceList, Error] = getlist(Family);
    if Error
        return
    end
end

if nargin == 2
    if (size(DeviceList,2) == 1)
        DeviceList = elem2dev(Family, DeviceList);
    end

    DeviceListTotal = getlist(Family);
    [iDevice, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
    if ~isempty(iNotFound)
        ErrorFlag = 1;
        for i = 1:length(iNotFound)
            warning('Device [%d,%d] not found in Family %s',DeviceList(iNotFound(i),1),DeviceList(iNotFound(i),2),Family);
        end
    end
    if isempty(iDevice)
        ErrorFlag = 1;
        warning('No devices to get for Family %s', Family);
        return;
    end
end


[Output, Error] = getfamilydata(Family, 'CommonNames', DeviceList);

