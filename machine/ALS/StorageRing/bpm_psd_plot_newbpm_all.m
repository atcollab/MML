function varargout = bpm_psd_plot_newbpm_all(varargin)
% function varargout = bpm_psd_plot_newbpm_all(varargin)
%
% Plot fast orbit data - using new BPMs
% Christoph Steier, 2015-08


% Needed for standalone, if using MML functions that require the AO,AD setup or setting up LabCA
checkforao;


BPMlist = getlist('BPM');  
% BPMlist = [10 3;10 8];  
IDxnames = family2channel('BPMx', BPMlist);
IDynames = family2channel('BPMy', BPMlist);

dt = 1/10000;

for loop=1:size(IDxnames,1)
    setpvonline([IDxnames(loop,1:end-8) 'wfr:FA:arm'],0);
    setpvonline([IDxnames(loop,1:end-8) 'wfr:FA:acqCount'],50000);
    setpvonline([IDxnames(loop,1:end-8) 'wfr:FA:triggerMask'],bin2dec('01000011'));
    setpvonline([IDxnames(loop,1:end-8) 'EVR:event122trig'],bin2dec('01000000'));
end


%try
PauseBetweenUpdates = 25; 
f1 = figure;
h = f1;

tic

    
    state = scaget('SR_STATE');
    ffbon = scaget('SR01____FFBON__BC00');
    
    if state == 5 && ((ffbon == 1) || (ffbon == 2))
        % if state == 5 %using this for two-bunch mode (no ffb)
        tic
        
        for loop=1:size(IDxnames,1)
            setpvonline([IDxnames(loop,1:end-8) 'wfr:FA:arm'],1);
        end
        
        pause(0.5);
        
        while getpv([IDxnames(1,1:end-8) 'wfr:FA:armed']) & getpv([IDxnames(2,1:end-8) 'wfr:FA:armed'])
            pause(0.2);
        end
        
        pause(0.5);

        for loop=1:size(IDxnames,1)
            bpmx(loop,:)=getpvonline([IDxnames(loop,1:end-8) 'wfr:FA:c0'])/1e6; 
            bpmy(loop,:)=getpvonline([IDynames(loop,1:end-8) 'wfr:FA:c1'])/1e6;
        end

        bpmx=(bpmx'-ones(length(bpmx),1)*mean(bpmx'))';
        bpmy=(bpmy'-ones(length(bpmy),1)*mean(bpmy'))';
               

        figure
        subplot(2,1,1)
        plot(bpmx')
        subplot(2,1,2)
        plot((1:length(bpmx))./length(bpmx).*1e4,abs(fft(bpmx')))

        figure
        subplot(2,1,1)
        plot(bpmy')
        subplot(2,1,2)
        plot((1:length(bpmy))./length(bpmy).*1e4,abs(fft(bpmy')))

%         loop2 = 1; 
%         for loop = 1:size(bpmx,1)
%             
%             [Pdd, f, Drms, Pdd_int, h] = ibpm_psd(bpmx(loop,:), dt, 'r', h);
%             set(h(7), 'String', [datestr(now)]);
%             drawnow;
%                        
% 
%         end
%         
%         for loop = 1:size(bpmy,1)
%             
%             [Pdd, f, Drms, Pdd_int, h] = ibpm_psd(bpmy(loop,:), dt, 'r', h);
%             set(h(7), 'String', [datestr(now)]);
%             drawnow;
%             
%             
%             loop2 = loop2 + 1;
%         end
        
    else
        fprintf('Pausing until orbit feedback runs again (dt=%.1f)...\n',toc);
        tic;
        pause(60);
    end

% catch
%    disp('Exiting ...');
%    return
% end


function [Pdd, f, Drms, Pdd_int, h] = ibpm_psd(data, T, LineColor, h)
%BPM_PSD - Computes the power spectral density of orbit data
%  [Pdd, f, Drms, Pdd_int] = bpm_psd(Data, LineColor)
%
%  INPUTS
%  1. Data - 1.111 kHz data
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
elseif nargin<3
    LineColor = 'b';
end

if nargout == 0
    PlotFlag = 0;
else
    PlotFlag = 1;
end
if nargin < 2
    T = 1/1111;
end

N = length(data);
if rem(N,2) ~= 0
    N = N - 1;
    data = data(1:end-1);
end
deltaX = T;   % seconds


T  = deltaX*N;
T1 = deltaX;
f0 = 1/(N*T1);
f  = f0*(0:N/2)';

iNaN = find(isnan(data));
if length(iNaN) > 0
    fprintf('   WARNING: %d NaN replaced with 0\n', length(iNaN));
    data(iNaN) = 0;
end

a  = data / 1000;  % meters
%a = a-mean(a);
%a = detrend(a);
Drms_data = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));


% POWER SPECTRUM
if exist('hanning','file')
    w = hanning(N);    % hanning window
else
    w = ones(N,1);     % no window
end
w = w(:);
a = a(:);
a_w = a .* w;
A = fft(a_w);
Pdd = A.*conj(A)/N;

%Pdd = zeros(1,N/2+1);
%Drms = 0;
%Pdd_int = cumsum(Pdd);
%return;


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
    if isempty(h) || length(h)==1
        if isempty(h)
            figure;
        else
            figure(h);
            clf reset
        end
        
        subplot(3,1,1);
        h(1) = loglog(f(m+1:N/2),1e12*Pdd(m+1:N/2),LineColor);
        grid on;
        h(2) = title(['BPM POWER SPECTRUM (',num2str(N), ' points)']);
        xlabel('Frequency [Hz]');
        ylabel('PSD [\mum^2/Hz]');
        legend off;
        %aa=axis;
        %axis([1 fx(N/2) aa(3) aa(4)]);
        
        % Position spectrum
        subplot(3,1,2);
        h(3) = semilogx(f(m:N/2),1e12*Pdd_int(m:N/2), LineColor);
        grid on;
        %semilogx(f(m:N/2),sqrt(Pdd_int(m:N/2)), LineColor); grid on;
        h(4) = title(['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(sqrt((1e6*Drms).^2-0.2^2)),' \mum)']);
        xlabel('Frequency [Hz]');
        ylabel('Mean Square Displacement [\mum^2]');
        legend off;
        %aa=axis;
        %axis([1 f(N/2) aa(3) aa(4)]);
        
        subplot(3,1,3);
        h(5) = plot(0:deltaX:deltaX*(N-1),1e6*detrend(a),LineColor);
        xaxis([0 0.2*deltaX*(N-1)]);
        grid on;
        h(6) = title(['BPM DATA (mean removed) (RMS=',num2str(sqrt((1e6*Drms).^2-0.2^2)),' \mum)']);
        xlabel('Time [seconds]');
        ylabel('Displacement [\mum]');
        legend off;
        
        h(7) = addlabel(datestr(now));
        set(h(7), 'Interpreter','None');
        
        orient tall
        
    else
        set(h(1), 'XData', f(m+1:N/2), 'YData', 1e12*Pdd(m+1:N/2));
        set(h(2), 'String', ['BPM POWER SPECTRUM (',num2str(N), ' points)']);
        
        set(h(3), 'XData', f(m:N/2), 'YData', 1e12*Pdd_int(m:N/2));
        set(h(4), 'String', ['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(sqrt((1e6*Drms).^2-0.2^2)),' \mum)']);
        
        set(h(5), 'XData', 0:deltaX:deltaX*(N-1), 'YData', 1e6*detrend(a));
        set(h(6), 'String', ['BPM DATA (mean removed) (RMS=',num2str(sqrt((1e6*Drms).^2-0.2^2)),' \mum)']);
        
        set(h(7), 'String', datestr(now));
    end
end



function cellOut = split(string, delimiter)
%SPLIT rip string apart using strtok
i = 1;
[cellOut{i}, string] = strtok(string, delimiter);
while ~isempty(string)
    i = i + 1;
    [cellOut{i}, string] = strtok(string, delimiter);
end

