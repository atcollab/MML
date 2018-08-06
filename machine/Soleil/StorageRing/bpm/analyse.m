load('BPMData_30tours.mat');

% %%
% figure
% mesh(AM.Data.Sum)
% 
% %%
% Sum  = AM.Data.Va + AM.Data.Vd + AM.Data.Va + AM.Data.Vd;
% Kx = 11.4; Kz = 11.4;
% XPos = Kx*(AM.Data.Va - AM.Data.Vb + AM.Data.Vd - AM.Data.Vc)./Sum;
% ZPos = Kz*(AM.Data.Va + AM.Data.Vb - AM.Data.Vc - AM.Data.Vd)./Sum;
% 
% 
% %% Signal 
% plot([XPos(1,:);AM.Data.X(1,:)]','.-')
% grid on
% xlabel('Turn number')
% ylabel('Sum (u.a.)')
% legend('Reconstruction','Dserveur')

plotDD(AM,0,0)
plotDD(AM,4,30)
plotDD(AM,4*2,30*2)
plotDD(AM,4*3,30*3)

plotDDraw(AM,0,0)
plotDDraw(AM,4,30)
plotDDraw(AM,4*2,30*2)
plotDDraw(AM,4*3,30*3)
