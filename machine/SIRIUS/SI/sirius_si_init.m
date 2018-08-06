function sirius_si_init
%SIRIUSINIT - MML initialization file for the VUV ring at sirius3
%
%  See also setoperationalmode

%  PS: All the Fields 'Position' are built in the 'updateatindex.m' script.

% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso
%
setao([]);
setad([]);

[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir  = '/home/fac_files/lnls-sirius/control-system-constants/magnet/excitation-data';
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);


%% dipoles

AO.B1.FamilyName  = 'B1';
AO.B1.MemberOf    = {'PlotFamily'; 'B1'; 'BEND'; 'Magnet';};
AO.B1.DeviceList  = getDeviceList(20,2);
AO.B1.ElementList = (1:size(AO.B1.DeviceList,1))';
AO.B1.Status      = ones(size(AO.B1.DeviceList,1),1);
AO.B1.Position    = [];
AO.B1.ExcitationCurves = sirius_getexcdata(repmat('si-dipole-b1b2-fam',size(AO.B1.DeviceList,1),1));

AO.B1.Monitor.MemberOf = {};
AO.B1.Monitor.Mode = 'Simulator';
AO.B1.Monitor.DataType = 'Scalar';
AO.B1.Monitor.ChannelNames = sirius_si_getname(AO.B1.FamilyName, 'Monitor', AO.B1.DeviceList);
AO.B1.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B1.Monitor.Physics2HWFcn = @gev2bend;
AO.B1.Monitor.Units        = 'Hardware';
AO.B1.Monitor.HWUnits      = 'Ampere';
AO.B1.Monitor.PhysicsUnits = 'GeV';

AO.B1.ReferenceMonitor.MemberOf = {};
AO.B1.ReferenceMonitor.Mode = 'Simulator';
AO.B1.ReferenceMonitor.DataType = 'Scalar';
AO.B1.ReferenceMonitor.ChannelNames = sirius_si_getname(AO.B1.FamilyName, 'ReferenceMonitor', AO.B1.DeviceList);
AO.B1.ReferenceMonitor.HW2PhysicsFcn = @bend2gev;
AO.B1.ReferenceMonitor.Physics2HWFcn = @gev2bend;
AO.B1.ReferenceMonitor.Units        = 'Hardware';
AO.B1.ReferenceMonitor.HWUnits      = 'Ampere';
AO.B1.ReferenceMonitor.PhysicsUnits = 'GeV';

AO.B1.Readback.MemberOf = {};
AO.B1.Readback.Mode = 'Simulator';
AO.B1.Readback.DataType = 'Scalar';
AO.B1.Readback.ChannelNames = sirius_si_getname(AO.B1.FamilyName, 'Readback', AO.B1.DeviceList);
AO.B1.Readback.HW2PhysicsFcn = @bend2gev;
AO.B1.Readback.Physics2HWFcn = @gev2bend;
AO.B1.Readback.Units        = 'Hardware';
AO.B1.Readback.HWUnits      = 'Ampere';
AO.B1.Readback.PhysicsUnits = 'GeV';

AO.B1.Setpoint.MemberOf = {'MachineConfig';};
AO.B1.Setpoint.Mode = 'Simulator';
AO.B1.Setpoint.DataType = 'Scalar';
AO.B1.Setpoint.ChannelNames = sirius_si_getname(AO.B1.FamilyName, 'Setpoint', AO.B1.DeviceList);
AO.B1.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B1.Setpoint.Physics2HWFcn = @gev2bend;
AO.B1.Setpoint.Units        = 'Hardware';
AO.B1.Setpoint.HWUnits      = 'Ampere';
AO.B1.Setpoint.PhysicsUnits = 'GeV';
AO.B1.Setpoint.Range        = [0 300];
AO.B1.Setpoint.Tolerance    = .1;
AO.B1.Setpoint.DeltaRespMat = .01;


AO.B2.FamilyName  = 'B2';
AO.B2.MemberOf    = {'PlotFamily'; 'B2'; 'BEND'; 'Magnet';};
AO.B2.DeviceList  = getDeviceList(20,2);
AO.B2.ElementList = (1:size(AO.B2.DeviceList,1))';
AO.B2.Status      = ones(size(AO.B2.DeviceList,1),1);
AO.B2.Position    = [];
AO.B2.ExcitationCurves = sirius_getexcdata(repmat('si-dipole-b1b2-fam',size(AO.B2.DeviceList,1),1));

AO.B2.Monitor.MemberOf = {};
AO.B2.Monitor.Mode = 'Simulator';
AO.B2.Monitor.DataType = 'Scalar';
AO.B2.Monitor.ChannelNames = sirius_si_getname(AO.B2.FamilyName, 'Monitor', AO.B2.DeviceList);
AO.B2.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B2.Monitor.Physics2HWFcn = @gev2bend;
AO.B2.Monitor.Units        = 'Hardware';
AO.B2.Monitor.HWUnits      = 'Ampere';
AO.B2.Monitor.PhysicsUnits = 'GeV';

AO.B2.ReferenceMonitor.MemberOf = {};
AO.B2.ReferenceMonitor.Mode = 'Simulator';
AO.B2.ReferenceMonitor.DataType = 'Scalar';
AO.B2.ReferenceMonitor.ChannelNames = sirius_si_getname(AO.B2.FamilyName, 'ReferenceMonitor', AO.B2.DeviceList);
AO.B2.ReferenceMonitor.HW2PhysicsFcn = @bend2gev;
AO.B2.ReferenceMonitor.Physics2HWFcn = @gev2bend;
AO.B2.ReferenceMonitor.Units        = 'Hardware';
AO.B2.ReferenceMonitor.HWUnits      = 'Ampere';
AO.B2.ReferenceMonitor.PhysicsUnits = 'GeV';

AO.B2.Readback.MemberOf = {};
AO.B2.Readback.Mode = 'Simulator';
AO.B2.Readback.DataType = 'Scalar';
AO.B2.Readback.ChannelNames = sirius_si_getname(AO.B2.FamilyName, 'Readback', AO.B2.DeviceList);
AO.B2.Readback.HW2PhysicsFcn = @bend2gev;
AO.B2.Readback.Physics2HWFcn = @gev2bend;
AO.B2.Readback.Units        = 'Hardware';
AO.B2.Readback.HWUnits      = 'Ampere';
AO.B2.Readback.PhysicsUnits = 'GeV';

AO.B2.Setpoint.MemberOf = {'MachineConfig';};
AO.B2.Setpoint.Mode = 'Simulator';
AO.B2.Setpoint.DataType = 'Scalar';
AO.B2.Setpoint.ChannelNames = sirius_si_getname(AO.B2.FamilyName, 'Setpoint', AO.B2.DeviceList);
AO.B2.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B2.Setpoint.Physics2HWFcn = @gev2bend;
AO.B2.Setpoint.Units        = 'Hardware';
AO.B2.Setpoint.HWUnits      = 'Ampere';
AO.B2.Setpoint.PhysicsUnits = 'GeV';
AO.B2.Setpoint.Range        = [0 300];
AO.B2.Setpoint.Tolerance    = .1;
AO.B2.Setpoint.DeltaRespMat = .01;

AO.BC.FamilyName  = 'BC';
AO.BC.MemberOf    = {'SI-BC'; 'BC';};
AO.BC.DeviceList  = getDeviceList(20,1);
AO.BC.ElementList = (1:size(AO.BC.DeviceList,1))';
AO.BC.Status      = ones(size(AO.BC.DeviceList,1),1);
AO.BC.Position    = [];


%% quadrupoles
AO = get_AO_quads(AO,'QFA', 'q20-fam', 2, 1, 4);
AO = get_AO_quads(AO,'QDA', 'q14-fam', 2, 1, 4);
AO = get_AO_quads(AO,'QDB1','q14-fam', 2, 2, 2);
AO = get_AO_quads(AO,'QFB', 'q30-fam', 2, 2, 2);
AO = get_AO_quads(AO,'QDB2','q14-fam', 2, 2, 2);
AO = get_AO_quads(AO,'QDP1','q14-fam', 2, 3, 4);
AO = get_AO_quads(AO,'QFP', 'q30-fam', 2, 3, 4);
AO = get_AO_quads(AO,'QDP2','q14-fam', 2, 3, 4);
AO = get_AO_quads(AO,'Q1',  'q20-fam', 2, 1, 1);
AO = get_AO_quads(AO,'Q2',  'q20-fam', 2, 1, 1);
AO = get_AO_quads(AO,'Q3',  'q20-fam', 2, 1, 1);
AO = get_AO_quads(AO,'Q4',  'q20-fam', 2, 1, 1);


%% sextupoles

AO = get_AO_sexts(AO,'SDA0',2,1,4);
AO = get_AO_sexts(AO,'SDB0',2,2,2);
AO = get_AO_sexts(AO,'SDP0',2,3,4);
AO = get_AO_sexts(AO,'SDA1',1,[1,4],4);
AO = get_AO_sexts(AO,'SDB1',1,1,1);
AO = get_AO_sexts(AO,'SDP1',1,[2,3],4);
AO = get_AO_sexts(AO,'SDA2',1,[1,4],4);
AO = get_AO_sexts(AO,'SDB2',1,1,1);
AO = get_AO_sexts(AO,'SDP2',1,[2,3],4);
AO = get_AO_sexts(AO,'SDA3',1,[1,4],4);
AO = get_AO_sexts(AO,'SDB3',1,1,1);
AO = get_AO_sexts(AO,'SDP3',1,[2,3],4);
AO = get_AO_sexts(AO,'SFA0',2,1,4);
AO = get_AO_sexts(AO,'SFB0',2,2,2);
AO = get_AO_sexts(AO,'SFP0',2,3,4);
AO = get_AO_sexts(AO,'SFA1',1,[1,4],4);
AO = get_AO_sexts(AO,'SFB1',1,1,1);
AO = get_AO_sexts(AO,'SFP1',1,[2,3],4);
AO = get_AO_sexts(AO,'SFA2',1,[1,4],4);
AO = get_AO_sexts(AO,'SFB2',1,1,1);
AO = get_AO_sexts(AO,'SFP2',1,[2,3],4);


%% correctors

% CH
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'Magnet'; 'HCM'; 'hcm_slow';};
AO.CH.DeviceList  = getDeviceList(20, 6);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('si-sextupole-s15-ch',size(AO.CH.DeviceList,1),1));

AO.CH.Monitor.MemberOf      = {'Horizontal'; 'COR'; 'CH'; 'Magnet';};
AO.CH.Monitor.Mode          = 'Simulator';
AO.CH.Monitor.DataType      = 'Scalar';
AO.CH.Monitor.ChannelNames  = sirius_si_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList);
AO.CH.Monitor.Units         = 'Hardware';
AO.CH.Monitor.HWUnits       = 'Ampere';
AO.CH.Monitor.PhysicsUnits  = 'Radian';
AO.CH.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.CH.ReferenceMonitor.MemberOf      = {};
AO.CH.ReferenceMonitor.Mode          = 'Simulator';
AO.CH.ReferenceMonitor.DataType      = 'Scalar';
AO.CH.ReferenceMonitor.ChannelNames  = sirius_si_getname(AO.CH.FamilyName, 'ReferenceMonitor', AO.CH.DeviceList);
AO.CH.ReferenceMonitor.Units         = 'Hardware';
AO.CH.ReferenceMonitor.HWUnits       = 'Ampere';
AO.CH.ReferenceMonitor.PhysicsUnits  = 'Radian';
AO.CH.ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.CH.Readback.MemberOf      = {};
AO.CH.Readback.Mode          = 'Simulator';
AO.CH.Readback.DataType      = 'Scalar';
AO.CH.Readback.ChannelNames  = sirius_si_getname(AO.CH.FamilyName, 'Readback', AO.CH.DeviceList);
AO.CH.Readback.Units         = 'Hardware';
AO.CH.Readback.HWUnits       = 'Ampere';
AO.CH.Readback.PhysicsUnits  = 'Radian';
AO.CH.Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Readback.Physics2HWFcn = @sirius_ph2hw;

AO.CH.Setpoint.MemberOf      = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.CH.Setpoint.Mode          = 'Simulator';
AO.CH.Setpoint.DataType      = 'Scalar';
AO.CH.Setpoint.ChannelNames  = sirius_si_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.Units         = 'Hardware';
AO.CH.Setpoint.HWUnits       = 'Ampere';
AO.CH.Setpoint.PhysicsUnits  = 'Radian';
AO.CH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Setpoint.Range         = [-10 10];
AO.CH.Setpoint.Tolerance     = 0.00001;
AO.CH.Setpoint.DeltaRespMat  = 5e-4;


% CV
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'Magnet'; 'VCM'; 'vcm_slow';};
AO.CV.DeviceList  = getDeviceList(20, 8);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('si-sextupole-s15-cv',size(AO.CV.DeviceList,1),1));

AO.CV.Monitor.MemberOf      = {'Vertical'; 'COR'; 'CV'; 'Magnet';};
AO.CV.Monitor.Mode          = 'Simulator';
AO.CV.Monitor.DataType      = 'Scalar';
AO.CV.Monitor.ChannelNames  = sirius_si_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList);
AO.CV.Monitor.Units         = 'Hardware';
AO.CV.Monitor.HWUnits       = 'Ampere';
AO.CV.Monitor.PhysicsUnits  = 'Radian';
AO.CV.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.CV.ReferenceMonitor.MemberOf      = {};
AO.CV.ReferenceMonitor.Mode          = 'Simulator';
AO.CV.ReferenceMonitor.DataType      = 'Scalar';
AO.CV.ReferenceMonitor.ChannelNames  = sirius_si_getname(AO.CV.FamilyName, 'ReferenceMonitor', AO.CV.DeviceList);
AO.CV.ReferenceMonitor.Units         = 'Hardware';
AO.CV.ReferenceMonitor.HWUnits       = 'Ampere';
AO.CV.ReferenceMonitor.PhysicsUnits  = 'Radian';
AO.CV.ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.CV.Readback.MemberOf      = {};
AO.CV.Readback.Mode          = 'Simulator';
AO.CV.Readback.DataType      = 'Scalar';
AO.CV.Readback.ChannelNames  = sirius_si_getname(AO.CV.FamilyName, 'Readback', AO.CV.DeviceList);
AO.CV.Readback.Units         = 'Hardware';
AO.CV.Readback.HWUnits       = 'Ampere';
AO.CV.Readback.PhysicsUnits  = 'Radian';
AO.CV.Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Readback.Physics2HWFcn = @sirius_ph2hw;

AO.CV.Setpoint.MemberOf      = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.CV.Setpoint.Mode          = 'Simulator';
AO.CV.Setpoint.DataType      = 'Scalar';
AO.CV.Setpoint.ChannelNames  = sirius_si_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.Units         = 'Hardware';
AO.CV.Setpoint.HWUnits       = 'Ampere';
AO.CV.Setpoint.PhysicsUnits  = 'Radian';
AO.CV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Setpoint.Range         = [-10 10];
AO.CV.Setpoint.Tolerance     = 0.00001;
AO.CV.Setpoint.DeltaRespMat  = 5e-4;


% FCH
AO.FCH.FamilyName  = 'FCH';
AO.FCH.MemberOf    = {'PlotFamily'; 'COR'; 'FCH'; 'Magnet'; 'HCM'; 'hcm_fast';};
AO.FCH.DeviceList  = getDeviceList(20, 4);
% AO.FCH.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.FCH.ElementList = (1:size(AO.FCH.DeviceList,1))';
AO.FCH.Status      = ones(size(AO.FCH.DeviceList,1),1);
AO.FCH.Position    = [];
AO.FCH.ExcitationCurves = sirius_getexcdata(repmat('si-corrector-fch',size(AO.FCH.DeviceList,1),1));

AO.FCH.Monitor.MemberOf      = {'Horizontal'; 'COR'; 'FCH'; 'Magnet';};
AO.FCH.Monitor.Mode          = 'Simulator';
AO.FCH.Monitor.DataType      = 'Scalar';
AO.FCH.Monitor.ChannelNames  = sirius_si_getname(AO.FCH.FamilyName, 'Monitor', AO.FCH.DeviceList);
AO.FCH.Monitor.Units         = 'Hardware';
AO.FCH.Monitor.HWUnits       = 'Ampere';
AO.FCH.Monitor.PhysicsUnits  = 'Radian';
AO.FCH.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCH.Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.FCH.ReferenceMonitor.MemberOf      = {};
AO.FCH.ReferenceMonitor.Mode          = 'Simulator';
AO.FCH.ReferenceMonitor.DataType      = 'Scalar';
AO.FCH.ReferenceMonitor.ChannelNames  = sirius_si_getname(AO.FCH.FamilyName, 'ReferenceMonitor', AO.FCH.DeviceList);
AO.FCH.ReferenceMonitor.Units         = 'Hardware';
AO.FCH.ReferenceMonitor.HWUnits       = 'Ampere';
AO.FCH.ReferenceMonitor.PhysicsUnits  = 'Radian';
AO.FCH.ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCH.ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.FCH.Readback.MemberOf      = {};
AO.FCH.Readback.Mode          = 'Simulator';
AO.FCH.Readback.DataType      = 'Scalar';
AO.FCH.Readback.ChannelNames  = sirius_si_getname(AO.FCH.FamilyName, 'Readback', AO.FCH.DeviceList);
AO.FCH.Readback.Units         = 'Hardware';
AO.FCH.Readback.HWUnits       = 'Ampere';
AO.FCH.Readback.PhysicsUnits  = 'Radian';
AO.FCH.Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCH.Readback.Physics2HWFcn = @sirius_ph2hw;

AO.FCH.Setpoint.MemberOf      = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.FCH.Setpoint.Mode          = 'Simulator';
AO.FCH.Setpoint.DataType      = 'Scalar';
AO.FCH.Setpoint.ChannelNames  = sirius_si_getname(AO.FCH.FamilyName, 'Setpoint', AO.FCH.DeviceList);
AO.FCH.Setpoint.Units         = 'Hardware';
AO.FCH.Setpoint.HWUnits       = 'Ampere';
AO.FCH.Setpoint.PhysicsUnits  = 'Radian';
AO.FCH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.FCH.Setpoint.Range         = [-10 10];
AO.FCH.Setpoint.Tolerance     = 0.00001;
AO.FCH.Setpoint.DeltaRespMat  = 5e-4;


% FCV
AO.FCV.FamilyName  = 'FCV';
AO.FCV.MemberOf    = {'PlotFamily'; 'COR'; 'FCV'; 'Magnet';'VCM';'vcm_fast';};
AO.FCV.DeviceList  = getDeviceList(20, 4);
% AO.FCV.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.FCV.ElementList = (1:size(AO.FCV.DeviceList,1))';
AO.FCV.Status      = ones(size(AO.FCV.DeviceList,1),1);
AO.FCV.Position    = [];
AO.FCV.ExcitationCurves = sirius_getexcdata(repmat('si-corrector-fcv',size(AO.FCV.DeviceList,1),1));

AO.FCV.Monitor.MemberOf      = {'Vertical'; 'COR'; 'FCV'; 'Magnet';};
AO.FCV.Monitor.Mode          = 'Simulator';
AO.FCV.Monitor.DataType      = 'Scalar';
AO.FCV.Monitor.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'Monitor', AO.FCV.DeviceList);
AO.FCV.Monitor.Units         = 'Hardware';
AO.FCV.Monitor.HWUnits       = 'Ampere';
AO.FCV.Monitor.PhysicsUnits  = 'Radian';
AO.FCV.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCV.Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.FCV.ReferenceMonitor.MemberOf      = {};
AO.FCV.ReferenceMonitor.Mode          = 'Simulator';
AO.FCV.ReferenceMonitor.DataType      = 'Scalar';
AO.FCV.ReferenceMonitor.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'ReferenceMonitor', AO.FCV.DeviceList);
AO.FCV.ReferenceMonitor.Units         = 'Hardware';
AO.FCV.ReferenceMonitor.HWUnits       = 'Ampere';
AO.FCV.ReferenceMonitor.PhysicsUnits  = 'Radian';
AO.FCV.ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCV.ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.FCV.Readback.MemberOf      = {};
AO.FCV.Readback.Mode          = 'Simulator';
AO.FCV.Readback.DataType      = 'Scalar';
AO.FCV.Readback.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'Readback', AO.FCV.DeviceList);
AO.FCV.Readback.Units         = 'Hardware';
AO.FCV.Readback.HWUnits       = 'Ampere';
AO.FCV.Readback.PhysicsUnits  = 'Radian';
AO.FCV.Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCV.Readback.Physics2HWFcn = @sirius_ph2hw;

AO.FCV.Setpoint.MemberOf      = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.FCV.Setpoint.Mode          = 'Simulator';
AO.FCV.Setpoint.DataType      = 'Scalar';
AO.FCV.Setpoint.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'Setpoint', AO.FCV.DeviceList);
AO.FCV.Setpoint.Units         = 'Hardware';
AO.FCV.Setpoint.HWUnits       = 'Ampere';
AO.FCV.Setpoint.PhysicsUnits  = 'Radian';
AO.FCV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.FCV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.FCV.Setpoint.Range         = [-10 10];
AO.FCV.Setpoint.Tolerance     = 0.00001;
AO.FCV.Setpoint.DeltaRespMat  = 5e-4;


% QS
AO.QS.FamilyName  = 'QS';
AO.QS.MemberOf    = {'PlotFamily'; 'COR'; 'QS'; 'Magnet'; 'SKEWQUAD'};
AO.QS.DeviceList  = getDeviceList(20, 5);
AO.QS.ElementList = (1:size(AO.QS.DeviceList,1))';
AO.QS.Status      = ones(size(AO.QS.DeviceList,1),1);
AO.QS.Position    = [];
AO.QS.ExcitationCurves = sirius_getexcdata(repmat('si-quadrupole-qs',size(AO.QS.DeviceList,1),1));

AO.QS.Monitor.MemberOf      = {'Horizontal'; 'COR'; 'QS'; 'Magnet';};
AO.QS.Monitor.ChannelNames  = sirius_si_getname(AO.QS.FamilyName, 'Monitor', AO.QS.DeviceList);
AO.QS.Monitor.Mode          = 'Simulator';
AO.QS.Monitor.DataType      = 'Scalar';
AO.QS.Monitor.Units         = 'Hardware';
AO.QS.Monitor.HWUnits       = 'Ampere';
AO.QS.Monitor.PhysicsUnits  = 'Radian';
AO.QS.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.QS.ReferenceMonitor.MemberOf      = {};
AO.QS.ReferenceMonitor.ChannelNames  = sirius_si_getname(AO.QS.FamilyName, 'ReferenceMonitor', AO.QS.DeviceList);
AO.QS.ReferenceMonitor.Mode          = 'Simulator';
AO.QS.ReferenceMonitor.DataType      = 'Scalar';
AO.QS.ReferenceMonitor.Units         = 'Hardware';
AO.QS.ReferenceMonitor.HWUnits       = 'Ampere';
AO.QS.ReferenceMonitor.PhysicsUnits  = 'Radian';
AO.QS.ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.QS.Readback.MemberOf      = {};
AO.QS.Readback.ChannelNames  = sirius_si_getname(AO.QS.FamilyName, 'Readback', AO.QS.DeviceList);
AO.QS.Readback.Mode          = 'Simulator';
AO.QS.Readback.DataType      = 'Scalar';
AO.QS.Readback.Units         = 'Hardware';
AO.QS.Readback.HWUnits       = 'Ampere';
AO.QS.Readback.PhysicsUnits  = 'Radian';
AO.QS.Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.Readback.Physics2HWFcn = @sirius_ph2hw;

AO.QS.Setpoint.MemberOf      = {'MachineConfig'; 'Horizontal'; 'COR'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.QS.Setpoint.Mode          = 'Simulator';
AO.QS.Setpoint.DataType      = 'Scalar';
AO.QS.Setpoint.ChannelNames  = sirius_si_getname(AO.QS.FamilyName, 'Setpoint', AO.QS.DeviceList);
AO.QS.Setpoint.Units         = 'Hardware';
AO.QS.Setpoint.HWUnits       = 'Ampere';
AO.QS.Setpoint.PhysicsUnits  = 'Radian';
AO.QS.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QS.Setpoint.Range         = [-10 10];
AO.QS.Setpoint.Tolerance     = 0.00001;
AO.QS.Setpoint.DeltaRespMat  = 5e-4;

%% monitors

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = getDeviceList(20, 8);
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.Golden      = zeros(length(AO.BPMx.ElementList),1);
AO.BPMx.Offset      = zeros(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.ChannelNames = sirius_si_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-9;  % HW [nm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1e9;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'nm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = getDeviceList(20, 8);
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.Golden      = zeros(length(AO.BPMy.ElementList),1);
AO.BPMy.Offset      = zeros(length(AO.BPMy.ElementList),1);

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.ChannelNames = sirius_si_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-9;  % HW [nm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1e9;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'nm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';

%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE'};
AO.TUNE.DeviceList = [17 1;18 1];
AO.TUNE.ElementList = [1;2];
AO.TUNE.Status = [1; 1];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'];

AO.TUNE.Monitor.MemberOf   = {'TUNE'};
AO.TUNE.Monitor.ChannelNames = sirius_si_getname(AO.TUNE.FamilyName, 'Monitor');
AO.TUNE.Monitor.Mode = 'Simulator';
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


%%%%%%
% RF %
%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
% AO.RF.DeviceList                = [ 3 1 ]; % if operating with SRFCav
AO.RF.DeviceList                = [ 2 1 ]; % if operating with P7Cav
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = [];

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.ChannelNames      = sirius_si_getname(AO.RF.FamilyName, 'Monitor');
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.ChannelNames     = sirius_si_getname(AO.RF.FamilyName, 'Setpoint');
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [0 inf];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageMonitor.MemberOf         = {};
AO.RF.VoltageMonitor.Mode             = 'Simulator';
AO.RF.VoltageMonitor.DataType         = 'Scalar';
AO.RF.VoltageMonitor.ChannelNames     = sirius_si_getname(AO.RF.FamilyName, 'VoltageMonitor');
AO.RF.VoltageMonitor.HW2PhysicsParams = 1e+6;
AO.RF.VoltageMonitor.Physics2HWParams = 1e-6;
AO.RF.VoltageMonitor.Units            = 'Hardware';
AO.RF.VoltageMonitor.HWUnits          = 'MV';
AO.RF.VoltageMonitor.PhysicsUnits     = 'Volts';

AO.RF.VoltageSetpoint.MemberOf         = {};
AO.RF.VoltageSetpoint.Mode             = 'Simulator';
AO.RF.VoltageSetpoint.DataType         = 'Scalar';
AO.RF.VoltageSetpoint.ChannelNames     = sirius_si_getname(AO.RF.FamilyName, 'VoltageSetpoint');
AO.RF.VoltageSetpoint.HW2PhysicsParams = 1e+6;
AO.RF.VoltageSetpoint.Physics2HWParams = 1e-6;
AO.RF.VoltageSetpoint.Units            = 'Hardware';
AO.RF.VoltageSetpoint.HWUnits          = 'MV';
AO.RF.VoltageSetpoint.PhysicsUnits     = 'Volts';

% AO.RF.Power.MemberOf          = {};
% AO.RF.Power.Mode              = 'Simulator';
% AO.RF.Power.DataType          = 'Scalar';
% AO.RF.Power.ChannelNames      = '';          % ???
% AO.RF.Power.HW2PhysicsParams  = 1;
% AO.RF.Power.Physics2HWParams  = 1;
% AO.RF.Power.Units             = 'Hardware';
% AO.RF.Power.HWUnits           = 'MWatts';
% AO.RF.Power.PhysicsUnits      = 'MWatts';
% AO.RF.Power.Range             = [-inf inf];  % ???
% AO.RF.Power.Tolerance         = inf;  % ???
%
% AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
% AO.RF.Phase.Mode              = 'Simulator';
% AO.RF.Phase.DataType          = 'Scalar';
% AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???
% AO.RF.Phase.Units             = 'Hardware';
% AO.RF.Phase.HW2PhysicsParams  = 1;
% AO.RF.Phase.Physics2HWParams  = 1;
% AO.RF.Phase.HWUnits           = 'Degrees';
% AO.RF.Phase.PhysicsUnits      = 'Degrees';
%
% AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
% AO.RF.PhaseCtrl.Mode              = 'Simulator';
% AO.RF.PhaseCtrl.DataType          = 'Scalar';
% AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???
% AO.RF.PhaseCtrl.Units             = 'Hardware';
% AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;
% AO.RF.PhaseCtrl.Physics2HWParams  = 1;
% AO.RF.PhaseCtrl.HWUnits           = 'Degrees';
% AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees';
% AO.RF.PhaseCtrl.Range             = [-200 200];    % ???
% AO.RF.PhaseCtrl.Tolerance         = 10;    % ???



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [13, 1; 14, 1];
AO.DCCT.ElementList              = [1; 2];
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = [];

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = sirius_si_getname(AO.DCCT.FamilyName, 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1e-3;   % HW [mA], Simulator [Ampere]
AO.DCCT.Monitor.Physics2HWParams = 1e3;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'mA';
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);

%sirius_comm_connect_inputdlg;


function AO = get_AO_quads(AO,fam,type,num_el_arc,init_sector,periodicity)

famTrim = [fam,'Trim'];
famFam = [fam,'Fam'];

AO.(fam).FamilyName = fam;
AO.(fam).MemberOf    = {'PlotFamily'; fam; 'QUAD'; 'Magnet';type;'Tune Corrector'};
AO.(fam).DeviceList  = getDeviceList(20, num_el_arc, init_sector, 1, periodicity);
AO.(fam).ElementList = (1:size(AO.(fam).DeviceList,1))';
AO.(fam).Status      = ones(size(AO.(fam).DeviceList,1),1);
AO.(fam).Position    = [];
AO.(fam).FamilyPS    = famFam;
AO.(fam).ShuntPS     = famTrim;
AO.(fam).ExcitationCurves = sirius_getexcdata(repmat(['si-quadrupole-',type],size(AO.(fam).DeviceList,1),1));

AO.(fam).Monitor.MemberOf           = {};
AO.(fam).Monitor.Mode               = 'Simulator';
AO.(fam).Monitor.DataType           = 'Scalar';
AO.(fam).Monitor.Units              = 'Hardware';
AO.(fam).Monitor.HWUnits            = 'Ampere';
AO.(fam).Monitor.PhysicsUnits       = 'meter^-2';
AO.(fam).Monitor.SpecialFunctionGet = @sirius_si_quadget;
AO.(fam).Monitor.SpecialFunctionSet = @sirius_si_quadset;
AO.(fam).Monitor.HW2PhysicsFcn      = @sirius_hw2ph;
AO.(fam).Monitor.Physics2HWFcn      = @sirius_ph2hw;

AO.(fam).ReferenceMonitor.MemberOf           = {};
AO.(fam).ReferenceMonitor.Mode               = 'Simulator';
AO.(fam).ReferenceMonitor.DataType           = 'Scalar';
AO.(fam).ReferenceMonitor.Units              = 'Hardware';
AO.(fam).ReferenceMonitor.HWUnits            = 'Ampere';
AO.(fam).ReferenceMonitor.PhysicsUnits       = 'meter^-2';
AO.(fam).ReferenceMonitor.SpecialFunctionGet = @sirius_si_quadget;
AO.(fam).ReferenceMonitor.SpecialFunctionSet = @sirius_si_quadset;
AO.(fam).ReferenceMonitor.HW2PhysicsFcn      = @sirius_hw2ph;
AO.(fam).ReferenceMonitor.Physics2HWFcn      = @sirius_ph2hw;

AO.(fam).Readback.MemberOf           = {};
AO.(fam).Readback.Mode               = 'Simulator';
AO.(fam).Readback.DataType           = 'Scalar';
AO.(fam).Readback.Units              = 'Hardware';
AO.(fam).Readback.HWUnits            = 'Ampere';
AO.(fam).Readback.PhysicsUnits       = 'meter^-2';
AO.(fam).Readback.SpecialFunctionGet = @sirius_si_quadget;
AO.(fam).Readback.SpecialFunctionSet = @sirius_si_quadset;
AO.(fam).Readback.HW2PhysicsFcn      = @sirius_hw2ph;
AO.(fam).Readback.Physics2HWFcn      = @sirius_ph2hw;

AO.(fam).Setpoint.MemberOf           = {'MachineConfig'};
AO.(fam).Setpoint.Mode               = 'Simulator';
AO.(fam).Setpoint.DataType           = 'Scalar';
AO.(fam).Setpoint.Units              = 'Hardware';
AO.(fam).Setpoint.HWUnits            = 'Ampere';
AO.(fam).Setpoint.PhysicsUnits       = 'meter^-2';
AO.(fam).Setpoint.SpecialFunctionGet = @sirius_si_quadget;
AO.(fam).Setpoint.SpecialFunctionSet = @sirius_si_quadset;
AO.(fam).Setpoint.HW2PhysicsFcn      = @sirius_hw2ph;
AO.(fam).Setpoint.Physics2HWFcn      = @sirius_ph2hw;
AO.(fam).Setpoint.Range              = [0 225];
AO.(fam).Setpoint.Tolerance          = 0.2;
AO.(fam).Setpoint.DeltaRespMat       = 0.5;


AO.(famTrim).FamilyName = famTrim;
AO.(famTrim).MemberOf    = {'PlotFamily'; famTrim};
AO.(famTrim).DeviceList  = getDeviceList(20, num_el_arc, init_sector, 1, periodicity);
AO.(famTrim).ElementList = (1:size(AO.(famTrim).DeviceList,1))';
AO.(famTrim).Status      = ones(size(AO.(famTrim).DeviceList,1),1);
AO.(famTrim).Position    = [];

AO.(famTrim).Monitor.MemberOf     = {};
AO.(famTrim).Monitor.Mode         = 'Simulator';
AO.(famTrim).Monitor.DataType     = 'Scalar';
AO.(famTrim).Monitor.ChannelNames = sirius_si_getname(famTrim, 'Monitor', AO.(famTrim).DeviceList);
AO.(famTrim).Monitor.Units        = 'Hardware';
AO.(famTrim).Monitor.HWUnits      = 'Ampere';

AO.(famTrim).ReferenceMonitor.MemberOf     = {};
AO.(famTrim).ReferenceMonitor.Mode         = 'Simulator';
AO.(famTrim).ReferenceMonitor.DataType     = 'Scalar';
AO.(famTrim).ReferenceMonitor.ChannelNames = sirius_si_getname(famTrim, 'ReferenceMonitor', AO.(famTrim).DeviceList);
AO.(famTrim).ReferenceMonitor.Units        = 'Hardware';
AO.(famTrim).ReferenceMonitor.HWUnits      = 'Ampere';

AO.(famTrim).Readback.MemberOf     = {};
AO.(famTrim).Readback.Mode         = 'Simulator';
AO.(famTrim).Readback.DataType     = 'Scalar';
AO.(famTrim).Readback.ChannelNames = sirius_si_getname(famTrim, 'Readback', AO.(famTrim).DeviceList);
AO.(famTrim).Readback.Units        = 'Hardware';
AO.(famTrim).Readback.HWUnits      = 'Ampere';

AO.(famTrim).Setpoint.MemberOf     = {'MachineConfig'};
AO.(famTrim).Setpoint.Mode         = 'Simulator';
AO.(famTrim).Setpoint.DataType     = 'Scalar';
AO.(famTrim).Setpoint.ChannelNames = sirius_si_getname(famTrim, 'Setpoint', AO.(famTrim).DeviceList);
AO.(famTrim).Setpoint.Units        = 'Hardware';
AO.(famTrim).Setpoint.HWUnits      = 'Ampere';
AO.(famTrim).Setpoint.Range        = [0 225];
AO.(famTrim).Setpoint.Tolerance    = 0.2;
AO.(famTrim).Setpoint.DeltaRespMat = 0.5;


AO.(famFam).FamilyName = famFam;
AO.(famFam).MemberOf    = {'PlotFamily'; famFam};
AO.(famFam).DeviceList  = getDeviceList(20, num_el_arc, init_sector, 1, periodicity);
AO.(famFam).ElementList = (1:size(AO.(famFam).DeviceList,1))';
AO.(famFam).Status      = ones(size(AO.(famFam).DeviceList,1),1);
AO.(famFam).Position    = [];

AO.(famFam).Monitor.MemberOf     = {};
AO.(famFam).Monitor.Mode         = 'Simulator';
AO.(famFam).Monitor.DataType     = 'Scalar';
AO.(famFam).Monitor.ChannelNames = sirius_si_getname(famFam, 'Monitor', AO.(famFam).DeviceList);
AO.(famFam).Monitor.Units        = 'Hardware';
AO.(famFam).Monitor.HWUnits      = 'Ampere';

AO.(famFam).ReferenceMonitor.MemberOf     = {};
AO.(famFam).ReferenceMonitor.Mode         = 'Simulator';
AO.(famFam).ReferenceMonitor.DataType     = 'Scalar';
AO.(famFam).ReferenceMonitor.ChannelNames = sirius_si_getname(famFam, 'ReferenceMonitor', AO.(famFam).DeviceList);
AO.(famFam).ReferenceMonitor.Units        = 'Hardware';
AO.(famFam).ReferenceMonitor.HWUnits      = 'Ampere';

AO.(famFam).Readback.MemberOf     = {};
AO.(famFam).Readback.Mode         = 'Simulator';
AO.(famFam).Readback.DataType     = 'Scalar';
AO.(famFam).Readback.ChannelNames = sirius_si_getname(famFam, 'Readback', AO.(famFam).DeviceList);
AO.(famFam).Readback.Units        = 'Hardware';
AO.(famFam).Readback.HWUnits      = 'Ampere';

AO.(famFam).Setpoint.MemberOf     = {'MachineConfig'};
AO.(famFam).Setpoint.Mode         = 'Simulator';
AO.(famFam).Setpoint.DataType     = 'Scalar';
AO.(famFam).Setpoint.ChannelNames = sirius_si_getname(famFam, 'Setpoint', AO.(famFam).DeviceList);
AO.(famFam).Setpoint.Units        = 'Hardware';
AO.(famFam).Setpoint.HWUnits      = 'Ampere';
AO.(famFam).Setpoint.Range        = [0 225];
AO.(famFam).Setpoint.Tolerance    = 0.2;
AO.(famFam).Setpoint.DeltaRespMat = 0.5;


function AO = get_AO_sexts(AO,fam,num_el_arc, init_sector, periodicity)

if strfind(fam, 'SD')
    fname = 'si-sextupole-s15-sd-fam';
else
    fname = 'si-sextupole-s15-sf-fam';
end

AO.(fam).FamilyName = fam;
AO.(fam).MemberOf    = {'PlotFamily'; fam; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.(fam).DeviceList  = getDeviceList(20, num_el_arc, init_sector, 1, periodicity);
AO.(fam).ElementList = (1:size(AO.(fam).DeviceList,1))';
AO.(fam).Status      = ones(size(AO.(fam).DeviceList,1),1);
AO.(fam).Position    = [];
AO.(fam).ExcitationCurves = sirius_getexcdata(repmat(fname,size(AO.(fam).DeviceList,1),1));

AO.(fam).Monitor.MemberOf      = {};
AO.(fam).Monitor.Mode          = 'Simulator';
AO.(fam).Monitor.DataType      = 'Scalar';
AO.(fam).Monitor.ChannelNames  = sirius_si_getname(fam, 'Monitor', AO.(fam).DeviceList);
AO.(fam).Monitor.Units         = 'Hardware';
AO.(fam).Monitor.HWUnits       = 'Ampere';
AO.(fam).Monitor.PhysicsUnits  = 'meter^-3';
AO.(fam).Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.(fam).Monitor.Physics2HWFcn = @sirius_ph2hw;

AO.(fam).ReferenceMonitor.MemberOf      = {};
AO.(fam).ReferenceMonitor.Mode          = 'Simulator';
AO.(fam).ReferenceMonitor.DataType      = 'Scalar';
AO.(fam).ReferenceMonitor.ChannelNames  = sirius_si_getname(fam, 'ReferenceMonitor', AO.(fam).DeviceList);
AO.(fam).ReferenceMonitor.Units         = 'Hardware';
AO.(fam).ReferenceMonitor.HWUnits       = 'Ampere';
AO.(fam).ReferenceMonitor.PhysicsUnits  = 'meter^-3';
AO.(fam).ReferenceMonitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.(fam).ReferenceMonitor.Physics2HWFcn = @sirius_ph2hw;

AO.(fam).Readback.MemberOf      = {};
AO.(fam).Readback.Mode          = 'Simulator';
AO.(fam).Readback.DataType      = 'Scalar';
AO.(fam).Readback.ChannelNames  = sirius_si_getname(fam, 'Readback', AO.(fam).DeviceList);
AO.(fam).Readback.Units         = 'Hardware';
AO.(fam).Readback.HWUnits       = 'Ampere';
AO.(fam).Readback.PhysicsUnits  = 'meter^-3';
AO.(fam).Readback.HW2PhysicsFcn = @sirius_hw2ph;
AO.(fam).Readback.Physics2HWFcn = @sirius_ph2hw;

AO.(fam).Setpoint.MemberOf      = {'MachineConfig'};
AO.(fam).Setpoint.Mode          = 'Simulator';
AO.(fam).Setpoint.DataType      = 'Scalar';
AO.(fam).Setpoint.ChannelNames  = sirius_si_getname(fam, 'Setpoint', AO.(fam).DeviceList);
AO.(fam).Setpoint.Units         = 'Hardware';
AO.(fam).Setpoint.HWUnits       = 'Ampere';
AO.(fam).Setpoint.PhysicsUnits  = 'meter^-3';
AO.(fam).Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.(fam).Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.(fam).Setpoint.Range         = [0 225];
AO.(fam).Setpoint.Tolerance     = 0.2;
AO.(fam).Setpoint.DeltaRespMat  = 0.5;


function DList = getDeviceList(NSectorsTotal, NDevicesPerSector, varargin)

if isempty(varargin)
    InitialSector = 1;
    InitialDevice = 1;
    Periodicity = 1;
else
    InitialSector = varargin{1};
    InitialDevice = varargin{2};
    Periodicity = varargin{3};
end

DList = [];
DL = ones(NDevicesPerSector,2);
DL(:,2) = (1:NDevicesPerSector)';
for j=1:length(InitialSector)
    for i=InitialSector(j):Periodicity:NSectorsTotal
        DL(:,1) = i;
        DList = [DList; DL];
    end
end
DList = sortrows(DList,1);

idx=1;
for i=1:size(DList,1)
    if DList(i,:) == [InitialSector(i), InitialDevice]
        break
    end
    idx=idx+1;
end

DList = [DList(idx:size(DList,1), :) ; DList(1:idx-1, :)];
