function Out = close_jh_scrapers(Command)
%
%
% See also open_jh_scrapers


if nargin < 1
    Command = 'Set';
end


% Note: use EPICS NoWaitFlag=1
% setpvonline(ChannelNames, NewSP, 'double', NoWaitFlag)
Top = getproductionlattice('TOPSCRAPER');
Top = Top.Setpoint;
ChannelNames = family2channel(Top.FamilyName, Top.Field, Top.DeviceList);

% Set
if strcmpi(Command, 'Set')
    setpvonline(ChannelNames, Top.Data, 'double', 1);
end

Bot = getproductionlattice('BOTTOMSCRAPER');
Bot = Bot.Setpoint;
ChannelNames = family2channel(Bot.FamilyName, Bot.Field, Bot.DeviceList);

% Set
if strcmpi(Command, 'Set')
    setpvonline(ChannelNames, Bot.Data, 'double', 1);
end

% Check if closed
ChannelNames = family2channel('TOPSCRAPER', 'Monitor', Top.DeviceList);
TopAM = getpvonline(ChannelNames);
TopOpen = all(abs(Top.Data-TopAM) < .1); 

ChannelNames = family2channel('BOTTOMSCRAPER', 'Monitor', Bot.DeviceList);
BottomAM = getpvonline(ChannelNames);
BottomOpen = all(abs(Bot.Data-BottomAM) < .2);

Out = all([TopOpen BottomOpen]);


