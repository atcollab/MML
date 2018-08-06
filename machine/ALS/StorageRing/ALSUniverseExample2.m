
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALS Universe Example - Emittance Scatter Plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Note: if you don't have a good computer rendering these plots can take a long time


EmittanceBound = 1e-7;
AlphaBound     = 2.5e-3;


% Load Weishi's Data
WeishiData = getuniverse;


% Search on emittance
i = find(WeishiData.Emittance < EmittanceBound);  


% Reduced points
% Note: it can take a long time to print even the reduced point case

figure(1);
clf reset
scatter(WeishiData.MuX(i), WeishiData.MuY(i), 1, log10(WeishiData.Emittance(i)), 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Emittance','Fontsize',14);
addlabel(0,0,sprintf('Constraint:  Emittance < %g',EmittanceBound));
colorbar; 
orient landscape



figure(2);
clf reset
scatter(WeishiData.MuX(i), WeishiData.MuY(i), 1, WeishiData.Alpha0(i), 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Momentum Compaction Factor','Fontsize',14);
addlabel(0,0,sprintf('Constraint:  Emittance < %g',EmittanceBound));
colorbar; 
orient landscape



% Search on emittance & MCF
i = find(WeishiData.Emittance < EmittanceBound & WeishiData.Alpha0 < AlphaBound & WeishiData.Alpha0 > -AlphaBound);  


figure(3);
clf reset
subplot(2,1,1);
scatter(WeishiData.MuX(i), WeishiData.MuY(i), 1, log10(WeishiData.Emittance(i)), 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Emittance','Fontsize',14);
colorbar; 

subplot(2,1,2);
scatter(WeishiData.MuX(i), WeishiData.MuY(i), 1, WeishiData.Alpha0(i), 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Momentum Compaction Factor','Fontsize',14);
colorbar; 

addlabel(0,0,sprintf('Constraint:  Emittance < %g  and  %g < MCF < %g',EmittanceBound, -AlphaBound, AlphaBound));
orient tall


return;



% All Points

figure; 
scatter(WeishiData.MuX, WeishiData.MuY, 1, log10(WeishiData.Emittance), 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Emittance','Fontsize',14);
colorbar; 
orient landscape


figure; 
scatter(WeishiData.MuX, WeishiData.MuY, 1, WeishiData.Alpha0, 'filled'); 
xlabel('\nu_x','Fontsize',14);
ylabel('\nu_y','Fontsize',14);
title('Momentum Compaction Factor','Fontsize',14);
colorbar; 
orient landscape

