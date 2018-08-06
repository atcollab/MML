function FamilyNameCell = fieldnames(DataObj)
%FIELDNAMES - Returns a cell array of field names for the 
%             non-empty structures in the middle layer data object (AccObj)
%
%  Written by Greg Portmann


% Don't do this because stuct uses fieldnames
%DataStruct = struct(DataObj);  

% Note: the AO is a matlab structure
FamilyNameCell = fieldnames(getao);


for i = length(FamilyNameCell):-1:1
    if isempty(DataObj.(FamilyNameCell{i}))
        FamilyNameCell(i) = [];
    end
end