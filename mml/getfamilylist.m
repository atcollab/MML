function  [Families, AO] = getfamilylist(OutputFlag)
%GETFAMILYLIST - Returns a list of all the family names 
%
%  [Families, AO] = getfamilylist  (matrix of strings)
%  [Families, AO] = getfamilylist('Cell')  (cell array of strings)
%
%  See also showao, showfamily, isfamily

%  Written by Greg Portmann


if nargin == 0
    OutputFlag = 'Matrix';
end

AO = getao;

if isempty(AO)
    error('Initialization is needed (aoinit)');
end

if strcmpi(OutputFlag, 'Cell')
    % Cell array output
    Families = fieldnames(AO);
else
    % Matrix output
    Families = [];
    AOFamilyCell = fieldnames(AO);
    for i = 1:length(AOFamilyCell)
        Families = strvcat(Families, AOFamilyCell{i});
    end
end


if nargout == 0
    % Print to the screen
    for i = 1:size(Families,1)
        if strcmpi(OutputFlag, 'Cell')
            fprintf('  %2d.  %s\n', i, Families{i});
        else
            fprintf('  %2d.  %s\n', i, deblank(Families(i,:)));
        end
    end
end

