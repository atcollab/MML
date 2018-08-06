function arplot_vacuum(monthStr, days, year1, month2Str, days2, year2)
% arplot_vacuum(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
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

LeftGraphColor = 'b';
RightGraphColor = 'r';

t=[];
dcct=[];
lifetime=[];
lifetimeAM=[];
IDgap5=[];
%IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap12=[];

SR01IG1 = []; SR01IG2 = [];
SR02IG1 = [];
SR03IG1 = []; SR03SIG2 = []; SR03IG3 = [];
SR04IG1 = []; SR04IG2 = [];
SR05IG1 = [];
SR06IG1 = []; SR06IG2 = []; SR06IG3 = [];
SR07IG1 = []; SR07IG2 = [];
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

%    [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
    [y1, idcct] = arselect('cmm:beam_current');
    dcct = [dcct y1];
    [y1, ilifetimeAM] = arselect('Topoff_lifetime_AM');
    lifetimeAM = [lifetimeAM  y1];

    [y1,i]=arselect('SR05W___GDS1PS_AM00');
%    [y2,i]=arselect('SR07U___GDS1PS_AM00');
    [y3,i]=arselect('SR08U___GDS1PS_AM00');
    [y4,i]=arselect('SR09U___GDS1PS_AM00');
    [y5,i]=arselect('SR12U___GDS1PS_AM00');
    IDgap5 =[IDgap5  y1];
%    IDgap7 =[IDgap7  y2];
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
    [y1, i] = arselect('SR03S___IG2____AM00');
    SR03SIG2 = [SR03SIG2 y1];
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
    [y1, i] = arselect('SR06U___IG3____AM00');
    SR06IG3 = [SR06IG3 y1];
    [y1, i] = arselect('SR07U___IG1____AM00');
    SR07IG1 = [SR07IG1 y1];
    [y1, i] = arselect('SR07U___IG2____AM00');
    SR07IG2 = [SR07IG2 y1];
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
    [y1, i] = arselect('SR12U___IG1____AM00');
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
    if size(y1,1)>6    % added 2-29-12 since now there are SR03C___IP2____AM01 and SR03C___IP6____AM01 (as well as AM00)
        IP3(1:6,N+1:N+length(ARt))=y1(1:6,:);
    else
        IP3(:,N+1:N+length(ARt))=y1;
    end
    
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

    [y1, i] = arselect(['SR03S___IP';'SR03S_IPNE']);
    IP3S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR04U___IP');
    IP4S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR05W___IP');
    IP5S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect('SR06S___IP');
    IP6S(:,N+1:N+length(ARt))=y1;

    [y1, i] = arselect(['SR07U___IP';'SR07S_IPNE']);
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

%        [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
        [y1, idcct] = arselect('cmm:beam_current');
        dcct = [dcct y1];
        [y1, ilifetimeAM] = arselect('Topoff_lifetime_AM');
        lifetimeAM = [lifetimeAM  y1];

        [y1,i]=arselect('SR05W___GDS1PS_AM00');
%        [y2,i]=arselect('SR07U___GDS1PS_AM00');
        [y3,i]=arselect('SR08U___GDS1PS_AM00');
        [y4,i]=arselect('SR09U___GDS1PS_AM00');
        [y5,i]=arselect('SR12U___GDS1PS_AM00');
        IDgap5 =[IDgap5  y1];
%        IDgap7 =[IDgap7  y2];
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
        [y1, i] = arselect('SR03S___IG2____AM00');
        SR03SIG2 = [SR03SIG2 y1];
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
        [y1, i] = arselect('SR06U___IG3____AM00');
        SR06IG3 = [SR06IG3 y1];
        [y1, i] = arselect('SR07U___IG1____AM00');
        SR07IG1 = [SR07IG1 y1];
        [y1, i] = arselect('SR07U___IG2____AM00');
        SR07IG2 = [SR07IG2 y1];
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
        [y1, i] = arselect('SR12U___IG1____AM00');
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
        if size(y1,1)>6    % added 2-29-12 since now there are SR03C___IP2____AM01 and SR03C___IP6____AM01 (as well as AM00)
            IP3(1:6,N+1:N+length(ARt))=y1(1:6,:);
        else
            IP3(:,N+1:N+length(ARt))=y1;
        end
        
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

        [y1, i] = arselect(['SR03S___IP';'SR03S_IPNE']);
        IP3S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR04U___IP');
        IP4S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR05W___IP');
        IP5S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect('SR06S___IP');
        IP6S(:,N+1:N+length(ARt))=y1;

        [y1, i] = arselect(['SR07U___IP';'SR07S_IPNE']);
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

%remove data less than zero
i = find(SR01IG1<0); SR01IG1(i)=NaN;
i = find(SR01IG2<0); SR01IG2(i)=NaN;
i = find(SR02IG1<0); SR02IG1(i)=NaN;
i = find(SR03IG1<0); SR03IG1(i)=NaN;
i = find(SR03SIG2<0); SR03SIG2(i)=NaN;
i = find(SR03IG3<0); SR03IG3(i)=NaN;
i = find(SR04IG1<0); SR04IG1(i)=NaN;
i = find(SR04IG2<0); SR04IG2(i)=NaN;
i = find(SR05IG1<0); SR05IG1(i)=NaN;
i = find(SR06IG1<0); SR06IG1(i)=NaN;
i = find(SR06IG2<0); SR06IG2(i)=NaN;
i = find(SR06IG3<0); SR06IG3(i)=NaN;
i = find(SR07IG1<0); SR07IG1(i)=NaN;
i = find(SR07IG2<0); SR07IG2(i)=NaN;
i = find(SR08IG1<0); SR08IG1(i)=NaN;
i = find(SR09IG1<0); SR09IG1(i)=NaN;
i = find(SR10IG1<0); SR10IG1(i)=NaN;
i = find(SR11IG1<0); SR11IG1(i)=NaN;
i = find(SR11IG2<0); SR11IG2(i)=NaN;
i = find(SR12IG1<0); SR12IG1(i)=NaN;

i = find(IG1<0); IG1(i)=NaN;

i = find(IP1<0); IP1(i)=NaN;
i = find(IP2<0); IP2(i)=NaN;
i = find(IP3<0); IP3(i)=NaN;
i = find(IP4<0); IP4(i)=NaN;
i = find(IP5<0); IP5(i)=NaN;
i = find(IP6<0); IP6(i)=NaN;
i = find(IP7<0); IP7(i)=NaN;
i = find(IP8<0); IP8(i)=NaN;
i = find(IP9<0); IP9(i)=NaN;
i = find(IP10<0); IP10(i)=NaN;
i = find(IP11<0); IP11(i)=NaN;
i = find(IP12<0); IP12(i)=NaN;
i = find(IP1S<0); IP1S(i)=NaN;
i = find(IP2S<0); IP2S(i)=NaN;
i = find(IP3S<0); IP3S(i)=NaN;
i = find(IP4S<0); IP4S(i)=NaN;
i = find(IP5S<0); IP5S(i)=NaN;
i = find(IP6S<0); IP6S(i)=NaN;
i = find(IP7S<0); IP7S(i)=NaN;
i = find(IP8S<0); IP8S(i)=NaN;
i = find(IP9S<0); IP9S(i)=NaN;
i = find(IP10S<0) ;IP10S(i)=NaN;
i = find(IP11S<0) ;IP11S(i)=NaN;
i = find(IP12S<0) ;IP12S(i)=NaN;

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
axis([0 xmax 0 16.5]);
grid on;
title(titleStr);
ChangeAxesLabel2(ax, t, Days, DayFlag);

subplot(3,1,2);
h1=semilogy(t, SR01IG1, t, SR01IG2, t, IG1(1,:), t, SR02IG1, t, IG1(2,:), t, SR03IG1, t, SR03SIG2, t, SR03IG3, t, IG1(3,:) ,'--');
for h = 1:length(h1)
    set(h1(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
axis([xmin xmax 1e-10 1e-7]);
clear name;
for j = 1:12
    name(j,:)=sprintf('SR%02dC IG2 AM',j);
end
name1 = ['SR01S IG1 AM'
    'SR01S IG2 AM'
    name(1,:)
    'SR02S IG1 AM'
    name(2,:)
    'SR03S IG1 AM'
    'SR03S IG2 AM'
    'SR03S IG3 AM'
    name(3,:)];
legend(name1,'Location','best');
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
h2=semilogy(t, SR04IG1, t, SR04IG2, t, IG1(4,:), t, SR05IG1, t, IG1(5,:), t, IG1(6,:), t, SR06IG1, t, SR06IG2 ,'--', t, SR06IG3 ,'--');
for h = 1:length(h2)
    set(h2(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-7]);
name2 = [
    'SR04U IG1 AM'
    'SR04U IG2 AM'
    name(4,:)
    'SR05W IG1 AM'
    name(5,:)
    name(6,:)
    'SR06U IG1 AM'
    'SR06U IG2 AM'
    'SR06U IG3 AM'];
legend(name2,'Location','best');
ChangeAxesLabel(t, Days, DayFlag);
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
axis([0 xmax 0 16.5]);
grid on;
title(titleStr);
ChangeAxesLabel2(ax, t, Days, DayFlag);

subplot(3,1,2);
h3=semilogy(t, SR07IG1, t, SR07IG2, t, IG1(7,:), t, SR08IG1, t, IG1(8,:), t, SR09IG1, t, IG1(9,:));
for h = 1:length(h3)
    set(h3(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
axis([xmin xmax 1e-10 1e-7]);
name3 = ['SR07U IG1 AM'
    'SR07U IG2 AM'
    name(7,:)
    'SR08U IG1 AM'
    name(8,:)
    'SR09U IG1 AM'
    name(9,:)];
legend(name3,'Location','best');
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
h4=semilogy(t, SR10IG1, t, IG1(10,:), t, SR11IG1, t, SR11IG2, t, IG1(11,:), t, SR12IG1, t, IG1(12,:));
for h = 1:length(h4)
    set(h4(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-7]);
name4 = ['SR10U IG1 AM'
    name(10,:)
    'SR11U IG1 AM'
    'SR11U IG2 AM'
    name(11,:)
    'SR12U IG1 AM'
    name(12,:)];
legend(name4,'Location','best');
axis([xmin xmax 1e-10 1e-7]);
ChangeAxesLabel(t, Days, DayFlag);
orient landscape

%third page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
plot(t, dcct); grid on;
yaxis([0 550])
ylabel('Beam Current [mAmps]');
title(titleStr);
axis([xmin xmax 0 550]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
plot(t,lifetimeAM); grid on;
ylabel('Lifetime [hours]');
axis([xmin xmax 0 8]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
semilogy(t, IP1, t, IP2, t, IP3, t, IP4, ...
    t, IP5, t, IP6, t, IP7, t, IP8, ...
    t, IP9, t, IP10, t, IP11, t, IP12, ...
    t, IP1S, t, IP2S, t, IP3S, t, IP4S, ...
    t, IP5S, t, IP6S, t, IP7S, t, IP8S, ...
    t, IP9S, t, IP10S, t, IP11S, t, IP12S);
grid on;
ylabel('Ion Pumps [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);
orient landscape

%fourth page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
semilogy(t, IP1, t, IP1S);
grid on;
ylabel('IP sector 1 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
title(titleStr);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
semilogy(t, IP2, t, IP2S);
grid on;
ylabel('IP sector 2 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
semilogy(t, IP3, t, IP3S);
grid on;
ylabel('IP sector 3 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);
orient landscape

%fifth page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
semilogy(t, IP4, t, IP4S);
grid on;
ylabel('IP sector 4 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
title(titleStr);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
semilogy(t, IP5, t, IP5S);
grid on;
ylabel('IP sector 5 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
semilogy(t, IP6, t, IP6S);
grid on;
ylabel('IP sector 6 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);
orient landscape

%sixth page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
semilogy(t, IP7, t, IP7S);
grid on;
ylabel('IP sector 7 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
title(titleStr);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
semilogy(t, IP8, t, IP8S);
grid on;
ylabel('IP sector 8 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
semilogy(t, IP9, t, IP9S);
grid on;
ylabel('IP sector 9 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);
orient landscape

%seventh page
h=figure;
subfig(1,2,2, h);
subplot(3,1,1);
semilogy(t, IP10, t, IP10S);
grid on;
ylabel('IP sector 10 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
title(titleStr);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2);
semilogy(t, IP11, t, IP11S);
grid on;
ylabel('IP sector 11 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,3);
semilogy(t, IP12, t, IP12S);
grid on;
ylabel('IP sector 12 [Torr] ');
%xlabel(['Time since ', StartDayStr,' [days]']);
xlabel(xlabelstring);
axis([xmin xmax 1e-10 1e-6]);
ChangeAxesLabel(t, Days, DayFlag);
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

%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel2(ax, t, Days, DayFlag)

if length(ax)~=2
    ChangeAxesLabel(t, Days, DayFlag)
else
    if DayFlag
        if size(Days,2) > 1
            Days = Days'; % Make a column vector
        end
        
        MaxDay = round(max(t));
        set(ax(1),'XTick',[0:MaxDay]');
        set(ax(2),'XTick',[0:MaxDay]');
        
        if length(Days) < MaxDay-1
            % Days were skipped
            set(ax(1),'XTickLabel',strvcat(num2str([0:MaxDay-1]'+Days(1)),' '));
            set(ax(2),'XTickLabel','');
        else
            % All days plotted
            set(ax(1),'XTickLabel',strvcat(num2str(Days),' '));
            set(ax(2),'XTickLabel','');
        end
        
        XTickLabelString = get(ax(1),'XTickLabel');
        if MaxDay < 20
            % ok
        elseif MaxDay < 40
            set(ax(1),'XTick',[0:2:MaxDay]');
            set(ax(2),'XTick',[0:2:MaxDay]');
            set(ax(1),'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));
            set(ax(2),'XTickLabel','');
        elseif MaxDay < 63
            set(ax(1),'XTick',[0:3:MaxDay]');
            set(ax(2),'XTick',[0:3:MaxDay]');
            set(ax(1),'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));
            set(ax(2),'XTickLabel','');
        elseif MaxDay < 80
            set(ax(1),'XTick',[0:4:MaxDay]');
            set(ax(2),'XTick',[0:4:MaxDay]');
            set(ax(1),'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));
            set(ax(2),'XTickLabel','');
        end
    end
end
