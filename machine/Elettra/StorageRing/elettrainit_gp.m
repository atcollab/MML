function elettrainit(OperationalMode)
%ELETTRAINIT - MML initialization function for Elettra


% To do:
% 1. Something isn't right with the AT lattice.  It's close but findorbit6 and findm66 are not working properly.  
%
%    Are these correct?
%      L0 = 259.200000 m   
%      RF = 499.654097 MHz  (oddly similar to ALS)
% 1. All families need channel names (getname_elettra) or whatever tango uses
% 2. elettra2at and at2elettra need work!
% 4. If you want to work at different energies, bend2gev and gev2bend need work.
% 6. Set the following properly 
%      DeltaRespMat
%      Range
%      Tolerance (monmags can help)
% 8. linktime2datenum needed for Tango



if nargin < 1
    OperationalMode = 1;
end


setao([]);   %clear previous AcceleratorObjects


%[BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, BEND] = mad2at_elettra;
mad2at_elettra;


% Build the various device lists
OnePerSectorList=[];
TwoPerSectorList=[];
ThreePerSectorList=[];
FourPerSectorList=[];
SevenPerSectorList=[];
EightPerSectorList=[];
for Sector = 1:12
    OnePerSectorList = [OnePerSectorList;
        Sector 1;];
    TwoPerSectorList = [TwoPerSectorList;
        Sector 1;
        Sector 2;];
    ThreePerSectorList = [ThreePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;];
    FourPerSectorList = [FourPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];
    SevenPerSectorList = [SevenPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        ];
    EightPerSectorList = [EightPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        ];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMx'; 'HBPM'};
AO.BPMx.DeviceList = EightPerSectorList;
AO.BPMx.ElementList = (1:size(EightPerSectorList,1))';
AO.BPMx.Status = ones(size(EightPerSectorList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_elettra('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMy'; 'VBPM'};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status = AO.BPMx.Status;

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_elettra('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;



% Correctors
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = SevenPerSectorList;
AO.HCM.ElementList = (1:size(SevenPerSectorList,1))';
AO.HCM.Status = ones(size(SevenPerSectorList,1),1);

AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_elettra('HCM', 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @elettra2at;
AO.HCM.Monitor.Physics2HWFcn = @at2elettra;
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_elettra('HCM', 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2elettra;
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Units = 'Hardware';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = SevenPerSectorList;
AO.VCM.DeviceList([7 64],:) = [];
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status = ones(size(AO.VCM.DeviceList,1),1);

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_elettra('VCM', 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @elettra2at;
AO.VCM.Monitor.Physics2HWFcn = @at2elettra;
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_elettra('VCM', 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2elettra;
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Units = 'Hardware';



% Quadrupoles
AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'Dispersion Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QF.DeviceList = TwoPerSectorList;
AO.QF.ElementList = (1:size(TwoPerSectorList,1))';
AO.QF.Status = ones(size(TwoPerSectorList,1),1);

AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_elettra('QF', 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsFcn = @elettra2at;
AO.QF.Monitor.Physics2HWFcn = @at2elettra;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_elettra('QF', 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.QF.Setpoint.Physics2HWFcn = @at2elettra;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'Dispersion Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = OnePerSectorList;
AO.QD.ElementList = (1:size(OnePerSectorList,1))';
AO.QD.Status = ones(size(OnePerSectorList,1),1);

AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_elettra('QD', 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsFcn = @elettra2at;
AO.QD.Monitor.Physics2HWFcn = @at2elettra;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_elettra('QD', 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.QD.Setpoint.Physics2HWFcn = @at2elettra;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';

AO.Q1.FamilyName = 'Q1';
AO.Q1.MemberOf   = {'PlotFamily'; 'Dispersion Corrector'; 'QUAD'; 'Magnet'};
AO.Q1.DeviceList = TwoPerSectorList;
AO.Q1.ElementList = (1:size(TwoPerSectorList,1))';
AO.Q1.Status = ones(size(TwoPerSectorList,1),1);

AO.Q1.Monitor.Mode = 'Simulator';
AO.Q1.Monitor.DataType = 'Scalar';
AO.Q1.Monitor.ChannelNames = getname_elettra('Q1', 'Monitor', AO.Q1.DeviceList);
AO.Q1.Monitor.HW2PhysicsFcn = @elettra2at;
AO.Q1.Monitor.Physics2HWFcn = @at2elettra;
AO.Q1.Monitor.Units = 'Hardware';
AO.Q1.Monitor.HWUnits = 'Ampere';
AO.Q1.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q1.Setpoint.MemberOf = {'MachineConfig'};
AO.Q1.Setpoint.Mode = 'Simulator';
AO.Q1.Setpoint.DataType = 'Scalar';
AO.Q1.Setpoint.ChannelNames = getname_elettra('Q1', 'Setpoint', AO.Q1.DeviceList);
AO.Q1.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.Q1.Setpoint.Physics2HWFcn = @at2elettra;
AO.Q1.Setpoint.Units = 'Hardware';
AO.Q1.Setpoint.HWUnits = 'Ampere';
AO.Q1.Setpoint.PhysicsUnits = '1/Meter^2';

AO.Q2.FamilyName = 'Q2';
AO.Q2.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QUAD'; 'Magnet'};
AO.Q2.DeviceList = TwoPerSectorList;
AO.Q2.ElementList = (1:size(TwoPerSectorList,1))';
AO.Q2.Status = ones(size(TwoPerSectorList,1),1);

AO.Q2.Monitor.Mode = 'Simulator';
AO.Q2.Monitor.DataType = 'Scalar';
AO.Q2.Monitor.ChannelNames = getname_elettra('Q2', 'Monitor', AO.Q2.DeviceList);
AO.Q2.Monitor.HW2PhysicsFcn = @elettra2at;
AO.Q2.Monitor.Physics2HWFcn = @at2elettra;
AO.Q2.Monitor.Units = 'Hardware';
AO.Q2.Monitor.HWUnits = 'Ampere';
AO.Q2.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q2.Setpoint.MemberOf = {'MachineConfig'};
AO.Q2.Setpoint.Mode = 'Simulator';
AO.Q2.Setpoint.DataType = 'Scalar';
AO.Q2.Setpoint.ChannelNames = getname_elettra('Q2', 'Setpoint', AO.Q2.DeviceList);
AO.Q2.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.Q2.Setpoint.Physics2HWFcn = @at2elettra;
AO.Q2.Setpoint.Units = 'Hardware';
AO.Q2.Setpoint.HWUnits = 'Ampere';
AO.Q2.Setpoint.PhysicsUnits = '1/Meter^2';


AO.Q3.FamilyName = 'Q3';
AO.Q3.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QUAD'; 'Magnet'};
AO.Q3.DeviceList = TwoPerSectorList;
AO.Q3.ElementList = (1:size(TwoPerSectorList,1))';
AO.Q3.Status = ones(size(TwoPerSectorList,1),1);

AO.Q3.Monitor.Mode = 'Simulator';
AO.Q3.Monitor.DataType = 'Scalar';
AO.Q3.Monitor.ChannelNames = getname_elettra('Q3', 'Monitor', AO.Q3.DeviceList);
AO.Q3.Monitor.HW2PhysicsFcn = @elettra2at;
AO.Q3.Monitor.Physics2HWFcn = @at2elettra;
AO.Q3.Monitor.Units = 'Hardware';
AO.Q3.Monitor.HWUnits = 'Ampere';
AO.Q3.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q3.Setpoint.MemberOf = {'MachineConfig'};
AO.Q3.Setpoint.Mode = 'Simulator';
AO.Q3.Setpoint.DataType = 'Scalar';
AO.Q3.Setpoint.ChannelNames = getname_elettra('Q3', 'Setpoint', AO.Q3.DeviceList);
AO.Q3.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.Q3.Setpoint.Physics2HWFcn = @at2elettra;
AO.Q3.Setpoint.Units = 'Hardware';
AO.Q3.Setpoint.HWUnits = 'Ampere';
AO.Q3.Setpoint.PhysicsUnits = '1/Meter^2';


% Sextupoles
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = (1:size(TwoPerSectorList,1))';
AO.SF.Status = ones(size(TwoPerSectorList,1),1);

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_elettra('SF', 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsFcn = @elettra2at;
AO.SF.Monitor.Physics2HWFcn = @at2elettra;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_elettra('SF', 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.SF.Setpoint.Physics2HWFcn = @at2elettra;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = TwoPerSectorList;
AO.SD.ElementList = (1:size(TwoPerSectorList,1))';
AO.SD.Status = ones(size(TwoPerSectorList,1),1);

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_elettra('SD', 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsFcn = @elettra2at;
AO.SD.Monitor.Physics2HWFcn = @at2elettra;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_elettra('SD', 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.SD.Setpoint.Physics2HWFcn = @at2elettra;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S1.FamilyName = 'S1';
AO.S1.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'S1'; 'SEXT'; 'Magnet'};
AO.S1.DeviceList = TwoPerSectorList;
AO.S1.ElementList = (1:size(TwoPerSectorList,1))';
AO.S1.Status = ones(size(TwoPerSectorList,1),1);

AO.S1.Monitor.Mode = 'Simulator';
AO.S1.Monitor.DataType = 'Scalar';
AO.S1.Monitor.ChannelNames = getname_elettra('S1', 'Monitor', AO.S1.DeviceList);
AO.S1.Monitor.HW2PhysicsFcn = @elettra2at;
AO.S1.Monitor.Physics2HWFcn = @at2elettra;
AO.S1.Monitor.Units = 'Hardware';
AO.S1.Monitor.HWUnits = 'Ampere';
AO.S1.Monitor.PhysicsUnits = '1/Meter^3';

AO.S1.Setpoint.MemberOf = {'MachineConfig';};
AO.S1.Setpoint.Mode = 'Simulator';
AO.S1.Setpoint.DataType = 'Scalar';
AO.S1.Setpoint.ChannelNames = getname_elettra('S1', 'Setpoint', AO.S1.DeviceList);
AO.S1.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.S1.Setpoint.Physics2HWFcn = @at2elettra;
AO.S1.Setpoint.Units = 'Hardware';
AO.S1.Setpoint.HWUnits = 'Ampere';
AO.S1.Setpoint.PhysicsUnits = '1/Meter^3';


% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = TwoPerSectorList;
AO.BEND.ElementList = (1:size(TwoPerSectorList,1))';
AO.BEND.Status = ones(size(TwoPerSectorList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_elettra('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @elettra2at;
AO.BEND.Monitor.Physics2HWFcn = @at2elettra;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_elettra('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @elettra2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2elettra;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.Mode = 'Simulator'; 
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_elettra('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.SpecialFunctionGet = 'getrf_elettra';
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator'; 
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.SpecialFunctionSet = 'setrf_elettra';
AO.RF.Setpoint.SpecialFunctionGet = 'getrf_elettra';
AO.RF.Setpoint.ChannelNames = getname_elettra('RF', 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [0 Inf];


% Tune
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];

AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
%AO.TUNE.Monitor.ChannelNames = getname_elettra('TUNE', 'Monitor', AO.RF.DeviceList);
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_elettra';
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
AO.DCCT.Monitor.ChannelNames = getname_elettra('DCCT', 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';

%%%%%%%%%%%%%%%
% Fast Kicker %
%%%%%%%%%%%%%%%
% AO.Kicker.FamilyName = 'Kicker';
% AO.Kicker.MemberOf   = {'Kicker';};
% AO.Kicker.DeviceList = [1 1];
% AO.Kicker.ElementList = 1;
% AO.Kicker.Status = ones(size(AO.Kicker.DeviceList,1),1);
% 
% AO.Kicker.Monitor.MemberOf = {'Monitor'};
% AO.Kicker.Monitor.Mode = 'Simulator';
% AO.Kicker.Monitor.DataType = 'Scalar';
% AO.Kicker.Monitor.ChannelNames = '';
% AO.Kicker.Monitor.HW2PhysicsParams = 10e-6 / 1000;  % 1000? volts -> 10? urad
% AO.Kicker.Monitor.Physics2HWParams = 1000 / 10e-6;  
% AO.Kicker.Monitor.Units        = 'Hardware';
% AO.Kicker.Monitor.HWUnits      = 'Volts';
% AO.Kicker.Monitor.PhysicsUnits = 'Radians';
% 
% AO.Kicker.Setpoint.MemberOf = {'Setpoint'};
% AO.Kicker.Setpoint.Mode = 'Simulator';
% AO.Kicker.Setpoint.DataType = 'Scalar';
% AO.Kicker.Setpoint.ChannelNames = '';
% AO.Kicker.Setpoint.HW2PhysicsParams = 10e-6 / 1000;  % 1000? volts -> 10? urad
% AO.Kicker.Setpoint.Physics2HWParams = 1000 / 10e-6;
% AO.Kicker.Setpoint.Units        = 'Hardware';
% AO.Kicker.Setpoint.HWUnits      = 'Volts';
% AO.Kicker.Setpoint.PhysicsUnits = 'Radians';
% AO.Kicker.Setpoint.Range = [0 1000];


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
AO.Q1.Setpoint.Range   = [local_minsp(AO.Q1.FamilyName)   local_maxsp(AO.Q1.FamilyName)];
AO.Q2.Setpoint.Range   = [local_minsp(AO.Q2.FamilyName)   local_maxsp(AO.Q2.FamilyName)];
AO.Q3.Setpoint.Range   = [local_minsp(AO.Q3.FamilyName)   local_maxsp(AO.Q3.FamilyName)];
AO.SF.Setpoint.Range   = [local_minsp(AO.SF.FamilyName)   local_maxsp(AO.SF.FamilyName)];
AO.SD.Setpoint.Range   = [local_minsp(AO.SD.FamilyName)   local_maxsp(AO.SD.FamilyName)];
AO.S1.Setpoint.Range   = [local_minsp(AO.S1.FamilyName)   local_maxsp(AO.S1.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.RF.Setpoint.Range   = [local_minsp(AO.RF.FamilyName)   local_maxsp(AO.RF.FamilyName)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName);
AO.Q1.Setpoint.Tolerance   = gettol(AO.Q1.FamilyName);
AO.Q2.Setpoint.Tolerance   = gettol(AO.Q2.FamilyName);
AO.Q3.Setpoint.Tolerance   = gettol(AO.Q3.FamilyName);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName);
AO.S1.Setpoint.Tolerance   = gettol(AO.S1.FamilyName);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName);
AO.RF.Setpoint.Tolerance   = gettol(AO.RF.FamilyName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response matrix kick size (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .5e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .5e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat  = 1e-4;
AO.QD.Setpoint.DeltaRespMat  = 1e-4;
AO.Q1.Setpoint.DeltaRespMat  = 1e-4;
AO.Q2.Setpoint.DeltaRespMat  = 1e-4;
AO.Q3.Setpoint.DeltaRespMat  = 1e-4;
AO.SF.Setpoint.DeltaRespMat  = 1e-4;
AO.SD.Setpoint.DeltaRespMat  = 1e-4;

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
        Amps(i,1) = -33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'Q1')
        Amps(i,1) = 0;
    elseif strcmp(Family,'Q2')
        Amps(i,1) = 0;
    elseif strcmp(Family,'Q3')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')        
        Amps(i,1) = 0;
    elseif strcmp(Family,'S1')        
        Amps(i,1) = 0;
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
        Amps(i,1) = 33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 500;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 500;
    elseif strcmp(Family,'Q1')
        Amps(i,1) = 400;
    elseif strcmp(Family,'Q2')
        Amps(i,1) = 400;
    elseif strcmp(Family,'Q3')
        Amps(i,1) = 400;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'S1')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 2000;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 550e6;  % MHz
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
    tol = 0.5;
elseif strcmp(Family,'QD')
    tol = 0.5;
elseif strcmp(Family,'Q1')
    tol = 0.5;
elseif strcmp(Family,'Q2')
    tol = 0.5;
elseif strcmp(Family,'Q3')
    tol = 0.5;
elseif strcmp(Family,'SQSF')
    tol = 0.25;
elseif strcmp(Family,'SQSD')
    tol = 0.25;
elseif strcmp(Family,'SF')
    tol = 0.15;
elseif strcmp(Family,'SD')
    tol = 0.1;
elseif strcmp(Family,'S1')
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
