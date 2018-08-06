function arplot_diagbl(monthStr, days, year1, month2Str, days2, year2)
% arplot_diagbl(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots diagnostic beamlines 3.1 and 7.2 archived data.
% Only plots data when feed forward is on.
%
% Example #1:  arplot_sr('January',22:24,1998);
%              plots data from 1/22, 1/23, and 1/24 in 1998
%
% Example #2:  arplot_sr('January',28:31,1998,'February',1:4,1998);
%              plots data from the last 4 days in Jan. and the first 4 days in Feb.

% original arplot code: Greg Portmann, 1999
%
% modified by C. Steier, 2001; modified by T. Scarvie, 2002
%
% insert note about how Chris's BL31 averaging works


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
gev=[];

IDgap = [];
EPU=[];

FF7Enable = [];

ID3BPM1x=[];
ID3BPM1y=[];
ID3BPM2x=[];
ID3BPM2y=[];

ID4BPM1x=[];
ID4BPM1y=[];
ID4BPM2x=[];
ID4BPM2y=[];
ID4BPM3x=[];
ID4BPM3y=[];
ID4BPM4x=[];
ID4BPM4y=[];

ID7BPM1x=[];
ID7BPM1y=[];
ID7BPM2x=[];
ID7BPM2y=[];

ID8BPM1x=[];
ID8BPM1y=[];
ID8BPM2x=[];
ID8BPM2y=[];

BPM34x=[];
BPM34y=[];

BPM35x=[];
BPM35y=[];

BPM74x=[];
BPM74y=[];

BPM75x=[];
BPM75y=[];

SigX31=[];
SigY31=[];
SigX31ave=[];
SigY31ave=[];
SigX72=[];
SigY72=[];
SigX72ave=[];
SigY72ave=[];
X31 = [];
Y31 = [];
X31ave = [];
Y31ave = [];
X72 = [];
Y72 = [];
X72ave = [];
Y72ave = [];

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
      dcct = [dcct y1];
      
      [y1, igev] = arselect('cmm:sr_energy');
      gev = [gev y1];
      
      [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
      lifetime = [lifetime  y1];
      
      [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS1PS_AM00']);
      EPU =[EPU  y1];
      
      [y1,i]=arselect(getname('IDpos'));
      IDgap =[IDgap  y1];
      
      if FFFlag
         [y1,i]=arselect('sr07u:FFEnable:bi');
         FF7Enable =[FF7Enable  y1];
      end
      
      [y1, i] = arselect('SR03S___IBPM1X_AM');
      [y2, i] = arselect('SR03S___IBPM1Y_AM');
      [y3, i] = arselect('SR03S___IBPM2X_AM');
      [y4, i] = arselect('SR03S___IBPM2Y_AM');
      ID3BPM1x=[ID3BPM1x y1];
      ID3BPM1y=[ID3BPM1y y2]; 
      ID3BPM2x=[ID3BPM2x y3];
      ID3BPM2y=[ID3BPM2y y4];
      
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
      
      [y1, i] = arselect('SR03C___BPM4XT_AM00');
      [y2, i] = arselect('SR03C___BPM4YT_AM01');
      BPM34x=[BPM34x y1];
      BPM34y=[BPM34y y2]; 
      
      [y1, i] = arselect('SR03C___BPM5XT_AM02');
      [y2, i] = arselect('SR03C___BPM5YT_AM03');
      BPM35x=[BPM35x y1];
      BPM35y=[BPM35y y2]; 
      
      [y1, i] = arselect('SR07C___BPM4XT_AM00');
      [y2, i] = arselect('SR07C___BPM4YT_AM01');
      BPM74x=[BPM74x y1];
      BPM74y=[BPM74y y2]; 
      
      [y1, i] = arselect('SR07C___BPM5XT_AM02');
      [y2, i] = arselect('SR07C___BPM5YT_AM03');
      BPM75x=[BPM75x y1];
      BPM75y=[BPM75y y2]; 
      
      [y1, i] = arselect('SR04S___SPIRICOAM07');
      [y2, i] = arselect('SR04S___SPIRICOAM08');
      SigX31=[SigX31 y1];
      SigY31=[SigY31 y2];
      
      [y1, i] = arselect('bl31:XRMSAve');
      [y2, i] = arselect('bl31:YRMSAve');
      SigX31ave=[SigX31ave y1];
      SigY31ave=[SigY31ave y2];

      [y1, i] = arselect('bl72:XRMSNow');
      [y2, i] = arselect('bl72:YRMSNow');
      SigX72=[SigX72 y1];
      SigY72=[SigY72 y2];
      
      [y1, i] = arselect('bl72:XRMSAve');
      [y2, i] = arselect('bl72:YRMSAve');
      SigX72ave=[SigX72ave y1(1,:)]; %(1,:) because there is also a Ave_Error channel
      SigY72ave=[SigY72ave y2(1,:)];

      [y1, i] = arselect('SR04S___SPIRICOAM01');
      [y2, i] = arselect('SR04S___SPIRICOAM02');
      X31=[X31 y1];
      Y31=[Y31 y2];
      
      [y1, i] = arselect('bl31:XCentAve');
      [y2, i] = arselect('bl31:YCentAve');
      X31ave=[X31ave y1];
      Y31ave=[Y31ave y2];

      [y1, i] = arselect('bl72:XCentNow');
      [y2, i] = arselect('bl72:YCentNow');
      X72=[X72 y1];
      Y72=[Y72 y2];
     
      [y1, i] = arselect('bl72:XCentAve');
      [y2, i] = arselect('bl72:YCentAve');
      X72ave=[X72ave y1(1,:)];
      Y72ave=[Y72ave y2(1,:)];

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
      dcct = [dcct y1];
      
      [y1, igev] = arselect('cmm:sr_energy');
      gev = [gev y1];
      
      [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
      lifetime = [lifetime  y1];
      
      [y1,i]=arselect(['SR04U___ODS1PS_AM00';'SR11U___ODS1PS_AM00']);
      EPU =[EPU  y1];
      
      [y1,i]=arselect(getname('IDpos'));
      IDgap =[IDgap  y1];
      
      if FFFlag
         [y1,i]=arselect('sr07u:FFEnable:bi');
         FF7Enable =[FF7Enable  y1];
      end
      
      [y1, i] = arselect('SR03S___IBPM1X_AM');
      [y2, i] = arselect('SR03S___IBPM1Y_AM');
      [y3, i] = arselect('SR03S___IBPM2X_AM');
      [y4, i] = arselect('SR03S___IBPM2Y_AM');
      ID3BPM1x=[ID3BPM1x y1];
      ID3BPM1y=[ID3BPM1y y2]; 
      ID3BPM2x=[ID3BPM2x y3];
      ID3BPM2y=[ID3BPM2y y4];
      
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
      
      [y1, i] = arselect('SR03C___BPM4XT_AM00');
      [y2, i] = arselect('SR03C___BPM4YT_AM01');
      BPM34x=[BPM34x y1];
      BPM34y=[BPM34y y2]; 
      
      [y1, i] = arselect('SR03C___BPM5XT_AM02');
      [y2, i] = arselect('SR03C___BPM5YT_AM03');
      BPM35x=[BPM35x y1];
      BPM35y=[BPM35y y2]; 
      
      [y1, i] = arselect('SR07C___BPM4XT_AM00');
      [y2, i] = arselect('SR07C___BPM4YT_AM01');
      BPM74x=[BPM74x y1];
      BPM74y=[BPM74y y2]; 
      
      [y1, i] = arselect('SR07C___BPM5XT_AM02');
      [y2, i] = arselect('SR07C___BPM5YT_AM03');
      BPM75x=[BPM75x y1];
      BPM75y=[BPM75y y2]; 
      
      [y1, i] = arselect('SR04S___SPIRICOAM07');
      [y2, i] = arselect('SR04S___SPIRICOAM08');
      SigX31=[SigX31 y1];
      SigY31=[SigY31 y2];
      
      [y1, i] = arselect('bl31:XRMSAve');
      [y2, i] = arselect('bl31:YRMSAve');
      SigX31ave=[SigX31ave y1];
      SigY31ave=[SigY31ave y2];

      [y1, i] = arselect('bl72:XRMSNow');
      [y2, i] = arselect('bl72:YRMSNow');
      SigX72=[SigX72 y1];
      SigY72=[SigY72 y2];
      
      [y1, i] = arselect('bl72:XRMSAve');
      [y2, i] = arselect('bl72:YRMSAve');
      SigX72ave=[SigX72ave y1(1,:)]; %(1,:) because there is also a Ave_Error channel
      SigY72ave=[SigY72ave y2(1,:)];
      
      [y1, i] = arselect('SR04S___SPIRICOAM01');
      [y2, i] = arselect('SR04S___SPIRICOAM02');
      X31=[X31 y1];
      Y31=[Y31 y2];
      
      [y1, i] = arselect('bl31:XCentAve');
      [y2, i] = arselect('bl31:YCentAve');
      X31ave=[X31ave y1];
      Y31ave=[Y31ave y2];

      [y1, i] = arselect('bl72:XCentNow');
      [y2, i] = arselect('bl72:YCentNow');
      X72=[X72 y1];
      Y72=[Y72 y2];
     
      [y1, i] = arselect('bl72:XCentAve');
      [y2, i] = arselect('bl72:YCentAve');
      X72ave=[X72ave y1(1,:)];
      Y72ave=[Y72ave y2(1,:)];

      t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
         
      catch
         fprintf('  Error reading archived data file.\n');
         fprintf('  %s will be ignored.\n', FileName);
      end
      
      disp(' ');
   end
end


% condition data

dcct = 100*dcct;

% Remove points when current is below 1 mamps
[y, i]=find(dcct<1);
ID3BPM1x(i)=NaN*ones(size(i));
ID3BPM1y(i)=NaN*ones(size(i));
ID3BPM2x(i)=NaN*ones(size(i));
ID3BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
BPM34x(i)=NaN*ones(size(i));
BPM34y(i)=NaN*ones(size(i));
BPM35x(i)=NaN*ones(size(i));
BPM35y(i)=NaN*ones(size(i));
BPM74x(i)=NaN*ones(size(i));
BPM74y(i)=NaN*ones(size(i));
BPM75x(i)=NaN*ones(size(i));
BPM75y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX31(i)=NaN*ones(size(i));
SigY31(i)=NaN*ones(size(i));
SigX31ave(i)=NaN*ones(size(i));
SigY31ave(i)=NaN*ones(size(i));
SigX72(i)=NaN*ones(size(i));
SigY72(i)=NaN*ones(size(i));
SigX72ave(i)=NaN*ones(size(i));
SigY72ave(i)=NaN*ones(size(i));
X31(i)=NaN*ones(size(i));
Y31(i)=NaN*ones(size(i));
X31ave(i)=NaN*ones(size(i));
Y31ave(i)=NaN*ones(size(i));
X72(i)=NaN*ones(size(i));
Y72(i)=NaN*ones(size(i));
X72ave(i)=NaN*ones(size(i));
Y72ave(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

% Remove points when the current is below .5 mamps for the lifetime calculation
i = find(dcct < .5);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime1 = -diff(t/60/60)./(dlogdcct);
i = find(lifetime1 < 0);
lifetime1(i) = NaN;

% lifetime2 = -(diff(t(1:(end-9)))/60/60)./(dlogcam);
%i = find(lifetime2 < 0);
%lifetime2(i) = NaN;

% Remove points when FF is disabled
if FFFlag 
   [y, i]=find(FF7Enable==0);
   ID3BPM1x(i)=NaN*ones(size(i));
   ID3BPM1y(i)=NaN*ones(size(i));
   ID3BPM2x(i)=NaN*ones(size(i));
   ID3BPM2y(i)=NaN*ones(size(i));
   ID4BPM1x(i)=NaN*ones(size(i));
   ID4BPM1y(i)=NaN*ones(size(i));
   ID4BPM2x(i)=NaN*ones(size(i));
   ID4BPM2y(i)=NaN*ones(size(i));
   ID4BPM3x(i)=NaN*ones(size(i));
   ID4BPM3y(i)=NaN*ones(size(i));
   ID4BPM4x(i)=NaN*ones(size(i));
   ID4BPM4y(i)=NaN*ones(size(i));
   ID7BPM1x(i)=NaN*ones(size(i));
   ID7BPM1y(i)=NaN*ones(size(i));
   ID7BPM2x(i)=NaN*ones(size(i));
   ID7BPM2y(i)=NaN*ones(size(i));
   ID8BPM1x(i)=NaN*ones(size(i));
   ID8BPM1y(i)=NaN*ones(size(i));
   ID8BPM2x(i)=NaN*ones(size(i));
   ID8BPM2y(i)=NaN*ones(size(i));
   BPM34x(i)=NaN*ones(size(i));
   BPM34y(i)=NaN*ones(size(i));
   BPM35x(i)=NaN*ones(size(i));
   BPM35y(i)=NaN*ones(size(i));
   BPM74x(i)=NaN*ones(size(i));
   BPM74y(i)=NaN*ones(size(i));
   BPM75x(i)=NaN*ones(size(i));
   BPM75y(i)=NaN*ones(size(i));
   %dcct(i)=NaN*ones(size(i));
   EPU(:,i)=NaN*ones(2,length(i));
   IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
	SigX31(i)=NaN*ones(size(i));
	SigY31(i)=NaN*ones(size(i));
	SigX31ave(i)=NaN*ones(size(i));
	SigY31ave(i)=NaN*ones(size(i));
	SigX72(i)=NaN*ones(size(i));
	SigY72(i)=NaN*ones(size(i));
	SigX72ave(i)=NaN*ones(size(i));
	SigY72ave(i)=NaN*ones(size(i));
	X31(i)=NaN*ones(size(i));
	Y31(i)=NaN*ones(size(i));
	X31ave(i)=NaN*ones(size(i));
	Y31ave(i)=NaN*ones(size(i));
	X72(i)=NaN*ones(size(i));
	Y72(i)=NaN*ones(size(i));
	X72ave(i)=NaN*ones(size(i));
	Y72ave(i)=NaN*ones(size(i));
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
end   

% Remove points when the gaps are open
% j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
j = any(IDgap < 80);
i = 1:length(t);
i(j) = [];
ID3BPM1x(i)=NaN*ones(size(i));
ID3BPM1y(i)=NaN*ones(size(i));
ID3BPM2x(i)=NaN*ones(size(i));
ID3BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
BPM34x(i)=NaN*ones(size(i));
BPM34y(i)=NaN*ones(size(i));
BPM35x(i)=NaN*ones(size(i));
BPM35y(i)=NaN*ones(size(i));
BPM74x(i)=NaN*ones(size(i));
BPM74y(i)=NaN*ones(size(i));
BPM75x(i)=NaN*ones(size(i));
BPM75y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
EPU(:,i)=NaN*ones(2,length(i));
IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX31(i)=NaN*ones(size(i));
SigY31(i)=NaN*ones(size(i));
SigX31ave(i)=NaN*ones(size(i));
SigY31ave(i)=NaN*ones(size(i));
SigX72(i)=NaN*ones(size(i));
SigY72(i)=NaN*ones(size(i));
SigX72ave(i)=NaN*ones(size(i));
SigY72ave(i)=NaN*ones(size(i));
X31(i)=NaN*ones(size(i));
Y31(i)=NaN*ones(size(i));
X31ave(i)=NaN*ones(size(i));
Y31ave(i)=NaN*ones(size(i));
X72(i)=NaN*ones(size(i));
Y72(i)=NaN*ones(size(i));
X72ave(i)=NaN*ones(size(i));
Y72ave(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

% Remove points after a NaN
[y, i]=find(isnan(ID3BPM1x));
i = i + 1;
if ~isempty(i)
   if i(end) > length(ID3BPM1x)
      i = i(1:end-1);
   end
end
ID3BPM1x(i)=NaN*ones(size(i));
ID3BPM1y(i)=NaN*ones(size(i));
ID3BPM2x(i)=NaN*ones(size(i));
ID3BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
BPM34x(i)=NaN*ones(size(i));
BPM34y(i)=NaN*ones(size(i));
BPM35x(i)=NaN*ones(size(i));
BPM35y(i)=NaN*ones(size(i));
BPM74x(i)=NaN*ones(size(i));
BPM74y(i)=NaN*ones(size(i));
BPM75x(i)=NaN*ones(size(i));
BPM75y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX31(i)=NaN*ones(size(i));
SigY31(i)=NaN*ones(size(i));
SigX31ave(i)=NaN*ones(size(i));
SigY31ave(i)=NaN*ones(size(i));
SigX72(i)=NaN*ones(size(i));
SigY72(i)=NaN*ones(size(i));
SigX72ave(i)=NaN*ones(size(i));
SigY72ave(i)=NaN*ones(size(i));
X31(i)=NaN*ones(size(i));
Y31(i)=NaN*ones(size(i));
X31ave(i)=NaN*ones(size(i));
Y31ave(i)=NaN*ones(size(i));
X72(i)=NaN*ones(size(i));
Y72(i)=NaN*ones(size(i));
X72ave(i)=NaN*ones(size(i));
Y72ave(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

if 0
   % Remove points 2 after a NaN
   [y, i]=find(isnan(ID3BPM1x));
   i = i + 1;
   if ~isempty(i)
      if i(end) > length(ID3BPM1x)
         i = i(1:end-1);
      end
   end
   ID3BPM1x(i)=NaN*ones(size(i));
   ID3BPM1y(i)=NaN*ones(size(i));
   ID3BPM2x(i)=NaN*ones(size(i));
   ID3BPM2y(i)=NaN*ones(size(i));
   ID4BPM1x(i)=NaN*ones(size(i));
   ID4BPM1y(i)=NaN*ones(size(i));
   ID4BPM2x(i)=NaN*ones(size(i));
   ID4BPM2y(i)=NaN*ones(size(i));
   ID4BPM3x(i)=NaN*ones(size(i));
   ID4BPM3y(i)=NaN*ones(size(i));
   ID4BPM4x(i)=NaN*ones(size(i));
   ID4BPM4y(i)=NaN*ones(size(i));
   ID7BPM1x(i)=NaN*ones(size(i));
   ID7BPM1y(i)=NaN*ones(size(i));
   ID7BPM2x(i)=NaN*ones(size(i));
   ID7BPM2y(i)=NaN*ones(size(i));
   ID8BPM1x(i)=NaN*ones(size(i));
   ID8BPM1y(i)=NaN*ones(size(i));
   ID8BPM2x(i)=NaN*ones(size(i));
   ID8BPM2y(i)=NaN*ones(size(i));
   BPM34x(i)=NaN*ones(size(i));
   BPM34y(i)=NaN*ones(size(i));
   BPM35x(i)=NaN*ones(size(i));
   BPM35y(i)=NaN*ones(size(i));
   BPM74x(i)=NaN*ones(size(i));
   BPM74y(i)=NaN*ones(size(i));
   BPM75x(i)=NaN*ones(size(i));
   BPM75y(i)=NaN*ones(size(i));
   %dcct(i)=NaN*ones(size(i));
   %EPU(:,i)=NaN*ones(2,length(i));
   %IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
	SigX31(i)=NaN*ones(size(i));
	SigY31(i)=NaN*ones(size(i));
	SigX31ave(i)=NaN*ones(size(i));
	SigY31ave(i)=NaN*ones(size(i));
	SigX72(i)=NaN*ones(size(i));
	SigY72(i)=NaN*ones(size(i));
	SigX72ave(i)=NaN*ones(size(i));
	SigY72ave(i)=NaN*ones(size(i));
	X31(i)=NaN*ones(size(i));
	Y31(i)=NaN*ones(size(i));
	X31ave(i)=NaN*ones(size(i));
	Y31ave(i)=NaN*ones(size(i));
	X72(i)=NaN*ones(size(i));
	Y72(i)=NaN*ones(size(i));
	X72ave(i)=NaN*ones(size(i));
	Y72ave(i)=NaN*ones(size(i));
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
end

% Remove points before a NaN
i = i - 2;
if ~isempty(i)
   if i(1) < 1
      i = i(2:end);
   end
end
ID3BPM1x(i)=NaN*ones(size(i));
ID3BPM1y(i)=NaN*ones(size(i));
ID3BPM2x(i)=NaN*ones(size(i));
ID3BPM2y(i)=NaN*ones(size(i));
ID4BPM1x(i)=NaN*ones(size(i));
ID4BPM1y(i)=NaN*ones(size(i));
ID4BPM2x(i)=NaN*ones(size(i));
ID4BPM2y(i)=NaN*ones(size(i));
ID4BPM3x(i)=NaN*ones(size(i));
ID4BPM3y(i)=NaN*ones(size(i));
ID4BPM4x(i)=NaN*ones(size(i));
ID4BPM4y(i)=NaN*ones(size(i));
ID7BPM1x(i)=NaN*ones(size(i));
ID7BPM1y(i)=NaN*ones(size(i));
ID7BPM2x(i)=NaN*ones(size(i));
ID7BPM2y(i)=NaN*ones(size(i));
ID8BPM1x(i)=NaN*ones(size(i));
ID8BPM1y(i)=NaN*ones(size(i));
ID8BPM2x(i)=NaN*ones(size(i));
ID8BPM2y(i)=NaN*ones(size(i));
BPM34x(i)=NaN*ones(size(i));
BPM34y(i)=NaN*ones(size(i));
BPM35x(i)=NaN*ones(size(i));
BPM35y(i)=NaN*ones(size(i));
BPM74x(i)=NaN*ones(size(i));
BPM74y(i)=NaN*ones(size(i));
BPM75x(i)=NaN*ones(size(i));
BPM75y(i)=NaN*ones(size(i));
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
SigX31(i)=NaN*ones(size(i));
SigY31(i)=NaN*ones(size(i));
SigX31ave(i)=NaN*ones(size(i));
SigY31ave(i)=NaN*ones(size(i));
SigX72(i)=NaN*ones(size(i));
SigY72(i)=NaN*ones(size(i));
SigX72ave(i)=NaN*ones(size(i));
SigY72ave(i)=NaN*ones(size(i));
X31(i)=NaN*ones(size(i));
Y31(i)=NaN*ones(size(i));
X31ave(i)=NaN*ones(size(i));
Y31ave(i)=NaN*ones(size(i));
X72(i)=NaN*ones(size(i));
Y72(i)=NaN*ones(size(i));
X72ave(i)=NaN*ones(size(i));
Y72ave(i)=NaN*ones(size(i));
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));


% Subtract known amount (golden orbit)
Sector = 3;
IDBPMgoalx = getgoldenorbit('IDBPMx', [Sector 1; Sector 2]);
IDBPMgoaly = getgoldenorbit('IDBPMy', [Sector 1; Sector 2]);
i3_1x=IDBPMgoalx(1); ID3BPM1x=ID3BPM1x-i3_1x;
i3_1y=IDBPMgoaly(1); ID3BPM1y=ID3BPM1y-i3_1y;
i3_2x=IDBPMgoalx(2); ID3BPM2x=ID3BPM2x-i3_2x;
i3_2y=IDBPMgoaly(2); ID3BPM2y=ID3BPM2y-i3_2y;

BBPMgoalx = getgoldenorbit('BBPMx', [Sector 4; Sector 5]);
BBPMgoaly = getgoldenorbit('BBPMy', [Sector 4; Sector 5]);
b3_4x=BBPMgoalx(1); BPM34x=BPM34x-b3_4x;
b3_4y=BBPMgoaly(1); BPM34y=BPM34y-b3_4y;
b3_5x=BBPMgoalx(2); BPM35x=BPM35x-b3_5x;
b3_5y=BBPMgoaly(2); BPM35y=BPM35y-b3_5y;

Sector = 4;
IDBPMgoalx = getgoldenorbit('IDBPMx', [Sector 1; Sector 2]);
IDBPMgoaly = getgoldenorbit('IDBPMy', [Sector 1; Sector 2]);
i4_1x=IDBPMgoalx(1); ID4BPM1x=ID4BPM1x-i4_1x;
i4_1y=IDBPMgoaly(1); ID4BPM1y=ID4BPM1y-i4_1y;
i4_2x=IDBPMgoalx(2); ID4BPM2x=ID4BPM2x-i4_2x;
i4_2y=IDBPMgoaly(2); ID4BPM2y=ID4BPM2y-i4_2y;

IDBPMgoalx = getgoldenorbit('IDBPMx', [Sector 3; Sector 4]);
IDBPMgoaly = getgoldenorbit('IDBPMy', [Sector 3; Sector 4]);
i4_3x=IDBPMgoalx(1); ID4BPM3x=ID4BPM3x-i4_3x;
i4_3y=IDBPMgoaly(1); ID4BPM3y=ID4BPM3y-i4_3y;
i4_4x=IDBPMgoalx(2); ID4BPM4x=ID4BPM4x-i4_4x;
i4_4y=IDBPMgoaly(2); ID4BPM4y=ID4BPM4y-i4_4y;

Sector =7;
IDBPMgoalx = getgoldenorbit('IDBPMx', [Sector 1; Sector 2]);
IDBPMgoaly = getgoldenorbit('IDBPMy', [Sector 1; Sector 2]);
i7_1x=IDBPMgoalx(1); ID7BPM1x=ID7BPM1x-i7_1x;
i7_1y=IDBPMgoaly(1); ID7BPM1y=ID7BPM1y-i7_1y;
i7_2x=IDBPMgoalx(2); ID7BPM2x=ID7BPM2x-i7_2x;
i7_2y=IDBPMgoaly(2); ID7BPM2y=ID7BPM2y-i7_2y;

BBPMgoalx = getgoldenorbit('BBPMx', [Sector 4; Sector 5]);
BBPMgoaly = getgoldenorbit('BBPMy', [Sector 4; Sector 5]);
b7_4x=BBPMgoalx(1); BPM74x=BPM74x-b7_4x;
b7_4y=BBPMgoaly(1); BPM74y=BPM74y-b7_4y;
b7_5x=BBPMgoalx(2); BPM75x=BPM75x-b7_5x;
b7_5y=BBPMgoaly(2); BPM75y=BPM75y-b7_5y;

Sector = 8;
IDBPMgoalx = getgoldenorbit('IDBPMx', [Sector 1; Sector 2]);
IDBPMgoaly = getgoldenorbit('IDBPMy', [Sector 1; Sector 2]);
i8_1x=IDBPMgoalx(1); ID8BPM1x=ID8BPM1x-i8_1x;
i8_1y=IDBPMgoaly(1); ID8BPM1y=ID8BPM1y-i8_1y;
i8_2x=IDBPMgoalx(2); ID8BPM2x=ID8BPM2x-i8_2x;
i8_2y=IDBPMgoaly(2); ID8BPM2y=ID8BPM2y-i8_2y;

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

% change data to NaN for plotting if archiver has stalled for more than 12minutes
StalledArchFlag = [];
for loop = 1:size(t,2)-1
   StalledArchFlag(loop) = (t(loop+1)-t(loop)>0.2);
end
SANum = find(StalledArchFlag==1)+1;
dcct(SANum)=NaN;

for loop = 1:size(SigX31,2)
	[Emittance(loop), ESpread(loop)] = emit_spread(SigX31(loop)/2, SigX72(loop));
end

% plot beam sizes and calculated emittance and energy spread
figure(1); clf;
subplot(6,1,1);
plot(t, SigX31/2.0, 'b', t, SigX31ave, 'r'); grid on;
ylabel('\fontsize{10}BL 3.1 RMS \sigma_x [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 40 70]);
ChangeAxesLabel(t, Days, DayFlag);
title(['Diagnostic beamlines data: ',titleStr]);

subplot(6,1,2);
plot(t, SigY31/2.0, 'b', t, SigY31ave, 'r'); grid on;
ylabel('\fontsize{10}BL 3.1 RMS \sigma_y [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 40 70]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,3);
plot(t, SigX72, 'b', t, SigX72ave, 'r'); grid on;
ylabel('\fontsize{10}BL 7.2 RMS \sigma_x [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 105 125]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,4);
plot(t, SigY72, 'b', t, SigY72ave, 'r'); grid on;
ylabel('\fontsize{10}BL 7.2 RMS \sigma_y [\mum]');
legend('raw', 'averaged')
axis tight
axis([0 xmax 30 60]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,5);
plot(t, Emittance*1e9, 'b'); grid on;
ylabel('\fontsize{10}Emittance [nm]');
axis tight
axis([0 xmax 3 8]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(6,1,6)
plot(t, ESpread*100, 'b'); grid on;
ylabel('\fontsize{10}Energy Spread [%]');
axis tight
axis([0 xmax 0.05 0.15]);
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
orient tall


% plot beam sizes: raw and averaged
figure(2); clf;
subplot(4,1,1);
plot(t, X31, 'b', t, X31ave, 'r'); grid on;
ylabel('\fontsize{10}BL 3.1 X [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 120 170]);
ChangeAxesLabel(t, Days, DayFlag);
title(['Diagnostic beamlines data: ',titleStr]);

subplot(4,1,2);
plot(t, Y31, 'b', t, Y31ave, 'r'); grid on;
ylabel('\fontsize{10}BL 3.1 Y [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 170 230]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,3);
plot(t, X72, 'b', t, X72ave, 'r'); grid on;
ylabel('\fontsize{10}BL 7.2 X [\mum]');
legend('raw', 'averaged')
axis tight;
axis([0 xmax 380 390]);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,4);
plot(t, Y72, 'b', t, Y72ave, 'r'); grid on;
ylabel('\fontsize{10}BL 7.2 Y [\mum]');
legend('raw', 'averaged')
axis tight
axis([0 xmax 425 435]);
ChangeAxesLabel(t, Days, DayFlag);

orient tall


return

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
