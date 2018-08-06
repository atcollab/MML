function arplot_pbpm(monthStr, days, year1, month2Str, days2, year2)
% arplot_pbpm(Month1 String, Days1, Year1, Month2 String, Days2, Year2)


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


GapEnableNames = family2channel('ID','GapEnable');
BPMxNames = family2channel('BPMx', [7 5;7 6]);
BPMyNames = family2channel('BPMy', [7 5;7 6]);

BPMxGolden = getgolden('BPMx', [7 5;7 6]);
BPMyGolden = getgolden('BPMy', [7 5;7 6]);
BPMyGain   = getgain(  'BPMy', [7 5;7 6]);
BPMspos    = getspos(  'BPMy', [7 5;7 6]) * 1000; % mm


t = [];
DCCT = [];
GapEnable = [];
BPMx = [];
BPMy = [];
pBPM = [];


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


for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    arread(FileName, 1);

    DCCT = [DCCT 100*arselect('SR05S___DCCTLP_AM01')];

    GapEnable = [GapEnable arselect(GapEnableNames)];

    BPMx = [BPMx arselect(BPMxNames)];
    BPMy = [BPMy arselect(BPMyNames)];

    pBPM = [pBPM arselect('Physics')];

    t = [t  ARt+(day-StartDay)*24*60*60];
end

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
        arread(FileName, 1);

        DCCT = [DCCT 100*arselect('SR05S___DCCTLP_AM01')];

        GapEnable = [GapEnable arselect(GapEnableNames)];

        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];

        pBPM = [pBPM arselect('Physics')];

        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
    end
end

         
         
         % Hours or days for the x-axis
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


% User time index
GapEnable(isnan(GapEnable)) = 0;
GapEnable(GapEnable==127) = 1;       % Sometime 127 is the same as 1 (boolean???)
i = find(sum(GapEnable) < 3);        % Why 3, just because sometimes 1 or 2 gaps are enabled for testing.
iUser = find(sum(GapEnable) >= 3);   % Why 3, just because sometimes 1 or 2 gaps are enabled for testing.
iGood = iUser(floor(median(iUser)));

BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
pBPM(:,i) = NaN;


if 0
    % Inputs: blade 1-4

    yy1 = 17.4 * (pBPM(1,:)-pBPM(3,:)) ./ (pBPM(1,:)+pBPM(3,:));
    yy2 = 17.4 * (pBPM(2,:)-pBPM(4,:)) ./ (pBPM(2,:)+pBPM(4,:));


    figure(1);
    clf reset

    subplot(2,1,1);
    plot(ARt/60/60, [pBPM(5,:); pBPM(6,:)-1.016; pBPM(8,:); pBPM(9,:); yy1; yy2]);
    ylabel('Vertical Position [mm]');
    legend('Y1 (avg y)', 'Y2','Y1 (avg voltage)', 'Y2', 'Y1 (fixed gain)', 'Y2');

    subplot(2,1,2);
    plot(ARt/60/60, [pBPM(1,:); pBPM(2,:); pBPM(3,:); pBPM(4,:)]);
    xlabel('Time [Hours]');
    ylabel('Voltage');
    legend('1. Top Inside', '2. Top Outside', '3. Bottom Inside', '4. Bottom Outside', 0);


    figure(2);
    clf reset

    subplot(2,1,1);
    plot(ARt/60/60, 1000*DCCT);
    ylabel('DCCT');

    subplot(2,1,2);
    plot(ARt/60/60, [pBPM(6,:); pBPM(10,:)]);
    xlabel('Time [Hours]');
    ylabel('Gain');


else
    
    % Inputs: blades 1 3 (Physics5 is the inside blades)
    %         2 - BPMy(7,5)
    %         4 - BPMy(7,6)
    
    y1 = BPMyGain(1) * (pBPM(2,:) - BPMyGolden(1));  % mm
    y2 = BPMyGain(2) * (pBPM(4,:) - BPMyGolden(2));  % mm
    yangle = (y2-y1) / (BPMspos(2)-BPMspos(1));      % radians
    pBPMprojected = (y1+y2)/2 + 6000*yangle;         % mm
        
    %pBPMprojected = pBPMprojected - pBPMprojected(iGood);
    %pBPMprojected = pBPMprojected / 6;
    
    
    pBPMy = pBPM(5,:);
    pBPMy = pBPMy - pBPMy(iGood);
    
    
    %figure(1);
    clf reset

    subplot(2,1,1);
    %plot(t, [(pBPM(5,:)-pBPM(5,iUser(floor(median(iUser)))))' (pBPM(2,:)-BPMyGolden(1))' (pBPM(4,:)-BPMyGolden(2))' (BPMy(1,:)-BPMyGolden(2))' (BPMy(2,:)-BPMyGolden(2))'])
    %plot(t, [(pBPM(5,:)-pBPM(5,iUser(floor(median(iUser)))))' (pBPM(2,:)-BPMyGolden(1))' (pBPM(4,:)-BPMyGolden(2))'])
    %plot(t, [(pBPM(5,:)-pBPM(5,iUser(floor(median(iUser)))))' (pBPM(2,:)-BPMyGolden(1))' (pBPM(4,:)-BPMyGolden(2))' pBPMprojected(:)])
    plot(t, [pBPMy(:) y1(:) y2(:) pBPMprojected(:)])
    grid on;
    xaxis([0 xmax]);
    yaxis([-.02 .02]);
    ylabel('Vertical Position [mm]');
    title(['Photon Beam Position Monitor Sector 7: ',titleStr]);
    %legend('pBPMy (Inside Blades)', 'BPMy(7,5)', 'BPMy(7,6)', 0);
    legend('pBPMy (Inside Blades)', 'BPMy(7,5)', 'BPMy(7,6)', 'BPMy(7,5) & BPMy(7,6) projected to the pBPM', 0);
    ChangeAxesLabel(t, Days, DayFlag);

    subplot(2,1,2);
    plot(t, [pBPM(1,:); pBPM(3,:)]);
    grid on;
    xaxis([0 xmax]);
    %xlabel('Time [Hours]');
    ylabel('Blade Voltage');
    legend('Blade #1', 'Blade #3', 0);
    xlabel(xlabelstring);
    ChangeAxesLabel(t, Days, DayFlag);
    
    yaxesposition(1.15);
    orient tall

end



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
