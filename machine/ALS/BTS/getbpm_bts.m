function [Orbit, tout, DataTime, ErrorFlag] = getbpm_bts(Family, varargin)
% [x or y, tout, DataTime, ErrorFlag] = getbpm_bts(Family, DeviceList)
% [x or y, tout, DataTime, ErrorFlag] = getbpm_bts(Family, Field, DeviceList)
%

%  Written by Greg Portmann

persistent x y xsum ysum TimeStamp

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

FigNum = 0;
FFTFlag = 0;

% Xgain = 20;
% Ygain = 20;
% Xgain = 17.5;
% Ygain = 17.5;
%Xgain = 17.9; %18.5mm move on BTS BPM3 (Mike Chin BPM) for 10mm on TV4 with this gain value
%Ygain = 18.8; %19.4mm move on BTS BPM3 (Mike Chin BPM) for 10mm on TV4 with this gain value
XgainBPM3 = 15.7;
YgainBPM3 = 15.9;

XgainBPM2 = 15.1;
YgainBPM2 = 16.0;



tout = [];
DataTime = [];
ErrorFlag = 0;

% Field input
Field = 'Monitor';
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove the Field string
        Field = varargin{1};
        varargin(1) = [];
    end
end

if nargin < 1
    Family = 'BPMx';
end
if isempty(varargin)
    DeviceList = family2dev(Family);
else
    DeviceList = varargin{1};
end

if isempty(TimeStamp) || etime(clock,TimeStamp) > .25
    % Get new data
    %fprintf('   Getting new data\n');
    
    % Get ztec bpm
    %if 0
    ScopeName = 'ztec13';
    WaveCounter = getpvonline([ScopeName,':Inp1WaveCount']);
    Range = getpvonline('ztec13:getInp1Range');
    t = getpvonline([ScopeName,':InpScaledTime'],  'double', 2000);
    a = getpvonline([ScopeName,':Inp1ScaledWave'], 'double', 2000)*2^14/Range;
    b = getpvonline([ScopeName,':Inp2ScaledWave'], 'double', 2000)*2^14/Range;
    c = getpvonline([ScopeName,':Inp3ScaledWave'], 'double', 2000)*2^14/Range;
    d = getpvonline([ScopeName,':Inp4ScaledWave'], 'double', 2000)*2^14/Range;
    [WaveCounterEnd, tout, DataTime] = getpvonline([ScopeName,':Inp1WaveCount']);
    
    if WaveCounter ~= WaveCounterEnd
        %fprintf('  Warning: Injection occurred in the middle of a reading.');
    end
    
    N = 128;
    Offset = 20;
    
    if 1
        [tmp, i] = max(a);        
        t   = t(i-N/2+1+Offset:i+N/2+Offset);
        chA = a(i-N/2+1+Offset:i+N/2+Offset);
        chB = b(i-N/2+1+Offset:i+N/2+Offset);
        chC = c(i-N/2+1+Offset:i+N/2+Offset);
        chD = d(i-N/2+1+Offset:i+N/2+Offset);
    else
        [tmp, istart] = find(t<=-.5e-7);
        istart = max(istart);
        [tmp, iend]   = find(t>=2.5e-7);
        iend = min(iend);
        
        t = t(istart:iend);
        chA = a(istart:iend);
        chB = b(istart:iend);
        chC = c(istart:iend);
        chD = d(istart:iend);
    end
    
    if ~FFTFlag
        Arms = sqrt(sum((chA-mean(chA)).^2)/length(chA));
        Brms = sqrt(sum((chB-mean(chB)).^2)/length(chB));
        Crms = sqrt(sum((chC-mean(chC)).^2)/length(chC));
        Drms = sqrt(sum((chD-mean(chD)).^2)/length(chD));
    else
        Fs =  400e6;            % Sampling frequency [Hz]
        T1 = 1/Fs;              % Sampling period [seconds]
        T  = T1 * N;
        f0 = 1 / (N*T1);
        Nfreq = ceil(N/2);
        f = (0:Nfreq-1)*Fs/N;
        %fprintf('\n\n   Fs   =  %f MHz (%f nsec)\n\n', Fs/1e6, 1e9/Fs);
        
        %[tmp, iRMS] = find(f==100e6);
        [tmp, iRMS] = find(f==125e6);
        iFreq = iRMS-3:iRMS+3;
        %iFreq = iRMS;
        
        w = 1;
        U = 1;
        %if exist('hanning') == 0
        %    w = ones(N,1);            % no window
        %else
        %    w = hanning(N)';           % hanning window
        %end
        %U = sum(w.^2)/N;              % approximately .375 for hanning
        %U2 = ((norm(w)/sum(w))^2);    % used to normalize plots (p. 1-68, matlab DSP toolbox)
        
        % POWER SPECTRUM
        a_w = chA .* w;
        A = fft(a_w);
        P11 = A.*conj(A)/N;
        P11 = P11 / U;
        P11(ceil(N/2)+1:N) = [];
        P11(2:ceil(N/2)) = 2*P11(2:ceil(N/2));
        
        a_w = chB .* w;
        A = fft(a_w);
        P22 = A.*conj(A)/N;
        P22 = P22/U;
        P22(ceil(N/2)+1:N) = [];
        P22(2:ceil(N/2)) = 2*P22(2:ceil(N/2));
        
        a_w = chC .* w;
        A = fft(a_w);
        P33 = A.*conj(A)/N;
        P33 = P33/U;
        P33(ceil(N/2)+1:N) = [];
        P33(2:ceil(N/2)) = 2*P33(2:ceil(N/2));
        
        a_w = chD .* w;
        A = fft(a_w);
        P44 = A.*conj(A)/N;
        P44 = P44/U;
        P44(ceil(N/2)+1:N) = [];
        P44(2:ceil(N/2)) = 2*P44(2:ceil(N/2));
        
        % Not sure if the DC term is correct
        P11(1) = 0;
        P22(1) = 0;
        P33(1) = 0;
        P44(1) = 0;
        
        RMS_11 = sqrt(sum((chA-mean(chA)).^2)/length(chA));
        RMS_22 = sqrt(sum((chB-mean(chB)).^2)/length(chB));
        RMS_33 = sqrt(sum((chC-mean(chC)).^2)/length(chC));
        RMS_44 = sqrt(sum((chD-mean(chD)).^2)/length(chD));
        
        P11_int = cumsum(P11)/N;
        P22_int = cumsum(P22)/N;
        P33_int = cumsum(P33)/N;
        P44_int = cumsum(P44)/N;
        
        % fprintf('   chA RMS: %g counts (Time series data)\n', RMS_11);
        % fprintf('   chA RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P11_int(end)));
        %
        % fprintf('   chB RMS: %g counts (Time series data)\n', RMS_22);
        % fprintf('   chB RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P22_int(end)));
        %
        % fprintf('   chC RMS: %g counts (Time series data)\n', RMS_33);
        % fprintf('   chC RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P33_int(end)));
        %
        % fprintf('   chD RMS: %g counts (Time series data)\n', RMS_44);
        % fprintf('   chD RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P44_int(end)));
        
        Arms = cumsum(P11(iFreq))/N;
        Brms = cumsum(P22(iFreq))/N;
        Crms = cumsum(P33(iFreq))/N;
        Drms = cumsum(P44(iFreq))/N;
    end
    
    %else
    %    Arms = randn(1);
    %    Brms = randn(1);
    %    Crms = randn(1);
    %    Drms = randn(1);
    %end
    
    % SR
    %x = Xgain * (Arms-Brms-Crms+Drms) / (Arms+Brms+Crms+Drms); % mm
    %y = Ygain * (Arms+Brms-Crms-Drms) / (Arms+Brms+Crms+Drms); % mm
    
    % Linac (accept GTL1 and GTL2??), BTS
    x(1,1) = XgainBPM2 * (Drms-Brms) / (Drms+Brms); % mm
    y(1,1) = YgainBPM2 * (Arms-Crms) / (Arms+Crms); % mm
    xsum(1,1) = Brms+Drms;
    ysum(1,1) = Arms+Crms;
    
    %Paa     = [P11; P22; P33; P44];
    %Paa_int = [P11_int; P22_int; P33_int; P44_int];
    
    if 1
        figure(100);
        %clf reset
        subplot(2,1,1);
        plot(t*1e9, [chA;chB;chC;chD]);
        xlabel('Time [nsec]', 'Fontsize',12);
        ylabel('Stripline Signal [Counts]', 'Fontsize',12);
        title(sprintf('BTS BPM #2 (14-bit Ztec Scope)  %d',WaveCounter), 'Fontsize',12);
        yaxis([-4000 4000]);
    end


    
    % Mike's BPM
    tic       
    if isunix
        fid = fopen('/home/als/physbase/machine/ALS/BTS/BTSBPM_MIKE_chD.txt', 'r');
    else
        fid = fopen('N:\machine\ALS\BTS\BTSBPM_MIKE_chD.txt', 'r');
        %fid = fopen('C:\Users\portmann\Documents\Matlab\machine\ALS\BTS\BTSBPM_MIKE.txt', 'r');
    end
    
    while 1
        tmp = fgetl(fid); if ~ischar(tmp);break; end
        chA = tmp;
        tmp = fgetl(fid); if ~ischar(tmp);break; end
        chB = tmp;
        tmp = fgetl(fid); if ~ischar(tmp);break; end
        chC = tmp;
        tmp = fgetl(fid); if ~ischar(tmp);break; end
        chD = tmp;
        tmp = fgetl(fid); if ~ischar(tmp);break; end
    end
    fclose(fid);
    
    chA = str2num(chA);
    chB = str2num(chB);
    chC = str2num(chC);
    chD = str2num(chD);
    toctime = toc;
    
    if WaveCounter ~= getpvonline([ScopeName,':Inp1WaveCount'])
        %fprintf('  Warning: Injection occurred between computing BPM(2) and BPM(3).');
    end

    
    Arms = sqrt(sum((chA-mean(chA)).^2)/length(chA));
    Brms = sqrt(sum((chB-mean(chB)).^2)/length(chB));
    Crms = sqrt(sum((chC-mean(chC)).^2)/length(chC));
    Drms = sqrt(sum((chD-mean(chD)).^2)/length(chD));
    
    x(2,1) = XgainBPM3 * (Drms-Brms) / (Drms+Brms); % mm
    y(2,1) = YgainBPM3 * (Arms-Crms) / (Arms+Crms); % mm
    xsum(2,1) = Brms+Drms;
    ysum(2,1) = Arms+Crms;
    
    TimeStamp = clock;
    
    if 1
        figure(100);
        subplot(2,1,2);
        plot([chA;chB;chC;chD]');
        xlabel('Samples', 'Fontsize',12);
        ylabel('Stripline Signal [Counts]', 'Fontsize',12);
        title(sprintf('BTS BPM #3 (%.2f sec file read)  Max RMS=%.2f',toctime,max([Arms Brms Crms Drms])), 'Fontsize',12);
        yaxis([-4000 4000]);
        drawnow
    end
end


DeviceListTotal = family2dev(Family);
j = findrowindex(DeviceList, DeviceListTotal);

if strcmpi(Family, 'BPMx')
    if strcmpi(Field, 'Monitor')
        Orbit = x(j);
    else
        Orbit = xsum(j);
    end
else
    if strcmpi(Field, 'Monitor')
        Orbit = y(j);
    else
        Orbit = ysum(j);
    end
end




% h = subplot(2,2,1);
% plot(t_date, x(1,:)-x(1,1), 'b');
% hold on
% plot(t_date, -1*(x(2,:)-x(2,1)), 'g');
% hold off
% datetick x
% xlabel('Time');
% ylabel('Horizontal');
% 
% h(2) = subplot(2,2,3);
% plot(t_date, y(1,:)-y(1,1), 'b');
% hold on
% plot(t_date, y(2,:)-y(2,1), 'g');
% datetick x
% xlabel('Time');
% ylabel('Vertical');
% 
% h(3) = subplot(2,2,2);
% plot(t_date, xsum);
% datetick x
% xlabel('Time');
% ylabel('Horizontal Sum');
% 
% h(4) = subplot(2,2,4);
% plot(t_date, ysum);
% datetick x
% xlabel('Time');
% ylabel('Vertical Sum');
% 
% linkaxes(h, 'x');


if FigNum
    figure(FigNum);
    clf reset
    plot(t, [chA; chB; chC; chD]);
    
    % Button voltages
    figure(FigNum+1);
    clf reset
    
    h = subplot(2,1,1);
    plot(t_date, x);
    datetick x
    xlabel('Time');
    ylabel('Horizontal');
    
    h(2) = subplot(2,1,2);
    plot(t_date, y);
    datetick x
    xlabel('Time');
    ylabel('Vertical');
    
    linkaxes(h, 'x');
    
    
    figure(FigNum+2);
    clf reset
    
    h = subplot(2,1,1);
    plot(x);
    %xlabel('Time');
    ylabel('Horizontal');
    
    h(2) = subplot(2,1,2);
    plot(y);
    %xlabel('Time');
    ylabel('Vertical');
    
    linkaxes(h, 'x');
    
    % Plotting T1*Paa makes the PSD the same units as on the HP Control System Analyzer
    % Ie, you can integrate it visually and get counts^2
    figure(FigNum+3);
    clf reset
    h = subplot(2,1,1);
    semilogy(f(2:end)/1e6, T1*Paa(1:4,2:end), '.-');
    hold on
    semilogy(f(iFreq)/1e6, T1*Paa(1:4,iFreq)', 'o');
    hold off
    xlabel('Frequency [MHz]', 'FontSize',12);
    ylabel('[Volts{^2}/Hz]', 'FontSize',12);
    title('Power Spectral Density', 'FontSize',12);
    axis tight
    grid on
    %axis([1 5000 1e-6 1e0]);
    
    h(2) = subplot(2,1,2);
    plot(f/1e6, Paa_int, '.-');
    xlabel('Frequency [MHz]', 'FontSize',12);
    ylabel('[Volts {^2}]', 'FontSize',12);
    title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: chA=%.1f chB=%.1f chC=%.1f chD=%.1f mV)', 1000*sqrt(P11_int(end)), 1000*sqrt(P22_int(end)), 1000*sqrt(P33_int(end)), 1000*sqrt(P44_int(end))));
    axis tight
    grid on
    %xaxis([1 5000]);
    
    linkaxes(h, 'x');
end