function arplot_rb(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_RB - Plots various performance data from the ALS archiver
%  arplot_rb(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
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

% Written by Greg Portmann & Tom Scarvie - odified by Rick Bloemhard to get
% rid of camshaft trace
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
% 2009-11-19, R. Bloemhard
%       copied script and removed camshaft trace



LeftGraphColor = 'b';
RightGraphColor = 'r';
FFFlag = 1;
GapOpenFlag = 1;


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

BPMlist = getbpmlist('bergoz');
GapEnableNames = family2channel('ID','GapEnable');
BPMxNames = family2channel('BPMx',BPMlist);
BPMyNames = family2channel('BPMy',BPMlist);
BPMxPos = getspos('BPMx',BPMlist);
BPMyPos = getspos('BPMy',BPMlist);
BPMxGolden = getgolden('BPMx',BPMlist);
BPMyGolden = getgolden('BPMy',BPMlist);

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

tic;
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
        [dcct, idcct] = arselect('SR05S___DCCTLP_AM01');
        [lcw, ilcw ] = arselect('SR03S___LCWTMP_AM00');
        [i_cam, ii_cam] = arselect('cmm:cam_current');
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
            [FF7Enable, iFF7Enable] = arselect('sr07u:FFEnable:bi');
        end

        [TC7_1, iTC7_1] = arselect('SR07U___IDTC1__AM');
        [TC7_2, iTC7_2] = arselect('SR07U___IDTC2__AM');
        [TC7_3, iTC7_3] = arselect('SR07U___IDTC3__AM');
        [TC7_4, iTC7_4] = arselect('SR07U___IDTC4__AM');

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

        [CWTemp, iCWTemp] = arselect('6_______CW__T__AM00'); %chilled H20 supply temp. bld 6 AHU's F
        [CWValve, iCWValve] = arselect('6_______CWV____AM00'); %chilled water valve

        [RingLCWSupPx, iRingLCWSupPx]  = arselect('SR11U___H2OPX1_AM00'); %Bldg 6 LCW supply pressure in PSI
        [RingLCWRetPx, iRingLCWRetPx]  = arselect('SR11U___H2OPX2_AM01'); %Bldg 6 LCW return pressure in PSI
        [LCWSupPx, iLCWSupPx]  = arselect('37LCW___SPPAVG_AM00'); %LCW supply pressure average in PSI
        [LCWRetPx, iLCWRetPx]  = arselect('37LCW___RTP____AM00'); %LCW return pressure in PSIG
        [LCWSupTemp, iLCWSupTemp]  = arselect('37LCW___SPTAVG_AM00'); %LCW supply temperature average in deg. F
        [LCWRetTemp, iLCWRetTemp]  = arselect('37LCW___RTT'); %LCW return temperature (3 entries)
        [WBasinTemp, iWBasinTemp]  = arselect('37CT100_TW_ST__AM00'); %North Cooling tower supply (basin) temperature
        [EBasinTemp, iEBasinTemp] = arselect('37CT101_TW_ST__AM00'); %South Cooling tower supply (basin) temperature

        % All Bergoz BPMs
        [BPMx, iBPMx] = arselect(BPMxNames);
        [BPMy, iBPMy] = arselect(BPMyNames);

        [ID9BPM1xRMS, iID9BPM1xRMS] = arselect('SR09S_IBPM1X_RMS');
        [ID9BPM1yRMS, iID9BPM1yRMS] = arselect('SR09S_IBPM1Y_RMS');
        [ID9BPM2xRMS, iID9BPM2xRMS] = arselect('SR09S_IBPM2X_RMS');
        [ID9BPM2yRMS, iID9BPM2yRMS] = arselect('SR09S_IBPM2Y_RMS');

        [C1TEMP, iC1TEMP] = arselect('SR03S___C1TEMP_AM');
        [C2TEMP, iC2TEMP] = arselect('SR03S___C2TEMP_AM');

        [SigX, iSigX] = arselect('SR04S___SPIRICOAM07');
        [SigY, iSigY] = arselect('SR04S___SPIRICOAM08');

        [SigX31, iSigX31] = arselect('beamline31:XRMSAve',1);
        [SigY31, iSigY31] = arselect('beamline31:YRMSAve',1);
        if isempty(SigX31)
            SigX31 = NaN * ones(1,length(ARt));
        end
        if isempty(SigY31)
            SigY31 = NaN * ones(1,length(ARt));
        end

        [SigX72, iSigX72] = arselect('bl72:XRMSAve',1);
        [SigY72, iSigY72] = arselect('bl72:YRMSAve',1);
        if isempty(SigX72)
            SigX72 = NaN * ones(1,length(ARt));
        end
        if isempty(SigY72)
            SigY72 = NaN * ones(1,length(ARt));
        end

        [SpiroX, iSpiroX] = arselect('SR04S___SPIRICOAM01');
        [SpiroY, iSpiroY] = arselect('SR04S___SPIRICOAM02');

        [HPcounter, iHPcounter] = arselect('SR01C___FREQB__AM00');
        [HPcounter_precise, iHPcounter_precise] = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = HPcounter_precise+499.642;
        
        [HPsyn, iHPsyn] = arselect('SR03S___RFFREQ_AM00');

        [hqmofm, ihqmofm] = arselect('EG______HQMOFM_AC01');
        hqmofm = hqmofm*4.988e3;

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
        [ICS_BL042_PSS101_RSS_TRLY_OP, iICS_BL042_PSS101_RSS_TRLY_OP] = arselect('ICS_BL042_PSS101_RSS_TRLY_OP');
        [ICS_BL042_PSS201_RSS_TRLY_OP, iICS_BL042_PSS201_RSS_TRLY_OP] = arselect('ICS_BL042_PSS201_RSS_TRLY_OP');
        [ICS_BL043_PSS101_RSS_TRLY_OP, iICS_BL043_PSS101_RSS_TRLY_OP] = arselect('ICS_BL043_PSS101_RSS_TRLY_OP');
        [ICS_BL043_PSS201_RSS_TRLY_OP, iICS_BL043_PSS201_RSS_TRLY_OP] = arselect('ICS_BL043_PSS201_RSS_TRLY_OP');
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
        [B0701_PSS1_RSS_TRLY_OPN, iB0701_PSS1_RSS_TRLY_OPN] = arselect('B0701_PSS1_RSS_TRLY_OPN');
        [B073_PSS1_RSS_TRLY_OPN, iB073_PSS1_RSS_TRLY_OPN] = arselect('B073_PSS1_RSS_TRLY_OPN');
        [B0733_PSS1_OPN, iB0733_PSS1_OPN] = arselect('B0733_PSS1_OPN');
        [ICS_B0801_PSS1_RSS_TRLY_OPN, iICS_B0801_PSS1_RSS_TRLY_OPN] = arselect('ICS_B0801_PSS1_RSS_TRLY_OPN');
        [ICS_B082_PSS101_RSS_TRLY_OP, iICS_B082_PSS101_RSS_TRLY_OP] = arselect('ICS_B082_PSS101_RSS_TRLY_OP');
        [ICS_B082_PSS201_RSS_TRLY_OP, iICS_B082_PSS201_RSS_TRLY_OP] = arselect('ICS_B082_PSS201_RSS_TRLY_OP');
        [ICS_B083_PSS101_RSS_TRLY_OP, iICS_B083_PSS101_RSS_TRLY_OP] = arselect('ICS_B083_PSS101_RSS_TRLY_OP');
        [ICS_B083_PSS201_RSS_TRLY_OP, iICS_B083_PSS201_RSS_TRLY_OP] = arselect('ICS_B083_PSS201_RSS_TRLY_OP');
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
        [ICS_BL12_2_PSS101_RSS_TRLY_O, iICS_BL12_2_PSS101_RSS_TRLY_O] = arselect('ICS_BL12_2_PSS101_RSS_TRLY_O');
        [ICS_BL12_2_PSS201_RSS_TRLY_O, iICS_BL12_2_PSS201_RSS_TRLY_O] = arselect('ICS_BL12_2_PSS201_RSS_TRLY_O');
        [ICS_BL12_3_PSS101_RSS_TRLY_O, iICS_BL12_3_PSS101_RSS_TRLY_O] = arselect('ICS_BL12_3_PSS101_RSS_TRLY_O');
        [ICS_BL12_3_PSS201_RSS_TRLY_O, iICS_BL12_3_PSS201_RSS_TRLY_O] = arselect('ICS_BL12_3_PSS201_RSS_TRLY_O');
        [B122_PSS111_OPN, iB122_PSS111_OPN] = arselect('B122_PSS111_OP');
        [B122_PSS211_OPN, iB122_PSS211_OPN] = arselect('B122_PSS211_OP');
        [B123_PSS111_OPN, iB123_PSS111_OPN] = arselect('B123_PSS111_OP');
        [B123_PSS211_OPN, iB123_PSS211_OPN] = arselect('B123_PSS211_OP');

        % time vector
        t = [ARt+(day-StartDay)*24*60*60];


    else

        dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
        i_cam = [i_cam arselect('cmm:cam_current')];
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

        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];

        % ID vertical gap
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];

        if FFFlag
            GapEnable = [GapEnable arselect(GapEnableNames)];
            FF7Enable = [FF7Enable arselect('sr07u:FFEnable:bi')];
        end

        TC7_1 = [TC7_1 arselect('SR07U___IDTC1__AM')];
        TC7_2 = [TC7_2 arselect('SR07U___IDTC2__AM')];
        TC7_3 = [TC7_3 arselect('SR07U___IDTC3__AM')];
        TC7_4 = [TC7_4 arselect('SR07U___IDTC4__AM')];

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

        CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
        CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve

        RingLCWSupPx  = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
        RingLCWRetPx  = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
        LCWSupPx  = [LCWSupPx arselect('37LCW___SPPAVG_AM00')]; %LCW supply pressure average in PSI
        LCWRetPx  = [LCWRetPx arselect('37LCW___RTP____AM00')]; %LCW return pressure in PSIG
        LCWSupTemp  = [LCWSupTemp arselect('37LCW___SPTAVG_AM00')]; %LCW supply temperature average in deg. F
        LCWRetTemp  = [LCWRetTemp arselect('37LCW___RTT')]; %LCW return temperature (3 entries)
        WBasinTemp = [WBasinTemp arselect('37CT100_TW_ST__AM00')]; %North Cooling tower supply (basin) temperature
        EBasinTemp = [EBasinTemp arselect('37CT101_TW_ST__AM00')]; %South Cooling tower supply (basin) temperature

        % All Bergoz BPMs
        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];

        ID9BPM1xRMS = [ID9BPM1xRMS arselect('SR09S_IBPM1X_RMS')];
        ID9BPM1yRMS = [ID9BPM1yRMS arselect('SR09S_IBPM1Y_RMS')];
        ID9BPM2xRMS = [ID9BPM2xRMS arselect('SR09S_IBPM2X_RMS')];
        ID9BPM2yRMS = [ID9BPM2yRMS arselect('SR09S_IBPM2Y_RMS')];

        C1TEMP = [C1TEMP arselect('SR03S___C1TEMP_AM')];
        C2TEMP = [C2TEMP arselect('SR03S___C2TEMP_AM')];

        SigX = [SigX arselect('SR04S___SPIRICOAM07')];
        SigY = [SigY arselect('SR04S___SPIRICOAM08')];

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

        SpiroX = [SpiroX arselect('SR04S___SPIRICOAM01')];
        SpiroY = [SpiroY arselect('SR04S___SPIRICOAM02')];

        HPcounter = [HPcounter arselect('SR01C___FREQB__AM00')];
        tmp = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = [HPcounter_precise tmp+499.642];

        HPsyn = [HPsyn arselect('SR03S___RFFREQ_AM00')];

        tmp = arselect('EG______HQMOFM_AC01');
        hqmofm = [hqmofm tmp*4.988e3];

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
        ICS_BL042_PSS101_RSS_TRLY_OP = [ICS_BL042_PSS101_RSS_TRLY_OP arselect('ICS_BL042_PSS101_RSS_TRLY_OP')];
        ICS_BL042_PSS201_RSS_TRLY_OP = [ICS_BL042_PSS201_RSS_TRLY_OP arselect('ICS_BL042_PSS201_RSS_TRLY_OP')];
        ICS_BL043_PSS101_RSS_TRLY_OP = [ICS_BL043_PSS101_RSS_TRLY_OP arselect('ICS_BL043_PSS101_RSS_TRLY_OP')];
        ICS_BL043_PSS201_RSS_TRLY_OP = [ICS_BL043_PSS201_RSS_TRLY_OP arselect('ICS_BL043_PSS201_RSS_TRLY_OP')];
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
        B0701_PSS1_RSS_TRLY_OPN = [B0701_PSS1_RSS_TRLY_OPN arselect('B0701_PSS1_RSS_TRLY_OPN')];
        B073_PSS1_RSS_TRLY_OPN = [B073_PSS1_RSS_TRLY_OPN arselect('B073_PSS1_RSS_TRLY_OPN')];
        B0733_PSS1_OPN = [B0733_PSS1_OPN arselect('B0733_PSS1_OPN')];
        ICS_B0801_PSS1_RSS_TRLY_OPN = [ICS_B0801_PSS1_RSS_TRLY_OPN arselect('ICS_B0801_PSS1_RSS_TRLY_OPN')];
        ICS_B082_PSS101_RSS_TRLY_OP = [ICS_B082_PSS101_RSS_TRLY_OP arselect('ICS_B082_PSS101_RSS_TRLY_OP')];
        ICS_B082_PSS201_RSS_TRLY_OP = [ICS_B082_PSS201_RSS_TRLY_OP arselect('ICS_B082_PSS201_RSS_TRLY_OP')];
        ICS_B083_PSS101_RSS_TRLY_OP = [ICS_B083_PSS101_RSS_TRLY_OP arselect('ICS_B083_PSS101_RSS_TRLY_OP')];
        ICS_B083_PSS201_RSS_TRLY_OP = [ICS_B083_PSS201_RSS_TRLY_OP arselect('ICS_B083_PSS201_RSS_TRLY_OP')];
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
        ICS_BL12_2_PSS101_RSS_TRLY_O = [ICS_BL12_2_PSS101_RSS_TRLY_O arselect('ICS_BL12_2_PSS101_RSS_TRLY_O')];
        ICS_BL12_2_PSS201_RSS_TRLY_O = [ICS_BL12_2_PSS201_RSS_TRLY_O arselect('ICS_BL12_2_PSS201_RSS_TRLY_O')];
        ICS_BL12_3_PSS101_RSS_TRLY_O = [ICS_BL12_3_PSS101_RSS_TRLY_O arselect('ICS_BL12_3_PSS101_RSS_TRLY_O')];
        ICS_BL12_3_PSS201_RSS_TRLY_O = [ICS_BL12_3_PSS201_RSS_TRLY_O arselect('ICS_BL12_3_PSS201_RSS_TRLY_O')];
        B122_PSS111_OPN = [B122_PSS111_OPN arselect('B122_PSS111_OP')];
        B122_PSS211_OPN = [B122_PSS211_OPN arselect('B122_PSS211_OP')];
        B123_PSS111_OPN = [B123_PSS111_OPN arselect('B123_PSS111_OP')];
        B123_PSS211_OPN = [B123_PSS211_OPN arselect('B123_PSS211_OP')];

        % time vector
        t = [t  ARt+(day-StartDay)*24*60*60];

    end

    tmp = toc;
    ar_functions_time = ar_functions_time + tmp;
    fprintf('                One day of arselect = %g seconds\n',tmp);
    tic;
    
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
        arread(FileName, 1);


        dcct = [dcct arselect('SR05S___DCCTLP_AM01')];
        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
        i_cam = [i_cam arselect('cmm:cam_current')];
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

        [tmp, iEPU, iNotFound] = arselect(EPUChan);
        tmp(iNotFound,:) = [];
        EPU = [EPU tmp];

        % ID vertical gap
        [tmp, iIDgap, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
        tmp(iNotFound,:) = [];
        IDgap = [IDgap tmp];

        if FFFlag
            GapEnable = [GapEnable arselect(GapEnableNames)];
            FF7Enable = [FF7Enable arselect('sr07u:FFEnable:bi')];
        end

        TC7_1 = [TC7_1 arselect('SR07U___IDTC1__AM')];
        TC7_2 = [TC7_2 arselect('SR07U___IDTC2__AM')];
        TC7_3 = [TC7_3 arselect('SR07U___IDTC3__AM')];
        TC7_4 = [TC7_4 arselect('SR07U___IDTC4__AM')];

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

        CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
        CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve

        RingLCWSupPx  = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
        RingLCWRetPx  = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
        LCWSupPx  = [LCWSupPx arselect('37LCW___SPPAVG_AM00')]; %LCW supply pressure average in PSI
        LCWRetPx  = [LCWRetPx arselect('37LCW___RTP____AM00')]; %LCW return pressure in PSIG
        LCWSupTemp  = [LCWSupTemp arselect('37LCW___SPTAVG_AM00')]; %LCW supply temperature average in deg. F
        LCWRetTemp  = [LCWRetTemp arselect('37LCW___RTT')]; %LCW return temperature (3 entries)
        WBasinTemp = [WBasinTemp arselect('37CT100_TW_ST__AM00')]; %North Cooling tower supply (basin) temperature
        EBasinTemp = [EBasinTemp arselect('37CT101_TW_ST__AM00')]; %South Cooling tower supply (basin) temperature

        % All Bergoz BPMs
        BPMx = [BPMx arselect(BPMxNames)];
        BPMy = [BPMy arselect(BPMyNames)];

        ID9BPM1xRMS = [ID9BPM1xRMS arselect('SR09S_IBPM1X_RMS')];
        ID9BPM1yRMS = [ID9BPM1yRMS arselect('SR09S_IBPM1Y_RMS')];
        ID9BPM2xRMS = [ID9BPM2xRMS arselect('SR09S_IBPM2X_RMS')];
        ID9BPM2yRMS = [ID9BPM2yRMS arselect('SR09S_IBPM2Y_RMS')];

        C1TEMP = [C1TEMP arselect('SR03S___C1TEMP_AM')];
        C2TEMP = [C2TEMP arselect('SR03S___C2TEMP_AM')];

        SigX = [SigX arselect('SR04S___SPIRICOAM07')];
        SigY = [SigY arselect('SR04S___SPIRICOAM08')];

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

        SpiroX = [SpiroX arselect('SR04S___SPIRICOAM01')];
        SpiroY = [SpiroY arselect('SR04S___SPIRICOAM02')];

        HPcounter = [HPcounter arselect('SR01C___FREQB__AM00')];
        tmp = arselect('SR01C___FREQBHPAM00');
        HPcounter_precise = [HPcounter_precise tmp+499.642];

        HPsyn = [HPsyn arselect('SR03S___RFFREQ_AM00')];

        tmp = arselect('EG______HQMOFM_AC01');
        hqmofm = [hqmofm tmp*4.988e3];

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
        ICS_BL042_PSS101_RSS_TRLY_OP = [ICS_BL042_PSS101_RSS_TRLY_OP arselect('ICS_BL042_PSS101_RSS_TRLY_OP')];
        ICS_BL042_PSS201_RSS_TRLY_OP = [ICS_BL042_PSS201_RSS_TRLY_OP arselect('ICS_BL042_PSS201_RSS_TRLY_OP')];
        ICS_BL043_PSS101_RSS_TRLY_OP = [ICS_BL043_PSS101_RSS_TRLY_OP arselect('ICS_BL043_PSS101_RSS_TRLY_OP')];
        ICS_BL043_PSS201_RSS_TRLY_OP = [ICS_BL043_PSS201_RSS_TRLY_OP arselect('ICS_BL043_PSS201_RSS_TRLY_OP')];
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
        B0701_PSS1_RSS_TRLY_OPN = [B0701_PSS1_RSS_TRLY_OPN arselect('B0701_PSS1_RSS_TRLY_OPN')];
        B073_PSS1_RSS_TRLY_OPN = [B073_PSS1_RSS_TRLY_OPN arselect('B073_PSS1_RSS_TRLY_OPN')];
        B0733_PSS1_OPN = [B0733_PSS1_OPN arselect('B0733_PSS1_OPN')];
        ICS_B0801_PSS1_RSS_TRLY_OPN = [ICS_B0801_PSS1_RSS_TRLY_OPN arselect('ICS_B0801_PSS1_RSS_TRLY_OPN')];
        ICS_B082_PSS101_RSS_TRLY_OP = [ICS_B082_PSS101_RSS_TRLY_OP arselect('ICS_B082_PSS101_RSS_TRLY_OP')];
        ICS_B082_PSS201_RSS_TRLY_OP = [ICS_B082_PSS201_RSS_TRLY_OP arselect('ICS_B082_PSS201_RSS_TRLY_OP')];
        ICS_B083_PSS101_RSS_TRLY_OP = [ICS_B083_PSS101_RSS_TRLY_OP arselect('ICS_B083_PSS101_RSS_TRLY_OP')];
        ICS_B083_PSS201_RSS_TRLY_OP = [ICS_B083_PSS201_RSS_TRLY_OP arselect('ICS_B083_PSS201_RSS_TRLY_OP')];
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
        ICS_BL12_2_PSS101_RSS_TRLY_O = [ICS_BL12_2_PSS101_RSS_TRLY_O arselect('ICS_BL12_2_PSS101_RSS_TRLY_O')];
        ICS_BL12_2_PSS201_RSS_TRLY_O = [ICS_BL12_2_PSS201_RSS_TRLY_O arselect('ICS_BL12_2_PSS201_RSS_TRLY_O')];
        ICS_BL12_3_PSS101_RSS_TRLY_O = [ICS_BL12_3_PSS101_RSS_TRLY_O arselect('ICS_BL12_3_PSS101_RSS_TRLY_O')];
        ICS_BL12_3_PSS201_RSS_TRLY_O = [ICS_BL12_3_PSS201_RSS_TRLY_O arselect('ICS_BL12_3_PSS201_RSS_TRLY_O')];
        B122_PSS111_OPN = [B122_PSS111_OPN arselect('B122_PSS111_OP')];
        B122_PSS211_OPN = [B122_PSS211_OPN arselect('B122_PSS211_OP')];
        B123_PSS111_OPN = [B123_PSS111_OPN arselect('B123_PSS111_OP')];
        B123_PSS211_OPN = [B123_PSS211_OPN arselect('B123_PSS211_OP')];

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

LCWRetTemp = mean(LCWRetTemp);

dcct = 100*dcct;

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
SigX(i)=NaN;
SigY(i)=NaN;
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
    [y, i] = find(FF7Enable==0);
    BPMx(:,i) = NaN;
    BPMy(:,i) = NaN;
    ID9BPM1xRMS(i)=NaN;
    ID9BPM1yRMS(i)=NaN;
    ID9BPM2xRMS(i)=NaN;
    ID9BPM2yRMS(i)=NaN;
    %dcct(i)=NaN*ones(size(i));
    EPU(:,i)=NaN;
    IDgap(:,i)=NaN;
    SigX(i)=NaN;
    SigY(i)=NaN;
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
    HPsyn(i)=NaN;
    hqmofm(i)=NaN;
    HPcounter(i)=NaN;
    HPcounter_precise(i)=NaN;
end

% Remove points when the gaps are open
if GapOpenFlag
    % j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
    %j = any(IDgap < 80); % was 80 before IVID
    j = any(IDgap < 29); %changed from 37 10-10-05 because we've been running IVID at 30mm pemanently
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
    SigX(i)=NaN;
    SigY(i)=NaN;
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
SigX(i)=NaN;
SigY(i)=NaN;
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
SigX(i)=NaN;
SigY(i)=NaN;
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
HPsyn(i)=NaN;
hqmofm(i)=NaN;
HPcounter(i)=NaN;
HPcounter_precise(i)=NaN;

% remove HPCounter errant data
[y, i]=find(HPcounter<400);
HPcounter(i)=NaN;
HPcounter_precise(i)=NaN;

% remove when T>55 (this usually indicates work on system - trip is at 33)
[y, i]=find(TC7_1>55 | TC7_2>55 | TC7_3>55 | TC7_4>55 | TC8_1>55 | TC8_2>55 | TC8_3>55 | TC8_4>55 | TC9_1>55 | TC9_2>55 | TC9_3>55 | TC9_4>55 | TC10_1>55 | TC10_2>55 | TC10_3>55 | TC10_4>55 | TC12_1>55 | TC12_2>55 | TC12_3>55 | TC12_4>55);
TC7_1(i)=NaN;
TC7_2(i)=NaN;
TC7_3(i)=NaN;
TC7_4(i)=NaN;
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
WBasinTemp = (WBasinTemp-32)*5/9;
EBasinTemp = (EBasinTemp-32)*5/9;
CWTemp     = (CWTemp-32)*5/9;

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
TC7_1(SANum)=NaN;
TC7_2(SANum)=NaN;
TC7_3(SANum)=NaN;
TC7_4(SANum)=NaN;
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

% Remove zero sigmas
SigX(find(SigX==0)) = NaN;
SigY(find(SigY==0)) = NaN;

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
B0701_PSS1_RSS_TRLY_OPN(:,find(isnan(B0701_PSS1_RSS_TRLY_OPN)))=0;
B0701_PSS1_RSS_TRLY_OPN(:,find(B0701_PSS1_RSS_TRLY_OPN>1))=0;
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
	       B0632_PSS1_OPN + B0701_PSS1_RSS_TRLY_OPN + B073_PSS1_RSS_TRLY_OPN + B0733_PSS1_OPN + ICS_B0801_PSS1_RSS_TRLY_OPN + ...
	       ICS_B082_PSS101_RSS_TRLY_OP + ICS_B082_PSS201_RSS_TRLY_OP + ICS_B083_PSS101_RSS_TRLY_OP + ...
	       ICS_B083_PSS201_RSS_TRLY_OP + B090_PSS1_RSS_TRLY_OPN + B09_31_PSS1_RSS_TRLY_OPN + B09_3_PSS1_RSS_TRLY_OPN + ...
	       B10_0_PSS001_RSS_TRLY_OPN + B10_31_PSS1_RSS_TRLY_OPN + B10_31_PSS1_RSS_TRLY_OPN + B110_PSS101_RSS_TRLY_OPN + ...
	       B110_PSS201_RSS_TRLY_OPN + BL113_PSS101_RSS_TRLY_OPN + BL113_PSS201_RSS_TRLY_OPN + ICS_BL12_0_PSS1_RSS_TRLY_OPN + ...
	       ICS_BL12_2_PSS101_RSS_TRLY_O + ICS_BL12_2_PSS201_RSS_TRLY_O + ICS_BL12_3_PSS101_RSS_TRLY_O + ...
	       ICS_BL12_3_PSS201_RSS_TRLY_O + B122_PSS111_OPN + B122_PSS211_OPN + B123_PSS111_OPN + B123_PSS211_OPN];


% Plotted during user time
if FFFlag
    GapEnable(isnan(GapEnable)) = 0;
    GapEnable(GapEnable==127) = 1;  % Sometime 127 is the same as 1 (boolean???)
    i = find(sum(GapEnable) < 3);   % Why 3, just because sometimes 1 or 2 gaps are enabled for testing.
else
    i = find(dcct < 150);
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

subplot(7,1,1);
[ax, h1, h2] = plotyy(t,dcct,t,);
set(get(ax(1),'Ylabel'), 'String', 'Beam Current [mA]');

set(ax(2), 'YColor', LeftGraphColor);
set(h2, 'Color', RightGraphColor);
axes(ax(1));
set(ax(1),'YTick',[0 100 200 300 400 500]);
axis([0 xmax 0 550]);
axes(ax(2));
axis([0 xmax 0 11]);
grid on;

if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


YLim1 = get(ax(1),'YLim');
YLim2 = get(ax(2),'YLim');
set(ax(2),'YTick',round([0 100 200 300 400 500]*YLim2(2)/YLim1(2)*10)/10);

title(['ALS Parameters: ',titleStr]);


% plot(t, dcct, 'r'); grid on;
% legend('I_{total}');
% ylabel('Beam Current, I [mA]','fontsize',10);
% axis([0 xmax 0 450]);
% set(gca,'XTickLabel','');


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
