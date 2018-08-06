function  [Output, CommonName, ErrorFlag] = getname_apex(Family, Field, StructFlag)
% [ChannelName, ErrorFlag] = getname_apex(Family, Field, DeviceList)
%
%   Inputs:  Family name
%            DeviceList ([Sector Device #] or [element #]) (default: whole family)
%            ChanTypeStr 0 -> 'AM' channel type (default)
%                        1 -> 'AC' channel type
%                        2 -> 'BM' channel type
%                        3 -> 'BC' channel type
%
%   Outputs: ChannelName = IOC channel name corresponding to the family and DeviceList
%            ErrorFlag = 0 if family name was found
%                       -1 if no family name was found, ChannelName = Family

ErrorFlag = 0;
CommonName = [];

if nargin < 2
    error('Must have at least one input (''Family'')!');
end
if nargin < 3
    StructFlag = 0;
end

MemberOf = {};
ChannelNames = {''};
HW2PhysicsParams = 1;
Physics2HWParams = 1;
HWUnits      = '';
PhysicsUnits = '';


if strcmpi(Family, 'RF') && strcmpi(Field, 'Permit')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        %'RSS_ChainA'
        %'RSS_ChainB'
        'FastFeeder_RFPermit'
        'Cir12_TCU'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'PermitIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        %'RSS_ChainA_Intlk'
        %'RSS_ChainB_Intlk'
        'FastFeeder_RFPermit_Intlk'
        
        %'RSS_ChainA2_Intlk'
        %'RSS_ChainB2_Intlk'
        'FastFeeder_RFPermit2_Intlk'
        
        'RSS_RFPermit_Intlk'
        'EPS_RFPermit_Intlk'
        
        'Cir12_TCU_Intlk'
        
        %'RF_Window1_Intlk'  % Always tripped?
        %'RF_Window2_Intlk'  % Always tripped?
        
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'ArcDetect')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Window1_ArcDet_Intlk'
        'Window2_ArcDetDet_Intlk'
        'Circ1_ArcDet_Intlk'
        'Circ2_ArcDet_Intlk'
        'Cav_ArcDet_Intlk'
        
        %'ArcDet6_Intlk'
        %'ArcDet7_Intlk'
        %'ArcDet8_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'ArcDetectPowerSupply')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Window1_ArcDetPS_Intlk'
        'Window2_ArcDetPS_Intlk'
        'Circ1_ArcDetPS_Intlk'
        'Circ2_ArcDetPS_Intlk'
        'Cav_ArcDetPS_Intlk'
        
        %'ArcDet6PS_Intlk'
        %'ArcDet7PS_Intlk'
        %'ArcDet8PS_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Circ1Intlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Circ1_TCU_OK_Intlk'
        'Circ1_Load_FWD_Pwr_Intlk'
        'Circ1_Load_REV_Pwr_Intlk'
        'Circ1_Error_Coil_Discon_Intlk'
        'Circ1_Error_Tin_Lo_Intlk'
        'Circ1_Error_Tin_Hi_Intlk'
        'Circ1_Error_DeltaT_Hi_Intlk'
        'Circ1_Error_Tamb_Lo_Intlk'
        
        %'Circ1_TCU_Booting_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Circ2Intlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Circ2_TCU_OK_Intlk'
        'Circ2_Load_FWD_Pwr_Intlk'
        'Circ2_Load_REV_Pwr_Intlk'
        'Circ2_Error_Coil_Discon_Intlk'
        'Circ2_Error_Tin_Lo_Intlk'
        'Circ2_Error_Tin_Hi_Intlk'
        'Circ2_Error_DeltaT_Hi_Intlk'
        'Circ2_Error_Tamb_Lo_Intlk'
        
        %'Circ2_TCU_Booting_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'SSPA')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'SSPA_A1_FWD_Pwr_Intlk'
        'SSPA_A1_REV_Pwr_Intlk'
        'SSPA_A2_FWD_Pwr_Intlk'
        'SSPA_A2_REV_Pwr_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'TetrodeIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Tetrode_A3_FWD_Pwr_Intlk'
        'Tetrode_A3_REV_Pwr_Intlk'
        'Tetrode_A4_FWD_Pwr_Intlk'
        'Tetrode_A4_REV_Pwr_Intlk'
        };
    
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Power')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Power_Dissipation'
        'Feeder_Power_Dissipation'
        'Cav_Cooling'
        'Feeder_Cooling'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'PowerIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Power_Dissipation_Intlk'
        'Feeder_Power_Dissipation_Intlk'
        'Cav_Cooling_Intlk'
        'Feeder_Cooling_Intlk'
        
        'Cav_Probe_2_Pwr_Intlk'
        
        'Cplr2_A4_FWD_Pwr_Intlk'
        'Cplr2_A4_REV_Pwr_Intlk'
        'A3_FWD_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'WaterFlow')
    MemberOf = {'Gun'; 'RF'; 'Monitor'; 'Save'};
    % Real
    HWUnits      = 'gpm';
    PhysicsUnits = 'gpm';
    
    ChannelNames = {
        'Cav_Nose_Cone_Flow'
        'Cav_1_3_4_Anode_2_Flow'
        'Cav_2_5_Anode_1_Flow'
        'Cav_Wall_Outlet_Flow'
        
        'Int_Solenoid_Outlet_Flow'
        'Window_Coupler_Outlet_Flow'
        
        'Circ1_Flow'
        'Circ1_RF_Load_Flow'
        'Circ2_Flow'
        'Circ2_RF_Load_Flow'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'WaterFlowIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Nose_Cone_Flow_Intlk'
        'Cav_1_3_4_Anode_2_Flow_Intlk'
        'Cav_2_5_Anode_1_Flow_Intlk'
        'Cav_Wall_Outlet_Flow_Intlk'
        
        'Int_Solenoid_Outlet_Flow_Intlk'
        'Loop_Coupler_Outlet_Flow_Intlk'
        
        'Circ1_Flow_Intlk'
        'Circ1_RF_Load_Flow_Intlk'
        'Circ2_Flow_Intlk'
        'Circ2_RF_Load_Flow_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Temperature')
    MemberOf = {'Gun'; 'RF'; 'Monitor'; 'Save'};
    % Real - C
    HWUnits      = 'C';
    PhysicsUnits = 'C';
    ChannelNames = {
        'Cav_Nose_Cone_Outlet_Temp'
        'Cav_1_3_4_Anode_2_Outlet_Temp'
        'Cav_2_5_Anode_1_Outlet_Temp'
        'Cav_Wall_Outlet_Temp'
        
        'Int_Solenoid_Outlet_Temp'
        'Window_Coupler_Outlet_Temp'
        
        'Circ1_Outlet_Temp'
        'Circ1_RF_Load_Outlet_Temp'
        'Circ2_Outlet_Temp'
        'Circ2_RF_Load_Outlet_Temp'
        
        'LCW_Supply_Temp'
        'Cav_LCW_Supply_Temp'
        
        'Temp8'
        'Temp9'
        'Temp10'
        'Temp11'
        'Temp12'
        'Temp13'
        'Temp14'
        'Temp15'
        'Temp16'
        % 'Net23_AI_Spare_6
        % 'Net23_AI_Spare_7'
        % 'Net23_AI_Spare_8'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'TemperatureIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Nose_Cone_Outlet_Temp_Intlk'
        'Cav_1_3_4_Anode_2_Outlet_Temp_Intlk'
        'Cav_2_5_Anode_1_Outlet_Temp_Intlk'
        'Cav_Wall_Outlet_Temp_Intlk'
        
        'Int_Solenoid_Outlet_Temp_Intlk'
        'RF_Window_Coupler_Outlet_Temp_Intlk'
        
        'Circ1_Outlet_Temp_Intlk'
        'Circ1_RF_Load_Outlet_Temp_Intlk'
        'Circ2_Outlet_Temp_Intlk'
        'Circ2_RF_Load_Outlet_Temp_Intlk'
        
        'LCW_Supply_Temp_Intlk'
        'Cav_LCW_Supply_Temp_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Vacuum')
    MemberOf = {'Gun'; 'RF'; 'Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Vacuum'
       %'Cav_Vac_IG_Pressure_Expt_Holder'
        };
    % Torr
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'VacuumIntlk')
    MemberOf = {'Gun'; 'RF'; 'Boolean Monitor'; 'Save'};
    ChannelNames = {
        'Cav_Vacuum_Intlk'
        'Window1_IG_Pressure_Intlk'
        'Window2_IG_Pressure_Intlk'
        'Cav_Vac_IG_Pressure_Intlk'
        'Vacuum_Intlk'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Pressure')
    MemberOf = {'Gun'; 'RF'; 'Monitor'; 'Save'};
    % Real - Torr
    HWUnits      = 'Torr';
    PhysicsUnits = 'Torr';
    ChannelNames = {
        'Cav_Vacuum_Mon'
        %'Window1_IG_Pressure_Expt_Holder'
        %'Window2_IG_Pressure_Expt_Holder'
        };
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Monitor')
    % Real - Frequency
    MemberOf = {'Gun'; 'RF'; 'Monitor'; };   % 'Save';
    HW2PhysicsParams = 1e6;
    Physics2HWParams = 1/1e6;
    HWUnits       = 'MHz';
    PhysicsUnits  = 'Hz';
    % Special function ???
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Setpoint')
    MemberOf = {'Gun'; 'RF'; 'Setpoint'; };   %'Save/Restore'
    % Real - Frequency
    HW2PhysicsParams = 1e6;
    Physics2HWParams = 1/1e6;
    HWUnits       = 'MHz';
    PhysicsUnits  = 'Hz';
    % Special function ???
    
elseif strcmpi(Family, 'RF') && strcmpi(Field, 'Reset')
    MemberOf = {'Save'; 'Gun'; 'RF'; 'Boolean Control'; 'Save'};
    ChannelNames = {
        'InterlockReset'
        };
    
else
    ChannelNames = Family;
end

if strcmpi(Family, 'RF')
    Prefix = 'Gun:RF:';
    for i = 1:length(ChannelNames)
        if ~isempty(ChannelNames{i})
            ChannelNames{i} = [Prefix, ChannelNames{i}];
        end
    end
end

N =size(ChannelNames,1);

% Cell or not?
%ChannelNames = cell2mat(ChannelNames, N, ??);

if StructFlag
    Output.MemberOf         = MemberOf;
    Output.Mode             = 'Online';     % 'Online' 'Simulator', 'Manual' or 'Special'
    Output.DataType         = 'Scalar';
    Output.Status           = ones(N,1);
    Output.DeviceList       = [ones(N,1) (1:N)'];
    Output.ElementList      = (1:N)';
    Output.ChannelNames     = ChannelNames;
    Output.HW2PhysicsParams = HW2PhysicsParams;
    Output.Physics2HWParams = Physics2HWParams;
    Output.Units            = 'Hardware';
    Output.HWUnits          = HWUnits;
    Output.PhysicsUnits     = PhysicsUnits;
    
    if ~isempty(strfind(Field, 'Intlk'))
        Output.Counter = zeros(N,1);
    end
else
    Output = ChannelNames;
    CommonName = ErrorFlag;
end



% 'Net23_AI_Spare_6_Intlk'
% 'Net23_AI_Spare_7_Intlk'
% 'Net23_AI_Spare_8_Intlk'
% 'Net24_AI_Spare_8_Intlk'
% 'Net24_AI_Spare_9_Intlk'
% 'Net24_AI_Spare_10_Intlk'
% 'Net24_AI_Spare_11_Intlk'
% 'Net24_AI_Spare_12_Intlk'
% 'Net24_AI_Spare_13_Intlk'
% 'Net24_AI_Spare_14_Intlk'
% 'Net24_AI_Spare_15_Intlk'
% 'Net24_AI_Spare_16_Intlk'
% 'Channel_8_Spare_Intlk'



% RFPLC.Controls.ChanneNames = {
%     'InterlockReset'
%     };
%
% RFPLC.State.ChanneNames = {
%     'RSS_ChainA'
%     'RSS_ChainB'
%     'Cir12_TCU'
%     'Cav_Vacuum'
%     'Cav_Cooling'
%     'Cav_Power_Dissipation'
%     'Cav_Vac_IG_Pressure_Expt_Holder'
%     'FastFeeder_RFPermit'
%     'Feeder_Cooling'
%     'Feeder_Power_Dissipation'
%     };
%
% RFPLC.Interlock.ChanneNames = {
% 'Vacuum_Intlk'
% 'EPS_RFPermit_Intlk'
% 'RSS_RFPermit_Intlk'
% 'RSS_ChainA_Intlk'
% 'RSS_ChainB_Intlk'
% %'RSS_ChainA2_Intlk'
% %'RSS_ChainB2_Intlk'
%
% 'RF_Window1_Intlk'
% 'RF_Window2_Intlk'
%
% 'FastFeeder_RFPermit_Intlk'
% %'FastFeeder_RFPermit2_Intlk'
% 'Feeder_Cooling_Intlk'
% 'Feeder_Power_Dissipation_Intlk'
%
% 'Cav_ArcDet_Intlk'
% 'Cav_Probe_2_Pwr_Intlk'
% 'Cav_Vacuum_Intlk'
% 'Cav_Cooling_Intlk'
% 'Cav_LCW_Supply_Temp_Intlk'
% 'Cav_Nose_Cone_Outlet_Temp_Intlk'
% 'Cav_2_5_Anode_1_Outlet_Temp_Intlk'
% 'Cav_1_3_4_Anode_2_Outlet_Temp_Intlk'
% 'Cav_Wall_Outlet_Temp_Intlk'
% 'Cav_Nose_Cone_Flow_Intlk'
% 'Cav_2_5_Anode_1_Flow_Intlk'
% 'Cav_1_3_4_Anode_2_Flow_Intlk'
% 'Cav_Wall_Outlet_Flow_Intlk'
% 'Cav_Vac_IG_Pressure_Intlk'
% 'Cav_Power_Dissipation_Intlk'
% 'Cav_ArcDet_Intlk'
%
% 'Circ1_Load_FWD_Pwr_Intlk'
% 'Circ1_Load_REV_Pwr_Intlk'
% 'Circ1_TCU_OK_Intlk'
% 'Circ1_Error_Coil_Discon_Intlk'
% 'Circ1_Error_Tin_Lo_Intlk'
% 'Circ1_Error_Tin_Hi_Intlk'
% 'Circ1_Error_DeltaT_Hi_Intlk'
% 'Circ1_Error_Tamb_Lo_Intlk'
% %'Circ1_TCU_Booting_Intlk'
%
% 'Circ2_Load_FWD_Pwr_Intlk'
% 'Circ2_Load_REV_Pwr_Intlk'
% 'Cir12_TCU_Intlk'
% 'Circ2_TCU_OK_Intlk'
% 'Circ2_Error_Coil_Discon_Intlk'
% 'Circ2_Error_Tin_Lo_Intlk'
% 'Circ2_Error_Tin_Hi_Intlk'
% 'Circ2_Error_DeltaT_Hi_Intlk'
% 'Circ2_Error_Tamb_Lo_Intlk'
% %'Circ2_TCU_Booting_Intlk'
%
% 'Circ1_Outlet_Temp_Intlk'
% 'Circ1_RF_Load_Outlet_Temp_Intlk'
% 'Circ2_Outlet_Temp_Intlk'
% 'Circ2_RF_Load_Outlet_Temp_Intlk'
% 'Circ1_Flow_Intlk'
% 'Circ1_RF_Load_Flow_Intlk'
% 'Circ2_Flow_Intlk'
% 'Circ2_RF_Load_Flow_Intlk'
%
% 'Window1_ArcDet_Intlk'
% 'Window2_ArcDetDet_Intlk'
%
% 'Circ1_ArcDet_Intlk'
% 'Circ2_ArcDet_Intlk'
%
% 'LCW_Supply_Temp_Intlk'
%
% % 'ArcDet6_Intlk'
% % 'ArcDet7_Intlk'
% % 'ArcDet8_Intlk'
%
% 'SSPA_A1_FWD_Pwr_Intlk'
% 'SSPA_A1_REV_Pwr_Intlk'
% 'SSPA_A2_FWD_Pwr_Intlk'
% 'SSPA_A2_REV_Pwr_Intlk'
%
% 'Tetrode_A3_FWD_Pwr_Intlk'
% 'Tetrode_A3_REV_Pwr_Intlk'
% 'Tetrode_A4_FWD_Pwr_Intlk'
% 'Tetrode_A4_REV_Pwr_Intlk'
%
% 'Cplr2_A4_FWD_Pwr_Intlk'
% 'Cplr2_A4_REV_Pwr_Intlk'
%
% 'A3_FWD_Intlk'
%
% 'Int_Solenoid_Outlet_Temp_Intlk'
% 'Int_Solenoid_Outlet_Flow_Intlk'
%
% 'RF_Window_Coupler_Outlet_Temp_Intlk'
% 'Loop_Coupler_Outlet_Flow_Intlk'
%
% 'Window1_IG_Pressure_Intlk'
% 'Window2_IG_Pressure_Intlk'
%
% % 'Net23_AI_Spare_6_Intlk'
% % 'Net23_AI_Spare_7_Intlk'
% % 'Net23_AI_Spare_8_Intlk'
% % 'Net24_AI_Spare_8_Intlk'
% % 'Net24_AI_Spare_9_Intlk'
% % 'Net24_AI_Spare_10_Intlk'
% % 'Net24_AI_Spare_11_Intlk'
% % 'Net24_AI_Spare_12_Intlk'
% % 'Net24_AI_Spare_13_Intlk'
% % 'Net24_AI_Spare_14_Intlk'
% % 'Net24_AI_Spare_15_Intlk'
% % 'Net24_AI_Spare_16_Intlk'
% % 'Channel_8_Spare_Intlk'
%
% % 'ArcDet6PS_Intlk'
% % 'ArcDet7PS_Intlk'
% % 'ArcDet8PS_Intlk'
% % 'Cav_ArcDetPS_Intlk'
% % 'Window1_ArcDetPS_Intlk'
% % 'Window2_ArcDetPS_Intlk'
% % 'Circ1_ArcDetPS_Intlk'
% % 'Circ2_ArcDetPS_Intlk'
% };
%
%
% RFPLC.Flows.ChanneNames = {
%     'Cav_1_3_4_Anode_2_Flow'
%     'Cav_2_5_Anode_1_Flow'
%     'Cav_Nose_Cone_Flow'
%     'Cav_Wall_Outlet_Flow'
%     'Circ1_Flow'
%     'Circ1_RF_Load_Flow'
%     'Circ2_Flow'
%     'Circ2_RF_Load_Flow'
%     'Int_Solenoid_Outlet_Flow'
%     'Window_Coupler_Outlet_Flow'
%     };
%
% RFPLC.Temperatures.ChanneNames = {
%     'Cav_1_3_4_Anode_2_Outlet_Temp'
%     'Cav_2_5_Anode_1_Outlet_Temp'
%     'Cav_Nose_Cone_Outlet_Temp'
%     'Cav_Wall_Outlet_Temp'
%     'Circ1_Outlet_Temp'
%     'Circ1_RF_Load_Outlet_Temp'
%     'Circ2_Outlet_Temp'
%     'Circ2_RF_Load_Outlet_Temp'
%     'Int_Solenoid_Outlet_Temp'
%     'Window_Coupler_Outlet_Temp'
%     'LCW_Supply_Temp'
%     'Cav_LCW_Supply_Temp'
%     'Temp8'
%     'Temp9'
%     'Temp10'
%     'Temp11'
%     'Temp12'
%     'Temp13'
%     'Temp14'
%     'Temp15'
%     'Temp16'
%     };
% % 'Net23_AI_Spare_6
% % 'Net23_AI_Spare_7'
% % 'Net23_AI_Spare_8'
%
%
% RFPLC.Vacuum.ChanneNames = {
%     'Cav_Vacuum_Mon'
%     'Window1_IG_Pressure_Expt_Holder'
%     'Window2_IG_Pressure_Expt_Holder'
%     };