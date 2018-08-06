function [runtime, filltime, t, dcct]=arfill_length(monthStr, days, year1, month2Str, days2, year2)
% arplot_sr(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots a whole bunch of storage ring related archived data.
% Only plots data when feed forward is on.
%
% Example #1:  arplot_sr('January',22:24,1998);
%              plots data from 1/22, 1/23, and 1/24 in 1998
%
% Example #2:  arplot_sr('January',28:31,1998,'February',1:4,1998);
%              plots data from the last 4 days in Jan. and the first 4 days in Feb.


alsglobe

FFFlag = 0;

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
gev=[];

QFAam=[];

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

TC10_1=[];
TC10_2=[];
TC10_3=[];
TC10_4=[];

TC12_1=[];
TC12_2=[];
TC12_3=[];
TC12_4=[];

IDgap4 = [];
IDgap5 = [];
IDgap7 = [];
IDgap8 = [];
IDgap9 = [];
IDgap10 = [];
IDgap12 = [];
IDgap = [];
EPU4=[];

FF7Enable = [];

ID2BPM1x=[];
ID2BPM1y=[];
ID2BPM2x=[];
ID2BPM2y=[];

ID4BPM1x=[];
ID4BPM1y=[];
ID4BPM2x=[];
ID4BPM2y=[];
ID4BPM3x=[];
ID4BPM3y=[];
ID4BPM4x=[];
ID4BPM4y=[];

ID5BPM1x=[];
ID5BPM1y=[];
ID5BPM2x=[];
ID5BPM2y=[];

ID6BPM1x=[];
ID6BPM1y=[];
ID6BPM2x=[];
ID6BPM2y=[];

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

ID10BPM1x=[];
ID10BPM1y=[];
ID10BPM2x=[];
ID10BPM2y=[];

ID11BPM1x=[];
ID11BPM1y=[];
ID11BPM2x=[];
ID11BPM2y=[];

ID12BPM1x=[];
ID12BPM1y=[];
ID12BPM2x=[];
ID12BPM2y=[];

ID9BPM2xRMS=[];
ID9BPM2yRMS=[];
ID9BPM5xRMS=[];
ID9BPM5yRMS=[];

BPM45x=[];
BPM45y=[];

BPM94x=[];
BPM94y=[];

BPM95x=[];
BPM95y=[];

SigX=[];
SigY=[];

C1TEMP=[];
C2TEMP=[];

HPcounter=[];
HPsyn=[];

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
   day;
   year1str = num2str(year1);
   if year1 < 2000
      year1str = year1str(3:4);
      FileName = sprintf('%2s%02d%02d', year1str, month, day);
   else
      FileName = sprintf('%4s%02d%02d', year1str, month, day);
   end
   arread(FileName, FFFlag);
   
   [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
   [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
   dcct = [dcct y1];
   lcw  = [lcw  y2];
   
   [y1, igev] = arselect('cmm:sr_energy');
   gev = [gev y1];
   
   [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
   lifetime = [lifetime  y1];
   
   [y1,i]=arselect('SR04U___ODS1PS_AM00');
   EPU4 =[EPU4  y1];
   
   [y1,i]=arselect('SR04U___GDS1PS_AM00');
   IDgap4 =[IDgap4  y1];
   
   [y1,i]=arselect('SR05W___GDS1PS_AM00');
   IDgap5 =[IDgap5  y1];
   
   [y1,i]=arselect('SR07U___GDS1PS_AM00');
   IDgap7 =[IDgap7  y1];
   
   [y1,i]=arselect('SR08U___GDS1PS_AM00');
   IDgap8 =[IDgap8  y1];
   
   [y1,i]=arselect('SR09U___GDS1PS_AM00');
   IDgap9 =[IDgap9  y1];
   
   [y1,i]=arselect('SR10U___GDS1PS_AM00');
   IDgap10 =[IDgap10  y1];
   
   [y1,i]=arselect('SR12U___GDS1PS_AM00');
   IDgap12 =[IDgap12  y1];

   
   if FFFlag
      [y1,i]=arselect('sr07u:FFEnable:bi');
      FF7Enable =[FF7Enable  y1];
   end

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
   
   [y1, i] = arselect('SR10U___IDTC1__AM');
   [y2, i] = arselect('SR10U___IDTC2__AM');
   [y3, i] = arselect('SR10U___IDTC3__AM');
   [y4, i] = arselect('SR10U___IDTC4__AM');
   TC10_1=[TC10_1 y1];
   TC10_2=[TC10_2 y2]; 
   TC10_3=[TC10_3 y3];
   TC10_4=[TC10_4 y4];
   
   [y1, i] = arselect('SR12U___IDTC1__AM');
   [y2, i] = arselect('SR12U___IDTC2__AM');
   [y3, i] = arselect('SR12U___IDTC3__AM');
   [y4, i] = arselect('SR12U___IDTC4__AM');
   TC12_1=[TC12_1 y1];
   TC12_2=[TC12_2 y2]; 
   TC12_3=[TC12_3 y3];
   TC12_4=[TC12_4 y4];
   
   [y1, i] = arselect('SR02S___IBPM1X_AM');
   [y2, i] = arselect('SR02S___IBPM1Y_AM');
   [y3, i] = arselect('SR02S___IBPM2X_AM');
   [y4, i] = arselect('SR02S___IBPM2Y_AM');
   ID2BPM1x=[ID2BPM1x y1];
   ID2BPM1y=[ID2BPM1y y2]; 
   ID2BPM2x=[ID2BPM2x y3];
   ID2BPM2y=[ID2BPM2y y4];
   
   [y1, i] = arselect('SR04S___IBPM1X_AM');
   [y2, i] = arselect('SR04S___IBPM1Y_AM');
   [y3, i] = arselect('SR04S___IBPM2X_AM');
   [y4, i] = arselect('SR04S___IBPM2Y_AM');
   ID4BPM1x=[ID4BPM1x y1];
   ID4BPM1y=[ID4BPM1y y2]; 
   ID4BPM2x=[ID4BPM2x y3];
   ID4BPM2y=[ID4BPM2y y4];

   [y1, i] = arselect('SR04S___IBPM3X_AM');
   [y2, i] = arselect('SR04S___IBPM3Y_AM');
   [y3, i] = arselect('SR04S___IBPM4X_AM');
   [y4, i] = arselect('SR04S___IBPM4Y_AM');
   ID4BPM3x=[ID4BPM3x y1];
   ID4BPM3y=[ID4BPM3y y2]; 
   ID4BPM4x=[ID4BPM4x y3];
   ID4BPM4y=[ID4BPM4y y4];
   
   [y1, i] = arselect('SR05S___IBPM1X_AM');
   [y2, i] = arselect('SR05S___IBPM1Y_AM');
   [y3, i] = arselect('SR05S___IBPM2X_AM');
   [y4, i] = arselect('SR05S___IBPM2Y_AM');
   ID5BPM1x=[ID5BPM1x y1];
   ID5BPM1y=[ID5BPM1y y2]; 
   ID5BPM2x=[ID5BPM2x y3];
   ID5BPM2y=[ID5BPM2y y4];
   
   [y1, i] = arselect('SR06S___IBPM1X_AM');
   [y2, i] = arselect('SR06S___IBPM1Y_AM');
   [y3, i] = arselect('SR06S___IBPM2X_AM');
   [y4, i] = arselect('SR06S___IBPM2Y_AM');
   ID6BPM1x=[ID6BPM1x y1];
   ID6BPM1y=[ID6BPM1y y2]; 
   ID6BPM2x=[ID6BPM2x y3];
   ID6BPM2y=[ID6BPM2y y4];
   
   [y1, i] = arselect('SR07S___IBPM1X_AM');
   [y2, i] = arselect('SR07S___IBPM1Y_AM');
   [y3, i] = arselect('SR07S___IBPM2X_AM');
   [y4, i] = arselect('SR07S___IBPM2Y_AM');
   ID7BPM1x=[ID7BPM1x y1];
   ID7BPM1y=[ID7BPM1y y2]; 
   ID7BPM2x=[ID7BPM2x y3];
   ID7BPM2y=[ID7BPM2y y4];
   
   [y1, i] = arselect('SR08S___IBPM1X_AM');
   [y2, i] = arselect('SR08S___IBPM1Y_AM');
   [y3, i] = arselect('SR08S___IBPM2X_AM');
   [y4, i] = arselect('SR08S___IBPM2Y_AM');
   ID8BPM1x=[ID8BPM1x y1];
   ID8BPM1y=[ID8BPM1y y2]; 
   ID8BPM2x=[ID8BPM2x y3];
   ID8BPM2y=[ID8BPM2y y4];
   
   [y1, i] = arselect('SR09S___IBPM1X_AM');
   [y2, i] = arselect('SR09S___IBPM1Y_AM');
   [y3, i] = arselect('SR09S___IBPM2X_AM');
   [y4, i] = arselect('SR09S___IBPM2Y_AM');
   ID9BPM1x=[ID9BPM1x y1];
   ID9BPM1y=[ID9BPM1y y2]; 
   ID9BPM2x=[ID9BPM2x y3];
   ID9BPM2y=[ID9BPM2y y4];
   
   [y1, i] = arselect('SR10S___IBPM1X_AM');
   [y2, i] = arselect('SR10S___IBPM1Y_AM');
   [y3, i] = arselect('SR10S___IBPM2X_AM');
   [y4, i] = arselect('SR10S___IBPM2Y_AM');
   ID10BPM1x=[ID10BPM1x y1];
   ID10BPM1y=[ID10BPM1y y2]; 
   ID10BPM2x=[ID10BPM2x y3];
   ID10BPM2y=[ID10BPM2y y4];
   
   [y1, i] = arselect('SR11S___IBPM1X_AM');
   [y2, i] = arselect('SR11S___IBPM1Y_AM');
   [y3, i] = arselect('SR11S___IBPM2X_AM');
   [y4, i] = arselect('SR11S___IBPM2Y_AM');
   ID11BPM1x=[ID11BPM1x y1];
   ID11BPM1y=[ID11BPM1y y2]; 
   ID11BPM2x=[ID11BPM2x y3];
   ID11BPM2y=[ID11BPM2y y4];
   
   [y1, i] = arselect('SR12S___IBPM1X_AM');
   [y2, i] = arselect('SR12S___IBPM1Y_AM');
   [y3, i] = arselect('SR12S___IBPM2X_AM');
   [y4, i] = arselect('SR12S___IBPM2Y_AM');
   ID12BPM1x=[ID12BPM1x y1];
   ID12BPM1y=[ID12BPM1y y2]; 
   ID12BPM2x=[ID12BPM2x y3];
   ID12BPM2y=[ID12BPM2y y4];
   
   [y1, i] = arselect('SR09S_IBPM2X_RMS');
   [y2, i] = arselect('SR09S_IBPM2Y_RMS');
   [y3, i] = arselect('SR09C_IBPM5X_RMS');
   [y4, i] = arselect('SR09C_IBPM5Y_RMS');
   ID9BPM2xRMS=[ID9BPM2xRMS y1];
   ID9BPM2yRMS=[ID9BPM2yRMS y2]; 
   ID9BPM5xRMS=[ID9BPM5xRMS y3];
   ID9BPM5yRMS=[ID9BPM5yRMS y4];
      
   %[y1, i] = arselect(getname('BPMx',[4 5]));
   %[y2, i] = arselect(getname('BPMy',[4 5]));
   BPM45x=[BPM45x y1];
   BPM45y=[BPM45y y2]; 
   
   [y1, i] = arselect('SR09C___BPM4XT_AM00');
   [y2, i] = arselect('SR09C___BPM4YT_AM01');
   BPM94x=[BPM94x y1];
   BPM94y=[BPM94y y2]; 
    
   [y1, i] = arselect('SR09C___BPM5XT_AM02');
   [y2, i] = arselect('SR09C___BPM5YT_AM03');
   BPM95x=[BPM95x y1];
   BPM95y=[BPM95y y2]; 

   [y1, i] = arselect('SR03S___C1TEMP_AM');
   [y2, i] = arselect('SR03S___C2TEMP_AM');
   C1TEMP=[C1TEMP y1];
   C2TEMP=[C2TEMP y2];
   
   [y1, i] = arselect('SR04S___SPIRICOAM07');
   [y2, i] = arselect('SR04S___SPIRICOAM08');
   SigX=[SigX y1];
   SigY=[SigY y2];
   
   [y1, i] = arselect('SR01C___FREQB__AM00');
   HPcounter=[HPcounter y1];
   
   [y1, i] = arselect('SR03S___RFFREQ_AM00RF');
   HPsyn=[HPsyn y1];
   
   [y1, i] = arselect('SR01C___QFA____AM00');
   QFAam=[QFAam y1];  
   
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
      if year1 < 2000
         year1str = year1str(3:4);
         FileName = sprintf('%2s%02d%02d', year1str, month, day);
      else
         FileName = sprintf('%4s%02d%02d', year1str, month, day);
      end
      arread(FileName, FFFlag);
      %readtime = etime(clock, t0)
      
      [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
      [y2, ilcw ] = arselect('SR03S___LCWTMP_AM00');
      dcct = [dcct y1];
      lcw  = [lcw  y2];
      
      [y1, igev] = arselect('cmm:sr_energy');
      gev = [gev y1];
   
      [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
      lifetime = [lifetime  y1];
      
      [y1,i]=arselect('SR04U___ODS1PS_AM00');
      EPU4 =[EPU4  y1];
      
      [y1,i]=arselect('SR04U___GDS1PS_AM00');
   IDgap4 =[IDgap4  y1];
   
   [y1,i]=arselect('SR05W___GDS1PS_AM00');
   IDgap5 =[IDgap5  y1];
   
   [y1,i]=arselect('SR07U___GDS1PS_AM00');
   IDgap7 =[IDgap7  y1];
   
   [y1,i]=arselect('SR08U___GDS1PS_AM00');
   IDgap8 =[IDgap8  y1];
   
   [y1,i]=arselect('SR09U___GDS1PS_AM00');
   IDgap9 =[IDgap9  y1];
   
   [y1,i]=arselect('SR10U___GDS1PS_AM00');
   IDgap10 =[IDgap10  y1];
   
   [y1,i]=arselect('SR12U___GDS1PS_AM00');
   IDgap12 =[IDgap12  y1];      
   
   if FFFlag
         [y1,i]=arselect('sr07u:FFEnable:bi');
         FF7Enable =[FF7Enable  y1];
      end
      
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
      
      [y1, i] = arselect('SR10U___IDTC1__AM');
      [y2, i] = arselect('SR10U___IDTC2__AM');
      [y3, i] = arselect('SR10U___IDTC3__AM');
      [y4, i] = arselect('SR10U___IDTC4__AM');
      TC10_1=[TC10_1 y1];
      TC10_2=[TC10_2 y2]; 
      TC10_3=[TC10_3 y3];
      TC10_4=[TC10_4 y4];

      [y1, i] = arselect('SR12U___IDTC1__AM');
      [y2, i] = arselect('SR12U___IDTC2__AM');
      [y3, i] = arselect('SR12U___IDTC3__AM');
      [y4, i] = arselect('SR12U___IDTC4__AM');
      TC12_1=[TC12_1 y1];
      TC12_2=[TC12_2 y2]; 
      TC12_3=[TC12_3 y3];
      TC12_4=[TC12_4 y4];
      
      [y1, i] = arselect('SR02S___IBPM1X_AM');
      [y2, i] = arselect('SR02S___IBPM1Y_AM');
      [y3, i] = arselect('SR02S___IBPM2X_AM');
      [y4, i] = arselect('SR02S___IBPM2Y_AM');
      ID2BPM1x=[ID2BPM1x y1];
      ID2BPM1y=[ID2BPM1y y2]; 
      ID2BPM2x=[ID2BPM2x y3];
      ID2BPM2y=[ID2BPM2y y4];
      
      [y1, i] = arselect('SR04S___IBPM1X_AM');
      [y2, i] = arselect('SR04S___IBPM1Y_AM');
      [y3, i] = arselect('SR04S___IBPM2X_AM');
      [y4, i] = arselect('SR04S___IBPM2Y_AM');
      ID4BPM1x=[ID4BPM1x y1];
      ID4BPM1y=[ID4BPM1y y2]; 
      ID4BPM2x=[ID4BPM2x y3];
      ID4BPM2y=[ID4BPM2y y4];
      
      [y1, i] = arselect('SR04S___IBPM3X_AM');
      [y2, i] = arselect('SR04S___IBPM3Y_AM');
      [y3, i] = arselect('SR04S___IBPM4X_AM');
      [y4, i] = arselect('SR04S___IBPM4Y_AM');
      ID4BPM3x=[ID4BPM3x y1];
      ID4BPM3y=[ID4BPM3y y2]; 
      ID4BPM4x=[ID4BPM4x y3];
      ID4BPM4y=[ID4BPM4y y4];
      
      [y1, i] = arselect('SR05S___IBPM1X_AM');
      [y2, i] = arselect('SR05S___IBPM1Y_AM');
      [y3, i] = arselect('SR05S___IBPM2X_AM');
      [y4, i] = arselect('SR05S___IBPM2Y_AM');
      ID5BPM1x=[ID5BPM1x y1];
      ID5BPM1y=[ID5BPM1y y2]; 
      ID5BPM2x=[ID5BPM2x y3];
      ID5BPM2y=[ID5BPM2y y4];
      
      [y1, i] = arselect('SR06S___IBPM1X_AM');
      [y2, i] = arselect('SR06S___IBPM1Y_AM');
      [y3, i] = arselect('SR06S___IBPM2X_AM');
      [y4, i] = arselect('SR06S___IBPM2Y_AM');
      ID6BPM1x=[ID6BPM1x y1];
      ID6BPM1y=[ID6BPM1y y2]; 
      ID6BPM2x=[ID6BPM2x y3];
      ID6BPM2y=[ID6BPM2y y4];
      
      [y1, i] = arselect('SR07S___IBPM1X_AM');
      [y2, i] = arselect('SR07S___IBPM1Y_AM');
      [y3, i] = arselect('SR07S___IBPM2X_AM');
      [y4, i] = arselect('SR07S___IBPM2Y_AM');
      ID7BPM1x=[ID7BPM1x y1];
      ID7BPM1y=[ID7BPM1y y2]; 
      ID7BPM2x=[ID7BPM2x y3];
      ID7BPM2y=[ID7BPM2y y4];
      
      [y1, i] = arselect('SR08S___IBPM1X_AM');
      [y2, i] = arselect('SR08S___IBPM1Y_AM');
      [y3, i] = arselect('SR08S___IBPM2X_AM');
      [y4, i] = arselect('SR08S___IBPM2Y_AM');
      ID8BPM1x=[ID8BPM1x y1];
      ID8BPM1y=[ID8BPM1y y2]; 
      ID8BPM2x=[ID8BPM2x y3];
      ID8BPM2y=[ID8BPM2y y4];
      
      [y1, i] = arselect('SR09S___IBPM1X_AM');
      [y2, i] = arselect('SR09S___IBPM1Y_AM');
      [y3, i] = arselect('SR09S___IBPM2X_AM');
      [y4, i] = arselect('SR09S___IBPM2Y_AM');
      ID9BPM1x=[ID9BPM1x y1];
      ID9BPM1y=[ID9BPM1y y2]; 
      ID9BPM2x=[ID9BPM2x y3];
      ID9BPM2y=[ID9BPM2y y4];
      
      [y1, i] = arselect('SR10S___IBPM1X_AM');
      [y2, i] = arselect('SR10S___IBPM1Y_AM');
      [y3, i] = arselect('SR10S___IBPM2X_AM');
      [y4, i] = arselect('SR10S___IBPM2Y_AM');
      ID10BPM1x=[ID10BPM1x y1];
      ID10BPM1y=[ID10BPM1y y2]; 
      ID10BPM2x=[ID10BPM2x y3];
      ID10BPM2y=[ID10BPM2y y4];
      
      [y1, i] = arselect('SR11S___IBPM1X_AM');
      [y2, i] = arselect('SR11S___IBPM1Y_AM');
      [y3, i] = arselect('SR11S___IBPM2X_AM');
      [y4, i] = arselect('SR11S___IBPM2Y_AM');
      ID11BPM1x=[ID11BPM1x y1];
      ID11BPM1y=[ID11BPM1y y2]; 
      ID11BPM2x=[ID11BPM2x y3];
      ID11BPM2y=[ID11BPM2y y4];
      
      [y1, i] = arselect('SR12S___IBPM1X_AM');
      [y2, i] = arselect('SR12S___IBPM1Y_AM');
      [y3, i] = arselect('SR12S___IBPM2X_AM');
      [y4, i] = arselect('SR12S___IBPM2Y_AM');
      ID12BPM1x=[ID12BPM1x y1];
      ID12BPM1y=[ID12BPM1y y2]; 
      ID12BPM2x=[ID12BPM2x y3];
      ID12BPM2y=[ID12BPM2y y4];
      
      [y1, i] = arselect('SR09S_IBPM2X_RMS');
      [y2, i] = arselect('SR09S_IBPM2Y_RMS');
      [y3, i] = arselect('SR09C_IBPM5X_RMS');
      [y4, i] = arselect('SR09C_IBPM5Y_RMS');
      ID9BPM2xRMS=[ID9BPM2xRMS y1];
      ID9BPM2yRMS=[ID9BPM2yRMS y2]; 
      ID9BPM5xRMS=[ID9BPM5xRMS y3];
      ID9BPM5yRMS=[ID9BPM5yRMS y4];
      
      %[y1, i] = arselect(getname('BPMx',[4 5]));
      %[y2, i] = arselect(getname('BPMy',[4 5]));
      BPM45x=[BPM45x y1];
      BPM45y=[BPM45y y2]; 
      
      [y1, i] = arselect('SR09C___BPM4XT_AM00');
      [y2, i] = arselect('SR09C___BPM4YT_AM01');
      BPM94x=[BPM94x y1];
      BPM94y=[BPM94y y2]; 
      
      [y1, i] = arselect('SR09C___BPM5XT_AM02');
      [y2, i] = arselect('SR09C___BPM5YT_AM03');
      BPM95x=[BPM95x y1];
      BPM95y=[BPM95y y2]; 
      
      [y1, i] = arselect('SR03S___C1TEMP_AM');
      [y2, i] = arselect('SR03S___C2TEMP_AM');
      C1TEMP=[C1TEMP y1];
      C2TEMP=[C2TEMP y2];
      
      [y1, i] = arselect('SR04S___SPIRICOAM07');
      [y2, i] = arselect('SR04S___SPIRICOAM08');
      SigX=[SigX y1];
      SigY=[SigY y2];
      
      [y1, i] = arselect('SR01C___FREQB__AM00');
      HPcounter=[HPcounter y1];
      
      [y1, i] = arselect('SR03S___RFFREQ_AM00RF');
      HPsyn=[HPsyn y1];
      
      [y1, i] = arselect('SR01C___QFA____AM00');
      QFAam=[QFAam y1];  
      
      t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
      
      disp(' ');
   end
end


% Plot data
dcct = 100*dcct;


% Remove points when the current is below .5 mamps for the lifetime calculation
i = find(dcct < .5);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime1 = -diff(t/60/60)./(dlogdcct);
i = find(lifetime1 < 0);
lifetime1(i) = NaN;


% Remove points when current is below 1 mamps
[y, i]=find(dcct<1);
ID2BPM1x(i)=NaN*ones(size(i));
ID2BPM1y(i)=NaN*ones(size(i));
ID2BPM2x(i)=NaN*ones(size(i));
ID2BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID5BPM1x(i)=NaN*ones(size(i));
ID5BPM1y(i)=NaN*ones(size(i));
ID5BPM2x(i)=NaN*ones(size(i));
ID5BPM2y(i)=NaN*ones(size(i));
ID6BPM1x(i)=NaN*ones(size(i));
ID6BPM1y(i)=NaN*ones(size(i));
ID6BPM2x(i)=NaN*ones(size(i));
ID6BPM2y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
ID9BPM1x(i)=NaN*ones(size(i));
ID9BPM1y(i)=NaN*ones(size(i));
ID9BPM2x(i)=NaN*ones(size(i));
ID9BPM2y(i)=NaN*ones(size(i));
ID10BPM1x(i)=NaN*ones(size(i));
ID10BPM1y(i)=NaN*ones(size(i));
ID10BPM2x(i)=NaN*ones(size(i));
ID10BPM2y(i)=NaN*ones(size(i));
ID11BPM1x(i)=NaN*ones(size(i));
ID11BPM1y(i)=NaN*ones(size(i));
ID11BPM2x(i)=NaN*ones(size(i));
ID11BPM2y(i)=NaN*ones(size(i));
ID12BPM1x(i)=NaN*ones(size(i));
ID12BPM1y(i)=NaN*ones(size(i));
ID12BPM2x(i)=NaN*ones(size(i));
ID12BPM2y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Remove points when FF is disabled
if FFFlag 
   [y, i]=find(FF7Enable==0);
   ID2BPM1x(i)=NaN*ones(size(i));
   ID2BPM1y(i)=NaN*ones(size(i));
   ID2BPM2x(i)=NaN*ones(size(i));
   ID2BPM2y(i)=NaN*ones(size(i));
   ID4BPM1x(i)=NaN*ones(size(i));
   ID4BPM1y(i)=NaN*ones(size(i));
   ID4BPM2x(i)=NaN*ones(size(i));
   ID4BPM2y(i)=NaN*ones(size(i));
   ID4BPM3x(i)=NaN*ones(size(i));
   ID4BPM3y(i)=NaN*ones(size(i));
   ID4BPM4x(i)=NaN*ones(size(i));
   ID4BPM4y(i)=NaN*ones(size(i));
   ID5BPM1x(i)=NaN*ones(size(i));
   ID5BPM1y(i)=NaN*ones(size(i));
   ID5BPM2x(i)=NaN*ones(size(i));
   ID5BPM2y(i)=NaN*ones(size(i));
   ID6BPM1x(i)=NaN*ones(size(i));
   ID6BPM1y(i)=NaN*ones(size(i));
   ID6BPM2x(i)=NaN*ones(size(i));
   ID6BPM2y(i)=NaN*ones(size(i));
   ID7BPM1x(i)=NaN*ones(size(i));
   ID7BPM1y(i)=NaN*ones(size(i));
   ID7BPM2x(i)=NaN*ones(size(i));
   ID7BPM2y(i)=NaN*ones(size(i));
   ID8BPM1x(i)=NaN*ones(size(i));
   ID8BPM1y(i)=NaN*ones(size(i));
   ID8BPM2x(i)=NaN*ones(size(i));
   ID8BPM2y(i)=NaN*ones(size(i));
   ID9BPM1x(i)=NaN*ones(size(i));
   ID9BPM1y(i)=NaN*ones(size(i));
   ID9BPM2x(i)=NaN*ones(size(i));
   ID9BPM2y(i)=NaN*ones(size(i));
   ID10BPM1x(i)=NaN*ones(size(i));
   ID10BPM1y(i)=NaN*ones(size(i));
   ID10BPM2x(i)=NaN*ones(size(i));
   ID10BPM2y(i)=NaN*ones(size(i));
   ID11BPM1x(i)=NaN*ones(size(i));
   ID11BPM1y(i)=NaN*ones(size(i));
   ID11BPM2x(i)=NaN*ones(size(i));
   ID11BPM2y(i)=NaN*ones(size(i));
   ID12BPM1x(i)=NaN*ones(size(i));
   ID12BPM1y(i)=NaN*ones(size(i));
   ID12BPM2x(i)=NaN*ones(size(i));
   ID12BPM2y(i)=NaN*ones(size(i));
   BPM45x(i)=NaN*ones(size(i));
   BPM45y(i)=NaN*ones(size(i));
   BPM94x(i)=NaN*ones(size(i));
   BPM94y(i)=NaN*ones(size(i));
   BPM95x(i)=NaN*ones(size(i));
   BPM95y(i)=NaN*ones(size(i));
   %dcct(i)=NaN*ones(size(i));
   EPU4(i)=NaN*ones(size(i));
   IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
   SigX(i)=NaN*ones(size(i));
   SigY(i)=NaN*ones(size(i));
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
end   

% Remove points when the gaps are open
j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
%j = any(IDgap < 80);
%j = any([IDgap9; IDgap9] < 80)
i = 1:length(t);
i(j) = [];
ID2BPM1x(i)=NaN*ones(size(i));
ID2BPM1y(i)=NaN*ones(size(i));
ID2BPM2x(i)=NaN*ones(size(i));
ID2BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID5BPM1x(i)=NaN*ones(size(i));
ID5BPM1y(i)=NaN*ones(size(i));
ID5BPM2x(i)=NaN*ones(size(i));
ID5BPM2y(i)=NaN*ones(size(i));
ID6BPM1x(i)=NaN*ones(size(i));
ID6BPM1y(i)=NaN*ones(size(i));
ID6BPM2x(i)=NaN*ones(size(i));
ID6BPM2y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
ID9BPM1x(i)=NaN*ones(size(i));
ID9BPM1y(i)=NaN*ones(size(i));
ID9BPM2x(i)=NaN*ones(size(i));
ID9BPM2y(i)=NaN*ones(size(i));
ID10BPM1x(i)=NaN*ones(size(i));
ID10BPM1y(i)=NaN*ones(size(i));
ID10BPM2x(i)=NaN*ones(size(i));
ID10BPM2y(i)=NaN*ones(size(i));
ID11BPM1x(i)=NaN*ones(size(i));
ID11BPM1y(i)=NaN*ones(size(i));
ID11BPM2x(i)=NaN*ones(size(i));
ID11BPM2y(i)=NaN*ones(size(i));
ID12BPM1x(i)=NaN*ones(size(i));
ID12BPM1y(i)=NaN*ones(size(i));
ID12BPM2x(i)=NaN*ones(size(i));
ID12BPM2y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Remove points before/after a NaN
[y, i]=find(isnan(ID2BPM1x));
i = i + 1;
if i(end) > length(ID2BPM1x)
   i = i(1:end-1);
end
ID2BPM1x(i)=NaN*ones(size(i));
ID2BPM1y(i)=NaN*ones(size(i));
ID2BPM2x(i)=NaN*ones(size(i));
ID2BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID5BPM1x(i)=NaN*ones(size(i));
ID5BPM1y(i)=NaN*ones(size(i));
ID5BPM2x(i)=NaN*ones(size(i));
ID5BPM2y(i)=NaN*ones(size(i));
ID6BPM1x(i)=NaN*ones(size(i));
ID6BPM1y(i)=NaN*ones(size(i));
ID6BPM2x(i)=NaN*ones(size(i));
ID6BPM2y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
ID9BPM1x(i)=NaN*ones(size(i));
ID9BPM1y(i)=NaN*ones(size(i));
ID9BPM2x(i)=NaN*ones(size(i));
ID9BPM2y(i)=NaN*ones(size(i));
ID10BPM1x(i)=NaN*ones(size(i));
ID10BPM1y(i)=NaN*ones(size(i));
ID10BPM2x(i)=NaN*ones(size(i));
ID10BPM2y(i)=NaN*ones(size(i));
ID11BPM1x(i)=NaN*ones(size(i));
ID11BPM1y(i)=NaN*ones(size(i));
ID11BPM2x(i)=NaN*ones(size(i));
ID11BPM2y(i)=NaN*ones(size(i));
ID12BPM1x(i)=NaN*ones(size(i));
ID12BPM1y(i)=NaN*ones(size(i));
ID12BPM2x(i)=NaN*ones(size(i));
ID12BPM2y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

i = i - 2;
if i(1) < 1
   i = i(2:end);
end
ID2BPM1x(i)=NaN*ones(size(i));
ID2BPM1y(i)=NaN*ones(size(i));
ID2BPM2x(i)=NaN*ones(size(i));
ID2BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID5BPM1x(i)=NaN*ones(size(i));
ID5BPM1y(i)=NaN*ones(size(i));
ID5BPM2x(i)=NaN*ones(size(i));
ID5BPM2y(i)=NaN*ones(size(i));
ID6BPM1x(i)=NaN*ones(size(i));
ID6BPM1y(i)=NaN*ones(size(i));
ID6BPM2x(i)=NaN*ones(size(i));
ID6BPM2y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
ID9BPM1x(i)=NaN*ones(size(i));
ID9BPM1y(i)=NaN*ones(size(i));
ID9BPM2x(i)=NaN*ones(size(i));
ID9BPM2y(i)=NaN*ones(size(i));
ID10BPM1x(i)=NaN*ones(size(i));
ID10BPM1y(i)=NaN*ones(size(i));
ID10BPM2x(i)=NaN*ones(size(i));
ID10BPM2y(i)=NaN*ones(size(i));
ID11BPM1x(i)=NaN*ones(size(i));
ID11BPM1y(i)=NaN*ones(size(i));
ID11BPM2x(i)=NaN*ones(size(i));
ID11BPM2y(i)=NaN*ones(size(i));
ID12BPM1x(i)=NaN*ones(size(i));
ID12BPM1y(i)=NaN*ones(size(i));
ID12BPM2x(i)=NaN*ones(size(i));
ID12BPM2y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Subtract the point at 9.5 hours
%i=find(ARt>9.5*60*60);
%i7_1x=ID7BPM1x(i(1)), ID7BPM1x=ID7BPM1x-ID7BPM1x(i(1));
%i7_1y=ID7BPM1y(i(1)), ID7BPM1y=ID7BPM1y-ID7BPM1y(i(1));
%i7_2x=ID7BPM2x(i(1)), ID7BPM2x=ID7BPM2x-ID7BPM2x(i(1));
%i7_2y=ID7BPM2y(i(1)), ID7BPM2y=ID7BPM2y-ID7BPM2y(i(1));
%i12_1x=ID12BPM1x(i(1)), ID12BPM1x=ID12BPM1x-ID12BPM1x(i(1));
%i12_1y=ID12BPM1y(i(1)), ID12BPM1y=ID12BPM1y-ID12BPM1y(i(1));
%i12_2x=ID12BPM2x(i(1)), ID12BPM2x=ID12BPM2x-ID12BPM2x(i(1));
%i12_2y=ID12BPM2y(i(1)), ID12BPM2y=ID12BPM2y-ID12BPM2y(i(1));


% Subtract known amount
IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',2)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',2)));
i2_1x=IDBPMgoalx(1); ID2BPM1x=ID2BPM1x-i2_1x;
i2_1y=IDBPMgoaly(1); ID2BPM1y=ID2BPM1y-i2_1y;
i2_2x=IDBPMgoalx(2); ID2BPM2x=ID2BPM2x-i2_2x;
i2_2y=IDBPMgoaly(2); ID2BPM2y=ID2BPM2y-i2_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',4)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',4)));
i4_1x=IDBPMgoalx(1); ID4BPM1x=ID4BPM1x-i4_1x;
i4_1y=IDBPMgoaly(1); ID4BPM1y=ID4BPM1y-i4_1y;
i4_2x=IDBPMgoalx(2); ID4BPM2x=ID4BPM2x-i4_2x;
i4_2y=IDBPMgoaly(2); ID4BPM2y=ID4BPM2y-i4_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',5)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',5)));
i5_1x=IDBPMgoalx(1); ID5BPM1x=ID5BPM1x-i5_1x;
i5_1y=IDBPMgoaly(1); ID5BPM1y=ID5BPM1y-i5_1y;
i5_2x=IDBPMgoalx(2); ID5BPM2x=ID5BPM2x-i5_2x;
i5_2y=IDBPMgoaly(2); ID5BPM2y=ID5BPM2y-i5_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',6)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',6)));
i6_1x=IDBPMgoalx(1); ID6BPM1x=ID6BPM1x-i6_1x;
i6_1y=IDBPMgoaly(1); ID6BPM1y=ID6BPM1y-i6_1y;
i6_2x=IDBPMgoalx(2); ID6BPM2x=ID6BPM2x-i6_2x;
i6_2y=IDBPMgoaly(2); ID6BPM2y=ID6BPM2y-i6_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',7)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',7)));
i7_1x=IDBPMgoalx(1); ID7BPM1x=ID7BPM1x-i7_1x;
i7_1y=IDBPMgoaly(1); ID7BPM1y=ID7BPM1y-i7_1y;
i7_2x=IDBPMgoalx(2); ID7BPM2x=ID7BPM2x-i7_2x;
i7_2y=IDBPMgoaly(2); ID7BPM2y=ID7BPM2y-i7_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',8)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',8)));
i8_1x=IDBPMgoalx(1); ID8BPM1x=ID8BPM1x-i8_1x;
i8_1y=IDBPMgoaly(1); ID8BPM1y=ID8BPM1y-i8_1y;
i8_2x=IDBPMgoalx(2); ID8BPM2x=ID8BPM2x-i8_2x;
i8_2y=IDBPMgoaly(2); ID8BPM2y=ID8BPM2y-i8_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',9)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',9)));
i9_1x=IDBPMgoalx(1); ID9BPM1x=ID9BPM1x-i9_1x;
i9_1y=IDBPMgoaly(1); ID9BPM1y=ID9BPM1y-i9_1y;
i9_2x=IDBPMgoalx(2); ID9BPM2x=ID9BPM2x-i9_2x;
i9_2y=IDBPMgoaly(2); ID9BPM2y=ID9BPM2y-i9_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',10)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',10)));
i10_1x=IDBPMgoalx(1); ID10BPM1x=ID10BPM1x-i10_1x;
i10_1y=IDBPMgoaly(1); ID10BPM1y=ID10BPM1y-i10_1y;
i10_2x=IDBPMgoalx(2); ID10BPM2x=ID10BPM2x-i10_2x;
i10_2y=IDBPMgoaly(2); ID10BPM2y=ID10BPM2y-i10_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',11)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',11)));
i11_1x=IDBPMgoalx(1); ID11BPM1x=ID11BPM1x-i11_1x;
i11_1y=IDBPMgoaly(1); ID11BPM1y=ID11BPM1y-i11_1y;
i11_2x=IDBPMgoalx(2); ID11BPM2x=ID11BPM2x-i11_2x;
i11_2y=IDBPMgoaly(2); ID11BPM2y=ID11BPM2y-i11_2y;

IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',12)));
IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',12)));
i12_1x=IDBPMgoalx(1); ID12BPM1x=ID12BPM1x-i12_1x;
i12_1y=IDBPMgoaly(1); ID12BPM1y=ID12BPM1y-i12_1y;
i12_2x=IDBPMgoalx(2); ID12BPM2x=ID12BPM2x-i12_2x;
i12_2y=IDBPMgoaly(2); ID12BPM2y=ID12BPM2y-i12_2y;


itmp = find(isnan(ID4BPM3x));
imean = 1:length(ID4BPM3x);
imean(itmp)=[];
%ID4BPM3x = ID4BPM3x - 1.089;
%ID4BPM3y = ID4BPM3y + .620;
%ID4BPM4x = ID4BPM4x - 1.015;
%ID4BPM4y = ID4BPM4y + .136;

%BPM94x = BPM94x + .270; 
%BPM94y = BPM94y + .030; 
%BPM95x = BPM95x - .070;
%BPM95y = BPM95y - .380;


% Find the tune shift due to insertion devices
%TuneShift = zeros(size(IDgap(1,:)));
%i = find(IDlist(:,1) == 5);              % remove sector 5
%list = 1:size(IDlist,1);
%list(i) = []; 
%for i = 1:length(list)
   %TuneShift = TuneShift + gap2tune(IDlist(list(i),1),IDgap(list(i),:),gev);
%end

% Hours or days for the x-axis?
if t(end)/60/60/24 > 3
   t = t/60/60/24;     % + days(1)
   xunitsstring = '[Days]';
else
   t = t/60/60;
   xunitsstring = '[Hours]';
end
xmax = max(t);


%fill length
filltime = [];
runtime= [];
t1=0;t2=0; %beginning and end of run (t2-t1 = filling time)
run=0; %false
for i = 1:length(t)
   if ((isnan(dcct(i)) == 1) & (run == 1))%marks end of run (current=no, was running) 
      t2=t(i);
      if t1 > t(1) & i < length(t)
         runtime=[runtime; t1 t2-t1];
      end
   else if ((isnan(dcct(i)) == 0) & (run == 0))%marks beginning of run (current=yes, not prev running)
         run=1;
         t1=t(i);
         %if i>1 & i < length(t)
            filltime=[filltime; t2 t1-t2];
            %end
        end
   end
end



figure(1); clf;
subplot(6,1,1);
plot(t, dcct, 'b'); grid on;
ylabel('Beam Current, I [mAmps]','fontsize',10);
title(titleStr);
axis([0 xmax 0 450]);

