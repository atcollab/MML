function TimeZoneDiff = gettimezone(PVName)
%GETTIMEZONE - Time zone difference from UTC
%  TimeZoneDiff = gettimezone(PVName)

TimeZoneDiff = 0;

% if nargin < 1
%     TimeZoneDiff = 2;
% else
%     [tmp1, tmp2, DataTime] = getpvonline(PVName);
%     t0 = clock;
%     DateNumber1970 = 719529;  %datenum('1-Jan-1970');
%     days = datenum(t0(1:3)) - DateNumber1970;
%     t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
%     TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
% end

