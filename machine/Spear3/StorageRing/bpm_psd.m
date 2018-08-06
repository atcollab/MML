function [Pdd, f, Drms, Pdd_int] = bpm_psd(data, LineColor)
%BPM_PSD - Computes the power spectral density of orbit data
%  [Pdd, f, Drms, Pdd_int] = bpm_psd(Data, LineColor)
%
%  INPUTS
%  1. Data - 4 kHz data
%  2. LineColor - {Default: 'b'}
%     If input 2 exists or no output exists, then data will be plotted to the screen
%
%  OUTPUTS
%  1. Pdd     - Displacement power spectrum  [(m)^2/Hz]
%  2. f       - Frequency vector [Hz]
%  3. Drms    - RMS deplacement [m]
%  4. Pdd_int - Integrated RMS deplacement squared [m^2]
%
%  NOTES
%  1. If the hanning function exists, then a hanning window will be used
%
%  Written by Greg Portmann

if nargin==0 
    error('This function requires one input arguement (FileName).')
elseif nargin==1
    LineColor = 'b';
end

if nargout == 0
    PlotFlag = 1;
else
    PlotFlag = 0;
end
if nargin >= 2
    PlotFlag = 1;
end

N = length(data);
deltaX = 1/4000;   % seconds


T  = deltaX*N;
T1 = deltaX;
f0 = 1/(N*T1);
f  = f0*(0:N/2)';
a  = data / 1000;  % meters  
%a = a-mean(a);
%a = detrend(a);
Drms_data = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));
% POWER SPECTRUM
if exist('hanning','file')
    w = hanning(N);    % hanning window
else
    w = ones(N,1);    % no window
end
w = w(:);
a = a(:);
a_w = a .* w;
A = fft(a_w);
Pdd = A.*conj(A)/N;
U = sum(w.^2)/N;              % approximately .375 for hanning
U2 = ((norm(w)/sum(w))^2);    % used to normalize plots (p. 1-68, matlab DSP toolbox)
Pdd=Pdd/U;
Pdd(N/2+2:N) = [];
Pdd(2:N/2+1)=2*Pdd(2:N/2+1);


% PSD using matlab functions (NOTE: matlab function detrend by default)
%PddS = spectrum(a,N,0,w,f0); PddS = 2*PddS(:,1); PddS(1)=PddS(1)/2;
%PddPSD=2*psd(a,N); PddPSD(1)=PddPSD(1)/2;


% Paa(0) is the DC term, and the first few data points are questionable in an FFT
Pdd(1) = 0;   % not sure if the DC term is correct
Pdd1 = Pdd;
m = 2;
for i=1:m
    Pdd1(i) = 0;
end

% Parseval's Thm
Drms  = sqrt(sum(Pdd1)/N);
Pdd_int = cumsum(Pdd1)/N;

% Make PSD units meters^2/Hz
Pdd = T1*Pdd;


if PlotFlag
    % Output
    %fprintf('\nRMS Displacement: %g meters   (Time series data, %d points, mean removed)\n', Drms_data, N);
    %fprintf('RMS Displacement: %g meters   (PSD, Parseval''s Thm, first %d frequencies removed)\n', Drms, m);
    
    % Plot the power spectrum
    subplot(3,1,1);
    
    loglog(f(m+1:N/2),1e12*Pdd(m+1:N/2),LineColor); grid on;hold on
    title(['BPM POWER SPECTRUM (',num2str(N), ' points)']);
    xlabel('Frequency [Hz]');
    ylabel('PSD [\mum^2/Hz]');
    legend off;
    axis([2 2000 1e-4 1]);
    
    % Position spectrum
    subplot(3,1,2);
    loglog(f(m:N/2),1e12*Pdd_int(m:N/2), LineColor); grid on; hold on
    %semilogx(f(m:N/2),sqrt(Pdd_int(m:N/2)), LineColor); grid on;
    title(['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(1e6*Drms),' \mum)']);
    xlabel('Frequency [Hz]');
    ylabel('Mean Square Displacement [\mum^2]');
    legend off;
    xaxis([2 2000]);
    
    subplot(3,1,3);
    
    plot(0:deltaX:deltaX*(N-1),1e6*detrend(a),LineColor); grid on; hold on
    title(['BPM DATA (mean removed) (RMS=',num2str(1e6*Drms_data),' \mum)']);
    xlabel('Time [seconds]');
    ylabel('Displacement [\mum]');
    legend off;
    
    drawnow;
    
    orient tall
end



% % Plot the power spectrum
% %figure(3);
% subplot(3,1,1);
% loglog(f(3:N/2),Pdd(3:N/2),LineColor); grid on;
% title(['BPM POWER SPECTRUM (',num2str(N), ' points)']);
% xlabel('Frequency (Hz)');
% ylabel('[meters^2/Hz]');
% legend off;
% %aa=axis;
% %axis([1 100 aa(3) aa(4)]);
% 
% 
% % Position spectrum
% %figure(4);
% subplot(3,1,2);
% semilogx(f(m:N/2),Pdd_int(m:N/2), LineColor); grid on;
% %semilogx(f(m:N/2),sqrt(Pdd_int(m:N/2)), LineColor); grid on;
% title(['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(Drms),' meters)']);
% xlabel('Frequency (Hz)');
% ylabel('Mean Square Displacement (meters)^2');
% legend off;
% %aa=axis;
% %axis([1 100 aa(3) aa(4)]);
% 
% %figure(5);
% subplot(3,1,3);
% plot(0:deltaX:deltaX*(N-1),detrend(a),LineColor); grid on;
% title(['BPM DATA (mean removed) (RMS=',num2str(Drms_data),' meters)']);
% xlabel('Time (seconds)');
% ylabel('Displacement (meters)');
% legend off;
% 
% orient tall