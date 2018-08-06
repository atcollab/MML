function plotpbpmpsd(FileName)

if nargin == 0
    uiload;
else
    load(FileName);
end

if ~exist('d1','var')
    return;
end


NaaAvg = 10;
Paa1Avg = 0;
Paa2Avg = 0;


Gain1 = 2.1137;  %   1/1.2;
%Gain2 = 1/.64;

BPMyGain = getgain('BPMy',[7 5;7 6]);
BPMyGolden = getgolden('BPMy',[7 5;7 6]);
BPMspos = 1000*getspos('BPMy',[7 5;7 6]);  % mm


for i = 1:NaaAvg
    % Vertical position
    y1(:,i) = (d1(:,i) - d3(:,i)) ./ (d1(:,i) + d3(:,i));
    y1(:,i) = Gain1 * y1(:,i);
    a1 = y1(:,i);  % Inside


    y1 = BPMyGain(1) * (d2(:,i) - BPMyGolden(1));  % mm
    y2 = BPMyGain(2) * (d4(:,i) - BPMyGolden(2));  % mm
    yangle = (y2-y1) / (BPMspos(2)-BPMspos(1));    % radians
    ypBPM = (y1+y2)/2 + 6000*yangle;               % mm


    if i == 1
        figure(20);
        h(1) = subplot(3,1,1);
        plot((0:length(y1)-1)/Fs, a1);
        ylabel('pBPM [mm]');

        h(2) = subplot(3,1,2);
        plot((0:length(y1)-1)/Fs, [y1-mean(y1) y2-mean(y2)]);
        ylabel('BPMy(7,5) & BPMy(7,6) [mm]');

        h(3) = subplot(3,1,3);
        plot((0:length(y1)-1)/Fs, (y1+y2)/2 + 6000*yangle);
        ylabel('BPMs Projected to pBPM [mm]');
        xlabel('Time [seconds]');

        orient tall;

        % Link the x-axes
        linkaxes(h, 'x');
    end

    a2 = ypBPM;

    %a = a-mean(a);
    a1 = detrend(a1);
    a2 = detrend(a2);


    % POWER SPECTRUM
    T1 = 1/Fs;
    T  = T1 * N;

    f0 = 1 / (N*T1);
    f  = f0 * (0:N/2)';

    %w = ones(N,1);               % no window
    w = hanning(N);               % hanning window
    U = sum(w.^2)/N;              % approximately .375 for hanning
    %U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

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


    % PSD using matlab functions (NOTE: matlab function detrend by default)
    % PaaS = spectrum(a,N,0,w,f0);
    % PaaS = 2*PaaS(:,1);
    % PaaS(1)=PaaS(1)/2;
    % PaaPSD=2*psd(a,N);
    % PddPSD(1)=PddPSD(1)/2;

    %
    %     Pdd(1) = 0;   % not sure if the DC term is correct
    %     Pdd1 = Pdd;
    %     m = 3;        % not sure if the first couple terms are good
    %     for i=1:m
    %        Pdd(i) = 0;
    %     end


    RMS_data1 = sqrt(sum((a1-mean(a1)).^2)/length((a1-mean(a1))));
    RMS_data2 = sqrt(sum((a2-mean(a2)).^2)/length((a2-mean(a2))));

    Paa1_int = cumsum(Paa1)/N;
    %Paa1_int = cumsum(Paa1(end:-1:1))/N;
    %Paa1_int = Paa1_int(length(Paa1_int):-1:1);

    Paa2_int = cumsum(Paa2)/N;
    %Paa2_int = cumsum(Paa2(end:-1:1))/N;
    %Paa2_int = Paa2_int(length(Paa2_int):-1:1);

    fprintf('\n   RMS Displacement: %g mm (Inside Blades) (Time series data)\n', RMS_data1);
    fprintf(  '   RMS Displacement: %g mm (Inside Blades) (PSD, Parseval''s Thm)\n\n', sqrt(Paa1_int(end)));

    fprintf('\n   RMS Displacement: %g mm (BPMy projected to the pBPM)  (Time series data)\n', RMS_data2);
    fprintf(  '   RMS Displacement: %g mm (BPMy projected to the pBPM)  (PSD, Parseval''s Thm)\n\n', sqrt(Paa2_int(end)));

    Paa1Avg = Paa1Avg + Paa1/NaaAvg;
    Paa2Avg = Paa2Avg + Paa2/NaaAvg;
end

fprintf('\n   %d Averaged Power Spectrums\n', NaaAvg);

Paa1 = Paa1Avg;
Paa1_int = cumsum(Paa1)/N;
%Paa1_int = cumsum(Paa1(end:-1:1))/N;
%Paa1_int = Paa1_int(length(Paa1_int):-1:1);
fprintf('   RMS Displacement: %g mm (Inside Blades) (PSD, Parseval''s Thm)\n', sqrt(Paa1_int(end)));

Paa2 = Paa2Avg;
Paa2_int = cumsum(Paa2)/N;
%Paa2_int = cumsum(Paa2(end:-1:1))/N;
%Paa2_int = Paa2_int(length(Paa2_int):-1:1);
fprintf('   RMS Displacement: %g mm (BPMy projected to the pBPM)  (PSD, Parseval''s Thm)\n', sqrt(Paa2_int(end)));


d1avg = mean(mean(d1));
d2avg = mean(mean(d2));
d3avg = mean(mean(d3));
d4avg = mean(mean(d4));



figure(21)
clf reset
% subplot(3,1,1);
% plot((1:4096)/Fs, y1(:,1));


% Plotting T1*Paa makes the PSD the same units as on the HP Control System Analyzer
% Ie, you can integrate it visually and get mm^2
clear h
h(1) = subplot(2,1,1);
loglog(f, 1000*1000*T1*[Paa1 Paa2]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum{^2}/Hz]', 'FontSize',12);
title('Photon BPM 7.2 and BPMy Power Spectral Density', 'FontSize',12);
legend('pBPM (Inside Blades)', 'BPMy(7,5) & BPMy(7,6) projected to the pBPM', 0);
axis tight
grid on

a = axis;
if a(3) < 1e-3
    a(3) = 1e-5;
    axis(a);
end

h(2) = subplot(2,1,2);
semilogx(f, 1000*1000*[Paa1_int Paa2_int]);
xlabel('Frequency [Hz]', 'FontSize',12);
ylabel('[\mum {^2}]', 'FontSize',12);
title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df     (RMS: pBPM=%.2g \\mum   BPMy=%.2g \\mum)', 1000*sqrt(Paa1_int(end)),1000*sqrt(Paa2_int(end))));
legend('pBPM (Inside)', 'BPMy(7,5)', 0);
axis tight
grid on

addlabel(1,0,sprintf('%.1f mA  %s', DCCT, datestr(TimeClock,0)));
addlabel(0,0,sprintf('Avg Blade Voltage: Top Inside = %.2f   Bottom Inside = %.2f   Gain = %.1f', d1avg, d3avg, Gain1));

% Link the x-axes
linkaxes(h, 'x');

orient tall





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
