function  [IsTest, Index] = ismemberof(FamilyName, Field, MemberString)
%ISMEMBEROF - Returns turn if the membership information of a family (cell of strings)
%  [MemberOfBooleanVector, Index] = ismemberof(FamilyName, MemberString)
%  [MemberOfBooleanVector, Index] = ismemberof(FamilyName, Field, MemberString)
% 
%  INPUTS
%  1. FamilyName - Family name
%                  If FamilyName is a matrix, then a column of individual ismemberof calls is returned.
%                  If the family was not found, then [] is returned.
%  2. Field - Used to only look through subfields (optional)
%  3. MemberString - Member of string to search over
%
%  See also getmemberof, findmemberof, isfamily

%  Written by Greg Portmann


if nargin < 2
    error('2 or 3 inputs required');
end
if nargin == 2
    MemberString = Field;
end

if isstruct(FamilyName)
    if isfield(FamilyName, 'FamilyName')
        FamilyName = FamilyName.FamilyName;
    else
        error('For structure inputs, FamilyName field must exist');
    end
end


IsTest = [];
Index = [];
for i = 1:size(FamilyName,1)
    Family = deblank(FamilyName(i,:));
    if nargin == 2
        IsTest(i,1) = any(strcmpi(MemberString, getmemberof(Family)));
    else
        IsTest(i,1) = any(strcmpi(MemberString, getmemberof(Family, Field)));
    end
    if IsTest(i,1) == 1
        Index = [Index; i];
    end
end
