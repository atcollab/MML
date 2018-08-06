% Appel en série orbit_bump
% Mesure orbite et taille faisceau sur perte dans la chambre veticale au
% droit de chaque QP verticale

step =1;   % pas en mm
borne=11;   % max en mm
BBA=measorbitv_data1;
LBBA=length(BBA);
scanz=-borne:step:borne;

nmax=17;
NQP=[1 : nmax];
data=[];

%orbit_bump(QP,dz(1));
fprintf('******** Mesure orbite **********   \n');
for i=1:nmax  % on saute le premier QPV = orbite à l'injection
    QP=BBA(i,1);
    R=BBA(i,2:LBBA);
    [estimates, model] = fitprofil1(scanz, R);
    [sse, FittedCurve] = model(estimates);
    plot(scanz, R, '*', scanz, FittedCurve, 'r'); 
    ylim([0 100])
    grid on
    fprintf('QP= %6.2f  Sig=%6.2f    Dz=%6.2f   chambre=%6.2f    A=%6.2f    err=%6.2e\n',QP,estimates,sse);
    data=[data ; QP estimates sse];
    %orbit_bump(QP,-estimates(2));pause(2)
end

return 
figure(1)
subplot(3,1, 1)
   plot(data(:,1), data(:,3),'-o'); ylim([-3 3]);grid on
   ylabel('Z pos (mm)')
subplot(3, 1, 2)
   plot(data(:,1), data(:,2),'-o'); ylim([0 3]);grid on
   ylabel('Z rms (mm)')
subplot(3, 1, 3)
   plot(data(:,1), data(:,4),'-o'); ylim([5 12]);grid on
   xlabel('QPD');ylabel('Gap Chambre (mm)')
   
   
