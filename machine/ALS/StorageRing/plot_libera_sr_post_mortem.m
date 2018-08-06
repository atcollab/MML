% plot_libera_sr_post_mortem
%
% Christoph Steier, 2010

data=getlibera('PM',[3 5;6 5;9 5]);

figure;
subplot(3,1,1);
plot(cat(1,data.PM_SUM_MONITOR)');
ylabel('Sum Data');
subplot(3,1,2);
plot(cat(1,data.PM_X_MONITOR)'/1e6);
yaxis([-5 5]);
ylabel('x [mm]');
subplot(3,1,3)
plot(cat(1,data.PM_Y_MONITOR)'/1e6)
yaxis([-1 1])
xlabel('turn #');
ylabel('y [mm]');

figure;
subplot(3,1,1);
plot(cat(1,data.PM_SUM_MONITOR)');
xaxis([14000 16000]);
ylabel('Sum Data');
subplot(3,1,2);
plot(cat(1,data.PM_X_MONITOR)'/1e6);
xaxis([14000 16000]);
yaxis([-5 5]);
ylabel('x [mm]');
subplot(3,1,3)
plot(cat(1,data.PM_Y_MONITOR)'/1e6)
yaxis([-1 1])
xlabel('turn #');
ylabel('y [mm]');
xaxis([14000 16000]);

ind=min(find(data(1).PM_SUM_MONITOR<1e6));
ind2=min(find(data(2).PM_SUM_MONITOR<1e6));
ind3=min(find(data(3).PM_SUM_MONITOR<1e6));

ind=max([ind ind2 ind3]);

if isempty(ind)
    ind=length(data(1).PM_SUM_MONITOR);
end

fftsum=abs(fft(data(1).PM_SUM_MONITOR(1:ind)-mean(data(1).PM_SUM_MONITOR(1:ind))));
fftx=abs(fft(data(1).PM_X_MONITOR(1:ind)-mean(data(1).PM_X_MONITOR(1:ind))));
ffty=abs(fft(data(1).PM_Y_MONITOR(1:ind)-mean(data(1).PM_Y_MONITOR(1:ind))));

fftsum2=abs(fft(data(2).PM_SUM_MONITOR(1:ind)-mean(data(2).PM_SUM_MONITOR(1:ind))));
fftx2=abs(fft(data(2).PM_X_MONITOR(1:ind)-mean(data(2).PM_X_MONITOR(1:ind))));
ffty2=abs(fft(data(2).PM_Y_MONITOR(1:ind)-mean(data(2).PM_Y_MONITOR(1:ind))));

fftsum3=abs(fft(data(3).PM_SUM_MONITOR(1:ind)-mean(data(3).PM_SUM_MONITOR(1:ind))));
fftx3=abs(fft(data(3).PM_X_MONITOR(1:ind)-mean(data(3).PM_X_MONITOR(1:ind))));
ffty3=abs(fft(data(3).PM_Y_MONITOR(1:ind)-mean(data(3).PM_Y_MONITOR(1:ind))));

fftsum=([fftsum;fftsum2;fftsum3]);
fftx=([fftx;fftx2;fftx3]);
ffty=([ffty;ffty2;ffty3]);

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
