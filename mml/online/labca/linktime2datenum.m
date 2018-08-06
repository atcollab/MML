function DataTime = linktime2datenum(DataTime)

TimeZoneDiff = getfamilydata('TimeZone');

DateNumber1970 = 719529;  %datenum('1-Jan-1970');

if isempty(TimeZoneDiff)
    % The problem with doing this is if the PV wasn't processed in the last .5 hours, it will be treated like a time zone change!!!
    t0 = clock;
    days = datenum(t0(1:3)) - DateNumber1970;
    t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
    TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
end

DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);