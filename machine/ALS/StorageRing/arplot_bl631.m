function arplot_bl631(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_BL631 - Plots various performance data from the ALS archiver
%  arplot_bl631(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLES
%  1. arplot_bl631('January',22:24,1998);
%     plots data from 1/22, 1/23, and 1/24 in 1998
%
%  2. arplot_bl631('January',28:31,1998,'February',1:4,1998);
%     plots data from the last 4 days in Jan. and the first 4 days in Feb.
%
%  See also arplot_sr, arplot_sbm

% Written by Greg Portmann


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

BPMlist = getbpmlist('bergoz');
BPMxNames = family2channel('BPMx',BPMlist);
BPMyNames = family2channel('BPMy',BPMlist);
BPMxPos = getspos('BPMx',BPMlist);
BPMyPos = getspos('BPMy',BPMlist);
BPMxGolden = getgolden('BPMx',BPMlist);
BPMyGolden = getgolden('BPMy',BPMlist);

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
EndDay   = days(length(days));

t = [];
LCW = [];
DCCT = [];
BPMx = [];
BPMy = [];
UserBeam = [];
B0631_PSS1_OPN = [];
B0632_PSS1_OPN = [];


% Get data from archiver

% Month 1
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    try
        arread(FileName, 1);
        
        %DCCT = [DCCT arselect('SR05S___DCCTLP_AM01')];
        DCCT = [DCCT arselect('cmm:beam_current')];
        LCW  = [LCW  arselect('SR03S___LCWTMP_AM00')];
        
        % All Bergoz BPMs
        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];
        
        % Beamline shutters
        UserBeam = [UserBeam arselect('sr:UserBeam')];
        B0631_PSS1_OPN = [B0631_PSS1_OPN arselect('B0631_PSS1_OPN')];
        B0632_PSS1_OPN = [B0632_PSS1_OPN arselect('B0632_PSS1_OPN')];
        
        % time vector
        t = [t  ARt+(day-StartDay)*24*60*60];
    catch
        fprintf(2, '%s not found', FileName);
    end
end


% Month 2
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
        
        try
            arread(FileName, 1);
            
            %DCCT = [DCCT arselect('SR05S___DCCTLP_AM01')];
            DCCT = [DCCT arselect('cmm:beam_current')];
            LCW  = [LCW  arselect('SR03S___LCWTMP_AM00')];
            
            % All Bergoz BPMs
            BPMx = [BPMx arselect(BPMxNames)];
            BPMy = [BPMy arselect(BPMyNames)];
            
            % Beamline shutters
            UserBeam = [UserBeam arselect('sr:UserBeam')];
            B0631_PSS1_OPN = [B0631_PSS1_OPN arselect('B0631_PSS1_OPN')];
            B0632_PSS1_OPN = [B0632_PSS1_OPN arselect('B0632_PSS1_OPN')];
            
            % time vector
            %       t = [t  ARt+(day-StartDay)*24*60*60];
            t = [t  ARt+(day-StartDay+(days(end)-days(1)+1))*24*60*60];
        catch
            fprintf(2, '%s not found', FileName);
        end
    end
end


%%%%%%%%%%%%%%%%%%
% Condition Data %
%%%%%%%%%%%%%%%%%%

%DCCT = 100*DCCT;

% Remove points for low current
[y, i] = find(DCCT < 300);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
DCCT(i)   = NaN;
LCW(i)    = NaN;

[y, i] = find(UserBeam==0);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
DCCT(i)   = NaN;
LCW(i)    = NaN;

[y, i] = find(B0631_PSS1_OPN==0);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
DCCT(i)   = NaN;
LCW(i)    = NaN;

%[y, i] = find(B0632_PSS1_OPN==0);
%BPMx(:,i) = NaN;
%BPMy(:,i) = NaN;


% Remove points after a NaN (based on BPMx, which is filtered to NaN during fills...)
% [y, i]=find(isnan(BPMx(1,:)));
% i = i + 1;
% if ~isempty(i)
%     if i(end) > size(BPMx,2)
%         i = i(1:end-1);
%     end
% end


%  x-axis
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


% filter BL shutters: change NaN's to zeros (NaN + number is always NaN)
%B0631_PSS1_OPN(:,find(isnan(B0631_PSS1_OPN)))=0;
%B0631_PSS1_OPN(:,find(B0631_PSS1_OPN>1))=0;

FontSize = 10;

%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%
FigNum = 10;

FigNum = FigNum + 1;
h = figure(FigNum);
%subfig(1,1,1, h);
clf reset;

ha = subplot(2,1,1);
plot(t, DCCT);
ylabel('Beam Current [mA]', 'Fontsize', FontSize);
axis tight;
ChangeAxesLabel(t, Days, DayFlag);
title([' ',titleStr], 'Fontsize', FontSize+2);
%set(gca,'XTickLabel','');


ha(length(ha)+1) = subplot(2,1,2);
plot(t, B0631_PSS1_OPN);
ylabel('BL631 Shutter', 'Fontsize', FontSize);
axis tight;
yaxis([-.1 1.1]);
%xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);


%%%%%%%%%%%%%%%
% Orbit Plots %
%%%%%%%%%%%%%%%

for i = 1:size(BPMx,2)
    BPMx(:,i) = BPMx(:,i) - BPMxGolden;
    BPMy(:,i) = BPMy(:,i) - BPMyGolden;
end


FigNum = FigNum + 1;
h = figure(FigNum);
clf reset;

i = findrowindex([6 5], BPMlist);
BPMxNames(i,:)
ha(length(ha)+1) = subplot(2,1,1);
plot(t, 1000 * BPMx(i,:));
ylabel('BPMx(6,4) [\mum]', 'Fontsize', FontSize);
title(['Horizontal Orbit: ',titleStr], 'Fontsize', FontSize+2);
axis tight;
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');

i = findrowindex([6 6], BPMlist);
BPMxNames(i,:)
ha(length(ha)+1) = subplot(2,1,2);
plot(t, 1000 * BPMx(i,:));
ylabel('BPMx(6,5) [\mum]', 'Fontsize', FontSize);
axis tight;
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');
xlabel(xlabelstring);

FigNum = FigNum + 1;
h = figure(FigNum);
clf reset;

i = findrowindex([6 5], BPMlist);
BPMyNames(i,:)
ha(length(ha)+1) = subplot(2,1,1);
plot(t, 1000 * BPMy(i,:));
ylabel('BPMy(6,4) [\mum]', 'Fontsize', FontSize);
title(['Vetical Orbit: ',titleStr], 'Fontsize', FontSize+2);
axis tight;
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');

i = findrowindex([6 6], BPMlist);
BPMyNames(i,:)
ha(length(ha)+1) = subplot(2,1,2);
plot(t, 1000 * BPMy(i,:));
ylabel('BPMy(6,5) [\mum]', 'Fontsize', FontSize);
axis tight;
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');
xlabel(xlabelstring);


linkaxes(ha, 'x');



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
