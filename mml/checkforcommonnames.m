function [Family, DeviceList] = checkforcommonnames(Family, DeviceList)
%CHECKFORCOMMONNAMES - Checks for common names in the Family or DeviceList input
% [Family, DeviceList] = checkforcommonnames(Family, DeviceList)
%
%  INPUTS
%  1. Family - Potential common name list replacing a family name
%  2. DeviceList - Potential common name list replacing a device list
%
%  OUTPUTS
%  1. Family - Actual family name
%  2. DeviceList - Actual device list
%
%  NOTES
%  1. First checks if the DeviceList inputs is a common name list, 
%     if not, then checks the Family input for a common name list.
%
%  See also common2dev, inputparsingffd

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(DeviceList) && ~isempty(DeviceList)
    [DeviceList_Common, Family_Common] = common2dev(DeviceList, Family);
    if isempty(DeviceList)
        error('DeviceList was a string but no common name(s) could not be found.');
    else
        if ~isempty(Family_Common)
            Family = Family_Common;
            DeviceList = DeviceList_Common;
        end
    end
else
    % Check if the family is a common name list
    if ~isfamily(Family(1,:));
        % Common names where the family was the common name
        [DeviceList_Common, Family_Common] = common2dev(Family);
        if ~isempty(Family_Common)
            Family = Family_Common;
            DeviceList = DeviceList_Common;
        end
    end
end

