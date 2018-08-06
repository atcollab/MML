function bpm_plotsa(SA, FigNum)
%

% Written by Greg Portmann


% Equal amplitude test, PTs on but compensation off
%  9:38am Start
%         SA = bpm_getsa('SR01C:BPM4:',0:.1:2*60*60, 1);
%  9:47am Openned the rack door
% 10:36am Closed the rack door
%


if nargin < 2
    FigNum = 100;
end


PTFlag = 1;
FontSize = 12;


if PTFlag == 2 && ~isfield(SA, 'GainA')
    PTFlag = 9;
end


% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
[Xgain, Ygain] = bpm_getgain([1 2]);

% SA.s = SA.A + SA.B + SA.C + SA.D;
% SA.X= Xgain * (SA.A - SA.B - SA.C + SA.D ) ./ SA.s;  % mm
% SA.Y = Ygain * (SA.A + SA.B - SA.C - SA.D ) ./ SA.s;  % mm

% Unscaled RF
SA.A = SA.A ./ SA.GainA;
SA.B = SA.B ./ SA.GainB;
SA.C = SA.C ./ SA.GainC;
SA.D = SA.D ./ SA.GainD;

if PTFlag == 1
    SA.PTHiS =          SA.PTHiA + SA.PTHiB + SA.PTHiC + SA.PTHiD;
    SA.PTHiX = Xgain * (SA.PTHiA - SA.PTHiB - SA.PTHiC + SA.PTHiD ) ./ SA.PTHiS;  % mm
    SA.PTHiY = Ygain * (SA.PTHiA + SA.PTHiB - SA.PTHiC - SA.PTHiD ) ./ SA.PTHiS;  % mm
    
    
    % PTHi delayed
    if 1
        n = 0;
        if 0
            aa = SA.A;
            bb = SA.B .* (SA.PTHiA ./ SA.PTHiB);
            cc = SA.C .* (SA.PTHiA ./ SA.PTHiC);
            dd = SA.D .* (SA.PTHiA ./ SA.PTHiD);
        elseif 0
            aa = SA.A;
            bb = SA.B .* (SA.PTLoA ./ SA.PTLoB);
            cc = SA.C .* (SA.PTLoA ./ SA.PTLoC);
            dd = SA.D .* (SA.PTLoA ./ SA.PTLoD);
        elseif 0
            aa = SA.A .* (SA.PTLoA(1) ./ SA.PTLoA);
            bb = SA.B .* (SA.PTLoB(1) ./ SA.PTLoB);
            cc = SA.C .* (SA.PTLoC(1) ./ SA.PTLoC);
            dd = SA.D .* (SA.PTLoD(1) ./ SA.PTLoD);
        elseif 0
            aa = SA.A .* (SA.PTHiA(1) ./ SA.PTHiA);
            bb = SA.B .* (SA.PTHiB(1) ./ SA.PTHiB);
            cc = SA.C .* (SA.PTHiC(1) ./ SA.PTHiC);
            dd = SA.D .* (SA.PTHiD(1) ./ SA.PTHiD);
        elseif 0
            aa = SA.A .* ((SA.PTLoA(1) ./ SA.PTLoA) + (SA.PTHiA(1) ./ SA.PTHiA)) / 2;
            bb = SA.B .* ((SA.PTLoB(1) ./ SA.PTLoB) + (SA.PTHiB(1) ./ SA.PTHiB)) / 2;
            cc = SA.C .* ((SA.PTLoC(1) ./ SA.PTLoC) + (SA.PTHiC(1) ./ SA.PTHiC)) / 2;
            dd = SA.D .* ((SA.PTLoD(1) ./ SA.PTLoD) + (SA.PTHiD(1) ./ SA.PTHiD)) / 2;
        else
            aa = SA.A;
            bb = SA.B .* ((SA.PTLoA ./ SA.PTLoB) + (SA.PTHiA ./ SA.PTHiB)) / 2;
            cc = SA.C .* ((SA.PTLoA ./ SA.PTLoC) + (SA.PTHiA ./ SA.PTHiC)) / 2;
            dd = SA.D .* ((SA.PTLoA ./ SA.PTLoD) + (SA.PTHiA ./ SA.PTHiD)) / 2;
        end
    else
        % Just to make
        n = 0;
        aa = SA.A(1:end-n);
        bb = SA.B(1:end-n) .* (SA.PTHiA(1+n:end) ./ SA.PTHiB(1+n:end));
        cc = SA.C(1:end-n) .* (SA.PTHiA(1+n:end) ./ SA.PTHiC(1+n:end));
        dd = SA.D(1:end-n) .* (SA.PTHiA(1+n:end) ./ SA.PTHiD(1+n:end));
    end
    
    
    SA.ss =          aa + bb + cc + dd;
    SA.xx = Xgain * (aa - bb - cc + dd ) ./ SA.ss;  % mm
    SA.yy = Ygain * (aa + bb - cc - dd ) ./ SA.ss;  % mm
end


if 1
    
    if SA.tout(end) > 3*60*60
        TimeScalar = 60*60;
        TimeLabel = 'Time [Hours]';
    elseif SA.tout(end) > 4*60
        TimeScalar = 60;
        TimeLabel = 'Time [Minutes]';
    else
        TimeScalar = 1;
        TimeLabel = 'Time [Seconds]';
    end
    
    
    figure(FigNum + 0);
    clf reset
    h = subplot(2,1,1);
    plot(SA.tout/TimeScalar, SA.X);
    %plot(SA.tout/TimeScalar, SA.X - SA.X(200));
    xlabel(TimeLabel);
    ylabel('Horizontal [mm]');
    title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.X),1000*(max(SA.X)-min(SA.X))));
    axis tight
    
    h(length(h)+1) = subplot(2,1,2);
    plot(SA.tout/TimeScalar, SA.Y);
    %plot(SA.tout/TimeScalar, SA.Y - SA.Y(200));
    xlabel(TimeLabel);
    ylabel('Vertical [mm]');
    title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.Y),1000*(max(SA.Y)-min(SA.Y))));
    axis tight
    
    figure(FigNum + 1);
    clf reset
    h(length(h)+1) = subplot(1,1,1);
    %plot(SA.tout/TimeScalar, [SA.A; SA.B; SA.C; SA.D]);
    plot(SA.tout/TimeScalar, [SA.A-mean(SA.A); SA.B-mean(SA.B); SA.C-mean(SA.C); SA.D-mean(SA.D)]);
    xlabel(TimeLabel);
    %axis tight;
    legend(sprintf('A - %.0f',mean(SA.A)), sprintf('B - %.0f',mean(SA.B)), sprintf('C - %.0f',mean(SA.C)), sprintf('D - %.0f',mean(SA.D)));
    %legend(sprintf('mean(A) = %.0f',mean(SA.A)), sprintf('mean(B) = %.0f',mean(SA.B)), sprintf('mean(C) = %.0f',mean(SA.C)), sprintf('mean(D) = %.0f',mean(SA.D)));
    title('SA Data at the RF Frequency (rfMag)');
    %a = axis;
    
    figure(FigNum + 2);
    clf reset
    h(length(h)+1) = subplot(2,2,1);
    plot(SA.tout/TimeScalar, SA.A);
    xlabel(TimeLabel);
    ylabel('SA A');
    %axis(a);
    
    h(length(h)+1) = subplot(2,2,2);
    plot(SA.tout/TimeScalar, SA.B);
    xlabel(TimeLabel);
    ylabel('SA B');
    %axis(a);
    
    h(length(h)+1) = subplot(2,2,3);
    plot(SA.tout/TimeScalar, SA.C);
    xlabel(TimeLabel);
    ylabel('SA C');
    %axis(a);
    
    h(length(h)+1) = subplot(2,2,4);
    plot(SA.tout/TimeScalar, SA.D);
    xlabel(TimeLabel);
    ylabel('SA D');
    %axis(a);
    
    figure(FigNum + 3);
    clf reset
    h(length(h)+1) = subplot(1,1,1);
    plot(SA.tout/TimeScalar, SA.DCCT);
    xlabel(TimeLabel);
    ylabel('DCCT [mA]');
    title('SR Beam Current');
    axis tight
    
    %     figure(FigNum + 4);
    %     clf reset
    %     h(length(h)+1) = subplot(1,1,1);
    %     plot(SA.tout/TimeScalar, 1e6*(SA.RF-SA.RF(1)));
    %     xlabel(TimeLabel);
    %     ylabel('\Delta RF [Hz]');
    %     title('RF Frequency');
    %     axis tight
    
    if PTFlag == 1
        
        figure(FigNum + 4);
        clf reset
        h(length(h)+1) = subplot(2,1,1);
        plot(SA.tout/TimeScalar, SA.PTHiX, 'g');
        xlabel(TimeLabel);
        ylabel('Horizontal [mm]');
        title(sprintf('Pilot Tone  std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.PTHiX),1000*(max(SA.PTHiX)-min(SA.PTHiX))));
        axis tight
        
        h(length(h)+1) = subplot(2,1,2);
        plot(SA.tout/TimeScalar, SA.PTHiY);
        xlabel(TimeLabel);
        ylabel('Vertical [mm]');
        title(sprintf('Pilot Tone  std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.PTHiY),1000*(max(SA.PTHiY)-min(SA.PTHiY))));
        axis tight
        
        figure(FigNum + 14);
        clf reset
        h(length(h)+1) = subplot(2,2,1);
        plot(SA.tout/TimeScalar, (SA.PTHiA(1) ./ SA.PTHiA), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, (SA.PTLoA(1) ./ SA.PTLoA), 'g');
        plot(SA.tout/TimeScalar, (SA.A(1)     ./ SA.A),     'r');
        hold off
        axis tight
        xlabel(TimeLabel);
        title('SA Data A');
        legend('High PT','Low PT','RF');
        h(length(h)+1) = subplot(2,2,2);
        plot(SA.tout/TimeScalar, (SA.PTHiB(1) ./ SA.PTHiB), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, (SA.PTLoB(1) ./ SA.PTLoB), 'g');
        plot(SA.tout/TimeScalar, (SA.B(1)     ./ SA.B),     'r');
        hold off
        axis tight
        xlabel(TimeLabel);
        title('SA Data B');
        h(length(h)+1) = subplot(2,2,3);
        plot(SA.tout/TimeScalar, (SA.PTHiC(1) ./ SA.PTHiC), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, (SA.PTLoC(1) ./ SA.PTLoC), 'g');
        plot(SA.tout/TimeScalar, (SA.C(1)     ./ SA.C),     'r');
        hold off
        axis tight
        xlabel(TimeLabel);
        title('SA Data C');
        h(length(h)+1) = subplot(2,2,4);
        plot(SA.tout/TimeScalar, (SA.PTHiD(1) ./ SA.PTHiD), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, (SA.PTLoD(1) ./ SA.PTLoD), 'g');
        plot(SA.tout/TimeScalar, (SA.D(1)     ./ SA.D),     'r');
        hold off
        axis tight
        xlabel(TimeLabel);
        title('SA Data D');

        figure(FigNum + 15);
        clf reset
        h(length(h)+1) = subplot(2,2,1);
        plot(SA.tout/TimeScalar, [SA.PTHiA-mean(SA.PTHiA(1:100)); ], 'b');
        hold on ;
        plot(SA.tout/TimeScalar, [SA.PTLoA-mean(SA.PTLoA(1:100)); ], 'g');
        plot(SA.tout/TimeScalar, [SA.A-mean(SA.A(1:100)); ], 'r');
        hold off
        xlabel(TimeLabel);
        title('SA Data A');
        legend('High PT','Low PT','RF');
        %axis tight;
        h(length(h)+1) = subplot(2,2,2);
        plot(SA.tout/TimeScalar, [SA.PTHiB-mean(SA.PTHiB(1:100)); ], 'b');
        hold on ;
        plot(SA.tout/TimeScalar, [SA.PTLoB-mean(SA.PTLoB(1:100)); ], 'g');
        plot(SA.tout/TimeScalar, [SA.B-mean(SA.B(1:100)); ], 'r');
        hold off
        xlabel(TimeLabel);
        title('SA Data B');
        %axis tight;
        h(length(h)+1) = subplot(2,2,3);
        plot(SA.tout/TimeScalar, [SA.PTHiC-mean(SA.PTHiC(1:100)); ], 'b');
        hold on 
        plot(SA.tout/TimeScalar, [SA.PTLoC-mean(SA.PTLoC(1:100)); ], 'g');
        plot(SA.tout/TimeScalar, [SA.C-mean(SA.C(1:100)); ], 'r');
        hold off
        xlabel(TimeLabel);
        title('SA Data C');
        %axis tight;
        h(length(h)+1) = subplot(2,2,4);
        plot(SA.tout/TimeScalar, [SA.PTHiD-mean(SA.PTHiD(1:100)); ], 'b');
        hold on ;
        plot(SA.tout/TimeScalar, [SA.PTLoD-mean(SA.PTLoD(1:100)); ], 'g');
        plot(SA.tout/TimeScalar, [SA.D-mean(SA.D(1:100)); ], 'r');
        hold off
        xlabel(TimeLabel);
        title('SA Data D');
        %axis tight;
        
        GainLoB = SA.PTLoB./SA.PTLoA;
        GainLoC = SA.PTLoC./SA.PTLoA;
        GainLoD = SA.PTLoD./SA.PTLoA;
        
        GainHiB = SA.PTHiB./SA.PTHiA;
        GainHiC = SA.PTHiC./SA.PTHiA;
        GainHiD = SA.PTHiD./SA.PTHiA;
        
        GainRFB = SA.B./SA.A;
        GainRFC = SA.C./SA.A;
        GainRFD = SA.D./SA.A;

        figure(FigNum + 16);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(SA.tout/TimeScalar, GainLoB - GainLoB(1), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, GainLoC - GainLoC(1), 'g');
        plot(SA.tout/TimeScalar, GainLoD - GainLoD(1), 'r');
        hold off
        xlabel(TimeLabel);
        title('SA Low PT');
        
        h(length(h)+1) = subplot(3,1,2);
        plot(SA.tout/TimeScalar, GainRFB - GainRFB(1), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, GainRFC - GainRFC(1), 'g');
        plot(SA.tout/TimeScalar, GainRFD - GainRFD(1), 'r');
        hold off
        xlabel(TimeLabel);
        title('SA RF');
        
        h(length(h)+1) = subplot(3,1,3);
        plot(SA.tout/TimeScalar, GainHiB - GainHiB(1), 'b');
        hold on ;
        plot(SA.tout/TimeScalar, GainHiC - GainHiC(1), 'g');
        plot(SA.tout/TimeScalar, GainHiD - GainHiD(1), 'r');
        hold off
        xlabel(TimeLabel);
        title('SA High PT');
   
        
        figure(FigNum + 5);
        clf reset
        h(length(h)+1) = subplot(1,1,1);
        plot(SA.tout/TimeScalar, [SA.PTHiA-mean(SA.PTHiA); SA.PTHiB-mean(SA.PTHiB); SA.PTHiC-mean(SA.PTHiC); SA.PTHiD-mean(SA.PTHiD)], 'b');
        %hold on ;
        %plot(SA.tout/TimeScalar, [SA.PTLoA-mean(SA.PTLoA); SA.PTLoB-mean(SA.PTLoB); SA.PTLoC-mean(SA.PTLoC); SA.PTLoD-mean(SA.PTLoD)]);
        %plot(SA.tout/TimeScalar, [SA.A-mean(SA.A); SA.B-mean(SA.B); SA.C-mean(SA.C); SA.D-mean(SA.D)]);
        xlabel(TimeLabel);
        title('SA Data at the Pilot Tone Frequency (PTHiMag)');
        legend(sprintf('PTHiA - %.0f',mean(SA.PTHiA)), sprintf('PTHiB - %.0f',mean(SA.PTHiB)), sprintf('PTHiC - %.0f',mean(SA.PTHiC)), sprintf('PTHiD - %.0f',mean(SA.PTHiD)));
        %axis tight;
        a = axis;
        
        figure(FigNum + 6);
        clf reset
        h(length(h)+1) = subplot(2,2,1);
        plot(SA.tout/TimeScalar, SA.PTHiA);
        xlabel(TimeLabel);
        ylabel('SA PTHiA');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,2);
        plot(SA.tout/TimeScalar, SA.PTHiB);
        xlabel(TimeLabel);
        ylabel('SA PTHiB');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,3);
        plot(SA.tout/TimeScalar, SA.PTHiC);
        xlabel(TimeLabel);
        ylabel('SA PTHiC');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,4);
        plot(SA.tout/TimeScalar, SA.PTHiD);
        xlabel(TimeLabel);
        ylabel('SA PTHiD');
        %axis(a);
        
        figure(FigNum + 7);
        clf reset
        h = subplot(2,1,1);
        plot(SA.tout(1:end-n)/TimeScalar, SA.xx);
        xlabel(TimeLabel);
        ylabel('Horizontal [mm]');
        title(sprintf('Pilot Tone Corrected:  std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.xx),1000*(max(SA.xx)-min(SA.xx))));
        axis tight
        
        h(length(h)+1) = subplot(2,1,2);
        plot(SA.tout(1:end-n)/TimeScalar, SA.yy);
        xlabel(TimeLabel);
        ylabel('Vertical [mm]');
        title(sprintf('Pilot Tone Corrected:  std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.yy),1000*(max(SA.yy)-min(SA.yy))));
        axis tight
        
        figure(FigNum + 8);
        clf reset
        h(length(h)+1) = subplot(1,1,1);
        plot(SA.tout(1:end-n)/TimeScalar, [aa-mean(aa(1)); bb-mean(bb(1)); cc-mean(cc(1)); dd-mean(dd(1))]);
        xlabel(TimeLabel);
        title('Pilot Tone Corrected SA Data at the RF Frequency (rfMag)');
        %axis tigc
        %legend(sprintf('mean(A) = %.0f',mean(aa)), sprintf('mean(B) = %.0f',mean(bb)), sprintf('mean(C) = %.0f',mean(cc)), sprintf('mean(D) = %.0f',mean(dd)));
        legend(sprintf('A - %.0f',mean(aa)), sprintf('B - %.0f',mean(bb)), sprintf('C - %.0f',mean(cc)), sprintf('D - %.0f',mean(dd)));
        %a = axis;
        
        figure(FigNum + 9 );
        clf reset
        h = subplot(2,1,1);
        plot(SA.tout/TimeScalar, 1000*(SA.X- mean(SA.X)));
        hold on
        plot(SA.tout(1:end-n)/TimeScalar, 1000*(SA.xx - mean(SA.xx)), 'g');
        xlabel(TimeLabel);
        ylabel('Horizontal [\mum]');
        %title(sprintf('std=%.3f / %.3f \\mum   peak-to-peak = %.3f / %.3f \\mum',1000*std(SA.x), 1000*std(SA.xx), 1000*(max(SA.X)-min(SA.X)), 1000*(max(SA.xx)-min(SA.xx))));
        title(sprintf('SA Data:  std=%.3f / %.3f \\mum', 1000*std(SA.X), 1000*std(SA.xx)));
        if 0
            legend('Raw Orbit', 'Pilot Corrected Orbit', 'Location', 'NorthWest');
        else
            legend('Raw Orbit', sprintf('Pilot Corrected Orbit (PT delayed %d samples)',n), 'Location', 'NorthWest');
        end
        axis tight
        
        h(length(h)+1) = subplot(2,1,2);
        plot(SA.tout/TimeScalar, 1000*(SA.Y - mean(SA.Y)));
        hold on
        plot(SA.tout(1:end-n)/TimeScalar, 1000*(SA.yy - mean(SA.yy)), 'g');
        xlabel(TimeLabel);
        ylabel('Vertical [\mum]');
        %title(sprintf('std=%.3f / %.3f \\mum   peak-to-peak = %.3f / %.3f \\mum',1000*std(SA.Y), 1000*std(SA.yy), 1000*(max(SA.Y)-min(SA.Y)), 1000*(max(SA.yy)-min(SA.yy))));
        title(sprintf('SA Data:  std=%.3f / %.3f \\mum ', 1000*std(SA.Y), 1000*std(SA.yy)));
        axis tight
        
    elseif PTFlag == 2
        
%         A = SA.A ./ SA.GainA;
%         B = SA.B ./ SA.GainB;
%         C = SA.C ./ SA.GainC;
%         D = SA.D ./ SA.GainD;
        % A = SA.A;
        % B = SA.B;
        % C = SA.C;
        % D = SA.D;
        s = A + B + C + D;
        X = Xgain * (A - B - C + D ) ./ s;  % mm
        Y = Ygain * (A + B - C - D ) ./ s;  % mm
        
        
        figure(FigNum + 10);
        clf reset
        if 0
            h(length(h)+1) = subplot(2,2,1);
            plot(SA.tout/TimeScalar, SA.GainA);
            h(length(h)+1) = subplot(2,2,2);
            plot(SA.tout/TimeScalar, SA.GainB);
            h(length(h)+1) = subplot(2,2,3);
            plot(SA.tout/TimeScalar, SA.GainC);
            h(length(h)+1) = subplot(2,2,4);
            plot(SA.tout/TimeScalar, SA.GainD);
            xlabel(TimeLabel);
            ylabel('Gain');
            % title(sprintf('Pilot Tone  std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(SA.PTHiX),1000*(max(SA.PTHiX)-min(SA.PTHiX))));
            axis tight
        else
            h(length(h)+1) = subplot(1,1,1);
            plot(SA.tout/TimeScalar, [A-mean(A); B-mean(B); C-mean(C); D-mean(D)]);
            xlabel(TimeLabel);
            %axis tight;
            legend(sprintf('A - %.0f',mean(A)), sprintf('B - %.0f',mean(B)), sprintf('C - %.0f',mean(C)), sprintf('D - %.0f',mean(D)));
            title('SA Data at the RF Frequency (cal tone gain removed)');
            %a = axis;
        end
        
        
        figure(FigNum + 11);
        clf reset
        h(length(h)+1) = subplot(2,2,1);
        plot(SA.tout/TimeScalar, SA.A ./ SA.GainA);
        xlabel(TimeLabel);
        ylabel('SA A');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,2);
        plot(SA.tout/TimeScalar, SA.B ./ SA.GainB);
        xlabel(TimeLabel);
        ylabel('SA B');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,3);
        plot(SA.tout/TimeScalar, SA.C ./ SA.GainC);
        xlabel(TimeLabel);
        ylabel('SA C');
        %axis(a);
        
        h(length(h)+1) = subplot(2,2,4);
        plot(SA.tout/TimeScalar, SA.D ./ SA.GainD);
        xlabel(TimeLabel);
        ylabel('SA D');
        %axis(a);
        
        figure(FigNum + 12);
        clf reset
        h(length(h)+1) = subplot(2,1,1);
        plot(SA.tout/TimeScalar, X);
        xlabel(TimeLabel);
        ylabel('Horizontal [mm]');
        title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(X),1000*(max(X)-min(X))));
        axis tight
        
        h(length(h)+1) = subplot(2,1,2);
        plot(SA.tout/TimeScalar, Y);
        xlabel(TimeLabel);
        ylabel('Vertical [mm]');
        title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(Y),1000*(max(Y)-min(Y))));
        axis tight
        
    end
end

linkaxes(h, 'x');



if 0
    % PSD
    Pxx = 0;
    Pyy = 0;
    Paa = 0;
    Pbb = 0;
    Pcc = 0;
    Pdd = 0;
    
    %T = 656e-9 * SA.TurnNumber(end)
    %T = SA.TurnNumber(end) * 328/(ENV.RF0*1e6);
    %fs = N / T;
    fs = 10;
    WindowType = 'hanning';
    
    NAVG = 1;
    N = 10000;
    NN = length(SA.X);
    T1 = 1 / fs;
    NAVG = floor(NN / N)
    
    for j = 1:NAVG
        
        ii = N*(j-1)+(1:N);
        
        SA.PSD.WindowType = WindowType;
        Pxx = Pxx + psd_local(SA.X(ii), fs, SA.PSD.WindowType) / NAVG;
        Pyy = Pyy + psd_local(SA.Y(ii), fs, SA.PSD.WindowType) / NAVG;
        Paa = Paa + psd_local(SA.A(ii), fs, SA.PSD.WindowType) / NAVG;
        Pbb = Pbb + psd_local(SA.B(ii), fs, SA.PSD.WindowType) / NAVG;
        Pcc = Pcc + psd_local(SA.C(ii), fs, SA.PSD.WindowType) / NAVG;
        Pdd = Pdd + psd_local(SA.D(ii), fs, SA.PSD.WindowType) / NAVG;
        
        %     figure(FigNum + 10);
        %     clf reset
        %     h2 = subplot(2,1,1);
        %     plot((0:length(SA.X(ii))-1)/fs, SA.X(ii));
        %     xlabel('Time [Seconds]', 'FontSize', FontSize);
        %     ylabel('Horizontal [mm]', 'FontSize', FontSize);
        %     title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.X)), 'FontSize', FontSize);
        %
        %     h2(2) = subplot(2,1,2);
        %     plot((0:length(SA.X(ii))-1)/fs, SA.Y(ii));
        %     xlabel('Time Seconds]', 'FontSize', FontSize);
        %     ylabel('Vertical [mm]', 'FontSize', FontSize);
        %     title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.Y)), 'FontSize', FontSize);
        %     axis tight
        %     drawnow;
    end
    
    
    Nfreq = length(Paa);
    f = ((0:Nfreq-1)/Nfreq)*(fs/2);
    
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
    
    
    
    figure(FigNum + 11);
    clf reset
    h1 = subplot(2,1,1);
    loglog(f(3:end), 1e6*T1*Pxx(3:end));
    %title(sprintf('SA Horizontal PSD (%d points, %d turn FFT/point, %d averages)', N, Setup.xy.NTurnsPerFFT, Setup.xy.NAvg), 'FontSize', FontSize);
    title(sprintf('SA Horizontal PSD (%d points)', N), 'FontSize', FontSize);
    ylabel('Horizontal [\mum^2/Hz]', 'FontSize', FontSize);
    axis tight
    
    h1(2) = subplot(2,1,2);
    semilogx(f(2:end), 1e6*Pxx_int(2:end));
    xlabel('Frequency [Hz]', 'FontSize', FontSize);
    ylabel('[\mum {^2}]', 'FontSize', FontSize);
    title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Pxx_int(end))), 'FontSize', FontSize);
    axis tight
    
    figure(FigNum + 12);
    clf reset
    h1(3) = subplot(2,1,1);
    loglog(f(3:end), 1e6*T1*Pyy(3:end));
    title(sprintf('SA Vertical PSD (%d points)', N), 'FontSize', FontSize);
    ylabel('Vertical [\mum^2/Hz]', 'FontSize', FontSize);
    axis tight;
    
    h1(4) = subplot(2,1,2);
    semilogx(f(2:end), 1e6*Pyy_int(2:end));
    xlabel('Frequency [Hz]', 'FontSize', FontSize);
    ylabel('[\mum {^2}]', 'FontSize', FontSize);
    title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f \\mum)', FontSize+2, 1000*sqrt(Pyy_int(end))), 'FontSize', FontSize);
    axis tight;
    
    
    figure(FigNum + 13);
    h2 = subplot(2,1,1);
    plot((0:length(SA.X)-1)*1000/fs, SA.X);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.X)), 'FontSize', FontSize);
    axis tight;
    
    h2(2) = subplot(2,1,2);
    plot((0:length(SA.Y)-1)*1000/fs, SA.Y);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('SA Data (RMS=%.3f \\mum))', 1000*std(SA.Y)), 'FontSize', FontSize);
    axis tight
    axis tight;
    
    figure(FigNum + 14);
    clf reset
    h1(5) = subplot(2,1,1);
    loglog(f(3:end), T1*Paa(3:end), 'b');
    hold on
    loglog(f(3:end), T1*Pbb(3:end), 'g');
    loglog(f(3:end), T1*Pcc(3:end), 'r');
    loglog(f(3:end), T1*Pdd(3:end), 'c');
    title(sprintf('SA Channel PSD (%d points)', N), 'FontSize', FontSize);
    ylabel('["Volt"^2/Hz]', 'FontSize', FontSize);
    axis tight;
    
    h1(6) = subplot(2,1,2);
    semilogx(f(3:end), 1e6*Paa_int(3:end), 'b');
    hold on
    semilogx(f(3:end), 1e6*Pbb_int(3:end), 'g');
    semilogx(f(3:end), 1e6*Pcc_int(3:end), 'r');
    semilogx(f(3:end), 1e6*Pdd_int(3:end), 'c');
    xlabel('Frequency [Hz]', 'FontSize', FontSize);
    ylabel('["volts" {^2}]', 'FontSize', FontSize);
    title(sprintf('\\fontsize{%d}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: %.3f  %.3f  %.3f  %.3f)', FontSize+2,sqrt(Paa_int(end)),sqrt(Pbb_int(end)),sqrt(Pcc_int(end)),sqrt(Pdd_int(end))), 'FontSize', FontSize);
    axis tight;
    
    
    linkaxes(h1, 'x');
    linkaxes(h2, 'x');
    
    
    
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
    SA.PSD.f = f;
    SA.PSD.fs = fs;
    SA.PSD.T1 = T1;
    SA.PSD.N = N;
    
end


function [Paa, WindowType] = psd_local(a, fs, WindowType)
N = length(a);
T1 = 1/fs;     % Sampling period of xy [seconds]

% ??? TurnsPerFFT = SA.TurnNumber(end) / N;

if nargin < 3 || isempty(WindowType) || strcmpi(WindowType, 'None')
    w = ones(N,1);            % no window
else
    if exist('hanning','file')
        w = hanning(N);          % hanning window
        SA.PSD.WindowType = 'Hanning';
    else
        w = ones(1,N);            % no window
    end
end
w = w(:)';
U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

a_w = a .* w;
A = fft(a_w);
Paa = A.*conj(A)/N;
Paa = Paa/U;
Paa = Paa(1:ceil(N/2));
Paa(2:end) = 2*Paa(2:end);





