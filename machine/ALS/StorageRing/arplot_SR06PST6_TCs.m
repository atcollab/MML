function arplot_SR06PST6_TCs(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_SR06PST6_TCS - Plots New (August 2010) Wago installation temps on
%SR06C___PST6
%  arplot_SR06PST_TCs(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLES
%  1. arplot_SR06PST_TCs('January',22:24,1998);
%     plots data from 1/22, 1/23, and 1/24 in 1998
%
%  2. arplot_SR06PST_TCs('January',28:31,1998,'February',1:4,1998);
%     plots data from the last 4 days in Jan. and the first 4 days in Feb.
%
%  See also arplot, arplot_sr_report, arplot_sbm

% Written by Greg Portmann & Tom Scarvie


LeftGraphColor = 'b';
RightGraphColor = 'r';
FFFlag = 1;
GapOpenFlag = 1;
UserBeamFlag = 1;


% Inputs
if nargin < 2
    error('ARPLOTS:  You need at least two input arguments.');
elseif nargin == 2
    tmp = clock;
    year1 = tmp(1);
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 3
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 4
    error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
elseif nargin == 5
    tmp = clock;
    year2 = tmp(1);
elseif nargin == 6
else
    error('ARPLOTS:  Inputs incorrect.');
end


arglobal

GapEnableNames = family2channel('ID','GapEnable');

ar_functions_time = 0;

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

tic;
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    arread(FileName, 1);

    ar_functions_time = ar_functions_time + toc;
    tic;
    if day==days(1)
        [dcct, idcct] = arselect('cmm:beam_current');
        [lcw, ilcw ] = arselect('SR03S___LCWTMP_AM00');

        % Wago temperature monitors
        [SR06C_TCWAGO_AM22, iSR06C_TCWAGO_AM22] = arselect('SR06C___TCWAGO_AM22');
        [SR06C_TCWAGO_AM23, iSR06C_TCWAGO_AM23] = arselect('SR06C___TCWAGO_AM23');
        
        % time vector
        t = [ARt+(day-StartDay)*24*60*60];

    else

        dcct = [dcct arselect('cmm:beam_current')];
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];

        % Wago temperature monitors
        SR06C_TCWAGO_AM22 = [SR06C_TCWAGO_AM22 arselect('SR06C___TCWAGO_AM22')];
        SR06C_TCWAGO_AM23 = [SR06C_TCWAGO_AM23 arselect('SR06C___TCWAGO_AM23')];

        % time vector
        t = [t  ARt+(day-StartDay)*24*60*60];

    end

    tmp = toc;
    ar_functions_time = ar_functions_time + tmp;
    fprintf('                One day of arselect = %g seconds\n',tmp);
    tic;
    
end


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
        arread(FileName, 1);


        dcct = [dcct arselect('cmm:beam_current')];
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];

        % Wago temperature monitors
        SR06C_TCWAGO_AM22 = [SR06C_TCWAGO_AM22 arselect('SR06C___TCWAGO_AM22')];
        SR06C_TCWAGO_AM23 = [SR06C_TCWAGO_AM23 arselect('SR06C___TCWAGO_AM23')];

        % time vector
%       t = [t  ARt+(day-StartDay)*24*60*60];
        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];

    end
    tmp = toc;
    ar_functions_time = ar_functions_time + tmp;
    fprintf('One day of arselect = %g s\n',tmp);
    tic;
end
fprintf('  %.1f seconds to arread and arselect data\n', ar_functions_time);


%%%%%%%%%%%%%%%%%%
% Condition Data %
%%%%%%%%%%%%%%%%%%

% Convert Wago temperature monitors to degF
SR06C_TCWAGO_AM22 = SR06C_TCWAGO_AM22*9/5+32;
SR06C_TCWAGO_AM23 = SR06C_TCWAGO_AM23*9/5+32;
        
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
xmax = max(t);

% change data to NaN for plotting if archiver has stalled for more than 12minutes
StalledArchFlag = [];
for loop = 1:size(t,2)-1
    StalledArchFlag(loop) = (t(loop+1)-t(loop)>0.2);
end
SANum = find(StalledArchFlag==1)+1;
dcct(SANum)=NaN;
SR06C_TCWAGO_AM22(SANum)=NaN;
SR06C_TCWAGO_AM23(SANum)=NaN;

filter_data_time = toc;
%fprintf('  %.1f seconds to filter data\n', filter_data_time);


%%%%%%%%%%%%%%%
% Plot figure %
%%%%%%%%%%%%%%%

% Wago Temperature Monitors
h = figure;
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(3,1,1)
plot(t, SR06C_TCWAGO_AM22, t, SR06C_TCWAGO_AM23);
grid on;
ylabel('SR06 PST6 Temps [degF]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([axisvals(3)-2 axisvals(4)+2]);
if DayFlag
  MaxDay = round(max(t));
  set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
%legend(sprintf('%s',getpvonline('SR06C___TCWAGO_AM24.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM25.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM26.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM27.DESC')));
legend('SR06 PST6 TC1 - SR06C___TCWAGO_AM22','SR06 PST6 TC2 - SR06C___TCWAGO_AM23');
title(['SR06 PST6 Temperatures: ', titleStr]);

subplot(3,1,2);
plot(t, lcw*9/5+32, 'b'); grid on;
ylabel({'LCW [degF]','(SR03 Sensor)'});
axis tight
axisvals = axis;
xaxis([0 xmax]);
yaxis([axisvals(3)-2 axisvals(4)+2]);

subplot(3,1,3)
plot(t, dcct);
grid on;
ylabel('Beam Current [mA]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([axisvals(3)-2 axisvals(4)+2]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(h, 'ArchiveDate', DirectoryDate);
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
