function [Family, DeviceList, FamilyCell, DeviceListCell, ErrorFlag] = atindex2family(ATIndex, varargin);
%ATINDEX2FAMILY - Returns the AT index for a given family
%  [Family, DeviceList] = atindex2family(ATIndex)
%
%  INPUTS
%  1. ATIndexList - AT indexes referenced to THERING
% 
%  OUTPUTS
%  1. Family - Family Name (first match found)
%  2. DeviceList - Device list (first match found)
%  3. FamilyCell - Family name cell array of all AT index matches 
%  4. DeviceListCell - Device list cell array of all AT index matches

%  Written by Greg Portmann


if nargin == 0,
    error('Must have at least one input (ATIndex).');
end

if isempty(ATIndex)
    Family = ''; 
    DeviceList = [];
    ErrorFlag = -1;
    return;
end


Families = getfamilylist;
FamilyCell = {};
DeviceListCell = {};
iHit = [];
for i = 1:size(Families,1)
    Family = deblank(Families(i,:));
    DeviceList = family2dev(Family, 0);
    try
        [ATIndexList, ErrorFlag] = family2atindex(Family, DeviceList);
        
        [iHit, Col] = find(ATIndex == ATIndexList);
        if ~isempty(iHit)
            FamilyCell = [FamilyCell;{Family}];
            DeviceListCell = [DeviceListCell; {DeviceList(iHit,:)}];
            if nargout < 3
                break;
            end
        end
    catch
    end
end

if isempty(FamilyCell)
    Family = '';
    DeviceList = [];
    ErrorFlag = -1;
else
    Family = FamilyCell{1};
    DeviceList = DeviceListCell{1};
    ErrorFlag = 0;
end

