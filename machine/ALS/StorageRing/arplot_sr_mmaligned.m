function arplot_sr_mmaligned(monthStr, days, year1, month2Str, days2, year2)
% arplot_sr_mmaligned(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots a whole bunch of storage ring related archived data.
% Only plots data when feed forward is on.
%
% Used for the special case when the spiricon beamsize monitor is set up
%		in "mm-aligned" mode
%
% Example #1:  arplot_sr_mmaligned('January',22:24,1998);
%              plots data from 1/22, 1/23, and 1/24 in 1998
%
% Example #2:  arplot_sr_mmaligned('January',28:31,1998,'February',1:4,1998);
%              plots data from the last 4 days in Jan. and the first 4 days in Feb.
%
% Greg Portmann, 1999
%
% modified by C. Steier, 2001

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

IDgap = [];
EPU4=[];

FF7Enable = [];

ID1BPM1x=[];
ID1BPM1y=[];

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

BPM44x=[];
BPM44y=[];

BPM45x=[];
BPM45y=[];

BPM84x=[];
BPM84y=[];

BPM85x=[];
BPM85y=[];

BPM94x=[];
BPM94y=[];

BPM95x=[];
BPM95y=[];

BPM124x=[];
BPM124y=[];

BPM125x=[];
BPM125y=[];

hqmofm=[];

SigX=[];
SigY=[];
SpiroX = [];
SpiroY = [];
Spirorient = [];

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
	try
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
		
		[y1,i]=arselect(getname('IDpos'));
		IDgap =[IDgap  y1];
		
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
      
  		[y1, i] = arselect('SR01S___IBPM1X_AM');
		[y2, i] = arselect('SR01S___IBPM1Y_AM');
%		[y3, i] = arselect('SR01S___IBPM2X_AM');
%		[y4, i] = arselect('SR01S___IBPM2Y_AM');
		ID1BPM1x=[ID1BPM1x y1];
		ID1BPM1y=[ID1BPM1y y2]; 
%		ID1BPM2x=[ID1BPM2x y3];
%		ID1BPM2y=[ID1BPM2y y4];

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
		
   		[y1, i] = arselect('SR04C___BPM4XT_AM00');
		[y2, i] = arselect('SR04C___BPM4YT_AM01');
		BPM44x=[BPM44x y1];
		BPM44y=[BPM44y y2]; 
		
		[y1, i] = arselect('SR04C___BPM5XT_AM02');
		[y2, i] = arselect('SR04C___BPM5YT_AM03');
		BPM45x=[BPM45x y1];
		BPM45y=[BPM45y y2]; 
      
   		[y1, i] = arselect('SR08C___BPM4XT_AM00');
		[y2, i] = arselect('SR08C___BPM4YT_AM01');
		BPM84x=[BPM84x y1];
		BPM84y=[BPM84y y2]; 
		
		[y1, i] = arselect('SR08C___BPM5XT_AM02');
		[y2, i] = arselect('SR08C___BPM5YT_AM03');
		BPM85x=[BPM85x y1];
		BPM85y=[BPM85y y2]; 
		
		[y1, i] = arselect('SR09C___BPM4XT_AM00');
		[y2, i] = arselect('SR09C___BPM4YT_AM01');
		BPM94x=[BPM94x y1];
		BPM94y=[BPM94y y2]; 
		
		[y1, i] = arselect('SR09C___BPM5XT_AM02');
		[y2, i] = arselect('SR09C___BPM5YT_AM03');
		BPM95x=[BPM95x y1];
		BPM95y=[BPM95y y2]; 
      
   		[y1, i] = arselect('SR12C___BPM4XT_AM00');
		[y2, i] = arselect('SR12C___BPM4YT_AM01');
		BPM124x=[BPM124x y1];
		BPM124y=[BPM124y y2]; 
		
		[y1, i] = arselect('SR12C___BPM5XT_AM02');
		[y2, i] = arselect('SR12C___BPM5YT_AM03');
		BPM125x=[BPM125x y1];
		BPM125y=[BPM125y y2]; 
 
		[y1, i] = arselect('SR03S___C1TEMP_AM');
		[y2, i] = arselect('SR03S___C2TEMP_AM');
		C1TEMP=[C1TEMP y1];
		C2TEMP=[C2TEMP y2];
		
		[y1, i] = arselect('SR04S___SPIRICOAM06');
		[y2, i] = arselect('SR04S___SPIRICOAM11');
		SigX=[SigX y1];
		SigY=[SigY y2];
		
		[y1, i] = arselect('SR04S___SPIRICOAM01');
		[y2, i] = arselect('SR04S___SPIRICOAM02');
		SpiroX=[SpiroX y1];
      SpiroY=[SpiroY y2];
      
      [y1, i] = arselect('SR04S___SPIRICOAM03');
      Spirorient=[Spirorient y1];

		[y1, i] = arselect('SR01C___FREQB__AM00');
		HPcounter=[HPcounter y1];
		
		[y1, i] = arselect('SR03S___RFFREQ_AM00RF');
		HPsyn=[HPsyn y1];
      
		[y1, i] = arselect('EG______HQMOFM_AC01');
		hqmofm=[hqmofm y1*4.988e3];

   		[y1, i] = arselect('SR01C___QFA____AM00');
		QFAam=[QFAam y1];  
		
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
			
			[y1,i]=arselect(getname('IDpos'));
			IDgap =[IDgap  y1];
			
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
         
   		[y1, i] = arselect('SR01S___IBPM1X_AM');
		[y2, i] = arselect('SR01S___IBPM1Y_AM');
%		[y3, i] = arselect('SR01S___IBPM2X_AM');
%		[y4, i] = arselect('SR01S___IBPM2Y_AM');
		ID1BPM1x=[ID1BPM1x y1];
		ID1BPM1y=[ID1BPM1y y2]; 
%		ID1BPM2x=[ID1BPM2x y3];
%		ID1BPM2y=[ID1BPM2y y4];

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
			
     		[y1, i] = arselect('SR04C___BPM4XT_AM00');
    		[y2, i] = arselect('SR04C___BPM4YT_AM01');
    	 	BPM44x=[BPM44x y1];
    		BPM44y=[BPM44y y2]; 
		
    		[y1, i] = arselect('SR04C___BPM5XT_AM02');
    		[y2, i] = arselect('SR04C___BPM5YT_AM03');
    		BPM45x=[BPM45x y1];
    		BPM45y=[BPM45y y2]; 
      
         [y1, i] = arselect('SR08C___BPM4XT_AM00');
         [y2, i] = arselect('SR08C___BPM4YT_AM01');
         BPM84x=[BPM84x y1];
         BPM84y=[BPM84y y2]; 
         
         [y1, i] = arselect('SR08C___BPM5XT_AM02');
         [y2, i] = arselect('SR08C___BPM5YT_AM03');
         BPM85x=[BPM85x y1];
         BPM85y=[BPM85y y2]; 
         
         [y1, i] = arselect('SR09C___BPM4XT_AM00');
         [y2, i] = arselect('SR09C___BPM4YT_AM01');
         BPM94x=[BPM94x y1];
         BPM94y=[BPM94y y2]; 
         
         [y1, i] = arselect('SR09C___BPM5XT_AM02');
         [y2, i] = arselect('SR09C___BPM5YT_AM03');
         BPM95x=[BPM95x y1];
         BPM95y=[BPM95y y2]; 
         
         [y1, i] = arselect('SR12C___BPM4XT_AM00');
         [y2, i] = arselect('SR12C___BPM4YT_AM01');
         BPM124x=[BPM124x y1];
         BPM124y=[BPM124y y2]; 
         
         [y1, i] = arselect('SR12C___BPM5XT_AM02');
         [y2, i] = arselect('SR12C___BPM5YT_AM03');
         BPM125x=[BPM125x y1];
         BPM125y=[BPM125y y2]; 
         
         [y1, i] = arselect('SR03S___C1TEMP_AM');
			[y2, i] = arselect('SR03S___C2TEMP_AM');
			C1TEMP=[C1TEMP y1];
			C2TEMP=[C2TEMP y2];
			
			[y1, i] = arselect('SR04S___SPIRICOAM06');
			[y2, i] = arselect('SR04S___SPIRICOAM11');
			SigX=[SigX y1];
			SigY=[SigY y2];
			
			[y1, i] = arselect('SR04S___SPIRICOAM01');
			[y2, i] = arselect('SR04S___SPIRICOAM02');
			SpiroX=[SpiroX y1];
			SpiroY=[SpiroY y2];
	      
      	[y1, i] = arselect('SR04S___SPIRICOAM03');
      	Spirorient=[Spirorient y1];
		
			[y1, i] = arselect('SR01C___FREQB__AM00');
			HPcounter=[HPcounter y1];
			
			[y1, i] = arselect('SR03S___RFFREQ_AM00RF');
			HPsyn=[HPsyn y1];
         
    		[y1, i] = arselect('EG______HQMOFM_AC01');
	    	hqmofm=[hqmofm y1*4.988e3];
         
			[y1, i] = arselect('SR01C___QFA____AM00');
			QFAam=[QFAam y1];  
			
			t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
			
		catch
			fprintf('  Error reading archived data file.\n');
			fprintf('  %s will be ignored.\n', FileName);
		end
		
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
ID1BPM1x(i)=NaN*ones(size(i));
ID1BPM1y(i)=NaN*ones(size(i));
% ID1BPM2x(i)=NaN*ones(size(i));
% ID1BPM2y(i)=NaN*ones(size(i));
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
BPM44x(i)=NaN*ones(size(i));
BPM44y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM84x(i)=NaN*ones(size(i));
BPM84y(i)=NaN*ones(size(i));
BPM85x(i)=NaN*ones(size(i));
BPM85y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
BPM124x(i)=NaN*ones(size(i));
BPM124y(i)=NaN*ones(size(i));
BPM125x(i)=NaN*ones(size(i));
BPM125y(i)=NaN*ones(size(i));
ID9BPM2xRMS(i)=NaN*ones(size(i));
ID9BPM5xRMS(i)=NaN*ones(size(i));
ID9BPM2yRMS(i)=NaN*ones(size(i));
ID9BPM5yRMS(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
SpiroX(i)=NaN*ones(size(i));
SpiroY(i)=NaN*ones(size(i));
Spirorient(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Remove points when FF is disabled
if FFFlag 
   [y, i]=find(FF7Enable==0);
   ID1BPM1x(i)=NaN*ones(size(i));
   ID1BPM1y(i)=NaN*ones(size(i));
%   ID1BPM2x(i)=NaN*ones(size(i));
%   ID1BPM2y(i)=NaN*ones(size(i));
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
   BPM44x(i)=NaN*ones(size(i));
   BPM44y(i)=NaN*ones(size(i));
   BPM45x(i)=NaN*ones(size(i));
   BPM45y(i)=NaN*ones(size(i));
   BPM84x(i)=NaN*ones(size(i));
   BPM84y(i)=NaN*ones(size(i));
   BPM85x(i)=NaN*ones(size(i));
   BPM85y(i)=NaN*ones(size(i));
   BPM94x(i)=NaN*ones(size(i));
   BPM94y(i)=NaN*ones(size(i));
   BPM95x(i)=NaN*ones(size(i));
   BPM95y(i)=NaN*ones(size(i));
   BPM124x(i)=NaN*ones(size(i));
   BPM124y(i)=NaN*ones(size(i));
   BPM125x(i)=NaN*ones(size(i));
   BPM125y(i)=NaN*ones(size(i));
	ID9BPM2xRMS(i)=NaN*ones(size(i));
	ID9BPM5xRMS(i)=NaN*ones(size(i));
	ID9BPM2yRMS(i)=NaN*ones(size(i));
	ID9BPM5yRMS(i)=NaN*ones(size(i));
   %dcct(i)=NaN*ones(size(i));
   EPU4(i)=NaN*ones(size(i));
   IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
   SigX(i)=NaN*ones(size(i));
   SigY(i)=NaN*ones(size(i));
	SpiroX(i)=NaN*ones(size(i));	
	SpiroY(i)=NaN*ones(size(i));
	Spirorient(i)=NaN*ones(size(i));
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
end   

% Remove points when the gaps are open
%j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
j = any(IDgap < 80);
i = 1:length(t);
i(j) = [];
ID1BPM1x(i)=NaN*ones(size(i));
ID1BPM1y(i)=NaN*ones(size(i));
% ID1BPM2x(i)=NaN*ones(size(i));
% ID1BPM2y(i)=NaN*ones(size(i));
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
BPM44x(i)=NaN*ones(size(i));
BPM44y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM84x(i)=NaN*ones(size(i));
BPM84y(i)=NaN*ones(size(i));
BPM85x(i)=NaN*ones(size(i));
BPM85y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
BPM124x(i)=NaN*ones(size(i));
BPM124y(i)=NaN*ones(size(i));
BPM125x(i)=NaN*ones(size(i));
BPM125y(i)=NaN*ones(size(i));
ID9BPM2xRMS(i)=NaN*ones(size(i));
ID9BPM5xRMS(i)=NaN*ones(size(i));
ID9BPM2yRMS(i)=NaN*ones(size(i));
ID9BPM5yRMS(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
SpiroX(i)=NaN*ones(size(i));
SpiroY(i)=NaN*ones(size(i));
Spirorient(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Remove points before/after a NaN
[y, i]=find(isnan(ID2BPM1x));
i = i + 1;
if i(end) > length(ID2BPM1x)
   i = i(1:end-1);
end
ID1BPM1x(i)=NaN*ones(size(i));
ID1BPM1y(i)=NaN*ones(size(i));
% ID1BPM2x(i)=NaN*ones(size(i));
% ID1BPM2y(i)=NaN*ones(size(i));
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
BPM44x(i)=NaN*ones(size(i));
BPM44y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM84x(i)=NaN*ones(size(i));
BPM84y(i)=NaN*ones(size(i));
BPM85x(i)=NaN*ones(size(i));
BPM85y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
BPM124x(i)=NaN*ones(size(i));
BPM124y(i)=NaN*ones(size(i));
BPM125x(i)=NaN*ones(size(i));
BPM125y(i)=NaN*ones(size(i));
ID9BPM2xRMS(i)=NaN*ones(size(i));
ID9BPM5xRMS(i)=NaN*ones(size(i));
ID9BPM2yRMS(i)=NaN*ones(size(i));
ID9BPM5yRMS(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
SpiroX(i)=NaN*ones(size(i));
SpiroY(i)=NaN*ones(size(i));
Spirorient(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

i = i - 2;
if i(1) < 1
   i = i(2:end);
end
ID1BPM1x(i)=NaN*ones(size(i));
ID1BPM1y(i)=NaN*ones(size(i));
% ID1BPM2x(i)=NaN*ones(size(i));
% ID1BPM2y(i)=NaN*ones(size(i));
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
BPM44x(i)=NaN*ones(size(i));
BPM44y(i)=NaN*ones(size(i));
BPM45x(i)=NaN*ones(size(i));
BPM45y(i)=NaN*ones(size(i));
BPM84x(i)=NaN*ones(size(i));
BPM84y(i)=NaN*ones(size(i));
BPM85x(i)=NaN*ones(size(i));
BPM85y(i)=NaN*ones(size(i));
BPM94x(i)=NaN*ones(size(i));
BPM94y(i)=NaN*ones(size(i));
BPM95x(i)=NaN*ones(size(i));
BPM95y(i)=NaN*ones(size(i));
BPM124x(i)=NaN*ones(size(i));
BPM124y(i)=NaN*ones(size(i));
BPM125x(i)=NaN*ones(size(i));
BPM125y(i)=NaN*ones(size(i));
ID9BPM2xRMS(i)=NaN*ones(size(i));
ID9BPM5xRMS(i)=NaN*ones(size(i));
ID9BPM2yRMS(i)=NaN*ones(size(i));
ID9BPM5yRMS(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU4(i)=NaN*ones(size(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX(i)=NaN*ones(size(i));
SigY(i)=NaN*ones(size(i));
SpiroX(i)=NaN*ones(size(i));
SpiroY(i)=NaN*ones(size(i));
Spirorient(i)=NaN*ones(size(i));
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


% Subtract known amount (golden orbit)
Sector = 1;
IDBPMgoalx = getgolden('BPMx', [12 9; 1 2]);
IDBPMgoaly = getgolden('BPMy', [12 9; 1 2]);
i1_1x=IDBPMgoalx(1); ID1BPM1x=ID1BPM1x-i1_1x;
i1_1y=IDBPMgoaly(1); ID1BPM1y=ID1BPM1y-i1_1y;
i1_2x=IDBPMgoalx(2); ID1BPM2x=ID1BPM2x-i1_2x;
i1_2y=IDBPMgoaly(2); ID1BPM2y=ID1BPM2y-i1_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b1_4x=BBPMgoalx(1); BPM14x=BPM14x-b1_4x;
b1_4y=BBPMgoaly(1); BPM14y=BPM14y-b1_4y;
b1_5x=BBPMgoalx(2); BPM15x=BPM15x-b1_5x;
b1_5y=BBPMgoaly(2); BPM15y=BPM15y-b1_5y;

Sector = 2;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i2_1x=IDBPMgoalx(1); ID2BPM1x=ID2BPM1x-i2_1x;
i2_1y=IDBPMgoaly(1); ID2BPM1y=ID2BPM1y-i2_1y;
i2_2x=IDBPMgoalx(2); ID2BPM2x=ID2BPM2x-i2_2x;
i2_2y=IDBPMgoaly(2); ID2BPM2y=ID2BPM2y-i2_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b2_4x=BBPMgoalx(1); BPM24x=BPM24x-b2_4x;
b2_4y=BBPMgoaly(1); BPM24y=BPM24y-b2_4y;
b2_5x=BBPMgoalx(2); BPM25x=BPM25x-b2_5x;
b2_5y=BBPMgoaly(2); BPM25y=BPM25y-b2_5y;

Sector = 3;
IDBPMgoalx = getgolden('BPMx', [Sector-1 9; Sector 2]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 9; Sector 2]);
i3_1x=IDBPMgoalx(1); ID3BPM1x=ID3BPM1x-i3_1x;
i3_1y=IDBPMgoaly(1); ID3BPM1y=ID3BPM1y-i3_1y;
i3_2x=IDBPMgoalx(2); ID3BPM2x=ID3BPM2x-i3_2x;
i3_2y=IDBPMgoaly(2); ID3BPM2y=ID3BPM2y-i3_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b3_4x=BBPMgoalx(1); BPM34x=BPM34x-b3_4x;
b3_4y=BBPMgoaly(1); BPM34y=BPM34y-b3_4y;
b3_5x=BBPMgoalx(2); BPM35x=BPM35x-b3_5x;
b3_5y=BBPMgoaly(2); BPM35y=BPM35y-b3_5y;

Sector = 4;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i4_1x=IDBPMgoalx(1); ID4BPM1x=ID4BPM1x-i4_1x;
i4_1y=IDBPMgoaly(1); ID4BPM1y=ID4BPM1y-i4_1y;
i4_2x=IDBPMgoalx(2); ID4BPM2x=ID4BPM2x-i4_2x;
i4_2y=IDBPMgoaly(2); ID4BPM2y=ID4BPM2y-i4_2y;

IDBPMgoalx = getgolden('IDBPMx', [Sector-1 11; Sector-1 12]);
IDBPMgoaly = getgolden('IDBPMy', [Sector-1 11; Sector-1 12]);
i4_3x=IDBPMgoalx(1); ID4BPM3x=ID4BPM3x-i4_3x;
i4_3y=IDBPMgoaly(1); ID4BPM3y=ID4BPM3y-i4_3y;
i4_4x=IDBPMgoalx(2); ID4BPM4x=ID4BPM4x-i4_4x;
i4_4y=IDBPMgoaly(2); ID4BPM4y=ID4BPM4y-i4_4y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b4_4x=BBPMgoalx(1); BPM44x=BPM44x-b4_4x;
b4_4y=BBPMgoaly(1); BPM44y=BPM44y-b4_4y;
b4_5x=BBPMgoalx(2); BPM45x=BPM45x-b4_5x;
b4_5y=BBPMgoaly(2); BPM45y=BPM45y-b4_5y;

Sector = 5;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i5_1x=IDBPMgoalx(1); ID5BPM1x=ID5BPM1x-i5_1x;
i5_1y=IDBPMgoaly(1); ID5BPM1y=ID5BPM1y-i5_1y;
i5_2x=IDBPMgoalx(2); ID5BPM2x=ID5BPM2x-i5_2x;
i5_2y=IDBPMgoaly(2); ID5BPM2y=ID5BPM2y-i5_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b5_4x=BBPMgoalx(1); BPM54x=BPM54x-b5_4x;
b5_4y=BBPMgoaly(1); BPM54y=BPM54y-b5_4y;
b5_5x=BBPMgoalx(2); BPM55x=BPM55x-b5_5x;
b5_5y=BBPMgoaly(2); BPM55y=BPM55y-b5_5y;

Sector = 6;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i6_1x=IDBPMgoalx(1); ID6BPM1x=ID6BPM1x-i6_1x;
i6_1y=IDBPMgoaly(1); ID6BPM1y=ID6BPM1y-i6_1y;
i6_2x=IDBPMgoalx(2); ID6BPM2x=ID6BPM2x-i6_2x;
i6_2y=IDBPMgoaly(2); ID6BPM2y=ID6BPM2y-i6_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b6_4x=BBPMgoalx(1); BPM64x=BPM64x-b6_4x;
b6_4y=BBPMgoaly(1); BPM64y=BPM64y-b6_4y;
b6_5x=BBPMgoalx(2); BPM65x=BPM65x-b6_5x;
b6_5y=BBPMgoaly(2); BPM65y=BPM65y-b6_5y;

Sector =7;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i7_1x=IDBPMgoalx(1); ID7BPM1x=ID7BPM1x-i7_1x;
i7_1y=IDBPMgoaly(1); ID7BPM1y=ID7BPM1y-i7_1y;
i7_2x=IDBPMgoalx(2); ID7BPM2x=ID7BPM2x-i7_2x;
i7_2y=IDBPMgoaly(2); ID7BPM2y=ID7BPM2y-i7_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b7_4x=BBPMgoalx(1); BPM74x=BPM74x-b7_4x;
b7_4y=BBPMgoaly(1); BPM74y=BPM74y-b7_4y;
b7_5x=BBPMgoalx(2); BPM75x=BPM75x-b7_5x;
b7_5y=BBPMgoaly(2); BPM75y=BPM75y-b7_5y;

Sector = 8;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i8_1x=IDBPMgoalx(1); ID8BPM1x=ID8BPM1x-i8_1x;
i8_1y=IDBPMgoaly(1); ID8BPM1y=ID8BPM1y-i8_1y;
i8_2x=IDBPMgoalx(2); ID8BPM2x=ID8BPM2x-i8_2x;
i8_2y=IDBPMgoaly(2); ID8BPM2y=ID8BPM2y-i8_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b8_4x=BBPMgoalx(1); BPM84x=BPM84x-b8_4x;
b8_4y=BBPMgoaly(1); BPM84y=BPM84y-b8_4y;
b8_5x=BBPMgoalx(2); BPM85x=BPM85x-b8_5x;
b8_5y=BBPMgoaly(2); BPM85y=BPM85y-b8_5y;

Sector = 9;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i9_1x=IDBPMgoalx(1); ID9BPM1x=ID9BPM1x-i9_1x;
i9_1y=IDBPMgoaly(1); ID9BPM1y=ID9BPM1y-i9_1y;
i9_2x=IDBPMgoalx(2); ID9BPM2x=ID9BPM2x-i9_2x;
i9_2y=IDBPMgoaly(2); ID9BPM2y=ID9BPM2y-i9_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b9_4x=BBPMgoalx(1); BPM94x=BPM94x-b9_4x;
b9_4y=BBPMgoaly(1); BPM94y=BPM94y-b9_4y;
b9_5x=BBPMgoalx(2); BPM95x=BPM95x-b9_5x;
b9_5y=BBPMgoaly(2); BPM95y=BPM95y-b9_5y;

Sector = 10;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i10_1x=IDBPMgoalx(1); ID10BPM1x=ID10BPM1x-i10_1x;
i10_1y=IDBPMgoaly(1); ID10BPM1y=ID10BPM1y-i10_1y;
i10_2x=IDBPMgoalx(2); ID10BPM2x=ID10BPM2x-i10_2x;
i10_2y=IDBPMgoaly(2); ID10BPM2y=ID10BPM2y-i10_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b10_4x=BBPMgoalx(1); BPM104x=BPM104x-b10_4x;
b10_4y=BBPMgoaly(1); BPM104y=BPM104y-b10_4y;
b10_5x=BBPMgoalx(2); BPM105x=BPM105x-b10_5x;
b10_5y=BBPMgoaly(2); BPM105y=BPM105y-b10_5y;

Sector = 11;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i11_1x=IDBPMgoalx(1); ID11BPM1x=ID11BPM1x-i11_1x;
i11_1y=IDBPMgoaly(1); ID11BPM1y=ID11BPM1y-i11_1y;
i11_2x=IDBPMgoalx(2); ID11BPM2x=ID11BPM2x-i11_2x;
i11_2y=IDBPMgoaly(2); ID11BPM2y=ID11BPM2y-i11_2y;

IDBPMgoalx = getgolden('IDBPMx', [Sector-1 11; Sector-1 12]);
IDBPMgoaly = getgolden('IDBPMy', [Sector-1 11; Sector-1 12]);
i11_3x=IDBPMgoalx(1); ID11BPM3x=ID11BPM3x-i11_3x;
i11_3y=IDBPMgoaly(1); ID11BPM3y=ID11BPM3y-i11_3y;
i11_4x=IDBPMgoalx(2); ID11BPM4x=ID11BPM4x-i11_4x;
i11_4y=IDBPMgoaly(2); ID11BPM4y=ID11BPM4y-i11_4y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b11_4x=BBPMgoalx(1); BPM114x=BPM114x-b11_4x;
b11_4y=BBPMgoaly(1); BPM114y=BPM114y-b11_4y;
b11_5x=BBPMgoalx(2); BPM115x=BPM115x-b11_5x;
b11_5y=BBPMgoaly(2); BPM115y=BPM115y-b11_5y;

Sector = 12;
IDBPMgoalx = getgolden('BPMx', [Sector-1 10; Sector 1]);
IDBPMgoaly = getgolden('BPMy', [Sector-1 10; Sector 1]);
i12_1x=IDBPMgoalx(1); ID12BPM1x=ID12BPM1x-i12_1x;
i12_1y=IDBPMgoaly(1); ID12BPM1y=ID12BPM1y-i12_1y;
i12_2x=IDBPMgoalx(2); ID12BPM2x=ID12BPM2x-i12_2x;
i12_2y=IDBPMgoaly(2); ID12BPM2y=ID12BPM2y-i12_2y;

BBPMgoalx = getgolden('BPMx', [Sector 5; Sector 6]);
BBPMgoaly = getgolden('BPMy', [Sector 5; Sector 6]);
b12_4x=BBPMgoalx(1); BPM124x=BPM124x-b12_4x;
b12_4y=BBPMgoaly(1); BPM124y=BPM124y-b12_4y;
b12_5x=BBPMgoalx(2); BPM125x=BPM125x-b12_5x;
b12_5y=BBPMgoaly(2); BPM125y=BPM125y-b12_5y;


% Find the tune shift due to insertion devices
TuneShift = zeros(size(IDgap(1,:)));
i = find(IDlist(:,1) == 5);              % remove sector 5
list = 1:size(IDlist,1);
list(i) = []; 
for i = 1:length(list)
   TuneShift = TuneShift + gap2tune(IDlist(list(i),1),IDgap(list(i),:),gev);
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

figure(1); clf;
subplot(7,1,1);
plot(t, dcct, 'b'); grid on;
ylabel('Beam Current, I [mAmps]','fontsize',10);
title(titleStr);
axis([0 xmax 0 450]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,2);
plot(t, lifetime, 'b'); grid on;
%plot(t, lifetime, 'b', t(2:end)/60/60, lifetime1, 'r'); grid on;
ylabel('Lifetime, \tau [Hours]','fontsize',10);
axis([0 xmax 0 18]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,3);
plot(t, SigX/2.0,'-b',t, SigY/2.0,'r'); grid on;
ylabel('\fontsize{7}RMS  \fontsize{14}\sigma_x \sigma_y \fontsize{10}[\mum]');
axis tight;
axis([0 xmax 30 90]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,4);
plot(t, Spirorient,'b'); grid on;
ylabel('Orientation [deg]','fontsize',10);
axis tight;
axis([0 xmax -100 100]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,5);
plot(t, dcct .* lifetime ./ (SigX/2.0) ./ (SigY/2.0), 'b'); grid on;
ylabel('I \tau / (\sigma_x \sigma_y)','fontsize',10);
axis([0 xmax .25 1.25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,6);
plot(t,TuneShift,'b'); grid on;
ylabel('\Delta \nu_y(Gap)^1','fontsize',10);
axis([0 xmax 0 .05]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,7)
plot(t,IDgap);
hold on;
plot(t,EPU4,'r');
hold off
xlabel(xlabelstring);
ylabel('Insertion Device Gap [mm]','fontsize',10);
%legend('ID4','ID5  ','ID7  ', 'ID8  ', 'ID9  ','ID10  ','ID12  ');
axis([0 xmax -27 60]);
ChangeAxesLabel(t, Days, DayFlag);
orient tall
addlabel(1,0,'^1W16 and EPU(4) longitudinal tune shifts are not included.');


figure(2); clf;

subplot(14,1,1);
% plot(t, 1000*ID1BPM1x, '-b', t, 1000*ID1BPM2x, '--r'); grid on;
plot(t, 1000*ID1BPM1x, '-b'); grid on;
ylabel('1');
title(['Horizontal IDBPM Data in \mum: ',titleStr]);
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,2);
plot(t, 1000*ID2BPM1x, '-b', t, 1000*ID2BPM2x, '--r'); grid on;
ylabel('2');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,3);
plot(t, 1000*ID4BPM1x, '-b', t, 1000*ID4BPM2x, '--r',...
   t, 1000*ID4BPM3x, '-c', t, 1000*ID4BPM4x, '--m'); grid on;
ylabel('4EPU');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,4);
plot(t, 1000*ID5BPM1x, '-b', t, 1000*ID5BPM2x, '--r'); grid on;
ylabel('5W');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,5);
plot(t, 1000*ID6BPM1x, '-b', t, 1000*ID6BPM2x, '--r'); grid on;
ylabel('6');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,6);
plot(t, 1000*ID7BPM1x, '-b', t, 1000*ID7BPM2x, '--r'); grid on;
ylabel('7U');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,7);
plot(t, 1000*ID8BPM1x, '-b', t, 1000*ID8BPM2x, '--r'); grid on;
ylabel('8U');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,8);
plot(t, 1000*ID9BPM1x, '-b', t, 1000*ID9BPM2x, '--r'); grid on;
ylabel('9U');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,9);
plot(t, 1000*ID10BPM1x, '-b', t, 1000*ID10BPM2x, '--r'); grid on;
ylabel('10U');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,10);
plot(t, 1000*ID11BPM1x, '-b', t, 1000*ID11BPM2x, '--r'); grid on;
ylabel('11');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,11);
plot(t, 1000*ID12BPM1x, '-b', t, 1000*ID12BPM2x, '--r'); grid on;
xlabel(xlabelstring);
ylabel('12U');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(14,1,12);

plot(t, 1000*BPM44x, '-', t, 1000*BPM45x, '--',...
	t, 1000*BPM84x, '-', t, 1000*BPM85x, '--',...
   t, 1000*BPM94x, '-', t, 1000*BPM95x, '--',...
   t, 1000*BPM124x, '-', t, 1000*BPM125x, '--'); grid on;
ylabel('arc 4,8,9,12');
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(14,1,13);
plot(t, ID9BPM2xRMS, '-b', t, ID9BPM5xRMS, '--r'); grid on;
ylabel('rms noise');
axis tight;
axis([0 xmax 0 6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(14,1,14);
plot(t, hqmofm); grid on;
xlabel(xlabelstring);
ylabel('\Delta f_{RF} [Hz]');
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);

orient tall

%addlabel(1,0,sprintf('Mean removed from: X(4,3)=%.3f, X(4,4)=%.3f, X(9,4)=%.3f, X(9,5)=%.3f',mean(ID4BPM3x(imean)),mean(ID4BPM4x(imean)),mean(BPM94x(imean)),mean(BPM95x(imean))));
%addlabel(1,0,'Offset: X(4,3)=1.089, X(4,4)=1.015, X(9,4)=-.270, X(9,5)=.070');

figure(3); clf;

subplot(13,1,1);
%plot(t, 1000*ID1BPM1y, '-b', t, 1000*ID1BPM2y, '--r'); grid on;
plot(t, 1000*ID1BPM1y, '-b'); grid on;
ylabel('1');
title(['Vertical IDBPM Data in \mum: ',titleStr]);
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,2);
plot(t, 1000*ID2BPM1y, '-b', t, 1000*ID2BPM2y, '--r'); grid on;
ylabel('2');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,3);
plot(t, 1000*ID4BPM1y, '-b', t, 1000*ID4BPM2y, '--r',...
   t, 1000*ID4BPM3y, '-c', t, 1000*ID4BPM4y, '--m'); grid on;
ylabel('4EPU');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,4);
plot(t, 1000*ID5BPM1y, '-b', t, 1000*ID5BPM2y, '--r'); grid on;
ylabel('5W');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,5);
plot(t, 1000*ID6BPM1y, '-b', t, 1000*ID6BPM2y, '--r'); grid on;
ylabel('6');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,6);
plot(t, 1000*ID7BPM1y, '-b', t, 1000*ID7BPM2y, '--r'); grid on;
ylabel('7U');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,7);
plot(t, 1000*ID8BPM1y, '-b', t, 1000*ID8BPM2y, '--r'); grid on;
ylabel('8U');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(13,1,8);
plot(t, 1000*ID9BPM1y, '-b', t, 1000*ID9BPM2y, '--r'); grid on;
ylabel('9U');
axis([0 xmax -10 10]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(13,1,9);
plot(t, 1000*ID10BPM1y, '-b', t, 1000*ID10BPM2y, '--r'); grid on;
ylabel('10U');
axis([0 xmax -10 10]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(13,1,10);
plot(t, 1000*ID11BPM1y, '-b', t, 1000*ID11BPM2y, '--r'); grid on;
ylabel('11');
axis([0 xmax -10 10]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(13,1,11);
plot(t, 1000*ID12BPM1y, '-b', t, 1000*ID12BPM2y, '--r'); grid on;
xlabel(xlabelstring);
ylabel('12U');
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(13,1,12);
plot(t, 1000*BPM44y, '-', t, 1000*BPM45y, '--',...
	t, 1000*BPM84y, '-', t, 1000*BPM85y, '--',...
   t, 1000*BPM94y, '-', t, 1000*BPM95y, '--',...
   t, 1000*BPM124y, '-', t, 1000*BPM125y, '--'); grid on;
ylabel('arc 4,8,9,12');
axis([0 xmax -30 30]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(13,1,13);
plot(t, ID9BPM2yRMS, '-b', t, ID9BPM5yRMS, '--r'); grid on;
xlabel(xlabelstring);
ylabel('rms noise');
axis tight;
axis([0 xmax 0 3]);
ChangeAxesLabel(t, Days, DayFlag);

orient tall

%addlabel(1,0,sprintf('Mean removed from: Y(4,3)=%.3f, Y(4,4)=%.3f, Y(9,4)=%.3f, Y(9,5)=%.3f',mean(ID4BPM3y(imean)),mean(ID4BPM4y(imean)),mean(BPM94y(imean)),mean(BPM95y(imean))));
%addlabel(1,0,'Offsets: Y(4,3)=-.620, Y(4,4)=-.136, Y(9,4)=-.030, Y(9,5)=.380');

if 1
   % b - absolute feedback
   % g - non ID straight
   % r - not in feedback
   figure(4); clf;
   subplot(2,1,1);
   plot(t, 1000*ID6BPM1x, '-b', t, 1000*ID6BPM2x, '-r'); 
   hold on
   plot(t, 1000*BPM44x, '-g', t, 1000*BPM45x, '-g');
   plot(t, 1000*BPM84x, '-g', t, 1000*BPM85x, '-g');
   plot(t, 1000*BPM94x, '-g', t, 1000*BPM95x, '-g');
   plot(t, 1000*BPM124x, '-g', t, 1000*BPM125x, '-g');
   plot(t, 1000*ID1BPM1x, '-r');
   plot(t, 1000*ID2BPM1x, '-b', t, 1000*ID2BPM2x, '-b');
   plot(t, 1000*ID5BPM1x, '-b', t, 1000*ID5BPM2x, '-b');
   plot(t, 1000*ID4BPM3x, '-r', t, 1000*ID4BPM4x, '-r');
   plot(t, 1000*ID7BPM1x, '-b', t, 1000*ID7BPM2x, '-b');
   plot(t, 1000*ID8BPM1x, '-b', t, 1000*ID8BPM2x, '-b');
   plot(t, 1000*ID9BPM1x, '-b', t, 1000*ID9BPM2x, '-b');
   plot(t, 1000*ID10BPM1x,'-b', t, 1000*ID10BPM2x,'-b');
   plot(t, 1000*ID11BPM1x,'-b', t, 1000*ID11BPM2x,'-b');
   plot(t, 1000*ID12BPM1x,'-b', t, 1000*ID12BPM2x,'-b');
   ylabel('Horizontal IDBPMs [\mum]');
   title([titleStr]);
   hold off
   axis([0 xmax -30 30]);
   ChangeAxesLabel(t, Days, DayFlag);
   grid on;
   
   legend('In Feedback Loop','Not in Feedback Loop','Arc BPMs',0);
   
   
   subplot(2,1,2);
   plot(t, 1000*ID6BPM1y, '-b', t, 1000*ID6BPM2y, '-r');
   hold on;
   plot(t, 1000*BPM44y,   '-g', t, 1000*BPM45y,   '-g');
   plot(t, 1000*BPM84y,   '-g', t, 1000*BPM85y,   '-g');
   plot(t, 1000*BPM94y,   '-g', t, 1000*BPM95y,   '-g');
   plot(t, 1000*BPM124y,   '-g', t, 1000*BPM125y,   '-g');
   plot(t, 1000*ID1BPM1y, '-r'); 
   plot(t, 1000*ID2BPM1y, '-b', t, 1000*ID2BPM2y, '-b'); 
   plot(t, 1000*ID5BPM1y, '-b', t, 1000*ID5BPM2y, '-b');
   plot(t, 1000*ID4BPM3y, '-r', t, 1000*ID4BPM4y, '-r');
   plot(t, 1000*ID7BPM1y, '-b', t, 1000*ID7BPM2y, '-b');
   plot(t, 1000*ID8BPM1y, '-b', t, 1000*ID8BPM2y, '-b');
   plot(t, 1000*ID9BPM1y, '-b', t, 1000*ID9BPM2y, '-b');
   plot(t, 1000*ID10BPM1y,'-b', t, 1000*ID10BPM2y,'-b');
   plot(t, 1000*ID11BPM1y,'-b', t, 1000*ID11BPM2y,'-b');
   plot(t, 1000*ID12BPM1y,'-b', t, 1000*ID12BPM2y,'-b');
   xlabel(xlabelstring);
   ylabel('Vertical IDBPMs [\mum]');
   hold off
   axis([0 xmax -15 15]);
   ChangeAxesLabel(t, Days, DayFlag);
   grid on;
   orient tall
else
   % mm
   
   
   % b - absolute feedback
   % g - non ID straight
   % r - not in feedback
   figure(4); clf;
   subplot(2,1,1);
   plot(t, ID6BPM1x, '-b', t, ID6BPM2x, '-b'); 
   hold on
   plot(t, ID5BPM1x, '-b', t, ID5BPM2x, '-b');
   plot(t, ID2BPM1x, '-b', t, ID2BPM2x, '-b');
   plot(t, ID7BPM1x, '-b', t, ID7BPM2x, '-b');
   plot(t, ID8BPM1x, '-b', t, ID8BPM2x, '-b');
   plot(t, ID9BPM1x, '-b', t, ID9BPM2x, '-b');
   plot(t, ID10BPM1x,'-b', t, ID10BPM2x,'-b');
   plot(t, ID11BPM1x,'-b', t, ID11BPM2x,'-b');
   plot(t, ID12BPM1x,'-b', t, ID12BPM2x,'-b');
   ylabel('Horizontal IDBPMs [mm]');
   title([titleStr]);
   hold off
   axis([0 xmax -.11 .11]);
   ChangeAxesLabel(t, Days, DayFlag);
   grid on;
   
  
   subplot(2,1,2);
   plot(t, ID2BPM1y, '-b', t, ID2BPM2y, '-b'); 
   hold on;
   plot(t, ID5BPM1y, '-b', t, ID5BPM2y, '-b');
   plot(t, ID6BPM1y, '-b', t, ID6BPM2y, '-b');
   plot(t, ID7BPM1y, '-b', t, ID7BPM2y, '-b');
   plot(t, ID8BPM1y, '-b', t, ID8BPM2y, '-b');
   plot(t, ID9BPM1y, '-b', t, ID9BPM2y, '-b');
   plot(t, ID10BPM1y,'-b', t, ID10BPM2y,'-b');
   plot(t, ID11BPM1y,'-b', t, ID11BPM2y,'-b');
   plot(t, ID12BPM1y,'-b', t, ID12BPM2y,'-b');
   xlabel(xlabelstring);
   ylabel('Vertical IDBPMs [mm]');
   hold off
   axis([0 xmax -.06 .06]);
   ChangeAxesLabel(t, Days, DayFlag);
   grid on;
   orient tall
   
end


figure(5); clf;
subplot(2,2,1);
plot(t, ID9BPM2xRMS); grid on;
xlabel(xlabelstring);
ylabel('IDBPMx(9,2) [\mum]');
axis tight;
axis([0 xmax 0 6]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(2,2,2);
plot(t, ID9BPM5xRMS); grid on;
xlabel(xlabelstring);
ylabel('IDBPMx(9,5) [\mum]');
axis tight;
axis([0 xmax 0 2]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(2,2,3);
plot(t, ID9BPM2yRMS); grid on;
xlabel(xlabelstring);
ylabel('IDBPMy(9,2) [\mum]');
axis tight;
axis([0 xmax 0 2]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(2,2,4);
plot(t, ID9BPM5yRMS); grid on;
xlabel(xlabelstring);
ylabel('IDBPMy(9,5) [\mum]');
axis tight;
axis([0 xmax 0 1]);
ChangeAxesLabel(t, Days, DayFlag);

h=addlabel(.5,1,sprintf('IDBPM RMS:  %s',titleStr));
set(h,'fontsize',10);
set(h,'HorizontalAlignment','center');
set(h,'VerticalAlignment','Top');

orient landscape


figure(6);clf;
subplot(3,1,1)
plot(t, 1000*ID4BPM1x, 'b'); hold on
plot(t, 1000*ID4BPM2x, 'r'); 
plot(t, 1000*ID4BPM3x, 'k');
plot(t, 1000*ID4BPM4x, 'g');
hold off;
ylabel('Horizontal [\mum]','fontsize',10);
title(titleStr);
axis([0 xmax -30 30]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(3,1,2)
plot(t, 1000*ID4BPM1y, 'b'); hold on
plot(t, 1000*ID4BPM2y, 'r'); 
plot(t, 1000*ID4BPM3y, 'k');
plot(t, 1000*ID4BPM4y, 'g');
hold off;
ylabel('Vertical [\mum]','fontsize',10);
axis([0 xmax -10 10]);
ChangeAxesLabel(t, Days, DayFlag);
legend('IDBPM(4,1)','IDBPM(4,2)','IDBPM(4,3)','IDBPM(4,4)',0);

subplot(3,1,3)
i = find(IDlist(:,1) == 4);
plot(t,IDgap(i,:),'b', t,EPU4,'r');
xlabel(xlabelstring);
ylabel('EPU 4 [mm]','fontsize',10);
axis([0 xmax -30 60]);
ChangeAxesLabel(t, Days, DayFlag);

orient tall




figure(7); clf;
subplot(7,1,1);
plot(t,TC7_3,'-b', t,TC7_4,'--r'); grid on;
ylabel('Sector 7 [Celsius]');
title(['SR Temperature at ID, ', titleStr]);
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 21.5 24]);
%legend(	'Sector 7, Aisle Side', ...
% 	'Sector 7, Beamline Side');

subplot(7,1,2);
plot(t,TC8_3,'-b', t,TC8_4,'--r'); grid on;
ylabel('Sector 8 [Celsius]');
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 21.5 24]);
%title(['SR Temperature at ID, ',titleStr]);
%legend(	'Sector 8, Aisle Side', ...
% 	'Sector 8, Beamline Side');

subplot(7,1,3);
plot(t,TC9_3,'-b', t,TC9_4,'--r'); grid on;
ylabel('Sector 9 [Celsius]');
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 21.5 24]);
%title(['SR Temperature at ID, ',titleStr]);
%legend(	'Sector 9, Aisle Side', ...
% 	'Sector 9, Beamline Side');

subplot(7,1,4);
plot(t,TC10_3,'-b', t,TC10_4,'--r'); grid on;
ylabel('Sector 10 [Celsius]');
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 21.5 24]);
%legend(	'Sector 10, Aisle Side', ...
% 	'Sector 10, Beamline Side');

subplot(7,1,5);
plot(t,TC12_3,'-b', t,TC12_4,'--r'); grid on;
ylabel('Sector 12 [Celsius]');
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 21.5 24]);
%legend(	'Sector 12, Aisle Side', ...
% 	'Sector 12, Beamline Side');

subplot(7,1,6);
plot(t,mean([TC7_3;TC7_4;TC8_3;TC8_4;TC9_3;TC9_4;TC10_3;TC10_4;TC12_3;TC12_4]),'b'); grid on;
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Avg. Air [Celsius]');

subplot(7,1,7);
plot(t, lcw, 'b'); grid on;
xlabel(xlabelstring);
ylabel('LCW [Celsius]');
axis tight
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
%axis([0 xmax 20 24]);
orient tall


figure(8); clf;
subplot(7,1,1);
plot(t,TC7_1,'-b', t,TC7_2,'--r'); grid on;
ylabel('Sector 7 [Celsius]');
title(['ID Backing Beam Temperature , ',titleStr]);
axis tight
xaxis([0 xmax]);
%axis([0 xmax 22.5 25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,2);
plot(t,TC8_1,'-b', t,TC8_2,'--r'); grid on;
ylabel('Sector 8 [Celsius]');
axis tight
xaxis([0 xmax]);
%axis([0 xmax 22.5 25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,3);
plot(t,TC9_1,'-b', t,TC9_2,'--r'); grid on;
ylabel('Sector 9 [Celsius]');
axis tight
xaxis([0 xmax]);
%axis([0 xmax 22.5 25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,4);
plot(t,TC10_1,'-b', t,TC10_2,'--r'); grid on;
ylabel('Sector 10 [Celsius]');
axis tight
xaxis([0 xmax]);
%axis([0 xmax 22.5 25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,5);
plot(t,TC12_1,'-b', t,TC12_2,'--r'); grid on;
ylabel('Sector 12 [Celsius]');
axis tight
xaxis([0 xmax]);
%axis([0 xmax 22.5 25]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,6);
plot(t, mean([TC7_1;TC7_2;TC8_1;TC8_2;TC9_1;TC9_2;TC10_1;TC10_2;TC12_1;TC12_2]), 'b'); grid on;
axis tight
xaxis([0 xmax]);
ylabel('Avg. Air [Celsius]');
ChangeAxesLabel(t, Days, DayFlag);

subplot(7,1,7);
plot(t, lcw, 'b'); grid on;
xlabel(xlabelstring);
ylabel('LCW [Celsius]');
axis tight
xaxis([0 xmax]);
%axis([0 xmax 20 24]);
ChangeAxesLabel(t, Days, DayFlag);
orient tall


itmp = find(isnan(SpiroX));
imean = 1:length(SpiroX);
imean(itmp)=[];

figure(9); clf;
subplot(6,1,1);
plot(t, dcct, 'b'); grid on;
ylabel('Beam Current, I [mA]','fontsize',9);
title(titleStr);
axis([0 xmax 0 450]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,2);
%plot(t, 1000*(BPM94x-mean(BPM94x(imean))), '-b', t, 1000*(BPM95x-mean(BPM95x(imean))), '--r'); grid on;
plot(t, 1000*BPM44x, '-', t, 1000*BPM45x, '--',...
	t, 1000*BPM84x, '-', t, 1000*BPM85x, '--',...
   t, 1000*BPM94x, '-', t, 1000*BPM95y, '--',...
   t, 1000*BPM124x, '-', t, 1000*BPM125x, '--'); grid on;
ylabel('X (arcs 4,8,9,12) [\mum]');
axis([0 xmax -50 50]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,3);
plot(t, SpiroX-mean(SpiroX(imean)), 'b'); grid on;
ylabel('Spiricon X [\mum]','fontsize',10);
axis([0 xmax -50 50]);
%xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,4);
%plot(t, 1000*(BPM94y-mean(BPM94y(imean))), '-b', t, 1000*(BPM95y-mean(BPM95y(imean))), '--r'); grid on;
plot(t, 1000*BPM44y, '-', t, 1000*BPM45y, '--',...
	t, 1000*BPM84y, '-', t, 1000*BPM85y, '--',...
   t, 1000*BPM94y, '-', t, 1000*BPM95y, '--',...
   t, 1000*BPM124y, '-', t, 1000*BPM125y, '--'); grid on;
ylabel('Y (arcs 4,8,9,12) [\mum]');
axis([0 xmax -50 50]);
set(gca,'XTickLabel','');
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,5);
plot(t, SpiroY-mean(SpiroY(imean)), 'b'); grid on;
ylabel('Spiricon Y [\mum]','fontsize',10);
%xaxis([0 xmax]);
axis([0 xmax -50 50]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,6);
plot(t, SigX/2.0,'-b',t, SigY/2.0,'r'); grid on;
ylabel('\fontsize{7}RMS  \fontsize{14}\sigma_x \sigma_y \fontsize{10}[\mum]');
axis tight;
axis([0 xmax 30 100]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);
orient tall




figure(10); clf;
subplot(3,1,1);
plot(t, C1TEMP,'b', t, C2TEMP,'--r'); grid on;
ylabel('Temperature [Celsius]');
legend('RF Cavity #1 ', 'RF Cavity #2  ');
title(titleStr);
xaxis([0 xmax]);

subplot(3,1,2);
%plot(t, HPsyn,'b',t, HPcounter,'--r'); grid on;
plot(t, HPcounter,'-b'); grid on;
ylabel('RF Frequency [MHz]');
%legend('RF Synthesizer', 'HP Counter');
legend('HP Counter');
xaxis([0 xmax]);

subplot(3,1,3);
plot(t, hqmofm,'-m'); grid on;
xlabel(xlabelstring);
ylabel('\Delta f_{RF} [Hz]');
legend('FM input user synthesizer');
xaxis([0 xmax]);

orient tall

%save ar_save

return




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
