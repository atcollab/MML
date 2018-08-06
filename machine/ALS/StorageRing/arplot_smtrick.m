function arplot_ig(monthStr, days, year1, month2Str, days2, year2)
% arplot_ig(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots Beam Current, Lifetime, and all SR IG data.
%
% Example:  arplot_ig('January',22:24, 1998);
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


t=[];
dcct=[];
lifetime=[];
lifetimeAM=[];
IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap12=[];

SR01IG1 = []; SR01IG2 = [];
SR02IG1 = [];
SR03IG1 = []; SR03IG3 = [];
SR04IG1 = []; SR04IG2 = [];
SR05IG1 = [];
SR06IG1 = []; SR06IG2 = [];
SR07IG1 = [];
SR08IG1 = [];
SR09IG1 = [];
SR10IG1 = [];
SR11IG1 = []; SR11IG2 = [];
SR12IG1 = [];

IG1=[];

IP1=[]; IP2=[]; IP3=[]; IP4=[]; IP5=[]; IP6=[];
IP7=[]; IP8=[]; IP9=[]; IP10=[]; IP11=[]; IP12=[];

IP1S=[]; IP2S=[]; IP3S=[]; IP4S=[]; IP5S=[]; IP6S=[];
IP7S=[]; IP8S=[]; IP9S=[]; IP10S=[]; IP11S=[]; IP12S=[];

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
    [y1, ilifetimeAM] = arselect('SR05W___DCCT2__AM00');
    lifetimeAM = [lifetimeAM  y1];

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

    [y1, i] = arselect('SR01S___IG1____AM00');
    SR01IG1 = [SR01IG1 y1];
    [y1, i] = arselect('SR01S___IG2____AM00');
    SR01IG2 = [SR01IG2 y1];
    [y1, i] = arselect('SR02S___IG1____AM00');
    SR02IG1 = [SR02IG1 y1];
    [y1, i] = arselect('SR03S___IG1____AM01');
    SR03IG1 = [SR03IG1 y1];
    [y1, i] = arselect('SR03S___IG3____AM05');
    SR03IG3 = [SR03IG3 y1];
    [y1, i] = arselect('SR04U___IG1____AM00');
    SR04IG1 = [SR04IG1 y1];
    [y1, i] = arselect('SR04U___IG2____AM00');
    SR04IG2 = [SR04IG2 y1];
    [y1, i] = arselect('SR05W___IG1____AM00');
    SR05IG1 = [SR05IG1 y1];
    [y1, i] = arselect('SR06U___IG1____AM00');
    SR06IG1 = [SR06IG1 y1];
    [y1, i] = arselect('SR06U___IG2____AM00');
    SR06IG2 = [SR06IG2 y1];
    [y1, i] = arselect('SR07U___IG1____AM00');
    SR07IG1 = [SR07IG1 y1];
    [y1, i] = arselect('SR08U___IG1____AM00');
    SR08IG1 = [SR08IG1 y1];
    [y1, i] = arselect('SR09U___IG1____AM00');
    SR09IG1 = [SR09IG1 y1];
    [y1, i] = arselect('SR10U___IG1____AM00');
    SR10IG1 = [SR10IG1 y1];
    [y1, i] = arselect('SR11U___IG1____AM00');
    SR11IG1 = [SR11IG1 y1];
    [y1, i] = arselect('SR11U___IG2____AM00');
    SR11IG2 = [SR11IG2 y1];
    [y1, i] = arselect('SR12U___IG1____AM02');
    SR12IG1 = [SR12IG1 y1];

    for j = 1:12
        [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
        IG1(j,N+1:N+length(ARt))=y1;
    end;

    [y1, i] = arselect('SR01C___IP');
    IP1(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR02C___IP');
    IP2(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR03C___IP');
    IP3(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR04C___IP');
    IP4(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR05C___IP');
    IP5(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR06C___IP');
    IP6(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR07C___IP');
    IP7(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR08C___IP');
    IP8(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR09C___IP');
    IP9(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR10C___IP');
    IP10(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR11C___IP');
    IP11(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR12C___IP');
    IP12(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR01S___IP');
    IP1S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR02S___IP');
    IP2S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR03S___IP');
    IP3S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR04U___IP');
    IP4S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR05W___IP');
    IP5S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR06S___IP');
    IP6S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR07U___IP');
    IP7S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR08U___IP');
    IP8S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR09U___IP');
    IP9S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR10U___IP');
    IP10S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR11U___IP');
    IP11S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR12U___IP');
    IP12S(:,N+1:N+length(ARt))=y1;

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
        [y1, ilifetimeAM] = arselect('SR05W___DCCT2__AM00');
        lifetimeAM = [lifetimeAM  y1];

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

        [y1, i] = arselect('SR01S___IG1____AM00');
        SR01IG1 = [SR01IG1 y1];
        [y1, i] = arselect('SR01S___IG2____AM00');
        SR01IG2 = [SR01IG2 y1];
        [y1, i] = arselect('SR02S___IG1____AM00');
        SR02IG1 = [SR02IG1 y1];
        [y1, i] = arselect('SR03S___IG1____AM01');
        SR03IG1 = [SR03IG1 y1];
        [y1, i] = arselect('SR03S___IG3____AM05');
        SR03IG3 = [SR03IG3 y1];
        [y1, i] = arselect('SR04U___IG1____AM00');
        SR04IG1 = [SR04IG1 y1];
        [y1, i] = arselect('SR04U___IG2____AM00');
        SR04IG2 = [SR04IG2 y1];
        [y1, i] = arselect('SR05W___IG1____AM00');
        SR05IG1 = [SR05IG1 y1];
        [y1, i] = arselect('SR06U___IG1____AM00');
        SR06IG1 = [SR06IG1 y1];
        [y1, i] = arselect('SR06U___IG2____AM00');
        SR06IG2 = [SR06IG2 y1];
        [y1, i] = arselect('SR07U___IG1____AM00');
        SR07IG1 = [SR07IG1 y1];
        [y1, i] = arselect('SR08U___IG1____AM00');
        SR08IG1 = [SR08IG1 y1];
        [y1, i] = arselect('SR09U___IG1____AM00');
        SR09IG1 = [SR09IG1 y1];
        [y1, i] = arselect('SR10U___IG1____AM00');
        SR10IG1 = [SR10IG1 y1];
        [y1, i] = arselect('SR11U___IG1____AM00');
        SR11IG1 = [SR11IG1 y1];
        [y1, i] = arselect('SR11U___IG2____AM00');
        SR11IG2 = [SR11IG2 y1];
        [y1, i] = arselect('SR12U___IG1____AM02');
        SR12IG1 = [SR12IG1 y1];

        for j = 1:12
            [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
            IG1(j,N+1:N+length(ARt))=y1;
        end;

        [y1, i] = arselect('SR01C___IP');
        IP1(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR02C___IP');
        IP2(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR03C___IP');
        IP3(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR04C___IP');
        IP4(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR05C___IP');
        IP5(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR06C___IP');
        IP6(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR07C___IP');
        IP7(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR08C___IP');
        IP8(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR09C___IP');
        IP9(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR10C___IP');
        IP10(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR11C___IP');
        IP11(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR12C___IP');
        IP12(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR01S___IP');
        IP1S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR02S___IP');
        IP2S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR03S___IP');
        IP3S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR04U___IP');
        IP4S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR05W___IP');
        IP5S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR06S___IP');
        IP6S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR07U___IP');
        IP7S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR08U___IP');
        IP8S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR09U___IP');
        IP9S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR10U___IP');
        IP10S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR11U___IP');
        IP11S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR12U___IP');
        IP12S(:,N+1:N+length(ARt))=y1;

        N = N + length(ARt);


        t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];

        disp(' ');
    end
end

%dcct conditioning 
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
xmin = min(t);

%plot data
%first page
figure
subplot(3,1,1);
plot(t, dcct,'b-');
grid on;
%ylabel('Beam Current [mAmps]');
axis([xmin xmax 0 550]);
title(titleStr);

ChangeAxesLabel(t, Days, DayFlag);





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
