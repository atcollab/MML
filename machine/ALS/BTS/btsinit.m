function btsinit(OperationalMode)
%BTSINIT


% To do
% 1. units and conversions for the bumps, etc.
% 2. SR bumps? - should they be in the save restore?  Ramp rate protection?
% 3. corrector amp2k
% 4. check one point in Q amp2k table (get the book from Ken)
% 5. ramprates
% 6. Check turn on/off
% 7. Runflag will be difficult for the BEND 1-3.  Probably best to use a delay based on the ramprate?

% Measurements
% 1. monmags
% 2. measamlinearity
% 3. monbpm
% 4. measbpmresp,
% 5. QMS


if nargin < 1
    % 1 => 1.9   GeV injection
    % 2 => 1.23  GeV injection
    % 3 => 1.522 GeV injection    
    OperationalMode = 1;
end


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);
setad([]);


% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMx';};
AO.BPMx.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6;];
AO.BPMx.ElementList = [1 2 3 4 5 6]';
AO.BPMx.Status = [1 1 1 1 1 1]';
AO.BPMx.Position = [];

AO.BPMx.Monitor.MemberOf = {};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = []; %getname_bts(AO.BPMx.FamilyName, 'Monitor');
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getbpm_bts;

AO.BPMx.Sum.MemberOf = {};
AO.BPMx.Sum.Mode = 'Simulator';
AO.BPMx.Sum.DataType = 'Scalar';
AO.BPMx.Sum.ChannelNames = []; %getname_bts(AO.BPMx.FamilyName, 'Sum');
AO.BPMx.Sum.HW2PhysicsParams = 1; 
AO.BPMx.Sum.Physics2HWParams = 1;
AO.BPMx.Sum.Units        = 'Hardware';
AO.BPMx.Sum.HWUnits      = 'mm';
AO.BPMx.Sum.PhysicsUnits = 'Meter';
%AO.BPMx.Sum.SpecialFunctionGet = @getbpm_bts;

AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;
AO.BPMy.Position = [];

AO.BPMy.Monitor.MemberOf = {};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = []; %getname_bts(AO.BPMy.FamilyName, 'Monitor');
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'Meter';
%AO.BPMy.Monitor.SpecialFunctionGet = @getbpm_bts;

AO.BPMy.Sum.MemberOf = {};
AO.BPMy.Sum.Mode = 'Simulator';
AO.BPMy.Sum.DataType = 'Scalar';
AO.BPMy.Sum.ChannelNames = []; %getname_bts(AO.BPMy.FamilyName, 'Sum');
AO.BPMy.Sum.HW2PhysicsParams = 1; 
AO.BPMy.Sum.Physics2HWParams = 1;
AO.BPMy.Sum.Units        = 'Hardware';
AO.BPMy.Sum.HWUnits      = 'mm';
AO.BPMy.Sum.PhysicsUnits = 'Meter';
%AO.BPMy.Sum.SpecialFunctionGet = @getbpm_bts;

% BPM
setao(AO);
AO = buildmmlbpmfamily(AO, 'BTS');

AO.BPMx.Monitor.ChannelNames = AO.BPM.X.ChannelNames;
AO.BPMy.Monitor.ChannelNames = AO.BPM.Y.ChannelNames;
AO.BPMx.Sum.ChannelNames     = AO.BPM.S.ChannelNames;
AO.BPMy.Sum.ChannelNames     = AO.BPM.S.ChannelNames;


% HCM
AO.HCM.FamilyName = 'HCM';
AO.HCM.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9];
AO.HCM.BaseName = {
    'BTS:HCM1'
    'BTS:HCM2'
    'BTS:HCM3'
    'BTS:HCM4'
    'BTS:HCM5'
    'BTS:HCM6'
    'BTS:HCM7'
    'BTS:HCM8'
    'BTS:HCM9'
    };
AO.HCM.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    };
AO.HCM = buildmmlcaen(AO.HCM, 5);
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.ElementList = [1 2 3 4 5 6 7 8 9]';
AO.HCM.Status = ones(9,1);
AO.HCM.Position = [];
AO.HCM.CommonNames = getname_bts('HCM', 'CommonNames');

AO.HCM.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.HCM.Monitor.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Monitor');
AO.HCM.Monitor = rmfield(AO.HCM.Monitor, 'HW2PhysicsParams');
AO.HCM.Monitor = rmfield(AO.HCM.Monitor, 'Physics2HWParams');
AO.HCM.Monitor.HW2PhysicsFcn = @bts2at;
AO.HCM.Monitor.Physics2HWFcn = @at2bts;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'Save/Restore'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Setpoint');
AO.HCM.Setpoint = rmfield(AO.HCM.Setpoint, 'HW2PhysicsParams');
AO.HCM.Setpoint = rmfield(AO.HCM.Setpoint, 'Physics2HWParams');
AO.HCM.Setpoint.HW2PhysicsFcn = @bts2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2bts;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Tolerance    = gettol(AO.HCM.FamilyName) * ones(length(AO.HCM.ElementList), 1);
AO.HCM.Setpoint.DeltaRespMat = 1;  % (hardware units)
AO.HCM.Setpoint.Range        = [
    -4.5 4.5
    -4.5 4.5
    -6.0 6.0
    -6.0 6.0
    -6.0 6.0
    -6.0 6.0
    -6.0 6.0
    -4.5 4.5
    -4.5 4.5
    ];

AO.HCM.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.HCM.RampRate.ChannelNames = getname_bts(AO.HCM.FamilyName, 'RampRate');
AO.HCM.RampRate.Range        = [0 50];

AO.HCM.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.HCM.OnControl.ChannelNames = getname_bts(AO.HCM.FamilyName, 'OnControl');
AO.HCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.HCM.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.HCM.On.ChannelNames = getname_bts(AO.HCM.FamilyName, 'On');

AO.HCM.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
%AO.HCM.Reset.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Reset');

AO.HCM.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Ready');
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units        = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName = 'VCM';
AO.VCM.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9];
AO.VCM.BaseName = {
    'BTS:VCM1'
    'BTS:VCM2'
    'BTS:VCM3'
    'BTS:VCM4'
    'BTS:VCM5'
    'BTS:VCM6'
    'BTS:VCM7'
    'BTS:VCM8'
    'BTS:VCM9'
    };
AO.VCM.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    };
AO.VCM = buildmmlcaen(AO.VCM, 5);
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet';};
AO.VCM.ElementList = [1 2 3 4 5 6 7 8 9]';
AO.VCM.Status = ones(9,1);
AO.VCM.Position = [];
AO.VCM.CommonNames = getname_bts('VCM', 'CommonNames');

AO.VCM.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Monitor');
AO.VCM.Monitor = rmfield(AO.VCM.Monitor, 'HW2PhysicsParams');
AO.VCM.Monitor = rmfield(AO.VCM.Monitor, 'Physics2HWParams');
AO.VCM.Monitor.HW2PhysicsFcn = @bts2at;
AO.VCM.Monitor.Physics2HWFcn = @at2bts;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'Save/Restore'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Setpoint');
AO.VCM.Setpoint = rmfield(AO.VCM.Setpoint, 'HW2PhysicsParams');
AO.VCM.Setpoint = rmfield(AO.VCM.Setpoint, 'Physics2HWParams');
AO.VCM.Setpoint.HW2PhysicsFcn = @bts2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2bts;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Tolerance    = gettol(AO.VCM.FamilyName) * ones(length(AO.VCM.ElementList), 1);
AO.VCM.Setpoint.DeltaRespMat = 1;  % (hardware units)
AO.VCM.Setpoint.Range        = AO.HCM.Setpoint.Range;

AO.VCM.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.VCM.RampRate.ChannelNames = getname_bts(AO.VCM.FamilyName, 'RampRate');
AO.VCM.RampRate.Range        = [0 50];

AO.VCM.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCM.OnControl.ChannelNames = getname_bts(AO.VCM.FamilyName, 'OnControl');
%AO.VCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCM.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCM.On.ChannelNames = getname_bts(AO.VCM.FamilyName, 'On');

AO.VCM.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
%AO.VCM.Reset.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Reset');

AO.VCM.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Ready');
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units        = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';


% Quadrupoles (QF & QD all in one family)
AO.Q.FamilyName = 'Q';
AO.Q.MemberOf   = {'PlotFamily'; 'QUAD'; 'Magnet';};
AO.Q.DeviceList = [1 1; 2 1; 2 2; 3 1; 3 2; 4 1; 5 1; 5 2; 6 1; 6 2; 7 1;];
AO.Q.ElementList = (1:size(AO.Q.DeviceList,1))';
AO.Q.Status = 1;
AO.Q.Position = [];
AO.Q.CommonNames = getname_bts('Q', 'CommonNames');
AO.Q.BaseName = {
    'irm:045:'
    'irm:045:'
    'irm:045:'
    'irm:046:'
    'irm:046:'
    'irm:047:'
    'irm:047:'
    'irm:047:'
    'irm:048:'
    'irm:048:'
    'irm:048:'
    };
AO.Q.DeviceType = {
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
};

AO.Q.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.Q.Monitor.Mode = 'Simulator';
AO.Q.Monitor.DataType = 'Scalar';
AO.Q.Monitor.ChannelNames = getname_bts(AO.Q.FamilyName, 'Monitor');
AO.Q.Monitor.HW2PhysicsFcn = @bts2at;
AO.Q.Monitor.Physics2HWFcn = @at2bts;
AO.Q.Monitor.Units        = 'Hardware';
AO.Q.Monitor.HWUnits      = 'Ampere';
AO.Q.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q.Setpoint.MemberOf = {'Save/Restore';};
AO.Q.Setpoint.Mode = 'Simulator';
AO.Q.Setpoint.DataType = 'Scalar';
AO.Q.Setpoint.ChannelNames = getname_bts(AO.Q.FamilyName, 'Setpoint');
AO.Q.Setpoint.HW2PhysicsFcn = @bts2at;
AO.Q.Setpoint.Physics2HWFcn = @at2bts;
AO.Q.Setpoint.Units        = 'Hardware';
AO.Q.Setpoint.HWUnits      = 'Ampere';
AO.Q.Setpoint.PhysicsUnits = '1/Meter^2';
AO.Q.Setpoint.Range        = [local_minsp(AO.Q.FamilyName, AO.Q.DeviceList) local_maxsp(AO.Q.FamilyName, AO.Q.DeviceList)];
AO.Q.Setpoint.Tolerance    = gettol(AO.Q.FamilyName) * ones(length(AO.Q.ElementList), 1);
AO.Q.Setpoint.DeltaRespMat = 1;   % (hardware units)
AO.Q.Setpoint.RampRate = [
   2.0  % Measured -2.1420
   2.0  % Measured -2.1484
   3.1  % Measured -3.3064
   3.1  % Measured -3.3456
   2.0  % Measured -2.1420
   3.5  % Measured -3.6854
   3.5  % Measured -3.6870
   3.5  % Measured -3.6870
   3.5  % Measured -3.6735
   3.5  % Measured -3.6691
   3.5  % Measured -3.6687
    ];
%AO.Q.Setpoint.RampRate = .8*AO.Q.Setpoint.RampRate;

% AO.Q.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.Q.RampRate.Mode = 'Simulator';
% AO.Q.RampRate.DataType = 'Scalar';
% AO.Q.RampRate.ChannelNames = getname_bts('Q', 'RampRate');
% AO.Q.RampRate.HW2PhysicsFcn = @bts2at;
% AO.Q.RampRate.Physics2HWFcn = @at2bts;
% AO.Q.RampRate.Units        = 'Hardware';
% AO.Q.RampRate.HWUnits      = 'Ampere/Second';
% AO.Q.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.Q.RampRate.Range        = [0 10000];
% 
% AO.Q.TimeConstant.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.Q.TimeConstant.Mode = 'Simulator';
% AO.Q.TimeConstant.DataType = 'Scalar';
% AO.Q.TimeConstant.ChannelNames = getname_bts('Q', 'TimeConstant');
% AO.Q.TimeConstant.HW2PhysicsParams = 1;
% AO.Q.TimeConstant.Physics2HWParams = 1;
% AO.Q.TimeConstant.Units        = 'Hardware';
% AO.Q.TimeConstant.HWUnits      = 'Second';
% AO.Q.TimeConstant.PhysicsUnits = 'Second';
% AO.Q.TimeConstant.Range        = [0 10000];
% 
% AO.Q.DAC.MemberOf = {'PlotFamily'; 'Save';};
% AO.Q.DAC.Mode = 'Simulator';
% AO.Q.DAC.DataType = 'Scalar';
% AO.Q.DAC.ChannelNames = getname_bts('Q', 'DAC');
% AO.Q.DAC.HW2PhysicsParams = 1;
% AO.Q.DAC.Physics2HWParams = 1;
% AO.Q.DAC.Units        = 'Hardware';
% AO.Q.DAC.HWUnits      = 'Ampere';
% AO.Q.DAC.PhysicsUnits = 'Ampere';

AO.Q.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.Q.OnControl.Mode = 'Simulator';
AO.Q.OnControl.DataType = 'Scalar';
AO.Q.OnControl.ChannelNames = getname_bts('Q', 'OnControl');
AO.Q.OnControl.HW2PhysicsParams = 1;
AO.Q.OnControl.Physics2HWParams = 1;
AO.Q.OnControl.Units        = 'Hardware';
AO.Q.OnControl.HWUnits      = '';
AO.Q.OnControl.PhysicsUnits = '';
AO.Q.OnControl.Range        = [0 1];
AO.Q.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.Q.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.Q.On.Mode = 'Simulator';
AO.Q.On.DataType = 'Scalar';
AO.Q.On.ChannelNames = getname_bts('Q', 'On');
AO.Q.On.HW2PhysicsParams = 1;
AO.Q.On.Physics2HWParams = 1;
AO.Q.On.Units        = 'Hardware';
AO.Q.On.HWUnits      = '';
AO.Q.On.PhysicsUnits = '';

AO.Q.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.Q.Ready.Mode = 'Simulator';
AO.Q.Ready.DataType = 'Scalar';
AO.Q.Ready.ChannelNames = getname_bts('Q', 'Ready');
AO.Q.Ready.HW2PhysicsParams = 1;
AO.Q.Ready.Physics2HWParams = 1;
AO.Q.Ready.Units        = 'Hardware';
AO.Q.Ready.HWUnits      = '';
AO.Q.Ready.PhysicsUnits = '';

AO.Q.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.Q.Reset.Mode = 'Simulator';
AO.Q.Reset.DataType = 'Scalar';
AO.Q.Reset.ChannelNames = getname_bts('Q', 'Reset');
AO.Q.Reset.HW2PhysicsParams = 1;
AO.Q.Reset.Physics2HWParams = 1;
AO.Q.Reset.Units        = 'Hardware';
AO.Q.Reset.HWUnits      = '';
AO.Q.Reset.PhysicsUnits = '';
AO.Q.Reset.Range        = [0 1];


% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = [1 1; 1 2; 1 3; 1 4;];
AO.BEND.ElementList = [1 2 3 4]';
AO.BEND.Status = [1 1 1 1]';
AO.BEND.Position = [];
AO.BEND.CommonNames = getname_bts('BEND', 'CommonNames');
AO.BEND.BaseName = {
    ''
    ''
    ''
    ''
    };
AO.BEND.DeviceType = {
    ''
    ''
    ''
    ''
};

AO.BEND.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @bts2at;
AO.BEND.Monitor.Physics2HWFcn = @at2bts;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'Save/Restore';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @bts2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2bts;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';
AO.BEND.Setpoint.Range        = [local_minsp(AO.BEND.FamilyName, AO.BEND.DeviceList) local_maxsp(AO.BEND.FamilyName, AO.BEND.DeviceList)];
AO.BEND.Setpoint.Tolerance    = gettol(AO.BEND.FamilyName) * ones(length(AO.BEND.ElementList), 1);

% AO.BEND.RampRate.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.BEND.RampRate.Mode = 'Simulator';
% AO.BEND.RampRate.DataType = 'Scalar';
% AO.BEND.RampRate.ChannelNames = getname_bts(AO.BEND.FamilyName, 'RampRate');
% AO.BEND.RampRate.HW2PhysicsParams = 1;
% AO.BEND.RampRate.Physics2HWParams = 1;
% AO.BEND.RampRate.Units        = 'Hardware';
% AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
% AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.BEND.RampRate.Range        = [0 10000];
% 
% AO.BEND.TimeConstant.MemberOf = {'PlotFamily'; 'Save/Restore';};
% AO.BEND.TimeConstant.Mode = 'Simulator';
% AO.BEND.TimeConstant.DataType = 'Scalar';
% AO.BEND.TimeConstant.ChannelNames = getname_bts(AO.BEND.FamilyName, 'TimeConstant');
% AO.BEND.TimeConstant.HW2PhysicsParams = 1;
% AO.BEND.TimeConstant.Physics2HWParams = 1;
% AO.BEND.TimeConstant.Units        = 'Hardware';
% AO.BEND.TimeConstant.HWUnits      = 'Second';
% AO.BEND.TimeConstant.PhysicsUnits = 'Second';
% AO.BEND.TimeConstant.Range        = [0 10000];
% 
% AO.BEND.DAC.MemberOf = {'PlotFamily'; 'Save';};
% AO.BEND.DAC.Mode = 'Simulator';
% AO.BEND.DAC.DataType = 'Scalar';
% AO.BEND.DAC.ChannelNames = getname_bts(AO.BEND.FamilyName, 'DAC');
% AO.BEND.DAC.HW2PhysicsParams = 1;
% AO.BEND.DAC.Physics2HWParams = 1;
% AO.BEND.DAC.Units        = 'Hardware';
% AO.BEND.DAC.HWUnits      = 'Ampere';
% AO.BEND.DAC.PhysicsUnits = 'Ampere';

AO.BEND.RampRate.MemberOf = {'PlotFamily'; 'Control';};
AO.BEND.RampRate.Mode = 'Simulator';
AO.BEND.RampRate.DataType = 'Scalar';
AO.BEND.RampRate.ChannelNames = getname_bts(AO.BEND.FamilyName, 'RampRate');
AO.BEND.RampRate.HW2PhysicsParams = 1;
AO.BEND.RampRate.Physics2HWParams = 1;
AO.BEND.RampRate.Units        = 'Hardware';
AO.BEND.RampRate.HWUnits      = '';
AO.BEND.RampRate.PhysicsUnits = '';
AO.BEND.RampRate.Range        = [0 50];
AO.BEND.RampRate.SpecialFunctionGet = @getramprate_bts;
AO.BEND.RampRate.SpecialFunctionSet = @setramprate_bts;

AO.BEND.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_bts(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range        = [0 1];
AO.BEND.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.BEND.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_bts(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units        = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units        = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';

AO.BEND.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.Reset.Mode = 'Simulator';
AO.BEND.Reset.DataType = 'Scalar';
AO.BEND.Reset.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Reset');
AO.BEND.Reset.HW2PhysicsParams = 1;
AO.BEND.Reset.Physics2HWParams = 1;
AO.BEND.Reset.Units        = 'Hardware';
AO.BEND.Reset.HWUnits      = '';
AO.BEND.Reset.PhysicsUnits = '';
AO.BEND.Reset.Range        = [0 1];



%%%%%%%%%%%%%%%%%%%%%
% Injection Magnets %
%%%%%%%%%%%%%%%%%%%%%

% BR Bump Magnets
AO.BRBump.FamilyName = 'BRBump';
AO.BRBump.MemberOf = {'Bump Magnet'; 'PlotFamily';};
AO.BRBump.DeviceList = [1 1;1 2;1 3;];
AO.BRBump.ElementList = [1 2 3]';
AO.BRBump.Status = [1 1 1]';
AO.BRBump.Position = [];
AO.BRBump.CommonNames = [
    'BR Bump Magnet 1'
    'BR Bump Magnet 2'
    'BR Bump Magnet 3'
    ];

AO.BRBump.Monitor.MemberOf = {'Bump Magnet'; 'Monitor'; 'Save';};
AO.BRBump.Monitor.Mode = 'Simulator';
AO.BRBump.Monitor.DataType = 'Scalar';
AO.BRBump.Monitor.ChannelNames = ['BR2_____BUMP1__AM00';'BR2_____BUMP2__AM02';'BR2_____BUMP3__AM00'];
AO.BRBump.Monitor.HW2PhysicsParams = [1;1;1];
AO.BRBump.Monitor.Physics2HWParams = 1./AO.BRBump.Monitor.HW2PhysicsParams;
AO.BRBump.Monitor.Units        = 'Hardware';
AO.BRBump.Monitor.HWUnits      = 'Volts';
AO.BRBump.Monitor.PhysicsUnits = 'Radian';

AO.BRBump.Setpoint.MemberOf = {'Bump Magnet'; 'Save/Restore';};
AO.BRBump.Setpoint.Mode = 'Simulator';
AO.BRBump.Setpoint.DataType = 'Scalar';
AO.BRBump.Setpoint.ChannelNames = ['BR2_____BUMP1__AC00';'BR2_____BUMP2__AC01';'BR2_____BUMP3__AC00'];
AO.BRBump.Setpoint.HW2PhysicsParams = AO.BRBump.Monitor.HW2PhysicsParams;
AO.BRBump.Setpoint.Physics2HWParams = AO.BRBump.Monitor.Physics2HWParams;
AO.BRBump.Setpoint.Units        = 'Hardware';
AO.BRBump.Setpoint.HWUnits      = 'Volts';
AO.BRBump.Setpoint.PhysicsUnits = 'Radian';
AO.BRBump.Setpoint.Range = [0 Inf];
AO.BRBump.Setpoint.Tolerance = 0;


% BR Kickers
AO.Kicker.FamilyName = 'Kicker';
AO.Kicker.MemberOf = {'Kicker';};
AO.Kicker.DeviceList = [1 1;1 2];
AO.Kicker.ElementList = [1; 1];
AO.Kicker.Status = 1;
AO.Kicker.Position = [0; 20];  % ???
AO.Kicker.CommonNames = [
    'BR Injection Kicker';
    'BR Extration Kicker';];

AO.Kicker.Monitor.MemberOf = {'Kicker'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.Kicker.Monitor.Mode = 'Simulator';
AO.Kicker.Monitor.DataType = 'Scalar';
AO.Kicker.Monitor.ChannelNames = [ ...
    'BR1_____KI_____AM00';
    'BR2_____KE_____AM00';];
AO.Kicker.Monitor.HW2PhysicsParams = 1;  % Nominal hardware 95.1708;
AO.Kicker.Monitor.Physics2HWParams = 1 ./ AO.Kicker.Monitor.HW2PhysicsParams;
AO.Kicker.Monitor.Units        = 'Hardware';
AO.Kicker.Monitor.HWUnits      = '';
AO.Kicker.Monitor.PhysicsUnits = '';

AO.Kicker.Setpoint.MemberOf = {'Kicker'; 'Save/Restore'; 'PlotFamily';};
AO.Kicker.Setpoint.Mode = 'Simulator';
AO.Kicker.Setpoint.DataType = 'Scalar';
AO.Kicker.Setpoint.ChannelNames = [ ...
    'BR1_____KI_____AC00';
    'BR2_____KE_____AC00';];
AO.Kicker.Setpoint.HW2PhysicsParams = 1;  % Nominal hardware 95.1708;
AO.Kicker.Setpoint.Physics2HWParams = 1 ./ AO.Kicker.Setpoint.HW2PhysicsParams;
AO.Kicker.Setpoint.Units        = 'Hardware';
AO.Kicker.Setpoint.HWUnits      = '';
AO.Kicker.Setpoint.PhysicsUnits = '';
AO.Kicker.Setpoint.Range = [0 Inf];


% Thin & Thick Septum
AO.Septum.FamilyName = 'Septum';
AO.Septum.MemberOf = {'Septum'; 'PlotFamily';};
AO.Septum.DeviceList = [1 1;1 2;2 1;2 2];
AO.Septum.ElementList = [1;2;3;4];
AO.Septum.Status = [1;1;1;1];
AO.Septum.Position = [];
AO.Septum.CommonNames = [
    'BR Thin Septum '
    'BR Thick Septum'
    'SR Thick Septum'
    'SR Thin Septum '
    ];

AO.Septum.Monitor.MemberOf = {'Septum'; 'Monitor'; 'Save';};
AO.Septum.Monitor.Mode = 'Simulator';
AO.Septum.Monitor.DataType = 'Scalar';
AO.Septum.Monitor.ChannelNames = [
    'BR2_____SEN____AM00';
    'BR2_____SEK____AM02';
    'SR01S___SEK____AM02';
    'SR01S___SEN____AM00';];
AO.Septum.Monitor.HW2PhysicsParams = [
     2.00*pi/180 / 1296.9
    10.00*pi/180 / 3908.9
    10.07*pi/180 / 3723.5
     2.00*pi/180 / 1819.8];
AO.Septum.Monitor.Physics2HWParams = 1./AO.Septum.Monitor.HW2PhysicsParams;
AO.Septum.Monitor.Units        = 'Hardware';
AO.Septum.Monitor.HWUnits      = 'Volts';
AO.Septum.Monitor.PhysicsUnits = 'Radian';

AO.Septum.Setpoint.MemberOf = {'Septum'; 'Save/Restore';};
AO.Septum.Setpoint.Mode = 'Simulator';
AO.Septum.Setpoint.DataType = 'Scalar';
AO.Septum.Setpoint.ChannelNames = [
    'BR2_____SEN____AC00';
    'BR2_____SEK____AC01';
    'SR01S___SEK____AC01';
    'SR01S___SEN____AC00';];
AO.Septum.Setpoint.HW2PhysicsParams = AO.Septum.Monitor.HW2PhysicsParams;
AO.Septum.Setpoint.Physics2HWParams = AO.Septum.Monitor.Physics2HWParams;
AO.Septum.Setpoint.Units        = 'Hardware';
AO.Septum.Setpoint.HWUnits      = 'Volts';
AO.Septum.Setpoint.PhysicsUnits = 'Radian';
AO.Septum.Setpoint.Range = [0 Inf];
AO.Septum.Setpoint.Tolerance = 0;


% BR2_____SEN____BC20	HV_ON/OFF_CNTRL
% BR2_____SEN____BM02	CRASH_OFF_MON
% BR2_____SEN____BM05	REMOTE_ON_MON
% BR2_____SEN____BM04	PS_O/T
% BR2_____SEN____BM01	VAC OK
% BR2_____SEN____BM06	HV_ON_MON
% BR2_____SEN____BM03	HV_READY_MON
% BR2_____SEN____BM00	MAG_COVER_ON_MON
% 
% BR2_____SEK____BC21	HV_ON/OFF_CNTRL
% BR2_____SEK____BM07	MAG_COVER_ON_MON
% BR2_____SEK____BM08	VAC OK
% BR2_____SEK____BM09	CRASH_OFF_MON
% BR2_____SEK____BM11	RACK/AIR OK
% BR2_____SEK____BM12	REMOTE_ON_MON
% BR2_____SEK____BM13	HV_ON_MON
% BR2_____SEK____BM10	HV_READY_MON
% 
% SR01S___SEK____BC21	HV_ON/OFF_CNTRL
% SR01S___SEK_P__BC23	TRIGGER_ENABLED
% SR01S___SEK____BM07	SEK CRASH OFF OK
% SR01S___SEK____BM14	SEK AIRFLOW MON
% SR01S___SEK____BM09	SEK HV COVER ON
% SR01S___SEK____BM08	SEK VACUUM OK
% SR01S___SEK____BM13	SEK HV ON MON
% SR01S___SEK____BM10	SEK HV RDY MON
% SR01S___SEK____BM12	CRASH OFF OK
% SR01S___SEK____BM11	NOT USED
% 
% SR01S___SEN____BC20	HV_ON/OFF_CNTRL
% SR01S___SEN_P__BC22	TRIGGER_ENABLED
% SR01S___SEN____BM05	SEN REM/LOC MON
% SR01S___SEN____BM01	SEN VACUUM OK
% SR01S___SEN____BM00	SEN CRASH OFF OK
% SR01S___SEN____BM06	SEN HV ON MON
% SR01S___SEN____BM02	SEN HV COVER ON
% SR01S___SEN____BM03	SEN HV RDY MON
% SR01S___SEN____BM04	SEN PS OVRTMP OK




% SR Bump Magnets
AO.SRBump.FamilyName = 'SRBump';
AO.SRBump.MemberOf = {'Bump Magnet'; 'PlotFamily';};
AO.SRBump.DeviceList = [12 1;12 2;1 3;1 4];
AO.SRBump.ElementList = [1 2 3 4]';
AO.SRBump.Status = [1 1 1 1]';
AO.SRBump.Position = [];
AO.SRBump.CommonNames = [
    'SR Bump Magnet 1'
    'SR Bump Magnet 2'
    'SR Bump Magnet 3'
    'SR Bump Magnet 4'
    ];

AO.SRBump.Monitor.MemberOf = {'Bump Magnet'; 'Monitor'; 'Save';};
AO.SRBump.Monitor.Mode = 'Simulator';
AO.SRBump.Monitor.DataType = 'Scalar';
AO.SRBump.Monitor.ChannelNames = [
    'SR01S___BUMP1__AM00'; 
    'SR01S___BUMP1__AM00'; 
    'SR01S___BUMP1__AM00'; 
    'SR01S___BUMP1__AM00';];
AO.SRBump.Monitor.HW2PhysicsParams = 1;
AO.SRBump.Monitor.Physics2HWParams = 1;
AO.SRBump.Monitor.Units        = 'Hardware';
AO.SRBump.Monitor.HWUnits      = 'Volts';
AO.SRBump.Monitor.PhysicsUnits = 'Radian';

AO.SRBump.Setpoint.MemberOf = {'Bump Magnet'; 'Save/Restore';};
AO.SRBump.Setpoint.Mode = 'Simulator';
AO.SRBump.Setpoint.DataType = 'Scalar';
AO.SRBump.Setpoint.ChannelNames = [
    'SR01S___BUMP1__AC00'; 
    'SR01S___BUMP1__AC00'; 
    'SR01S___BUMP1__AC00'; 
    'SR01S___BUMP1__AC00';];
AO.SRBump.Setpoint.HW2PhysicsParams = AO.SRBump.Monitor.HW2PhysicsParams;
AO.SRBump.Setpoint.Physics2HWParams = AO.SRBump.Monitor.Physics2HWParams;
AO.SRBump.Setpoint.Units        = 'Hardware';
AO.SRBump.Setpoint.HWUnits      = 'Volts';
AO.SRBump.Setpoint.PhysicsUnits = 'Radian';
AO.SRBump.Setpoint.Range = [0 Inf];
AO.SRBump.Setpoint.Tolerance = 0;


AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT';};
AO.DCCT.DeviceList = [1 1;1 2];
AO.DCCT.ElementList = [1;2];
AO.DCCT.Status = [1;1;];
AO.DCCT.Position = [0;35];  % ???

AO.DCCT.MemberOf = {'DCCT'; 'Monitor';};
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = ['BTS_____ICT01__AM00';'BTS_____ICT02__AM01'];
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units        = 'Hardware';
AO.DCCT.Monitor.HWUnits      = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';
%AO.DCCT.Monitor.SpecialFunctionGet = 'getdcct_bts';

% Other ICTs
% 'LTB_____ICT01__AM02'
% 'BR2_____ICT01__AM03'


% Waveforms
% 'BTS_____ICT2___AT00'
% 'BR1_____ICT1___AT00'


% Energy (soft family for energy ramping)
% AO.GeV.FamilyName = 'GeV';
% AO.GeV.MemberOf = {};
% AO.GeV.Status = 1;
% AO.GeV.DeviceList = [1 1];
% AO.GeV.ElementList = [1];
% 
% AO.GeV.Monitor.Mode = 'Simulator';
% AO.GeV.Monitor.DataType = 'Scalar';
% AO.GeV.Monitor.ChannelNames = '';
% AO.GeV.Monitor.HW2PhysicsParams = 1;
% AO.GeV.Monitor.Physics2HWParams = 1;
% AO.GeV.Monitor.Units        = 'Hardware';
% AO.GeV.Monitor.HWUnits      = 'GeV';
% AO.GeV.Monitor.PhysicsUnits = 'GeV';
% AO.GeV.Monitor.SpecialFunctionGet = 'getenergy_als';  %'bend2gev';
% 
% AO.GeV.Setpoint.Mode = 'Simulator';
% AO.GeV.Setpoint.DataType = 'Scalar';
% AO.GeV.Setpoint.ChannelNames = '';
% AO.GeV.Setpoint.HW2PhysicsParams = 1;
% AO.GeV.Setpoint.Physics2HWParams = 1;
% AO.GeV.Setpoint.Units        = 'Hardware';
% AO.GeV.Setpoint.HWUnits      = 'GeV';
% AO.GeV.Setpoint.PhysicsUnits = 'GeV';
% AO.GeV.Setpoint.SpecialFunctionGet = 'getenergy_als';
% AO.GeV.Setpoint.SpecialFunctionSet = 'setenergy_als';


% TV
AO.TV.FamilyName = 'TV';
AO.TV.MemberOf   = {'PlotFamily'; 'TV';};
AO.TV.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6;2 1];
AO.TV.ElementList = [1 2 3 4 5 6 7]';
AO.TV.Status = ones(7,1);
AO.TV.Status(7) = 0;  % SR1 TV1 has a "read access denied" error
AO.TV.Position = (1:size(AO.TV.DeviceList,1))';  % Hopefully gets over written
AO.TV.CommonNames = getname_bts('TV', 'CommonNames');

% AO.TV.Monitor.MemberOf = {'PlotFamily';  'Boolean Monitor';};
% AO.TV.Monitor.Mode = 'Simulator';
% AO.TV.Monitor.DataType = 'Scalar';
% AO.TV.Monitor.ChannelNames = getname_bts(AO.TV.FamilyName, 'Monitor');
% AO.TV.Monitor.HW2PhysicsParams = 1;
% AO.TV.Monitor.Physics2HWParams = 1;
% AO.TV.Monitor.Units        = 'Hardware';
% AO.TV.Monitor.HWUnits      = '';
% AO.TV.Monitor.PhysicsUnits = '';

AO.TV.Setpoint.MemberOf = {'TV'; 'Boolean Control';};
AO.TV.Setpoint.Mode = 'Simulator';
AO.TV.Setpoint.DataType = 'Scalar';
AO.TV.Setpoint.ChannelNames = ''; % getname_bts(AO.TV.FamilyName, 'Setpoint');
AO.TV.Setpoint.HW2PhysicsParams = 1;
AO.TV.Setpoint.Physics2HWParams = 1;
AO.TV.Setpoint.Units        = 'Hardware';
AO.TV.Setpoint.HWUnits      = '';
AO.TV.Setpoint.PhysicsUnits = '';
AO.TV.Setpoint.Range = [0 1];
AO.TV.Setpoint.Tolerance = .5 * ones(length(AO.TV.ElementList), 1);  % Hardware units
AO.TV.Setpoint.SpecialFunctionGet = @gettv;
AO.TV.Setpoint.SpecialFunctionSet = @settv;

AO.TV.Video.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.TV.Video.Mode = 'Simulator';
AO.TV.Video.DataType = 'Scalar';
AO.TV.Video.ChannelNames = getname_bts(AO.TV.FamilyName, 'Video');
AO.TV.Video.HW2PhysicsParams = 1;
AO.TV.Video.Physics2HWParams = 1;
AO.TV.Video.Units        = 'Hardware';
AO.TV.Video.HWUnits      = '';
AO.TV.Video.PhysicsUnits = '';
AO.TV.Video.Range = [0 1];
AO.TV.Video.SpecialFunctionGet = @getvideo;
AO.TV.Video.SpecialFunctionSet = @setvideo;

AO.TV.InControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.TV.InControl.Mode = 'Simulator';
AO.TV.InControl.DataType = 'Scalar';
AO.TV.InControl.ChannelNames = getname_bts(AO.TV.FamilyName, 'InControl');
AO.TV.InControl.HW2PhysicsParams = 1;
AO.TV.InControl.Physics2HWParams = 1;
AO.TV.InControl.Units        = 'Hardware';
AO.TV.InControl.HWUnits      = '';
AO.TV.InControl.PhysicsUnits = '';
AO.TV.InControl.Range = [0 1];

AO.TV.In.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.In.Mode = 'Simulator';
AO.TV.In.DataType = 'Scalar';
AO.TV.In.ChannelNames = getname_bts(AO.TV.FamilyName, 'In');
AO.TV.In.HW2PhysicsParams = 1;
AO.TV.In.Physics2HWParams = 1;
AO.TV.In.Units        = 'Hardware';
AO.TV.In.HWUnits      = '';
AO.TV.In.PhysicsUnits = '';

AO.TV.Out.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Out.Mode = 'Simulator';
AO.TV.Out.DataType = 'Scalar';
AO.TV.Out.ChannelNames = getname_bts(AO.TV.FamilyName, 'Out');
AO.TV.Out.HW2PhysicsParams = 1;
AO.TV.Out.Physics2HWParams = 1;
AO.TV.Out.Units        = 'Hardware';
AO.TV.Out.HWUnits      = '';
AO.TV.Out.PhysicsUnits = '';

AO.TV.LampControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.TV.LampControl.Mode = 'Simulator';
AO.TV.LampControl.DataType = 'Scalar';
AO.TV.LampControl.ChannelNames = getname_bts(AO.TV.FamilyName, 'LampControl');
AO.TV.LampControl.HW2PhysicsParams = 1;
AO.TV.LampControl.Physics2HWParams = 1;
AO.TV.LampControl.Units        = 'Hardware';
AO.TV.LampControl.HWUnits      = '';
AO.TV.LampControl.PhysicsUnits = '';
AO.TV.LampControl.Range = [0 1];

AO.TV.Lamp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Lamp.Mode = 'Simulator';
AO.TV.Lamp.DataType = 'Scalar';
AO.TV.Lamp.ChannelNames = getname_bts(AO.TV.FamilyName, 'Lamp');
AO.TV.Lamp.HW2PhysicsParams = 1;
AO.TV.Lamp.Physics2HWParams = 1;
AO.TV.Lamp.Units        = 'Hardware';
AO.TV.Lamp.HWUnits      = '';
AO.TV.Lamp.PhysicsUnits = '';


%%%%%%%%%%%%
% Scrapers %
%%%%%%%%%%%%

% Scraper names from Rick Steele
% 1. DeviceList
% 2. T/B/R/L
% 3. positive limit
% 4. negative limit 
% 5. home_status 
% 6. moving status 
% 7. readback value 
% 8. home command 
% 9. move to position command


% Other fields: .ACCL, .REP (encoder), .STOP, 
RightNames = getnames_scrapers('BTS','right');
LeftNames  = getnames_scrapers('BTS','left');

AO.RightScraper.FamilyName = 'RightScraper';
AO.RightScraper.MemberOf   = {'Scraper'; 'Right';};
AO.RightScraper.DeviceList = [1 1;1 2];
AO.RightScraper.ElementList = [1 2]';
AO.RightScraper.Status = ones(size(AO.RightScraper.DeviceList,1),1);
AO.RightScraper.Position = [10 20]';
AO.RightScraper.CommonNames = [
    'JH(1,1)'
    'JH(1,2)'
    ];

AO.RightScraper.Monitor.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.RightScraper.Monitor.Mode = 'Simulator';
AO.RightScraper.Monitor.DataType = 'Scalar';
AO.RightScraper.Monitor.ChannelNames = deblank(RightNames{7});
AO.RightScraper.Monitor.HW2PhysicsParams = 1;
AO.RightScraper.Monitor.Physics2HWParams = 1;
AO.RightScraper.Monitor.Units        = 'Hardware';
AO.RightScraper.Monitor.HWUnits      = 'mm';
AO.RightScraper.Monitor.PhysicsUnits = 'mm';

AO.RightScraper.Setpoint.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Setpoint'; 'Save/Restore';};
AO.RightScraper.Setpoint.Mode = 'Simulator';
AO.RightScraper.Setpoint.DataType = 'Scalar';
AO.RightScraper.Setpoint.ChannelNames = deblank(RightNames{9});
AO.RightScraper.Setpoint.HW2PhysicsParams = 1;
AO.RightScraper.Setpoint.Physics2HWParams = 1;
AO.RightScraper.Setpoint.Units        = 'Hardware';
AO.RightScraper.Setpoint.HWUnits      = 'mm';
AO.RightScraper.Setpoint.PhysicsUnits = 'mm';
AO.RightScraper.Setpoint.Range        = [-Inf Inf];
AO.RightScraper.Setpoint.Tolerance    = .1;

AO.RightScraper.Velocity.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Monitor'; 'Velocity';};
AO.RightScraper.Velocity.Mode = 'Simulator';
AO.RightScraper.Velocity.DataType = 'Scalar';
AO.RightScraper.Velocity.ChannelNames = strcat(deblank(RightNames{9}), '.VELO');
AO.RightScraper.Velocity.HW2PhysicsParams = 1;
AO.RightScraper.Velocity.Physics2HWParams = 1;
AO.RightScraper.Velocity.Units        = 'Hardware';
AO.RightScraper.Velocity.HWUnits      = 'mm/sec';
AO.RightScraper.Velocity.PhysicsUnits = 'mm/sec';

AO.RightScraper.RunFlag.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.RightScraper.RunFlag.Mode = 'Simulator';
AO.RightScraper.RunFlag.DataType = 'Scalar';
AO.RightScraper.RunFlag.ChannelNames = deblank(RightNames{6});
AO.RightScraper.RunFlag.HW2PhysicsParams = 1;
AO.RightScraper.RunFlag.Physics2HWParams = 1;
AO.RightScraper.RunFlag.Units        = 'Hardware';
AO.RightScraper.RunFlag.HWUnits      = '';
AO.RightScraper.RunFlag.PhysicsUnits = '';

AO.RightScraper.HomeControl.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Control';};
AO.RightScraper.HomeControl.Mode = 'Simulator';
AO.RightScraper.HomeControl.DataType = 'Scalar';
AO.RightScraper.HomeControl.ChannelNames = deblank(RightNames{8});
AO.RightScraper.HomeControl.HW2PhysicsParams = 1;
AO.RightScraper.HomeControl.Physics2HWParams = 1;
AO.RightScraper.HomeControl.Units        = 'Hardware';
AO.RightScraper.HomeControl.HWUnits      = '';
AO.RightScraper.HomeControl.PhysicsUnits = '';
AO.RightScraper.HomeControl.Range = [0 1];
AO.RightScraper.HomeControl.Tolerance = 0;

AO.RightScraper.Home.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.RightScraper.Home.Mode = 'Simulator';
AO.RightScraper.Home.DataType = 'Scalar';
AO.RightScraper.Home.ChannelNames = deblank(RightNames{5});
AO.RightScraper.Home.HW2PhysicsParams = 1;
AO.RightScraper.Home.Physics2HWParams = 1;
AO.RightScraper.Home.Units        = 'Hardware';
AO.RightScraper.Home.HWUnits      = '';
AO.RightScraper.Home.PhysicsUnits = '';

AO.RightScraper.PositiveLimit.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.RightScraper.PositiveLimit.Mode = 'Simulator';
AO.RightScraper.PositiveLimit.DataType = 'Scalar';
AO.RightScraper.PositiveLimit.ChannelNames = deblank(RightNames{3});
AO.RightScraper.PositiveLimit.HW2PhysicsParams = 1;
AO.RightScraper.PositiveLimit.Physics2HWParams = 1;
AO.RightScraper.PositiveLimit.Units        = 'Hardware';
AO.RightScraper.PositiveLimit.HWUnits      = '';
AO.RightScraper.PositiveLimit.PhysicsUnits = '';

AO.RightScraper.NegativeLimit.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.RightScraper.NegativeLimit.Mode = 'Simulator';
AO.RightScraper.NegativeLimit.DataType = 'Scalar';
AO.RightScraper.NegativeLimit.ChannelNames = deblank(RightNames{4});
AO.RightScraper.NegativeLimit.HW2PhysicsParams = 1;
AO.RightScraper.NegativeLimit.Physics2HWParams = 1;
AO.RightScraper.NegativeLimit.Units        = 'Hardware';
AO.RightScraper.NegativeLimit.HWUnits      = '';
AO.RightScraper.NegativeLimit.PhysicsUnits = '';


AO.LeftScraper.FamilyName = 'LeftScraper';
AO.LeftScraper.MemberOf   = {'Scraper'; 'Left';};
AO.LeftScraper.DeviceList = [1 1;1 2];
AO.LeftScraper.ElementList = [1 2]';
AO.LeftScraper.Status = ones(size(AO.LeftScraper.DeviceList,1),1);
AO.LeftScraper.Position = [10 20]';
AO.LeftScraper.CommonNames = [
    'JH(1,1)'
    'JH(1,2)'
    ];

AO.LeftScraper.Monitor.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.LeftScraper.Monitor.Mode = 'Simulator';
AO.LeftScraper.Monitor.DataType = 'Scalar';
AO.LeftScraper.Monitor.ChannelNames = deblank(LeftNames{7});
AO.LeftScraper.Monitor.HW2PhysicsParams = 1;
AO.LeftScraper.Monitor.Physics2HWParams = 1;
AO.LeftScraper.Monitor.Units        = 'Hardware';
AO.LeftScraper.Monitor.HWUnits      = 'mm';
AO.LeftScraper.Monitor.PhysicsUnits = 'mm';

AO.LeftScraper.Setpoint.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Setpoint'; 'Save/Restore';};
AO.LeftScraper.Setpoint.Mode = 'Simulator';
AO.LeftScraper.Setpoint.DataType = 'Scalar';
AO.LeftScraper.Setpoint.ChannelNames = deblank(LeftNames{9});
AO.LeftScraper.Setpoint.HW2PhysicsParams = 1;
AO.LeftScraper.Setpoint.Physics2HWParams = 1;
AO.LeftScraper.Setpoint.Units        = 'Hardware';
AO.LeftScraper.Setpoint.HWUnits      = 'mm';
AO.LeftScraper.Setpoint.PhysicsUnits = 'mm';
AO.LeftScraper.Setpoint.Range        = [-Inf Inf];
AO.LeftScraper.Setpoint.Tolerance    = .1;

AO.LeftScraper.Velocity.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Monitor'; 'Velocity';};
AO.LeftScraper.Velocity.Mode = 'Simulator';
AO.LeftScraper.Velocity.DataType = 'Scalar';
AO.LeftScraper.Velocity.ChannelNames = strcat(deblank(LeftNames{9}), '.VELO');
AO.LeftScraper.Velocity.HW2PhysicsParams = 1;
AO.LeftScraper.Velocity.Physics2HWParams = 1;
AO.LeftScraper.Velocity.Units        = 'Hardware';
AO.LeftScraper.Velocity.HWUnits      = 'mm/sec';
AO.LeftScraper.Velocity.PhysicsUnits = 'mm/sec';

AO.LeftScraper.RunFlag.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.LeftScraper.RunFlag.Mode = 'Simulator';
AO.LeftScraper.RunFlag.DataType = 'Scalar';
AO.LeftScraper.RunFlag.ChannelNames = deblank(LeftNames{6});
AO.LeftScraper.RunFlag.HW2PhysicsParams = 1;
AO.LeftScraper.RunFlag.Physics2HWParams = 1;
AO.LeftScraper.RunFlag.Units        = 'Hardware';
AO.LeftScraper.RunFlag.HWUnits      = '';
AO.LeftScraper.RunFlag.PhysicsUnits = '';

AO.LeftScraper.HomeControl.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Boolean Control';};
AO.LeftScraper.HomeControl.Mode = 'Simulator';
AO.LeftScraper.HomeControl.DataType = 'Scalar';
AO.LeftScraper.HomeControl.ChannelNames = deblank(LeftNames{8});
AO.LeftScraper.HomeControl.HW2PhysicsParams = 1;
AO.LeftScraper.HomeControl.Physics2HWParams = 1;
AO.LeftScraper.HomeControl.Units        = 'Hardware';
AO.LeftScraper.HomeControl.HWUnits      = '';
AO.LeftScraper.HomeControl.PhysicsUnits = '';
AO.LeftScraper.HomeControl.Range = [0 1];
AO.LeftScraper.HomeControl.Tolerance = 0;

AO.LeftScraper.Home.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Boolean Monitor';};
AO.LeftScraper.Home.Mode = 'Simulator';
AO.LeftScraper.Home.DataType = 'Scalar';
AO.LeftScraper.Home.ChannelNames = deblank(LeftNames{5});
AO.LeftScraper.Home.HW2PhysicsParams = 1;
AO.LeftScraper.Home.Physics2HWParams = 1;
AO.LeftScraper.Home.Units        = 'Hardware';
AO.LeftScraper.Home.HWUnits      = '';
AO.LeftScraper.Home.PhysicsUnits = '';

AO.LeftScraper.PositiveLimit.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Boolean Monitor';};
AO.LeftScraper.PositiveLimit.Mode = 'Simulator';
AO.LeftScraper.PositiveLimit.DataType = 'Scalar';
AO.LeftScraper.PositiveLimit.ChannelNames = deblank(LeftNames{3});
AO.LeftScraper.PositiveLimit.HW2PhysicsParams = 1;
AO.LeftScraper.PositiveLimit.Physics2HWParams = 1;
AO.LeftScraper.PositiveLimit.Units        = 'Hardware';
AO.LeftScraper.PositiveLimit.HWUnits      = '';
AO.LeftScraper.PositiveLimit.PhysicsUnits = '';

AO.LeftScraper.NegativeLimit.MemberOf = {'Scraper'; 'Left'; 'PlotFamily'; 'Boolean Monitor';};
AO.LeftScraper.NegativeLimit.Mode = 'Simulator';
AO.LeftScraper.NegativeLimit.DataType = 'Scalar';
AO.LeftScraper.NegativeLimit.ChannelNames = deblank(LeftNames{4});
AO.LeftScraper.NegativeLimit.HW2PhysicsParams = 1;
AO.LeftScraper.NegativeLimit.Physics2HWParams = 1;
AO.LeftScraper.NegativeLimit.Units        = 'Hardware';
AO.LeftScraper.NegativeLimit.HWUnits      = '';
AO.LeftScraper.NegativeLimit.PhysicsUnits = '';



% The operational mode sets the path, filenames, AT model, and other important parameters.
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode.
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;




function [Amps] = local_minsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'Q')
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
    if strcmp(Family,'Q')
        % Amps(i,1) = 130;
        
        % Qmax = [
        %     1     1    90
        %     2     1    90
        %     2     2    40
        %     3     1    40
        %     3     2    90
        %     4     1    90
        %     5     1   110
        %     5     2   110
        %     6     1    90
        %     6     2    90
        %     7     1    90];
        if all(List(i,:) == [2 2]) || all(List(i,:) == [3 1])
           Amps(i,1) = 40;
        elseif all(List(i,:) == [5 1]) || all(List(i,:) == [5 2])
           Amps(i,1) = 110;
        else
            Amps(i,1) = 90;
        end
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 950;
        % if all(List(i,:) == [1 1])
        %     Amps(i,1) = 800;
        % elseif all(List(i,:) == [1 2])
        %     Amps(i,1) = 810;
        % elseif all(List(i,:) == [1 3])
        %     Amps(i,1) = 810;
        % elseif all(List(i,:) == [1 4])
        %     Amps(i,1) = 750;
        % end
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
elseif strcmp(Family,'Q')
    tol = 0.2;
elseif strcmp(Family,'BEND')
    tol = 1000;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end


