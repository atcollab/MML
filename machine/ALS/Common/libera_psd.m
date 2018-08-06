function libera_psd(DD, FigNum)

% Get Orbit
if nargin < 1
    DD = getlibera('DD4', [12 5], 0);
end

if nargin < 2
    FigNum = 1;
end


% Orbit in um
xx = 1e-3 * DD.DD_X_MONITOR;
yy = 1e-3 * DD.DD_Y_MONITOR;
ss = DD.DD_SUM_MONITOR;

N = 2048;

figure(FigNum);
h = subplot(2,1,1);
plot(xx/1000);
axis tight
title('Libera Turn-By-Turn Data');
ylabel('Horizontal [mm]');
title(sprintf('Horizontal Orbit (RMS = %.3f \\mum)', std(xx(1:N))));
axis tight

h(2) = subplot(2,1,2);
plot(yy/1000);
axis tight
xlabel('Turns [~656 ns / turn]');
ylabel('Vertical [mm]');
title(sprintf('Vertical Orbit (RMS = %.3f \\mum)', std(yy(1:N))));

linkaxes(h, 'x');

xaxis([0 N]);


% a = fft(Data(1:10000,2)-Data(1,2));
% loglog(10000*(1:10000)/10000,abs(a));

Fs = 500e6/328;
N = 8*1024;   % 2^13 = 8192
Navg = floor(length(xx)/N);
PxxAvg = 0;
PyyAvg = 0;
PssAvg = 0;

for i = 1:Navg
    ii = (1:N)+(i-1)*N;
    x = detrend(xx(ii))';
    y = detrend(yy(ii))';
    %s = detrend(ss(ii))';
    s = ss(ii)';

    % POWER SPECTRUM
    T1 = 1/Fs;
    T  = T1 * N;

    f0 = 1 / (N*T1);
    f  = f0 * (0:N/2)';

    %w = ones(N,1);               % no window
    w = hanning(N);               % hanning window
    U = sum(w.^2)/N;              % approximately .375 for hanning
    %U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

    a_w = x .* w;
    A = fft(a_w);
    Pxx = A.*conj(A)/N;
    Pxx = Pxx / U;
    Pxx(N/2+2:N) = [];
    Pxx(2:N/2+1) = 2*Pxx(2:N/2+1);

    a_w = y .* w;
    A = fft(a_w);
    Pyy = A.*conj(A)/N;
    Pyy = Pyy/U;
    Pyy(N/2+2:N) = [];
    Pyy(2:N/2+1) = 2*Pyy(2:N/2+1);

    a_w = s .* w;
    A = fft(a_w);
    Pss = A.*conj(A)/N;
    Pss = Pss/U;
    Pss(N/2+2:N) = [];
    Pss(2:N/2+1) = 2*Pss(2:N/2+1);

    % PSD using matlab functions (NOTE: matlab function detrend by default)
    % PaaS = spectrum(a,N,0,w,f0);
    % PaaS = 2*PaaS(:,1);
    % PaaS(1)=PaaS(1)/2;
    % PaaPSD=2*psd(a,N);
    % PddPSD(1)=PddPSD(1)/2;

    %Pdd(1) = 0;   % not sure if the DC term is correct
    %Pdd1 = Pdd;
    %m = 3;        % not sure if the first couple terms are good
    %for i=1:m
    %   Pdd(i) = 0;
    %end

    RMS_X = sqrt(sum((x-mean(x)).^2)/length((x-mean(x))));
    RMS_Y = sqrt(sum((y-mean(y)).^2)/length((y-mean(y))));
    RMS_S = sqrt(sum((s-mean(s)).^2)/length((s-mean(s))));

    Pxx_int = cumsum(Pxx)/N;
    %Pxx_int = cumsum(Pxx(end:-1:1))/N;
    %Pxx_int = Pxx_int(length(Pxx_int):-1:1);

    Pyy_int = cumsum(Pyy)/N;
    %Pyy_int = cumsum(Pyy(end:-1:1))/N;
    %Pyy_int = Pyy_int(length(Pyy_int):-1:1);

    Pss_int = cumsum(Pss)/N;
    %Pss_int = cumsum(Pss(end:-1:1))/N;
    %Pss_int = Pss_int(length(Pss_int):-1:1);

    fprintf('   BPMx PP  Displacement: %g um\n', max(x)-min(x));
    fprintf('   BPMx RMS Displacement: %g um (Time series data)\n', RMS_X);
    fprintf('   BPMx RMS Displacement: %g um (PSD, Parseval''s Thm)\n', sqrt(Pxx_int(end)));

    fprintf('   BPMy PP  Displacement: %g um\n', max(y)-min(y));
    fprintf('   BPMy RMS Displacement: %g um (Time series data)\n', RMS_Y);
    fprintf('   BPMy RMS Displacement: %g um (PSD, Parseval''s Thm)\n\n', sqrt(Pyy_int(end)));

    fprintf('   SUM RMS Voltage: %g Counts (Time series data)\n', RMS_S);
    fprintf('   SUM RMS Voltage: %g Counts (PSD, Parseval''s Thm)\n\n', sqrt(Pss_int(end)));

    PxxAvg = PxxAvg + Pxx/Navg;
    PyyAvg = PyyAvg + Pyy/Navg;
    PssAvg = PssAvg + Pss/Navg;
end

fprintf('\n   %d Point Power Spectrums, %d Averages\n', N, Navg);

Pxx = PxxAvg;
Pxx_int = cumsum(Pxx)/N;
%Pxx_int = cumsum(Pxx(end:-1:1))/N;
%Pxx_int = Pxx_int(length(Pxx_int):-1:1);
fprintf('   RMS Displacement X: %g um (PSD, Parseval''s Thm)\n', sqrt(Pxx_int(end)));

Pyy = PyyAvg;
Pyy_int = cumsum(Pyy)/N;
%Pyy_int = cumsum(Pyy(end:-1:1))/N;
%Pyy_int = Pyy_int(length(Pyy_int):-1:1);
fprintf('   RMS Displacement Y: %g um (PSD, Parseval''s Thm)\n', sqrt(Pyy_int(end)));


% Plotting T1*Paa makes the PSD the same units as on the HP Control System Analyzer
% Ie, you can integrate it visually and get um^2
figure(FigNum+1);
%clf reset
h = subplot(2,1,1);
%hold on
semilogy(f/1e6, T1*[Pxx Pyy]);
xlabel('Frequency [MHz]', 'FontSize',12);
ylabel('[\mum{^2}/Hz]', 'FontSize',12);
title('Libera Turn-By-Turn Power Spectral Density', 'FontSize',12);
%axis tight
grid on

h(2) = subplot(2,1,2);
%hold on
plot(f/1e6, [Pxx_int Pyy_int]);
xlabel('Frequency [MHz]', 'FontSize',12);
ylabel('[\mum {^2}]', 'FontSize',12);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df    (RMS: BPMx=%.3f \\mum  BPMy=%.3f \\mum)', sqrt(Pxx_int(end)), sqrt(Pyy_int(end))));
axis tight
grid on

linkaxes(h, 'x');
xaxis([0 500/328/2]);

addlabel(1, 0, sprintf('%d Point Power Spectrums, %d Averages (%s)  ', N, Navg, DD.DD_FINISHED_MONITOR_TIMESTAMP), 10);

figure(FigNum+2)
subplot(2,1,1);
plot(ss);
axis tight
xlabel('Turns');
ylabel('Sum');

subplot(2,1,2);
semilogy(f/1e6, T1*[Pss]);
xlabel('Frequency [MHz]', 'FontSize',12);
ylabel('Sum [Counts{^2}/Hz]', 'FontSize',12);
title('PSD of the Button Sum', 'FontSize',12);
axis tight
grid on
xaxis([0 500/328/2]);
%yaxis([100 1e5]);

addlabel(1, 0, sprintf('%d Point Power Spectrums, %d Averages (%s)  ', N, Navg, DD.DD_FINISHED_MONITOR_TIMESTAMP), 10);
