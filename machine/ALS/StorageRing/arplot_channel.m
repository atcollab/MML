


function [data, t, i] = arplot_channel(channel,monthStr, days, year1, month2Str, days2, year2)
% [data, t] = arplot_channel(channel,Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots diagnostic beamlines 3.1 and 7.2 archived data.
% Only plots data when feed forward is on.
%
% Example #1:  arplot_sr('January',22:24,1998);
%              plots data from 1/22, 1/23, and 1/24 in 1998
%
% Example #2:  arplot_sr('January',28:31,1998,'February',1:4,1998);
%              plots data from the last 4 days in Jan. and the first 4 days in Feb.

% original arplot code: Greg Portmann, 1999
%
% modified by C. Steier, 2001; modified by T. Scarvie, 2002
%
% insert note about how Chris's BL31 averaging works


% alsglobe
%
%
% % check whether alsinit was run
% if isempty(IDXoffset) | isempty(IDXoffset) | isempty(IDXgolden) | isempty(IDXgolden)
%    disp('  Run alsvars (or alsinit) before running this function.');
%    return
% end

BooleanFlag = 0;

semilogy_plotflag = 0;

% Inputs
if nargin < 3
    error('ARPLOTS:  You need at least three input arguments.');
elseif nargin == 3
    tmp = clock;
    year1 = tmp(1);
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 4
    monthStr2 = [];
    days2 = [];
    year2 = [];
elseif nargin == 5
    error('ARPLOTS:  You need 3, 4, 6, or 7 input arguments.');
elseif nargin == 6
    tmp = clock;
    year2 = tmp(1);
elseif nargin == 7
else
    error('ARPLOTS:  Inputs incorrect.');
end


arglobal


t=[];

dcct=[];
lifetime=[];
gev=[];

data = [];

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
    try
        year1str = num2str(year1);
        if year1 < 2000
            year1str = year1str(3:4);
            FileName = sprintf('%2s%02d%02d', year1str, month, day);
        else
            FileName = sprintf('%4s%02d%02d', year1str, month, day);
        end
        arread(FileName, BooleanFlag);

        [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
        dcct = [dcct y1];

        [y1, igev] = arselect('cmm:sr_energy');
        gev = [gev y1];

        [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
        lifetime = [lifetime  y1];

        [y1, i] = arselect(channel);
        data=[data y1];

        t = [t  ARt+(day-StartDay)*24*60*60];

    catch
        fprintf('  Error reading archived data file.\n');
        fprintf('  %s will be ignored.\n', FileName);
    end

    disp(' ');
end


if ~isempty(days2)

    StartDay = days2(1);
    EndDay = days2(length(days2));

    for day = days2
        try
            year2str = num2str(year2);
            if year2 < 2000
                year2str = year2str(3:4);
                FileName = sprintf('%2s%02d%02d', year2str, month2, day);
            else
                FileName = sprintf('%4s%02d%02d', year2str, month2, day);
            end
            arread(FileName, BooleanFlag);

            [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
            dcct = [dcct y1];

            [y1, igev] = arselect('cmm:sr_energy');
            gev = [gev y1];

            [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
            lifetime = [lifetime  y1];

            [y1, i] = arselect(channel);
            data=[data y1];

            t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];

        catch
            fprintf('  Error reading archived data file.\n');
            fprintf('  %s will be ignored.\n', FileName);
        end

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


% plot
figure; clf;
if semilogy_plotflag
    semilogy(t, data); grid on;
else
    plot(t, data); grid on;
end
axis tight;
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
k = find(ARChanNames(i,:)=='_');
titlestr = ARChanNames(i,:);
titlestr(k) = ' ';
legend(titlestr);

orient tall


return

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
        %set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));
        set(gca,'XTickLabel',XTickLabelString(1:2:end,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:end,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end,:));
    end
end
