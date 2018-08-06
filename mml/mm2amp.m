function Amps = mm2amp(CMfamily, mm, CMDevList, varargin)
%MM2AMPS - Returns the change in corrector need for a maximum orbit change
%  Amps = mm2amp(CMFamily, mm, CMDevList, varargin)
%
%  INPUTS
%  1. CMFamily - Corrector magnet family name (ex. 'HCM', 'VCM')
%  2. mm - Maximum change in orbit produces by a change in
%           corrector strength of Amps.
%  3. CMDevList - Corrector magnet device list
%  4. varargin - Inputs sent to getrespmat function call
%
%  OUTPUTS
%  1. Amps - Change in corrector magnet strength
%
%  NOTES
%  1. mm and Amps happen to be the hardware units for the ALS.  This function 
%     actually works in whatever the hardware units are for the middlelayer.
%
%  ALGORITHM
%  Based on the response matrix, mm = R * Amps, the maximum change in the
%  orbit due to a corrector change can be found.
%
%  See also amp2mm

%  Written by Greg Portmann


% Input checking
if nargin < 2
    error('Must have at least two inputs (Family & Amps)');
end
if nargin < 3
    CMDevList = [];
end
if isempty(CMDevList)
    CMDevList = family2dev(CMfamily);
end
if (size(CMDevList,1) == 1)
    CMDevList = elem2dev(CMfamily, CMDevList);
end


% Response matrix
if ~isempty(findstr(upper(CMfamily),'H')) || ~isempty(findstr(upper(CMfamily),'X'))
    Smat = getrespmat(gethbpmfamily, [], CMfamily, CMDevList, varargin{:});
elseif ~isempty(findstr(upper(CMfamily),'V')) || ~isempty(findstr(upper(CMfamily),'Y'))
    Smat = getrespmat(getvbpmfamily, [], CMfamily, CMDevList, varargin{:});
else
    error('Not sure if corrector family is horizontal or vertical.');
end


if isempty(mm)
    error('mm is empty');
elseif all(size(mm) == [1 1])
    mm = mm * ones(size(CMDevList,1),1);
elseif size(mm,1) == size(CMDevList,1)
    % input OK
else
    error('Rows of mm must be equal to the rows of CMDevList or a scalar!');
end


% Check for missing correctors
[iFound, iNotFound] = findrowindex(CMDevList, family2dev(CMfamily,0));
if ~isempty(iNotFound)
    error('   Not all correctors found.\n');
end


% Main
for j = 1:size(mm,2)
    for i = 1:size(CMDevList,1)
        Amps(i,j) = mm(i,j) / max(Smat(:,i));
    end
end
