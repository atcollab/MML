function [iFound, iNotFound, iFoundList1] = findrowindex(List1, List2)
%FINDROWINDEX
%  [iFound, iNotFound, iFoundList1] = findrowindex(List1, List2)
%
%  INPUTS
%  1. List1 and List2 are matrices with the same number of columns.
%     This function return the row indicies where each row of List1
%     is found in List2.
%
%  OUTPUTS
%  1. iFound are the row numbers of List2 where a row of List1 was found.
%     If there are multiple matches, then only the smallest index is used.
%  2. iNotFound are the row number of List1 which was not found in List2.
%  3. iFoundList1 are the indicies of List1 where List1 rows were found in List2 
%     length(iFoundList1) always equals the length(iFound), iFoundList1 just
%     references List1.
%
%  If all the rows of List1 are also in List2, then
%  List1 = List2(iFound,:)
%  If not, 
%  List1(iFoundList1,:) = List2(iFound,:)

%  Written by Greg Portmann

%  History
%  2016-07-13 -> Commented lines 38-40, I don't think List1 and List2 have to be equal columns


iFound = [];
iNotFound = [];
iFoundList1 = [];

if isempty(List1) || isempty(List2)
    return
end

N = size(List1,2);

% if N ~= size(List2,2)
%     error('List1 and List2 must have the same number of columns');    
% end

for i = 1:size(List1,1)
    % Make N = 1 or 2 a special case for speed reasons (this may not be true or required)
    if N == 1
        k = find(List1(i)==List2);
    elseif N == 2
        k = find(List1(i,1)==List2(:,1) & List1(i,2)==List2(:,2));
    else
        k = (List1(i,1)==List2(:,1));
        for j = 2:N
            k = k & (List1(i,j)==List2(:,j));
        end
        k = find(k);
    end
    
    if isempty(k)
        iNotFound = [iNotFound; i];
    else
        iFound = [iFound; k(1)];        
        iFoundList1 = [iFoundList1; i];
    end
end


% member = ismember(List2,List1,'rows');
% %DeviceListTotal(member,:);
% iFound = find(member);
% iNotFound = [];


% The unique and intersect method seems to be a little slower
%
% % Intersect removes duplicate devices so first store index of how to unsort in j_unique 
% DeviceListOld = List1;
% [List1, i_unique, j_unique] = unique(List1, 'rows');        
% 
% % Find the indexes in the full device list (reorder and remove duplicates)
% [List1, ii, DeviceIndex] = intersect(List1, List2, 'rows');
% if size(List1,1) ~= size(DeviceListOld,1)
%     % All devices must exist (duplicate devices ok)
%     [DeviceListNotFound, iNotFound] = setdiff(DeviceListOld, List2, 'rows');
%     %if length(iNotFound) > 0
%     %    % Device not found
%     %    for i = 1:length(iNotFound)
%     %        fprintf('   No devices to get for (%d,%d)\n', DeviceListNotFound(i,1), DeviceListNotFound(i,2));
%     %    end
%     %    error(sprintf('%d Devices not found', length(iNotFound)));
%     %end
% end
% iFound = DeviceIndex(j_unique);   % Reorder and add multiple elements back

