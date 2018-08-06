% Eugene Tan
% 30-05-2006

plotsurfacedata = 0;
coilradius = 0.02697;

% This scaling factor is to the coil ceometry used in the measurement.
% There should be one for the sextupole component however for now assume
% its 1.
% The scaling factor is only used here because the harmonic measurements
% from Buckley use the theoretical conversion factor of 42.072495 T/Vs
% where as this factor has been experimentally measured to be 43.95792
% T/Vs. Data here for B vs I comes from harmonic measurements.
quad_scaling_factor = 1.04479174615680;
sext_scaling_factor = 1;

% Read QD data
data = xlsread('BH_curve.xls','QD','range','basic');
% First row contains the current data and the first column the harmonic
% number.
BIdata.QD.I = data(1,2:end);
BIdata.QD.harmon = data(2:end,1);
BIdata.QD.B = data(2:end,2:end);

% The BH_curve.xls spreedsheet was measured by people Buckley when Alan
% Jackson visited and contains harmonic data measured at many different
% currents.
% Read QF data
data = xlsread('BH_curve.xls','QF10','range','basic');
% First row contains the current data and the first column the harmonic
% number.
BIdata.QF.I = data(1,2:end);
BIdata.QF.harmon = data(2:end,1);
BIdata.QF.B = data(2:end,2:end);

% Read SVR data
data = xlsread('BH_curve.xls','SVR12','range','basic');
% First row contains the current data and the first column the harmonic
% number.
BIdata.SVR.I = data(1,2:end);
BIdata.SVR.harmon = data(2:end,1);
BIdata.SVR.B = data(2:end,2:end);

% Load Dipole data. This data is derived from tracking single particles
% through dipole field data for different energies and determining the
% scaling factors (ie currents) needed bend the electron by pi/14.
load dipole_current_calibration.mat
BIdata.DIP.I = dipole_current;
BIdata.DIP.Energy = dipole_energy;

% Load Plot data. This comes from running plotdata =
% plotmagdatmpole2(magdata); with the magnetic measurements. These contain
% harmonic data for all each quadrupole and sextupole measured at various
% test currents. The harmonic data saved/used here is an average across all
% magnets.
load plotdata.mat
BIdata.HCM.I = plotdata.sh{1}.current;
BIdata.HCM.harmon = mean(plotdata.sh{1}.harmon,2);
BIdata.HCM.Bharmon = mean(plotdata.sh{1}.bln,2);
BIdata.HCM.Bharmon_std= std(plotdata.sh{1}.bln,0,2);

BIdata.VCM.I = plotdata.svr{3}.current;
BIdata.VCM.harmon = mean(plotdata.svr{3}.harmon,2);
BIdata.VCM.Bharmon = mean(plotdata.svr{3}.bln,2);
BIdata.VCM.Bharmon_std = std(plotdata.svr{3}.bln,0,2);

%%
% Do some data plotting

if plotsurfacedata
    figure;
    surface(BIdata.QD.I,BIdata.QD.harmon,log10(BIdata.QD.B/max(BIdata.QD.B(:))))
    campos([7.83044978305752  -0.07829528232128   0.21011226237000]*1e2);
    title('QD');

    figure;
    surface(BIdata.QF.I,BIdata.QF.harmon,log10(BIdata.QF.B/max(BIdata.QF.B(:))))
    campos([7.83044978305752  -0.07829528232128   0.21011226237000]*1e2);
    title('QF');

    figure;
    surface(BIdata.SVR.I,BIdata.SVR.harmon,log10(BIdata.SVR.B/max(BIdata.SVR.B(:))))
    campos([7.83044978305752  -0.07829528232128   0.21011226237000]*1e2);
    title('SVR');
end
    
%%
% Fit a line to the primary harmonic and determine the difference between
% the measured and the values predicted by the linear equation.
% 
% D Quadrupole, primary harmonic = 2.
% 
% lastnum = 9;
% [P, S, MU] = polyfit(BIdata.QD.I(1,end-lastnum:end),BIdata.QD.B(2,end-lastnum:end),7);
% delta = zeros(1,length(BIdata.QD.I));
% difference = zeros(1,length(BIdata.QD.I));
% for i=1:length(BIdata.QD.I)
% %     predicted = P(end) + P(end-1)*BIdata.QD.I(i);
%     [predicted(i) delta(i)] = polyval(P,BIdata.QD.I(i),S,MU);
%     difference(i) = (predicted(i)/BIdata.QD.B(2,i)-1);
% %     fprintf('I = %3d Amps, Actual = %11.3e, Prediction = %11.3e, Difference = %11.3e, Delta = %11.3e\n',...
% %         BIdata.QD.I(i),BIdata.QD.B(2,i),predicted,difference(i),delta(i));
% end
% fprintf('Average delta = %11.3e, Average difference = %11.3e\n',mean(delta(1,end-lastnum:end)),...
%     mean(abs(difference(1,end-lastnum:end))));

%%
% Create curve for QF

% Usr plot to determine where nonlinear curve begins.
% figure; 
% plot(BIdata.QF.I,gradient(BIdata.QF.B(2,:)))

clear I_* B_*

% Current at which magnet begins to saturate.
I_nonlinearpoint = 120;   
ind = find(BIdata.QF.I == I_nonlinearpoint);

% Fit a line to points below this current
[P S MU] = polyfit(BIdata.QF.I(1:ind),BIdata.QF.B(2,1:ind),1);

% Generate points from the line for the curve. Stop 10 amps from the top.
% The top 10 amps used to match the gradient of the curve in the next
% section.
I_gen_linear = [0:5:I_nonlinearpoint-10];
B_gen_linear = polyval(P,I_gen_linear,S,MU);

% Generate curve matching section
I_gen_match = [I_nonlinearpoint-10:1:I_nonlinearpoint];
B_gen_match = polyval(P,I_gen_match,S,MU);

% Add match data set above to the nonlinear points to fit curve to.
I_nonlinear = [I_gen_match BIdata.QF.I(ind+1:end)];
B_nonlinear = [B_gen_match BIdata.QF.B(2,ind+1:end)];

% Use pchip to generate a curve to the above nonlinear points with matching
% section.
I_gen_nonlinear = [I_nonlinearpoint - 5:5:BIdata.QF.I(end)];
B_gen_nonlinear = pchip(I_nonlinear,B_nonlinear,I_gen_nonlinear);

% Put both together and plot with original data
I_gen = [I_gen_linear I_gen_nonlinear];
B_gen = [B_gen_linear B_gen_nonlinear];

% Try just using pchip for all data points.
B_gen_pchip = pchip(BIdata.QF.I(1:ind),BIdata.QF.B(2,1:ind),I_gen);

figure;
subplot(2,1,1);
plot(BIdata.QF.I,BIdata.QF.B(2,:),'-ro',I_gen,B_gen,'b',I_gen,B_gen_pchip,'k','MarkerSize',4);
legend('Data,','B gen','B gen pchip');
subplot(2,1,2);
plot(BIdata.QF.I,(interp1(I_gen,B_gen,BIdata.QF.I) - BIdata.QF.B(2,:))./BIdata.QF.B(2,:),'b',...
    BIdata.QF.I,(interp1(I_gen,B_gen_pchip,BIdata.QF.I) - BIdata.QF.B(2,:))./BIdata.QF.B(2,:),'r');
legend('B gen - data','B gen pchip - data');
title('% difference between curve and data');

BIdata.QF.I_gen = I_gen;
BIdata.QF.B_gen = B_gen;
BIdata.QF.dBdx = B_gen/coilradius*quad_scaling_factor;

%%
% Create curve for QD

% Usr plot to determine where nonlinear curve begins.
figure; 
plot(BIdata.QD.I,gradient(BIdata.QD.B(2,:)))

%%
clear I_* B_*

% % Current at which magnet begins to saturate.
% I_nonlinearpoint = 120;   
% ind = find(BIdata.QF.I == I_nonlinearpoint);
% 
% From data the magnet does not appear to saturate so fit a line to all the
% data points.
ignore_first = 3;
[P S MU] = polyfit(BIdata.QD.I(ignore_first:end),BIdata.QD.B(2,ignore_first:end),1);

% Generate points from the line for the curve.
I_gen_linear = [0:5:BIdata.QD.I(end)];
B_gen_linear = polyval(P,I_gen_linear,S,MU);

% Try just using pchip for all data points.
B_gen_pchip = pchip(BIdata.QD.I(ignore_first:end),BIdata.QD.B(2,ignore_first:end),I_gen_linear);

figure;
subplot(2,1,1);
plot(BIdata.QD.I,BIdata.QD.B(2,:),'-ro',I_gen_linear,B_gen_pchip,'k',I_gen_linear,B_gen_linear,'b','MarkerSize',4);
legend('Data,','B gen pchip','B gen linear');
subplot(2,1,2);
plot(BIdata.QD.I,(interp1(I_gen_linear,B_gen_pchip,BIdata.QD.I) - BIdata.QD.B(2,:))./BIdata.QD.B(2,:),'r',...
    BIdata.QD.I,(interp1(I_gen_linear,B_gen_linear,BIdata.QD.I) - BIdata.QD.B(2,:))./BIdata.QD.B(2,:),'b');
legend('B gen pchip - data','B gen linear - data');
title('% difference between curve and data');

BIdata.QD.I_gen = I_gen_linear;
BIdata.QD.B_gen = B_gen_linear;
BIdata.QD.dBdx = B_gen_linear/coilradius*quad_scaling_factor;

%%
% Create curve for Sext

% Usr plot to determine where nonlinear curve begins.
figure; 
plot(BIdata.SVR.I,gradient(BIdata.SVR.B(3,:)))

%%
clear I_* B_*

% % Current at which magnet begins to saturate.
% I_nonlinearpoint = 120;   
% ind = find(BIdata.QF.I == I_nonlinearpoint);
% 
% From data the magnet does not appear to saturate so fit a line to all the
% data points.
ignore_first = 3;
[P S MU] = polyfit(BIdata.SVR.I(ignore_first:end),BIdata.SVR.B(3,ignore_first:end),1);

% Generate points from the line for the curve.
I_gen_linear = [0:5:BIdata.SVR.I(end)];
B_gen_linear = polyval(P,I_gen_linear,S,MU);

% Try just using pchip for all data points.
B_gen_pchip = pchip(BIdata.SVR.I(ignore_first:end),BIdata.SVR.B(3,ignore_first:end),I_gen_linear);

figure;
subplot(2,1,1);
plot(BIdata.SVR.I,BIdata.SVR.B(3,:),'-ro',I_gen_linear,B_gen_pchip,'k',I_gen_linear,B_gen_linear,'b','MarkerSize',4);
legend('Data,','B gen pchip','B gen linear');
subplot(2,1,2);
plot(BIdata.SVR.I,(interp1(I_gen_linear,B_gen_pchip,BIdata.SVR.I) - BIdata.SVR.B(3,:))./BIdata.SVR.B(3,:),'r',...
    BIdata.SVR.I,(interp1(I_gen_linear,B_gen_linear,BIdata.SVR.I) - BIdata.SVR.B(3,:))./BIdata.SVR.B(3,:),'b');
legend('B gen pchip - data','B gen linear - data');
title('% difference between curve and data');

BIdata.SVR.I_gen = I_gen_linear;
BIdata.SVR.B_gen = B_gen_linear;
% The factor of 2 is to get the units into d^2B/dx^2. The data for B from
% the harmonic data is premultiplies by 1/2! already!
BIdata.SVR.d2Bdx2 = B_gen_linear/coilradius/coilradius*sext_scaling_factor*2;

%%
% Save BIdata
save B_vs_I_data BIdata
