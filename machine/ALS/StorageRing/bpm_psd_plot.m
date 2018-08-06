function varargout = bpm_psd_plot(varargin)
% function varargout = bpm_psd_plot(varargin)
%
% Plot FFB data
% Christoph Steier, 2004-09-2


% Needed for standalone, if using MML functions that require the AO,AD setup or setting up LabCA
checkforao;


if ispc
    pathname = '\\Als-filer\crconfs1\prod\srdata\orbitfeedback_fast\log\';
    %filename2 = '\\Als-filer\physdata\matlab\srdata\orbitfeedback_fast\log\SR09ctl.log';
    %ImageDir = '\\Als-filer\als2\www\htdoc\dynamic_pages\incoming\portmann\';
    ImageDir = '\\Als-filer\alswebdata\portmann\';
elseif ismac
    pathname = '/Volumes/crconfs1/prod/srdata/orbitfeedback_fast/log/';
    %filename2 = '/home/als/physdata/matlab/srdata/orbitfeedback_fast/log/SR09ctl.log';
    ImageDir = '/Volumes/als2/www/htdoc/dynamic_pages/incoming/portmann/';
else
    pathname = '/home/crconfs1/prod/srdata/orbitfeedback_fast/log/';
    %filename2 = '/home/als/physdata/matlab/srdata/orbitfeedback_fast/log/SR09ctl.log';
    ImageDir = '/home/als2/www/htdoc/dynamic_pages/incoming/portmann/';
end

filenamewc = sprintf('bpm*.log');


BPMlist = [5 10;6 1];  % IDBPM [6 1;6 2]
IDxnames = family2channel('BPMx', BPMlist);
IDynames = family2channel('BPMy', BPMlist);

% IDxnames = [
%     'SR09S___IBPM1X_AM00'
%     'SR09S___IBPM2X_AM02'];
%
% IDynames = [
%     'SR09S___IBPM1Y_AM01'
%     'SR09S___IBPM2Y_AM03'];


for loop = 1:size(IDxnames,1)
    changeindex = findstr(IDxnames(loop,:), 'X_AM');
    IDxnames(loop,changeindex:(changeindex+3)) = 'XRAM';
end

for loop = 1:size(IDynames,1)
    changeindex = findstr(IDynames(loop,:), 'Y_AM');
    IDynames(loop,changeindex:(changeindex+3)) = 'YRAM';
end

%try
PauseBetweenUpdates = 360; %log files take >180 seconds to write completely
f1 = figure;
h = f1;
tic
while 1
    state = scaget('SR_STATE');
    ffbon = scaget('SR01____FFBON__BC00');
    
    if state > 4 && ((ffbon == 1) || (ffbon == 2))
        % if state == 5 %using this for two-bunch mode (no ffb)
        tic
        
        scaput('SR01____FFBLOG_BC00',1);
        pause(0.005);
        scaput('SR01____FFBLOG_BC00',0);
        
        dt = 1/scaget('SR01____FFBFREQAM00');
        fprintf('   Delta_t = %.2f\n',toc);
        
        % Pause for a bit
        fprintf('   Pausing %.1f seconds ... ', PauseBetweenUpdates);
        pause(PauseBetweenUpdates);
        fprintf('   Done\n');
        
        % unix(['cp ' filename ' bpmdata_' datestr(now,30) '.log']);
        % unix(['cp ' filename2 ' cmdata_' datestr(now,30) '.log']);
        
        dirdata = dir([pathname 'SR06' filenamewc]);
        datevect = zeros(length(dirdata),1);
        for loop = 1:length(dirdata)
            datevect(loop)= datenum(dirdata(loop).date);
        end
        [lastdat, ind] = max(datevect);
        filename = [pathname dirdata(ind).name];
        
        if findstr(filename,'.log')
            bpmdata = importdata(filename);
            if scaget('SR01____FFBON__BC00')
                % Problem with too many files accumulating in the directory ...
                %
                % (Temporary) workaround: If feedback is still running, erase .log
                % files after they have been read by this program. That way, logs
                % generated after feedback trips should not be erased.
                
                for loop2=1:12
                    sectorstr=sprintf('SR%02d',loop2);
                    dirdata=dir([pathname sectorstr filenamewc]);
                    datevect=zeros(length(dirdata),1);
                    for loop=1:length(dirdata)
                        datevect(loop)= datenum(dirdata(loop).date);
                    end
                    [lastdat,ind]=max(datevect);
                    if ~isempty(ind)
                        filename=[pathname dirdata(ind).name];
                        if ~isempty(dirdata(ind).name)
                            del_name=sprintf('SR%02d*%s.log',loop2,dirdata(ind).name(8:19));
                            del_name=[pathname del_name];
                            disp(['   Removing file/files ',del_name]);
                            delete(del_name);
                            %unix(['rm ',del_name]);
                        end
                    end
                end
            end
            if ~isempty(str2num(version('-release')))
                if (str2num(version('-release'))<14)
                    bpmdata.textdata=split(bpmdata.textdata{1},' ');
                end
            elseif (strcmp(version('-release'),'2006b'))
                bpmdata.textdata=split(bpmdata.textdata{1},' ');
            end
        else
            load(filename);
        end
        
        loop2 = 1; suppress_inj = 1;
        for loop = 2:(size(bpmdata.data,2)-1)
            if strmatch(bpmdata.textdata{loop},IDxnames)
                labelstr=bpmdata.textdata{loop};
                replaceindex=findstr(labelstr,'_');
                if replaceindex
                    labelstr(replaceindex)=' ';
                end
                
                pause(1);
                [Pdd, f, Drms, Pdd_int, h] = ibpm_psd(bpmdata.data(:,loop), dt, 'r', h);
                set(h(7), 'String', [labelstr '      ' datestr(now)]);
                drawnow;
                
                if max(abs(bpmdata.data(:,loop)))<0.025
                    suppress_inj=0;
                end
                
                if ~suppress_inj % reject injection transients
                    fn = sprintf('psd%d',loop2);
                    %print locally
                    % print( f1, '-dpng', '-r0', fn );
                    %print to web location
                    print(f1, '-dpng', '-r0', [ImageDir, fn] );
                    if loop2==1
                        scaput('SR09S_IBPM1X_RMS',sqrt((1e6*Drms).^2-0.36^2));
                    elseif loop2==2
                        scaput('SR09S_IBPM2X_RMS',sqrt((1e6*Drms).^2-0.36^2));
                    end
                end
                loop2=loop2+1;
            end
        end
        
        for loop = 2:(size(bpmdata.data,2)-1)
            if strmatch(bpmdata.textdata{loop},IDynames)
                labelstr=bpmdata.textdata{loop};
                replaceindex=findstr(labelstr,'_');
                if replaceindex
                    labelstr(replaceindex)=' ';
                end
                
                pause(1);
                [Pdd, f, Drms, Pdd_int, h] = ibpm_psd(bpmdata.data(:,loop), dt, 'r', h);
                set(h(7), 'String', [labelstr '      ' datestr(now)]);
                drawnow;
                
                if ~suppress_inj % reject injection transients
                    fn = sprintf('psd%d',loop2);
                    %print locally
                    %  print( f1, '-dpng', '-r0', fn );
                    %print to web location
                    print(f1, '-dpng', '-r0', [ImageDir, fn]);
                    
                    if loop2 == 3
                        scaput('SR09S_IBPM1Y_RMS', sqrt((1e6*Drms).^2-0.72^2));
                    elseif loop2==4
                        scaput('SR09S_IBPM2Y_RMS', sqrt((1e6*Drms).^2-0.72^2));
                    end
                end
                
                loop2 = loop2 + 1;
            end
        end
        
    else
        fprintf('Pausing until orbit feedback runs again (dt=%.1f)...\n',toc);
        tic;
        pause(60);
    end
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
elseif nargin==1
    LineColor = 'b';
end

if nargout == 0
    PlotFlag = 1;
else
    PlotFlag = 0;
end
if nargin >= 2
    T = 1/1111;
end
if nargin >= 3
    PlotFlag = 1;
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
        h(4) = title(['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(1e6*Drms),' \mum)']);
        xlabel('Frequency [Hz]');
        ylabel('Mean Square Displacement [\mum^2]');
        legend off;
        %aa=axis;
        %axis([1 f(N/2) aa(3) aa(4)]);
        
        subplot(3,1,3);
        h(5) = plot(0:deltaX:deltaX*(N-1),1e6*detrend(a),LineColor);
        grid on;
        h(6) = title(['BPM DATA (mean removed) (RMS=',num2str(1e6*Drms_data),' \mum)']);
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
        set(h(4), 'String', ['BPM INTEGRATED DISPLACEMENT POWER SPECTRUM (RMS=',num2str(1e6*Drms),' \mum)']);
        
        set(h(5), 'XData', 0:deltaX:deltaX*(N-1), 'YData', 1e6*detrend(a));
        set(h(6), 'String', ['BPM DATA (mean removed) (RMS=',num2str(1e6*Drms_data),' \mum)']);
        
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

