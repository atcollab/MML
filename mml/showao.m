function showao(Family)
%SHOWAO - Display the AcceleratorObjects fields that have get or set capability
%
%  INPUTS
%  1. Family - Family Name
%
%  See also getfamilylist, showfamily, isfamily, getfamilytype


%  Written by Greg Portmann
%  Modified by Laurent S. Nadolski
%    Added TangoNames

ao = getao;
if nargin < 1
    FieldNameCell = fieldnames(ao);
else
    FieldNameCell = {Family};
end

for i = 1:length(FieldNameCell)
    if isfield(ao, FieldNameCell{i})
        if isfield(ao.(FieldNameCell{i}),'FamilyName')
            fprintf('Family = %s\n', ao.(FieldNameCell{i}).FamilyName);
        end
        % Find all the subfields that are data structures
        SubFieldNameCell = fieldnames(ao.(FieldNameCell{i}));
        for ii = 1:length(SubFieldNameCell)
            if isfield(ao.(FieldNameCell{i}).(SubFieldNameCell{ii}),'ChannelNames')  ...
                    || isfield(ao.(FieldNameCell{i}).(SubFieldNameCell{ii}),'TangoNames')  ...
                    || isfield(ao.(FieldNameCell{i}).(SubFieldNameCell{ii}),'SpecialFunction')  ...
                    || isfield(ao.(FieldNameCell{i}).(SubFieldNameCell{ii}),'SpecialFunctionGet')  ...
                    || isfield(ao.(FieldNameCell{i}).(SubFieldNameCell{ii}),'SpecialFunctionSet')
                fprintf('%s.%s\n', ao.(FieldNameCell{i}).FamilyName, SubFieldNameCell{ii});
            end
        end
        fprintf('\n');
    end
end