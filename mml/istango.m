function Test = istango
%ISTANGO - Return true if TANGO is the online method

%  Written by Laurent S. Nadolski
if isempty(findstr(lower(which('getpvonline')), 'tango'))
    Test = 0;
else
    Test = 1;
end

