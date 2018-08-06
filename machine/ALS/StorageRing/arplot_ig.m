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

SR01IG1 = [];
SR01IG2 = [];
SR03IG1 = []; 
SR03IG3 = [];
SR04IG1 = []; 
SR04IG2 = []; 
SR05IG1 = []; 
SR07IG1 = []; 
SR08IG1 = []; 
SR09IG1 = []; 
SR10IG1 = []; 
SR11IG1 = []; 
SR11IG2 = []; 
SR12IG1 = []; 

IG1=[];

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
      N = N + length(ARt);
      
      
      t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
      
      disp(' ');
   end
end

%dcct conditioning and lifetime calculation
dcct = 100*dcct;
i = find(dcct < 1.);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime = -diff(t/60/60)./(dlogdcct);
i = find(lifetime < 0);
lifetime(i) = NaN;

lifetimeAM=10*lifetimeAM;

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

%plot data
%first page
figure
subplot(3,1,1);
plot(t, dcct,'b-',t,lifetimeAM,'r-');
grid on;
%ylabel('Beam Current [mAmps] and Lifetime*10 [hrs*10]');
axis([min(t) max(t) 0 450]);
title(titleStr);
legend('Beam Current [mA]','Lifetime*10 [hrs*10]',3);

subplot(3,1,2);
h1=semilogy(t, SR01IG1, t, SR01IG2, t, IG1(1,:), t, IG1(2,:), t, SR03IG1, t, SR03IG3, t, IG1(3,:));
for h = 1:length(h1)
	set(h1(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
axis([min(t) max(t) 1e-11 1e-7]);
clear name;
for j = 1:12
   name(j,:)=sprintf('SR%02dC IG2 AM',j);
end
name1 = ['SR01S IG1 AM'
   'SR01S IG2 AM'
   name(1,:)
   name(2,:)
   'SR03S IG1 AM'
   'SR03S IG3 AM'
   name(3,:)];
legend(name1,3);

subplot(3,1,3);
h2=semilogy(t, SR04IG1, t, SR04IG2, t, IG1(4,:), t, SR05IG1, t, IG1(5,:), t, IG1(6,:));
for h = 1:length(h2)
	set(h2(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
xlabel(xlabelstring);
axis([min(t) max(t) 1e-11 1e-7]);
name2 = ['SR04U IG1 AM'
   'SR04U IG2 AM'
   name(4,:)
   'SR05W IG1 AM'
   name(5,:)
   name(6,:)];
legend(name2,3);
orient tall

% second page
figure
subplot(3,1,1);
plot(t, dcct,'b-',t,lifetimeAM,'r-');
grid on;
%ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 450]);
title(titleStr);
legend('Beam Current [mA]','Lifetime*10 [hrs*10]',3);

subplot(3,1,2);
h3=semilogy(t, SR07IG1, t, IG1(7,:), t, SR08IG1, t, IG1(8,:), t, SR09IG1, t, IG1(9,:));
for h = 1:length(h3)
	set(h3(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
axis([min(t) max(t) 1e-11 1e-7]);
name3 = ['SR07U IG1 AM'
   name(7,:)
   'SR08U IG1 AM'
   name(8,:)
   'SR09U IG1 AM'
   name(9,:)];
legend(name3,3);

subplot(3,1,3);
h4=semilogy(t, SR10IG1, t, IG1(10,:), t, SR11IG1, t, SR11IG2, t, IG1(11,:), t, SR12IG1, t, IG1(12,:));
for h = 1:length(h4)
	set(h4(h),'LineWidth',3)
end
grid on;
ylabel('IG [torr]');
xlabel(xlabelstring);
axis([min(t) max(t) 1e-11 1e-7]);
name4 = ['SR10U IG1 AM'
   name(10,:)			
   'SR11U IG1 AM'
   'SR11U IG2 AM'
   name(11,:)
   'SR12U IG1 AM'
   name(12,:)];
legend(name4,3);
orient tall
