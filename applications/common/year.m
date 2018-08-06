function y = year(d)
% Return the year, given a string date

if nargin < 1
    d = date;
end

c = datevec(datenum(d));
y = c(:,1);
