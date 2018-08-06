function DataTime = modeltime2datenum(DataTime)

TimeZoneDiff = getfamilydata('TimeZone');
DateNumber1970 = 719529;  %datenum('1-Jan-1970');

if ~isempty(TimeZoneDiff)
    DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
end


