function alsuinit(OperationalMode)
%ALSUINIT - MML setup file for ALS-U


if nargin < 1
    % Default operational mode: User Mode
    OperationalMode = 1;
end


% Clear previous AcceleratorObjects
setao([]);   
setad([]);   

% Build the device lists
for Sector = 1:12
    TwoPerSectorList(2*(Sector-1)+1:2*Sector,:) = [
        Sector 1;
        Sector 2;];
    ThreePerSectorList(3*(Sector-1)+1:3*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 3;];
    FourPerSectorList(4*(Sector-1)+1:4*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];
    SixPerSectorList(6*(Sector-1)+1:6*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;];
end

alsulattice;


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = ThreePerSectorList;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status = ones(size(AO.BPMx.DeviceList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_alsu('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status = ones(size(AO.BPMy.DeviceList,1),1);

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_alsu('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;



% Correctors
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = ThreePerSectorList;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status = ones(size(AO.HCM.DeviceList,1),1);


AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_alsu('HCM', 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsParams = 1e-3;
AO.HCM.Monitor.Physics2HWParams = 1/AO.HCM.Monitor.HW2PhysicsParams;
%AO.HCM.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.HCM.Monitor.Physics2HWFcn = @at2solaris;
AO.HCM.Monitor.HWUnits      = 'mrad'; 
AO.HCM.Monitor.PhysicsUnits = 'rad';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_alsu('HCM', 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsParams = AO.HCM.Monitor.HW2PhysicsParams;
AO.HCM.Setpoint.Physics2HWParams = AO.HCM.Monitor.Physics2HWParams;
%AO.HCM.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.HCM.Setpoint.Physics2HWFcn = @at2solaris;
AO.HCM.Setpoint.HWUnits      = 'mrad'; 
AO.HCM.Setpoint.PhysicsUnits = 'rad';
AO.HCM.Setpoint.Units = 'Hardware';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = ThreePerSectorList;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status = ones(size(AO.VCM.DeviceList,1),1);

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_alsu('VCM', 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsParams = 1e-3;
AO.VCM.Monitor.Physics2HWParams = 1./AO.VCM.Monitor.HW2PhysicsParams;
%AO.VCM.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.VCM.Monitor.Physics2HWFcn = @at2solaris;
AO.VCM.Monitor.HWUnits      = 'mrad';
AO.VCM.Monitor.PhysicsUnits = 'rad';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_alsu('VCM', 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsParams = AO.VCM.Monitor.HW2PhysicsParams;
AO.VCM.Setpoint.Physics2HWParams = AO.VCM.Monitor.Physics2HWParams;
%AO.VCM.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.VCM.Setpoint.Physics2HWFcn = @at2solaris;
AO.VCM.Setpoint.HWUnits      = 'mrad';
AO.VCM.Setpoint.PhysicsUnits = 'rad';
AO.VCM.Setpoint.Units = 'Hardware';



% Quadrupoles
AO.QFI.FamilyName = 'QFI';
AO.QFI.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QFI.DeviceList = FourPerSectorList;
AO.QFI.ElementList = (1:size(AO.QFI.DeviceList,1))';
AO.QFI.Status = ones(size(AO.QFI.DeviceList,1),1);

AO.QFI.Monitor.Mode = 'Simulator';
AO.QFI.Monitor.DataType = 'Scalar';
AO.QFI.Monitor.ChannelNames = getname_alsu('QF', 'Monitor', AO.QFI.DeviceList);
AO.QFI.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.QFI.Monitor.Physics2HWParams = 1 ./ AO.QFI.Monitor.HW2PhysicsParams;
%AO.QFI.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.QFI.Monitor.Physics2HWFcn = @at2solaris;
AO.QFI.Monitor.Units = 'Hardware';
AO.QFI.Monitor.HWUnits      = '1/Meter^2';
AO.QFI.Monitor.PhysicsUnits = '1/Meter^2';

AO.QFI.Setpoint.MemberOf = {'MachineConfig';};
AO.QFI.Setpoint.Mode = 'Simulator';
AO.QFI.Setpoint.DataType = 'Scalar';
AO.QFI.Setpoint.ChannelNames = getname_alsu('QF', 'Setpoint', AO.QFI.DeviceList);
AO.QFI.Setpoint.HW2PhysicsParams = AO.QFI.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QFI.Setpoint.Physics2HWParams = AO.QFI.Monitor.Physics2HWParams;
%AO.QFI.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.QFI.Setpoint.Physics2HWFcn = @at2solaris;
AO.QFI.Setpoint.Units = 'Hardware';
AO.QFI.Setpoint.HWUnits      = '1/Meter^2';
AO.QFI.Setpoint.PhysicsUnits = '1/Meter^2';


AO.QFO.FamilyName = 'QFO';
AO.QFO.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QFO.DeviceList = SixPerSectorList;
AO.QFO.ElementList = (1:size(AO.QFO.DeviceList,1))';
AO.QFO.Status = ones(size(AO.QFO.DeviceList,1),1);

AO.QFO.Monitor.Mode = 'Simulator';
AO.QFO.Monitor.DataType = 'Scalar';
AO.QFO.Monitor.ChannelNames = getname_alsu('QF', 'Monitor', AO.QFO.DeviceList);
AO.QFO.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.QFO.Monitor.Physics2HWParams = 1 ./ AO.QFO.Monitor.HW2PhysicsParams;
%AO.QFO.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.QFO.Monitor.Physics2HWFcn = @at2solaris;
AO.QFO.Monitor.Units = 'Hardware';
AO.QFO.Monitor.HWUnits      = '1/Meter^2';
AO.QFO.Monitor.PhysicsUnits = '1/Meter^2';

AO.QFO.Setpoint.MemberOf = {'MachineConfig';};
AO.QFO.Setpoint.Mode = 'Simulator';
AO.QFO.Setpoint.DataType = 'Scalar';
AO.QFO.Setpoint.ChannelNames = getname_alsu('QF', 'Setpoint', AO.QFO.DeviceList);
AO.QFO.Setpoint.HW2PhysicsParams = AO.QFO.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QFO.Setpoint.Physics2HWParams = AO.QFO.Monitor.Physics2HWParams;
%AO.QFO.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.QFO.Setpoint.Physics2HWFcn = @at2solaris;
AO.QFO.Setpoint.Units = 'Hardware';
AO.QFO.Setpoint.HWUnits      = '1/Meter^2';
AO.QFO.Setpoint.PhysicsUnits = '1/Meter^2';


% Sextupoles
AO.SFI.FamilyName = 'SFI';
AO.SFI.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SFI'; 'SEXT'; 'Magnet'};
AO.SFI.DeviceList = FourPerSectorList;
AO.SFI.ElementList = (1:size(AO.SFI.DeviceList,1))';
AO.SFI.Status = ones(size(AO.SFI.DeviceList,1),1);

AO.SFI.Monitor.Mode = 'Simulator';
AO.SFI.Monitor.DataType = 'Scalar';
AO.SFI.Monitor.ChannelNames = getname_alsu('SFI', 'Monitor', AO.SFI.DeviceList);
AO.SFI.Monitor.HW2PhysicsParams = 1;
AO.SFI.Monitor.Physics2HWParams = 1 ./ AO.SFI.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.SFI.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.SFI.Monitor.Physics2HWFcn = @at2solaris;
AO.SFI.Monitor.Units = 'Hardware';
AO.SFI.Monitor.HWUnits = '1/Meter^3';
AO.SFI.Monitor.PhysicsUnits = '1/Meter^3';

AO.SFI.Setpoint.MemberOf = {'MachineConfig';};
AO.SFI.Setpoint.Mode = 'Simulator';
AO.SFI.Setpoint.DataType = 'Scalar';
AO.SFI.Setpoint.ChannelNames = getname_alsu('SFI', 'Setpoint', AO.SFI.DeviceList);
AO.SFI.Setpoint.HW2PhysicsParams = AO.SFI.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SFI.Setpoint.Physics2HWParams = AO.SFI.Monitor.Physics2HWParams;
%AO.SFI.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.SFI.Setpoint.Physics2HWFcn = @at2solaris;
AO.SFI.Setpoint.Units = 'Hardware';
AO.SFI.Setpoint.HWUnits = '1/Meter^3';
AO.SFI.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SFO.FamilyName = 'SFO';
AO.SFO.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SFO.DeviceList = FourPerSectorList;
AO.SFO.ElementList = (1:size(AO.SFO.DeviceList,1))';
AO.SFO.Status = ones(size(AO.SFO.DeviceList,1),1);

AO.SFO.Monitor.Mode = 'Simulator';
AO.SFO.Monitor.DataType = 'Scalar';
AO.SFO.Monitor.ChannelNames = getname_alsu('SFO', 'Monitor', AO.SFO.DeviceList);
AO.SFO.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.SFO.Monitor.Physics2HWParams = 1 ./ AO.SFO.Monitor.HW2PhysicsParams;
%AO.SFO.Monitor.HW2PhysicsFcn = @solaris2at;
%AO.SFO.Monitor.Physics2HWFcn = @at2solaris;
AO.SFO.Monitor.Units = 'Hardware';
AO.SFO.Monitor.HWUnits = '1/Meter^3';
AO.SFO.Monitor.PhysicsUnits = '1/Meter^3';

AO.SFO.Setpoint.MemberOf = {'MachineConfig';};
AO.SFO.Setpoint.Mode = 'Simulator';
AO.SFO.Setpoint.DataType = 'Scalar';
AO.SFO.Setpoint.ChannelNames = getname_alsu('SFO', 'Setpoint', AO.SFO.DeviceList);
AO.SFO.Setpoint.HW2PhysicsParams = AO.SFO.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SFO.Setpoint.Physics2HWParams = AO.SFO.Monitor.Physics2HWParams;
%AO.SFO.Setpoint.HW2PhysicsFcn = @solaris2at;
%AO.SFO.Setpoint.Physics2HWFcn = @at2solaris;
AO.SFO.Setpoint.Units = 'Hardware';
AO.SFO.Setpoint.HWUnits = '1/Meter^3';
AO.SFO.Setpoint.PhysicsUnits = '1/Meter^3';



% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = TwoPerSectorList;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_alsu('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @solaris2at;
AO.BEND.Monitor.Physics2HWFcn = @at2solaris;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Radian';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_alsu('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @solaris2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2solaris;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Radian';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1;];
AO.RF.ElementList = [1;];

AO.RF.Monitor.Mode = 'Simulator'; 
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_alsu('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator'; 
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = getname_alsu('RF', 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [0 125];


% Tune
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];

AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
%AO.TUNE.Monitor.ChannelNames = getname_alsu('TUNE', 'Monitor', AO.RF.DeviceList);
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_solaris';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


% DCCT
AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {};
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = getname_alsu('DCCT', 'Monitor', AO.DCCT.DeviceList);
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Range (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Range  = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.VCM.Setpoint.Range  = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.QFI.Setpoint.Range  = [local_minsp(AO.QFI.FamilyName)  local_maxsp(AO.QFI.FamilyName)];
AO.QFO.Setpoint.Range  = [local_minsp(AO.QFO.FamilyName)  local_maxsp(AO.QFO.FamilyName)];
AO.SFI.Setpoint.Range  = [local_minsp(AO.SFI.FamilyName)  local_maxsp(AO.SFI.FamilyName)];
AO.SFO.Setpoint.Range  = [local_minsp(AO.SFO.FamilyName)  local_maxsp(AO.SFO.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.RF.Setpoint.Range   = [local_minsp(AO.RF.FamilyName)   local_maxsp(AO.RF.FamilyName)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName);
AO.QFI.Setpoint.Tolerance   = gettol(AO.QFI.FamilyName);
AO.QFO.Setpoint.Tolerance   = gettol(AO.QFO.FamilyName);
AO.SFI.Setpoint.Tolerance   = gettol(AO.SFI.FamilyName);
AO.SFO.Setpoint.Tolerance   = gettol(AO.SFO.FamilyName);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName);
AO.RF.Setpoint.Tolerance   = gettol(AO.RF.FamilyName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response matrix kick size (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', 4e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', 4e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QFI.Setpoint.DeltaRespMat  = .001;
AO.QFO.Setpoint.DeltaRespMat  = .001;
AO.SFI.Setpoint.DeltaRespMat  = .1;
AO.SFO.Setpoint.DeltaRespMat  = .1;

setao(AO);




function [Amps] = local_minsp(Family, List)
%   local_minsp = local_minsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is minimum strength for that family


% Input checking
if nargin < 1 || nargin > 2
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
        Amps(i,1) = -10;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -10;
    elseif strcmp(Family,'QFI')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'QFO')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SFI')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SFO')        
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 0;
    else
        fprintf('   Min setpoint unknown for %s family, hence set to -Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)
%   Amps = local_maxsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is maximum strength for that family


% Input checking
if nargin < 1 || nargin > 2
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
        Amps(i,1) = 10;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 10;
    elseif strcmp(Family,'QFI')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'QFO')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SFI')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SFO')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 110e6;  % ~100MHz nominal
    else
        fprintf('   Max setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  tolerance on the SP-AM for that family
%
%  Note: the real tolerance is in gplink
%

% Input checking
if nargin < 1 || nargin > 2
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
    tol = 0.25;
elseif strcmp(Family,'VCM')
    tol = 0.15;
elseif strcmp(Family,'QFI')
    tol = 1.0;
elseif strcmp(Family,'QFO')
    tol = 2.5;
elseif strcmp(Family,'SFI')
    tol = 0.15;
elseif strcmp(Family,'SFO')
    tol = 0.1;
elseif strcmp(Family,'BEND')
    tol = 0.5;
elseif strcmp(Family,'RF')
    tol = 0.5;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end

tol = tol * ones(size(List,1),1);