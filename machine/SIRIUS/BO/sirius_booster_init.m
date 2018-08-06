function sirius_booster_init(OperationalMode)

if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));

AD.Directory.ExcDataDir  = '/home/fac_files/siriusdb/excitation_curves';

%AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);

% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;

% BENDS

AO.b.FamilyName  = 'b';
AO.b.MemberOf    = {'PlotFamily'; 'b'; 'BEND'; 'Magnet';};
AO.b.DeviceList  = getDeviceList(5,10);
AO.b.ElementList = (1:size(AO.b.DeviceList,1))';
AO.b.Status      = ones(size(AO.b.DeviceList,1),1);
AO.b.Position    = [];
AO.b.PowerSupplies = ['bend_a'; 'bend_b']; 

AO.b.ExcitationCurves            = sirius_getexcdata(repmat('boma-bend', size(AO.b.DeviceList,1), 1)); 
AO.b.Monitor.MemberOf            = {};
AO.b.Monitor.Mode                = 'Simulator';
AO.b.Monitor.DataType            = 'Scalar';
AO.b.Monitor.SpecialFunctionGet  = @sirius_bo_bendget;
AO.b.Monitor.SpecialFunctionSet  = @sirius_bo_bendset;
AO.b.Monitor.HW2PhysicsFcn       = @bend2gev;
AO.b.Monitor.Physics2HWFcn       = @gev2bend;
AO.b.Monitor.Units               = 'Hardware';
AO.b.Monitor.HWUnits             = 'Ampere';
AO.b.Monitor.PhysicsUnits        = 'GeV';

AO.b.Setpoint.MemberOf           = {'MachineConfig';};
AO.b.Setpoint.Mode               = 'Simulator';
AO.b.Setpoint.DataType           = 'Scalar';
AO.b.Setpoint.SpecialFunctionGet = @sirius_bo_bendget;
AO.b.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.b.Setpoint.HW2PhysicsFcn      = @bend2gev;
AO.b.Setpoint.Physics2HWFcn      = @gev2bend;
AO.b.Setpoint.Units              = 'Hardware';
AO.b.Setpoint.HWUnits            = 'Ampere';
AO.b.Setpoint.PhysicsUnits       = 'GeV';
AO.b.Setpoint.Range              = [0 300];
AO.b.Setpoint.Tolerance          = .1;
AO.b.Setpoint.DeltaRespMat       = .01;

AO.bend_a.FamilyName            = 'bend_a';
AO.bend_a.MemberOf              = {'BendPS', 'PowerSupply'};
AO.bend_a.DeviceList            = getDeviceList(5,10);
AO.bend_a.ElementList           = (1:size(AO.bend_a.DeviceList,1))';
AO.bend_a.Status                = ones(size(AO.bend_a.DeviceList,1),1);
AO.bend_a.Magnet                = 'b';
AO.bend_a.Monitor.MemberOf      = {};
AO.bend_a.Monitor.Mode          = 'Simulator';
AO.bend_a.Monitor.DataType      = 'Scalar';
AO.bend_a.Monitor.ChannelNames  = repmat(sirius_booster_getname(AO.bend_a.FamilyName, 'Monitor'), size(AO.bend_a.DeviceList, 1), 1);
AO.bend_a.Monitor.Units         = 'Hardware';
AO.bend_a.Monitor.HWUnits       = 'Ampere';
AO.bend_a.Setpoint.MemberOf     = {'MachineConfig'};
AO.bend_a.Setpoint.Mode         = 'Simulator';
AO.bend_a.Setpoint.DataType     = 'Scalar';
AO.bend_a.Setpoint.ChannelNames = repmat(sirius_booster_getname(AO.bend_a.FamilyName, 'Setpoint'), size(AO.bend_a.DeviceList, 1), 1);
AO.bend_a.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.bend_a.Setpoint.Units        = 'Hardware';
AO.bend_a.Setpoint.HWUnits      = 'Ampere';
AO.bend_a.Setpoint.Range        = [0 300];
AO.bend_a.Setpoint.Tolerance    = .1;
AO.bend_a.Setpoint.DeltaRespMat = .01;

AO.bend_b.FamilyName            = 'bend_b';
AO.bend_b.MemberOf              = {'BendPS', 'PowerSupply'};
AO.bend_b.DeviceList            = getDeviceList(5,10);
AO.bend_b.ElementList           = (1:size(AO.bend_b.DeviceList,1))';
AO.bend_b.Status                = ones(size(AO.bend_b.DeviceList,1),1);
AO.bend_b.Magnet                = 'b';
AO.bend_b.Monitor.MemberOf      = {};
AO.bend_b.Monitor.Mode          = 'Simulator';
AO.bend_b.Monitor.DataType      = 'Scalar';
AO.bend_b.Monitor.ChannelNames  = repmat(sirius_booster_getname(AO.bend_b.FamilyName, 'Monitor'), size(AO.bend_b.DeviceList, 1), 1);
AO.bend_b.Monitor.Units         = 'Hardware';
AO.bend_b.Monitor.HWUnits       = 'Ampere';
AO.bend_b.Setpoint.MemberOf     = {'MachineConfig'};
AO.bend_b.Setpoint.Mode         = 'Simulator';
AO.bend_b.Setpoint.DataType     = 'Scalar';
AO.bend_b.Setpoint.ChannelNames = repmat(sirius_booster_getname(AO.bend_b.FamilyName, 'Setpoint'), size(AO.bend_b.DeviceList, 1), 1);
AO.bend_b.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.bend_b.Setpoint.Units        = 'Hardware';
AO.bend_b.Setpoint.HWUnits      = 'Ampere';
AO.bend_b.Setpoint.Range        = [0 300];
AO.bend_b.Setpoint.Tolerance    = .1;
AO.bend_b.Setpoint.DeltaRespMat = .01;

% QUADS
AO.qd.FamilyName  = 'qd';
AO.qd.MemberOf    = {'PlotFamily'; 'qd'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.qd.DeviceList  = getDeviceList(5,5);
AO.qd.ElementList = (1:size(AO.qd.DeviceList,1))';
AO.qd.Status      = ones(size(AO.qd.DeviceList,1),1);
AO.qd.Position    = [];
AO.qd.ExcitationCurves = sirius_getexcdata(repmat('boma-qd', size(AO.qd.DeviceList,1), 1)); 
AO.qd.Monitor.MemberOf = {};
AO.qd.Monitor.Mode = 'Simulator';
AO.qd.Monitor.DataType = 'Scalar';
AO.qd.Monitor.Units        = 'Hardware';
AO.qd.Monitor.HWUnits      = 'Ampere';
AO.qd.Monitor.PhysicsUnits = 'meter^-2';
AO.qd.Monitor.ChannelNames = repmat(sirius_booster_getname('qd_fam', 'Monitor'), size(AO.qd.DeviceList,1), 1);
AO.qd.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qd.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qd.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd.Setpoint.Mode          = 'Simulator';
AO.qd.Setpoint.DataType      = 'Scalar';
AO.qd.Setpoint.Units         = 'Hardware';
AO.qd.Setpoint.HWUnits       = 'Ampere';
AO.qd.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd.Setpoint.ChannelNames  = repmat(sirius_booster_getname('qd_fam', 'Setpoint'), size(AO.qd.DeviceList,1), 1);
AO.qd.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd.Setpoint.Range         = [-5 5];
AO.qd.Setpoint.Tolerance     = 0.002;
AO.qd.Setpoint.DeltaRespMat  = 0.05; 

AO.qf.FamilyName = 'qf';
AO.qf.MemberOf    = {'PlotFamily'; 'qf'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.qf.DeviceList  = getDeviceList(5,10);
AO.qf.ElementList = (1:size(AO.qf.DeviceList,1))';
AO.qf.Status      = ones(size(AO.qf.DeviceList,1),1);
AO.qf.Position    = [];
AO.qf.ExcitationCurves = sirius_getexcdata(repmat('boma-qf', size(AO.qf.DeviceList,1), 1)); 
AO.qf.Monitor.MemberOf = {};
AO.qf.Monitor.Mode = 'Simulator';
AO.qf.Monitor.DataType = 'Scalar';
AO.qf.Monitor.Units        = 'Hardware';
AO.qf.Monitor.HWUnits      = 'Ampere';
AO.qf.Monitor.PhysicsUnits = 'meter^-2';
AO.qf.Monitor.ChannelNames = repmat(sirius_booster_getname('qf_fam', 'Monitor'), size(AO.qf.DeviceList,1), 1);
AO.qf.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qf.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qf.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf.Setpoint.Mode          = 'Simulator';
AO.qf.Setpoint.DataType      = 'Scalar';
AO.qf.Setpoint.Units         = 'Hardware';
AO.qf.Setpoint.HWUnits       = 'Ampere';
AO.qf.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf.Setpoint.ChannelNames = repmat(sirius_booster_getname('qf_fam', 'Setpoint'), size(AO.qf.DeviceList,1), 1);
AO.qf.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf.Setpoint.Range         = [-5 5];
AO.qf.Setpoint.Tolerance     = 0.002;
AO.qf.Setpoint.DeltaRespMat  = 0.05; 

%SEXT
AO.sd.FamilyName = 'sd';
AO.sd.MemberOf    = {'PlotFamily'; 'sd'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.sd.DeviceList  = getDeviceList(5,2);
AO.sd.ElementList = (1:size(AO.sd.DeviceList,1))';
AO.sd.Status      = ones(size(AO.sd.DeviceList,1),1);
AO.sd.Position    = [];
AO.sd.ExcitationCurves = sirius_getexcdata(repmat('boma-sd', size(AO.sd.DeviceList,1), 1)); 
AO.sd.Monitor.MemberOf = {};
AO.sd.Monitor.Mode = 'Simulator';
AO.sd.Monitor.DataType = 'Scalar';
AO.sd.Monitor.Units        = 'Hardware';
AO.sd.Monitor.HWUnits      = 'Ampere';
AO.sd.Monitor.PhysicsUnits = 'meter^-3';
AO.sd.Monitor.ChannelNames = repmat(sirius_booster_getname('sd_fam', 'Monitor'), size(AO.sd.DeviceList,1), 1);
AO.sd.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.sd.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.sd.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd.Setpoint.Mode          = 'Simulator';
AO.sd.Setpoint.DataType      = 'Scalar';
AO.sd.Setpoint.Units         = 'Hardware';
AO.sd.Setpoint.HWUnits       = 'Ampere';
AO.sd.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd.Setpoint.ChannelNames  = repmat(sirius_booster_getname('sd_fam', 'Setpoint'), size(AO.sd.DeviceList,1), 1);
AO.sd.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.sd.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.sd.Setpoint.Range         = [-500 500];
AO.sd.Setpoint.Tolerance     = 0.05;
AO.sd.Setpoint.DeltaRespMat  = 0.1; 

AO.sf.FamilyName = 'sf';
AO.sf.MemberOf    = {'PlotFamily'; 'sf'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.sf.DeviceList  = getDeviceList(5,5);
AO.sf.ElementList = (1:size(AO.sf.DeviceList,1))';
AO.sf.Status      = ones(size(AO.sf.DeviceList,1),1);
AO.sf.Position    = [];
AO.sf.ExcitationCurves = sirius_getexcdata(repmat('boma-sf', size(AO.sf.DeviceList,1), 1)); 
AO.sf.Monitor.MemberOf = {};
AO.sf.Monitor.Mode = 'Simulator';
AO.sf.Monitor.DataType = 'Scalar';
AO.sf.Monitor.Units        = 'Hardware';
AO.sf.Monitor.HWUnits      = 'Ampere';
AO.sf.Monitor.PhysicsUnits = 'meter^-3';
AO.sf.Monitor.ChannelNames = repmat(sirius_booster_getname('sf_fam', 'Monitor'), size(AO.sf.DeviceList,1), 1);
AO.sf.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.sf.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.sf.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf.Setpoint.Mode          = 'Simulator';
AO.sf.Setpoint.DataType      = 'Scalar';
AO.sf.Setpoint.Units         = 'Hardware';
AO.sf.Setpoint.HWUnits       = 'Ampere';
AO.sf.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf.Setpoint.ChannelNames = repmat(sirius_booster_getname('sf_fam', 'Setpoint'), size(AO.sf.DeviceList,1), 1);
AO.sf.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.sf.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.sf.Setpoint.Range         = [-500 500];
AO.sf.Setpoint.Tolerance     = 0.05;
AO.sf.Setpoint.DeltaRespMat  = 0.1; 

% HCM
AO.ch.FamilyName  = 'ch';
AO.ch.MemberOf    = {'PlotFamily'; 'COR'; 'ch'; 'Magnet'; 'HCM'};
AO.ch.DeviceList  = getDeviceList(5,5);
AO.ch.ElementList = (1:size(AO.ch.DeviceList,1))';
AO.ch.Status      = ones(size(AO.ch.DeviceList,1),1);
AO.ch.Position    = [];
AO.ch.ExcitationCurves = sirius_getexcdata(repmat('boma-ch', size(AO.ch.DeviceList,1), 1)); 
AO.ch.Monitor.MemberOf = {'Horizontal'; 'COR'; 'ch'; 'Magnet';};
AO.ch.Monitor.Mode = 'Simulator';
AO.ch.Monitor.DataType = 'Scalar';
AO.ch.Monitor.Units        = 'Physics';
AO.ch.Monitor.HWUnits      = 'Ampere';
AO.ch.Monitor.PhysicsUnits = 'Radian';
AO.ch.Monitor.ChannelNames = sirius_booster_getname(AO.ch.FamilyName, 'Monitor', AO.ch.DeviceList) ;
AO.ch.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.ch.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.ch.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'ch'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.ch.Setpoint.Mode = 'Simulator';
AO.ch.Setpoint.DataType = 'Scalar';
AO.ch.Setpoint.Units        = 'Physics';
AO.ch.Setpoint.HWUnits      = 'Ampere';
AO.ch.Setpoint.PhysicsUnits = 'Radian';
AO.ch.Setpoint.ChannelNames = sirius_booster_getname(AO.ch.FamilyName, 'Setpoint', AO.ch.DeviceList);
AO.ch.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.ch.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.ch.Setpoint.Range        = [-10 10];
AO.ch.Setpoint.Tolerance    = 0.00001;
AO.ch.Setpoint.DeltaRespMat = 0.0005; 


% VCM
AO.cv.FamilyName  = 'cv';
AO.cv.MemberOf    = {'PlotFamily'; 'COR'; 'cv'; 'Magnet'; 'VCM'};
AO.cv.DeviceList  = getDeviceList(5,5);
AO.cv.ElementList = (1:size(AO.cv.DeviceList,1))';
AO.cv.Status      = ones(size(AO.cv.DeviceList,1),1);
AO.cv.Position    = [];
AO.cv.ExcitationCurves = sirius_getexcdata(repmat('boma-cv', size(AO.cv.DeviceList,1), 1)); 
AO.cv.Monitor.MemberOf = {'Vertical'; 'COR'; 'cv'; 'Magnet';};
AO.cv.Monitor.Mode = 'Simulator';
AO.cv.Monitor.DataType = 'Scalar';
AO.cv.Monitor.Units        = 'Physics';
AO.cv.Monitor.HWUnits      = 'Ampere';
AO.cv.Monitor.PhysicsUnits = 'Radian';
AO.cv.Monitor.ChannelNames = sirius_booster_getname(AO.cv.FamilyName, 'Monitor', AO.cv.DeviceList) ;
AO.cv.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.cv.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.cv.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'cv'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.cv.Setpoint.Mode = 'Simulator';
AO.cv.Setpoint.DataType = 'Scalar';
AO.cv.Setpoint.Units        = 'Physics';
AO.cv.Setpoint.HWUnits      = 'Ampere';
AO.cv.Setpoint.PhysicsUnits = 'Radian';
AO.cv.Setpoint.ChannelNames = sirius_booster_getname(AO.cv.FamilyName, 'Setpoint', AO.cv.DeviceList);
AO.cv.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.cv.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.cv.Setpoint.Range        = [-10 10];
AO.cv.Setpoint.Tolerance    = 0.00001;
AO.cv.Setpoint.DeltaRespMat = 0.0005; 

% BPMx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(5,10);
AO.bpmx.ElementList = (1:size(AO.bpmx.DeviceList,1))';
AO.bpmx.Status      = ones(size(AO.bpmx.DeviceList,1),1);
AO.bpmx.Position    = [];
AO.bpmx.Golden      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Offset      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Monitor.MemberOf = {'bpmx'; 'Monitor';};
AO.bpmx.Monitor.Mode = 'Simulator';
AO.bpmx.Monitor.DataType = 'Scalar';
AO.bpmx.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams =  1e6;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'um';
AO.bpmx.Monitor.PhysicsUnits = 'meter';
AO.bpmx.Monitor.ChannelNames = sirius_booster_getname(AO.bpmx.FamilyName, 'Monitor', AO.bpmx.DeviceList) ;

% BPMy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(5,10);
AO.bpmy.ElementList = (1:size(AO.bpmy.DeviceList,1))';
AO.bpmy.Status      = ones(size(AO.bpmy.DeviceList,1),1);
AO.bpmy.Position    = [];
AO.bpmy.Golden      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Offset      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Monitor.MemberOf = {'bpmy'; 'Monitor';};
AO.bpmy.Monitor.Mode = 'Simulator';
AO.bpmy.Monitor.DataType = 'Scalar';
AO.bpmy.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams =  1e6;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'um';
AO.bpmy.Monitor.PhysicsUnits = 'meter';
AO.bpmy.Monitor.ChannelNames = sirius_booster_getname(AO.bpmy.FamilyName, 'Monitor', AO.bpmy.DeviceList) ;

%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.TUNE.Monitor.MemberOf   = {'TUNE'};
AO.TUNE.Monitor.ChannelNames = sirius_booster_getname(AO.TUNE.FamilyName, 'Monitor');
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';

%%%%%%%%%%
%   RF   %
%%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';
AO.RF.Monitor.ChannelNames      = sirius_booster_getname(AO.RF.FamilyName, 'Monitor') ;

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [400.0 600.0];
AO.RF.Setpoint.Tolerance        = 1.0;
AO.RF.Setpoint.ChannelNames     = sirius_booster_getname(AO.RF.FamilyName, 'Setpoint') ;

AO.RF.VoltageCtrl.MemberOf          = {};
AO.RF.VoltageCtrl.Mode              = 'Simulator';
AO.RF.VoltageCtrl.DataType          = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames      = '';
AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
AO.RF.VoltageCtrl.Physics2HWParams  = 1;
AO.RF.VoltageCtrl.Units             = 'Hardware';
AO.RF.VoltageCtrl.HWUnits           = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';

AO.RF.Voltage.MemberOf          = {};
AO.RF.Voltage.Mode              = 'Simulator';
AO.RF.Voltage.DataType          = 'Scalar';
AO.RF.Voltage.ChannelNames      = '';
AO.RF.Voltage.HW2PhysicsParams  = 1;
AO.RF.Voltage.Physics2HWParams  = 1;
AO.RF.Voltage.Units             = 'Hardware';
AO.RF.Voltage.HWUnits           = 'Volts';
AO.RF.Voltage.PhysicsUnits      = 'Volts';

AO.RF.Power.MemberOf          = {};
AO.RF.Power.Mode              = 'Simulator';
AO.RF.Power.DataType          = 'Scalar';
AO.RF.Power.ChannelNames      = '';          % ???
AO.RF.Power.HW2PhysicsParams  = 1;         
AO.RF.Power.Physics2HWParams  = 1;
AO.RF.Power.Units             = 'Hardware';
AO.RF.Power.HWUnits           = 'MWatts';           
AO.RF.Power.PhysicsUnits      = 'MWatts';
AO.RF.Power.Range             = [-inf inf];  % ???  
AO.RF.Power.Tolerance         = inf;  % ???  

AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
AO.RF.Phase.Mode              = 'Simulator';
AO.RF.Phase.DataType          = 'Scalar';
AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???  
AO.RF.Phase.Units             = 'Hardware';
AO.RF.Phase.HW2PhysicsParams  = 1; 
AO.RF.Phase.Physics2HWParams  = 1;
AO.RF.Phase.HWUnits           = 'Degrees';  
AO.RF.Phase.PhysicsUnits      = 'Degrees';

AO.RF.PhaseCtrl.MemberOf          = {'RF; Phase'; 'Control'};  % 'MachineConfig';
AO.RF.PhaseCtrl.Mode              = 'Simulator';
AO.RF.PhaseCtrl.DataType          = 'Scalar';
AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???     
AO.RF.PhaseCtrl.Units             = 'Hardware';
AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;         
AO.RF.PhaseCtrl.Physics2HWParams  = 1;
AO.RF.PhaseCtrl.HWUnits           = 'Degrees';  
AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees'; 
AO.RF.PhaseCtrl.Range             = [-200 200];    % ??? 
AO.RF.PhaseCtrl.Tolerance         = 10;    % ??? 

%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%

AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'AMC03';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'Ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';
AO.DCCT.Monitor.ChannelNames     = repmat(sirius_booster_getname(AO.DCCT.FamilyName, 'Monitor'), size(AO.DCCT.DeviceList,1), 1); 

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
% setoperationalmode(OperationalMode);


 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end



