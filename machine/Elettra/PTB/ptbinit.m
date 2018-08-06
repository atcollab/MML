function ptbinit

% Applications and functions to try:
% 1. plotfmaily;
% 2. mmlviewer;  % To view the MML setup
% 3. modeltwiss('Orbit','drawlattice');
% 4. modeltwiss('Phase','drawlattice');

% Notes
% 1. ptb2at and at2ptb need work to convert control system units to AT units
% 2. Input proper .Ranges, .Tolerances, and .DeltaRespMat (hardware units)
% 3. run monmags to check the .Tolerance field
% 4. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)
% 5. Input conditions need to be put in TwissData in updateatindex.
% 7. QF and QD families could be combined to just Q.
% 8. getname_ptb is for channel names but I'm not sure how Tango works.  
%    I have Tango functions on the path from Soleil (Laurant) but I'm 
%    not sure how they work or if I have all that is needed. 


if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);


% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = [
    1 1
    2 1
    2 2
    2 3
    2 4];
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_ptb(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMy.Position    = [];

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_ptb(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = [
    1 1
    1 2
    1 3
    1 4
    2 1
    2 2
    2 3
    2 4
    ];
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];

AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_ptb(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @ptb2at;
AO.HCM.Monitor.Physics2HWFcn = @at2ptb;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_ptb(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @ptb2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2ptb;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-.01 .01];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 100e-6;
 

% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = [
    1 1
    1 2
    1 3
    1 4
    2 1
    2 2
    2 3
    2 4
    ];
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];

AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_ptb(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @ptb2at;
AO.VCM.Monitor.Physics2HWFcn = @at2ptb;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_ptb(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @ptb2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2ptb;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-.01 .01];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 100e-6;



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
AO.QF.FamilyName  = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector';};
AO.QF.DeviceList  = [
    1 1
    1 2
    2 1
    2 2
    2 3];
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status      = ones(size(AO.QF.DeviceList,1),1);
AO.QF.Position    = [];

AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_ptb(AO.QF.FamilyName, 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsFcn = @ptb2at;
AO.QF.Monitor.Physics2HWFcn = @at2ptb;
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_ptb(AO.QF.FamilyName, 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsFcn = @ptb2at;
AO.QF.Setpoint.Physics2HWFcn = @at2ptb;
AO.QF.Setpoint.Units        = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF.Setpoint.Range        = [-25 25];
AO.QF.Setpoint.Tolerance    = .1;
AO.QF.Setpoint.DeltaRespMat = .01;


AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD.DeviceList  = [
    1 1
    1 2
    1 3
    1 4
    2 1
    2 2
    2 3
    2 4
    2 5];
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status      = ones(size(AO.QD.DeviceList,1),1);
AO.QD.Position    = [];

AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_ptb(AO.QD.FamilyName, 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsFcn = @ptb2at;
AO.QD.Monitor.Physics2HWFcn = @at2ptb;
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_ptb(AO.QD.FamilyName, 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsFcn = @ptb2at;
AO.QD.Setpoint.Physics2HWFcn = @at2ptb;
AO.QD.Setpoint.Units        = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD.Setpoint.Range        = [-25 25];
AO.QD.Setpoint.Tolerance    = .1;
AO.QD.Setpoint.DeltaRespMat = .01;


%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = [2 1;2 2];
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];

AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_ptb(AO.BEND.FamilyName, 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @ptb2at;
AO.BEND.Monitor.Physics2HWFcn = @at2ptb;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_ptb(AO.BEND.FamilyName, 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @ptb2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2ptb;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radians';
AO.BEND.Setpoint.Range        = [-1 1];
AO.BEND.Setpoint.Tolerance    = .1;
AO.BEND.Setpoint.DeltaRespMat = .01;



%%%%%%%%%%
%   RF   %
%%%%%%%%%%
% AO.RF.FamilyName                = 'RF';
% AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
% AO.RF.DeviceList                = [ 1 1 ];
% AO.RF.ElementList               = 1;
% AO.RF.Status                    = 1;
% AO.RF.Position                  = 0;
% 
% AO.RF.Monitor.MemberOf          = {};
% AO.RF.Monitor.Mode              = 'Simulator';
% AO.RF.Monitor.DataType          = 'Scalar';
% AO.RF.Monitor.ChannelNames      = '';
% AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
% AO.RF.Monitor.Physics2HWParams  = 1e-6;
% AO.RF.Monitor.Units             = 'Hardware';
% AO.RF.Monitor.HWUnits           = 'MHz';
% AO.RF.Monitor.PhysicsUnits      = 'Hz';
% 
% AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
% AO.RF.Setpoint.Mode             = 'Simulator';
% AO.RF.Setpoint.DataType         = 'Scalar';
% AO.RF.Setpoint.ChannelNames     = '';
% AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
% AO.RF.Setpoint.Physics2HWParams = 1e-6;
% AO.RF.Setpoint.Units            = 'Hardware';
% AO.RF.Setpoint.HWUnits          = 'MHz';
% AO.RF.Setpoint.PhysicsUnits     = 'Hz';
% AO.RF.Setpoint.Range            = [0 500000];
% AO.RF.Setpoint.Tolerance        = 1.0;
% 
% AO.RF.VoltageCtrl.MemberOf          = {};
% AO.RF.VoltageCtrl.Mode              = 'Simulator';
% AO.RF.VoltageCtrl.DataType          = 'Scalar';
% AO.RF.VoltageCtrl.ChannelNames      = '';
% AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
% AO.RF.VoltageCtrl.Physics2HWParams  = 1;
% AO.RF.VoltageCtrl.Units             = 'Hardware';
% AO.RF.VoltageCtrl.HWUnits           = 'Volts';
% AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';
% 
% AO.RF.Voltage.MemberOf          = {};
% AO.RF.Voltage.Mode              = 'Simulator';
% AO.RF.Voltage.DataType          = 'Scalar';
% AO.RF.Voltage.ChannelNames      = '';
% AO.RF.Voltage.HW2PhysicsParams  = 1;
% AO.RF.Voltage.Physics2HWParams  = 1;
% AO.RF.Voltage.Units             = 'Hardware';
% AO.RF.Voltage.HWUnits           = 'Volts';
% AO.RF.Voltage.PhysicsUnits      = 'Volts';
% 
% AO.RF.Power.MemberOf          = {};
% AO.RF.Power.Mode              = 'Simulator';
% AO.RF.Power.DataType          = 'Scalar';
% AO.RF.Power.ChannelNames      = '';
% AO.RF.Power.HW2PhysicsParams  = 1;         
% AO.RF.Power.Physics2HWParams  = 1;
% AO.RF.Power.Units             = 'Hardware';
% AO.RF.Power.HWUnits           = 'MWatts';           
% AO.RF.Power.PhysicsUnits      = 'MWatts';
% AO.RF.Power.Range             = [-inf inf]; 
% AO.RF.Power.Tolerance         = Inf;  
% 
% AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
% AO.RF.Phase.Mode              = 'Simulator';
% AO.RF.Phase.DataType          = 'Scalar';
% AO.RF.Phase.ChannelNames      = ''; 
% AO.RF.Phase.Units             = 'Hardware';
% AO.RF.Phase.HW2PhysicsParams  = 1; 
% AO.RF.Phase.Physics2HWParams  = 1;
% AO.RF.Phase.HWUnits           = 'Degrees';  
% AO.RF.Phase.PhysicsUnits      = 'Degrees';
% 
% AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
% AO.RF.PhaseCtrl.Mode              = 'Simulator';
% AO.RF.PhaseCtrl.DataType          = 'Scalar';
% AO.RF.PhaseCtrl.ChannelNames      = '';
% AO.RF.PhaseCtrl.Units             = 'Hardware';
% AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;         
% AO.RF.PhaseCtrl.Physics2HWParams  = 1;
% AO.RF.PhaseCtrl.HWUnits           = 'Degrees';  
% AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees'; 
% AO.RF.PhaseCtrl.Range             = [-200 200]; 
% AO.RF.PhaseCtrl.Tolerance         = 10;
% 


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Convert to hardware units
% 'NoEnergyScaling' is needed so that the BEND is not read to get the energy (this is a setup file)  
AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat,  AO.HCM.DeviceList,  'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat,  AO.VCM.DeviceList,  'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat   = physics2hw('QF',  'Setpoint', AO.QF.Setpoint.DeltaRespMat,   AO.QF.DeviceList,   'NoEnergyScaling');
AO.QD.Setpoint.DeltaRespMat   = physics2hw('QD',  'Setpoint', AO.QD.Setpoint.DeltaRespMat,   AO.QD.DeviceList,   'NoEnergyScaling');
setao(AO);


 