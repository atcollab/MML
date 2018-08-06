function tlsinit


% NOTES & COMMENTS
% 1. Magnet positions get overwritten in updateatindex.  
%    Ie, positions come directly from the AT model.
% 2. Make sure the BPM and magnes are in the correct location in the AT model 
%    or LOCO will have trouble.  
% 3. Try viewfamily, plotfamily, mmlviewer to view and check the MML setup.
% 4. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 5. Try setorbitgui, steptune, stepchro, ...
% 6. To run LOCO
%    1. Measure new data
%       >> measlocodata
%       For the model use
%       >> measlocodata('model');
%    2. Build the LOCO input file
%       >> buildlocoinput
%    3. Run LOCO
%       >> loco
%    4. To set back to the machine see setlocodata (may need some work)
%       >> setlocodata
%
%
% TO-D0 LIST:
% 0. Channel names must be added to getname_tls and tlsinit (RF, TUNE, DCCT)!!!
% 1. tls2at and tls2at need some work
% 2. bend2gev and gev2bend need some work
% 3. Check .Ranges, .Tolerances, and .DeltaRespMat
% 4. run monmags to check the .Tolerance field
% 5. Measurements - monbpm, measbpmresp, measdisp
%    Copy them to the StorageRingOpsData directory using plotfamily.
% 6. Get the tune family working
% 7. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)


if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);


% Get the device lists (local function)
[BPMlist, HCMlist, VCMlist, TwoPerSector, ThreePerSector] = buildthedevicelists;


% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = BPMlist;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Input';
AO.BPMx.Monitor.ChannelNames = getname_tls(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = BPMlist;
AO.BPMy.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMy.Position    = [];

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Input';
AO.BPMy.Monitor.ChannelNames = getname_tls(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
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
AO.HCM.DeviceList  = HCMlist;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];

AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Input';
AO.HCM.Monitor.ChannelNames = getname_tls(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @tls2at;
AO.HCM.Monitor.Physics2HWFcn = @at2tls;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Output';
AO.HCM.Setpoint.ChannelNames = getname_tls(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2tls;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-Inf Inf];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 100-6;
 

% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = VCMlist;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];

AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Input';
AO.VCM.Monitor.ChannelNames = getname_tls(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @tls2at;
AO.VCM.Monitor.Physics2HWFcn = @at2tls;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Output';
AO.VCM.Setpoint.ChannelNames = getname_tls(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2tls;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-Inf Inf];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 100e-6;



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
AO.QF1.FamilyName  = 'QF1';
AO.QF1.MemberOf    = {'PlotFamily'; 'QF1'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector';};
AO.QF1.DeviceList  = TwoPerSector;
AO.QF1.ElementList = (1:size(AO.QF1.DeviceList,1))';
AO.QF1.Status      = ones(size(AO.QF1.DeviceList,1),1);
AO.QF1.Position    = [];

AO.QF1.Monitor.MemberOf = {};
AO.QF1.Monitor.Mode = 'Simulator';
AO.QF1.Monitor.DataType = 'Input';
AO.QF1.Monitor.ChannelNames = getname_tls(AO.QF1.FamilyName, 'Monitor', AO.QF1.DeviceList);
% AO.QF1.Monitor.HW2PhysicsFcn = @tls2at;
% AO.QF1.Monitor.Physics2HWFcn = @at2tls;
AO.QF1.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
AO.QF1.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.QF1.Monitor.Units        = 'Hardware';
AO.QF1.Monitor.HWUnits      = 'Ampere';
AO.QF1.Monitor.PhysicsUnits = 'meter^-2';

AO.QF1.Setpoint.MemberOf = {'MachineConfig';};
AO.QF1.Setpoint.Mode = 'Simulator';
AO.QF1.Setpoint.DataType = 'Output';
AO.QF1.Setpoint.ChannelNames = getname_tls(AO.QF1.FamilyName, 'Setpoint', AO.QF1.DeviceList);
% AO.QF1.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.QF1.Setpoint.Physics2HWFcn = @at2tls;
AO.QF1.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
AO.QF1.Setpoint.Physics2HWParams = (188.89/2.5447); 
AO.QF1.Setpoint.Units        = 'Hardware';
AO.QF1.Setpoint.HWUnits      = 'Ampere';
AO.QF1.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF1.Setpoint.Range        = [-Inf Inf];
AO.QF1.Setpoint.Tolerance    = .1;
AO.QF1.Setpoint.DeltaRespMat = .01;


AO.QF2.FamilyName  = 'QF2';
AO.QF2.MemberOf    = {'PlotFamily'; 'QF2'; 'QF'; 'QUAD'; 'Magnet';};
AO.QF2.DeviceList  = TwoPerSector;
AO.QF2.ElementList = (1:size(AO.QF2.DeviceList,1))';
AO.QF2.Status      = ones(size(AO.QF2.DeviceList,1),1);
AO.QF2.Position    = [];

AO.QF2.Monitor.MemberOf = {};
AO.QF2.Monitor.Mode = 'Simulator';
AO.QF2.Monitor.DataType = 'Input';
AO.QF2.Monitor.ChannelNames = getname_tls(AO.QF2.FamilyName, 'Monitor', AO.QF2.DeviceList);
% AO.QF2.Monitor.HW2PhysicsFcn = @tls2at;
% AO.QF2.Monitor.Physics2HWFcn = @at2tls;
AO.QF2.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
AO.QF2.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.QF2.Monitor.Units        = 'Hardware';
AO.QF2.Monitor.HWUnits      = 'Ampere';
AO.QF2.Monitor.PhysicsUnits = 'meter^-2';

AO.QF2.Setpoint.MemberOf = {'MachineConfig';};
AO.QF2.Setpoint.Mode = 'Simulator';
AO.QF2.Setpoint.DataType = 'Output';
AO.QF2.Setpoint.ChannelNames = getname_tls(AO.QF2.FamilyName, 'Setpoint', AO.QF2.DeviceList);
% AO.QF2.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.QF2.Setpoint.Physics2HWFcn = @at2tls;
AO.QF2.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
AO.QF2.Setpoint.Physics2HWParams = (188.89/2.5447);
AO.QF2.Setpoint.Units        = 'Hardware';
AO.QF2.Setpoint.HWUnits      = 'Ampere';
AO.QF2.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF2.Setpoint.Range        = [-Inf Inf];
AO.QF2.Setpoint.Tolerance    = .1;
AO.QF2.Setpoint.DeltaRespMat = .01;


AO.QD1.FamilyName  = 'QD1';
AO.QD1.MemberOf    = {'PlotFamily'; 'QD1'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD1.DeviceList  = TwoPerSector;
AO.QD1.ElementList = (1:size(AO.QD1.DeviceList,1))';
AO.QD1.Status      = ones(size(AO.QD1.DeviceList,1),1);
AO.QD1.Position    = [];

AO.QD1.Monitor.MemberOf = {};
AO.QD1.Monitor.Mode = 'Simulator';
AO.QD1.Monitor.DataType = 'Input';
AO.QD1.Monitor.ChannelNames = getname_tls(AO.QD1.FamilyName, 'Monitor', AO.QD1.DeviceList);
% AO.QD1.Monitor.HW2PhysicsFcn = @tls2at;
% AO.QD1.Monitor.Physics2HWFcn = @at2tls;
AO.QD1.Monitor.HW2PhysicsParams = (-1.6840/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
AO.QD1.Monitor.Physics2HWParams = (125.148/-1.6840);
AO.QD1.Monitor.Units        = 'Hardware';
AO.QD1.Monitor.HWUnits      = 'Ampere';
AO.QD1.Monitor.PhysicsUnits = 'meter^-2';

AO.QD1.Setpoint.MemberOf = {'MachineConfig';};
AO.QD1.Setpoint.Mode = 'Simulator';
AO.QD1.Setpoint.DataType = 'Output';
AO.QD1.Setpoint.ChannelNames = getname_tls(AO.QD1.FamilyName, 'Setpoint', AO.QD1.DeviceList);
% AO.QD1.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.QD1.Setpoint.Physics2HWFcn = @at2tls;
AO.QD1.Setpoint.HW2PhysicsParams = (-1.6840/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
AO.QD1.Setpoint.Physics2HWParams = (125.148/-1.6840);
AO.QD1.Setpoint.Units        = 'Hardware';
AO.QD1.Setpoint.HWUnits      = 'Ampere';
AO.QD1.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD1.Setpoint.Range        = [-Inf Inf];
AO.QD1.Setpoint.Tolerance    = .1;
AO.QD1.Setpoint.DeltaRespMat = .01;


AO.QD2.FamilyName  = 'QD2';
AO.QD2.MemberOf    = {'PlotFamily'; 'QD2'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD2.DeviceList  = TwoPerSector;
AO.QD2.ElementList = (1:size(AO.QD2.DeviceList,1))';
AO.QD2.Status      = ones(size(AO.QD2.DeviceList,1),1);
AO.QD2.Position    = [];

AO.QD2.Monitor.MemberOf = {};
AO.QD2.Monitor.Mode = 'Simulator';
AO.QD2.Monitor.DataType = 'Input';
AO.QD2.Monitor.ChannelNames = getname_tls(AO.QD2.FamilyName, 'Monitor', AO.QD2.DeviceList);
% AO.QD2.Monitor.HW2PhysicsFcn = @tls2at;
% AO.QD2.Monitor.Physics2HWFcn = @at2tls;
AO.QD2.Monitor.HW2PhysicsParams = (-1.7374/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
AO.QD2.Monitor.Physics2HWParams = (125.148/-1.7374);
AO.QD2.Monitor.Units        = 'Hardware';
AO.QD2.Monitor.HWUnits      = 'Ampere';
AO.QD2.Monitor.PhysicsUnits = 'meter^-2';

AO.QD2.Setpoint.MemberOf = {'MachineConfig';};
AO.QD2.Setpoint.Mode = 'Simulator';
AO.QD2.Setpoint.DataType = 'Output';
AO.QD2.Setpoint.ChannelNames = getname_tls(AO.QD2.FamilyName, 'Setpoint', AO.QD2.DeviceList);
% AO.QD2.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.QD2.Setpoint.Physics2HWFcn = @at2tls;
AO.QD2.Setpoint.HW2PhysicsParams = (-1.7374/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
AO.QD2.Setpoint.Physics2HWParams = (125.148/-1.7374);
AO.QD2.Setpoint.Units        = 'Hardware';
AO.QD2.Setpoint.HWUnits      = 'Ampere';
AO.QD2.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD2.Setpoint.Range        = [-Inf Inf];
AO.QD2.Setpoint.Tolerance    = .1;
AO.QD2.Setpoint.DeltaRespMat = .01;



%%%%%%%%%%%%%%
% Sextupoles %
%%%%%%%%%%%%%%
AO.SF.FamilyName  = 'SF';
AO.SF.MemberOf    = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SF.DeviceList  = TwoPerSector;
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status      = ones(size(AO.SF.DeviceList,1),1);
AO.SF.Position    = [];

AO.SF.Monitor.MemberOf = {};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Input';
AO.SF.Monitor.ChannelNames = getname_tls(AO.SF.FamilyName, 'Monitor', AO.SF.DeviceList);
% AO.SF.Monitor.HW2PhysicsFcn = @tls2at;
% AO.SF.Monitor.Physics2HWFcn = @at2tls;
AO.SF.Monitor.HW2PhysicsParams = (50.852/195.465);
AO.SF.Monitor.Physics2HWParams = (195.465/50.852);
AO.SF.Monitor.Units        = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = 'meter^-3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Output';
AO.SF.Setpoint.ChannelNames = getname_tls(AO.SF.FamilyName, 'Setpoint', AO.SF.DeviceList);
% AO.SF.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.SF.Setpoint.Physics2HWFcn = @at2tls;
AO.SF.Setpoint.HW2PhysicsParams = (50.852/195.465);
AO.SF.Setpoint.Physics2HWParams = (195.465/50.852);
AO.SF.Setpoint.Units        = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = 'meter^-3';
AO.SF.Setpoint.Range        = [-Inf Inf];
AO.SF.Setpoint.Tolerance    = .1;
AO.SF.Setpoint.DeltaRespMat = .01;


AO.SD.FamilyName  = 'SD';
AO.SD.MemberOf    = {'PlotFamily'; 'SD'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SD.DeviceList  = TwoPerSector;
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status      = ones(size(AO.SD.DeviceList,1),1);
AO.SD.Position    = [];

AO.SD.Monitor.MemberOf = {};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Input';
AO.SD.Monitor.ChannelNames = getname_tls(AO.SD.FamilyName, 'Monitor', AO.SD.DeviceList);
% AO.SD.Monitor.HW2PhysicsFcn = @tls2at;
% AO.SD.Monitor.Physics2HWFcn = @at2tls;
AO.SD.Monitor.HW2PhysicsParams = (-38.837/146.246);
AO.SD.Monitor.Physics2HWParams = (146.246/-38.837);
AO.SD.Monitor.Units        = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = 'meter^-3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Output';
AO.SD.Setpoint.ChannelNames = getname_tls(AO.SD.FamilyName, 'Setpoint', AO.SD.DeviceList);
% AO.SD.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.SD.Setpoint.Physics2HWFcn = @at2tls;
AO.SD.Setpoint.HW2PhysicsParams = (-38.837/146.246);
AO.SD.Setpoint.Physics2HWParams = (146.246/-38.837);
AO.SD.Setpoint.Units        = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = 'meter^-3';
AO.SD.Setpoint.Range        = [-Inf Inf];
AO.SD.Setpoint.Tolerance    = .1;
AO.SD.Setpoint.DeltaRespMat = .01;



%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = ThreePerSector;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];

AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Input';
AO.BEND.Monitor.ChannelNames = getname_tls(AO.BEND.FamilyName, 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Output';
AO.BEND.Setpoint.ChannelNames = getname_tls(AO.BEND.FamilyName, 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = [-Inf Inf];
AO.BEND.Setpoint.Tolerance    = .1;
AO.BEND.Setpoint.DeltaRespMat = .01;



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
AO.RF.Monitor.DataType          = 'Input';
AO.RF.Monitor.ChannelNames      = '';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Output';
AO.RF.Setpoint.ChannelNames     = '';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [0 500000];
AO.RF.Setpoint.Tolerance        = 1.0;

% AO.RF.VoltageCtrl.MemberOf          = {};
% AO.RF.VoltageCtrl.Mode              = 'Simulator';
% AO.RF.VoltageCtrl.DataType          = 'Output';
% AO.RF.VoltageCtrl.ChannelNames      = '';
% AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
% AO.RF.VoltageCtrl.Physics2HWParams  = 1;
% AO.RF.VoltageCtrl.Units             = 'Hardware';
% AO.RF.VoltageCtrl.HWUnits           = 'Volts';
% AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';
% 
% AO.RF.Voltage.MemberOf          = {};
% AO.RF.Voltage.Mode              = 'Simulator';
% AO.RF.Voltage.DataType          = 'Input';
% AO.RF.Voltage.ChannelNames      = '';
% AO.RF.Voltage.HW2PhysicsParams  = 1;
% AO.RF.Voltage.Physics2HWParams  = 1;
% AO.RF.Voltage.Units             = 'Hardware';
% AO.RF.Voltage.HWUnits           = 'Volts';
% AO.RF.Voltage.PhysicsUnits      = 'Volts';
% 
% AO.RF.Power.MemberOf          = {};
% AO.RF.Power.Mode              = 'Simulator';
% AO.RF.Power.DataType          = 'Input';
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
% AO.RF.Phase.DataType          = 'Input';
% AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???  
% AO.RF.Phase.Units             = 'Hardware';
% AO.RF.Phase.HW2PhysicsParams  = 1; 
% AO.RF.Phase.Physics2HWParams  = 1;
% AO.RF.Phase.HWUnits           = 'Degrees';  
% AO.RF.Phase.PhysicsUnits      = 'Degrees';
% 
% AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
% AO.RF.PhaseCtrl.Mode              = 'Simulator';
% AO.RF.PhaseCtrl.DataType          = 'Output';
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
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Input';
AO.DCCT.Monitor.ChannelNames     = '';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'milli-ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'ampere';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];

AO.TUNE.Monitor.MemberOf   = {'TUNE';};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Input';
AO.TUNE.Monitor.ChannelNames = '';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_tls';



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
AO.QF1.Setpoint.DeltaRespMat   = physics2hw('QF1',  'Setpoint', AO.QF1.Setpoint.DeltaRespMat,   AO.QF1.DeviceList,   'NoEnergyScaling');
AO.QD1.Setpoint.DeltaRespMat   = physics2hw('QD1',  'Setpoint', AO.QD1.Setpoint.DeltaRespMat,   AO.QD1.DeviceList,   'NoEnergyScaling');
AO.QF2.Setpoint.DeltaRespMat   = physics2hw('QF2',  'Setpoint', AO.QF2.Setpoint.DeltaRespMat,   AO.QF2.DeviceList,   'NoEnergyScaling');
AO.QD2.Setpoint.DeltaRespMat   = physics2hw('QD2',  'Setpoint', AO.QD2.Setpoint.DeltaRespMat,   AO.QD2.DeviceList,   'NoEnergyScaling');
AO.SF.Setpoint.DeltaRespMat   = physics2hw('SF',  'Setpoint', AO.SF.Setpoint.DeltaRespMat,   AO.SF.DeviceList,   'NoEnergyScaling');
AO.SD.Setpoint.DeltaRespMat   = physics2hw('SD',  'Setpoint', AO.SD.Setpoint.DeltaRespMat,   AO.SD.DeviceList,   'NoEnergyScaling');
setao(AO);


 
function [BPMlist, HCMlist, VCMlist, TwoPerSector, ThreePerSector] = buildthedevicelists

NSector = 6;

BPMlist = [
             1 1
             1 2
             1 3
             1 4
             1 5
             1 6
             1 7
             1 8
             1 9
             1 10
             2 1
             2 2
             2 3
             2 4
             2 5
             2 6
             2 7
             2 8
             2 9
             2 10
             3 1
             3 2
             3 3
             3 4
             3 5
             3 6
             3 7
             3 8
             3 9
             3 10
             3 11
             4 1
             4 2
             4 3
             4 4
             4 5
             4 6
             4 7
             4 8
             4 9
             4 10 % 01/19/2009
             5 1
             5 2
             5 3
             5 4
             5 5
             5 6
             5 7
             5 8
             5 9
             5 10
             6 1
             6 2
             6 3
             6 4
             6 5
             6 6
             6 7
             6 8 ];


HCMlist=[1 1
    1 2
    1 3
    1 4
    1 5 
    1 6
    1 7
    1 8
    1 9
    2 1
    2 2
    2 3
    2 4
    2 5
    2 6
    2 7
    2 8
    3 1
    3 2
    3 3
    3 4
    3 5
    3 6
    3 7 % 01/19/2009
    4 1
    4 2
    4 3
    4 4
    4 5
    4 6
    4 7 % 01/19/2009
    4 8 % 01/19/2009
    5 1
    5 2
    5 3
    5 4
    5 5
    5 6
    5 7
    5 8
    6 1
    6 2
    6 3
    6 4
    6 5
    6 6
    6 7];
VCMlist=[1 1
    1 2
    1 3
    1 4
    1 5 
    1 6
    1 7
    1 8
    2 1
    2 2
    2 3
    2 4
    2 5
    2 6
    2 7
   %2 8 % 01/21/2009
    3 1
    3 2
    3 3
    3 4
    3 5
    3 6
    3 7
    4 1
    4 2
    4 3
    4 4
    4 5
    4 6
    4 7
    4 8 % 01/19/2009
    5 1
    5 2
    5 3
    5 4
    5 5
    5 6
    5 7
    5 8
    5 9
    6 1
    6 2
    6 3
    6 4
    6 5
    6 6
    6 7
    6 8];

TwoPerSector=[];
ThreePerSector=[];
for Sector =1:NSector  
    TwoPerSector = [TwoPerSector;
        Sector 1;
        Sector 2;];
    
    ThreePerSector = [ThreePerSector;
        Sector 1;
        Sector 2;
        Sector 3;];	
end

