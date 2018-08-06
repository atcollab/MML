function [Pdd, f, Drms, Pdd_int] = monbpmpsd(varargin)
%BPM_PSD - Computes the power spectral density of orbit data
%  [Pdd, f, Drms, Pdd_int] = monbpmpsd(Data, DeviceList, LineColor)
%
%  INPUTS
%  1. Data
%  2. DeviceList
%  3. LineColor - {Default: 'b'}
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


if ~isempty(varargin)
    FileName = varargin{1};
    varargin(1) = [];
else
    FileName = [];
end

if isstruct(FileName)
    BPMx = FileName;
    if ~isempty(varargin)
        BPMy = varargin{2};
        varargin(1) = [];
    else
        BPMy = BPMx;
    end
    % BPM response matrix cludge
    if all(size(BPMx) == [2 2])
        BPMx = BPMx(1,1);
    end
else
    DirFlag = 0;
    if isdir(FileName)
        DirFlag = 1;
    else
        if length(FileName)>=1
            if strcmp(FileName(end),filesep)
                DirFlag = 1;
            end
        end
    end
    if strcmp(FileName,'.') || isempty(FileName) || DirFlag
        % Data root
        if strcmp(FileName,'.')
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze');
        elseif DirFlag
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze', FileName);
        else
            DirectoryName = getfamilydata('Directory','DataRoot');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a file to analyze', DirectoryName);
        end
        if FileName == 0
            return
        end
        FileName = [DirectoryName FileName];
    end
    
    % Get data from file
    try
        BPMxFamily = gethbpmfamily;
        BPMyFamily = getvbpmfamily;
        HBPM = getdata(BPMxFamily, FileName, 'Struct');
        VBPM = getdata(BPMyFamily, FileName, 'Struct');
    catch
        disp('Not sure what type of file this is.');
        return
    end
end

if ~isempty(varargin)
    DeviceList = varargin{1};
    varargin(1) = [];
else
    DeviceList = [];
end

if ~isempty(varargin)
    LineColor = varargin{1};
else
    LineColor = 'b';
end

if ~isempty(DeviceList)
    i = findrowindex(DeviceList, HBPM.DeviceList);
    HBPM.Data = HBPM.Data(i,:);
    HBPM.DeviceList = HBPM.DeviceList(i,:);

    i = findrowindex(DeviceList, VBPM.DeviceList);
    VBPM.Data = VBPM.Data(i,:);
    VBPM.DeviceList = VBPM.DeviceList(i,:);
end

m = 3;

if rem(size(HBPM.Data,2), 2) == 1
    HBPM.Data(:,end) = [];
    VBPM.Data(:,end) = [];
    HBPM.t(:,end) = [];
    VBPM.t(:,end) = [];
end

N = size(HBPM.Data,2);
Tsample = mean(diff(HBPM.t));   % seconds
Fig1 = figure(1); %gcf;
clf reset
for i = 1:size(HBPM.Data,1)
    [Pxx(i,:), f] = calcpsd(HBPM.Data(i,:), Tsample);
    PlotPSDLocal(f, Pxx(i,:), HBPM.Data(i,:)/1000, Tsample, m, LineColor);
end

% Plot the power spectrum
figure(Fig1+1);
%clf reset
%loglog(f, 1e12*mean(Pxx,1), LineColor);
loglog(f(m+1:end), 1e12*mean(Pxx(:,m+1:end),1), LineColor);
grid on;
%hold on
if size(Pxx,1) > 1
    title(sprintf('BPM POWER SPECTRUM (%d points, %d Averages)', N, size(Pxx,1)));
else
    title(sprintf('BPM POWER SPECTRUM (%d points)', N));
end
xlabel('Frequency [Hz]');
ylabel('PSD [\mum^2/Hz]');
legend off;
%axis([2 2000 1e-4 1]);
axis tight



function [Pdd, f] = calcpsd(data, Tsample)
N = length(data);
T  = Tsample*N;
T1 = Tsample;
f0 = 1/(N*T1);
f  = f0*(0:N/2)';
a  = data / 1000;  % meters
%a = a-mean(a);
%a = detrend(a);

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
Pdd(2:N/2+1) = 2*Pdd(2:N/2+1);


% PSD using matlab functions (NOTE: matlab function detrend by default)
%PddS = spectrum(a,N,0,w,f0); PddS = 2*PddS(:,1); PddS(1)=PddS(1)/2;
%PddPSD=2*psd(a,N); PddPSD(1)=PddPSD(1)/2;


function PlotPSDLocal(f, Pdd, a, T1, m, LineColor)
% Output
%fprintf('\nRMS Displacement: %g meters   (Time series data, %d points, mean removed)\n', Drms_data, N);
%fprintf('RMS Displacement: %g meters   (PSD, Parseval''s Thm, first %d frequencies removed)\n', Drms, m);

N = length(a);

% Paa(0) is the DC term, and the first few data points are questionable in an FFT
Pdd(1) = 0;   % not sure if the DC term is correct
Pdd1 = Pdd;
for i=1:m
    Pdd1(i) = 0;
end

% Parseval's Thm
Drms  = sqrt(sum(Pdd1)/N);
Pdd_int = cumsum(Pdd1)/N;

% Make PSD units meters^2/Hz
Pdd = T1*Pdd;

[LineColor, LineStyle, LineNumber] = nextline;

% Plot the power spectrum
subplot(3,1,1);
%loglog(f, 1e12*Pdd, LineColor);
loglog(f(m+1:N/2),1e12*Pdd(m+1:N/2), 'Color',LineColor, 'LineStyle',LineStyle);
grid on;
hold on
title(['BPM POWER SPECTRUM (',num2str(N), ' points)']);
xlabel('Frequency [Hz]');
ylabel('PSD [\mum^2/Hz]');
legend off;
%  axis([2 2000 1e-4 1]);
axis tight

% Position spectrum
subplot(3,1,2);
loglog(f(m+1:N/2),1e12*Pdd_int(m+1:N/2), 'Color',LineColor, 'LineStyle',LineStyle);
grid on;
hold on
%semilogx(f(m:N/2),sqrt(Pdd_int(m:N/2)), LineColor); 
%title(['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(1e6*Drms),' \mum)']);
title('INTEGRATED POWER SPECTRUM');
xlabel('Frequency [Hz]');
ylabel('[\mum^2]');
legend off;
%   xaxis([2 2000]);
axis tight


Drms_data = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));

subplot(3,1,3);
plot(0:T1:T1*(N-1),1e6*detrend(a), 'Color',LineColor, 'LineStyle',LineStyle); 
grid on; 
hold on
%title(['BPM DATA (mean removed) (RMS=',num2str(1e6*Drms_data),' \mum)']);
title('BPM Time Series Data (mean removed)');
xlabel('Time [seconds]');
ylabel('[\mum]');
legend off;

% drawnow;
% orient tall



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
% plot(0:T1:T1*(N-1),detrend(a),LineColor); grid on;
% title(['BPM DATA (mean removed) (RMS=',num2str(Drms_data),' meters)']);
% xlabel('Time (seconds)');
% ylabel('Displacement (meters)');
% legend off;
%
% orient tall