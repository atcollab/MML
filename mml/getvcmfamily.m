function Family = getvcmfamily(OneHit)
%GETVCMFAMILY - Returns the default vertical corrector family
%  Family = getvcmfamily(OneHit)
%
%  INPUTS
%  1. OneHit - If true, return the first family found (Default: true)
%
%  OUTPUTS
%  1. Family - family name is determined by the MemberOf field equal to 'VCM' 
%              If OneHit=0, then a cell array of families is returned.
%
%  See also gethbpmfamily, getvbpmfamily, gethcmfamily, findmemberof

%  Written by Greg Portmann


%persistent WarningFlag 

if nargin < 1
    OneHit = 1;
end

Family = findmemberof('VCM', OneHit);

if isempty(Family)
    Family = findmemberof('VCOR', OneHit);
    if isempty(Family)
        
        fprintf('\n   No default vertical corrector family has been specified in the MML.\n');
        fprintf('   To define one, add ''VCM'' to the .MemberOf field for the default family.\n\n');
        error('No family found (getvcmfamily)');

        %if isempty(WarningFlag)
        %    fprintf('\n   No default vertical corrector family has been specified in the MML.\n');
        %    fprintf('   To define one, add ''VCM'' or ''VCOR'' to the .MemberOf field for the default family.\n\n');
        %    WarningFlag = 1;
        %end
        %Family = {''};
    end
end

if OneHit
    Family = Family{1};
end



% [FamilyList, AO] = getfamilylist('Cell');
% for i = 1:size(FamilyList,1)
%     Family = deblank(FamilyList(i,:));
%     if any(strcmpi('VCM', AO.(FamilyList{i}).MemberOf))
%         Family = FamilyList{i};
%         break;
%     end
% end