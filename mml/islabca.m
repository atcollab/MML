function Test = islabca
%ISLABCA - Is labca being used as the control connection?

if isempty(findstr(lower(which('getpvonline')), 'labca'))
    Test = 0;
else
    Test = 1;
end

