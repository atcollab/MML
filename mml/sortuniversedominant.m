function [U, iDominate, Population] = sortuniversedominant(UFields, U)
% [U, iDominate] = sortuniversedominant(UFields, U)
%
%  INPUTS
%  1. UFields - Fields of the universe to constrain
%  2. U - The universe {Default: getuniverse}
%
%  EXAMPLES
%  1. [U, iDominate] = sortuniversedominant({'SigmaXStraight','SigmaXB1','SigmaXB2','BetaYStraight'});
%
%  See also sortuniverse

%  Written by Greg Portmann


% Load universe data
if nargin < 2
    U = getuniverse;
end


% Input #1 must be 1 string or a cell array of strings
if nargin < 1
    UFields = '';
end
if ~iscell(UFields)
    UFields = {UFields};
end
if isempty(UFields) || isempty(UFields{1})
    %return;
    UFields = {'SigmaXStraight','SigmaXB2','BetaYStraight'};
    %UFields = fieldnames(U);
end


% Row sort the population
Population = U.(UFields{1});
for i = 2:length(UFields)
    Population = [Population U.(UFields{i})];
end
[Population, iDominate] = sortrows(Population, 1:size(Population,2));


% % Dim = 2
% j = 1;
% while j < size(Population,1)
%     iLessDominate = find(Population(j+1:end,2) >= Population(j,2));
%     Population(iLessDominate+j,:) = [];   
%     iDominate(iLessDominate+j) = [];
%     j = j + 1;
% end


% All dimensions
j = 1;
while j < size(Population,1)
    iLessDominate = Population(j+1:end,2) >= Population(j,2);
    for iCol = 3:size(Population,2)
        iLessDominate = iLessDominate & (Population(j+1:end,iCol) >= Population(j,iCol));
    end
    iLessDominate = find(iLessDominate);
    Population(iLessDominate+j,:) = [];   
    iDominate(iLessDominate+j) = [];
    j = j + 1;
end


% Remove equals
isame = find(all(diff(Population,1,1)==0,2)==1)+1;
Population(isame,:) = [];
iDominate(isame) = [];


%[iDominate Population]
iDominate = iDominate(:);
fprintf('   %d lattices found (sortuniversedominant)\n', length(iDominate));


UFields = fieldnames(U);
for i = 1:length(UFields)
    U.(UFields{i}) = U.(UFields{i})(iDominate);
end


