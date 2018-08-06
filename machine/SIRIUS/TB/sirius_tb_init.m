function sirius_tb_init(OperationalMode)
%SIRIUS_TB_INIT - MML initialization file for the TB at sirius
% 
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);


AD.Directory.ExcDataDir  = '/home/fac_files/lnls-sirius/control-system-constants/magnet/excitation-data';
setad(AD);


% BENDS

% AO.Spect.FamilyName  = 'Spect';
% AO.Spect.MemberOf    = {'PlotFamily'; 'Spect'; 'BEND'; 'Magnet';};
% AO.Spect.DeviceList  = getDeviceList(1,1);
% AO.Spect.ElementList = (1:size(AO.Spect.DeviceList,1))';
% AO.Spect.Status      = ones(size(AO.Spect.DeviceList,1),1);
% AO.Spect.Position    = [];
% AO.Spect.ExcitationCurves = sirius_getexcdata(repmat('tb-dipole-b-fam', size(AO.Spect.DeviceList,1), 1)); 
% AO.Spect.Monitor.MemberOf = {};
% AO.Spect.Monitor.Mode = 'Simulator';
% AO.Spect.Monitor.DataType = 'Scalar';
% AO.Spect.Monitor.ChannelNames = sirius_tb_getname(AO.Spect.FamilyName, 'Monitor', AO.Spect.DeviceList);
% AO.Spect.Monitor.HW2PhysicsFcn = @bend2gev;
% AO.Spect.Monitor.Physics2HWFcn = @gev2bend;
% AO.Spect.Monitor.Units        = 'Hardware';
% AO.Spect.Monitor.HWUnits      = 'Ampere';
% AO.Spect.Monitor.PhysicsUnits = 'GeV';
% AO.Spect.Setpoint.MemberOf = {'MachineConfig';};
% AO.Spect.Setpoint.Mode = 'Simulator';
% AO.Spect.Setpoint.DataType = 'Scalar';
% AO.Spect.Setpoint.ChannelNames = sirius_tb_getname(AO.Spect.FamilyName, 'Setpoint', AO.Spect.DeviceList);
% AO.Spect.Setpoint.HW2PhysicsFcn = @bend2gev;
% AO.Spect.Setpoint.Physics2HWFcn = @gev2bend;
% AO.Spect.Setpoint.Units        = 'Hardware';
% AO.Spect.Setpoint.HWUnits      = 'Ampere';
% AO.Spect.Setpoint.PhysicsUnits = 'GeV';
% AO.Spect.Setpoint.Range        = [0 300];
% AO.Spect.Setpoint.Tolerance    = .1;
% AO.Spect.Setpoint.DeltaRespMat = .01;

AO.B.FamilyName  = 'B';
AO.B.MemberOf    = {'PlotFamily'; 'B'; 'BEND'; 'Magnet';};
AO.B.DeviceList  = getDeviceList(1,3);
AO.B.ElementList = (1:size(AO.B.DeviceList,1))';
AO.B.Status      = ones(size(AO.B.DeviceList,1),1);
AO.B.Position    = [];
AO.B.ExcitationCurves = sirius_getexcdata(repmat('tb-dipole-b-fam', size(AO.B.DeviceList,1), 1));
AO.B.Monitor.MemberOf = {};
AO.B.Monitor.Mode = 'Simulator';
AO.B.Monitor.DataType = 'Scalar';
AO.B.Monitor.ChannelNames = sirius_tb_getname(AO.B.FamilyName, 'Monitor', AO.B.DeviceList);
AO.B.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B.Monitor.Physics2HWFcn = @gev2bend;
AO.B.Monitor.Units        = 'Hardware';
AO.B.Monitor.HWUnits      = 'Ampere';
AO.B.Monitor.PhysicsUnits = 'GeV';
AO.B.Setpoint.MemberOf = {'MachineConfig';};
AO.B.Setpoint.Mode = 'Simulator';
AO.B.Setpoint.DataType = 'Scalar';
AO.B.Setpoint.ChannelNames = sirius_tb_getname(AO.B.FamilyName, 'Setpoint', AO.B.DeviceList);
AO.B.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B.Setpoint.Physics2HWFcn = @gev2bend;
AO.B.Setpoint.Units        = 'Hardware';
AO.B.Setpoint.HWUnits      = 'Ampere';
AO.B.Setpoint.PhysicsUnits = 'GeV';
AO.B.Setpoint.Range        = [0 300];
AO.B.Setpoint.Tolerance    = .1;
AO.B.Setpoint.DeltaRespMat = .01;

AO.InjS.FamilyName  = 'InjS';
AO.InjS.MemberOf    = {'PlotFamily'; 'InjS'; 'BEND'; 'Magnet';};
AO.InjS.DeviceList  = getDeviceList(1,1);
AO.InjS.ElementList = (1:size(AO.InjS.DeviceList,1))';
AO.InjS.Status      = ones(size(AO.InjS.DeviceList,1),1);
AO.InjS.Position    = [];
AO.InjS.ExcitationCurves = sirius_getexcdata(repmat('tb-injseptum', size(AO.InjS.DeviceList,1), 1));
AO.InjS.Monitor.MemberOf = {};
AO.InjS.Monitor.Mode = 'Simulator';
AO.InjS.Monitor.DataType = 'Scalar';
AO.InjS.Monitor.ChannelNames = sirius_tb_getname(AO.InjS.FamilyName, 'Monitor', AO.InjS.DeviceList);
AO.InjS.Monitor.HW2PhysicsFcn = @bend2gev;
AO.InjS.Monitor.Physics2HWFcn = @gev2bend;
AO.InjS.Monitor.Units        = 'Hardware';
AO.InjS.Monitor.HWUnits      = 'Ampere';
AO.InjS.Monitor.PhysicsUnits = 'GeV';
AO.InjS.Setpoint.MemberOf = {'MachineConfig';};
AO.InjS.Setpoint.Mode = 'Simulator';
AO.InjS.Setpoint.DataType = 'Scalar';
AO.InjS.Setpoint.ChannelNames = sirius_tb_getname(AO.InjS.FamilyName, 'Setpoint', AO.InjS.DeviceList);
AO.InjS.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.InjS.Setpoint.Physics2HWFcn = @gev2bend;
AO.InjS.Setpoint.Units        = 'Hardware';
AO.InjS.Setpoint.HWUnits      = 'Ampere';
AO.InjS.Setpoint.PhysicsUnits = 'GeV';
AO.InjS.Setpoint.Range        = [0 300];
AO.InjS.Setpoint.Tolerance    = .1;
AO.InjS.Setpoint.DeltaRespMat = .01;

AO.QF2L.FamilyName  = 'QF2L';
AO.QF2L.MemberOf    = {'PlotFamily'; 'QF2L'; 'QUAD'; 'Magnet';};
AO.QF2L.DeviceList  = getDeviceList(1,2);
AO.QF2L.ElementList = (1:size(AO.QF2L.DeviceList,1))';
AO.QF2L.Status      = ones(size(AO.QF2L.DeviceList,1),1);
AO.QF2L.Position    = [];
AO.QF2L.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF2L.DeviceList,1), 1));
AO.QF2L.Monitor.MemberOf = {};
AO.QF2L.Monitor.Mode = 'Simulator';
AO.QF2L.Monitor.DataType = 'Scalar';
AO.QF2L.Monitor.ChannelNames = sirius_tb_getname(AO.QF2L.FamilyName, 'Monitor', AO.QF2L.DeviceList);
AO.QF2L.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF2L.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QF2L.Monitor.Units        = 'Hardware';
AO.QF2L.Monitor.HWUnits      = 'Ampere';
AO.QF2L.Monitor.PhysicsUnits = 'meter^-2';
AO.QF2L.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF2L.Setpoint.Mode          = 'Simulator';
AO.QF2L.Setpoint.DataType      = 'Scalar';
AO.QF2L.Setpoint.ChannelNames = sirius_tb_getname(AO.QF2L.FamilyName, 'Setpoint', AO.QF2L.DeviceList);
AO.QF2L.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2L.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF2L.Setpoint.Units         = 'Hardware';
AO.QF2L.Setpoint.HWUnits       = 'Ampere';
AO.QF2L.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF2L.Setpoint.Range         = [0 225];
AO.QF2L.Setpoint.Tolerance     = 0.2;
AO.QF2L.Setpoint.DeltaRespMat  = 0.5; 

AO.QD2L.FamilyName  = 'QD2L';
AO.QD2L.MemberOf    = {'PlotFamily'; 'QD2L'; 'QUAD'; 'Magnet';};
AO.QD2L.DeviceList  = getDeviceList(1,1);
AO.QD2L.ElementList = (1:size(AO.QD2L.DeviceList,1))';
AO.QD2L.Status      = ones(size(AO.QD2L.DeviceList,1),1);
AO.QD2L.Position    = [];
AO.QD2L.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD2L.DeviceList,1), 1));
AO.QD2L.Monitor.MemberOf = {};
AO.QD2L.Monitor.Mode = 'Simulator';
AO.QD2L.Monitor.DataType = 'Scalar';
AO.QD2L.Monitor.ChannelNames = sirius_tb_getname(AO.QD2L.FamilyName, 'Monitor', AO.QD2L.DeviceList);
AO.QD2L.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD2L.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QD2L.Monitor.Units        = 'Hardware';
AO.QD2L.Monitor.HWUnits      = 'Ampere';
AO.QD2L.Monitor.PhysicsUnits = 'meter^-2';
AO.QD2L.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD2L.Setpoint.Mode          = 'Simulator';
AO.QD2L.Setpoint.DataType      = 'Scalar';
AO.QD2L.Setpoint.ChannelNames = sirius_tb_getname(AO.QD2L.FamilyName, 'Setpoint', AO.QD2L.DeviceList);
AO.QD2L.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2L.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD2L.Setpoint.Units         = 'Hardware';
AO.QD2L.Setpoint.HWUnits       = 'Ampere';
AO.QD2L.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD2L.Setpoint.Range         = [0 225];
AO.QD2L.Setpoint.Tolerance     = 0.2;
AO.QD2L.Setpoint.DeltaRespMat  = 0.5; 

AO.QF3L.FamilyName  = 'QF3L';
AO.QF3L.MemberOf    = {'PlotFamily'; 'QF3L'; 'QUAD'; 'Magnet';};
AO.QF3L.DeviceList  = getDeviceList(1,1);
AO.QF3L.ElementList = (1:size(AO.QF3L.DeviceList,1))';
AO.QF3L.Status      = ones(size(AO.QF3L.DeviceList,1),1);
AO.QF3L.Position    = [];
AO.QF3L.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF3L.DeviceList,1), 1));
AO.QF3L.Monitor.MemberOf = {};
AO.QF3L.Monitor.Mode = 'Simulator';
AO.QF3L.Monitor.DataType = 'Scalar';
AO.QF3L.Monitor.ChannelNames = sirius_tb_getname(AO.QF3L.FamilyName, 'Monitor', AO.QF3L.DeviceList);
AO.QF3L.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3L.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF3L.Monitor.Units        = 'Hardware';
AO.QF3L.Monitor.HWUnits      = 'Ampere';
AO.QF3L.Monitor.PhysicsUnits = 'meter^-2';
AO.QF3L.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF3L.Setpoint.Mode          = 'Simulator';
AO.QF3L.Setpoint.DataType      = 'Scalar';
AO.QF3L.Setpoint.ChannelNames = sirius_tb_getname(AO.QF3L.FamilyName, 'Setpoint', AO.QF3L.DeviceList);
AO.QF3L.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3L.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF3L.Setpoint.Units         = 'Hardware';
AO.QF3L.Setpoint.HWUnits       = 'Ampere';
AO.QF3L.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF3L.Setpoint.Range         = [0 225];
AO.QF3L.Setpoint.Tolerance     = 0.2;
AO.QF3L.Setpoint.DeltaRespMat  = 0.5; 

AO.QD1.FamilyName  = 'QD1';
AO.QD1.MemberOf    = {'PlotFamily'; 'QD1'; 'QUAD'; 'Magnet';};
AO.QD1.DeviceList  = getDeviceList(1,1);
AO.QD1.ElementList = (1:size(AO.QD1.DeviceList,1))';
AO.QD1.Status      = ones(size(AO.QD1.DeviceList,1),1);
AO.QD1.Position    = [];
AO.QD1.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD1.DeviceList,1), 1));
AO.QD1.Monitor.MemberOf = {};
AO.QD1.Monitor.Mode = 'Simulator';
AO.QD1.Monitor.DataType = 'Scalar';
AO.QD1.Monitor.ChannelNames = sirius_tb_getname(AO.QD1.FamilyName, 'Monitor', AO.QD1.DeviceList);
AO.QD1.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD1.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD1.Monitor.Units        = 'Hardware';
AO.QD1.Monitor.HWUnits      = 'Ampere';
AO.QD1.Monitor.PhysicsUnits = 'meter^-2';
AO.QD1.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD1.Setpoint.Mode          = 'Simulator';
AO.QD1.Setpoint.DataType      = 'Scalar';
AO.QD1.Setpoint.ChannelNames = sirius_tb_getname(AO.QD1.FamilyName, 'Setpoint', AO.QD1.DeviceList);
AO.QD1.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD1.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD1.Setpoint.Units         = 'Hardware';
AO.QD1.Setpoint.HWUnits       = 'Ampere';
AO.QD1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD1.Setpoint.Range         = [0 225];
AO.QD1.Setpoint.Tolerance     = 0.2;
AO.QD1.Setpoint.DeltaRespMat  = 0.5; 

AO.QF1.FamilyName  = 'QF1';
AO.QF1.MemberOf    = {'PlotFamily'; 'QF1'; 'QUAD'; 'Magnet';};
AO.QF1.DeviceList  = getDeviceList(1,1);
AO.QF1.ElementList = (1:size(AO.QF1.DeviceList,1))';
AO.QF1.Status      = ones(size(AO.QF1.DeviceList,1),1);
AO.QF1.Position    = [];
AO.QF1.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF1.DeviceList,1), 1));
AO.QF1.Monitor.MemberOf = {};
AO.QF1.Monitor.Mode = 'Simulator';
AO.QF1.Monitor.DataType = 'Scalar';
AO.QF1.Monitor.ChannelNames = sirius_tb_getname(AO.QF1.FamilyName, 'Monitor', AO.QF1.DeviceList);
AO.QF1.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF1.Monitor.Units        = 'Hardware';
AO.QF1.Monitor.HWUnits      = 'Ampere';
AO.QF1.Monitor.PhysicsUnits = 'meter^-2';
AO.QF1.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF1.Setpoint.Mode          = 'Simulator';
AO.QF1.Setpoint.DataType      = 'Scalar';
AO.QF1.Setpoint.ChannelNames = sirius_tb_getname(AO.QF1.FamilyName, 'Setpoint', AO.QF1.DeviceList);
AO.QF1.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF1.Setpoint.Units         = 'Hardware';
AO.QF1.Setpoint.HWUnits       = 'Ampere';
AO.QF1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF1.Setpoint.Range         = [0 225];
AO.QF1.Setpoint.Tolerance     = 0.2;
AO.QF1.Setpoint.DeltaRespMat  = 0.5; 

AO.QD2A.FamilyName  = 'QD2A';
AO.QD2A.MemberOf    = {'PlotFamily'; 'QD2A'; 'QUAD'; 'Magnet';};
AO.QD2A.DeviceList  = getDeviceList(1,1);
AO.QD2A.ElementList = (1:size(AO.QD2A.DeviceList,1))';
AO.QD2A.Status      = ones(size(AO.QD2A.DeviceList,1),1);
AO.QD2A.Position    = [];
AO.QD2A.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD2A.DeviceList,1), 1));
AO.QD2A.Monitor.MemberOf = {};
AO.QD2A.Monitor.Mode = 'Simulator';
AO.QD2A.Monitor.DataType = 'Scalar';
AO.QD2A.Monitor.ChannelNames = sirius_tb_getname(AO.QD2A.FamilyName, 'Monitor', AO.QD2A.DeviceList);
AO.QD2A.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2A.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD2A.Monitor.Units        = 'Hardware';
AO.QD2A.Monitor.HWUnits      = 'Ampere';
AO.QD2A.Monitor.PhysicsUnits = 'meter^-2';
AO.QD2A.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD2A.Setpoint.Mode          = 'Simulator';
AO.QD2A.Setpoint.DataType      = 'Scalar';
AO.QD2A.Setpoint.ChannelNames = sirius_tb_getname(AO.QD2A.FamilyName, 'Setpoint', AO.QD2A.DeviceList);
AO.QD2A.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2A.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD2A.Setpoint.Units         = 'Hardware';
AO.QD2A.Setpoint.HWUnits       = 'Ampere';
AO.QD2A.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD2A.Setpoint.Range         = [0 225];
AO.QD2A.Setpoint.Tolerance     = 0.2;
AO.QD2A.Setpoint.DeltaRespMat  = 0.5; 

AO.QF2A.FamilyName  = 'QF2A';
AO.QF2A.MemberOf    = {'PlotFamily'; 'QF2A'; 'QUAD'; 'Magnet';};
AO.QF2A.DeviceList  = getDeviceList(1,1);
AO.QF2A.ElementList = (1:size(AO.QF2A.DeviceList,1))';
AO.QF2A.Status      = ones(size(AO.QF2A.DeviceList,1),1);
AO.QF2A.Position    = [];
AO.QF2A.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF2A.DeviceList,1), 1));
AO.QF2A.Monitor.MemberOf = {};
AO.QF2A.Monitor.Mode = 'Simulator';
AO.QF2A.Monitor.DataType = 'Scalar';
AO.QF2A.Monitor.ChannelNames = sirius_tb_getname(AO.QF2A.FamilyName, 'Monitor', AO.QF2A.DeviceList);
AO.QF2A.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2A.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF2A.Monitor.Units        = 'Hardware';
AO.QF2A.Monitor.HWUnits      = 'Ampere';
AO.QF2A.Monitor.PhysicsUnits = 'meter^-2';
AO.QF2A.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF2A.Setpoint.Mode          = 'Simulator';
AO.QF2A.Setpoint.DataType      = 'Scalar';
AO.QF2A.Setpoint.ChannelNames = sirius_tb_getname(AO.QF2A.FamilyName, 'Setpoint', AO.QF2A.DeviceList);
AO.QF2A.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2A.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF2A.Setpoint.Units         = 'Hardware';
AO.QF2A.Setpoint.HWUnits       = 'Ampere';
AO.QF2A.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF2A.Setpoint.Range         = [0 225];
AO.QF2A.Setpoint.Tolerance     = 0.2;
AO.QF2A.Setpoint.DeltaRespMat  = 0.5; 

AO.QF2B.FamilyName  = 'QF2B';
AO.QF2B.MemberOf    = {'PlotFamily'; 'QF2B'; 'QUAD'; 'Magnet';};
AO.QF2B.DeviceList  = getDeviceList(1,1);
AO.QF2B.ElementList = (1:size(AO.QF2B.DeviceList,1))';
AO.QF2B.Status      = ones(size(AO.QF2B.DeviceList,1),1);
AO.QF2B.Position    = [];
AO.QF2B.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF2B.DeviceList,1), 1));
AO.QF2B.Monitor.MemberOf = {};
AO.QF2B.Monitor.Mode = 'Simulator';
AO.QF2B.Monitor.DataType = 'Scalar';
AO.QF2B.Monitor.ChannelNames = sirius_tb_getname(AO.QF2B.FamilyName, 'Monitor', AO.QF2B.DeviceList);
AO.QF2B.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2B.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF2B.Monitor.Units        = 'Hardware';
AO.QF2B.Monitor.HWUnits      = 'Ampere';
AO.QF2B.Monitor.PhysicsUnits = 'meter^-2';
AO.QF2B.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF2B.Setpoint.Mode          = 'Simulator';
AO.QF2B.Setpoint.DataType      = 'Scalar';
AO.QF2B.Setpoint.ChannelNames = sirius_tb_getname(AO.QF2B.FamilyName, 'Setpoint', AO.QF2B.DeviceList);
AO.QF2B.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2B.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF2B.Setpoint.Units         = 'Hardware';
AO.QF2B.Setpoint.HWUnits       = 'Ampere';
AO.QF2B.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF2B.Setpoint.Range         = [0 225];
AO.QF2B.Setpoint.Tolerance     = 0.2;
AO.QF2B.Setpoint.DeltaRespMat  = 0.5; 

AO.QD2B.FamilyName  = 'QD2B';
AO.QD2B.MemberOf    = {'PlotFamily'; 'QD2B'; 'QUAD'; 'Magnet';};
AO.QD2B.DeviceList  = getDeviceList(1,1);
AO.QD2B.ElementList = (1:size(AO.QD2B.DeviceList,1))';
AO.QD2B.Status      = ones(size(AO.QD2B.DeviceList,1),1);
AO.QD2B.Position    = [];
AO.QD2B.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD2B.DeviceList,1), 1));
AO.QD2B.Monitor.MemberOf = {};
AO.QD2B.Monitor.Mode = 'Simulator';
AO.QD2B.Monitor.DataType = 'Scalar';
AO.QD2B.Monitor.ChannelNames = sirius_tb_getname(AO.QD2B.FamilyName, 'Monitor', AO.QD2B.DeviceList);
AO.QD2B.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2B.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD2B.Monitor.Units        = 'Hardware';
AO.QD2B.Monitor.HWUnits      = 'Ampere';
AO.QD2B.Monitor.PhysicsUnits = 'meter^-2';
AO.QD2B.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD2B.Setpoint.Mode          = 'Simulator';
AO.QD2B.Setpoint.DataType      = 'Scalar';
AO.QD2B.Setpoint.ChannelNames = sirius_tb_getname(AO.QD2B.FamilyName, 'Setpoint', AO.QD2B.DeviceList);
AO.QD2B.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2B.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD2B.Setpoint.Units         = 'Hardware';
AO.QD2B.Setpoint.HWUnits       = 'Ampere';
AO.QD2B.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD2B.Setpoint.Range         = [0 225];
AO.QD2B.Setpoint.Tolerance     = 0.2;
AO.QD2B.Setpoint.DeltaRespMat  = 0.5; 

AO.QF3.FamilyName  = 'QF3';
AO.QF3.MemberOf    = {'PlotFamily'; 'QF3'; 'QUAD'; 'Magnet';};
AO.QF3.DeviceList  = getDeviceList(1,1);
AO.QF3.ElementList = (1:size(AO.QF3.DeviceList,1))';
AO.QF3.Status      = ones(size(AO.QF3.DeviceList,1),1);
AO.QF3.Position    = [];
AO.QF3.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF3.DeviceList,1), 1));
AO.QF3.Monitor.MemberOf = {};
AO.QF3.Monitor.Mode = 'Simulator';
AO.QF3.Monitor.DataType = 'Scalar';
AO.QF3.Monitor.ChannelNames  = sirius_tb_getname(AO.QF3.FamilyName, 'Monitor', AO.QF3.DeviceList);
AO.QF3.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Monitor.Units        = 'Hardware';
AO.QF3.Monitor.HWUnits      = 'Ampere';
AO.QF3.Monitor.PhysicsUnits = 'meter^-2';
AO.QF3.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF3.Setpoint.Mode          = 'Simulator';
AO.QF3.Setpoint.DataType      = 'Scalar';
AO.QF3.Setpoint.ChannelNames  = sirius_tb_getname(AO.QF3.FamilyName, 'Setpoint', AO.QF3.DeviceList);
AO.QF3.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Setpoint.Units         = 'Hardware';
AO.QF3.Setpoint.HWUnits       = 'Ampere';
AO.QF3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF3.Setpoint.Range         = [0 225];
AO.QF3.Setpoint.Tolerance     = 0.2;
AO.QF3.Setpoint.DeltaRespMat  = 0.5; 

AO.QD3.FamilyName  = 'QD3';
AO.QD3.MemberOf    = {'PlotFamily'; 'QD3'; 'QUAD'; 'Magnet';};
AO.QD3.DeviceList  = getDeviceList(1,1);
AO.QD3.ElementList = (1:size(AO.QD3.DeviceList,1))';
AO.QD3.Status      = ones(size(AO.QD3.DeviceList,1),1);
AO.QD3.Position    = [];
AO.QD3.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD3.DeviceList,1), 1));
AO.QD3.Monitor.MemberOf = {};
AO.QD3.Monitor.Mode = 'Simulator';
AO.QD3.Monitor.DataType = 'Scalar';
AO.QD3.Monitor.ChannelNames  = sirius_tb_getname(AO.QD3.FamilyName, 'Monitor', AO.QD3.DeviceList);
AO.QD3.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD3.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD3.Monitor.Units        = 'Hardware';
AO.QD3.Monitor.HWUnits      = 'Ampere';
AO.QD3.Monitor.PhysicsUnits = 'meter^-2';
AO.QD3.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD3.Setpoint.Mode          = 'Simulator';
AO.QD3.Setpoint.DataType      = 'Scalar';
AO.QD3.Setpoint.ChannelNames  = sirius_tb_getname(AO.QD3.FamilyName, 'Setpoint', AO.QD3.DeviceList);
AO.QD3.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD3.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD3.Setpoint.Units         = 'Hardware';
AO.QD3.Setpoint.HWUnits       = 'Ampere';
AO.QD3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD3.Setpoint.Range         = [0 225];
AO.QD3.Setpoint.Tolerance     = 0.2;
AO.QD3.Setpoint.DeltaRespMat  = 0.5; 

AO.QF4.FamilyName  = 'QF4';
AO.QF4.MemberOf    = {'PlotFamily'; 'QF4'; 'QUAD'; 'Magnet';};
AO.QF4.DeviceList  = getDeviceList(1,1);
AO.QF4.ElementList = (1:size(AO.QF4.DeviceList,1))';
AO.QF4.Status      = ones(size(AO.QF4.DeviceList,1),1);
AO.QF4.Position    = [];
AO.QF4.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QF4.DeviceList,1), 1));
AO.QF4.Monitor.MemberOf = {};
AO.QF4.Monitor.Mode = 'Simulator';
AO.QF4.Monitor.DataType = 'Scalar';
AO.QF4.Monitor.ChannelNames = sirius_tb_getname(AO.QF4.FamilyName, 'Monitor', AO.QF4.DeviceList);
AO.QF4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF4.Monitor.Units        = 'Hardware';
AO.QF4.Monitor.HWUnits      = 'Ampere';
AO.QF4.Monitor.PhysicsUnits = 'meter^-2';
AO.QF4.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF4.Setpoint.Mode          = 'Simulator';
AO.QF4.Setpoint.DataType      = 'Scalar';
AO.QF4.Setpoint.ChannelNames = sirius_tb_getname(AO.QF4.FamilyName, 'Setpoint', AO.QF4.DeviceList);
AO.QF4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF4.Setpoint.Units         = 'Hardware';
AO.QF4.Setpoint.HWUnits       = 'Ampere';
AO.QF4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF4.Setpoint.Range         = [0 225];
AO.QF4.Setpoint.Tolerance     = 0.2;
AO.QF4.Setpoint.DeltaRespMat  = 0.5; 

AO.QD4.FamilyName  = 'QD4';
AO.QD4.MemberOf    = {'PlotFamily'; 'QD4'; 'QUAD'; 'Magnet';};
AO.QD4.DeviceList  = getDeviceList(1,1);
AO.QD4.ElementList = (1:size(AO.QD4.DeviceList,1))';
AO.QD4.Status      = ones(size(AO.QD4.DeviceList,1),1);
AO.QD4.Position    = [];
AO.QD4.ExcitationCurves = sirius_getexcdata(repmat('tb-quadrupole', size(AO.QD4.DeviceList,1), 1));
AO.QD4.Monitor.MemberOf = {};
AO.QD4.Monitor.Mode = 'Simulator';
AO.QD4.Monitor.DataType = 'Scalar';
AO.QD4.Monitor.ChannelNames = sirius_tb_getname(AO.QD4.FamilyName, 'Monitor', AO.QD4.DeviceList);
AO.QD4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD4.Monitor.Units        = 'Hardware';
AO.QD4.Monitor.HWUnits      = 'Ampere';
AO.QD4.Monitor.PhysicsUnits = 'meter^-2';
AO.QD4.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD4.Setpoint.Mode          = 'Simulator';
AO.QD4.Setpoint.DataType      = 'Scalar';
AO.QD4.Setpoint.ChannelNames = sirius_tb_getname(AO.QD4.FamilyName, 'Setpoint', AO.QD4.DeviceList);
AO.QD4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD4.Setpoint.Units         = 'Hardware';
AO.QD4.Setpoint.HWUnits       = 'Ampere';
AO.QD4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD4.Setpoint.Range         = [0 225];
AO.QD4.Setpoint.Tolerance     = 0.2;
AO.QD4.Setpoint.DeltaRespMat  = 0.5; 

%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% CH
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'HCM'; 'Magnet'};
AO.CH.DeviceList  = getDeviceList(1,5);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('tb-corrector-ch', size(AO.CH.DeviceList,1), 1));
AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'HCM'; 'Magnet';};
AO.CH.Monitor.ChannelNames = sirius_tb_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList);
AO.CH.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Monitor.Mode = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.Units        = 'Physics';
AO.CH.Monitor.HWUnits      = 'Ampere';
AO.CH.Monitor.PhysicsUnits = 'Radian';
AO.CH.Setpoint.MemberOf = {'MaCHineConfig'; 'Horizontal'; 'COR'; 'CH'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CH.Setpoint.ChannelNames = sirius_tb_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Setpoint.Mode = 'Simulator';
AO.CH.Setpoint.DataType = 'Scalar';
AO.CH.Setpoint.Units        = 'Physics';
AO.CH.Setpoint.HWUnits      = 'Ampere';
AO.CH.Setpoint.PhysicsUnits = 'Radian';
AO.CH.Setpoint.Range        = [-10 10];
AO.CH.Setpoint.Tolerance    = 0.00001;
AO.CH.Setpoint.DeltaRespMat = 0.0005; 

% CV
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'VCM'; 'Magnet'};
AO.CV.DeviceList  = getDeviceList(1,6);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('tb-corrector-cv', size(AO.CV.DeviceList,1), 1));
AO.CV.Monitor.MemberOf = {'Vertical'; 'COR'; 'CV'; 'VCM'; 'Magnet';};
AO.CV.Monitor.ChannelNames = sirius_tb_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList);
AO.CV.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Monitor.Mode = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.Units        = 'Physics';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'CV'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CV.Setpoint.ChannelNames = sirius_tb_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Setpoint.Mode = 'Simulator';
AO.CV.Setpoint.DataType = 'Scalar';
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
AO.BPMx.Monitor.ChannelNames = sirius_tb_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
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
AO.BPMy.Monitor.ChannelNames = sirius_tb_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
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
