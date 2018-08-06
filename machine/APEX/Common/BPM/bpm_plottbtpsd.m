function TBT = bpm_plottbtpsd(TBT, FigNum)
%

% Written by Greg Portmann

if nargin < 2
    FigNum = 201;
end

FontSize = 12;

Pxx = TBT.PSD.Pxx;
Pxx_int = TBT.PSD.Pxx_int;
Pyy = TBT.PSD.Pyy;
Pyy_int = TBT.PSD.Pyy_int;
Paa = TBT.PSD.Paa;
Paa_int = TBT.PSD.Paa_int;
Pbb = TBT.PSD.Pbb;
Pbb_int = TBT.PSD.Pbb_int;
Pcc = TBT.PSD.Pcc;
Pcc_int = TBT.PSD.Pcc_int;
Pdd = TBT.PSD.Pdd;
Pdd_int = TBT.PSD.Pdd_int;

f  = TBT.PSD.f;
fs = TBT.PSD.fs;
T1 = TBT.PSD.T1;
N  = TBT.PSD.N;


figure(FigNum);
clf reset
h1 = subplot(2,1,1);
loglog(f(3:end), 1e6*T1*Pxx(3:end));
%title(sprintf('TBT Horizontal PSD (%d points, %d turn FFT/point, %d averages)', N, Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
title(sprintf('TBT Horizontal PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Horizontal [\mum^2/Hz]', 'FontSize', FontSize);
axis tight

h1(2) = subplot(2,1,2);
semilogx(f(2:end), 1e6*Pxx_int(2:end));
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('[\mum {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Pxx_int(end))), 'FontSize', FontSize);
axis tight

figure(FigNum+1);
clf reset
h1(3) = subplot(2,1,1);
loglog(f(3:end), 1e6*T1*Pyy(3:end));
title(sprintf('TBT Vertical PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Vertical [\mum^2/Hz]', 'FontSize', FontSize);
axis tight;

h1(4) = subplot(2,1,2);
semilogx(f(2:end), 1e6*Pyy_int(2:end));
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('[\mum {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Pyy_int(end))), 'FontSize', FontSize);
axis tight;


figure(FigNum+2);
h2 = subplot(2,1,1);
plot((0:length(TBT.X)-1)*1000/fs, TBT.X);
xlabel('Time [milliseconds]', 'FontSize', FontSize);
ylabel('Horizontal [mm]', 'FontSize', FontSize);
title(sprintf('TBT Data (RMS=%.3f \\mum))', 1000*std(TBT.X)), 'FontSize', FontSize);
axis tight;

h2(2) = subplot(2,1,2);
plot((0:length(TBT.Y)-1)*1000/fs, TBT.Y);
xlabel('Time [milliseconds]', 'FontSize', FontSize);
ylabel('Vertical [mm]', 'FontSize', FontSize);
title(sprintf('TBT Data (RMS=%.3f \\mum))', 1000*std(TBT.Y)), 'FontSize', FontSize);
axis tight
axis tight;

figure(FigNum+3);
clf reset
h1(5) = subplot(2,1,1);
loglog(f(3:end), T1*Paa(3:end), 'b');
hold on
loglog(f(3:end), T1*Pbb(3:end), 'g');
loglog(f(3:end), T1*Pcc(3:end), 'r');
loglog(f(3:end), T1*Pdd(3:end), 'c');
title(sprintf('TBT Channel PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Button ["Volts"^2/Hz]', 'FontSize', FontSize);
axis tight;

h1(6) = subplot(2,1,2);
semilogx(f(3:end), 1e6*Paa_int(3:end), 'b');
hold on
semilogx(f(3:end), 1e6*Pbb_int(3:end), 'g');
semilogx(f(3:end), 1e6*Pcc_int(3:end), 'r');
semilogx(f(3:end), 1e6*Pdd_int(3:end), 'c');
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('["volts" {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f  %.3f  %.3f  %.3f)', FontSize+2,sqrt(Paa_int(end)),sqrt(Pbb_int(end)),sqrt(Pcc_int(end)),sqrt(Pdd_int(end))), 'FontSize', FontSize);
axis tight;


linkaxes(h1, 'x');
linkaxes(h2, 'x');

