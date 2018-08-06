function FA = bpm_getfapsd(Prefix, TriggerMode, NAVG, FigNum)
%
%  Note: the function is using a Hanning window by default (signal processing TB)

% Written by Greg Portmann

if nargin < 1 || isempty(Prefix)
    Prefix = 'SR01C:BPM2';
    %Prefix = 'SR01C:BPM4';
end
if isstruct(Prefix)
    FA = Prefix;
    Prefix = '';
end
if isnumeric(Prefix)
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
end
if nargin < 2 || isempty(TriggerMode)
    TriggerMode = 'software';
end

if nargin < 3 || isempty(NAVG)
    if isempty(Prefix)
        NAVG = 1;
    else
        NAVG = 10;
    end
end

if nargin < 4
    FigNum = 101;
end

FontSize = 12;

Pxx = 0;
Pyy = 0;
Pss = 0;
Paa = 0;
Pbb = 0;
Pcc = 0;
Pdd = 0;

%T = 656e-9 * FA.TurnNumber(end)
%T = FA.TurnNumber(end) * 328/(ENV.RF0*1e6);
%fs = N / T;
fs = 10000;    % ?Sampling frequency of FA
WindowType = 'hanning';

FA.PSD.NAVG = NAVG;
            
for j = 1:NAVG
    if ~isempty(Prefix)
        OutlierFlag = 1;
        while OutlierFlag
            %if strcmpi(TriggerMode, 'software')
            %    %bpm_softtrigger(Prefix);
            %    bpm_trigger('Software', Prefix);
            %end
            bpm_trigger(TriggerMode, Prefix);
            
            FA = bpm_getfa(Prefix, [], FigNum);
            
            % For injection rejection
            %if (max(FA.X)-min(FA.X)) < .03
            if FA.S(end)-FA.S(1) > 500
                fprintf('  %d.  Possible injection:     max-min - %.3f um  Sum(end-start) = %d\n', j, 1000*(max(FA.X)-min(FA.X)), FA.S(end)-FA.S(1));
            else
                fprintf('  %d.  No injection detected:  max-min - %.3f um  Sum(end-start) = %d\n', j, 1000*(max(FA.X)-min(FA.X)), FA.S(end)-FA.S(1));
                OutlierFlag = 0;
            end        
        end
    end
    
    FA.PSD.WindowType = WindowType;
    Pxx = Pxx + psd_local(FA.X, fs, FA.PSD.WindowType) / NAVG;
    Pyy = Pyy + psd_local(FA.Y, fs, FA.PSD.WindowType) / NAVG;
    Pss = Pss + psd_local(FA.S, fs, FA.PSD.WindowType) / NAVG;
    Paa = Paa + psd_local(FA.A, fs, FA.PSD.WindowType) / NAVG;
    Pbb = Pbb + psd_local(FA.B, fs, FA.PSD.WindowType) / NAVG;
    Pcc = Pcc + psd_local(FA.C, fs, FA.PSD.WindowType) / NAVG;
    Pdd = Pdd + psd_local(FA.D, fs, FA.PSD.WindowType) / NAVG;
        
    figure(FigNum+4);
    clf reset
    h2 = subplot(2,1,1);
    plot((0:length(FA.X)-1)*1000/fs, FA.X);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('FA Data (RMS=%.3f \\mum))', 1000*std(FA.X)), 'FontSize', FontSize);
    
    h2(2) = subplot(2,1,2);
    plot((0:length(FA.X)-1)*1000/fs, FA.Y);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('FA Data (RMS=%.3f \\mum))', 1000*std(FA.Y)), 'FontSize', FontSize);
    axis tight
    drawnow;

    pause(.1);
    drawnow;
end

N = length(FA.X);
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

FA.PSD.Pxx = Pxx;
FA.PSD.Pxx_int = Pxx_int;
FA.PSD.Pyy = Pyy;
FA.PSD.Pyy_int = Pyy_int;
FA.PSD.Pss = Pss;
FA.PSD.Pss_int = Pss_int;
FA.PSD.Paa = Paa;
FA.PSD.Paa_int = Paa_int;
FA.PSD.Pbb = Pbb;
FA.PSD.Pbb_int = Pbb_int;
FA.PSD.Pcc = Pcc;
FA.PSD.Pcc_int = Pcc_int;
FA.PSD.Pdd = Pdd;
FA.PSD.Pdd_int = Pdd_int;
FA.PSD.f = FreqVec;
FA.PSD.fs = fs;
FA.PSD.T1 = T1;
FA.PSD.N = N;


FA = bpm_plotfapsd(FA, FigNum);



function [Paa, WindowType] = psd_local(a, fs, WindowType)
N = length(a);
T1 = 1/fs;     % Sampling period of xy [seconds]

% ??? TurnsPerFFT = FA.TurnNumber(end) / N;

if nargin < 3 || isempty(WindowType) || strcmpi(WindowType, 'None')
    w = ones(N,1);            % no window
    Paa.PSD.WindowType = 'None';
else
    w = hanning_local(N);          % hanning window
    Paa.PSD.WindowType = 'Hanning';
    %w = ones(N,1);            % no window
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


function w = hanning_local(n)
w = .5*(1 - cos(2*pi*(1:n/2)'/(n+1)));
w = [w; w(end:-1:1)];

