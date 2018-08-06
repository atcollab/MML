function [PddSum, Paa, f, Pdd, Drms, Pdd_int] = plotvibrationpsd(FileName, Gain, Fmin, Fmax, LineColor, IntOffset, TitleStr, FigNum)
% [PddSum,Paa, f, Pdd, Drms, Pdd_int] = plotvibrationpsd(InputFileName, Accelerometer Gain [volts/g], Fmin, Fmax, LineColor, OffsetForInt, TitleStr, FigNum)
%
% Program to analyze vibration PSD data from the control system analyzer
% 
%          Paa     = acceleration power spectrum [(m/s/s)^2/Hz]
%          f       = frequency vector [Hz]
%          Pdd     = displacement power spectrum  [(m)^2/Hz]
%          Drms    = RMS deplacement [m]
%          Pdd_int = Integrated RMS deplacement squared [m^2]
%

StartDirectory = pwd;

if nargin < 1
    [FileName, DirectoryName, ErrorFlag] = uigetfile('*.m', 'Select a Vibration Data File');
    cd(DirectoryName);
end
if nargin < 2
  Gain = 1000;
end
if nargin < 3
  Fmin = 0;
end
if nargin < 4
  Fmax = 1e10;
end
if nargin < 5
  LineColor = 'b';
end
if nargin < 6
  IntOffset = 0;
end
if nargin < 7
  TitleStr = 'Accelerometer Power Spectral Density';
end
if nargin < 8
  FigNum = gcf;
end

if strcmpi(FileName(end-1:end), '.m')
    FileName(end-1:end) = [];
end

% Get data
eval(FileName);
cd(StartDirectory);

fprintf('   Accelerometer gain is %f volts. /n', Gain);

N_f = Npts;     % number of frequence points

T = 1/deltaX;
T1 = T/N;
w0 = 2*pi/T;

f0 = deltaX;
f=f0*(0:N_f-1)';

% scale data to the proper units:  [(m/s/s)^2 / Hz]
Paa = data * (9.8/Gain)^2;   %  Gain on the accelerometers

%Paa = Paa*10^2; 

% continuous to discrete scaling for the PSD
Paa = Paa/T1;


if (windowflag == 1)
%  Paa = data /.375;   % hanning window (correction done in the CSA 3563A)
  fprintf('   Data hanning windowed.\n');
else
% Paa = Paa;           % box car window (i.e. no window)
  fprintf('   No windowing.\n');
end

fprintf('   Number of averages = %f\n',avg);


% Divide by 1/s and 1/s^2 to get velocity and position power spectra
Pvv(2:N/2,1) = Paa(2:N/2) .* (ones(length(f(2:N/2)),1)./(2*pi*f(2:N/2)).^2);
Pdd(2:N/2,1) = Paa(2:N/2) .* (ones(length(f(2:N/2)),1)./(2*pi*f(2:N/2)).^4);
Pvv(1) = 0;
Pdd(1) = 0;

% Paa(0) is the DC term, and the first few data points are questionable in an FFT
Paa(1) = 0;   % not sure if the DC term is correct
Paa1=Paa;
Pvv1=Pvv;
Pdd1=Pdd;

[ii] = find(f>=Fmin);
m = ii(1);
%m = 8;
for i=1:m
  Paa1(i) = 0;
  Pvv1(i) = 0;
  Pdd1(i) = 0;
end

[ii] = find(f<=Fmax);
Imax = max(ii);


% Parseval's Thm
Arms  = sqrt(sum(Paa1)/N);
Vrms  = sqrt(sum(Pvv1)/N);
Drms  = sqrt(sum(Pdd1)/N);
Pvv_int = cumsum(Pvv1)/N;
Pdd_int = cumsum(Pdd1)/N;

%Pvv_int = cumsum(Pvv1)/N;
%Pdd_int = cumsum(Pdd1(length(Pdd1):-1:1))/N;
%Pdd_int = Pdd_int(length(Pdd_int):-1:1);

fprintf('\n  RMS Acceleration: %g m/s^2   (PSD, Parseval''s Thm, first %d frequencies removed).\n', Arms, m-1);
fprintf('  RMS     Velocity: %g m/s   (PSD, Parseval''s Thm, first %d frequencies removed).\n', Vrms, m-1);
fprintf('  RMS Displacement: %g m   (PSD, Parseval''s Thm, first %d frequencies removed).\n\n', Drms, m-1);


% Make PSD the same units as on the Control System Analyzer (CSA)
Paa = T1*Paa;
Pvv = T1*Pvv;
Pdd = T1*Pdd;


% Plot the full power spectrum
%figure(FigNum)
%clf reset

subplot(2,1,1);
%loglog(f(2:N_f),Paa(2:N_f),LineColor, f(2:N_f), Pdd(2:N_f),['--',LineColor]);
%legend('Acceleration PSD','Displacement PSD')
%loglog(f(2:N_f),Paa(2:N_f),LineColor);
%ylabel('[(meters/sec^2)^2/Hz] and [meters^2/Hz]');

%loglog(f(2:N_f),Pdd(2:N_f),LineColor);
%loglog(f(m:Imax),1e12*Paa(m:Imax), 'Color', LineColor);
loglog(f(m:Imax),1e12*Pdd(m:Imax), 'Color', LineColor);
grid on
ylabel('[(\mum/sec^2)^2/Hz]');
legend off;
title([TitleStr]);
xlabel('Frequency (Hz)');


% Velocity spectrum
%figure(2);
%semilogx(f(2:N_f),Pvv_int(2:N_f),LineColor); grid on;
%title('INTEGRATED VELOCITY POWER SPECTRUM');
%xlabel('Frequency (Hz)');
%ylabel('Mean Square Velocity [meters/sec]^2');


% Position spectrum
subplot(2,1,2);
%loglog(f(m:Imax),sqrt(Pdd_int(m:Imax)),LineColor); grid on;
%loglog(f(m:Imax),sqrt(Pdd_int(m:Imax)+IntOffset-Pdd_int(Imax)),LineColor);
%semilogx(f(m:Imax), Pdd_int(m:Imax)+IntOffset-Pdd_int(Imax), LineColor); 
semilogx(f(m:Imax), 1e12*Pdd_int(m:Imax), 'Color', LineColor); 
grid on;

%title(['Square Root of the Cumulative Reverse Integral of the Displacement PSD']);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12} Displacement PSD df  (%f \\mum)',1e6*sqrt(Pdd_int(end))));
%title(['Square Root of the Cumulative Reverse Integral of the Displacement PSD']);
xlabel('Frequency (Hz)');
ylabel('[\mum{^2}]');

PddSum = Pdd_int(end);

% fprintf('  CUM. REVERSE INTEGRAL at f(%d)=%f: %g m   (PSD)\n', m, f(m), sqrt(1e-12*Pdd_int(m)));
% fprintf('  CUM. REVERSE INTEGRAL at f(%d)=%f: %g m   (PSD)\n\n', Imax, f(Imax), sqrt(1e-12*Pdd_int(Imax)));


% For output
f = f(m:Imax);
Paa = Paa(m:Imax);
Pdd = Pdd(m:Imax);
Pdd_int = Pdd_int(m:Imax)+IntOffset-Pdd_int(Imax);

