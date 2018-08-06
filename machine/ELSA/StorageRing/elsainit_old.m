function elsainit(OperationalMode)
%ELSAINIT - MML setup file for ELSA


if nargin < 1
    % Default operational mode: User Mode
    OperationalMode = 1;
end


% Clear previous AcceleratorObjects
setao([]);   
setad([]);   


[BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, BEND] = elsalattice;


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = BPMx.DeviceList;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status = ones(size(AO.BPMx.DeviceList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_elsa('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList = BPMy.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status = ones(size(AO.BPMy.DeviceList,1),1);

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_elsa('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;



% Correctors
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = HCM.DeviceList;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status = ones(size(AO.HCM.DeviceList,1),1);


AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_elsa('HCM', 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsParams = 1e-3;
AO.HCM.Monitor.Physics2HWParams = 1/AO.HCM.Monitor.HW2PhysicsParams;
%AO.HCM.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.HCM.Monitor.Physics2HWFcn = @at2elsa;
AO.HCM.Monitor.HWUnits      = 'mrad'; 
AO.HCM.Monitor.PhysicsUnits = 'rad';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_elsa('HCM', 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsParams = AO.HCM.Monitor.HW2PhysicsParams;
AO.HCM.Setpoint.Physics2HWParams = AO.HCM.Monitor.Physics2HWParams;
%AO.HCM.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.HCM.Setpoint.Physics2HWFcn = @at2elsa;
AO.HCM.Setpoint.HWUnits      = 'mrad'; 
AO.HCM.Setpoint.PhysicsUnits = 'rad';
AO.HCM.Setpoint.Units = 'Hardware';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = VCM.DeviceList;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status = ones(size(AO.VCM.DeviceList,1),1);

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_elsa('VCM', 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsParams = 1e-3;
AO.VCM.Monitor.Physics2HWParams = 1./AO.VCM.Monitor.HW2PhysicsParams;
%AO.VCM.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.VCM.Monitor.Physics2HWFcn = @at2elsa;
AO.VCM.Monitor.HWUnits      = 'mrad';
AO.VCM.Monitor.PhysicsUnits = 'rad';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_elsa('VCM', 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsParams = AO.VCM.Monitor.HW2PhysicsParams;
AO.VCM.Setpoint.Physics2HWParams = AO.VCM.Monitor.Physics2HWParams;
%AO.VCM.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.VCM.Setpoint.Physics2HWFcn = @at2elsa;
AO.VCM.Setpoint.HWUnits      = 'mrad';
AO.VCM.Setpoint.PhysicsUnits = 'rad';
AO.VCM.Setpoint.Units = 'Hardware';



% Quadrupoles
AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QF.DeviceList = QF.DeviceList;
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status = ones(size(AO.QF.DeviceList,1),1);

AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_elsa('QF', 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Monitor.Physics2HWParams = 1 ./ AO.QF.Monitor.HW2PhysicsParams;
%AO.QF.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.QF.Monitor.Physics2HWFcn = @at2elsa;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = '1/Meter^2';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_elsa('QF', 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsParams = AO.QF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Setpoint.Physics2HWParams = AO.QF.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2elsa;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = '1/Meter^2';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = QD.DeviceList;
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status = ones(size(AO.QD.DeviceList,1),1);

AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_elsa('QD', 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.QD.Monitor.Physics2HWParams = 1 ./ AO.QD.Monitor.HW2PhysicsParams;
%AO.QD.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.QD.Monitor.Physics2HWFcn = @at2elsa;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = '1/Meter^2';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_elsa('QD', 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsParams = AO.QD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QD.Setpoint.Physics2HWParams = AO.QD.Monitor.Physics2HWParams;
%AO.QD.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.QD.Setpoint.Physics2HWFcn = @at2elsa;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = '1/Meter^2';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';


% Sextupoles
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = SF.DeviceList;
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status = ones(size(AO.SF.DeviceList,1),1);

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_elsa('SF', 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsParams = 1;
AO.SF.Monitor.Physics2HWParams = 1 ./ AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.SF.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.SF.Monitor.Physics2HWFcn = @at2elsa;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits = '1/Meter^3';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_elsa('SF', 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsParams = AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SF.Setpoint.Physics2HWParams = AO.SF.Monitor.Physics2HWParams;
%AO.SF.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.SF.Setpoint.Physics2HWFcn = @at2elsa;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits = '1/Meter^3';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = SD.DeviceList;
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status = ones(size(AO.SD.DeviceList,1),1);

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_elsa('SD', 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsParams = 1;    % K/Ampere:  HW2Physics*Amps=K
AO.SD.Monitor.Physics2HWParams = 1 ./ AO.SD.Monitor.HW2PhysicsParams;
%AO.SD.Monitor.HW2PhysicsFcn = @elsa2at;
%AO.SD.Monitor.Physics2HWFcn = @at2elsa;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits = '1/Meter^3';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_elsa('SD', 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsParams = AO.SD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SD.Setpoint.Physics2HWParams = AO.SD.Monitor.Physics2HWParams;
%AO.SD.Setpoint.HW2PhysicsFcn = @elsa2at;
%AO.SD.Setpoint.Physics2HWFcn = @at2elsa;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits = '1/Meter^3';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';



% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = BEND.DeviceList;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_elsa('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @elsa2at;
AO.BEND.Monitor.Physics2HWFcn = @at2elsa;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Radian';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_elsa('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @elsa2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2elsa;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Radian';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1;1 2];
AO.RF.ElementList = [1; 1];

AO.RF.Monitor.Mode = 'Simulator'; 
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_elsa('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator'; 
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = getname_elsa('RF', 'Setpoint', AO.RF.DeviceList);
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
%AO.TUNE.Monitor.ChannelNames = getname_elsa('TUNE', 'Monitor', AO.RF.DeviceList);
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_elsa';
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
AO.DCCT.Monitor.ChannelNames = getname_elsa('DCCT', 'Monitor', AO.DCCT.DeviceList);
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
AO.QF.Setpoint.Range   = [local_minsp(AO.QF.FamilyName)   local_maxsp(AO.QF.FamilyName)];
AO.QD.Setpoint.Range   = [local_minsp(AO.QD.FamilyName)   local_maxsp(AO.QD.FamilyName)];
AO.SF.Setpoint.Range   = [local_minsp(AO.SF.FamilyName)   local_maxsp(AO.SF.FamilyName)];
AO.SD.Setpoint.Range   = [local_minsp(AO.SD.FamilyName)   local_maxsp(AO.SD.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.RF.Setpoint.Range   = [local_minsp(AO.RF.FamilyName)   local_maxsp(AO.RF.FamilyName)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName);
AO.RF.Setpoint.Tolerance   = gettol(AO.RF.FamilyName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response matrix kick size (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', 4e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', 4e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat  = .001;
AO.QD.Setpoint.DeltaRespMat  = .001;
AO.SF.Setpoint.DeltaRespMat  = .1;
AO.SD.Setpoint.DeltaRespMat  = .1;

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
    elseif strcmp(Family,'QF')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'QD')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SF')
        Amps(i,1) = -Inf;
    elseif strcmp(Family,'SD')        
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
    elseif strcmp(Family,'QF')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'QD')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SF')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'SD')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = Inf;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 150e6;  % 150Mhz
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
elseif strcmp(Family,'QF')
    tol = 1.0;
elseif strcmp(Family,'QD')
    tol = 2.5;
elseif strcmp(Family,'SF')
    tol = 0.15;
elseif strcmp(Family,'SD')
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