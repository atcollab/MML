function  [FamilyName, FieldName] = findmemberof(MemberString, varargin)
%FINDMEMBEROF - Finds all family members
%  [FamilyNameCell, FieldNameCell] = ismemberof(MemberString, OneHit)
%  [FamilyNameCell, FieldNameCell] = ismemberof(MemberString, Field, OneHit)
%
%  INPUTS
%  1. MemberString - Must be a string or cell array of strings
%                    For cell arrays, the lodgic is AND (&&).
%  2. Field - An optional input to only look through subfields.
%             '' or 'AllFieldSearch' searches through all fields
%             If the Field input is not included then only the main 
%             family .MemberOf fields are searched.
%  3. OneHit - If true, return after the first find (Default: false (0))
%
%  OUTPUTS
%  1. FamilyName - Cell array of family names (Column cell)
%                  {} if no member is found
%  2. FieldName - Cell array of field names (Column cell)
%                  {''} empty string if it a main family MemberOf (not a sub-field).
%                  {} if no member is found
%
%  EXAMPLES
%  1. findmemberof('HBPM')
%  2. findmemberof('COR','Horizontal')
%
%  See also getmemberof, ismemberof, isfamily

%  Written by Greg Portmann


if nargin < 1
    error('1 inputs required');
end

OneHit = 0;
Field = '';
if length(varargin) >= 1
    if ischar(varargin{1})
        if isempty(varargin{1})
            Field = 'AllFieldSearch';
        else
            Field = varargin{1};
        end
        if length(varargin) >= 2
            OneHit = varargin{2};
        end
    else
        OneHit = varargin{1};
    end
end


FamilyName = {};
FieldName  = {};

[FamilyList, AO] = getfamilylist('Cell');

if ~isempty(Field)
    % Look for subfield membership
    for i = 1:length(FamilyList)
        Family = FamilyList{i};
        if strcmpi(Field,'AllFieldSearch')
            % Search all fields
            FieldCell = fieldnames(AO.(Family));
        else
            % Only search on 1 field
            FieldCell = {Field};
        end
        for j = 1:length(FieldCell)
            try
                MemberOfField = AO.(Family).(FieldCell{j}).MemberOf;
                if iscell(MemberString)
                    Hit = zeros(length(MemberString),1);
                    for k = 1:length(MemberString)
                        if any(strcmpi(MemberString{k}, MemberOfField))
                            Hit(k) = 1;
                        end
                    end
                    if all(Hit)
                        FamilyName = [FamilyName; {Family}];
                        FieldName = [FieldName; {FieldCell{j}}];
                        if OneHit
                            return
                        end
                    end
                else
                    if any(strcmpi(MemberString, MemberOfField))
                        FamilyName = [FamilyName; {Family}];
                        FieldName = [FieldName; {FieldCell{j}}];
                        if OneHit
                            return
                        end
                    end
                end
            catch
                % Allow for missing .MemberOf fields
            end
        end
    end
else
    % Look for main field membership
    for i = 1:length(FamilyList)
        Family = FamilyList{i};
        try
            % MemberOfField = getfamilydata(Family, 'MemberOf');
            MemberOfField = AO.(Family).MemberOf;

            if iscell(MemberString)
                Hit = zeros(length(MemberString),1);
                for k = 1:length(MemberString)
                    if any(strcmpi(MemberString{k}, MemberOfField))
                        Hit(k) = 1;
                    end
                end
                if all(Hit)
                    FamilyName = [FamilyName; {Family}];
                    FieldName  = [FieldName; {''}];
                end
            else
                % same as, if any(strcmpi(MemberString, getmemberof(Family)))
                if any(strcmpi(MemberString, MemberOfField))
                    FamilyName = [FamilyName; {Family}];
                    FieldName  = [FieldName; {''}];
                    if OneHit
                        return
                    end
                end
            end
        catch
            % Allow for missing .MemberOf fields
        end
    end
end
