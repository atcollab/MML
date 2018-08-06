function arplot_SR06QF2(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_SR06QF2 - Plots SR06_QF2 coil temperature data from the ALS archiver
%  arplot_SR06QF2(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLE
%  arplot_SR06QF2('September',1:19,2008);
%


uiwait(warndlg('WARNING: The TC mappings given in the legend are only valid BEFORE 14:00 on 11-16-09!','arplot_SR06QF2 WARNING'));

uiwait(warndlg('NOTE: The SR06 QF2 coils were acid flushed on 11-30-09...','arplot_SR06QFTCs NOTICE'));

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
lcw = [];
SR06TCWAGOAM03 = [];
SR06TCWAGOAM04 = [];
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
    lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
    SR06TCWAGOAM03 = [SR06TCWAGOAM03 arselect('SR06W___TCWAGO_AM03')];
    SR06TCWAGOAM04 = [SR06TCWAGOAM04 arselect('SR06W___TCWAGO_AM04')];
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
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
        SR06TCWAGOAM03 = [SR06TCWAGOAM03 arselect('SR06W___TCWAGO_AM03')];
        SR06TCWAGOAM04 = [SR06TCWAGOAM04 arselect('SR06W___TCWAGO_AM04')];
        dcct = [dcct arselect('cmm:beam_current')];
    end
end

% Convert to Farenheit
SR06TCWAGOAM03 = (SR06TCWAGOAM03*9/5) + 32;
SR06TCWAGOAM04 = (SR06TCWAGOAM04*9/5) + 32;


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
plot(t, [SR06TCWAGOAM03; SR06TCWAGOAM04]);
xaxis([0 MaxTime]);
yaxis([20 160]);
grid on;
title(['SR06C QF2 Coil Temps: ',titleStr]);
text(1,1,'WARNING: The TC mappings given in the legend are only valid BEFORE 14:00 on 11-16-09!');
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Temp [DegF]');
h=legend('SR06C QF2 Upper Coil', 'SR06C QF2 Lower Coil');

subplot(3,1,2)
plot(t, lcw);
xaxis([0 MaxTime]);
yaxis([21 27])
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('LCW Temp [degF]');

subplot(3,1,3)
plot(t, dcct);
xaxis([0 MaxTime]);
yaxis([0 505])
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('DCCT [mA]');

yaxesposition(1.15);

orient tall

% if isunix
%     cd('/home/als/physdata/matlab/srdata/LCW')
% else
%     cd('\\Als-filer\physdata\matlab\srdata\LCW')
% end

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
