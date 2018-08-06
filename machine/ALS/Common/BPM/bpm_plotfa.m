function FA = bpm_plotfa(FA, FigNum)

if nargin < 2
    FigNum = 101;
end

n = 1:length(FA.A);
t = ((1:length(FA.A))-1)/FA.fs;

% if (FilterOnNoBeam)
iBeam = find(FA.S>4000);
n = iBeam;

figure(FigNum);
clf reset
h = subplot(3,1,1);
plot(t(n), FA.X(n));
ylabel('Horizontal [mm]');
title(sprintf('%s FA  std=%.3f \\mum   peak-to-peak = %.3f \\mum', FA.Prefix, 1000*std(FA.X), 1000*(max(FA.X)-min(FA.X))));
axis tight

h(length(h)+1) = subplot(3,1,2);
plot(t(n), FA.Y(n));
ylabel('Vertical [mm]');
title(sprintf('%s FA  std=%.3f \\mum   peak-to-peak = %.3f \\mum', FA.Prefix, 1000*std(FA.Y), 1000*(max(FA.Y)-min(FA.Y))));
axis tight

h(length(h)+1) = subplot(3,1,3);
plot(t(n), FA.S(n));
xlabel('Time [Seconds]');
ylabel('Sum');
title(sprintf('%s FA  std=%.1f   peak-to-peak = %.1f', FA.Prefix, 1000*std(FA.S), 1000*(max(FA.S)-min(FA.S))));
axis tight

addlabel(1, 0, datestr(FA.Ts(1),31));


figure(FigNum+1);
clf reset
h(length(h)+1) = subplot(1,1,1);
plot(t(n), [FA.A(n)  FA.B(n)  FA.C(n)  FA.D(n)]);
xlabel('Time [Seconds]');
title(sprintf('%s FA', FA.Prefix));
%axis tight;
a = axis;

addlabel(1, 0, datestr(FA.Ts(1),31));

figure(FigNum+2);
clf reset
h(length(h)+1) = subplot(2,2,1);
plot(t(n), FA.A(n));
xlabel('Time [Seconds]');
ylabel('FA A');
title(sprintf('%s FA', FA.Prefix));
axis tight;

h(length(h)+1) = subplot(2,2,2);
plot(t(n), FA.B(n));
xlabel('Time [Seconds]');
ylabel('FA B');
title(sprintf('%s FA', FA.Prefix));
axis tight;

h(length(h)+1) = subplot(2,2,3);
plot(t(n), FA.C(n));
xlabel('Time [Seconds]');
ylabel('FA C');
title(sprintf('%s FA', FA.Prefix));
axis tight;

h(length(h)+1) = subplot(2,2,4);
plot(t(n), FA.D(n));
xlabel('Time [Seconds]');
ylabel('FA D');
title(sprintf('%s FA', FA.Prefix));
axis tight;

linkaxes(h, 'x');

addlabel(1, 0, datestr(FA.Ts(1),31));



