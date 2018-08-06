function [n,m] = month(d)
% Return the month number, given a string date


if nargin < 1
    d = date;
end

c = datevec(datenum(d));
n = c(:,2);
mths = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';
        'Aug';'Sep';'Oct';'Nov';'Dec'];
n = c(:,2);                          % Extract months
m = mths(c(:,2)+(c(:,2)==0),:);      % Month strings

