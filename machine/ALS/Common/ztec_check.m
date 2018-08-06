function [Wave1Counter] = ztec_check(ScopeName)


if nargin == 0
    % 'ztec10' update every 1.4 seconds
    % 'ztec1', 'ztec6', 'ztec7', 'ztec8','ztec11','ztec12' update with top-off
    % 'ztec9' spare
    ScopeName = {'ztec1', 'ztec2', 'ztec3', 'ztec4','ztec5', 'ztec6', 'ztec7', 'ztec8', 'ztec9', 'ztec10','ztec11','ztec12','ztec13', 'ztec14'}; %  ,'ztec15'
end


for i = 1:length(ScopeName)
    try
        setpvonline([ScopeName{i},':UtilID.PROC'], 1);
    catch ME        
        fprintf(' Error on scope %s %s\n', ScopeName{i}, ME.message);
    end
end


fprintf('                 Time\n');
for i = 1:length(ScopeName)
    try
        [UtilID, tmp, DataTime] = getpvonline([ScopeName{i},':UtilID']);
        Wave1Counter(i,1)       = getpvonline([ScopeName{i},':Inp1WaveCount']);
        DataTime = linktime2datenum(DataTime);
        %DataTime = EPICS2MatlabTime(DataTime);
        DataTimeStr = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
        fprintf('   %s %s %6s %7d\n', DataTimeStr, UtilID, ScopeName{i}, Wave1Counter(i));
    catch ME        
        fprintf(' Error on scope %s %s\n', ScopeName{i}, ME.message);
    end
end

% 
% function DataTime = EPICS2MatlabTime(DataTime)
% t0 = clock;
% DateNumber1970 = 719529;  %datenum('1-Jan-1970');
% days = datenum(t0(1:3)) - DateNumber1970;
% t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
% 
% % 0 is UTC
% TimeZoneDiff = 0;
% %TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
% % if abs(TimeZoneDiff)>10
% %     % Typically -7 (daylight savings) or -8 hours
% %     fprintf('   TimeZoneDiff=%f hours???\n', TimeZoneDiff);
% % end
% % if ~(TimeZoneDiff==-7 || TimeZoneDiff==-8)
% %     % Typically -7 (daylight savings) or -8 hours
% %     fprintf('   TimeZoneDiff=%f hours, reset to zero (UTC)!\n', TimeZoneDiff);
% %     TimeZoneDiff = 0;
% % end
% 
% DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
