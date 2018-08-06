function Field = findfirstfield(Family, ChannelNamesFlag)
%GETFIRSTFIELD - Return the first field of a family that has a .Mode and .Units field
% Field = getfirstfield(Family, ChannelNamesFlag)
%
% ChannelNamesFlag - True, then must also have non-empty ChannelNames field

Field = '';

if nargin < 2
    ChannelNamesFlag = 0;
end

AOStruct = getfamilydata(Family);
if isempty(AOStruct)
    return;
end

FieldNames = fieldnames(AOStruct);
for j = 1:length(FieldNames)
    if ChannelNamesFlag
        % Search for a field that has a .Mode and .Units subfields
        if isfield(AOStruct.(FieldNames{j}),'Mode') && isfield(AOStruct.(FieldNames{j}),'Units') && isfield(AOStruct.(FieldNames{j}),'ChannelNames') && ~isempty(AOStruct.(FieldNames{j}).ChannelNames)
            Field = FieldNames{j};
            break;
        end
    else
        % Search for a field that has a .Mode and .Units subfields
        if isfield(AOStruct.(FieldNames{j}),'Mode') && isfield(AOStruct.(FieldNames{j}),'Units')
            Field = FieldNames{j};
            break;
        end
    end
end
