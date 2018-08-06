function TBT = bpm_plottbt(TBT, FigNum)

if nargin < 2
    FigNum = figure;
end

%n = (length(TBT.A)-2*77):length(TBT.A);
n = 1:length(TBT.A);

figure(FigNum);
clf reset
h = subplot(3,1,1);
plot(TBT.X(n));
ylabel('Horizontal [mm]');
title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(TBT.X),1000*(max(TBT.X)-min(TBT.X))));
axis tight

h(2) = subplot(3,1,2);
plot(TBT.Y(n));
ylabel('Vertical [mm]');
title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(TBT.Y),1000*(max(TBT.Y)-min(TBT.Y))));
axis tight

h(3) = subplot(3,1,3);
plot(TBT.S(n));
ylabel('Sum');
title(sprintf('Sum std=%.3f     peak-to-peak = %.3f', std(TBT.S), (max(TBT.S)-min(TBT.S))));
axis tight

addlabel(0, 0, sprintf('%s',datestr(TBT.Ts(1,1), 31)));

% ALS SR:  656ns per turn  (328 * 2ns)
% ALS BR:  250ns per turn  (125 * 2ns)
%          100k samples * 250ns = 25 msec

figure(FigNum+1);
clf reset
plot([TBT.A(n)  TBT.B(n)  TBT.C(n)  TBT.D(n)]);
%axis tight;
a = axis;

addlabel(0, 0, sprintf('%s',datestr(TBT.Ts(1,1), 31)));


figure(FigNum+2);
clf reset
subplot(2,2,1);
plot(TBT.A(n));
ylabel('TBT A');
%axis(a);

subplot(2,2,2);
plot(TBT.A(n));
ylabel('TBT B');
%axis(a);

subplot(2,2,3);
plot(TBT.C(n));
ylabel('TBT C');
%axis(a);

subplot(2,2,4);
plot(TBT.C(n));
ylabel('TBT D');
%axis(a);

addlabel(0, 0, sprintf('%s',datestr(TBT.Ts(1,1), 31)));

linkaxes(h, 'x');
