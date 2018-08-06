function uedinit(OperationalMode)
%UEDINIT - MML initialization program for APEX-UED branch


if nargin < 1
    OperationalMode = 1;
end


% Clear the AO 
setao([]); 

AO = [];

% % BPMx
% AO.BPMx.FamilyName  = 'BPMx';
% AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx';};
% AO.BPMx.DeviceList  = [1 1;1 2];
% AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
% AO.BPMx.Status      = [1;1];
% AO.BPMx.Position    = [2;5];
% %AO.BPMx.CommonNames = ;
% 
% AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
% AO.BPMx.Monitor.Mode = 'Simulator';
% AO.BPMx.Monitor.DataType = 'Scalar';
% AO.BPMx.Monitor.ChannelNames = [];
% AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
% AO.BPMx.Monitor.Physics2HWParams = 1000;
% AO.BPMx.Monitor.Units        = 'Hardware';
% AO.BPMx.Monitor.HWUnits      = 'mm';
% AO.BPMx.Monitor.PhysicsUnits = 'meter';
% 
% 
% % BPMy
% AO.BPMy.FamilyName  = 'BPMy';
% AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy';};
% AO.BPMy.DeviceList  = [1 1;1 2];
% AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
% AO.BPMy.Status      = [1;1];
% AO.BPMy.Position    = [2;5];
% %AO.BPMy.CommonNames = ;
% 
% AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
% AO.BPMy.Monitor.Mode = 'Simulator';
% AO.BPMy.Monitor.DataType = 'Scalar';
% AO.BPMy.Monitor.ChannelNames = [];
% AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
% AO.BPMy.Monitor.Physics2HWParams = 1000;
% AO.BPMy.Monitor.Units        = 'Hardware';
% AO.BPMy.Monitor.HWUnits      = 'mm';
% AO.BPMy.Monitor.PhysicsUnits = 'meter';

AO.BPM = buildmmlbpmfamily(AO, 'Gun');

% Caen power supplies
BaseName = {
    'HCM0'
    'HCM1'
    'HCM2'
    'HCM3'
    'HCM4'
    'DHCM5'
    'DHCM6'
    'UHCM7'
    'UHCM8'
    'UHCM9'
    'UHCM10'
    };
AO.HCM = buildmmlcaen('HCM', [1 0;1 1;1 2;1 3;1 4;1 5;1 6;1 7;1 8;1 9;1 10], 5, BaseName);
AO.HCM.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
};
AO.HCM.MemberOf{length(AO.HCM.MemberOf)+1} =  'Horizontal';
AO.HCM.MemberOf{length(AO.HCM.MemberOf)+1} =  'HCM';

BaseName = {
    'VCM0'
    'VCM1'
    'VCM2'
    'VCM3'
    'VCM4'
    'DVCM5'
    'DVCM6'
    'UVCM7'
    'UVCM8'
    'UVCM9'
    'UVCM10'
    };
AO.VCM = buildmmlcaen('VCM', [1 0;1 1;1 2;1 3;1 4;1 5;1 6;1 7;1 8;1 9;1 10], 5, BaseName);
AO.VCM.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
};
AO.VCM.MemberOf{length(AO.HCM.MemberOf)+1} =  'Vertical';
AO.VCM.MemberOf{length(AO.HCM.MemberOf)+1} =  'VCM';


% Solenoid
BaseName = {
    'Sol1'
    'Sol2'
    };
AO.Sol = buildmmlcaen('Sol', [1 1;1 2;], 16.5, BaseName);
AO.Sol.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};


% Solenoid Motors 
AO.Sol1M = buildmmliaimotor('Sol1', [1 1; 1 2; 1 3; 1 4; 1 5], 50);
AO.Sol2M = buildmmliaimotor('Sol2', [1 1; 1 2; 1 3; 1 4; 1 5], 50);

AO.Sol1M.Setpoint.Golden = [4.0; 3.2; 6.3; 4.4; 3.3;];
AO.Sol2M.Setpoint.Golden = [4.5; 5.5; 6.0; 4.1; 4.7;];


% Solenoid quad and skewquad
BaseName = {
    'Sol1Quad1'
    'Sol1Quad2'
    };
AO.Sol1Quad = buildmmlcaen('Sol1Quad', [1 1;1 2;], 2, BaseName); 
AO.Sol1Quad.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};

BaseName = {
    'Sol2Quad1'
    'Sol2Quad2'
    };
AO.Sol2Quad = buildmmlcaen('Sol2Quad', [1 1;1 2;], 2, BaseName); 
AO.Sol2Quad.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};

BaseName = {
    'Sol1SQuad1'
    'Sol1SQuad2'
    };
AO.Sol1SQuad = buildmmlcaen('Sol1SQuad', [1 1;1 2;], 2, BaseName); 
AO.Sol1SQuad.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};

BaseName = {
    'Sol2SQuad1'
    'Sol2SQuad2'
    };
AO.Sol2SQuad = buildmmlcaen('Sol2SQuad', [1 1;1 2;], 2, BaseName);
AO.Sol2SQuad.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};

% Broken coils (fixed Dec 2014)
%AO.Sol1Quad.Status(2)  = 0;
%AO.Sol1SQuad.Status(2) = 0;


% Qaudrupoles
BaseName = {
    'UQ1'
    'UQ2'
    'UQ3'
    'UQ4'
    'UQ5'
    'UQ6'
    };
AO.Quad = buildmmlcaen('Quad',  [1 1;1 2;1 3;1 4;1 5;1 6], 30, BaseName);
AO.Quad.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
};


% Bend
BaseName = {
    'UDIP1'
    'UDIP2'
    };
AO.Bend = buildmmlcaen('Bend',  [1 1;1 2;], 30, BaseName);
AO.Bend.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
};




% ICT
AO.ICT.FamilyName               = 'ICT';
AO.ICT.MemberOf                 = {'Diagnostics'; 'ICT'};
AO.ICT.DeviceList               = [1 1; 1 2];
AO.ICT.ElementList              = [1;2];
AO.ICT.Status                   = [1;1];
AO.ICT.Position                 = [3; 10];  % ???
AO.ICT.CommonNames              = {'ICT1';'ICT2'};

AO.ICT.RMSMin.MemberOf         = {'Diagnostics'; 'ICT'; 'Monitor'};
AO.ICT.RMSMin.Mode             = 'Simulator';
AO.ICT.RMSMin.DataType         = 'Scalar';
AO.ICT.RMSMin.ChannelNames     = {'BLM:0:dac20_min'; 'BLM:0:dac21_min'};
AO.ICT.RMSMin.HW2PhysicsParams = 1;    
AO.ICT.RMSMin.Physics2HWParams = 1;
AO.ICT.RMSMin.Units            = 'Hardware';
AO.ICT.RMSMin.HWUnits          = 'mA';  % ???
AO.ICT.RMSMin.PhysicsUnits     = 'mA';  % ???

AO.ICT.RMSMax.MemberOf         = {'Diagnostics'; 'ICT'; 'Monitor'};
AO.ICT.RMSMax.Mode             = 'Simulator';
AO.ICT.RMSMax.DataType         = 'Scalar';
AO.ICT.RMSMax.ChannelNames     = {'BLM:0:dac20_max'; 'BLM:0:dac21_max'}; 
AO.ICT.RMSMax.HW2PhysicsParams = 1;    
AO.ICT.RMSMax.Physics2HWParams = 1;
AO.ICT.RMSMax.Units            = 'Hardware';
AO.ICT.RMSMax.HWUnits          = 'mA';  % ???
AO.ICT.RMSMax.PhysicsUnits     = 'mA';  % ???


% RF 
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'Gun';'RF';};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;
AO.RF.Position = 0;

AO.RF.Monitor              = getname_apex('RF', 'Monitor', 1);
AO.RF.Setpoint             = getname_apex('RF', 'Setpoint', 1);
AO.RF.Setpoint.Range = [185 189];  % 187 MHz nominal?
AO.RF.Setpoint.Tolerance = 1;
%AO.RF.Setpoint.SpecialFunctionSet = @setrf_apex;
%AO.RF.Setpoint.SpecialFunctionGet = @getrf_apex;
AO.RF.Permit               = getname_apex('RF', 'Permit', 1);
AO.RF.PermitIntlk          = getname_apex('RF', 'PermitIntlk', 1);
AO.RF.ArcDetect            = getname_apex('RF', 'ArcDetect', 1);
AO.RF.ArcDetectPowerSupply = getname_apex('RF', 'ArcDetectPowerSupply', 1);
AO.RF.Circ1Intlk           = getname_apex('RF', 'Circ1Intlk', 1);
AO.RF.Circ2Intlk           = getname_apex('RF', 'Circ2Intlk', 1);
AO.RF.SSPA                 = getname_apex('RF', 'SSPA', 1);
AO.RF.Tetrode              = getname_apex('RF', 'TetrodeIntlk', 1);
AO.RF.Power                = getname_apex('RF', 'Power', 1);
AO.RF.PowerIntlk           = getname_apex('RF', 'PowerIntlk', 1);
AO.RF.WaterFlow            = getname_apex('RF', 'WaterFlow', 1);
AO.RF.WaterFlowIntlk       = getname_apex('RF', 'WaterFlowIntlk', 1);
AO.RF.Temperature          = getname_apex('RF', 'Temperature', 1);
AO.RF.TemperatureIntlk     = getname_apex('RF', 'TemperatureIntlk', 1);
AO.RF.Vacuum               = getname_apex('RF', 'Vacuum', 1);
AO.RF.VacuumIntlk          = getname_apex('RF', 'VacuumIntlk', 1);
AO.RF.Pressure             = getname_apex('RF', 'Pressure', 1);
AO.RF.Reset                = getname_apex('RF', 'Reset', 1);
    

% LLRF
AO.LLRF = buildmmlllrf;


% Cavity Temperature Controls
% ???


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Convert to hardware units
% 'NoEnergyScaling' is needed so that the BEND is not read to get the energy (this is a setup file)  
%AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat,  AO.HCM.DeviceList,  'NoEnergyScaling');
%AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat,  AO.VCM.DeviceList,  'NoEnergyScaling');
%setao(AO);


