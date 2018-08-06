function b = cell2field(a)
%CELL2FIELD - Converts a cell array to a structure array
%CELL2FIELD - Converts a cell array of MML data structures to a structure
%  b = cell2field(a)
%
%  INPUTS
%  1. a  - cell array of data structures
%
%  OUTPUTS
%  1. b - structure where the first field is the family name
%
%  See also field2cell

%  Written by Greg Portmann


b = [];
for i = 1:length(a)
    if isfield(a{i},'FamilyName')
        if isfield(a{i},'Field')
            b.(a{i}.FamilyName).(a{i}.Field) = a{i};
        else
            b.(a{i}.FamilyName) = a{i};
        end
    else
        error('Cannot convert this cell array to a structure (cell2field)');
    end
end