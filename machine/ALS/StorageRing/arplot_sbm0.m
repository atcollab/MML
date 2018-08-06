function arplot_sbm0(monthStr, days, year1, month2Str, days2, year2)
% arplot_sbm0(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots archived data about the spare Superbend.
%
% Example:  arplot_sbm0('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1 in 1998
%
% C. Steier, August 2001

% 2002-08-15 T.Scarvie - Added cryo-liquid pressure plots
%
% 2012-11-19 C. Steier - modified arplot_sbm for the spare Superbend

FigNum = 34; %figure;  

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

sbm1i = []; sbm1ln = []; sbm1lnp = []; sbm1lhe = []; sbm1lhep = []; sbm1hall =[]; sbm1cryovac =[];
sbm1t1 = []; sbm1t2 = []; sbm1t3 = []; sbm1t4 = [];
sbm1t5 = []; sbm1t6 = []; sbm1t7 = []; sbm1t8 = [];

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
   
   [y1, i] = arselect('SR00C___BSC_P__AM00');
   sbm1i = [sbm1i y1];
   
   [y1, i] = arselect('SR00C___BSCLVN2AM00');
   sbm1ln = [sbm1ln y1];

   [y1, i] = arselect('SR00C___BSC_LN_AM00');
   sbm1lnp = [sbm1lnp y1];

   [y1, i] = arselect('SR00C___BSCLVHEAM00');
   sbm1lhe = [sbm1lhe y1];

   [y1, i] = arselect('SR00C___BSC_LHEAM00');
   sbm1lhep = [sbm1lhep y1];

   [y1, i] = arselect('SR00C___BSCHALLAM00');
   sbm1hall = [sbm1hall y1];

   [y1, i] = arselect('SR00C___BSCIG1_AM00');
   sbm1cryovac = [sbm1cryovac y1];

   [y1, i] = arselect('SR00C___BSC_T1_AM00');
   sbm1t1 = [sbm1t1 y1];

   [y1, i] = arselect('SR00C___BSC_T2_AM01');
   sbm1t2 = [sbm1t2 y1];

   [y1, i] = arselect('SR00C___BSC_T3_AM02');
   sbm1t3 = [sbm1t3 y1];

   [y1, i] = arselect('SR00C___BSC_T4_AM03');
   sbm1t4 = [sbm1t4 y1];

   [y1, i] = arselect('SR00C___BSC_T5_AM04');
   sbm1t5 = [sbm1t5 y1];

   [y1, i] = arselect('SR00C___BSC_T6_AM05');
   sbm1t6 = [sbm1t6 y1];

   [y1, i] = arselect('SR00C___BSC_T7_AM06');
   sbm1t7 = [sbm1t7 y1];

   [y1, i] = arselect('SR00C___BSC_T8_AM07');
   sbm1t8 = [sbm1t8 y1];

   
   t    = [t  ARt+(day-StartDay)*24*60*60];
   
   disp(' ');
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
         
         FileName = sprintf('%2s%02d%02d', year2str, month2, day);
                  
	   arread(FileName);
	   %readtime = etime(clock, t0)
   
   
   [y1, i] = arselect('SR00C___BSC_P__AM00');
   sbm1i = [sbm1i y1];
   
   [y1, i] = arselect('SR00C___BSCLVN2AM00');
   sbm1ln = [sbm1ln y1];

   [y1, i] = arselect('SR00C___BSC_LN_AM00');
   sbm1lnp = [sbm1lnp y1];

   [y1, i] = arselect('SR00C___BSCLVHEAM00');
   sbm1lhe = [sbm1lhe y1];

   [y1, i] = arselect('SR00C___BSC_LHEAM00');
   sbm1lhep = [sbm1lhep y1];

   [y1, i] = arselect('SR00C___BSCHALLAM00');
   sbm1hall = [sbm1hall y1];

   [y1, i] = arselect('SR00C___BSCIG1_AM00');
   sbm1cryovac = [sbm1cryovac y1];

   [y1, i] = arselect('SR00C___BSC_T1_AM00');
   sbm1t1 = [sbm1t1 y1];

   [y1, i] = arselect('SR00C___BSC_T2_AM01');
   sbm1t2 = [sbm1t2 y1];

   [y1, i] = arselect('SR00C___BSC_T3_AM02');
   sbm1t3 = [sbm1t3 y1];

   [y1, i] = arselect('SR00C___BSC_T4_AM03');
   sbm1t4 = [sbm1t4 y1];

   [y1, i] = arselect('SR00C___BSC_T5_AM04');
   sbm1t5 = [sbm1t5 y1];

   [y1, i] = arselect('SR00C___BSC_T6_AM05');
   sbm1t6 = [sbm1t6 y1];

   [y1, i] = arselect('SR00C___BSC_T7_AM06');
   sbm1t7 = [sbm1t7 y1];

   [y1, i] = arselect('SR00C___BSC_T8_AM07');
   sbm1t8 = [sbm1t8 y1];

	t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
   
   disp(' ');

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
xmax = max(t);



% change data to NaN for plotting if archiver has stalled for more than 12minutes
StalledArchFlag = [];
for loop = 1:size(t,2)-1
    StalledArchFlag(loop) = (t(loop+1)-t(loop)>0.2);
end
SANum = find(StalledArchFlag==1)+1;
sbm1i(SANum) = NaN; sbm1ln(SANum) = NaN; sbm1lnp(SANum) = NaN; sbm1lhe(SANum) = NaN; sbm1lhep(SANum) = NaN; sbm1hall(SANum) = NaN; sbm1cryovac(SANum) = NaN;
sbm1t1(SANum) = NaN; sbm1t2(SANum) = NaN; sbm1t3(SANum) = NaN; sbm1t4(SANum) = NaN;
sbm1t5(SANum) = NaN; sbm1t6(SANum) = NaN; sbm1t7(SANum) = NaN; sbm1t8(SANum) = NaN;


h = FigNum;
subfig(1,1,1, h);
%%p = get(h, 'Position');
%FigurePosition = [p(1)-.4*p(3) p(2)-.95*p(4) p(3)+.4*p(3) p(4)+.95*p(4)];
%set(h, 'Position', FigurePosition);
clf reset;

subplot(6,1,1)
plot(t,sbm1i);
legend('I power supply', 0);
ylabel('I [A]');
grid;
axis([min(t) max(t) 0 320]);
title(['spare Superbend Temperatures ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(6,1,2)
plot(t,sbm1ln,t,sbm1lhe);
legend('LN level','LHe level',0);
ylabel('Liquid Level [cm]');
grid;
axis([min(t) max(t) 0 35]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(6,1,3)
plot(t,sbm1lnp, '-', t,sbm1lhep, '--');
legend('LN pressure','LHe pressure',0);
ylabel({'Liquid','Pressure [psi]'});
grid;
axis([min(t) max(t) -15 8]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(6,1,4)
semilogy(t,sbm1cryovac);
legend('cryo pressure',0);
ylabel({'Cryostat','Pressure [Torr]'});
grid;
%axis tight
%xaxis([min(t) max(t)])
axis([min(t) max(t) 1e-8 1e-5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(6,1,5)
plot(t,sbm1t7,t,sbm1t2,t,sbm1t6,...
t,sbm1t4,t,sbm1t8);
hh=legend('stage 2','upper coil','lower coil','yoke center 1','yoke center 2');
set(hh, 'Units','Normalized', 'position',[.895 .26 .1 .1]);
ylabel('T [K]');
grid;
axis([min(t) max(t) 3.5 5.2]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(6,1,6)
plot(t,sbm1t3,t,sbm1t1,t,sbm1t5);
hh=legend('stage 1','upper HTS lead','lower HTS lead');
%set(hh, 'Units','Normalized', 'position',[.859 .17 .14 .05]);
set(hh, 'Units','Normalized', 'position',[.87 .025 .11 .05]);
ylabel('T [K]');
grid;
axis([min(t) max(t) 40 80]);

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);
yaxesposition(1.20);
orient tall



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
      set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));       
   elseif MaxDay < 63
      set(gca,'XTick',[0:3:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));       
   elseif MaxDay < 80
      set(gca,'XTick',[0:4:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));       
   end
end
