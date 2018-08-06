%% Read
d = readcheckerfile;


%% Booster
iBR = strmatch('BR1', d.ChannelName);

% IP
i = strmatch('BR1_____IP', d.ChannelName(iBR,:));
iBR_IP = iBR(i);

i = strmatch('BC*', d.Ext(iBR_IP,:));
iBR_IP_BC = iBR_IP(i);
d.ChannelName(iBR_IP_BC,:)


% IG
i = strmatch('BR1_____IG', d.ChannelName(iBR,:));
iBR_IG = iBR(i);

i = strmatch('BC*', d.Ext(iBR_IG,:));
iBR_IG_BC = iBR_IG(i);
d.ChannelName(iBR_IG_BC,:)


% VVR
i = strmatch('BR1_____VVR', d.ChannelName(iBR,:));
iBR_VVR = iBR(i);

i = strmatch('BC*', d.Ext(iBR_VVR,:));
iBR_VVR_BC = iBR_VVR(i);
d.ChannelName(iBR_VVR_BC,:)



%% Storage Ring
iSR = strmatch('SR', d.ChannelName(:,1:2));

i = strmatch('IP', d.ChannelName(iSR,9:10));
iSR_IP = iSR(i);

i = strmatch('BC*', d.Ext(iSR_IP,:));
iSR_IP_BC = iSR_IP(i);
d.ChannelName(iSR_IP_BC,:)


i = strmatch('IG', d.ChannelName(iSR,9:10));
iSR_IG = iSR(i);

i = strmatch('BC*', d.Ext(iSR_IG,:));
iSR_IG_BC = iSR_IG(i);
d.ChannelName(iSR_IG_BC,:)


% VVR
i = strmatch('VVR', d.ChannelName(iSR,9:11));
iSR_VVR = iSR(i);

i = strmatch('BC*', d.Ext(iSR_VVR,:));
iSR_VVR_BC = iSR_VVR(i);
d.ChannelName(iSR_VVR_BC,:)



%% LTB
iLTB = strmatch('LTB', d.ChannelName);

% IP
i = strmatch('LTB_____IP', d.ChannelName(iLTB,:));
iLTB_IP = iLTB(i);

i = strmatch('BC*', d.Ext(iLTB_IP,:));
iLTB_IP_BC = iLTB_IP(i);
d.ChannelName(iLTB_IP_BC,:)


% IG
i = strmatch('LTB_____IG', d.ChannelName(iLTB,:));
iLTB_IG = iLTB(i);

i = strmatch('BC*', d.Ext(iLTB_IG,:));
iLTB_IG_BC = iLTB_IG(i);
d.ChannelName(iLTB_IG_BC,:)


% VVR
i = strmatch('LTB_____VVR', d.ChannelName(iLTB,:));
iLTB_VVR = iLTB(i);

i = strmatch('BC*', d.Ext(iLTB_VVR,:));
iLTB_VVR_BC = iLTB_VVR(i);
d.ChannelName(iLTB_VVR_BC,:)


% TV
i = strmatch('LTB_____TV', d.ChannelName(iLTB,:));
iLTB_TV = iLTB(i);

i = strmatch('BC*', d.Ext(iLTB_TV,:));
iLTB_TV_BC = iLTB_TV(i);
d.ChannelName(iLTB_TV_BC,:)

i = strmatch('BM*', d.Ext(iLTB_TV,:));
iLTB_TV_BM = iLTB_TV(i);
d.ChannelName(iLTB_TV_BM,:)

