function dom = day(d)
% Return the day of the month, given a string date

if nargin < 1
    d = date;
end

c = datevec(datenum(d));
dom = c(3);
