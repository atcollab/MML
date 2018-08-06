function [month, day, year] = date2mdy(d)
%DATE2MDY - Convert a Matlab date format to month, day, year
%  [month, day, year] = date2mdy(Date)
%
%  Date is the date format is in the matlab function DATE


if nargin == 0
    d = date;
end


i = 1;
while d(i) ~= '-'
  day(1,i) = d(i);
  i = i + 1;
end
day = str2num(day);


i = i + 1;
while d(i) ~= '-'
  month = [month d(i)];
  i = i + 1;
end

if month == 'Jan'
  month = 1;
elseif month == 'Feb'
  month = 2;
elseif month == 'Mar'
  month = 3;
elseif month == 'Apr'
  month = 4;
elseif month == 'May'
  month = 5;
elseif month == 'Jun'
  month = 6;
elseif month == 'Jul'
  month = 7;
elseif month == 'Aug'
  month = 8;
elseif month == 'Sep'
  month = 9;
elseif month == 'Oct'
  month = 10;
elseif month == 'Nov'
  month = 11;
elseif month == 'Dec'
  month = 12;
else 
  error('Problem identifying the month')
end


i = i + 1;
year = d(1,i:size(d,2));
year = str2num(year);

