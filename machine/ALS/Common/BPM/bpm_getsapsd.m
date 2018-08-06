%function SA = bpm_getsapsd(SA, NAVG, FigNum)
%function SA = bpm_getsapsd(Prefix, NAVG, FigNum)
%
%  Note: the function is using a Hanning window by default (signal processing TB)

% Written by Greg Portmann

% if nargin < 1 || isempty(Prefix)
%     Prefix = 'SR01C:BPM4';
% end
% if isstruct(Prefix)
%     SA = Prefix;
%     Prefix = '';
% end
% if isnumeric(Prefix)
%     % DeviceList input
%     DeviceList = Prefix;
%     Prefix =  getfamilydata('BPM','BaseName', DeviceList);
% end
% if nargin < 2 || isempty(TriggerMode)
%     TriggerMode = 'software';
% end
% 
% if nargin < 3 || isempty(NAVG)
%     if isempty(Prefix)
%         NAVG = 1;
%     else
%         NAVG = 10;
%     end
% end
% 
% if nargin < 4
%     FigNum = 101;
% end

FigNum = 101;
FontSize = 12;
Prefix = SA.Prefix;

NAVG = 30;
N = 2^16;  % DFT length  2^16/10/60/60 = 1.82 hours

Pxx = 0;
Pyy = 0;
Paa = 0;
Pbb = 0;
Pcc = 0;
Pdd = 0;

%fs = N / T;
fs = 10;    % Sampling frequency of SA
WindowType = 'hanning';

SA.PSD.NAVG = NAVG;
SA.PSD.N = N;

for j = 1:NAVG
   
    nn = (1:N) + N*(j-1);
    
    SA.PSD.WindowType = WindowType;
    Pxx = Pxx + psd_local(SA.X(nn),       fs, SA.PSD.WindowType) / NAVG;
    Pyy = Pyy + psd_local(SA.Y(nn),       fs, SA.PSD.WindowType) / NAVG;
    Paa = Paa + psd_local(SA.RFmag(nn,1), fs, SA.PSD.WindowType) / NAVG;
    Pbb = Pbb + psd_local(SA.RFmag(nn,2), fs, SA.PSD.WindowType) / NAVG;
    Pcc = Pcc + psd_local(SA.RFmag(nn,3), fs, SA.PSD.WindowType) / NAVG;
    Pdd = Pdd + psd_local(SA.RFmag(nn,4), fs, SA.PSD.WindowType) / NAVG;
        
    figure(FigNum+4);
    clf reset
    h2 = subplot(2,1,1);
    plot((0:N-1)/fs, SA.X(nn));
    xlabel('Time [Seconds]',  'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.X)), 'FontSize', FontSize);
    
    h2(2) = subplot(2,1,2);
    plot((0:N-1)/fs, SA.Y(nn));
    xlabel('Time [Seconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.Y)), 'FontSize', FontSize);
    axis tight
    
    drawnow;

end

NN = SA.PSD.N * SA.PSD.NAVG;
SA.X = SA.X(1:NN);
SA.Y = SA.Y(1:NN);
SA.A = SA.RFmag(1:NN,1);
SA.B = SA.RFmag(1:NN,2);
SA.C = SA.RFmag(1:NN,3);
SA.D = SA.RFmag(1:NN,4);

T1 = 1 / fs;
Nfreq = length(Paa);
FreqVec = ((0:Nfreq-1)/Nfreq)*(fs/2);


Pxx([1 2]) = 0; % Remove the DC term +
Pyy([1 2]) = 0; % Remove the DC term +
Paa([1 2]) = 0; % Remove the DC term +
Pbb([1 2]) = 0; % Remove the DC term +
Pcc([1 2]) = 0; % Remove the DC term +
Pdd([1 2]) = 0; % Remove the DC term +

Pxx_int = cumsum(Pxx)/N;   % mm^2
Pyy_int = cumsum(Pyy)/N;   % mm^2
Paa_int = cumsum(Paa)/N;
Pbb_int = cumsum(Pbb)/N;
Pcc_int = cumsum(Pcc)/N;
Pdd_int = cumsum(Pdd)/N;


% std(a)
% sqrt(Paa_int(end))

SA.PSD.Pxx = Pxx;
SA.PSD.Pxx_int = Pxx_int;
SA.PSD.Pyy = Pyy;
SA.PSD.Pyy_int = Pyy_int;
SA.PSD.Paa = Paa;
SA.PSD.Paa_int = Paa_int;
SA.PSD.Pbb = Pbb;
SA.PSD.Pbb_int = Pbb_int;
SA.PSD.Pcc = Pcc;
SA.PSD.Pcc_int = Pcc_int;
SA.PSD.Pdd = Pdd;
SA.PSD.Pdd_int = Pdd_int;
SA.PSD.f = FreqVec;
SA.PSD.fs = fs;
SA.PSD.T1 = T1;
SA.PSD.N = N;


SA = bpm_plotsapsd(SA, FigNum);

if 0
    % Reduce the data for a save
    clear SA_noisefloor
    SA_noisefloor.Prefix = SA.Prefix;
    SA_noisefloor.X = SA.X;
    SA_noisefloor.Y = SA.Y;
    SA_noisefloor.A = SA.A;
    SA_noisefloor.B = SA.B;
    SA_noisefloor.C = SA.C;
    SA_noisefloor.D = SA.D;
    SA_noisefloor.PSD = SA.PSD;
    save bpm_sa_noisefloor SA_noisefloor
elseif 1
        % Reduce the data for a save
    clear SA2
    SA2.Prefix = SA.Prefix;
    SA2.X = SA.X;
    SA2.Y = SA.Y;
    SA2.A = SA.A;
    SA2.B = SA.B;
    SA2.C = SA.C;
    SA2.D = SA.D;
    SA2.PSD = SA.PSD;
    save bpm_sa_SR01C_BPM2_Jan2018 SA2
end


function [Paa, WindowType] = psd_local(a, fs, WindowType)
N = length(a);
T1 = 1/fs;     % Sampling period of xy [seconds]

% ??? TurnsPerFFT = SA.TurnNumber(end) / N;

if nargin < 3 || isempty(WindowType) || strcmpi(WindowType, 'None')
    w = ones(N,1);            % no window
    WindowType = 'None';
else
    w = hanning_local(N);          % hanning window
    WindowType = 'Hanning';
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
end

function w = hanning_local(n)
w = .5*(1 - cos(2*pi*(1:n/2)'/(n+1)));
w = [w; w(end:-1:1)];
end