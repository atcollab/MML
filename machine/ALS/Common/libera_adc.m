function [x, y, Paa, Pbb, Pcc, Pdd] = libera_adc(varargin)
% [x, y, Paa, Pbb, Pcc, Pdd] = libera_adc(chA, chB, chC, chD, ADC_Shift, DisplayFlag)
% [x, y, Paa, Pbb, Pcc, Pdd] = libera_adc(Filename, ADC_Shift, DisplayFlag)

% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
Xgain = 16.13;  % Arc
Ygain = 16.29;  % Arc

if isempty(varargin)
    % Prompt for a file
else
    if ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
        load(FileName);
        
        if iscell(ADC_AM)
            ii = 1;
            chA = ADC_AM{ii}.ADC_A_MONITOR;
            chB = ADC_AM{ii}.ADC_B_MONITOR;
            chC = ADC_AM{ii}.ADC_C_MONITOR;
            chD = ADC_AM{ii}.ADC_D_MONITOR;
        else
            chA = ADC_AM.ADC_A_MONITOR;
            chB = ADC_AM.ADC_B_MONITOR;
            chC = ADC_AM.ADC_C_MONITOR;
            chD = ADC_AM.ADC_D_MONITOR;
        end
        
        %x = DD4_AM.DD_X_MONITOR;
        %y = DD4_AM.DD_Y_MONITOR;
    else
        chA = varargin{1};
        chB = varargin{2};
        chC = varargin{3};
        chD = varargin{4};
        varargin(1:4) = [];
    end
end

if isempty(varargin)
    ADC_Shift = [];
else
    ADC_Shift = varargin{1};
    varargin(1) = [];
end

if isempty(varargin) && nargout == 0
    DisplayFlag = 1;
elseif isempty(varargin) && nargout > 0
    DisplayFlag = 0;
else
    DisplayFlag = varargin{1};
    varargin(1) = [];
end


Fs = 117.294;        % Sampling frequency, [MHz]  should base on RF???
Ts = 1/(Fs*1e6);     % Sampling period [seconds]
Rev = 656e-9;        % Revolution period [seconds]
N = round(Rev/Ts);   % Samples per revolution 77


Nfreq = round(N/2.0);
freq = (0:Nfreq-1)*Fs/N;
clock = (1:1024);
t = (0:1023)/Fs;

if 0
    % Single bunch
    low  = 15;
    high = 28;
else
    % Multi-bunch
    low  = 21;
    high = 21;
end

if isempty(ADC_Shift)
    % Find the offset in the time series
    % This only works for single bunch
    chAint = detrend(cumsum(abs(chA)));
    if chAint(1) > 0
        i = find(chAint(2:end)<0);
        i = i(1)+1;
    else
        i = find(chAint(2:end)>0);
        i = i(1)+1;
    end
    ADC_Shift = i(1) - 22;
    if ADC_Shift < 1
        ADC_Shift = ADC_Shift + N;
    end
end


NBunchesPerADCBuffer = floor((length(chA)-ADC_Shift)/N);
% if ADC_Shift < 10
%     NBunchesPerADCBuffer = 13;
% else
%     NBunchesPerADCBuffer = 12;
% end

% PSD
for i = 1:NBunchesPerADCBuffer
    [Paa(:,i), Arms(1,i)]  = libera_psd(chA((i-1)*N+1+ADC_Shift:i*N+ADC_Shift), low, high);
    [Pbb(:,i), Brms(1,i)]  = libera_psd(chB((i-1)*N+1+ADC_Shift:i*N+ADC_Shift), low, high);
    [Pcc(:,i), Crms(1,i)]  = libera_psd(chC((i-1)*N+1+ADC_Shift:i*N+ADC_Shift), low, high);
    [Pdd(:,i), Drms(1,i)]  = libera_psd(chD((i-1)*N+1+ADC_Shift:i*N+ADC_Shift), low, high);

    x(1,i)=Xgain*(Arms(1,i)-Brms(1,i)-Crms(1,i)+Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    y(1,i)=Ygain*(Arms(1,i)+Brms(1,i)-Crms(1,i)-Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
end


if DisplayFlag
    figure(DisplayFlag);
    clf reset

    subplot(2,1,1);
    plot(clock, [chA; chB; chC; chD]);
    hold on
    xlabel('ADC Sample Number');
    title('Libera ADC Data', 'interpreter',' none');

    xlim([0 1024]);
    lx(1) = 1 + ADC_Shift;
    lx(2) = 1 + ADC_Shift;
    ly(1) = min(chA);
    ly(2) = max(chA);
    
    line(lx, ly, 'Color', 'g');

    % PSD
    for i = 1:NBunchesPerADCBuffer
        subplot(2,1,1);
        lx(1) = i*N + ADC_Shift;
        lx(2) = i*N + ADC_Shift;
        line(lx, ly, 'Color', 'g');

        subplot(2,1,2);
        semilogy(freq, Paa(:,i)/Fs/1e6, 'b');
        hold on
        semilogy(freq, Pbb(:,i)/Fs/1e6, 'g');
        semilogy(freq, Pcc(:,i)/Fs/1e6, 'r');
        semilogy(freq, Pdd(:,i)/Fs/1e6, 'k');
    end

    legend('Button #1', 'Button #2', 'Button #3', 'Button #4', 'Location', 'NorthWest');

    ylabel('[Counts^2/Hz]');
    axis tight;
    %a = axis;
    %axis([2 60 1e-8 a(4)]);
    %%axis([2 60 1e-8 1]);
    %set(gca,'xtick',[2:10 20 30 40 50 60])
    %a = logspace(-8,1,10);
    %set(gca,'ytick',a(1:2:end))
    
    lx(1) = freq(low);
    lx(2) = lx(1);
    ly(1) = 0.0;
    ly(2) = max(max(Paa))/Fs/1e6;
    line(lx, ly, 'Color', 'm', 'LineWidth', 2);
    lx(1) = freq(high);
    lx(2) = lx(1);
    line(lx, ly, 'Color', 'm', 'LineWidth', 2);

    title(sprintf('Power Spectrum of Each Button for %d Turns', NBunchesPerADCBuffer));
    xlabel('Frequency [MHz]');
    grid on

    subplot(2,1,1);
    hold off
    ylabel('ADC [Counts]');

    subplot(2,1,2);
    hold off
   
    figure(DisplayFlag+1);
    clf reset
    subplot(2,1,1);
    %hold on;
    plot(x, '.-r');
    ylabel('Horizontal [mm]');
    title('Libera ADC Data', 'interpreter',' none');
    subplot(2,1,2);
    %hold on;
    plot(y, '.-r');
    ylabel('Vertical [mm]');
    xlabel('Turns [~656 ns / turn]');

    
    
    % 1024 Point FFT
%     Paa1024 = libera_psd(chA, low, high, 1);
%     Pbb1024 = libera_psd(chB, low, high, 1);
%     Pcc1024 = libera_psd(chC, low, high, 1);
%     Pdd1024 = libera_psd(chD, low, high, 1);
    
% Do 12 turns, no window
chA = chA(1:77*12);
chB = chB(1:77*12);
chC = chC(1:77*12);
chD = chD(1:77*12);

    Paa1024 = libera_psd(chA, low, high, 0);
    Pbb1024 = libera_psd(chB, low, high, 0);
    Pcc1024 = libera_psd(chC, low, high, 0);
    Pdd1024 = libera_psd(chD, low, high, 0);

    Nfreq1024 = round(length(chA)/2);
    freq1024 = (0:Nfreq1024-1)*Fs/(2*Nfreq1024);
    
    figure(DisplayFlag+2);
    clf reset
    
    semilogy(freq1024, Paa1024/Fs/1e6, 'b');
    hold on
    semilogy(freq1024, Pbb1024/Fs/1e6, 'g');
    semilogy(freq1024, Pcc1024/Fs/1e6, 'r');
    semilogy(freq1024, Pdd1024/Fs/1e6, 'k');
    hold off
    
    legend('Button #1', 'Button #2', 'Button #3', 'Button #4', 'Location', 'NorthWest');
    %     axis tight;
    %     a = axis;
    %     axis([2 60 1e-8 a(4)]);
    %     %axis([2 60 1e-8 1]);
    %     set(gca,'xtick',[2:10 20 30 40 50 60])
    %     a = logspace(-8,1,10);
    %     set(gca,'ytick',a(1:2:end))
    
    title(sprintf('Power Spectrum of Each Button for %d Turns (%d ADC Samples)', 1024, 1024*77));
    ylabel('[Counts^2/Hz]');
    xlabel('Frequency [MHz]');
    grid on
    
    
    figure(DisplayFlag+3);
    clf reset 
    
    semilogy(freq1024, Paa1024/Fs/1e6, 'r');
    hold on
    semilogy(freq, Paa(:,1)/Fs/1e6, '.-b')
    hold off
    title('ADC Power Spectrum of Button #1');
    ylabel('Button #1 [Counts^2/Hz]');
    xlabel('Frequency [MHz]');
    grid on
    legend('12*77 ADC Samples', '77 ADC Samples', 'Location', 'NorthWest');

    
    % figure(DisplayFlag+2);
    % clf reset
    % subplot(2,1,1);
    % %hold on;
    % plot(DD4_AM.DD_X_MONITOR(1:40)/1e6, '.-r');
    % title('Libera DD Data', 'interpreter',' none');
    % subplot(2,1,2);
    % %hold on;
    % plot(DD4_AM.DD_Y_MONITOR(1:40)/1e6, '.-r');
    % %xaxiss([0 20]);
    %
    %
    % figure(4);
    % clf reset
    % subplot(2,1,1);
    % %hold on;
    % plot(DD4_AM.DD_X_MONITOR/1e6, '-r');
    % title('Libera DD Data', 'interpreter',' none');
    % subplot(2,1,2);
    % %hold on;
    % plot(DD4_AM.DD_Y_MONITOR/1e6, '-r');
    % %xaxiss([0 20]);
end



function [Paa, Paa_RMS]  = libera_psd(a, low, high, WindowFlag)

if nargin < 4
    WindowFlag = 0;
end

a = a(:);

N = length(a);

%if exist('hanning') == 0
if WindowFlag
    w = hanning(N);           % hanning window
else
    w = ones(N,1);            % no window
end
U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)


a_w = a .* w;
A = fft(a_w);
Paa = A.*conj(A)/N;
Paa = Paa/U;
Paa = Paa(1:ceil(N/2));
Paa(2:end) = 2*Paa(2:end);
Paa(1) = 0; % Remove the DC term
Paa_RMS_Total = sqrt(sum(Paa)/N);
Paa_RMS = sqrt(sum(Paa(low:high))/N);
a_RMS = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));

