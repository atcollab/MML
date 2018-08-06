function [FamilyNew, DeviceListNew] = convertdevlist(Family, DeviceList)  
%GETDEVLIST - Converts old style Family and DeviceList to the new middle layer (ALS only)
% [FamilyNew, DeviceListNew] = convertdevlist(Family, DeviceList)  
%  
%  Use family2dev to get a middle layer device list.
%
%  Written by Greg Portmann


if nargin == 0
   error('Must have at least one input (''Family'').');
end


switch Family
    case {'BSC', 'SUPERBEND'}
        FamilyNew = 'BEND';
        DeviceListNew = [4 2; 8 2; 12 2];

        if nargin >= 2
            DeviceListOld = [4 1; 8 1; 12 1];
            i = findrowindex(DeviceList, DeviceListOld);
            DeviceListNew = DeviceListNew(i,:);

            if length(i) ~= size(DeviceList,1)
                error('One or more input devices not found in the new middle layer naming scheme.');
            end
        end

    otherwise
        % Family is also a Middle Layer family
        FamilyNew = Family;
        DeviceListNew = family2dev(Family);

        if nargin >= 2
            DeviceListOld = DeviceListNew;
            i = findrowindex(DeviceList, DeviceListOld);
            DeviceListNew = DeviceListNew(i,:);

            if length(i) ~= size(DeviceList,1)
                error('One or more input devices not found in the new middle layer naming scheme.');
            end
        end
end





