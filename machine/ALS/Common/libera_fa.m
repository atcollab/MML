
% Note: all the data in this directory was taken with kx,ky = 10000000
%       A scaling of 1.4822 is based on [3 5]

%load test_1min_A.txt -ascii
%Data = 1.4822 * test_1min_A;

load FA_Data_FOFB_Off_Switches_Off_A.txt -ascii
Data = 1.4822 * FA_Data_FOFB_Off_Switches_Off_A;


figure(1);
subplot(3,1,1);
plot((1:600000)/10000,(Data(:,2)-Data(1,2))/1e3);
xlabel('Seconds');
ylabel('Horizontal [um]');
title('Libera FA Data');

subplot(3,1,2);
plot((1:600000)/10000,(Data(:,3)-Data(1,3))/1e3);
xlabel('Seconds');
ylabel('Vertical [um]');

subplot(3,1,3);
plot((1:600000)/10000,(Data(:,1)-Data(1,1)));
xlabel('Seconds');
ylabel('Sum');



% a = fft(Data(1:10000,2)-Data(1,2));
% loglog(10000*(1:10000)/10000,abs(a));

Fs = 10000;
N = 2^13;
Navg = 10;
PxxAvg = 0;
PyyAvg = 0;

for i = 1:Navg
    ii = (1:N)+(i-1)*N;
    x = detrend(Data(ii,2))/1000;  % um
    y = detrend(Data(ii,3))/1000;

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

    Pxx_int = cumsum(Pxx)/N;
    %Pxx_int = cumsum(Pxx(end:-1:1))/N;
    %Pxx_int = Pxx_int(length(Pxx_int):-1:1);

    Pyy_int = cumsum(Pyy)/N;
    %Pyy_int = cumsum(Pyy(end:-1:1))/N;
    %Pyy_int = Pyy_int(length(Pyy_int):-1:1);

    fprintf('   BPMx RMS Displacement: %g mm (Time series data)\n', RMS_X);
    fprintf('   BPMx RMS Displacement: %g mm (PSD, Parseval''s Thm)\n', sqrt(Pxx_int(end)));

    fprintf('   BPMy RMS Displacement: %g mm (Time series data)\n', RMS_Y);
    fprintf('   BPMy RMS Displacement: %g mm (PSD, Parseval''s Thm)\n\n', sqrt(Pyy_int(end)));

    PxxAvg = PxxAvg + Pxx/Navg;
    PyyAvg = PyyAvg + Pyy/Navg;
end

fprintf('\n   %d Averaged Power Spectrums\n', Navg);

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
% Ie, you can integrate it visually and get mm^2
figure(2);
%clf reset
clear h
h(1) = subplot(2,1,1);
%hold on
loglog(f, T1*[Pxx Pyy]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum{^2}/Hz]', 'FontSize',12);
title('Power Spectral Density', 'FontSize',12);
axis tight
grid on
axis([1 5000 1e-6 1e0]);

h(2) = subplot(2,1,2);
%hold on
semilogx(f, [Pxx_int Pyy_int]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum {^2}]', 'FontSize',12);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df     (RMS: BPMx=%.2g \\mum  BPMy=%.2g \\mum)', sqrt(Pxx_int(end)), sqrt(Pyy_int(end))));
axis tight
grid on
xaxis([1 5000]);
