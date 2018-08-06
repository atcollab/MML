function gtbinit(OperationalMode)
%GTBINIT


% To-do
% 1. Add IP and IG families
% 2. Get the magnet ramprates and figure out how to make runflag work
% 3. What else needs to be in the save/restore?
% 4. What else in hwinit -- VVR?

% 5. Need an AT lattice!!!
% 6. Shot-to-shot reproducabiliy of the orbit
% 7. Response matrix
% 8. QMS


if nargin < 1
    % 1 => 50 MeV injection
    OperationalMode = 1;
end


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);

% BPM
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'BPM'; 'BPMx';};
AO.BPMx.DeviceList  = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 3 4; 3 5; 3 6; 3 7;];  % 1 3; 2 1 (signal is used for something else)
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.CommonNames = getname_gtb('BPMx', 'CommonNames');

AO.BPMx.Monitor.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor';};  %  'Save';
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_gtb(AO.BPMx.FamilyName, 'Monitor');
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_gtb;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'BPM'; 'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = getname_gtb('BPMy', 'CommonNames');

AO.BPMy.Monitor.MemberOf = {'PlotFamily'; 'BPM'; 'BPMy'; 'Monitor';}; % 'Save';
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_gtb(AO.BPMy.FamilyName, 'Monitor');
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMy.Monitor.SpecialFunctionGet = @gety_gtb;


% BPM
setao(AO);
AO = buildmmlbpmfamily(AO, 'GTB');

AO.BPMx.Monitor.ChannelNames = AO.BPM.X.ChannelNames;
AO.BPMy.Monitor.ChannelNames = AO.BPM.Y.ChannelNames;
AO.BPMx.Sum.ChannelNames     = AO.BPM.S.ChannelNames;
AO.BPMy.Sum.ChannelNames     = AO.BPM.S.ChannelNames;

%AO.BPMx.Monitor.ChannelNames = strvcat(char(AO.BPM.X.ChannelNames),AO.BPMx.Monitor.ChannelNames(5:end,:));
%AO.BPMy.Monitor.ChannelNames = strvcat(char(AO.BPM.Y.ChannelNames),AO.BPMy.Monitor.ChannelNames(5:end,:));


% HCM
AO.HCM.FamilyName = 'HCM';
AO.HCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 3 1; 3 2;];  % [3 7] removed
AO.HCM.BaseName = {
    'GTL:HCM1'
    'GTL:HCM2'
    'GTL:HCM3'
    'GTL:HCM4'
    'LN:HCM1'
    'LN:HCM2'
    'LTB:HCM1'
    'LTB:HCM2'
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
    };
AO.HCM = buildmmlcaen(AO.HCM, 4);
AO.HCM.MemberOf    = {'HCM'; 'Magnet'; 'COR';};
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
%AO.HCM.Status(end) = 0;  % LTB HC7 was removed
AO.HCM.Position    = [];
AO.HCM.CommonNames = getname_gtb('HCM', 'CommonNames');

AO.HCM.Monitor.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.HCM.Monitor.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Monitor');
AO.HCM.Monitor.HW2PhysicsFcn = @gtb2at;
AO.HCM.Monitor.Physics2HWFcn = @at2gtb;
AO.HCM.Monitor = rmfield(AO.HCM.Monitor, 'HW2PhysicsParams');
AO.HCM.Monitor = rmfield(AO.HCM.Monitor, 'Physics2HWParams');
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Real2RawFcn = @real2raw_gtb;
AO.HCM.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.HCM.Setpoint.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Save/Restore'; 'Setpoint'};
AO.HCM.Setpoint.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Setpoint');
AO.HCM.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2gtb;
AO.HCM.Setpoint = rmfield(AO.HCM.Setpoint, 'HW2PhysicsParams');
AO.HCM.Setpoint = rmfield(AO.HCM.Setpoint, 'Physics2HWParams');
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range = [
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -2.9000    2.9000
    -2.9000    2.9000
    %-2.9000    2.9000
    ];
AO.HCM.Setpoint.Tolerance = .1 * ones(length(AO.HCM.ElementList), 1);  % Hardware units
AO.HCM.Setpoint.DeltaRespMat = [
    2
    2
    2
    2
    2
    2
    .25
    .25
    %.25
];

AO.HCM.RampRate.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Ramprate'; 'PlotFamily'; 'Save';};
% AO.HCM.RampRate.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'RampRate');

AO.HCM.OnControl.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.HCM.OnControl.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'OnControl');
AO.HCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.HCM.On.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.On.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'On');

AO.HCM.Reset.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
%AO.HCM.Reset.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Reset');

AO.HCM.Ready.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Ready');
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units        = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName = 'VCM';
AO.VCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 3 1; 3 2; 3 3; 3 4; 3 5; 3 6; 3 7;];
AO.VCM.BaseName = {
    'GTL:VCM1'
    'GTL:VCM2'
    'GTL:VCM3'
    'GTL:VCM4'
    'LN:VCM1'
    'LN:VCM2'
    'LTB:VCM1'
    'LTB:VCM2'
    'LTB:VCM3'
    'LTB:VCM4'
    'LTB:VCM5'
    'LTB:VCM6'
    'LTB:VCM7'
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
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    };
AO.VCM = buildmmlcaen(AO.VCM, 4);
AO.VCM.MemberOf    = {'VCM'; 'Magnet'; 'COR';};
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = getname_gtb('VCM', 'CommonNames');

AO.VCM.Monitor.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.VCM.Monitor.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Monitor');
AO.VCM.Monitor = rmfield(AO.VCM.Monitor, 'HW2PhysicsParams');
AO.VCM.Monitor = rmfield(AO.VCM.Monitor, 'Physics2HWParams');
AO.VCM.Monitor.HW2PhysicsFcn = @gtb2at;
AO.VCM.Monitor.Physics2HWFcn = @at2gtb;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Real2RawFcn = @real2raw_gtb;
AO.VCM.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.VCM.Setpoint.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Save/Restore'; 'Setpoint'};
AO.VCM.Setpoint.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Setpoint');
AO.VCM.Setpoint = rmfield(AO.VCM.Setpoint, 'HW2PhysicsParams');
AO.VCM.Setpoint = rmfield(AO.VCM.Setpoint, 'Physics2HWParams');
AO.VCM.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2gtb;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range = [
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    ];
AO.VCM.Setpoint.Tolerance  = .1 * ones(length(AO.VCM.ElementList), 1);  % Hardware units
%AO.VCM.Setpoint.DeltaRespMat = .25;
AO.VCM.Setpoint.DeltaRespMat = [
    2
    2
    2
    2
    2
    1
    .25
    .25
    .25
    .25
    .25
    .25
    .25
];

AO.VCM.RampRate.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Ramprate'; 'PlotFamily'; 'Save';};
% AO.VCM.RampRate.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'RampRate');

AO.VCM.OnControl.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.VCM.OnControl.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'OnControl');
AO.VCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCM.On.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.VCM.On.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'On');

AO.VCM.Reset.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
%AO.VCM.Reset.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Reset');

AO.VCM.Ready.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Ready');
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units        = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';



AO.Q.FamilyName = 'Q';
AO.Q.DeviceList = [1 1; 1 2; 1 3; 3 1; 3 2; 3 3; 3 4; 3 5; 3 6; 3 7; 3 8; 3 9; 3 10;];
%              Just the LTB [1 1; 1 2; 1 3; 2 1; 3 1; 3 2; 4 1; 4 2; 5 1; 6  1;];
AO.Q.BaseName = {
    'LN:Q1_1'
    'LN:Q1_2'
    'LN:Q1_1'
    'LTB:Q1_1'
    'LTB:Q1_2'
    'LTB:Q1_1'
    'LTB:Q2'
    'LTB:Q3_1'
    'LTB:Q3_2'
    'LTB:Q4_1'
    'LTB:Q4_2'
    'LTB:Q5'
    'LTB:Q6'
    };
AO.Q.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
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
AO.Q = buildmmlcaen(AO.Q, 10);
AO.Q.MemberOf   = {'QUAD';  'Magnet';};
AO.Q.ElementList = (1:size(AO.Q.DeviceList,1))';
AO.Q.Status = ones(size(AO.Q.DeviceList,1),1);
AO.Q.Position = [];
AO.Q.CommonNames = getname_gtb('Q', 'CommonNames');

AO.Q.Monitor.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.Q.Monitor.ChannelNames = getname_gtb(AO.Q.FamilyName, 'Monitor');
AO.Q.Monitor = rmfield(AO.Q.Monitor, 'HW2PhysicsParams');
AO.Q.Monitor = rmfield(AO.Q.Monitor, 'Physics2HWParams');
AO.Q.Monitor.HW2PhysicsFcn = @gtb2at;
AO.Q.Monitor.Physics2HWFcn = @at2gtb;
AO.Q.Monitor.Units        = 'Hardware';
AO.Q.Monitor.HWUnits      = 'Ampere';
AO.Q.Monitor.PhysicsUnits = '1/Meter^2';
AO.Q.Monitor.Real2RawFcn = @real2raw_gtb;
AO.Q.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.Q.Setpoint.MemberOf = {'QUAD'; 'Magnet'; 'Save/Restore'; 'Setpoint';};
AO.Q.Setpoint.ChannelNames = getname_gtb(AO.Q.FamilyName, 'Setpoint');
AO.Q.Setpoint = rmfield(AO.Q.Setpoint, 'HW2PhysicsParams');
AO.Q.Setpoint = rmfield(AO.Q.Setpoint, 'Physics2HWParams');
AO.Q.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.Q.Setpoint.Physics2HWFcn = @at2gtb;
AO.Q.Setpoint.Units        = 'Hardware';
AO.Q.Setpoint.HWUnits      = 'Ampere';
AO.Q.Setpoint.PhysicsUnits = '1/Meter^2';
AO.Q.Setpoint.Range = [
    0   10.0000  % 10A Caens???
    0   10.0000
    0   10.0000
    0    8.0000  % Was -.5 ???
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    ];
AO.Q.Setpoint.Tolerance = [ 
    % Hardware units
    .5
    2
    .5
    .5
    .5
    .5
    .5
    .5
    .5
    .5
    2
    1.5
    1
    ];
AO.Q.Setpoint.DeltaRespMat = .5;

AO.Q.RampRate.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Save/Restore';};
% AO.Q.RampRate.ChannelNames = getname_gtb('Q', 'RampRate');

AO.Q.OnControl.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.Q.OnControl.ChannelNames = getname_gtb('Q', 'OnControl');
AO.Q.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.Q.On.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.Q.On.Mode = 'Simulator';
AO.Q.On.DataType = 'Scalar';
AO.Q.On.ChannelNames = getname_gtb('Q', 'On');
AO.Q.On.HW2PhysicsParams = 1;
AO.Q.On.Physics2HWParams = 1;
AO.Q.On.Units        = 'Hardware';
AO.Q.On.HWUnits      = '';
AO.Q.On.PhysicsUnits = '';

AO.Q.Reset.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
% AO.Q.Reset.ChannelNames = getname_gtb('Q', 'Reset');

AO.Q.Ready.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.Q.Ready.Mode = 'Simulator';
AO.Q.Ready.DataType = 'Scalar';
AO.Q.Ready.ChannelNames = getname_gtb('Q', 'Ready');
AO.Q.Ready.HW2PhysicsParams = 1;
AO.Q.Ready.Physics2HWParams = 1;
AO.Q.Ready.Units        = 'Hardware';
AO.Q.Ready.HWUnits      = '';
AO.Q.Ready.PhysicsUnits = '';



% Bucking Coil
AO.BuckingCoil.FamilyName = 'BuckingCoil';
AO.BuckingCoil.DeviceList = [1 1; 1 2;];
AO.BuckingCoil.BaseName = {
    'GTL:BC1'
    'GTL:BC2'
    };
AO.BuckingCoil.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    };
AO.BuckingCoil = buildmmlcaen(AO.BuckingCoil, 1.5);
AO.BuckingCoil.MemberOf = {'Bucking Coil';};
AO.BuckingCoil.ElementList = (1:size(AO.BuckingCoil.DeviceList,1))';
AO.BuckingCoil.Status = ones(size(AO.BuckingCoil.DeviceList,1),1);
AO.BuckingCoil.Position = (1:size(AO.BuckingCoil.DeviceList,1))';
AO.BuckingCoil.CommonNames = [
    'GTL BC1'
    'GTL BC2'
    ];
AO.BuckingCoil.BaseName = {
    'GTL:BC1'
    'GTL:BC2'
    };
AO.BuckingCoil.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    };
AO.BuckingCoil.Monitor.MemberOf = {'Bucking Coil'; 'Monitor'; 'PlotFamily'; 'Save/Restore';};
AO.BuckingCoil.Monitor.ChannelNames = [
    'GTL_____BC1____AM00'
    'GTL_____BC2____AM01'
    ];
AO.BuckingCoil.Setpoint.MemberOf = {'Bucking Coil'; 'Save/Restore'; 'Setpoint';};
AO.BuckingCoil.Setpoint.ChannelNames = [
    'GTL_____BC1____AC00'
    'GTL_____BC2____AC01'
    ];
AO.BuckingCoil.Setpoint.Range = [-1.5 1.5; -1.5 1.5];
AO.BuckingCoil.Setpoint.Tolerance = .1*ones(length(AO.BuckingCoil.ElementList), 1);  % Hardware units
AO.BuckingCoil.OnControl.MemberOf = {'Bucking Coil'; 'Boolean Control';};
AO.BuckingCoil.OnControl.ChannelNames = [
    'GTL_____BC1____BC23'
    'GTL_____BC2____BC23'
    ];
AO.BuckingCoil.On.MemberOf = {'Bucking Coil'; 'Boolean Monitor';};
AO.BuckingCoil.On.ChannelNames = [
    'GTL_____BC1____BM14' % PS_ON
    'GTL_____BC2____BM14' % PS_ON
    ];
AO.BuckingCoil.Ready.MemberOf = {'Bucking Coil'; 'Boolean Monitor';};
AO.BuckingCoil.Ready.ChannelNames = [
    'GTL_____BC1____BM15' % PS_READY
    'GTL_____BC2____BM15' % PS_READY
    ];


AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'BEND'; 'Magnet'};
AO.BEND.DeviceList = [3 1; 3 2; 3 3; 3 4;];
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position = [];
AO.BEND.CommonNames = getname_gtb('BEND', 'CommonNames');
AO.BEND.BaseName = {
    'irm:023:'
    'irm:023:'
    'irm:024:'
    'LTB:B3'
    };
AO.BEND.DeviceType = {
    'IRM'
    'IRM'
    'IRM'
    'Caen SY3634'
};

AO.BEND.Monitor.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @gtb2at;
AO.BEND.Monitor.Physics2HWFcn = @at2gtb;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';
AO.BEND.Monitor.Real2RawFcn = @real2raw_gtb;
AO.BEND.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.BEND.Setpoint.MemberOf = {'BEND'; 'Magnet'; 'Save/Restore'; 'Setpoint';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2gtb;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';
AO.BEND.Setpoint.Range = [
    0  220.0000
    0  220.0000
    0  250.0000
    0   10.0000
    ];
% In database
% AO.BEND.Setpoint.Range = [
%   -220.0000  220.0000
%     -2.2000  220.0000
%     -2.2000  250.0000
%     -1.0000   10.0000
%     ];
AO.BEND.Setpoint.Tolerance = [7 4 3 .5]';  % Hardware units (power outage damaged LTB,B2 AM)
AO.BEND.Setpoint.RampRate = [2 2.1 6.9 .09]';
%AO.BEND.Setpoint.RunFlagFcn = @getrunflag_gtb;

AO.BEND.Shunt.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Shunt';};
AO.BEND.Shunt.Mode = 'Simulator';
AO.BEND.Shunt.DataType = 'Scalar';
AO.BEND.Shunt.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Shunt');
AO.BEND.Shunt.HW2PhysicsParams = 1;
AO.BEND.Shunt.Physics2HWParams = 1;
AO.BEND.Shunt.Units        = 'Hardware';
AO.BEND.Shunt.HWUnits      = '';
AO.BEND.Shunt.PhysicsUnits = '';

AO.BEND.HallProbe.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Hall Probe';};
AO.BEND.HallProbe.Mode = 'Simulator';
AO.BEND.HallProbe.DataType = 'Scalar';
AO.BEND.HallProbe.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'HallProbe');
AO.BEND.HallProbe.HW2PhysicsParams = 1;
AO.BEND.HallProbe.Physics2HWParams = 1;
AO.BEND.HallProbe.Units        = 'Hardware';
AO.BEND.HallProbe.HWUnits      = '';
AO.BEND.HallProbe.PhysicsUnits = '';

AO.BEND.RampRate.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Save/Restore';};
AO.BEND.RampRate.Mode = 'Simulator';
AO.BEND.RampRate.DataType = 'Scalar';
AO.BEND.RampRate.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'RampRate');
AO.BEND.RampRate.HW2PhysicsParams = 1;
AO.BEND.RampRate.Physics2HWParams = 1;
AO.BEND.RampRate.Units        = 'Hardware';
AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';

% AO.BEND.TimeConstant.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Save/Restore';};
% AO.BEND.TimeConstant.Mode = 'Simulator';
% AO.BEND.TimeConstant.DataType = 'Scalar';
% AO.BEND.TimeConstant.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'TimeConstant');
% AO.BEND.TimeConstant.HW2PhysicsParams = 1;
% AO.BEND.TimeConstant.Physics2HWParams = 1;
% AO.BEND.TimeConstant.Units        = 'Hardware';
% AO.BEND.TimeConstant.HWUnits      = 'Second';
% AO.BEND.TimeConstant.PhysicsUnits = 'Second';
%
% AO.BEND.DAC.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily';};
% AO.BEND.DAC.Mode = 'Simulator';
% AO.BEND.DAC.DataType = 'Scalar';
% AO.BEND.DAC.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'DAC');
% AO.BEND.DAC.HW2PhysicsParams = 1;
% AO.BEND.DAC.Physics2HWParams = 1;
% AO.BEND.DAC.Units        = 'Hardware';
% AO.BEND.DAC.HWUnits      = 'Ampere';
% AO.BEND.DAC.PhysicsUnits = 'Ampere';

AO.BEND.OnControl.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range = [0 1];
AO.BEND.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.BEND.On.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units        = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

% AO.BEND.Reset.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
% AO.BEND.Reset.Mode = 'Simulator';
% AO.BEND.Reset.DataType = 'Scalar';
% AO.BEND.Reset.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Reset');
% AO.BEND.Reset.HW2PhysicsParams = 1;
% AO.BEND.Reset.Physics2HWParams = 1;
% AO.BEND.Reset.Units        = 'Hardware';
% AO.BEND.Reset.HWUnits      = '';
% AO.BEND.Reset.PhysicsUnits = '';
% AO.BEND.Reset.Range = [0 1];

AO.BEND.Ready.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units        = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';

AO.BEND.CtrlPower.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.CtrlPower.Mode = 'Simulator';
AO.BEND.CtrlPower.DataType = 'Scalar';
AO.BEND.CtrlPower.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'CtrlPower');
AO.BEND.CtrlPower.HW2PhysicsParams = 1;
AO.BEND.CtrlPower.Physics2HWParams = 1;
AO.BEND.CtrlPower.Units        = 'Hardware';
AO.BEND.CtrlPower.HWUnits      = '';
AO.BEND.CtrlPower.PhysicsUnits = '';

AO.BEND.OverTemperature.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.OverTemperature.Mode = 'Simulator';
AO.BEND.OverTemperature.DataType = 'Scalar';
AO.BEND.OverTemperature.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'OverTemperature');
AO.BEND.OverTemperature.HW2PhysicsParams = 1;
AO.BEND.OverTemperature.Physics2HWParams = 1;
AO.BEND.OverTemperature.Units        = 'Hardware';
AO.BEND.OverTemperature.HWUnits      = '';
AO.BEND.OverTemperature.PhysicsUnits = '';


% Solenoid
AO.SOL.FamilyName = 'SOL';
AO.SOL.MemberOf = {'Solenoid';};
AO.SOL.DeviceList = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 2 4];
AO.SOL.ElementList = (1:size(AO.SOL.DeviceList,1))';
AO.SOL.Status = ones(size(AO.SOL.DeviceList,1),1);
AO.SOL.Position = (1:size(AO.SOL.DeviceList,1))';
AO.SOL.CommonNames = [
    'GTL SOL1'
    'GTL SOL2'
    'GTL SOL3'
    'LN SOL1 '
    'LN SOL2 '
    'LN SOL3 '
    'LN SOL4 '
    ];
AO.SOL.BaseName = {
    'irm:003:'
    'irm:003:'
    'irm:003:'
    'irm:004:'
    'irm:004:'
    'irm:004:'
    'irm:004:'
    };
AO.SOL.DeviceType = {
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
    'IRM'
};
AO.SOL.Monitor.MemberOf = {'SOL'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.SOL.Monitor.Mode = 'Simulator';
AO.SOL.Monitor.DataType = 'Scalar';
AO.SOL.Monitor.ChannelNames = [
    'GTL_____SOL1___AM00'	% B
    'GTL_____SOL2___AM01'	% G
    'GTL_____SOL3___AM02'	% L
    'LN______SOL1___AM00'	% B
    'LN______SOL2___AM01'	% G
    'LN______SOL3___AM02'	% B
    'LN______SOL4___AM03'	% B
    ];
AO.SOL.Monitor.HW2PhysicsParams = 1;
AO.SOL.Monitor.Physics2HWParams = 1;
AO.SOL.Monitor.Units        = 'Hardware';
AO.SOL.Monitor.HWUnits      = '';
AO.SOL.Monitor.PhysicsUnits = '';

AO.SOL.Setpoint.MemberOf = {'SOL'; 'Save/Restore'; 'Setpoint'};
AO.SOL.Setpoint.Mode = 'Simulator';
AO.SOL.Setpoint.DataType = 'Scalar';
AO.SOL.Setpoint.ChannelNames = [
    'GTL_____SOL1___AC00'	% A
    'GTL_____SOL2___AC01'	% F
    'GTL_____SOL3___AC02'	% K
    'LN______SOL1___AC00'	% A
    'LN______SOL2___AC01'	% F
    'LN______SOL3___AC02'	% A
    'LN______SOL4___AC03'	% A
    ];
AO.SOL.Setpoint.HW2PhysicsParams = 1;
AO.SOL.Setpoint.Physics2HWParams = 1;
AO.SOL.Setpoint.Units        = 'Hardware';
AO.SOL.Setpoint.HWUnits      = '';
AO.SOL.Setpoint.PhysicsUnits = '';
AO.SOL.Setpoint.Range = [
    0    115
    0    115
    0    115
    0    495
    0    446
    0    492
    0    503
    ];
AO.SOL.Setpoint.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units
AO.SOL.Setpoint.Tolerance(5) = 1.25;  % LN SOL2 oscillates at a few Hz

AO.SOL.OnControl.MemberOf = {'SOL'; 'OnControl'; 'Boolean Control'; 'PlotFamily';};
AO.SOL.OnControl.Mode = 'Simulator';
AO.SOL.OnControl.DataType = 'Scalar';
AO.SOL.OnControl.ChannelNames = [
    'GTL_____SOL1___BC23'	% C
    'GTL_____SOL2___BC22'	% H
    'GTL_____SOL3___BC21'	% M
    'LN______SOL1___BC23'	% C
    'LN______SOL2___BC22'	% G
    'LN______SOL3___BC21'	% C
    'LN______SOL4___BC20'	% C
    ];
AO.SOL.OnControl.HW2PhysicsParams = 1;
AO.SOL.OnControl.Physics2HWParams = 1;
AO.SOL.OnControl.Units        = 'Hardware';
AO.SOL.OnControl.HWUnits      = '';
AO.SOL.OnControl.PhysicsUnits = '';
AO.SOL.OnControl.Range = [-Inf Inf];
AO.SOL.OnControl.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units

AO.SOL.Ready.MemberOf = {'SOL'; 'Ready'; 'Boolean Monitor'; 'PlotFamily';};
AO.SOL.Ready.Mode = 'Simulator';
AO.SOL.Ready.DataType = 'Scalar';
AO.SOL.Ready.ChannelNames = [
    'GTL_____SOL1___BM15' %	D
    'GTL_____SOL2___BM13' %	I
    'GTL_____SOL3___BM11' %	N
    'LN______SOL1___BM15' %	D
    'LN______SOL2___BM13' %	H
    'LN______SOL3___BM11' %	D
    'LN______SOL4___BM09' %	D
    ];
AO.SOL.Ready.HW2PhysicsParams = 1;
AO.SOL.Ready.Physics2HWParams = 1;
AO.SOL.Ready.Units        = 'Hardware';
AO.SOL.Ready.HWUnits      = '';
AO.SOL.Ready.PhysicsUnits = '';

AO.SOL.On.MemberOf = {'SOL'; 'On'; 'Boolean Monitor'; 'PlotFamily';};
AO.SOL.On.Mode = 'Simulator';
AO.SOL.On.DataType = 'Scalar';
AO.SOL.On.ChannelNames = [
    'GTL_____SOL1___BM14' %	E
    'GTL_____SOL2___BM12' %	J
    'GTL_____SOL3___BM10' %	O
    'LN______SOL1___BM14' %	E
    'LN______SOL2___BM12' %	H
    'LN______SOL3___BM10' %	E
    'LN______SOL4___BM08' %	E
    ];
AO.SOL.On.HW2PhysicsParams = 1;
AO.SOL.On.Physics2HWParams = 1;
AO.SOL.On.Units        = 'Hardware';
AO.SOL.On.HWUnits      = '';
AO.SOL.On.PhysicsUnits = '';

% 'LN______SOLIN1_BC19'	% LN SOL MOD1 INTLK
% 'LN______SOLIN2_BC18'	% LN SOL MOD2 INTLK



AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT';};
AO.DCCT.DeviceList = [1 1;1 2];
AO.DCCT.ElementList = [1;2];
AO.DCCT.Status = [1;1;];
AO.DCCT.Position = [0;35];  % ???

AO.DCCT.MemberOf = {'DCCT'; 'Monitor';};
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = ['LTB_____ICT01__AM02'; 'BR2_____ICT01__AM03'];
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units        = 'Hardware';
AO.DCCT.Monitor.HWUnits      = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';
%AO.DCCT.Monitor.SpecialFunctionGet = 'getdcct_gtb';

% Other ICTs
% 'BTS_____ICT01__AM00'
% 'BTS_____ICT02__AM01'

% Waveforms ICTs
% 'BTS_____ICT2___AT00'
% 'BR1_____ICT1___AT00'


AO.Trigger = buildmmlfamily_mrf_trigger;
%AO.Evt = buildmmlfamily_mrf_evt;


% EG
AO.EG.FamilyName = 'EG';
AO.EG.MemberOf = {'EG';};
AO.EG.DeviceList = [1 1; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8];
AO.EG.ElementList = (1:size(AO.EG.DeviceList,1))';
AO.EG.Status = ones(size(AO.EG.DeviceList,1),1);
AO.EG.Position = (1:size(AO.EG.DeviceList,1))';
AO.EG.CommonNames = [
    'EG Bias  '
    'EG Phase '
    'EG Pulser'
    'EG Heater'
    'EG HV    '
    'EG HV I  '
    'EG Temp  '
    ];

AO.EG.Monitor.MemberOf = {'EG'; 'Monitor'; 'Save';};
AO.EG.Monitor.Mode = 'Simulator';
AO.EG.Monitor.DataType = 'Scalar';
AO.EG.Monitor.ChannelNames = [
    'EG______BIAS___AM01'
    'EG______PHASE__AM02'
    'EG______PULSER_AM02'
    'EG______HTR____AM00' 
    'EG______HV_____AM00'	% LI0147_TS1_4
    'EG______HV_I___AM01'	% LI0147_TS1_7
    'EG______HSTEMP_AM03'   % ???
    ];
AO.EG.Monitor.HW2PhysicsParams = 1;
AO.EG.Monitor.Physics2HWParams = 1;
AO.EG.Monitor.Units        = 'Hardware';
AO.EG.Monitor.HWUnits      = '';
AO.EG.Monitor.PhysicsUnits = '';

AO.EG.Setpoint.MemberOf = {'EG'; 'Setpoint'; 'Save/Restore';};
AO.EG.Setpoint.Mode = 'Simulator';
AO.EG.Setpoint.DataType = 'Scalar';
AO.EG.Setpoint.ChannelNames = [
    'EG______BIAS___AC01'
    'EG______PHASE__AC02'
    'EG______PULSER_AC02' 
    'EG______HTR____AC00'
    'EG______HV_____AC00'	% ramp not necessary, 120 LI0130_P65_C
    '                   '
    '                   '
    ];
AO.EG.Setpoint.HW2PhysicsParams = 1;
AO.EG.Setpoint.Physics2HWParams = 1;
AO.EG.Setpoint.Units        = 'Hardware';
AO.EG.Setpoint.HWUnits      = '';
AO.EG.Setpoint.PhysicsUnits = '';
AO.EG.Setpoint.Range = [-Inf Inf];
AO.EG.Setpoint.Tolerance = ones(length(AO.EG.ElementList), 1);  % Hardware units

AO.EG.OnControl.MemberOf = {'EG'; 'Boolean Control';};
AO.EG.OnControl.Mode = 'Simulator';
AO.EG.OnControl.DataType = 'Scalar';
AO.EG.OnControl.ChannelNames = [
    '                   '
    '                   '
    '                   '
    'EG______HTR____BC22'
    'EG______HV_____BC23'
    '                   '
    '                   '
    ];
AO.EG.OnControl.HW2PhysicsParams = 1;
AO.EG.OnControl.Physics2HWParams = 1;
AO.EG.OnControl.Units        = 'Hardware';
AO.EG.OnControl.HWUnits      = '';
AO.EG.OnControl.PhysicsUnits = '';
AO.EG.OnControl.Range = [-Inf Inf];
AO.EG.OnControl.Tolerance = ones(length(AO.EG.ElementList), 1);  % Hardware units

% EG______AUX____BC23
% EG______EXTOSC_BC21
% EG______HQOSC__BC23
% EG______MQOSC__BC22


% Sub-Harmonic Buncher
AO.SHB.FamilyName = 'SHB';
AO.SHB.MemberOf = {'SHB'; 'Subharmonic Buncher';};
AO.SHB.DeviceList = [1 1; 1 2;];
AO.SHB.ElementList = (1:size(AO.SHB.DeviceList,1))';
AO.SHB.Status = ones(size(AO.SHB.DeviceList,1),1);
AO.SHB.Position = (1:size(AO.SHB.DeviceList,1))';
AO.SHB.CommonNames = [
    'GTL 125 MHz SHB1'
    'GTL 500 MHz SHB2'
    ];
AO.SHB.BaseName = {
    'irm:010:'
    'irm:011:'
    };
AO.SHB.DeviceType = {
    'IRM'
    'IRM'
};

AO.SHB.HV.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'High Voltage'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.SHB.HV.Mode = 'Simulator';
AO.SHB.HV.DataType = 'Scalar';
AO.SHB.HV.ChannelNames = [
    'GTL_____SHB1_HVAM01' % 125MHZ HV MON.
    'GTL_____SHB2_HVAM01' % 500MHZ HV MON.
    ];
AO.SHB.HV.HW2PhysicsParams = 1;
AO.SHB.HV.Physics2HWParams = 1;
AO.SHB.HV.Units        = 'Hardware';
AO.SHB.HV.HWUnits      = '';
AO.SHB.HV.PhysicsUnits = '';

AO.SHB.HVControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'High Voltage'; 'Save/Restore'; 'Setpoint';};
AO.SHB.HVControl.Mode = 'Simulator';
AO.SHB.HVControl.DataType = 'Scalar';
AO.SHB.HVControl.ChannelNames = [
    'GTL_____SHB1_HVAC01' % 125MHZ HV REF.
    'GTL_____SHB2_HVAC01' % 500MHZ HV REF.
    ];
AO.SHB.HVControl.HW2PhysicsParams = 1;
AO.SHB.HVControl.Physics2HWParams = 1;
AO.SHB.HVControl.Units        = 'Hardware';
AO.SHB.HVControl.HWUnits      = '';
AO.SHB.HVControl.PhysicsUnits = '';
AO.SHB.HVControl.Range = [-Inf Inf];
AO.SHB.HVControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units

AO.SHB.Phase.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Phase'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.SHB.Phase.Mode = 'Simulator';
AO.SHB.Phase.DataType = 'Scalar';
AO.SHB.Phase.ChannelNames = [
    'GTL_____SHB1_PHAM00' % PHASE MONITOR
    'GTL_____SHB2_PHAM00' % PHASE MONITOR
    ];
AO.SHB.Phase.HW2PhysicsParams = 1;
AO.SHB.Phase.Physics2HWParams = 1;
AO.SHB.Phase.Units        = 'Hardware';
AO.SHB.Phase.HWUnits      = '';
AO.SHB.Phase.PhysicsUnits = '';

AO.SHB.PhaseControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Phase'; 'Save/Restore'; 'Setpoint';};
AO.SHB.PhaseControl.Mode = 'Simulator';
AO.SHB.PhaseControl.DataType = 'Scalar';
AO.SHB.PhaseControl.ChannelNames = [
    'GTL_____SHB1_PHAC00' % PHASE REFERENCE
    'GTL_____SHB2_PHAC00' % PHASE REFERENCE
    ];
AO.SHB.PhaseControl.HW2PhysicsParams = 1;
AO.SHB.PhaseControl.Physics2HWParams = 1;
AO.SHB.PhaseControl.Units        = 'Hardware';
AO.SHB.PhaseControl.HWUnits      = '';
AO.SHB.PhaseControl.PhysicsUnits = '';
AO.SHB.PhaseControl.Range = [-Inf Inf];
AO.SHB.PhaseControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units

AO.SHB.Ready.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Ready'; 'Boolean Monitor';};
AO.SHB.Ready.Mode = 'Simulator';
AO.SHB.Ready.DataType = 'Scalar';
AO.SHB.Ready.ChannelNames = [
    'GTL_____SHB1_HVBM19' % SHB1 HV READY
    'GTL_____SHB2_HVBM19' % SHB2 HV READY
    ];
AO.SHB.Ready.HW2PhysicsParams = 1;
AO.SHB.Ready.Physics2HWParams = 1;
AO.SHB.Ready.Units        = 'Hardware';
AO.SHB.Ready.HWUnits      = '';
AO.SHB.Ready.PhysicsUnits = '';

AO.SHB.OnControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'OnControl'; 'Boolean Control';};
AO.SHB.OnControl.Mode = 'Simulator';
AO.SHB.OnControl.DataType = 'Scalar';
AO.SHB.OnControl.ChannelNames = [
    'GTL_____SHB1_HVBC23' % HV ON/OFF
    'GTL_____SHB2_HVBC23' % HV ON/OFF
    ];
AO.SHB.OnControl.HW2PhysicsParams = 1;
AO.SHB.OnControl.Physics2HWParams = 1;
AO.SHB.OnControl.Units        = 'Hardware';
AO.SHB.OnControl.HWUnits      = '';
AO.SHB.OnControl.PhysicsUnits = '';
AO.SHB.OnControl.Range = [0 1];
AO.SHB.OnControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units
 
AO.SHB.On.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'On'; 'Boolean Monitor';};
AO.SHB.On.Mode = 'Simulator';
AO.SHB.On.DataType = 'Scalar';
AO.SHB.On.ChannelNames = [
    'GTL_____SHB1_HVBM18' % SHB1 HV ON
    'GTL_____SHB2_HVBM18' % SHB2 HV ON'
    ];
AO.SHB.On.HW2PhysicsParams = 1;
AO.SHB.On.Physics2HWParams = 1;
AO.SHB.On.Units        = 'Hardware';
AO.SHB.On.HWUnits      = '';
AO.SHB.On.PhysicsUnits = '';

AO.SHB.PulsingControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingControl'; 'Boolean Control';};
AO.SHB.PulsingControl.Mode = 'Simulator';
AO.SHB.PulsingControl.DataType = 'Scalar';
AO.SHB.PulsingControl.ChannelNames = [
    'GTL_____SHB1_PHBC22' % PULSING ON/OFF
    'GTL_____SHB2_PHBC22' % PULSING ON/OFF
    ];
AO.SHB.PulsingControl.HW2PhysicsParams = 1;
AO.SHB.PulsingControl.Physics2HWParams = 1;
AO.SHB.PulsingControl.Units        = 'Hardware';
AO.SHB.PulsingControl.HWUnits      = '';
AO.SHB.PulsingControl.PhysicsUnits = '';
AO.SHB.PulsingControl.Range = [0 1];
AO.SHB.PulsingControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units

AO.SHB.PulsingOn.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingOn'; 'Boolean Monitor';};
AO.SHB.PulsingOn.Mode = 'Simulator';
AO.SHB.PulsingOn.DataType = 'Scalar';
AO.SHB.PulsingOn.ChannelNames = [
    'GTL_____SHB1_PHBM16' % SHB1 PULSING ON
    'GTL_____SHB2_PHBM16' % SHB2 PULSING ON
    ];
AO.SHB.PulsingOn.HW2PhysicsParams = 1;
AO.SHB.PulsingOn.Physics2HWParams = 1;
AO.SHB.PulsingOn.Units        = 'Hardware';
AO.SHB.PulsingOn.HWUnits      = '';
AO.SHB.PulsingOn.PhysicsUnits = '';

AO.SHB.PulsingReady.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingReady'; 'Boolean Monitor';};
AO.SHB.PulsingReady.Mode = 'Simulator';
AO.SHB.PulsingReady.DataType = 'Scalar';
AO.SHB.PulsingReady.ChannelNames = [
    'GTL_____SHB1_PHBM17' % SHB1 PULSING READY
    'GTL_____SHB2_PHBM17' % SHB2 PULSING READY
    ];
AO.SHB.PulsingReady.HW2PhysicsParams = 1;
AO.SHB.PulsingReady.Physics2HWParams = 1;
AO.SHB.PulsingReady.Units        = 'Hardware';
AO.SHB.PulsingReady.HWUnits      = '';
AO.SHB.PulsingReady.PhysicsUnits = '';

AO.SHB.DriveAmp.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'DriveAmp'; 'Boolean Monitor';};
AO.SHB.DriveAmp.Mode = 'Simulator';
AO.SHB.DriveAmp.DataType = 'Scalar';
AO.SHB.DriveAmp.ChannelNames = [
    'GTL_____SHB1_HVBM06' % SHB1 DRV AMP ON
    'GTL_____SHB2_HVBM06' % SHB2 DRV AMP ON
    ];
AO.SHB.DriveAmp.HW2PhysicsParams = 1;
AO.SHB.DriveAmp.Physics2HWParams = 1;
AO.SHB.DriveAmp.Units        = 'Hardware';
AO.SHB.DriveAmp.HWUnits      = '';
AO.SHB.DriveAmp.PhysicsUnits = '';

AO.SHB.Local.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Local'; 'Boolean Monitor';};
AO.SHB.Local.Mode = 'Simulator';
AO.SHB.Local.DataType = 'Scalar';
AO.SHB.Local.ChannelNames = [
    'GTL_____SHB1_HVBM05' % SHB1 IN LOCAL
    'GTL_____SHB2_HVBM05' % SHB2 IN LOCAL
    ];
AO.SHB.Local.HW2PhysicsParams = 1;
AO.SHB.Local.Physics2HWParams = 1;
AO.SHB.Local.Units        = 'Hardware';
AO.SHB.Local.HWUnits      = '';
AO.SHB.Local.PhysicsUnits = '';

AO.SHB.LocalPhase.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'LocalPhase'; 'Boolean Monitor';};
AO.SHB.LocalPhase.Mode = 'Simulator';
AO.SHB.LocalPhase.DataType = 'Scalar';
AO.SHB.LocalPhase.ChannelNames = [
    'GTL_____SHB1_HVBM02' % SHB1 PH IN LOCAL
    'GTL_____SHB2_HVBM02' % SHB2 PH IN LOCAL
    ];
AO.SHB.LocalPhase.HW2PhysicsParams = 1;
AO.SHB.LocalPhase.Physics2HWParams = 1;
AO.SHB.LocalPhase.Units        = 'Hardware';
AO.SHB.LocalPhase.HWUnits      = '';
AO.SHB.LocalPhase.PhysicsUnits = '';

AO.SHB.Comp.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Comp'; 'Boolean Monitor';};
AO.SHB.Comp.Mode = 'Simulator';
AO.SHB.Comp.DataType = 'Scalar';
AO.SHB.Comp.ChannelNames = [
    'GTL_____SHB1_HVBM03' % SHB1 PH IN COMP
    'GTL_____SHB2_HVBM03' % SHB2 PH IN COMP

    ];
AO.SHB.Comp.HW2PhysicsParams = 1;
AO.SHB.Comp.Physics2HWParams = 1;
AO.SHB.Comp.Units        = 'Hardware';
AO.SHB.Comp.HWUnits      = '';
AO.SHB.Comp.PhysicsUnits = '';

AO.SHB.Computer.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Computer'; 'Boolean Monitor';};
AO.SHB.Computer.Mode = 'Simulator';
AO.SHB.Computer.DataType = 'Scalar';
AO.SHB.Computer.ChannelNames = [
    'GTL_____SHB1_HVBM04' % SHB1 IN COMPUTER
    'GTL_____SHB2_HVBM04' % SHB2 IN COMPUTER
    ];
AO.SHB.Computer.HW2PhysicsParams = 1;
AO.SHB.Computer.Physics2HWParams = 1;
AO.SHB.Computer.Units        = 'Hardware';
AO.SHB.Computer.HWUnits      = '';
AO.SHB.Computer.PhysicsUnits = '';

AO.SHB.ExtInterlock1.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock1'; 'Boolean Monitor';};
AO.SHB.ExtInterlock1.Mode = 'Simulator';
AO.SHB.ExtInterlock1.DataType = 'Scalar';
AO.SHB.ExtInterlock1.ChannelNames = [
    'GTL_____SHB1_HVBM09' % SHB1 EXT INTRLK 1
    'GTL_____SHB2_HVBM09' % SHB2 EXT INTRLK 1
    ];
AO.SHB.ExtInterlock1.HW2PhysicsParams = 1;
AO.SHB.ExtInterlock1.Physics2HWParams = 1;
AO.SHB.ExtInterlock1.Units        = 'Hardware';
AO.SHB.ExtInterlock1.HWUnits      = '';
AO.SHB.ExtInterlock1.PhysicsUnits = '';

AO.SHB.ExtInterlock2.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock2'; 'Boolean Monitor';};
AO.SHB.ExtInterlock2.Mode = 'Simulator';
AO.SHB.ExtInterlock2.DataType = 'Scalar';
AO.SHB.ExtInterlock2.ChannelNames = [
    'GTL_____SHB1_HVBM08' % SHB1 EXT INTRLK 2
    'GTL_____SHB2_HVBM08' % SHB2 EXT INTRLK 2
    ];
AO.SHB.ExtInterlock2.HW2PhysicsParams = 1;
AO.SHB.ExtInterlock2.Physics2HWParams = 1;
AO.SHB.ExtInterlock2.Units        = 'Hardware';
AO.SHB.ExtInterlock2.HWUnits      = '';
AO.SHB.ExtInterlock2.PhysicsUnits = '';

AO.SHB.ExtInterlock3.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock3'; 'Boolean Monitor';};
AO.SHB.ExtInterlock3.Mode = 'Simulator';
AO.SHB.ExtInterlock3.DataType = 'Scalar';
AO.SHB.ExtInterlock3.ChannelNames = [
    'GTL_____SHB1_HVBM07' % SHB1 EXT INTRLK 3
    'GTL_____SHB2_HVBM07' % SHB2 EXT INTRLK 3
    ];
AO.SHB.ExtInterlock3.HW2PhysicsParams = 1;
AO.SHB.ExtInterlock3.Physics2HWParams = 1;
AO.SHB.ExtInterlock3.Units        = 'Hardware';
AO.SHB.ExtInterlock3.HWUnits      = '';
AO.SHB.ExtInterlock3.PhysicsUnits = '';

AO.SHB.FilamentTimeOut.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'FilamentTimeOut'; 'Boolean Monitor';};
AO.SHB.FilamentTimeOut.Mode = 'Simulator';
AO.SHB.FilamentTimeOut.DataType = 'Scalar';
AO.SHB.FilamentTimeOut.ChannelNames = [
    'GTL_____SHB1_HVBM10' % SHB1 FIL TIME OUT
    'GTL_____SHB2_HVBM10' % SHB2 FIL TIME OUT
    ];
AO.SHB.FilamentTimeOut.HW2PhysicsParams = 1;
AO.SHB.FilamentTimeOut.Physics2HWParams = 1;
AO.SHB.FilamentTimeOut.Units        = 'Hardware';
AO.SHB.FilamentTimeOut.HWUnits      = '';
AO.SHB.FilamentTimeOut.PhysicsUnits = '';

AO.SHB.PlugInterlock.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PlugInterlock'; 'Boolean Monitor';};
AO.SHB.PlugInterlock.Mode = 'Simulator';
AO.SHB.PlugInterlock.DataType = 'Scalar';
AO.SHB.PlugInterlock.ChannelNames = [
    'GTL_____SHB1_HVBM11' % SHB1 PLUG INTRLK
    'GTL_____SHB2_HVBM11' % SHB2 PLUG INTRLK
    ];
AO.SHB.PlugInterlock.HW2PhysicsParams = 1;
AO.SHB.PlugInterlock.Physics2HWParams = 1;
AO.SHB.PlugInterlock.Units        = 'Hardware';
AO.SHB.PlugInterlock.HWUnits      = '';
AO.SHB.PlugInterlock.PhysicsUnits = '';

AO.SHB.Thermal.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Thermal'; 'Boolean Monitor';};
AO.SHB.Thermal.Mode = 'Simulator';
AO.SHB.Thermal.DataType = 'Scalar';
AO.SHB.Thermal.ChannelNames = [
    'GTL_____SHB1_HVBM12' % SHB1 THERMAL
    'GTL_____SHB2_HVBM12' % SHB2 THERMAL
    ];
AO.SHB.Thermal.HW2PhysicsParams = 1;
AO.SHB.Thermal.Physics2HWParams = 1;
AO.SHB.Thermal.Units        = 'Hardware';
AO.SHB.Thermal.HWUnits      = '';
AO.SHB.Thermal.PhysicsUnits = '';

AO.SHB.AirFlow.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'AirFlow'; 'Boolean Monitor';};
AO.SHB.AirFlow.Mode = 'Simulator';
AO.SHB.AirFlow.DataType = 'Scalar';
AO.SHB.AirFlow.ChannelNames = [
    'GTL_____SHB1_HVBM13' % SHB1 AIR FLOW
    'GTL_____SHB2_HVBM13' % SHB2 AIR FLOW
    ];
AO.SHB.AirFlow.HW2PhysicsParams = 1;
AO.SHB.AirFlow.Physics2HWParams = 1;
AO.SHB.AirFlow.Units        = 'Hardware';
AO.SHB.AirFlow.HWUnits      = '';
AO.SHB.AirFlow.PhysicsUnits = '';

AO.SHB.AC_120V_OK.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'AC_120V_OK'; 'Boolean Monitor';};
AO.SHB.AC_120V_OK.Mode = 'Simulator';
AO.SHB.AC_120V_OK.DataType = 'Scalar';
AO.SHB.AC_120V_OK.ChannelNames = [
    'GTL_____SHB1_HVBM14' % SHB1 120VAC OK
    'GTL_____SHB2_HVBM14' % SHB2 120VAC OK
    ];
AO.SHB.AC_120V_OK.HW2PhysicsParams = 1;
AO.SHB.AC_120V_OK.Physics2HWParams = 1;
AO.SHB.AC_120V_OK.Units        = 'Hardware';
AO.SHB.AC_120V_OK.HWUnits      = '';
AO.SHB.AC_120V_OK.PhysicsUnits = '';

AO.SHB.DC_24V_OK.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'DC_24V_OK'; 'Boolean Monitor';};
AO.SHB.DC_24V_OK.Mode = 'Simulator';
AO.SHB.DC_24V_OK.DataType = 'Scalar';
AO.SHB.DC_24V_OK.ChannelNames = [
    'GTL_____SHB1_HVBM15' % SHB1 24VDC OK
    'GTL_____SHB2_HVBM15' % SHB2 24VDC OK
    ];
AO.SHB.DC_24V_OK.HW2PhysicsParams = 1;
AO.SHB.DC_24V_OK.Physics2HWParams = 1;
AO.SHB.DC_24V_OK.Units        = 'Hardware';
AO.SHB.DC_24V_OK.HWUnits      = '';
AO.SHB.DC_24V_OK.PhysicsUnits = '';


% 'GTL_____SHB1___AT03' % scope	
% 'GTL_____SHB2___AT07' % scope	



% Modulator
AO.MOD.FamilyName = 'MOD';
AO.MOD.MemberOf = {'Modulator';};
AO.MOD.DeviceList = [1 1; 1 2;];
AO.MOD.ElementList = (1:size(AO.MOD.DeviceList,1))';
AO.MOD.Status = ones(size(AO.MOD.DeviceList,1),1);
AO.MOD.Position = (1:size(AO.MOD.DeviceList,1))';
AO.MOD.CommonNames = [
    'MOD 1'
    'MOD 2'
    ];
AO.MOD.BaseName = {
    'irm:014:'
    'irm:020:'
    };
AO.MOD.DeviceType = {
    'IRM'
    'IRM'
};

AO.MOD.Monitor.MemberOf = {'Modulator'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.MOD.Monitor.Mode = 'Simulator';
AO.MOD.Monitor.DataType = 'Scalar';
AO.MOD.Monitor.ChannelNames = [
    'LN______MD1HV__AM02' % MD1HV CHARGE MON
    'LN______MD2HV__AM02' % MD2HV CHARGE MON
    ];
AO.MOD.Monitor.HW2PhysicsParams = 1;
AO.MOD.Monitor.Physics2HWParams = 1;
AO.MOD.Monitor.Units        = 'Hardware';
AO.MOD.Monitor.HWUnits      = '';
AO.MOD.Monitor.PhysicsUnits = '';

AO.MOD.Setpoint.MemberOf = {'Modulator'; 'Save/Restore'; 'Setpoint';};
AO.MOD.Setpoint.Mode = 'Simulator';
AO.MOD.Setpoint.DataType = 'Scalar';
AO.MOD.Setpoint.ChannelNames = [
    'LN______MD1HV__AC02'  % MOD1 HV CHARGE REF
    'LN______MD2HV__AC02'  % MOD2 HV CHARGE REF
    ];
AO.MOD.Setpoint.HW2PhysicsParams = 1;
AO.MOD.Setpoint.Physics2HWParams = 1;
AO.MOD.Setpoint.Units        = 'Hardware';
AO.MOD.Setpoint.HWUnits      = '';
AO.MOD.Setpoint.PhysicsUnits = '';
AO.MOD.Setpoint.Range = [-Inf Inf];
AO.MOD.Setpoint.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units

AO.MOD.Klystron.MemberOf = {'Modulator'; 'Klystron'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.MOD.Klystron.Mode = 'Simulator';
AO.MOD.Klystron.DataType = 'Scalar';
AO.MOD.Klystron.ChannelNames = [
    'LN______MD1CC__AM03' % KY1 HV CHARGE I
    'LN______MD2CC__AM03' % KY2 HV CHARGE I
    ];
AO.MOD.Klystron.HW2PhysicsParams = 1;
AO.MOD.Klystron.Physics2HWParams = 1;
AO.MOD.Klystron.Units        = 'Hardware';
AO.MOD.Klystron.HWUnits      = '';
AO.MOD.Klystron.PhysicsUnits = '';

AO.MOD.HVControl.MemberOf = {'Modulator'; 'HighVoltage'; 'Boolean Control';};
AO.MOD.HVControl.Mode = 'Simulator';
AO.MOD.HVControl.DataType = 'Scalar';
AO.MOD.HVControl.ChannelNames = [
    'LN______MD1HV__BC22'  % MOD1 HV ON/OFF
    'LN______MD2HV__BC22'  % MOD2 HV ON/OFF
    ];
AO.MOD.HVControl.HW2PhysicsParams = 1;
AO.MOD.HVControl.Physics2HWParams = 1;
AO.MOD.HVControl.Units        = 'Hardware';
AO.MOD.HVControl.HWUnits      = '';
AO.MOD.HVControl.PhysicsUnits = '';
AO.MOD.HVControl.Range = [-Inf Inf];
AO.MOD.HVControl.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units

AO.MOD.Trigger.MemberOf = {'Modulator'; 'Trigger'; 'Boolean Control';};
AO.MOD.Trigger.Mode = 'Simulator';
AO.MOD.Trigger.DataType = 'Scalar';
AO.MOD.Trigger.ChannelNames = [
    'LN______MD1TRG_BC21' % MOD1 TRIGGER ON/OFF
    'LN______MD2TRG_BC21' % MOD2 TRIGGER ON/OFF
    ];
AO.MOD.Trigger.HW2PhysicsParams = 1;
AO.MOD.Trigger.Physics2HWParams = 1;
AO.MOD.Trigger.Units        = 'Hardware';
AO.MOD.Trigger.HWUnits      = '';
AO.MOD.Trigger.PhysicsUnits = '';
AO.MOD.Trigger.Range = [-Inf Inf];
AO.MOD.Trigger.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units

AO.MOD.Start.MemberOf = {'Modulator'; 'Start'; 'Boolean Control';};
AO.MOD.Start.Mode = 'Simulator';
AO.MOD.Start.DataType = 'Scalar';
AO.MOD.Start.ChannelNames = [
    'LN______MD1____BC23' % MOD1 START/STOP
    'LN______MD2____BC23' % MOD2 START/STOP
    ];
AO.MOD.Start.HW2PhysicsParams = 1;
AO.MOD.Start.Physics2HWParams = 1;
AO.MOD.Start.Units        = 'Hardware';
AO.MOD.Start.HWUnits      = '';
AO.MOD.Start.PhysicsUnits = '';
AO.MOD.Start.Range = [-Inf Inf];
AO.MOD.Start.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units


AO.MOD.Test.MemberOf = {'Modulator'; 'Test'; 'Boolean Control';};
AO.MOD.Test.Mode = 'Simulator';
AO.MOD.Test.DataType = 'Scalar';
AO.MOD.Test.ChannelNames = [
    'LN______MD1_RF_BC21' % MOD1 RF TEST
    'LN______MD2_RF_BC21' % MOD2 RF TEST
    ];
AO.MOD.Test.HW2PhysicsParams = 1;
AO.MOD.Test.Physics2HWParams = 1;
AO.MOD.Test.Units        = 'Hardware';
AO.MOD.Test.HWUnits      = '';
AO.MOD.Test.PhysicsUnits = '';
AO.MOD.Test.Range = [-Inf Inf];
AO.MOD.Test.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units


AO.MOD.Reset.MemberOf = {'Modulator'; 'Reset'; 'Boolean Control';};
AO.MOD.Reset.Mode = 'Simulator';
AO.MOD.Reset.DataType = 'Scalar';
AO.MOD.Reset.ChannelNames = [
    'LN______MD1RST_BC23' % MOD1 RESET
    'LN______MD2RST_BC23' % MOD2 RESET
    ];
AO.MOD.Reset.HW2PhysicsParams = 1;
AO.MOD.Reset.Physics2HWParams = 1;
AO.MOD.Reset.Units        = 'Hardware';
AO.MOD.Reset.HWUnits      = '';
AO.MOD.Reset.PhysicsUnits = '';
AO.MOD.Reset.Range = [-Inf Inf];
AO.MOD.Reset.Tolerance = ones(length(AO.MOD.ElementList), 1);  % Hardware units


% LN______MD1____BM12 % START/STOP MON.  
% LN______MD2____BM12 % START/STOP MON.  

% LN______MD1____BM13 % START/STOP RDY   
% LN______MD2____BM13 % START/STOP RDY   
    
% LN______MD1HV__BM03 % MD1HV ON MONITOR 
% LN______MD2HV__BM03 % MD2HV ON MONITOR 

% LN______MD1HV__BM04 % MD1HV READY      
% LN______MD2HV__BM04 % MD2HV READY      

% LN______MD1TRG_BM02 % TRIGGER ON       
% LN______MD2TRG_BM02 % TRIGGER ON       

% LN______MD1TRG_BM18 % TRIGGER READY    
% LN______MD2TRG_BM18 % TRIGGER READY    



% LN______MD1____BM09 % MD1 DOORS        
% LN______MD1____BM08 % MD1 AIR          
% LN______MD1____BM07 % PFN TUBE FIL T/O 
% LN______MD1____BM06 % KY1 FIL. TIMEOUT 
% LN______MD1____BM05 % KY1 FOCUS        
% LN______MD1____BM10 % MD1 GROUND STICK 
% LN______MD1____BM11 % MD1 LIDS         
% LN______MD1____BM16 % KY1 OIL LEVEL    
% LN______MD1____BM15 % MD1 H2O FLOW     
% LN______MD1____BM19 % EMERGENCY OFF    
% LN______MD1____BM14 % MD1 H2O TEMP     
% LN______MD1____BM17 % KY1 ION PUMP     
% LN______MD1_RF_BM03 % bi         OFF            RF TEST MODE     
% LN______MD1_RF_BM02 % bi         OFF            RF TEST ON       
% LN______MD1_RF_BM04 % RF TEST READY    
% LN______MD1FLT_BM00 % bi         OFF            HV FAULT         
% LN______MD1INT_BM11 % LNAS1 WATER TEMP 
% LN______MD1INT_BM09 % KY1 REV POWER OK 
% LN______MD1INT_BM08 % LN VVR1 OPEN     
% LN______MD1INT_BM07 % LN SOLS OK       
% LN______MD1INT_BM10 % LNAS1 WATER FLOW 
% LN______MD1INT_BM16 % bi         OFF            E.GUN IN TEST    
% LN______MD1INT_BM15 % RADIATION CHAIN  
% LN______MD1INT_BM18 % MD1HV PERMISSIVE 
% LN______MD1INT_BM14 % WG BYPASS VALVE  
% LN______MD1INT_BM12 % LN AS1 VACUUM OK 
% LN______MD1INT_BM06 % TRIGGER READY    
% LN______MD1INT_BM13 % WG VACUUM OK     
% LN______MD1INT_BM17 % P.SAFETY CHAIN B 
% LN______MD1INT_BM19 % P.SAFETY CHAIN A 
% LN______MD1RST_BM05 % bi         OFF            RESET FAULT      
 
% LN______MD2____BM17 % KY2 ION PUMP     
% LN______MD2____BM19 % EMERGENCY OFF    
% LN______MD2____BM15 % MD2 H2O FLOW     
% LN______MD2____BM16 % KY2 OIL LEVEL    
% LN______MD2____BM10 % MD2 GROUND STICK 
% LN______MD2____BM14 % MD2 H2O TEMP     
% LN______MD2____BM06 % KY2 FIL. TIMEOUT 
% LN______MD2____BM05 % KY2 FOCUS        
% LN______MD2____BM08 % MD2 AIR          
% LN______MD2____BM07 % PFN TUBE FIL T/O 
% LN______MD2____BM11 % MD2 LIDS         
% LN______MD2____BM09 % MD2 DOORS        
% LN______MD2_RF_BM04 % RF TEST READY    
% LN______MD2_RF_BM03 % bi         OFF            RF TEST MODE     
% LN______MD2_RF_BM02 % bi         OFF            RF TEST ON       
% LN______MD2FLT_BM00 % bi         OFF            HV FAULT         
% LN______MD2INT_BM10 % LNAS1 WATER FLOW 
% LN______MD2INT_BM12 % LN AS2 VACUUM OK 
% LN______MD2INT_BM15 % RADIATION CHAIN  
% LN______MD2INT_BM13 % START/STOP RDY   
% LN______MD2INT_BM17 % P. SAFTEY B MON. 
% LN______MD2INT_BM14 % WG BYPASS VALVE  
% LN______MD2INT_BM19 % P. SAFETY A MON. 
% LN______MD2INT_BM16 bi         OFF            E.GUN IN TEST    
% LN______MD2INT_BM11 % LNAS2 WATER TEMP 
% LN______MD2INT_BM09 % KY2 REV PWR OK   
% LN______MD2INT_BM18 % MD2HV PERMISSIVE 
% LN______MD2INT_BM08 % LN VVR1 OPEN     
% LN______MD2INT_BM07 % LN SOLS OK       
% LN______MD2INT_BM06 % MOD #2 TRIG RDY  
% LN______MD2RST_BM05 % RESET FAULT      



AO.AS.FamilyName = 'AS';
AO.AS.MemberOf = {'AS';};
AO.AS.DeviceList = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 2 4; 2 5];
AO.AS.ElementList = (1:size(AO.AS.DeviceList,1))';
AO.AS.Status = ones(size(AO.AS.DeviceList,1),1);
AO.AS.Position = (1:size(AO.AS.DeviceList,1))';
AO.AS.CommonNames = [
    'AS1 Loop Phase     '
    'AS1 Pad Phase      '
    'AS1 Pad Phase Error'
    'AS2 Loop Phase     '
    'AS2 Pad Phase      '
    'AS2 Pad Phase Error'
    'AS2 Phase          '
    'LN Master Phase    '
    ];

AO.AS.Monitor.MemberOf = {'AS'; 'Monitor'; 'Save';};
AO.AS.Monitor.Mode = 'Simulator';
AO.AS.Monitor.DataType = 'Scalar';
AO.AS.Monitor.ChannelNames = [
    'LN______AS1LCT_AM01' % AS1 LOOP PHASE
    'LN______AS1PPH_AM02' % AS1 PAD PHASE
    'LN______AS1PER_AM03' % AS1 PAD PH ERROR
    'LN______AS2LCT_AM01' % AS2 LOOP PHASE
    'LN______AS2PPH_AM02' % AS2 PAD PHASE
    'LN______AS2PER_AM03' % AS2 PAD PH ERROR
    'LN______AS2_PH_AM00' % AS2 PHASE
    '                   '
    ];
AO.AS.Monitor.HW2PhysicsParams = 1;
AO.AS.Monitor.Physics2HWParams = 1;
AO.AS.Monitor.Units        = 'Hardware';
AO.AS.Monitor.HWUnits      = '';
AO.AS.Monitor.PhysicsUnits = '';

AO.AS.Setpoint.MemberOf = {'AS'; 'Save/Restore'; 'Setpoint';};
AO.AS.Setpoint.Mode = 'Simulator';
AO.AS.Setpoint.DataType = 'Scalar';
AO.AS.Setpoint.ChannelNames = [
    'LN______AS1LCT_AC01' % AS1 LOOP PHASE
    'LN______AS1PPH_AC02' % AS1 PAD PHASE
    '                   '
    'LN______AS2LCT_AC01' % AS2 LOOP PHASE
    'LN______AS2PPH_AC02' % AS2 PAD PHASE
    '                   '
    'LN______AS2_PH_AC00' % AS2 PHASE        (Tuned by ops)
    'LN______MASTPH_AC00' % LN Master Phase  (Tuned by ops)
    ];
AO.AS.Setpoint.HW2PhysicsParams = 1;
AO.AS.Setpoint.Physics2HWParams = 1;
AO.AS.Setpoint.Units        = 'Hardware';
AO.AS.Setpoint.HWUnits      = '';
AO.AS.Setpoint.PhysicsUnits = '';
AO.AS.Setpoint.Range = [0 1];
AO.AS.Setpoint.Tolerance = ones(length(AO.AS.ElementList), 1);  % Hardware units


AO.AS.LoopControl.MemberOf = {'AS'; 'Save/Restore'; 'LoopControl'; 'Boolean Control';};
AO.AS.LoopControl.Mode = 'Simulator';
AO.AS.LoopControl.DataType = 'Scalar';
AO.AS.LoopControl.ChannelNames = [
    'LN______AS1LCT_BC23' % AS1 COMP/LOCAL LOOP
    'LN______AS1LOP_BC22' % AS1 LOOP OPN/CLS
    '                   '
    'LN______AS2LCT_BC23' % AS2 COMP/LOCAL LOOP
    'LN______AS2LOP_BC22' % AS2 LOOP OPN/CLS
    '                   '
    '                   '
    '                   '
    ];
AO.AS.LoopControl.HW2PhysicsParams = 1;
AO.AS.LoopControl.Physics2HWParams = 1;
AO.AS.LoopControl.Units        = 'Hardware';
AO.AS.LoopControl.HWUnits      = '';
AO.AS.LoopControl.PhysicsUnits = '';
AO.AS.LoopControl.Range = [0 1];
AO.AS.LoopControl.Tolerance = .5 * ones(length(AO.AS.ElementList), 1);  % Hardware units

% Extra BM & BC in the ExtraMonitor family

% 'LN______AS1____AT16' % scope
% 'LN______AS2____AT19' % scope	


% TV
AO.TV.FamilyName = 'TV';
AO.TV.MemberOf = {'PlotFamily'; 'TV';};
AO.TV.DeviceList = [1 1; 1 2; 2 1; 2 2; 3 1; 3 3; 3 4; 3 5; 3 6;];  %3 2 is in the FC line
AO.TV.ElementList = (1:size(AO.TV.DeviceList,1))';
AO.TV.Status = ones(size(AO.TV.DeviceList,1),1);
AO.TV.Position = (1:size(AO.TV.DeviceList,1))';
AO.TV.CommonNames = getname_gtb('TV', 'CommonNames');

AO.TV.Monitor.MemberOf = {'PlotFamily';  'Boolean Monitor';};
AO.TV.Monitor.Mode = 'Simulator';
AO.TV.Monitor.DataType = 'Scalar';
AO.TV.Monitor.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Monitor');
AO.TV.Monitor.HW2PhysicsParams = 1;
AO.TV.Monitor.Physics2HWParams = 1;
AO.TV.Monitor.Units        = 'Hardware';
AO.TV.Monitor.HWUnits      = '';
AO.TV.Monitor.PhysicsUnits = '';

AO.TV.Setpoint.MemberOf = {'TV'; 'Boolean Control';};
AO.TV.Setpoint.Mode = 'Simulator';
AO.TV.Setpoint.DataType = 'Scalar';
AO.TV.Setpoint.ChannelNames = ''; % getname_gtb(AO.TV.FamilyName, 'Setpoint');
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
AO.TV.Video.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Video');
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
AO.TV.InControl.ChannelNames = getname_gtb(AO.TV.FamilyName, 'InControl');
AO.TV.InControl.HW2PhysicsParams = 1;
AO.TV.InControl.Physics2HWParams = 1;
AO.TV.InControl.Units        = 'Hardware';
AO.TV.InControl.HWUnits      = '';
AO.TV.InControl.PhysicsUnits = '';
AO.TV.InControl.Range = [0 1];

AO.TV.In.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.In.Mode = 'Simulator';
AO.TV.In.DataType = 'Scalar';
AO.TV.In.ChannelNames = getname_gtb(AO.TV.FamilyName, 'In');
AO.TV.In.HW2PhysicsParams = 1;
AO.TV.In.Physics2HWParams = 1;
AO.TV.In.Units        = 'Hardware';
AO.TV.In.HWUnits      = '';
AO.TV.In.PhysicsUnits = '';

AO.TV.Out.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Out.Mode = 'Simulator';
AO.TV.Out.DataType = 'Scalar';
AO.TV.Out.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Out');
AO.TV.Out.HW2PhysicsParams = 1;
AO.TV.Out.Physics2HWParams = 1;
AO.TV.Out.Units        = 'Hardware';
AO.TV.Out.HWUnits      = '';
AO.TV.Out.PhysicsUnits = '';

AO.TV.LampControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.TV.LampControl.Mode = 'Simulator';
AO.TV.LampControl.DataType = 'Scalar';
AO.TV.LampControl.ChannelNames = getname_gtb(AO.TV.FamilyName, 'LampControl');
AO.TV.LampControl.HW2PhysicsParams = 1;
AO.TV.LampControl.Physics2HWParams = 1;
AO.TV.LampControl.Units        = 'Hardware';
AO.TV.LampControl.HWUnits      = '';
AO.TV.LampControl.PhysicsUnits = '';
AO.TV.LampControl.Range = [0 1];

AO.TV.Lamp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Lamp.Mode = 'Simulator';
AO.TV.Lamp.DataType = 'Scalar';
AO.TV.Lamp.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Lamp');
AO.TV.Lamp.HW2PhysicsParams = 1;
AO.TV.Lamp.Physics2HWParams = 1;
AO.TV.Lamp.Units        = 'Hardware';
AO.TV.Lamp.HWUnits      = '';
AO.TV.Lamp.PhysicsUnits = '';


% VVR
AO.VVR.FamilyName  = 'VVR';
AO.VVR.MemberOf    = {'VVR'; 'Vacuum';};
AO.VVR.DeviceList  = [1 1; 2 1; 3 1; 3 2;];
AO.VVR.ElementList = (1:size(AO.VVR.DeviceList,1))';
AO.VVR.Status      = ones(size(AO.VVR.DeviceList,1),1);
AO.VVR.Position    = [1 2 3 4]';
AO.VVR.CommonNames = getname_gtb('VVR', 'CommonNames');

AO.VVR.OpenControl.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Control'; 'PlotFamily'; 'Save';};
AO.VVR.OpenControl.Mode = 'Simulator';
AO.VVR.OpenControl.DataType = 'Scalar';
AO.VVR.OpenControl.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'OpenControl');
AO.VVR.OpenControl.HW2PhysicsParams = 1;
AO.VVR.OpenControl.Physics2HWParams = 1;
AO.VVR.OpenControl.Units        = 'Hardware';
AO.VVR.OpenControl.HWUnits      = '';
AO.VVR.OpenControl.PhysicsUnits = '';
AO.VVR.OpenControl.Range = [0 1];

AO.VVR.Open.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Open.Mode = 'Simulator';
AO.VVR.Open.DataType = 'Scalar';
AO.VVR.Open.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Open');
AO.VVR.Open.HW2PhysicsParams = 1;
AO.VVR.Open.Physics2HWParams = 1;
AO.VVR.Open.Units        = 'Hardware';
AO.VVR.Open.HWUnits      = '';
AO.VVR.Open.PhysicsUnits = '';

AO.VVR.Closed.MemberOf = {'VVR'; 'Vacuum'; 'PlotFamily'; 'Boolean Monitor';};
AO.VVR.Closed.Mode = 'Simulator';
AO.VVR.Closed.DataType = 'Scalar';
AO.VVR.Closed.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Closed');
AO.VVR.Closed.HW2PhysicsParams = 1;
AO.VVR.Closed.Physics2HWParams = 1;
AO.VVR.Closed.Units        = 'Hardware';
AO.VVR.Closed.HWUnits      = '';
AO.VVR.Closed.PhysicsUnits = '';

AO.VVR.UpStream.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.UpStream.Mode = 'Simulator';
AO.VVR.UpStream.DataType = 'Scalar';
AO.VVR.UpStream.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'UpStream');
AO.VVR.UpStream.HW2PhysicsParams = 1;
AO.VVR.UpStream.Physics2HWParams = 1;
AO.VVR.UpStream.Units        = 'Hardware';
AO.VVR.UpStream.HWUnits      = '';
AO.VVR.UpStream.PhysicsUnits = '';

AO.VVR.DownStream.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.DownStream.Mode = 'Simulator';
AO.VVR.DownStream.DataType = 'Scalar';
AO.VVR.DownStream.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'DownStream');
AO.VVR.DownStream.HW2PhysicsParams = 1;
AO.VVR.DownStream.Physics2HWParams = 1;
AO.VVR.DownStream.Units        = 'Hardware';
AO.VVR.DownStream.HWUnits      = '';
AO.VVR.DownStream.PhysicsUnits = '';

AO.VVR.Ready.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Ready.Mode = 'Simulator';
AO.VVR.Ready.DataType = 'Scalar';
AO.VVR.Ready.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Ready');
AO.VVR.Ready.HW2PhysicsParams = 1;
AO.VVR.Ready.Physics2HWParams = 1;
AO.VVR.Ready.Units        = 'Hardware';
AO.VVR.Ready.HWUnits      = '';
AO.VVR.Ready.PhysicsUnits = '';

AO.VVR.Interlock.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Interlock.Mode = 'Simulator';
AO.VVR.Interlock.DataType = 'Scalar';
AO.VVR.Interlock.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Interlock');
AO.VVR.Interlock.HW2PhysicsParams = 1;
AO.VVR.Interlock.Physics2HWParams = 1;
AO.VVR.Interlock.Units        = 'Hardware';
AO.VVR.Interlock.HWUnits      = '';
AO.VVR.Interlock.PhysicsUnits = '';

AO.VVR.Local.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Local.Mode = 'Simulator';
AO.VVR.Local.DataType = 'Scalar';
AO.VVR.Local.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Local');
AO.VVR.Local.HW2PhysicsParams = 1;
AO.VVR.Local.Physics2HWParams = 1;
AO.VVR.Local.Units        = 'Hardware';
AO.VVR.Local.HWUnits      = '';
AO.VVR.Local.PhysicsUnits = '';

AO.VVR.DC_24V_OK.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.DC_24V_OK.Mode = 'Simulator';
AO.VVR.DC_24V_OK.DataType = 'Scalar';
AO.VVR.DC_24V_OK.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'DC_24V_OK');
AO.VVR.DC_24V_OK.HW2PhysicsParams = 1;
AO.VVR.DC_24V_OK.Physics2HWParams = 1;
AO.VVR.DC_24V_OK.Units        = 'Hardware';
AO.VVR.DC_24V_OK.HWUnits      = '';
AO.VVR.DC_24V_OK.PhysicsUnits = '';

AO.VVR.Air.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Air.Mode = 'Simulator';
AO.VVR.Air.DataType = 'Scalar';
AO.VVR.Air.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Air');
AO.VVR.Air.HW2PhysicsParams = 1;
AO.VVR.Air.Physics2HWParams = 1;
AO.VVR.Air.Units        = 'Hardware';
AO.VVR.Air.HWUnits      = '';
AO.VVR.Air.PhysicsUnits = '';

AO.VVR.Cathode.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Cathode.Mode = 'Simulator';
AO.VVR.Cathode.DataType = 'Scalar';
AO.VVR.Cathode.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Cathode');
AO.VVR.Cathode.HW2PhysicsParams = 1;
AO.VVR.Cathode.Physics2HWParams = 1;
AO.VVR.Cathode.Units        = 'Hardware';
AO.VVR.Cathode.HWUnits      = '';
AO.VVR.Cathode.PhysicsUnits = '';



% Extra Monitors
NameCell = {
    'EG______EXTOSC_BM05', 'Ext Osc Sel'
    'EG______MQOSC__BM06', 'Ext Osc Sel'
    'EG______HQOSC__BM07', 'MQ MO Sel'
    
   %'EG______MO_____AM00', 'Freq Reference'
   %'EG______MO_CENTBM15', 'MO CENTER REF FOR V'
   %'EG______MO_COMPBM13', 'MO COMP REF FOR VCX'
   %'EG______MO_EXT_BM10', 'MO IN EXT. POSITION'
   %'EG______MO_LOC_BM14', 'MO IN LOCAL REF'
   %'EG______MO_NORMBM11', 'MO IN NORM POSITION'
   %'EG______MO_OK__BM09', 'MO DRV LEVEL OK'
   %'EG______MO_SWP_BM12', 'MO IN SWEEP POSITION'
        
    'EG______AUX____BM12', 'EN GTL VVR1+INM1'
    'EG______AUX____BM13', 'RF TEST BM'
    'EG______AUX____BM15', 'AUX RDY'
    'EG______AUX____BM11', 'HV TEST LOC BM'
    'EG______AUX____BM09', 'AUX LOC CNTL BM'
    'EG______AUX____BM14', 'AUX ON BM'
    'EG______AUX____BM10', 'GUN OPERATNL BM1'
    
    'EG______HTR____BM01', 'HTR LOC CNTL BM'
    'EG______HTR____BM08', 'HEATER RDY'
    'EG______HTR____BM07', 'HTR ON BM1'
    'EG______HTR____BM06', 'K AIR BM'
    'EG______HTR____BM02', 'HV TEST OFF BM'
    'EG______HTR____BM03', 'RF TEST OFF'
    'EG______HTR____BM04', 'GTL IP1(B) BM1'
    'EG______HTR____BM05', 'EG IP1 BM'
    
    'EG______HV_____BM12', 'HTR OFF BM'
    'EG______HV_____BM02', 'HV LOC CNTL BM'
    'EG______HV_____BM10', 'GTL IP1(B) BM2'
    'EG______HV_____BM11', 'GTL VVR1 CLSD BM'
    'EG______HV_____BM13', 'HV TEST BM'
    'EG______HV_____BM09', 'GUN OPERATIONAL BM2'
    'EG______HV_____BM14', 'HV ON BM'
    'EG______HV_____BM08', 'HTR ON BM2'
    'EG______HV_____BM06', 'GTL(IP1C+IG1)BM2'
    'EG______HV_____BM03', 'P SAFETY 2 BM'
    'EG______HV_____BM04', 'P SAFETY 1 BM'
    'EG______HV_____BM05', 'HV ENCLOSURE BM'
    'EG______HV_____BM07', 'GTL VVR1 OPEN BM'
    'EG______HV_____BM15', 'HV RDY BM1'
    
   %'GTL_____TIME2__BM17', 'TIME2 RNP READY'
   %'GTL_____TIME2__BM16', 'TIME2 NOT RAMP'
   %'GTL_____TIME2__BM18', 'TIME2 LOCAL/REMOTE'    

    'LN______SBUNAT_AM01', 'SBUN ATTEN POSITION'
    'LN______SBUNPH_AM00', 'SBUN PHASE SHIFT POSITION'

    'LN______AS1LCT_BM06', 'AS1 COMP LOOP MON'
    'LN______AS1LCT_BM07', 'AS1 COMP LOOP RDY'
    'LN______AS1LCT_BM12', 'AS1 COMP LOOP ON'
    'LN______AS1LCT_BM13', 'AS1 LOCAL LOOP MON'
    'LN______AS1LOP_BM04', 'AS1 LOOP OPN/CLS MON'
    'LN______AS1LOP_BM05', 'AS1 LOOP RDY'
    'LN______AS1LOP_BM10', 'AS1 LOOP CLOSED'
    'LN______AS1LOP_BM11', 'AS1 LOOP OPEN'
    'LN______AS1PPH_BM08', 'AS1 PAD PH READY'
    'LN______AS1PPH_BM09', 'AS1 PAD PH IN LOCAL'
    
    'LN______AS2LCT_BM06', 'AS2 COMP LOOP MON'
    'LN______AS2LCT_BM07', 'AS2 COMP LOOP RDY'
    'LN______AS2LCT_BM12', 'AS2 COMP LOOP ON'
    'LN______AS2LCT_BM13', 'AS2 LOCAL LOOP MON'
    'LN______AS2LOP_BM04', 'AS2 LOOP OPN/CLS MON'
    'LN______AS2LOP_BM05', 'AS2 LOOP RDY'
    'LN______AS2LOP_BM10', 'AS2 LOOP CLOSED'
    'LN______AS2LOP_BM11', 'AS2 LOOP OPEN'
    'LN______AS2PPH_BM08', 'AS2 PAD PH READY'
    'LN______AS2PPH_BM09', 'AS2 PAD PH IN LOCAL'
    
    'LN______AS2_PH_BM14', 'AS2 PHASE RDY'
    'LN______AS2_PH_BM15', 'AS2 PH IN LOCAL'    
    };

AO.ExtraMonitors.FamilyName = 'ExtraMonitors';
AO.ExtraMonitors.MemberOf = {'ExtraMonitors'};
AO.ExtraMonitors.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraMonitors.ElementList = (1:size(AO.ExtraMonitors.DeviceList,1))';
AO.ExtraMonitors.Status = ones(size(AO.ExtraMonitors.DeviceList,1),1);
AO.ExtraMonitors.Position = (1:size(NameCell,1))';
AO.ExtraMonitors.CommonNames = str2mat(NameCell(:,2));

AO.ExtraMonitors.Monitor.MemberOf = {'ExtraMonitors'; 'Boolean Monitor'; 'Save';};
AO.ExtraMonitors.Monitor.Mode = 'Simulator';
AO.ExtraMonitors.Monitor.DataType = 'Scalar';
AO.ExtraMonitors.Monitor.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraMonitors.Monitor.HW2PhysicsParams = 1;
AO.ExtraMonitors.Monitor.Physics2HWParams = 1;
AO.ExtraMonitors.Monitor.Units        = 'Hardware';
AO.ExtraMonitors.Monitor.HWUnits      = '';
AO.ExtraMonitors.Monitor.PhysicsUnits = '';


% Extra controls
NameCell = {
    'EG______HTR____BC22', 'EG HEATER ON/OFF'
    'EG______HV_____BC23', 'EG HV ON/OFF'
    'LN______SBUNAT_BC16', 'SBUN ATTENUATOR RUN IN/OUT'
    'LN______SBUNAT_BC19', 'SBUN ATTENUATOR ON/OFF CNT'
    'LN______SBUNAT_BC18', 'SBUN ATTENUATOR SLOW'
    'LN______SBUNAT_BC17', 'SBUN ATTENUATOR FAST'
    'LN______SBUNPH_BC21', 'SBUN PHASE SHIFT FAST'
    'LN______SBUNPH_BC20', 'SBUN IN/OUT CONTROL'
    'LN______SBUNPH_BC22', 'SBUN PHASE SHIFT SLOW'
    'LN______SBUNPH_BC23', 'SBUN PHASE SHIFT ON/OFF'
    'LN______WTRHE__BC22', 'LN H EXCHGR ON/OFF'
    'LN______WTRHTR_BC21', 'LN WTR HTR ON/OFF'
    'LN______WTRPMP_BC23', 'LN WTR PUMP ON/OFF'
    'LN______WTRRST_BC20', 'LN SYS INTRLK RESET'
    };

AO.ExtraControls.FamilyName = 'ExtraControls';
AO.ExtraControls.MemberOf = {'ExtraControls';};
AO.ExtraControls.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraControls.ElementList = (1:size(AO.ExtraControls.DeviceList,1))';
AO.ExtraControls.Status = ones(size(AO.ExtraControls.DeviceList,1),1);
AO.ExtraControls.Position = (1:size(NameCell,1))';
AO.ExtraControls.CommonNames = str2mat(NameCell(:,2));

AO.ExtraControls.Setpoint.MemberOf = {'ExtraControls'; 'Setpoint'; 'Save';};
AO.ExtraControls.Setpoint.Mode = 'Simulator';
AO.ExtraControls.Setpoint.DataType = 'Scalar';
AO.ExtraControls.Setpoint.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraControls.Setpoint.HW2PhysicsParams = 1;
AO.ExtraControls.Setpoint.Physics2HWParams = 1;
AO.ExtraControls.Setpoint.Units        = 'Hardware';
AO.ExtraControls.Setpoint.HWUnits      = '';
AO.ExtraControls.Setpoint.PhysicsUnits = '';
AO.ExtraControls.Setpoint.Range = [-Inf Inf];
AO.ExtraControls.Setpoint.Tolerance = Inf * ones(length(AO.ExtraControls.ElementList), 1);  % Hardware units


% Extra controls that are included in save/restore
NameCell = {
   %'EG______MO_____AC00', 'MO'               % Set by the storage ring (new mini-IOC ???)
    'EG______HQOSC__BC23', 'HQ MO Sel'
    'EG______MQOSC__BC22', 'MQ MO Sel'
    'EG______EXTOSC_BC21', 'Ext Osc Sel'
    'LN______WTRTMP_AC00', 'LN WATER TEMP'
    };

AO.ExtraMachineConfig.FamilyName = 'ExtraMachineConfig';
AO.ExtraMachineConfig.MemberOf = {'ExtraMachineConfig'};
AO.ExtraMachineConfig.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraMachineConfig.ElementList = (1:size(AO.ExtraMachineConfig.DeviceList,1))';
AO.ExtraMachineConfig.Status = ones(size(AO.ExtraMachineConfig.DeviceList,1),1);
AO.ExtraMachineConfig.Position = (1:size(NameCell,1))';
AO.ExtraMachineConfig.CommonNames = str2mat(NameCell(:,2));

AO.ExtraMachineConfig.Setpoint.MemberOf = {'Save/Restore'; 'Setpoint'}; 
AO.ExtraMachineConfig.Setpoint.Mode = 'Simulator';
AO.ExtraMachineConfig.Setpoint.DataType = 'Scalar';
AO.ExtraMachineConfig.Setpoint.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraMachineConfig.Setpoint.HW2PhysicsParams = 1;
AO.ExtraMachineConfig.Setpoint.Physics2HWParams = 1;
AO.ExtraMachineConfig.Setpoint.Units        = 'Hardware';
AO.ExtraMachineConfig.Setpoint.HWUnits      = '';
AO.ExtraMachineConfig.Setpoint.PhysicsUnits = '';
AO.ExtraMachineConfig.Setpoint.Range = [-Inf Inf];
AO.ExtraMachineConfig.Setpoint.Tolerance = Inf * ones(length(AO.ExtraMachineConfig.ElementList), 1);  % Hardware units



% IP, IG families???



% Save the AO so that family2dev will work
setao(AO);


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);





% AO.NewFamily.FamilyName = 'NewFamily';
% AO.NewFamily.MemberOf = {'NewFamily';};
% AO.NewFamily.DeviceList = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 3 3;3 4; 3 5; 3 6;];
% AO.NewFamily.ElementList = (1:size(AO.NewFamily.DeviceList,1))';
% AO.NewFamily.Status = ones(size(AO.NewFamily.DeviceList,1),1);
% AO.NewFamily.Position = (1:size(AO.NewFamily.DeviceList,1))';
% AO.NewFamily.CommonNames = [
%     ];
%
% AO.NewFamily.Monitor.MemberOf = {'NewFamily'; 'Monitor'; };
% AO.NewFamily.Monitor.Mode = 'Simulator';
% AO.NewFamily.Monitor.DataType = 'Scalar';
% AO.NewFamily.Monitor.ChannelNames = [
%     ];
% AO.NewFamily.Monitor.HW2PhysicsParams = 1;
% AO.NewFamily.Monitor.Physics2HWParams = 1;
% AO.NewFamily.Monitor.Units        = 'Hardware';
% AO.NewFamily.Monitor.HWUnits      = '';
% AO.NewFamily.Monitor.PhysicsUnits = '';
%
% AO.NewFamily.Setpoint.MemberOf = {'NewFamily'; 'Setpoint'};
% AO.NewFamily.Setpoint.Mode = 'Simulator';
% AO.NewFamily.Setpoint.DataType = 'Scalar';
% AO.NewFamily.Setpoint.ChannelNames = [
%     ];
% AO.NewFamily.Setpoint.HW2PhysicsParams = 1;
% AO.NewFamily.Setpoint.Physics2HWParams = 1;
% AO.NewFamily.Setpoint.Units        = 'Hardware';
% AO.NewFamily.Setpoint.HWUnits      = '';
% AO.NewFamily.Setpoint.PhysicsUnits = '';
% AO.NewFamily.Setpoint.Range = [0 1];
% AO.NewFamily.Setpoint.Tolerance = ones(length(AO.NewFamily.ElementList), 1);  % Hardware units
%
% AO.NewFamily.BC.MemberOf = {'NewFamily'; 'BC'};
% AO.NewFamily.BC.Mode = 'Simulator';
% AO.NewFamily.BC.DataType = 'Scalar';
% AO.NewFamily.BC.ChannelNames = [
%     ];
% AO.NewFamily.BC.HW2PhysicsParams = 1;
% AO.NewFamily.BC.Physics2HWParams = 1;
% AO.NewFamily.BC.Units        = 'Hardware';
% AO.NewFamily.BC.HWUnits      = '';
% AO.NewFamily.BC.PhysicsUnits = '';
% AO.NewFamily.BC.Range = [-Inf Inf];
% AO.NewFamily.BC.Tolerance = ones(length(AO.NewFamily.ElementList), 1);  % Hardware units
