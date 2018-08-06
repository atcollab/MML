function [Num] = mon2num(month)
%MON2NUM - Converts month (string) to month number
%  [Num] = mon2num(month)

month = lower(month);
month(1) = upper(month(1));

if strcmp(month, 'Jan')
  Num = 1;
elseif strcmp(month, 'Feb')
  Num = 2;
elseif strcmp(month, 'Mar')
  Num = 3;
elseif strcmp(month, 'Apr')
  Num = 4;
elseif strcmp(month, 'May')
  Num = 5;
elseif strcmp(month, 'Jun')
  Num = 6;
elseif strcmp(month, 'Jul')
  Num = 7;
elseif strcmp(month, 'Aug')
  Num = 8;
elseif strcmp(month, 'Sep')
  Num = 9;
elseif strcmp(month, 'Oct')
  Num = 10;
elseif strcmp(month, 'Nov')
  Num = 11;
elseif strcmp(month, 'Dec')
  Num = 12;

elseif strcmp(month, 'January')
  Num = 1;
elseif strcmp(month, 'February')
  Num = 2;
elseif strcmp(month, 'March')
  Num = 3;
elseif strcmp(month, 'April')
  Num = 4;
elseif strcmp(month, 'May')
  Num = 5;
elseif strcmp(month, 'June')
  Num = 6;
elseif strcmp(month, 'July')
  Num = 7;
elseif strcmp(month, 'August')
  Num = 8;
elseif strcmp(month, 'September')
  Num = 9;
elseif strcmp(month, 'October')
  Num = 10;
elseif strcmp(month, 'November')
  Num = 11;
elseif strcmp(month, 'December')
  Num = 12;

elseif strcmp(month, 'Sept')
  Num = 9;
else 
  error('Problem identifying the month.')
end


