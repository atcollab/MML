function Out = open_jh_scrapers(Command)
%
%
% See also close_jh_scrapers


% setpv('TOPSCRAPER', 'Setpoint', 4.91, [1 1], 0);
% setpv('TOPSCRAPER', 'Setpoint', 5.64, [2 1], 0);
% setpv('TOPSCRAPER', 'Setpoint', 8.57, [2 6], 0);
% setpv('TOPSCRAPER', 'Setpoint', 0, [3 1], 0);
% setpv('TOPSCRAPER', 'Setpoint', 4.91, [12 6], 0);
% 
% setpv('BOTTOMSCRAPER', 'Setpoint', 6.42, [1 1], 0);
% setpv('BOTTOMSCRAPER', 'Setpoint', 4.62, [2 1], 0);
% setpv('BOTTOMSCRAPER', 'Setpoint', 0, [3 1], 0);


if nargin < 1
    Command = 'Set';
end


% Open positions 
Top = [
    4.91, [ 1 1]
    5.64, [ 2 1]
    8.575, [ 2 6]
    0.00, [ 3 1]
    4.91, [12 6]
    ];

Bottom = [
    6.42, [1 1]
    5.69, [2 1]
    0.00, [3 1]
    ];


% Set
if strcmpi(Command, 'Set')
    % Note: use EPICS NoWaitFlag=1
    % setpvonline(ChannelNames, NewSP, 'double', NoWaitFlag)
    ChannelNamesTop = family2channel('TOPSCRAPER', 'Setpoint', Top(:,2:3));
    setpvonline(ChannelNamesTop, Top(:,1), 'double', 1);
    
    ChannelNamesBottom = family2channel('BOTTOMSCRAPER', 'Setpoint', Bottom(:,2:3));
    setpvonline(ChannelNamesBottom, Bottom(:,1), 'double', 1);

    setpvonline(ChannelNamesTop, Top(:,1), 'double', 0);
    setpvonline(ChannelNamesBottom, Bottom(:,1), 'double', 0);
end


% Check if open
ChannelNames = family2channel('TOPSCRAPER', 'Monitor', Top(:,2:3));
TopAM = getpvonline(ChannelNames);
TopOpen = all(abs(Top(:,1)-TopAM) < .1);

ChannelNames = family2channel('BOTTOMSCRAPER', 'Monitor', Bottom(:,2:3));
BottomAM = getpvonline(ChannelNames);
BottomOpen = all(abs(Bottom(:,1)-BottomAM) < .2);

Out = all([TopOpen BottomOpen]);


