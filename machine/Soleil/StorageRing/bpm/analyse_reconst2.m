function analyse_reconst

load('BPMData_30tours.mat');

% to be set in startup file
set(0,'DefaultAxesColorOrder',(colordg(1:15))); 

%%
Sum  = AM.Data.Va + AM.Data.Vd + AM.Data.Va + AM.Data.Vd;
Quad  = (AM.Data.Va + AM.Data.Vc - AM.Data.Vb - AM.Data.Vd)./Sum;
Kx = 11.4; Kz = 11.4;
XPos = Kx*(AM.Data.Va - AM.Data.Vb + AM.Data.Vd - AM.Data.Vc)./Sum;
ZPos = Kz*(AM.Data.Va + AM.Data.Vb - AM.Data.Vc - AM.Data.Vd)./Sum;

AM.Data.Sum = Sum; 
AM.Data.Q = Quad; 
AM.Data.X = XPos; 
AM.Data.Z = ZPos; 

% figure;
% plot(repmat((1:8),3),'.-')
% legend('1','2','3','4','5','6','7','8')
 
%% Superperiod 1


plotDD(AM,0,0)
plotDD(AM,4,30)
plotDD(AM,4*2,30*2)
plotDD(AM,4*3,30*3)


