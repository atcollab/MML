function arplot_id(monthStr, days, year1, month2Str, days2, year2)
% arplot_id(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots insertion device archived data info.
%
% Example:  arplot_id('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1/24 in 1998
%

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


t = [];
dcct = [];
lcw = [];
lifetime = [];
IDgap = [];
EPU = [];
IDmovecount = [];
IG11_2 = [];


IDgap4=[];
IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap10=[];
IDgap11=[];
IDgap12=[];

IDmovecount4=[];
IDmovecount5=[];
IDmovecount7=[];
IDmovecount8=[];
IDmovecount9=[];
IDmovecount10=[];
IDmovecount11=[];
IDmovecount12=[];


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
    arread(FileName);
    %readtime = etime(clock, t0)

    [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
    [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
    dcct = [dcct y1];
    lcw  = [lcw  y2];

    [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
    lifetime = [lifetime  y1];


    % EPU
    %if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
    %    [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS1PS_AM00']);
    %else
    %    [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS2PS_AM00']);
    %end
    EPUlist = family2dev('EPU');
    EPUChan = family2channel('EPU','Monitor');
    if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
        [tmp, i] = ismember('SR11U___ODS2PS_AM00', EPUChan, 'rows');
        EPUChan(i,:) = []; % remove it because it probably already in the list 'SR11U___ODS1PS_AM00';
    end
    [y1, i, iNotFound] = arselect(EPUChan);
    y1(iNotFound,:) = [];
    EPU =[EPU  y1];
    EPULegend = mat2cell(ARChanNames(i,3:4), ones(length(i),1), 2);
    EPULegend = strcat(EPULegend,'EPU');
    EPULegend = strcat(EPULegend,ARChanNames(i,12));


    % ID vertical gap
    IDlist = family2dev('ID');
    [y1, i, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
    y1(iNotFound,:) = [];
    IDlist(iNotFound,:) = [];
    IDgap = [IDgap  y1];
    IDLegend = mat2cell(ARChanNames(i,3:5),ones(length(i),1),3);
    IDLegend = strcat(IDLegend,ARChanNames(i,12));


    % ID move count (vertical gap)
    IDlist = family2dev('ID');
    [y1, i, iNotFound] = arselect(family2channel('ID','MoveCount',IDlist));
    y1(iNotFound,:) = [];
    IDmovecount = [IDmovecount  y1];
    %IDLegend = mat2cell(ARChanNames(i,3:5),ones(length(i),1),3);
    %IDLegend = strcat(IDLegend,ARChanNames(i,12));

    
    [y1, i, iNotFound] = arselect(family2channel('IonGauge','Monitor',[11 2]));
    y1(iNotFound,:) = [];
    IG11_2 = [IG11_2  y1];
    
    
    [y1,i] = arselect('SR04U___GDS1PS_AM00');
    [y2,i] = arselect('SR05W___GDS1PS_AM00');
    [y3,i] = arselect('SR07U___GDS1PS_AM00');
    [y4,i] = arselect('SR08U___GDS1PS_AM00');
    [y5,i] = arselect('SR09U___GDS1PS_AM00');
    [y6,i] = arselect('SR10U___GDS1PS_AM00');
    [y7,i] = arselect('SR11U___GDS1PS_AM00');
    [y8,i] = arselect('SR12U___GDS1PS_AM00');
    IDgap4  = [IDgap4   y1];
    IDgap5  = [IDgap5   y2];
    IDgap7  = [IDgap7   y3];
    IDgap8  = [IDgap8   y4];
    IDgap9  = [IDgap9   y5];
    IDgap10 = [IDgap10  y6];
    IDgap11 = [IDgap11  y7];
    IDgap12 = [IDgap12  y8];

    [y1, i] = arselect('SR04U___GDS1E__AM02');
    [y2, i] = arselect('SR05W___GDS1E__AM02');
    [y3, i] = arselect('SR07U___GDS1E__AM02');
    [y4, i] = arselect('SR08U___GDS1E__AM02');
    [y5, i] = arselect('SR09U___GDS1E__AM02');
    [y6, i] = arselect('SR10U___GDS1E__AM02');
    [y7, i] = arselect('SR11U___GDS1E__AM02');
    [y8, i] = arselect('SR12U___GDS1E__AM02');
    IDmovecount4  = [IDmovecount4   y1];
    IDmovecount5  = [IDmovecount5   y2];
    IDmovecount7  = [IDmovecount7   y3];
    IDmovecount8  = [IDmovecount8   y4];
    IDmovecount9  = [IDmovecount9   y5];
    IDmovecount10 = [IDmovecount10  y6];
    IDmovecount11 = [IDmovecount11  y7];
    IDmovecount12 = [IDmovecount12  y8];

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
        arread(FileName);
        %readtime = etime(clock, t0)

        [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
        [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
        dcct = [dcct y1];
        lcw  = [lcw  y2];

        [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
        lifetime = [lifetime  y1];

        % EPU
        %if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
        %    [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS1PS_AM00']);
        %else
        %    [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS2PS_AM00']);
        %end
        EPUChan = family2channel('EPU','Monitor');
        if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
            [tmp, i] = ismember('SR11U___ODS2PS_AM00', EPUChan, 'rows');
            EPUChan(i,:) = []; % remove it because it probably already in the list 'SR11U___ODS1PS_AM00';
        end
        [y1, i, iNotFound] = arselect(EPUChan);
        y1(iNotFound,:) = [];
        EPU =[EPU  y1];
        EPULegend = mat2cell(ARChanNames(i,3:4), ones(length(i),1), 2);
        EPULegend = strcat(EPULegend,'EPU');
        EPULegend = strcat(EPULegend,ARChanNames(i,12));


        % ID vertical gap
        IDlist = family2dev('ID');
        [y1, i, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        y1(iNotFound,:) = [];
        IDlist(iNotFound,:) = [];
        IDgap = [IDgap  y1];
        IDLegend = mat2cell(ARChanNames(i,3:5),ones(length(i),1),3);
        IDLegend = strcat(IDLegend,ARChanNames(i,12));


        % ID move count (vertical gap)
        IDlist = family2dev('ID');
        [y1, i, iNotFound] = arselect(family2channel('ID','MoveCount',IDlist));
        y1(iNotFound,:) = [];
        IDmovecount = [IDmovecount  y1];
        %IDLegend = mat2cell(ARChanNames(i,3:5),ones(length(i),1),3);
        %IDLegend = strcat(IDLegend,ARChanNames(i,12));
        

        [y1, i, iNotFound] = arselect(family2channel('IonGauge','Monitor',[11 2]));
        y1(iNotFound,:) = [];
        IG11_2 = [IG11_2  y1];

        
        
        [y1,i] = arselect('SR04U___GDS1PS_AM00');
        [y2,i] = arselect('SR05W___GDS1PS_AM00');
        [y3,i] = arselect('SR07U___GDS1PS_AM00');
        [y4,i] = arselect('SR08U___GDS1PS_AM00');
        [y5,i] = arselect('SR09U___GDS1PS_AM00');
        [y6,i] = arselect('SR10U___GDS1PS_AM00');
        [y7,i] = arselect('SR11U___GDS1PS_AM00');
        [y8,i] = arselect('SR12U___GDS1PS_AM00');
        IDgap4  = [IDgap4   y1];
        IDgap5  = [IDgap5   y2];
        IDgap7  = [IDgap7   y3];
        IDgap8  = [IDgap8   y4];
        IDgap9  = [IDgap9   y5];
        IDgap10 = [IDgap10  y6];
        IDgap11 = [IDgap11  y7];
        IDgap12 = [IDgap12  y8];

        [y1, i] = arselect('SR04U___GDS1E__AM02');
        [y2, i] = arselect('SR05W___GDS1E__AM02');
        [y3, i] = arselect('SR07U___GDS1E__AM02');
        [y4, i] = arselect('SR08U___GDS1E__AM02');
        [y5, i] = arselect('SR09U___GDS1E__AM02');
        [y6, i] = arselect('SR10U___GDS1E__AM02');
        [y7, i] = arselect('SR11U___GDS1E__AM02');
        [y8, i] = arselect('SR12U___GDS1E__AM02');
        IDmovecount4  = [IDmovecount4   y1];
        IDmovecount5  = [IDmovecount5   y2];
        IDmovecount7  = [IDmovecount7   y3];
        IDmovecount8  = [IDmovecount8   y4];
        IDmovecount9  = [IDmovecount9   y5];
        IDmovecount10 = [IDmovecount10  y6];
        IDmovecount11 = [IDmovecount11  y7];
        IDmovecount12 = [IDmovecount12  y8];

        t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];

        disp(' ');
    end
end


dcct = 100*dcct;


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


figure(1);clf;
subplot(2,1,1);
plot(t,IDgap);
hold on;
plot(t,EPU);
IDLegend = [IDLegend; EPULegend];
hold off
%set(gca,'XTickLabel','');
xlabel(xlabelstring);
ylabel('ID Gap [mm]','fontsize',10);
axis([0 xmax -27 60]);
ChangeAxesLabel(t, Days, DayFlag);

hh = legend(IDLegend);
set(hh, 'Units','Normalized', 'position',[-.01 .4 .08 .27]);  % Left side

subplot(2,1,2);
plot(t,IDmovecount);
xlabel(xlabelstring);
ylabel('ID Move Count','fontsize',10);
%axis([0 xmax -27 60]);
ChangeAxesLabel(t, Days, DayFlag);
yaxesposition(1.20);

orient tall


figure(2); clf;
subplot(3,1,1);
plot(t, dcct); grid on;
%set(gca,'XTickLabel','');
ylabel('Beam Current [mAmps]');
ChangeAxesLabel(t, Days, DayFlag);
yaxis([0 420]);
title(titleStr);

subplot(3,1,2);
plot(t, lifetime); grid on;
%set(gca,'XTickLabel','');
ylabel('Lifetime [Hours]');
yaxis([0 20]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
plot(t, lcw); grid on;
xlabel(xlabelstring, 'fontsize',12);
ylabel('LCW Temperature [Celsius]');
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.20);
orient tall


% figure(3); clf;
% subplot(2,1,1);
% plot(t,IDgap4,'y', t,IDgap5,'--m', t,IDgap7,':c', t,IDgap8,'-.r');
% set(gca,'XTickLabel','');
% ylabel('Insertion Device Gap [mm]');
% title(titleStr);
% legend('EPU4  ', '5W  ', '7U  ','8U  ');
% ChangeAxesLabel(t, Days, DayFlag);
% 
% subplot(2,1,2);
% plot(t,IDgap9,'y', t,IDgap10,'--m', t,IDgap11,':c', t,IDgap12,'-.r');
% xlabel(xlabelstring, 'fontsize',12);
% ylabel('Insertion Device Gap [mm]');
% legend('9U  ', '10U ', '11U ','12U ');
% ChangeAxesLabel(t, Days, DayFlag);
% 
% yaxesposition(1.20);
% orient tall


figure(3); clf;
subplot(4,1,1);
plot(t,IDmovecount4,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 4');
title(['Move Count , ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,2);
plot(t,IDmovecount5,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 5');
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,3);
plot(t,IDmovecount7,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 7');
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,4);
plot(t,IDmovecount8,'r'); grid on;
xlabel(xlabelstring, 'fontsize',12);
ylabel('Sector 8');
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.20);
orient tall


figure(4); clf;
subplot(4,1,1);
plot(t,IDmovecount9,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 9');
ChangeAxesLabel(t, Days, DayFlag);
title(['Move Count , ',titleStr]);

subplot(4,1,2);
plot(t,IDmovecount10,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 10');
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,3);
plot(t,IDmovecount11,'r'); grid on;
%set(gca,'XTickLabel','');
ylabel('Sector 11');
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,4);
plot(t,IDmovecount12,'r'); grid on;
%set(gca,'XTickLabel','');
xlabel(xlabelstring, 'fontsize',12);
ylabel('Sector 12');
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.20);
orient tall


figure(5); clf reset;
subplot(3,1,1);
plot(t, dcct); grid on;
%set(gca,'XTickLabel','');
ylabel('Beam Current [mAmps]', 'fontsize',12);
title(['EPU(11,1):  ',titleStr], 'fontsize',12);
ChangeAxesLabel(t, Days, DayFlag);
yaxis([0 420]);

subplot(3,1,2);
i = findrowindex([11 1], IDlist);

%plot(t,IDgap(i,:));
%%set(gca,'XTickLabel','');
%ylabel('Vertical Gap, EPU(11,1) [mm]', 'fontsize',12);
%yaxis([10 60]);
%ChangeAxesLabel(t, Days, DayFlag);


RightGraphColor = 'r';
[ax, h1, h2] = plotyy(t,IDgap(i,:), t,IG11_2,'plot','semilogy');
%grid on;
set(get(ax(1),'Ylabel'), 'String', 'Vertical Gap [mm]', 'fontsize',12);
set(get(ax(2),'Ylabel'), 'String', 'IG(11,2) [Torr]', 'Color', RightGraphColor, 'fontsize',12);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);

axes(ax(1));
set(ax(1),'YTick',[10 20 30 40 50 60]);
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa = [0 xmax 10 60];
axis(aa);


axes(ax(2));
set(ax(2),'YTick',[1e-9 1e-8]);
%set(ax(2),'YScale', 'Log');
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa = [0 xmax 1e-9 1e-8];
axis(aa);

if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
%set(ax(2),'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);


subplot(3,1,3);
i = findrowindex([11 1], EPUlist);
plot(t,EPU(i,:));
grid on;
xlabel(xlabelstring, 'fontsize',12);
ylabel('Horizontal Offset [mm]', 'fontsize',12);
yaxis([-26 26]);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.20);
orient tall



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
        set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));
    end
end
