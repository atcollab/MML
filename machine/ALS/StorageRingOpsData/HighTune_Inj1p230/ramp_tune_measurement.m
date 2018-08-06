figure;
subplot(2,1,1);

load([getfamilydata('Directory','OpsData'), 'rampup_tune_table.mat']);
e = linspace(tune_meas_ramp.energy(1), tune_meas_ramp.energy(end), 300);
tunefilt = interp1(tune_meas_ramp.energy, tune_meas_ramp.tune, e, 'spline', 'extrap');

plot(tune_meas_ramp.energy, tune_meas_ramp.tunefilt, '-');
hold on;
plot(e, tunefilt, 'k');
plot(tune_meas_ramp.energy, tune_meas_ramp.tune, '.');
hold off
legend('Horizontal','Vertical','Spline');
ylabel('Tune');
xlabel('Energy');
title(sprintf('Tune During Slow Energy Ramp Up (%s)', getfamilydata('OperationalMode')));

subplot(2,1,2);

load([getfamilydata('Directory','OpsData'), 'rampdown_tune_table.mat']);
e = linspace(tune_meas_ramp.energy(1), tune_meas_ramp.energy(end), 300);
tunefilt = interp1(tune_meas_ramp.energy, tune_meas_ramp.tune, e, 'spline', 'extrap');

plot(tune_meas_ramp.energy, tune_meas_ramp.tunefilt, '-');
hold on;
plot(e, tunefilt, 'k');
plot(tune_meas_ramp.energy, tune_meas_ramp.tune, '.');
hold off
legend('Horizontal','Vertical','Spline');
ylabel('Tune');
xlabel('Energy');
title(sprintf('Tune During Slow Energy Ramp Down (%s)', getfamilydata('OperationalMode')));



