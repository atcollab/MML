function arplot_idbpm(monthStr, days, year1, month2Str, days2, year2)
% arplot_idbpm(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots meshgrid plots of IDBPMs.
% Only plots data when feed forward is on.
%
% Example:  arplots_idbpm('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1/24 in 1998
%

alsglobe

IDBPMl = [
  				 1 1
			    1 2
 			    2 1
 			    2 2
 			    3 1
 			    3 2
             4 1
             4 2
             5 1
             5 2
             6 1
             6 2
             7 1
             7 2
             8 1
             8 2
             9 1
             9 2
            10 1
            10 2
            11 1
            11 2
            12 1
            12 2];

IDBPMe = dev2elem('IDBPMx', IDBPMl);


if isempty(IDXoffset) | isempty(IDXoffset) | isempty(IDXgolden) | isempty(IDXgolden)
   disp('  Run alsvars (or alsinit) before running this function.');
   return
end


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
lcw=[];

TC7_1=[];
TC7_2=[];
TC7_3=[];
TC7_4=[];

TC8_1=[];
TC8_2=[];
TC8_3=[];
TC8_4=[];

TC9_1=[];
TC9_2=[];
TC9_3=[];
TC9_4=[];

TC12_1=[];
TC12_2=[];
TC12_3=[];
TC12_4=[];

IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap12=[];

FF7Enable = [];

ID5BPM1x=[];
ID5BPM1y=[];
ID5BPM2x=[];
ID5BPM2y=[];

ID7BPM1x=[];
ID7BPM1y=[];
ID7BPM2x=[];
ID7BPM2y=[];

ID8BPM1x=[];
ID8BPM1y=[];
ID8BPM2x=[];
ID8BPM2y=[];

ID9BPM1x=[];
ID9BPM1y=[];
ID9BPM2x=[];
ID9BPM2y=[];

ID12BPM1x=[];
ID12BPM1y=[];
ID12BPM2x=[];
ID12BPM2y=[];

BPM45x=[];
BPM45y=[];

C1TEMP=[];
C2TEMP=[];


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

pwd

for day = days
   day;
   %t0=clock;
   year1str = num2str(year1);
   %year1str = year1str(3:4);
   FileName = sprintf('%4s%02d%02d', year1str, month, day);
   arread(FileName,1);
   %readtime = etime(clock, t0)
   
   [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
   [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
   dcct = [dcct y1];
   lcw  = [lcw  y2];
   
   [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
   lifetime = [lifetime  y1];
   
   [y1,i]=arselect('SR05W___GDS1PS_AM00');
   [y2,i]=arselect('SR07U___GDS1PS_AM00');
   [y3,i]=arselect('SR08U___GDS1PS_AM00');
   [y4,i]=arselect('SR09U___GDS1PS_AM00');
   [y5,i]=arselect('SR12U___GDS1PS_AM00');
   IDgap5 =[IDgap5  y1];
   IDgap7 =[IDgap7  y2];
   IDgap8 =[IDgap8  y2];
   IDgap9 =[IDgap9  y4];
   IDgap12=[IDgap12 y5];
   
   [y1,i]=arselect('sr07u:FFEnable:bi');
   FF7Enable =[FF7Enable  y1];
   
   [y1, i] = arselect('SR07U___IDTC1__AM');
   [y2, i] = arselect('SR07U___IDTC2__AM');
   [y3, i] = arselect('SR07U___IDTC3__AM');
   [y4, i] = arselect('SR07U___IDTC4__AM');
   TC7_1=[TC7_1 y1];
   TC7_2=[TC7_2 y2]; 
   TC7_3=[TC7_3 y3];
   TC7_4=[TC7_4 y4];
   
   [y1, i] = arselect('SR08U___IDTC1__AM');
   [y2, i] = arselect('SR08U___IDTC2__AM');
   [y3, i] = arselect('SR08U___IDTC3__AM');
   [y4, i] = arselect('SR08U___IDTC4__AM');
   TC8_1=[TC8_1 y1];
   TC8_2=[TC8_2 y2]; 
   TC8_3=[TC8_3 y3];
   TC8_4=[TC8_4 y4];
   
   [y1, i] = arselect('SR09U___IDTC1__AM');
   [y2, i] = arselect('SR09U___IDTC2__AM');
   [y3, i] = arselect('SR09U___IDTC3__AM');
   [y4, i] = arselect('SR09U___IDTC4__AM');
   TC9_1=[TC9_1 y1];
   TC9_2=[TC9_2 y2]; 
   TC9_3=[TC9_3 y3];
   TC9_4=[TC9_4 y4];
   
   [y1, i] = arselect('SR12U___IDTC1__AM');
   [y2, i] = arselect('SR12U___IDTC2__AM');
   [y3, i] = arselect('SR12U___IDTC3__AM');
   [y4, i] = arselect('SR12U___IDTC4__AM');
   TC12_1=[TC12_1 y1];
   TC12_2=[TC12_2 y2]; 
   TC12_3=[TC12_3 y3];
   TC12_4=[TC12_4 y4];
     
   [y1, i] = arselect('SR03S___C1TEMP_AM');
   [y2, i] = arselect('SR03S___C2TEMP_AM');
   C1TEMP=[C1TEMP y1];
   C2TEMP=[C2TEMP y2];
   
   for j = 1:length(IDBPMe)
      [x1, i] = arselect(getname('IDBPMx',IDBPMe(j)));
      [y1, i] = arselect(getname('IDBPMy',IDBPMe(j)));
   
      if day==days(1)
         IDBPMx0(j,1) = x1(1);
         IDBPMy0(j,1) = y1(1);
      end
      
      IDBPMx(j,N+1:N+length(ARt))=x1-IDBPMx0(j);
      IDBPMy(j,N+1:N+length(ARt))=y1-IDBPMy0(j);
   end
   N = N + length(ARt);
   
   t = [t  ARt+(day-StartDay)*24*60*60];
   
   disp(' ');
end


if ~isempty(days2)
   
   StartDay = days2(1);
   EndDay = days2(length(days2));
   
   for day = days2
      day;
      %t0=clock;
      year2str = num2str(year2);
      year2str = year2str(3:4);
      FileName = sprintf('%2s%02d%02d', year2str, month2, day);
      arread(FileName,1);
      %readtime = etime(clock, t0)
      
      [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
      [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
      dcct = [dcct y1];
      lcw  = [lcw  y2];
      
      [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
      lifetime = [lifetime  y1];
      
      [y1,i]=arselect('SR05W___GDS1PS_AM00');
      [y2,i]=arselect('SR07U___GDS1PS_AM00');
      [y3,i]=arselect('SR08U___GDS1PS_AM00');
      [y4,i]=arselect('SR09U___GDS1PS_AM00');
      [y5,i]=arselect('SR12U___GDS1PS_AM00');
      IDgap5 =[IDgap5  y1];
      IDgap7 =[IDgap7  y2];
      IDgap8 =[IDgap8  y2];
      IDgap9 =[IDgap9  y4];
      IDgap12=[IDgap12 y5];
      
      [y1,i]=arselect('sr07u:FFEnable:bi');
      FF7Enable =[FF7Enable  y1];
      
      [y1, i] = arselect('SR07U___IDTC1__AM');
      [y2, i] = arselect('SR07U___IDTC2__AM');
      [y3, i] = arselect('SR07U___IDTC3__AM');
      [y4, i] = arselect('SR07U___IDTC4__AM');
      TC7_1=[TC7_1 y1];
      TC7_2=[TC7_2 y2]; 
      TC7_3=[TC7_3 y3];
      TC7_4=[TC7_4 y4];
      
      [y1, i] = arselect('SR08U___IDTC1__AM');
      [y2, i] = arselect('SR08U___IDTC2__AM');
      [y3, i] = arselect('SR08U___IDTC3__AM');
      [y4, i] = arselect('SR08U___IDTC4__AM');
      TC8_1=[TC8_1 y1];
      TC8_2=[TC8_2 y2]; 
      TC8_3=[TC8_3 y3];
      TC8_4=[TC8_4 y4];
      
      [y1, i] = arselect('SR09U___IDTC1__AM');
      [y2, i] = arselect('SR09U___IDTC2__AM');
      [y3, i] = arselect('SR09U___IDTC3__AM');
      [y4, i] = arselect('SR09U___IDTC4__AM');
      TC9_1=[TC9_1 y1];
      TC9_2=[TC9_2 y2]; 
      TC9_3=[TC9_3 y3];
      TC9_4=[TC9_4 y4];
      
      [y1, i] = arselect('SR12U___IDTC1__AM');
      [y2, i] = arselect('SR12U___IDTC2__AM');
      [y3, i] = arselect('SR12U___IDTC3__AM');
      [y4, i] = arselect('SR12U___IDTC4__AM');
      TC12_1=[TC12_1 y1];
      TC12_2=[TC12_2 y2]; 
      TC12_3=[TC12_3 y3];
      TC12_4=[TC12_4 y4];
      
      [y1, i] = arselect('SR03S___C1TEMP_AM');
      [y2, i] = arselect('SR03S___C2TEMP_AM');
      C1TEMP=[C1TEMP y1];
      C2TEMP=[C2TEMP y2];
      
      for j = 1:length(IDBPMe)
         [x1, i] = arselect(getname('IDBPMx',IDBPMe(j)));
         [y1, i] = arselect(getname('IDBPMy',IDBPMe(j)));
         IDBPMx(j,N+1:N+length(ARt))=x1-IDBPMx0(j);
         IDBPMy(j,N+1:N+length(ARt))=y1-IDBPMy0(j);
      end
      N = N + length(ARt);
      
      t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
      
      disp(' ');
   end
end


dcct = 100*dcct;

i = find(dcct < .2);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime1 = -diff(t/60/60)./(dlogdcct);
i = find(lifetime1 < 0);
lifetime1(i) = NaN;

xmax = max(t/60/60);

figure(1); clf;
subplot(3,1,1);
plot(t/60/60, dcct); grid on;
ylabel('Beam Current [mAmps]');
title(titleStr);
axis([0 xmax 0 450]);

subplot(3,1,2);
%plot(t/60/60, lifetime, 'g', t(2:end)/60/60, lifetime1, 'r'); grid on;
plot(t(2:end)/60/60, lifetime1, 'r'); grid on;
ylabel('Lifetime [Hours]');
axis([0 xmax 0 15]);

subplot(3,1,3);
plot(t/60/60, lcw); grid on;
xlabel(['Time since ', StartDayStr,' [hours]']);
ylabel('LCW Temperature [Celsius]');
axis([0 xmax 20 24]);
orient tall


if 0
	figure(2); clf;
	subplot(4,1,1);
	plot(t/60/60,TC7_3,'-m', t/60/60,TC7_4,'--y'); grid on;
	ylabel('Sector 7 [Celsius]');
	title(['SR Temperature at ID, ',titleStr]);
	%axis([0 xmax 21.5 24]);
	%legend(	'Sector 7, Aisle Side', ...
	% 	'Sector 7, Beamline Side');

	subplot(4,1,2);
	plot(t/60/60,TC8_3,'-m', t/60/60,TC8_4,'--y'); grid on;
	%xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Sector 8 [Celsius]');
	%axis([0 xmax 21.5 24]);
	%title(['SR Temperature at ID, ',titleStr]);
	%legend(	'Sector 8, Aisle Side', ...
	% 	'Sector 8, Beamline Side');

	subplot(4,1,3);
	plot(t/60/60,TC9_3,'-m', t/60/60,TC9_4,'--y'); grid on;
	%xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Sector 9 [Celsius]');
	%axis([0 xmax 21.5 24]);
	%title(['SR Temperature at ID, ',titleStr]);
	%legend(	'Sector 9, Aisle Side', ...
	% 	'Sector 9, Beamline Side');

	subplot(4,1,4);
	plot(t/60/60,TC12_3,'-m', t/60/60,TC12_4,'--y'); grid on;
	xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Sector 12 [Celsius]');
	%axis([0 xmax 21.5 24]);
	%title(['SR Temperature at ID, ',titleStr]);
	%legend(	'Sector 12, Aisle Side', ...
	% 	'Sector 12, Beamline Side');
	orient tall


	figure(3); clf;
	subplot(4,1,1);
	plot(t/60/60,TC7_1,'-m', t/60/60,TC7_2,'--y'); grid on;
	ylabel('Sector 7 [Celsius]');
	title(['ID Backing Beam Temperature , ',titleStr]);
	%axis([0 xmax 22.5 25]);

	subplot(4,1,2);
	plot(t/60/60,TC8_1,'-m', t/60/60,TC8_2,'--y'); grid on;
	ylabel('Sector 8 [Celsius]');
	%axis([0 xmax 22.5 25]);

	subplot(4,1,3);
	plot(t/60/60,TC9_1,'-m', t/60/60,TC9_2,'--y'); grid on;
	ylabel('Sector 9 [Celsius]');
	%axis([0 xmax 22.5 25]);

	subplot(4,1,4);
	plot(t/60/60,TC12_1,'-m', t/60/60,TC12_2,'--y'); grid on;
	xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Sector 12 [Celsius]');
	%axis([0 xmax 22.5 25]);
	orient tall
end

% Remove points when current is below 5 mamps
[y, i]=find(dcct<5);
for j = 1:length(IDBPMelem)
   IDBPMx(j,i)=NaN*ones(size(i));
   IDBPMy(j,i)=NaN*ones(size(i));
end


% Remove points when FF is disabled
[y, i]=find(FF7Enable==0);
for j = 1:length(IDBPMelem)
   IDBPMx(j,i)=NaN*ones(size(i));
   IDBPMy(j,i)=NaN*ones(size(i));
end


if 0
	figure(4); clf;
	plot(t/60/60,IDgap5,'y', t/60/60,IDgap7,'--m', t/60/60,IDgap8,':c', t/60/60,IDgap9,'-.r', t/60/60,IDgap12,'-b');
	xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Insertion Device Gap [mm]');
	title(titleStr);
	legend('ID5  ','ID7  ', 'ID8  ', 'ID9  ','ID12  ');
	axis([0 xmax 10 100]);


	figure(5); clf;
	plot(t/60/60, C1TEMP,'y', t/60/60, C2TEMP,'--m'); grid on;
	xlabel(['Time since ', StartDayStr,' [hours]']);
	ylabel('Temperature [Celsius]');
	legend('RF Cavity #1 ', 'RF Cavity #2  ');
	title(titleStr);
	xaxis([0 xmax]);
end

[x,y] = meshgrid(IDBPMs(IDBPMe),t/60/60);
figure(2); clf
subplot(2,1,1);
size(x),size(y),size(IDBPMx)
plot3(x, y, IDBPMx');
view(86,75);
xlabel(['IDBPM Position [meters]']);
ylabel(['Time since ', StartDayStr,' [hours]']);
zlabel('IDBPMx [mm]');
title(titleStr);

subplot(2,1,2);
plot3(x, y, IDBPMy');
view(86,75);
xlabel(['IDBPM Position [meters]']);
ylabel(['Time since ', StartDayStr,' [hours]']);
zlabel('IDBPMy [mm]');

