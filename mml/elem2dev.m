function Output = elem2dev(Family, Field, ElementList)
%ELEM2DEV - Converts a device list to an element list
%  [Sector Device#] = elem2dev(Family, Element#)
%
%  This function convects between the two methods of representing
%  the same device in the ring.  The "Device" method is a two column
%  matrix with the first being sector number and the seconds being
%  the device number in the sector.  The "Element" method is a one column
%  matrix with each entry being the element number starting at sector 1.
%
%  The following are equivalent devices for VCMs at the ALS:
%                     | 1  2 |                    |  2 |
%                     | 1  3 |                    |  3 |
%  [Sector Device#] = | 2  1 |    [ElementList] = |  9 |
%                     | 2  2 |                    | 10 |
%                     | 3  4 |                    | 20 |
%
%  NOTES
%  1. If ElementList is empty, the entire family list will be returned.
%  2. If the device is not found, then an error will occur.
%  3. If the Family is not found, then empty, [], is returned.
%
%  See also dev2elem

%  Written by Greg Portmann


if nargin == 0
    error('One input required.');
end
if nargin == 1
    Output = getlist(Family);
    return
end
if nargin < 2
	Field = '';
end
if nargin < 3
	ElementList = [];
end
if isnumeric(Field) && isempty(ElementList)
    ElementList = Field;
    Field = '';
end
if isempty(ElementList)
    Output = family2dev(Family, Field);
    return
end
if size(ElementList,2) == 2
    % Assume that the input was already a device list
    Output = ElementList;
    return
end

%Output = getfamilydata(Family, 'DeviceList', DevList);

[FamilyIndex, ACCELERATOR_OBJECT] = isfamily(Family);
if FamilyIndex
    if isempty(Field)
        DeviceListTotal  = ACCELERATOR_OBJECT.DeviceList;
        ElementListTotal = ACCELERATOR_OBJECT.ElementList;
    else
        % First check if there is DeviceList/ElementList at the Field level
        if isfield(ACCELERATOR_OBJECT.(Field), 'DeviceList')
            DeviceListTotal = ACCELERATOR_OBJECT.(Field).DeviceList;
        else
            DeviceListTotal = ACCELERATOR_OBJECT.DeviceList;
        end
        if isfield(ACCELERATOR_OBJECT.(Field), 'ElementList')
            ElementListTotal = ACCELERATOR_OBJECT.(Field).ElementList;
        else
            ElementListTotal = ACCELERATOR_OBJECT.ElementList;
        end
        if size(DeviceListTotal,1) ~= size(ElementListTotal,1)
            ElementListTotal = (1:size(DeviceListTotal,1))';
        end
    end
    
    Err = 0;
    
    % Intersect removes duplicate devices so first store index of how to unsort in j_unique 
    ElementListOld = ElementList;
    [ElementList, i_unique, j_unique] = unique(ElementList);   
    
    % Find the indexes in the full device list (reorder and remove duplicates)
    [ElementList, ii, DeviceIndex] = intersect(ElementList, ElementListTotal);
    if size(ElementList,1) ~= size(ElementListOld,1)
        % All devices must exist (duplicate devices ok)
        [ElementListNotFound, iNotFound] = setdiff(ElementListOld, ElementListTotal);
        if ~isempty(iNotFound)
            % Device not found
            for i = 1:length(iNotFound)
                fprintf('   No devices to get for Family %s(%d)\n', ACCELERATOR_OBJECT.FamilyName, ElementListNotFound(i));
            end
            error(sprintf('%d Devices not found', length(iNotFound)));
        end
    end
    Output = DeviceListTotal(DeviceIndex,:);   % Only data referenced to DeviceList
    Output = Output(j_unique,:);               % Reorder and add multiple elements back
else
    error(sprintf('%s family not found', Family));
end

