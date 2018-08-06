function boosterinit(OperationalMode)
%BOOSTERINIT - Initialization function of the ALS booster

% 1. Check SP and AM for all magnets (proper channel names)
% 2. IP, IG, VVR, etc. to hwinit?  Or at least a warning on the valves
% 3. QF & QD monitors don't update and don't seem to plot in EDM?
% 4. BEND, QF, QD - OnControl not functional.  
%        What sequence should we use?  Special function?  Turnoff.m?
%        Add additional check on brcontrol
% 5. Test RF and BEND table load
% 6. Add all gains, etc to save/restore


if nargin < 1
    % 1 => 1.9   GeV injection
    % 2 => 1.23  GeV injection
    % 3 => 1.522 GeV injection    
    OperationalMode = 1;
end


% Device lists
TwoPerSectorList   = [];
ThreePerSectorList = [];
FourPerSectorList  = [];
SixPerSectorList   = [];
EightPerSectorList = [];

for Sector = 1:4
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

    SixPerSectorList = [SixPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;];

    EightPerSectorList = [EightPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];
end



%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = [
    1     2
    1     3
    1     4
    1     6
    1     8
    2     2
    2     3
    2     4
    2     6
    2     8
    3     2
    3     3
    3     4
    3     6
    3     8
    4     2
    4     3
    4     4
    4     6
    4     8
    ];
AO.BPMx.ElementList = 8 * (AO.BPMx.DeviceList(:,1)-1) + AO.BPMx.DeviceList(:,2); 
AO.BPMx.Status = ones(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
%AO.BPMx.Monitor.ChannelNames = getname_booster(AO.BPMx.FamilyName, 'Monitor');
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_bts;
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;

AO.BPMy.Monitor.MemberOf = {};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
%AO.BPMy.Monitor.ChannelNames = getname_booster(AO.BPMy.FamilyName, 'Monitor');
%AO.BPMy.Monitor.SpecialFunctionGet = @gety_bts;
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;


% BPM
setao(AO);
AO = buildmmlbpmfamily(AO, 'Booster');

AO.BPMx.Monitor.ChannelNames = AO.BPM.X.ChannelNames;
AO.BPMy.Monitor.ChannelNames = AO.BPM.Y.ChannelNames;
% AO.BPMx.Sum.ChannelNames     = AO.BPM.S.ChannelNames;
% AO.BPMy.Sum.ChannelNames     = AO.BPM.S.ChannelNames;


% HCM
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = FourPerSectorList;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status = ones(size(AO.HCM.DeviceList,1),1);
%AO.HCM.Status = [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0]';
AO.HCM.BaseName = [
    'BR1:HCM1'
    'BR1:HCM2'
    'BR1:HCM3'
    'BR1:HCM4'
    'BR2:HCM1'
    'BR2:HCM2'
    'BR2:HCM3'
    'BR2:HCM4'
    'BR3:HCM1'
    'BR3:HCM2'
    'BR3:HCM3'
    'BR3:HCM4'
    'BR4:HCM1'
    'BR4:HCM2'
    'BR4:HCM3'
    'BR4:HCM4'
    ];

%   IRM  SP  AM OnBC OnBM Rdy
a = [
    124  00  00  22   01   00
    112  03  03  23   03   02
    115  00  00  22   01   00
    115  02  02  23   03   02
    
    112  02  02  22   01   00
    116  03  03  23   03   02
    116  00  00  20   05   04
    116  01  01  21   07   06
    
    116  02  02  22   01   00
    120  03  03  23   03   02
    123  00  00  22   01   00
    123  02  02  23   03   02
    
    120  02  02  22   01   00
    124  03  03  23   03   02
    127  00  00  22   01   00
    127  02  02  23   03   02
    ];

AO.HCM.IRM = a(:,1);

AO.HCM.Monitor.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = '';
AO.HCM.Monitor.HW2PhysicsFcn = @booster2at;
AO.HCM.Monitor.Physics2HWFcn = @at2booster;
AO.HCM.Monitor.Units = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = '';
AO.HCM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2booster;
AO.HCM.Setpoint.Units = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';

AO.HCM.RampRate.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'Save/Restore';};
AO.HCM.RampRate.Mode = 'Simulator';
AO.HCM.RampRate.DataType = 'Scalar';
AO.HCM.RampRate.ChannelNames = '';
AO.HCM.RampRate.HW2PhysicsParams = 1;
AO.HCM.RampRate.Physics2HWParams = 1;
AO.HCM.RampRate.Units = 'Hardware';
AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.HCM.OnControl.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = '';
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';
AO.HCM.OnControl.Range = [0 1];
AO.HCM.OnControl.Tolerance = .5;    

AO.HCM.On.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor';};
AO.HCM.On.Mode = 'Simulator';
AO.HCM.On.DataType = 'Scalar';
AO.HCM.On.ChannelNames = '';
AO.HCM.On.HW2PhysicsParams = 1;
AO.HCM.On.Physics2HWParams = 1;
AO.HCM.On.Units = 'Hardware';
AO.HCM.On.HWUnits      = '';
AO.HCM.On.PhysicsUnits = '';

AO.HCM.Ready.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = '';
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';

% Setpoint waveform (1400 points) 
AO.HCM.AWGPattern.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Waveform'; 'AWG'};
AO.HCM.AWGPattern.Mode = 'Simulator';
AO.HCM.AWGPattern.DataType = 'Scalar';
AO.HCM.AWGPattern.ChannelNames = '';
AO.HCM.AWGPattern.HW2PhysicsFcn = @booster2at;
AO.HCM.AWGPattern.Physics2HWFcn = @at2booster;
AO.HCM.AWGPattern.Units = 'Hardware';
AO.HCM.AWGPattern.HWUnits      = 'Ampere or Counts?';
AO.HCM.AWGPattern.PhysicsUnits = 'Radian';

%  Auto-Rearm/Single (1/0)
AO.HCM.AWGTrigMode.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGTrigMode.Mode = 'Simulator';
AO.HCM.AWGTrigMode.DataType = 'Scalar';
AO.HCM.AWGTrigMode.ChannelNames = '';
AO.HCM.AWGTrigMode.HW2PhysicsFcn = 1;
AO.HCM.AWGTrigMode.Physics2HWFcn = 1;
AO.HCM.AWGTrigMode.Units = 'Hardware';
AO.HCM.AWGTrigMode.HWUnits      = '';
AO.HCM.AWGTrigMode.PhysicsUnits = '';

% Armed/Disarmed (1/0)
AO.HCM.AWGArm.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGArm.Mode = 'Simulator';
AO.HCM.AWGArm.DataType = 'Scalar';
AO.HCM.AWGArm.ChannelNames = '';
AO.HCM.AWGArm.HW2PhysicsFcn = 1;
AO.HCM.AWGArm.Physics2HWFcn = 1;
AO.HCM.AWGArm.Units = 'Hardware';
AO.HCM.AWGArm.HWUnits      = '';
AO.HCM.AWGArm.PhysicsUnits = '';

AO.HCM.AWGEnable.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGEnable.Mode = 'Simulator';
AO.HCM.AWGEnable.DataType = 'Scalar';
AO.HCM.AWGEnable.ChannelNames = '';
AO.HCM.AWGEnable.HW2PhysicsFcn = 1;
AO.HCM.AWGEnable.Physics2HWFcn = 1;
AO.HCM.AWGEnable.Units = 'Hardware';
AO.HCM.AWGEnable.HWUnits      = '';
AO.HCM.AWGEnable.PhysicsUnits = '';

% Active/Idle (1/0)
AO.HCM.AWGActive.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGActive.Mode = 'Simulator';
AO.HCM.AWGActive.DataType = 'Scalar';
AO.HCM.AWGActive.ChannelNames = '';
AO.HCM.AWGActive.HW2PhysicsFcn = 1;
AO.HCM.AWGActive.Physics2HWFcn = 1;
AO.HCM.AWGActive.Units = 'Hardware';
AO.HCM.AWGActive.HWUnits      = '';
AO.HCM.AWGActive.PhysicsUnits = '';

AO.HCM.AWGTrigModeRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGTrigModeRBV.Mode = 'Simulator';
AO.HCM.AWGTrigModeRBV.DataType = 'Scalar';
AO.HCM.AWGTrigModeRBV.ChannelNames = '';
AO.HCM.AWGTrigModeRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGTrigModeRBV.Physics2HWFcn = 1;
AO.HCM.AWGTrigModeRBV.Units = 'Hardware';
AO.HCM.AWGTrigModeRBV.HWUnits      = '';
AO.HCM.AWGTrigModeRBV.PhysicsUnits = '';

AO.HCM.AWGArmRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGArmRBV.Mode = 'Simulator';
AO.HCM.AWGArmRBV.DataType = 'Scalar';
AO.HCM.AWGArmRBV.ChannelNames = '';
AO.HCM.AWGArmRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGArmRBV.Physics2HWFcn = 1;
AO.HCM.AWGArmRBV.Units = 'Hardware';
AO.HCM.AWGArmRBV.HWUnits      = '';
AO.HCM.AWGArmRBV.PhysicsUnits = '';

AO.HCM.AWGEnableRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGEnableRBV.Mode = 'Simulator';
AO.HCM.AWGEnableRBV.DataType = 'Scalar';
AO.HCM.AWGEnableRBV.ChannelNames = '';
AO.HCM.AWGEnableRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGEnableRBV.Physics2HWFcn = 1;
AO.HCM.AWGEnableRBV.Units = 'Hardware';
AO.HCM.AWGEnableRBV.HWUnits      = '';
AO.HCM.AWGEnableRBV.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.HCM.AWGInt1Rise.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGInt1Rise.Mode = 'Simulator';
AO.HCM.AWGInt1Rise.DataType = 'Scalar';
AO.HCM.AWGInt1Rise.ChannelNames = '';
AO.HCM.AWGInt1Rise.HW2PhysicsFcn = 1;
AO.HCM.AWGInt1Rise.Physics2HWFcn = 1;
AO.HCM.AWGInt1Rise.Units = 'Hardware';
AO.HCM.AWGInt1Rise.HWUnits      = '';
AO.HCM.AWGInt1Rise.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.HCM.AWGInt2Rise.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGInt2Rise.Mode = 'Simulator';
AO.HCM.AWGInt2Rise.DataType = 'Scalar';
AO.HCM.AWGInt2Rise.ChannelNames = '';
AO.HCM.AWGInt2Rise.HW2PhysicsFcn = 1;
AO.HCM.AWGInt2Rise.Physics2HWFcn = 1;
AO.HCM.AWGInt2Rise.Units = 'Hardware';
AO.HCM.AWGInt2Rise.HWUnits      = '';
AO.HCM.AWGInt2Rise.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.HCM.AWGInt1Fall.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGInt1Fall.Mode = 'Simulator';
AO.HCM.AWGInt1Fall.DataType = 'Scalar';
AO.HCM.AWGInt1Fall.ChannelNames = '';
AO.HCM.AWGInt1Fall.HW2PhysicsFcn = 1;
AO.HCM.AWGInt1Fall.Physics2HWFcn = 1;
AO.HCM.AWGInt1Fall.Units = 'Hardware';
AO.HCM.AWGInt1Fall.HWUnits      = '';
AO.HCM.AWGInt1Fall.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.HCM.AWGInt2Fall.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.HCM.AWGInt2Fall.Mode = 'Simulator';
AO.HCM.AWGInt2Fall.DataType = 'Scalar';
AO.HCM.AWGInt2Fall.ChannelNames = '';
AO.HCM.AWGInt2Fall.HW2PhysicsFcn = 1;
AO.HCM.AWGInt2Fall.Physics2HWFcn = 1;
AO.HCM.AWGInt2Fall.Units = 'Hardware';
AO.HCM.AWGInt2Fall.HWUnits      = '';
AO.HCM.AWGInt2Fall.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.HCM.AWGInt1RiseRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGInt1RiseRBV.Mode = 'Simulator';
AO.HCM.AWGInt1RiseRBV.DataType = 'Scalar';
AO.HCM.AWGInt1RiseRBV.ChannelNames = '';
AO.HCM.AWGInt1RiseRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGInt1RiseRBV.Physics2HWFcn = 1;
AO.HCM.AWGInt1RiseRBV.Units = 'Hardware';
AO.HCM.AWGInt1RiseRBV.HWUnits      = '';
AO.HCM.AWGInt1RiseRBV.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.HCM.AWGInt2RiseRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGInt2RiseRBV.Mode = 'Simulator';
AO.HCM.AWGInt2RiseRBV.DataType = 'Scalar';
AO.HCM.AWGInt2RiseRBV.ChannelNames = '';
AO.HCM.AWGInt2RiseRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGInt2RiseRBV.Physics2HWFcn = 1;
AO.HCM.AWGInt2RiseRBV.Units = 'Hardware';
AO.HCM.AWGInt2RiseRBV.HWUnits      = '';
AO.HCM.AWGInt2RiseRBV.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.HCM.AWGInt1FallRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGInt1FallRBV.Mode = 'Simulator';
AO.HCM.AWGInt1FallRBV.DataType = 'Scalar';
AO.HCM.AWGInt1FallRBV.ChannelNames = '';
AO.HCM.AWGInt1FallRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGInt1FallRBV.Physics2HWFcn = 1;
AO.HCM.AWGInt1FallRBV.Units = 'Hardware';
AO.HCM.AWGInt1FallRBV.HWUnits      = '';
AO.HCM.AWGInt1FallRBV.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.HCM.AWGInt2FallRBV.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.HCM.AWGInt2FallRBV.Mode = 'Simulator';
AO.HCM.AWGInt2FallRBV.DataType = 'Scalar';
AO.HCM.AWGInt2FallRBV.ChannelNames = '';
AO.HCM.AWGInt2FallRBV.HW2PhysicsFcn = 1;
AO.HCM.AWGInt2FallRBV.Physics2HWFcn = 1;
AO.HCM.AWGInt2FallRBV.Units = 'Hardware';
AO.HCM.AWGInt2FallRBV.HWUnits      = '';
AO.HCM.AWGInt2FallRBV.PhysicsUnits = '';


for i = 1:size(AO.HCM.DeviceList)
    AO.HCM.Setpoint.ChannelNames(i,:)       = sprintf('irm:%03d:DAC%d',      a(i,1), a(i,2));
    AO.HCM.Monitor.ChannelNames(i,:)        = sprintf('irm:%03d:ADC%d',      a(i,1), a(i,3));
    AO.HCM.OnControl.ChannelNames(i,:)      = sprintf('irm:%03d:B%02dOut',   a(i,1), a(i,4));
    AO.HCM.On.ChannelNames(i,:)             = sprintf('irm:%03d:B%02dRBV',   a(i,1), a(i,5));
    AO.HCM.Ready.ChannelNames(i,:)          = sprintf('irm:%03d:B%02dRBV'  , a(i,1), a(i,6));
    AO.HCM.RampRate.ChannelNames(i,:)       = sprintf('irm:%03d:SlewRate%d', a(i,1), a(i,2));
    
    AO.HCM.AWGPattern.ChannelNames(i,:)     = sprintf('irm:%03d:AWG%d:pattern',     a(i,1), a(i,2));
    AO.HCM.AWGTrigMode.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:TrigMode',    a(i,1), a(i,2));
    AO.HCM.AWGArm.ChannelNames(i,:)         = sprintf('irm:%03d:AWG%d:Arm',         a(i,1), a(i,2));
    AO.HCM.AWGEnable.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:Enable',      a(i,1), a(i,2));
    AO.HCM.AWGActive.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ActiveRBV',   a(i,1), a(i,2));
    AO.HCM.AWGTrigModeRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:TrigModeRBV', a(i,1), a(i,2));
    AO.HCM.AWGArmRBV.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ArmRBV',      a(i,1), a(i,2));
    AO.HCM.AWGEnableRBV.ChannelNames(i,:)   = sprintf('irm:%03d:AWG%d:EnableRBV',   a(i,1), a(i,2));
    
    AO.HCM.AWGInt1Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Rise',    a(i,1), a(i,2));
    AO.HCM.AWGInt2Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Rise',    a(i,1), a(i,2));
    AO.HCM.AWGInt1Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Fall',    a(i,1), a(i,2));
    AO.HCM.AWGInt2Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Fall',    a(i,1), a(i,2));    
    
    AO.HCM.AWGInt1RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1RiseRBV', a(i,1), a(i,2));
    AO.HCM.AWGInt2RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2RiseRBV', a(i,1), a(i,2));
    AO.HCM.AWGInt1FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1FallRBV', a(i,1), a(i,2));
    AO.HCM.AWGInt2FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2FallRBV', a(i,1), a(i,2));    
end


% VCM
AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = FourPerSectorList;
AO.VCM.ElementList = [1:size(AO.VCM.DeviceList,1)]';
AO.VCM.Status = ones(size(AO.VCM.DeviceList,1),1);
%AO.VCM.Status = [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0]';

AO.VCM.BaseName = [
    'BR1:VCM1'
    'BR1:VCM2'
    'BR1:VCM3'
    'BR1:VCM4'
    'BR2:VCM1'
    'BR2:VCM2'
    'BR2:VCM3'
    'BR2:VCM4'
    'BR3:VCM1'
    'BR3:VCM2'
    'BR3:VCM3'
    'BR3:VCM4'
    'BR4:VCM1'
    'BR4:VCM2'
    'BR4:VCM3'
    'BR4:VCM4'
    ];

%   IRM  SP  AM OnBC OnBM Rdy
a = [
    113  00  00  22   01   00
    113  01  03  23   03   02
    114  00  00  22   01   00
    114  01  03  23   03   02
    
    117  00  00  22   01   00
    117  01  03  23   03   02
    118  00  00  22   01   00
    118  01  03  23   03   02
    
    121  00  00  22   01   00
    121  01  03  23   03   02
    122  00  00  22   01   00
    122  01  03  23   03   02
    
    125  00  00  22   01   00
    125  01  03  23   03   02
    126  00  00  22   01   00
    126  01  03  23   03   02
    ];

AO.VCM.IRM = a(:,1);

AO.VCM.Monitor.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = '';
AO.VCM.Monitor.HW2PhysicsFcn = @booster2at;
AO.VCM.Monitor.Physics2HWFcn = @at2booster;
AO.VCM.Monitor.Units = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = '';
AO.VCM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2booster;
AO.VCM.Setpoint.Units = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';

AO.VCM.RampRate.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint';'Save/Restore';};
AO.VCM.RampRate.Mode = 'Simulator';
AO.VCM.RampRate.DataType = 'Scalar';
AO.VCM.RampRate.ChannelNames = '';
AO.VCM.RampRate.HW2PhysicsParams = 1;
AO.VCM.RampRate.Physics2HWParams = 1;
AO.VCM.RampRate.Units = 'Hardware';
AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.VCM.OnControl.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = '';
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';
AO.VCM.OnControl.Range = [0 1];
AO.VCM.OnControl.Tolerance = .5;    

AO.VCM.On.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor';};
AO.VCM.On.Mode = 'Simulator';
AO.VCM.On.DataType = 'Scalar';
AO.VCM.On.ChannelNames = '';
AO.VCM.On.HW2PhysicsParams = 1;
AO.VCM.On.Physics2HWParams = 1;
AO.VCM.On.Units = 'Hardware';
AO.VCM.On.HWUnits      = '';
AO.VCM.On.PhysicsUnits = '';

AO.VCM.Ready.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = '';
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';

% Setpoint waveform (1400 points) 
AO.VCM.AWGPattern.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Waveform'; 'AWG'};
AO.VCM.AWGPattern.Mode = 'Simulator';
AO.VCM.AWGPattern.DataType = 'Scalar';
AO.VCM.AWGPattern.ChannelNames = '';
AO.VCM.AWGPattern.HW2PhysicsFcn = @booster2at;
AO.VCM.AWGPattern.Physics2HWFcn = @at2booster;
AO.VCM.AWGPattern.Units = 'Hardware';
AO.VCM.AWGPattern.HWUnits      = 'Ampere or Counts?';
AO.VCM.AWGPattern.PhysicsUnits = 'Radian';

%  Auto-Rearm/Single (1/0)
AO.VCM.AWGTrigMode.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGTrigMode.Mode = 'Simulator';
AO.VCM.AWGTrigMode.DataType = 'Scalar';
AO.VCM.AWGTrigMode.ChannelNames = '';
AO.VCM.AWGTrigMode.HW2PhysicsFcn = 1;
AO.VCM.AWGTrigMode.Physics2HWFcn = 1;
AO.VCM.AWGTrigMode.Units = 'Hardware';
AO.VCM.AWGTrigMode.HWUnits      = '';
AO.VCM.AWGTrigMode.PhysicsUnits = '';

% Armed/Disarmed (1/0)
AO.VCM.AWGArm.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGArm.Mode = 'Simulator';
AO.VCM.AWGArm.DataType = 'Scalar';
AO.VCM.AWGArm.ChannelNames = '';
AO.VCM.AWGArm.HW2PhysicsFcn = 1;
AO.VCM.AWGArm.Physics2HWFcn = 1;
AO.VCM.AWGArm.Units = 'Hardware';
AO.VCM.AWGArm.HWUnits      = '';
AO.VCM.AWGArm.PhysicsUnits = '';

AO.VCM.AWGEnable.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGEnable.Mode = 'Simulator';
AO.VCM.AWGEnable.DataType = 'Scalar';
AO.VCM.AWGEnable.ChannelNames = '';
AO.VCM.AWGEnable.HW2PhysicsFcn = 1;
AO.VCM.AWGEnable.Physics2HWFcn = 1;
AO.VCM.AWGEnable.Units = 'Hardware';
AO.VCM.AWGEnable.HWUnits      = '';
AO.VCM.AWGEnable.PhysicsUnits = '';

% Active/Idle (1/0)
AO.VCM.AWGActive.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGActive.Mode = 'Simulator';
AO.VCM.AWGActive.DataType = 'Scalar';
AO.VCM.AWGActive.ChannelNames = '';
AO.VCM.AWGActive.HW2PhysicsFcn = 1;
AO.VCM.AWGActive.Physics2HWFcn = 1;
AO.VCM.AWGActive.Units = 'Hardware';
AO.VCM.AWGActive.HWUnits      = '';
AO.VCM.AWGActive.PhysicsUnits = '';

AO.VCM.AWGTrigModeRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGTrigModeRBV.Mode = 'Simulator';
AO.VCM.AWGTrigModeRBV.DataType = 'Scalar';
AO.VCM.AWGTrigModeRBV.ChannelNames = '';
AO.VCM.AWGTrigModeRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGTrigModeRBV.Physics2HWFcn = 1;
AO.VCM.AWGTrigModeRBV.Units = 'Hardware';
AO.VCM.AWGTrigModeRBV.HWUnits      = '';
AO.VCM.AWGTrigModeRBV.PhysicsUnits = '';

AO.VCM.AWGArmRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGArmRBV.Mode = 'Simulator';
AO.VCM.AWGArmRBV.DataType = 'Scalar';
AO.VCM.AWGArmRBV.ChannelNames = '';
AO.VCM.AWGArmRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGArmRBV.Physics2HWFcn = 1;
AO.VCM.AWGArmRBV.Units = 'Hardware';
AO.VCM.AWGArmRBV.HWUnits      = '';
AO.VCM.AWGArmRBV.PhysicsUnits = '';

AO.VCM.AWGEnableRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGEnableRBV.Mode = 'Simulator';
AO.VCM.AWGEnableRBV.DataType = 'Scalar';
AO.VCM.AWGEnableRBV.ChannelNames = '';
AO.VCM.AWGEnableRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGEnableRBV.Physics2HWFcn = 1;
AO.VCM.AWGEnableRBV.Units = 'Hardware';
AO.VCM.AWGEnableRBV.HWUnits      = '';
AO.VCM.AWGEnableRBV.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.VCM.AWGInt1Rise.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGInt1Rise.Mode = 'Simulator';
AO.VCM.AWGInt1Rise.DataType = 'Scalar';
AO.VCM.AWGInt1Rise.ChannelNames = '';
AO.VCM.AWGInt1Rise.HW2PhysicsFcn = 1;
AO.VCM.AWGInt1Rise.Physics2HWFcn = 1;
AO.VCM.AWGInt1Rise.Units = 'Hardware';
AO.VCM.AWGInt1Rise.HWUnits      = '';
AO.VCM.AWGInt1Rise.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.VCM.AWGInt2Rise.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGInt2Rise.Mode = 'Simulator';
AO.VCM.AWGInt2Rise.DataType = 'Scalar';
AO.VCM.AWGInt2Rise.ChannelNames = '';
AO.VCM.AWGInt2Rise.HW2PhysicsFcn = 1;
AO.VCM.AWGInt2Rise.Physics2HWFcn = 1;
AO.VCM.AWGInt2Rise.Units = 'Hardware';
AO.VCM.AWGInt2Rise.HWUnits      = '';
AO.VCM.AWGInt2Rise.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.VCM.AWGInt1Fall.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGInt1Fall.Mode = 'Simulator';
AO.VCM.AWGInt1Fall.DataType = 'Scalar';
AO.VCM.AWGInt1Fall.ChannelNames = '';
AO.VCM.AWGInt1Fall.HW2PhysicsFcn = 1;
AO.VCM.AWGInt1Fall.Physics2HWFcn = 1;
AO.VCM.AWGInt1Fall.Units = 'Hardware';
AO.VCM.AWGInt1Fall.HWUnits      = '';
AO.VCM.AWGInt1Fall.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.VCM.AWGInt2Fall.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.VCM.AWGInt2Fall.Mode = 'Simulator';
AO.VCM.AWGInt2Fall.DataType = 'Scalar';
AO.VCM.AWGInt2Fall.ChannelNames = '';
AO.VCM.AWGInt2Fall.HW2PhysicsFcn = 1;
AO.VCM.AWGInt2Fall.Physics2HWFcn = 1;
AO.VCM.AWGInt2Fall.Units = 'Hardware';
AO.VCM.AWGInt2Fall.HWUnits      = '';
AO.VCM.AWGInt2Fall.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.VCM.AWGInt1RiseRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGInt1RiseRBV.Mode = 'Simulator';
AO.VCM.AWGInt1RiseRBV.DataType = 'Scalar';
AO.VCM.AWGInt1RiseRBV.ChannelNames = '';
AO.VCM.AWGInt1RiseRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGInt1RiseRBV.Physics2HWFcn = 1;
AO.VCM.AWGInt1RiseRBV.Units = 'Hardware';
AO.VCM.AWGInt1RiseRBV.HWUnits      = '';
AO.VCM.AWGInt1RiseRBV.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.VCM.AWGInt2RiseRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGInt2RiseRBV.Mode = 'Simulator';
AO.VCM.AWGInt2RiseRBV.DataType = 'Scalar';
AO.VCM.AWGInt2RiseRBV.ChannelNames = '';
AO.VCM.AWGInt2RiseRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGInt2RiseRBV.Physics2HWFcn = 1;
AO.VCM.AWGInt2RiseRBV.Units = 'Hardware';
AO.VCM.AWGInt2RiseRBV.HWUnits      = '';
AO.VCM.AWGInt2RiseRBV.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.VCM.AWGInt1FallRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGInt1FallRBV.Mode = 'Simulator';
AO.VCM.AWGInt1FallRBV.DataType = 'Scalar';
AO.VCM.AWGInt1FallRBV.ChannelNames = '';
AO.VCM.AWGInt1FallRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGInt1FallRBV.Physics2HWFcn = 1;
AO.VCM.AWGInt1FallRBV.Units = 'Hardware';
AO.VCM.AWGInt1FallRBV.HWUnits      = '';
AO.VCM.AWGInt1FallRBV.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.VCM.AWGInt2FallRBV.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.VCM.AWGInt2FallRBV.Mode = 'Simulator';
AO.VCM.AWGInt2FallRBV.DataType = 'Scalar';
AO.VCM.AWGInt2FallRBV.ChannelNames = '';
AO.VCM.AWGInt2FallRBV.HW2PhysicsFcn = 1;
AO.VCM.AWGInt2FallRBV.Physics2HWFcn = 1;
AO.VCM.AWGInt2FallRBV.Units = 'Hardware';
AO.VCM.AWGInt2FallRBV.HWUnits      = '';
AO.VCM.AWGInt2FallRBV.PhysicsUnits = '';

for i = 1:size(AO.VCM.DeviceList)
    AO.VCM.Setpoint.ChannelNames(i,:)  = sprintf('irm:%03d:DAC%d',      a(i,1), a(i,2));
    AO.VCM.Monitor.ChannelNames(i,:)   = sprintf('irm:%03d:ADC%d',      a(i,1), a(i,3));
    AO.VCM.OnControl.ChannelNames(i,:) = sprintf('irm:%03d:B%02dOut',   a(i,1), a(i,4));
    AO.VCM.On.ChannelNames(i,:)        = sprintf('irm:%03d:B%02dRBV',   a(i,1), a(i,5));
    AO.VCM.Ready.ChannelNames(i,:)     = sprintf('irm:%03d:B%02dRBV',   a(i,1), a(i,6));
    AO.VCM.RampRate.ChannelNames(i,:)  = sprintf('irm:%03d:SlewRate%d', a(i,1), a(i,2));
    
    AO.VCM.AWGPattern.ChannelNames(i,:)     = sprintf('irm:%03d:AWG%d:pattern',     a(i,1), a(i,2));
    AO.VCM.AWGTrigMode.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:TrigMode',    a(i,1), a(i,2));
    AO.VCM.AWGArm.ChannelNames(i,:)         = sprintf('irm:%03d:AWG%d:Arm',         a(i,1), a(i,2));
    AO.VCM.AWGEnable.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:Enable',      a(i,1), a(i,2));
    AO.VCM.AWGActive.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ActiveRBV',   a(i,1), a(i,2));
    AO.VCM.AWGTrigModeRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:TrigModeRBV', a(i,1), a(i,2));
    AO.VCM.AWGArmRBV.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ArmRBV',      a(i,1), a(i,2));
    AO.VCM.AWGEnableRBV.ChannelNames(i,:)   = sprintf('irm:%03d:AWG%d:EnableRBV',   a(i,1), a(i,2));
    
    AO.VCM.AWGInt1Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Rise',    a(i,1), a(i,2));
    AO.VCM.AWGInt2Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Rise',    a(i,1), a(i,2));
    AO.VCM.AWGInt1Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Fall',    a(i,1), a(i,2));
    AO.VCM.AWGInt2Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Fall',    a(i,1), a(i,2));    
    
    AO.VCM.AWGInt1RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1RiseRBV', a(i,1), a(i,2));
    AO.VCM.AWGInt2RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2RiseRBV', a(i,1), a(i,2));
    AO.VCM.AWGInt1FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1FallRBV', a(i,1), a(i,2));
    AO.VCM.AWGInt2FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2FallRBV', a(i,1), a(i,2));    
end



AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'};
AO.QF.DeviceList = EightPerSectorList;
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status = ones(size(AO.QF.DeviceList,1),1);

AO.QF.Monitor.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Monitor';};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_booster(AO.QF.FamilyName, 'Monitor');
AO.QF.Monitor.HW2PhysicsFcn = @booster2at;
AO.QF.Monitor.Physics2HWFcn = @at2booster;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Setpoint';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_booster(AO.QF.FamilyName, 'Setpoint');
AO.QF.Setpoint.HW2PhysicsFcn = @booster2at;
AO.QF.Setpoint.Physics2HWFcn = @at2booster;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QF.IDN.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Char';};
AO.QF.IDN.Mode = 'Simulator';
AO.QF.IDN.DataType = 'Char';
AO.QF.IDN.ChannelNames = 'BR1:QF_IDN';
AO.QF.IDN.HW2PhysicsParams = 1;
AO.QF.IDN.Physics2HWParams = 1;
AO.QF.IDN.Units = 'Hardware';
AO.QF.IDN.HWUnits      = '';
AO.QF.IDN.PhysicsUnits = '';

AO.QF.On.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Boolean Monitor';};
AO.QF.On.Mode = 'Simulator';
AO.QF.On.DataType = 'Scalar';
AO.QF.On.ChannelNames = getname_booster('QF', 'On');
AO.QF.On.HW2PhysicsParams = 1;
AO.QF.On.Physics2HWParams = 1;
AO.QF.On.Units = 'Hardware';
AO.QF.On.HWUnits      = '';
AO.QF.On.PhysicsUnits = '';

AO.QF.OnControl.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Boolean Control';};
AO.QF.OnControl.Mode = 'Simulator';
AO.QF.OnControl.DataType = 'Scalar';
AO.QF.OnControl.ChannelNames = getname_booster('QF', 'OnControl');
AO.QF.OnControl.HW2PhysicsParams = 1;
AO.QF.OnControl.Physics2HWParams = 1;
AO.QF.OnControl.Units = 'Hardware';
AO.QF.OnControl.HWUnits      = '';
AO.QF.OnControl.PhysicsUnits = '';
AO.QF.OnControl.Range = [0 1];
AO.QF.OnControl.Tolerance = .5;    

AO.QF.EnableDAC.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Boolean Control';};
AO.QF.EnableDAC.Mode = 'Simulator';
AO.QF.EnableDAC.DataType = 'Scalar';
AO.QF.EnableDAC.ChannelNames = getname_booster('QF', 'EnableDAC');
AO.QF.EnableDAC.HW2PhysicsParams = 1;
AO.QF.EnableDAC.Physics2HWParams = 1;
AO.QF.EnableDAC.Units = 'Hardware';
AO.QF.EnableDAC.HWUnits      = '';
AO.QF.EnableDAC.PhysicsUnits = '';
AO.QF.EnableDAC.Range = [0 1];
AO.QF.EnableDAC.Tolerance = .5;    

AO.QF.EnableRamp.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Boolean Control';};
AO.QF.EnableRamp.Mode = 'Simulator';
AO.QF.EnableRamp.DataType = 'Scalar';
AO.QF.EnableRamp.ChannelNames = getname_booster('QF', 'EnableRamp');
AO.QF.EnableRamp.HW2PhysicsParams = 1;
AO.QF.EnableRamp.Physics2HWParams = 1;
AO.QF.EnableRamp.Units = 'Hardware';
AO.QF.EnableRamp.HWUnits      = '';
AO.QF.EnableRamp.PhysicsUnits = '';
AO.QF.EnableRamp.Range = [0 1];
AO.QF.EnableRamp.Tolerance = .5;    

AO.QF.Gain.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Setpoint'; 'Save';};
AO.QF.Gain.Mode = 'Simulator';
AO.QF.Gain.DataType = 'Scalar';
AO.QF.Gain.ChannelNames = getname_booster('QF', 'Gain');
AO.QF.Gain.HW2PhysicsParams = 1;
AO.QF.Gain.Physics2HWParams = 1;
AO.QF.Gain.Units = 'Hardware';
AO.QF.Gain.HWUnits      = '';
AO.QF.Gain.PhysicsUnits = '';
AO.QF.Gain.Range = [0 2];
AO.QF.Gain.Tolerance = .5;    

AO.QF.Offset.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Setpoint'; 'Save/Restore';};
AO.QF.Offset.Mode = 'Simulator';
AO.QF.Offset.DataType = 'Scalar';
AO.QF.Offset.ChannelNames = getname_booster('QF', 'Offset');
AO.QF.Offset.HW2PhysicsParams = 1;
AO.QF.Offset.Physics2HWParams = 1;
AO.QF.Offset.Units = 'Hardware';
AO.QF.Offset.HWUnits      = '';
AO.QF.Offset.PhysicsUnits = '';
AO.QF.Offset.Range = [0 2];
AO.QF.Offset.Tolerance = .5;    

% AO.QF.Enable.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF';};
% AO.QF.Enable.Mode = 'Simulator';
% AO.QF.Enable.DataType = 'Scalar';
% AO.QF.Enable.ChannelNames = getname_booster('QF', 'Enable');
% AO.QF.Enable.HW2PhysicsParams = 1;
% AO.QF.Enable.Physics2HWParams = 1;
% AO.QF.Enable.Units = 'Hardware';
% AO.QF.Enable.HWUnits      = '';
% AO.QF.Enable.PhysicsUnits = '';
% AO.QF.Enable.Range        = [0 1];

AO.QF.Ready.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QF'; 'Boolean Monitor';};
AO.QF.Ready.Mode = 'Simulator';
AO.QF.Ready.DataType = 'Scalar';
AO.QF.Ready.ChannelNames = getname_booster('QF', 'Ready');
AO.QF.Ready.HW2PhysicsParams = 1;
AO.QF.Ready.Physics2HWParams = 1;
AO.QF.Ready.Units = 'Hardware';
AO.QF.Ready.HWUnits      = '';
AO.QF.Ready.PhysicsUnits = '';

AO.QF.RampTable.MemberOf = {'QUAD'; 'Magnet'; 'QF';};
AO.QF.RampTable.Mode = 'Simulator';
AO.QF.RampTable.DataType = 'Scalar';
AO.QF.RampTable.SpecialFunctionGet = @getsp_RampTable;
AO.QF.RampTable.SpecialFunctionSet = @setsp_RampTable;
AO.QF.RampTable.HW2PhysicsFcn = @booster2at;
AO.QF.RampTable.Physics2HWFcn = @at2booster;
AO.QF.RampTable.Units = 'Hardware';
AO.QF.RampTable.HWUnits      = 'Ampere';
AO.QF.RampTable.PhysicsUnits = '1/Meter^2';

AO.QF.DVM.MemberOf = {};
AO.QF.DVM.Mode = 'Simulator';
AO.QF.DVM.DataType = 'Scalar';
AO.QF.DVM.SpecialFunctionGet = @getam_DVM;
AO.QF.DVM.HW2PhysicsFcn = @booster2at;
AO.QF.DVM.Physics2HWFcn = @at2booster;
AO.QF.DVM.Units = 'Hardware';
AO.QF.DVM.HWUnits      = 'Ampere';
AO.QF.DVM.PhysicsUnits = '1/Meter^2';

AO.QF.ILCTrim.MemberOf = {};
AO.QF.ILCTrim.Mode = 'Simulator';
AO.QF.ILCTrim.DataType = 'Scalar';
AO.QF.ILCTrim.SpecialFunctionGet = @getsp_ILCTrimQF;
AO.QF.ILCTrim.SpecialFunctionSet = @setsp_ILCTrimQF;
AO.QF.ILCTrim.HW2PhysicsFcn = @booster2at;
AO.QF.ILCTrim.Physics2HWFcn = @at2booster;
AO.QF.ILCTrim.Units = 'Hardware';
AO.QF.ILCTrim.HWUnits      = 'Ampere';
AO.QF.ILCTrim.PhysicsUnits = '1/Meter^2';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD';};
AO.QD.DeviceList = EightPerSectorList;
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status = ones(size(AO.QD.DeviceList,1),1);

AO.QD.Monitor.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Monitor';};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_booster(AO.QD.FamilyName, 'Monitor');
AO.QD.Monitor.HW2PhysicsFcn = @booster2at;
AO.QD.Monitor.Physics2HWFcn = @at2booster;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Setpoint';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_booster(AO.QD.FamilyName, 'Setpoint');
AO.QD.Setpoint.HW2PhysicsFcn = @booster2at;
AO.QD.Setpoint.Physics2HWFcn = @at2booster;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QD.On.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD';};
AO.QD.On.Mode = 'Simulator';
AO.QD.On.DataType = 'Scalar';
AO.QD.On.ChannelNames = getname_booster('QD', 'On');
AO.QD.On.HW2PhysicsParams = 1;
AO.QD.On.Physics2HWParams = 1;
AO.QD.On.Units = 'Hardware';
AO.QD.On.HWUnits      = '';
AO.QD.On.PhysicsUnits = '';

AO.QD.OnControl.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD';};
AO.QD.OnControl.Mode = 'Simulator';
AO.QD.OnControl.DataType = 'Scalar';
AO.QD.OnControl.ChannelNames = getname_booster('QD', 'OnControl');
AO.QD.OnControl.HW2PhysicsParams = 1;
AO.QD.OnControl.Physics2HWParams = 1;
AO.QD.OnControl.Units = 'Hardware';
AO.QD.OnControl.HWUnits      = '';
AO.QD.OnControl.PhysicsUnits = '';
AO.QD.OnControl.Range = [0 1];
AO.QD.OnControl.Tolerance = .5;    

AO.QD.EnableDAC.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Boolean Control';};
AO.QD.EnableDAC.Mode = 'Simulator';
AO.QD.EnableDAC.DataType = 'Scalar';
AO.QD.EnableDAC.ChannelNames = getname_booster('QD', 'EnableDAC');
AO.QD.EnableDAC.HW2PhysicsParams = 1;
AO.QD.EnableDAC.Physics2HWParams = 1;
AO.QD.EnableDAC.Units = 'Hardware';
AO.QD.EnableDAC.HWUnits      = '';
AO.QD.EnableDAC.PhysicsUnits = '';
AO.QD.EnableDAC.Range = [0 1];
AO.QD.EnableDAC.Tolerance = .5;    

AO.QD.EnableRamp.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Boolean Control';};
AO.QD.EnableRamp.Mode = 'Simulator';
AO.QD.EnableRamp.DataType = 'Scalar';
AO.QD.EnableRamp.ChannelNames = getname_booster('QD', 'EnableRamp');
AO.QD.EnableRamp.HW2PhysicsParams = 1;
AO.QD.EnableRamp.Physics2HWParams = 1;
AO.QD.EnableRamp.Units = 'Hardware';
AO.QD.EnableRamp.HWUnits      = '';
AO.QD.EnableRamp.PhysicsUnits = '';
AO.QD.EnableRamp.Range = [0 1];
AO.QD.EnableRamp.Tolerance = .5;    

AO.QD.Gain.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Setpoint'; 'Save';};
AO.QD.Gain.Mode = 'Simulator';
AO.QD.Gain.DataType = 'Scalar';
AO.QD.Gain.ChannelNames = getname_booster('QD', 'Gain');
AO.QD.Gain.HW2PhysicsParams = 1;
AO.QD.Gain.Physics2HWParams = 1;
AO.QD.Gain.Units = 'Hardware';
AO.QD.Gain.HWUnits      = '';
AO.QD.Gain.PhysicsUnits = '';
AO.QD.Gain.Range = [0 2];
AO.QD.Gain.Tolerance = .5;    

AO.QD.Offset.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD'; 'Setpoint'; 'Save/Restore';};
AO.QD.Offset.Mode = 'Simulator';
AO.QD.Offset.DataType = 'Scalar';
AO.QD.Offset.ChannelNames = getname_booster('QD', 'Offset');
AO.QD.Offset.HW2PhysicsParams = 1;
AO.QD.Offset.Physics2HWParams = 1;
AO.QD.Offset.Units = 'Hardware';
AO.QD.Offset.HWUnits      = '';
AO.QD.Offset.PhysicsUnits = '';
AO.QD.Offset.Range = [0 2];
AO.QD.Offset.Tolerance = .5;    

% AO.QD.Enable.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD';};
% AO.QD.Enable.Mode = 'Simulator';
% AO.QD.Enable.DataType = 'Scalar';
% AO.QD.Enable.ChannelNames = getname_booster('QD', 'Enable');
% AO.QD.Enable.HW2PhysicsParams = 1;
% AO.QD.Enable.Physics2HWParams = 1;
% AO.QD.Enable.Units = 'Hardware';
% AO.QD.Enable.HWUnits      = '';
% AO.QD.Enable.PhysicsUnits = '';
% AO.QD.Enable.Range        = [0 1];

AO.QD.Ready.MemberOf = {'PlotFamily'; 'QUAD'; 'Magnet'; 'QD';};
AO.QD.Ready.Mode = 'Simulator';
AO.QD.Ready.DataType = 'Scalar';
AO.QD.Ready.ChannelNames = getname_booster('QD', 'Ready');
AO.QD.Ready.HW2PhysicsParams = 1;
AO.QD.Ready.Physics2HWParams = 1;
AO.QD.Ready.Units = 'Hardware';
AO.QD.Ready.HWUnits      = '';
AO.QD.Ready.PhysicsUnits = '';

AO.QD.RampTable.MemberOf = {'QUAD'; 'Magnet'; 'QD';};
AO.QD.RampTable.Mode = 'Simulator';
AO.QD.RampTable.DataType = 'Scalar';
AO.QD.RampTable.SpecialFunctionGet = @getsp_RampTable;
AO.QD.RampTable.SpecialFunctionSet = @setsp_RampTable;
AO.QD.RampTable.HW2PhysicsFcn = @booster2at;
AO.QD.RampTable.Physics2HWFcn = @at2booster;
AO.QD.RampTable.Units = 'Hardware';
AO.QD.RampTable.HWUnits      = 'Ampere';
AO.QD.RampTable.PhysicsUnits = '1/Meter^2';

AO.QD.DVM.MemberOf = {'QUAD'; 'Magnet'; 'QD';};
AO.QD.DVM.Mode = 'Simulator';
AO.QD.DVM.DataType = 'Scalar';
AO.QD.DVM.SpecialFunctionGet = @getam_DVM;
AO.QD.DVM.HW2PhysicsFcn = @booster2at;
AO.QD.DVM.Physics2HWFcn = @at2booster;
AO.QD.DVM.Units = 'Hardware';
AO.QD.DVM.HWUnits      = 'Ampere';
AO.QD.DVM.PhysicsUnits = '1/Meter^2';

AO.QD.ILCTrim.MemberOf = {'QUAD'; 'Magnet'; 'QD';};
AO.QD.ILCTrim.Mode = 'Simulator';
AO.QD.ILCTrim.DataType = 'Scalar';
AO.QD.ILCTrim.SpecialFunctionGet = @getsp_ILCTrimQD;
AO.QD.ILCTrim.SpecialFunctionSet = @setsp_ILCTrimQD;
AO.QD.ILCTrim.HW2PhysicsFcn = @booster2at;
AO.QD.ILCTrim.Physics2HWFcn = @at2booster;
AO.QD.ILCTrim.Units = 'Hardware';
AO.QD.ILCTrim.HWUnits      = 'Ampere';
AO.QD.ILCTrim.PhysicsUnits = '1/Meter^2';


AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status = ones(size(AO.SF.DeviceList,1),1);

AO.SF.Monitor.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'; 'Monitor';};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_booster(AO.SF.FamilyName, 'Monitor');
AO.SF.Monitor.HW2PhysicsFcn = @booster2at;
AO.SF.Monitor.Physics2HWFcn = @at2booster;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^2';

AO.SF.Setpoint.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'; 'Setpoint';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_booster(AO.SF.FamilyName, 'Setpoint');
AO.SF.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SF.Setpoint.Physics2HWFcn = @at2booster;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^2';

% AO.SF.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.SF.RampRate.Mode = 'Simulator';
% AO.SF.RampRate.DataType = 'Scalar';
% AO.SF.RampRate.ChannelNames = getname_booster('SF', 'RampRate');
% AO.SF.RampRate.HW2PhysicsFcn = @booster2at;
% AO.SF.RampRate.Physics2HWFcn = @at2booster;
% AO.SF.RampRate.Units = 'Hardware';
% AO.SF.RampRate.HWUnits      = 'Ampere/Second';
% AO.SF.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.SF.TimeConstant.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.SF.TimeConstant.Mode = 'Simulator';
% AO.SF.TimeConstant.DataType = 'Scalar';
% AO.SF.TimeConstant.ChannelNames = getname_booster('SF', 'TimeConstant');
% AO.SF.TimeConstant.HW2PhysicsParams = 1;
% AO.SF.TimeConstant.Physics2HWParams = 1;
% AO.SF.TimeConstant.Units = 'Hardware';
% AO.SF.TimeConstant.HWUnits      = 'Second';
% AO.SF.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.SF.DAC.MemberOf = {'PlotFamily';};
% AO.SF.DAC.Mode = 'Simulator';
% AO.SF.DAC.DataType = 'Scalar';
% AO.SF.DAC.ChannelNames = getname_booster('SF', 'DAC');
% AO.SF.DAC.HW2PhysicsParams = 1;
% AO.SF.DAC.Physics2HWParams = 1;
% AO.SF.DAC.Units = 'Hardware';
% AO.SF.DAC.HWUnits      = 'Ampere';
% AO.SF.DAC.PhysicsUnits = 'Ampere';


AO.SF.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SF.On.Mode = 'Simulator';
AO.SF.On.DataType = 'Scalar';
AO.SF.On.ChannelNames = getname_booster('SF', 'On');
AO.SF.On.HW2PhysicsParams = 1;
AO.SF.On.Physics2HWParams = 1;
AO.SF.On.Units = 'Hardware';
AO.SF.On.HWUnits      = '';
AO.SF.On.PhysicsUnits = '';

AO.SF.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SF.OnControl.Mode = 'Simulator';
AO.SF.OnControl.DataType = 'Scalar';
AO.SF.OnControl.ChannelNames = getname_booster('SF', 'OnControl');
AO.SF.OnControl.HW2PhysicsParams = 1;
AO.SF.OnControl.Physics2HWParams = 1;
AO.SF.OnControl.Units = 'Hardware';
AO.SF.OnControl.HWUnits      = '';
AO.SF.OnControl.PhysicsUnits = '';
AO.SF.OnControl.Range = [0 1];
AO.SF.OnControl.Tolerance = .5;    

AO.SF.EnableDAC.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SF.EnableDAC.Mode = 'Simulator';
AO.SF.EnableDAC.DataType = 'Scalar';
AO.SF.EnableDAC.ChannelNames = getname_booster('SF', 'EnableDAC');
AO.SF.EnableDAC.HW2PhysicsParams = 1;
AO.SF.EnableDAC.Physics2HWParams = 1;
AO.SF.EnableDAC.Units = 'Hardware';
AO.SF.EnableDAC.HWUnits      = '';
AO.SF.EnableDAC.PhysicsUnits = '';
AO.SF.EnableDAC.Range = [0 1];
AO.SF.EnableDAC.Tolerance = .5;    

AO.SF.EnableRamp.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SF.EnableRamp.Mode = 'Simulator';
AO.SF.EnableRamp.DataType = 'Scalar';
AO.SF.EnableRamp.ChannelNames = getname_booster('SF', 'EnableRamp');
AO.SF.EnableRamp.HW2PhysicsParams = 1;
AO.SF.EnableRamp.Physics2HWParams = 1;
AO.SF.EnableRamp.Units = 'Hardware';
AO.SF.EnableRamp.HWUnits      = '';
AO.SF.EnableRamp.PhysicsUnits = '';
AO.SF.EnableRamp.Range = [0 1];
AO.SF.EnableRamp.Tolerance = .5;    

AO.SF.Gain.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
AO.SF.Gain.Mode = 'Simulator';
AO.SF.Gain.DataType = 'Scalar';
AO.SF.Gain.ChannelNames = getname_booster('SF', 'Gain');
AO.SF.Gain.HW2PhysicsParams = 1;
AO.SF.Gain.Physics2HWParams = 1;
AO.SF.Gain.Units = 'Hardware';
AO.SF.Gain.HWUnits      = '';
AO.SF.Gain.PhysicsUnits = '';
AO.SF.Gain.Range = [0 2];
AO.SF.Gain.Tolerance = .5;    

% AO.SF.Offset.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
% AO.SF.Offset.Mode = 'Simulator';
% AO.SF.Offset.DataType = 'Scalar';
% AO.SF.Offset.ChannelNames = getname_booster('SF', 'Offset');
% AO.SF.Offset.HW2PhysicsParams = 1;
% AO.SF.Offset.Physics2HWParams = 1;
% AO.SF.Offset.Units = 'Hardware';
% AO.SF.Offset.HWUnits      = '';
% AO.SF.Offset.PhysicsUnits = '';

AO.SF.Ready.MemberOf = {'PlotFamily';};
AO.SF.Ready.Mode = 'Simulator';
AO.SF.Ready.DataType = 'Scalar';
AO.SF.Ready.ChannelNames = getname_booster('SF', 'Ready');
AO.SF.Ready.HW2PhysicsParams = 1;
AO.SF.Ready.Physics2HWParams = 1;
AO.SF.Ready.Units = 'Hardware';
AO.SF.Ready.HWUnits      = '';
AO.SF.Ready.PhysicsUnits = '';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'};
AO.SD.DeviceList = ThreePerSectorList;
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status = ones(size(AO.SD.DeviceList,1),1);

AO.SD.Monitor.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Monitor';};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_booster(AO.SD.FamilyName, 'Monitor');
AO.SD.Monitor.HW2PhysicsFcn = @booster2at;
AO.SD.Monitor.Physics2HWFcn = @at2booster;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^2';

AO.SD.Setpoint.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Setpoint';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_booster(AO.SD.FamilyName, 'Setpoint');
AO.SD.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SD.Setpoint.Physics2HWFcn = @at2booster;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^2';

% AO.SD.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.SD.RampRate.Mode = 'Simulator';
% AO.SD.RampRate.DataType = 'Scalar';
% AO.SD.RampRate.ChannelNames = getname_booster('SD', 'RampRate');
% AO.SD.RampRate.HW2PhysicsFcn = @booster2at;
% AO.SD.RampRate.Physics2HWFcn = @at2booster;
% AO.SD.RampRate.Units = 'Hardware';
% AO.SD.RampRate.HWUnits      = 'Ampere/Second';
% AO.SD.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.SD.TimeConstant.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.SD.TimeConstant.Mode = 'Simulator';
% AO.SD.TimeConstant.DataType = 'Scalar';
% AO.SD.TimeConstant.ChannelNames = getname_booster('SD', 'TimeConstant');
% AO.SD.TimeConstant.HW2PhysicsParams = 1;
% AO.SD.TimeConstant.Physics2HWParams = 1;
% AO.SD.TimeConstant.Units = 'Hardware';
% AO.SD.TimeConstant.HWUnits      = 'Second';
% AO.SD.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.SD.DAC.MemberOf = {'PlotFamily';};
% AO.SD.DAC.Mode = 'Simulator';
% AO.SD.DAC.DataType = 'Scalar';
% AO.SD.DAC.ChannelNames = getname_booster('SD', 'DAC');
% AO.SD.DAC.HW2PhysicsParams = 1;
% AO.SD.DAC.Physics2HWParams = 1;
% AO.SD.DAC.Units = 'Hardware';
% AO.SD.DAC.HWUnits      = 'Ampere';
% AO.SD.DAC.PhysicsUnits = 'Ampere';

AO.SD.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SD.On.Mode = 'Simulator';
AO.SD.On.DataType = 'Scalar';
AO.SD.On.ChannelNames = getname_booster('SD', 'On');
AO.SD.On.HW2PhysicsParams = 1;
AO.SD.On.Physics2HWParams = 1;
AO.SD.On.Units = 'Hardware';
AO.SD.On.HWUnits      = '';
AO.SD.On.PhysicsUnits = '';

AO.SD.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SD.OnControl.Mode = 'Simulator';
AO.SD.OnControl.DataType = 'Scalar';
AO.SD.OnControl.ChannelNames = getname_booster('SD', 'OnControl');
AO.SD.OnControl.HW2PhysicsParams = 1;
AO.SD.OnControl.Physics2HWParams = 1;
AO.SD.OnControl.Units = 'Hardware';
AO.SD.OnControl.HWUnits      = '';
AO.SD.OnControl.PhysicsUnits = '';
AO.SD.OnControl.Range = [0 1];
AO.SD.OnControl.Tolerance = .5;    

AO.SD.EnableDAC.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SD.EnableDAC.Mode = 'Simulator';
AO.SD.EnableDAC.DataType = 'Scalar';
AO.SD.EnableDAC.ChannelNames = getname_booster('SD', 'EnableDAC');
AO.SD.EnableDAC.HW2PhysicsParams = 1;
AO.SD.EnableDAC.Physics2HWParams = 1;
AO.SD.EnableDAC.Units = 'Hardware';
AO.SD.EnableDAC.HWUnits      = '';
AO.SD.EnableDAC.PhysicsUnits = '';
AO.SD.EnableDAC.Range = [0 1];
AO.SD.EnableDAC.Tolerance = .5;    

AO.SD.EnableRamp.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SD.EnableRamp.Mode = 'Simulator';
AO.SD.EnableRamp.DataType = 'Scalar';
AO.SD.EnableRamp.ChannelNames = getname_booster('SD', 'EnableRamp');
AO.SD.EnableRamp.HW2PhysicsParams = 1;
AO.SD.EnableRamp.Physics2HWParams = 1;
AO.SD.EnableRamp.Units = 'Hardware';
AO.SD.EnableRamp.HWUnits      = '';
AO.SD.EnableRamp.PhysicsUnits = '';
AO.SD.EnableRamp.Range = [0 1];
AO.SD.EnableRamp.Tolerance = .5;    

AO.SD.Gain.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
AO.SD.Gain.Mode = 'Simulator';
AO.SD.Gain.DataType = 'Scalar';
AO.SD.Gain.ChannelNames = getname_booster('SD', 'Gain');
AO.SD.Gain.HW2PhysicsParams = 1;
AO.SD.Gain.Physics2HWParams = 1;
AO.SD.Gain.Units = 'Hardware';
AO.SD.Gain.HWUnits      = '';
AO.SD.Gain.PhysicsUnits = '';
AO.SD.Gain.Range = [0 2];
AO.SD.Gain.Tolerance = .5;    

% AO.SD.Offset.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
% AO.SD.Offset.Mode = 'Simulator';
% AO.SD.Offset.DataType = 'Scalar';
% AO.SD.Offset.ChannelNames = getname_booster('SD', 'Offset');
% AO.SD.Offset.HW2PhysicsParams = 1;
% AO.SD.Offset.Physics2HWParams = 1;
% AO.SD.Offset.Units = 'Hardware';
% AO.SD.Offset.HWUnits      = '';
% AO.SD.Offset.PhysicsUnits = '';

AO.SD.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor'};
AO.SD.Ready.Mode = 'Simulator';
AO.SD.Ready.DataType = 'Scalar';
AO.SD.Ready.ChannelNames = getname_booster('SD', 'Ready');
AO.SD.Ready.HW2PhysicsParams = 1;
AO.SD.Ready.Physics2HWParams = 1;
AO.SD.Ready.Units = 'Hardware';
AO.SD.Ready.HWUnits      = '';
AO.SD.Ready.PhysicsUnits = '';



AO.SF_IRM.FamilyName = 'SF';
AO.SF_IRM.MemberOf   = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'};
AO.SF_IRM.DeviceList = TwoPerSectorList;
AO.SF_IRM.ElementList = (1:size(AO.SF_IRM.DeviceList,1))';
AO.SF_IRM.Status = ones(size(AO.SF_IRM.DeviceList,1),1);

AO.SF_IRM.BaseName = [
    'BR1:SF'
    'BR1:SF'
    'BR2:SF'
    'BR2:SF'
    'BR3:SF'
    'BR3:SF'
    'BR4:SF'
    'BR4:SF'
    ];

%   IRM  SP  AM OnBC OnBM Rdy
a = [
    129  00  00  22   01   00
    129  00  00  22   01   00
    
    130  00  00  22   01   00
    130  00  00  22   01   00
    
    131  00  00  22   01   00
    131  00  00  22   01   00
    
    132  00  00  22   01   00
    132  00  00  22   01   00
    ];

AO.SF_IRM.IRM = a(:,1);

AO.SF_IRM.Monitor.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'; 'Monitor';};
AO.SF_IRM.Monitor.Mode = 'Simulator';
AO.SF_IRM.Monitor.DataType = 'Scalar';
AO.SF_IRM.Monitor.ChannelNames = '';
AO.SF_IRM.Monitor.HW2PhysicsFcn = @booster2at;
AO.SF_IRM.Monitor.Physics2HWFcn = @at2booster;
AO.SF_IRM.Monitor.Units = 'Hardware';
AO.SF_IRM.Monitor.HWUnits      = 'Ampere';
AO.SF_IRM.Monitor.PhysicsUnits = '1/Meter^2';

AO.SF_IRM.Setpoint.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'; 'Setpoint';};
AO.SF_IRM.Setpoint.Mode = 'Simulator';
AO.SF_IRM.Setpoint.DataType = 'Scalar';
AO.SF_IRM.Setpoint.ChannelNames = '';
AO.SF_IRM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SF_IRM.Setpoint.Physics2HWFcn = @at2booster;
AO.SF_IRM.Setpoint.Units = 'Hardware';
AO.SF_IRM.Setpoint.HWUnits      = 'Ampere';
AO.SF_IRM.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SF_IRM.OnControl.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SF'; 'Boolean Control';};
AO.SF_IRM.OnControl.Mode = 'Simulator';
AO.SF_IRM.OnControl.DataType = 'Scalar';
AO.SF_IRM.OnControl.ChannelNames = '';
AO.SF_IRM.OnControl.HW2PhysicsParams = 1;
AO.SF_IRM.OnControl.Physics2HWParams = 1;
AO.SF_IRM.OnControl.Units = 'Hardware';
AO.SF_IRM.OnControl.HWUnits      = '';
AO.SF_IRM.OnControl.PhysicsUnits = '';
AO.SF_IRM.OnControl.Range = [0 1];
AO.SF_IRM.OnControl.Tolerance = .5;    

AO.SF_IRM.On.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor';};
AO.SF_IRM.On.Mode = 'Simulator';
AO.SF_IRM.On.DataType = 'Scalar';
AO.SF_IRM.On.ChannelNames = '';
AO.SF_IRM.On.HW2PhysicsParams = 1;
AO.SF_IRM.On.Physics2HWParams = 1;
AO.SF_IRM.On.Units = 'Hardware';
AO.SF_IRM.On.HWUnits      = '';
AO.SF_IRM.On.PhysicsUnits = '';

AO.SF_IRM.Ready.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor';};
AO.SF_IRM.Ready.Mode = 'Simulator';
AO.SF_IRM.Ready.DataType = 'Scalar';
AO.SF_IRM.Ready.ChannelNames = '';
AO.SF_IRM.Ready.HW2PhysicsParams = 1;
AO.SF_IRM.Ready.Physics2HWParams = 1;
AO.SF_IRM.Ready.Units = 'Hardware';
AO.SF_IRM.Ready.HWUnits      = 'Second';
AO.SF_IRM.Ready.PhysicsUnits = 'Second';

% Setpoint waveform (1400 points) 
AO.SF_IRM.AWGPattern.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Waveform'; 'AWG'};
AO.SF_IRM.AWGPattern.Mode = 'Simulator';
AO.SF_IRM.AWGPattern.DataType = 'Scalar';
AO.SF_IRM.AWGPattern.ChannelNames = '';
AO.SF_IRM.AWGPattern.HW2PhysicsFcn = @booster2at;
AO.SF_IRM.AWGPattern.Physics2HWFcn = @at2booster;
AO.SF_IRM.AWGPattern.Units = 'Hardware';
AO.SF_IRM.AWGPattern.HWUnits      = 'Ampere or Counts?';
AO.SF_IRM.AWGPattern.PhysicsUnits = 'Radian';

%  Auto-Rearm/Single (1/0)
AO.SF_IRM.AWGTrigMode.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGTrigMode.Mode = 'Simulator';
AO.SF_IRM.AWGTrigMode.DataType = 'Scalar';
AO.SF_IRM.AWGTrigMode.ChannelNames = '';
AO.SF_IRM.AWGTrigMode.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGTrigMode.Physics2HWFcn = 1;
AO.SF_IRM.AWGTrigMode.Units = 'Hardware';
AO.SF_IRM.AWGTrigMode.HWUnits      = '';
AO.SF_IRM.AWGTrigMode.PhysicsUnits = '';

% Armed/Disarmed (1/0)
AO.SF_IRM.AWGArm.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGArm.Mode = 'Simulator';
AO.SF_IRM.AWGArm.DataType = 'Scalar';
AO.SF_IRM.AWGArm.ChannelNames = '';
AO.SF_IRM.AWGArm.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGArm.Physics2HWFcn = 1;
AO.SF_IRM.AWGArm.Units = 'Hardware';
AO.SF_IRM.AWGArm.HWUnits      = '';
AO.SF_IRM.AWGArm.PhysicsUnits = '';

AO.SF_IRM.AWGEnable.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGEnable.Mode = 'Simulator';
AO.SF_IRM.AWGEnable.DataType = 'Scalar';
AO.SF_IRM.AWGEnable.ChannelNames = '';
AO.SF_IRM.AWGEnable.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGEnable.Physics2HWFcn = 1;
AO.SF_IRM.AWGEnable.Units = 'Hardware';
AO.SF_IRM.AWGEnable.HWUnits      = '';
AO.SF_IRM.AWGEnable.PhysicsUnits = '';

% Active/Idle (1/0)
AO.SF_IRM.AWGActive.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGActive.Mode = 'Simulator';
AO.SF_IRM.AWGActive.DataType = 'Scalar';
AO.SF_IRM.AWGActive.ChannelNames = '';
AO.SF_IRM.AWGActive.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGActive.Physics2HWFcn = 1;
AO.SF_IRM.AWGActive.Units = 'Hardware';
AO.SF_IRM.AWGActive.HWUnits      = '';
AO.SF_IRM.AWGActive.PhysicsUnits = '';

AO.SF_IRM.AWGTrigModeRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGTrigModeRBV.Mode = 'Simulator';
AO.SF_IRM.AWGTrigModeRBV.DataType = 'Scalar';
AO.SF_IRM.AWGTrigModeRBV.ChannelNames = '';
AO.SF_IRM.AWGTrigModeRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGTrigModeRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGTrigModeRBV.Units = 'Hardware';
AO.SF_IRM.AWGTrigModeRBV.HWUnits      = '';
AO.SF_IRM.AWGTrigModeRBV.PhysicsUnits = '';

AO.SF_IRM.AWGArmRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGArmRBV.Mode = 'Simulator';
AO.SF_IRM.AWGArmRBV.DataType = 'Scalar';
AO.SF_IRM.AWGArmRBV.ChannelNames = '';
AO.SF_IRM.AWGArmRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGArmRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGArmRBV.Units = 'Hardware';
AO.SF_IRM.AWGArmRBV.HWUnits      = '';
AO.SF_IRM.AWGArmRBV.PhysicsUnits = '';

AO.SF_IRM.AWGEnableRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGEnableRBV.Mode = 'Simulator';
AO.SF_IRM.AWGEnableRBV.DataType = 'Scalar';
AO.SF_IRM.AWGEnableRBV.ChannelNames = '';
AO.SF_IRM.AWGEnableRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGEnableRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGEnableRBV.Units = 'Hardware';
AO.SF_IRM.AWGEnableRBV.HWUnits      = '';
AO.SF_IRM.AWGEnableRBV.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.SF_IRM.AWGInt1Rise.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGInt1Rise.Mode = 'Simulator';
AO.SF_IRM.AWGInt1Rise.DataType = 'Scalar';
AO.SF_IRM.AWGInt1Rise.ChannelNames = '';
AO.SF_IRM.AWGInt1Rise.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt1Rise.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt1Rise.Units = 'Hardware';
AO.SF_IRM.AWGInt1Rise.HWUnits      = '';
AO.SF_IRM.AWGInt1Rise.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.SF_IRM.AWGInt2Rise.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGInt2Rise.Mode = 'Simulator';
AO.SF_IRM.AWGInt2Rise.DataType = 'Scalar';
AO.SF_IRM.AWGInt2Rise.ChannelNames = '';
AO.SF_IRM.AWGInt2Rise.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt2Rise.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt2Rise.Units = 'Hardware';
AO.SF_IRM.AWGInt2Rise.HWUnits      = '';
AO.SF_IRM.AWGInt2Rise.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.SF_IRM.AWGInt1Fall.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGInt1Fall.Mode = 'Simulator';
AO.SF_IRM.AWGInt1Fall.DataType = 'Scalar';
AO.SF_IRM.AWGInt1Fall.ChannelNames = '';
AO.SF_IRM.AWGInt1Fall.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt1Fall.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt1Fall.Units = 'Hardware';
AO.SF_IRM.AWGInt1Fall.HWUnits      = '';
AO.SF_IRM.AWGInt1Fall.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.SF_IRM.AWGInt2Fall.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SF_IRM.AWGInt2Fall.Mode = 'Simulator';
AO.SF_IRM.AWGInt2Fall.DataType = 'Scalar';
AO.SF_IRM.AWGInt2Fall.ChannelNames = '';
AO.SF_IRM.AWGInt2Fall.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt2Fall.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt2Fall.Units = 'Hardware';
AO.SF_IRM.AWGInt2Fall.HWUnits      = '';
AO.SF_IRM.AWGInt2Fall.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.SF_IRM.AWGInt1RiseRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGInt1RiseRBV.Mode = 'Simulator';
AO.SF_IRM.AWGInt1RiseRBV.DataType = 'Scalar';
AO.SF_IRM.AWGInt1RiseRBV.ChannelNames = '';
AO.SF_IRM.AWGInt1RiseRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt1RiseRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt1RiseRBV.Units = 'Hardware';
AO.SF_IRM.AWGInt1RiseRBV.HWUnits      = '';
AO.SF_IRM.AWGInt1RiseRBV.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.SF_IRM.AWGInt2RiseRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGInt2RiseRBV.Mode = 'Simulator';
AO.SF_IRM.AWGInt2RiseRBV.DataType = 'Scalar';
AO.SF_IRM.AWGInt2RiseRBV.ChannelNames = '';
AO.SF_IRM.AWGInt2RiseRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt2RiseRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt2RiseRBV.Units = 'Hardware';
AO.SF_IRM.AWGInt2RiseRBV.HWUnits      = '';
AO.SF_IRM.AWGInt2RiseRBV.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.SF_IRM.AWGInt1FallRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGInt1FallRBV.Mode = 'Simulator';
AO.SF_IRM.AWGInt1FallRBV.DataType = 'Scalar';
AO.SF_IRM.AWGInt1FallRBV.ChannelNames = '';
AO.SF_IRM.AWGInt1FallRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt1FallRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt1FallRBV.Units = 'Hardware';
AO.SF_IRM.AWGInt1FallRBV.HWUnits      = '';
AO.SF_IRM.AWGInt1FallRBV.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.SF_IRM.AWGInt2FallRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SF'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SF_IRM.AWGInt2FallRBV.Mode = 'Simulator';
AO.SF_IRM.AWGInt2FallRBV.DataType = 'Scalar';
AO.SF_IRM.AWGInt2FallRBV.ChannelNames = '';
AO.SF_IRM.AWGInt2FallRBV.HW2PhysicsFcn = 1;
AO.SF_IRM.AWGInt2FallRBV.Physics2HWFcn = 1;
AO.SF_IRM.AWGInt2FallRBV.Units = 'Hardware';
AO.SF_IRM.AWGInt2FallRBV.HWUnits      = '';
AO.SF_IRM.AWGInt2FallRBV.PhysicsUnits = '';

for i = 1:size(AO.SF_IRM.DeviceList)
    AO.SF_IRM.Setpoint.ChannelNames(i,:)  = sprintf('irm:%03d:DAC%d',    a(i,1), a(i,2));
    AO.SF_IRM.Monitor.ChannelNames(i,:)   = sprintf('irm:%03d:ADC%d',    a(i,1), a(i,3));
    AO.SF_IRM.OnControl.ChannelNames(i,:) = sprintf('irm:%03d:B%02dOut', a(i,1), a(i,4));
    AO.SF_IRM.On.ChannelNames(i,:)        = sprintf('irm:%03d:B%02dRBV', a(i,1), a(i,5));
    AO.SF_IRM.Ready.ChannelNames(i,:)     = sprintf('irm:%03d:B%02dRBV', a(i,1), a(i,6));
    AO.SF_IRM.RampRate.ChannelNames(i,:)  = sprintf('irm:%03d:SlewRate%d', a(i,1), a(i,2));
    
    AO.SF_IRM.AWGPattern.ChannelNames(i,:)     = sprintf('irm:%03d:AWG%d:pattern',     a(i,1), a(i,2));
    AO.SF_IRM.AWGTrigMode.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:TrigMode',    a(i,1), a(i,2));
    AO.SF_IRM.AWGArm.ChannelNames(i,:)         = sprintf('irm:%03d:AWG%d:Arm',         a(i,1), a(i,2));
    AO.SF_IRM.AWGEnable.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:Enable',      a(i,1), a(i,2));
    AO.SF_IRM.AWGActive.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ActiveRBV',   a(i,1), a(i,2));
    AO.SF_IRM.AWGTrigModeRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:TrigModeRBV', a(i,1), a(i,2));
    AO.SF_IRM.AWGArmRBV.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ArmRBV',      a(i,1), a(i,2));
    AO.SF_IRM.AWGEnableRBV.ChannelNames(i,:)   = sprintf('irm:%03d:AWG%d:EnableRBV',   a(i,1), a(i,2));
    
    AO.SF_IRM.AWGInt1Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Rise',    a(i,1), a(i,2));
    AO.SF_IRM.AWGInt2Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Rise',    a(i,1), a(i,2));
    AO.SF_IRM.AWGInt1Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Fall',    a(i,1), a(i,2));
    AO.SF_IRM.AWGInt2Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Fall',    a(i,1), a(i,2));    
    
    AO.SF_IRM.AWGInt1RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1RiseRBV', a(i,1), a(i,2));
    AO.SF_IRM.AWGInt2RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2RiseRBV', a(i,1), a(i,2));
    AO.SF_IRM.AWGInt1FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1FallRBV', a(i,1), a(i,2));
    AO.SF_IRM.AWGInt2FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2FallRBV', a(i,1), a(i,2));    
end


AO.SD_IRM.FamilyName = 'SD';
AO.SD_IRM.MemberOf   = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'};
AO.SD_IRM.DeviceList = ThreePerSectorList;
AO.SD_IRM.ElementList = (1:size(AO.SD_IRM.DeviceList,1))';
AO.SD_IRM.Status = ones(size(AO.SD_IRM.DeviceList,1),1);

AO.SD_IRM.BaseName = [
    'BR1:SD'
    'BR1:SD'
    'BR1:SD'
    'BR2:SD'
    'BR2:SD'
    'BR2:SD'
    'BR3:SD'
    'BR3:SD'
    'BR3:SD'
    'BR4:SD'
    'BR4:SD'
    'BR4:SD'
    ];

%   IRM  SP  AM OnBC OnBM Rdy
a = [
    129  01  03  23   03   02
    129  01  03  23   03   02
    129  01  03  23   03   02
    
    130  01  03  23   03   02
    130  01  03  23   03   02
    130  01  03  23   03   02
    
    131  01  03  23   03   02
    131  01  03  23   03   02
    131  01  03  23   03   02
    
    132  01  03  23   03   02
    132  01  03  23   03   02
    132  01  03  23   03   02
    ];

AO.SD_IRM.IRM = a(:,1);

AO.SD_IRM.Monitor.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Monitor';};
AO.SD_IRM.Monitor.Mode = 'Simulator';
AO.SD_IRM.Monitor.DataType = 'Scalar';
AO.SD_IRM.Monitor.ChannelNames = '';
AO.SD_IRM.Monitor.HW2PhysicsFcn = @booster2at;
AO.SD_IRM.Monitor.Physics2HWFcn = @at2booster;
AO.SD_IRM.Monitor.Units = 'Hardware';
AO.SD_IRM.Monitor.HWUnits      = 'Ampere';
AO.SD_IRM.Monitor.PhysicsUnits = '1/Meter^2';

AO.SD_IRM.Setpoint.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Setpoint';};
AO.SD_IRM.Setpoint.Mode = 'Simulator';
AO.SD_IRM.Setpoint.DataType = 'Scalar';
AO.SD_IRM.Setpoint.ChannelNames = '';
AO.SD_IRM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SD_IRM.Setpoint.Physics2HWFcn = @at2booster;
AO.SD_IRM.Setpoint.Units = 'Hardware';
AO.SD_IRM.Setpoint.HWUnits      = 'Ampere';
AO.SD_IRM.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SD_IRM.OnControl.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Boolean Control';};
AO.SD_IRM.OnControl.Mode = 'Simulator';
AO.SD_IRM.OnControl.DataType = 'Scalar';
AO.SD_IRM.OnControl.ChannelNames = '';
AO.SD_IRM.OnControl.HW2PhysicsParams = 1;
AO.SD_IRM.OnControl.Physics2HWParams = 1;
AO.SD_IRM.OnControl.Units = 'Hardware';
AO.SD_IRM.OnControl.HWUnits      = '';
AO.SD_IRM.OnControl.PhysicsUnits = '';
AO.SD_IRM.OnControl.Range = [0 1];
AO.SD_IRM.OnControl.Tolerance = .5;    

AO.SD_IRM.On.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Boolean Monitor';};
AO.SD_IRM.On.Mode = 'Simulator';
AO.SD_IRM.On.DataType = 'Scalar';
AO.SD_IRM.On.ChannelNames = '';
AO.SD_IRM.On.HW2PhysicsParams = 1;
AO.SD_IRM.On.Physics2HWParams = 1;
AO.SD_IRM.On.Units = 'Hardware';
AO.SD_IRM.On.HWUnits      = '';
AO.SD_IRM.On.PhysicsUnits = '';

AO.SD_IRM.Ready.MemberOf = {'PlotFamily'; 'SEXT'; 'Magnet'; 'SD'; 'Boolean Monitor';};
AO.SD_IRM.Ready.Mode = 'Simulator';
AO.SD_IRM.Ready.DataType = 'Scalar';
AO.SD_IRM.Ready.ChannelNames = '';
AO.SD_IRM.Ready.HW2PhysicsParams = 1;
AO.SD_IRM.Ready.Physics2HWParams = 1;
AO.SD_IRM.Ready.Units = 'Hardware';
AO.SD_IRM.Ready.HWUnits      = 'Second';
AO.SD_IRM.Ready.PhysicsUnits = 'Second';

% Setpoint waveform (1400 points) 
AO.SD_IRM.AWGPattern.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Waveform'; 'AWG'};
AO.SD_IRM.AWGPattern.Mode = 'Simulator';
AO.SD_IRM.AWGPattern.DataType = 'Scalar';
AO.SD_IRM.AWGPattern.ChannelNames = '';
AO.SD_IRM.AWGPattern.HW2PhysicsFcn = @booster2at;
AO.SD_IRM.AWGPattern.Physics2HWFcn = @at2booster;
AO.SD_IRM.AWGPattern.Units = 'Hardware';
AO.SD_IRM.AWGPattern.HWUnits      = 'Ampere or Counts?';
AO.SD_IRM.AWGPattern.PhysicsUnits = 'Radian';

%  Auto-Rearm/Single (1/0)
AO.SD_IRM.AWGTrigMode.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGTrigMode.Mode = 'Simulator';
AO.SD_IRM.AWGTrigMode.DataType = 'Scalar';
AO.SD_IRM.AWGTrigMode.ChannelNames = '';
AO.SD_IRM.AWGTrigMode.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGTrigMode.Physics2HWFcn = 1;
AO.SD_IRM.AWGTrigMode.Units = 'Hardware';
AO.SD_IRM.AWGTrigMode.HWUnits      = '';
AO.SD_IRM.AWGTrigMode.PhysicsUnits = '';

% Armed/Disarmed (1/0)
AO.SD_IRM.AWGArm.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGArm.Mode = 'Simulator';
AO.SD_IRM.AWGArm.DataType = 'Scalar';
AO.SD_IRM.AWGArm.ChannelNames = '';
AO.SD_IRM.AWGArm.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGArm.Physics2HWFcn = 1;
AO.SD_IRM.AWGArm.Units = 'Hardware';
AO.SD_IRM.AWGArm.HWUnits      = '';
AO.SD_IRM.AWGArm.PhysicsUnits = '';

AO.SD_IRM.AWGEnable.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGEnable.Mode = 'Simulator';
AO.SD_IRM.AWGEnable.DataType = 'Scalar';
AO.SD_IRM.AWGEnable.ChannelNames = '';
AO.SD_IRM.AWGEnable.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGEnable.Physics2HWFcn = 1;
AO.SD_IRM.AWGEnable.Units = 'Hardware';
AO.SD_IRM.AWGEnable.HWUnits      = '';
AO.SD_IRM.AWGEnable.PhysicsUnits = '';

% Active/Idle (1/0)
AO.SD_IRM.AWGActive.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGActive.Mode = 'Simulator';
AO.SD_IRM.AWGActive.DataType = 'Scalar';
AO.SD_IRM.AWGActive.ChannelNames = '';
AO.SD_IRM.AWGActive.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGActive.Physics2HWFcn = 1;
AO.SD_IRM.AWGActive.Units = 'Hardware';
AO.SD_IRM.AWGActive.HWUnits      = '';
AO.SD_IRM.AWGActive.PhysicsUnits = '';

AO.SD_IRM.AWGTrigModeRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGTrigModeRBV.Mode = 'Simulator';
AO.SD_IRM.AWGTrigModeRBV.DataType = 'Scalar';
AO.SD_IRM.AWGTrigModeRBV.ChannelNames = '';
AO.SD_IRM.AWGTrigModeRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGTrigModeRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGTrigModeRBV.Units = 'Hardware';
AO.SD_IRM.AWGTrigModeRBV.HWUnits      = '';
AO.SD_IRM.AWGTrigModeRBV.PhysicsUnits = '';

AO.SD_IRM.AWGArmRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGArmRBV.Mode = 'Simulator';
AO.SD_IRM.AWGArmRBV.DataType = 'Scalar';
AO.SD_IRM.AWGArmRBV.ChannelNames = '';
AO.SD_IRM.AWGArmRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGArmRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGArmRBV.Units = 'Hardware';
AO.SD_IRM.AWGArmRBV.HWUnits      = '';
AO.SD_IRM.AWGArmRBV.PhysicsUnits = '';

AO.SD_IRM.AWGEnableRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGEnableRBV.Mode = 'Simulator';
AO.SD_IRM.AWGEnableRBV.DataType = 'Scalar';
AO.SD_IRM.AWGEnableRBV.ChannelNames = '';
AO.SD_IRM.AWGEnableRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGEnableRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGEnableRBV.Units = 'Hardware';
AO.SD_IRM.AWGEnableRBV.HWUnits      = '';
AO.SD_IRM.AWGEnableRBV.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.SD_IRM.AWGInt1Rise.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt1Rise.Mode = 'Simulator';
AO.SD_IRM.AWGInt1Rise.DataType = 'Scalar';
AO.SD_IRM.AWGInt1Rise.ChannelNames = '';
AO.SD_IRM.AWGInt1Rise.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt1Rise.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt1Rise.Units = 'Hardware';
AO.SD_IRM.AWGInt1Rise.HWUnits      = '';
AO.SD_IRM.AWGInt1Rise.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.SD_IRM.AWGInt2Rise.MemberOf = {'PlotFamily'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt2Rise.Mode = 'Simulator';
AO.SD_IRM.AWGInt2Rise.DataType = 'Scalar';
AO.SD_IRM.AWGInt2Rise.ChannelNames = '';
AO.SD_IRM.AWGInt2Rise.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt2Rise.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt2Rise.Units = 'Hardware';
AO.SD_IRM.AWGInt2Rise.HWUnits      = '';
AO.SD_IRM.AWGInt2Rise.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.SD_IRM.AWGInt1Fall.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt1Fall.Mode = 'Simulator';
AO.SD_IRM.AWGInt1Fall.DataType = 'Scalar';
AO.SD_IRM.AWGInt1Fall.ChannelNames = '';
AO.SD_IRM.AWGInt1Fall.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt1Fall.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt1Fall.Units = 'Hardware';
AO.SD_IRM.AWGInt1Fall.HWUnits      = '';
AO.SD_IRM.AWGInt1Fall.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.SD_IRM.AWGInt2Fall.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt2Fall.Mode = 'Simulator';
AO.SD_IRM.AWGInt2Fall.DataType = 'Scalar';
AO.SD_IRM.AWGInt2Fall.ChannelNames = '';
AO.SD_IRM.AWGInt2Fall.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt2Fall.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt2Fall.Units = 'Hardware';
AO.SD_IRM.AWGInt2Fall.HWUnits      = '';
AO.SD_IRM.AWGInt2Fall.PhysicsUnits = '';

% AWGc:Int1Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT1
AO.SD_IRM.AWGInt1RiseRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt1RiseRBV.Mode = 'Simulator';
AO.SD_IRM.AWGInt1RiseRBV.DataType = 'Scalar';
AO.SD_IRM.AWGInt1RiseRBV.ChannelNames = '';
AO.SD_IRM.AWGInt1RiseRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt1RiseRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt1RiseRBV.Units = 'Hardware';
AO.SD_IRM.AWGInt1RiseRBV.HWUnits      = '';
AO.SD_IRM.AWGInt1RiseRBV.PhysicsUnits = '';

% AWGc:Int2Rise (1/0) arbitrary waveform generator triggers on the rising edge of INT2
AO.SD_IRM.AWGInt2RiseRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Control'; 'AWG'};
AO.SD_IRM.AWGInt2RiseRBV.Mode = 'Simulator';
AO.SD_IRM.AWGInt2RiseRBV.DataType = 'Scalar';
AO.SD_IRM.AWGInt2RiseRBV.ChannelNames = '';
AO.SD_IRM.AWGInt2RiseRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt2RiseRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt2RiseRBV.Units = 'Hardware';
AO.SD_IRM.AWGInt2RiseRBV.HWUnits      = '';
AO.SD_IRM.AWGInt2RiseRBV.PhysicsUnits = '';

% AWGc:Int1Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT1
AO.SD_IRM.AWGInt1FallRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGInt1FallRBV.Mode = 'Simulator';
AO.SD_IRM.AWGInt1FallRBV.DataType = 'Scalar';
AO.SD_IRM.AWGInt1FallRBV.ChannelNames = '';
AO.SD_IRM.AWGInt1FallRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt1FallRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt1FallRBV.Units = 'Hardware';
AO.SD_IRM.AWGInt1FallRBV.HWUnits      = '';
AO.SD_IRM.AWGInt1FallRBV.PhysicsUnits = '';

% AWGc:Int2Fall (1/0) arbitrary waveform generator triggers on the falling edge of INT2
AO.SD_IRM.AWGInt2FallRBV.MemberOf = {'PlotFamily'; 'SEXT'; 'SD'; 'Magnet'; 'Boolean Monitor'; 'AWG'};
AO.SD_IRM.AWGInt2FallRBV.Mode = 'Simulator';
AO.SD_IRM.AWGInt2FallRBV.DataType = 'Scalar';
AO.SD_IRM.AWGInt2FallRBV.ChannelNames = '';
AO.SD_IRM.AWGInt2FallRBV.HW2PhysicsFcn = 1;
AO.SD_IRM.AWGInt2FallRBV.Physics2HWFcn = 1;
AO.SD_IRM.AWGInt2FallRBV.Units = 'Hardware';
AO.SD_IRM.AWGInt2FallRBV.HWUnits      = '';
AO.SD_IRM.AWGInt2FallRBV.PhysicsUnits = '';

for i = 1:size(AO.SD_IRM.DeviceList)
    AO.SD_IRM.Setpoint.ChannelNames(i,:)  = sprintf('irm:%03d:DAC%d',    a(i,1), a(i,2));
    AO.SD_IRM.Monitor.ChannelNames(i,:)   = sprintf('irm:%03d:ADC%d',    a(i,1), a(i,3));
    AO.SD_IRM.OnControl.ChannelNames(i,:) = sprintf('irm:%03d:B%02dOut', a(i,1), a(i,4));
    AO.SD_IRM.On.ChannelNames(i,:)        = sprintf('irm:%03d:B%02dRBV', a(i,1), a(i,5));
    AO.SD_IRM.Ready.ChannelNames(i,:)     = sprintf('irm:%03d:B%02dRBV', a(i,1), a(i,6));
    AO.SD_IRM.RampRate.ChannelNames(i,:)  = sprintf('irm:%03d:SlewRate%d', a(i,1), a(i,2));
    
    AO.SD_IRM.AWGPattern.ChannelNames(i,:)     = sprintf('irm:%03d:AWG%d:pattern',     a(i,1), a(i,2));
    AO.SD_IRM.AWGTrigMode.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:TrigMode',    a(i,1), a(i,2));
    AO.SD_IRM.AWGArm.ChannelNames(i,:)         = sprintf('irm:%03d:AWG%d:Arm',         a(i,1), a(i,2));
    AO.SD_IRM.AWGEnable.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:Enable',      a(i,1), a(i,2));
    AO.SD_IRM.AWGActive.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ActiveRBV',   a(i,1), a(i,2));
    AO.SD_IRM.AWGTrigModeRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:TrigModeRBV', a(i,1), a(i,2));
    AO.SD_IRM.AWGArmRBV.ChannelNames(i,:)      = sprintf('irm:%03d:AWG%d:ArmRBV',      a(i,1), a(i,2));
    AO.SD_IRM.AWGEnableRBV.ChannelNames(i,:)   = sprintf('irm:%03d:AWG%d:EnableRBV',   a(i,1), a(i,2));
    
    AO.SD_IRM.AWGInt1Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Rise',    a(i,1), a(i,2));
    AO.SD_IRM.AWGInt2Rise.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Rise',    a(i,1), a(i,2));
    AO.SD_IRM.AWGInt1Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int1Fall',    a(i,1), a(i,2));
    AO.SD_IRM.AWGInt2Fall.ChannelNames(i,:)    = sprintf('irm:%03d:AWG%d:Int2Fall',    a(i,1), a(i,2));    
    
    AO.SD_IRM.AWGInt1RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1RiseRBV', a(i,1), a(i,2));
    AO.SD_IRM.AWGInt2RiseRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2RiseRBV', a(i,1), a(i,2));
    AO.SD_IRM.AWGInt1FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int1FallRBV', a(i,1), a(i,2));
    AO.SD_IRM.AWGInt2FallRBV.ChannelNames(i,:) = sprintf('irm:%03d:AWG%d:Int2FallRBV', a(i,1), a(i,2));
end



AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = SixPerSectorList;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);

AO.BEND.Monitor.MemberOf = {'PlotFamily'; 'Magnet'; 'BEND'; 'Monitor'};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @booster2at;
AO.BEND.Monitor.Physics2HWFcn = @at2booster;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'PlotFamily'; 'Magnet'; 'BEND'; 'Setpoint'};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @booster2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2booster;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';

AO.BEND.DVM.MemberOf = {};
AO.BEND.DVM.Mode = 'Simulator';
AO.BEND.DVM.DataType = 'Scalar';
AO.BEND.DVM.SpecialFunctionGet = @getam_DVM;
AO.BEND.DVM.HW2PhysicsFcn = @booster2at;
AO.BEND.DVM.Physics2HWFcn = @at2booster;
AO.BEND.DVM.Units = 'Hardware';
AO.BEND.DVM.HWUnits      = 'Ampere';
AO.BEND.DVM.PhysicsUnits = 'Radian';

AO.BEND.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_booster(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_booster(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range = [0 1];
AO.BEND.OnControl.Tolerance = .5;    

AO.BEND.EnableDAC.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.EnableDAC.Mode = 'Simulator';
AO.BEND.EnableDAC.DataType = 'Scalar';
AO.BEND.EnableDAC.ChannelNames = getname_booster('BEND', 'EnableDAC');
AO.BEND.EnableDAC.HW2PhysicsParams = 1;
AO.BEND.EnableDAC.Physics2HWParams = 1;
AO.BEND.EnableDAC.Units = 'Hardware';
AO.BEND.EnableDAC.HWUnits      = '';
AO.BEND.EnableDAC.PhysicsUnits = '';
AO.BEND.EnableDAC.Range = [0 1];
AO.BEND.EnableDAC.Tolerance = .5;    

AO.BEND.EnableRamp.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.EnableRamp.Mode = 'Simulator';
AO.BEND.EnableRamp.DataType = 'Scalar';
AO.BEND.EnableRamp.ChannelNames = getname_booster('BEND', 'EnableRamp');
AO.BEND.EnableRamp.HW2PhysicsParams = 1;
AO.BEND.EnableRamp.Physics2HWParams = 1;
AO.BEND.EnableRamp.Units = 'Hardware';
AO.BEND.EnableRamp.HWUnits      = '';
AO.BEND.EnableRamp.PhysicsUnits = '';
AO.BEND.EnableRamp.Range = [0 1];
AO.BEND.EnableRamp.Tolerance = .5;    

AO.BEND.Gain.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
AO.BEND.Gain.Mode = 'Simulator';
AO.BEND.Gain.DataType = 'Scalar';
AO.BEND.Gain.ChannelNames = getname_booster('BEND', 'Gain');
AO.BEND.Gain.HW2PhysicsParams = 1;
AO.BEND.Gain.Physics2HWParams = 1;
AO.BEND.Gain.Units = 'Hardware';
AO.BEND.Gain.HWUnits      = '';
AO.BEND.Gain.PhysicsUnits = '';
AO.BEND.Gain.Range = [0 2];
AO.BEND.Gain.Tolerance = .5;    

AO.BEND.Offset.MemberOf = {'PlotFamily'; 'Magnet'; 'BEND'; 'Setpoint'; 'Save/Restore';};
AO.BEND.Offset.Mode = 'Simulator';
AO.BEND.Offset.DataType = 'Scalar';
AO.BEND.Offset.ChannelNames = getname_booster('BEND', 'Offset');
AO.BEND.Offset.HW2PhysicsParams = 1;
AO.BEND.Offset.Physics2HWParams = 1;
AO.BEND.Offset.Units = 'Hardware';
AO.BEND.Offset.HWUnits      = '';
AO.BEND.Offset.PhysicsUnits = '';
AO.BEND.Offset.Range = [0 2];
AO.BEND.Offset.Tolerance = .5;    

% AO.BEND.Enable.MemberOf = {'PlotFamily'; 'Boolean Control';};
% AO.BEND.Enable.Mode = 'Simulator';
% AO.BEND.Enable.DataType = 'Scalar';
% AO.BEND.Enable.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Enable');
% AO.BEND.Enable.HW2PhysicsParams = 1;
% AO.BEND.Enable.Physics2HWParams = 1;
% AO.BEND.Enable.Units = 'Hardware';
% AO.BEND.Enable.HWUnits      = '';
% AO.BEND.Enable.PhysicsUnits = '';

AO.BEND.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';



% RF
% RF power in the SP/AM
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'PlotFamily'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.MemberOf   = {'PlotFamily'; 'RF'};
AO.RF.Monitor.Mode = 'Simulator';  
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = 'BR4_____RFCONT_AM01';
AO.RF.Monitor.HW2PhysicsParams = 1;
AO.RF.Monitor.Physics2HWParams = 1;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = '';
AO.RF.Monitor.PhysicsUnits  = '';

AO.RF.Setpoint.MemberOf = {'PlotFamily'; 'RF'; 'Setpoint';};
AO.RF.Setpoint.Mode = 'Simulator';     
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = 'BR4_____RFCONT_AC01';
AO.RF.Setpoint.HW2PhysicsParams = 1;
AO.RF.Setpoint.Physics2HWParams = 1;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits       = 'DAC Volts'; % 'kW';
AO.RF.Setpoint.PhysicsUnits  = 'DAC Volts';
AO.RF.Setpoint.Range = [0 6.6];
AO.RF.Setpoint.Tolerance = Inf;
   
% Mode is CW (0) or Ramp (1)
AO.RF.Mode.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Monitor';};
AO.RF.Mode.Mode = 'Simulator';     
AO.RF.Mode.DataType = 'Scalar';
AO.RF.Mode.ChannelNames = 'BR4_____RFMODE_BM01';
AO.RF.Mode.HW2PhysicsParams = 1;
AO.RF.Mode.Physics2HWParams = 1;
AO.RF.Mode.Units = 'Hardware';
AO.RF.Mode.HWUnits       = '';
AO.RF.Mode.PhysicsUnits  = '';  
    
AO.RF.ModeControl.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Control';};
AO.RF.ModeControl.Mode = 'Simulator';     
AO.RF.ModeControl.DataType = 'Scalar';
AO.RF.ModeControl.ChannelNames = 'BR4_____RFMODE_BC22';
AO.RF.ModeControl.HW2PhysicsParams = 1;
AO.RF.ModeControl.Physics2HWParams = 1;
AO.RF.ModeControl.Units = 'Hardware';
AO.RF.ModeControl.HWUnits       = '';
AO.RF.ModeControl.PhysicsUnits  = '';
AO.RF.ModeControl.Range = [0 1];
AO.RF.ModeControl.Tolerance = .5; 

AO.RF.On.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Monitor';};
AO.RF.On.Mode = 'Simulator';     
AO.RF.On.DataType = 'Scalar';
AO.RF.On.ChannelNames = 'BR4_____RFCONT_BM08';
AO.RF.On.HW2PhysicsParams = 1;
AO.RF.On.Physics2HWParams = 1;
AO.RF.On.Units = 'Hardware';
AO.RF.On.HWUnits       = '';
AO.RF.On.PhysicsUnits  = '';  
    
AO.RF.OnControl.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Control';};
AO.RF.OnControl.Mode = 'Simulator';     
AO.RF.OnControl.DataType = 'Scalar';
AO.RF.OnControl.ChannelNames = 'BR4_____RFCONT_BC23';
AO.RF.OnControl.HW2PhysicsParams = 1;
AO.RF.OnControl.Physics2HWParams = 1;
AO.RF.OnControl.Units = 'Hardware';
AO.RF.OnControl.HWUnits       = '';
AO.RF.OnControl.PhysicsUnits  = '';
AO.RF.OnControl.Range = [0 1];
AO.RF.OnControl.Tolerance = .5;    

AO.RF.EnableDAC.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Control';};
AO.RF.EnableDAC.Mode = 'Simulator';
AO.RF.EnableDAC.DataType = 'Scalar';
AO.RF.EnableDAC.ChannelNames = 'BR4_____XMIT___REBC01';
AO.RF.EnableDAC.HW2PhysicsParams = 1;
AO.RF.EnableDAC.Physics2HWParams = 1;
AO.RF.EnableDAC.Units = 'Hardware';
AO.RF.EnableDAC.HWUnits       = '';
AO.RF.EnableDAC.PhysicsUnits  = '';
AO.RF.EnableDAC.Range = [0 1];
AO.RF.EnableDAC.Tolerance = .5;    

AO.RF.Gain.MemberOf = {'PlotFamily'; 'RF'; 'Setpoint'; 'Save';};
AO.RF.Gain.Mode = 'Simulator';
AO.RF.Gain.DataType = 'Scalar';
AO.RF.Gain.ChannelNames = 'BR4_____XMIT___GNAC01';
AO.RF.Gain.HW2PhysicsParams = 1;
AO.RF.Gain.Physics2HWParams = 1;
AO.RF.Gain.Units = 'Hardware';
AO.RF.Gain.HWUnits       = '';
AO.RF.Gain.PhysicsUnits  = '';
AO.RF.Gain.Range = [0 2];
AO.RF.Gain.Tolerance = .5;    

AO.RF.EnableRamp.MemberOf = {'PlotFamily'; 'RF'; 'Boolean Control';};
AO.RF.EnableRamp.Mode = 'Simulator';
AO.RF.EnableRamp.DataType = 'Scalar';
AO.RF.EnableRamp.ChannelNames = 'li14-40:ENABLE_RAMP';
AO.RF.EnableRamp.HW2PhysicsParams = 1;
AO.RF.EnableRamp.Physics2HWParams = 1;
AO.RF.EnableRamp.Units = 'Hardware';
AO.RF.EnableRamp.HWUnits       = '';
AO.RF.EnableRamp.PhysicsUnits  = '';
AO.RF.EnableRamp.Range = [0 1];
AO.RF.EnableRamp.Tolerance = .5;    

AO.RF.PhaseControl.MemberOf = {'PlotFamily'; 'RF'; 'Setpoint'; 'Save';};
AO.RF.PhaseControl.Mode = 'Simulator';     
AO.RF.PhaseControl.DataType = 'Scalar';
AO.RF.PhaseControl.ChannelNames = 'BR4_____PHSCON_AC00';
AO.RF.PhaseControl.HW2PhysicsParams = 1;
AO.RF.PhaseControl.Physics2HWParams = 1;
AO.RF.PhaseControl.Units = 'Hardware';
AO.RF.PhaseControl.HWUnits       = 'Degrees';
AO.RF.PhaseControl.PhysicsUnits  = 'Degrees';
AO.RF.PhaseControl.Range = [0 360];
AO.RF.PhaseControl.Tolerance = .2;

AO.RF.Phase.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.Phase.Mode = 'Simulator';     
AO.RF.Phase.DataType = 'Scalar';
AO.RF.Phase.ChannelNames = 'BR4_____PHSCON_AM00';
AO.RF.Phase.HW2PhysicsParams = 1;
AO.RF.Phase.Physics2HWParams = 1;
AO.RF.Phase.Units = 'Hardware';
AO.RF.Phase.HWUnits       = 'Degrees';
AO.RF.Phase.PhysicsUnits  = 'Degrees';

AO.RF.PhaseError.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.PhaseError.Mode = 'Simulator';     
AO.RF.PhaseError.DataType = 'Scalar';
AO.RF.PhaseError.ChannelNames = 'BR4_____TUNERR_AM02';
AO.RF.PhaseError.HW2PhysicsParams = 1;
AO.RF.PhaseError.Physics2HWParams = 1;
AO.RF.PhaseError.Units = 'Hardware';
AO.RF.PhaseError.HWUnits       = 'Degrees';
AO.RF.PhaseError.PhysicsUnits  = 'Degrees';

AO.RF.CircForwardPower.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CircForwardPower.Mode = 'Simulator';     
AO.RF.CircForwardPower.DataType = 'Scalar';
AO.RF.CircForwardPower.ChannelNames = 'BR4_____CLDFWD_AM00';
AO.RF.CircForwardPower.HW2PhysicsParams = 1;
AO.RF.CircForwardPower.Physics2HWParams = 1;
AO.RF.CircForwardPower.Units = 'Hardware';
AO.RF.CircForwardPower.HWUnits       = 'kW';
AO.RF.CircForwardPower.PhysicsUnits  = 'kW';

AO.RF.WaveGuideForwardPower.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.WaveGuideForwardPower.Mode = 'Simulator';     
AO.RF.WaveGuideForwardPower.DataType = 'Scalar';
AO.RF.WaveGuideForwardPower.ChannelNames = 'BR4_____WGFWD__AM02';
AO.RF.WaveGuideForwardPower.HW2PhysicsParams = 1;
AO.RF.WaveGuideForwardPower.Physics2HWParams = 1;
AO.RF.WaveGuideForwardPower.Units = 'Hardware';
AO.RF.WaveGuideForwardPower.HWUnits       = 'kW';
AO.RF.WaveGuideForwardPower.PhysicsUnits  = 'kW';

AO.RF.WaveGuideReversePower.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.WaveGuideReversePower.Mode = 'Simulator';     
AO.RF.WaveGuideReversePower.DataType = 'Scalar';
AO.RF.WaveGuideReversePower.ChannelNames = 'BR4_____WGREV__AM01';
AO.RF.WaveGuideReversePower.HW2PhysicsParams = 1;
AO.RF.WaveGuideReversePower.Physics2HWParams = 1;
AO.RF.WaveGuideReversePower.Units = 'Hardware';
AO.RF.WaveGuideReversePower.HWUnits       = 'kW';
AO.RF.WaveGuideReversePower.PhysicsUnits  = 'kW';

AO.RF.TunerPosition.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.TunerPosition.Mode = 'Simulator';     
AO.RF.TunerPosition.DataType = 'Scalar';
AO.RF.TunerPosition.ChannelNames = 'BR4_____TUNPOS_AM00';
AO.RF.TunerPosition.HW2PhysicsParams = 1;
AO.RF.TunerPosition.Physics2HWParams = 1;
AO.RF.TunerPosition.Units = 'Hardware';
AO.RF.TunerPosition.HWUnits       = 'CM';
AO.RF.TunerPosition.PhysicsUnits  = 'CM';

AO.RF.CavityTemperatureControl.MemberOf = {'PlotFamily'; 'RF'; 'Setpoint'; 'Save';};
AO.RF.CavityTemperatureControl.Mode = 'Simulator';     
AO.RF.CavityTemperatureControl.DataType = 'Scalar';
AO.RF.CavityTemperatureControl.ChannelNames = 'BR4_____CAVTMP_AC03';
AO.RF.CavityTemperatureControl.HW2PhysicsParams = 1;
AO.RF.CavityTemperatureControl.Physics2HWParams = 1;
AO.RF.CavityTemperatureControl.Units = 'Hardware';
AO.RF.CavityTemperatureControl.HWUnits       = 'C';
AO.RF.CavityTemperatureControl.PhysicsUnits  = 'C';

AO.RF.CavityTemperature.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CavityTemperature.Mode = 'Simulator';     
AO.RF.CavityTemperature.DataType = 'Scalar';
AO.RF.CavityTemperature.ChannelNames = 'BR4_____CAVTMP_AM03';
AO.RF.CavityTemperature.HW2PhysicsParams = 1;
AO.RF.CavityTemperature.Physics2HWParams = 1;
AO.RF.CavityTemperature.Units = 'Hardware';
AO.RF.CavityTemperature.HWUnits       = 'C';
AO.RF.CavityTemperature.PhysicsUnits  = 'C';

AO.RF.LCWTemperature.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.LCWTemperature.Mode = 'Simulator';     
AO.RF.LCWTemperature.DataType = 'Scalar';
AO.RF.LCWTemperature.ChannelNames = 'BR4_____LCWTMP_AM03';
AO.RF.LCWTemperature.HW2PhysicsParams = 1;
AO.RF.LCWTemperature.Physics2HWParams = 1;
AO.RF.LCWTemperature.Units = 'Hardware';
AO.RF.LCWTemperature.HWUnits       = 'C';
AO.RF.LCWTemperature.PhysicsUnits  = 'C';

AO.RF.CircTemperature.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CircTemperature.Mode = 'Simulator';     
AO.RF.CircTemperature.DataType = 'Scalar';
AO.RF.CircTemperature.ChannelNames = 'BR4_____CIRTMP_AM03';
AO.RF.CircTemperature.HW2PhysicsParams = 1;
AO.RF.CircTemperature.Physics2HWParams = 1;
AO.RF.CircTemperature.Units = 'Hardware';
AO.RF.CircTemperature.HWUnits       = 'C';
AO.RF.CircTemperature.PhysicsUnits  = 'C';

AO.RF.CircLoadTemperature.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CircLoadTemperature.Mode = 'Simulator';     
AO.RF.CircLoadTemperature.DataType = 'Scalar';
AO.RF.CircLoadTemperature.ChannelNames = 'BR4_____CLDTMP_AM03';
AO.RF.CircLoadTemperature.HW2PhysicsParams = 1;
AO.RF.CircLoadTemperature.Physics2HWParams = 1;
AO.RF.CircLoadTemperature.Units = 'Hardware';
AO.RF.CircLoadTemperature.HWUnits       = 'C';
AO.RF.CircLoadTemperature.PhysicsUnits  = 'C';

AO.RF.CircLoadFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CircLoadFlow.Mode = 'Simulator';     
AO.RF.CircLoadFlow.DataType = 'Scalar';
AO.RF.CircLoadFlow.ChannelNames = 'BR4_____CLDFLW_AM01';
AO.RF.CircLoadFlow.HW2PhysicsParams = 1;
AO.RF.CircLoadFlow.Physics2HWParams = 1;
AO.RF.CircLoadFlow.Units = 'Hardware';
AO.RF.CircLoadFlow.HWUnits       = 'gpm';
AO.RF.CircLoadFlow.PhysicsUnits  = 'gpm';

AO.RF.CircFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CircFlow.Mode = 'Simulator';     
AO.RF.CircFlow.DataType = 'Scalar';
AO.RF.CircFlow.ChannelNames = 'BR4_____CIRFLW_AM02';
AO.RF.CircFlow.HW2PhysicsParams = 1;
AO.RF.CircFlow.Physics2HWParams = 1;
AO.RF.CircFlow.Units = 'Hardware';
AO.RF.CircFlow.HWUnits       = 'gpm';
AO.RF.CircFlow.PhysicsUnits  = 'gpm';

AO.RF.SwitchLoadFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.SwitchLoadFlow.Mode = 'Simulator';     
AO.RF.SwitchLoadFlow.DataType = 'Scalar';
AO.RF.SwitchLoadFlow.ChannelNames = 'BR4_____SLDFLW_AM00';
AO.RF.SwitchLoadFlow.HW2PhysicsParams = 1;
AO.RF.SwitchLoadFlow.Physics2HWParams = 1;
AO.RF.SwitchLoadFlow.Units = 'Hardware';
AO.RF.SwitchLoadFlow.HWUnits       = 'gpm';
AO.RF.SwitchLoadFlow.PhysicsUnits  = 'gpm';

AO.RF.CavityFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CavityFlow.Mode = 'Simulator';     
AO.RF.CavityFlow.DataType = 'Scalar';
AO.RF.CavityFlow.ChannelNames = 'BR4_____CAVFLW_AM00';
AO.RF.CavityFlow.HW2PhysicsParams = 1;
AO.RF.CavityFlow.Physics2HWParams = 1;
AO.RF.CavityFlow.Units = 'Hardware';
AO.RF.CavityFlow.HWUnits       = 'gpm';
AO.RF.CavityFlow.PhysicsUnits  = 'gpm';

AO.RF.WindowFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.WindowFlow.Mode = 'Simulator';     
AO.RF.WindowFlow.DataType = 'Scalar';
AO.RF.WindowFlow.ChannelNames = 'BR4_____WINFLW_AM01';
AO.RF.WindowFlow.HW2PhysicsParams = 1;
AO.RF.WindowFlow.Physics2HWParams = 1;
AO.RF.WindowFlow.Units = 'Hardware';
AO.RF.WindowFlow.HWUnits       = 'gpm';
AO.RF.WindowFlow.PhysicsUnits  = 'gpm';

AO.RF.CavityTunerFlow.MemberOf = {'PlotFamily'; 'RF'; 'Monitor'; 'Save';};
AO.RF.CavityTunerFlow.Mode = 'Simulator';     
AO.RF.CavityTunerFlow.DataType = 'Scalar';
AO.RF.CavityTunerFlow.ChannelNames = 'BR4_____TUNFLW_AM02';
AO.RF.CavityTunerFlow.HW2PhysicsParams = 1;
AO.RF.CavityTunerFlow.Physics2HWParams = 1;
AO.RF.CavityTunerFlow.Units = 'Hardware';
AO.RF.CavityTunerFlow.HWUnits       = 'gpm';
AO.RF.CavityTunerFlow.PhysicsUnits  = 'gpm';

AO.RF.Position = 0;


% RF_IRM???

AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {};
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = [1];
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;

AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = 'BR2_____ICT01__AM03';
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';

% Waveforms ICTs
% 'BR1_____ICT1___AT00'


% % This is a soft family for energy ramping
% AO.GeV.FamilyName = 'GeV';
% AO.GeV.MemberOf = {};
% AO.GeV.Status = 1;
% AO.GeV.DeviceList = [1 1];
% AO.GeV.ElementList = [1];
% 
% AO.GeV.Monitor.Mode = 'Simulator';
% AO.GeV.Monitor.DataType = 'Scalar';
% AO.GeV.Monitor.ChannelNames = '';
% AO.GeV.Monitor.SpecialFunctionGet = @getenergy_als;  %'bend2gev';
% AO.GeV.Monitor.HW2PhysicsParams = 1;
% AO.GeV.Monitor.Physics2HWParams = 1;
% AO.GeV.Monitor.Units = 'Hardware';
% AO.GeV.Monitor.HWUnits      = 'GeV';
% AO.GeV.Monitor.PhysicsUnits = 'GeV';
% 
% AO.GeV.Setpoint.Mode = 'Simulator';
% AO.GeV.Setpoint.DataType = 'Scalar';
% AO.GeV.Setpoint.ChannelNames = '';
% AO.GeV.Setpoint.SpecialFunctionGet = @getenergy_als;
% AO.GeV.Setpoint.SpecialFunctionSet = @setenergy_als;
% AO.GeV.Setpoint.HW2PhysicsParams = 1;
% AO.GeV.Setpoint.Physics2HWParams = 1;
% AO.GeV.Setpoint.Units = 'Hardware';
% AO.GeV.Setpoint.HWUnits      = 'GeV';
% AO.GeV.Setpoint.PhysicsUnits = 'GeV';


% % TV
% AO.TV.FamilyName = 'TV';
% AO.TV.MemberOf   = {'PlotFamily'; 'TV';};
% AO.TV.DeviceList = [1 1; 1 2; 4 1];
% AO.TV.ElementList = [1 2 3]';
% AO.TV.Status = ones(3,1);
% 
% AO.TV.Monitor.MemberOf   = {'PlotFamily'; };
% AO.TV.Monitor.Mode = 'Simulator';
% AO.TV.Monitor.DataType = 'Scalar';
% AO.TV.Monitor.ChannelNames = getname_booster(AO.TV.FamilyName, 'Monitor');
% AO.TV.Monitor.Units = 'Hardware';
% AO.TV.Monitor.HWUnits          = '';
% AO.TV.Monitor.PhysicsUnits     = '';
% AO.TV.Monitor.HW2PhysicsParams = 1;
% AO.TV.Monitor.Physics2HWParams = 1;
% 
% AO.TV.Setpoint.MemberOf   = {'TV'};
% AO.TV.Setpoint.Mode = 'Simulator';
% AO.TV.Setpoint.DataType = 'Scalar';
% AO.TV.Setpoint.ChannelNames = getname_booster(AO.TV.FamilyName, 'Setpoint');
% AO.TV.Setpoint.SpecialFunctionGet = @gettv_bts;
% AO.TV.Setpoint.SpecialFunctionSet = @settv_bts;
% AO.TV.Setpoint.Units = 'Hardware';
% AO.TV.Setpoint.HWUnits          = '';
% AO.TV.Setpoint.PhysicsUnits     = '';
% AO.TV.Setpoint.HW2PhysicsParams = 1;
% AO.TV.Setpoint.Physics2HWParams = 1;
% 
% AO.TV.In.MemberOf   = {'PlotFamily'; };
% AO.TV.In.Mode = 'Simulator';
% AO.TV.In.DataType = 'Scalar';
% AO.TV.In.ChannelNames = getname_booster(AO.TV.FamilyName, 'In');
% AO.TV.In.Units = 'Hardware';
% AO.TV.In.HWUnits          = '';
% AO.TV.In.PhysicsUnits     = '';
% AO.TV.In.HW2PhysicsParams = 1;
% AO.TV.In.Physics2HWParams = 1;
% 
% AO.TV.Out.MemberOf   = {'PlotFamily'; };
% AO.TV.Out.Mode = 'Simulator';
% AO.TV.Out.DataType = 'Scalar';
% AO.TV.Out.ChannelNames = getname_booster(AO.TV.FamilyName, 'Out');
% AO.TV.Out.Units = 'Hardware';
% AO.TV.Out.HWUnits          = '';
% AO.TV.Out.PhysicsUnits     = '';
% AO.TV.Out.HW2PhysicsParams = 1;
% AO.TV.Out.Physics2HWParams = 1;
% 
% AO.TV.InControl.MemberOf   = {'PlotFamily'; };
% AO.TV.InControl.Mode = 'Simulator';
% AO.TV.InControl.DataType = 'Scalar';
% AO.TV.InControl.ChannelNames = getname_booster(AO.TV.FamilyName, 'InControl');
% AO.TV.InControl.Units = 'Hardware';
% AO.TV.InControl.HWUnits          = '';
% AO.TV.InControl.PhysicsUnits     = '';
% AO.TV.InControl.HW2PhysicsParams = 1;
% AO.TV.InControl.Physics2HWParams = 1;
% 
% AO.TV.Lamp.MemberOf   = {'PlotFamily'; };
% AO.TV.Lamp.Mode = 'Simulator';
% AO.TV.Lamp.DataType = 'Scalar';
% AO.TV.Lamp.ChannelNames = getname_booster(AO.TV.FamilyName, 'Lamp');
% AO.TV.Lamp.Units = 'Hardware';
% AO.TV.Lamp.HWUnits          = '';
% AO.TV.Lamp.PhysicsUnits     = '';
% AO.TV.Lamp.HW2PhysicsParams = 1;
% AO.TV.Lamp.Physics2HWParams = 1;

% Save the AO so that family2dev will work
setao(AO);


%%%%%%%%%%%%%
% Get Range %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Range     = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.HCM.RampRate.Range     = [-10 10];

AO.VCM.Setpoint.Range     = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.VCM.RampRate.Range     = [-10 10];

AO.QF.Setpoint.Range     = [local_minsp(AO.QF.FamilyName, AO.QF.DeviceList) local_maxsp(AO.QF.FamilyName, AO.QF.DeviceList)];
%AO.QF.RampRate.Range     = [0 10000];
%AO.QF.TimeConstant.Range = [0 10000];
 
AO.QD.Setpoint.Range     = [local_minsp(AO.QD.FamilyName, AO.QD.DeviceList) local_maxsp(AO.QD.FamilyName, AO.QD.DeviceList)];
%AO.QD.RampRate.Range     = [0 10000];
%AO.QD.TimeConstant.Range = [0 10000];

AO.SF.Setpoint.Range     = [local_minsp(AO.SF.FamilyName, AO.SF.DeviceList) local_maxsp(AO.SF.FamilyName, AO.SF.DeviceList)];
%AO.SF.RampRate.Range     = [0 10000];
%AO.SF.TimeConstant.Range = [0 10000];

AO.SF_IRM.Setpoint.Range     = [local_minsp(AO.SF.FamilyName, AO.SF.DeviceList) local_maxsp(AO.SF.FamilyName, AO.SF.DeviceList)];
AO.SD_IRM.Setpoint.Range     = [local_minsp(AO.SD.FamilyName, AO.SD.DeviceList) local_maxsp(AO.SD.FamilyName, AO.SD.DeviceList)];
AO.SF_IRM.RampRate.Range     = [-100 100];
AO.SD_IRM.RampRate.Range     = [-100 100];

AO.SD.Setpoint.Range     = [local_minsp(AO.SD.FamilyName, AO.SD.DeviceList) local_maxsp(AO.SD.FamilyName, AO.SD.DeviceList)];
%AO.SD.RampRate.Range     = [0 10000];
%AO.SD.TimeConstant.Range = [0 10000];

AO.BEND.Setpoint.Range     = [local_minsp(AO.BEND.FamilyName, AO.BEND.DeviceList) local_maxsp(AO.BEND.FamilyName, AO.BEND.DeviceList)];
%AO.BEND.RampRate.Range     = [0 10000];
%AO.BEND.TimeConstant.Range = [0 10000];


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response Matrix Kick Size (hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = .5e-3;
AO.VCM.Setpoint.DeltaRespMat = .5e-3;
AO.QF.Setpoint.DeltaRespMat   = 1e-5;
AO.QD.Setpoint.DeltaRespMat   = 1e-5;
AO.SF.Setpoint.DeltaRespMat   = 1e-5;
AO.SD.Setpoint.DeltaRespMat   = 1e-5;
AO.SF_IRM.Setpoint.DeltaRespMat = 1e-5;
AO.SD_IRM.Setpoint.DeltaRespMat = 1e-5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName)  * ones(length(AO.HCM.ElementList),  1);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName)  * ones(length(AO.VCM.ElementList),  1);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName)   * ones(length(AO.QF.ElementList),   1);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName)   * ones(length(AO.QD.ElementList),   1);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName)   * ones(length(AO.SF.ElementList),   1);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName)   * ones(length(AO.SD.ElementList),   1);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName) * ones(length(AO.BEND.ElementList), 1);
%AO.TV.Setpoint.Tolerance   = gettol(AO.TV.FamilyName)   * ones(length(AO.TV.ElementList),   1);

AO.SF_IRM.Setpoint.Tolerance = gettol(AO.SF.FamilyName) * ones(length(AO.SF.ElementList),  1);
AO.SD_IRM.Setpoint.Tolerance = gettol(AO.SD.FamilyName) * ones(length(AO.SD.ElementList),  1);

setao(AO);



function [Amps] = local_minsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    else
        fprintf('   Minimum setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = 6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 6;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 130;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 130;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 130;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 130;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'TV')
        Amps(i,1) = .1;
    else
        fprintf('   Maximum setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  tolerance on the SP-AM for that family

if strcmp(Family,'HCM')
    tol = 0.1;
elseif strcmp(Family,'VCM')
    tol = 0.1;
elseif strcmp(Family,'QF')
    tol = 0.6;
elseif strcmp(Family,'QD')
    tol = 0.6;
elseif strcmp(Family,'SF')
    tol = 0.6;
elseif strcmp(Family,'SD')
    tol = 0.6;
elseif strcmp(Family,'BEND')
    tol = .5;
elseif strcmp(Family,'TV')
    tol = .5;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end


