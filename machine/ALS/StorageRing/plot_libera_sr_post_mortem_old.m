% plot_libera_sr_post_mortem
%
% Christoph Steier, 2010

data=getlibera('PM',[3 5]);
data2=getlibera('PM',[6 5]);
data3=getlibera('PM',[9 5]);

turnvec=(1:length(data.PM_SUM_MONITOR));

figure;
subplot(3,1,1);
plot(turnvec,data.PM_SUM_MONITOR,turnvec,data2.PM_SUM_MONITOR,turnvec,data3.PM_SUM_MONITOR);
ylabel('Sum Data');
subplot(3,1,2);
plot(turnvec,data.PM_X_MONITOR/1e6,turnvec,data2.PM_X_MONITOR/1e6,turnvec,data3.PM_X_MONITOR/1e6);
yaxis([-5 5]);
ylabel('x [mm]');
subplot(3,1,3)
plot(turnvec,data.PM_Y_MONITOR/1e6,turnvec,data2.PM_Y_MONITOR/1e6,turnvec,data3.PM_Y_MONITOR/1e6);
yaxis([-1 1])
xlabel('turn #');
ylabel('y [mm]');

figure;
subplot(3,1,1);
plot(turnvec,data.PM_SUM_MONITOR,turnvec,data2.PM_SUM_MONITOR,turnvec,data3.PM_SUM_MONITOR);
xaxis([14000 16000]);
ylabel('Sum Data');
subplot(3,1,2);
plot(turnvec,data.PM_X_MONITOR/1e6,turnvec,data2.PM_X_MONITOR/1e6,turnvec,data3.PM_X_MONITOR/1e6);
xaxis([14000 16000]);
yaxis([-5 5]);
ylabel('x [mm]');
subplot(3,1,3)
plot(turnvec,data.PM_Y_MONITOR/1e6,turnvec,data2.PM_Y_MONITOR/1e6,turnvec,data3.PM_Y_MONITOR/1e6);
yaxis([-1 1])
xlabel('turn #');
ylabel('y [mm]');
xaxis([14000 16000]);

ind=min(find(data.PM_SUM_MONITOR<1e6));

fftsum=abs(fft(data.PM_SUM_MONITOR(1:ind)-mean(data.PM_SUM_MONITOR(1:ind))));
fftx=abs(fft(data.PM_X_MONITOR(1:ind)-mean(data.PM_X_MONITOR(1:ind))));
ffty=abs(fft(data.PM_Y_MONITOR(1:ind)-mean(data.PM_Y_MONITOR(1:ind))));

freqvec=(1:ind)./ind;

figure;
subplot(3,1,1);
plot(freqvec,fftsum);
xaxis([0 1]);
ylabel('fft(Sum Data)');
subplot(3,1,2);
plot(freqvec,fftx);
xaxis([0 1]);
ylabel('fft(x)');
subplot(3,1,3)
plot(freqvec,ffty)
ylabel('fft(y)');
xaxis([0 1]);
xlabel('fractional tune');
