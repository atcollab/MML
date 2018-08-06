function Test = ismca
%ISMCA - Is MCA being used as the control connection?

if isempty(findstr(lower(which('getpvonline')), 'mca'))
    Test = 0;
else
    Test = 1;
end

