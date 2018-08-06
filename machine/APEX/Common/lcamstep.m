%% Get data
PVs = {'LCam1:Stats1:CentroidX_RBV';'LCam1:Stats1:CentroidY_RBV';'Laser:HCathode.RBV';'Laser:VCathode.RBV'};
[d, t, ts]=getpv(PVs, 0:.1:60);


%% plot
figure(2);

for i = 1:4
    subplot(2,2,i);
    plot(t, d{i});
    xlabel('Time [Sec]');
    ylabel(PVs{i});
end
