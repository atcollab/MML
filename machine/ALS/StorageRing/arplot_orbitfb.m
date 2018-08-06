function arplot_orbitfb(monthStr, days, year1, month2Str, days2, year2)
% arplot_orbitfb(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots archived data about the orbit feedback - specifically the trim DAC values
%
% Example:  arplots_orbitfb('January',22:24, 2008);
%           plots data from 1/22, 1/23, and 1/24 in 2008
%
% C. Steier, May 2002



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

hcm12 = []; hcm18 = []; hcm21 = []; hcm28 = []; hcm31 = []; hcm38 = []; hcmu42 = []; hcm41 = [];  hcm48 = [];
hcm12am = []; hcm18am = [];
hcm51 = []; hcm58 = []; hcm61 = []; hcm68 = []; hcm71 = []; hcm78 = []; hcm81 = []; hcm88 = [];
hcm91 = []; hcm98 = []; hcm101 = []; hcm108 = []; hcmu112 = []; hcm111 = []; hcm118 = []; hcm121 = []; hcm127 = [];

vcm12 = []; vcm17 = []; vcm18 = []; vcm21 = []; vcm22 = []; vcm27 = []; vcm28 = []; 
vcm31 = []; vcm32 = []; vcm37 = []; vcm38 = []; vcmu42 = []; vcm41 = []; vcm42 = []; vcm47 = []; vcm48 = [];
vcm51 = []; vcm52 = []; vcm57 = []; vcm58 = []; vcm61 = []; vcm62 = []; vcm67 = []; vcm68 = [];
vcm71 = []; vcm72 = []; vcm77 = []; vcm78 = []; vcm81 = []; vcm82 = []; vcm87 = []; vcm88 = [];
vcm91 = []; vcm92 = []; vcm97 = []; vcm98 = []; vcm101 = []; vcm102 = []; vcm107 = []; vcm108 = [];
vcmu112 = []; vcm111 = []; vcm112 = []; vcm117 = []; vcm118 = []; vcm121 = []; vcm122 = []; vcm127 = [];

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
   
   [y1, i] = arselect('SR01C___HCM2T__AC');
   hcm12 = [hcm12 y1];
   
   [y1, i] = arselect('SR01C___HCM4T__AC');
   hcm18 = [hcm18 y1];
   
   [y1, i] = arselect('SR02C___HCM1T__AC');
   hcm21 = [hcm21 y1];
   
   [y1, i] = arselect('SR02C___HCM4T__AC');
   hcm28 = [hcm28 y1];
      
   [y1, i] = arselect('SR03C___HCM1T__AC');
   hcm31 = [hcm31 y1];
   
   [y1, i] = arselect('SR03C___HCM4T__AC');
   hcm38 = [hcm38 y1];
   
   [y1, i] = arselect('SR04U___HCM2___AM');
   hcmu42 = [hcmu42 y1];
   
   [y1, i] = arselect('SR04C___HCM1T__AC');
   hcm41 = [hcm41 y1];   
   
   [y1, i] = arselect('SR04C___HCM4T__AC');
   hcm48 = [hcm48 y1];
   
   [y1, i] = arselect('SR05C___HCM1T__AC');
   hcm51 = [hcm51 y1];
   
   [y1, i] = arselect('SR05C___HCM4T__AC');
   hcm58 = [hcm58 y1];
   
   [y1, i] = arselect('SR06C___HCM1T__AC');
   hcm61 = [hcm61 y1];
   
   [y1, i] = arselect('SR06C___HCM4T__AC');
   hcm68 = [hcm68 y1];
   
   [y1, i] = arselect('SR07C___HCM1T__AC');
   hcm71 = [hcm71 y1];
   
   [y1, i] = arselect('SR07C___HCM4T__AC');
   hcm78 = [hcm78 y1];
   
   [y1, i] = arselect('SR08C___HCM1T__AC');
   hcm81 = [hcm81 y1];
   
   [y1, i] = arselect('SR08C___HCM4T__AC');
   hcm88 = [hcm88 y1];
   
   [y1, i] = arselect('SR09C___HCM1T__AC');
   hcm91 = [hcm91 y1];
   
   [y1, i] = arselect('SR09C___HCM4T__AC');
   hcm98 = [hcm98 y1];
   
   [y1, i] = arselect('SR10C___HCM1T__AC');
   hcm101 = [hcm101 y1];
   
   [y1, i] = arselect('SR10C___HCM4T__AC');
   hcm108 = [hcm108 y1];
   
   [y1, i] = arselect('SR11U___HCM2___AM');
   hcmu112 = [hcmu112 y1];
   
   [y1, i] = arselect('SR11C___HCM1T__AC');
   hcm111 = [hcm111 y1];
   
   [y1, i] = arselect('SR11C___HCM4T__AC');
   hcm118 = [hcm118 y1];
   
   [y1, i] = arselect('SR12C___HCM1T__AC');
   hcm121 = [hcm121 y1];
   
   [y1, i] = arselect('SR12C___HCM3T__AC');
   hcm127 = [hcm127 y1];
   
   [y1, i] = arselect('SR01C___VCM2T__AC');
   vcm12 = [vcm12 y1];
   
   [y1, i] = arselect('SR01C___VCM3T__AC');
   vcm17 = [vcm17 y1];
   
   [y1, i] = arselect('SR01C___VCM4T__AC');
   vcm18 = [vcm18 y1];
   
   [y1, i] = arselect('SR02C___VCM1T__AC');
   vcm21 = [vcm21 y1];
   
   [y1, i] = arselect('SR02C___VCM2T__AC');
   vcm22 = [vcm22 y1];
      
   [y1, i] = arselect('SR02C___VCM3T__AC');
   vcm27 = [vcm27 y1];
   
   [y1, i] = arselect('SR02C___VCM4T__AC');
   vcm28 = [vcm28 y1];
      
   [y1, i] = arselect('SR03C___VCM1T__AC');
   vcm31 = [vcm31 y1];
   
   [y1, i] = arselect('SR03C___VCM2T__AC');
   vcm32 = [vcm32 y1];
      
   [y1, i] = arselect('SR03C___VCM3T__AC');
   vcm37 = [vcm37 y1];
   
   [y1, i] = arselect('SR03C___VCM4T__AC');
   vcm38 = [vcm38 y1];
   
   [y1, i] = arselect('SR04U___VCM2___AM');
   vcmu42 = [vcmu42 y1];
   
   [y1, i] = arselect('SR04C___VCM1T__AC');
   vcm41 = [vcm41 y1];
   
   [y1, i] = arselect('SR04C___VCM2T__AC');
   vcm42 = [vcm42 y1];
   
   [y1, i] = arselect('SR04C___VCM3T__AC');
   vcm47 = [vcm47 y1];
   
   [y1, i] = arselect('SR04C___VCM4T__AC');
   vcm48 = [vcm48 y1];
   
   [y1, i] = arselect('SR05C___VCM1T__AC');
   vcm51 = [vcm51 y1];
   
   [y1, i] = arselect('SR05C___VCM2T__AC');
   vcm52 = [vcm52 y1];
   
   [y1, i] = arselect('SR05C___VCM3T__AC');
   vcm57 = [vcm57 y1];
   
   [y1, i] = arselect('SR05C___VCM4T__AC');
   vcm58 = [vcm58 y1];
   
   [y1, i] = arselect('SR06C___VCM1T__AC');
   vcm61 = [vcm61 y1];
   
   [y1, i] = arselect('SR06C___VCM2T__AC');
   vcm62 = [vcm62 y1];
   
   [y1, i] = arselect('SR06C___VCM3T__AC');
   vcm67 = [vcm67 y1];
   
   [y1, i] = arselect('SR06C___VCM4T__AC');
   vcm68 = [vcm68 y1];
   
   [y1, i] = arselect('SR07C___VCM1T__AC');
   vcm71 = [vcm71 y1];
   
   [y1, i] = arselect('SR07C___VCM2T__AC');
   vcm72 = [vcm72 y1];
   
   [y1, i] = arselect('SR07C___VCM3T__AC');
   vcm77 = [vcm77 y1];
   
   [y1, i] = arselect('SR07C___VCM4T__AC');
   vcm78 = [vcm78 y1];
   
   [y1, i] = arselect('SR08C___VCM1T__AC');
   vcm81 = [vcm81 y1];
   
   [y1, i] = arselect('SR08C___VCM2T__AC');
   vcm82 = [vcm82 y1];
   
   [y1, i] = arselect('SR08C___VCM3T__AC');
   vcm87 = [vcm87 y1];
   
   [y1, i] = arselect('SR08C___VCM4T__AC');
   vcm88 = [vcm88 y1];
   
   [y1, i] = arselect('SR09C___VCM1T__AC');
   vcm91 = [vcm91 y1];
   
   [y1, i] = arselect('SR09C___VCM2T__AC');
   vcm92 = [vcm92 y1];
   
   [y1, i] = arselect('SR09C___VCM3T__AC');
   vcm97 = [vcm97 y1];
   
   [y1, i] = arselect('SR09C___VCM4T__AC');
   vcm98 = [vcm98 y1];
   
   [y1, i] = arselect('SR10C___VCM1T__AC');
   vcm101 = [vcm101 y1];
   
   [y1, i] = arselect('SR10C___VCM2T__AC');
   vcm102 = [vcm102 y1];
   
   [y1, i] = arselect('SR10C___VCM3T__AC');
   vcm107 = [vcm107 y1];
   
   [y1, i] = arselect('SR10C___VCM4T__AC');
   vcm108 = [vcm108 y1];
      
   [y1, i] = arselect('SR11U___VCM2___AM');
   vcmu112 = [vcmu112 y1];
   
   [y1, i] = arselect('SR11C___VCM1T__AC');
   vcm111 = [vcm111 y1];
   
   [y1, i] = arselect('SR11C___VCM2T__AC');
   vcm112 = [vcm112 y1];
   
   [y1, i] = arselect('SR11C___VCM3T__AC');
   vcm117 = [vcm117 y1];
   
   [y1, i] = arselect('SR11C___VCM4T__AC');
   vcm118 = [vcm118 y1];
   
   [y1, i] = arselect('SR12C___VCM1T__AC');
   vcm121 = [vcm121 y1];
   
   [y1, i] = arselect('SR12C___VCM2T__AC');
   vcm122 = [vcm122 y1];
   
   [y1, i] = arselect('SR12C___VCM3T__AC');
   vcm127 = [vcm127 y1];
   
   
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
   
   [y1, i] = arselect('SR01C___HCM2T__AC');
   hcm12 = [hcm12 y1];
   
   [y1, i] = arselect('SR01C___HCM4T__AC');
   hcm18 = [hcm18 y1];
   
   [y1, i] = arselect('SR02C___HCM1T__AC');
   hcm21 = [hcm21 y1];
   
   [y1, i] = arselect('SR02C___HCM4T__AC');
   hcm28 = [hcm28 y1];
      
   [y1, i] = arselect('SR03C___HCM1T__AC');
   hcm31 = [hcm31 y1];
   
   [y1, i] = arselect('SR03C___HCM4T__AC');
   hcm38 = [hcm38 y1];
   
   [y1, i] = arselect('SR04U___HCM2___AM');
   hcmu42 = [hcmu42 y1];
   
   [y1, i] = arselect('SR04C___HCM1T__AC');
   hcm41 = [hcm41 y1];   
   
   [y1, i] = arselect('SR04C___HCM4T__AC');
   hcm48 = [hcm48 y1];
   
   [y1, i] = arselect('SR05C___HCM1T__AC');
   hcm51 = [hcm51 y1];
   
   [y1, i] = arselect('SR05C___HCM4T__AC');
   hcm58 = [hcm58 y1];
   
   [y1, i] = arselect('SR06C___HCM1T__AC');
   hcm61 = [hcm61 y1];
   
   [y1, i] = arselect('SR06C___HCM4T__AC');
   hcm68 = [hcm68 y1];
   
   [y1, i] = arselect('SR07C___HCM1T__AC');
   hcm71 = [hcm71 y1];
   
   [y1, i] = arselect('SR07C___HCM4T__AC');
   hcm78 = [hcm78 y1];
   
   [y1, i] = arselect('SR08C___HCM1T__AC');
   hcm81 = [hcm81 y1];
   
   [y1, i] = arselect('SR08C___HCM4T__AC');
   hcm88 = [hcm88 y1];
   
   [y1, i] = arselect('SR09C___HCM1T__AC');
   hcm91 = [hcm91 y1];
   
   [y1, i] = arselect('SR09C___HCM4T__AC');
   hcm98 = [hcm98 y1];
   
   [y1, i] = arselect('SR10C___HCM1T__AC');
   hcm101 = [hcm101 y1];
   
   [y1, i] = arselect('SR10C___HCM4T__AC');
   hcm108 = [hcm108 y1];
   
   [y1, i] = arselect('SR11U___HCM2___AM');
   hcmu112 = [hcmu112 y1];
   
   [y1, i] = arselect('SR11C___HCM1T__AC');
   hcm111 = [hcm111 y1];
   
   [y1, i] = arselect('SR11C___HCM4T__AC');
   hcm118 = [hcm118 y1];
   
   [y1, i] = arselect('SR12C___HCM1T__AC');
   hcm121 = [hcm121 y1];
   
   [y1, i] = arselect('SR12C___HCM3T__AC');
   hcm127 = [hcm127 y1];
   
   [y1, i] = arselect('SR01C___VCM2T__AC');
   vcm12 = [vcm12 y1];
   
   [y1, i] = arselect('SR01C___VCM3T__AC');
   vcm17 = [vcm17 y1];
   
   [y1, i] = arselect('SR01C___VCM4T__AC');
   vcm18 = [vcm18 y1];
   
   [y1, i] = arselect('SR02C___VCM1T__AC');
   vcm21 = [vcm21 y1];
   
   [y1, i] = arselect('SR02C___VCM2T__AC');
   vcm22 = [vcm22 y1];
      
   [y1, i] = arselect('SR02C___VCM3T__AC');
   vcm27 = [vcm27 y1];
   
   [y1, i] = arselect('SR02C___VCM4T__AC');
   vcm28 = [vcm28 y1];
      
   [y1, i] = arselect('SR03C___VCM1T__AC');
   vcm31 = [vcm31 y1];
   
   [y1, i] = arselect('SR03C___VCM2T__AC');
   vcm32 = [vcm32 y1];
      
   [y1, i] = arselect('SR03C___VCM3T__AC');
   vcm37 = [vcm37 y1];
   
   [y1, i] = arselect('SR03C___VCM4T__AC');
   vcm38 = [vcm38 y1];
   
   [y1, i] = arselect('SR04U___VCM2___AM');
   vcmu42 = [vcmu42 y1];
   
   [y1, i] = arselect('SR04C___VCM1T__AC');
   vcm41 = [vcm41 y1];
   
   [y1, i] = arselect('SR04C___VCM2T__AC');
   vcm42 = [vcm42 y1];
   
   [y1, i] = arselect('SR04C___VCM3T__AC');
   vcm47 = [vcm47 y1];
   
   [y1, i] = arselect('SR04C___VCM4T__AC');
   vcm48 = [vcm48 y1];
   
   [y1, i] = arselect('SR05C___VCM1T__AC');
   vcm51 = [vcm51 y1];
   
   [y1, i] = arselect('SR05C___VCM2T__AC');
   vcm52 = [vcm52 y1];
   
   [y1, i] = arselect('SR05C___VCM3T__AC');
   vcm57 = [vcm57 y1];
   
   [y1, i] = arselect('SR05C___VCM4T__AC');
   vcm58 = [vcm58 y1];
   
   [y1, i] = arselect('SR06C___VCM1T__AC');
   vcm61 = [vcm61 y1];
   
   [y1, i] = arselect('SR06C___VCM2T__AC');
   vcm62 = [vcm62 y1];
   
   [y1, i] = arselect('SR06C___VCM3T__AC');
   vcm67 = [vcm67 y1];
   
   [y1, i] = arselect('SR06C___VCM4T__AC');
   vcm68 = [vcm68 y1];
   
   [y1, i] = arselect('SR07C___VCM1T__AC');
   vcm71 = [vcm71 y1];
   
   [y1, i] = arselect('SR07C___VCM2T__AC');
   vcm72 = [vcm72 y1];
   
   [y1, i] = arselect('SR07C___VCM3T__AC');
   vcm77 = [vcm77 y1];
   
   [y1, i] = arselect('SR07C___VCM4T__AC');
   vcm78 = [vcm78 y1];
   
   [y1, i] = arselect('SR08C___VCM1T__AC');
   vcm81 = [vcm81 y1];
   
   [y1, i] = arselect('SR08C___VCM2T__AC');
   vcm82 = [vcm82 y1];
   
   [y1, i] = arselect('SR08C___VCM3T__AC');
   vcm87 = [vcm87 y1];
   
   [y1, i] = arselect('SR08C___VCM4T__AC');
   vcm88 = [vcm88 y1];
   
   [y1, i] = arselect('SR09C___VCM1T__AC');
   vcm91 = [vcm91 y1];
   
   [y1, i] = arselect('SR09C___VCM2T__AC');
   vcm92 = [vcm92 y1];
   
   [y1, i] = arselect('SR09C___VCM3T__AC');
   vcm97 = [vcm97 y1];
   
   [y1, i] = arselect('SR09C___VCM4T__AC');
   vcm98 = [vcm98 y1];
   
   [y1, i] = arselect('SR10C___VCM1T__AC');
   vcm101 = [vcm101 y1];
   
   [y1, i] = arselect('SR10C___VCM2T__AC');
   vcm102 = [vcm102 y1];
   
   [y1, i] = arselect('SR10C___VCM3T__AC');
   vcm107 = [vcm107 y1];
   
   [y1, i] = arselect('SR10C___VCM4T__AC');
   vcm108 = [vcm108 y1];
      
   [y1, i] = arselect('SR11U___VCM2___AM');
   vcmu112 = [vcmu112 y1];
   
   [y1, i] = arselect('SR11C___VCM1T__AC');
   vcm111 = [vcm111 y1];
   
   [y1, i] = arselect('SR11C___VCM2T__AC');
   vcm112 = [vcm112 y1];
   
   [y1, i] = arselect('SR11C___VCM3T__AC');
   vcm117 = [vcm117 y1];
   
   [y1, i] = arselect('SR11C___VCM4T__AC');
   vcm118 = [vcm118 y1];
   
   [y1, i] = arselect('SR12C___VCM1T__AC');
   vcm121 = [vcm121 y1];
   
   [y1, i] = arselect('SR12C___VCM2T__AC');
   vcm122 = [vcm122 y1];
   
   [y1, i] = arselect('SR12C___VCM3T__AC');
   vcm127 = [vcm127 y1];
      
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


figure

subplot(4,1,1)
plot(t,hcm12,t,hcm18);
legend('HCM 1.2','HCM 1.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm21,t,hcm28);
legend('HCM 2.1','HCM 2.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,3)
plot(t,hcm31,t,hcm38);
legend('HCM 3.1','HCM 3.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,4)
plot(t,hcm41,t,hcm48,t,hcmu42/10);
legend('HCM 4.1','HCM 4.8','HCMCHIC 4.2/10',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
xlabel(xlabelstring);
orient tall;




figure

subplot(4,1,1)
plot(t,hcm51,t,hcm58);
legend('HCM 5.1','HCM 5.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm61,t,hcm68);
legend('HCM 6.1','HCM 6.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,3)
plot(t,hcm71,t,hcm78);
legend('HCM 7.1','HCM 7.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,4)
plot(t,hcm81,t,hcm88);
legend('HCM 8.1','HCM 8.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
xlabel(xlabelstring);
orient tall;


figure

subplot(4,1,1)
plot(t,hcm91,t,hcm98);
legend('HCM 9.1','HCM 9.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
title(['HCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,hcm101,t,hcm108);
legend('HCM 10.1','HCM 10.8',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,3)
plot(t,hcm111,t,hcm118,t,hcmu112/10);
legend('HCM 11.1','HCM 11.8','HCMCHIC 11.2/10',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);

subplot(4,1,4)
plot(t,hcm121,t,hcm127);
legend('HCM 12.1','HCM 12.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -1 1]);
xlabel(xlabelstring);
orient tall;

figure

subplot(4,1,1)
plot(t,vcm12,t,vcm18,t,vcm17);
legend('VCM 1.2','VCM 1.8','VCM 1.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
title(['VCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,vcm21,t,vcm28,t,vcm22,t,vcm27);
legend('VCM 2.1','VCM 2.8','VCM 2.2','VCM 2.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,3)
plot(t,vcm31,t,vcm38,t,vcm32,t,vcm37);
legend('VCM 3.1','VCM 3.8','VCM 3.2','VCM 3.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,4)
plot(t,vcm41,t,vcm48,t,vcmu42/10,t,vcm42,t,vcm47);
legend('VCM 4.1','VCM 4.8','VCMCHIC 4.2/10','VCM 4.2','VCM 4.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
xlabel(xlabelstring);
orient tall;




figure

subplot(4,1,1)
plot(t,vcm51,t,vcm58,t,vcm52,t,vcm57);
legend('VCM 5.1','VCM 5.8','VCM 5.2','VCM 5.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
title(['VCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,vcm61,t,vcm68,t,vcm62,t,vcm67);
legend('VCM 6.1','VCM 6.8','VCM 6.2','VCM 6.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,3)
plot(t,vcm71,t,vcm78,t,vcm72,t,vcm77);
legend('VCM 7.1','VCM 7.8','VCM 7.2','VCM 7.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,4)
plot(t,vcm81,t,vcm88,t,vcm82,t,vcm87);
legend('VCM 8.1','VCM 8.8','VCM 8.2','VCM 8.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
xlabel(xlabelstring);
orient tall;


figure

subplot(4,1,1)
plot(t,vcm91,t,vcm98,t,vcm92,t,vcm97);
legend('VCM 9.1','VCM 9.8','VCM 9.2','VCM 9.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
title(['VCM trim DACs ',titleStr]);

subplot(4,1,2)
plot(t,vcm101,t,vcm108,t,vcm102,t,vcm107);
legend('VCM 10.1','VCM 10.8','VCM 10.2','VCM 10.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,3)
plot(t,vcm111,t,vcm118,t,vcmu112/10,t,vcm112,t,vcm117);
legend('VCM 11.1','VCM 11.8','VCMCHIC 11.2/10','VCM 11.2','VCM 11.7',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);

subplot(4,1,4)
plot(t,vcm121,t,vcm127,t,vcm122);
legend('VCM 12.1','VCM 12.7','VCM 12.2',3);
ylabel('I [A]');
grid;
axis([min(t) max(t) -2 2]);
xlabel(xlabelstring);
orient tall;

