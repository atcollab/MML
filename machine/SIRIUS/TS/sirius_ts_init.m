function sirius_ts_init(OperationalMode)
%SIRIUS_TS_INIT - MML initialization file for the TS at sirius
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);



AD.Directory.ExcDataDir = '/home/fac_files/lnls-sirius/control-system-constants/magnet/excitation-data';
setad(AD);


% BENDS

AO.B.FamilyName  = 'B';
AO.B.MemberOf    = {'PlotFamily'; 'B'; 'BEND'; 'Magnet';};
AO.B.DeviceList  = getDeviceList(1,3);
AO.B.ElementList = (1:size(AO.B.DeviceList,1))';
AO.B.Status      = ones(size(AO.B.DeviceList,1),1);
AO.B.Position    = [];
AO.B.ExcitationCurves = sirius_getexcdata(repmat('ts-dipole-b-fam', size(AO.B.DeviceList,1), 1)); 
AO.B.Monitor.MemberOf = {};
AO.B.Monitor.Mode = 'Simulator';
AO.B.Monitor.DataType = 'Scalar';
AO.B.Monitor.ChannelNames = sirius_ts_getname(AO.B.FamilyName, 'Monitor', AO.B.DeviceList);
AO.B.Monitor.HW2PhysicsFcn = @B2gev;
AO.B.Monitor.Physics2HWFcn = @gev2B;
AO.B.Monitor.Units        = 'Hardware';
AO.B.Monitor.HWUnits      = 'Ampere';
AO.B.Monitor.PhysicsUnits = 'GeV';
AO.B.Setpoint.MemberOf = {'MachineConfig';};
AO.B.Setpoint.Mode = 'Simulator';
AO.B.Setpoint.DataType = 'Scalar';
AO.B.Setpoint.ChannelNames = sirius_ts_getname(AO.B.FamilyName, 'Setpoint', AO.B.DeviceList);
AO.B.Setpoint.HW2PhysicsFcn = @B2gev;
AO.B.Setpoint.Physics2HWFcn = @gev2B;
AO.B.Setpoint.Units        = 'Hardware';
AO.B.Setpoint.HWUnits      = 'Ampere';
AO.B.Setpoint.PhysicsUnits = 'GeV';
AO.B.Setpoint.Range        = [0 300];
AO.B.Setpoint.Tolerance    = .1;
AO.B.Setpoint.DeltaRespMat = .01;

% Septa

AO.EjeSF.FamilyName  = 'EjeSF';
AO.EjeSF.MemberOf    = {'PlotFamily'; 'EjeSF'; 'SEPTUM'; 'Magnet';};
AO.EjeSF.DeviceList  = getDeviceList(1,1);
AO.EjeSF.ElementList = (1:size(AO.EjeSF.DeviceList,1))';
AO.EjeSF.Status      = ones(size(AO.EjeSF.DeviceList,1),1);
AO.EjeSF.Position    = [];
AO.EjeSF.ExcitationCurves = sirius_getexcdata(repmat('ts-ejeseptum-thin', size(AO.EjeSF.DeviceList,1), 1)); 
AO.EjeSF.Monitor.MemberOf = {};
AO.EjeSF.Monitor.Mode = 'Simulator';
AO.EjeSF.Monitor.DataType = 'Scalar';
AO.EjeSF.Monitor.ChannelNames  = sirius_ts_getname(AO.EjeSF.FamilyName, 'Monitor', AO.EjeSF.DeviceList);
AO.EjeSF.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.EjeSF.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.EjeSF.Monitor.Units         = 'Hardware';
AO.EjeSF.Monitor.HWUnits       = 'Ampere';
AO.EjeSF.Monitor.PhysicsUnits  = 'Radian';
AO.EjeSF.Setpoint.MemberOf = {'MachineConfig';};
AO.EjeSF.Setpoint.Mode = 'Simulator';
AO.EjeSF.Setpoint.DataType = 'Scalar';
AO.EjeSF.Setpoint.ChannelNames  = sirius_ts_getname(AO.EjeSF.FamilyName, 'Setpoint', AO.EjeSF.DeviceList);
AO.EjeSF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.EjeSF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.EjeSF.Setpoint.Units         = 'Hardware';
AO.EjeSF.Setpoint.HWUnits       = 'Ampere';
AO.EjeSF.Setpoint.PhysicsUnits  = 'Radian';
AO.EjeSF.Setpoint.Range         = [0 300];
AO.EjeSF.Setpoint.Tolerance     = .1;
AO.EjeSF.Setpoint.DeltaRespMat  = .01;

AO.EjeSG.FamilyName  = 'EjeSG';
AO.EjeSG.MemberOf    = {'PlotFamily'; 'EjeSG'; 'SEPTUM'; 'Magnet';};
AO.EjeSG.DeviceList  = getDeviceList(1,1);
AO.EjeSG.ElementList = (1:size(AO.EjeSG.DeviceList,1))';
AO.EjeSG.Status      = ones(size(AO.EjeSG.DeviceList,1),1);
AO.EjeSG.Position    = [];
AO.EjeSG.ExcitationCurves = sirius_getexcdata(repmat('ts-ejeseptum-thick', size(AO.EjeSG.DeviceList,1), 1)); 
AO.EjeSG.Monitor.MemberOf = {};
AO.EjeSG.Monitor.Mode = 'Simulator';
AO.EjeSG.Monitor.DataType = 'Scalar';
AO.EjeSG.Monitor.ChannelNames  = sirius_ts_getname(AO.EjeSG.FamilyName, 'Monitor', AO.EjeSG.DeviceList);
AO.EjeSG.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.EjeSG.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.EjeSG.Monitor.Units         = 'Hardware';
AO.EjeSG.Monitor.HWUnits       = 'Ampere';
AO.EjeSG.Monitor.PhysicsUnits  = 'Radian';
AO.EjeSG.Setpoint.MemberOf = {'MachineConfig';};
AO.EjeSG.Setpoint.Mode = 'Simulator';
AO.EjeSG.Setpoint.DataType = 'Scalar';
AO.EjeSG.Setpoint.ChannelNames  = sirius_ts_getname(AO.EjeSG.FamilyName, 'Setpoint', AO.EjeSG.DeviceList);
AO.EjeSG.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.EjeSG.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.EjeSG.Setpoint.Units         = 'Hardware';
AO.EjeSG.Setpoint.HWUnits       = 'Ampere';
AO.EjeSG.Setpoint.PhysicsUnits  = 'Radian';
AO.EjeSG.Setpoint.Range         = [0 300];
AO.EjeSG.Setpoint.Tolerance     = .1;
AO.EjeSG.Setpoint.DeltaRespMat  = .01;

AO.InjSG.FamilyName  = 'InjSG';
AO.InjSG.MemberOf    = {'PlotFamily'; 'InjSG'; 'SEPTUM'; 'Magnet';};
AO.InjSG.DeviceList  = getDeviceList(1,2);
AO.InjSG.ElementList = (1:size(AO.InjSG.DeviceList,1))';
AO.InjSG.Status      = ones(size(AO.InjSG.DeviceList,1),1);
AO.InjSG.Position    = [];
AO.InjSG.ExcitationCurves = sirius_getexcdata(repmat('ts-injseptum-thick', size(AO.InjSG.DeviceList,1), 1)); 
AO.InjSG.Monitor.MemberOf = {};
AO.InjSG.Monitor.Mode = 'Simulator';
AO.InjSG.Monitor.DataType = 'Scalar';
AO.InjSG.Monitor.ChannelNames  = sirius_ts_getname(AO.InjSG.FamilyName, 'Monitor', AO.InjSG.DeviceList);
AO.InjSG.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.InjSG.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.InjSG.Monitor.Units         = 'Hardware';
AO.InjSG.Monitor.HWUnits       = 'Ampere';
AO.InjSG.Monitor.PhysicsUnits  = 'Radian';
AO.InjSG.Setpoint.MemberOf = {'MachineConfig';};
AO.InjSG.Setpoint.Mode = 'Simulator';
AO.InjSG.Setpoint.DataType = 'Scalar';
AO.InjSG.Setpoint.ChannelNames  = sirius_ts_getname(AO.InjSG.FamilyName, 'Setpoint', AO.InjSG.DeviceList);
AO.InjSG.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.InjSG.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.InjSG.Setpoint.Units         = 'Hardware';
AO.InjSG.Setpoint.HWUnits       = 'Ampere';
AO.InjSG.Setpoint.PhysicsUnits  = 'Radian';
AO.InjSG.Setpoint.Range         = [0 300];
AO.InjSG.Setpoint.Tolerance     = .1;
AO.InjSG.Setpoint.DeltaRespMat  = .01;

AO.InjSF.FamilyName  = 'InjSF';
AO.InjSF.MemberOf    = {'PlotFamily'; 'InjSF'; 'SEPTUM'; 'Magnet';};
AO.InjSF.DeviceList  = getDeviceList(1,1);
AO.InjSF.ElementList = (1:size(AO.InjSF.DeviceList,1))';
AO.InjSF.Status      = ones(size(AO.InjSF.DeviceList,1),1);
AO.InjSF.Position    = [];
AO.InjSF.ExcitationCurves = sirius_getexcdata(repmat('ts-injseptum-thin', size(AO.InjSF.DeviceList,1), 1)); 
AO.InjSF.Monitor.MemberOf = {};
AO.InjSF.Monitor.Mode = 'Simulator';
AO.InjSF.Monitor.DataType = 'Scalar';
AO.InjSF.Monitor.ChannelNames  = sirius_ts_getname(AO.InjSF.FamilyName, 'Monitor', AO.InjSF.DeviceList);
AO.InjSF.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.InjSF.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.InjSF.Monitor.Units         = 'Hardware';
AO.InjSF.Monitor.HWUnits       = 'Ampere';
AO.InjSF.Monitor.PhysicsUnits  = 'Radian';
AO.InjSF.Setpoint.MemberOf = {'MachineConfig';};
AO.InjSF.Setpoint.Mode = 'Simulator';
AO.InjSF.Setpoint.DataType = 'Scalar';
AO.InjSF.Setpoint.ChannelNames  = sirius_ts_getname(AO.InjSF.FamilyName, 'Setpoint', AO.InjSF.DeviceList);
AO.InjSF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.InjSF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.InjSF.Setpoint.Units         = 'Hardware';
AO.InjSF.Setpoint.HWUnits       = 'Ampere';
AO.InjSF.Setpoint.PhysicsUnits  = 'Radian';
AO.InjSF.Setpoint.Range         = [0 300];
AO.InjSF.Setpoint.Tolerance     = .1;
AO.InjSF.Setpoint.DeltaRespMat  = .01;

% Quadrupoles

AO.QF1A.FamilyName  = 'QF1A';
AO.QF1A.MemberOf    = {'PlotFamily'; 'QF1A'; 'QUAD'; 'Magnet';};
AO.QF1A.DeviceList  = getDeviceList(1,1);
AO.QF1A.ElementList = (1:size(AO.QF1A.DeviceList,1))';
AO.QF1A.Status      = ones(size(AO.QF1A.DeviceList,1),1);
AO.QF1A.Position    = [];
AO.QF1A.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q14', size(AO.QF1A.DeviceList,1), 1));
AO.QF1A.Monitor.MemberOf = {};
AO.QF1A.Monitor.Mode = 'Simulator';
AO.QF1A.Monitor.DataType = 'Scalar';
AO.QF1A.Monitor.ChannelNames = sirius_ts_getname(AO.QF1A.FamilyName, 'Monitor', AO.QF1A.DeviceList);
AO.QF1A.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF1A.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QF1A.Monitor.Units        = 'Hardware';
AO.QF1A.Monitor.HWUnits      = 'Ampere';
AO.QF1A.Monitor.PhysicsUnits = 'meter^-2';
AO.QF1A.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF1A.Setpoint.Mode          = 'Simulator';
AO.QF1A.Setpoint.DataType      = 'Scalar';
AO.QF1A.Setpoint.ChannelNames = sirius_ts_getname(AO.QF1A.FamilyName, 'Setpoint', AO.QF1A.DeviceList);
AO.QF1A.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1A.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF1A.Setpoint.Units         = 'Hardware';
AO.QF1A.Setpoint.HWUnits       = 'Ampere';
AO.QF1A.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF1A.Setpoint.Range         = [0 225];
AO.QF1A.Setpoint.Tolerance     = 0.2;
AO.QF1A.Setpoint.DeltaRespMat  = 0.5; 


AO.QF1B.FamilyName  = 'QF1B';
AO.QF1B.MemberOf    = {'PlotFamily'; 'QF1B'; 'QUAD'; 'Magnet';};
AO.QF1B.DeviceList  = getDeviceList(1,1);
AO.QF1B.ElementList = (1:size(AO.QF1B.DeviceList,1))';
AO.QF1B.Status      = ones(size(AO.QF1B.DeviceList,1),1);
AO.QF1B.Position    = [];
AO.QF1B.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q14', size(AO.QF1B.DeviceList,1), 1));
AO.QF1B.Monitor.MemberOf = {};
AO.QF1B.Monitor.Mode = 'Simulator';
AO.QF1B.Monitor.DataType = 'Scalar';
AO.QF1B.Monitor.ChannelNames = sirius_ts_getname(AO.QF1B.FamilyName, 'Monitor', AO.QF1B.DeviceList);
AO.QF1B.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF1B.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QF1B.Monitor.Units        = 'Hardware';
AO.QF1B.Monitor.HWUnits      = 'Ampere';
AO.QF1B.Monitor.PhysicsUnits = 'meter^-2';
AO.QF1B.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF1B.Setpoint.Mode          = 'Simulator';
AO.QF1B.Setpoint.DataType      = 'Scalar';
AO.QF1B.Setpoint.ChannelNames = sirius_ts_getname(AO.QF1B.FamilyName, 'Setpoint', AO.QF1B.DeviceList);
AO.QF1B.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1B.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF1B.Setpoint.Units         = 'Hardware';
AO.QF1B.Setpoint.HWUnits       = 'Ampere';
AO.QF1B.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF1B.Setpoint.Range         = [0 225];
AO.QF1B.Setpoint.Tolerance     = 0.2;
AO.QF1B.Setpoint.DeltaRespMat  = 0.5; 


AO.QD2.FamilyName  = 'QD2';
AO.QD2.MemberOf    = {'PlotFamily'; 'QD2'; 'QUAD'; 'Magnet';};
AO.QD2.DeviceList  = getDeviceList(1,1);
AO.QD2.ElementList = (1:size(AO.QD2.DeviceList,1))';
AO.QD2.Status      = ones(size(AO.QD2.DeviceList,1),1);
AO.QD2.Position    = [];
AO.QD2.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q14', size(AO.QD2.DeviceList,1), 1));
AO.QD2.Monitor.MemberOf = {};
AO.QD2.Monitor.Mode = 'Simulator';
AO.QD2.Monitor.DataType = 'Scalar';
AO.QD2.Monitor.ChannelNames = sirius_ts_getname(AO.QD2.FamilyName, 'Monitor', AO.QD2.DeviceList);
AO.QD2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD2.Monitor.Units        = 'Hardware';
AO.QD2.Monitor.HWUnits      = 'Ampere';
AO.QD2.Monitor.PhysicsUnits = 'meter^-2';
AO.QD2.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD2.Setpoint.Mode          = 'Simulator';
AO.QD2.Setpoint.DataType      = 'Scalar';
AO.QD2.Setpoint.ChannelNames = sirius_ts_getname(AO.QD2.FamilyName, 'Setpoint', AO.QD2.DeviceList);
AO.QD2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD2.Setpoint.Units         = 'Hardware';
AO.QD2.Setpoint.HWUnits       = 'Ampere';
AO.QD2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD2.Setpoint.Range         = [0 225];
AO.QD2.Setpoint.Tolerance     = 0.2;
AO.QD2.Setpoint.DeltaRespMat  = 0.5; 


AO.QF2.FamilyName  = 'QF2';
AO.QF2.MemberOf    = {'PlotFamily'; 'QF2'; 'QUAD'; 'Magnet';};
AO.QF2.DeviceList  = getDeviceList(1,1);
AO.QF2.ElementList = (1:size(AO.QF2.DeviceList,1))';
AO.QF2.Status      = ones(size(AO.QF2.DeviceList,1),1);
AO.QF2.Position    = [];
AO.QF2.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q20', size(AO.QF2.DeviceList,1), 1));
AO.QF2.Monitor.MemberOf = {};
AO.QF2.Monitor.Mode = 'Simulator';
AO.QF2.Monitor.DataType = 'Scalar';
AO.QF2.Monitor.ChannelNames = sirius_ts_getname(AO.QF2.FamilyName, 'Monitor', AO.QF2.DeviceList);
AO.QF2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF2.Monitor.Units        = 'Hardware';
AO.QF2.Monitor.HWUnits      = 'Ampere';
AO.QF2.Monitor.PhysicsUnits = 'meter^-2';
AO.QF2.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF2.Setpoint.Mode          = 'Simulator';
AO.QF2.Setpoint.DataType      = 'Scalar';
AO.QF2.Setpoint.ChannelNames = sirius_ts_getname(AO.QF2.FamilyName, 'Setpoint', AO.QF2.DeviceList);
AO.QF2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF2.Setpoint.Units         = 'Hardware';
AO.QF2.Setpoint.HWUnits       = 'Ampere';
AO.QF2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF2.Setpoint.Range         = [0 225];
AO.QF2.Setpoint.Tolerance     = 0.2;
AO.QF2.Setpoint.DeltaRespMat  = 0.5; 


AO.QF3.FamilyName  = 'QF3';
AO.QF3.MemberOf    = {'PlotFamily'; 'QF3'; 'QUAD'; 'Magnet';};
AO.QF3.DeviceList  = getDeviceList(1,1);
AO.QF3.ElementList = (1:size(AO.QF3.DeviceList,1))';
AO.QF3.Status      = ones(size(AO.QF3.DeviceList,1),1);
AO.QF3.Position    = [];
AO.QF3.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q20', size(AO.QF3.DeviceList,1), 1));
AO.QF3.Monitor.MemberOf = {};
AO.QF3.Monitor.Mode = 'Simulator';
AO.QF3.Monitor.DataType = 'Scalar';
AO.QF3.Monitor.ChannelNames = sirius_ts_getname(AO.QF3.FamilyName, 'Monitor', AO.QF3.DeviceList);
AO.QF3.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.MOnitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Monitor.Units        = 'Hardware';
AO.QF3.Monitor.HWUnits      = 'Ampere';
AO.QF3.Monitor.PhysicsUnits = 'meter^-2';
AO.QF3.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF3.Setpoint.Mode          = 'Simulator';
AO.QF3.Setpoint.DataType      = 'Scalar';
AO.QF3.Setpoint.ChannelNames = sirius_ts_getname(AO.QF3.FamilyName, 'Setpoint', AO.QF3.DeviceList);
AO.QF3.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Setpoint.Units         = 'Hardware';
AO.QF3.Setpoint.HWUnits       = 'Ampere';
AO.QF3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF3.Setpoint.Range         = [0 225];
AO.QF3.Setpoint.Tolerance     = 0.2;
AO.QF3.Setpoint.DeltaRespMat  = 0.5; 


AO.QD4A.FamilyName  = 'QD4A';
AO.QD4A.MemberOf    = {'PlotFamily'; 'QD4A'; 'QUAD'; 'Magnet';};
AO.QD4A.DeviceList  = getDeviceList(1,1);
AO.QD4A.ElementList = (1:size(AO.QD4A.DeviceList,1))';
AO.QD4A.Status      = ones(size(AO.QD4A.DeviceList,1),1);
AO.QD4A.Position    = [];
AO.QD4A.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q14', size(AO.QD4A.DeviceList,1), 1));
AO.QD4A.Monitor.MemberOf = {};
AO.QD4A.Monitor.Mode = 'Simulator';
AO.QD4A.Monitor.DataType = 'Scalar';
AO.QD4A.Monitor.ChannelNames = sirius_ts_getname(AO.QD4A.FamilyName, 'Monitor', AO.QD4A.DeviceList);
AO.QD4A.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4A.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD4A.Monitor.Units        = 'Hardware';
AO.QD4A.Monitor.HWUnits      = 'Ampere';
AO.QD4A.Monitor.PhysicsUnits = 'meter^-2';
AO.QD4A.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD4A.Setpoint.Mode          = 'Simulator';
AO.QD4A.Setpoint.DataType      = 'Scalar';
AO.QD4A.Setpoint.ChannelNames = sirius_ts_getname(AO.QD4A.FamilyName, 'Setpoint', AO.QD4A.DeviceList);
AO.QD4A.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4A.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD4A.Setpoint.Units         = 'Hardware';
AO.QD4A.Setpoint.HWUnits       = 'Ampere';
AO.QD4A.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD4A.Setpoint.Range         = [0 225];
AO.QD4A.Setpoint.Tolerance     = 0.2;
AO.QD4A.Setpoint.DeltaRespMat  = 0.5; 


AO.QF4.FamilyName  = 'QF4';
AO.QF4.MemberOf    = {'PlotFamily'; 'QF4'; 'QUAD'; 'Magnet';};
AO.QF4.DeviceList  = getDeviceList(1,1);
AO.QF4.ElementList = (1:size(AO.QF4.DeviceList,1))';
AO.QF4.Status      = ones(size(AO.QF4.DeviceList,1),1);
AO.QF4.Position    = [];
AO.QF4.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q20', size(AO.QF4.DeviceList,1), 1));
AO.QF4.Monitor.MemberOf = {};
AO.QF4.Monitor.Mode = 'Simulator';
AO.QF4.Monitor.DataType = 'Scalar';
AO.QF4.Monitor.ChannelNames = sirius_ts_getname(AO.QF4.FamilyName, 'Monitor', AO.QF4.DeviceList);
AO.QF4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF4.Monitor.Units        = 'Hardware';
AO.QF4.Monitor.HWUnits      = 'Ampere';
AO.QF4.Monitor.PhysicsUnits = 'meter^-2';
AO.QF4.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF4.Setpoint.Mode          = 'Simulator';
AO.QF4.Setpoint.DataType      = 'Scalar';
AO.QF4.Setpoint.ChannelNames = sirius_ts_getname(AO.QF4.FamilyName, 'Setpoint', AO.QF4.DeviceList);
AO.QF4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF4.Setpoint.Units         = 'Hardware';
AO.QF4.Setpoint.HWUnits       = 'Ampere';
AO.QF4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF4.Setpoint.Range         = [0 225];
AO.QF4.Setpoint.Tolerance     = 0.2;
AO.QF4.Setpoint.DeltaRespMat  = 0.5; 

AO.QD4B.FamilyName  = 'QD4B';
AO.QD4B.MemberOf    = {'PlotFamily'; 'QD4B'; 'QUAD'; 'Magnet';};
AO.QD4B.DeviceList  = getDeviceList(1,1);
AO.QD4B.ElementList = (1:size(AO.QD4B.DeviceList,1))';
AO.QD4B.Status      = ones(size(AO.QD4B.DeviceList,1),1);
AO.QD4B.Position    = [];
AO.QD4B.ExcitationCurves = sirius_getexcdata(repmat('ts-quadrupole-q14', size(AO.QD4B.DeviceList,1), 1));
AO.QD4B.Monitor.MemberOf = {};
AO.QD4B.Monitor.Mode = 'Simulator';
AO.QD4B.Monitor.DataType = 'Scalar';
AO.QD4B.Monitor.ChannelNames = sirius_ts_getname(AO.QD4B.FamilyName, 'Monitor', AO.QD4B.DeviceList);
AO.QD4B.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4B.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD4B.Monitor.Units        = 'Hardware';
AO.QD4B.Monitor.HWUnits      = 'Ampere';
AO.QD4B.Monitor.PhysicsUnits = 'meter^-2';
AO.QD4B.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD4B.Setpoint.Mode          = 'Simulator';
AO.QD4B.Setpoint.DataType      = 'Scalar';
AO.QD4B.Setpoint.ChannelNames = sirius_ts_getname(AO.QD4B.FamilyName, 'Setpoint', AO.QD4B.DeviceList);
AO.QD4B.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4B.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD4B.Setpoint.Units         = 'Hardware';
AO.QD4B.Setpoint.HWUnits       = 'Ampere';
AO.QD4B.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD4B.Setpoint.Range         = [0 225];
AO.QD4B.Setpoint.Tolerance     = 0.2;
AO.QD4B.Setpoint.DeltaRespMat  = 0.5;  


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% CH
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'Magnet'; 'HCM'};
AO.CH.DeviceList  = getDeviceList(1,5);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('ts-corrector-ch', size(AO.CH.DeviceList,1), 1));
AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'Magnet';};
AO.CH.Monitor.Mode = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.ChannelNames  = sirius_ts_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList);
AO.CH.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Monitor.Units         = 'Physics';
AO.CH.Monitor.HWUnits       = 'Ampere';
AO.CH.Monitor.PhysicsUnits  = 'Radian';
AO.CH.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'CH'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CH.Setpoint.Mode = 'Simulator';
AO.CH.Setpoint.DataType = 'Scalar';
AO.CH.Setpoint.ChannelNames = sirius_ts_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Setpoint.Units        = 'Physics';
AO.CH.Setpoint.HWUnits      = 'Ampere';
AO.CH.Setpoint.PhysicsUnits = 'Radian';
AO.CH.Setpoint.Range        = [-10 10];
AO.CH.Setpoint.Tolerance    = 0.00001;
AO.CH.Setpoint.DeltaRespMat = 0.0005; 

% CV
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'Magnet'; 'VCM'};
AO.CV.DeviceList  = getDeviceList(1,5);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('ts-corrector-cv', size(AO.CV.DeviceList,1), 1));
AO.CV.Monitor.MemberOf = {'Vertical'; 'COR'; 'CV'; 'Magnet';};
AO.CV.Monitor.Mode = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.ChannelNames = sirius_ts_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList);
AO.CV.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Monitor.Units        = 'Physics';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'CV'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CV.Setpoint.Mode = 'Simulator';
AO.CV.Setpoint.DataType = 'Scalar';
AO.CV.Setpoint.ChannelNames = sirius_ts_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Setpoint.Units        = 'Physics';
AO.CV.Setpoint.HWUnits      = 'Ampere';
AO.CV.Setpoint.PhysicsUnits = 'Radian';
AO.CV.Setpoint.Range        = [-10 10];
AO.CV.Setpoint.Tolerance    = 0.00001;
AO.CV.Setpoint.DeltaRespMat = 0.0005; 


% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = getDeviceList(1,5);
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.Golden      = zeros(length(AO.BPMx.ElementList),1);
AO.BPMx.Offset      = zeros(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = sirius_ts_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams =  1e6;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'um';
AO.BPMx.Monitor.PhysicsUnits = 'meter';

% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = getDeviceList(1,5);
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.Golden      = zeros(length(AO.BPMy.ElementList),1);
AO.BPMy.Offset      = zeros(length(AO.BPMy.ElementList),1);

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = sirius_ts_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams =  1e6;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'um';
AO.BPMy.Monitor.PhysicsUnits = 'meter';

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);

 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end
