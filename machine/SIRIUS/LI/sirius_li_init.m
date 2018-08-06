function sirius_li_init(OperationalMode)
%SIRIUS_TB_INIT - MML initialization file for the TB at sirius
% 
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);

% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));

AD.Directory.ExcDataDir  = '/home/fac_files/siriusdb/excitation_curves';

%AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];

setad(AD);


% BENDS
AO.Spect.FamilyName  = 'Spect';
AO.Spect.MemberOf    = {'PlotFamily'; 'Spect'; 'BEND'; 'Magnet';};
AO.Spect.DeviceList  = getDeviceList(1,1);
AO.Spect.ElementList = (1:size(AO.Spect.DeviceList,1))';
AO.Spect.Status      = ones(size(AO.Spect.DeviceList,1),1);
AO.Spect.Position    = [];
AO.Spect.ExcitationCurves = sirius_getexcdata(repmat('lima-spect', size(AO.Spect.DeviceList,1), 1)); 
AO.Spect.Monitor.MemberOf = {};
AO.Spect.Monitor.Mode = 'Simulator';
AO.Spect.Monitor.DataType = 'Scalar';
AO.Spect.Monitor.ChannelNames = sirius_li_getname(AO.Spect.FamilyName, 'Monitor', AO.Spect.DeviceList);
AO.Spect.Monitor.HW2PhysicsFcn = @bend2gev;
AO.Spect.Monitor.Physics2HWFcn = @gev2bend;
AO.Spect.Monitor.Units        = 'Hardware';
AO.Spect.Monitor.HWUnits      = 'Ampere';
AO.Spect.Monitor.PhysicsUnits = 'GeV';
AO.Spect.Setpoint.MemberOf = {'MachineConfig';};
AO.Spect.Setpoint.Mode = 'Simulator';
AO.Spect.Setpoint.DataType = 'Scalar';
AO.Spect.Setpoint.ChannelNames = sirius_li_getname(AO.Spect.FamilyName, 'Setpoint', AO.Spect.DeviceList);
AO.Spect.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.Spect.Setpoint.Physics2HWFcn = @gev2bend;
AO.Spect.Setpoint.Units        = 'Hardware';
AO.Spect.Setpoint.HWUnits      = 'Ampere';
AO.Spect.Setpoint.PhysicsUnits = 'GeV';
AO.Spect.Setpoint.Range        = [0 300];
AO.Spect.Setpoint.Tolerance    = .1;
AO.Spect.Setpoint.DeltaRespMat = .01;

AO.QF2.FamilyName  = 'QF2';
AO.QF2.MemberOf    = {'PlotFamily'; 'QF2'; 'QUAD'; 'Magnet';};
AO.QF2.DeviceList  = getDeviceList(1,2);
AO.QF2.ElementList = (1:size(AO.QF2.DeviceList,1))';
AO.QF2.Status      = ones(size(AO.QF2.DeviceList,1),1);
AO.QF2.Position    = [];
AO.QF2.ExcitationCurves = sirius_getexcdata(repmat('lima-q', size(AO.QF2.DeviceList,1), 1));
AO.QF2.Monitor.MemberOf = {};
AO.QF2.Monitor.Mode = 'Simulator';
AO.QF2.Monitor.DataType = 'Scalar';
AO.QF2.Monitor.ChannelNames = sirius_li_getname(AO.QF2.FamilyName, 'Monitor', AO.QF2.DeviceList);
AO.QF2.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF2.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QF2.Monitor.Units        = 'Hardware';
AO.QF2.Monitor.HWUnits      = 'Ampere';
AO.QF2.Monitor.PhysicsUnits = 'meter^-2';
AO.QF2.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF2.Setpoint.Mode          = 'Simulator';
AO.QF2.Setpoint.DataType      = 'Scalar';
AO.QF2.Setpoint.ChannelNames = sirius_li_getname(AO.QF2.FamilyName, 'Setpoint', AO.QF2.DeviceList);
AO.QF2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF2.Setpoint.Units         = 'Hardware';
AO.QF2.Setpoint.HWUnits       = 'Ampere';
AO.QF2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF2.Setpoint.Range         = [0 225];
AO.QF2.Setpoint.Tolerance     = 0.2;
AO.QF2.Setpoint.DeltaRespMat  = 0.5; 

AO.QD2.FamilyName  = 'QD2';
AO.QD2.MemberOf    = {'PlotFamily'; 'QD2'; 'QUAD'; 'Magnet';};
AO.QD2.DeviceList  = getDeviceList(1,1);
AO.QD2.ElementList = (1:size(AO.QD2.DeviceList,1))';
AO.QD2.Status      = ones(size(AO.QD2.DeviceList,1),1);
AO.QD2.Position    = [];
AO.QD2.ExcitationCurves = sirius_getexcdata(repmat('lima-q', size(AO.QD2.DeviceList,1), 1));
AO.QD2.Monitor.MemberOf = {};
AO.QD2.Monitor.Mode = 'Simulator';
AO.QD2.Monitor.DataType = 'Scalar';
AO.QD2.Monitor.ChannelNames = sirius_li_getname(AO.QD2.FamilyName, 'Monitor', AO.QD2.DeviceList);
AO.QD2.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD2.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QD2.Monitor.Units        = 'Hardware';
AO.QD2.Monitor.HWUnits      = 'Ampere';
AO.QD2.Monitor.PhysicsUnits = 'meter^-2';
AO.QD2.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD2.Setpoint.Mode          = 'Simulator';
AO.QD2.Setpoint.DataType      = 'Scalar';
AO.QD2.Setpoint.ChannelNames = sirius_li_getname(AO.QD2.FamilyName, 'Setpoint', AO.QD2.DeviceList);
AO.QD2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD2.Setpoint.Units         = 'Hardware';
AO.QD2.Setpoint.HWUnits       = 'Ampere';
AO.QD2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD2.Setpoint.Range         = [0 225];
AO.QD2.Setpoint.Tolerance     = 0.2;
AO.QD2.Setpoint.DeltaRespMat  = 0.5; 

AO.QF3.FamilyName  = 'QF3';
AO.QF3.MemberOf    = {'PlotFamily'; 'QF3'; 'QUAD'; 'Magnet';};
AO.QF3.DeviceList  = getDeviceList(1,1);
AO.QF3.ElementList = (1:size(AO.QF3.DeviceList,1))';
AO.QF3.Status      = ones(size(AO.QF3.DeviceList,1),1);
AO.QF3.Position    = [];
AO.QF3.ExcitationCurves = sirius_getexcdata(repmat('lima-q', size(AO.QF3.DeviceList,1), 1));
AO.QF3.Monitor.MemberOf = {};
AO.QF3.Monitor.Mode = 'Simulator';
AO.QF3.Monitor.DataType = 'Scalar';
AO.QF3.Monitor.ChannelNames = sirius_li_getname(AO.QF3.FamilyName, 'Monitor', AO.QF3.DeviceList);
AO.QF3.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Monitor.Units        = 'Hardware';
AO.QF3.Monitor.HWUnits      = 'Ampere';
AO.QF3.Monitor.PhysicsUnits = 'meter^-2';
AO.QF3.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF3.Setpoint.Mode          = 'Simulator';
AO.QF3.Setpoint.DataType      = 'Scalar';
AO.QF3.Setpoint.ChannelNames = sirius_li_getname(AO.QF3.FamilyName, 'Setpoint', AO.QF3.DeviceList);
AO.QF3.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF3.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF3.Setpoint.Units         = 'Hardware';
AO.QF3.Setpoint.HWUnits       = 'Ampere';
AO.QF3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF3.Setpoint.Range         = [0 225];
AO.QF3.Setpoint.Tolerance     = 0.2;
AO.QF3.Setpoint.DeltaRespMat  = 0.5; 

AO.QD1.FamilyName  = 'QD1';
AO.QD1.MemberOf    = {'PlotFamily'; 'QD1'; 'QUAD'; 'Magnet';};
AO.QD1.DeviceList  = getDeviceList(1,1);
AO.QD1.ElementList = (1:size(AO.QD1.DeviceList,1))';
AO.QD1.Status      = ones(size(AO.QD1.DeviceList,1),1);
AO.QD1.Position    = [];
AO.QD1.ExcitationCurves = sirius_getexcdata(repmat('lima-q', size(AO.QD1.DeviceList,1), 1));
AO.QD1.Monitor.MemberOf = {};
AO.QD1.Monitor.Mode = 'Simulator';
AO.QD1.Monitor.DataType = 'Scalar';
AO.QD1.Monitor.ChannelNames = sirius_li_getname(AO.QD1.FamilyName, 'Monitor', AO.QD1.DeviceList);
AO.QD1.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD1.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QD1.Monitor.Units        = 'Hardware';
AO.QD1.Monitor.HWUnits      = 'Ampere';
AO.QD1.Monitor.PhysicsUnits = 'meter^-2';
AO.QD1.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD1.Setpoint.Mode          = 'Simulator';
AO.QD1.Setpoint.DataType      = 'Scalar';
AO.QD1.Setpoint.ChannelNames = sirius_li_getname(AO.QD1.FamilyName, 'Setpoint', AO.QD1.DeviceList);
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
AO.QF1.ExcitationCurves = sirius_getexcdata(repmat('lima-q', size(AO.QF1.DeviceList,1), 1));
AO.QF1.Monitor.MemberOf = {};
AO.QF1.Monitor.Mode = 'Simulator';
AO.QF1.Monitor.DataType = 'Scalar';
AO.QF1.Monitor.ChannelNames = sirius_li_getname(AO.QF1.FamilyName, 'Monitor', AO.QF1.DeviceList);
AO.QF1.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.QF1.Monitor.Units        = 'Hardware';
AO.QF1.Monitor.HWUnits      = 'Ampere';
AO.QF1.Monitor.PhysicsUnits = 'meter^-2';
AO.QF1.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF1.Setpoint.Mode          = 'Simulator';
AO.QF1.Setpoint.DataType      = 'Scalar';
AO.QF1.Setpoint.ChannelNames = sirius_li_getname(AO.QF1.FamilyName, 'Setpoint', AO.QF1.DeviceList);
AO.QF1.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF1.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF1.Setpoint.Units         = 'Hardware';
AO.QF1.Setpoint.HWUnits       = 'Ampere';
AO.QF1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF1.Setpoint.Range         = [0 225];
AO.QF1.Setpoint.Tolerance     = 0.2;
AO.QF1.Setpoint.DeltaRespMat  = 0.5; 


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
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('lima-ch', size(AO.CH.DeviceList,1), 1));
AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'HCM'; 'Magnet';};
AO.CH.Monitor.ChannelNames = sirius_li_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList);
AO.CH.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Monitor.Mode = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.Units        = 'Physics';
AO.CH.Monitor.HWUnits      = 'Ampere';
AO.CH.Monitor.PhysicsUnits = 'Radian';
AO.CH.Setpoint.MemberOf = {'MaCHineConfig'; 'Horizontal'; 'COR'; 'CH'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CH.Setpoint.ChannelNames = sirius_li_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
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
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('lima-cv', size(AO.CV.DeviceList,1), 1));
AO.CV.Monitor.MemberOf = {'Vertical'; 'COR'; 'CV'; 'VCM'; 'Magnet';};
AO.CV.Monitor.ChannelNames = sirius_li_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList);
AO.CV.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Monitor.Mode = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.Units        = 'Physics';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'CV'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CV.Setpoint.ChannelNames = sirius_li_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
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
AO.BPMx.Monitor.ChannelNames = sirius_li_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
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
AO.BPMy.Monitor.ChannelNames = sirius_li_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
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
