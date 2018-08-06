figure(1);
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



b = [
   1 1.3530 0.27834 0.20120 51.30
  54 1.3884 0.28321 0.24847 51.30
 108 1.4244 0.27481 0.23985 51.30
 162 1.4604 0.27136 0.23960 51.27
 216 1.4965 0.26742 0.22729 51.24
 270 1.5325 0.25838 0.21721 51.18
 324 1.5685 0.25607 0.21376 51.18
 378 1.6046 0.25386 0.20932 51.15
 432 1.6406 0.26198 0.21154 51.18
 486 1.6767 0.25164 0.20268 51.12
 540 1.7127 0.25184 0.19726 51.09
 594 1.7487 0.24939 0.19258 51.09
 648 1.7848 0.24117 0.18963 51.06
 702 1.8208 0.24191 0.18791 51.03
 756 1.8568 0.23502 0.18692 51.03
 807 1.8909 0.23383 0.18052 51.03];
figure(2);
plot(b(:,2),[b(:,3) b(:,4)],'.-');
legend('Horizontal','Vertical');
ylabel('Tune');
xlabel('Energy');
title('Tune Shift During Slow Energy Ramp Up (2007-10-02)');

b = [
   1 1.8909 0.25483 0.20670 50.33
  54 1.8555 0.27612 0.20202 50.26
 108 1.8195 0.27531 0.22418 50.26
 162 1.7834 0.27900 0.22369 50.17
 216 1.7474 0.28638 0.23181 50.14
 270 1.7114 0.28761 0.23575 50.14
 324 1.6753 0.28836 0.23796 50.11
 378 1.6393 0.28589 0.24584 50.05
 432 1.6032 0.29032 0.25372 50.02
 486 1.5672 0.29083 0.25544 49.93
 540 1.5312 0.29121 0.15352 49.93
 594 1.4951 0.29227 0.27464 49.93
 648 1.4591 0.29006 0.22319 49.93
 702 1.4231 0.29277 0.27243 49.84
 756 1.3870 0.29424 0.27686 49.81
 807 1.3530 0.29645 0.26750 49.78];
figure(3);
plot(b(:,2),[b(:,3) b(:,4)],'.-');
legend('Horizontal','Vertical');
ylabel('Tune');
xlabel('Energy');
title('Tune Shift During Slow Energy Ramp Down (2007-10-02)');

b = [
   1 1.3530 0.25616 0.19956 49.44
  54 1.3884 0.26675 0.24953 49.41
 108 1.4244 0.26749 0.24166 49.41
 162 1.4604 0.23499 0.24043 49.38
 216 1.4965 0.25943 0.23403 49.35
 270 1.5325 0.25007 0.22959 49.32
 324 1.5685 0.24712 0.23107 49.35
 378 1.6046 0.24712 0.23205 49.35
 432 1.6406 0.24958 0.23452 49.29
 486 1.6767 0.28110 0.23550 49.32
 540 1.7127 0.25105 0.23649 49.29
 594 1.7487 0.25254 0.23894 49.26
 648 1.7848 0.25156 0.23894 49.23
 702 1.8208 0.25056 0.23894 49.26
 756 1.8568 0.25056 0.24092 49.26
 807 1.8909 0.24614 0.18725 49.23];
figure(4);
plot(b(:,2),[b(:,3) b(:,4)],'.-');
legend('Horizontal','Vertical');
ylabel('Tune');
xlabel('Energy');
title('Tune Shift During Slow Energy Ramp Up - Parabolic Offset (2007-10-02)');

b=[
   1 1.8909 0.25406 0.20694 48.86
  54 1.8555 0.27542 0.23058 48.83
 108 1.8195 0.27492 0.22467 48.83
 162 1.7834 0.27911 0.22442 48.80
 216 1.7474 0.28649 0.23279 48.77
 270 1.7114 0.28699 0.23624 48.71
 324 1.6753 0.28774 0.23845 48.68
 378 1.6393 0.28492 0.24609 48.62
 432 1.6032 0.28960 0.22467 48.62
 486 1.5672 0.28971 0.25667 48.52
 540 1.5312 0.28946 0.26553 48.55
 594 1.4951 0.28906 0.27514 48.46
 648 1.4591 0.28512 0.27514 48.46
 702 1.4231 0.28656 0.25864 48.40
 756 1.3870 0.28815 0.27833 48.37
 807 1.3530 0.28987 0.27193 48.31];
figure(5);
plot(b(:,2),[b(:,3) b(:,4)],'.-');
legend('Horizontal','Vertical');
ylabel('Tune');
xlabel('Energy');
title('Tune Shift During Slow Energy Ramp Down (2007-10-02)');
