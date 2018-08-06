function eFlag = umersetpvonline(ChannelNames,NewSP)
% UMER uses an http web server (run by Django) to grab/set magnet values from a
% central server/computer that is connected to all power supplies
%
ad = getad;

% server address
server = ad.server;
% command
command = 'InitMagnets/';

eFlag = 0;
for i = 1:length(ChannelNames)
    if strcmp(ChannelNames{i}(1:3),'Mon')
        try
            urlread([server,command,ChannelNames{i}(4:end),filesep,num2str(NewSP(i))],'Timeout',1);
        catch
            eFlag = 1;
        end
    end
end

end