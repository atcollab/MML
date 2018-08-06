function hfigure = plotepbitest3(FN, Options)

if nargin < 1 || isempty(FN)
    [PlotFile, DirectoryPath] = uigetfile({'*.mat','MAT-files (*.mat)'},'Pick an EPBI file', 'MultiSelect', 'off');
    if PlotFile == 0
        return
    end
    FN = [DirectoryPath, PlotFile];
end
if nargin < 2
    Options = '';
end

load(FN);

LineType = '.-';


%TSFlag = 3;  % TimeStamps and waveforms
%TSFlag = 2;  % TimeStamps
%TSFlag = 1;  % Corrected Matlab time
%TSFlag = 0;  % Matlab time
TSFlag = 1;

%dT = t1-t0;
%t = t + dT;


% New figure
hfig = figure;
clf reset
subfig(1, 1, 1, hfig);

if strcmpi(Options, 'html')
    %p = get(hfig, 'Position');
    %set(hfig, 'Position', FigurePosition);
    set(hfig, 'InvertHardcopy', 'Off');
end


% Time offset
% iRelay = min([find(Data(NTC+1,:) == 1); find(Data(NTC+2,:) == 1)]);
% if isempty(iRelay);
%     Toffset = 0;
% else
%     % Find time of beam dump
%     y1 = Data(NTC+2+3,iRelay-300:iRelay+300)-Data(NTC+2+3,1);
%     plot(y1);
% end

% Find BPM to TC offset
% Force all time difference relative to TC1, TimeStamp(1,1)
T_Ref = TimeStamp(1,1);


% Estimate the delay in the EPBI channels
t1_now = t1/24/60/60 + 719529;  %datenum('1-Jan-1970');
T_EPBI  = 24*60*60*(TimeStamp(1:18,1)        - t1_now) + .08;
T_Relay = 24*60*60*(TimeStamp(19:20,1)       - t1_now) + .08;
T_BPM   = 0 * 24*60*60*(TimeStamp(NTC+2+(3:4),1) - t1_now);


tsBPM1 = (TimeStamp(NTC+2+3,:)-T_Ref)*24*60*60;
tsBPM2 = (TimeStamp(NTC+2+4,:)-T_Ref)*24*60*60;


dt = diff(tsBPM1);
tsBPM1i = find(dt > 0) + 1;

dt = diff(tsBPM2);
tsBPM2i = find(dt > 0) + 1;


h = subplot(4,1,1);
if TSFlag == 2 || TSFlag == 3
    t1 = (TimeStamp(NTC+2+5,:)-T_Ref)*24*60*60;
    plot(t1, Data(NTC+2+5,:), LineType);
elseif TSFlag == 1
%     tsVCM = (TimeStamp(NTC+2+5,:)-T_Ref)*24*60*60;
%     dt = diff(tsVCM);
%     tsVCMi = find(dt > 0) + 1;
%     t1 = t - t(tsBPM1i(1)) + tsBPM1(tsBPM1i(1)) + .1;
%     %t1 = (TimeStamp(NTC+2+5,:)-T_Ref)*24*60*60;
%     plot(t1, Data(NTC+2+5,:), LineType);  % -Data(NTC+2+5,1)

    plot(t, Data(NTC+2+5,:), LineType);  % -Data(NTC+2+5,1)
else
    plot(t, Data(NTC+2+5,:), LineType);  % -Data(NTC+2+5,1)
end
ylabel(sprintf('VCM(%d,%d) AM [Amps]', VCMDev), 'Interpret','None');
title(sprintf('VCM(%d,%d) Step of %.2f Amps', VCMDev, VCMdelta), 'Interpret','None');  % VCMsp
grid on;
axis tight;
a1 = axis;


% TC = Data((1:NTC),:);
% for i = 1:size(TC,1)
%     TC(i,:) = TC(i,:) -TC(i,1);
% end

h(2) = subplot(4,1,2);
if TSFlag == 2 || TSFlag == 3
    plot(tsBPM1, Data(NTC+2+3,:)-Data(NTC+2+3,1), LineType', 'Color','b');
    hold on
    plot(tsBPM2, Data(NTC+2+4,:)-Data(NTC+2+4,1), LineType', 'Color','g');
    hold off
elseif TSFlag == 1
%     t1 = t - t(tsBPM1i(1)) + tsBPM1(tsBPM1i(1)) + .1;
%     plot(t1, Data(NTC+2+3,:)-Data(NTC+2+3,1), LineType', 'Color','b');
%     hold on
%     t2 = t - t(tsBPM2i(1)) + tsBPM2(tsBPM2i(1)) + .1;
%     plot(t2, Data(NTC+2+4,:)-Data(NTC+2+4,1), LineType', 'Color','g');
%     hold off
    
    t1 = t - T_BPM(1);
    plot(t1, Data(NTC+2+3,:)-Data(NTC+2+3,1), LineType', 'Color','b');
    hold on
    t2 = t - T_BPM(2);
    plot(t2, Data(NTC+2+4,:)-Data(NTC+2+4,1), LineType', 'Color','g');
    hold off
else
    plot(t, Data(NTC+2+3,:)-Data(NTC+2+3,1), LineType', 'Color','b');
    hold on
    plot(t, Data(NTC+2+4,:)-Data(NTC+2+4,1), LineType', 'Color','g');
    hold off
end
title(sprintf('Vertical Orbit Data'), 'Interpret','None');
ylabel('Vertical Orbit [mm]');
grid on;
axis tight;
a2 = axis;


h(3) = subplot(4,1,3);
%plot(t, Data((1:NTC),:), LineType);
if UpperFlag
    if TSFlag == 3
        tsTC = .02*(0:size(TCUP,2)-1);
        for i = 1:size(TCUP,1)
            plot(tsTC, TCUP(i,:), LineType);
            hold on
        end
    elseif TSFlag == 2
        for i = 1:9
            tsTC = (TimeStamp(i,:)-T_Ref)*24*60*60;
            plot(tsTC, Data(i,:), LineType, 'Color', nxtcolor);
            hold on
        end
        hold off
    elseif TSFlag == 1
        for i = 1:9
            plot(t-T_EPBI(i), Data(i,:), LineType, 'Color', nxtcolor);
            hold on
        end
        hold off
    else
        plot(t, Data((1:9),:), LineType);
    end
else
    if TSFlag == 3
        tsTC = .02*(0:size(TCDN,2)-1);
        for i = 1:size(TCDN,1)
            plot(tsTC, TCDN(i,:), LineType);
            hold on
        end
    elseif TSFlag == 2
        for i = 10:18
            tsTC = (TimeStamp(i,:)-T_Ref)*24*60*60;
            plot(tsTC, Data(i,:), LineType, 'Color', nxtcolor);
            hold on
        end
        hold off
    elseif TSFlag == 1
        for i = 10:18
            plot(t-T_EPBI(i), Data(i,:), LineType, 'Color', nxtcolor);
            hold on
        end
        hold off
    else
        plot(t, Data((10:18),:), LineType);
    end
end
ylabel('TC [C]');
title(sprintf('EPBI Thermocouples in Sector %d', Sector), 'Interpret','None');
grid on;
axis tight;
a3 = axis;


h(4) = subplot(4,1,4);
if TSFlag == 2 || TSFlag == 3
    tsTC = (TimeStamp(NTC+1,:)-T_Ref)*24*60*60;
    plot(tsTC, Data(NTC+1,:), LineType, 'Color','b');
    hold on
    tsTC = (TimeStamp(NTC+2,:)-T_Ref)*24*60*60;
    plot(tsTC, Data(NTC+2,:), LineType, 'Color','g');
    hold off
elseif TSFlag == 1
    plot(t-T_Relay(1), Data(NTC+1,:), LineType, 'Color','b');
    hold on
    plot(t-T_Relay(2), Data(NTC+2,:), LineType, 'Color','g');
    hold off
else
    plot(t, Data(NTC+1:NTC+2,:), LineType);
end
ylabel('Relay');
xlabel(sprintf('Time relative to %s [seconds]', datestr(DataTime(1,1))));
title(sprintf('Sector %d Relays', Sector), 'Interpret','None');
legend('Unit A','Unit B', 'Location','Best');
grid on
axis([0 max(t) -.1 1.1]);
axis tight;
a4 = axis;


xmin = min([a1(1) a2(1) a3(1) a4(1)]);
if xmin > 0
    xmin = 0;
end

linkaxes(h, 'x');
xaxis([xmin max(t)]);

if UpperFlag
    addlabel(.5, 1, sprintf('Sector %d Upper EPBI Test #3', Sector), 14);
else
    addlabel(.5, 1, sprintf('Sector %d Lower EPBI Test #3', Sector), 14);
end

%addlabel(1, 0, datestr(DataTime(1,1)), 10);

orient tall


if nargout > 0
    hfigure = hfig;
end