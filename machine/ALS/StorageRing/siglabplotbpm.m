function [rms1,  rms2, rms3, rms4] = siglabplot(Filename, JPegFlag, JPegDirectory, LineColor, HoldFlag)
% [rms1,  rms2, rms3, rms4] = siglabplot(Filename, JPegFlag, JPegDirectory, LineColor, HoldFlag)
%
%  Filename = data file name {default or []: ask user for file}
%
%  JPegFlag = 0    - do not output a JPeg file {default: 0}
%             else - output a JPeg formated file
%
%  JPegDirectory = directory name to save JPeg file {default: current directory}
%
%  LineColor = line color and style  (ex., '--r' is a red dotted line)
%
%  HoldFlag = 0    - new plot
%             else - hold last plot
%

if 0
    % For adding multiple plots
    h1=1;
    h2=2;
    h3=3;
    h4=4;
else
    h1 = figure;
    h2 = h1 + 1;
    h3 = h1 + 2;
    h4 = h1 + 3;
end

NoiseFloorFlag = 0;
SquareRootFlag = 0;
PaperPosition = [.25 .25 4 4.5];
Fstart = 10;
fprintf('  \n');


if nargin < 1
    [Filename, Pathname] = uigetfile('*.mat', 'Choose the desired PSD file.');
    if Filename==0
        disp('  Function canceled.');
        return
    end
    load([Pathname, Filename]);
else
    if isempty(Filename)
        [Filename, Pathname] = uigetfile('*.mat', 'Choose the desired PSD file.');
        if Filename==0
            disp('  Function canceled.');
            return
        end
        load([Pathname, Filename]);
    else
        load(Filename);
        if isunix
            Pathname = [pwd,'/'];
        else
            Pathname = [pwd,'\'];
        end
    end
end

if nargin < 2
    JPegFlag = 0;
end
if JPegFlag
    FontSize = 7;
else
    FontSize = 10;
end


if nargin < 3
    % Put in the same directory as Filename
    JPegDirectory = Pathname;
end

if nargin < 4
    LineColor = '-b';
end

if nargin < 5
    HoldFlag = 0;
end


f=f1*(0:length(Fd1)-1)';
ff = f(Fstart:end);

% Check for vibration data
if strcmp(lower(Pathname),'e:\idbpm\1998-12-01') | strcmp(lower(Pathname),'e:\idbpm\1998-11-19')
    fprintf('  Channel 2 is QFA vibration data\n');
    P1 = Fd1(Fstart:end);
    P2 = Fd2(Fstart:end);

    Gain = (1000 * 9.8/1000)^2;             % Vibration gain [(mm/s/s)^2 / Hz]
    P3 = Gain * Fd3;
    P4 = Gain * Fd4;
    P3(2:end) = Gain * Fd3(2:end) .* ((ones(size(f(2:end)))./(2*pi*f(2:end))).^4);
    P4(2:end) = Gain * Fd4(2:end) .* ((ones(size(f(2:end)))./(2*pi*f(2:end))).^4);
    P3 = P3(Fstart:end);
    P4 = P4(Fstart:end);

    Chan1Flag  = 'IDBPM';
    Chan1Label = 'IDBPMx(9,2)';
    Chan2Flag  = 'IDBPM';
    Chan2Label = 'IDBPMy(9,2)';
    Chan3Flag  = 'Vibration';
    Chan3Label = 'QFA(9,2)';
    Chan4Flag  = 'Vibration';
    Chan4Label = 'QFA(9,2)';
else
    P1 = Fd1(Fstart:end);
    P2 = Fd2(Fstart:end);
    P3 = Fd3(Fstart:end);
    P4 = Fd4(Fstart:end);

    Chan1Flag  = 'BPM';
    Chan1Label = 'BPMx(7,5)';
    Chan2Flag  = 'BPM';
    Chan2Label = 'BPMy(7,5)';
    Chan3Flag  = 'BPM';
    Chan3Label = 'BPMx(7,6)';
    Chan4Flag  = 'BPM';
    Chan4Label = 'BPMy(7,6)';

    %Chan1Flag  = 'IDBPM';
    %Chan1Label = 'IDBPMx(10,2)';
    %Chan2Flag  = 'IDBPM';
    %Chan2Label = 'IDBPMy(10,2)';
    %Chan3Flag  = 'IDBPM';
    %Chan3Label = 'IDBPMx(10,1)';
    %Chan4Flag  = 'IDBPM';
    %Chan4Label = 'IDBPMy(10,1)';
end

T = 1/f1;          % Time buffer length

if WindowType == 0
    Uwindow = 1;
    fprintf('  No window function\n');
elseif WindowType == 1
    Uwindow = .66666666666666667;
    fprintf('  Hanning window function\n');
else
    error('WindowType unknown');
end

year = TimeClock(1);
month = TimeClock(2);
day = TimeClock(3);
hour = TimeClock(4);
min = TimeClock(5);
sec  = TimeClock(6);


DateStr1 = sprintf('DCCT = %.1f mAmps  (%d-%d-%d  %d:%d:%.0f)', DCCT,month,day,year,hour,min,sec);
DirStr1  = sprintf('Data file: %s%s', lower(Pathname), lower(Filename));
%i=findstr(DirStr1,'\');
%DirStr1(i)='/';

fprintf('  Data file: %s%s \n', Pathname, Filename);
fprintf('  Created on %d-%d-%d at time %d:%d:%.0d \n', month,day,year,hour,min,sec);
fprintf('  DCCT = %.1f mAmps \n', DCCT);

if exist('FFEnable1') == 1
    fprintf('  FF  Enable 1 = ');
    fprintf(' %d ', FFEnable1);
    fprintf('\n');

    fprintf('  FF  Enable 2 = ');
    fprintf(' %d ', FFEnable2);
    fprintf('\n');

    fprintf('  Gap Enable 1 = ');
    fprintf(' %d ', GapEnable1);
    fprintf('\n');

    fprintf('  Gap Enable 2 = ');
    fprintf(' %d ', GapEnable2);
    fprintf('\n');

    fprintf('  Gaps 1 = ');
    fprintf(' %.3f ', Gap1);
    fprintf('\n');

    fprintf('  Gaps 2 = ');
    fprintf(' %.3f ', Gap2);
    fprintf('\n\n');
end


P1_int = sqrt(cumsum(P1(end:-1:1))*Uwindow);
P2_int = sqrt(cumsum(P2(end:-1:1))*Uwindow);
P3_int = sqrt(cumsum(P3(end:-1:1))*Uwindow);
P4_int = sqrt(cumsum(P4(end:-1:1))*Uwindow);

rms1 = 1000*P1_int(end);
rms2 = 1000*P2_int(end);
rms3 = 1000*P3_int(end);
rms4 = 1000*P4_int(end);


Buffer = .01;
HeightBuffer = .05;


figure(h1);
if JPegFlag
    subplot(2,1,1);
else
    subplot(2,2,1);
end
if HoldFlag; hold on; end
loglog(ff, 1000*1000*T*P1*Uwindow,LineColor);
if HoldFlag; hold off; end
if NoiseFloorFlag
    hold on;
    floor92(50,1,0,SquareRootFlag);
    hold off
end
set(gca,'FontSize',FontSize);
xlabel('Frequency [Hz]','FontSize',FontSize);
ylabel([Chan1Label, ' [\mum{^2}/Hz]'],'FontSize',FontSize);
axis tight
grid on

if JPegFlag
    title(sprintf('Horizontal Power Spectral Density (RMS=%.1f \\mum)',1000*P1_int(end)),'FontSize',FontSize);
    subplot(2,1,2);
else
    title('Horizontal Power Spectral Density','FontSize',FontSize);
    subplot(2,2,2);
end
if HoldFlag; hold on; end
loglog(ff, 1000*1000*T*P2*Uwindow,LineColor);
if HoldFlag; hold off; end
if NoiseFloorFlag
    hold on;
    floor92(50,2,0,SquareRootFlag);
    hold off
end
set(gca,'FontSize',FontSize);
xlabel('Frequency [Hz]','FontSize',FontSize);
ylabel([Chan2Label, ' [\mum{^2}/Hz]'],'FontSize',FontSize);
if JPegFlag
    title(sprintf('Vertical Power Spectral Density (RMS=%.1f \\mum)',1000*P2_int(end)),'FontSize',FontSize);
else
    title('Vertical Power Spectral Density','FontSize',FontSize);
end
axis tight
grid on


if ~JPegFlag
    if SquareRootFlag
        subplot(2,2,3);
        if HoldFlag; hold on; end
        loglog(ff(end:-1:1), 1000*P1_int,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor92(50,1,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan1Label, ' [\mum]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('\\surd( Cumulative \\intPSD)'),'FontSize',FontSize);
        else
            title(sprintf('\\surd( Cumulative \\intPSD) (RMS=%.1f \\mum)',1000*P1_int(end)),'FontSize',FontSize);
        end
        grid on;
        axis tight

        subplot(2,2,4);
        if HoldFlag; hold on; end
        loglog(ff(end:-1:1), 1000*P2_int,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor92(50,2,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan2Label, ' [\mum]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('\\surd( Cumulative \\intPSD)'),'FontSize',FontSize);
        else
            title(sprintf('\\surd( Cumulative \\intPSD) (RMS=%.1f \\mum)',1000*P2_int(end)),'FontSize',FontSize);
        end
        grid on;
        axis tight
    else
        subplot(2,2,3);
        if HoldFlag; hold on; end
        %loglog(ff(end:-1:1), 1000*1000*(P1_int).^2,LineColor);
        semilogx(ff(end:-1:1), 1000*1000*(P1_int).^2,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor92(50,1,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan1Label, ' [\mum^2]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('Cumulative \\intPSD'),'FontSize',FontSize);
        else
            title(sprintf('Cumulative \\intPSD (RMS=%.1f \\mum)',1000*P1_int(end)),'FontSize',FontSize);
        end
        grid on;
        a = axis;
        axis tight
        %yaxis([a(3) a(4)]);

        subplot(2,2,4);
        if HoldFlag; hold on; end
        %loglog(ff(end:-1:1), 1000*1000*P2_int.^2,LineColor);
        semilogx(ff(end:-1:1), 1000*1000*P2_int.^2,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor92(50,2,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan2Label, ' [\mum^2]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('Cumulative \\intPSD'),'FontSize',FontSize);
        else
            title(sprintf('Cumulative \\intPSD (RMS=%.1f \\mum)',1000*P2_int(end)),'FontSize',FontSize);
        end
        grid on;
        a = axis;
        axis tight
        %yaxis([a(3) a(4)]);
    end
end


%orient landscape
if ~HoldFlag
    h = addlabel(1,0,DateStr1);
end

if JPegFlag
    % For jpeg
    set(h,'FontSize',FontSize-2);
    set(gcf,'PaperPosition',PaperPosition);
    eval(['print ',JPegDirectory,'psd1 -djpeg']);
else
    if ~HoldFlag
        addlabel(0,0,DirStr1);
    end
end
set(h1,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


if exist('d1') == 1
    t = (0:length(d1)-1)*T/length(d1);
    figure(h3);
    subplot(2,1,1);
    if HoldFlag; hold on; end
    plot(t, 1000*d1, LineColor);
    if HoldFlag; hold off; end
    set(gca,'FontSize',FontSize);
    xlabel('Time [Seconds]','FontSize',FontSize);
    ylabel([Chan1Label, ' [\mum]'],'FontSize',FontSize);
    if HoldFlag
        title(sprintf('Time Domain Data for %s', Chan1Label),'FontSize',FontSize);
    else
        title(sprintf('Time Domain Data for %s (RMS=%.1f \\mum)', Chan1Label, 1000*P1_int(end)),'FontSize',FontSize);
    end
    axis tight
    grid on

    subplot(2,1,2);
    if HoldFlag; hold on; end
    plot(t, 1000*d2, LineColor);
    if HoldFlag; hold off; end
    set(gca,'FontSize',FontSize);
    xlabel('Time [Seconds]','FontSize',FontSize);
    ylabel([Chan2Label, ' [\mum]'],'FontSize',FontSize);
    if HoldFlag
        title(sprintf('Time Domain Data for %s', Chan1Label),'FontSize',FontSize);
    else
        title(sprintf('Time Domain Data for %s (RMS=%.1f \\mum)', Chan2Label, 1000*P2_int(end)),'FontSize',FontSize);
    end
    axis tight
    grid on

    %    orient landscape
    if ~HoldFlag
        h = addlabel(1,0,DateStr1);
    end

    if JPegFlag
        % For jpeg
        set(h,'FontSize',FontSize-2);
        set(gcf,'PaperPosition',PaperPosition);
        eval(['print ',JPegDirectory,'time1 -djpeg']);
    else
        if ~HoldFlag
            addlabel(0,0,DirStr1);
        end
    end
    set(h3,'units','normal','position',[.5+Buffer .05+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


    figure(h4);
    subplot(2,1,1);
    if HoldFlag; hold on; end
    plot(t, 1000*d3, LineColor);
    if HoldFlag; hold off; end
    set(gca,'FontSize',FontSize);
    xlabel('Time [Seconds]','FontSize',FontSize);
    ylabel([Chan3Label, ' [\mum]'],'FontSize',FontSize);
    if HoldFlag
        title(sprintf('Time Domain Data for %s', Chan1Label),'FontSize',FontSize);
    else
        title(sprintf('Time Domain Data for %s (RMS=%.1f \\mum)', Chan3Label, 1000*P3_int(end)),'FontSize',FontSize);
    end
    axis tight
    grid on

    subplot(2,1,2);
    if HoldFlag; hold on; end
    plot(t, 1000*d4, LineColor);
    if HoldFlag; hold off; end
    set(gca,'FontSize',FontSize);
    xlabel('Time [Seconds]','FontSize',FontSize);
    ylabel([Chan4Label, ' [\mum]'],'FontSize',FontSize);
    if HoldFlag
        title(sprintf('Time Domain Data for %s', Chan1Label),'FontSize',FontSize);
    else
        title(sprintf('Time Domain Data for %s (RMS=%.1f \\mum)', Chan4Label, 1000*P4_int(end)),'FontSize',FontSize);
    end
    axis tight
    grid on

    % orient landscape
    if ~HoldFlag
        h = addlabel(1,0,DateStr1);
    end

    if JPegFlag
        % For jpeg
        set(h,'FontSize',FontSize-2);
        set(gcf,'PaperPosition',PaperPosition);
        eval(['print ',JPegDirectory,'time2 -djpeg']);
    else
        if ~HoldFlag
            addlabel(0,0,DirStr1);
        end
    end
    set(h4,'units','normal','position',[.0+Buffer .05+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

    std(d1)
    std(d2)
    std(d3)
    std(d4)
end



figure(h2);
if JPegFlag
    subplot(2,1,1);
else
    subplot(2,2,1);
end
if HoldFlag; hold on; end
loglog(ff, 1000*1000*T*P3*Uwindow,LineColor);
if HoldFlag; hold off; end
if NoiseFloorFlag
    hold on;
    floor95(50,1,0,SquareRootFlag);
    hold off
end
set(gca,'FontSize',FontSize);
xlabel('Frequency [Hz]','FontSize',FontSize);
ylabel([Chan3Label, ' [\mum{^2}/Hz]'],'FontSize',FontSize);
axis tight
grid on

if JPegFlag
    title(sprintf('Horizontal Power Spectral Density (RMS=%.1f \\mum)',1000*P3_int(end)),'FontSize',FontSize);
    subplot(2,1,2);
else
    title('Horizontal Power Spectral Density','FontSize',FontSize);
    subplot(2,2,2);
end
if HoldFlag; hold on; end
loglog(ff, 1000*1000*T*P4*Uwindow,LineColor);
if HoldFlag; hold off; end
if NoiseFloorFlag
    hold on;
    floor95(50,2,0,SquareRootFlag);
    hold off
end
set(gca,'FontSize',FontSize);
xlabel('Frequency [Hz]','FontSize',FontSize);
ylabel([Chan4Label, ' [\mum{^2}/Hz]'],'FontSize',FontSize);
if JPegFlag
    title(sprintf('Vertical Power Spectral Density (RMS=%.1f \\mum)',1000*P4_int(end)),'FontSize',FontSize);
else
    title('Vertical Power Spectral Density','FontSize',FontSize);
end
axis tight
grid on

if ~JPegFlag
    if SquareRootFlag
        subplot(2,2,3);
        if HoldFlag; hold on; end
        loglog(ff(end:-1:1), 1000*P3_int,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor95(50,1,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan3Label,' [\mum]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('\\surd( Cumulative \\intPSD)'),'FontSize',FontSize);
        else
            title(sprintf('\\surd( Cumulative \\intPSD) (RMS=%.1f \\mum)',1000*P3_int(end)),'FontSize',FontSize);
        end
        grid on;
        axis tight

        subplot(2,2,4);
        if HoldFlag; hold on; end
        loglog(ff(end:-1:1), 1000*P4_int,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor95(50,2,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan4Label, ' [\mum]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('\\surd( Cumulative \\intPSD)'),'FontSize',FontSize);
        else
            title(sprintf('\\surd( Cumulative \\intPSD) (RMS=%.1f \\mum)',1000*P4_int(end)),'FontSize',FontSize);
        end
        grid on;
        axis tight
    else
        subplot(2,2,3);
        if HoldFlag; hold on; end
        % loglog(ff(end:-1:1), 1000*1000*P3_int.^2,LineColor);
        semilogx(ff(end:-1:1), 1000*1000*P3_int.^2,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor95(50,1,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan3Label, ' [\mum^2]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('Cumulative \\intPSD'),'FontSize',FontSize);
        else
            title(sprintf('Cumulative \\intPSD (RMS=%.1f \\mum)',1000*P3_int(end)),'FontSize',FontSize);
        end
        grid on;
        a = axis;
        axis tight
        yaxis([a(3) a(4)]);

        subplot(2,2,4);
        if HoldFlag; hold on; end
        %%loglog(ff(end:-1:1), 1000*1000*P4_int.^2,LineColor);
        semilogx(ff(end:-1:1), 1000*1000*P4_int.^2,LineColor);
        if HoldFlag; hold off; end
        if NoiseFloorFlag
            hold on;
            floor95(50,2,1,SquareRootFlag);
            hold off
        end
        set(gca,'FontSize',FontSize);
        xlabel('Frequency [Hz]','FontSize',FontSize);
        ylabel([Chan4Label, ' [\mum^2]'],'FontSize',FontSize);
        if HoldFlag
            title(sprintf('Cumulative \\intPSD'),'FontSize',FontSize);
        else
            title(sprintf('Cumulative \\intPSD (RMS=%.1f \\mum)',1000*P4_int(end)),'FontSize',FontSize);
        end
        grid on;
        a = axis;
        axis tight
        yaxis([a(3) a(4)]);
    end
end

%orient landscape
if ~HoldFlag
    h = addlabel(1,0,DateStr1);
end

if JPegFlag
    % For jpeg
    set(h,'FontSize',FontSize-2);
    set(gcf,'PaperPosition',PaperPosition);
    eval(['print ',JPegDirectory,'psd2 -djpeg']);
else
    if ~HoldFlag
        addlabel(0,0,DirStr1);
    end
end
set(h2,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


