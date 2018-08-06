function Family = gethcmfamily(OneHit)
%GETHCMFAMILY - Returns the default horizontal corrector family
%  Family = gethcmfamily(OneHit)
%
%  INPUTS
%  1. OneHit - If true, return the first family found (Default: true)
%
%  OUTPUTS
%  1. Family - family name is determined by the MemberOf field equal to 'HCM'
%              If OneHit=0, then a cell array of families is returned.
%
%  See also gethbpmfamily, getvbpmfamily, getvcmfamily, findmemberof

%  Written by Greg Portmann


%persistent WarningFlag 

if nargin < 1
    OneHit = 1;
end

Family = findmemberof('HCM', OneHit);

if isempty(Family)
    Family = findmemberof('HCOR', OneHit);
    if isempty(Family)

        fprintf('\n   No default horizontal corrector family has been specified in the MML.\n');
        fprintf('   To define one, add ''HCM'' to the .MemberOf field for the default family.\n\n');
        error('No family found (gethbpmfamily)');

        %if isempty(WarningFlag)
        %    fprintf('\n   No default horizontal corrector family has been specified in the MML.\n');
        %    fprintf('   To define one, add ''HCM'' or ''HCOR'' to the .MemberOf field for the default family.\n\n');
        %    WarningFlag = 1;
        %end
        %Family = {''};
    end
end

if OneHit
    Family = Family{1};
end


