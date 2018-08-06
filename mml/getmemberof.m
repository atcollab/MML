function  MemberOfCell = getmemberof(FamilyName, Field)
%GETMEMBEROF - Returns the membership information of a family (cell of strings)
%  MemberOfCell = getmemberof(FamilyName)
%  MemberOfCell = getmemberof(FamilyName, Field)
%
%  If FamilyName is a matrix, then a column of cells is returned.
%  If the family was not found, then {[]} is returned
%  An optional Field input can be used to only look through subfields.
%
%  NOTES
%  1. If no input, then the all families will be returned
%     MemberOfCell = getmemberof;
%  2. If no output, then the MemberOf strings will be printed to the screen
%
%  See also ismemberof, findmemberof, isfamily, getfamilylist

%  Written by Greg Portmann


if nargin < 1
    FamilyName = getfamilylist;
end


MemberOfCell = {};
for i = 1:size(FamilyName,1)
    Family = deblank(FamilyName(i,:));
    if nargin >= 2
        if size(Field,1) == 1
            a = getfamilydata(Family, deblank(Field), 'MemberOf');
        else
            a = getfamilydata(Family, deblank(Field(i,:)), 'MemberOf');
        end
    else
        a = getfamilydata(Family, 'MemberOf');
    end
    MemberOfCell{i,1} = a(:)';
end


if nargout == 0
    % Print to the screen
    if nargin == 1
        fprintf('   #  Family:    Memberships \n');
    else
        fprintf('   #  Family.Field:    Memberships \n');
    end
    for i = 1:size(MemberOfCell,1)
        if nargin == 1
            fprintf('  %2d. %s:', i, deblank(FamilyName(i,:)));
        else
            if size(Field,1) == 1
                fprintf('  %2d. %s.%s:', i, deblank(FamilyName(i,:)), deblank(Field));
            else
                fprintf('  %2d. %s.%s:', i, deblank(FamilyName(i,:)), deblank(Field(i,:)));
            end
        end
        Members = MemberOfCell{i};
        for j = 1:length(Members)
            fprintf('  "%s"', Members{j});
        end
        fprintf(' \n');
    end
else
    % For one family, returns a cell array, not cell array of cell arrays
    if length(MemberOfCell) == 1
        MemberOfCell = MemberOfCell{1};
    end
end
