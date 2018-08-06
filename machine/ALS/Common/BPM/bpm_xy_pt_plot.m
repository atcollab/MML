function bpm_xy_pt_plot(Orbit, ENV, Setup)

% Orbit =
%              x: [1x7700 double]
%              y: [1x7700 double]
%           xcal: [1x7700 double]
%           ycal: [1x7700 double]
%           Arms: [1x7700 double]
%           Brms: [1x7700 double]
%           Crms: [1x7700 double]
%           Drms: [1x7700 double]
%            Paa: [5775x1 double]
%            Pbb: [5775x1 double]
%            Pcc: [5775x1 double]
%            Pdd: [5775x1 double]
%              f: [1x5775 double]
%     nHarmOrbit: 3001
%          nHarm: [1x39 double]
%        nHarmPT: 2991
%      PilotTone: 1
%            Orbit.PTHx: [1x7700 double]
%            Orbit.PTHy: [1x7700 double]
%         PTArms: [1x7700 double]
%         PTBrms: [1x7700 double]
%         PTCrms: [1x7700 double]
%         PTDrms: [1x7700 double]
%     TurnNumber: [1x7700 double]
%
% Setup =
%            NADC: 4194304
%            NTBT: 65536
%             NFA: 0
%     FillPattern: 500
%              PT: [1x1 struct]
%         ADC_PGA: 0
%            Info: {'500 mA, User Beam'  'No Splitter'  'PT On'}
%           Xgain: 16.1300
%           Ygain: 16.2900
%            Attn: 0
%             PSD: [1x1 struct]
%              xy: [1x1 struct]
%
% Setup.xy
%       nHarmOrbit: 21
%     Setup.xy.NTurnsPerFFT: 150
%             Setup.xy.NAvg: 1
%          NPoints: 7700
%         NAdvance: 11
%           FigNum: 4
%            Shift: 0
%
% Setup.PSD
%           Nfft: 11550
%        NaveMax: 350
%     WindowFlag: 0
%          Shift: 0
%         FigNum: 1
%
% ENV =
%     DFE_TEMP0: 43
%     DFE_TEMP1: 43
%     DFE_TEMP2: 45
%     DFE_TEMP3: 42
%     AFE_TEMP0: 509
%     AFE_TEMP1: 509
%         Clock: [2013 11 11 22 35 12.4528]
%           RF0: 499.6409
%            Fs: 117.2937
%          DCCT: 3.8135
%      DataTime: 7.3555e+05


FontSize = 12;
nFig = Setup.xy.FigNum - 1;
h = [];

% x, y plot
nFig = nFig + 1;
figure(nFig);
clf reset
h(length(h)+1) = subplot(2,1,1);
plot(Orbit.TurnNumber, 1000*Orbit.x, '-b');
xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
ylabel('Horizontal [\mum]', 'FontSize', FontSize);
title(sprintf('Horizontal Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.x), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
axis tight
a = axis;
axis([0 a(2:4)]);

h(length(h)+1) = subplot(2,1,2);
plot(Orbit.TurnNumber, 1000*Orbit.y, '-b');
ylabel('Vertical [\mum]', 'FontSize', FontSize);
xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
title(sprintf('Vertical Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.y), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
axis tight
a = axis;
axis([0 a(2:4)]);

% RMS vs time
nFig = nFig + 1;
figure(nFig);
clf reset
h(length(h)+1) = subplot(1,1,1);
plot(Orbit.TurnNumber, [Orbit.Arms-Orbit.Arms(1); 1*(Orbit.Brms-Orbit.Brms(1)); 1*(Orbit.Crms-Orbit.Crms(1)); Orbit.Drms-Orbit.Drms(1);]);
xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
ylabel('RMS [Counts]', 'FontSize', FontSize);
%title(sprintf('Channel RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), 'FontSize', FontSize);
title(sprintf('Channel RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), 'FontSize', FontSize);
legend(sprintf('Button A_0=%.4g',Orbit.Arms(1)), sprintf('Button B_0=%.4g',Orbit.Brms(1)), sprintf('Button C_0=%.4g',Orbit.Crms(1)), sprintf('Button D_0=%.4g',Orbit.Drms(1)), 'Location', 'NorthWest');
axis tight

% nFig = nFig + 1;
% figure(nFig);
% clf reset
% h(length(h)+1) = subplot(1,1,1);
% plot(Orbit.TurnNumber, [Orbit.Arms; Orbit.Brms; Orbit.Crms; Orbit.Drms;]);
% xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
% ylabel('RMS [Counts]', 'FontSize', FontSize);
% title(sprintf('Channel RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), 'FontSize', FontSize);
% legend('Button A', 'Button B', 'Button C', 'Button D', 'Location', 'NorthWest');
% axis tight


% RMS vs time
% nFig = nFig + 1;
% figure(nFig);
% clf reset
% h(length(h)+1) = subplot(3,1,1);
% plot(Orbit.TurnNumber, Orbit.Brms ./ Orbit.Arms);
% axis tight
% ylabel('B/A', 'FontSize', FontSize);
% %title(sprintf('Ratio of the Button RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), 'FontSize', FontSize);
% title(sprintf('Ratio of the Button RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), 'FontSize', FontSize);
% h(length(h)+1) = subplot(3,1,2);
% plot(Orbit.TurnNumber, Orbit.Crms ./ Orbit.Arms);
% axis tight
% ylabel('C/A', 'FontSize', FontSize);
% h(length(h)+1) = subplot(3,1,3);
% plot(Orbit.TurnNumber, Orbit.Drms ./ Orbit.Arms);
% axis tight
% ylabel('D/A', 'FontSize', FontSize);
% xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);



    %%%%%%%%%%%%%%
    % PT - Upper %
    %%%%%%%%%%%%%%

    
    %nFig = nFig + 1;
    %figure(nFig);
    %clf reset
    %h(length(h)+1) = subplot(1,1,1);
    %plot(Orbit.TurnNumber, [Orbit.PTHArms; Orbit.PTHBrms; Orbit.PTHCrms; Orbit.PTHDrms;]);
    %xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    %ylabel('PT RMS [Counts]', 'FontSize', FontSize);
    %title(sprintf('Channel RMS at Pilot Tone Freq = %.3f MHz', Orbit.f(Orbit.nHarmPTH(1))), 'FontSize', FontSize);
    %legend('Button A', 'Button B', 'Button C', 'Button D', 'Location', 'NorthWest');
    %axis tight
    
    % x, y plot
    nFig = nFig + 1;
    figure(nFig);
    clf reset
    h(length(h)+1) = subplot(2,1,1);
    plot(Orbit.TurnNumber, 1000*Orbit.PTHx, '-b');
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    ylabel('Horizontal [\mum]', 'FontSize', FontSize);
    title(sprintf('Upper Pilot Tone Horizontal Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.PTHx), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    axis tight
    a = axis;
    axis([0 a(2:4)]);
    
    h(length(h)+1) = subplot(2,1,2);
    plot(Orbit.TurnNumber, 1000*Orbit.PTHy, '-b');
    ylabel('Vertical [\mum]', 'FontSize', FontSize);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    title(sprintf('Upper Pilot Tone Vertical Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.PTHy), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    axis tight
    a = axis;
    axis([0 a(2:4)]);

    nFig = nFig + 1;
    figure(nFig);
    clf reset
    plot(Orbit.TurnNumber, [Orbit.PTHArms-Orbit.PTHArms(1); Orbit.PTHBrms-Orbit.PTHBrms(1); Orbit.PTHCrms-Orbit.PTHCrms(1); Orbit.PTHDrms-Orbit.PTHDrms(1);]);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    ylabel('RMS [Counts]', 'FontSize', FontSize);
    title(sprintf('Channel RMS at the Upper Pilot Tone Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmPTH(1)), ENV.Machine.Clock), 'FontSize', FontSize);
    legend(sprintf('Button A_0=%.4g',Orbit.PTHArms(1)), sprintf('Button B_0=%.4g',Orbit.PTHBrms(1)), sprintf('Button C_0=%.4g',Orbit.PTHCrms(1)), sprintf('Button D_0=%.4g',Orbit.PTHDrms(1)), 'Location', 'NorthWest');
    axis tight
    
    nFig = nFig + 1;
    figure(nFig);
    clf reset
    h(length(h)+1) = subplot(3,1,1);
    plot(Orbit.TurnNumber, Orbit.PTHBrms ./ Orbit.PTHArms);
    title(sprintf('Ratio of the Upper Pilot Tone RMS at %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmPTH(1)), ENV.Machine.Clock), 'FontSize', FontSize);
    ylabel('B/A', 'FontSize', FontSize);
    axis tight
    h(length(h)+1) = subplot(3,1,2);
    plot(Orbit.TurnNumber, Orbit.PTHCrms ./ Orbit.PTHArms);
    ylabel('C/A', 'FontSize', FontSize);
    axis tight
    h(length(h)+1) = subplot(3,1,3);
    plot(Orbit.TurnNumber, Orbit.PTHDrms ./ Orbit.PTHArms);
    ylabel('D/A', 'FontSize', FontSize);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    axis tight
    
        

    
    %%%%%%%%%%%%%%
    % PT - Lower %
    %%%%%%%%%%%%%%
    nFig = nFig + 1;
    figure(nFig);
    clf reset
    h(length(h)+1) = subplot(2,1,1);
    plot(Orbit.TurnNumber, 1000*Orbit.PTLx, '-b');
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    ylabel('Horizontal [\mum]', 'FontSize', FontSize);
    title(sprintf('Lower Pilot Tone Horizontal Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.PTLx), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    axis tight
    a = axis;
    axis([0 a(2:4)]);
    
    h(length(h)+1) = subplot(2,1,2);
    plot(Orbit.TurnNumber, 1000*Orbit.PTLy, '-b');
    ylabel('Vertical [\mum]', 'FontSize', FontSize);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    title(sprintf('Lower Pilot Tone Vertical Orbit Data (RMS=%.3f \\mum) (%d turn FFT, %d averages)', 1000*std(Orbit.PTLy), Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    axis tight
    a = axis;
    axis([0 a(2:4)]);

    nFig = nFig + 1;
    figure(nFig);
    clf reset
    plot(Orbit.TurnNumber, [Orbit.PTLArms-Orbit.PTLArms(1); Orbit.PTLBrms-Orbit.PTLBrms(1); Orbit.PTLCrms-Orbit.PTLCrms(1); Orbit.PTLDrms-Orbit.PTLDrms(1);]);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    ylabel('RMS [Counts]', 'FontSize', FontSize);
    title(sprintf('Channel RMS at the Lower Pilot Tone Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmPTL(1)), ENV.Machine.Clock), 'FontSize', FontSize);
    legend(sprintf('Button A_0=%.4g',Orbit.PTLArms(1)), sprintf('Button B_0=%.4g',Orbit.PTLBrms(1)), sprintf('Button C_0=%.4g',Orbit.PTLCrms(1)), sprintf('Button D_0=%.4g',Orbit.PTLDrms(1)), 'Location', 'NorthWest');
    axis tight
    
    nFig = nFig + 1;
    figure(nFig);
    clf reset
    h(length(h)+1) = subplot(3,1,1);
    plot(Orbit.TurnNumber, Orbit.PTLBrms ./ Orbit.PTLArms);
    title(sprintf('Ratio of the Lower Pilot Tone RMS at %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmPTL(1)), ENV.Machine.Clock), 'FontSize', FontSize);
    ylabel('B/A', 'FontSize', FontSize);
    axis tight
    h(length(h)+1) = subplot(3,1,2);
    plot(Orbit.TurnNumber, Orbit.PTLCrms ./ Orbit.PTLArms);
    ylabel('C/A', 'FontSize', FontSize);
    axis tight
    h(length(h)+1) = subplot(3,1,3);
    plot(Orbit.TurnNumber, Orbit.PTLDrms ./ Orbit.PTLArms);
    ylabel('D/A', 'FontSize', FontSize);
    xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
    axis tight

    
    linkaxes(h, 'x');

    return



%%%%%%%%%%%%%%
% Histograms %
%%%%%%%%%%%%%%
nFig = nFig + 1;
figure(nFig);
clf reset
subplot(2,2,1);
hist(Orbit.Arms, 1000);
grid on 
xlabel('Arms [Counts]', 'FontSize', FontSize);
xaxis([-10 10]+mean(Orbit.Arms));
%addlabel(.5, 1, sprintf('Histogram: Button RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), FontSize);
addlabel(.5, 1, sprintf('Histogram: Button RMS at the RF Freq = %.3f MHz  (RF = %.6f MHz)', Orbit.f(Orbit.nHarmOrbit(1)), ENV.Machine.Clock), FontSize);

subplot(2,2,2);
hist(Orbit.Brms, 1000);
grid on 
xlabel('Brms [Counts]', 'FontSize', FontSize);
xaxis([-10 10]+mean(Orbit.Brms));

subplot(2,2,3);
hist(Orbit.Crms, 1000);
grid on 
xlabel('Crms [Counts]', 'FontSize', FontSize);
xaxis([-10 10]+mean(Orbit.Crms));

subplot(2,2,4);
hist(Orbit.Drms, 1000);
grid on 
xlabel('Drms [Counts]', 'FontSize', FontSize);
xaxis([-10 10]+mean(Orbit.Drms));

nFig = nFig + 1;
figure(nFig);
clf reset
subplot(2,2,1);
hist(Orbit.TPArms, 1000);
grid on 
xlabel('TP Arms [Counts]', 'FontSize', FontSize);
addlabel(.5, 1, sprintf('Histogram: Button RMS at a Test Point of %.3f MHz', Orbit.f(Orbit.nHarmTP(1))), FontSize);

subplot(2,2,2);
hist(Orbit.TPBrms, 1000);
grid on 
xlabel('TP Brms [Counts]', 'FontSize', FontSize);

subplot(2,2,3);
hist(Orbit.TPCrms, 1000);
grid on 
xlabel('TP Crms [Counts]', 'FontSize', FontSize);

subplot(2,2,4);
hist(Orbit.TPDrms, 1000);
grid on 
xlabel('TP Drms [Counts]', 'FontSize', FontSize);



linkaxes(h, 'x');


%     nFig = nFig + 1;
%     figure(nFig);
%     clf reset
%     subplot(2,2,1);
%     hist(Orbit.PTHArms, 1000);
%     grid on
%     xlabel('PT Arms [Counts]', 'FontSize', FontSize);
%     addlabel(.5, 1, sprintf('Histogram: Button RMS at the Pilot Tone %.3f MHz', Orbit.f(Orbit.nHarmPTH(1))), FontSize);
% 
%     subplot(2,2,2);
%     hist(Orbit.PTHBrms, 1000);
%     grid on
%     xlabel('PT Brms [Counts]', 'FontSize', FontSize);
%     
%     subplot(2,2,3);
%     hist(Orbit.PTHCrms, 1000);
%     grid on
%     xlabel('PT Crms [Counts]', 'FontSize', FontSize);
%     
%     subplot(2,2,4);
%     hist(Orbit.PTHDrms, 1000);
%     grid on
%     xlabel('PT Drms [Counts]', 'FontSize', FontSize);


% figure(Setup.PSD.FigNum + 8);
% N_plot = 77 * 2;
% clf reset
% plot((1:N_plot), ADC.cha(1:N_plot), 'b');
% hold on
% plot((1:N_plot), ADC.chb(1:N_plot), 'g');
% plot((1:N_plot), ADC.chc(1:N_plot), 'r');
% plot((1:N_plot), ADC.chd(1:N_plot), 'c');
% a = axis;
% axis([0 N_plot a(3:4)]);
% title('ADC Data', 'FontSize', FontSize);
% ylabel('ADC Counts', 'FontSize', FontSize);
% xlabel('Sample Number [~8.526 nsec/sample]', 'FontSize', FontSize);
% %yaxis([-55 55]);

%     % Phase vs time
%     if 0
%         figure(Setup.xy.FigNum+5);
%         clf reset
%         h = subplot(2,2,1);
%         plot(Orbit.TurnNumber, PhaseA(Orbit.Orbit.nHarm(21),:), 'b');
%         xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%         ylabel('Channel A [Radians]', 'FontSize', FontSize);
%         %title(sprintf('Horizontal Orbit Data (RMS=%.3f \\mum)',1000*std(Orbit.x)), 'FontSize', FontSize);
%         axis tight
%
%         h(2) = subplot(2,2,2);
%         plot(Orbit.TurnNumber, PhaseB(Orbit.Orbit.nHarm(21),:), 'b');
%         ylabel('Channel B [Radians]', 'FontSize', FontSize);
%         xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%         axis tight
%
%         h(3) = subplot(2,2,3);
%         plot(Orbit.TurnNumber, PhaseD(Orbit.Orbit.nHarm(21),:), 'b');
%         ylabel('Channel D [Radians]', 'FontSize', FontSize);
%         xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%         axis tight
%
%         h(4) = subplot(2,2,4);
%         plot(Orbit.TurnNumber, PhaseC(Orbit.Orbit.nHarm(21),:), 'b');
%         ylabel('Channel C [Radians]', 'FontSize', FontSize);
%         xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%         axis tight
%
%         linkaxes(h, 'x');
%
%         addlabel(.5, 1, 'Button Phase');
%     else
%         figure(Setup.xy.FigNum+5);
%         clf reset
%         plot(Orbit.TurnNumber, [PhaseA(Orbit.Orbit.nHarm(21),:);PhaseB(Orbit.Orbit.nHarm(21),:);PhaseC(Orbit.Orbit.nHarm(21),:);PhaseD(Orbit.Orbit.nHarm(21),:);]);
%         xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%         ylabel('Phase [Radians]', 'FontSize', FontSize);
%         %title(sprintf('Horizontal Orbit Data (RMS=%.3f \\mum)',1000*std(Orbit.x)), 'FontSize', FontSize);
%         axis tight
%     end


%     h(3) = subplot(3,1,3);
%     %plot([Orbit.Arms-Orbit.Arms(1); Orbit.Brms-Orbit.Brms(1); Orbit.Crms-Orbit.Crms(1); Orbit.Drms-Orbit.Drms(1)]');
%     plot(Orbit.Arms-Orbit.Arms(1),'b');
%     hold on
%     plot(Orbit.Brms-Orbit.Brms(1),'g');
%     plot(Orbit.Crms-Orbit.Crms(1),'r');
%     plot(Orbit.Drms-Orbit.Drms(1),'k');
%     hold off;
%     %plot(Orbit.Arms,'b');
%     %hold on
%     %plot(Orbit.Brms,'g');
%     %plot(Orbit.Crms,'r');
%     %plot(Orbit.Drms,'k');
%     %hold off;
%     ylabel('Button RMS', 'FontSize', FontSize);
%     xlabel('Turns [~656 ns / turn]', 'FontSize', FontSize);
%     title(sprintf('Button RMS (first point subtracted) (first point: %.3f  %.3f  %.3f  %.3f)',Orbit.Arms(1),Orbit.Brms(1),Orbit.Crms(1),Orbit.Drms(1)), 'FontSize', FontSize);
%     axis tight
%     a = axis;
%     axis([0 a(2:4)]);


%     % PSD plot (just plot everything)
%     figure(Setup.xy.FigNum+1);
%     clf reset
%     if SaveAllPSD
%         for i = 1:PlotTurns
%             semilogy(Orbit.f, Orbit.Paa(:,i)/NN/T1, 'b');  % Volt^2/Hz
%             hold on
%             semilogy(Orbit.f, Orbit.Pbb(:,i)/NN/T1, 'g');  % Volt^2/Hz
%             semilogy(Orbit.f, Orbit.Pcc(:,i)/NN/T1, 'r');  % Volt^2/Hz
%             semilogy(Orbit.f, Orbit.Pdd(:,i)/NN/T1, 'k');  % Volt^2/Hz
%         end
%     else
%         semilogy(Orbit.f, Orbit.Paa/NN/T1, 'b');  % Volt^2/Hz
%         hold on
%         semilogy(Orbit.f, Orbit.Pbb/NN/T1, 'g');  % Volt^2/Hz
%         semilogy(Orbit.f, Orbit.Pcc/NN/T1, 'r');  % Volt^2/Hz
%         semilogy(Orbit.f, Orbit.Pdd/NN/T1, 'k');  % Volt^2/Hz
%     end
%     hold off
%
%     legend('Button A', 'Button B', 'Button C', 'Button D', 'Location', 'NorthWest');
%     axis tight;
%     xaxis([0 60]);
%     %a = axis;
%     %axis([0 60 1e-8 a(4)]);
%     %axis([2 60 1e-8 a(4)]);
%     %axis([2 60 1e-8 1]);
%     %set(gca,'xtick',[2:10 20 30 40 50 60])
%     %a = logspace(-8,1,10);
%     %set(gca,'ytick',a(1:2:end))
%
%     % Add line to show DFT bins in the rms calculation
%     %lx(1) = Orbit.f(low);
%     %lx(2) = lx(1);
%     %ly(1) = 1e-10;
%     %ly(2) = max(max(Orbit.Paa))/Fs;
%     %line(lx, ly, 'Color', 'm', 'LineWidth', 2);
%     %lx(1) = Orbit.f(high);
%     %lx(2) = lx(1);
%     %line(lx, ly, 'Color', 'm', 'LineWidth', 2);
%
%     title(sprintf('Power Spectrum of Each Button (%d turns FFT, %d averages)', Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
%     ylabel('[Counts^2/Hz]', 'FontSize', FontSize);
%     xlabel('Frequency [MHz]', 'FontSize', FontSize);
%     grid on
%     hold off


%     % Phase plot
%     figure(Setup.xy.FigNum+2);
%     clf reset
%     for i = 1:PlotTurns
%         plot(Orbit.f(Orbit.Orbit.nHarm), PhaseA(Orbit.Orbit.nHarm,i), 'b');
%         hold on
%         plot(Orbit.f(Orbit.nHarm), PhaseB(Orbit.nHarm,i), 'g');
%         plot(Orbit.f(Orbit.nHarm), PhaseC(Orbit.nHarm,i), 'r');
%         plot(Orbit.f(Orbit.nHarm), PhaseD(Orbit.nHarm,i), 'k');
%     end
%     hold off
%
%     legend('Button A', 'Button B', 'Button C', 'Button D', 'Location', 'NorthWest');
%     axis tight;
%     a = axis;
%     xaxis([0 60]);
%     %set(gca,'xtick',[2:10 20 30 40 50 60])
%     title(sprintf('Phase for Each Button (%d turn FFT, %d averages)', Setup.xy.NTurnsPerFFT, Setup.xy.NAvg));
%     ylabel('[Radians]');
%     xlabel('Frequency [MHz]');
%     grid on
%     hold off
