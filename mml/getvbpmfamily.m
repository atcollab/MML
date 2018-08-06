function Family = getvbpmfamily(OneHit)
%GETVBPMFAMILY - Return the default vertical BPM family
%  Family = getvbpmfamily(OneHit)
%
%  INPUTS
%  1. OneHit - If true, return the first family found (Default: true)
%
%  OUTPUTS
%  1. Family - family name is determined by the MemberOf field equal to 'VBPM' 
%              If OneHit=0, then a cell array of families is returned.
%
%  See also gethbpmfamily, gethcmfamily, getvcmfamily, findmemberof

%  Written by Greg Portmann


%persistent WarningFlag 

if nargin < 1
    OneHit = 1;
end

Family = findmemberof('VBPM', OneHit);

if isempty(Family)
    Family = findmemberof('BPMy', OneHit);
    if isempty(Family)
        fprintf('\n   No default vertical BPM family has been specified in the MML.\n');
        fprintf('   To define one, add ''VBPM'' to the .MemberOf field for the default family.\n\n');
        error('No family found (getvbpmfamily)');

        %if isempty(WarningFlag)
        %    fprintf('\n   No default vertical BPM family has been specified in the MML.\n');
        %    fprintf('   To define one, add ''BPMy'' or ''VBPM'' to the .MemberOf field for the default family.\n\n');
        %    WarningFlag = 1;
        %end
        %Family = {''};
    end
end

if OneHit
    Family = Family{1};
end

