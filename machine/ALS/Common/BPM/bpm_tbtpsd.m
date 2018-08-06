function TBT = bpm_tbtpsd(TBT, ENV, NFFT, NAVG, FigNum)
%

% Written by Greg Portmann

if nargin < 3 || isempty(NFFT)
    NFFT = 1024*8;
end
if nargin < 4 || isempty(NAVG)
    NAVG = 10;
end
if nargin < 5
    FigNum = 101;
end

FontSize = 12;

Pxx = 0;
Pyy = 0;
Paa = 0;
Pbb = 0;
Pcc = 0;
Pdd = 0;


%T = 656e-9 * TBT.TurnNumber(end)
%T = TBT.TurnNumber(end) * 328/(ENV.RF0*1e6);
%fs = N / T;


fs = ENV.Machine.Clock * 1e6 / 328;     % Sampling frequency of SR TBT
%fsADC = ENV.Clock.ADCRate * 1e6;    % Sampling frequency of TBT


WindowType = 'None';

nStart = 1;
for j = 1:NAVG
    
    n = (nStart:(nStart+NFFT-1));
    
    if length(TBT.X) >= n(end)
    
    TBT.PSD.WindowType = WindowType;
    Pxx = Pxx + psd_local(TBT.X(n), fs, TBT.PSD.WindowType) / NAVG;
    Pyy = Pyy + psd_local(TBT.Y(n), fs, TBT.PSD.WindowType) / NAVG;
    Paa = Paa + psd_local(TBT.A(n), fs, TBT.PSD.WindowType) / NAVG;
    Pbb = Pbb + psd_local(TBT.B(n), fs, TBT.PSD.WindowType) / NAVG;
    Pcc = Pcc + psd_local(TBT.C(n), fs, TBT.PSD.WindowType) / NAVG;
    Pdd = Pdd + psd_local(TBT.D(n), fs, TBT.PSD.WindowType) / NAVG;
        
    figure(FigNum+4);
    h2 = subplot(2,1,1);
    plot((0:length(TBT.X(n))-1)*1000/fs, TBT.X(n));
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('TBT Data (RMS=%.3f \\mum))', 1000*std(TBT.X)), 'FontSize', FontSize);
    axis tight
    
    h2(2) = subplot(2,1,2);
    plot((0:length(TBT.X(n))-1)*1000/fs, TBT.Y(n));
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('TBT Data (RMS=%.3f \\mum))', 1000*std(TBT.Y)), 'FontSize', FontSize);
    axis tight
    drawnow;

    nStart = nStart + NFFT;
    
    else
        fprintf('   NAVG changed from %d to %d (ran out of data).\n', NAVG, j);
        NAVG = j;
        break;
    end
end

T1 = 1 / fs;
Nfreq = length(Paa);
FreqVec = ((0:Nfreq-1)/Nfreq)*(fs/2);

Pxx([1 2]) = 0; % Remove the DC term +
Pyy([1 2]) = 0; % Remove the DC term +
Paa([1 2]) = 0; % Remove the DC term +
Pbb([1 2]) = 0; % Remove the DC term +
Pcc([1 2]) = 0; % Remove the DC term +
Pdd([1 2]) = 0; % Remove the DC term +

Pxx_int = cumsum(Pxx)/NFFT;   % mm^2
Pyy_int = cumsum(Pyy)/NFFT;   % mm^2
Paa_int = cumsum(Paa)/NFFT;
Pbb_int = cumsum(Pbb)/NFFT;
Pcc_int = cumsum(Pcc)/NFFT;
Pdd_int = cumsum(Pdd)/NFFT;


% std(a)
% sqrt(Paa_int(end))

TBT.PSD.Pxx = Pxx;
TBT.PSD.Pxx_int = Pxx_int;
TBT.PSD.Pyy = Pyy;
TBT.PSD.Pyy_int = Pyy_int;
TBT.PSD.Paa = Paa;
TBT.PSD.Paa_int = Paa_int;
TBT.PSD.Pbb = Pbb;
TBT.PSD.Pbb_int = Pbb_int;
TBT.PSD.Pcc = Pcc;
TBT.PSD.Pcc_int = Pcc_int;
TBT.PSD.Pdd = Pdd;
TBT.PSD.Pdd_int = Pdd_int;
TBT.PSD.f = FreqVec;
TBT.PSD.fs = fs;
TBT.PSD.T1 = T1;
TBT.PSD.N = NFFT;


TBT = bpm_plottbtpsd(TBT, FigNum);



function [Paa, WindowType] = psd_local(a, fs, WindowType)
N = length(a);
T1 = 1/fs;     % Sampling period of xy [seconds]

% ??? TurnsPerFFT = TBT.TurnNumber(end) / N;

if nargin < 3 || isempty(WindowType) || strcmpi(WindowType, 'None')
    w = ones(N,1);            % no window
else
    if exist('hanning','file')
        w = hanning(N);          % hanning window
        TBT.PSD.WindowType = 'Hanning';
    else
        w = ones(N,1);            % no window
    end
end
w = w(:);
U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

a_w = a .* w;
A = fft(a_w);
Paa = A.*conj(A)/N;
Paa = Paa/U;
Paa = Paa(1:ceil(N/2));
Paa(2:end) = 2*Paa(2:end);


