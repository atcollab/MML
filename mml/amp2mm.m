function mm = amp2mm(CMfamily, Amps, CMDevList, varargin)
%AMPS2MM - Returns the maximum millimeter orbit change per change in corrector
%  mm = amps2mm(CMFamily, Amps, CMDevList, varargin)
%
%  INPUTS
%  1. CMFamily - Corrector magnet family name (ex. 'HCM', 'VCM')
%  2. Amps - Change in corrector magnet strength
%  3. CMDevList - Corrector magnet device list
%  4. varargin - Inputs sent to getrespmat function call
%
%  OUTPUTS
%  1. mm - Maximum change in orbit produces by a change in
%          corrector strength of Amps.
%
%  NOTES
%  1. mm and Amps happen to be the hardware units for the ALS.  This function 
%     actually works in whatever the hardware units are for the middlelayer.
%
%  ALGORITHM
%  Based on the response matrix, mm = R * Amps, the maximum change in the
%  orbit due to a corrector change can be found.
%
%  See also mm2amp

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


if isempty(Amps)
    error('Amps is empty');
elseif all(size(Amps) == [1 1])
    Amps = Amps * ones(size(CMDevList,1),1);
elseif size(Amps,1) == size(CMDevList,1)
    % input OK
else
    error('Rows of Amps must be equal to the rows of CMDevList or a scalar!');
end


% Check for missing correctors
[iFound, iNotFound] = findrowindex(CMDevList, family2dev(CMfamily,0));
if ~isempty(iNotFound)
    error('   Not all correctors found.\n');
end


% Main
for j = 1:size(Amps,2)
    for i = 1:size(CMDevList,1)
        mm(i,j) = Amps(i,j) * max(Smat(:,i));
    end
end

