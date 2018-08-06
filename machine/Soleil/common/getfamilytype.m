function  [FamilyType, FamilyName] = getfamilytype(FamilyName)
%GETFAMILYTYPE - Returns the family type (string matrix)
%  FamilyType = getfamilytype(FamilyName)
% 
%  If FamilyName is a matrix, then a matrix of family types is returned.
%  If the family was not found, then [] is returned
%
%  NOTE
%  1. If no input, then the all families will be returned
%     [FamilyType, FamilyName] = getfamilytype;
%
%  See also isfamily, getfamilylist, findmemberof

%
%  Written by Gregory J. Portmann


AO = getao;

if nargin < 1
    FamilyName = getfamilylist;
    AOFamilyCell = fieldnames(AO);
else
    if isstruct(FamilyName)
        FamilyName = FamilyName.FamilyName;
    end
    AOFamilyCell = {FamilyName};
end

if isempty(AO)
    error('Initialization is needed (aoinit)');
end

FamilyType = [];
for i = 1:size(FamilyName,1)    
    if isfield(AO,deblank(FamilyName(i,:)))
        FamilyType = strvcat(FamilyType, AO.(AOFamilyCell{i}).FamilyType);
    else
        FamilyType = strvcat(FamilyType, ' ');
    end
end

if nargout == 0
    % Print to the screen
    BlankSpaces = ' ';
    if length(FamilyName(1,:)) > 3
        BlankSpaces(1:length(FamilyName(1,:))-2) = ' ';
    end
    fprintf('   #   Name%sType\n', BlankSpaces);
    for i = 1:size(FamilyType,1)
        fprintf('  %2d.  %s  %s\n', i, FamilyName(i,:), FamilyType(i,:));
    end
end

