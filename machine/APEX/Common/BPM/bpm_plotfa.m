function FA = bpm_plotfa(FA, FigNum)

if nargin < 2
    FigNum = 101;
end

n = 1:length(FA.A);
t = ((1:length(FA.A))-1)/10000;

figure(FigNum);
clf reset
h = subplot(2,1,1);
plot(t, FA.X(n));
xlabel('Time [Seconds]');
ylabel('Horizontal [mm]');
title(sprintf('%s FA  std=%.3f \\mum   peak-to-peak = %.3f \\mum', FA.Prefix, 1000*std(FA.X), 1000*(max(FA.X)-min(FA.X))));
axis tight

h(length(h)+1) = subplot(2,1,2);
plot(t, FA.Y(n));
xlabel('Time [Seconds]');
ylabel('Vertical [mm]');
title(sprintf('%s FA  std=%.3f \\mum   peak-to-peak = %.3f \\mum', FA.Prefix, 1000*std(FA.Y), 1000*(max(FA.Y)-min(FA.Y))));
axis tight

figure(FigNum+1);
clf reset
h(length(h)+1) = subplot(1,1,1);
plot(t, [FA.A(n)  FA.B(n)  FA.C(n)  FA.D(n)]);
xlabel('Time [Seconds]');
title(sprintf('%s FA', FA.Prefix));
%axis tight;
a = axis;

figure(FigNum+2);
clf reset
h(length(h)+1) = subplot(2,2,1);
plot(t, FA.A(n));
xlabel('Time [Seconds]');
ylabel('FA A');
title(sprintf('%s FA', FA.Prefix));
%axis(a);

h(length(h)+1) = subplot(2,2,2);
plot(t, FA.B(n));
xlabel('Time [Seconds]');
ylabel('FA B');
title(sprintf('%s FA', FA.Prefix));
%axis(a);

h(length(h)+1) = subplot(2,2,3);
plot(t, FA.C(n));
xlabel('Time [Seconds]');
ylabel('FA C');
title(sprintf('%s FA', FA.Prefix));
%axis(a);

h(length(h)+1) = subplot(2,2,4);
plot(t, FA.D(n));
xlabel('Time [Seconds]');
ylabel('FA D');
title(sprintf('%s FA', FA.Prefix));
%axis(a);

linkaxes(h, 'x');
