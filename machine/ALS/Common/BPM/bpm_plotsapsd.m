function SA = bpm_plotsapsd(SA, FigNum)
%

% Written by Greg Portmann

if nargin < 2
    FigNum = 101;
end

FontSize = 12;

Pxx = SA.PSD.Pxx;
Pxx_int = SA.PSD.Pxx_int;
Pyy = SA.PSD.Pyy;
Pyy_int = SA.PSD.Pyy_int;
Paa = SA.PSD.Paa;
Paa_int = SA.PSD.Paa_int;
Pbb = SA.PSD.Pbb;
Pbb_int = SA.PSD.Pbb_int;
Pcc = SA.PSD.Pcc;
Pcc_int = SA.PSD.Pcc_int;
Pdd = SA.PSD.Pdd;
Pdd_int = SA.PSD.Pdd_int;

f  = SA.PSD.f;
fs = SA.PSD.fs;
T1 = SA.PSD.T1;
N  = SA.PSD.N;


figure(FigNum);
clf reset
h1 = subplot(2,1,1);
loglog(f(3:end), 1e6*T1*Pxx(3:end));
%title(sprintf('SA Horizontal PSD (%d points, %d turn FFT/point, %d averages)', N, Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
title(sprintf('SA Horizontal PSD (%d points)', N), 'FontSize', FontSize);
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
title(sprintf('SA Vertical PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Vertical [\mum^2/Hz]', 'FontSize', FontSize);
axis tight;

h1(4) = subplot(2,1,2);
semilogx(f(2:end), 1e6*Pyy_int(2:end));
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('[\mum {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Pyy_int(end))), 'FontSize', FontSize);
axis tight;


if isfield(SA.PSD, 'Pss')
figure(FigNum+2);
clf reset
h1(5) = subplot(2,1,1);
loglog(f(3:end), 1e6*T1*SA.PSD.Pss(3:end));
title(sprintf('SA Sum PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Sum [\mum^2/Hz]', 'FontSize', FontSize);
axis tight;

h1(6) = subplot(2,1,2);
semilogx(f(2:end), 1e6*SA.PSD.Pss_int(2:end));
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('[\mum {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f)', FontSize+2, 1000*sqrt(SA.PSD.Pss_int(end))), 'FontSize', FontSize);
axis tight;
end


Nrm = 1;
figure(FigNum+3);
clf reset
h1(7) = subplot(2,1,1);
loglog(f(Nrm:end), T1*Paa(Nrm:end), 'b');
hold on
loglog(f(Nrm:end), T1*Pbb(Nrm:end), 'g');
loglog(f(Nrm:end), T1*Pcc(Nrm:end), 'r');
loglog(f(Nrm:end), T1*Pdd(Nrm:end), 'c');
title(sprintf('SA Channel PSD (%d points)', N), 'FontSize', FontSize);
ylabel('Channel ["Volts"^2/Hz]', 'FontSize', FontSize);
axis tight;

h1(8) = subplot(2,1,2);
semilogx(f(Nrm:end), 1e6*Paa_int(Nrm:end), 'b');
hold on
semilogx(f(Nrm:end), 1e6*Pbb_int(Nrm:end), 'g');
semilogx(f(Nrm:end), 1e6*Pcc_int(Nrm:end), 'r');
semilogx(f(Nrm:end), 1e6*Pdd_int(Nrm:end), 'c');
xlabel('Frequency [Hz]', 'FontSize', FontSize);
ylabel('Channel ["volts" {^2}]', 'FontSize', FontSize);
title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f  %.3f  %.3f  %.3f)', FontSize+2,sqrt(Paa_int(end)),sqrt(Pbb_int(end)),sqrt(Pcc_int(end)),sqrt(Pdd_int(end))), 'FontSize', FontSize);
axis tight;

linkaxes(h1, 'x');


figure(FigNum+5);
NN = SA.PSD.N * SA.PSD.NAVG;
h2 = subplot(2,1,1);
plot((0:NN-1)/fs, SA.X(1:NN));
xlabel('Time [Seconds]', 'FontSize', FontSize);
ylabel('Horizontal [mm]', 'FontSize', FontSize);
title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.X)), 'FontSize', FontSize);
axis tight;

h2(2) = subplot(2,1,2);
plot((0:NN-1)/fs, SA.Y(1:NN));
xlabel('Time [Seconds]', 'FontSize', FontSize);
ylabel('Vertical [mm]', 'FontSize', FontSize);
title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.Y)), 'FontSize', FontSize);
axis tight;

linkaxes(h2, 'x');


% Add noise floor
%load bpmTest004_SA_500mA_NoiseFloor


