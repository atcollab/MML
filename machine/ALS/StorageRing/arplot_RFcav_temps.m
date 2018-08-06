function arplot_RFcav_flows(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_RFcav_flows - Plots QF1 and QF2 networked coil temperature data from the ALS archiver
%  arplot_SR06QFTCs(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLE
%  arplot_omegaTCs('September',1:19,2008);
%


% Inputs
if nargin < 2
    monthStr = 'August';
    days = 5;
end
if nargin < 3
    tmp = clock;
    year1 = tmp(1);
end
if nargin < 4
    monthStr2 = [];
end
if nargin < 5
    days2 = [];
end
if nargin < 6
    year2 = year1;
end


BooleanFlag = 0;

arglobal

LeftGraphColor = 'b';
RightGraphColor = 'r';

if isempty(days2)
    if length(days) == [1]
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [''];
        titleStr = [StartDayStr];
        DirectoryDate = sprintf('%d-%02d-%02d', year1, month, days(1));
    else
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
        titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
        DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year1, month, days(end));
    end
else
    month  = mon2num(monthStr);
    month2 = mon2num(month2Str);
    NumDays = length(days) + length(days2);
    StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
    EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];
    titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
    DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year2, month2, days2(end));
end

StartDay = days(1);
EndDay = days(length(days));

t = [];
C1CAVFLW = [];
C1LCWFLW = [];
C1TUNFLW = [];
C1WINFLW = [];
C1HOMFLW = [];
C2CAVFLW = [];
C2LCWFLW = [];
C2TUNFLW = [];
C2WINFLW = [];
C2HOMFLW = [];
dcct = [];

% Month #1
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    arread(FileName, BooleanFlag);

    % time vector
    t = [t ARt+(day-StartDay)*24*60*60];
    C1CAVFLW = [C1CAVFLW arselect('SR03S___C1CAVF_AM03')];
    C1LCWFLW = [C1LCWFLW arselect('SR03S___C1LCWF_AM00')];
    C1TUNFLW = [C1TUNFLW arselect('SR03S___C1TUNF_AM02')];
    C1WINFLW = [C1WINFLW arselect('SR03S___C1WINF_AM01')];
    C1HOMFLW = [C1HOMFLW arselect('SR03S___C1HOMF_AM00')];
    C2CAVFLW = [C2CAVFLW arselect('SR03S___C2CAVF_AM03')];
    C2LCWFLW = [C2LCWFLW arselect('SR03S___C2LCWF_AM00')];
    C2TUNFLW = [C2TUNFLW arselect('SR03S___C2TUNF_AM02')];
    C2WINFLW = [C2WINFLW arselect('SR03S___C2WINF_AM01')];
    C2HOMFLW = [C2HOMFLW arselect('SR03S___C2HOMF_AM00')];
    dcct = [dcct arselect('cmm:beam_current')];
end


% Month #2
if ~isempty(days2)

    StartDay = days2(1);
    EndDay = days2(length(days2));

    for day = days2
        year2str = num2str(year2);
        if year2 < 2000
            year2str = year2str(3:4);
            FileName = sprintf('%2s%02d%02d', year2str, month2, day);
        else
            FileName = sprintf('%4s%02d%02d', year2str, month2, day);
        end
        arread(FileName, BooleanFlag);

        % time vector
        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        C1CAVFLW = [C1CAVFLW arselect('SR03S___C1CAVF_AM03')];
        C1LCWFLW = [C1LCWFLW arselect('SR03S___C1LCWF_AM00')];
        C1TUNFLW = [C1TUNFLW arselect('SR03S___C1TUNF_AM02')];
        C1WINFLW = [C1WINFLW arselect('SR03S___C1WINF_AM01')];
        C1HOMFLW = [C1HOMFLW arselect('SR03S___C1HOMF_AM00')];
        C2CAVFLW = [C2CAVFLW arselect('SR03S___C2CAVF_AM03')];
        C2LCWFLW = [C2LCWFLW arselect('SR03S___C2LCWF_AM00')];
        C2TUNFLW = [C2TUNFLW arselect('SR03S___C2TUNF_AM02')];
        C2WINFLW = [C2WINFLW arselect('SR03S___C2WINF_AM01')];
        C2HOMFLW = [C2HOMFLW arselect('SR03S___C2HOMF_AM00')];
        dcct = [dcct arselect('cmm:beam_current')];
    end
end


% Hours or days for the x-axis?
if t(end)/60/60/24 > 3
    t = t/60/60/24;
    xlabelstring = ['Date since ', StartDayStr, ' [Days]'];
    DayFlag = 1;
else
    t = t/60/60;
    xlabelstring = ['Time since ', StartDayStr, ' [Hours]'];
    DayFlag = 0;
end
Days = [days days2];
MaxTime = max(t);


%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%


h = figure;
subfig(1,1,1,h);
clf reset

%h = subplot(2,1,1);
subplot(3,1,1)
plot(t, C1CAVFLW, t, C2CAVFLW);
xaxis([0 MaxTime]);
yaxis([90 110]);
grid on;
title(['SR RF Flows: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Cavity Flows [GPM]');
h=legend('C1 Cavity Flow','C2 Cavity Flow');

subplot(3,1,2)
plot(t, C1LCWFLW, t ,C2LCWFLW);
xaxis([0 MaxTime]);
yaxis([10 20])
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('LCW Flows [GPM]');
h=legend('C1 LCW Flow','C2 LCW Flow');

subplot(3,1,3)
plot(t, C1TUNFLW, t, C1WINFLW, t, C1HOMFLW, t, C2TUNFLW, t, C2WINFLW, t, C2HOMFLW);
xaxis([0 MaxTime]);
yaxis([0 3])
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Other Flows [GPM]');
xlabel(xlabelstring);
h=legend('C1 Tuner Flow','C1 Window Flow','C1 HOM Flow','C2 Tuner Flow','C2 Window Flow','C2 HOM Flow');

yaxesposition(1.15);

orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
xaxis([0 max(t)]);

if DayFlag
    if size(Days,2) > 1
        Days = Days'; % Make a column vector
    end

    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
    %xaxis([0 MaxDay]);

    if length(Days) < MaxDay-1
        % Days were skipped
        set(gca,'XTickLabel',strvcat(num2str([0:MaxDay-1]'+Days(1)),' '));
    else
        % All days plotted
        set(gca,'XTickLabel',strvcat(num2str(Days),' '));
    end

    XTickLabelString = get(gca,'XTickLabel');
    if MaxDay < 20
        % ok
    elseif MaxDay < 40
        set(gca,'XTick',[0:2:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:2:end-1,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:end-1,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end-1,:));
    end
end
