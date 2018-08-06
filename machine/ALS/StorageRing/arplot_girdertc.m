function meanTC = arplot_girdertc(monthStr, days, year1, month2Str, days2, year2)
% mean = arplot_girdertc(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots Beam Current and Storage Ring Girder Thermocouple data.
% Returns a structure "mean" with mean values for each sector
%
% Example:  arplot_girdertc('January',22:24, 1998);
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

global GLOBAL_SR_MODE_TITLE

if strcmp(GLOBAL_SR_MODE_TITLE, '1.9 GeV, Two Bunch')
   dcctplotmax = 60;
else
   dcctplotmax = 400;
end

minT = 19.5;
maxT = 23.5;

arglobal


t=[];
dcct=[];
IDgap4=[];
IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap10=[];
IDgap11=[];
IDgap12=[];

SR01CUP = []; SR01CMD = []; SR01CDN = [];
SR02CUP = []; SR02CMD = []; SR02CDN = [];
SR03CUP = []; SR03CMD = []; SR03CDN = [];
SR04CUP = []; SR04CMD = []; SR04CDN = [];
SR05CUP = []; SR05CMD = []; SR05CDN = [];
SR06CUP = []; SR06CMD = []; SR06CDN = [];
SR07CUP = []; SR07CMD = []; SR07CDN = [];
SR08CUP = []; SR08CMD = []; SR08CDN = [];
SR09CUP = []; SR09CMD = []; SR09CDN = [];
SR10CUP = []; SR10CMD = []; SR10CDN = [];
SR11CUP = []; SR11CMD = []; SR11CDN = [];
SR12CUP = []; SR12CMD = []; SR12CDN = [];

meanTC = [];
%SR04TC = [];

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
	if str2num(FileName) < 20050322
		disp(' ');
		disp('  For dates previous to 3-22-05, the temperatures are from flexbands!!!');
		disp(' ');
	end
   arread(FileName);
   %readtime = etime(clock, t0)
   
   [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
   dcct = [dcct y1];
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

   [y1, i] = arselect('SR01W___TCWAGO_AM02');
   SR01CUP = [SR01CUP y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM01');
   SR01CMD = [SR01CMD y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM03');
   SR01CDN = [SR01CDN y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM00');
   SR02CUP = [SR02CUP y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM01');
   SR02CMD = [SR02CMD y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM05');
   SR02CDN = [SR02CDN y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM00');
   SR03CUP = [SR03CUP y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM01');
   SR03CMD = [SR03CMD y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM05');
   SR03CDN = [SR03CDN y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM00');
   SR04CUP = [SR04CUP y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM01');
   SR04CMD = [SR04CMD y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM05');
   SR04CDN = [SR04CDN y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM00');
   SR05CUP = [SR05CUP y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM01');
   SR05CMD = [SR05CMD y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM05');
   SR05CDN = [SR05CDN y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM02');
   SR06CUP = [SR06CUP y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM01');
   SR06CMD = [SR06CMD y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM04');
   SR06CDN = [SR06CDN y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM00');
   SR07CUP = [SR07CUP y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM01');
   SR07CMD = [SR07CMD y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM05');
   SR07CDN = [SR07CDN y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM00');
   SR08CUP = [SR08CUP y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM01');
   SR08CMD = [SR08CMD y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM05');
   SR08CDN = [SR08CDN y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM00');
   SR09CUP = [SR09CUP y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM01');
   SR09CMD = [SR09CMD y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM05');
   SR09CDN = [SR09CDN y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM00');
   SR10CUP = [SR10CUP y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM01');
   SR10CMD = [SR10CMD y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM05');
   SR10CDN = [SR10CDN y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM00');
   SR11CUP = [SR11CUP y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM01');
   SR11CMD = [SR11CMD y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM05');
   SR11CDN = [SR11CDN y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM00');
   SR12CUP = [SR12CUP y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM01');
   SR12CMD = [SR12CMD y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM05');
   SR12CDN = [SR12CDN y1]; 
%   for j = 1:12
%      [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
%      IG1(j,N+1:N+length(ARt))=y1;
%   end;

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
		if str2num(FileName) < 20050322
			disp(' ');
			disp('  For dates previous to 3-22-05, the temperatures are from flexbands!!!');
			disp(' ');
		end
      arread(FileName);
      %readtime = etime(clock, t0)
      
		[y1, idcct] = arselect('SR05S___DCCTLP_AM01');
		dcct = [dcct y1];
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


		[y1, i] = arselect('SR01W___TCWAGO_AM02');
		SR01CUP = [SR01CUP y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM01');
		SR01CMD = [SR01CMD y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM03');
		SR01CDN = [SR01CDN y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM00');
		SR02CUP = [SR02CUP y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM01');
		SR02CMD = [SR02CMD y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM05');
		SR02CDN = [SR02CDN y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM00');
		SR03CUP = [SR03CUP y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM01');
		SR03CMD = [SR03CMD y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM05');
		SR03CDN = [SR03CDN y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM00');
		SR04CUP = [SR04CUP y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM01');
		SR04CMD = [SR04CMD y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM05');
		SR04CDN = [SR04CDN y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM00');
		SR05CUP = [SR05CUP y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM01');
		SR05CMD = [SR05CMD y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM05');
		SR05CDN = [SR05CDN y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM02');
		SR06CUP = [SR06CUP y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM01');
		SR06CMD = [SR06CMD y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM04');
		SR06CDN = [SR06CDN y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM00');
		SR07CUP = [SR07CUP y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM01');
		SR07CMD = [SR07CMD y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM05');
		SR07CDN = [SR07CDN y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM00');
		SR08CUP = [SR08CUP y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM01');
		SR08CMD = [SR08CMD y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM05');
		SR08CDN = [SR08CDN y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM00');
		SR09CUP = [SR09CUP y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM01');
		SR09CMD = [SR09CMD y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM05');
		SR09CDN = [SR09CDN y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM00');
		SR10CUP = [SR10CUP y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM01');
		SR10CMD = [SR10CMD y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM05');
		SR10CDN = [SR10CDN y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM00');
		SR11CUP = [SR11CUP y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM01');
		SR11CMD = [SR11CMD y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM05');
		SR11CDN = [SR11CDN y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM00');
		SR12CUP = [SR12CUP y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM01');
		SR12CMD = [SR12CMD y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM05');
		SR12CDN = [SR12CDN y1]; 

%     for j = 1:12
%        [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
%        IG1(j,N+1:N+length(ARt))=y1;
%     end;

      N = N + length(ARt);
      
      
      t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
      
      disp(' ');
   end
end

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

% Channel descriptions - mine .DESC fields to get locations
%[d,SR01TC1full] = unix('scaget SR01W___TCWAGO_AM00.DESC');
%SR01TC1desc = SR01TC1full(end-22:end);
%
%SR01TC2desc = []; SR01TC3desc = []; SR01TC4desc = []; SR01TC5desc = []; SR01TC6desc = [];
%SR02TC1desc = []; SR02TC2desc = []; SR02TC3desc = []; SR02TC4desc = []; SR02TC5desc = []; SR02TC6desc = [];
%SR03TC1desc = []; SR03TC2desc = []; SR03TC3desc = []; SR03TC4desc = []; SR03TC5desc = []; SR03TC6desc = [];
%SR04TC1desc = []; SR04TC2desc = []; SR04TC3desc = []; SR04TC4desc = []; SR04TC5desc = []; SR04TC6desc = [];
%SR05TC1desc = []; SR05TC2desc = []; SR05TC3desc = []; SR05TC4desc = []; SR05TC5desc = []; SR05TC6desc = [];
%SR06TC1desc = []; SR06TC2desc = []; SR06TC3desc = []; SR06TC4desc = []; SR06TC5desc = []; SR06TC6desc = [];
%SR07TC1desc = []; SR07TC2desc = []; SR07TC3desc = []; SR07TC4desc = []; SR07TC5desc = []; SR07TC6desc = [];
%SR08TC1desc = []; SR08TC2desc = []; SR08TC3desc = []; SR08TC4desc = []; SR08TC5desc = []; SR08TC6desc = [];
%SR09TC1desc = []; SR09TC2desc = []; SR09TC3desc = []; SR09TC4desc = []; SR09TC5desc = []; SR09TC6desc = [];
%SR10TC1desc = []; SR10TC2desc = []; SR10TC3desc = []; SR10TC4desc = []; SR10TC5desc = []; SR10TC6desc = [];
%SR11TC1desc = []; SR11TC2desc = []; SR11TC3desc = []; SR11TC4desc = []; SR11TC5desc = []; SR11TC6desc = [];
%SR12TC1desc = []; SR12TC2desc = []; SR12TC3desc = []; SR12TC4desc = []; SR12TC5desc = []; SR12TC6desc = [];
%

% names
for Sector = 1:12
	name{3*Sector-2} = sprintf('SR%02dC upstream girder temp',Sector);
	name{3*Sector-1} = sprintf('SR%02dC middle girder temp',Sector);
	name{3*Sector} = sprintf('SR%02dC downstream girder temp',Sector);
end

%plot data
%first page
figure
subplot(5,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(5,1,2);
plot(t, SR01CUP, t, SR01CMD, t, SR01CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[1 2 3]},3);

subplot(5,1,3);
plot(t, SR02CUP, t, SR02CMD, t, SR02CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[4 5 6]},3);

subplot(5,1,4);
plot(t, SR03CUP, t, SR03CMD, t, SR03CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[7 8 9]},3);

subplot(5,1,5);
plot(t, SR04CUP, t, SR04CMD, t, SR04CDN);
grid on;
ylabel('Temp [deg C]');
xlabel(xlabelstring);
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[10 11 12]},3);

orient landscape

% second page
figure
subplot(5,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(5,1,2);
plot(t, SR05CUP, t, SR05CMD, t, SR05CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[13 14 15]},3);

subplot(5,1,3);
plot(t, SR06CUP, t, SR06CMD, t, SR06CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[16 17 18]},3);

subplot(5,1,4);
plot(t, SR07CUP, t, SR07CMD, t, SR07CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[19 20 21]},3);

subplot(5,1,5);
plot(t, SR08CUP, t, SR08CMD, t, SR08CDN);
grid on;
xlabel(xlabelstring);
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[22 23 24]},3);

orient landscape

%third page
figure
subplot(5,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(5,1,2);
plot(t, SR09CUP, t, SR09CMD, t, SR09CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[25 26 27]},3);

subplot(5,1,3);
plot(t, SR10CUP, t, SR10CMD, t, SR10CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[28 29 30]},3);

subplot(5,1,4);
plot(t, SR11CUP, t, SR11CMD, t, SR11CDN);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[31 32 33]},3);

subplot(5,1,5);
plot(t, SR12CUP, t, SR12CMD, t, SR12CDN);
grid on;
xlabel(xlabelstring);
ylabel('Temp [deg C]');
axis([min(t) max(t) minT maxT])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[34 35 36]},3);

orient landscape

% calculate means
meanTC.SR01CUP = mean(SR01CUP);
meanTC.SR01CMD = mean(SR01CMD);
meanTC.SR01CDN = mean(SR01CDN);
meanTC.SR02CUP = mean(SR02CUP);
meanTC.SR02CMD = mean(SR02CMD);
meanTC.SR02CDN = mean(SR02CDN);
meanTC.SR03CUP = mean(SR03CUP);
meanTC.SR03CMD = mean(SR03CMD);
meanTC.SR03CDN = mean(SR03CDN);
meanTC.SR04CUP = mean(SR04CUP);
meanTC.SR04CMD = mean(SR04CMD);
meanTC.SR04CDN = mean(SR04CDN);
meanTC.SR05CUP = mean(SR05CUP);
meanTC.SR05CMD = mean(SR05CMD);
meanTC.SR05CDN = mean(SR05CDN);
meanTC.SR06CUP = mean(SR06CUP);
meanTC.SR06CMD = mean(SR06CMD);
meanTC.SR06CDN = mean(SR06CDN);
meanTC.SR07CUP = mean(SR07CUP);
meanTC.SR07CMD = mean(SR07CMD);
meanTC.SR07CDN = mean(SR07CDN);
meanTC.SR08CUP = mean(SR08CUP);
meanTC.SR08CMD = mean(SR08CMD);
meanTC.SR08CDN = mean(SR08CDN);
meanTC.SR09CUP = mean(SR09CUP);
meanTC.SR09CMD = mean(SR09CMD);
meanTC.SR09CDN = mean(SR09CDN);
meanTC.SR10CUP = mean(SR10CUP);
meanTC.SR10CMD = mean(SR10CMD);
meanTC.SR10CDN = mean(SR10CDN);
meanTC.SR11CUP = mean(SR11CUP);
meanTC.SR11CMD = mean(SR11CMD);
meanTC.SR11CDN = mean(SR11CDN);
meanTC.SR12CUP = mean(SR12CUP);
meanTC.SR12CMD = mean(SR12CMD);
meanTC.SR12CDN = mean(SR12CDN);

%SR04TC.up = SR04CUP;
%SR04TC.md = SR04CMD;
%SR04TC.dn = SR04CDN;

% save 'temp_data_conf_survey'  SR01CDN  SR01CMD  SR01CUP  SR02CDN ...
%     SR02CMD  SR02CUP  SR03CDN  SR03CMD  SR03CUP  SR04CDN ...
%     SR04CMD  SR04CUP  SR05CDN  SR05CMD  SR05CUP  SR06CDN ...
%     SR06CMD  SR06CUP  SR07CDN  SR07CMD  SR07CUP  SR08CDN ...
%     SR08CMD  SR08CUP  SR09CDN  SR09CMD  SR09CUP  SR10CDN ...
%     SR10CMD  SR10CUP  SR11CDN  SR11CMD  SR11CUP  SR12CDN ...
%     SR12CMD  SR12CUP t

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
      set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));       
   elseif MaxDay < 63
      set(gca,'XTick',[0:3:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));       
   elseif MaxDay < 80
      set(gca,'XTick',[0:4:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));       
   end
end
