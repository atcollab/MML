function arplot_IG1TC(monthStr, days, year1, month2Str, days2, year2)
% arplot_IG1TC(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots Beam Current and Top-off aperture IG1 Thermocouple data.
%
% Example:  arplot_IG1tc('January',22:24, 1998);
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

global GLOBAL_SR_MODE_TITLE

if strcmp(GLOBAL_SR_MODE_TITLE, '1.9 GeV, Two Bunch')
    dcctplotmax = 60;
else
    dcctplotmax = 500;
end

arglobal


t=[];
dcct=[];
lcw=[];
IDgap4=[];
IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap10=[];
IDgap11=[];
IDgap12=[];

SR04TC1 = []; SR04TC2 = [];
SR05TC1 = []; SR05TC2 = [];
SR06TC1 = []; SR06TC2 = [];
SR07TC1 = []; SR07TC2 = [];
SR08TC1 = []; SR08TC2 = [];
SR09TC1 = []; SR09TC2 = [];
SR10TC1 = []; SR10TC2 = [];
SR11TC1 = []; SR11TC2 = [];
SR12TC1 = []; SR12TC2 = [];

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
    
    [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
    dcct = [dcct y1];
    [y1, ilcw] = arselect('SR03S___LCWTMP_AM00');
    lcw = [lcw y1];
    
    [y1,i]=arselect('SR05W___GDS1PS_AM00');
    [y2,i]=arselect('SR07U___GDS1PS_AM00');
    [y3,i]=arselect('SR08U___GDS1PS_AM00');
    [y4,i]=arselect('SR09U___GDS1PS_AM00');
    [y5,i]=arselect('SR12U___GDS1PS_AM00');
    IDgap5 =[IDgap5  y1];
    IDgap7 =[IDgap7  y2];
    IDgap8 =[IDgap8  y3];
    IDgap9 =[IDgap9  y4];
    IDgap12=[IDgap12 y5];
        
    [y1, i] = arselect('SR04S___TCUP9__AM');
    SR04TC1 = [SR04TC1 y1];
    [y1, i] = arselect('SR04W___TCWAGO_AM07');
    SR04TC2 = [SR04TC2 y1];
    [y1, i] = arselect('SR05W___TCUP9__AM');
    SR05TC1 = [SR05TC1 y1];
    [y1, i] = arselect('SR05W___TCWAGO_AM06');
    SR05TC2 = [SR05TC2 y1];
    [y1, i] = arselect('SR06S___TCUP9__AM');
    SR06TC1 = [SR06TC1 y1];
    [y1, i] = arselect('SR06W___TCWAGO_AM16');
    SR06TC2 = [SR06TC2 y1];
    [y1, i] = arselect('SR07S___TCUP9__AM');
    SR07TC1 = [SR07TC1 y1];
    [y1, i] = arselect('SR07W___TCWAGO_AM09');
    SR07TC2 = [SR07TC2 y1];
    [y1, i] = arselect('SR08S___TCUP9__AM');
    SR08TC1 = [SR08TC1 y1];
    [y1, i] = arselect('SR08W___TCWAGO_AM08');
    SR08TC2 = [SR08TC2 y1];
    [y1, i] = arselect('SR09S___TCUP9__AM');
    SR09TC1 = [SR09TC1 y1];
    [y1, i] = arselect('SR09W___TCWAGO_AM06');
    SR09TC2 = [SR09TC2 y1];
    [y1, i] = arselect('SR10S___TCUP9__AM');
    SR10TC1 = [SR10TC1 y1];
    [y1, i] = arselect('SR10W___TCWAGO_AM06');
    SR10TC2 = [SR10TC2 y1];
    [y1, i] = arselect('SR11S___TCUP9__AM');
    SR11TC1 = [SR11TC1 y1];
    [y1, i] = arselect('SR11W___TCWAGO_AM07');
    SR11TC2 = [SR11TC2 y1];
    [y1, i] = arselect('SR12S___TCUP9__AM');
    SR12TC1 = [SR12TC1 y1];
    [y1, i] = arselect('SR12W___TCWAGO_AM07');
    SR12TC2 = [SR12TC2 y1];
    
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
        
        [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
        dcct = [dcct y1];
        [y1, ilcw] = arselect('SR03S___LCWTMP_AM00');
        lcw = [lcw y1];

        [y1,i]=arselect('SR05W___GDS1PS_AM00');
        [y2,i]=arselect('SR07U___GDS1PS_AM00');
        [y3,i]=arselect('SR08U___GDS1PS_AM00');
        [y4,i]=arselect('SR09U___GDS1PS_AM00');
        [y5,i]=arselect('SR12U___GDS1PS_AM00');
        IDgap5 =[IDgap5  y1];
        IDgap7 =[IDgap7  y2];
        IDgap8 =[IDgap8  y3];
        IDgap9 =[IDgap9  y4];
        IDgap12=[IDgap12 y5];
        
        [y1, i] = arselect('SR04S___TCUP9__AM');
        SR04TC1 = [SR04TC1 y1];
        [y1, i] = arselect('SR04W___TCWAGO_AM07');
        SR04TC2 = [SR04TC2 y1];
        [y1, i] = arselect('SR05W___TCUP9__AM');
        SR05TC1 = [SR05TC1 y1];
        [y1, i] = arselect('SR05W___TCWAGO_AM06');
        SR05TC2 = [SR05TC2 y1];
        [y1, i] = arselect('SR06S___TCUP9__AM');
        SR06TC1 = [SR06TC1 y1];
        [y1, i] = arselect('SR06W___TCWAGO_AM16');
        SR06TC2 = [SR06TC2 y1];
        [y1, i] = arselect('SR07S___TCUP9__AM');
        SR07TC1 = [SR07TC1 y1];
        [y1, i] = arselect('SR07W___TCWAGO_AM09');
        SR07TC2 = [SR07TC2 y1];
        [y1, i] = arselect('SR08S___TCUP9__AM');
        SR08TC1 = [SR08TC1 y1];
        [y1, i] = arselect('SR08W___TCWAGO_AM08');
        SR08TC2 = [SR08TC2 y1];
        [y1, i] = arselect('SR09S___TCUP9__AM');
        SR09TC1 = [SR09TC1 y1];
        [y1, i] = arselect('SR09W___TCWAGO_AM06');
        SR09TC2 = [SR09TC2 y1];
        [y1, i] = arselect('SR10S___TCUP9__AM');
        SR10TC1 = [SR10TC1 y1];
        [y1, i] = arselect('SR10W___TCWAGO_AM06');
        SR10TC2 = [SR10TC2 y1];
        [y1, i] = arselect('SR11S___TCUP9__AM');
        SR11TC1 = [SR11TC1 y1];
        [y1, i] = arselect('SR11W___TCWAGO_AM07');
        SR11TC2 = [SR11TC2 y1];
        [y1, i] = arselect('SR12S___TCUP9__AM09');
        SR12TC1 = [SR12TC1 y1];
        [y1, i] = arselect('SR12W___TCWAGO_AM07');
        SR12TC2 = [SR12TC2 y1];
        
        N = N + length(ARt);
        
        t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        
        disp(' ');
    end
end

dcct = 100*dcct;
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

% n=1;
% for Sector = 1:12
% 	for j = 1:6
% 	   try
%            if isunix
%                [d,chanstr] = unix(['caget ',sprintf('SR%02dW___TCWAGO_AM%02d.DESC',Sector, j-1)]);
%                name{n} = chanstr(end-24:end-1); % end-1 is used to get rid of carriage return
%            else
%                name{n} = sprintf('SR%02dW TCWAGO AM%02d',Sector,j-1);
%            end
%        catch
%            name{n} = sprintf('SR%02dW TCWAGO AM%02d',Sector,j-1);
%        end
%        n=n+1;
% 	end
% end


%plot data
%first page
h = figure;
subfig(1,2,1,h);
subplot(2,1,1);
[ax, h1, h2] = plotyy(t, dcct, t, lcw);
grid on;
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'LCW Temp [degC]', 'Color', 'r');
set(ax(2), 'YColor', 'r');
set(h2, 'Color', 'r');
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500]);
axis([0 xmax 0 550]);
axes(ax(2));
set(ax(2),'YTick',[20 22 24 26 28 30]);
axis([0 xmax 20 30]);
grid on;
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(2,1,2);
plot(t, SR04TC1, t, SR05TC1, t, SR06TC1, t, SR07TC1, t, SR08TC1, t, SR09TC1, t, SR10TC1, t, SR11TC1, '--', t, SR12TC1, '--');
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 19 67])
ChangeAxesLabel(t, Days, DayFlag);
legend('SR04 IG1 TC1','SR05 IG1 TC1','SR06 IG1 TC1','SR07 IG1 TC1','SR08 IG1 TC1','SR09 IG1 TC1','SR10 IG1 TC1','SR11 IG1 TC1','SR12 IG1 TC1',3);

title('Top-off IG1 Aperture Interlocked TCs');

orient landscape

% second page
h = figure
subfig(1,2,2,h);
subplot(2,1,1);
[ax, h1, h2] = plotyy(t, dcct, t, lcw);
grid on;
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'LCW Temp [degC]', 'Color', 'r');
set(ax(2), 'YColor', 'r');
set(h2, 'Color', 'r');
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500]);
axis([0 xmax 0 550]);
axes(ax(2));
set(ax(2),'YTick',[20 22 24 26 28 30]);
axis([0 xmax 20 30]);
grid on;
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(2,1,2);
plot(t, SR04TC2, t, SR05TC2, t, SR06TC2, t, SR07TC2, t, SR08TC2, t, SR09TC2, t, SR10TC2, t, SR11TC2, '--', t, SR12TC2, '--');
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 19 30])
ChangeAxesLabel(t, Days, DayFlag);
legend('SR04 IG1 TC2','SR05 IG1 TC2','SR06 IG1 TC2','SR07 IG1 TC2','SR08 IG1 TC2','SR09 IG1 TC2','SR10 IG1 TC2','SR11 IG1 TC2','SR12 IG1 TC2',3);

title('Top-off IG1 Aperture Non-Interlocked TCs');

orient landscape


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
