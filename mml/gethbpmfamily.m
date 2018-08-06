function Family = gethbpmfamily(OneHit)
%GETHBPMFAMILY - Return the default horizontal BPM family
%  Family = gethbpmfamily(OneHit)
%
%  INPUTS
%  1. OneHit - If true, return the first family found (Default: true)
%
%  OUTPUTS
%  1. Family - family name is determined by the MemberOf field equal to 'HBPM' 
%              If OneHit=0, then a cell array of families is returned.
%
%  See also getvbpmfamily, gethcmfamily, getvcmfamily, findmemberof

%  Written by Greg Portmann


%persistent WarningFlag 

if nargin < 1
    OneHit = 1;
end

Family = findmemberof('HBPM', OneHit);

if isempty(Family)
    Family = findmemberof('BPMx', OneHit);
    if isempty(Family)
        fprintf('\n   No default horizontal BPM family has been specified in the MML.\n');
        fprintf('   To define one, add ''HBPM'' to the .MemberOf field for the default family.\n\n');
        error('No family found (gethbpmfamily)');

        %if isempty(WarningFlag)
        %    fprintf('\n   No default horizontal BPM family has been specified in the MML.\n');
        %    fprintf('   To define one, add ''BPMx'' or ''HBPM'' to the .MemberOf field for the default family.\n\n');
        %    WarningFlag = 1;
        %end
        %Family = {''};
    end
end

if OneHit
    Family = Family{1};
end

