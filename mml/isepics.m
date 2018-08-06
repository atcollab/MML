function Test = isepics
%ISEPICS - Return true if EPICS is the online method


OnlinePath = lower(which('getpvonline'));

Test = ~isempty(findstr(OnlinePath, 'mcq_asp')) || ~isempty(findstr(OnlinePath, 'labca')) || ~isempty(findstr(OnlinePath, 'sca')) || ~isempty(findstr(OnlinePath, 'mca')) || ~isempty(findstr(OnlinePath, 'slc'));

