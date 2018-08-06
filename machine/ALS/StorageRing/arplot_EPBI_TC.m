function arplot_EPBI_TC(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_EPBI_TC - Plots EPBI system thermocouple data from the ALS archiver
%  arplot_EPBI_TC(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLES
%  1. arplot_EPBI_TC('January',22:24,2009);
%     plots data from 1/22, 1/23, and 1/24 in 2009
%
%  2. arplot_EPBI_TC('January',28:31,2009,'February',1:4,2009);
%     plots data from the last 4 days in Jan. and the first 4 days in Feb.
%


% Inputs
if nargin < 2
    monthStr = 'November';
    days = 6;
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

arglobal

BooleanFlag = 0;

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
Temperatures = [];
dcct = [];
lcw = [];
EPU = [];
IDgap = [];

% Updated 2008-12-01 (GP - Visual inspection)
ChanNames = {
'SR04S___TCLL___AM01', 'Exit Flange Lower Left'
'SR04S___TCLR___AM03', 'Exit Flange Lower Right'
'SR04S___TCUL___AM00', 'Exit Flange Upper Left'
'SR04S___TCUR___AM02', 'Exit Flange Upper Right'
'SR04S___TCMLL__AM19', 'Mask Lower Left'
'SR04S___TCMLM__AM23', 'Mask Lower Center'
'SR04S___TCMLR__AM18', 'Mask Lower Right'
'SR04S___TCMUC__AM21', 'Mask Upper Chamber'
'SR04S___TCMUL__AM16', 'Mask Upper Left'
'SR04S___TCMUM__AM20', 'Mask Upper Center'
'SR04S___TCMUR__AM17', 'Mask Upper Right'
'SR04S___TCLB1__AM25', 'Bend 1-1 Lower'
'SR04S___TCLB2__AM05', 'Bend 1-2 Lower'
'SR04S___TCUB1__AM24', 'Bend 1-1 Upper'
'SR04S___TCUB2__AM04', 'Bend 1-2 Upper'
'SR04S___TCLQ___AM07', 'QFA Lower'
'SR04S___TCUQ___AM06', 'QFA Upper'
'SR04S___TCLSD__AM09', 'SF Lower'
'SR04S___TCUSD__AM08', 'SF Upper'
'SR04S___TCMLC__AM22', 'SR04 IG1 TO Aperture'
'SR05W___TCIDN0_AM03', 'ID Lower Upstream'
'SR05W___TCIDN1_AM04', 'ID Lower Middle'
'SR05W___TCIDN2_AM05', 'ID Lower Downstream'
'SR05W___TCIUP0_AM00', 'ID Upper Upstream'
'SR05W___TCIUP1_AM01', 'ID Upper Middle'
'SR05W___TCIUP2_AM02', 'ID Upper Downstream'
'SR05W___TCEFL0_AM06', 'Exit Flange Upper'
'SR05W___TCEFL1_AM07', 'Exit Flange Lower'
'SR05W___TCDN0__AM16', 'Lower 0'
'SR05W___TCDN1__AM17', 'Lower 1'
'SR05W___TCDN2__AM18', 'Lower 2'
'SR05W___TCDN3__AM19', 'Lower 3'
'SR05W___TCDN4__AM20', 'Lower 4'
'SR05W___TCDN5__AM21', 'Lower 5'
'SR05W___TCDN6__AM22', 'Lower 6'
'SR05W___TCDN7__AM23', 'Lower 7'
'SR05W___TCDN8__AM24', 'Lower 8'
'SR05W___TCUP0__AM00', 'Upper 0'
'SR05W___TCUP1__AM01', 'Upper 1'
'SR05W___TCUP2__AM02', 'Upper 2'
'SR05W___TCUP3__AM03', 'Upper 3'
'SR05W___TCUP4__AM04', 'Upper 4'
'SR05W___TCUP5__AM05', 'Upper 5'
'SR05W___TCUP6__AM06', 'Upper 6'
'SR05W___TCUP7__AM07', 'Upper 7'
'SR05W___TCUP8__AM08', 'Upper 8'
'SR05W___TCUP9__AM09', 'SR05 IG1 TO Aperture'
'SR06S___TCDN0__AM16', 'Lower 0'
'SR06S___TCDN1__AM17', 'Lower 1'
'SR06S___TCDN2__AM18', 'Lower 2'
'SR06S___TCDN3__AM19', 'Lower 3'
'SR06S___TCDN4__AM20', 'Lower 4'
'SR06S___TCDN5__AM21', 'Lower 5'
'SR06S___TCDN6__AM22', 'Lower 6'
'SR06S___TCDN7__AM23', 'Lower 7'
'SR06S___TCDN8__AM24', 'Lower 8'
'SR06S___TCUP0__AM00', 'Upper 0'
'SR06S___TCUP1__AM01', 'Upper 1'
'SR06S___TCUP2__AM02', 'Upper 2'
'SR06S___TCUP3__AM03', 'Upper 3'
'SR06S___TCUP4__AM04', 'Upper 4'
'SR06S___TCUP5__AM05', 'Upper 5'
'SR06S___TCUP6__AM06', 'Upper 6'
'SR06S___TCUP7__AM07', 'Upper 7'
'SR06S___TCUP8__AM08', 'Upper 8'
'SR06S___TCUP9__AM09', 'SR06 IG1 TO Aperture'
'SR07S___TCDN0__AM16', 'Lower 0'
'SR07S___TCDN1__AM17', 'Lower 1'
'SR07S___TCDN2__AM18', 'Lower 2'
'SR07S___TCDN3__AM19', 'Lower 3'
'SR07S___TCDN4__AM20', 'Lower 4'
'SR07S___TCDN5__AM21', 'Lower 5'
'SR07S___TCDN6__AM22', 'Lower 6'
'SR07S___TCDN7__AM23', 'Lower 7'
'SR07S___TCDN8__AM24', 'Lower 8'
'SR07S___TCUP0__AM00', 'Upper 0'
'SR07S___TCUP1__AM01', 'Upper 1'
'SR07S___TCUP2__AM02', 'Upper 2'
'SR07S___TCUP3__AM03', 'Upper 3'
'SR07S___TCUP4__AM04', 'Upper 4'
'SR07S___TCUP5__AM05', 'Upper 5'
'SR07S___TCUP6__AM06', 'Upper 6'
'SR07S___TCUP7__AM07', 'Upper 7'
'SR07S___TCUP8__AM08', 'Upper 8'
'SR07S___TCUP9__AM09', 'SR07 IG1 TO Aperture'
'SR08S___TCDN0__AM16', 'Lower 0'
'SR08S___TCDN1__AM17', 'Lower 1'
'SR08S___TCDN2__AM18', 'Lower 2'
'SR08S___TCDN3__AM19', 'Lower 3'
'SR08S___TCDN4__AM20', 'Lower 4'
'SR08S___TCDN5__AM21', 'Lower 5'
'SR08S___TCDN6__AM22', 'Lower 6'
'SR08S___TCDN7__AM23', 'Lower 7'
'SR08S___TCDN8__AM24', 'Lower 8'
'SR08S___TCUP0__AM00', 'Upper 0'
'SR08S___TCUP1__AM01', 'Upper 1'
'SR08S___TCUP2__AM02', 'Upper 2'
'SR08S___TCUP3__AM03', 'Upper 3'
'SR08S___TCUP4__AM04', 'Upper 4'
'SR08S___TCUP5__AM05', 'Upper 5'
'SR08S___TCUP6__AM06', 'Upper 6'
'SR08S___TCUP7__AM07', 'Upper 7'
'SR08S___TCUP8__AM08', 'Upper 8'
'SR08S___TCUP9__AM09', 'SR08 IG1 TO Aperture'
'SR09S___TCDN0__AM16', 'Lower 0'
'SR09S___TCDN1__AM17', 'Lower 1'
'SR09S___TCDN2__AM18', 'Lower 2'
'SR09S___TCDN3__AM19', 'Lower 3'
'SR09S___TCDN4__AM20', 'Lower 4'
'SR09S___TCDN5__AM21', 'Lower 5'
'SR09S___TCDN6__AM22', 'Lower 6'
'SR09S___TCDN7__AM23', 'Lower 7'
'SR09S___TCDN8__AM24', 'Lower 8'
'SR09S___TCUP0__AM00', 'Upper 0'
'SR09S___TCUP1__AM01', 'Upper 1'
'SR09S___TCUP2__AM02', 'Upper 2'
'SR09S___TCUP3__AM03', 'Upper 3'
'SR09S___TCUP4__AM04', 'Upper 4'
'SR09S___TCUP5__AM05', 'Upper 5'
'SR09S___TCUP6__AM06', 'Upper 6'
'SR09S___TCUP7__AM07', 'Upper 7'
'SR09S___TCUP8__AM08', 'Upper 8'
'SR09S___TCUP9__AM09', 'SR09 IG1 TO Aperture'
'SR10S___TCLL___AM01', 'Exit Flange Lower Left'
'SR10S___TCLR___AM03', 'Exit Flange Lower Right'
'SR10S___TCUL___AM00', 'Exit Flange Upper Left'
'SR10S___TCUR___AM02', 'Exit Flange Upper Right'
'SR10S___TCDN0__AM16', 'Lower 0'
'SR10S___TCDN1__AM17', 'Lower 1'
'SR10S___TCDN2__AM18', 'Lower 2'
'SR10S___TCDN3__AM19', 'Lower 3'
'SR10S___TCDN4__AM20', 'Lower 4'
'SR10S___TCDN5__AM21', 'Lower 5'
'SR10S___TCDN6__AM22', 'Lower 6'
'SR10S___TCDN7__AM23', 'Lower 7'
'SR10S___TCDN8__AM24', 'Lower 8'
'SR10S___TCUP0__AM00', 'Upper 0'
'SR10S___TCUP1__AM01', 'Upper 1'
'SR10S___TCUP2__AM02', 'Upper 2'
'SR10S___TCUP3__AM03', 'Upper 3'
'SR10S___TCUP4__AM04', 'Upper 4'
'SR10S___TCUP5__AM05', 'Upper 5'
'SR10S___TCUP6__AM06', 'Upper 6'
'SR10S___TCUP7__AM07', 'Upper 7'
'SR10S___TCUP8__AM08', 'Upper 8'
'SR10S___TCUP9__AM09', 'SR10 IG1 TO Aperture'
'SR11S___TCMLL__AM07', 'ID Mask Lower Upstream'
'SR11S___TCMLR__AM06', 'ID Mask Upper Downstream'
'SR11S___TCMUL__AM04', 'ID Mask Upper Upstream'
'SR11S___TCMUR__AM05', 'ID Mask Upper Middle'
'SR11S___TCDN0__AM16', 'Lower 0'
'SR11S___TCDN1__AM17', 'Lower 1'
'SR11S___TCDN2__AM18', 'Lower 2'
'SR11S___TCDN3__AM19', 'Lower 3'
'SR11S___TCDN4__AM20', 'Lower 4'
'SR11S___TCDN5__AM21', 'Lower 5'
'SR11S___TCDN6__AM22', 'Lower 6'
'SR11S___TCDN7__AM23', 'Lower 7'
'SR11S___TCDN8__AM24', 'Lower 8'
'SR11S___TCUP0__AM00', 'Upper 0'
'SR11S___TCUP1__AM01', 'Upper 1'
'SR11S___TCUP2__AM02', 'Upper 2'
'SR11S___TCUP3__AM03', 'Upper 3'
'SR11S___TCUP4__AM04', 'Upper 4'
'SR11S___TCUP5__AM05', 'Upper 5'
'SR11S___TCUP6__AM06', 'Upper 6'
'SR11S___TCUP7__AM07', 'Upper 7'
'SR11S___TCUP8__AM08', 'Upper 8'
'SR11S___TCUP9__AM09', 'SR11 IG1 TO Aperture'
'SR12S___TCDN0__AM16', 'Lower 0'
'SR12S___TCDN1__AM17', 'Lower 1'
'SR12S___TCDN2__AM18', 'Lower 2'
'SR12S___TCDN3__AM19', 'Lower 3'
'SR12S___TCDN4__AM20', 'Lower 4'
'SR12S___TCDN5__AM21', 'Lower 5'
'SR12S___TCDN6__AM22', 'Lower 6'
'SR12S___TCDN7__AM23', 'Lower 7'
'SR12S___TCDN8__AM24', 'Lower 8'
'SR12S___TCUP0__AM00', 'Upper 0'
'SR12S___TCUP1__AM01', 'Upper 1'
'SR12S___TCUP2__AM02', 'Upper 2'
'SR12S___TCUP3__AM03', 'Upper 3'
'SR12S___TCUP4__AM04', 'Upper 4'
'SR12S___TCUP5__AM05', 'Upper 5'
'SR12S___TCUP6__AM06', 'Upper 6'
'SR12S___TCUP7__AM07', 'Upper 7'
'SR12S___TCUP8__AM08', 'Upper 8'
'SR12S___TCUP9__AM09', 'SR12C IG1 TO Aperture'
};


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
    Temperatures = [Temperatures arselect(cell2mat(ChanNames(:,1)))];
    
    dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
    lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
    
    EPUChan = family2channel('EPU','Monitor');
    if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
        [tmp, i] = ismember('SR11U___ODS2PS_AM00', EPUChan, 'rows');
        EPUChan(i,:) = []; % remove it because it probably already in the list 'SR11U___ODS1PS_AM00';
    end
    if day == 1
        [EPU, iEPU, iNotFound] = arselect(EPUChan);
        EPU(iNotFound,:) = [];
    else
        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];
    end
    EPULegend = mat2cell(ARChanNames(iEPU,3:4), ones(length(iEPU),1), 2);
    EPULegend = strcat(EPULegend,'EPU');
    EPULegend = strcat(EPULegend,ARChanNames(iEPU,12));
    
    % ID vertical gap
    IDlist = family2dev('ID');
    if day == 1
        [IDgap, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        IDgap(iNotFound,:) = [];
        IDlist(iNotFound,:) = [];
    else
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];
        IDlist(iNotFound,:) = [];
    end
    IDLegend = mat2cell(ARChanNames(iIDgap,3:5),ones(length(iIDgap),1),3);
    IDLegend = strcat(IDLegend,ARChanNames(iIDgap,12));

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
        Temperatures = [Temperatures arselect(cell2mat(ChanNames(:,1)))];
        
        dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
        
        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];
        
        % ID vertical gap
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    % SR04
    ChanNamesIndex = strmatch('SR04',cell2mat(ChanNames(:,1)));
    figure;
    clf reset
    %subfig(1,1,1,h);

    subplot(3,1,1);
    [ax, h1, h2] = plotyy(t, [Temperatures(ChanNamesIndex(1:end-1),:); lcw], t, Temperatures(ChanNamesIndex(end,:)));
    %plotyy(t, [Temperatures(strmatch('SR04',cell2mat(ChanNames(:,1))),:); lcw]);
    legend([ChanNames(ChanNamesIndex(1:end-1),2); 'LCW Temp'; ChanNames(ChanNamesIndex(end))]);
    axes(ax(1));
    xaxis([0 MaxTime]);
    % set(ax(1),'YTick',[0 100 200 300 400 500]);
    % axis([0 xmax 0 550]);
    axes(ax(2));
    xaxis([0 MaxTime]);
    title(['SR04 EPBI TC temps  ',titleStr]);

    set(h2,'Marker','.');
    set(get(ax(1),'Ylabel'), 'String', 'TC Temps [degF]');
    set(get(ax(2),'Ylabel'), 'String', 'IG1 TC Temp [degF]', 'Color', 'k');
    grid on;


    subplot(3,1,2);
    plot(t, dcct*100)
    ylabel('DCCT [mA]')
    xaxis([0 MaxTime]);
    subplot(3,1,3);
    plot(t, IDgap(1:2,:))
    ylabel('EPU4-1 and 4-2 Gaps [mm]')
    %[ax, h1, h2] = plotyy(t, [dcct; lcw], t, IDgap(1:2,:));
    xaxis([0 MaxTime]);
    grid on;
    ChangeAxesLabel(t, Days, DayFlag);
    %ylabel('Degrees [F]');

    %set(h,'interpreter','none');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SR04
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR04',cell2mat(ChanNames(:,1))),:); lcw; IDgap(1:2,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR04 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR04',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; 'EPU4-1 Gap'; 'EPU 4-2 Gap']);
%set(h,'interpreter','none');


% SR05
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR05',cell2mat(ChanNames(:,1))),:); lcw; IDgap(3,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR05 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR05',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '5W Gap']);
%set(h,'interpreter','none');


% SR06
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR06',cell2mat(ChanNames(:,1))),:); lcw; IDgap(4,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR06 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR06',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; 'IVID Gap']);
%set(h,'interpreter','none');


% SR07
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR07',cell2mat(ChanNames(:,1))),:); lcw; IDgap(5,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR07 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR07',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '7U Gap']);
%set(h,'interpreter','none');


% SR08
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR08',cell2mat(ChanNames(:,1))),:); lcw; IDgap(6,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR08 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR08',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '8U Gap']);
%set(h,'interpreter','none');


% SR09
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR09',cell2mat(ChanNames(:,1))),:); lcw; IDgap(7,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR09 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR09',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '9U Gap']);
%set(h,'interpreter','none');


% SR10
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR10',cell2mat(ChanNames(:,1))),:); lcw; IDgap(8,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR10 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR10',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '10U Gap']);
%set(h,'interpreter','none');


% SR11
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR11',cell2mat(ChanNames(:,1))),:); lcw; IDgap(9:10,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR11 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR11',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; 'EPU11-1 Gap'; 'EPU11-2 Gap']);
%set(h,'interpreter','none');


% SR12
h = figure;
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, [Temperatures(strmatch('SR12',cell2mat(ChanNames(:,1))),:); lcw; IDgap(11,:)]);
xaxis([0 MaxTime]);
grid on;
title(['SR12 EPBI TC temps  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [F]');
h=legend([ChanNames(strmatch('SR12',cell2mat(ChanNames(:,1))),2); 'LCW Temp'; '12U Gap']);
%set(h,'interpreter','none');


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
