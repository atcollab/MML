function umerinit(OperationalMode)
%UMERINIT - MML initialization program for University of Maryland accelerator


%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet center  (often overwritten in updateatindex)
% CommonNames           Shortcut name for each element
%
% Monitor Fields
% Mode                  online/manual/special/simulator
% ChannelNames          PV for monitor
% Units                 Physics or HW
% HW2PhysicsFcn         function handle used to convert from hardware to physics units ==> inline will not compile, see below
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';           
% PhysicsUnits          units for physics 'Rad';
%
% Setpoint Fields
% Mode                  online/manual/special/simulator
% ChannelNames          PV for monitor
% Units                 hardware or physics
% HW2PhysicsFcn         function handle used to convert from hardware to physics units
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';           
% PhysicsUnits          units for physics 'Rad';
% Range                 minsetpoint, maxsetpoint;
% Tolerance             setpoint-monitor


% NOTES
% 1. Magnet positions get overwritten in updateatindex.  
%    Ie, positions will come directly from the AT model.

% TO DO
% add channelnames and getpvonline for SetPoint values. This will probably
% load a magnet settings file to use?
%
%
%

if nargin < 1
    OperationalMode = 1;
end


% Clear the AO 
setao([]); 

%  # of BPM HCM VCM QF QD BEND
Cell1 = [1   2   1  2  2  2];
Cell2 = [0   2   1  2  2  2];
Cell3 = [1   2   3  2  2  2];
CellY = [0   3   1  2  2  2];
a = [
    1   Cell1
    2   Cell1
    3   Cell1
    4   Cell2
    5   Cell3
    6   Cell3
    7   Cell3
    8   Cell3
    9   Cell3
    10  Cell2
    11  Cell3
    12  Cell1
    13  Cell1
    14  Cell1
    15  Cell1
    16  Cell2
    17  Cell1
    18  CellY
    ];


%%%%%%%%%%%%%%%
%  BPMx/BPMy  %
%%%%%%%%%%%%%%%

% BPMx, N = 14
BPMxcell = {
'RC1x'
'RC2x'
'RC3x'
'RC5x'
'RC6x'
'RC7x'
'RC8x'
'RC9x'
'RC11x'
'RC12x'
'RC13x'
'RC14x'
'RC15x'
'RC17x'
};
BPMycell = {
'RC1y'
'RC2y'
'RC3y'
'RC5y'
'RC6y'
'RC7y'
'RC8y'
'RC9y'
'RC11y'
'RC12y'
'RC13y'
'RC14y'
'RC15y'
'RC17y'
};

AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,2)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.BPMx.DeviceList = DeviceList;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.CommonNames = BPMxcell;

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = BPMxcell;
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = BPMycell;

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = BPMycell;
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM, N = 37
HCMcell = {
'D1'
'D2'
'D3'
'D4'
'D5'
'D6'
'D7'
'D8'
'D9'
'D10'
'D11'
'D12'
'D13'
'D14'
'D15'
'D16'
'D17'
'D18'
'D19'
'D20'
'D21'
'D22'
'D23'
'D24'
'D25'
'D26'
'D27'
'D28'
'D29'
'D30'
'D31'
'D32'
'D33'
'D34'
'D35'
'PD-Rec'
'SDR6H'
};
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,3)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.HCM.DeviceList = DeviceList;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Status(end-1) = 0; % don't use PD-Rec for anything
AO.HCM.Position    = [];
AO.HCM.CommonNames = HCMcell; % same as channel names

AO.HCM.Monitor.MemberOf = {'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Online';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = strcat('Mon',HCMcell);
AO.HCM.Monitor.HW2PhysicsFcn = @umer2at;
AO.HCM.Monitor.Physics2HWFcn = @at2umer;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = strcat('Set',HCMcell);
AO.HCM.Setpoint.HW2PhysicsFcn = @umer2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2umer;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range = [-3, 3];
AO.HCM.Setpoint.Tolerance = .001;
AO.HCM.Setpoint.DeltaRespMat = 0.1;
 

% VCM, N = 30
% VCM
VCMcell= {
'RSV1'
'RSV2'
'RSV3'
'RSV4'
'RSV5'
'RSV6'
'RSV7'
'RSV8'
'RSV9'
'RSV10'
'RSV11'
'RSV12'
'RSV13'
'RSV14'
'RSV15'
'RSV16'
'RSV17'
'RSV18'
'SSV9'
'SSV10'
'SSV11'
'SSV12'
'SSV13'
'SSV14'
'SSV15'
'SSV16'
'SSV17'
'SSV18' % figure out where extra 3 steerers appear
'SSV19'
'SSV20'
};

AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,4)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.VCM.DeviceList = DeviceList;AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = VCMcell; % same as channel names

AO.VCM.Monitor.MemberOf = {'COR'; 'Vertical'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Online';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = strcat('Mon',VCMcell);
AO.VCM.Monitor.HW2PhysicsFcn = @umer2at;
AO.VCM.Monitor.Physics2HWFcn = @at2umer;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Vertical'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = strcat('Set',VCMcell);
AO.VCM.Setpoint.HW2PhysicsFcn = @umer2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2umer;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range = [-2, 2];
AO.VCM.Setpoint.Tolerance = .001;
AO.VCM.Setpoint.DeltaRespMat = 0.1;



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%

% QF, N = 36
QFcell = {
'QR1'
'QR3'
'QR5'
'QR7'
'QR9'
'QR11'
'QR13'
'QR15'
'QR17'
'QR19'
'QR21'
'QR23'
'QR25'
'QR27'
'QR29'
'QR31'
'QR33'
'QR35'
'QR37'
'QR39'
'QR41'
'QR43'
'QR45'
'QR47'
'QR49'
'QR51'
'QR53'
'QR55'
'QR57'
'QR59'
'QR61'
'QR63'
'QR65'
'QR67'
'QR69'
'QR71'
};

AO.QF.FamilyName  = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,5)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.QF.DeviceList  = DeviceList;
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status      = ones(size(AO.QF.DeviceList,1),1);
AO.QF.Position    = [];
AO.QF.CommonNames = QFcell; % same as channel names

AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Online';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = strcat('Mon',QFcell);
AO.QF.Monitor.HW2PhysicsFcn = @umer2at;
AO.QF.Monitor.Physics2HWFcn = @at2umer;
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = strcat('Set',QFcell);
AO.QF.Setpoint.HW2PhysicsFcn = @umer2at;
AO.QF.Setpoint.Physics2HWFcn = @at2umer;
AO.QF.Setpoint.Units        = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF.Setpoint.Range = [0, 2.5];
AO.QF.Setpoint.Tolerance = .001;
AO.QF.Setpoint.DeltaRespMat = 0.1;


% QD, N = 36
QDcell = {
'QR2'
'QR4'
'QR6'
'QR8'
'QR10'
'QR12'
'QR14'
'QR16'
'QR18'
'QR20'
'QR22'
'QR24'
'QR26'
'QR28'
'QR30'
'QR32'
'QR34'
'QR36'
'QR38'
'QR40'
'QR42'
'QR44'
'QR46'
'QR48'
'QR50'
'QR52'
'QR54'
'QR56'
'QR58'
'QR60'
'QR62'
'QR64'
'QR66'
'QR68'
'QR70'
'YQ'
};
AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,6)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.QD.DeviceList = DeviceList;
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status      = ones(size(AO.QD.DeviceList,1),1);
AO.QD.Position    = [];
AO.QD.CommonNames = QDcell;

AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Online';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = strcat('Mon',QDcell);
AO.QD.Monitor.HW2PhysicsFcn = @umer2at;
AO.QD.Monitor.Physics2HWFcn = @at2umer;
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = strcat('Set',QDcell);
AO.QD.Setpoint.HW2PhysicsFcn = @umer2at;
AO.QD.Setpoint.Physics2HWFcn = @at2umer;
AO.QD.Setpoint.Units        = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD.Setpoint.Range = [0,2.5]; % note some magnets have different ranges how to program this in?
AO.QD.Setpoint.Tolerance = .001;
AO.QD.Setpoint.DeltaRespMat = 0.1;


% BEND, N = 36
BENDcell = {
'D1'
'D2'
'D3'
'D4'
'D5'
'D6'
'D7'
'D8'
'D9'
'D10'
'D11'
'D12'
'D13'
'D14'
'D15'
'D16'
'D17'
'D18'
'D19'
'D20'
'D21'
'D22'
'D23'
'D24'
'D25'
'D26'
'D27'
'D28'
'D29'
'D30'
'D31'
'D32'
'D33'
'D34'
'D35'
'PD-Rec'
};

AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet'; 'HCM'; 'COR';};
DeviceList = [];
for i = 1:size(a,1)
    for j = 1:a(i,7)
        DeviceList = [DeviceList; [i j]];
    end
end
AO.BEND.DeviceList = DeviceList;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];
AO.BEND.CommonNames = BENDcell; % same as channel names

AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Online';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = strcat('Mon',BENDcell);
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = strcat('Set',BENDcell);
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = [-Inf Inf];
AO.BEND.Setpoint.Tolerance    = .001;
AO.BEND.Setpoint.DeltaRespMat = 0.1;


%%%%%%%%%
%   RF  %
%%%%%%%%%

% no rf in UMER
% (low energy beam, no synchrotron radiation)
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;
AO.RF.CommonNames               = 'RF';

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.ChannelNames      = '';  % ???
AO.RF.Monitor.HW2PhysicsParams  = 1e+3;
AO.RF.Monitor.Physics2HWParams  = 1e-3;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'kHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = '';  % ???
AO.RF.Setpoint.HW2PhysicsParams = 1e+3;
AO.RF.Setpoint.Physics2HWParams = 1e-3;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'kHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [0 500000];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageCtrl.MemberOf          = {};
AO.RF.VoltageCtrl.Mode              = 'Simulator';
AO.RF.VoltageCtrl.DataType          = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames      = '';    % ???
AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
AO.RF.VoltageCtrl.Physics2HWParams  = 1;
AO.RF.VoltageCtrl.Units             = 'Hardware';
AO.RF.VoltageCtrl.HWUnits           = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 0;
AO.DCCT.CommonNames              = 'DCCT';

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'DCCT';      % Will add this in
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'mA';
AO.DCCT.Monitor.PhysicsUnits     = 'mA';



%%%%%%%%
% Tune %
%%%%%%%%

% no idea what this is
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = 'TUNE';

AO.TUNE.Monitor.MemberOf   = {'TUNE';};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.ChannelNames = '';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_umer';


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
%AO.QF.Setpoint.DeltaRespMat   = physics2hw('QF',  'Setpoint', AO.QF.Setpoint.DeltaRespMat,   AO.QF.DeviceList,   'NoEnergyScaling');
%AO.QD.Setpoint.DeltaRespMat   = physics2hw('QD',  'Setpoint', AO.QD.Setpoint.DeltaRespMat,   AO.QD.DeviceList,   'NoEnergyScaling');
%AO.SF.Setpoint.DeltaRespMat   = physics2hw('SF',  'Setpoint', AO.SF.Setpoint.DeltaRespMat,   AO.SF.DeviceList,   'NoEnergyScaling');
%AO.SD.Setpoint.DeltaRespMat   = physics2hw('SD',  'Setpoint', AO.SD.Setpoint.DeltaRespMat,   AO.SD.DeviceList,   'NoEnergyScaling');
setao(AO);


