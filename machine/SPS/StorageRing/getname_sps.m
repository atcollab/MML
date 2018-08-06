function ChanName = getname_sps(Family, Field, DeviceList)
%GETNAME_SPS - Return the channel names for a family
%  ChanName = getname_sps(Family, Field, DeviceList)


ChanName = '';

if nargin < 1
    error('Family name input needed.');
end
if nargin < 2
    Field = '';
end
if isempty(Field)
    Field = 'Monitor';
end

BPMNewFlag = 1; %BPMNewFlag = 1 for NI and 0 for DCS;

if strcmpi(Family,'BPMx')
    if BPMNewFlag
        ChanName = [
           '\\192.168.100.19\BPM\BPMX23'
           '\\192.168.100.19\BPM\BPMX24'            
           '\\192.168.100.19\BPM\BPMX01'
           '\\192.168.100.19\BPM\BPMX02'
           '\\192.168.100.19\BPM\BPMX03'
           '\\192.168.100.19\BPM\BPMX04'
           '\\192.168.100.19\BPM\BPMX05'
           '\\192.168.100.19\BPM\BPMX06'
           '\\192.168.100.19\BPM\BPMX07'
           '\\192.168.100.19\BPM\BPMX08'
           '\\192.168.100.19\BPM\BPMX09'
           '\\192.168.100.19\BPM\BPMX10'
           '\\192.168.100.19\BPM\BPMX11'
           '\\192.168.100.19\BPM\BPMX12'
           '\\192.168.100.19\BPM\BPMX13'
           '\\192.168.100.19\BPM\BPMX14'
           '\\192.168.100.19\BPM\BPMX15'
           '\\192.168.100.19\BPM\BPMX21'
           '\\192.168.100.19\BPM\BPMX22'         
           '\\192.168.100.19\BPM\BPMX16'
           '\\192.168.100.19\BPM\BPMX17'
           '\\192.168.100.19\BPM\BPMX18'
           '\\192.168.100.19\BPM\BPMX19'
           '\\192.168.100.19\BPM\BPMX20'];
    else
        ChanName = [      
            '[BPM-DCS]S_ESM1.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM2.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM3.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM4.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM5.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM6.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM7.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM8.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM9.XY_XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM10.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM11.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM12.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM13.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM14.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM15.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM16.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM17.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM18.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM19.XY_XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM20.XY_XPosCal.MonitoredValue'];
    end

elseif strcmpi(Family,'BPMy')
    if BPMNewFlag
        ChanName = [ 
           '\\192.168.100.19\BPM\BPMY23'
           '\\192.168.100.19\BPM\BPMY24' 
           '\\192.168.100.19\BPM\BPMY01'
           '\\192.168.100.19\BPM\BPMY02'
           '\\192.168.100.19\BPM\BPMY03'
           '\\192.168.100.19\BPM\BPMY04'
           '\\192.168.100.19\BPM\BPMY05'          
           '\\192.168.100.19\BPM\BPMY06'
           '\\192.168.100.19\BPM\BPMY07'
           '\\192.168.100.19\BPM\BPMY08'
           '\\192.168.100.19\BPM\BPMY09'
           '\\192.168.100.19\BPM\BPMY10'
           '\\192.168.100.19\BPM\BPMY11'
           '\\192.168.100.19\BPM\BPMY12'
           '\\192.168.100.19\BPM\BPMY13'
           '\\192.168.100.19\BPM\BPMY14'
           '\\192.168.100.19\BPM\BPMY15'
           '\\192.168.100.19\BPM\BPMY21'
           '\\192.168.100.19\BPM\BPMY22'
           '\\192.168.100.19\BPM\BPMY16'
           '\\192.168.100.19\BPM\BPMY17'
           '\\192.168.100.19\BPM\BPMY18'
           '\\192.168.100.19\BPM\BPMY19'
           '\\192.168.100.19\BPM\BPMY20'];
    else
        ChanName = [
            '[BPM-DCS]S_ESM1.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM2.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM3.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM4.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM5.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM6.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM7.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM8.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM9.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM10.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM11.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM12.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM13.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM14.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM15.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM16.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM17.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM18.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM19.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM20.XY_YPosCal.MonitoredValue'];
    end

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_STH_M1.MonitoredValue '
        '[STR-DCS2]S_STH_M2.MonitoredValue '
        '[STR-DCS2]S_STH_M3.MonitoredValue '
        '[STR-DCS2]S_STH_M4.MonitoredValue '
        '[STR-DCS2]S_STH_M5.MonitoredValue '
        '[STR-DCS2]S_STH_M6.MonitoredValue '
        '[STR-DCS2]S_STH_M7.MonitoredValue '
        '[STR-DCS2]S_STH_M8.MonitoredValue '
        '[STR-DCS2]S_STH_M9.MonitoredValue '
        '[STR-DCS2]S_STH_M10.MonitoredValue'
        '[STR-DCS2]S_STH_M11.MonitoredValue'
        '[STR-DCS2]S_STH_M12.MonitoredValue'
        '[STR-DCS2]S_STH_M13.MonitoredValue'
        '[STR-DCS2]S_STH_M14.MonitoredValue'
        '[STR-DCS2]S_STH_M15.MonitoredValue'
        '[STR-DCS2]S_STH_M16.MonitoredValue'];

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_STH_M1.SetupValue '
        '[STR-DCS2]S_STH_M2.SetupValue '
        '[STR-DCS2]S_STH_M3.SetupValue '
        '[STR-DCS2]S_STH_M4.SetupValue '
        '[STR-DCS2]S_STH_M5.SetupValue '
        '[STR-DCS2]S_STH_M6.SetupValue '
        '[STR-DCS2]S_STH_M7.SetupValue '
        '[STR-DCS2]S_STH_M8.SetupValue '
        '[STR-DCS2]S_STH_M9.SetupValue '
        '[STR-DCS2]S_STH_M10.SetupValue'
        '[STR-DCS2]S_STH_M11.SetupValue'
        '[STR-DCS2]S_STH_M12.SetupValue'
        '[STR-DCS2]S_STH_M13.SetupValue'
        '[STR-DCS2]S_STH_M14.SetupValue'
        '[STR-DCS2]S_STH_M15.SetupValue'
        '[STR-DCS2]S_STH_M16.SetupValue'];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_STV_M1.MonitoredValue '
        '[STR-DCS2]S_STV_M2.MonitoredValue '
        '[STR-DCS2]S_STV_M3.MonitoredValue '
        '[STR-DCS2]S_STV_M4.MonitoredValue '
        '[STR-DCS2]S_STV_M5.MonitoredValue '
        '[STR-DCS2]S_STV_M6.MonitoredValue '
        '[STR-DCS2]S_STV_M7.MonitoredValue '
        '[STR-DCS2]S_STV_M8.MonitoredValue '
        '[STR-DCS2]S_STV_M9.MonitoredValue '
        '[STR-DCS2]S_STV_M10.MonitoredValue'
        '[STR-DCS2]S_STV_M11.MonitoredValue'
        '[STR-DCS2]S_STV_M12.MonitoredValue'];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_STV_M1.SetupValue '
        '[STR-DCS2]S_STV_M2.SetupValue '
        '[STR-DCS2]S_STV_M3.SetupValue '
        '[STR-DCS2]S_STV_M4.SetupValue '
        '[STR-DCS2]S_STV_M5.SetupValue '
        '[STR-DCS2]S_STV_M6.SetupValue '
        '[STR-DCS2]S_STV_M7.SetupValue '
        '[STR-DCS2]S_STV_M8.SetupValue '
        '[STR-DCS2]S_STV_M9.SetupValue '
        '[STR-DCS2]S_STV_M10.SetupValue'
        '[STR-DCS2]S_STV_M11.SetupValue'
        '[STR-DCS2]S_STV_M12.SetupValue'];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_M1.MonitoredValue     '
        '[STR-DCS2]S_QF_M1.MonitoredValue     '
        '[STR-DCS2]S_QF_M1.MonitoredValue     '
        '[STR-DCS2]S_QF_M1.MonitoredValue     '
        ];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_M1.SetUpValue     '
        '[STR-DCS2]S_QF_M1.SetUpValue     '
        '[STR-DCS2]S_QF_M1.SetUpValue     '
        '[STR-DCS2]S_QF_M1.SetUpValue     '
        ];
    
elseif strcmpi(Family,'QF1_SWLS') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_L1_SWLS.MonitoredValue'
        '[STR-DCS2]S_QF_L1_SWLS.MonitoredValue'
        ];

elseif strcmpi(Family,'QF1_SWLS') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_L1_SWLS.SetUpValue'
        '[STR-DCS2]S_QF_L1_SWLS.SetUpValue'
        ];
    
elseif strcmpi(Family,'QF11_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_L11_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QF11_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_L11_MPW.SetUpValue'
        ];
    
elseif strcmpi(Family,'QF18_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_L18_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QF18_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_L18_MPW.SetUpValue'
        ];
    
elseif strcmpi(Family,'QD') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD_M2.MonitoredValue     '
        '[STR-DCS2]S_QD_M2.MonitoredValue     '
        '[STR-DCS2]S_QD_M2.MonitoredValue     '
        '[STR-DCS2]S_QD_M2.MonitoredValue     '
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD_M2.SetUpValue     '
        '[STR-DCS2]S_QD_M2.SetUpValue     '
        '[STR-DCS2]S_QD_M2.SetUpValue     '
        '[STR-DCS2]S_QD_M2.SetUpValue     '
        ];
    
elseif strcmpi(Family,'QD2_SWLS') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD_L2_SWLS.MonitoredValue'
        '[STR-DCS2]S_QD_L2_SWLS.MonitoredValue'
        ];

elseif strcmpi(Family,'QD2_SWLS') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD_L2_SWLS.SetUpValue'
        '[STR-DCS2]S_QD_L2_SWLS.SetUpValue'
        ];
    
elseif strcmpi(Family,'QD21_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD_L21_MPW.MonitoredValue'
        '[STR-DCS2]S_QD_L21_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QD21_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD_L21_MPW.SetUpValue'
        '[STR-DCS2]S_QD_L21_MPW.SetUpValue'
        ];
    
elseif strcmpi(Family,'QD28_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD_L28_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QD28_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD_L28_MPW.SetUpValue'
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        '[STR-DCS2]S_QF_M3.MonitoredValue     '
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        '[STR-DCS2]S_QF_M3.SetUpValue     '
        ];

elseif strcmpi(Family,'QF31_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_L31_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QF31_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_L31_MPW.SetUpValue'
        ];
    
elseif strcmpi(Family,'QF38_MPW') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF_L38_MPW.MonitoredValue'
        ];

elseif strcmpi(Family,'QF38_MPW') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF_L38_MPW.SetUpValue'
        ];    
    
elseif strcmpi(Family,'QDA') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD_M4.MonitoredValue'
        '[STR-DCS2]S_QD_M4.MonitoredValue'
        '[STR-DCS2]S_QD_M4.MonitoredValue'
        '[STR-DCS2]S_QD_M4.MonitoredValue'
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD_M4.SetUpValue'
        '[STR-DCS2]S_QD_M4.SetUpValue'
        '[STR-DCS2]S_QD_M4.SetUpValue'
        '[STR-DCS2]S_QD_M4.SetUpValue'
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        '[STR-DCS2]S_SXF_M.MonitoredValue'
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        '[STR-DCS2]S_SXF_M.SetupValue'
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        '[STR-DCS2]S_SXD_M.MonitoredValue'
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        '[STR-DCS2]S_SXD_M.SetupValue'
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        '[STR-DCS2]S_BM_M.MonitoredValue'
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        '[STR-DCS2]S_BM_M.SetupValue'
        ];
      
elseif strcmpi(Family,'IDsHCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_MPW_STH_U.MonitoredValue '
        '[STR-DCS2]S_MPW_STH_D.MonitoredValue '
        '[STR-DCS2]S_SWLS_STH_U.MonitoredValue'
        '[STR-DCS2]S_SWLS_STH_D.MonitoredValue'];
    
elseif strcmpi(Family,'IDsHCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_MPW_STH_U.SetupValue '
        '[STR-DCS2]S_MPW_STH_D.SetupValue '
        '[STR-DCS2]S_SWLS_STH_U.SetupValue'
        '[STR-DCS2]S_SWLS_STH_D.SetupValue'];
    
elseif strcmpi(Family,'IDsVCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_MPW_STV_U.MonitoredValue '
        '[STR-DCS2]S_MPW_STV_D.MonitoredValue '
        '[STR-DCS2]S_SWLS_STV_U.MonitoredValue'
        '[STR-DCS2]S_SWLS_STV_D.MonitoredValue'];
    
elseif strcmpi(Family,'IDsVCM') && strcmpi(Field,'Setpoint')
    ChanName = [
         '[STR-DCS2]S_MPW_STV_U.SetupValue '
         '[STR-DCS2]S_MPW_STV_D.SetupValue '
         '[STR-DCS2]S_SWLS_STV_U.SetupValue'
         '[STR-DCS2]S_SWLS_STV_D.SetupValue' ];
     
elseif strcmpi(Family,'U60CM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[U60-DCS]S_U60_STH_U_MonitoredValue'
        '[U60-DCS]S_U60_STH_D_MonitoredValue'
        '[U60-DCS]S_U60_STV_U_MonitoredValue'
        '[U60-DCS]S_U60_STV_D_MonitoredValue'];
            
elseif strcmpi(Family,'U60CM') && strcmpi(Field,'Setpoint')
    ChanName = [
         '[U60-DCS]S_U60_STH_U_SetupValue'
         '[U60-DCS]S_U60_STH_D_SetupValue'
         '[U60-DCS]S_U60_STV_U_SetupValue'
         '[U60-DCS]S_U60_STV_D_SetupValue']; 
     
elseif strcmpi(Family,'QFC') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF1_S1.MonitoredValue'
        '[STR-DCS2]S_QF1_S2.MonitoredValue'
        '[STR-DCS2]S_QF1_S3.MonitoredValue'
        '[STR-DCS2]S_QF1_S4.MonitoredValue'
        '[STR-DCS2]S_QF1_S5.MonitoredValue'
        '[STR-DCS2]S_QF1_S6.MonitoredValue'
        '[STR-DCS2]S_QF1_S7.MonitoredValue'
        '[STR-DCS2]S_QF1_S8.MonitoredValue'];
    
elseif strcmpi(Family,'QFC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF1_S1.SetupValue'
        '[STR-DCS2]S_QF1_S2.SetupValue'
        '[STR-DCS2]S_QF1_S3.SetupValue'
        '[STR-DCS2]S_QF1_S4.SetupValue'
        '[STR-DCS2]S_QF1_S5.SetupValue'
        '[STR-DCS2]S_QF1_S6.SetupValue'
        '[STR-DCS2]S_QF1_S7.SetupValue'
        '[STR-DCS2]S_QF1_S8.SetupValue']; 
    
elseif strcmpi(Family,'QDC') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD2_S1.MonitoredValue'
        '[STR-DCS2]S_QD2_S2.MonitoredValue'
        '[STR-DCS2]S_QD2_S3.MonitoredValue'
        '[STR-DCS2]S_QD2_S4.MonitoredValue'
        '[STR-DCS2]S_QD2_S5.MonitoredValue'
        '[STR-DCS2]S_QD2_S6.MonitoredValue'
        '[STR-DCS2]S_QD2_S7.MonitoredValue'
        '[STR-DCS2]S_QD2_S8.MonitoredValue'];
    
elseif strcmpi(Family,'QDC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD2_S1.SetupValue'
        '[STR-DCS2]S_QD2_S2.SetupValue'
        '[STR-DCS2]S_QD2_S3.SetupValue'
        '[STR-DCS2]S_QD2_S4.SetupValue'
        '[STR-DCS2]S_QD2_S5.SetupValue'
        '[STR-DCS2]S_QD2_S6.SetupValue'
        '[STR-DCS2]S_QD2_S7.SetupValue'
        '[STR-DCS2]S_QD2_S8.SetupValue'];    
    
elseif strcmpi(Family,'QFAC') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QF3_S1.MonitoredValue'
        '[STR-DCS2]S_QF3_S2.MonitoredValue'
        '[STR-DCS2]S_QF3_S3.MonitoredValue'
        '[STR-DCS2]S_QF3_S4.MonitoredValue'
        '[STR-DCS2]S_QF3_S5.MonitoredValue'
        '[STR-DCS2]S_QF3_S6.MonitoredValue'
        '[STR-DCS2]S_QF3_S7.MonitoredValue'
        '[STR-DCS2]S_QF3_S8.MonitoredValue'];
    
elseif strcmpi(Family,'QFAC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QF3_S1.SetupValue'
        '[STR-DCS2]S_QF3_S2.SetupValue'
        '[STR-DCS2]S_QF3_S3.SetupValue'
        '[STR-DCS2]S_QF3_S4.SetupValue'
        '[STR-DCS2]S_QF3_S5.SetupValue'
        '[STR-DCS2]S_QF3_S6.SetupValue'
        '[STR-DCS2]S_QF3_S7.SetupValue'
        '[STR-DCS2]S_QF3_S8.SetupValue'];
    
elseif strcmpi(Family,'QDAC') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_QD4_S1.MonitoredValue'
        '[STR-DCS2]S_QD4_S2.MonitoredValue'
        '[STR-DCS2]S_QD4_S3.MonitoredValue'
        '[STR-DCS2]S_QD4_S4.MonitoredValue'];
    
elseif strcmpi(Family,'QDAC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_QD4_S1.SetupValue'
        '[STR-DCS2]S_QD4_S2.SetupValue'
        '[STR-DCS2]S_QD4_S3.SetupValue'
        '[STR-DCS2]S_QD4_S4.SetupValue'];
            
elseif strcmpi(Family,'IDsSC') && strcmpi(Field,'Monitor')
    ChanName = [
        '\\192.168.100.25\Automatic_Polarity_Changer\S_SWLS_SC_U'
        '\\192.168.100.25\Automatic_Polarity_Changer\S_SWLS_SC_D'];
    
elseif strcmpi(Family,'IDsSC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '\\192.168.100.25\Automatic_Polarity_Changer\S_SWLS_SC_U'
        '\\192.168.100.25\Automatic_Polarity_Changer\S_SWLS_SC_D'];
                           
elseif strcmpi(Family,'IDsLC') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_MPW_LC.MonitoredValue'];
    
elseif strcmpi(Family,'IDsLC') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_MPW_LC.SetupValue'];
          
elseif strcmpi(Family,'RF') && strcmpi(Field,'Monitor')
    %ChanName = '[GIS-DCS]RFOSC.MonitoredValue';
    ChanName = '[GIS-DCS]Program:RF_Oscillator.Monitored_from_counter';
elseif strcmpi(Family,'RF') && strcmpi(Field,'Setpoint')
    %ChanName = '[GIS-DCS]RFOSC.SetupValue';
    ChanName = '[GIS-DCS]RFFreq';

elseif strcmpi(Family,'DCCT') && strcmpi(Field,'Monitor')
    ChanName = '[CNT-DCS]Beam_Current';
    
% elseif strcmpi(Family,'xOFFSET') && strcmpi(Field,'Setpoint')
%     ChanName=[
%         '[BPM-DCS]S_ESM1.Xoffset'
%         '[BPM-DCS]S_ESM2.Xoffset'
%         '[BPM-DCS]S_ESM3.Xoffset'
%         '[BPM-DCS]S_ESM4.Xoffset'
%         '[BPM-DCS]S_ESM5.Xoffset'
%         '[BPM-DCS]S_ESM6.Xoffset'
%         '[BPM-DCS]S_ESM7.Xoffset'
%         '[BPM-DCS]S_ESM8.Xoffset'
%         '[BPM-DCS]S_ESM9.Xoffset'
%         '[BPM-DCS]S_ESM10.Xoffset'
%         '[BPM-DCS]S_ESM11.Xoffset'
%         '[BPM-DCS]S_ESM12.Xoffset'
%         '[BPM-DCS]S_ESM13.Xoffset'
%         '[BPM-DCS]S_ESM14.Xoffset'
%         '[BPM-DCS]S_ESM15.Xoffset'
%         '[BPM-DCS]S_ESM16.Xoffset'
%         '[BPM-DCS]S_ESM17.Xoffset'
%         '[BPM-DCS]S_ESM18.Xoffset'
%         '[BPM-DCS]S_ESM19.Xoffset'
%         '[BPM-DCS]S_ESM12.Xoffset'
%         ];
% elseif strcmpi(Family,'yOFFSET') && strcmpi(Field,'Setpoint')
%     ChanName=[
%         '[BPM-DCS]S_ESM1.Yoffset'
%         '[BPM-DCS]S_ESM2.Yoffset'
%         '[BPM-DCS]S_ESM3.Yoffset'
%         '[BPM-DCS]S_ESM4.Yoffset'
%         '[BPM-DCS]S_ESM5.Yoffset'
%         '[BPM-DCS]S_ESM6.Yoffset'
%         '[BPM-DCS]S_ESM7.Yoffset'
%         '[BPM-DCS]S_ESM8.Yoffset'
%         '[BPM-DCS]S_ESM9.Yoffset'
%         '[BPM-DCS]S_ESM10.Yoffset'
%         '[BPM-DCS]S_ESM11.Yoffset'
%         '[BPM-DCS]S_ESM12.Yoffset'
%         '[BPM-DCS]S_ESM13.Yoffset'
%         '[BPM-DCS]S_ESM14.Yoffset'
%         '[BPM-DCS]S_ESM15.Yoffset'
%         '[BPM-DCS]S_ESM16.Yoffset'
%         '[BPM-DCS]S_ESM17.Yoffset'
%         '[BPM-DCS]S_ESM18.Yoffset'
%         '[BPM-DCS]S_ESM19.Yoffset'
%         '[BPM-DCS]S_ESM12.Yoffset'
%         ];
else
    ChanName = strvcat(ChanName, ' ');
end
