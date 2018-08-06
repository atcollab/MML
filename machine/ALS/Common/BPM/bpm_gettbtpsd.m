function TBT = bpm_gettbtpsd(Prefix, TriggerMode, NAVG, FigNum)
%

% Written by Greg Portmann

N = 100000;

if nargin < 1
    Prefix = '';  %getappdata(0, 'EPICS_BPM_PREFIX');
end
if isempty(Prefix)
  %  Prefix = 'SR01C:BPM2';
    Prefix = 'SR01C:BPM5';
   %Prefix = 'BR3:BPM4';
end
if isstruct(Prefix)
    TBT = Prefix;
    Prefix = '';
end

if nargin < 2 || isempty(TriggerMode)
    TriggerMode = 'software';
end

if nargin < 3 || isempty(NAVG)
    NAVG = 10;
end

if nargin < 4
    FigNum = 401;
end

FontSize = 12;

Pxx = 0;
Pyy = 0;
Pss = 0;
Paa = 0;
Pbb = 0;
Pcc = 0;
Pdd = 0;


%T = 656e-9 * TBT.TurnNumber(end)
%T = TBT.TurnNumber(end) * 328/(ENV.RF0*1e6);
%fs = N / T;

if 1
    % SR
    fs = getrf * 1e6 / 328;    % Sampling frequency of TBT
else
    % BR
    fs = getrf * 1e6 / 125    % Sampling frequency of TBT
    %fs = getpvonline([Prefix,':AFE:adcRate']) / 29;
end

WindowType = 'None';

for j = 1:NAVG
    if ~isempty(Prefix)
        OutlierFlag = 1;
        while OutlierFlag
            if strcmpi(TriggerMode, 'software')
                bpm_softtrigger(Prefix);
            end
            
            TBT = bpm_gettbt(Prefix, N, []);
            
            % For injection rejection
            if (max(TBT.X)-min(TBT.X)) < .1
            %if (max(TBT.S)-min(TBT.S)) < 100000
                OutlierFlag = 0;
                fprintf('TBT max-min OK - %d\n', (max(TBT.S)-min(TBT.S)));
            else
                fprintf('TBT X outlier max-min - %.3f um\n', 1000*(max(TBT.X)-min(TBT.X)));
                fprintf('TBT Sum outlier max-min  - %d\n', (max(TBT.S)-min(TBT.S)));
                figure(1);
                subplot(2,1,1);
                plot(TBT.X)
                subplot(2,1,2);
                plot(TBT.S)
                drawnow;
            end            
           % OutlierFlag = 0;
        
        end
    end
    
    TBT.PSD.WindowType = WindowType;
    Pxx = Pxx + psd_local(TBT.X, fs, TBT.PSD.WindowType) / NAVG;
    Pyy = Pyy + psd_local(TBT.Y, fs, TBT.PSD.WindowType) / NAVG;
    Pss = Pss + psd_local(TBT.S, fs, TBT.PSD.WindowType) / NAVG;
    Paa = Paa + psd_local(TBT.A, fs, TBT.PSD.WindowType) / NAVG;
    Pbb = Pbb + psd_local(TBT.B, fs, TBT.PSD.WindowType) / NAVG;
    Pcc = Pcc + psd_local(TBT.C, fs, TBT.PSD.WindowType) / NAVG;
    Pdd = Pdd + psd_local(TBT.D, fs, TBT.PSD.WindowType) / NAVG;
        
    figure(FigNum+5);
    h2 = subplot(3,1,1);
    plot((0:length(TBT.X)-1)*1000/fs, TBT.X);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('TBT Horizontal (RMS=%.3f \\mum))', 1000*std(TBT.X)), 'FontSize', FontSize);
    axis tight

    h2(2) = subplot(3,1,2);
    plot((0:length(TBT.Y)-1)*1000/fs, TBT.Y);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('TBT Vertical (RMS=%.3f \\mum))', 1000*std(TBT.Y)), 'FontSize', FontSize);
    axis tight
    
    h2(3) = subplot(3,1,3);
    plot((0:length(TBT.S)-1)*1000/fs, TBT.S);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Sum', 'FontSize', FontSize);
    title(sprintf('TBT Sum (RMS=%.3f \\mum))', 1000*std(TBT.S)), 'FontSize', FontSize);
    axis tight
    drawnow;

    pause(.5);
end

N = length(TBT.X);
T1 = 1 / fs;
Nfreq = length(Paa);
FreqVec = ((0:Nfreq-1)/Nfreq)*(fs/2);

Pxx([1 2]) = 0; % Remove the DC term +
Pyy([1 2]) = 0; % Remove the DC term +
Pss([1 2]) = 0; % Remove the DC term +
Paa([1 2]) = 0; % Remove the DC term +
Pbb([1 2]) = 0; % Remove the DC term +
Pcc([1 2]) = 0; % Remove the DC term +
Pdd([1 2]) = 0; % Remove the DC term +

Pxx_int = cumsum(Pxx)/N;   % mm^2
Pyy_int = cumsum(Pyy)/N;   % mm^2
Pss_int = cumsum(Pss)/N;
Paa_int = cumsum(Paa)/N;
Pbb_int = cumsum(Pbb)/N;
Pcc_int = cumsum(Pcc)/N;
Pdd_int = cumsum(Pdd)/N;


% std(a)
% sqrt(Paa_int(end))

TBT.PSD.Pxx = Pxx;
TBT.PSD.Pxx_int = Pxx_int;
TBT.PSD.Pyy = Pyy;
TBT.PSD.Pyy_int = Pyy_int;
TBT.PSD.Pss = Pss;
TBT.PSD.Pss_int = Pss_int;
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
TBT.PSD.N = N;


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


