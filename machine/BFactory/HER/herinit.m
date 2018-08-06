function herinit(OperationalMode)
%HERINIT


if nargin < 1
    OperationalMode = 1;
end

setao([]);


% Build Family Structure
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = [];
AO.BPMx.ElementList = [];
AO.BPMx.Status = [];

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_her(AO.BPMx.FamilyName, AO.BPMx.DeviceList, 0);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'um';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-6;
AO.BPMx.Monitor.Physics2HWParams = 1e+6;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status = [];

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_her(AO.BPMy.FamilyName, AO.BPMy.DeviceList, 0);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'um';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-6;
AO.BPMy.Monitor.Physics2HWParams = 1e+6;


AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = [];
AO.HCM.ElementList = [];
AO.HCM.Status = 1;

AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_her(AO.HCM.FamilyName, AO.HCM.DeviceList, 0);
%AO.HCM.Monitor.HW2PhysicsParams = 1;
%AO.HCM.Monitor.Physics2HWParams = 1;
AO.HCM.Monitor.HW2PhysicsFcn = @her2at;
AO.HCM.Monitor.Physics2HWFcn = @at2her;
AO.HCM.Monitor.HWUnits      = 'kGm';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_her(AO.HCM.FamilyName, AO.HCM.DeviceList, 1);
%AO.HCM.Setpoint.HW2PhysicsParams = 1;
%AO.HCM.Setpoint.Physics2HWParams = 1;
AO.HCM.Setpoint.HW2PhysicsFcn = @her2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2her;
AO.HCM.Setpoint.HWUnits      = 'kGm';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Units = 'Hardware';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = [];
AO.VCM.ElementList = [];
AO.VCM.Status = 1;

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_her(AO.VCM.FamilyName, AO.VCM.DeviceList, 0);
%AO.VCM.Monitor.HW2PhysicsParams = 1;
%AO.VCM.Monitor.Physics2HWParams = 1;
AO.VCM.Monitor.HW2PhysicsFcn = @her2at;
AO.VCM.Monitor.Physics2HWFcn = @at2her;
AO.VCM.Monitor.HWUnits      = 'kGm';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_her(AO.VCM.FamilyName, AO.VCM.DeviceList, 1);
%AO.VCM.Setpoint.HW2PhysicsParams = 1;
%AO.VCM.Setpoint.Physics2HWParams = 1;
AO.VCM.Setpoint.HW2PhysicsFcn = @her2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2her;
AO.VCM.Setpoint.HWUnits      = 'kGm';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Units = 'Hardware';


AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QF.DeviceList = [ones(40,1) (1:40)'];
AO.QF.ElementList = local_dev2elem('QF', AO.QF.DeviceList);
AO.QF.Status = ones(size(AO.QF.DeviceList,1),1);

AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_her(AO.QF.FamilyName, AO.QF.DeviceList, 0);
AO.QF.Monitor.HW2PhysicsFcn = @her2at;
AO.QF.Monitor.Physics2HWFcn = @at2her;
%AO.QF.Monitor.Physics2HWParams = (74.8377/2.2103);
%AO.QF.Monitor.HW2PhysicsParams = (2.2103/74.8377);    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_her(AO.QF.FamilyName, AO.QF.DeviceList, 1);
AO.QF.Setpoint.HW2PhysicsFcn = @her2at;
AO.QF.Setpoint.Physics2HWFcn = @at2her;
%AO.QF.Setpoint.HW2PhysicsParams = (2.2103/74.8377);    % K/Ampere:  HW2Physics*Amps=K
%AO.QF.Setpoint.Physics2HWParams = (74.8377/2.2103);
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';
AO.QF.Setpoint.RunFlagFcn = @getrunflagquad;


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = [ones(36,1) (1:36)'];
AO.QD.ElementList = local_dev2elem('QD', AO.QD.DeviceList);
AO.QD.Status = ones(size(AO.QD.DeviceList,1),1);

AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_her(AO.QD.FamilyName, AO.QD.DeviceList, 0);
AO.QD.Monitor.HW2PhysicsFcn = @her2at;
AO.QD.Monitor.Physics2HWFcn = @at2her;
%AO.QD.Monitor.HW2PhysicsParams = (-2.3366/77.3692);    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Monitor.Physics2HWParams = (77.3692/-2.3366);
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_her(AO.QD.FamilyName, AO.QF.DeviceList, 1);
AO.QD.Setpoint.HW2PhysicsFcn = @her2at;
AO.QD.Setpoint.Physics2HWFcn = @at2her;
%AO.QD.Setpoint.HW2PhysicsParams = (-2.3366/77.3692);    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Setpoint.Physics2HWParams = (77.3692/-2.3366);
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';
AO.QD.Setpoint.RunFlagFcn = @getrunflagquad;


AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = [ones(96,1) (1:96)'];
AO.SF.ElementList = local_dev2elem('SF', AO.SF.DeviceList);
AO.SF.Status = ones(size(AO.SF.DeviceList,1),1);

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_her(AO.SF.FamilyName, AO.SF.DeviceList, 0);
AO.SF.Monitor.HW2PhysicsFcn = @her2at;
AO.SF.Monitor.Physics2HWFcn = @at2her;
%AO.SF.Monitor.HW2PhysicsParams = 1;
%AO.SF.Monitor.Physics2HWParams = 1;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_her(AO.SF.FamilyName, AO.SF.DeviceList, 1);
AO.SF.Setpoint.HW2PhysicsFcn = @her2at;
AO.SF.Setpoint.Physics2HWFcn = @at2her;
%AO.SF.Setpoint.HW2PhysicsParams = 1;
%AO.SF.Setpoint.Physics2HWParams = 1;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = [ones(96,1) (1:96)'];
AO.SD.ElementList = local_dev2elem('SD', AO.SD.DeviceList);
AO.SD.Status = ones(size(AO.SD.DeviceList,1),1);

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_her(AO.SD.FamilyName, AO.SD.DeviceList, 0);
AO.SD.Monitor.HW2PhysicsFcn = @her2at;
AO.SD.Monitor.Physics2HWFcn = @at2her;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_her(AO.SD.FamilyName, AO.SD.DeviceList, 1);
AO.SD.Setpoint.HW2PhysicsFcn = @her2at;
AO.SD.Setpoint.Physics2HWFcn = @at2her;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';


% AO.SQSF.FamilyName = 'SQSF';
% AO.SQSF.MemberOf   = {'PlotFamily'; 'SKEWQUAD'; 'Magnet'};
% AO.SQSF.DeviceList = TwoPerSectorList;
% AO.SQSF.ElementList = local_dev2elem('SQSF', AO.SQSF.DeviceList);
% AO.SQSF.Status = 1;
% 
% AO.SQSF.Monitor.Mode = 'Simulator';
% AO.SQSF.Monitor.DataType = 'Scalar';
% AO.SQSF.Monitor.ChannelNames = getname_her(AO.SQSF.FamilyName, AO.SQSF.DeviceList, 0);
% AO.SQSF.Monitor.HW2PhysicsFcn = @her2at;
% AO.SQSF.Monitor.Physics2HWFcn = @at2her;
% %AO.SQSF.Monitor.HW2PhysicsParams = SQSFfac;
% %AO.SQSF.Monitor.Physics2HWParams = 1./SQSFfac;
% AO.SQSF.Monitor.Units = 'Hardware';
% AO.SQSF.Monitor.HWUnits = 'Ampere';
% AO.SQSF.Monitor.PhysicsUnits = '1/Meter^2';
% 
% AO.SQSF.Setpoint.MemberOf = {'MachineConfig';};
% AO.SQSF.Setpoint.Mode = 'Simulator';
% AO.SQSF.Setpoint.DataType = 'Scalar';
% AO.SQSF.Setpoint.ChannelNames = getname_her(AO.SQSF.FamilyName, AO.SQSF.DeviceList, 1);
% AO.SQSF.Setpoint.HW2PhysicsFcn = @her2at;
% AO.SQSF.Setpoint.Physics2HWFcn = @at2her;
% %AO.SQSF.Setpoint.HW2PhysicsParams = SQSFfac;
% %AO.SQSF.Setpoint.Physics2HWParams = 1./SQSFfac;
% AO.SQSF.Setpoint.Units = 'Hardware';
% AO.SQSF.Setpoint.HWUnits = 'Ampere';
% AO.SQSF.Setpoint.PhysicsUnits = '1/Meter^2';
% 
% 
% AO.SQSD.FamilyName = 'SQSD';
% AO.SQSD.MemberOf   = {'PlotFamily'; 'SKEWQUAD'; 'Magnet'};
% AO.SQSD.DeviceList = TwoPerSectorList;
% AO.SQSD.ElementList = local_dev2elem('SQSD', AO.SQSD.DeviceList);
% AO.SQSD.Status = 1;
%
% AO.SQSD.Monitor.Mode = 'Simulator';
% AO.SQSD.Monitor.DataType = 'Scalar';
% AO.SQSD.Monitor.ChannelNames = getname_her('SQSD', AO.SQSD.DeviceList, 0);
% AO.SQSD.Monitor.HW2PhysicsFcn = @her2at;
% AO.SQSD.Monitor.Physics2HWFcn = @at2her;
% %AO.SQSD.Monitor.HW2PhysicsParams = SQSDfac;
% %AO.SQSD.Monitor.Physics2HWParams = 1./SQSDfac;
% AO.SQSD.Monitor.Units = 'Hardware';
% AO.SQSD.Monitor.HWUnits = 'Ampere';
% AO.SQSD.Monitor.PhysicsUnits = '1/Meter^2';
% 
% AO.SQSD.Setpoint.MemberOf = {'MachineConfig';};
% AO.SQSD.Setpoint.Mode = 'Simulator';
% AO.SQSD.Setpoint.DataType = 'Scalar';
% AO.SQSD.Setpoint.ChannelNames = getname_her('SQSD', AO.SQSD.DeviceList, 1);
% AO.SQSD.Setpoint.HW2PhysicsFcn = @her2at;
% AO.SQSD.Setpoint.Physics2HWFcn = @at2her;
% %AO.SQSD.Setpoint.HW2PhysicsParams = SQSDfac;
% %AO.SQSD.Setpoint.Physics2HWParams = 1./SQSDfac;
% AO.SQSD.Setpoint.Units = 'Hardware';
% AO.SQSD.Setpoint.HWUnits = 'Ampere';
% AO.SQSD.Setpoint.PhysicsUnits = '1/Meter^2';
% 
% 
% AO.QFA.FamilyName = 'QFA';
% AO.QFA.MemberOf   = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'};
% AO.QFA.DeviceList = [];
% AO.QFA.Status = 1;
%
% AO.QFA.Monitor.Mode = 'Simulator';
% AO.QFA.Monitor.DataType = 'Scalar';
% AO.QFA.Monitor.ChannelNames = getname_her(AO.QFA.FamilyName, AO.QFA.DeviceList, 0);
% AO.QFA.Monitor.HW2PhysicsFcn = @her2at;
% AO.QFA.Monitor.Physics2HWFcn = @at2her;
% AO.QFA.Monitor.Units = 'Hardware';
% AO.QFA.Monitor.HWUnits = 'Ampere';
% AO.QFA.Monitor.PhysicsUnits = '1/Meter^2';
% 
% AO.QFA.Setpoint.MemberOf = {'MachineConfig';};
% AO.QFA.Setpoint.Mode = 'Simulator';
% AO.QFA.Setpoint.DataType = 'Scalar';
% AO.QFA.Setpoint.ChannelNames = getname_her(AO.QFA.FamilyName, AO.QFA.DeviceList, 1);
% AO.QFA.Setpoint.HW2PhysicsFcn = @her2at;
% AO.QFA.Setpoint.Physics2HWFcn = @at2her;
% AO.QFA.Setpoint.Units = 'Hardware';
% AO.QFA.Setpoint.HWUnits = 'Ampere';
% AO.QFA.Setpoint.PhysicsUnits = '1/Meter^2';


AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.Status = 1;
AO.BEND.DeviceList = [];
AO.BEND.ElementList = [];

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_her(AO.BEND.FamilyName, AO.BEND.DeviceList, 0);
AO.BEND.Monitor.HW2PhysicsFcn = @her2at;
AO.BEND.Monitor.Physics2HWFcn = @at2her;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'BEND'; 'Magnet'};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_her(AO.BEND.FamilyName, AO.BEND.DeviceList, 1);
AO.BEND.Setpoint.HW2PhysicsFcn = @her2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2her;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = [1];

AO.RF.Monitor.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = ''; 
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.Setpoint.DataType = 'Scalar';
%AO.RF.Setpoint.SpecialFunctionSet = 'setrf_her';
%AO.RF.Setpoint.SpecialFunctionGet = 'getrf_her';
AO.RF.Setpoint.ChannelNames = '';
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [0 Inf];
AO.RF.Setpoint.Toherance = 1;


AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Monitor.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_her';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT'};
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = [1];
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = '';
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Make the device and element lists
n = length(AO.BPMx.AT.ATIndex);
AO.BPMx.DeviceList = [ones(n,1) (1:n)'];
AO.BPMx.ElementList = (1:n)';
AO.BPMx.Status = ones(n,1);

n = length(AO.BPMy.AT.ATIndex);
AO.BPMy.DeviceList = [ones(n,1) (1:n)'];
AO.BPMy.ElementList = (1:n)';
AO.BPMy.Status = ones(n,1);

n = length(AO.HCM.AT.ATIndex);
AO.HCM.DeviceList = [ones(n,1) (1:n)'];
AO.HCM.ElementList = (1:n)';
AO.HCM.Status = ones(n,1);

n = length(AO.VCM.AT.ATIndex);
AO.VCM.DeviceList = [ones(n,1) (1:n)'];
AO.VCM.ElementList = (1:n)';
AO.VCM.Status = ones(n,1);

n = length(AO.BEND.AT.ATIndex);
AO.BEND.DeviceList = [ones(n,1) (1:n)'];
AO.BEND.ElementList = (1:n)';
AO.BEND.Status = ones(n,1);


% Save the AO so that family2dev will work
setao(AO);



%%%%%%%%%%%%%
% Get Range %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Range = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.VCM.Setpoint.Range = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.QF.Setpoint.Range = [local_minsp(AO.QF.FamilyName) local_maxsp(AO.QF.FamilyName)];
AO.QD.Setpoint.Range = [local_minsp(AO.QD.FamilyName) local_maxsp(AO.QD.FamilyName)];
AO.SF.Setpoint.Range = [local_minsp(AO.SF.FamilyName) local_maxsp(AO.SF.FamilyName)];
AO.SD.Setpoint.Range = [local_minsp(AO.SD.FamilyName) local_maxsp(AO.SD.FamilyName)];
% AO.QFA.Setpoint.Range = [local_minsp(AO.QFA.FamilyName) local_maxsp(AO.QFA.FamilyName)];
% AO.QDA.Setpoint.Range = [local_minsp(AO.QDA.FamilyName) local_maxsp(AO.QDA.FamilyName)];
% AO.SQSF.Setpoint.Range = [local_minsp(AO.SQSF.FamilyName, AO.SQSF.DeviceList) local_maxsp(AO.SQSF.FamilyName, AO.SQSF.DeviceList)];
% AO.SQSD.Setpoint.Range = [local_minsp(AO.SQSD.FamilyName, AO.SQSD.DeviceList) local_maxsp(AO.SQSD.FamilyName, AO.SQSD.DeviceList)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];


%%%%%%%%%%%%%
% Toherance %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Toherance = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Toherance = gettol(AO.VCM.FamilyName);
AO.QF.Setpoint.Toherance = gettol(AO.QF.FamilyName);
AO.QD.Setpoint.Toherance = gettol(AO.QD.FamilyName);
AO.SF.Setpoint.Toherance = gettol(AO.SF.FamilyName);
AO.SD.Setpoint.Toherance = gettol(AO.SD.FamilyName);
% AO.QFA.Setpoint.Toherance = gettol(AO.QF.FamilyName);
% AO.QDA.Setpoint.Toherance = gettol(AO.QD.FamilyName);
% AO.SQSF.Setpoint.Toherance = gettol(AO.SQSF.FamilyName);
% AO.SQSD.Setpoint.Toherance = gettol(AO.SQSD.FamilyName);
AO.BEND.Setpoint.Toherance = gettol(AO.BEND.FamilyName);


% Set response matrix kick size in hardware units
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .5e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .5e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat  = physics2hw('QF', 'Setpoint', .0001, AO.QF.DeviceList,  'NoEnergyScaling');
AO.QD.Setpoint.DeltaRespMat  = physics2hw('QD', 'Setpoint', .0001, AO.QD.DeviceList,  'NoEnergyScaling');
AO.SF.Setpoint.DeltaRespMat  = physics2hw('SF', 'Setpoint', .001,  AO.SF.DeviceList,  'NoEnergyScaling');
AO.SD.Setpoint.DeltaRespMat  = physics2hw('SD', 'Setpoint', .001,  AO.SD.DeviceList,  'NoEnergyScaling');

setao(AO);



function ElemList = local_dev2elem(Family, DeviceList)
ElemList = ones(size(DeviceList,1),1);


function [Amps] = local_minsp(Family, List);
% function local_minsp = local_minsp(Family, List {entire list});
%
%   Inputs:  Family must be a string of capitols (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is minimum strength for that family


% Input checking
if nargin < 1 | nargin > 2
    error('local_minsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family, 0);
end


if isempty(List)
    error('local_minsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_minsp: List must be 1 or 2 columns only');
end

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'QF')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'QD')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SF')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SD')        
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SQSF')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SQSD')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = -Inf;
    else
        fprintf('   Min setpoint unknown for %s family, hence set to -Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List);
% function Amps = local_maxsp(Family, List {entire list});
%
%   Inputs:  Family must be a string of capitols (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is maximum strength for that family


% Input checking
if nargin < 1 | nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
end

if isempty(List)
    error('local_maxsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_maxsp: List must be 1 or 2 columns only');
end

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'QF')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'QD')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SF')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SD')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SQSF')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SQSD')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = Inf;
    else
        fprintf('   Max setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  toherance on the SP-AM for that family
%
%  Note: the real toherance is in gplink
%

% Input checking
if nargin < 1 | nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
end

if isempty(List)
    error('local_maxsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_maxsp: List must be 1 or 2 columns only');
end


if strcmp(Family,'HCM')
    tol = 0.2;
elseif strcmp(Family,'VCM')
    tol = 0.2;
elseif strcmp(Family,'QF')
    tol = 0.25;
elseif strcmp(Family,'QD')
    tol = 0.25;
elseif strcmp(Family,'SQSF')
    tol = 0.25;
elseif strcmp(Family,'SQSD')
    tol = 0.25;
elseif strcmp(Family,'SF')
    tol = 1.0;
elseif strcmp(Family,'SD')
    tol = 1.0;
elseif strcmp(Family,'BEND')
    tol = 1.0;
else
    fprintf('   Toherance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end

tol = tol * ones(size(List,1),1);
