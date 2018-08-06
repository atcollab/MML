function [AM, DataTime] = umergetpvonline(ChannelNames)
% UMER uses an http web server (run by Django) to get/set magnet values from a
% central server/computer that has access to all power supplies
%
ad = getad;
% server address
server = ad.server;
% command
command = 'ReadCurrents/';

% grab setpoints from operationsettings file
% just grab the first file in the folder, for now...
%
% data root
setpoints = umerbuildsetpoints();

AM = zeros(length(ChannelNames),1);
DataTime = zeros(length(ChannelNames),1);

for i = 1:length(ChannelNames)
    if strcmp(ChannelNames{i}(1:3),'Mon') % if monitor value, do a get current
        try
            AM(i) =  str2num(urlread([server,command,ChannelNames{i}(4:end)],'Timeout',3));
        end
    elseif strcmpi(ChannelNames{i}(1:3),'Set') % if setpoint, grab value from ops file
        try
            idx=strcmp( cellfun( @(S) S.Name, setpoints, 'uni', false ), {ChannelNames{i}(4:end)} );
            AM(i) = setpoints{idx}.Current;
        end
    elseif strcmpi(ChannelNames{i}(1:2),'RC') % BPM data
        bpm = get_bpm(str2num(ChannelNames{i}(3:end-1)),1); % default returns 1 turn of data
        % check if request was for x or y data
        if strcmpi(ChannelNames{i}(end),'x')
            AM(i) = bpm.X;
        elseif strcmpi(ChannelNames{i}(end),'y')
            AM(i) = bpm.Y;
        end
    end
    t1 = clock;
    days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
    tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
    DataTime(i) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
end

end