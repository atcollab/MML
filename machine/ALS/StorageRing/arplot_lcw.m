function arplot_lcw(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_LCW - Plots various data from the ALS archiver for some LCW parameters
%  arplot_lcwalc(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLE
%  arplot_lcw('September',1:19,2008);
%


% Inputs
if nargin < 2
    monthStr = 'August';
    days = 5;
end
if nargin < 3
    tmp = clock;
    year1 = tmp(1);
end
if nargin < 4
    monthStr2 = [];
end
if nargin < 5
    days2 = [];
end
if nargin < 6
    tmp = clock;
    year2 = tmp(1);
end


BooleanFlag = 1;

arglobal

LeftGraphColor = 'b';
RightGraphColor = 'r';

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

t = [];LCWparams = [];
lcw = [];
brlcw = [];
CWTemp = [];
CWValve = [];
RingLCWSupPx = [];
RingLCWRetPx = [];
LCWSupPx = [];
LCWRetPx = [];
LCWSupTemp = [];
LCWRetTemp = [];
TRWSupTemp = [];
TRWRetTemp = [];
WBasinTemp = [];
EBasinTemp = [];
Flow10inSup = [];
Flow6inSup = [];
Flow10inRet = [];
Flow6inRet = [];
AlCorrR = [];
CuCorrR =[];
ConductSup = [];
ConductRet = [];
O2Sup = [];
O2Ret = [];
pHSup = [];
pHRet = [];
EBottleValve = [];
EBottleConduct = [];
WBottleValve = [];
WBottleConduct = [];

SR01Girder = [];
SR02Girder = [];
SR03Girder = [];
SR04Girder = [];
SR05Girder = [];
SR06Girder = [];
SR07Girder = [];
SR08Girder = [];
SR09Girder = [];
SR10Girder = [];
SR11Girder = [];
SR12Girder = [];
SR01Rack = [];
SR02Rack = [];
SR03Rack = [];
SR04Rack = [];
SR05Rack = [];
SR06Rack = [];
SR07Rack = [];
SR08Rack = [];
SR09Rack = [];
SR10Rack = [];
SR11Rack = [];
SR12Rack = [];
SR04PST4 = [];
SR04PST5 = [];
SR04PST6 = [];
SR08PST4 = [];
SR08PST5 = [];
SR08PST6 = [];
SR12PST4 = [];
SR12PST5 = [];
SR12PST6 = [];

if datenum(year1, month, days(1)) < 734677 %data before 6-23-2011, when LCW pump PVs were changed
    ChanNames = {
        'GP100_SPEED','Exchanger Pump Speed'
        'GP101_SPEED','Exchanger Pump Speed'
        'GP110_SPEED','Treated Water Pump Speed'
        'GP112_SPEED','LCW Pump Speed'
        'GP113_SPEED','LCW Pump Speed'
        'GP114_SPEED','LCW Pump Speed'
        'GP115_SPEED','LCW Pump Speed'
        'GP116_SPEED','LCW Pump Speed'
        'GP112_STATE','LCW Pump On Off'
        'GP113_STATE','LCW Pump On Off'
        'GP117_SPEED','Treated Water Pump Speed'
        'CT100_SPEED','Fan Speed'
        'CT101_SPEED','Fan Speed'
        'GP102_STATE','Exchanger Pump (GP102)'
        'GP103_STATE','Exchanger Pump (GP102)'
        'GP104_STATE','Exchanger Pump (GP102)'
        };
    
    SPPname='37LCW___SPPAVG_AM00'; %LCW supply pressure average in PSI
    RTPname='37LCW___RTP____AM00'; %LCW return pressure in PSIG
    SPTname='37LCW___SPTAVG_AM00'; %LCW supply temperature average in deg. F
    RTTname='37LCW___RTT'; %LCW return temperature (3 entries)
    WBasinname='37CT100_TW_ST__AM00'; %North Cooling tower supply (basin) temperature
    EBasinname='37CT101_TW_ST__AM00'; %South Cooling tower supply (basin) temperature
    TRWSTname='B37_TRW_SPTAVG_AM00';
    TRWRTname='B37_TRW_RTTAVG_AM00';
    
    ConductSupname = '37LCW___SPWCOD';
    ConductRetname = '37LCW___RTWCOD';
    O2Supname = '37LCW___SPOXY';
    O2Retname = '37LCW___RTOXY';
    pHSupname = '37LCW___SPPH';
    pHRetname = '37LCW___RTPH';

    SRRFlcwtmpname = 'SR03S___LCWTMP_AM00';
    
elseif datenum(year1, month, days(1)) < 735466 %data before 8-20-2013, when ALC system was installed
    ChanNames = {
        'GP100_SPEED','Exchanger Pump Speed (GP100)'
        'GP101_SPEED','Exchanger Pump Speed (GP101)'
        'GP110_SPEED','TRW Pump Speed (GP110)'
        'GP138_SPEED','LCW Pump Speed (GP138)' % replaces 'GP112_SPEED' as of 6-23-2011
        'GP139_SPEED','LCW Pump Speed (GP139)' % replaces 'GP113_SPEED' as of 6-23-2011
        'GP140_SPEED','LCW Pump Speed (GP140)' % replaces 'GP114_SPEED' as of 6-23-2011
        'GP141_SPEED','LCW Pump Speed (GP141)' % replaces 'GP115_SPEED' as of 6-23-2011
        'GP142_SPEED','LCW Pump Speed (GP142)' % replaces 'GP116_SPEED' as of 6-23-2011
        %        'GP138_STATE','LCW Pump On Off' % replaces 'GP112_STATE' as of 6-23-2011
        %        'GP139_STATE','LCW Pump On Off' % replaces 'GP113_STATE' as of 6-23-2011
        'GP117_SPEED','TRW Pump Speed (GP117)'
        'CT100_SPEED','Fan Speed (CT100)'
        'CT101_SPEED','Fan Speed (CT101)'
        'GP102_STATE','Exchanger Pump (GP102)'
        'GP103_STATE','Exchanger Pump (GP103)'
        'GP104_STATE','Exchanger Pump (GP104)'
        };
    
    SPPname='37LCW___SPPAVG_AM00'; %LCW supply pressure average in PSI
    RTPname='37LCW___RTP____AM00'; %LCW return pressure in PSIG
    SPTname='37LCW___SPTAVG_AM00'; %LCW supply temperature average in deg. F
    RTTname='37LCW___RTT'; %LCW return temperature (3 entries)
    WBasinname='37CT100_TW_ST__AM00'; %North Cooling tower supply (basin) temperature
    EBasinname='37CT101_TW_ST__AM00'; %South Cooling tower supply (basin) temperature
    TRWSTname='B37_TRW_SPTAVG_AM00';
    TRWRTname='B37_TRW_RTTAVG_AM00';
    
    ConductSupname = '37LCW___SPWCOD';
    ConductRetname = '37LCW___RTWCOD';
    O2Supname = '37LCW___SPOXY';
    O2Retname = '37LCW___RTOXY';
    pHSupname = '37LCW___SPPH';
    pHRetname = '37LCW___RTPH';

    SRRFlcwtmpname = 'SR03S___LCWTMP_AM00';

elseif datenum(year1, month, days(1)) < 735778  %data before 6-28-2014, when readback for exchanger pumps that are now all VFDs was added
    ChanNames = {
        'B37_CW__GP100__AM02','Exchanger Pump Speed (GP100)'
        'B37_CW__GP101__AM02','Exchanger Pump Speed (GP101)'
        'B37_LCW_GP110__AM02','TRW Pump Speed (GP110)'
        'B37_LCW_GP138__AM02','LCW Pump Speed (GP138)'
        'B37_LCW_GP139__AM02','LCW Pump Speed (GP139)'
        'B37_LCW_GP140__AM02','LCW Pump Speed (GP140)'
        'B37_LCW_GP141__AM02','LCW Pump Speed (GP141)'
        'B37_LCW_GP142__AM02','LCW Pump Speed (GP142)'
        'B37_LCW_GP117__AM02','TRW Pump Speed (GP117)'
        'B37_CW__CT100__AM00','Fan Speed (CT100)'
        'B37_CW__CT101__AM00','Fan Speed (CT101)'
        'B37_CW__GP102__BM00','Exchanger Pump (GP102)'
        'B37_CW__GP103__BM00','Exchanger Pump (GP103)'
        'B37_CW__GP104__BM00','Exchanger Pump (GP104)'
        'B37_LCW_EX102__AM00','Exchanger Valve (EX102)'
        'B37_LCW_EX103__AM00','Exchanger Valve (EX103)'
        'B37_LCW_EX104__AM00','Exchanger Valve (EX104)'
        'B37_LCW_EX105__AM00','Exchanger Valve (EX105)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX100)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX101)'
        };
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    %     RTPname='B37_LCW_RTPAVG_AM00'; %LCW return pressure in PSIG
    SPPname='B37_LCW_SPP1___AM00'; %LCW supply pressure average in PSI
    RTPname='B37_LCW_RTP1___AM00'; %LCW return pressure in PSIG
    SPTname='B37_LCW_SPT'; %LCW supply temperature average in deg. F
    RTTname='B37_LCW_RTT'; %LCW return temperature (3 entries)
    WBasinname='B37_CW__ST_W___AM00'; %North Cooling tower supply (basin) temperature
    EBasinname='B37_CW__ST_E___AM00'; %South Cooling tower supply (basin) temperature
    %     TRWSTname='B37_TRW_SPTAVG_AM00';
    %     TRWRTname='B37_TRW_RTTAVG_AM00';
    TRWSTname='B37_TRW_SPT1___AM00';
    TRWRTname='B37_TRW_RTT1___AM00';
    
    ConductSupname = 'B37_LCW_SYSSCD_AM00';
    ConductRetname = 'B37_LCW_SYSRCD_AM00';
    O2Supname = 'B37_LCW_SPOXY__AM00';
    O2Retname = 'B37_LCW_RTOXY__AM00';
    pHSupname = 'B37_LCW_SPPH___AM00';
    pHRetname = 'B37_LCW_RTPH___AM00';
    
    
    EBottleValvename = 'B37_LCW_VECOND_AM00';
    EBottleConductname = 'B37_LCW_EBTLCODAM00';
    WBottleValvename = 'B37_LCW_VWCOND_AM00';
    WBottleConductname = 'B37_LCW_WBTLCODAM00';

    SRRFlcwtmpname = 'SR03S___LCWTMP_AM00';

elseif datenum(year1, month, days(1)) < 736764  %data before 2017-3-10, when CT102 was added
    
    ChanNames = {
        'B37_CW__GP100__AM02','Exchanger Pump Speed (GP100)'
        'B37_CW__GP101__AM02','Exchanger Pump Speed (GP101)'
        'B37_CW__GP102__AM02','Exchanger Pump Speed (GP102)'
        'B37_CW__GP103__AM02','Exchanger Pump Speed (GP103)'
        'B37_CW__GP104__AM02','Exchanger Pump Speed (GP104)'
        'B37_LCW_GP110__AM02','TRW Pump Speed (GP110)'
        'B37_LCW_GP138__AM02','LCW Pump Speed (GP138)'
        'B37_LCW_GP139__AM02','LCW Pump Speed (GP139)'
        'B37_LCW_GP140__AM02','LCW Pump Speed (GP140)'
        'B37_LCW_GP141__AM02','LCW Pump Speed (GP141)'
        'B37_LCW_GP142__AM02','LCW Pump Speed (GP142)'
        'B37_LCW_GP117__AM02','TRW Pump Speed (GP117)'
        'B37_CW__CT100__AM00','Fan Speed (CT100)'
        'B37_CW__CT101__AM00','Fan Speed (CT101)'
        'B37_CW__GP100__BM00','Exchanger Pump (GP100)'
        'B37_CW__GP101__BM00','Exchanger Pump (GP101)'
        'B37_CW__GP102__BM00','Exchanger Pump (GP102)'
        'B37_CW__GP103__BM00','Exchanger Pump (GP103)'
        'B37_CW__GP104__BM00','Exchanger Pump (GP104)'
        'B37_LCW_EX102__AM00','Exchanger Valve (EX102)'
        'B37_LCW_EX103__AM00','Exchanger Valve (EX103)'
        'B37_LCW_EX104__AM00','Exchanger Valve (EX104)'
        'B37_LCW_EX105__AM00','Exchanger Valve (EX105)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX100)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX101)'
        };
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    %     RTPname='B37_LCW_RTPAVG_AM00'; %LCW return pressure in PSIG
    SPPname='B37_LCW_SPP1___AM00'; %LCW supply pressure average in PSI
    RTPname='B37_LCW_RTP1___AM00'; %LCW return pressure in PSIG
    SPTname='B37_LCW_SPT'; %LCW supply temperature average in deg. F
    RTTname='B37_LCW_RTT'; %LCW return temperature (3 entries)
    WBasinname='B37_CW__ST_W___AM00'; %North Cooling tower supply (basin) temperature
    EBasinname='B37_CW__ST_E___AM00'; %South Cooling tower supply (basin) temperature
    %     TRWSTname='B37_TRW_SPTAVG_AM00';
    %     TRWRTname='B37_TRW_RTTAVG_AM00';
    TRWSTname='B37_TRW_SPT1___AM00';
    TRWRTname='B37_TRW_RTT1___AM00';
    
    ConductSupname = 'B37_LCW_SYSSCD_AM00';
    ConductRetname = 'B37_LCW_SYSRCD_AM00';
    O2Supname = 'B37_LCW_SPOXY__AM00';
    O2Retname = 'B37_LCW_RTOXY__AM00';
    pHSupname = 'B37_LCW_SPPH___AM00';
    pHRetname = 'B37_LCW_RTPH___AM00';
    
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    
    EBottleValvename = 'B37_LCW_VECOND_AM00';
    EBottleConductname = 'B37_LCW_EBTLCODAM00';
    WBottleValvename = 'B37_LCW_VWCOND_AM00';
    WBottleConductname = 'B37_LCW_WBTLCODAM00';
    
    SRRFlcwtmpname = 'SR03S___LCWTMP_AM00';

elseif datenum(year1, month, days(1)) < 736939  %data before 2017-9-1 (new pump configuration happene before 9/1)
    ChanNames = {
        'B37_CW__GP100__AM02','Exchanger Pump Speed (GP100)'
        'B37_CW__GP101__AM02','Exchanger Pump Speed (GP101)'
        'B37_CW__GP102__AM02','Exchanger Pump Speed (GP102)'
        'B37_CW__GP103__AM02','Exchanger Pump Speed (GP103)'
        'B37_CW__GP104__AM02','Exchanger Pump Speed (GP104)'
        'B37_LCW_GP110__AM02','TRW Pump Speed (GP110)'
        'B37_LCW_GP138__AM02','LCW Pump Speed (GP138)'
        'B37_LCW_GP139__AM02','LCW Pump Speed (GP139)'
        'B37_LCW_GP140__AM02','LCW Pump Speed (GP140)'
        'B37_LCW_GP141__AM02','LCW Pump Speed (GP141)'
        'B37_LCW_GP142__AM02','LCW Pump Speed (GP142)'
        'B37_LCW_GP117__AM02','TRW Pump Speed (GP117)'
        'B37_CW__CT100__AM00','Fan Speed (CT100)'
        'B37_CW__CT101__AM00','Fan Speed (CT101)'
        'B37_CW__CT102__AM00','Fan Speed (CT102)'
        'B37_CW__GP100__BM00','Exchanger Pump (GP100)'
        'B37_CW__GP101__BM00','Exchanger Pump (GP101)'
        'B37_CW__GP102__BM00','Exchanger Pump (GP102)'
        'B37_CW__GP103__BM00','Exchanger Pump (GP103)'
        'B37_CW__GP104__BM00','Exchanger Pump (GP104)'
        'B37_LCW_EX102__AM00','Exchanger Valve (EX102)'
        'B37_LCW_EX103__AM00','Exchanger Valve (EX103)'
        'B37_LCW_EX104__AM00','Exchanger Valve (EX104)'
        'B37_LCW_EX105__AM00','Exchanger Valve (EX105)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX100)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX101)'
        };
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    %     RTPname='B37_LCW_RTPAVG_AM00'; %LCW return pressure in PSIG
    SPPname='B37_LCW_SPP1___AM00'; %LCW supply pressure average in PSI
    RTPname='B37_LCW_RTP1___AM00'; %LCW return pressure in PSIG
    SPTname='B37_LCW_SPT'; %LCW supply temperature average in deg. F
    RTTname='B37_LCW_RTT'; %LCW return temperature (3 entries)
    WBasinname='B37_CW__ST_'; % Basin Supply temperature
    EBasinname='B37_CW__RT_'; % Basin Return Temperature
    %     TRWSTname='B37_TRW_SPTAVG_AM00';
    %     TRWRTname='B37_TRW_RTTAVG_AM00';
    TRWSTname='B37_TRW_SPT1___AM00';
    TRWRTname='B37_TRW_RTT1___AM00';
    
    ConductSupname = 'B37_LCW_SYSSCD_AM00';
    ConductRetname = 'B37_LCW_SYSRCD_AM00';
    O2Supname = 'B37_LCW_SPOXY__AM00';
    O2Retname = 'B37_LCW_RTOXY__AM00';
    pHSupname = 'B37_LCW_SPPH___AM00';
    pHRetname = 'B37_LCW_RTPH___AM00';
    
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    
    EBottleValvename = 'B37_LCW_VECOND_AM00';
    EBottleConductname = 'B37_LCW_EBTLCODAM00';
    WBottleValvename = 'B37_LCW_VWCOND_AM00';
    WBottleConductname = 'B37_LCW_WBTLCODAM00';

    SRRFlcwtmpname = 'SR03S___LCWTMP_AM00';

else
    ChanNames = {
        'B37_CW__GP144__AM03','Exchanger Diff Pressure (GP144)'
        'B37_CW__GP145__AM03','Exchanger Diff Pressure (GP145)'
        'B37_CW__GP146__AM02','Exchanger Pump Speed (GP146)'
        'B37_CW__GP147__AM02','Exchanger Pump Speed (GP147)'
        'B37_CW__GP148__AM02','Exchanger Pump Speed (GP148)'
        'B37_LCW_GP110__AM02','TRW Pump Speed (GP110)'
        'B37_LCW_GP138__AM02','LCW Pump Speed (GP138)'
        'B37_LCW_GP139__AM02','LCW Pump Speed (GP139)'
        'B37_LCW_GP140__AM02','LCW Pump Speed (GP140)'
        'B37_LCW_GP141__AM02','LCW Pump Speed (GP141)'
        'B37_LCW_GP142__AM02','LCW Pump Speed (GP142)'
        'B37_LCW_GP117__AM02','TRW Pump Speed (GP117)'
        'B37_CW__CT102__AM00','Fan Speed (CT102)'
        'B37_CW__GP146__BM00','Exchanger Pump (GP146)'
        'B37_CW__GP147__BM00','Exchanger Pump (GP147)'
        'B37_CW__GP148__BM00','Exchanger Pump (GP148)'
        'B37_CW_FLWT____AM00','Tower flow rate'
        'B37_LCW_EX102__AM00','Exchanger Valve (EX102)'
        'B37_LCW_EX103__AM00','Exchanger Valve (EX103)'
        'B37_LCW_EX104__AM00','Exchanger Valve (EX104)'
        'B37_LCW_EX105__AM00','Exchanger Valve (EX105)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX100)'
        'B37_TRW_EX100__AM00','TRW Exchanger Valve (EX101)'
        };
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    %     RTPname='B37_LCW_RTPAVG_AM00'; %LCW return pressure in PSIG
    SPPname='B37_LCW_SPP1___AM00'; %LCW supply pressure average in PSI
    RTPname='B37_LCW_RTP1___AM00'; %LCW return pressure in PSIG
    SPTname='B37_LCW_SPT'; %LCW supply temperature average in deg. F
    RTTname='B37_LCW_RTT'; %LCW return temperature (3 entries)
    WBasinname='B37_CW__ST_'; % Basin Supply temperature
    EBasinname='B37_CW__RT_'; % Basin Return Temperature
    %     TRWSTname='B37_TRW_SPTAVG_AM00';
    %     TRWRTname='B37_TRW_RTTAVG_AM00';
    TRWSTname='B37_TRW_SPT1___AM00';
    TRWRTname='B37_TRW_RTT1___AM00';
    
    ConductSupname = 'B37_LCW_SYSSCD_AM00';
    ConductRetname = 'B37_LCW_SYSRCD_AM00';
    O2Supname = 'B37_LCW_SPOXY__AM00';
    O2Retname = 'B37_LCW_RTOXY__AM00';
    pHSupname = 'B37_LCW_SPPH___AM00';
    pHRetname = 'B37_LCW_RTPH___AM00';
    
    
    %     SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    
    EBottleValvename = 'B37_LCW_VECOND_AM00';
    EBottleConductname = 'B37_LCW_EBTLCODAM00';
    WBottleValvename = 'B37_LCW_VWCOND_AM00';
    WBottleConductname = 'B37_LCW_WBTLCODAM00';
    
    SRRFlcwtmpname = 'SR03S___LCWTMP_AM99';
    
end

exchangerind = [];
for loop=1:length(ChanNames)
    if strfind(ChanNames{loop,2},'Exchanger')==1
        exchangerind=[exchangerind loop];
    end
end

valveind = [];
for loop=1:length(ChanNames)
    if strfind(ChanNames{loop,2},'Valve')>0
        valveind=[valveind loop];
    end
end

lcwind = [];
for loop=1:length(ChanNames)
    if strfind(ChanNames{loop,2},'LCW Pump')==1
        lcwind=[lcwind loop];
    end
end


waterpumpind = [];
for loop=1:length(ChanNames)
    if strfind(ChanNames{loop,2},'Pump Speed')>0
        waterpumpind=[waterpumpind loop];
    end
end

booleanind = [];
for loop=1:length(ChanNames)
    if ~isempty(strfind(ChanNames{loop,2},'Pump (GP'))
        booleanind=[booleanind loop];
    end
end

fanind = [];
for loop=1:length(ChanNames)
    if ~isempty(strfind(ChanNames{loop,2},'Fan'))
        fanind=[fanind loop];
    end
end

flowind = [];
for loop=1:length(ChanNames)
    if ~isempty(strfind(ChanNames{loop,2},'Tower flow rate'))
        flowind=[fanind loop];
    end
end

waterind = 1:length(ChanNames);
waterind([booleanind fanind valveind flowind])=[];

% Month #1
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    
    try
        arread(FileName, BooleanFlag);
        
        % time vector
        t = [t ARt+(day-StartDay)*24*60*60];
        
        % Add Channels Here (and below)
        LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];
               
        lcw = [lcw arselect(SRRFlcwtmpname)];
        brlcw = [brlcw arselect('BR4_____LCWTMP_AM03')];
        CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
        CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve
        RingLCWSupPx = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
        RingLCWRetPx = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
        LCWSupPx = [LCWSupPx arselect(SPPname)]; %LCW supply pressure average in PSI
        LCWRetPx = [LCWRetPx arselect(RTPname)]; %LCW return pressure in PSIG
        LCWSupTemp = [LCWSupTemp arselect(SPTname)]; %LCW supply temperature average in deg. F
        LCWRetTemp = [LCWRetTemp arselect(RTTname)]; %LCW return temperature
        TRWSupTemp = [TRWSupTemp arselect(TRWSTname)]; %TRW supply temperature average in deg. F
        TRWRetTemp = [TRWRetTemp arselect(TRWRTname)]; %TRW return temperature
        WBasinTemp = [WBasinTemp arselect(WBasinname)]; %North Cooling tower supply (basin) temperature
        EBasinTemp = [EBasinTemp arselect(EBasinname)]; %South Cooling tower supply (basin) temperature
        
        Flow10inSup = [Flow10inSup arselect('B37_LCW_FLWS10_AM00')];
        Flow6inSup = [Flow6inSup arselect('B37_LCW_FLWS6__AM00')];
        Flow10inRet = [Flow10inRet arselect('B37_LCW_FLWR10_AM00')];
        Flow6inRet = [Flow6inRet arselect('B37_LCW_FLWR6__AM00')];
        AlCorrR = [AlCorrR arselect('B37_LCW_AL_COR_AM00')];
        CuCorrR =[CuCorrR arselect('B37_LCW_CU_COR_AM00')];
        ConductSup = [ConductSup arselect(ConductSupname)];
        ConductRet = [ConductRet arselect(ConductRetname)];
        O2Sup = [O2Sup arselect(O2Supname)];
        O2Ret = [O2Ret arselect(O2Retname)];
        pHSup = [pHSup arselect(pHSupname)];
        pHRet = [pHRet arselect(pHRetname)];
        EBottleValve = [EBottleValve arselect(EBottleValvename)];
        EBottleConduct = [EBottleConduct arselect(EBottleConductname)];
        WBottleValve = [WBottleValve arselect(WBottleValvename)];
        WBottleConduct = [WBottleConduct arselect(WBottleConductname)];
        
        % Storage Ring Water Flows
        SR01Girder = [SR01Girder arselect('SR01C___H2OFLW1AM00')];
        SR02Girder = [SR02Girder arselect('SR02C___H2OFLW1AM00')];
        SR03Girder = [SR03Girder arselect('SR03C___H2OFLW1AM00')];
        SR04Girder = [SR04Girder arselect('SR04C___H2OFLW1AM00')];
        SR05Girder = [SR05Girder arselect('SR05C___H2OFLW1AM00')];
        SR06Girder = [SR06Girder arselect('SR06C___H2OFLW1AM00')];
        SR07Girder = [SR07Girder arselect('SR07C___H2OFLW1AM00')];
        SR08Girder = [SR08Girder arselect('SR08C___H2OFLW1AM00')];
        SR09Girder = [SR09Girder arselect('SR09C___H2OFLW1AM00')];
        SR10Girder = [SR10Girder arselect('SR10C___H2OFLW1AM00')];
        SR11Girder = [SR11Girder arselect('SR11C___H2OFLW1AM00')];
        SR12Girder = [SR12Girder arselect('SR12C___H2OFLW1AM00')];
        
        SR01Rack = [SR01Rack arselect('SR01C___H2OFLW2AM00')];
        SR02Rack = [SR02Rack arselect('SR02C___H2OFLW2AM00')];
        SR03Rack = [SR03Rack arselect('SR03C___H2OFLW2AM00')];
        SR04Rack = [SR04Rack arselect('SR04C___H2OFLW2AM00')];
        SR05Rack = [SR05Rack arselect('SR05C___H2OFLW2AM00')];
        SR06Rack = [SR06Rack arselect('SR06C___H2OFLW2AM00')];
        SR07Rack = [SR07Rack arselect('SR07C___H2OFLW2AM00')];
        SR08Rack = [SR08Rack arselect('SR08C___H2OFLW2AM00')];
        SR09Rack = [SR09Rack arselect('SR09C___H2OFLW2AM00')];
        SR10Rack = [SR10Rack arselect('SR10C___H2OFLW2AM00')];
        SR11Rack = [SR11Rack arselect('SR11C___H2OFLW2AM00')];
        SR12Rack = [SR12Rack arselect('SR12C___H2OFLW2AM00')];
        
        SR04PST4 = [SR04PST4 arselect('SR04C___H2OFLW_AM02')];
        SR04PST5 = [SR04PST5 arselect('SR04C___H2OFLW_AM03')];
        SR04PST6 = [SR04PST6 arselect('SR04C___H2OFLW_AM00')];
        
        SR08PST4 = [SR08PST4 arselect('SR08C___H2OFLW_AM00')];
        SR08PST5 = [SR08PST5 arselect('SR08C___H2OFLW_AM01')];
        SR08PST6 = [SR08PST6 arselect('SR08C___H2OFLW_AM02')];
        
        SR12PST4 = [SR12PST4 arselect('SR12C___H2OFLW_AM00')];
        SR12PST5 = [SR12PST5 arselect('SR12C___H2OFLW_AM01')];
        SR12PST6 = [SR12PST6 arselect('SR12C___H2OFLW_AM02')];
    catch
        fprintf('  Error reading archived data file.\n');
        fprintf('  %s will be ignored.\n', FileName);
    end
    
end


% Month #2
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
        try
            arread(FileName, BooleanFlag);
            
            % time vector
            t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
            
            % Add Channels Here
            LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];
            
            lcw = [lcw arselect(SRRFlcwtmpname)];
            brlcw = [brlcw arselect('BR4_____LCWTMP_AM03')];
            CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
            CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve
            RingLCWSupPx = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
            RingLCWRetPx = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
            LCWSupPx = [LCWSupPx arselect(SPPname)]; %LCW supply pressure average in PSI
            LCWRetPx = [LCWRetPx arselect(RTPname)]; %LCW return pressure in PSIG
            LCWSupTemp = [LCWSupTemp arselect(SPTname)]; %LCW supply temperature average in deg. F
            LCWRetTemp = [LCWRetTemp arselect(RTTname)]; %LCW return temperature (3 entries)
            TRWSupTemp = [TRWSupTemp arselect(TRWSTname)]; %TRW supply temperature average in deg. F
            TRWRetTemp = [TRWRetTemp arselect(TRWRTname)]; %TRW return temperature
            WBasinTemp = [WBasinTemp arselect(WBasinname)]; %North Cooling tower supply (basin) temperature
            EBasinTemp = [EBasinTemp arselect(EBasinname)]; %South Cooling tower supply (basin) temperature
            
            Flow10inSup = [Flow10inSup arselect('B37_LCW_FLWS10_AM00')];
            Flow6inSup = [Flow6inSup arselect('B37_LCW_FLWS6__AM00')];
            Flow10inRet = [Flow10inRet arselect('B37_LCW_FLWR10_AM00')];
            Flow6inRet = [Flow6inRet arselect('B37_LCW_FLWR6__AM00')];
            AlCorrR = [AlCorrR arselect('B37_LCW_AL_COR_AM00')];
            CuCorrR =[CuCorrR arselect('B37_LCW_CU_COR_AM00')];
            ConductSup = [ConductSup arselect(ConductSupname)];
            ConductRet = [ConductRet arselect(ConductRetname)];
            O2Sup = [O2Sup arselect(O2Supname)];
            O2Ret = [O2Ret arselect(O2Retname)];
            pHSup = [pHSup arselect(pHSupname)];
            pHRet = [pHRet arselect(pHRetname)];
            EBottleValve = [EBottleValve arselect(EBottleValvename)];
            EBottleConduct = [EBottleConduct arselect(EBottleConductname)];
            WBottleValve = [WBottleValve arselect(WBottleValvename)];
            WBottleConduct = [WBottleConduct arselect(WBottleConductname)];
            
            % Storage Ring Water Flows
            SR01Girder = [SR01Girder arselect('SR01C___H2OFLW1AM00')];
            SR02Girder = [SR02Girder arselect('SR02C___H2OFLW1AM00')];
            SR03Girder = [SR03Girder arselect('SR03C___H2OFLW1AM00')];
            SR04Girder = [SR04Girder arselect('SR04C___H2OFLW1AM00')];
            SR05Girder = [SR05Girder arselect('SR05C___H2OFLW1AM00')];
            SR06Girder = [SR06Girder arselect('SR06C___H2OFLW1AM00')];
            SR07Girder = [SR07Girder arselect('SR07C___H2OFLW1AM00')];
            SR08Girder = [SR08Girder arselect('SR08C___H2OFLW1AM00')];
            SR09Girder = [SR09Girder arselect('SR09C___H2OFLW1AM00')];
            SR10Girder = [SR10Girder arselect('SR10C___H2OFLW1AM00')];
            SR11Girder = [SR11Girder arselect('SR11C___H2OFLW1AM00')];
            SR12Girder = [SR12Girder arselect('SR12C___H2OFLW1AM00')];
            
            SR01Rack = [SR01Rack arselect('SR01C___H2OFLW2AM00')];
            SR02Rack = [SR02Rack arselect('SR02C___H2OFLW2AM00')];
            SR03Rack = [SR03Rack arselect('SR03C___H2OFLW2AM00')];
            SR04Rack = [SR04Rack arselect('SR04C___H2OFLW2AM00')];
            SR05Rack = [SR05Rack arselect('SR05C___H2OFLW2AM00')];
            SR06Rack = [SR06Rack arselect('SR06C___H2OFLW2AM00')];
            SR07Rack = [SR07Rack arselect('SR07C___H2OFLW2AM00')];
            SR08Rack = [SR08Rack arselect('SR08C___H2OFLW2AM00')];
            SR09Rack = [SR09Rack arselect('SR09C___H2OFLW2AM00')];
            SR10Rack = [SR10Rack arselect('SR10C___H2OFLW2AM00')];
            SR11Rack = [SR11Rack arselect('SR11C___H2OFLW2AM00')];
            SR12Rack = [SR12Rack arselect('SR12C___H2OFLW2AM00')];
            
            SR04PST4 = [SR04PST4 arselect('SR04C___H2OFLW_AM02')];
            SR04PST5 = [SR04PST5 arselect('SR04C___H2OFLW_AM03')];
            SR04PST6 = [SR04PST6 arselect('SR04C___H2OFLW_AM00')];
            
            SR08PST4 = [SR08PST4 arselect('SR08C___H2OFLW_AM00')];
            SR08PST5 = [SR08PST5 arselect('SR08C___H2OFLW_AM01')];
            SR08PST6 = [SR08PST6 arselect('SR08C___H2OFLW_AM02')];
            
            SR12PST4 = [SR12PST4 arselect('SR12C___H2OFLW_AM00')];
            SR12PST5 = [SR12PST5 arselect('SR12C___H2OFLW_AM01')];
            SR12PST6 = [SR12PST6 arselect('SR12C___H2OFLW_AM02')];
        catch
            fprintf('  Error reading archived data file.\n');
            fprintf('  %s will be ignored.\n', FileName);
        end
        
    end
end

% Convert to celcius
LCWSupTemp = (LCWSupTemp-32)*5/9;
LCWRetTemp = (LCWRetTemp-32)*5/9;
TRWSupTemp = (TRWSupTemp-32)*5/9;
TRWRetTemp = (TRWRetTemp-32)*5/9;
WBasinTemp = (WBasinTemp-32)*5/9;
EBasinTemp = (EBasinTemp-32)*5/9;
CWTemp     = (CWTemp-32)*5/9;

% % ind=find(all(LCWparams<5));
% ind=[];
% LCWparams(:,ind)=NaN;
% lcw(:,ind) = NaN;
% CWTemp(:,ind) = NaN;
% CWValve(:,ind) = NaN;
% RingLCWSupPx(:,ind) = NaN;
% RingLCWRetPx(:,ind) = NaN;
% LCWSupPx(:,ind) = NaN;
% LCWRetPx(:,ind) = NaN;
% LCWSupTemp(:,ind) = NaN;
% LCWRetTemp(:,ind) = NaN;
% WBasinTemp(:,ind) = NaN;
% EBasinTemp(:,ind) = NaN;
%
% % ind=find(all(LCWparams(exchangerind,:)<5));
% % LCWparams(:,ind)=NaN;
% % lcw(:,ind) = NaN;
% % CWTemp(:,ind) = NaN;
% % CWValve(:,ind) = NaN;
% % RingLCWSupPx(:,ind) = NaN;
% % RingLCWRetPx(:,ind) = NaN;
% % LCWSupPx(:,ind) = NaN;
% % LCWRetPx(:,ind) = NaN;
% % LCWSupTemp(:,ind) = NaN;
% % LCWRetTemp(:,ind) = NaN;
% % WBasinTemp(:,ind) = NaN;
% % EBasinTemp(:,ind) = NaN;
%
% ind=find(all(LCWparams(exchangerind,:)<5));
% LCWparams(exchangerind,ind)=NaN;
%
% % ind=find(all(LCWparams(lcwind,:)<5));
% ind=[];
% LCWparams(:,ind)=NaN;
% % lcw(:,ind) = NaN;
%
% %%%%%%%% commented out 10-21-09 since one LCW pump is not reporting it's speed %%%%%%%%%%%%
% % [ind1,ind2]=find(LCWparams(waterpumpind,:)<5);
% % LCWparams(waterpumpind(ind1),ind2)=NaN;
% %%%%%%%% commented out 10-21-09 since one LCW pump is not reporting it's speed %%%%%%%%%%%%
%
% % Remove unrealistic data
% LCWSupPx(find(LCWSupPx<10)) = NaN;
% LCWRetPx(find(LCWRetPx<10)) = NaN;
% LCWSupTemp(find(LCWSupTemp<15)) = NaN;
% LCWRetTemp(find(LCWRetTemp<15)) = NaN;
% WBasinTemp(find(WBasinTemp<15)) = NaN;
% EBasinTemp(find(EBasinTemp<15)) = NaN;
%
% [ind1,ind2]=find(LCWparams(booleanind,:)>1.1);
% LCWparams(booleanind(ind1),ind2)=NaN;
%
% % ind=find(all(LCWparams(booleanind,:)==0));
% % LCWparams(booleanind,ind)=NaN;

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
MaxTime = max(t);
xmax = max(t);


%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LCW System Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure;
subfig(1,2,1,h);
clf reset

%h = subplot(2,1,1);
subplot(4,1,1)
plot(t, LCWparams(waterind,:));
xaxis([0 MaxTime]);
yaxis([-1 61]);
grid on;
title(['LCW Parameters: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Frequency [Hz]');
h=legend(ChanNames(waterind,2),'Location','Best');

subplot(4,1,2)
if ~isempty(flowind)
    [ax, h1, h2] =plotyy(t, LCWparams(fanind,:),t, LCWparams(flowind,:));
    set(get(ax(1),'Ylabel'), 'String', {'Fan Frequency [Hz]'});
    set(get(ax(2),'Ylabel'), 'String', {'Tower Flow [GPM]'}, 'Color', RightGraphColor);
    set(ax(2), 'YColor', RightGraphColor);
    set(h2, 'Color', RightGraphColor);
    grid on
    axes(ax(1));
    aa = axis;
    aa(1) = 0;
    aa(2) = MaxTime;
    axis(aa);
    yaxis([0 60]);
    set(ax(1),'YTick',[0:20:60]');
    axes(ax(2));
    aa = axis;
    aa(1) = 0;
    aa(2) = MaxTime;
    axis(aa);
    yaxis([0 9000]);
    set(ax(2),'YTick',[0:3000:9000]');
    if DayFlag
        MaxDay = round(max(t));
        set(ax(1),'XTick',[0:MaxDay]');
        set(ax(2),'XTick',[0:MaxDay]');
    end
    set(ax(1),'XTickLabel','');
    set(ax(2),'XTickLabel','');
else
    plot(t, LCWparams(fanind,:));
    xaxis([0 MaxTime]);
    yaxis([-1 61]);
    grid on;
    ChangeAxesLabel(t, Days, DayFlag);
    ylabel('Frequency [Hz]');
    h=legend(ChanNames(fanind,2),'Location','Best');
end

subplot(4,1,3)
if ~isempty(valveind)
    plot(t, LCWparams(valveind,:));
else
    plot(t, 100*ones(size(t)));
end
xaxis([0 MaxTime]);
% yaxis([-1 101]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Valve setting');
h=legend(ChanNames(valveind,2),'Location','Best');

subplot(4,1,4)
plot(t,LCWparams(booleanind,:)+(ones(length(LCWparams),1)*[0:0.01:0.01*(length(booleanind)-1)])');
axis([0 MaxTime -0.1 1.1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('On/Off');
h=legend(ChanNames(booleanind,2),'Location','Best');
orient tall

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

%set(h,'interpreter','none');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hill and water temperatures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure;
subfig(1,2,2,h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(5,1,1);
[ax, h1, h2] = plotyy(t,RingLCWSupPx, t,RingLCWRetPx);
set(get(ax(1),'Ylabel'), 'String', {'Ring LCW [PSI]',' ','Px_{supply}'});
set(get(ax(2),'Ylabel'), 'String', {'Ring LCW [PSI]',' ','Px_{return}'}, 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
%axisvals = axis;
%yaxis([axisvals(3)-.5 axisvals(4)+.5]);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

title(['Cooling Water Parameters: ',titleStr]);


subplot(5,1,2);
[ax, h1, h2] = plotyy(t,LCWSupPx, t,LCWRetPx);
set(get(ax(1),'Ylabel'), 'String', {'Tower [PSI]',' ','Px_{supply}'});
set(get(ax(2),'Ylabel'), 'String', {'Tower [PSI]',' ','Px_{return}'}, 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
yaxis([130 140]);
set(ax(1),'YTick',[130:2:140]');
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
yaxis([13 18]);
set(ax(2),'YTick',[13:18]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
if size(WBasinTemp,1)<3
    [ax, h1, h2] = plotyy(t,WBasinTemp, t,EBasinTemp);
    set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}W.Basin (TRW) \fontsize{10}[C]');
    set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}E.Basin (LCW) \fontsize{10}[C]', 'Color', RightGraphColor);
    set(ax(2), 'YColor', RightGraphColor);
    set(h2, 'Color', RightGraphColor);
else
    [ax, h1, h2] = plotyy(t,WBasinTemp, t,EBasinTemp);
    set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}Basin Supply Temperatures \fontsize{10}[C]');
    set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}Basin Return Temperatures \fontsize{10}[C]');
end
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
yaxis([15 24]);
set(ax(1),'YTick',[15:24]');
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
yaxis([15 24]);
set(ax(2),'YTick',[15:24]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
if size(WBasinTemp,1)>=3
    legend([h1;h2],'Common','East','West','Common','East','West','Location','Best')
end

subplot(5,1,4);
if size(LCWSupTemp,1)>1
    LCWSupTemp=mean(LCWSupTemp);
end
if size(LCWRetTemp,1)>1
    LCWRetTemp=mean(LCWRetTemp);
end
[ax, h1, h2] = plotyy(t, LCWSupTemp, t, LCWRetTemp);
set(get(ax(1),'Ylabel'), 'String', 'T_{supply} [C]', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'T_{return} [C]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
aa(3) = 21;
aa(4) = 24;
axis(aa);
set(ax(1),'YTick',[21:0.5:24]');
hold on;
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
aa(3) = 21;
aa(4) = 27;
axis(aa);
set(ax(2),'YTick',[21:1:27]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
hold on;
h3 = plot(ax(1), t, TRWSupTemp);
h4 = plot(ax(2), t, TRWRetTemp);
% set(ax2(1), 'YColor', LeftGraphColor);
set(h3, 'Color', 'c');
% set(ax2(2), 'YColor', RightGraphColor);
set(h4, 'Color', 'm');
legend([h1 h2 h3 h4],'LCW Sup','LCW Ret','TRW Sup','TRW Ret','Location','Best');
% axes(ax2(1));
% aa = axis;
% aa(1) = 0;
% aa(2) = MaxTime;
% aa(3) = 21;
% aa(2) = 24;
% axis(aa);
% set(ax2(1),'YTick',[21:24]');
% axes(ax2(2));
% aa = axis;
% aa(1) = 0;
% aa(2) = MaxTime;
% aa(1) = 21;
% aa(2) = 27;
% axis(aa);
% set(ax2(2),'YTick',[21:27]');
% if DayFlag
%     MaxDay = round(max(t));
%     set(ax2(1),'XTick',[0:MaxDay]');
%     set(ax2(2),'XTick',[0:MaxDay]');
% end
% set(ax2(1),'XTickLabel','');
% set(ax2(2),'XTickLabel','');

subplot(5,1,5);
plot(t, lcw, 'b', t, brlcw, 'r'); grid on;
ylabel({'LCW [C]','(SR03/BR4 Sensor)'}, 'Color', LeftGraphColor);
legend('LCW @ SR RF','LCW @ BR RF','Location','Best');
set(gca,'YColor', LeftGraphColor);
xaxis([0 MaxTime]);
yaxis([22 25]);
set(gca,'YTick',[22:25]');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(2, 'ArchiveDate', DirectoryDate);

orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Water Flows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = figure;
subfig(1,2,2,h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1)
plot(t, SR01Girder, 'b', t, SR02Girder, 'g', t, SR03Girder, 'r', t, SR04Girder, 'c', t, SR05Girder, 'm', t, SR06Girder, 'y', t, SR07Girder, 'k', t, SR08Girder, 'b--', t, SR09Girder, 'g--', t, SR10Girder, 'r--', t, SR11Girder, 'c--', t, SR12Girder, 'm--');
grid on;
ylabel('Girder Flows [GPM]');
axis tight;
axisvals = axis;
xaxis([0 MaxTime]);
yaxis([50 105]);
%yaxis([axisvals(3)-0.5 axisvals(4)+0.5]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('SR01','SR02','SR03','SR04','SR05','SR06','SR07','SR08','SR09','SR10','SR11','SR12','Location','Best');
title(['Storage Ring Water Flows: ', titleStr]);

subplot(4,1,2);
plot(t, SR01Rack, t, SR02Rack, t, SR03Rack, t, SR04Rack, t, SR05Rack, t, SR06Rack, t, SR07Rack, t, SR08Rack, t, SR09Rack, t, SR10Rack, t, SR11Rack, t, SR12Rack);
grid on;
ylabel('Rack Flows [GPM]');
axis tight
axisvals = axis;
xaxis([0 MaxTime]);
yaxis([20 30]);
%yaxis([axisvals(3)-0.5 axisvals(4)+0.5]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('SR01','SR02','SR03','SR04','SR05','SR06','SR07','SR08','SR09','SR10','SR11','SR12','Location','Best');

subplot(4,1,3)
plot(t, SR04PST4, t, SR04PST5, t, SR04PST6, t, SR08PST4, t, SR08PST5, t, SR08PST6, t, SR12PST4, t, SR12PST5, t, SR12PST6);
grid on;
ylabel('PST Flows [GPM]');
legend('SR04PST4','SR04PST5','SR04PST6','SR08PST4','SR08PST5','SR08PST6','SR12PST4','SR12PST5','SR12PST6','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 MaxTime]);
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');

subplot(4,1,4)
plot(t, Flow10inSup, t, Flow10inRet, t, Flow6inSup, t, Flow6inRet);
grid on;
ylabel('B37 Flows [GPM]');
legend('10inch Supply','10inch Return','6inch Supply','6inch Return','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 MaxTime]);
yaxis([axisvals(3)-100 axisvals(4)+100]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(2, 'ArchiveDate', DirectoryDate);
orient tall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Water Chemistry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = figure;
subfig(1,2,2, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1)
plot(t, AlCorrR, t, CuCorrR);
grid on;
ylabel('Corrosion Rates [MPY]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([0 0.25]);
% if DayFlag
%     MaxDay = round(max(t));
%     set(gca,'XTick',[0:MaxDay]');
% end
set(gca,'XTickLabel','');
legend('Aluminum','Copper','Location','Best');
title(['Water Chemistry: ', titleStr]);

% The control system channels are resistivities, not conductivity - so to
% convert to same units as other conductivities, take the inverse.

EBottleConduct=(EBottleConduct).^(-1); WBottleConduct=(WBottleConduct).^(-1);

subplot(4,1,2);
[ax, h1, h2] = plotyy(t, [ConductSup; ConductRet; EBottleConduct; WBottleConduct], t, [EBottleValve; WBottleValve]);
set(get(ax(1),'Ylabel'), 'String', 'Conductivity Parameters', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Valve settings [%]', 'Color', 'Black');
set(ax(1), 'YColor', LeftGraphColor);
set(ax(2), 'YColor', 'Black');
set(h2, 'Color', 'Black');
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 2.5;
axis(aa);
set(ax(1),'YTick',[0:0.5:2.5]');
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 100;
axis(aa);
set(ax(2),'YTick',[0:20:100]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
if datenum(year1, month, days(1)) < 735466
    legend('Supply [MOhm/cm]','Return [MOhm/cm]','Location','Best'); % in old Barrington system both channels were resistivity
elseif datenum(year1, month, days(1)) < 735488 % sensor was recalibrated from MOhm/cm to microS/cm on 2013-09-11
    legend('Supply [\muS/cm]','Return [MOhm/cm]','Location','Best');
else
    legend(h1,'Supply [\muS/cm]','Return [\muS/cm]','E.Bottle Conductivity [\muS/cm]','W.Bottle Conductivity [\muS/cm]','Location','Best');
end

subplot(4,1,3)
plot(t, O2Sup, t, O2Ret);
grid on;
ylabel('Oxygen Content [PPM]');
legend('Supply','Return','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([0 25]);
% if DayFlag
%     MaxDay = round(max(t));
%     set(gca,'XTick',[0:MaxDay]');
% end
set(gca,'XTickLabel','');

subplot(4,1,4)
plot(t, pHSup, t, pHRet);
grid on;
ylabel('pH level');
legend('Supply','Return','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([5 9]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(h, 'ArchiveDate', DirectoryDate);
orient tall

%figure(h-2);
%figure(h-1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display trip point headroom for girders and racks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ispc
    
    SR01girder_trip_point = getpv('SR01C___GRDRSPTAM00');
    SR02girder_trip_point = getpv('SR02C___GRDRSPTAM00');
    SR03girder_trip_point = getpv('SR03C___GRDRSPTAM00');
    SR04girder_trip_point = getpv('SR04C___GRDRSPTAM00');
    SR05girder_trip_point = getpv('SR05C___GRDRSPTAM00');
    SR06girder_trip_point = getpv('SR06C___GRDRSPTAM00');
    SR07girder_trip_point = getpv('SR07C___GRDRSPTAM00');
    SR08girder_trip_point = getpv('SR08C___GRDRSPTAM00');
    SR09girder_trip_point = getpv('SR09C___GRDRSPTAM00');
    SR10girder_trip_point = getpv('SR10C___GRDRSPTAM00');
    SR11girder_trip_point = getpv('SR11C___GRDRSPTAM00');
    SR12girder_trip_point = getpv('SR12C___GRDRSPTAM00');
    
    SR01rack_trip_point = getpv('SR01C___RACKSPTAM01');
    SR02rack_trip_point = getpv('SR02C___RACKSPTAM01');
    SR03rack_trip_point = getpv('SR03C___RACKSPTAM01');
    SR04rack_trip_point = getpv('SR04C___RACKSPTAM01');
    SR05rack_trip_point = getpv('SR05C___RACKSPTAM01');
    SR06rack_trip_point = getpv('SR06C___RACKSPTAM01');
    SR07rack_trip_point = getpv('SR07C___RACKSPTAM01');
    SR08rack_trip_point = getpv('SR08C___RACKSPTAM01');
    SR09rack_trip_point = getpv('SR09C___RACKSPTAM01');
    SR10rack_trip_point = getpv('SR10C___RACKSPTAM01');
    SR11rack_trip_point = getpv('SR11C___RACKSPTAM01');
    SR12rack_trip_point = getpv('SR12C___RACKSPTAM01');
    
    fprintf('\n');
    fprintf('"Mean" is the average for the days plotted! Be careful with the data if flows are not stable,\n');
    fprintf('Mean SR01 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR01Girder), SR01girder_trip_point, mean(SR01Girder)-SR01girder_trip_point);
    fprintf('Mean SR02 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR02Girder), SR02girder_trip_point, mean(SR02Girder)-SR02girder_trip_point);
    fprintf('Mean SR03 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR03Girder), SR03girder_trip_point, mean(SR03Girder)-SR03girder_trip_point);
    fprintf('Mean SR04 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR04Girder), SR04girder_trip_point, mean(SR04Girder)-SR04girder_trip_point);
    fprintf('Mean SR05 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR05Girder), SR05girder_trip_point, mean(SR05Girder)-SR05girder_trip_point);
    fprintf('Mean SR06 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR06Girder), SR06girder_trip_point, mean(SR06Girder)-SR06girder_trip_point);
    fprintf('Mean SR07 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR07Girder), SR07girder_trip_point, mean(SR07Girder)-SR07girder_trip_point);
    fprintf('Mean SR08 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR08Girder), SR08girder_trip_point, mean(SR08Girder)-SR08girder_trip_point);
    fprintf('Mean SR09 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR09Girder), SR09girder_trip_point, mean(SR09Girder)-SR09girder_trip_point);
    fprintf('Mean SR10 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR10Girder), SR10girder_trip_point, mean(SR10Girder)-SR10girder_trip_point);
    fprintf('Mean SR11 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR11Girder), SR11girder_trip_point, mean(SR11Girder)-SR11girder_trip_point);
    fprintf('Mean SR12 girder flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR12Girder), SR12girder_trip_point, mean(SR12Girder)-SR12girder_trip_point);
    fprintf('\n');
    fprintf('Mean SR01 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR01Rack), SR01rack_trip_point, mean(SR01Rack)-SR01rack_trip_point);
    fprintf('Mean SR02 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR02Rack), SR02rack_trip_point, mean(SR02Rack)-SR02rack_trip_point);
    fprintf('Mean SR03 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR03Rack), SR03rack_trip_point, mean(SR03Rack)-SR03rack_trip_point);
    fprintf('Mean SR04 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR04Rack), SR04rack_trip_point, mean(SR04Rack)-SR04rack_trip_point);
    fprintf('Mean SR05 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR05Rack), SR05rack_trip_point, mean(SR05Rack)-SR05rack_trip_point);
    fprintf('Mean SR06 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR06Rack), SR06rack_trip_point, mean(SR06Rack)-SR06rack_trip_point);
    fprintf('Mean SR07 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR07Rack), SR07rack_trip_point, mean(SR07Rack)-SR07rack_trip_point);
    fprintf('Mean SR08 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR08Rack), SR08rack_trip_point, mean(SR08Rack)-SR08rack_trip_point);
    fprintf('Mean SR09 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR09Rack), SR09rack_trip_point, mean(SR09Rack)-SR09rack_trip_point);
    fprintf('Mean SR10 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR10Rack), SR10rack_trip_point, mean(SR10Rack)-SR10rack_trip_point);
    fprintf('Mean SR11 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR11Rack), SR11rack_trip_point, mean(SR11Rack)-SR11rack_trip_point);
    fprintf('Mean SR12 rack flow [GPM] = %.1f; Current trip pt. = %.1f; Headroom = %.1f\n', mean(SR12Rack), SR12rack_trip_point, mean(SR12Rack)-SR12rack_trip_point);
end


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
        set(gca,'XTickLabel',XTickLabelString(1:2:end-1,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:end-1,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end-1,:));
    end
end
