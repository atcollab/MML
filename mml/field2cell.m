function OutputCell = field2cell(InputStruct)
%FIELD2CELL - Converts a structure of MML data structures into a cell array
%  OutputCell = field2cell(InputStruct)
%
%  INPUTS
%  1. InputStruct - structure array
%
%  OUTPUTS
%  2. OutputCell - cell array
%
%  See also cell2field

%  Written by Greg Portmann


OutputCell = [];
FieldNameCell = fieldnames(InputStruct);
j = 0;
for i = 1:length(FieldNameCell)
    % if isfield(InputStruct.(FieldNameCell{i}),'FamilyName')
    % j = j + 1;
    % OutputCell{j} = InputStruct.(FieldNameCell{i});
    % end
    
    if isfield(InputStruct, FieldNameCell{i})
        if isfield(InputStruct.(FieldNameCell{i}),'Data') && isfield(InputStruct.(FieldNameCell{i}),'FamilyName')
            j = j + 1;
            OutputCell{j} = InputStruct.(FieldNameCell{i});
        else
            % Find all the subfields that are data structures
            SubFieldNameCell = fieldnames(InputStruct.(FieldNameCell{i}));
            for ii = 1:length(SubFieldNameCell)
                if isfield(InputStruct.(FieldNameCell{i}).(SubFieldNameCell{ii}),'Data') && isfield(InputStruct.(FieldNameCell{i}).(SubFieldNameCell{ii}),'FamilyName')
                    j = j + 1;
                    OutputCell{j} = InputStruct.(FieldNameCell{i}).(SubFieldNameCell{ii});
                end
            end
        end
    else
        fprintf('   %s field does not exist for family, hence ignored (setmachineconfig)\n', deblank(FieldNameCell{i}));
    end
    
end