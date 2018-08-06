function [Paa, f, T1, LegendString] = pbpm_plotpsd(FileName, LineType, HoldFlag)
% [Paa, f, T1, LegendString] = pbpm_plotpsd(FileName, LineType, HoldFlag)

if nargin < 2
    LineType = 'b';%nextline;
end

if nargin < 3
    HoldFlag = 'off';
end
if isnumeric(HoldFlag) && HoldFlag == 1
    HoldFlag = 'on';
elseif isnumeric(HoldFlag) && HoldFlag == 0
    HoldFlag = 'off';
end
HoldFlag = lower(HoldFlag);

if nargout >= 4
    LegendFlag = 1;
else
    LegendFlag = 0;
end


if nargin == 0 || isempty(FileName)
    if 1
        %uiload;
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a pBPM File');
        FileName = [DirectoryName, FileName];
        fprintf('   Plotting file: %s\n', FileName);
    else
        % Plot a 
        DirectoryName = uigetdir(pwd, 'Select a directory');
        N = 4;
        for i = 1:N
            [Paa(:,i), f, T1] = pbpm_plotpsd([DirectoryName, filesep, 'pBPM', num2str(i)]);
            pause;
        end
        figure(5);
        [tt,ff] = meshgrid(1:N,f);
        %waterfall(tt,log10(ff),log10(1000*1000*T1*Paa));
        surf(tt,log10(ff),log10(1000*1000*T1*Paa));
        shading faceted
        %shading interp
        xlabel('Time', 'FontSize',12);
        ylabel('log10(Frequency) [Hz]', 'FontSize',12);
        zlabel('[\mum{^2}/Hz]', 'FontSize',12);
        title('Photon BPM 7.2 Power Spectral Density', 'FontSize',12);
        view(77,-30);
        return
    end
end


% Figure numbers start with nFig+1
nFig = 0;


load(FileName);

if ~exist('d1','var')
    return;
end


% Should be in file
if ~exist('NaaAvg', 'var')
    NaaAvg = size(d1,2);
end
if ~exist('N', 'var')
    N = size(d1,1);  % block_size
end

PaaAvg = 0;
Paa1Avg = 0;
Paa2Avg = 0;
Paa3Avg = 0;
Paa4Avg = 0;
Paa5Avg = 0;
Paa6Avg = 0;



for i = 1:NaaAvg

    % Vertical position
    y1(:,i) = (d1(:,i) - d3(:,i)) ./ (d1(:,i) + d3(:,i));
    y2(:,i) = (d2(:,i) - d4(:,i)) ./ (d2(:,i) + d4(:,i));


    % Calibrated position
    %Gain = 1;
    %Gain3 = .978 ./ (mean(y2(:,i)) - mean(y1(:,i)));
    %Gain2 = .978 ./ mean(y2(:,i) - y1(:,i));
    Gain = .978 ./ (y2(:,i) - y1(:,i));

    %y(:,i) = Gain .* y1(:,i);
    y(:,i) = mean(Gain) .* y1(:,i);

    y1(:,i) = mean(Gain) .* y1(:,i);
    y2(:,i) = mean(Gain) .* y2(:,i);

    a  = y(:,i);   % Calibrated
    a1 = d1(:,i);  % Channel #1
    a2 = d2(:,i);  % Channel #2
    a3 = d3(:,i);  % Channel #3
    a4 = d4(:,i);  % Channel #4
    a5 = y1(:,i);  % Inside
    a6 = y2(:,i);  % Outside

    
    if i == 1
        nFig = nFig + 1;
        figure(nFig);
        clf reset
        clear h
        m1 = mean(a1);
        m2 = mean(a2);
        m3 = mean(a3);
        m4 = mean(a4);
        h(1) = subplot(2,1,1);
        plot((0:length(a)-1)/Fs, [a1-m1 a2-m2 a3-m3 a4-m4]);
        ylabel('Blades [volts]');
        title(sprintf('pBPM Time Series (Top-Inside=%.2f Top-Outside=%.2f Bottom-Inside=%.2f Bottom-Outside=%.2f)',m1, m2, m3, m4));

        h(2) = subplot(2,1,2);
        plot((0:length(a5)-1)/Fs, [a5 a6-.978]);
        ylabel('pBPM(7,2) [mm]');
        legend('Inside','Outside-.978');
        
        orient tall;

        % Link the x-axes
        linkaxes(h, 'x');
        %set(gca,'xtick',0:.0083:.083);
    end


    %a = a-mean(a);
    a = detrend(a);
    a1 = detrend(a1);
    a2 = detrend(a2);
    a3 = detrend(a3);
    a4 = detrend(a4);
    a5 = detrend(a5);
    a6 = detrend(a6);

    
    % POWER SPECTRUM
    T1 = 1/Fs;
    T  = T1 * N;

    f0 = 1 / (N*T1);
    f  = f0 * (0:N/2)';

    if exist('hanning') == 0
        w = ones(N,1);               % no window
    else
        w = hanning(N);              % hanning window
    end
    U = sum(w.^2)/N;              % approximately .375 for hanning
    %U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

    a_w = a .* w;
    A = fft(a_w);
    Paa = A.*conj(A)/N;
    Paa = Paa/U;
    Paa(N/2+2:N) = [];
    Paa(2:N/2+1) = 2*Paa(2:N/2+1);

    a_w = a1 .* w;
    A = fft(a_w);
    Paa1 = A.*conj(A)/N;
    Paa1 = Paa1 / U;
    Paa1(N/2+2:N) = [];
    Paa1(2:N/2+1) = 2*Paa1(2:N/2+1);

    a_w = a2 .* w;
    A = fft(a_w);
    Paa2 = A.*conj(A)/N;
    Paa2 = Paa2/U;
    Paa2(N/2+2:N) = [];
    Paa2(2:N/2+1) = 2*Paa2(2:N/2+1);

    a_w = a3 .* w;
    A = fft(a_w);
    Paa3 = A.*conj(A)/N;
    Paa3 = Paa3/U;
    Paa3(N/2+2:N) = [];
    Paa3(2:N/2+1) = 2*Paa3(2:N/2+1);

    a_w = a4 .* w;
    A = fft(a_w);
    Paa4 = A.*conj(A)/N;
    Paa4 = Paa4/U;
    Paa4(N/2+2:N) = [];
    Paa4(2:N/2+1) = 2*Paa4(2:N/2+1);

    a_w = a5 .* w;
    A = fft(a_w);
    Paa5 = A.*conj(A)/N;
    Paa5 = Paa5/U;
    Paa5(N/2+2:N) = [];
    Paa5(2:N/2+1) = 2*Paa5(2:N/2+1);

    a_w = a6 .* w;
    A = fft(a_w);
    Paa6 = A.*conj(A)/N;
    Paa6 = Paa6/U;
    Paa6(N/2+2:N) = [];
    Paa6(2:N/2+1) = 2*Paa6(2:N/2+1);

    % PSD using matlab functions (NOTE: matlab function detrend by default)
    % PaaS = spectrum(a,N,0,w,f0);
    % PaaS = 2*PaaS(:,1);
    % PaaS(1)=PaaS(1)/2;
    % PaaPSD=2*psd(a,N);
    % PddPSD(1)=PddPSD(1)/2;


    %Pdd(1) = 0;   % not sure if the DC term is correct
    %Pdd1 = Pdd;
    %m = 3;        % not sure if the first couple terms are good
    %for i=1:m
    %   Pdd(i) = 0;
    %end


    RMS_data = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));
    RMS_data1 = sqrt(sum((a1-mean(a1)).^2)/length((a1-mean(a1))));
    RMS_data2 = sqrt(sum((a2-mean(a2)).^2)/length((a2-mean(a2))));
    RMS_data3 = sqrt(sum((a3-mean(a3)).^2)/length((a3-mean(a3))));
    RMS_data4 = sqrt(sum((a4-mean(a4)).^2)/length((a4-mean(a4))));
    RMS_data5 = sqrt(sum((a5-mean(a5)).^2)/length((a5-mean(a5))));
    RMS_data6 = sqrt(sum((a6-mean(a6)).^2)/length((a6-mean(a6))));


    Paa_int = cumsum(Paa)/N;
    %Paa_int = cumsum(Paa(end:-1:1))/N;
    %Paa_int = Paa_int(length(Paa_int):-1:1);
    Paa1_int = cumsum(Paa1)/N;
    Paa2_int = cumsum(Paa2)/N;
    Paa3_int = cumsum(Paa3)/N;
    Paa4_int = cumsum(Paa4)/N;
    Paa5_int = cumsum(Paa5)/N;
    Paa6_int = cumsum(Paa6)/N;


    fprintf('\n   RMS Displacement: %g mm (Calibrated) (Time series data)\n', RMS_data);
    fprintf(  '   RMS Displacement: %g mm (Calibrated) (PSD, Parseval''s Thm)\n\n', sqrt(Paa_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Channel #1) (Time series data)\n', RMS_data1);
    fprintf(  '   RMS Displacement: %g mm (Channel #1) (PSD, Parseval''s Thm)\n\n', sqrt(Paa1_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Channel #2) (Time series data)\n', RMS_data2);
    fprintf(  '   RMS Displacement: %g mm (Channel #2) (PSD, Parseval''s Thm)\n\n', sqrt(Paa2_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Channel #3) (Time series data)\n', RMS_data3);
    fprintf(  '   RMS Displacement: %g mm (Channel #3) (PSD, Parseval''s Thm)\n\n', sqrt(Paa3_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Channel #4) (Time series data)\n', RMS_data4);
    fprintf(  '   RMS Displacement: %g mm (Channel #4) (PSD, Parseval''s Thm)\n\n', sqrt(Paa4_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Inside) (Time series data)\n', RMS_data5);
    fprintf(  '   RMS Displacement: %g mm (Inside) (PSD, Parseval''s Thm)\n\n', sqrt(Paa5_int(end)));

    fprintf('\n   RMS Displacement: %g mm (Outside) (Time series data)\n', RMS_data6);
    fprintf(  '   RMS Displacement: %g mm (Outside) (PSD, Parseval''s Thm)\n\n', sqrt(Paa6_int(end)));


    PaaAvg = PaaAvg + Paa/NaaAvg;
    Paa1Avg = Paa1Avg + Paa1/NaaAvg;
    Paa2Avg = Paa2Avg + Paa2/NaaAvg;
    Paa3Avg = Paa3Avg + Paa3/NaaAvg;
    Paa4Avg = Paa4Avg + Paa4/NaaAvg;
    Paa5Avg = Paa5Avg + Paa5/NaaAvg;
    Paa6Avg = Paa6Avg + Paa6/NaaAvg;
end

fprintf('\n   %d Averaged Power Spectrums\n', NaaAvg);

Paa = PaaAvg;
Paa_int = cumsum(Paa)/N;
%Paa_int = cumsum(Paa(end:-1:1))/N;
%Paa_int = Paa_int(length(Paa_int):-1:1);
fprintf('   RMS Displacement: %g mm (Calibrated) (PSD, Parseval''s Thm)\n', sqrt(Paa_int(end)));

Paa1 = Paa1Avg;
Paa1_int = cumsum(Paa1)/N;
fprintf('   RMS Displacement: %g mm (Channel #1) (PSD, Parseval''s Thm)\n', sqrt(Paa1_int(end)));

Paa2 = Paa2Avg;
Paa2_int = cumsum(Paa2)/N;
fprintf('   RMS Displacement: %g mm (Channel #2) (PSD, Parseval''s Thm)\n', sqrt(Paa2_int(end)));

Paa3 = Paa3Avg;
Paa3_int = cumsum(Paa3)/N;
fprintf('   RMS Displacement: %g mm (Channel #3) (PSD, Parseval''s Thm)\n', sqrt(Paa3_int(end)));

Paa4 = Paa4Avg;
Paa4_int = cumsum(Paa4)/N;
fprintf('   RMS Displacement: %g mm (Channel #4) (PSD, Parseval''s Thm)\n', sqrt(Paa4_int(end)));

Paa5 = Paa5Avg;
Paa5_int = cumsum(Paa5)/N;
fprintf('   RMS Displacement: %g mm (Inside) (PSD, Parseval''s Thm)\n', sqrt(Paa5_int(end)));

Paa6 = Paa6Avg;
Paa6_int = cumsum(Paa6)/N;
fprintf('   RMS Displacement: %g mm (Outside) (PSD, Parseval''s Thm)\n', sqrt(Paa6_int(end)));



davg  = mean(mean(y));
d1avg = mean(mean(d1));
d2avg = mean(mean(d2));
d3avg = mean(mean(d3));
d4avg = mean(mean(d4));
d5avg = mean(mean(y1));
d6avg = mean(mean(y2));



% Plotting T1*Paa makes the PSD the same units as on the HP Control System Analyzer
% Ie, you can integrate it visually and get mm^2

% subplot(3,1,1);
% plot((1:4096)/Fs, y1(:,1));


nFig = nFig + 1;
figure(nFig);
clf reset

clear h
h(1) = subplot(2,1,1);
loglog(f, 1000*1000*T1*[Paa5 Paa6]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum{^2}/Hz]', 'FontSize',12);
title('Photon BPM 7.2 Power Spectral Density', 'FontSize',12);
legend('Inside Blades', 'Outside Blades', 'Location','NorthWest');
axis tight
grid on

a = axis;
if a(3) < 1e-3
    a(3) = 1e-5;
    axis(a);
end

h(2) = subplot(2,1,2);
semilogx(f, 1000*1000*[Paa5_int Paa6_int]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum {^2}]', 'FontSize',12);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df     (RMS=%.2g \\mum (Inside)  %.2g \\mum (Outside))', 1000*sqrt(Paa5_int(end)),1000*sqrt(Paa6_int(end))));
legend('Inside Blades', 'Outside Blades', 'Location','NorthWest');
axis tight
grid on

% Link the x-axes
linkaxes(h, 'x');

addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f  Top Outside = %.2f  Bottom Inside = %.2f  Bottom Outside = %.2f  (Average Gain = %.2f)', d1avg, d2avg, d3avg, d4avg, mean(Gain)));
%addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f   Bottom Inside = %.2f', d1avg, d3avg));
%addlabel(0,0,sprintf('Avg Blade Voltage: Top Outside = %.2f   Bottom Outside = %.2f', d2avg, d3avg));
orient tall


nFig = nFig + 1;
figure(nFig);
clf reset

clear h
h(1) = subplot(2,1,1);
loglog(f, 1000*1000*T1*[Paa1 Paa2 Paa3 Paa4]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[Volts{^2}/Hz]', 'FontSize',12);
title('Photon BPM 7.2 Power Spectral Density for Each Blade', 'FontSize',12);
axis tight
grid on

a = axis;
if a(3) < 1e-5
    a(3) = 1e-5;
    axis(a);
end

h(2) = subplot(2,1,2);
semilogx(f, [Paa1_int Paa2_int Paa3_int Paa4_int]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[Volts {^2}]', 'FontSize',12);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: Top Inside=%.2g  Top Outside=%.2g  Bottom Inside=%.2g  Bottom Outside=%.2g Volts)', sqrt(Paa1_int(end)), sqrt(Paa2_int(end)), sqrt(Paa3_int(end)), sqrt(Paa4_int(end)) ));
legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside', 'Location','NorthWest');
axis tight
grid on

% Link the x-axes
linkaxes(h, 'x');

addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f  Top Outside = %.2f  Bottom Inside = %.2f  Bottom Outside = %.2f', d1avg, d2avg, d3avg, d4avg));
orient tall



nFig = nFig + 1;
figure(nFig);
if strcmpi(HoldFlag,'off')
    clf reset
end

clear h
h(1) = subplot(2,1,1);
hold(HoldFlag);
loglog(f, 1000*1000*T1*Paa, 'Color', LineType);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum{^2}/Hz]', 'FontSize',12);
title('Photon BPM 7.2 Power Spectral Density', 'FontSize',12);
axis tight
grid on

a = axis;
if a(3) < 1e-3
    a(3) = 1e-5;
    axis(a);
end

h(2) = subplot(2,1,2);
hold(HoldFlag);
semilogx(f, 1000*1000*Paa_int, 'Color', LineType);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum {^2}]', 'FontSize',12);
axis tight
grid on


% Link the x-axes
linkaxes(h, 'x');

LegendString = sprintf('%s, %5.1f mA, RMS=%.2g \\mum', datestr(TimeClock,0), DCCT, 1000*sqrt(Paa_int(end)));

if LegendFlag
    title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df'));
else
    title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df   (RMS=%.2g \\mum)', 1000*sqrt(Paa_int(end))));
    addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
    addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f  Top Outside = %.2f  Bottom Inside = %.2f  Bottom Outside = %.2f  (Average Gain = %.2f)', d1avg, d2avg, d3avg, d4avg, mean(Gain)));
end

orient tall



% figure(4);
% %clf reset
%
% LineColor = 'k'; %nxtcolor;
%
% subplot(2,1,1);
% loglog(f, 1000*1000*T1*[Paa2], LineColor);
% xlabel('Frequency [Hz]', 'FontSize',12);
% ylabel('Top Outside [Volts{^2}/Hz]', 'FontSize',12);
% title('Photon BPM 7.2 Power Spectral Density', 'FontSize',12);
% axis tight
% grid on
%
% a = axis;
% if a(3) < 1e-5
%     a(3) = 1e-5;
%     axis(a);
% end
%
% subplot(2,1,2);
% semilogx(f, [Paa2_int], LineColor);
% xlabel('Frequency [Hz]', 'FontSize',12);
% ylabel('Top Outside [Volts {^2}]', 'FontSize',12);
% title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df)'));
% %legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside', 'Location','NorthWest');
% axis tight
% grid on
%
% %addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
% %addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f  Top Outside = %.2f  Bottom Inside = %.2f  Bottom Outside = %.2f', d1avg, d2avg, d3avg, d4avg));
% orient tall




% subplot(2,1,1);
% loglog(f, 1000*1000*T1*Paa);
% xlabel('Frequency [Hz]', 'FontSize',12);
% ylabel('[\mum{^2}/Hz]', 'FontSize',12);
% axis tight
% grid on
% title('Photon BPM 7.2  Power Spectral Density (Inside Blades)', 'FontSize',12);
%
% a = axis;
% if a(3) < 1e-3
%     a(3) = 1e-3;
%     axis(a);
% end
%
% subplot(2,1,2);
% semilogx(f, 1000*1000*Paa_int);
% xlabel('Frequency [Hz]', 'FontSize',12);
% ylabel('[\mum {^2}]', 'FontSize',12);
% title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df   (RMS=%.2g \\mum)', 1000*sqrt(Paa_int(end))));
% axis tight
% grid on
%
% addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
%
%
% %addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f   Top Outside = %.2f   Bottom Inside = %.2f   Bottom Outside = %.2f', d1avg, d2avg, d3avg, d4avg));
% addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f   Bottom Inside = %.2f', d1avg, d3avg));
% %addlabel(0,0,sprintf('Avg Blade Voltage: Top Outside = %.2f   Bottom Outside = %.2f', d2avg, d3avg));
