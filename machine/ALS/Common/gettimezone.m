function TimeZoneDiff = gettimezone(PVName)
%GETTIMEZONE - Time zone difference from UTC
%  TimeZoneDiff = gettimezone(PVName)

if nargin < 1
    TimeZoneDiff = -8 + isdaylightsavings;
    %if is_Daylight_Savings
    %    TimeZoneDiff = -8;  % Daylight savings
    %else
    %    TimeZoneDiff = -7;
    %end
else
    setpvonline([PVName,'.PROC'], 1);
    pause(.1);  % ???
    [tmp1, tmp2, DataTime] = getpvonline(PVName);
    t0 = clock;
    DateNumber1970 = 719529;  %datenum('1-Jan-1970');
    days = datenum(t0(1:3)) - DateNumber1970;
    t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
    TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
    %DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
end

