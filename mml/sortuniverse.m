function [U, iSort] = sortuniverse(UFields, C, U)
% [U, iSort] = sortuniverse(UFields, Constraint, U)
%
%  INPUTS
%  1. UFields - Fields of the universe to constrain
%  2. Constraint - if one constraint variable, then search within +/- of the constraint 
%                                              abs(U.(UFields)) < abs(Constraint)
%                  if two constraint variables, then search within variable boundary
%                                               Constraint(1) <= U.(UFields) <= Constraint(2)
%  3. U - The universe {Default: getuniverse}
%
%  EXAMPLES
%  1. [U, iSort] = sortuniverse({'SigmaXStraight','SigmaXB1','SigmaXB2','BetaYStraight'}, {300,400,300,10});
%  2. [U, iSort] = sortuniverse({'SigmaXStraight','SigmaXB1','QF'}, {[250 300],400,[0 2.5]});
%
%  See also sortuniversedominant

%  Written by Greg Portmann


% Load universe data
if nargin < 3
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
    return;
    %UFields = {'SigmaXStraight','SigmaXB1','SigmaXB2','BetaYStraight'};
end

% Input #2 must be constant or a cell array of constants
if nargin < 2
    C = [];
end
if ~iscell(C)
    C = {C};
end
if isempty(C) || isempty(C{1})
    %return;
    %C = {300,400,300,10}
end


% Sort the population
iSort = ones(length(U.(UFields{1})),1);
for i = 1:length(UFields)
    if length(C{i}) == 1
        iSort = iSort & abs((U.(UFields{i})) <= abs(C{i}));
    elseif length(C{i}) > 1
        iSort = iSort & (C{i}(1) <= U.(UFields{i})) & (U.(UFields{i}) <= C{i}(2));
    end
end
iSort = find(iSort);

fprintf('   %d lattices found (sortuniverse)\n', length(iSort));


UFields = fieldnames(U);
for i = 1:length(UFields)
    U.(UFields{i}) = U.(UFields{i})(iSort);
end

