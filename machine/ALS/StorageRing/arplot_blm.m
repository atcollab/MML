function arplot_blm(monthStr, days, year1, month2Str, days2, year2)
% arplot_ig(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots Beam Current, Lifetime, and all beam loss monitor data.
%
% Example:  arplot_blm('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1/24 in 1998



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

LeftGraphColor = 'b';
RightGraphColor = 'r';

t=[];
dcct=[];
lifetime=[];
lifetimeAM=[];

SR01BL1 = []; SR01BL2 = [];
SR02BL1 = []; SR02BL2 = [];
SR03BL1 = []; SR03BL2 = [];
SR04BL1 = []; SR04BL2 = [];
SR05BL1 = []; SR05BL2 = [];
SR06BL1 = []; SR06BL2 = [];
SR07BL1 = []; SR07BL2 = [];
SR08BL1 = []; SR08BL2 = [];
SR09BL1 = []; SR09BL2 = [];
SR10BL1 = []; SR10BL2 = [];
SR11BL1 = []; SR11BL2 = [];
SR12BL1 = []; SR12BL2 = [];


if isempty(days2)
    if length(days) == [1]
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [''];
        titleStr = [StartDayStr];
    else
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
        titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
    end
else
    month  = mon2num(monthStr);
    month2 = mon2num(month2Str);
    NumDays = length(days) + length(days2);
    StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
    EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];

    titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
end


StartDay = days(1);
EndDay = days(length(days));
N=0;

for day = days
    day;
    %t0=clock;
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    FileName = sprintf('%2s%02d%02d', year1str, month, day);
    arread(FileName);
    %readtime = etime(clock, t0)

%    [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
    [y1, idcct] = arselect('cmm:beam_current');
    dcct = [dcct y1];
    [y1, ilifetimeAM] = arselect('Topoff_lifetime_AM');
    lifetimeAM = [lifetimeAM  y1];

    [y1, i] = arselect('SR01S___BLM1___AM00DIAG');
    SR01BL1 = [SR01BL1 y1];
    [y1, i] = arselect('SR01S___BLM2___AM01DIAG');
    SR01BL2 = [SR01BL2 y1];
    [y1, i] = arselect('SR02S___BLM1___AM02DIAG');
    SR02BL1 = [SR02BL1 y1];
    [y1, i] = arselect('SR02S___BLM2___AM03DIAG');
    SR02BL2 = [SR02BL2 y1];
    [y1, i] = arselect('SR03S___BLM1___AM04DIAG');
    SR03BL1 = [SR03BL1 y1];
    [y1, i] = arselect('SR03S___BLM2___AM05DIAG');
    SR03BL2 = [SR03BL2 y1];

    [y1, i] = arselect('SR04S___BLM1___AM00DIAG');
    SR04BL1 = [SR04BL1 y1];
    [y1, i] = arselect('SR04S___BLM2___AM01DIAG');
    SR04BL2 = [SR04BL2 y1];
    [y1, i] = arselect('SR05S___BLM1___AM02DIAG');
    SR05BL1 = [SR05BL1 y1];
    [y1, i] = arselect('SR05S___BLM2___AM03DIAG');
    SR05BL2 = [SR05BL2 y1];
    [y1, i] = arselect('SR06S___BLM1___AM04DIAG');
    SR06BL1 = [SR06BL1 y1];
    [y1, i] = arselect('SR06S___BLM2___AM05DIAG');
    SR06BL2 = [SR06BL2 y1];

    [y1, i] = arselect('SR07S___BLM1___AM00DIAG');
    SR07BL1 = [SR07BL1 y1];
    [y1, i] = arselect('SR07S___BLM2___AM01DIAG');
    SR07BL2 = [SR07BL2 y1];
    [y1, i] = arselect('SR08S___BLM1___AM02DIAG');
    SR08BL1 = [SR08BL1 y1];
    [y1, i] = arselect('SR08S___BLM2___AM03DIAG');
    SR08BL2 = [SR08BL2 y1];
    [y1, i] = arselect('SR09S___BLM1___AM04DIAG');
    SR09BL1 = [SR09BL1 y1];
    [y1, i] = arselect('SR09S___BLM2___AM05DIAG');
    SR09BL2 = [SR09BL2 y1];

    [y1, i] = arselect('SR10S___BLM1___AM00DIAG');
    SR10BL1 = [SR10BL1 y1];
    [y1, i] = arselect('SR10S___BLM2___AM01DIAG');
    SR10BL2 = [SR10BL2 y1];
    [y1, i] = arselect('SR11S___BLM1___AM02DIAG');
    SR11BL1 = [SR11BL1 y1];
    [y1, i] = arselect('SR11S___BLM2___AM03DIAG');
    SR11BL2 = [SR11BL2 y1];
    [y1, i] = arselect('SR12S___BLM1___AM04DIAG');
    SR12BL1 = [SR12BL1 y1];
    [y1, i] = arselect('SR12S___BLM2___AM05DIAG');
    SR12BL2 = [SR12BL2 y1];

    N = N + length(ARt);

    t    = [t  ARt+(day-StartDay)*24*60*60];

    disp(' ');
end


if ~isempty(days2)

    StartDay = days2(1);
    EndDay = days2(length(days2));

    for day = days2
        day;
        %t0=clock;
        year2str = num2str(year2);
        if year2 < 2000
            year2str = year2str(3:4);
            FileName = sprintf('%2s%02d%02d', year2str, month, day);
        else
            FileName = sprintf('%4s%02d%02d', year2str, month, day);
        end
        FileName = sprintf('%2s%02d%02d', year2str, month2, day);
        arread(FileName);
        %readtime = etime(clock, t0)

%    [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
    [y1, idcct] = arselect('cmm:beam_current');
    dcct = [dcct y1];
    [y1, ilifetimeAM] = arselect('Topoff_lifetime_AM');
    lifetimeAM = [lifetimeAM  y1];

    [y1, i] = arselect('SR01S___BLM1___AM00DIAG');
    SR01BL1 = [SR01BL1 y1];
    [y1, i] = arselect('SR01S___BLM2___AM01DIAG');
    SR01BL2 = [SR01BL2 y1];
    [y1, i] = arselect('SR02S___BLM1___AM02DIAG');
    SR02BL1 = [SR02BL1 y1];
    [y1, i] = arselect('SR02S___BLM2___AM03DIAG');
    SR02BL2 = [SR02BL2 y1];
    [y1, i] = arselect('SR03S___BLM1___AM04DIAG');
    SR03BL1 = [SR03BL1 y1];
    [y1, i] = arselect('SR03S___BLM2___AM05DIAG');
    SR03BL2 = [SR03BL2 y1];

    [y1, i] = arselect('SR04S___BLM1___AM00DIAG');
    SR04BL1 = [SR04BL1 y1];
    [y1, i] = arselect('SR04S___BLM2___AM01DIAG');
    SR04BL2 = [SR04BL2 y1];
    [y1, i] = arselect('SR05S___BLM1___AM02DIAG');
    SR05BL1 = [SR05BL1 y1];
    [y1, i] = arselect('SR05S___BLM2___AM03DIAG');
    SR05BL2 = [SR05BL2 y1];
    [y1, i] = arselect('SR06S___BLM1___AM04DIAG');
    SR06BL1 = [SR06BL1 y1];
    [y1, i] = arselect('SR06S___BLM2___AM05DIAG');
    SR06BL2 = [SR06BL2 y1];

    [y1, i] = arselect('SR07S___BLM1___AM00DIAG');
    SR07BL1 = [SR07BL1 y1];
    [y1, i] = arselect('SR07S___BLM2___AM01DIAG');
    SR07BL2 = [SR07BL2 y1];
    [y1, i] = arselect('SR08S___BLM1___AM02DIAG');
    SR08BL1 = [SR08BL1 y1];
    [y1, i] = arselect('SR08S___BLM2___AM03DIAG');
    SR08BL2 = [SR08BL2 y1];
    [y1, i] = arselect('SR09S___BLM1___AM04DIAG');
    SR09BL1 = [SR09BL1 y1];
    [y1, i] = arselect('SR09S___BLM2___AM05DIAG');
    SR09BL2 = [SR09BL2 y1];

    [y1, i] = arselect('SR10S___BLM1___AM00DIAG');
    SR10BL1 = [SR10BL1 y1];
    [y1, i] = arselect('SR10S___BLM2___AM01DIAG');
    SR10BL2 = [SR10BL2 y1];
    [y1, i] = arselect('SR11S___BLM1___AM02DIAG');
    SR11BL1 = [SR11BL1 y1];
    [y1, i] = arselect('SR11S___BLM2___AM03DIAG');
    SR11BL2 = [SR11BL2 y1];
    [y1, i] = arselect('SR12S___BLM1___AM04DIAG');
    SR12BL1 = [SR12BL1 y1];
    [y1, i] = arselect('SR12S___BLM2___AM05DIAG');
    SR12BL2 = [SR12BL2 y1];

        N = N + length(ARt);


        t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];

        disp(' ');
    end
end


%dcct conditioning and lifetime calculation
% dcct = 100*dcct;
i = find(dcct < 1.);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime = -diff(t/60/60)./(dlogdcct);
i = find(lifetime < 0);
lifetime(i) = NaN;

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
xmin = min(t);

%plot data
%first page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
[ax, h1, h2] = plotyy(t, dcct, t, lifetimeAM);
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'Lifetime [hours]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500]);
axis([0 xmax 0 550]);
axes(ax(2));
set(ax(2),'YTick',[0:3:15]);
axis([0 xmax 0 15]);
grid on;
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
h1=plot(t, SR01BL1, t, SR01BL2, t, SR02BL1, t, SR02BL2, t, SR03BL1, t, SR03BL2,'--');
for h = 1:length(h1)
    set(h1(h),'LineWidth',3)
end
grid on;
ylabel('BLM rate [Hz]');
xaxis([xmin xmax]);
clear name;
legend('1BL1','1BL2','2BL1','2BL2','3BL1','3BL2',3);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
h1=plot(t, SR04BL1, t, SR04BL2, t, SR05BL1, t, SR05BL2, t, SR06BL1, t, SR06BL2,'--');
for h = 1:length(h1)
    set(h1(h),'LineWidth',3)
end
grid on;
ylabel('BLM rate [Hz]');
xaxis([xmin xmax]);
clear name;
legend('4BL1','4BL2','5BL1','5BL2','6BL1','6BL2',3);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
orient landscape

% second page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
[ax, h1, h2] = plotyy(t, dcct, t, lifetimeAM);
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'Lifetime [hours]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500]);
axis([0 xmax 0 550]);
axes(ax(2));
set(ax(2),'YTick',[0:3:15]);
axis([0 xmax 0 15]);
grid on;
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
h1=plot(t, SR07BL1, t, SR07BL2, t, SR08BL1, t, SR08BL2, t, SR09BL1, t, SR09BL2,'--');
for h = 1:length(h1)
    set(h1(h),'LineWidth',3)
end
grid on;
ylabel('BLM rate [Hz]');
xaxis([xmin xmax]);
clear name;
legend('7BL1','7BL2','8BL1','8BL2','9BL1','9BL2',3);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
h1=plot(t, SR10BL1, t, SR10BL2, t, SR11BL1, t, SR11BL2, t, SR12BL1, t, SR12BL2,'--');
for h = 1:length(h1)
    set(h1(h),'LineWidth',3)
end
grid on;
ylabel('BLM rate [Hz]');
xaxis([xmin xmax]);
clear name;
legend('10BL1','10BL2','11BL1','11BL2','12BL1','12BL2',3);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
orient landscape



%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
if DayFlag
    if size(Days,2) > 1
        Days = Days'; % Make a column vector
    end

    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');

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
        set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));
    end
end
