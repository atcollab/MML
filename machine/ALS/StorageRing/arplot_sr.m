function arplot_sr(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_SR - Plots various performance data from the ALS archiver
%  arplot_sr(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  Plots a whole bunch of storage ring related archived data.
%  Only plots data when feed forward is on.
%
%  EXAMPLES
%  1. arplot_sr('January',22:24,1998);
%     plots data from 1/22, 1/23, and 1/24 in 1998
%
%  2. arplot_sr('January',28:31,1998,'February',1:4,1998);
%     plots data from the last 4 days in Jan. and the first 4 days in Feb.
%
%  See also arplot, arplot_sr_report, arplot_sbm

% Written by Greg Portmann & Tom Scarvie
%
% Modified
% 2001, C. Steier
% 2002, T. Scarvie
%
% 2002-05-08, T.Scarvie
% 		modified to plot SR09S_IBPM1X/Y_RMS instead of SR09C_IBPM5X/Y_RMS
% 		we no longer measure IDBPM(9,5) RMS data due to change in IDBPM(9,5) electronics
% 		for now, IDBPM(9,1) and (9,2) RMS's are the ones measured
%
% 2004-06-14, T.Scarvie
%       added all new curved section BPMs to plots
%
% 2005-07-01, G.Portmann
%       small changes to a lot of graphs
%
% 2007-02-15, T.Scarvie
%       added new BR RF plots at request of K.Baptiste
%
% 2016-06-29, C. Steier
%       added plots for new BPMs in LTB + BTS transfer lines


LeftGraphColor = 'b';
RightGraphColor = 'r';
FFFlag = 0;
GapOpenFlag = 0;
UserBeamFlag = 1;
BergozFlag = 0;

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

if BergozFlag
    BPMlist = getbpmlist('bergoz');
else
    BPMlist = getbpmlist;
end

GapEnableNames = family2channel('ID','GapEnable');
BPMxNames = family2channel('BPMx',BPMlist);
BPMyNames = family2channel('BPMy',BPMlist);
BPMxPos = getspos('BPMx',BPMlist);
BPMyPos = getspos('BPMy',BPMlist);
BPMxGolden = getgolden('BPMx',BPMlist);
BPMyGolden = getgolden('BPMy',BPMlist);

BTSBPMxNames = ['BTS:BPM1:SA:X';'BTS:BPM2:SA:X';'BTS:BPM3:SA:X'; ...
    'BTS:BPM4:SA:X';'BTS:BPM5:SA:X';'BTS:BPM6:SA:X'];
BTSBPMyNames = ['BTS:BPM1:SA:Y';'BTS:BPM2:SA:Y';'BTS:BPM3:SA:Y'; ...
    'BTS:BPM4:SA:Y';'BTS:BPM5:SA:Y';'BTS:BPM6:SA:Y'];
BTSBPMsumNames = ['BTS:BPM1:SA:Q';'BTS:BPM2:SA:Q';'BTS:BPM3:SA:Q'; ...
    'BTS:BPM4:SA:Q';'BTS:BPM5:SA:Q';'BTS:BPM6:SA:Q'];

LinacBPMxNames = ['GTL:BPM1:SA:X';'GTL:BPM2:SA:X';'LN:BPM1:SA:X '; ...
    'LN:BPM2:SA:X ';'LTB:BPM1:SA:X';'LTB:BPM2:SA:X';'LTB:BPM4:SA:X'; ...
    'LTB:BPM5:SA:X';'LTB:BPM6:SA:X';'LTB:BPM7:SA:X'];
LinacBPMyNames = ['GTL:BPM1:SA:Y';'GTL:BPM2:SA:Y';'LN:BPM1:SA:Y '; ...
    'LN:BPM2:SA:Y ';'LTB:BPM1:SA:Y';'LTB:BPM2:SA:Y';'LTB:BPM4:SA:Y'; ...
    'LTB:BPM5:SA:Y';'LTB:BPM6:SA:Y';'LTB:BPM7:SA:Y'];
LinacBPMsumNames = ['GTL:BPM1:SA:Q';'GTL:BPM2:SA:Q';'LN:BPM1:SA:Q '; ...
    'LN:BPM2:SA:Q ';'LTB:BPM1:SA:Q';'LTB:BPM2:SA:Q';'LTB:BPM4:SA:Q'; ...
    'LTB:BPM5:SA:Q';'LTB:BPM6:SA:Q';'LTB:BPM7:SA:Q'];


ar_functions_time = 0;

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


% New AA archiver
try
    d1 = datenum([year1 month days(1) 0 0 0]);
    if isempty(days2)
        d2 = datenum([year1 month  days(end)  23 59 59]);
    else
        d2 = datenum([year2 month2 days2(end) 23 59 59]);
    end
    % Convert to UTC time
    if isdaylightsavings(d1)
        d1 = d1 + 7/24;
    else
        d1 = d1 + 8/24;
    end
    % Convert to UTC time
    if isdaylightsavings(d2)
        d2 = d2 + 7/24;
    else
        d2 = d2 + 8/24;
    end
    
    d1 = datestr(datenum(d1),   'yyyy-mm-ddTHH:MM:SS.FFFZ');
    d2 = datestr(datenum(d2),   'yyyy-mm-ddTHH:MM:SS.FFFZ');
    
    AAobj = ArchAppliance;
catch
    disp('Error getting AA archiver data');
end


t = [];

% setup LCW channel names
LCWparams = [];
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

BTSBPMx = [];
BTSBPMy = [];
BTSBPMsum = [];

LinacBPMx = [];
LinacBPMy = [];
LinacBPMsum = [];

if datenum(year1, month, days(1)) < 735813
    CATHVname='SR04S___CATHVT_AM01';
    HVPSIname='SR04S___HVPSI__AC00';
    MAVOLTname='SR04S___MAVOLT_AM01';
    MACURRname='SR04S___MACURR_AM02';
    HTRVLTname='SR04S___HTRVLT_AM03';
    HTRCURname='SR04S___HTRCUR_AM00';
    HVPSVname='SR03S___HVPSV__AM00';
    IP1name='SR04S___IP1CUR_AM02';
    IP2name='SR04S___IP2CUR_AM00';
else
    CATHVname='Kly2:MaIO:rCathVolt';
    HVPSIname='Master:Env:rKly2Curr';
    MAVOLTname='Kly2:MaIO:rMaVolt';
    MACURRname='Kly2:MaIO:rMaCurr';
    HTRVLTname='Kly2:HtrIO:rVoltVal';
    HTRCURname='Kly2:HtrIO:rCurrVal';
    HVPSVname='Master:Global:rHV';
    IP1name='Kly2:IP:rCurr1';
    IP2name='Kly2:IP:rCurr2';
end

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
    
else
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
    
    % SPPname='B37_LCW_SPPAVG_AM00'; %LCW supply pressure average in PSI
    % RTPname='B37_LCW_RTPAVG_AM00'; %LCW return pressure in PSIG
    SPPname='B37_LCW_SPP1___AM00'; %LCW supply pressure average in PSI
    RTPname='B37_LCW_RTP1___AM00'; %LCW return pressure in PSIG
    SPTname='B37_LCW_SPT'; %LCW supply temperature average in deg. F
    RTTname='B37_LCW_RTT'; %LCW return temperature (3 entries)
    WBasinname='B37_CW__ST_W___AM00'; %North Cooling tower supply (basin) temperature
    EBasinname='B37_CW__ST_E___AM00'; %South Cooling tower supply (basin) temperature
    % TRWSTname='B37_TRW_SPTAVG_AM00';
    % TRWRTname='B37_TRW_RTTAVG_AM00';
    TRWSTname='B37_TRW_SPT1___AM00';
    TRWRTname='B37_TRW_RTT1___AM00';
    
    ConductSupname = 'B37_LCW_SYSSCD_AM00:filter';
    ConductRetname = 'B37_LCW_SYSRCD_AM00:filter';
    O2Supname = 'B37_LCW_SPOXY__AM00';
    O2Retname = 'B37_LCW_RTOXY__AM00';
    pHSupname = 'B37_LCW_SPPH___AM00';
    pHRetname = 'B37_LCW_RTPH___AM00';
    
    EBottleValvename = 'B37_LCW_VECOND_AM00';
    EBottleConductname = 'B37_LCW_EBTLCODAM00';
    WBottleValvename = 'B37_LCW_VWCOND_AM00';
    WBottleConductname = 'B37_LCW_WBTLCODAM00';
    
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

waterind = 1:length(ChanNames);
waterind([booleanind fanind valveind])=[];

tic;


% Get data from archiver

% Month 1
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    arread(FileName, 1);
    
    ar_functions_time = ar_functions_time + toc;
    tic;
    if day==days(1)
        %[dcct, idcct] = arselect('SR05S___DCCTLP_AM01');
        [dcct, idcct] = arselect('cmm:beam_current');
        %[i_cam, ii_cam] = arselect('cmm:cam_current');
        %if all(i_cam==0)
        [i_cam1, ii_cam1] = arselect('Cam1_current');
        [i_cam2, ii_cam2] = arselect('Cam2_current');
        i_cam=i_cam1+i_cam2;
        %end
        [inj_eff, iinj_eff] = arselect('BTS_To_SR_Injection_Efficiency');
        [inj_rate, iinj_rate] = arselect('BTS_To_SR_Injection_Rate');
        [gev, igev] = arselect('cmm:sr_energy');
        [lifetime, ilifetime] = arselect('SR05W___DCCT2__AM00');
        [lifetime2, ilifetime2] = arselect('Topoff_lifetime_AM');
        if all(isnan(lifetime2)) | all(lifetime2==0)
            [dummy, idummy] =  arselect('Physics1'); %arselect('Physics1') also returns 'Physics10' due to the built-in wildcard feature!
            [lifetime3, ilifetime3] = arselect('Physics2');
            if size(dummy,1) == 2
                lifetime2 = dummy(1,:); ilifetime2 = idummy(1,:);
            else
                lifetime2 = dummy; ilifetime2 = idummy;
            end
        else
            [lifetime3, ilifetime3] = arselect('Topoff_cam_lifetime_AM');
        end
        
        BTSBPMx = arselect(BTSBPMxNames);
        BTSBPMy = arselect(BTSBPMyNames);
        BTSBPMsum = arselect(BTSBPMsumNames);
        
        LinacBPMx = arselect(LinacBPMxNames);
        LinacBPMy = arselect(LinacBPMyNames);
        LinacBPMsum = arselect(LinacBPMsumNames);
        
        EPUChan = family2channel('EPU','Monitor');
        if str2num(FileName) < 20050223 % this is the date that EPU(11,2) was renamed
            [tmp, i] = ismember('SR11U___ODS2PS_AM00', EPUChan, 'rows');
            EPUChan(i,:) = []; % remove it because it probably already in the list 'SR11U___ODS1PS_AM00';
        end
        [EPU, iEPU, iNotFound] = arselect(EPUChan);
        EPU(iNotFound,:) = [];
        EPULegend = mat2cell(ARChanNames(iEPU,3:4), ones(length(iEPU),1), 2);
        EPULegend = strcat(EPULegend,'EPU');
        EPULegend = strcat(EPULegend,ARChanNames(iEPU,12));
        
        % ID vertical gap
        IDlist = family2dev('ID');
        [IDgap, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        IDgap(iNotFound,:) = [];
        IDlist(iNotFound,:) = [];
        IDLegend = mat2cell(ARChanNames(iIDgap,3:5),ones(length(iIDgap),1),3);
        IDLegend = strcat(IDLegend,ARChanNames(iIDgap,12));
        
        if FFFlag
            [GapEnable, iGapEnable] = arselect(GapEnableNames);
            [FF8Enable, iFF8Enable] = arselect('sr08u:FFEnable:bi');
        end
        
        %         [TC7_1, iTC7_1] = arselect('SR07U___IDTC1__AM');
        %         [TC7_2, iTC7_2] = arselect('SR07U___IDTC2__AM');
        %         [TC7_3, iTC7_3] = arselect('SR07U___IDTC3__AM');
        %         [TC7_4, iTC7_4] = arselect('SR07U___IDTC4__AM');
        
        [TC8_1, iTC8_1] = arselect('SR08U___IDTC1__AM');
        [TC8_2, iTC8_2] = arselect('SR08U___IDTC2__AM');
        [TC8_3, iTC8_3] = arselect('SR08U___IDTC3__AM');
        [TC8_4, iTC8_4] = arselect('SR08U___IDTC4__AM');
        
        [TC9_1, iTC9_1] = arselect('SR09U___IDTC1__AM');
        [TC9_2, iTC9_2] = arselect('SR09U___IDTC2__AM');
        [TC9_3, iTC9_3] = arselect('SR09U___IDTC3__AM');
        [TC9_4, iTC9_4] = arselect('SR09U___IDTC4__AM');
        
        [TC10_1, iTC10_1] = arselect('SR10U___IDTC1__AM');
        [TC10_2, iTC10_2] = arselect('SR10U___IDTC2__AM');
        [TC10_3, iTC10_3] = arselect('SR10U___IDTC3__AM');
        [TC10_4, iTC10_4] = arselect('SR10U___IDTC4__AM');
        
        [TC12_1, iTC12_1] = arselect('SR12U___IDTC1__AM');
        [TC12_2, iTC12_2] = arselect('SR12U___IDTC2__AM');
        [TC12_3, iTC12_3] = arselect('SR12U___IDTC3__AM');
        [TC12_4, iTC12_4] = arselect('SR12U___IDTC4__AM');
        
        [TCSR01, iTCSR01] = arselect('SR01C___T______AM');
        [TCSR02, iTCSR02] = arselect('SR02C___T______AM');
        [TCSR03, iTCSR03] = arselect('SR03C___T______AM');
        [TCSR04, iTCSR04] = arselect('SR04C___T______AM');
        [TCSR05, iTCSR05] = arselect('SR05C___T______AM');
        [TCSR06, iTCSR06] = arselect('SR06C___T______AM');
        [TCSR07, iTCSR07] = arselect('SR07C___T______AM');
        [TCSR08, iTCSR08] = arselect('SR08C___T______AM');
        [TCSR09, iTCSR09] = arselect('SR09C___T______AM');
        [TCSR11, iTCSR11] = arselect('SR11C___T______AM');
        [TCSR12, iTCSR12] = arselect('SR12C___T______AM');
        [TCSRAVG, iTCSRAVG] = arselect('SR01C___T_AVG__AM');
        
        [AHUT01, iAHUT01] = arselect('SR01C___AHUT___AM');
        [AHUT03, iAHUT03] = arselect('SR03C___AHUT___AM');
        [AHUT04, iAHUT04] = arselect('SR04C___AHUT___AM');
        [AHUT06, iAHUT06] = arselect('SR06C___AHUT___AM');
        [AHUT07, iAHUT07] = arselect('SR07C___AHUT___AM');
        [AHUT08, iAHUT08] = arselect('SR08C___AHUT___AM');
        [AHUT09, iAHUT09] = arselect('SR09C___AHUT___AM');
        [AHUT11, iAHUT11] = arselect('SR11C___AHUT___AM');
        
        [WVSRM, iWVSRM] = arselect('SR01C___AHWVM__AM00');
        
        % Add Channels Here (and below)
        LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];
        
        lcwtmp = arselect('SR03S___LCWTMP_AM99');
        if isnan(lcwtmp) 
            lcwtmp = arselect('SR03S___LCWTMP_AM00');
        end
        lcw = [lcw lcwtmp];
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
        [SR01Girder, iSR01Girder] = arselect('SR01C___H2OFLW1AM00');
        [SR02Girder, iSR02Girder] = arselect('SR02C___H2OFLW1AM00');
        [SR03Girder, iSR03Girder] = arselect('SR03C___H2OFLW1AM00');
        [SR04Girder, iSR04Girder] = arselect('SR04C___H2OFLW1AM00');
        [SR05Girder, iSR05Girder] = arselect('SR05C___H2OFLW1AM00');
        [SR06Girder, iSR06Girder] = arselect('SR06C___H2OFLW1AM00');
        [SR07Girder, iSR07Girder] = arselect('SR07C___H2OFLW1AM00');
        [SR08Girder, iSR08Girder] = arselect('SR08C___H2OFLW1AM00');
        [SR09Girder, iSR09Girder] = arselect('SR09C___H2OFLW1AM00');
        [SR10Girder, iSR10Girder] = arselect('SR10C___H2OFLW1AM00');
        [SR11Girder, iSR11Girder] = arselect('SR11C___H2OFLW1AM00');
        [SR12Girder, iSR12Girder] = arselect('SR12C___H2OFLW1AM00');
        
        [SR01Rack, iSR01Rack] = arselect('SR01C___H2OFLW2AM00');
        [SR02Rack, iSR02Rack] = arselect('SR02C___H2OFLW2AM00');
        [SR03Rack, iSR03Rack] = arselect('SR03C___H2OFLW2AM00');
        [SR04Rack, iSR04Rack] = arselect('SR04C___H2OFLW2AM00');
        [SR05Rack, iSR05Rack] = arselect('SR05C___H2OFLW2AM00');
        [SR06Rack, iSR06Rack] = arselect('SR06C___H2OFLW2AM00');
        [SR07Rack, iSR07Rack] = arselect('SR07C___H2OFLW2AM00');
        [SR08Rack, iSR08Rack] = arselect('SR08C___H2OFLW2AM00');
        [SR09Rack, iSR09Rack] = arselect('SR09C___H2OFLW2AM00');
        [SR10Rack, iSR10Rack] = arselect('SR10C___H2OFLW2AM00');
        [SR11Rack, iSR11Rack] = arselect('SR11C___H2OFLW2AM00');
        [SR12Rack, iSR12Rack] = arselect('SR12C___H2OFLW2AM00');
        
        [SR04PST4, iSR04PST4] = arselect('SR04C___H2OFLW_AM02');
        [SR04PST5, iSR04PST5] = arselect('SR04C___H2OFLW_AM03');
        [SR04PST6, iSR04PST6] = arselect('SR04C___H2OFLW_AM00');
        
        [SR08PST4, iSR08PST4] = arselect('SR08C___H2OFLW_AM00');
        [SR08PST5, iSR08PST5] = arselect('SR08C___H2OFLW_AM01');
        [SR08PST6, iSR08PST6] = arselect('SR08C___H2OFLW_AM02');
        
        [SR12PST4, iSR12PST4] = arselect('SR12C___H2OFLW_AM00');
        [SR12PST5, iSR12PST5] = arselect('SR12C___H2OFLW_AM01');
        [SR12PST6, iSR12PST6] = arselect('SR12C___H2OFLW_AM02');
        
        % All Bergoz BPMs
        [BPMx, iBPMx] = arselect(BPMxNames);
        [BPMy, iBPMy] = arselect(BPMyNames);
        
        % actual BPMs that are written to these PVs are determined by bpm_psd_plot.m (line 30)
        [ID9BPM1xRMS, iID9BPM1xRMS] = arselect('SR09S_IBPM1X_RMS');
        [ID9BPM1yRMS, iID9BPM1yRMS] = arselect('SR09S_IBPM1Y_RMS');
        [ID9BPM2xRMS, iID9BPM2xRMS] = arselect('SR09S_IBPM2X_RMS');
        [ID9BPM2yRMS, iID9BPM2yRMS] = arselect('SR09S_IBPM2Y_RMS');
        
        [C1TEMP, iC1TEMP] = arselect('SR03S___C1TEMP_AM');
        [C2TEMP, iC2TEMP] = arselect('SR03S___C2TEMP_AM');
        
        [C1LCW, iC1LCW] = arselect('SR03S___C1LCWF_AM');
        [C2LCW, iC2LCW] = arselect('SR03S___C2LCWF_AM');
        
        %         [SigX, iSigX] = arselect('SR04S___SPIRICOAM07');
        %         [SigY, iSigY] = arselect('SR04S___SPIRICOAM08');
        
        [SigX31, iSigX31] = arselect('beamline31:XRMSAve',1);
        [SigY31, iSigY31] = arselect('beamline31:YRMSAve',1);
        if isempty(SigX31)
            SigX31 = NaN * ones(1,length(ARt));
        end
        if isempty(SigY31)
            SigY31 = NaN * ones(1,length(ARt));
        end
        
        [SigX72, iSigX72] = arselect('bl72:XRMSAve',0); %for some reason XRMS returns the *Error PV first
        [SigY72, iSigY72] = arselect('bl72:YRMSAve',1);
        SigX72 = SigX72(1,:); %for some reason XRMS returns the *Error PV first
        if isempty(SigX72)
            SigX72 = NaN * ones(1,length(ARt));
        end
        if isempty(SigY72)
            SigY72 = NaN * ones(1,length(ARt));
        end
        
        %         [SpiroX, iSpiroX] = arselect('SR04S___SPIRICOAM01');
        %         [SpiroY, iSpiroY] = arselect('SR04S___SPIRICOAM02');
        
        [HPcounter, iHPcounter] = arselect('SR01C___FREQB__AM00');
        [HPcounter_precise, iHPcounter_precise] = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = HPcounter_precise+499.642;
        [MOCounter_FREQ, iMOCounter_FREQ] = arselect('MOCounter:FREQUENCY');
        
        [HPsyn, iHPsyn] = arselect('SR01C___FREQB__AM00');
        
        [hqmofm, ihqmofm] = arselect('EG______HQMOFM_AC01');
        
        if datenum(year1,month,day)<734397
            factor=1;
        else
            factor=10;
        end
        hqmofm = hqmofm*4.988e3/factor;
        
        [QFAam, iQFAam] = arselect('SR01C___QFA____AM00');
        
        % BR RF parameters
        [Power_RF_fwd, iPower_RF_fwd] = arselect('Power_RF_fwd');
        [Power_RF_ref, iPower_RF_ref] = arselect('Power_RF_ref');
        [Power_drive, iPower_drive] = arselect('Power_drive');
        [HV_setpoint, iHV_setpoint] = arselect('HV_setpoint');
        [Beam_volts, iBeam_volts] = arselect('Beam_volts');
        [Beam_current, iBeam_current] = arselect('Beam_current');
        [Bias_volts, iBias_volts] = arselect('Bias_volts');
        [Bias_current, iBias_current] = arselect('Bias_current');
        [Heater_Voltage, iHeater_Voltage] = arselect('Heater_Voltage');
        [Heater_current, iHeater_current] = arselect('Heater_current');
        [Focus_voltage, iFocus_voltage] = arselect('Focus_voltage');
        [Focus_current, iFocus_current] = arselect('Focus_current');
        [VacIon_voltage, iVacIon_voltage] = arselect('VacIon_voltage');
        [VacIon_current, iVacIon_current] = arselect('VacIon_current');
        [Thy_Grid1_volts, iThy_Grid1_volts] = arselect('Thy_Grid1_volts');
        [Thy_Grid2_volts, iThy_Grid2_volts] = arselect('Thy_Grid2_volts');
        [Thy_heater_volts, iThy_heater_volts] = arselect('Thy_heater_volts');
        [Thy_heater_current, iThy_heater_current] = arselect('Thy_heater_current');
        [Body_Current, iBody_Current] = arselect('Body_Current');
        [Temp_HV_enclose, iTemp_HV_enclose] = arselect('Temp_HV_enclose');
        [Temp_IOT_enclose, iTemp_IOT_enclose] = arselect('Temp_IOT_enclose');
        [Temp_IOT_cooling, iTemp_IOT_cooling] = arselect('Temp_IOT_cooling');
        [Temp_ceramic_output, iTemp_ceramic_output] = arselect('Temp_ceramic_output');
        [BR_CLDFWD, iBR_CLDFWD] = arselect('BR4_____CLDFWD_AM00');
        [BR_WGREV, iBR_WGREV] = arselect('BR4_____WGREV__AM01');
        [BR_WGFWD, iBR_WGFWD] = arselect('BR4_____WGFWD__AM02');
        [BR_RFCONT, iBR_RFCONT] = arselect('BR4_____RFCONT_AM01');
        [BR_PHSCON_AM, iBR_PHSCON_AM] = arselect('BR4_____PHSCON_AM00');
        [BR_PHSCON_AC, iBR_PHSCON_AC] = arselect('BR4_____PHSCON_AC00');
        [BR_TUNPOS, iBR_TUNPOS] = arselect('BR4_____TUNPOS_AM00');
        [BR_TUNERR, iBR_TUNERR] = arselect('BR4_____TUNERR_AM02');
        [BR_CAVTMP, iBR_CAVTMP] = arselect('BR4_____CAVTMP_AM03');
        [BR_LCWTMP, iBR_LCWTMP] = arselect('BR4_____LCWTMP_AM03');
        [BR_CLDFLW, iBR_CLDFLW] = arselect('BR4_____CLDFLW_AM01');
        [BR_CIRFLW, iBR_CIRFLW] = arselect('BR4_____CIRFLW_AM02');
        [BR_SLDTMP, iBR_SLDTMP] = arselect('BR4_____SLDTMP_AM01');
        [BR_CIRTMP, iBR_CIRTMP] = arselect('BR4_____CIRTMP_AM03');
        [BR_SLDFLW, iBR_SLDFLW] = arselect('BR4_____SLDFLW_AM00');
        [BR_CLDTMP, iBR_CLDTMP] = arselect('BR4_____CLDTMP_AM03');
        [BR_CAVFLW, iBR_CAVFLW] = arselect('BR4_____CAVFLW_AM00');
        [BR_WINFLW, iBR_WINFLW] = arselect('BR4_____WINFLW_AM01');
        [BR_TUNFLW, iBR_TUNFLW] = arselect('BR4_____TUNFLW_AM02');
        
        % SR Klystron 2 parameters
        [SR_CATHVT,iSR_CATHVT] = arselect(CATHVname);
        [SR_HVPSI,iSR_HVPSI] = arselect(HVPSIname);
        [SR_MAVOLT,iSR_MAVOLT] = arselect(MAVOLTname);
        [SR_MACURR,iSR_MACURR] = arselect(MACURRname);
        [SR_HTRVLT,iSR_HTRVLT] = arselect(HTRVLTname);
        [SR_HTRCUR,iSR_HTRCUR] = arselect(HTRCURname);
        [SR_RFAMP,iSR_RFAMP] = arselect('SR03S___RFAMP__AM01');
        [SR_HVPSV,iSR_HVPSV] = arselect(HVPSVname);
        [SR_IP1CUR,iSR_IP1CUR] = arselect(IP1name);
        [SR_IP2CUR,iSR_IP2CUR] = arselect(IP2name);
        
        [user_beam, iuser_beam] = arselect('sr:user_beam');
        
        % Beamline shutters
        [B021_PSS201_OPN, iB021_PSS201_OPN] = arselect('B021_PSS201_OPN');
        if isempty(iB021_PSS201_OPN)
            B021_PSS201_OPN = NaN * ones(1,length(ARt));
        end
        [B03_11_PSS1_RSS_TRLY_OPN, iB03_11_PSS1_RSS_TRLY_OPN] = arselect('B03_11_PSS1_RSS_TRLY_OPN');
        [B03_2_PSS101_RSS_TRLY_OPN, iB03_2_PSS101_RSS_TRLY_OPN] = arselect('B03_2_PSS101_RSS_TRLY_OPN');
        [B03_2_PSS201_RSS_TRLY_OPN, iB03_2_PSS201_RSS_TRLY_OPN] = arselect('B03_2_PSS201_RSS_TRLY_OPN');
        [B03_3_PSS101_RSS_TRLY_OPN, iB03_3_PSS101_RSS_TRLY_OPN] = arselect('B03_3_PSS101_RSS_TRLY_OPN');
        [B03_3_PSS201_RSS_TRLY_OPN, iB03_3_PSS201_RSS_TRLY_OPN] = arselect('B03_3_PSS201_RSS_TRLY_OPN');
        [B040_PSS002_RSS_TRLY_OPN, iB040_PSS002_RSS_TRLY_OPN] = arselect('B040_PSS201_RSS_TRLY_OPN');
        [B040_PSS001_RSS_TRLY_OPN, iB040_PSS001_RSS_TRLY_OPN] = arselect('B040_PSS301_RSS_TRLY_OPN');
        [ICS_BL042_PSS101_RSS_TRLY_OP, iICS_BL042_PSS101_RSS_TRLY_OP] = arselect('ICS_BL042_PSS101_RSS_TRLY_OP',1);
        [ICS_BL042_PSS201_RSS_TRLY_OP, iICS_BL042_PSS201_RSS_TRLY_OP] = arselect('ICS_BL042_PSS201_RSS_TRLY_OP',1);
        [ICS_BL043_PSS101_RSS_TRLY_OP, iICS_BL043_PSS101_RSS_TRLY_OP] = arselect('ICS_BL043_PSS101_RSS_TRLY_OP',1);
        [ICS_BL043_PSS201_RSS_TRLY_OP, iICS_BL043_PSS201_RSS_TRLY_OP] = arselect('ICS_BL043_PSS201_RSS_TRLY_OP',1);
        [B050_PSS001_RSS_TRLY_OPN, iB050_PSS001_RSS_TRLY_OPN] = arselect('B050_PSS001_RSS_TRLY_OPN');
        [B050_PSS101_OPN, iB050_PSS101_OPN] = arselect('BL50_PSS101_OPN');
        [B050_PSS201_OPN, iB050_PSS201_OPN] = arselect('BL50_PSS201_OPN');
        [B050_PSS301_OPN, iB050_PSS301_OPN] = arselect('BL50_PSS301_OPN');
        [B050_PSS111_OPN, iB050_PSS111_OPN] = arselect('BL50_PSS111_OPN');
        [B050_PSS211_OPN, iB050_PSS211_OPN] = arselect('BL50_PSS211_OPN');
        [B050_PSS311_OPN, iB050_PSS311_OPN] = arselect('BL50_PSS311_OPN');
        [B053_PSS101_RSS_TRLY_OPN, iB053_PSS101_RSS_TRLY_OPN] = arselect('B053_PSS101_RSS_TRLY_OPN');
        [B053_PSS201_RSS_TRLY_OPN, iB053_PSS201_RSS_TRLY_OPN] = arselect('B053_PSS201_RSS_TRLY_OPN');
        [B060_PSS101_OPN, iB060_PSS101_OPN] = arselect('B060_PSS101_OPN');
        [B060_PSS202_OPN, iB060_PSS202_OPN] = arselect('B060_PSS202_OPN');
        [B0612_PSS1_OPN, iB0612_PSS1_OPN] = arselect('B0612_PSS1_OPN');
        [B0631_PSS1_OPN, iB0631_PSS1_OPN] = arselect('B0631_PSS1_OPN');
        [B0632_PSS1_OPN, iB0632_PSS1_OPN] = arselect('B0632_PSS1_OPN');
        [B0702_PSS1_RSS_TRLY_OPN, iB0702_PSS1_RSS_TRLY_OPN] = arselect('B0702_PSS201_RSS_TRLY_OPN');
        [B073_PSS1_RSS_TRLY_OPN, iB073_PSS1_RSS_TRLY_OPN] = arselect('B073_PSS1_RSS_TRLY_OPN');
        [B0733_PSS1_OPN, iB0733_PSS1_OPN] = arselect('B0733_PSS1_OPN');
        [ICS_B0801_PSS1_RSS_TRLY_OPN, iICS_B0801_PSS1_RSS_TRLY_OPN] = arselect('ICS_B0801_PSS1_RSS_TRLY_OPN');
        [ICS_B082_PSS101_RSS_TRLY_OP, iICS_B082_PSS101_RSS_TRLY_OP] = arselect('ICS_B082_PSS101_RSS_TRLY_OPN');
        [ICS_B082_PSS201_RSS_TRLY_OP, iICS_B082_PSS201_RSS_TRLY_OP] = arselect('ICS_B082_PSS201_RSS_TRLY_OPN');
        [ICS_B083_PSS101_RSS_TRLY_OP, iICS_B083_PSS101_RSS_TRLY_OP] = arselect('ICS_B083_PSS101_RSS_TRLY_OPN');
        [ICS_B083_PSS201_RSS_TRLY_OP, iICS_B083_PSS201_RSS_TRLY_OP] = arselect('ICS_B083_PSS201_RSS_TRLY_OPN');
        [B090_PSS1_RSS_TRLY_OPN, iB090_PSS1_RSS_TRLY_OPN] = arselect('B090_PSS1_RSS_TRLY_OPN');
        [B09_31_PSS1_RSS_TRLY_OPN, iB09_31_PSS1_RSS_TRLY_OPN] = arselect('B09_31_PSS1_RSS_TRLY_OPN');
        [B09_3_PSS1_RSS_TRLY_OPN, iB09_3_PSS1_RSS_TRLY_OPN] = arselect('B09_3_PSS1_RSS_TRLY_OPN');
        [B10_0_PSS001_RSS_TRLY_OPN, iB10_0_PSS001_RSS_TRLY_OPN] = arselect('B10_0_PSS001_RSS_TRLY_OPN');
        [B10_31_PSS1_RSS_TRLY_OPN, iB10_31_PSS1_RSS_TRLY_OPN] = arselect('B10_31_PSS1_RSS_TRLY_OPN');
        [B110_PSS101_RSS_TRLY_OPN, iB110_PSS101_RSS_TRLY_OPN] = arselect('B110_PSS101_RSS_TRLY_OPN');
        [B110_PSS201_RSS_TRLY_OPN, iB110_PSS201_RSS_TRLY_OPN] = arselect('B110_PSS201_RSS_TRLY_OPN');
        [BL113_PSS101_RSS_TRLY_OPN, iBL113_PSS101_RSS_TRLY_OPN] = arselect('BL113_PSS101_RSS_TRLY_OPN');
        [BL113_PSS201_RSS_TRLY_OPN, iBL113_PSS201_RSS_TRLY_OPN] = arselect('BL113_PSS201_RSS_TRLY_OPN');
        [ICS_BL12_0_PSS1_RSS_TRLY_OPN, iICS_BL12_0_PSS1_RSS_TRLY_OPN] = arselect('ICS_BL12_0_PSS1_RSS_TRLY_OPN');
        [ICS_BL12_2_PSS101_RSS_TRLY_O, iICS_BL12_2_PSS101_RSS_TRLY_O] = arselect('ICS_BL12_2_PSS101_RSS_TRLY_O',1);
        [ICS_BL12_2_PSS201_RSS_TRLY_O, iICS_BL12_2_PSS201_RSS_TRLY_O] = arselect('ICS_BL12_2_PSS201_RSS_TRLY_O',1);
        [ICS_BL12_3_PSS101_RSS_TRLY_O, iICS_BL12_3_PSS101_RSS_TRLY_O] = arselect('ICS_BL12_3_PSS101_RSS_TRLY_O',1);
        [ICS_BL12_3_PSS201_RSS_TRLY_O, iICS_BL12_3_PSS201_RSS_TRLY_O] = arselect('ICS_BL12_3_PSS201_RSS_TRLY_O',1);
        [B122_PSS111_OPN, iB122_PSS111_OPN] = arselect('B122_PSS111_OPN');
        [B122_PSS211_OPN, iB122_PSS211_OPN] = arselect('B122_PSS211_OPN');
        [B123_PSS111_OPN, iB123_PSS111_OPN] = arselect('B123_PSS111_OPN');
        [B123_PSS211_OPN, iB123_PSS211_OPN] = arselect('B123_PSS211_OPN');
        
        % Wago temperature monitors
        [SR06C_TCWAGO_AM20, iSR06C_TCWAGO_AM20] = arselect('SR06C___TCWAGO_AM20');
        [SR06C_TCWAGO_AM24, iSR06C_TCWAGO_AM24] = arselect('SR06C___TCWAGO_AM24');
        [SR06C_TCWAGO_AM25, iSR06C_TCWAGO_AM25] = arselect('SR06C___TCWAGO_AM25');
        [SR06C_TCWAGO_AM26, iSR06C_TCWAGO_AM26] = arselect('SR06C___TCWAGO_AM26');
        [SR06C_TCWAGO_AM27, iSR06C_TCWAGO_AM27] = arselect('SR06C___TCWAGO_AM27');
        [SR06C_TCWAGO_AM35, iSR06C_TCWAGO_AM35] = arselect('SR06C___TCWAGO_AM35');
        
        % time vector
        t = [ARt+(day-StartDay)*24*60*60];
        
        
    else
        
        %dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
        dcct = [dcct arselect('cmm:beam_current')];
        %if all(arselect('cmm:cam_current')==0)
        i_cam1 = arselect('Cam1_current');
        i_cam2 = arselect('Cam2_current');
        i_cam=[i_cam i_cam1+i_cam2];
        %else
        %    i_cam = [i_cam arselect('cmm:cam_current')];
        %end
        inj_eff = [inj_eff arselect('BTS_To_SR_Injection_Efficiency')];
        inj_rate = [inj_rate arselect('BTS_To_SR_Injection_Rate')];
        gev = [gev arselect('cmm:sr_energy')];
        lifetime = [lifetime arselect('SR05W___DCCT2__AM00')];
        [dummy, idummy] = arselect('Topoff_lifetime_AM');
        if all(isnan(dummy)) | all(dummy==0)
            [dummy, idummy] =  arselect('Physics1'); %arselect('Physics1') also returns 'Physics10' due to the built-in wildcard feature!
            lifetime3 = [lifetime3 arselect('Physics2')];
            if size(dummy,1) == 2
                lifetime2 = [lifetime2 dummy(1,:)];
            else
                lifetime2 = [lifetime2 dummy];
            end
        else
            lifetime2 = [lifetime2 dummy];
            lifetime3 = [lifetime3 arselect('Topoff_cam_lifetime_AM')];
        end
        
        BTSBPMx = [BTSBPMx arselect(BTSBPMxNames)];
        BTSBPMy = [BTSBPMy arselect(BTSBPMyNames)];
        BTSBPMsum = [BTSBPMsum arselect(BTSBPMsumNames)];
        
        LinacBPMx = [LinacBPMx arselect(LinacBPMxNames)];
        LinacBPMy = [LinacBPMy arselect(LinacBPMyNames)];
        LinacBPMsum = [LinacBPMsum arselect(LinacBPMsumNames)];
        
        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];
        
        % ID vertical gap
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];
        
        if FFFlag
            GapEnable = [GapEnable arselect(GapEnableNames)];
            FF8Enable = [FF8Enable arselect('sr08u:FFEnable:bi')];
        end
        
        %         TC7_1 = [TC7_1 arselect('SR07U___IDTC1__AM')];
        %         TC7_2 = [TC7_2 arselect('SR07U___IDTC2__AM')];
        %         TC7_3 = [TC7_3 arselect('SR07U___IDTC3__AM')];
        %         TC7_4 = [TC7_4 arselect('SR07U___IDTC4__AM')];
        
        TC8_1 = [TC8_1 arselect('SR08U___IDTC1__AM')];
        TC8_2 = [TC8_2 arselect('SR08U___IDTC2__AM')];
        TC8_3 = [TC8_3 arselect('SR08U___IDTC3__AM')];
        TC8_4 = [TC8_4 arselect('SR08U___IDTC4__AM')];
        
        TC9_1 = [TC9_1 arselect('SR09U___IDTC1__AM')];
        TC9_2 = [TC9_2 arselect('SR09U___IDTC2__AM')];
        TC9_3 = [TC9_3 arselect('SR09U___IDTC3__AM')];
        TC9_4 = [TC9_4 arselect('SR09U___IDTC4__AM')];
        
        TC10_1 = [TC10_1 arselect('SR10U___IDTC1__AM')];
        TC10_2 = [TC10_2 arselect('SR10U___IDTC2__AM')];
        TC10_3 = [TC10_3 arselect('SR10U___IDTC3__AM')];
        TC10_4 = [TC10_4 arselect('SR10U___IDTC4__AM')];
        
        TC12_1 = [TC12_1 arselect('SR12U___IDTC1__AM')];
        TC12_2 = [TC12_2 arselect('SR12U___IDTC2__AM')];
        TC12_3 = [TC12_3 arselect('SR12U___IDTC3__AM')];
        TC12_4 = [TC12_4 arselect('SR12U___IDTC4__AM')];
        
        TCSR01 = [TCSR01 arselect('SR01C___T______AM')];
        TCSR02 = [TCSR02 arselect('SR02C___T______AM')];
        TCSR03 = [TCSR03 arselect('SR03C___T______AM')];
        TCSR04 = [TCSR04 arselect('SR04C___T______AM')];
        TCSR05 = [TCSR05 arselect('SR05C___T______AM')];
        TCSR06 = [TCSR06 arselect('SR06C___T______AM')];
        TCSR07 = [TCSR07 arselect('SR07C___T______AM')];
        TCSR08 = [TCSR08 arselect('SR08C___T______AM')];
        TCSR09 = [TCSR09 arselect('SR09C___T______AM')];
        TCSR11 = [TCSR11 arselect('SR11C___T______AM')];
        TCSR12 = [TCSR12 arselect('SR12C___T______AM')];
        TCSRAVG = [TCSRAVG arselect('SR01C___T_AVG__AM')];
        
        AHUT01 = [AHUT01 arselect('SR01C___AHUT___AM')];
        AHUT03 = [AHUT03 arselect('SR03C___AHUT___AM')];
        AHUT04 = [AHUT04 arselect('SR04C___AHUT___AM')];
        AHUT06 = [AHUT06 arselect('SR06C___AHUT___AM')];
        AHUT07 = [AHUT07 arselect('SR07C___AHUT___AM')];
        AHUT08 = [AHUT08 arselect('SR08C___AHUT___AM')];
        AHUT09 = [AHUT09 arselect('SR09C___AHUT___AM')];
        AHUT11 = [AHUT11 arselect('SR11C___AHUT___AM')];
        
        WVSRM = [WVSRM arselect('SR01C___AHWVM__AM00')];
        
        lcwtmp = arselect('SR03S___LCWTMP_AM99');
        if isnan(lcwtmp) 
            lcwtmp = arselect('SR03S___LCWTMP_AM00');
        end
        lcw = [lcw lcwtmp];
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
        
        % All Bergoz BPMs
        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];
        
        % actual BPMs that are written to these PVs are determined by bpm_psd_plot.m (line 30)
        ID9BPM1xRMS = [ID9BPM1xRMS arselect('SR09S_IBPM1X_RMS')];
        ID9BPM1yRMS = [ID9BPM1yRMS arselect('SR09S_IBPM1Y_RMS')];
        ID9BPM2xRMS = [ID9BPM2xRMS arselect('SR09S_IBPM2X_RMS')];
        ID9BPM2yRMS = [ID9BPM2yRMS arselect('SR09S_IBPM2Y_RMS')];
        
        C1TEMP = [C1TEMP arselect('SR03S___C1TEMP_AM')];
        C2TEMP = [C2TEMP arselect('SR03S___C2TEMP_AM')];
        
        C1LCW = [C1LCW arselect('SR03S___C1LCWF_AM')];
        C2LCW = [C2LCW arselect('SR03S___C2LCWF_AM')];
        
        %         SigX = [SigX arselect('SR04S___SPIRICOAM07')];
        %         SigY = [SigY arselect('SR04S___SPIRICOAM08')];
        
        [tmpX, iSigX31] = arselect('beamline31:XRMSAve',1);
        [tmpY, iSigY31] = arselect('beamline31:YRMSAve',1);
        if isempty(tmpX)
            tmpX = NaN * ones(1,length(ARt));
        end
        if isempty(tmpY)
            tmpY = NaN * ones(1,length(ARt));
        end
        SigX31 = [SigX31 tmpX];
        SigY31 = [SigY31 tmpY];
        
        [tmpX, iSigX72] = arselect('bl72:XRMSAve',0); %for some reason XRMS returns the *Error PV first
        [tmpY, iSigY72] = arselect('bl72:YRMSAve',1);
        tmpX = tmpX(1,:); %for some reason XRMS returns the *Error PV first
        if isempty(tmpX)
            tmpX = NaN * ones(1,length(ARt));
        end
        if isempty(tmpY)
            tmpY = NaN * ones(1,length(ARt));
        end
        SigX72 = [SigX72 tmpX];
        SigY72 = [SigY72 tmpY];
        
        %         SpiroX = [SpiroX arselect('SR04S___SPIRICOAM01')];
        %         SpiroY = [SpiroY arselect('SR04S___SPIRICOAM02')];
        
        HPcounter = [HPcounter arselect('SR01C___FREQB__AM00')];
        tmp = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = [HPcounter_precise tmp+499.642];
        MOCounter_FREQ = [MOCounter_FREQ arselect('MOCounter:FREQUENCY')];
        
        HPsyn = [HPsyn arselect('SR01C___FREQB__AM00')];
        
        tmp = arselect('EG______HQMOFM_AC01');
        if datenum(year1,month,day)<734397
            factor=1;
        else
            factor=10;
        end
        hqmofm = [hqmofm tmp*4.988e3/factor];
        
        QFAam = [QFAam arselect('SR01C___QFA____AM00')];
        
        % BR RF parameters
        Power_RF_fwd = [Power_RF_fwd arselect('Power_RF_fwd')];
        Power_RF_ref = [Power_RF_ref arselect('Power_RF_ref')];
        Power_drive = [Power_drive arselect('Power_drive')];
        HV_setpoint = [HV_setpoint arselect('HV_setpoint')];
        Beam_volts = [Beam_volts arselect('Beam_volts')];
        Beam_current = [Beam_current arselect('Beam_current')];
        Bias_volts = [Bias_volts arselect('Bias_volts')];
        Bias_current = [Bias_current arselect('Bias_current')];
        Heater_Voltage = [Heater_Voltage arselect('Heater_Voltage')];
        Heater_current = [Heater_current arselect('Heater_current')];
        Focus_voltage = [Focus_voltage arselect('Focus_voltage')];
        Focus_current = [Focus_current arselect('Focus_current')];
        VacIon_voltage = [VacIon_voltage arselect('VacIon_voltage')];
        VacIon_current = [VacIon_current arselect('VacIon_current')];
        Thy_Grid1_volts = [Thy_Grid1_volts arselect('Thy_Grid1_volts')];
        Thy_Grid2_volts = [Thy_Grid2_volts arselect('Thy_Grid2_volts')];
        Thy_heater_volts = [Thy_heater_volts arselect('Thy_heater_volts')];
        Thy_heater_current = [Thy_heater_current arselect('Thy_heater_current')];
        Body_Current = [Body_Current arselect('Body_Current')];
        Temp_HV_enclose = [Temp_HV_enclose arselect('Temp_HV_enclose')];
        Temp_IOT_enclose = [Temp_IOT_enclose arselect('Temp_IOT_enclose')];
        Temp_IOT_cooling = [Temp_IOT_cooling arselect('Temp_IOT_cooling')];
        Temp_ceramic_output = [Temp_ceramic_output arselect('Temp_ceramic_output')];
        BR_CLDFWD = [BR_CLDFWD arselect('BR4_____CLDFWD_AM00')];
        BR_WGREV = [BR_WGREV arselect('BR4_____WGREV__AM01')];
        BR_WGFWD = [BR_WGFWD arselect('BR4_____WGFWD__AM02')];
        BR_RFCONT = [BR_RFCONT arselect('BR4_____RFCONT_AM01')];
        BR_PHSCON_AM = [BR_PHSCON_AM arselect('BR4_____PHSCON_AM00')];
        BR_PHSCON_AC = [BR_PHSCON_AC arselect('BR4_____PHSCON_AC00')];
        BR_TUNPOS = [BR_TUNPOS arselect('BR4_____TUNPOS_AM00')];
        BR_TUNERR = [BR_TUNERR arselect('BR4_____TUNERR_AM02')];
        BR_CAVTMP = [BR_CAVTMP arselect('BR4_____CAVTMP_AM03')];
        BR_LCWTMP = [BR_LCWTMP arselect('BR4_____LCWTMP_AM03')];
        BR_CLDFLW = [BR_CLDFLW arselect('BR4_____CLDFLW_AM01')];
        BR_CIRFLW = [BR_CIRFLW arselect('BR4_____CIRFLW_AM02')];
        BR_SLDTMP = [BR_SLDTMP arselect('BR4_____SLDTMP_AM01')];
        BR_CIRTMP = [BR_CIRTMP arselect('BR4_____CIRTMP_AM03')];
        BR_SLDFLW = [BR_SLDFLW arselect('BR4_____SLDFLW_AM00')];
        BR_CLDTMP = [BR_CLDTMP arselect('BR4_____CLDTMP_AM03')];
        BR_CAVFLW = [BR_CAVFLW arselect('BR4_____CAVFLW_AM00')];
        BR_WINFLW = [BR_WINFLW arselect('BR4_____WINFLW_AM01')];
        BR_TUNFLW = [BR_TUNFLW arselect('BR4_____TUNFLW_AM02')];
        
        % SR Klystron 2 parameters
        SR_CATHVT = [SR_CATHVT arselect(CATHVname)];
        SR_HVPSI = [SR_HVPSI arselect(HVPSIname)];
        SR_MAVOLT = [SR_MAVOLT arselect(MAVOLTname)];
        SR_MACURR = [SR_MACURR arselect(MACURRname)];
        SR_HTRVLT = [SR_HTRVLT arselect(HTRVLTname)];
        SR_HTRCUR = [SR_HTRCUR arselect(HTRCURname)];
        SR_RFAMP = [SR_RFAMP arselect('SR03S___RFAMP__AM01')];
        SR_HVPSV = [SR_HVPSV arselect(HVPSVname)];
        SR_IP1CUR = [SR_IP1CUR arselect(IP1name)];
        SR_IP2CUR = [SR_IP2CUR arselect(IP2name)];
        
        user_beam = [user_beam arselect('sr:user_beam')];
        
        % Beamline shutters
        tmp = arselect('B021_PSS201_OPN');
        if isempty(tmp)
            B021_PSS201_OPN = NaN * ones(1,length(ARt));
        end
        B021_PSS201_OPN = [B021_PSS201_OPN tmp];
        B03_11_PSS1_RSS_TRLY_OPN = [B03_11_PSS1_RSS_TRLY_OPN arselect('B03_11_PSS1_RSS_TRLY_OPN')];
        B03_2_PSS101_RSS_TRLY_OPN = [B03_2_PSS101_RSS_TRLY_OPN arselect('B03_2_PSS101_RSS_TRLY_OPN')];
        B03_2_PSS201_RSS_TRLY_OPN = [B03_2_PSS201_RSS_TRLY_OPN arselect('B03_2_PSS201_RSS_TRLY_OPN')];
        B03_3_PSS101_RSS_TRLY_OPN = [B03_3_PSS101_RSS_TRLY_OPN arselect('B03_3_PSS101_RSS_TRLY_OPN')];
        B03_3_PSS201_RSS_TRLY_OPN = [B03_3_PSS201_RSS_TRLY_OPN arselect('B03_3_PSS201_RSS_TRLY_OPN')];
        B040_PSS002_RSS_TRLY_OPN = [B040_PSS002_RSS_TRLY_OPN arselect('B040_PSS201_RSS_TRLY_OPN')];
        B040_PSS001_RSS_TRLY_OPN = [B040_PSS001_RSS_TRLY_OPN arselect('B040_PSS301_RSS_TRLY_OPN')];
        ICS_BL042_PSS101_RSS_TRLY_OP = [ICS_BL042_PSS101_RSS_TRLY_OP arselect('ICS_BL042_PSS101_RSS_TRLY_OP',1)];
        ICS_BL042_PSS201_RSS_TRLY_OP = [ICS_BL042_PSS201_RSS_TRLY_OP arselect('ICS_BL042_PSS201_RSS_TRLY_OP',1)];
        ICS_BL043_PSS101_RSS_TRLY_OP = [ICS_BL043_PSS101_RSS_TRLY_OP arselect('ICS_BL043_PSS101_RSS_TRLY_OP',1)];
        ICS_BL043_PSS201_RSS_TRLY_OP = [ICS_BL043_PSS201_RSS_TRLY_OP arselect('ICS_BL043_PSS201_RSS_TRLY_OP',1)];
        B050_PSS001_RSS_TRLY_OPN = [B050_PSS001_RSS_TRLY_OPN arselect('B050_PSS001_RSS_TRLY_OPN')];
        B050_PSS101_OPN = [B050_PSS101_OPN arselect('BL50_PSS101_OPN')];
        B050_PSS201_OPN = [B050_PSS201_OPN arselect('BL50_PSS201_OPN')];
        B050_PSS301_OPN = [B050_PSS301_OPN arselect('BL50_PSS301_OPN')];
        B050_PSS111_OPN = [B050_PSS111_OPN arselect('BL50_PSS111_OPN')];
        B050_PSS211_OPN = [B050_PSS211_OPN arselect('BL50_PSS211_OPN')];
        B050_PSS311_OPN = [B050_PSS311_OPN arselect('BL50_PSS311_OPN')];
        B053_PSS101_RSS_TRLY_OPN = [B053_PSS101_RSS_TRLY_OPN arselect('B053_PSS101_RSS_TRLY_OPN')];
        B053_PSS201_RSS_TRLY_OPN = [B053_PSS201_RSS_TRLY_OPN arselect('B053_PSS201_RSS_TRLY_OPN')];
        B060_PSS101_OPN = [B060_PSS101_OPN arselect('B060_PSS101_OPN')];
        B060_PSS202_OPN = [B060_PSS202_OPN arselect('B060_PSS202_OPN')];
        B0612_PSS1_OPN = [B0612_PSS1_OPN arselect('B0612_PSS1_OPN')];
        B0631_PSS1_OPN = [B0631_PSS1_OPN arselect('B0631_PSS1_OPN')];
        B0632_PSS1_OPN = [B0632_PSS1_OPN arselect('B0632_PSS1_OPN')];
        B0702_PSS1_RSS_TRLY_OPN = [B0702_PSS1_RSS_TRLY_OPN arselect('B0702_PSS201_RSS_TRLY_OPN')];
        B073_PSS1_RSS_TRLY_OPN = [B073_PSS1_RSS_TRLY_OPN arselect('B073_PSS1_RSS_TRLY_OPN')];
        B0733_PSS1_OPN = [B0733_PSS1_OPN arselect('B0733_PSS1_OPN')];
        ICS_B0801_PSS1_RSS_TRLY_OPN = [ICS_B0801_PSS1_RSS_TRLY_OPN arselect('ICS_B0801_PSS1_RSS_TRLY_OPN')];
        ICS_B082_PSS101_RSS_TRLY_OP = [ICS_B082_PSS101_RSS_TRLY_OP arselect('ICS_B082_PSS101_RSS_TRLY_OPN')];
        ICS_B082_PSS201_RSS_TRLY_OP = [ICS_B082_PSS201_RSS_TRLY_OP arselect('ICS_B082_PSS201_RSS_TRLY_OPN')];
        ICS_B083_PSS101_RSS_TRLY_OP = [ICS_B083_PSS101_RSS_TRLY_OP arselect('ICS_B083_PSS101_RSS_TRLY_OPN')];
        ICS_B083_PSS201_RSS_TRLY_OP = [ICS_B083_PSS201_RSS_TRLY_OP arselect('ICS_B083_PSS201_RSS_TRLY_OPN')];
        B090_PSS1_RSS_TRLY_OPN = [B090_PSS1_RSS_TRLY_OPN arselect('B090_PSS1_RSS_TRLY_OPN')];
        B09_31_PSS1_RSS_TRLY_OPN = [B09_31_PSS1_RSS_TRLY_OPN arselect('B09_31_PSS1_RSS_TRLY_OPN')];
        B09_3_PSS1_RSS_TRLY_OPN = [B09_3_PSS1_RSS_TRLY_OPN arselect('B09_3_PSS1_RSS_TRLY_OPN')];
        B10_0_PSS001_RSS_TRLY_OPN = [B10_0_PSS001_RSS_TRLY_OPN arselect('B10_0_PSS001_RSS_TRLY_OPN')];
        B10_31_PSS1_RSS_TRLY_OPN = [B10_31_PSS1_RSS_TRLY_OPN arselect('B10_31_PSS1_RSS_TRLY_OPN')];
        B110_PSS101_RSS_TRLY_OPN = [B110_PSS101_RSS_TRLY_OPN arselect('B110_PSS101_RSS_TRLY_OPN')];
        B110_PSS201_RSS_TRLY_OPN = [B110_PSS201_RSS_TRLY_OPN arselect('B110_PSS201_RSS_TRLY_OPN')];
        BL113_PSS101_RSS_TRLY_OPN = [BL113_PSS101_RSS_TRLY_OPN arselect('BL113_PSS101_RSS_TRLY_OPN')];
        BL113_PSS201_RSS_TRLY_OPN = [BL113_PSS201_RSS_TRLY_OPN arselect('BL113_PSS201_RSS_TRLY_OPN')];
        ICS_BL12_0_PSS1_RSS_TRLY_OPN = [ICS_BL12_0_PSS1_RSS_TRLY_OPN arselect('ICS_BL12_0_PSS1_RSS_TRLY_OPN')];
        ICS_BL12_2_PSS101_RSS_TRLY_O = [ICS_BL12_2_PSS101_RSS_TRLY_O arselect('ICS_BL12_2_PSS101_RSS_TRLY_O',1)];
        ICS_BL12_2_PSS201_RSS_TRLY_O = [ICS_BL12_2_PSS201_RSS_TRLY_O arselect('ICS_BL12_2_PSS201_RSS_TRLY_O',1)];
        ICS_BL12_3_PSS101_RSS_TRLY_O = [ICS_BL12_3_PSS101_RSS_TRLY_O arselect('ICS_BL12_3_PSS101_RSS_TRLY_O',1)];
        ICS_BL12_3_PSS201_RSS_TRLY_O = [ICS_BL12_3_PSS201_RSS_TRLY_O arselect('ICS_BL12_3_PSS201_RSS_TRLY_O',1)];
        B122_PSS111_OPN = [B122_PSS111_OPN arselect('B122_PSS111_OPN')];
        B122_PSS211_OPN = [B122_PSS211_OPN arselect('B122_PSS211_OPN')];
        B123_PSS111_OPN = [B123_PSS111_OPN arselect('B123_PSS111_OPN')];
        B123_PSS211_OPN = [B123_PSS211_OPN arselect('B123_PSS211_OPN')];
        
        % Wago temperature monitors
        SR06C_TCWAGO_AM20 = [SR06C_TCWAGO_AM20 arselect('SR06C___TCWAGO_AM20')];
        SR06C_TCWAGO_AM24 = [SR06C_TCWAGO_AM24 arselect('SR06C___TCWAGO_AM24')];
        SR06C_TCWAGO_AM25 = [SR06C_TCWAGO_AM25 arselect('SR06C___TCWAGO_AM25')];
        SR06C_TCWAGO_AM26 = [SR06C_TCWAGO_AM26 arselect('SR06C___TCWAGO_AM26')];
        SR06C_TCWAGO_AM27 = [SR06C_TCWAGO_AM27 arselect('SR06C___TCWAGO_AM27')];
        SR06C_TCWAGO_AM35 = [SR06C_TCWAGO_AM35 arselect('SR06C___TCWAGO_AM35')];
        
        % time vector
        t = [t  ARt+(day-StartDay)*24*60*60];
        
    end
    
    tmp = toc;
    ar_functions_time = ar_functions_time + tmp;
    fprintf('                One day of arselect = %g seconds\n',tmp);
    tic;
    
end

% Month 2
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
        
        
        %dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
        dcct = [dcct arselect('cmm:beam_current')];
        %if all(arselect('cmm:cam_current')==0)
        i_cam1 = arselect('Cam1_current');
        i_cam2 = arselect('Cam2_current');
        i_cam=[i_cam i_cam1+i_cam2];
        %else
        %    i_cam = [i_cam arselect('cmm:cam_current')];
        %end
        inj_eff = [inj_eff arselect('BTS_To_SR_Injection_Efficiency')];
        inj_rate = [inj_rate arselect('BTS_To_SR_Injection_Rate')];
        gev = [gev arselect('cmm:sr_energy')];
        lifetime = [lifetime arselect('SR05W___DCCT2__AM00')];
        [dummy, idummy] = arselect('Topoff_lifetime_AM');
        if all(isnan(dummy)) | all(dummy==0)
            [dummy, idummy] =  arselect('Physics1'); %arselect('Physics1') also returns 'Physics10' due to the built-in wildcard feature!
            lifetime3 = [lifetime3 arselect('Physics2')];
            if size(dummy,1) == 2
                lifetime2 = [lifetime2 dummy(1,:)];
            else
                lifetime2 = [lifetime2 dummy];
            end
        else
            lifetime2 = [lifetime2 dummy];
            lifetime3 = [lifetime3 arselect('Topoff_cam_lifetime_AM')];
        end
        
        BTSBPMx = [BTSBPMx arselect(BTSBPMxNames)];
        BTSBPMy = [BTSBPMy arselect(BTSBPMyNames)];
        BTSBPMsum = [BTSBPMsum arselect(BTSBPMsumNames)];
        
        LinacBPMx = [LinacBPMx arselect(LinacBPMxNames)];
        LinacBPMy = [LinacBPMy arselect(LinacBPMyNames)];
        LinacBPMsum = [LinacBPMsum arselect(LinacBPMsumNames)];
        
        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];
        
        % ID vertical gap
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];
        
        if FFFlag
            GapEnable = [GapEnable arselect(GapEnableNames)];
            FF8Enable = [FF8Enable arselect('sr08u:FFEnable:bi')];
        end
        
        %         TC7_1 = [TC7_1 arselect('SR07U___IDTC1__AM')];
        %         TC7_2 = [TC7_2 arselect('SR07U___IDTC2__AM')];
        %         TC7_3 = [TC7_3 arselect('SR07U___IDTC3__AM')];
        %         TC7_4 = [TC7_4 arselect('SR07U___IDTC4__AM')];
        
        TC8_1 = [TC8_1 arselect('SR08U___IDTC1__AM')];
        TC8_2 = [TC8_2 arselect('SR08U___IDTC2__AM')];
        TC8_3 = [TC8_3 arselect('SR08U___IDTC3__AM')];
        TC8_4 = [TC8_4 arselect('SR08U___IDTC4__AM')];
        
        TC9_1 = [TC9_1 arselect('SR09U___IDTC1__AM')];
        TC9_2 = [TC9_2 arselect('SR09U___IDTC2__AM')];
        TC9_3 = [TC9_3 arselect('SR09U___IDTC3__AM')];
        TC9_4 = [TC9_4 arselect('SR09U___IDTC4__AM')];
        
        TC10_1 = [TC10_1 arselect('SR10U___IDTC1__AM')];
        TC10_2 = [TC10_2 arselect('SR10U___IDTC2__AM')];
        TC10_3 = [TC10_3 arselect('SR10U___IDTC3__AM')];
        TC10_4 = [TC10_4 arselect('SR10U___IDTC4__AM')];
        
        TC12_1 = [TC12_1 arselect('SR12U___IDTC1__AM')];
        TC12_2 = [TC12_2 arselect('SR12U___IDTC2__AM')];
        TC12_3 = [TC12_3 arselect('SR12U___IDTC3__AM')];
        TC12_4 = [TC12_4 arselect('SR12U___IDTC4__AM')];
        
        TCSR01 = [TCSR01 arselect('SR01C___T______AM')];
        TCSR02 = [TCSR02 arselect('SR02C___T______AM')];
        TCSR03 = [TCSR03 arselect('SR03C___T______AM')];
        TCSR04 = [TCSR04 arselect('SR04C___T______AM')];
        TCSR05 = [TCSR05 arselect('SR05C___T______AM')];
        TCSR06 = [TCSR06 arselect('SR06C___T______AM')];
        TCSR07 = [TCSR07 arselect('SR07C___T______AM')];
        TCSR08 = [TCSR08 arselect('SR08C___T______AM')];
        TCSR09 = [TCSR09 arselect('SR09C___T______AM')];
        TCSR11 = [TCSR11 arselect('SR11C___T______AM')];
        TCSR12 = [TCSR12 arselect('SR12C___T______AM')];
        TCSRAVG = [TCSRAVG arselect('SR01C___T_AVG__AM')];
        
        AHUT01 = [AHUT01 arselect('SR01C___AHUT___AM')];
        AHUT03 = [AHUT03 arselect('SR03C___AHUT___AM')];
        AHUT04 = [AHUT04 arselect('SR04C___AHUT___AM')];
        AHUT06 = [AHUT06 arselect('SR06C___AHUT___AM')];
        AHUT07 = [AHUT07 arselect('SR07C___AHUT___AM')];
        AHUT08 = [AHUT08 arselect('SR08C___AHUT___AM')];
        AHUT09 = [AHUT09 arselect('SR09C___AHUT___AM')];
        AHUT11 = [AHUT11 arselect('SR11C___AHUT___AM')];
        
        WVSRM = [WVSRM arselect('SR01C___AHWVM__AM00')];
        
        % Add Channels Here
        LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];
        
        lcwtmp = arselect('SR03S___LCWTMP_AM99');
        if isnan(lcwtmp) 
            lcwtmp = arselect('SR03S___LCWTMP_AM00');
        end
        lcw = [lcw lcwtmp];
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
        
        % All Bergoz BPMs
        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];
        
        ID9BPM1xRMS = [ID9BPM1xRMS arselect('SR09S_IBPM1X_RMS')];
        ID9BPM1yRMS = [ID9BPM1yRMS arselect('SR09S_IBPM1Y_RMS')];
        ID9BPM2xRMS = [ID9BPM2xRMS arselect('SR09S_IBPM2X_RMS')];
        ID9BPM2yRMS = [ID9BPM2yRMS arselect('SR09S_IBPM2Y_RMS')];
        
        C1TEMP = [C1TEMP arselect('SR03S___C1TEMP_AM')];
        C2TEMP = [C2TEMP arselect('SR03S___C2TEMP_AM')];
        
        C1LCW = [C1LCW arselect('SR03S___C1LCWF_AM')];
        C2LCW = [C2LCW arselect('SR03S___C2LCWF_AM')];
        
        %         SigX = [SigX arselect('SR04S___SPIRICOAM07')];
        %         SigY = [SigY arselect('SR04S___SPIRICOAM08')];
        
        [tmpX, iSigX31] = arselect('beamline31:XRMSAve',1);
        [tmpY, iSigY31] = arselect('beamline31:YRMSAve',1);
        if isempty(tmpX)
            tmpX = NaN * ones(1,length(ARt));
        end
        if isempty(tmpY)
            tmpY = NaN * ones(1,length(ARt));
        end
        SigX31 = [SigX31 tmpX];
        SigY31 = [SigY31 tmpY];
        
        [tmpX, iSigX72] = arselect('bl72:XRMSAve',1);
        [tmpY, iSigY72] = arselect('bl72:YRMSAve',1);
        if isempty(tmpX)
            tmpX = NaN * ones(1,length(ARt));
        end
        if isempty(tmpY)
            tmpY = NaN * ones(1,length(ARt));
        end
        SigX72 = [SigX72 tmpX];
        SigY72 = [SigY72 tmpY];
        
        %         SpiroX = [SpiroX arselect('SR04S___SPIRICOAM01')];
        %         SpiroY = [SpiroY arselect('SR04S___SPIRICOAM02')];
        
        HPcounter = [HPcounter arselect('SR01C___FREQB__AM00')];
        tmp = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = [HPcounter_precise tmp+499.642];
        MOCounter_FREQ = [MOCounter_FREQ arselect('MOCounter:FREQUENCY')];
        
        HPsyn = [HPsyn arselect('SR01C___FREQB__AM00')];
        
        tmp = arselect('EG______HQMOFM_AC01');
        if datenum(year2,month2,day)<734397
            factor=1;
        else
            factor=10;
        end
        hqmofm = [hqmofm tmp*4.988e3/factor];
        
        QFAam = [QFAam arselect('SR01C___QFA____AM00')];
        
        % BR RF parameters
        Power_RF_fwd = [Power_RF_fwd arselect('Power_RF_fwd')];
        Power_RF_ref = [Power_RF_ref arselect('Power_RF_ref')];
        Power_drive = [Power_drive arselect('Power_drive')];
        HV_setpoint = [HV_setpoint arselect('HV_setpoint')];
        Beam_volts = [Beam_volts arselect('Beam_volts')];
        Beam_current = [Beam_current arselect('Beam_current')];
        Bias_volts = [Bias_volts arselect('Bias_volts')];
        Bias_current = [Bias_current arselect('Bias_current')];
        Heater_Voltage = [Heater_Voltage arselect('Heater_Voltage')];
        Heater_current = [Heater_current arselect('Heater_current')];
        Focus_voltage = [Focus_voltage arselect('Focus_voltage')];
        Focus_current = [Focus_current arselect('Focus_current')];
        VacIon_voltage = [VacIon_voltage arselect('VacIon_voltage')];
        VacIon_current = [VacIon_current arselect('VacIon_current')];
        Thy_Grid1_volts = [Thy_Grid1_volts arselect('Thy_Grid1_volts')];
        Thy_Grid2_volts = [Thy_Grid2_volts arselect('Thy_Grid2_volts')];
        Thy_heater_volts = [Thy_heater_volts arselect('Thy_heater_volts')];
        Thy_heater_current = [Thy_heater_current arselect('Thy_heater_current')];
        Body_Current = [Body_Current arselect('Body_Current')];
        Temp_HV_enclose = [Temp_HV_enclose arselect('Temp_HV_enclose')];
        Temp_IOT_enclose = [Temp_IOT_enclose arselect('Temp_IOT_enclose')];
        Temp_IOT_cooling = [Temp_IOT_cooling arselect('Temp_IOT_cooling')];
        Temp_ceramic_output = [Temp_ceramic_output arselect('Temp_ceramic_output')];
        BR_CLDFWD = [BR_CLDFWD arselect('BR4_____CLDFWD_AM00')];
        BR_WGREV = [BR_WGREV arselect('BR4_____WGREV__AM01')];
        BR_WGFWD = [BR_WGFWD arselect('BR4_____WGFWD__AM02')];
        BR_RFCONT = [BR_RFCONT arselect('BR4_____RFCONT_AM01')];
        BR_PHSCON_AM = [BR_PHSCON_AM arselect('BR4_____PHSCON_AM00')];
        BR_PHSCON_AC = [BR_PHSCON_AC arselect('BR4_____PHSCON_AC00')];
        BR_TUNPOS = [BR_TUNPOS arselect('BR4_____TUNPOS_AM00')];
        BR_TUNERR = [BR_TUNERR arselect('BR4_____TUNERR_AM02')];
        BR_CAVTMP = [BR_CAVTMP arselect('BR4_____CAVTMP_AM03')];
        BR_LCWTMP = [BR_LCWTMP arselect('BR4_____LCWTMP_AM03')];
        BR_CLDFLW = [BR_CLDFLW arselect('BR4_____CLDFLW_AM01')];
        BR_CIRFLW = [BR_CIRFLW arselect('BR4_____CIRFLW_AM02')];
        BR_SLDTMP = [BR_SLDTMP arselect('BR4_____SLDTMP_AM01')];
        BR_CIRTMP = [BR_CIRTMP arselect('BR4_____CIRTMP_AM03')];
        BR_SLDFLW = [BR_SLDFLW arselect('BR4_____SLDFLW_AM00')];
        BR_CLDTMP = [BR_CLDTMP arselect('BR4_____CLDTMP_AM03')];
        BR_CAVFLW = [BR_CAVFLW arselect('BR4_____CAVFLW_AM00')];
        BR_WINFLW = [BR_WINFLW arselect('BR4_____WINFLW_AM01')];
        BR_TUNFLW = [BR_TUNFLW arselect('BR4_____TUNFLW_AM02')];
        
        % SR Klystron 2 parameters
        SR_CATHVT = [SR_CATHVT arselect(CATHVname)];
        SR_HVPSI = [SR_HVPSI arselect(HVPSIname)];
        SR_MAVOLT = [SR_MAVOLT arselect(MAVOLTname)];
        SR_MACURR = [SR_MACURR arselect(MACURRname)];
        SR_HTRVLT = [SR_HTRVLT arselect(HTRVLTname)];
        SR_HTRCUR = [SR_HTRCUR arselect(HTRCURname)];
        SR_RFAMP = [SR_RFAMP arselect('SR03S___RFAMP__AM01')];
        SR_HVPSV = [SR_HVPSV arselect(HVPSVname)];
        SR_IP1CUR = [SR_IP1CUR arselect(IP1name)];
        SR_IP2CUR = [SR_IP2CUR arselect(IP2name)];
        
        user_beam = [user_beam arselect('sr:user_beam')];
        
        % Beamline shutters
        tmp = arselect('B021_PSS201_OPN');
        if isempty(tmp)
            B021_PSS201_OPN = NaN * ones(1,length(ARt));
        end
        B021_PSS201_OPN = [B021_PSS201_OPN tmp];
        B03_11_PSS1_RSS_TRLY_OPN = [B03_11_PSS1_RSS_TRLY_OPN arselect('B03_11_PSS1_RSS_TRLY_OPN')];
        B03_2_PSS101_RSS_TRLY_OPN = [B03_2_PSS101_RSS_TRLY_OPN arselect('B03_2_PSS101_RSS_TRLY_OPN')];
        B03_2_PSS201_RSS_TRLY_OPN = [B03_2_PSS201_RSS_TRLY_OPN arselect('B03_2_PSS201_RSS_TRLY_OPN')];
        B03_3_PSS101_RSS_TRLY_OPN = [B03_3_PSS101_RSS_TRLY_OPN arselect('B03_3_PSS101_RSS_TRLY_OPN')];
        B03_3_PSS201_RSS_TRLY_OPN = [B03_3_PSS201_RSS_TRLY_OPN arselect('B03_3_PSS201_RSS_TRLY_OPN')];
        B040_PSS002_RSS_TRLY_OPN = [B040_PSS002_RSS_TRLY_OPN arselect('B040_PSS201_RSS_TRLY_OPN')];
        B040_PSS001_RSS_TRLY_OPN = [B040_PSS001_RSS_TRLY_OPN arselect('B040_PSS301_RSS_TRLY_OPN')];
        ICS_BL042_PSS101_RSS_TRLY_OP = [ICS_BL042_PSS101_RSS_TRLY_OP arselect('ICS_BL042_PSS101_RSS_TRLY_OP',1)];
        ICS_BL042_PSS201_RSS_TRLY_OP = [ICS_BL042_PSS201_RSS_TRLY_OP arselect('ICS_BL042_PSS201_RSS_TRLY_OP',1)];
        ICS_BL043_PSS101_RSS_TRLY_OP = [ICS_BL043_PSS101_RSS_TRLY_OP arselect('ICS_BL043_PSS101_RSS_TRLY_OP',1)];
        ICS_BL043_PSS201_RSS_TRLY_OP = [ICS_BL043_PSS201_RSS_TRLY_OP arselect('ICS_BL043_PSS201_RSS_TRLY_OP',1)];
        B050_PSS001_RSS_TRLY_OPN = [B050_PSS001_RSS_TRLY_OPN arselect('B050_PSS001_RSS_TRLY_OPN')];
        B050_PSS101_OPN = [B050_PSS101_OPN arselect('BL50_PSS101_OPN')];
        B050_PSS201_OPN = [B050_PSS201_OPN arselect('BL50_PSS201_OPN')];
        B050_PSS301_OPN = [B050_PSS301_OPN arselect('BL50_PSS301_OPN')];
        B050_PSS111_OPN = [B050_PSS111_OPN arselect('BL50_PSS111_OPN')];
        B050_PSS211_OPN = [B050_PSS211_OPN arselect('BL50_PSS211_OPN')];
        B050_PSS311_OPN = [B050_PSS311_OPN arselect('BL50_PSS311_OPN')];
        B053_PSS101_RSS_TRLY_OPN = [B053_PSS101_RSS_TRLY_OPN arselect('B053_PSS101_RSS_TRLY_OPN')];
        B053_PSS201_RSS_TRLY_OPN = [B053_PSS201_RSS_TRLY_OPN arselect('B053_PSS201_RSS_TRLY_OPN')];
        B060_PSS101_OPN = [B060_PSS101_OPN arselect('B060_PSS101_OPN')];
        B060_PSS202_OPN = [B060_PSS202_OPN arselect('B060_PSS202_OPN')];
        B0612_PSS1_OPN = [B0612_PSS1_OPN arselect('B0612_PSS1_OPN')];
        B0631_PSS1_OPN = [B0631_PSS1_OPN arselect('B0631_PSS1_OPN')];
        B0632_PSS1_OPN = [B0632_PSS1_OPN arselect('B0632_PSS1_OPN')];
        B0702_PSS1_RSS_TRLY_OPN = [B0702_PSS1_RSS_TRLY_OPN arselect('B0702_PSS1_RSS_TRLY_OPN')];
        B073_PSS1_RSS_TRLY_OPN = [B073_PSS1_RSS_TRLY_OPN arselect('B073_PSS1_RSS_TRLY_OPN')];
        B0733_PSS1_OPN = [B0733_PSS1_OPN arselect('B0733_PSS1_OPN')];
        ICS_B0801_PSS1_RSS_TRLY_OPN = [ICS_B0801_PSS1_RSS_TRLY_OPN arselect('ICS_B0801_PSS1_RSS_TRLY_OPN')];
        ICS_B082_PSS101_RSS_TRLY_OP = [ICS_B082_PSS101_RSS_TRLY_OP arselect('ICS_B082_PSS101_RSS_TRLY_OPN')];
        ICS_B082_PSS201_RSS_TRLY_OP = [ICS_B082_PSS201_RSS_TRLY_OP arselect('ICS_B082_PSS201_RSS_TRLY_OPN')];
        ICS_B083_PSS101_RSS_TRLY_OP = [ICS_B083_PSS101_RSS_TRLY_OP arselect('ICS_B083_PSS101_RSS_TRLY_OPN')];
        ICS_B083_PSS201_RSS_TRLY_OP = [ICS_B083_PSS201_RSS_TRLY_OP arselect('ICS_B083_PSS201_RSS_TRLY_OPN')];
        B090_PSS1_RSS_TRLY_OPN = [B090_PSS1_RSS_TRLY_OPN arselect('B090_PSS1_RSS_TRLY_OPN')];
        B09_31_PSS1_RSS_TRLY_OPN = [B09_31_PSS1_RSS_TRLY_OPN arselect('B09_31_PSS1_RSS_TRLY_OPN')];
        B09_3_PSS1_RSS_TRLY_OPN = [B09_3_PSS1_RSS_TRLY_OPN arselect('B09_3_PSS1_RSS_TRLY_OPN')];
        B10_0_PSS001_RSS_TRLY_OPN = [B10_0_PSS001_RSS_TRLY_OPN arselect('B10_0_PSS001_RSS_TRLY_OPN')];
        B10_31_PSS1_RSS_TRLY_OPN = [B10_31_PSS1_RSS_TRLY_OPN arselect('B10_31_PSS1_RSS_TRLY_OPN')];
        B110_PSS101_RSS_TRLY_OPN = [B110_PSS101_RSS_TRLY_OPN arselect('B110_PSS101_RSS_TRLY_OPN')];
        B110_PSS201_RSS_TRLY_OPN = [B110_PSS201_RSS_TRLY_OPN arselect('B110_PSS201_RSS_TRLY_OPN')];
        BL113_PSS101_RSS_TRLY_OPN = [BL113_PSS101_RSS_TRLY_OPN arselect('BL113_PSS101_RSS_TRLY_OPN')];
        BL113_PSS201_RSS_TRLY_OPN = [BL113_PSS201_RSS_TRLY_OPN arselect('BL113_PSS201_RSS_TRLY_OPN')];
        ICS_BL12_0_PSS1_RSS_TRLY_OPN = [ICS_BL12_0_PSS1_RSS_TRLY_OPN arselect('ICS_BL12_0_PSS1_RSS_TRLY_OPN')];
        ICS_BL12_2_PSS101_RSS_TRLY_O = [ICS_BL12_2_PSS101_RSS_TRLY_O arselect('ICS_BL12_2_PSS101_RSS_TRLY_O',1)];
        ICS_BL12_2_PSS201_RSS_TRLY_O = [ICS_BL12_2_PSS201_RSS_TRLY_O arselect('ICS_BL12_2_PSS201_RSS_TRLY_O',1)];
        ICS_BL12_3_PSS101_RSS_TRLY_O = [ICS_BL12_3_PSS101_RSS_TRLY_O arselect('ICS_BL12_3_PSS101_RSS_TRLY_O',1)];
        ICS_BL12_3_PSS201_RSS_TRLY_O = [ICS_BL12_3_PSS201_RSS_TRLY_O arselect('ICS_BL12_3_PSS201_RSS_TRLY_O',1)];
        B122_PSS111_OPN = [B122_PSS111_OPN arselect('B122_PSS111_OPN')];
        B122_PSS211_OPN = [B122_PSS211_OPN arselect('B122_PSS211_OPN')];
        B123_PSS111_OPN = [B123_PSS111_OPN arselect('B123_PSS111_OPN')];
        B123_PSS211_OPN = [B123_PSS211_OPN arselect('B123_PSS211_OPN')];
        
        % Wago temperature monitors
        SR06C_TCWAGO_AM20 = [SR06C_TCWAGO_AM20 arselect('SR06C___TCWAGO_AM20')];
        SR06C_TCWAGO_AM24 = [SR06C_TCWAGO_AM24 arselect('SR06C___TCWAGO_AM24')];
        SR06C_TCWAGO_AM25 = [SR06C_TCWAGO_AM25 arselect('SR06C___TCWAGO_AM25')];
        SR06C_TCWAGO_AM26 = [SR06C_TCWAGO_AM26 arselect('SR06C___TCWAGO_AM26')];
        SR06C_TCWAGO_AM27 = [SR06C_TCWAGO_AM27 arselect('SR06C___TCWAGO_AM27')];
        SR06C_TCWAGO_AM35 = [SR06C_TCWAGO_AM35 arselect('SR06C___TCWAGO_AM35')];
        
        % time vector
        %       t = [t  ARt+(day-StartDay)*24*60*60];
        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        
    end
    tmp = toc;
    ar_functions_time = ar_functions_time + tmp;
    fprintf('One day of arselect = %g s\n',tmp);
    tic;
end
fprintf('  %.1f seconds to arread and arselect data\n', ar_functions_time);


%%%%%%%%%%%%%%%%%%
% Condition Data %
%%%%%%%%%%%%%%%%%%

if size(LCWSupTemp,1)>1
    LCWSupTemp=mean(LCWSupTemp);
end
if size(LCWRetTemp,1)>1
    LCWRetTemp=mean(LCWRetTemp);
end

%dcct = 100*dcct;

% Remove points when current is below 1 mamps
[y, i]=find(dcct<1);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
ID9BPM1xRMS(i)=NaN;
ID9BPM1yRMS(i)=NaN;
ID9BPM2xRMS(i)=NaN;
ID9BPM2yRMS(i)=NaN;
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
% SigX(i)=NaN;
% SigY(i)=NaN;
SigX31(i)=NaN;
SigY31(i)=NaN;
SigX72(i)=NaN;
SigY72(i)=NaN;
SpiroX(i)=NaN;
SpiroY(i)=NaN;
gev(i)=NaN;
lifetime(i)=NaN;
lifetime2(i)=NaN;
lifetime3(i) = NaN;
inj_eff(i)=NaN;
inj_rate(i)=NaN;
HPsyn(i)=NaN;
hqmofm(i)=NaN;
HPcounter(i)=NaN;
HPcounter_precise(i)=NaN;

% Remove points when the current is below .5 mamps for the lifetime calculation
i = find(dcct < .5);
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime1 = -diff(t/60/60)./(dlogdcct);
i = find(lifetime1 < 0);
lifetime1(i) = NaN;
% lifetime2(i) = NaN;

i = find(i_cam < .5);
i_cam(i) = NaN;

% dlogcam = mean([diff(log(i_cam(1:(end-9))));diff(log(i_cam(2:(end-8)))); ...
%        diff(log(i_cam(3:(end-7))));diff(log(i_cam(4:(end-6)))); ...
%        diff(log(i_cam(5:(end-5))));diff(log(i_cam(6:(end-4)))); ...
%        diff(log(i_cam(7:(end-3))));diff(log(i_cam(8:(end-2)))); ...
%        diff(log(i_cam(9:(end-1))));diff(log(i_cam(10:end)))],1);

% commented out since camshaft lifetime now comes from Christoph's getlife_topoff.m routine
% logcam = log(i_cam);lifetime3=[];
%
% tic;
% for loop = 1:(length(logcam)-15)
%     fitpar = polyfit(t(loop:(loop+15))/60/60,logcam(loop:(loop+15)),1);
%     stdfit = std(logcam(loop:(loop+15))-polyval(fitpar,t(loop:(loop+15))/60/60));
%     remindex = find(abs(logcam(loop:(loop+15))-polyval(fitpar,t(loop:(loop+15))/60/60))>2.5*stdfit);
%     logcam(loop+remindex-1)=NaN;
%     fitpar = polyfit(t(loop:(loop+15))/60/60,logcam(loop:(loop+15)),1);
%     lifetime3(loop) = -1/fitpar(1);
% end
% cam_fit_time = toc;
%fprintf('  %.1f seconds to fit cam bucket lifetime\n', cam_fit_time);

% lifetime2 = -(diff(t(1:(end-9)))/60/60)./(dlogcam);
i = find(lifetime3 < 0);
lifetime3(i) = NaN;


% Remove points when FF is disabled
if FFFlag
    [y, i] = find(FF8Enable==0);
    BPMx(:,i) = NaN;
    BPMy(:,i) = NaN;
    ID9BPM1xRMS(i)=NaN;
    ID9BPM1yRMS(i)=NaN;
    ID9BPM2xRMS(i)=NaN;
    ID9BPM2yRMS(i)=NaN;
    %dcct(i)=NaN*ones(size(i));
    EPU(:,i)=NaN;
    IDgap(:,i)=NaN;
    %     SigX(i)=NaN;
    %     SigY(i)=NaN;
    SigX31(i)=NaN;
    SigY31(i)=NaN;
    SigX72(i)=NaN;
    SigY72(i)=NaN;
    SpiroX(i)=NaN;
    SpiroY(i)=NaN;
    gev(i)=NaN;
    lifetime(i)=NaN;
    lifetime2(i)=NaN;
    lifetime3(i) = NaN;
    inj_eff(i)=NaN;
    inj_rate(i)=NaN;
    HPsyn(i)=NaN;
    hqmofm(i)=NaN;
    HPcounter(i)=NaN;
    HPcounter_precise(i)=NaN;
end

% Remove points when shutters are closed
if UserBeamFlag
    [y, i] = find(user_beam==0);
    BPMx(:,i) = NaN;
    BPMy(:,i) = NaN;
    ID9BPM1xRMS(i)=NaN;
    ID9BPM1yRMS(i)=NaN;
    ID9BPM2xRMS(i)=NaN;
    ID9BPM2yRMS(i)=NaN;
    %dcct(i)=NaN*ones(size(i));
    EPU(:,i)=NaN;
    IDgap(:,i)=NaN;
    %     SigX(i)=NaN;
    %     SigY(i)=NaN;
    SigX31(i)=NaN;
    SigY31(i)=NaN;
    SigX72(i)=NaN;
    SigY72(i)=NaN;
    SpiroX(i)=NaN;
    SpiroY(i)=NaN;
    gev(i)=NaN;
    lifetime(i)=NaN;
    lifetime2(i)=NaN;
    lifetime3(i) = NaN;
    inj_eff(i)=NaN;
    inj_rate(i)=NaN;
    HPsyn(i)=NaN;
    hqmofm(i)=NaN;
    HPcounter(i)=NaN;
    HPcounter_precise(i)=NaN;
end

% Remove points when the gaps are open
if GapOpenFlag
    % j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
    %j = any(IDgap < 80); % was 80 before IVID
    j = any(IDgap < 29); %changed from 37 10-10-05 because we were running IVID at 30mm permanently for a while
    i = 1:length(t);
    i(j) = [];
    BPMx(:,i) = NaN;
    BPMy(:,i) = NaN;
    ID9BPM1xRMS(i)=NaN;
    ID9BPM1yRMS(i)=NaN;
    ID9BPM2xRMS(i)=NaN;
    ID9BPM2yRMS(i)=NaN;
    %dcct(i)=NaN;
    EPU(:,i)=NaN;
    IDgap(:,i)=NaN;
    %     SigX(i)=NaN;
    %     SigY(i)=NaN;
    SigX31(i)=NaN;
    SigY31(i)=NaN;
    SigX72(i)=NaN;
    SigY72(i)=NaN;
    SpiroX(i)=NaN;
    SpiroY(i)=NaN;
    gev(i)=NaN;
    lifetime(i)=NaN;
    lifetime2(i)=NaN;
    lifetime3(i) = NaN;
    inj_eff(i)=NaN;
    inj_rate(i)=NaN;
    HPsyn(i)=NaN;
    hqmofm(i)=NaN;
    HPcounter(i)=NaN;
    HPcounter_precise(i)=NaN;
end


% Remove points after a NaN (based on BPMx, which is filtered to NaN during fills...)
[y, i]=find(isnan(BPMx(1,:)));
i = i + 1;
if ~isempty(i)
    if i(end) > size(BPMx,2)
        i = i(1:end-1);
    end
end
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
ID9BPM1xRMS(i)=NaN;
ID9BPM1yRMS(i)=NaN;
ID9BPM2xRMS(i)=NaN;
ID9BPM2yRMS(i)=NaN;
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
% SigX(i)=NaN;
% SigY(i)=NaN;
SigX31(i)=NaN;
SigY31(i)=NaN;
SigX72(i)=NaN;
SigY72(i)=NaN;
SpiroX(i)=NaN;
SpiroY(i)=NaN;
gev(i)=NaN;
lifetime(i)=NaN;
lifetime2(i)=NaN;
lifetime3(i) = NaN;
inj_eff(i)=NaN;
inj_rate(i)=NaN;
HPsyn(i)=NaN;
hqmofm(i)=NaN;
HPcounter(i)=NaN;

% Remove points before a NaN (based on BPMx, which is filtered to NaN during fills...)
i = i - 2;
if ~isempty(i)
    if i(1) < 1
        i = i(2:end);
    end
end
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;
ID9BPM1xRMS(i)=NaN;
ID9BPM1yRMS(i)=NaN;
ID9BPM2xRMS(i)=NaN;
ID9BPM2yRMS(i)=NaN;
%dcct(i)=NaN*ones(size(i));
%EPU(:,i)=NaN*ones(2,length(i));
%IDgap(:,i)=NaN*ones(size(IDgap,1),length(i));
% SigX(i)=NaN;
% SigY(i)=NaN;
SigX31(i)=NaN;
SigY31(i)=NaN;
SigX72(i)=NaN;
SigY72(i)=NaN;
SpiroX(i)=NaN;
SpiroY(i)=NaN;
gev(i)=NaN;
lifetime(i)=NaN;
lifetime2(i)=NaN;
lifetime3(i) = NaN;
inj_eff(i)=NaN;
inj_rate(i)=NaN;
HPsyn(i)=NaN;
hqmofm(i)=NaN;
HPcounter(i)=NaN;
HPcounter_precise(i)=NaN;
MOCounter_FREQ(i)=NaN;

% remove HPCounter errant data
[y, i]=find(HPcounter<400);
HPcounter(i)=NaN;
HPcounter_precise(i)=NaN;

% remove when T>55 (this usually indicates work on system - trip is at 33)
[y, i]=find(TC8_1>55 | TC8_2>55 | TC8_3>55 | TC8_4>55 | TC9_1>55 | TC9_2>55 | TC9_3>55 | TC9_4>55 | TC10_1>55 | TC10_2>55 | TC10_3>55 | TC10_4>55 | TC12_1>55 | TC12_2>55 | TC12_3>55 | TC12_4>55);
% TC7_1(i)=NaN;
% TC7_2(i)=NaN;
% TC7_3(i)=NaN;
% TC7_4(i)=NaN;
TC8_1(i)=NaN;
TC8_2(i)=NaN;
TC8_3(i)=NaN;
TC8_4(i)=NaN;
TC9_1(i)=NaN;
TC9_2(i)=NaN;
TC9_3(i)=NaN;
TC9_4(i)=NaN;
TC10_1(i)=NaN;
TC10_2(i)=NaN;
TC10_3(i)=NaN;
TC10_4(i)=NaN;
TC12_1(i)=NaN;
TC12_2(i)=NaN;
TC12_3(i)=NaN;
TC12_4(i)=NaN;

% remove points around zero temperture readings (these happen during facilities backups)
[y, i]=find(TCSR01<5 | TCSR02<5 | TCSR03<5 | TCSR04<5| TCSR06<5 | TCSR07<5 | TCSR08<5 | TCSR09<5 | TCSR11<5 | TCSR12<5 | TCSRAVG<5);
TCSR01(i)=NaN;
TCSR02(i)=NaN;
TCSR03(i)=NaN;
TCSR04(i)=NaN;
TCSR05(i)=NaN;
TCSR06(i)=NaN;
TCSR07(i)=NaN;
TCSR08(i)=NaN;
TCSR09(i)=NaN;
TCSR11(i)=NaN;
TCSR12(i)=NaN;
TCSRAVG(i)=NaN;
AHUT01(i)=NaN;
AHUT03(i)=NaN;
AHUT04(i)=NaN;
AHUT06(i)=NaN;
AHUT07(i)=NaN;
AHUT08(i)=NaN;
AHUT09(i)=NaN;
AHUT11(i)=NaN;
WVSRM(i)=NaN;
CWTemp(i)=NaN;
CWValve(i)=NaN;

%[y, i]=find(LCWSupPx<5 | LCWRetPx <5 | LCWSupTemp<5 | LCWRetTemp<5 | WBasinTemp<5 | EBasinTemp<5 | CWTemp < 5);
%next line temporary filter until facilities channels are fixed - 2004-03-23 T.Scarvie
[y, i]=find(LCWSupPx<5 | LCWRetPx <5 | LCWRetTemp<5 | CWTemp < 5);
LCWSupPx(i)=NaN;  % PSI
LCWRetPx(i)=NaN;
LCWSupTemp(i)=NaN;
LCWRetTemp(i)=NaN;
WBasinTemp(i)=NaN;
EBasinTemp(i)=NaN;
CWTemp(i)=NaN;

% Convert to celcius
LCWSupTemp = (LCWSupTemp-32)*5/9;
LCWRetTemp = (LCWRetTemp-32)*5/9;
TRWSupTemp = (TRWSupTemp-32)*5/9;
TRWRetTemp = (TRWRetTemp-32)*5/9;
WBasinTemp = (WBasinTemp-32)*5/9;
EBasinTemp = (EBasinTemp-32)*5/9;
CWTemp     = (CWTemp-32)*5/9;

% Convert Wago temperature monitors to degF
SR06C_TCWAGO_AM20 = SR06C_TCWAGO_AM20*9/5+32;
SR06C_TCWAGO_AM24 = SR06C_TCWAGO_AM24*9/5+32;
SR06C_TCWAGO_AM25 = SR06C_TCWAGO_AM25*9/5+32;
SR06C_TCWAGO_AM26 = SR06C_TCWAGO_AM26*9/5+32;
SR06C_TCWAGO_AM27 = SR06C_TCWAGO_AM27*9/5+32;
SR06C_TCWAGO_AM35 = SR06C_TCWAGO_AM35*9/5+32;

% Subtract known amount (golden orbit)
BPMx = BPMx-getgolden('BPMx', BPMlist)*ones(1,size(BPMx,2));
BPMy = BPMy-getgolden('BPMy', BPMlist)*ones(1,size(BPMy,2));

% Find the tune shift due to insertion devices
TuneShift = zeros(size(IDgap(1,:)));
ind5 = find(IDlist(:,1) == 5);              % remove sector 5
for i = 1:size(IDlist,1)
    if ~any(i==ind5)
        TuneShift = TuneShift + gap2tune(IDlist(i,:), IDgap(i,:), gev);
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
dcct(SANum)=NaN;
% TC7_1(SANum)=NaN;
% TC7_2(SANum)=NaN;
% TC7_3(SANum)=NaN;
% TC7_4(SANum)=NaN;
TC8_1(SANum)=NaN;
TC8_2(SANum)=NaN;
TC8_3(SANum)=NaN;
TC8_4(SANum)=NaN;
TC9_1(SANum)=NaN;
TC9_2(SANum)=NaN;
TC9_3(SANum)=NaN;
TC9_4(SANum)=NaN;
TC10_1(SANum)=NaN;
TC10_2(SANum)=NaN;
TC10_3(SANum)=NaN;
TC10_4(SANum)=NaN;
TC12_1(SANum)=NaN;
TC12_2(SANum)=NaN;
TC12_3(SANum)=NaN;
TC12_4(SANum)=NaN;
TCSR01(SANum)=NaN;
TCSR02(SANum)=NaN;
TCSR03(SANum)=NaN;
TCSR04(SANum)=NaN;
TCSR05(SANum)=NaN;
TCSR06(SANum)=NaN;
TCSR07(SANum)=NaN;
TCSR08(SANum)=NaN;
TCSR09(SANum)=NaN;
TCSR11(SANum)=NaN;
TCSR12(SANum)=NaN;
TCSRAVG(SANum)=NaN;
AHUT01(SANum)=NaN;
AHUT03(SANum)=NaN;
AHUT04(SANum)=NaN;
AHUT06(SANum)=NaN;
AHUT07(SANum)=NaN;
AHUT08(SANum)=NaN;
AHUT09(SANum)=NaN;
AHUT11(SANum)=NaN;
WVSRM(SANum)=NaN;
CWTemp(SANum)=NaN;
CWValve(SANum)=NaN;
LCWSupPx(SANum)=NaN;
LCWRetPx(SANum)=NaN;
RingLCWSupPx(SANum)=NaN;
RingLCWRetPx(SANum)=NaN;
LCWSupTemp(SANum)=NaN;
LCWRetTemp(SANum)=NaN;
WBasinTemp(SANum)=NaN;
EBasinTemp(SANum)=NaN;
CWTemp(i)=NaN;
C1TEMP(SANum)=NaN;
C2TEMP(SANum)=NaN;
lcw(SANum)=NaN;
SR01Girder(SANum)=NaN;
SR02Girder(SANum)=NaN;
SR03Girder(SANum)=NaN;
SR04Girder(SANum)=NaN;
SR05Girder(SANum)=NaN;
SR06Girder(SANum)=NaN;
SR07Girder(SANum)=NaN;
SR08Girder(SANum)=NaN;
SR09Girder(SANum)=NaN;
SR10Girder(SANum)=NaN;
SR11Girder(SANum)=NaN;
SR12Girder(SANum)=NaN;
SR01Rack(SANum)=NaN;
SR02Rack(SANum)=NaN;
SR03Rack(SANum)=NaN;
SR04Rack(SANum)=NaN;
SR05Rack(SANum)=NaN;
SR06Rack(SANum)=NaN;
SR07Rack(SANum)=NaN;
SR08Rack(SANum)=NaN;
SR09Rack(SANum)=NaN;
SR10Rack(SANum)=NaN;
SR11Rack(SANum)=NaN;
SR12Rack(SANum)=NaN;
SR04PST4(SANum)=NaN;
SR04PST5(SANum)=NaN;
SR04PST6(SANum)=NaN;
SR08PST4(SANum)=NaN;
SR08PST5(SANum)=NaN;
SR08PST6(SANum)=NaN;
SR12PST4(SANum)=NaN;
SR12PST5(SANum)=NaN;
SR12PST6(SANum)=NaN;
Power_RF_fwd(SANum)=NaN;
Power_RF_ref(SANum)=NaN;
Power_drive(SANum)=NaN;
HV_setpoint(SANum)=NaN;
Beam_volts(SANum)=NaN;
Beam_current(SANum)=NaN;
Bias_volts(SANum)=NaN;
Bias_current(SANum)=NaN;
Heater_Voltage(SANum)=NaN;
Heater_current(SANum)=NaN;
Focus_voltage(SANum)=NaN;
Focus_current(SANum)=NaN;
VacIon_voltage(SANum)=NaN;
VacIon_current(SANum)=NaN;
Thy_Grid1_volts(SANum)=NaN;
Thy_Grid2_volts(SANum)=NaN;
Thy_heater_volts(SANum)=NaN;
Thy_heater_current(SANum)=NaN;
Body_Current(SANum)=NaN;
Temp_HV_enclose(SANum)=NaN;
Temp_IOT_enclose(SANum)=NaN;
Temp_IOT_cooling(SANum)=NaN;
Temp_ceramic_output(SANum)=NaN;
BR_CLDFWD(SANum)=NaN;
BR_WGREV(SANum)=NaN;
BR_WGFWD(SANum)=NaN;
BR_RFCONT(SANum)=NaN;
BR_PHSCON_AM(SANum)=NaN;
BR_PHSCON_AC(SANum)=NaN;
BR_TUNPOS(SANum)=NaN;
BR_TUNERR(SANum)=NaN;
BR_CAVTMP(SANum)=NaN;
BR_LCWTMP(SANum)=NaN;
BR_CLDFLW(SANum)=NaN;
BR_CIRFLW(SANum)=NaN;
BR_SLDTMP(SANum)=NaN;
BR_CIRTMP(SANum)=NaN;
BR_SLDFLW(SANum)=NaN;
BR_CLDTMP(SANum)=NaN;
BR_CAVFLW(SANum)=NaN;
BR_WINFLW(SANum)=NaN;
BR_TUNFLW(SANum)=NaN;
SR06C_TCWAGO_AM20(SANum)=NaN;
SR06C_TCWAGO_AM24(SANum)=NaN;
SR06C_TCWAGO_AM25(SANum)=NaN;
SR06C_TCWAGO_AM26(SANum)=NaN;
SR06C_TCWAGO_AM27(SANum)=NaN;
SR06C_TCWAGO_AM35(SANum)=NaN;

% Remove zero sigmas
% SigX(find(SigX==0)) = NaN;
% SigY(find(SigY==0)) = NaN;

% Remove unrealistic data
LCWSupTemp(find(LCWSupTemp<15)) = NaN;
LCWRetTemp(find(LCWRetTemp<15)) = NaN;
WBasinTemp(find(WBasinTemp<15)) = NaN;
EBasinTemp(find(EBasinTemp<15)) = NaN;

% filter BL shutters: change NaN's to zeros (NaN + number is always NaN)
B021_PSS201_OPN(:,find(isnan(B021_PSS201_OPN)))=0;
B021_PSS201_OPN(:,find(B021_PSS201_OPN>1))=0;
B03_11_PSS1_RSS_TRLY_OPN(:,find(isnan(B03_11_PSS1_RSS_TRLY_OPN)))=0;
B03_11_PSS1_RSS_TRLY_OPN(:,find(B03_11_PSS1_RSS_TRLY_OPN>1))=0;
B03_2_PSS101_RSS_TRLY_OPN(:,find(isnan(B03_2_PSS101_RSS_TRLY_OPN)))=0;
B03_2_PSS101_RSS_TRLY_OPN(:,find(B03_2_PSS101_RSS_TRLY_OPN>1))=0;
B03_2_PSS201_RSS_TRLY_OPN(:,find(isnan(B03_2_PSS201_RSS_TRLY_OPN)))=0;
B03_2_PSS201_RSS_TRLY_OPN(:,find(B03_2_PSS201_RSS_TRLY_OPN>1))=0;
B03_3_PSS101_RSS_TRLY_OPN(:,find(isnan(B03_3_PSS101_RSS_TRLY_OPN)))=0;
B03_3_PSS101_RSS_TRLY_OPN(:,find(B03_3_PSS101_RSS_TRLY_OPN>1))=0;
B03_3_PSS201_RSS_TRLY_OPN(:,find(isnan(B03_3_PSS201_RSS_TRLY_OPN)))=0;
B03_3_PSS201_RSS_TRLY_OPN(:,find(B03_3_PSS201_RSS_TRLY_OPN>1))=0;
B040_PSS002_RSS_TRLY_OPN(:,find(isnan(B040_PSS002_RSS_TRLY_OPN)))=0;
B040_PSS002_RSS_TRLY_OPN(:,find(B040_PSS002_RSS_TRLY_OPN>1))=0;
B040_PSS001_RSS_TRLY_OPN(:,find(isnan(B040_PSS001_RSS_TRLY_OPN)))=0;
B040_PSS001_RSS_TRLY_OPN(:,find(B040_PSS001_RSS_TRLY_OPN>1))=0;
ICS_BL042_PSS101_RSS_TRLY_OP(:,find(isnan(ICS_BL042_PSS101_RSS_TRLY_OP)))=0;
ICS_BL042_PSS101_RSS_TRLY_OP(:,find(ICS_BL042_PSS101_RSS_TRLY_OP>1))=0;
ICS_BL042_PSS201_RSS_TRLY_OP(:,find(isnan(ICS_BL042_PSS201_RSS_TRLY_OP)))=0;
ICS_BL042_PSS201_RSS_TRLY_OP(:,find(ICS_BL042_PSS201_RSS_TRLY_OP>1))=0;
ICS_BL043_PSS101_RSS_TRLY_OP(:,find(isnan(ICS_BL043_PSS101_RSS_TRLY_OP)))=0;
ICS_BL043_PSS101_RSS_TRLY_OP(:,find(ICS_BL043_PSS101_RSS_TRLY_OP>1))=0;
ICS_BL043_PSS201_RSS_TRLY_OP(:,find(isnan(ICS_BL043_PSS201_RSS_TRLY_OP)))=0;
ICS_BL043_PSS201_RSS_TRLY_OP(:,find(ICS_BL043_PSS201_RSS_TRLY_OP>1))=0;
B050_PSS001_RSS_TRLY_OPN(:,find(isnan(B050_PSS001_RSS_TRLY_OPN)))=0;
B050_PSS001_RSS_TRLY_OPN(:,find(B050_PSS001_RSS_TRLY_OPN>1))=0;
B050_PSS101_OPN(:,find(isnan(B050_PSS101_OPN)))=0;
B050_PSS101_OPN(:,find(B050_PSS101_OPN>1))=0;
B050_PSS201_OPN(:,find(isnan(B050_PSS201_OPN)))=0;
B050_PSS201_OPN(:,find(B050_PSS201_OPN>1))=0;
B050_PSS301_OPN(:,find(isnan(B050_PSS301_OPN)))=0;
B050_PSS301_OPN(:,find(B050_PSS301_OPN>1))=0;
B050_PSS111_OPN(:,find(isnan(B050_PSS111_OPN)))=0;
B050_PSS111_OPN(:,find(B050_PSS111_OPN>1))=0;
B050_PSS211_OPN(:,find(isnan(B050_PSS211_OPN)))=0;
B050_PSS211_OPN(:,find(B050_PSS211_OPN>1))=0;
B050_PSS311_OPN(:,find(isnan(B050_PSS311_OPN)))=0;
B050_PSS311_OPN(:,find(B050_PSS311_OPN>1))=0;
B053_PSS101_RSS_TRLY_OPN(:,find(isnan(B053_PSS101_RSS_TRLY_OPN)))=0;
B053_PSS101_RSS_TRLY_OPN(:,find(B053_PSS101_RSS_TRLY_OPN>1))=0;
B053_PSS201_RSS_TRLY_OPN(:,find(isnan(B053_PSS201_RSS_TRLY_OPN)))=0;
B053_PSS201_RSS_TRLY_OPN(:,find(B053_PSS201_RSS_TRLY_OPN>1))=0;
B060_PSS101_OPN(:,find(isnan(B060_PSS101_OPN)))=0;
B060_PSS101_OPN(:,find(B060_PSS101_OPN>1))=0;
B060_PSS202_OPN(:,find(isnan(B060_PSS202_OPN)))=0;
B060_PSS202_OPN(:,find(B060_PSS202_OPN>1))=0;
B0612_PSS1_OPN(:,find(isnan(B0612_PSS1_OPN)))=0;
B0612_PSS1_OPN(:,find(B0612_PSS1_OPN>1))=0;
B0631_PSS1_OPN(:,find(isnan(B0631_PSS1_OPN)))=0;
B0631_PSS1_OPN(:,find(B0631_PSS1_OPN>1))=0;
B0632_PSS1_OPN(:,find(isnan(B0632_PSS1_OPN)))=0;
B0632_PSS1_OPN(:,find(B0632_PSS1_OPN>1))=0;
B0702_PSS1_RSS_TRLY_OPN(:,find(isnan(B0702_PSS1_RSS_TRLY_OPN)))=0;
B0702_PSS1_RSS_TRLY_OPN(:,find(B0702_PSS1_RSS_TRLY_OPN>1))=0;
B073_PSS1_RSS_TRLY_OPN(:,find(isnan(B073_PSS1_RSS_TRLY_OPN)))=0;
B073_PSS1_RSS_TRLY_OPN(:,find(B073_PSS1_RSS_TRLY_OPN>1))=0;
B0733_PSS1_OPN(:,find(isnan(B0733_PSS1_OPN)))=0;
B0733_PSS1_OPN(:,find(B0733_PSS1_OPN>1))=0;
ICS_B0801_PSS1_RSS_TRLY_OPN(:,find(isnan(ICS_B0801_PSS1_RSS_TRLY_OPN)))=0;
ICS_B0801_PSS1_RSS_TRLY_OPN(:,find(ICS_B0801_PSS1_RSS_TRLY_OPN>1))=0;
ICS_B082_PSS101_RSS_TRLY_OP(:,find(isnan(ICS_B082_PSS101_RSS_TRLY_OP)))=0;
ICS_B082_PSS101_RSS_TRLY_OP(:,find(ICS_B082_PSS101_RSS_TRLY_OP>1))=0;
ICS_B082_PSS201_RSS_TRLY_OP(:,find(isnan(ICS_B082_PSS201_RSS_TRLY_OP)))=0;
ICS_B082_PSS201_RSS_TRLY_OP(:,find(ICS_B082_PSS201_RSS_TRLY_OP>1))=0;
ICS_B083_PSS101_RSS_TRLY_OP(:,find(isnan(ICS_B083_PSS101_RSS_TRLY_OP)))=0;
ICS_B083_PSS101_RSS_TRLY_OP(:,find(ICS_B083_PSS101_RSS_TRLY_OP>1))=0;
ICS_B083_PSS201_RSS_TRLY_OP(:,find(isnan(ICS_B083_PSS201_RSS_TRLY_OP)))=0;
ICS_B083_PSS201_RSS_TRLY_OP(:,find(ICS_B083_PSS201_RSS_TRLY_OP>1))=0;
%B082_PSS111_OPN(:,find(isnan(B082_PSS111_OPN)))=0;
%B082_PSS111_OPNfindnan(>1B082_PSS111_OPN))=0;
%B082_PSS211_OPN(:,find(isnan(B082_PSS211_OPN)))=0;
%B082_PSS211_OPNfindnan(>1B082_PSS211_OPN))=0;
%B083_PSS111_OPN(:,find(isnan(B083_PSS111_OPN)))=0;
%B083_PSS111_OPNfindnan(>1B083_PSS111_OPN))=0;
B090_PSS1_RSS_TRLY_OPN(:,find(isnan(B090_PSS1_RSS_TRLY_OPN)))=0;
B090_PSS1_RSS_TRLY_OPN(:,find(B090_PSS1_RSS_TRLY_OPN>1))=0;
B09_31_PSS1_RSS_TRLY_OPN(:,find(isnan(B09_31_PSS1_RSS_TRLY_OPN)))=0;
B09_31_PSS1_RSS_TRLY_OPN(:,find(B09_31_PSS1_RSS_TRLY_OPN>1))=0;
B09_3_PSS1_RSS_TRLY_OPN(:,find(isnan(B09_3_PSS1_RSS_TRLY_OPN)))=0;
B09_3_PSS1_RSS_TRLY_OPN(:,find(B09_3_PSS1_RSS_TRLY_OPN>1))=0;
B10_0_PSS001_RSS_TRLY_OPN(:,find(isnan(B10_0_PSS001_RSS_TRLY_OPN)))=0;
B10_0_PSS001_RSS_TRLY_OPN(:,find(B10_0_PSS001_RSS_TRLY_OPN>1))=0;
B10_31_PSS1_RSS_TRLY_OPN(:,find(isnan(B10_31_PSS1_RSS_TRLY_OPN)))=0;
B10_31_PSS1_RSS_TRLY_OPN(:,find(B10_31_PSS1_RSS_TRLY_OPN>1))=0;
B10_31_PSS1_RSS_TRLY_OPN(:,find(isnan(B10_31_PSS1_RSS_TRLY_OPN)))=0;
B10_31_PSS1_RSS_TRLY_OPN(:,find(B10_31_PSS1_RSS_TRLY_OPN>1))=0;
B110_PSS101_RSS_TRLY_OPN(:,find(isnan(B110_PSS101_RSS_TRLY_OPN)))=0;
B110_PSS101_RSS_TRLY_OPN(:,find(B110_PSS101_RSS_TRLY_OPN>1))=0;
B110_PSS201_RSS_TRLY_OPN(:,find(isnan(B110_PSS201_RSS_TRLY_OPN)))=0;
B110_PSS201_RSS_TRLY_OPN(:,find(B110_PSS201_RSS_TRLY_OPN>1))=0;
BL113_PSS101_RSS_TRLY_OPN(:,find(isnan(BL113_PSS101_RSS_TRLY_OPN)))=0;
BL113_PSS101_RSS_TRLY_OPN(:,find(BL113_PSS101_RSS_TRLY_OPN>1))=0;
BL113_PSS201_RSS_TRLY_OPN(:,find(isnan(BL113_PSS201_RSS_TRLY_OPN)))=0;
BL113_PSS201_RSS_TRLY_OPN(:,find(BL113_PSS201_RSS_TRLY_OPN>1))=0;
ICS_BL12_0_PSS1_RSS_TRLY_OPN(:,find(isnan(ICS_BL12_0_PSS1_RSS_TRLY_OPN)))=0;
ICS_BL12_0_PSS1_RSS_TRLY_OPN(:,find(ICS_BL12_0_PSS1_RSS_TRLY_OPN>1))=0;
ICS_BL12_2_PSS101_RSS_TRLY_O(:,find(isnan(ICS_BL12_2_PSS101_RSS_TRLY_O)))=0;
ICS_BL12_2_PSS101_RSS_TRLY_O(:,find(ICS_BL12_2_PSS101_RSS_TRLY_O>1))=0;
ICS_BL12_2_PSS201_RSS_TRLY_O(:,find(isnan(ICS_BL12_2_PSS201_RSS_TRLY_O)))=0;
ICS_BL12_2_PSS201_RSS_TRLY_O(:,find(ICS_BL12_2_PSS201_RSS_TRLY_O>1))=0;
ICS_BL12_3_PSS101_RSS_TRLY_O(:,find(isnan(ICS_BL12_3_PSS101_RSS_TRLY_O)))=0;
ICS_BL12_3_PSS101_RSS_TRLY_O(:,find(ICS_BL12_3_PSS101_RSS_TRLY_O>1))=0;
ICS_BL12_3_PSS201_RSS_TRLY_O(:,find(isnan(ICS_BL12_3_PSS201_RSS_TRLY_O)))=0;
ICS_BL12_3_PSS201_RSS_TRLY_O(:,find(ICS_BL12_3_PSS201_RSS_TRLY_O>1))=0;
B122_PSS111_OPN(:,find(isnan(B122_PSS111_OPN)))=0;
B122_PSS111_OPN(:,find(B122_PSS111_OPN>1))=0;
B122_PSS211_OPN(:,find(isnan(B122_PSS211_OPN)))=0;
B122_PSS211_OPN(:,find(B122_PSS211_OPN>1))=0;
B123_PSS111_OPN(:,find(isnan(B123_PSS111_OPN)))=0;
B123_PSS111_OPN(:,find(B123_PSS111_OPN>1))=0;
B123_PSS211_OPN(:,find(isnan(B123_PSS211_OPN)))=0;
B123_PSS211_OPN(:,find(B123_PSS211_OPN>1))=0;

% sum together beamline shutter states
BL_SHUTTERS = [B021_PSS201_OPN + B03_11_PSS1_RSS_TRLY_OPN + B03_2_PSS101_RSS_TRLY_OPN + B03_2_PSS201_RSS_TRLY_OPN + ...
    B03_3_PSS101_RSS_TRLY_OPN + B03_3_PSS201_RSS_TRLY_OPN + B040_PSS002_RSS_TRLY_OPN + B040_PSS001_RSS_TRLY_OPN + ...
    ICS_BL042_PSS101_RSS_TRLY_OP + ICS_BL042_PSS201_RSS_TRLY_OP + ICS_BL043_PSS101_RSS_TRLY_OP + ...
    ICS_BL043_PSS201_RSS_TRLY_OP + B050_PSS001_RSS_TRLY_OPN + B050_PSS101_OPN + B050_PSS201_OPN + ...
    B050_PSS301_OPN + B050_PSS111_OPN + B050_PSS211_OPN + B050_PSS311_OPN + B053_PSS101_RSS_TRLY_OPN + ...
    B053_PSS201_RSS_TRLY_OPN + B060_PSS101_OPN + B060_PSS202_OPN + B0612_PSS1_OPN + B0631_PSS1_OPN + ...
    B0632_PSS1_OPN + B0702_PSS1_RSS_TRLY_OPN + B073_PSS1_RSS_TRLY_OPN + B0733_PSS1_OPN + ICS_B0801_PSS1_RSS_TRLY_OPN + ...
    ICS_B082_PSS101_RSS_TRLY_OP + ICS_B082_PSS201_RSS_TRLY_OP + ICS_B083_PSS101_RSS_TRLY_OP + ...
    ICS_B083_PSS201_RSS_TRLY_OP + B090_PSS1_RSS_TRLY_OPN + B09_31_PSS1_RSS_TRLY_OPN + B09_3_PSS1_RSS_TRLY_OPN + ...
    B10_0_PSS001_RSS_TRLY_OPN + B10_31_PSS1_RSS_TRLY_OPN + B10_31_PSS1_RSS_TRLY_OPN + B110_PSS101_RSS_TRLY_OPN + ...s
    B110_PSS201_RSS_TRLY_OPN + BL113_PSS101_RSS_TRLY_OPN + BL113_PSS201_RSS_TRLY_OPN + ICS_BL12_0_PSS1_RSS_TRLY_OPN + ...
    ICS_BL12_2_PSS101_RSS_TRLY_O + ICS_BL12_2_PSS201_RSS_TRLY_O + ICS_BL12_3_PSS101_RSS_TRLY_O + ...
    ICS_BL12_3_PSS201_RSS_TRLY_O + B122_PSS111_OPN + B122_PSS211_OPN + B123_PSS111_OPN + B123_PSS211_OPN];


% Plotted during user time
if FFFlag
    GapEnable(isnan(GapEnable)) = 0;
    GapEnable(GapEnable==127) = 1;  % Sometime 127 is the same as 1 (boolean???)
    i = find(sum(GapEnable) < 3);   % Why 3, just because sometimes 1 or 2 gaps are enabled for testing.
else
    i = find(dcct < 30);
end
BPMx(:,i) = NaN;
BPMy(:,i) = NaN;

filter_data_time = toc;
%fprintf('  %.1f seconds to filter data\n', filter_data_time);


%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%
FigNum = 10;  % Just to protect srcontrol window if it is open
% Note that arplot_sbm & arplot_sr_report must reflect a change to FigNum!!!

FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%FigurePosition = [p(1)-.4*p(3) p(2)-.95*p(4) p(3)+.4*p(3) p(4)+.95*p(4)];
%%set(h, 'Position', FigurePosition);
clf reset;

if mean(dcct(~isnan(dcct)))<50
    twobunchscale=1;
else
    twobunchscale=0;
end

subplot(7,1,1);
[ax, h1, h2] = plotyy(t,dcct, t,i_cam);
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
set(get(ax(2),'Ylabel'), 'String', 'I_{cam}', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
axes(ax(1));
if ~twobunchscale
    set(ax(1),'YTick',[0 100 200 300 400 500]);
    axis([0 xmax 0 550]);
    axes(ax(2));
    axis([0 xmax 0 16.5]);
else
    set(ax(1),'YTick',[0 10 20 30 40 50]);
    axis([0 xmax 0 50]);
    axes(ax(2));
    axis([0 xmax 0 50]);
end
grid off;

if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


YLim1 = get(ax(1),'YLim');
YLim2 = get(ax(2),'YLim');
if ~twobunchscale
    set(ax(2),'YTick',round([0 100 200 300 400 500]*YLim2(2)/YLim1(2)*10)/10);
else
    set(ax(2),'YTick',round([0 10 20 30 40 50]*YLim2(2)/YLim1(2)*10)/10);
end

title(['ALS Parameters: ',titleStr]);

subplot(7,1,2)
plot(t, BL_SHUTTERS);
% bar(t,BL_SHUTTERS,1.01);
% stairs(t, BL_SHUTTERS);
ylabel('# Shutters Open','fontsize',10, 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(7,1,3);
[ax,h1,h2]= plotyy(t, 100*inj_eff, t, inj_rate);
grid on;
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}Transfer-eff [%]', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}Inj-rate [mA/shot]', 'Color', RightGraphColor);
set(ax(1),'YColor', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
axes(ax(1));
axis tight;
xaxis([0 xmax]);
yaxis([0 100.0]);
axes(ax(2));
xaxis([0 xmax]);
yaxis([0 2]);
ChangeAxesLabel(t, Days, DayFlag);
set(ax(1),'YTick',[0 25 50 75 100]);
set(ax(2),'YTick',[0 0.5 1 1.5 2]);
% yaxesposition(1.0);
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


subplot(7,1,4);
if max(abs(lifetime2))==0
    lifetime2=lifetime;
else
    lifetime2=lifetime2(1,:);
end
%[ax, h1, h2] = plotyy(t,lifetime2, t(8:(end-8)),lifetime3);
[ax, h1, h2] = plotyy(t,lifetime2, t,lifetime3);
grid on
set(get(ax(1),'Ylabel'), 'String', '\fontsize{16}\tau_{\fontsize{8}total}');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{16}\tau_{\fontsize{8}cam}', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
set(h2, 'LineStyle', ':');
axes(ax(1));
if max(abs(lifetime2))>5
    set(ax(1),'YTick',[0 2.5 5 7.5 10]);
else
    set(ax(1),'YTick',[0 1 2 3 4 5]);
end
aa = axis;
aa(1) = 0;
aa(2) = xmax;
if max(abs(lifetime2))>5
    aa = [0 xmax 0 10];
else
    aa = [0 xmax 0 5];
end
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
if max(abs(lifetime2))>5
    aa = [0 xmax 0 10];
else
    aa = [0 xmax 0 5];
end
axis(aa);

if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

YLim1 = get(ax(1),'YLim');
YLim2 = get(ax(2),'YLim');
set(ax(2),'YTick',round([0 5 10 15 20]*YLim2(2)/YLim1(2)*10)/10);

% plot(t, lifetime, 'b', t(8:(end-8)), lifetime2, 'm'); grid on;
% legend('\tau_{total}','\tau_{cam}');
% %plot(t, lifetime, 'b', t(2:end)/60/60, lifetime1, 'r'); grid on;
% ylabel('Lifetime, \tau [Hours]','fontsize',10);
% axis([0 xmax 0 20]);
% set(gca,'XTickLabel','');

subplot(7,1,5);
h = plot(t, SigX31,'-b',t, SigY31,'r', t, SigX72, 'g', t, SigY72, 'm'); grid on;
% plot(t, SigX/2.0,'-b',t, SigY/2.0,'r'); grid on;
ylabel('\fontsize{14}\sigma_x \sigma_y \fontsize{10}[\mum]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight;
axis([0 xmax 20 70]);
ChangeAxesLabel(t, Days, DayFlag);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');

hh=legend('\fontsize{8}BL3.1 \fontsize{12}\sigma_x', '\fontsize{8}BL3.1 \fontsize{12}\sigma_y', '\fontsize{8}BL7.2 \fontsize{12}\sigma_x \fontsize{10}', '\fontsize{8}BL7.2 \fontsize{12}\sigma_y');
set(hh, 'Units','Normalized');
%set(hh, 'Units','Normalized', 'position',[.869 .54 .13 .09]);  % Right side
set(hh, 'Units','Normalized', 'position',[-.01 .4 .09 .09]);  % Left side
%p = get(h,'position');
%p(2)= p(2)+p(4)*.25;
%p(4)= p(4)*.1;
%set(h,'position',p);

% [ax, h1, h2] = plotyy(t,lifetime2, t,lifetime3);
% grid on
% set(get(ax(1),'Ylabel'), 'String', '\fontsize{16}\tau_{\fontsize{8}total}');
% set(get(ax(2),'Ylabel'), 'String', '\fontsize{16}\tau_{\fontsize{8}cam}', 'Color', RightGraphColor);
% set(ax(2), 'YColor', RightGraphColor);
% set(h2, 'Color', RightGraphColor);

subplot(7,1,6);
[ax,h1,h2]= plotyy(t, dcct .* lifetime2 ./ (SigX31) ./ (SigY31), t,TuneShift);
grid on;
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}I \tau / (\sigma_x \sigma_y )', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}\Delta \nu_y (Gap)^1', 'Color', RightGraphColor);
set(ax(1),'YColor', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
% axis tight
axes(ax(1));
axis tight;
xaxis([0 xmax]);
yaxis([0 2.0]);
axes(ax(2));
xaxis([0 xmax]);
yaxis([0 0.04]);
ChangeAxesLabel(t, Days, DayFlag);
set(ax(1),'YTick',[0 0.5 1 1.5 2]);
set(ax(2),'YTick',[0 0.01 0.02 0.03 0.04]);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


subplot(7,1,7)
plot(t,IDgap);
hold on;
plot(t,EPU);
IDLegend = [IDLegend; EPULegend];
%plot(t,EPU(1,:),'b');
%plot(t,EPU(2,:),'k');
hold off
xlabel(xlabelstring);
ylabel('ID Gap [mm]','fontsize',10, 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis([0 xmax -27 60]);
ChangeAxesLabel(t, Days, DayFlag);
hh = legend(IDLegend);

%hh = legend('4EPU ','5W   ','7U   ', '8U   ', '9U   ','10U  ','11EPU','12U  ');
%set(hh, 'Units','Normalized', 'position',[.87 .08 .116 .11]);
%set(hh, 'Units','Normalized', 'position',[.889 .08 .11 .14]);
set(hh, 'Units','Normalized', 'position',[-.01 .05 .08 .27]);  % Left side
%p = get(hh,'position');
%p(2)= p(2)+p(4)*.4;
%p(4)= p(4)*.5;
%set(hh,'position',p);

% addlabel(1,0,'^1W11 and the EPU longitudinal tune shifts are not included.');
yaxesposition(1.10);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linac BPM Monitors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1)
plot(t, LinacBPMx(1:4,:));
grid on;
ylabel('x [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('GTL BPM1','GTL BPM2','LN BPM1','LN BPM2','Location','Best');
title(['GTL/LN BPMs ', titleStr]);

subplot(4,1,2)
plot(t, LinacBPMy(1:4,:));
grid on;
ylabel('y [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('GTL BPM1','GTL BPM2','LN BPM1','LN BPM2','Location','Best');
title(['GTL/LN BPMs ', titleStr]);

subplot(4,1,3)
plot(t, LinacBPMx(5:end,:));
grid on;
ylabel('x [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('LTB BPM1','LTB BPM2','LTB BPM4','LTB BPM5','LTB BPM6','LTB BPM7','Location','Best');
title(['LTB BPMs ', titleStr]);

subplot(4,1,4)
plot(t, LinacBPMy(5:end,:));
grid on;
ylabel('y [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
xlabel(xlabelstring);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
% set(gca,'XTickLabel','');
legend('LTB BPM1','LTB BPM2','LTB BPM4','LTB BPM5','LTB BPM6','LTB BPM7','Location','Best');
title(['LTB BPMs ', titleStr]);

% subplot(6,1,5)
% plot(t, LinacBPMsum(1:4,:));
% grid on;
% ylabel('Q Signal [ADC counts]');
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% if DayFlag
%     MaxDay = round(max(t));
%     set(gca,'XTick',[0:MaxDay]');
% end
% set(gca,'XTickLabel','');
% legend('GTL BPM1','GTL BPM2','LN BPM1','LN BPM2','Location','Best');
% title(['GTL/LN BPMs ', titleStr]);
%
% subplot(6,1,6)
% plot(t, LinacBPMsum(5:end,:));
% grid on;
% ylabel('Q Signal [ADC counts]');
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% if DayFlag
%     MaxDay = round(max(t));
%     set(gca,'XTick',[0:MaxDay]');
% end
% legend('LTB BPM1','LTB BPM2','LTB BPM4','LTB BPM5','LTB BPM6','LTB BPM7','Location','Best');
% title(['LTB BPMs ', titleStr]);
hold off

ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BTS BPM Monitors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(2,1,1)
plot(t, BTSBPMx);
grid on;
ylabel('x [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('BPM1','BPM2','BPM3','BPM4','BPM5','BPM6','Location','Best');
title(['BTS BPMs ', titleStr]);

subplot(2,1,2)
plot(t, BTSBPMy);
grid on;
ylabel('y [mm]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
% set(gca,'XTickLabel','');
legend('BPM1','BPM2','BPM3','BPM4','BPM5','BPM6','Location','Best');

% subplot(3,1,3)
% plot(t, BTSBPMsum);
% grid on;
% ylabel('Q Signal [ADC counts]');
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% if DayFlag
%     MaxDay = round(max(t));
%     set(gca,'XTick',[0:MaxDay]');
% end
% legend('BPM1','BPM2','BPM3','BPM4','BPM5','BPM6','Location','Best');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%
% Orbit Plots %
%%%%%%%%%%%%%%%
% Straight Section Horizontal BPMs
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(12,1,1);

i = findrowindex([12 9;1 2], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('1');
title(['Horizontal Straight Section Bergoz BPMs [\mum]: ',titleStr]);
% axis tight;
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,2);
i = findrowindex([1 10;2 1], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('2');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,3);
i = findrowindex([2 9;3 2], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('3');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,4);
i = findrowindex([3 10;4 1;3 11;3 12], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('4EPU');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
legend('BPM(3,10)','BPM(4,1)','BPM(3,11)','BPM(3,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,5);
i = findrowindex([4 10;5 1], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('5W');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,6);
i = findrowindex([5 10;6 1;5 11;5 12], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('6');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
legend('BPM(5,10)','BPM(6,1)','BPM(5,11)','BPM(5,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,7);
i = findrowindex([6 10;7 1;6 11;6 12], BPMlist);
% i = findrowindex([6 10], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('7U');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
legend('BPM(6,10)','BPM(7,1)','BPM(6,11)','BPM(6,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,8);
i = findrowindex([7 10;8 1], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('8U');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,9);
i = findrowindex([8 10;9 1], BPMlist);
% i = findrowindex([8 10], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('9U');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,10);
i = findrowindex([9 10;10 1], BPMlist);
% i = findrowindex([9 10], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('10U');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');

subplot(12,1,11);
i = findrowindex([10 10;11 1;10 11;10 12], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('11EPU');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
set(gca,'XTickLabel','');
legend('BPM(10,10)','BPM(11,1)','BPM(10,11)','BPM(10,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,12);
i = findrowindex([11 10;12 1], BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('12U');
axis([0 xmax -40 40]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');

% subplot(13,1,13);
% plot(t, ID9BPM1xRMS, '-b', t, ID9BPM2xRMS, '-r');
% %grid on;
% ylabel('9U RMS');
% axis tight;
% axis([0 xmax 0 6]);
% ChangeAxesLabel(t, Days, DayFlag);

xlabel(xlabelstring);
yaxesposition(1.20);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% if 1        % Plot for Tony Warwick
%     figure(99)
%     subplot(2,1,1);
%     i = findrowindex([3 10;4 1;3 11;3 12], BPMlist);
%     BPMxm=[];
%     for loop=1:length(i)
%         j=find(~isnan(BPMx(i(loop),:)));
%         BPMxm(loop,:)=BPMx(i(loop),:)-mean(BPMx(i(loop),j));
%     end
%     plot(t, 1000*BPMxm);
%     %grid on;
%     ylabel('Straight 4, x [\mum]');
%     % axis([0 xmax -60 60]);
%     axis tight;
%     axisvals = axis;
%     xaxis([0 xmax]);
%     yaxis([axisvals(3)-5 axisvals(4)+5]);
%     ChangeAxesLabel(t, Days, DayFlag);
%     set(gca,'XTickLabel','');
%     legend('BPM(3,10)','BPM(4,1)','BPM(3,11)','BPM(3,12)','Orientation','horizontal');
%     legend(gca,'boxoff')
%     subplot(2,1,2);
%     i = findrowindex([3 10;4 1;3 11;3 12], BPMlist);
%     BPMym=[];
%     for loop=1:length(i)
%         j=find(~isnan(BPMy(i(loop),:)));
%         BPMym(loop,:)=BPMy(i(loop),:)-mean(BPMy(i(loop),j));
%     end
%     plot(t, 1000*BPMym);
%     %grid on;
%     ylabel('Straight 4, y [\mum]');
%     % axis([0 xmax -60 60]);
%     axis tight;
%     axisvals = axis;
%     xaxis([0 xmax]);
%     yaxis([axisvals(3)-5 axisvals(4)+5]);
%     ChangeAxesLabel(t, Days, DayFlag);
%     legend('BPM(3,10)','BPM(4,1)','BPM(3,11)','BPM(3,12)','Orientation','horizontal');
%     legend(gca,'boxoff')
%
%     xlabel(xlabelstring);
%     yaxesposition(1.20);
%     setappdata(99, 'ArchiveDate', DirectoryDate);
%     orient tall
%
% end


% Arc Section Horizontal BPMs
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(12,1,1);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',1), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
title(['Horizontal Arc Sector BPMs [\mum]: ',titleStr]);
ylabel('Arc 1');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,2);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',2), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 2');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,3);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',3), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 3');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,4);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',4), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 4');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,5);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',5), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 5');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,6);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',6), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 6');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
if BergozFlag
    legend('BPM 4','BPM 5','BPM 6','BPM 7','Orientation','horizontal');
else
    legend('BPM 2','BPM 3','BPM 4','BPM 5','BPM 6','BPM 7','BPM 8','BPM 9','Orientation','horizontal');
end
legend(gca,'boxoff')

subplot(12,1,7);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',7), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 7');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,8);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',8), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 8');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,9);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',9), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 9');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,10);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',10), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 10');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,11);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',11), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 11');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,12);
i = findrowindex(getbpmlist('BPMx','2 3 4 5 6 7 8 9',12), BPMlist);
plot(t, 1000*BPMx(i,:));
%grid on;
ylabel('Arc 12');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-50 50]);
%axis([0 xmax -48 48]);
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');

% subplot(13,1,13);
% plot(t, hqmofm);
% %grid on;
% ylabel('\Delta f_{RF} [Hz]');
% xaxis([0 xmax]);
% ChangeAxesLabel(t, Days, DayFlag);

xlabel(xlabelstring);
yaxesposition(1.20);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% Straight Section Vertical BPMs
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(12,1,1);
i = findrowindex([12 9;1 2], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('1');
title(['Vertical Straight Section Bergoz BPMs [\mum]: ',titleStr]);
% axis tight;
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,2);
i = findrowindex([1 10;2 1], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('2');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,3);
i = findrowindex([2 9;3 2], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('3');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,4);
i = findrowindex([3 10;4 1;3 11;3 12], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('4EPU');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
legend('BPM(3,10)','BPM(4,1)','BPM(3,11)','BPM(3,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,5);
i = findrowindex([4 10;5 1], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('5W');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,6);
i = findrowindex([5 10;6 1;5 11;5 12], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('6');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
legend('BPM(5,10)','BPM(6,1)','BPM(5,11)','BPM(5,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,7);
i = findrowindex([6 10;7 1;6 11;6 12], BPMlist);
% i = findrowindex([6 10], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('7U');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
legend('BPM(6,10)','BPM(7,1)','BPM(6,11)','BPM(6,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,8);
i = findrowindex([7 10;8 1], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('8U');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,9);
i = findrowindex([8 10;9 1], BPMlist);
% i = findrowindex([8 10], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('9U');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,10);
i = findrowindex([9 10;10 1], BPMlist);
% i = findrowindex([9 10], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('10U');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,11);
i = findrowindex([10 10;11 1;10 11;10 12], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('11EPU');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
legend('BPM(10,10)','BPM(11,1)','BPM(10,11)','BPM(10,12)','Orientation','horizontal');
legend(gca,'boxoff')

subplot(12,1,12);
i = findrowindex([11 10;12 1], BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('12U');
axis([0 xmax -30 30]);
% axis tight;
% axisvals = axis;
% xaxis([0 xmax]);
% yaxis([axisvals(3)-5 axisvals(4)+5]);
ChangeAxesLabel(t, Days, DayFlag);
%set(gca,'XTickLabel','');

% subplot(13,1,13);
% plot(t, ID9BPM1yRMS, '-b', t, ID9BPM2yRMS, '-r');
% %grid on;
% ylabel('9U RMS');
% axis tight;
% axis([0 xmax 0 3]);
% ChangeAxesLabel(t, Days, DayFlag);

xlabel(xlabelstring);
yaxesposition(1.20);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% Arc Section Vertical BPMs
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(12,1,1);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',1), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
title(['Vertical Arc Sector BPMs [\mum]: ',titleStr]);
%title(['Vertical Arc BBPM Data in \mum: ',titleStr]);
ylabel('Arc 1');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,2);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',2), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 2');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,3);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',3), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 3');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,4);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',4), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 4');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,5);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',5), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 5');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,6);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',6), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 6');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
if BergozFlag
    legend('BPM 4','BPM 5','BPM 6','BPM 7','Orientation','horizontal');
else
    legend('BPM 2','BPM 3','BPM 4','BPM 5','BPM 6','BPM 7','BPM 8','BPM 9','Orientation','horizontal');
end
legend(gca,'boxoff')

subplot(12,1,7);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',7), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 7');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,8);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',8), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 8');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,9);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',9), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 9');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,10);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',10), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 10');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,11);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',11), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
ylabel('Arc 11');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(12,1,12);
i = findrowindex(getbpmlist('BPMy','2 3 4 5 6 7 8 9',12), BPMlist);
plot(t, 1000*BPMy(i,:));
%grid on;
xlabel(xlabelstring);
ylabel('Arc 12');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([-30 30]);
%axis([0 xmax -35 35]);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.20);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% All BPMs
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
i = findrowindex(getbpmlist('BPMx', '1 10 11 12'), BPMlist);
plot(t, 1000 * BPMx(i,:));
grid on;
ylabel('Straight X [\mum]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
title(['Storage Ring Orbit: ',titleStr]);
axis([0 xmax -50 50]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(4,1,2);
i = findrowindex(getbpmlist('BPMx', '2 3 4 5 6 7 8 9'), BPMlist);
plot(t, 1000 * BPMx(i,:));
grid on;
ylabel('Arc Sector X [\mum]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis([0 xmax -50 50]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(4,1,3);
i = findrowindex(getbpmlist('BPMy', '1 10 11 12'), BPMlist);
plot(t, 1000 * BPMy(i,:));
grid on;
ylabel('Straight Y [\mum]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis([0 xmax -25 25]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(4,1,4);
i = findrowindex(getbpmlist('BPMy', '2 3 4 5 6 7 8 9'), BPMlist);
plot(t, 1000 * BPMy(i,:));
grid on;
ylabel('Arc Sector Y [\mum]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis([0 xmax -25 25]);

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);
yaxesposition(1.20);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% BPMs versus s-position
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(2,1,1);
plot(BPMxPos, 1000*BPMx);
grid on;
ylabel('BPMx [\mum]');
title(['Bergoz BPMs: ',titleStr]);
axis tight;
yaxis([-75 75]);
hold on;
drawlattice(60,10);
xaxis([0 getfamilydata('Circumference')]);
set(gca,'XTickLabel','');

subplot(2,1,2);
plot(BPMyPos, 1000*BPMy);
grid on;
ylabel('BPMy [\mum]');
axis tight;
yaxis([-60 60]);
hold on;
drawlattice(50,7);
xaxis([0 getfamilydata('Circumference')]);
xlabel('BPM Position [meters]');

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BPM Noise and Diagnostic Beamline Data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
[ax, h1, h2] = plotyy(t, ID9BPM1xRMS, t, ID9BPM1yRMS);
% actual BPMs that are written to these PVs are determined by bpm_psd_plot.m (line 30)
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}BPM_x (5,10) RMS [\mum]');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}BPM_y (5,10) RMS [\mum]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 10;
set(ax(1),'YTick',[0:2:10]');
set(ax(2),'YTick',[0:1:5]');
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 5;
set(ax(1),'YTick',[0:2:10]');
set(ax(2),'YTick',[0:1:5]');
axis(aa);

if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(sprintf('RMS Orbit Motion & Beam Size:  %s',titleStr));

subplot(4,1,2);
[ax, h1, h2] = plotyy(t, ID9BPM2xRMS, t, ID9BPM2yRMS);
% actual BPMs that are written to these PVs are determined by bpm_psd_plot.m (line 30)
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}BPM_x (6,1) RMS [\mum]');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}BPM_y (6,1) RMS [\mum]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 10;
set(ax(1),'YTick',[0:2:10]');
set(ax(2),'YTick',[0:1:5]');
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 0;
aa(4) = 5;
set(ax(1),'YTick',[0:2:10]');
set(ax(2),'YTick',[0:1:5]');
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


subplot(4,1,3);
[ax, h1, h2] = plotyy(t, SigX31, t, SigY31);
set(get(ax(1),'Ylabel'), 'String', {'\fontsize{14}\sigma_x \fontsize{10}BL 3.1 [\mum]'});
set(get(ax(2),'Ylabel'), 'String', {'\fontsize{14}\sigma_y \fontsize{10}BL 3.1 [\mum]'}, 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 40;
aa(4) = 60;
set(ax(1),'YTick',[40:5:60]');
set(ax(2),'YTick',[40:5:60]');
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 40;
aa(4) = 60;
set(ax(1),'YTick',[40:5:60]');
set(ax(2),'YTick',[40:5:60]');
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,4);
[ax, h1, h2] = plotyy(t, SigX72, t, SigY72);
set(get(ax(1),'Ylabel'), 'String', '\fontsize{14}\sigma_x\fontsize{10} BL 7.2 [\mum]');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{14}\sigma_y\fontsize{10} BL 7.2 [\mum]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
%aa = axis;
aa = [0 xmax 25 65];
axis(aa);
axes(ax(2));
%aa = axis;
aa = [0 xmax 25 65];
set(ax(1),'YTick',[25:10:65]');
set(ax(2),'YTick',[25:10:65]');
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
%set(ax(2),'XTickLabel','');
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);

orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Storage Ring Air & Water Temperatures %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(7,1,1);
plot(t,TC8_1, t,TC8_2, t,TC9_1, t,TC9_2, t,TC10_1, t,TC10_2, t,TC12_1, t,TC12_2);
%legend('TC7,1','TC7,2','TC8,1','TC8,2','TC9,1','TC9,2','TC10,1','TC10,2','TC12,1','TC12,2',-1);
%grid on
title(['Storage Ring Air and LCW Temperature [C]: ', titleStr]);
ylabel({'ID Backing','Beam'}, 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight;
axisvals = axis;
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(7,1,2);
plot(t,TC8_3, t,TC8_4, t,TC9_3, t,TC9_4, t,TC10_3, t,TC10_4, t,TC12_3, t,TC12_4);
%grid on
%set(gca,'YAxisLocation','Right');
%legend('TC7,3','TC7,4','TC8,3','TC8,4','TC9,3','TC9,4','TC10,3','TC10,4','TC12,3','TC12,4',-1);
ylabel('ID Housing', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight;
axisvals = axis;
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(7,1,3);
plot(t,TCSR01, t,TCSR02, t,TCSR03, t,TCSR04, t,TCSR05, t,TCSR06, t,TCSR07, t,TCSR08, t,TCSR09, t,TCSR11, t,TCSR12);
%legend('TCSR01','TCSR02','TCSR03','TCSR04','TCSR05','TCSR06','TCSR07','TCSR08','TCSR09','TCSR11','TCSR12',3);
%grid on
ylabel('SR Air', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight;
axisvals = axis;
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
%yaxis([21 axisvals(4)+0.1]);
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(7,1,4);
[ax, h1, h2] = plotyy(t,TCSRAVG, t,mean([TC8_3;TC8_4;TC9_3;TC9_4;TC10_3;TC10_4;TC12_3;TC12_4]));
set(get(ax(1),'Ylabel'), 'String', 'Mean SR Air');
set(get(ax(2),'Ylabel'), 'String', 'Mean ID Housing', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(7,1,5);
plot(t,AHUT01, t,AHUT03, t,AHUT04, t,AHUT06, t,AHUT07, t,AHUT08, t,AHUT09, t,AHUT11);
ylabel('SR AHU Air', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight;
axisvals = axis;
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
xaxis([0 xmax]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

indrm = find((abs(diff(diff(WVSRM)))>30));
WVSRM(indrm+1)= NaN;

subplot(7,1,6);
[ax, h1, h2] = plotyy(t,CWTemp, t,WVSRM);
set(get(ax(1),'Ylabel'), 'String', 'Chilled H_2 0');
set(get(ax(2),'Ylabel'), 'String', 'AHU H_2 0 Valves [%]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(ax, 'YTickMode', 'Auto');
set(h2, 'Color', RightGraphColor);
axes(ax(1));
axis tight;
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = aa(3)-0.5;
aa(4) = aa(4)+0.5;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
%axisvals = axis;
%yaxis([axisvals(3)-.5 axisvals(4)+.5]);
grid on
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(7,1,7);
plot(t, lcw, 'b'); grid on;
ylabel({'LCW [degC]','(SR03 Sensor)'}, 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
axis tight
xaxis([0 xmax]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%
% Hill Water Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
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
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
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
aa(2) = xmax;
axis(aa);
yaxis([130 140]);
set(ax(1),'YTick',[130:2:140]');
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
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
[ax, h1, h2] = plotyy(t,WBasinTemp, t,EBasinTemp);
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}W.Basin (TRW) \fontsize{10}[C]');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}E.Basin (LCW) \fontsize{10}[C]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
yaxis([16 21]);
set(ax(1),'YTick',[16:21]');
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
yaxis([16 21]);
set(ax(2),'YTick',[16:21]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

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
aa(2) = xmax;
aa(3) = 22;
aa(4) = 24;
axis(aa);
set(ax(1),'YTick',[22:24]');
hold on;
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 21;
aa(4) = 31;
axis(aa);
set(ax(2),'YTick',[21:31]');
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
% aa(2) = xmax;
% aa(3) = 21;
% aa(2) = 24;
% axis(aa);
% set(ax2(1),'YTick',[21:24]');
% axes(ax2(2));
% aa = axis;
% aa(1) = 0;
% aa(2) = xmax;
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
xaxis([0 xmax]);
yaxis([22 24]);
set(gca,'YTick',[21:24]');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);

orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Storage Ring Water Flows %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(3,1,1)
plot(t, SR01Girder, t, SR02Girder, t, SR03Girder, t, SR04Girder, t, SR05Girder, t, SR06Girder, t, SR07Girder, t, SR08Girder, t, SR09Girder, t, SR10Girder, t, SR11Girder, t, SR12Girder);
grid on;
ylabel('Girder Flows [GPM]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([50 105]);
%yaxis([axisvals(3)-0.5 axisvals(4)+0.5]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('SR01','SR02','SR03','SR04','SR05','SR06','SR07','SR08','SR09','SR10','SR11','SR12','Location','Best');
title(['Storage Ring Water Flows: ', titleStr]);

subplot(3,1,2);
plot(t, SR01Rack, t, SR02Rack, t, SR03Rack, t, SR04Rack, t, SR05Rack, t, SR06Rack, t, SR07Rack, t, SR08Rack, t, SR09Rack, t, SR10Rack, t, SR11Rack, t, SR12Rack);
grid on;
ylabel('Rack Flows [GPM]');
axis tight
axisvals = axis;
xaxis([0 xmax]);
yaxis([20 30]);
%yaxis([axisvals(3)-0.5 axisvals(4)+0.5]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
legend('SR01','SR02','SR03','SR04','SR05','SR06','SR07','SR08','SR09','SR10','SR11','SR12','Location','Best');

subplot(3,1,3)
plot(t, SR04PST4, t, SR04PST5, t, SR04PST6, t, SR08PST4, t, SR08PST5, t, SR08PST6, t, SR12PST4, t, SR12PST5, t, SR12PST6);
grid on;
ylabel('PST Flows [GPM]');
legend('SR04PST4','SR04PST5','SR04PST6','SR08PST4','SR08PST5','SR08PST6','SR12PST4','SR12PST5','SR12PST6','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Water Chemistry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
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

% Bottle Conductivity values are actually resistivity values in the
% database, so to get conductivities and plot on the same scale as the
% main conductivities, we need to take the inverse

EBottleConduct = (EBottleConduct).^(-1);
WBottleConduct = (WBottleConduct).^(-1);

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
if datenum(year1, month, days(1)) < 735466
    legend('Supply [MOhm/cm]','Return [MOhm/cm]','Location','Best'); % in old Barrington system both channels were resistivity
elseif datenum(year1, month, days(1)) < 735488 % sensor was recalibrated from MOhm/cm to microS/cm on 2013-09-11
    legend('Supply [\muS/cm]','Return [MOhm/cm]','Location','Best');
else
    legend('Supply [\muS/cm]','Return [\muS/cm]','E.Bottle Conductivity [\muS/cm]','W.Bottle Conductivity [\muS/cm]','Location','Best');
end
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
set(gca,'XTickLabel','');
set(ax(2),'XTickLabel','');

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
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Air Temperatures at the Insertion Devices %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;


subplot(5,1,1);
[ax, h1, h2] = plotyy(t,TC8_3, t,TC8_4);
set(get(ax(1),'Ylabel'), 'String', 'SR08 Aisle');
set(get(ax(2),'Ylabel'), 'String', 'SR08 BL Side', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Storage Ring Air Temperature at the Insertion Devices [C]: ', titleStr]);

subplot(5,1,2);
[ax, h1, h2] = plotyy(t,TC9_3, t,TC9_4);
set(get(ax(1),'Ylabel'), 'String', 'SR09 Aisle');
set(get(ax(2),'Ylabel'), 'String', 'SR09 BL Side', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,TC10_3, t,TC10_4);
set(get(ax(1),'Ylabel'), 'String', 'SR10 Aisle');
set(get(ax(2),'Ylabel'), 'String', 'SR10 BL Side', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,4);
[ax, h1, h2] = plotyy(t,TC12_3, t,TC12_4);
set(get(ax(1),'Ylabel'), 'String', 'SR12 Aisle');
set(get(ax(2),'Ylabel'), 'String', 'SR12 BL Side', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,5);
plot(t,mean([TC8_3;TC8_4;TC9_3;TC9_4;TC10_3;TC10_4;TC12_3;TC12_4]));
ylabel('Average Air', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Insertion Device Backing Beam Temperatures %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;


subplot(5,1,1);
[ax, h1, h2] = plotyy(t,TC8_1, t,TC8_2);
set(get(ax(1),'Ylabel'), 'String', 'SR08 Upstream');
set(get(ax(2),'Ylabel'), 'String', 'SR08 Downstream', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['ID Backing Beam Temperatures [C]: ',titleStr]);

subplot(5,1,2);
[ax, h1, h2] = plotyy(t,TC9_1, t,TC9_2);
set(get(ax(1),'Ylabel'), 'String', 'SR09 Upstream');
set(get(ax(2),'Ylabel'), 'String', 'SR09 Downstream', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,TC10_1, t,TC10_2);
set(get(ax(1),'Ylabel'), 'String', 'SR10 Upstream');
set(get(ax(2),'Ylabel'), 'String', 'SR10 Downstream', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,4);
[ax, h1, h2] = plotyy(t,TC12_1, t,TC12_2);
set(get(ax(1),'Ylabel'), 'String', 'SR12 Upstream');
set(get(ax(2),'Ylabel'), 'String', 'SR12 Downstream', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,5);
plot(t,mean([TC8_3;TC8_4;TC9_3;TC9_4;TC10_3;TC10_4;TC12_3;TC12_4]));
grid on;
ylabel('Average Air', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
xaxis([0 xmax]);

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);
yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


if 0
    FigNum = FigNum + 1;
    h = figure(FigNum);
    subfig(1,1,1, h);
    %p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    clf reset;
    
    % add (t, AHUT06) to plot when channel becomes active
    srnum=ones(1,size(t,2));
    plot3(t,1*srnum,AHUT01, t,3*srnum,AHUT03, t,4*srnum,AHUT04, t,7*srnum,AHUT07, t,8*srnum,AHUT08, t,9*srnum,AHUT09, t,11*srnum,AHUT11);
    grid on;
    xlabel(xlabelstring);
    ylabel('SR number');
    zlabel(sprintf('SR AHU Air Temps [C]'));
    legend('SR01 AHU','SR03 AHU','SR04 AHU','SR07 AHU','SR08 AHU','SR09 AHU','SR11 AHU');
    axis tight;
    axis([0 xmax 1 12 13 18]);
    view = ([83.5,16]);
    ChangeAxesLabel(t, Days, DayFlag);
    setappdata(FigNum, 'ArchiveDate', DirectoryDate);
    orient tall;
    
    
    FigNum = FigNum + 1;
    h = figure(FigNum);
    subfig(1,1,1, h);
    %p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    clf reset;
    
    subplot(8,1,1)
    plot(t,AHUT01, t,AHUT03, t,AHUT04, t,AHUT07, t,AHUT08, t,AHUT09, t,AHUT11);
    xlabel(xlabelstring);
    ylabel(sprintf('SR AHU Air Temps [C]'));
    legend('SR01 AHU','SR03 AHU','SR04 AHU','SR07 AHU','SR08 AHU','SR09 AHU','SR11 AHU');
    axis tight;
    axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,2)
    plot(t,AHUT01);
    ylabel(sprintf('SR01 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,3)
    plot(t,AHUT03);
    ylabel(sprintf('SR03 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,4)
    plot(t,AHUT04);
    ylabel(sprintf('SR04 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,5)
    plot(t,AHUT07);
    ylabel(sprintf('SR07 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,6)
    plot(t,AHUT08);
    ylabel(sprintf('SR08 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,7)
    plot(t,AHUT09);
    ylabel(sprintf('SR09 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');
    
    subplot(8,1,8)
    plot(t,AHUT11);
    ylabel(sprintf('SR11 AHU Air Temp [C]'));
    axis tight;
    %axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    %yaxis([13 17]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag);
    orient tall;
    
    
    FigNum = FigNum + 1;
    h = figure(FigNum);
    subfig(1,1,1, h);
    %p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    clf reset;
    
    subplot(2,1,1)
    plot(t,TCSR01, t,TCSR02, t,TCSR03, t,TCSR04, t,TCSR05, t,TCSR06);
    legend('TCSR01','TCSR02','TCSR03','TCSR04','TCSR05','TCSR06',3);
    ylabel(sprintf('SR Air Temps [C]'));
    axis tight;
    axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    xaxis([0 xmax]);
    
    subplot(2,1,2)
    plot(t,TCSR07, t,TCSR08, t,TCSR09, t,TCSR11, t,TCSR12)
    legend('TCSR07','TCSR08','TCSR09','TCSR11','TCSR12',3);
    ylabel(sprintf('SR Air Temps [C]'));
    axis tight;
    axisvals = axis;
    yaxis([axisvals(3)-0.1 axisvals(4)+0.1]);
    xaxis([0 xmax]);
    ChangeAxesLabel(t, Days, DayFlag);
    
    yaxesposition(1.15);
    setappdata(FigNum, 'ArchiveDate', DirectoryDate);
    orient tall
end


%%%%%%%%%%%%%%%%%%%
% RF Cavity Plots %
%%%%%%%%%%%%%%%%%%%


try
    AA_Flag = 1;
    pvname = 'MOCounter:FREQUENCY';
    ds = AAobj.getData(pvname, d1, d2);
    ds = aaepoch2datenum(ds);

    % Offset from 3-minute archiver time
    taa = ds.data.datenum - datenum([year month days(1)]);

    if DayFlag
        % Days
    else
        % Hours
        taa = 24 * taa;
    end
catch
    AA_Flag = 0;
    disp('Error get data from the AA archiver.  Using the lower resolution 3-minute archiver for the MO frequency.');
end


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(3,1,1);
plot(t, C1TEMP,'b', t, C2TEMP,'-r');
grid on;
ylabel('Temperature [C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
legend('RF Cavity #1 ', 'RF Cavity #2','Location','Best');
title(['Storage Ring RF Parameters: ',titleStr]);
axis tight;
xaxis([0 xmax]);
yaxis([33 40]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(3,1,2);
plot(t, C1LCW,'b', t, C2LCW,'-r');
grid on;
ylabel('Kates Valve LCW Flow [GPM]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
legend('RF Cavity #1 ', 'RF Cavity #2','Location','Best');
axis tight;
xaxis([0 xmax]);
yaxis([0 20]);
ChangeAxesLabel(t, Days, DayFlag); set(gca,'XTickLabel','');

subplot(3,1,3);
if AA_Flag
    try
        [ax, h1, h2] = plotyy(taa, ds.data.values(:)/1e6, t, hqmofm);
    catch
        [ax, h1, h2] = plotyy(t, MOCounter_FREQ/1e6, t, hqmofm);
    end
else
    [ax, h1, h2] = plotyy(t, MOCounter_FREQ/1e6, t, hqmofm);
end

set(get(ax(1),'Ylabel'), 'String', 'RF Frequency (MOCounter) [MHz]');
set(get(ax(2),'Ylabel'), 'String', '\Delta f_{RF} (Synthesizer Input) [Hz]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
%axis tight
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
%set(ax(2),'XTickLabel','');
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

% subplot(3,1,3);
% plot(t, hqmofm,'-m'); grid on;
% xlabel(xlabelstring);
% ylabel('\Delta f_{RF} [Hz]');
% legend('FM input user synthesizer');
% axis tight;
% xaxis([0 xmax]);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%
% BR RF Plots %
%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(5,1,1);
%[ax, h1, h2] = plotyy(t,[Power_RF_fwd; Power_RF_ref], t,Power_drive);
%set(get(ax(1),'Ylabel'), 'String', sprintf('Fwd Pwr and Ref [%%]'), 'Color', LeftGraphColor);
[ax, h1, h2] = plotyy(t,Power_RF_fwd, t,Power_drive);
set(get(ax(1),'Ylabel'), 'String', sprintf('Fwd Pwr [%%]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Pwr Drive [W]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(5,1,2);
%[ax, h1, h2] = plotyy(t,[HV_setpoint; Beam_volts], t,[Beam_current; Body_Current]);
[ax, h1, h2] = plotyy(t,[HV_setpoint; Beam_volts], t,Beam_current);
set(get(ax(1),'Ylabel'), 'String', 'Beam HV SP and AM [kV]', 'Color', LeftGraphColor);
%set(get(ax(2),'Ylabel'), 'String', 'Beam and Body I [A]', 'Color', RightGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Beam I [A]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,Bias_volts, t,Bias_current);
set(get(ax(1),'Ylabel'), 'String', 'Bias V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Bias I [mA]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = aa(3)+0.5;
aa(4) = aa(4)+0.5;
axis(aa);
axes(ax(2));
axis tight
aa = axis;
aa(1) = 0;
aa(2) = xmax;
%aa(4) = -aa(3);
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,4);
[ax, h1, h2] = plotyy(t,Heater_Voltage, t,Heater_current);
set(get(ax(1),'Ylabel'), 'String', 'Htr V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Htr I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,5);
[ax, h1, h2] = plotyy(t,Focus_voltage, t,Focus_current);
set(get(ax(1),'Ylabel'), 'String', 'Focus V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Focus I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 4.0;
aa(4) = 4.5;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
% set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
[ax, h1, h2] = plotyy(t,VacIon_voltage, t,VacIon_current);
set(get(ax(1),'Ylabel'), 'String', 'IonPump V [kV]');
set(get(ax(2),'Ylabel'), 'String', 'IonPump I [ \muA]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,2);
[ax, h1, h2] = plotyy(t,Thy_Grid1_volts, t,Thy_Grid2_volts);
set(get(ax(1),'Ylabel'), 'String', 'Thy Grid1 V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Thy Grid2 V [V]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = aa(3)+0.5;
aa(4) = aa(4)+0.5;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,3);
[ax, h1, h2] = plotyy(t,Thy_heater_volts, t,Thy_heater_current);
set(get(ax(1),'Ylabel'), 'String', 'Thy Htr V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Thy Htr I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,4);
plot(t,Temp_HV_enclose,'b', t,Temp_IOT_enclose,'r', t,Temp_IOT_cooling, 'g', t,Temp_ceramic_output,'m');
legend('HV Enclosure Temp','IOT Enclosure Temp','IOT Cooling Temp','Ceramic Output Temp','Location','NorthWest');
legend(gca,'boxoff')
set(get(gca,'Ylabel'), 'String', '[deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
% set(ax,'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
[ax, h1, h2] = plotyy(t,BR_CLDFWD, t,BR_RFCONT);
set(get(ax(1),'Ylabel'), 'String', 'Circulator Load Fwd Pwr [kW]');
set(get(ax(2),'Ylabel'), 'String', 'Cavity Cell Pwr [kW]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,2);
[ax, h1, h2] = plotyy(t,BR_WGREV, t,BR_WGFWD);
set(get(ax(1),'Ylabel'), 'String', 'Waveguide Rev Pwr [kW]');
set(get(ax(2),'Ylabel'), 'String', 'Waveguide Fwd Pwr [kW]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,3);
[ax, h1, h2] = plotyy(t,BR_PHSCON_AM, t,BR_PHSCON_AC);
set(get(ax(1),'Ylabel'), 'String', 'RF Phase AM [degrees]');
set(get(ax(2),'Ylabel'), 'String', 'RF Phase AC [degrees]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
offset1 = aa(3)+0.5;
offset2 = aa(4)+0.5;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = offset1;
aa(4) = offset2;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,4);
[ax, h1, h2] = plotyy(t,BR_TUNPOS, t,BR_TUNERR);
set(get(ax(1),'Ylabel'), 'String', 'Tuner Position AM [cm]');
set(get(ax(2),'Ylabel'), 'String', 'Tuner Loop Error [degrees]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
% set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
plot(t,BR_CAVTMP);
set(get(gca,'Ylabel'), 'String', 'Cavity Temp [deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(ax,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,2);
plot(t,BR_LCWTMP,'b', t,BR_SLDTMP,'r', t,BR_CIRTMP,'g', t,BR_CLDTMP,'m');
legend('LCW Inlet Temp','Switch Load Temp','Circulator Temp','Circulator Load Temp','Location','NorthWest');
legend(gca,'boxoff')
set(get(gca,'Ylabel'), 'String', '[deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');

subplot(4,1,3);
plot(t,BR_CLDFLW,'b', t,BR_CIRFLW,'r', t,BR_SLDFLW,'g');
legend('Circulator Load Flow','Circulator Flow','Switch Load Flow','Location','NorthWest');
legend(gca,'boxoff')
set(get(gca,'Ylabel'), 'String', '[GPM]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
yaxis([0 25]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');

subplot(4,1,4);
[ax, h1, h2] = plotyy(t,[BR_CAVFLW; BR_WINFLW], t,BR_TUNFLW);
set(get(ax(1),'Ylabel'), 'String', 'Cavity & RF Window Flow [GPM]', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Tuner Flow [GPM]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
aa(3) = 1.5;
aa(4) = 2.5;
axis(aa);
set(ax(2),'YTick',[1.5:0.5:2.5]');
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
% set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%
% SR RF Plots %
%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(5,1,1);
[ax, h1, h2] = plotyy(t,SR_CATHVT,t,SR_RFAMP);
set(get(ax(1),'Ylabel'), 'String', sprintf('U_{cathode} [kV]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', sprintf('Power_{RF} [kW]'), 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['SR RF  Plots: ', titleStr]);

subplot(5,1,2);
[ax, h1, h2] = plotyy(t,SR_HVPSV, t,SR_HVPSI);
set(get(ax(1),'Ylabel'), 'String', sprintf('U_{HVPS} [kV]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'I_{HVPS} [A]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,SR_MAVOLT, t,SR_MACURR);
set(get(ax(1),'Ylabel'), 'String', sprintf('U_{ModAnode} [kV]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'I_{ModAnode} [mA]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,4);
[ax, h1, h2] = plotyy(t,SR_HTRVLT, t,SR_HTRCUR);
set(get(ax(1),'Ylabel'), 'String', sprintf('U_{Heater} [V]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'I_{Heater} [A]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,5);
semilogy(t,[SR_IP1CUR;SR_IP2CUR]);
ylabel('IP current [A]');
grid on
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wago Temperature Monitors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(3,1,1)
plot(t, SR06C_TCWAGO_AM24, t, SR06C_TCWAGO_AM25, t, SR06C_TCWAGO_AM26, t, SR06C_TCWAGO_AM27);
grid on;
ylabel('SR06 QD2 Coil Temps [degF]');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
% yaxis([axisvals(3)-2 axisvals(4)+2]);
yaxis([70 125]);
if DayFlag
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
end
set(gca,'XTickLabel','');
%legend(sprintf('%s',getpvonline('SR06C___TCWAGO_AM24.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM25.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM26.DESC')),sprintf('%s',getpvonline('SR06C___TCWAGO_AM27.DESC')));
legend('QD2 Outer/Upper','QD2 Outer/Lower','QD2 Inner/Upper','QD2 Inner/Lower','Location','Best');
title(['SR06 QD2 Wago Temperatures: ', titleStr]);

subplot(3,1,2);
plot(t, lcw*9/5+32, 'b'); grid on;
ylabel({'LCW [degF]','(SR03 Sensor)'});
axis tight
axisvals = axis;
xaxis([0 xmax]);
% yaxis([axisvals(3)-2 axisvals(4)+2]);
yaxis([72 75]);

subplot(3,1,3)
plot(t, SR06C_TCWAGO_AM20, t, SR06C_TCWAGO_AM35);
grid on;
ylabel('SR06 Other Wago Temps [degF]');
legend('Wago Power Supply Temp','Ambient Air Temp','Location','Best');
axis tight;
axisvals = axis;
xaxis([0 xmax]);
yaxis([axisvals(3)-2 axisvals(4)+2]);
xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


% % Another Beam Current Plot
% FigNum = FigNum + 1;
% h = figure(FigNum);
% subfig(1,1,1, h);
% %p = get(h, 'Position');
% %set(h, 'Position', FigurePosition);
% clf reset;
%
% if mean(dcct(~isnan(dcct)))<50
%     twobunchscale=1;
% else
%     twobunchscale=0;
% end
%
% subplot(2,1,1);
% [ax, h1, h2] = plotyy(t,dcct, t,i_cam);
% set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');
% set(get(ax(2),'Ylabel'), 'String', 'I_{cam}', 'Color', RightGraphColor);
% set(ax(2), 'YColor', RightGraphColor);
% set(h2, 'Color', RightGraphColor);
% axes(ax(1));
% if ~twobunchscale
%     set(ax(1),'YTick',[0 100 200 300 400 500]);
%     axis([0 xmax 0 550]);
%     axes(ax(2));
%     axis([0 xmax 0 16.5]);
% else
%     set(ax(1),'YTick',[0 10 20 30 40 50]);
%     axis([0 xmax 0 50]);
%     axes(ax(2));
%     axis([0 xmax 0 50]);
% end
% grid off;
%
% if DayFlag
%     MaxDay = round(max(t));
%     set(ax(1),'XTick',[0:MaxDay]');
%     set(ax(2),'XTick',[0:MaxDay]');
% end
% set(ax(1),'XTickLabel','');
% set(ax(2),'XTickLabel','');
%
%
% YLim1 = get(ax(1),'YLim');
% YLim2 = get(ax(2),'YLim');
% if ~twobunchscale
%     set(ax(2),'YTick',round([0 100 200 300 400 500]*YLim2(2)/YLim1(2)*10)/10);
% else
%     set(ax(2),'YTick',round([0 10 20 30 40 50]*YLim2(2)/YLim1(2)*10)/10);
% end
%
% title(['ALS Parameters: ',titleStr]);
%
% subplot(2,1,2)
% %bar(t,BL_SHUTTERS,1.01);
% stairs(t, BL_SHUTTERS);
% ylabel('# Shutters Open','fontsize',10, 'Color', LeftGraphColor);
% set(gca,'YColor', LeftGraphColor);
% xaxis([0 xmax]);
% xlabel(xlabelstring);
% ChangeAxesLabel(t, Days, DayFlag);
% setappdata(FigNum, 'ArchiveDate', DirectoryDate);


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
