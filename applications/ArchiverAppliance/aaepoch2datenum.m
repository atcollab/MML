function aa = aaepoch2datenum(aa)

DateNumber1970 = 719529;  %datenum('1-Jan-1970');

if isstruct(aa)
    TimeZoneDiff = (double(aa.data.isDST) - 8) / 24;

    SecondsDateNum  = double(aa.data.epochSeconds)/60/60/24;
    nSecondsDateNum = double(aa.data.nanos)/1e9/60/60/24;    
    aa.data.datenum = SecondsDateNum + nSecondsDateNum + DateNumber1970 + TimeZoneDiff;
    
    %datestr(aaDateNum(1), 'yyyy-mm-dd HH:MM:SS.FFF')
    %datestr(aaDateNum(end), 'yyyy-mm-dd HH:MM:SS.FFF')
else
    
end



%  This is what labca2datenum does.  AA is already in local time.
% TimeZoneDiff = getfamilydata('TimeZone')
% 
% DateNumber1970 = 719529;  %datenum('1-Jan-1970');
% 
% if isempty(TimeZoneDiff)
%     % The problem with doing this is if the PV wasn't processed in the last .5 hours, it will be treated like a time zone change!!!
%     t0 = clock;
%     days = datenum(t0(1:3)) - DateNumber1970;
%     t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
%     TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
% end
% 
% DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);