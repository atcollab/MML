function arplot_bts(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_BTS - Plots various performance data from the ALS archiver for the BTS line
%  arplot_bts(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  Plots a whole bunch of BTS related archived data.


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


BooleanFlag = 1;

arglobal

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
Qam = [];
Bam = [];
Qac = [];
Bac = [];
HCMam = [];
VCMam = [];
HCMac = [];
VCMac = [];
BPMxm  = [];
BPMym  = [];
TVin  = [];
TVout  = [];
TVmon  = [];


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
    t = [t  ARt+(day-StartDay)*24*60*60];
    
    % Add Channels Here (and below)
    QamName = family2channel('Q');
    QacName = family2channel('Q','Setpoint');
    BamName = family2channel('BEND');
    BacName = family2channel('BEND','Setpoint');
    HCMamName = family2channel('HCM');
    HCMacName = family2channel('HCM','Setpoint');
    VCMamName = family2channel('VCM');
    VCMacName = family2channel('VCM','Setpoint');
    BPMxmName = family2channel('BPMx');
    BPMymName = family2channel('BPMy');
    TVinName = family2channel('TV','In');
    TVoutName = family2channel('TV','Out');
    TVmonName = family2channel('TV','Monitor');
    
    Qam = [Qam arselect(QamName)];
    Qac = [Qac arselect(QacName)];
    Bam = [Bam arselect(BamName)];
    Bac = [Bac arselect(BacName)];
    HCMam = [HCMam arselect(HCMamName)];
    HCMac = [HCMac arselect(HCMacName)];
    VCMam = [VCMam arselect(VCMamName)];
    VCMac = [VCMac arselect(VCMacName)];
    BPMxm = [BPMxm arselect(BPMxmName)];
    BPMym = [BPMym arselect(BPMymName)];
    TVin = [TVin arselect(TVinName)];
    TVout = [TVout arselect(TVoutName)];
    TVmon = [TVmon arselect(TVmonName)];
    
    
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


        % Add Channels Here
        QamName = family2channel('Q');
        QacName = family2channel('Q','Setpoint');
        BamName = family2channel('BEND');
        BacName = family2channel('BEND','Setpoint');
        HCMamName = family2channel('HCM');
        HCMacName = family2channel('HCM','Setpoint');
        VCMamName = family2channel('VCM');
        VCMacName = family2channel('VCM','Setpoint');
        BPMxmName = family2channel('BPMx');
        BPMymName = family2channel('BPMy');
        TVinName = family2channel('TV','In');
        TVoutName = family2channel('TV','Out');
        TVmonName = family2channel('TV','Monitor');
    
        Qam = [Qam arselect(QamName)];
        Qac = [Qac arselect(QacName)];
        Bam = [Bam arselect(BamName)];
        Bac = [Bac arselect(BacName)];
        HCMam = [HCMam arselect(HCMamName)];
        HCMac = [HCMac arselect(HCMacName)];
        VCMam = [VCMam arselect(VCMamName)];
        VCMac = [VCMac arselect(VCMacName)];
        BPMxm = [BPMxm arselect(BPMxmName)];
        BPMym = [BPMym arselect(BPMymName)];
        TVin = [TVin arselect(TVinName)];
        TVout = [TVout arselect(TVoutName)];
        TVmon = [TVmon arselect(TVmonName)];


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


h=figure(1);
clf reset
subfig(1,1,1,h);


h = subplot(11,1,1);
plot(t, Qam(1,:),t, Qac(1,:));
xaxis([0 MaxTime]);
yaxis([40 70]);
grid on;
title(['Quadrupoles [Amps]  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q1');
%h=legend(QamName(1,:));
%set(h,'interpreter','none');

h(2) = subplot(11,1,2);
plot(t, Qam(2,:),t, Qac(2,:));
xaxis([0 MaxTime]);
yaxis([0 30]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q2.1');
%h=legend(QamName(2:3,:));
%set(h,'interpreter','none');

h(3) = subplot(11,1,3);
plot(t, Qam(3,:),t, Qac(3,:));
xaxis([0 MaxTime]);
yaxis([0 20]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q2.2');

h(4) = subplot(11,1,4);
plot(t, Qam(4,:),t, Qac(4,:));
xaxis([0 MaxTime]);
yaxis([0 30]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q3.1');
%h=legend(QamName(4:5,:));
%set(h,'interpreter','none');

h(5) = subplot(11,1,5);
plot(t, Qam(5,:),t, Qac(5,:));
xaxis([0 MaxTime]);
yaxis([40 80]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q3.2');

h(6) = subplot(11,1,6);
plot(t, Qam(6,:),t, Qac(6,:));
xaxis([0 MaxTime]);
yaxis([60 90]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q4');
%h=legend(QamName(6,:));
%set(h,'interpreter','none');

h(7) = subplot(11,1,7);
plot(t, Qam(7,:),t, Qac(7,:));
xaxis([0 MaxTime]);
yaxis([70 100]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q5.1');
%h=legend(QamName(7:8,:));
%set(h,'interpreter','none');

h(8) = subplot(11,1,8);
plot(t, Qam(8,:),t, Qac(8,:));
xaxis([0 MaxTime]);
yaxis([80 110]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q5.2');

h(9) = subplot(11,1,9);
plot(t, Qam(9,:),t, Qac(9,:));
xaxis([0 MaxTime]);
yaxis([45 75]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q6.1');
%h=legend(QamName(9:10,:));
%set(h,'interpreter','none');

h(10) = subplot(11,1,10);
plot(t, Qam(10,:),t, Qac(10,:));
xaxis([0 MaxTime]);
yaxis([60 90]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel',''); 
ylabel('Q6.2');

h(11) = subplot(11,1,11);
plot(t, Qam(11,:));
xaxis([0 MaxTime]);
yaxis([40 70]);
grid on;
%title(['Quadrupoles: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
ylabel('Q7');
%h=legend(QamName(11,:));
%set(h,'interpreter','none');

yaxesposition(1.20);
linkaxes(h, 'x');
orient tall;


h=figure(2);
clf reset
subfig(1,1,1,h); 

subplot(4,1,1);
plot(t, Bam(1,:),t, Bac(1,:));
xaxis([0 MaxTime]);
yaxis([610 810]);
grid on;
title(['BEND [Amps]  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
%xlabel(xlabelstring);
ylabel('B1');
%h=legend(BamName(1,:));
%set(h,'interpreter','none');

subplot(4,1,2);
plot(t, Bam(2,:),t, Bac(2,:));
xaxis([0 MaxTime]);
yaxis([610 820]);
grid on;
%title(['Bends: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
%xlabel(xlabelstring);
ylabel('B2');
%h=legend(BamName(2,:));
%set(h,'interpreter','none');

subplot(4,1,3);
plot(t, Bam(3,:),t, Bac(3,:));
xaxis([0 MaxTime]);
yaxis([610 820]);
grid on;
%title(['Bends: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
%xlabel(xlabelstring);
ylabel('B3');
%h=legend(BamName(3,:));
%set(h,'interpreter','none');

subplot(4,1,4);
plot(t, Bam(4,:),t, Bac(4,:));
xaxis([0 MaxTime]);
yaxis([565 750]);
grid on;
%title(['Bends: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
ylabel('B4');
%h=legend(BamName(4,:));
%set(h,'interpreter','none');

orient tall;


h=figure(3);
clf reset
subfig(1,1,1,h); 

subplot(9,1,1);
plot(t, HCMam(1,:),t, HCMac(1,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
title(['HCM Family [Amps]  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM1');

subplot(9,1,2);
plot(t, HCMam(2,:),t, HCMac(2,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM2');

subplot(9,1,3);
plot(t, HCMam(3,:),t, HCMac(3,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM3');

subplot(9,1,4);
plot(t, HCMam(4,:),t, HCMac(4,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM4');

subplot(9,1,5);
plot(t, HCMam(5,:),t, HCMac(5,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM5');

subplot(9,1,6);
plot(t, HCMam(6,:),t, HCMac(6,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM6');

subplot(9,1,7);
plot(t, HCMam(7,:),t, HCMac(7,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM7');

subplot(9,1,8);
plot(t, HCMam(8,:),t, HCMac(8,:));
xaxis([0 MaxTime]);
yaxis([-4 4]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('HCM8');

subplot(9,1,9);
plot(t, HCMam(9,:),t, HCMac(9,:));
xaxis([0 MaxTime]);
yaxis([-4 4]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('HCM9');
xlabel(xlabelstring);

yaxesposition(1.20);



h=figure(4);
clf reset
subfig(1,1,1,h); 

subplot(9,1,1);
plot(t, VCMam(1,:),t, VCMac(1,:));
xaxis([0 MaxTime]);
yaxis([-2 2]);
grid on;
title(['VCM Family [Amps] ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM1');

subplot(9,1,2);
plot(t, VCMam(2,:),t, VCMac(2,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM2');

subplot(9,1,3);
plot(t, VCMam(3,:),t, VCMac(3,:));
xaxis([0 MaxTime]);
yaxis([-2 2]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM3');

subplot(9,1,4);
plot(t, VCMam(4,:),t, VCMac(4,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM4');

subplot(9,1,5);
plot(t, VCMam(5,:),t, VCMac(5,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM5');

subplot(9,1,6);
plot(t, VCMam(6,:),t, VCMac(6,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM6');

subplot(9,1,7);
plot(t, VCMam(7,:),t, VCMac(7,:));
xaxis([0 MaxTime]);
yaxis([-1 1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM7');

subplot(9,1,8);
plot(t, VCMam(8,:),t, VCMac(8,:));
xaxis([0 MaxTime]);
yaxis([0 2]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
ylabel('VCM8');

subplot(9,1,9);
plot(t, VCMam(9,:),t, VCMac(9,:));
xaxis([0 MaxTime]);
yaxis([0 2]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('VCM9');
xlabel(xlabelstring);

yaxesposition(1.20);


h=figure(5);
clf reset
subfig(1,1,1,h); 

subplot(6,1,1);
plot(t, BPMxm(1,:));
xaxis([0 MaxTime]);
grid on;
title(['BPMx [Amps]  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx1');

subplot(6,1,2);
plot(t, BPMxm(2,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx2');

subplot(6,1,3);
plot(t, BPMxm(3,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx3');

subplot(6,1,4);
plot(t, BPMxm(4,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx4');

subplot(6,1,5);
plot(t, BPMxm(5,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx5');

subplot(6,1,6);
plot(t, BPMxm(6,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMx6');
xlabel(xlabelstring);



h=figure(6);
clf reset
subfig(1,1,1,h); 

subplot(6,1,1);
plot(t, BPMym(1,:));
xaxis([0 MaxTime]);
grid on;
title(['BPMy [Amps]  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy1');

subplot(6,1,2);
plot(t, BPMym(2,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy2');

subplot(6,1,3);
plot(t, BPMym(3,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy3');

subplot(6,1,4);
plot(t, BPMym(4,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy4');

subplot(6,1,5);
plot(t, BPMym(5,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy5');

subplot(6,1,6);
plot(t, BPMym(6,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('BPMy6');
xlabel(xlabelstring);



h=figure(7);
clf reset
subfig(1,1,1,h); 

subplot(2,1,1);
plot(t, TVin);
xaxis([0 MaxTime]);
grid on;
title(['TV Paddle  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('TVin');
h=legend(TVinName);
set(h,'interpreter','none');
yaxis([-.2 1.2]);

subplot(2,1,2);
plot(t, TVout);
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
ylabel('TVout');
h=legend(TVoutName);
set(h,'interpreter','none');
yaxis([-.2 1.2]);


h=figure(8);
clf reset
subfig(1,1,1,h); 

subplot(1,1,1);
plot(t, TVmon);
xaxis([0 MaxTime]);
grid on;
title(['TVmon  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
ylabel(TVmon');
h=legend(TVmonName);
set(h,'interpreter','none');
yaxis([-.2 1.2]);





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
