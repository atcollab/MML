function Orbit = bpm_xy2psd(Orbit, Setup, ENV)
%


% Written by Greg Portmann


FontSize = 12;

FigNum = Setup.xy.FigNum+10;
figure(FigNum);
clf reset
h1 = [];
h2 = [];
ih1 = 0;

for i = 1:2    
    if i == 1
        a = Orbit.x;
    else
        a = Orbit.y;
    end 
    
    N = length(a);
    %T = 656e-9 * Orbit.TurnNumber(end)
    %T = Orbit.TurnNumber(end) * 328/(ENV.RF0*1e6);
    %fs = N / T;
    fs = ENV.Fs*1e6/Setup.xy.NAdvance;   % Sampling frequency of xy [Hz] (Fs and NAdvance are in ADC counts)
    T1 = 1/fs;                           % Sampling period of xy [seconds]
    
    % ??? TurnsPerFFT = Orbit.TurnNumber(end) / N;
    
    if exist('hanning','file')
        w = hanning(N);          % hanning window
        Orbit.PSD.WindowType = 'Hanning';
    else
        w = ones(N,1);            % no window
        Orbit.PSD.WindowType = 'None';
    end
    w = w(:)';
    U = sum(w.^2)/N;              % approximately .375 for hanning
    %U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)
    
    a_w = a .* w;
    A = fft(a_w);
    Paa = A.*conj(A)/N;
    Paa = Paa/U;
    Paa = Paa(1:ceil(N/2));
    Paa(2:end) = 2*Paa(2:end);
    
    Nfreq = length(Paa);
    FreqVec = ((0:Nfreq-1)/Nfreq)*(fs/2);

    Paa([1 2]) = 0; % Remove the DC term +
        
    Paa_int = cumsum(Paa)/N;   % mm^2

    % std(a)
    % sqrt(Paa_int(end))

        
    figure(FigNum+i-1);
    clf reset
    ih1 = ih1 + 1;
    h1(ih1) = subplot(2,1,1);
    semilogy(FreqVec(3:end), 1e6*T1*Paa(3:end));
    if i == 1
        Orbit.PSD.Pxx = Paa;
        Orbit.PSD.Pxx_int = Paa_int;
        Orbit.PSD.f = FreqVec;
        Orbit.PSD.T1 = T1;
        Orbit.PSD.N = N;
        title(sprintf('Orbit Horizontal PSD (%d points, %d turn FFT/point, %d averages)', N, Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
        ylabel('Horizontal [\mum^2/Hz]', 'FontSize', FontSize);
    else
        Orbit.PSD.Pyy = Paa;
        Orbit.PSD.Pyy_int = Paa_int;
        title(sprintf('Orbit Vertical PSD (%d points, %d turn FFT/point, %d averages)', N, Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
        ylabel('Vertical [\mum^2/Hz]', 'FontSize', FontSize);
    end
    xlabel('Frequency [Hz]', 'FontSize', FontSize);

    ih1 = ih1 + 1;
    h1(ih1) = subplot(2,1,2);
    plot(FreqVec(2:end), 1e6*Paa_int(2:end));
    xlabel('Frequency [Hz]', 'FontSize', FontSize);
    ylabel('[\mum {^2}]', 'FontSize', FontSize);
    title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Paa_int(end))), 'FontSize', FontSize);

    
    figure(FigNum+2);
    h2(i) = subplot(2,1,i);
    plot(Orbit.TurnNumber, a);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    if i == 1
        ylabel('Horizontal [mm]', 'FontSize', FontSize);
    else
        ylabel('Vertical [mm]', 'FontSize', FontSize);
    end
    title(sprintf('Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(a), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    axis tight
        
end

linkaxes(h1, 'x');
linkaxes(h2, 'x');

