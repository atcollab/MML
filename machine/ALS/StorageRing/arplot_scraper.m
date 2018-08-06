
arread('20071210');
%arread('20090504');


figure;

subplot(3,1,1)
%ChannelName = family2channel('TOPSCRAPER','Setpoint')
ChannelName = family2channel('TOPSCRAPER')
Top = arplot(ChannelName);
legend(ChannelName);

subplot(3,1,2)
ChannelName = family2channel('BOTTOMSCRAPER')
Bottom = arplot(ChannelName);
legend(ChannelName);

subplot(3,1,3)
ChannelName = family2channel('INSIDESCRAPER')
Inside = arplot(ChannelName);
legend(ChannelName,'Interpret','None');
ylabel('');


Top(:,1)
Bottom(:,1)
Inside(:,1)