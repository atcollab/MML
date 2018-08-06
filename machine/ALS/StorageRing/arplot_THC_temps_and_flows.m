function arplot_THC_temps_and_flows(monthStr, days, year1, month2Str, days2, year2)
% arplot_THC_temps_and_flows(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots THC temps, powers, LCW temps, and beam current.
%
% Example:  arplot_THC_temps_and_flows('January',22:24, 2017);
%           plots data from 1/22, 1/23, and 1/24 in 2017


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

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    dcctplotmax = 60;
else
    dcctplotmax = 500;
end

arglobal

t=[];
dcct=[];
lcw=[];
lcw_THC = [];

Cav1_ext_body_temp = [];
Cav2_ext_body_temp = [];
Cav3_ext_body_temp = [];

Cav1_main_tune_ret_temp = [];
Cav2_main_tune_ret_temp = [];
Cav3_main_tune_ret_temp = [];

Cav1_main_tune_bellows_temp = [];
Cav2_main_tune_bellows_temp = [];
Cav3_main_tune_bellows_temp = [];

Cav1_body_ret_temp = [];
Cav2_body_ret_temp = [];
Cav3_body_ret_temp = [];

Cav1_hor_HOM_ret_temp = [];
Cav2_hor_HOM_ret_temp = [];
Cav3_hor_HOM_ret_temp = [];

Cav1_ver_HOM_ret_temp = [];
Cav2_ver_HOM_ret_temp = [];
Cav3_ver_HOM_ret_temp = [];

Cav1_body_LCW_flow = [];
Cav2_body_LCW_flow = [];
Cav3_body_LCW_flow = [];

Cav1_HOM_LCW_flow = [];
Cav2_HOM_LCW_flow = [];
Cav3_HOM_LCW_flow = [];

Cav1_PWR = []; Cav1_Tuner_Pos = [];
Cav2_PWR = []; Cav2_Tuner_Pos = [];
Cav3_PWR = []; Cav3_Tuner_Pos = [];

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
    
    [y1, idcct] = arselect('cmm:beam_current');
    dcct = [dcct y1];

    [y1, ilcw] = arselect('SR03S___LCWTMP_AM00');
    lcw = [lcw y1];

    [y1, ilcw_THC] = arselect('SR02C___LCWTEMPAM00');
    lcw_THC = [lcw_THC y1];
    
    [y1,i]=arselect('SR02C___C1BRTP_AM00');
    [y2,i]=arselect('SR02C___C2BRTP_AM00');
    [y3,i]=arselect('SR02C___C3BRTP_AM00');
    [y4,i]=arselect('SR02C___C1BFLW_AM00');
    [y5,i]=arselect('SR02C___C2BFLW_AM00');
    [y6,i]=arselect('SR02C___C3BFLW_AM00');
    Cav1_body_ret_temp = [Cav1_body_ret_temp y1];
    Cav2_body_ret_temp = [Cav2_body_ret_temp y2];
    Cav3_body_ret_temp = [Cav3_body_ret_temp y3];
    Cav1_body_LCW_flow = [Cav1_body_LCW_flow y4];    
    Cav2_body_LCW_flow = [Cav2_body_LCW_flow y5];    
    Cav3_body_LCW_flow = [Cav3_body_LCW_flow y6];    
    
    [y1,i]=arselect('SR02C___C1PWR__AM00');
    [y2,i]=arselect('SR02C___C2PWR__AM00');
    [y3,i]=arselect('SR02C___C3PWR__AM00');
    [y4,i]=arselect('SR02C___C1MPOS_AM00');
    [y5,i]=arselect('SR02C___C2MPOS_AM00');
    [y6,i]=arselect('SR02C___C3MPOS_AM00');
    Cav1_PWR = [Cav1_PWR y1];
    Cav2_PWR = [Cav2_PWR y2];
    Cav3_PWR = [Cav3_PWR y3];
    Cav1_Tuner_Pos = [Cav1_Tuner_Pos y4];
    Cav2_Tuner_Pos = [Cav2_Tuner_Pos y5];
    Cav3_Tuner_Pos = [Cav3_Tuner_Pos y6];
    
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
        
        [y1, idcct] = arselect('cmm:beam_current');
        dcct = [dcct y1];
        
        [y1, ilcw] = arselect('SR03S___LCWTMP_AM00');
        lcw = [lcw y1];
        
        [y1, ilcw_THC] = arselect('SR02C___LCWTEMPAM00');
        lcw_THC = [lcw_THC y1];
        
        [y1,i]=arselect('SR02C___C1BRTP_AM00');
        [y2,i]=arselect('SR02C___C2BRTP_AM00');
        [y3,i]=arselect('SR02C___C3BRTP_AM00');
        [y4,i]=arselect('SR02C___C1BFLW_AM00');
        [y5,i]=arselect('SR02C___C2BFLW_AM00');
        [y6,i]=arselect('SR02C___C3BFLW_AM00');
        Cav1_body_ret_temp = [Cav1_body_ret_temp y1];
        Cav2_body_ret_temp = [Cav2_body_ret_temp y2];
        Cav3_body_ret_temp = [Cav3_body_ret_temp y3];
        Cav1_body_LCW_flow = [Cav1_body_LCW_flow y4];
        Cav2_body_LCW_flow = [Cav2_body_LCW_flow y5];
        Cav3_body_LCW_flow = [Cav3_body_LCW_flow y6];
        
        [y1,i]=arselect('SR02C___C1PWR__AM00');
        [y2,i]=arselect('SR02C___C2PWR__AM00');
        [y3,i]=arselect('SR02C___C3PWR__AM00');
        [y4,i]=arselect('SR02C___C1MPOS_AM00');
        [y5,i]=arselect('SR02C___C2MPOS_AM00');
        [y6,i]=arselect('SR02C___C3MPOS_AM00');
        Cav1_PWR = [Cav1_PWR y1];
        Cav2_PWR = [Cav2_PWR y2];
        Cav3_PWR = [Cav3_PWR y3];
        Cav1_Tuner_Pos = [Cav1_Tuner_Pos y4];
        Cav2_Tuner_Pos = [Cav2_Tuner_Pos y5];
        Cav3_Tuner_Pos = [Cav3_Tuner_Pos y6];
        
        N = N + length(ARt);
        
        t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        
        disp(' ');
    end
end

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


%plot data
%first page
h = figure;
%subfig(1,2,1,h);
subplot(5,1,1);
plot(t, Cav1_body_ret_temp, t, Cav2_body_ret_temp, t, Cav3_body_ret_temp);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 20 27])
ChangeAxesLabel(t, Days, DayFlag);
legend('Cav1 Body Temp', 'Cav2 Body Temp', 'Cav3 Body Temp','Location','Best');
%title(titleStr);
title(['THC Body Return Temperatures:' titleStr]);

subplot(5,1,2);
plot(t, Cav1_body_LCW_flow, t, Cav2_body_LCW_flow, t, Cav3_body_LCW_flow);
grid on;
ylabel('LCW flow [gpm]');
axis([min(t) max(t) 4 5])
ChangeAxesLabel(t, Days, DayFlag);
legend('Cav1 Body LCW flow', 'Cav2 Body LCW flow', 'Cav3 Body LCW flow','Location','Best');

subplot(5,1,3);
plot(t, Cav1_PWR, t, Cav2_PWR, t, Cav3_PWR);
grid on;
ylabel('Power [kW]');
axis([min(t) max(t) 2.2 2.8])
ChangeAxesLabel(t, Days, DayFlag);
legend('Cav1 Power', 'Cav2 Power', 'Cav3 Power','Location','Best');

subplot(5,1,4);
plot(t, Cav1_Tuner_Pos, t, Cav2_Tuner_Pos, t, Cav3_Tuner_Pos);
grid on;
ylabel('Tuner Positions [V]');
axis([min(t) max(t) 6.6 7.5])
ChangeAxesLabel(t, Days, DayFlag);
legend('Cav1 Tuner Position', 'Cav2 Tuner Position', 'Cav3 Tuner Position','Location','Best');

subplot(5,1,5);
[ax, ~, h2] = plotyy(t, dcct, t, [lcw; lcw_THC]);
% grid on;
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'LCW Temp (noisy) / THC LCW Temp [degC]', 'Color', 'r');
set(ax(2), 'YColor', 'r');
set(h2, 'Color', 'r');
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500 550]);
axis([0 xmax 0 550]);
axes(ax(2));
set(ax(2),'YTick',[20 22 24 26 28 30]);
axis([0 xmax 22 25]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);

orient tall

% % second page
% h = figure
% subfig(1,2,2,h);
% subplot(2,1,1);
% [ax, h1, h2] = plotyy(t, dcct, t, lcw);
% .
% .
% .

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
