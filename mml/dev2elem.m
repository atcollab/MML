function Output = dev2elem(Family, Field, DevList)
%DEV2ELEM - Converts an element list to a device list
%  ElementList = dev2elem(Family, [Sector Device#])
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
%  1. If DevList is empty, the entire family list will be returned.
%  2. If the device is not found, then an error will occur.
%  3. If the Family is not found, then empty, [], is returned.
%
%  See also elem2dev

%  Written by Greg Portmann


Output = [];

if nargin == 0
	error('DEV2ELEM:  one input required.');
end
if nargin < 2
	Field = '';
end
if nargin < 3
	DevList = [];
end
if isnumeric(Field) && isempty(DevList)
    DevList = Field;
    Field = '';
end
if isempty(DevList)
	DevList = family2dev(Family);
	if isempty(DevList)
		return
	end
end
if size(DevList,2) == 1
    % Assume that the input was already a element list
    Output = DevList;
    return
end

if ~isempty(Field)
    Output = getfamilydata(Family, Field, 'ElementList', DevList);
else
    Output = getfamilydata(Family, 'ElementList', DevList);
end

% [FamilyIndex, ACCELERATOR_OBJECT] = isfamily(Family);
% if FamilyIndex    
%     DeviceList  = ACCELERATOR_OBJECT.DeviceList;
%     ElementList = ACCELERATOR_OBJECT.ElementList;
%     
%     Output = [];
%     for j = 1:size(DevList,1)        
%         ksector = find(DevList(j,1) == DeviceList(:,1));
%         if isempty(ksector)
%             warning(sprintf('Device [%d,%d] not found in Family %s, hence removed from list.', DevList(j,1), DevList(j,2), ACCELERATOR_OBJECT.FamilyName));
%         else
%             k = find(DevList(j,2) == DeviceList(ksector,2));
%             
%             if isempty(k)
%                 warning(sprintf('Device [%d,%d] not found in Family %s, hence removed from list.',DevList(j,1),DevList(j,2),ACCELERATOR_OBJECT.FamilyName));
%             else
%                 Output = [Output; ElementList(ksector(k))];
%             end
%         end
%     end
% else
%     Output = [];
% end

