clear data;

data.dd1.x   = getpv('BR01BPM12:DD1_X_MONITOR');
data.dd1.y   = getpv('BR01BPM12:DD1_Y_MONITOR');
data.dd1.sum = getpv('BR01BPM12:DD1_SUM_MONITOR');

data.dd3.x   = getpv('BR01BPM12:DD3_X_MONITOR');
data.dd3.y   = getpv('BR01BPM12:DD3_Y_MONITOR');
data.dd3.sum = getpv('BR01BPM12:DD3_SUM_MONITOR');

data.adc.A = getpv('BR01BPM12:ADC_A_MONITOR');
data.adc.B = getpv('BR01BPM12:ADC_B_MONITOR');
data.adc.C = getpv('BR01BPM12:ADC_C_MONITOR');
data.adc.D = getpv('BR01BPM12:ADC_D_MONITOR');

data.picoscope.A = getpv('BR01PSC01:CHANNEL_A_MONITOR');
data.picoscope.B = getpv('BR01PSC01:CHANNEL_B_MONITOR');

%%
figure(440);
fs = 119361788.8;
t = ((1:1024)-1)/fs * 1e6;

subplot(2,2,1);
plot(t,data.adc.A); title('A');
xlabel('Time (us)');
subplot(2,2,2);
plot(t,data.adc.B); title('B');
xlabel('Time (us)');
subplot(2,2,3);
plot(t,data.adc.C); title('C');
xlabel('Time (us)');
subplot(2,2,4);
plot(t,data.adc.D); title('D');
xlabel('Time (us)');

figure(441);
set(gcf,'Position',[  24  490 1204  823])
clf;
fs = 1.387927776744186e+06/64; 1.387991888888889e+06/64;
t  = ((1:2e4)-1)/fs * 1e3;
t2 = (1:1000)/(1000) * 1e3;        % NEED TO CONFIRM SAMPLE TIME of the picoscope

h(1) = subplot(2,2,1);
plot(t,data.dd1.x*1e-3)
grid on;
ylabel('X (um)');
xlabel('Time (ms)');
title('BR01BPM12 (21.69 kHz)')

h(2) = subplot(2,2,2);
plot(t,data.dd1.y*1e-3)
grid on;
ylabel('Y (um)');
xlabel('Time (ms)');
h(3) = subplot(2,1,2);
toffset = t2( find(data.picoscope.A < -0.1,1,'first') );
plot(t + toffset,data.dd1.sum);
hold on;
yscale = diff(ylim);
plot(t2,(-data.picoscope.A)*yscale)
plot(t2,(data.picoscope.B)*yscale/10)
grid on;
xlabel('Time (ms)');
legend('BPM Sum','Pico A','Pico B');
linkaxes(h,'x')


figure(443);
clf;
fs = 1.387991888888889e+06;
t = ((1:1e4)-1)/fs * 1e6;

plotyy(t,data.dd3.x,t,data.dd3.sum)
xlabel('Time (us)');