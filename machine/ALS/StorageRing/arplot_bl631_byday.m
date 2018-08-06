function arplot_bl631_byday(Days)
%ARPLOT_BL631 - Plots various performance data from the ALS archiver
%  arplot_bl631_byday(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLES
%  1. arplot_bl631_byday('January',22:24,1998);
%     plots data from 1/22, 1/23, and 1/24 in 1998
%
%  2. arplot_bl631_byday('January',28:31,1998,'February',1:4,1998);
%     plots data from the last 4 Days in Jan. and the first 4 Days in Feb.
%
%  See also arplot_sr, arplot_sbm

% Written by Greg Portmann


% Inputs
% if nargin < 2
%     error('ARPLOTS:  You need at least two input arguments.');
% elseif nargin == 2
%     tmp = clock;
%     year1 = tmp(1);
%     monthStr2 = [];
%     Days2 = [];
%     year2 = [];
% elseif nargin == 3
%     monthStr2 = [];
%     Days2 = [];
%     year2 = [];
% elseif nargin == 4
%     error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
% elseif nargin == 5
%     tmp = clock;
%     year2 = tmp(1);
% elseif nargin == 6
% else
%     error('ARPLOTS:  Inputs incorrect.');
% end

if 0
    % Get data
    arglobal
    
    BPMlist = getbpmlist('bergoz');
    BPMxNames = family2channel('BPMx',BPMlist);
    BPMyNames = family2channel('BPMy',BPMlist);
    BPMxPos = getspos('BPMx',BPMlist);
    BPMyPos = getspos('BPMy',BPMlist);
    BPMxGolden = getgolden('BPMx',BPMlist);
    BPMyGolden = getgolden('BPMy',BPMlist);
    
    t = [];
    LCW = [];
    DCCT = [];
    BPMx = [];
    BPMy = [];
    UserBeam = [];
    B0631_PSS1_OPN = [];
    B0632_PSS1_OPN = [];
    
    dnum_start = datenum(2013,1,1);
    DayVec = 1:365;
    
    DaysOfTheYear = [];
    
    % Get data from archiver
    for i = 1:length(DayVec)
        [Year, Month, Day] = datevec(dnum_start+DayVec(i)-1);
        
        DaysOfTheYear = [DaysOfTheYear Day];
        
        if Year < 2000
            FileName = sprintf('%2d%02d%02d', Year-2000, Month, Day);
        else
            FileName = sprintf('%4d%02d%02d', Year, Month, Day);
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
            %UserBeam = [UserBeam arselect('sr:UserBeam')];
            B0631_PSS1_OPN = [B0631_PSS1_OPN arselect('B0631_PSS1_OPN')];
            B0632_PSS1_OPN = [B0632_PSS1_OPN arselect('B0632_PSS1_OPN')];
            
            % time vector
            t = [t  ARt+(DayVec(i)-DayVec(1))*24*60*60];
            
        catch
            fprintf(2, 'Error while processing %s\n', FileName);
            t = [t  (.5+DayVec(i)-DayVec(1))*24*60*60];
            LCW  = [LCW  NaN];
            DCCT = [DCCT NaN];
            BPMx = [BPMx NaN*ones(size(BPMx,1),1)];
            BPMy = [BPMy NaN*ones(size(BPMy,1),1)];
            UserBeam = [UserBeam NaN];
            B0631_PSS1_OPN = [B0631_PSS1_OPN NaN];
            B0632_PSS1_OPN = [B0632_PSS1_OPN NaN];
        end
    end
    
    save bl631_2013
    
else
    % plot data
    load bl631_2013
end


%%%%%%%%%%%%%%%%%%
% Condition Data %
%%%%%%%%%%%%%%%%%%

%DCCT = 100*DCCT;

% Remove points for low current
[y, i] = find(DCCT < 200);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
DCCT(i)   = NaN;
% LCW(i)    = NaN;

% [y, i] = find(UserBeam==0);
% BPMx(:,i) = NaN;
% BPMy(:,i) = NaN;
% DCCT(i)   = NaN;
% LCW(i)    = NaN;

[y, i] = find(B0631_PSS1_OPN==0);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
DCCT(i)   = NaN;
% LCW(i)    = NaN;

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
DayFlag = 1;
[Year, Month, Day] = datevec(dnum_start);
TitleStr = sprintf('Starting %s', datestr(dnum_start,1));
t = t/60/60/24;
xlabelstring = sprintf('Day of the Year in %d', Year);
%xlabelstring = ['Date since ', StartDaystr, ' [Days]'];

%t = t/60/60;
%xlabelstring = ['Time since ', StartDaystr, ' [Hours]'];
%DayFlag = 0;



%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%
FontSize = 12;
FigNum = 10;

FigNum = FigNum + 1;
h = figure(FigNum);
%subfig(1,1,1, h);
clf reset;

ha = subplot(3,1,1);
plot(t, DCCT);
ylabel('Beam Current [mA]', 'Fontsize', FontSize);
%axis tight;
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
title([' ',TitleStr], 'Fontsize', FontSize+2);
%set(gca,'XTickLabel','');

ha(length(ha)+1) = subplot(3,1,2);
plot(t, LCW);
ylabel('LCW', 'Fontsize', FontSize);
%axis tight;
yaxis([19 25]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);

ha(length(ha)+1) = subplot(3,1,3);
plot(t, B0631_PSS1_OPN);
ylabel('BL631 Shutter', 'Fontsize', FontSize);
%axis tight;
yaxis([-.1 1.1]);
%xaxis([0 xmax]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
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
ylabel('BPMx(6,5) [\mum]', 'Fontsize', FontSize);
title(['Horizontal Orbit: ',TitleStr], 'Fontsize', FontSize+2);
%axis tight;
yaxis([-125 100]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
%set(gca,'XTickLabel','');

i = findrowindex([6 6], BPMlist);
BPMxNames(i,:)
ha(length(ha)+1) = subplot(2,1,2);
plot(t, 1000 * BPMx(i,:));
ylabel('BPMx(6,6) [\mum]', 'Fontsize', FontSize);
%axis tight;
yaxis([-75 125]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
%set(gca,'XTickLabel','');
xlabel(xlabelstring);

FigNum = FigNum + 1;
h = figure(FigNum);
clf reset;

i = findrowindex([6 5], BPMlist);
BPMyNames(i,:)
ha(length(ha)+1) = subplot(2,1,1);
plot(t, 1000 * BPMy(i,:));
ylabel('BPMy(6,5) [\mum]', 'Fontsize', FontSize);
title(['Vetical Orbit: ',TitleStr], 'Fontsize', FontSize+2);
%axis tight;
yaxis([-200 200]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
%set(gca,'XTickLabel','');

i = findrowindex([6 6], BPMlist);
BPMyNames(i,:)
ha(length(ha)+1) = subplot(2,1,2);
plot(t, 1000 * BPMy(i,:));
ylabel('BPMy(6,6) [\mum]', 'Fontsize', FontSize);
%axis tight;
yaxis([-50 150]);
%ChangeAxesLabel(t, DaysOfTheYear, DayFlag);
%set(gca,'XTickLabel','');
xlabel(xlabelstring);


linkaxes(ha, 'x');
xaxis([0 365]);


i = find(t > 100);
ii = find(~isnan(BPMx(1,i)));
j = i(ii(1));

for i = 1:size(BPMx,2)
    BPMx(:,i) = BPMx(:,i) - BPMx(:,j);
    BPMy(:,i) = BPMy(:,i) - BPMy(:,j);
end

FigNum = FigNum + 1;
h = figure(FigNum);
clf reset;

ha(length(ha)+1) = subplot(2,1,1);
plot(t, 1000 * BPMy);
ylabel('BPMy [\mum]', 'Fontsize', FontSize);
title(['Vetical Orbit: ',TitleStr], 'Fontsize', FontSize+2);
%axis tight;
%yaxis([-200 200]);

ha(length(ha)+1) = subplot(2,1,2);
plot(t, 1000 * BPMy);
ylabel('BPMy [\mum]', 'Fontsize', FontSize);
xlabel(xlabelstring);


linkaxes(ha, 'x');
xaxis([0 365]);



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
        % All Days plotted
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
    elseif MaxDay <= 120
        set(gca,'XTick',[0:8:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end-1,:));
    elseif MaxDay > 120
        set(gca,'XTick',[0:15:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end-1,:));
    end
end
