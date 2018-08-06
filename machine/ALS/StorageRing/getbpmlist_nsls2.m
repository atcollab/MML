function [DevNSLS2, DevOther, i, j] = getbpmlist_nsls2(Dev)

% List of NSLS2-style BPMs
BPMList = [
     1     3
     1     8
     1     9
     2     3
     2     8
     3     3
     3     8
     3     9
     4     2
     4     3
     4     8
     4     9
     5     2
     5     3
     5     8
     5     9
     6     2
     6     3
     6     8
     6     9
     7     2
     7     3
     7     8
     7     9
     8     2
     8     3
     8     8
     8     9
     9     2
     9     3
     9     8
     9     9
    10     2
    10     3
    10     8
    10     9
    11     2
    11     3
    11     8
    11     9
    12     2
    12     3
    12     8
];

% note: this function assumes this Dev is an actual list of BPMs
if nargin < 1
    DevNSLS2 = BPMList;
else
    [i, iNotFound, iFoundList1] = findrowindex(BPMList, Dev);
    j = (1:size(Dev,1))';
    j(i) = [];
    DevNSLS2 = Dev(i,:);
    DevOther = Dev(j,:);
end