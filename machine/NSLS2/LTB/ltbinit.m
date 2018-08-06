function ltbinit(OperationalMode)
%LTBINIT

if nargin < 1
    % 1 => 200 MeV injection
    OperationalMode = 1;
end


% To do
% tolerance, DeltaRespMat, RampRate


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);

% BPM
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'BPM'; 'BPMx';};
AO.BPMx.DeviceList  = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7;];  % 7th is booster
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = [ones(6,1); 0];
AO.BPMx.Position    = [];
AO.BPMx.CommonNames = [
    'BPMx1    '
    'BPMx2    '
    'BPMx3    '
    'BPMx4    '
    'BPMx5    '
    'BPMx6    '
    'BPMxBR2SI'
    ];

AO.BPMx.Monitor.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Save';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = [
    'LTB-BI{BPM:1}Pos:X-I'
    'LTB-BI{BPM:2}Pos:X-I'
    'LTB-BI{BPM:3}Pos:X-I'
    'LTB-BI{BPM:4}Pos:X-I'
    'LTB-BI{BPM:5}Pos:X-I'
    'LTB-BI{BPM:6}Pos:X-I'
    '                    '
    ];
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_ltb;

AO.BPMx.Sum.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Sum';};
AO.BPMx.Sum.Mode = 'Simulator';
AO.BPMx.Sum.DataType = 'Scalar';
AO.BPMx.Sum.ChannelNames = [
    'LTB-BI{BPM:1}Ampl:SSA-Calc'
    'LTB-BI{BPM:2}Ampl:SSA-Calc'
    'LTB-BI{BPM:3}Ampl:SSA-Calc'
    'LTB-BI{BPM:4}Ampl:SSA-Calc'
    'LTB-BI{BPM:5}Ampl:SSA-Calc'
    'LTB-BI{BPM:6}Ampl:SSA-Calc'
    '                          '
    ];
AO.BPMx.Sum.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
AO.BPMx.Sum.Physics2HWParams = 1;
AO.BPMx.Sum.Units            = 'Hardware';
AO.BPMx.Sum.HWUnits          = '';
AO.BPMx.Sum.PhysicsUnits     = '';

% AO.BPMx.Button1.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Button1';};
% AO.BPMx.Button1.Mode = 'Simulator';
% AO.BPMx.Button1.DataType = 'Scalar';
% AO.BPMx.Button1.ChannelNames = getname_ltb(AO.BPMx.FamilyName, 'Button1');
% AO.BPMx.Button1.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
% AO.BPMx.Button1.Physics2HWParams = 1;
% AO.BPMx.Button1.Units            = 'Hardware';
% AO.BPMx.Button1.HWUnits          = '';
% AO.BPMx.Button1.PhysicsUnits     = '';
% %AO.BPMx.Button1.SpecialFunctionGet = @getbpm_voltage;
%
% AO.BPMx.Button2.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Button2';};
% AO.BPMx.Button2.Mode = 'Simulator';
% AO.BPMx.Button2.DataType = 'Scalar';
% AO.BPMx.Button2.ChannelNames = getname_ltb(AO.BPMx.FamilyName, 'Button2');
% AO.BPMx.Button2.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
% AO.BPMx.Button2.Physics2HWParams = 1;
% AO.BPMx.Button2.Units            = 'Hardware';
% AO.BPMx.Button2.HWUnits          = '';
% AO.BPMx.Button2.PhysicsUnits     = '';
% %AO.BPMx.Button2.SpecialFunctionGet = @getbpm_voltage;
%
% AO.BPMx.Button3.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Button3';};
% AO.BPMx.Button3.Mode = 'Simulator';
% AO.BPMx.Button3.DataType = 'Scalar';
% AO.BPMx.Button3.ChannelNames = getname_ltb(AO.BPMx.FamilyName, 'Button3');
% AO.BPMx.Button3.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
% AO.BPMx.Button3.Physics2HWParams = 1;
% AO.BPMx.Button3.Units            = 'Hardware';
% AO.BPMx.Button3.HWUnits          = '';
% AO.BPMx.Button3.PhysicsUnits     = '';
% %AO.BPMx.Button3.SpecialFunctionGet = @getbpm_voltage;
%
% AO.BPMx.Button4.MemberOf = {'PlotFamily'; 'BPM'; 'BPMx'; 'Monitor'; 'Button4';};
% AO.BPMx.Button4.Mode = 'Simulator';
% AO.BPMx.Button4.DataType = 'Scalar';
% AO.BPMx.Button4.ChannelNames = getname_ltb(AO.BPMx.FamilyName, 'Button4');
% AO.BPMx.Button4.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
% AO.BPMx.Button4.Physics2HWParams = 1;
% AO.BPMx.Button4.Units            = 'Hardware';
% AO.BPMx.Button4.HWUnits          = '';
% AO.BPMx.Button4.PhysicsUnits     = '';
% %AO.BPMx.Button4.SpecialFunctionGet = @getbpm_voltage;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'BPM'; 'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = [
    'BPMy1    '
    'BPMy2    '
    'BPMy3    '
    'BPMy4    '
    'BPMy5    '
    'BPMy6    '
    'BPMyBR2SI'
    ];

AO.BPMy.Monitor.MemberOf = {'PlotFamily'; 'BPM'; 'BPMy'; 'Monitor'; 'Save';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = [
    'LTB-BI{BPM:1}Pos:Y-I'
    'LTB-BI{BPM:2}Pos:Y-I'
    'LTB-BI{BPM:3}Pos:Y-I'
    'LTB-BI{BPM:4}Pos:Y-I'
    'LTB-BI{BPM:5}Pos:Y-I'
    'LTB-BI{BPM:6}Pos:Y-I'
    '                    '
    ];
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';

AO.BPMy.Sum.MemberOf = {'PlotFamily'; 'BPM'; 'BPMy'; 'Monitor'; 'Sum';};
AO.BPMy.Sum.Mode = 'Simulator';
AO.BPMy.Sum.DataType = 'Scalar';
AO.BPMy.Sum.ChannelNames = [
    'LTB-BI{BPM:1}Ampl:SSA-Calc'
    'LTB-BI{BPM:2}Ampl:SSA-Calc'
    'LTB-BI{BPM:3}Ampl:SSA-Calc'
    'LTB-BI{BPM:4}Ampl:SSA-Calc'
    'LTB-BI{BPM:5}Ampl:SSA-Calc'
    'LTB-BI{BPM:6}Ampl:SSA-Calc'
    '                          '
    ];
AO.BPMy.Sum.HW2PhysicsParams = 1;  % HW [Volts], Simulator [Volts]
AO.BPMy.Sum.Physics2HWParams = 1;
AO.BPMy.Sum.Units            = 'Hardware';
AO.BPMy.Sum.HWUnits          = '';
AO.BPMy.Sum.PhysicsUnits     = '';


% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'HCM'; 'Magnet'; 'COR';};
AO.HCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8;];
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];
AO.HCM.CommonNames = [
    'HCOR1'
    'HCOR2'
    'HCOR3'
    'HCOR4'
    'HCOR5'
    'HCOR6'
    'HCOR7'
    'HCOR8'
    ];

AO.HCM.Monitor.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = [
    'LTB-MG{Cor:1}I:Ps1DCCT1-I'
    'LTB-MG{Cor:2}I:Ps1DCCT1-I'
    'LTB-MG{Cor:3}I:Ps1DCCT1-I'
    'LTB-MG{Cor:4}I:Ps1DCCT1-I'
    'LTB-MG{Cor:5}I:Ps1DCCT1-I'
    'LTB-MG{Cor:6}I:Ps1DCCT1-I'
    'LTB-MG{Cor:7}I:Ps1DCCT1-I'
    'LTB-MG{Cor:8}I:Ps1DCCT1-I'
    ];
AO.HCM.Monitor.HW2PhysicsFcn = @hw2at;
AO.HCM.Monitor.Physics2HWFcn = @at2hw;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
%AO.HCM.Monitor.Real2RawFcn = @real2raw_ltb;
%AO.HCM.Monitor.Raw2RealFcn = @raw2real_ltb;

AO.HCM.Setpoint.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Save/Restore'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = [
    'LTB-MG{Cor:1}I:Sp1-SP'
    'LTB-MG{Cor:2}I:Sp1-SP'
    'LTB-MG{Cor:3}I:Sp1-SP'
    'LTB-MG{Cor:4}I:Sp1-SP'
    'LTB-MG{Cor:5}I:Sp1-SP'
    'LTB-MG{Cor:6}I:Sp1-SP'
    'LTB-MG{Cor:7}I:Sp1-SP'
    'LTB-MG{Cor:8}I:Sp1-SP'
    ];
AO.HCM.Setpoint.HW2PhysicsFcn = @hw2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2hw;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range = [-3 3];
AO.HCM.Setpoint.Tolerance  = .1 * ones(length(AO.HCM.ElementList), 1);  % Hardware units
AO.HCM.Setpoint.DeltaRespMat = 1;
%AO.HCM.Setpoint.RampRate = 1;
%AO.HCM.Setpoint.RunFlagFcn = @getrunflag_ltb;

% AO.HCM.RampRate.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Save/Restore';};
% AO.HCM.RampRate.Mode = 'Simulator';
% AO.HCM.RampRate.DataType = 'Scalar';
% AO.HCM.RampRate.ChannelNames = getname_ltb(AO.HCM.FamilyName, 'RampRate');
% AO.HCM.RampRate.HW2PhysicsParams = 1;
% AO.HCM.RampRate.Physics2HWParams = 1;
% AO.HCM.RampRate.Units        = 'Hardware';
% AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.HCM.OnControl.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = [
    'LTB-MG{Cor:1}PsOnOff-Sel'
    'LTB-MG{Cor:2}PsOnOff-Sel'
    'LTB-MG{Cor:3}PsOnOff-Sel'
    'LTB-MG{Cor:4}PsOnOff-Sel'
    'LTB-MG{Cor:5}PsOnOff-Sel'
    'LTB-MG{Cor:6}PsOnOff-Sel'
    'LTB-MG{Cor:7}PsOnOff-Sel'
    'LTB-MG{Cor:8}PsOnOff-Sel'
    ];
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units        = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';
AO.HCM.OnControl.Range = [0 1];
%AO.HCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

% AO.HCM.On.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
% AO.HCM.On.Mode = 'Simulator';
% AO.HCM.On.DataType = 'Scalar';
% AO.HCM.On.ChannelNames = getname_ltb(AO.HCM.FamilyName, 'On');
% AO.HCM.On.HW2PhysicsParams = 1;
% AO.HCM.On.Physics2HWParams = 1;
% AO.HCM.On.Units        = 'Hardware';
% AO.HCM.On.HWUnits      = '';
% AO.HCM.On.PhysicsUnits = '';

AO.HCM.Fault.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.Fault.Mode = 'Simulator';
AO.HCM.Fault.DataType = 'Scalar';
AO.HCM.Fault.ChannelNames = [
    'LTB-MG{Cor:1}Sum1-Sts'
    'LTB-MG{Cor:2}Sum1-Sts'
    'LTB-MG{Cor:3}Sum1-Sts'
    'LTB-MG{Cor:4}Sum1-Sts'
    'LTB-MG{Cor:5}Sum1-Sts'
    'LTB-MG{Cor:6}Sum1-Sts'
    'LTB-MG{Cor:7}Sum1-Sts'
    'LTB-MG{Cor:8}Sum1-Sts'
    ];
AO.HCM.Fault.HW2PhysicsParams = 1;
AO.HCM.Fault.Physics2HWParams = 1;
AO.HCM.Fault.Units        = 'Hardware';
AO.HCM.Fault.HWUnits      = '';
AO.HCM.Fault.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'VCM'; 'Magnet'; 'COR';};
AO.VCM.DeviceList  = AO.HCM.DeviceList;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = [
    'VCOR1'
    'VCOR2'
    'VCOR3'
    'VCOR4'
    'VCOR5'
    'VCOR6'
    'VCOR7'
    'VCOR8'
    ];

AO.VCM.Monitor.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = [
    'LTB-MG{Cor:1}I:Ps2DCCT1-I'
    'LTB-MG{Cor:2}I:Ps2DCCT1-I'
    'LTB-MG{Cor:3}I:Ps2DCCT1-I'
    'LTB-MG{Cor:4}I:Ps2DCCT1-I'
    'LTB-MG{Cor:5}I:Ps2DCCT1-I'
    'LTB-MG{Cor:6}I:Ps2DCCT1-I'
    'LTB-MG{Cor:7}I:Ps2DCCT1-I'
    'LTB-MG{Cor:8}I:Ps2DCCT1-I'
    ];
AO.VCM.Monitor.HW2PhysicsFcn = @hw2at;
AO.VCM.Monitor.Physics2HWFcn = @at2hw;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
%AO.VCM.Monitor.Real2RawFcn = @real2raw_ltb;
%AO.VCM.Monitor.Raw2RealFcn = @raw2real_ltb;

AO.VCM.Setpoint.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Save/Restore'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = [
    'LTB-MG{Cor:1}I:Sp2-SP'
    'LTB-MG{Cor:2}I:Sp2-SP'
    'LTB-MG{Cor:3}I:Sp2-SP'
    'LTB-MG{Cor:4}I:Sp2-SP'
    'LTB-MG{Cor:5}I:Sp2-SP'
    'LTB-MG{Cor:6}I:Sp2-SP'
    'LTB-MG{Cor:7}I:Sp2-SP'
    'LTB-MG{Cor:8}I:Sp2-SP'
    ];
AO.VCM.Setpoint.HW2PhysicsFcn = @hw2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2hw;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range = [-3 3];
AO.VCM.Setpoint.Tolerance  = .1;
AO.VCM.Setpoint.DeltaRespMat = 1;
%AO.VCM.Setpoint.RampRate = 1;
%AO.VCM.Setpoint.RunFlagFcn = @getrunflag_ltb;

% AO.VCM.RampRate.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Save/Restore';};
% AO.VCM.RampRate.Mode = 'Simulator';
% AO.VCM.RampRate.DataType = 'Scalar';
% AO.VCM.RampRate.ChannelNames = getname_ltb(AO.VCM.FamilyName, 'RampRate');
% AO.VCM.RampRate.HW2PhysicsParams = 1;
% AO.VCM.RampRate.Physics2HWParams = 1;
% AO.VCM.RampRate.Units        = 'Hardware';
% AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.VCM.OnControl.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = [
    'LTB-MG{Cor:1}PsOnOff-Sel'
    'LTB-MG{Cor:2}PsOnOff-Sel'
    'LTB-MG{Cor:3}PsOnOff-Sel'
    'LTB-MG{Cor:4}PsOnOff-Sel'
    'LTB-MG{Cor:5}PsOnOff-Sel'
    'LTB-MG{Cor:6}PsOnOff-Sel'
    'LTB-MG{Cor:7}PsOnOff-Sel'
    'LTB-MG{Cor:8}PsOnOff-Sel'
    ];
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units        = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';
AO.VCM.OnControl.Range = [0 1];
%AO.VCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

% AO.VCM.On.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
% AO.VCM.On.Mode = 'Simulator';
% AO.VCM.On.DataType = 'Scalar';
% AO.VCM.On.ChannelNames = [''}
% AO.VCM.On.HW2PhysicsParams = 1;
% AO.VCM.On.Physics2HWParams = 1;
% AO.VCM.On.Units        = 'Hardware';
% AO.VCM.On.HWUnits      = '';
% AO.VCM.On.PhysicsUnits = '';

% AO.VCM.Reset.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
% AO.VCM.Reset.Mode = 'Simulator';
% AO.VCM.Reset.DataType = 'Scalar';
% AO.VCM.Reset.ChannelNames = [''}
% AO.VCM.Reset.HW2PhysicsParams = 1;
% AO.VCM.Reset.Physics2HWParams = 1;
% AO.VCM.Reset.Units        = 'Hardware';
% AO.VCM.Reset.HWUnits      = '';
% AO.VCM.Reset.PhysicsUnits = '';
% AO.VCM.Reset.Range = [0 1];

AO.VCM.Fault.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.VCM.Fault.Mode = 'Simulator';
AO.VCM.Fault.DataType = 'Scalar';
AO.VCM.Fault.ChannelNames = [
    'LTB-MG{Cor:1}Sum2-Sts'
    'LTB-MG{Cor:2}Sum2-Sts'
    'LTB-MG{Cor:3}Sum2-Sts'
    'LTB-MG{Cor:4}Sum2-Sts'
    'LTB-MG{Cor:5}Sum2-Sts'
    'LTB-MG{Cor:6}Sum2-Sts'
    'LTB-MG{Cor:7}Sum2-Sts'
    'LTB-MG{Cor:8}Sum2-Sts'
    ];
AO.VCM.Fault.HW2PhysicsParams = 1;
AO.VCM.Fault.Physics2HWParams = 1;
AO.VCM.Fault.Units        = 'Hardware';
AO.VCM.Fault.HWUnits      = 'Second';
AO.VCM.Fault.PhysicsUnits = 'Second';



AO.Q.FamilyName = 'Q';
AO.Q.MemberOf   = {'QUAD';  'Magnet';};
AO.Q.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9; 1 10; 1 11; 1 12; 1 13; 1 14; 1 15;];
AO.Q.ElementList = (1:size(AO.Q.DeviceList,1))';
AO.Q.Status = ones(size(AO.Q.DeviceList,1),1);
AO.Q.Position = [];
AO.Q.CommonNames = [
    'Q1 '
    'Q2 '
    'Q3 '
    'Q4 '
    'Q5 '
    'Q6 '
    'Q7 '
    'Q8 '
    'Q9 '
    'Q10'
    'Q11'
    'Q12'
    'Q13'
    'Q14'
    'Q15'
    ];

AO.Q.Monitor.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.Q.Monitor.Mode = 'Simulator';
AO.Q.Monitor.DataType = 'Scalar';
AO.Q.Monitor.ChannelNames = [
    'LTB-MG{Quad:1}I:Ps1DCCT1-I '
    'LTB-MG{Quad:2}I:Ps1DCCT1-I '
    'LTB-MG{Quad:3}I:Ps1DCCT1-I '
    'LTB-MG{Quad:4}I:Ps1DCCT1-I '
    'LTB-MG{Quad:5}I:Ps1DCCT1-I '
    'LTB-MG{Quad:6}I:Ps1DCCT1-I '
    'LTB-MG{Quad:7}I:Ps1DCCT1-I '
    'LTB-MG{Quad:8}I:Ps1DCCT1-I '
    'LTB-MG{Quad:9}I:Ps1DCCT1-I '
    'LTB-MG{Quad:10}I:Ps1DCCT1-I'
    'LTB-MG{Quad:11}I:Ps1DCCT1-I'
    'LTB-MG{Quad:12}I:Ps1DCCT1-I'
    'LTB-MG{Quad:13}I:Ps1DCCT1-I'
    'LTB-MG{Quad:14}I:Ps1DCCT1-I'
    'LTB-MG{Quad:15}I:Ps1DCCT1-I'
    ];
AO.Q.Monitor.HW2PhysicsFcn = @hw2at;
AO.Q.Monitor.Physics2HWFcn = @at2hw;
AO.Q.Monitor.Units        = 'Hardware';
AO.Q.Monitor.HWUnits      = 'Ampere';
AO.Q.Monitor.PhysicsUnits = '1/Meter^2';
%AO.Q.Monitor.Real2RawFcn = @real2raw_ltb;
%AO.Q.Monitor.Raw2RealFcn = @raw2real_ltb;

AO.Q.Setpoint.MemberOf = {'QUAD'; 'Magnet'; 'Save/Restore'; 'Setpoint';};
AO.Q.Setpoint.Mode = 'Simulator';
AO.Q.Setpoint.DataType = 'Scalar';
AO.Q.Setpoint.ChannelNames = [
    'LTB-MG{Quad:1}I:Sp1-SP '
    'LTB-MG{Quad:2}I:Sp1-SP '
    'LTB-MG{Quad:3}I:Sp1-SP '
    'LTB-MG{Quad:4}I:Sp1-SP '
    'LTB-MG{Quad:5}I:Sp1-SP '
    'LTB-MG{Quad:6}I:Sp1-SP '
    'LTB-MG{Quad:7}I:Sp1-SP '
    'LTB-MG{Quad:8}I:Sp1-SP '
    'LTB-MG{Quad:9}I:Sp1-SP '
    'LTB-MG{Quad:10}I:Sp1-SP'
    'LTB-MG{Quad:11}I:Sp1-SP'
    'LTB-MG{Quad:12}I:Sp1-SP'
    'LTB-MG{Quad:13}I:Sp1-SP'
    'LTB-MG{Quad:14}I:Sp1-SP'
    'LTB-MG{Quad:15}I:Sp1-SP'
    ];
AO.Q.Setpoint.HW2PhysicsFcn = @hw2at;
AO.Q.Setpoint.Physics2HWFcn = @at2hw;
AO.Q.Setpoint.Units        = 'Hardware';
AO.Q.Setpoint.HWUnits      = 'Ampere';
AO.Q.Setpoint.PhysicsUnits = '1/Meter^2';
AO.Q.Setpoint.Range = [0 160];
AO.Q.Setpoint.Tolerance = .1;
AO.Q.Setpoint.DeltaRespMat = 1;
%AO.Q.Setpoint.RampRate = .15;
%AO.Q.Setpoint.RunFlagFcn = @getrunflag_ltb;

% AO.Q.RampRate.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Save/Restore';};
% AO.Q.RampRate.Mode = 'Simulator';
% AO.Q.RampRate.DataType = 'Scalar';
% AO.Q.RampRate.ChannelNames = getname_ltb('Q', 'RampRate');
% AO.Q.RampRate.HW2PhysicsFcn = @hw2at;
% AO.Q.RampRate.Physics2HWFcn = @at2hw;
% AO.Q.RampRate.Units        = 'Hardware';
% AO.Q.RampRate.HWUnits      = 'Ampere/Second';
% AO.Q.RampRate.PhysicsUnits = 'Ampere/Second';

AO.Q.OnControl.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.Q.OnControl.Mode = 'Simulator';
AO.Q.OnControl.DataType = 'Scalar';
AO.Q.OnControl.ChannelNames = [
    'LTB-MG{Quad:1}PsOnOff-Sel '
    'LTB-MG{Quad:2}PsOnOff-Sel '
    'LTB-MG{Quad:3}PsOnOff-Sel '
    'LTB-MG{Quad:4}PsOnOff-Sel '
    'LTB-MG{Quad:5}PsOnOff-Sel '
    'LTB-MG{Quad:6}PsOnOff-Sel '
    'LTB-MG{Quad:7}PsOnOff-Sel '
    'LTB-MG{Quad:8}PsOnOff-Sel '
    'LTB-MG{Quad:9}PsOnOff-Sel '
    'LTB-MG{Quad:10}PsOnOff-Sel'
    'LTB-MG{Quad:11}PsOnOff-Sel'
    'LTB-MG{Quad:12}PsOnOff-Sel'
    'LTB-MG{Quad:13}PsOnOff-Sel'
    'LTB-MG{Quad:14}PsOnOff-Sel'
    'LTB-MG{Quad:15}PsOnOff-Sel'
    ];
AO.Q.OnControl.HW2PhysicsParams = 1;
AO.Q.OnControl.Physics2HWParams = 1;
AO.Q.OnControl.Units        = 'Hardware';
AO.Q.OnControl.HWUnits      = '';
AO.Q.OnControl.PhysicsUnits = '';
AO.Q.OnControl.Range = [0 1];

% AO.Q.On.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
% AO.Q.On.Mode = 'Simulator';
% AO.Q.On.DataType = 'Scalar';
% AO.Q.On.ChannelNames = [];
% AO.Q.On.HW2PhysicsParams = 1;
% AO.Q.On.Physics2HWParams = 1;
% AO.Q.On.Units        = 'Hardware';
% AO.Q.On.HWUnits      = '';
% AO.Q.On.PhysicsUnits = '';

% AO.Q.Reset.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
% AO.Q.Reset.Mode = 'Simulator';
% AO.Q.Reset.DataType = 'Scalar';
% AO.Q.Reset.ChannelNames = [];
% AO.Q.Reset.HW2PhysicsParams = 1;
% AO.Q.Reset.Physics2HWParams = 1;
% AO.Q.Reset.Units        = 'Hardware';
% AO.Q.Reset.HWUnits      = '';
% AO.Q.Reset.PhysicsUnits = '';
% AO.Q.Reset.Range = [0 1];

AO.Q.Fault.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.Q.Fault.Mode = 'Simulator';
AO.Q.Fault.DataType = 'Scalar';
AO.Q.Fault.ChannelNames = [
    'LTB-MG{Quad:1}Sum1-Sts '
    'LTB-MG{Quad:2}Sum1-Sts '
    'LTB-MG{Quad:3}Sum1-Sts '
    'LTB-MG{Quad:4}Sum1-Sts '
    'LTB-MG{Quad:5}Sum1-Sts '
    'LTB-MG{Quad:6}Sum1-Sts '
    'LTB-MG{Quad:7}Sum1-Sts '
    'LTB-MG{Quad:8}Sum1-Sts '
    'LTB-MG{Quad:9}Sum1-Sts '
    'LTB-MG{Quad:10}Sum1-Sts'
    'LTB-MG{Quad:11}Sum1-Sts'
    'LTB-MG{Quad:12}Sum1-Sts'
    'LTB-MG{Quad:13}Sum1-Sts'
    'LTB-MG{Quad:14}Sum1-Sts'
    'LTB-MG{Quad:15}Sum1-Sts'
    ];
AO.Q.Fault.HW2PhysicsParams = 1;
AO.Q.Fault.Physics2HWParams = 1;
AO.Q.Fault.Units        = 'Hardware';
AO.Q.Fault.HWUnits      = '';
AO.Q.Fault.PhysicsUnits = '';



AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'BEND'; 'Magnet'};
AO.BEND.DeviceList = [1 1; 1 2; 1 3; 1 4;];
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position = [];
AO.BEND.CommonNames = [
    'BEND1'
    'BEND2'
    'BEND3'
    'BEND4'
    ];

AO.BEND.Monitor.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = [
    'LTB-MG{Bend:1}I:Ps1DCCT1-I'
    'LTB-MG{Bend:2}I:Ps1DCCT1-I'
    'LTB-MG{Bend:3}I:Ps1DCCT1-I'
    'LTB-MG{Bend:4}I:Ps1DCCT1-I'
    ];
AO.BEND.Monitor.HW2PhysicsFcn = @hw2at;
AO.BEND.Monitor.Physics2HWFcn = @at2hw;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';
%AO.BEND.Monitor.Real2RawFcn = @real2raw_ltb;
%AO.BEND.Monitor.Raw2RealFcn = @raw2real_ltb;

AO.BEND.Setpoint.MemberOf = {'BEND'; 'Magnet'; 'Save/Restore'; 'Setpoint';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = [
    'LTB-MG{Bend:1}I:Sp1-SP'
    'LTB-MG{Bend:2}I:Sp1-SP'
    'LTB-MG{Bend:3}I:Sp1-SP'
    'LTB-MG{Bend:4}I:Sp1-SP'
    ];
AO.BEND.Setpoint.HW2PhysicsFcn = @hw2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2hw;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';
AO.BEND.Setpoint.Range = [0 110];
AO.BEND.Setpoint.Tolerance = .1;  % Hardware units
%AO.BEND.Setpoint.RampRate = 1;
%AO.BEND.Setpoint.RunFlagFcn = @getrunflag_ltb;

% AO.BEND.RampRate.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Save/Restore';};
% AO.BEND.RampRate.Mode = 'Simulator';
% AO.BEND.RampRate.DataType = 'Scalar';
% AO.BEND.RampRate.ChannelNames = getname_ltb(AO.BEND.FamilyName, 'RampRate');
% AO.BEND.RampRate.HW2PhysicsParams = 1;
% AO.BEND.RampRate.Physics2HWParams = 1;
% AO.BEND.RampRate.Units        = 'Hardware';
% AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
% AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';

AO.BEND.OnControl.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = [
    'LTB-MG{Bend:1}PsOnOff-Sel'
    'LTB-MG{Bend:2}PsOnOff-Sel'
    'LTB-MG{Bend:3}PsOnOff-Sel'
    'LTB-MG{Bend:4}PsOnOff-Sel'
    ];
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range = [0 1];
AO.BEND.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

% AO.BEND.On.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
% AO.BEND.On.Mode = 'Simulator';
% AO.BEND.On.DataType = 'Scalar';
% AO.BEND.On.ChannelNames = getname_ltb(AO.BEND.FamilyName, 'On');
% AO.BEND.On.HW2PhysicsParams = 1;
% AO.BEND.On.Physics2HWParams = 1;
% AO.BEND.On.Units        = 'Hardware';
% AO.BEND.On.HWUnits      = '';
% AO.BEND.On.PhysicsUnits = '';

% AO.BEND.Reset.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
% AO.BEND.Reset.Mode = 'Simulator';
% AO.BEND.Reset.DataType = 'Scalar';
% AO.BEND.Reset.ChannelNames = getname_ltb(AO.BEND.FamilyName, 'Reset');
% AO.BEND.Reset.HW2PhysicsParams = 1;
% AO.BEND.Reset.Physics2HWParams = 1;
% AO.BEND.Reset.Units        = 'Hardware';
% AO.BEND.Reset.HWUnits      = '';
% AO.BEND.Reset.PhysicsUnits = '';
% AO.BEND.Reset.Range = [0 1];

AO.BEND.Fault.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Fault.Mode = 'Simulator';
AO.BEND.Fault.DataType = 'Scalar';
AO.BEND.Fault.ChannelNames = [
    'LTB-MG{Bend:1}Sum1-Sts'
    'LTB-MG{Bend:2}Sum1-Sts'
    'LTB-MG{Bend:3}Sum1-Sts'
    'LTB-MG{Bend:4}Sum1-Sts'
    ];
AO.BEND.Fault.HW2PhysicsParams = 1;
AO.BEND.Fault.Physics2HWParams = 1;
AO.BEND.Fault.Units        = 'Hardware';
AO.BEND.Fault.HWUnits      = '';
AO.BEND.Fault.PhysicsUnits = '';


% Screen
AO.Screen.FamilyName = 'Screen';
AO.Screen.MemberOf = {'PlotFamily'; 'Screen';};
AO.Screen.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5;];
AO.Screen.ElementList = (1:size(AO.Screen.DeviceList,1))';
AO.Screen.Status = ones(size(AO.Screen.DeviceList,1),1);
AO.Screen.Position = (1:size(AO.Screen.DeviceList,1))';
AO.Screen.CommonNames = [
    'Screen1'
    'Screen2'
    'Screen3'
    'Screen4'
    'Screen5'
    ];

AO.Screen.Monitor.MemberOf = {'PlotFamily';  'Boolean Monitor';};
AO.Screen.Monitor.Mode = 'Simulator';
AO.Screen.Monitor.DataType = 'Scalar';
AO.Screen.Monitor.ChannelNames = [];
AO.Screen.Monitor.HW2PhysicsParams = 1;
AO.Screen.Monitor.Physics2HWParams = 1;
AO.Screen.Monitor.Units        = 'Hardware';
AO.Screen.Monitor.HWUnits      = '';
AO.Screen.Monitor.PhysicsUnits = '';

AO.Screen.Setpoint.MemberOf = {'Screen'; 'Boolean Control';};
AO.Screen.Setpoint.Mode = 'Simulator';
AO.Screen.Setpoint.DataType = 'Scalar';
AO.Screen.Setpoint.ChannelNames = [];
AO.Screen.Setpoint.HW2PhysicsParams = 1;
AO.Screen.Setpoint.Physics2HWParams = 1;
AO.Screen.Setpoint.Units        = 'Hardware';
AO.Screen.Setpoint.HWUnits      = '';
AO.Screen.Setpoint.PhysicsUnits = '';
AO.Screen.Setpoint.Range = [0 1];
AO.Screen.Setpoint.Tolerance = .5 * ones(length(AO.Screen.ElementList), 1);  % Hardware units
%AO.Screen.Setpoint.SpecialFunctionGet = @getScreen;
%AO.Screen.Setpoint.SpecialFunctionSet = @setScreen;

% AO.Screen.InControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
% AO.Screen.InControl.Mode = 'Simulator';
% AO.Screen.InControl.DataType = 'Scalar';
% AO.Screen.InControl.ChannelNames = [];
% AO.Screen.InControl.HW2PhysicsParams = 1;
% AO.Screen.InControl.Physics2HWParams = 1;
% AO.Screen.InControl.Units        = 'Hardware';
% AO.Screen.InControl.HWUnits      = '';
% AO.Screen.InControl.PhysicsUnits = '';
% AO.Screen.InControl.Range = [0 1];
%
% AO.Screen.In.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
% AO.Screen.In.Mode = 'Simulator';
% AO.Screen.In.DataType = 'Scalar';
% AO.Screen.In.ChannelNames = [];
% AO.Screen.In.HW2PhysicsParams = 1;
% AO.Screen.In.Physics2HWParams = 1;
% AO.Screen.In.Units        = 'Hardware';
% AO.Screen.In.HWUnits      = '';
% AO.Screen.In.PhysicsUnits = '';
%
% AO.Screen.Out.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
% AO.Screen.Out.Mode = 'Simulator';
% AO.Screen.Out.DataType = 'Scalar';
% AO.Screen.Out.ChannelNames = [];
% AO.Screen.Out.HW2PhysicsParams = 1;
% AO.Screen.Out.Physics2HWParams = 1;
% AO.Screen.Out.Units        = 'Hardware';
% AO.Screen.Out.HWUnits      = '';
% AO.Screen.Out.PhysicsUnits = '';



% AO.Screen.LampControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
% AO.Screen.LampControl.Mode = 'Simulator';
% AO.Screen.LampControl.DataType = 'Scalar';
% AO.Screen.LampControl.ChannelNames = [];
% AO.Screen.LampControl.HW2PhysicsParams = 1;
% AO.Screen.LampControl.Physics2HWParams = 1;
% AO.Screen.LampControl.Units        = 'Hardware';
% AO.Screen.LampControl.HWUnits      = '';
% AO.Screen.LampControl.PhysicsUnits = '';
% AO.Screen.LampControl.Range = [0 1];
%
% AO.Screen.Lamp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
% AO.Screen.Lamp.Mode = 'Simulator';
% AO.Screen.Lamp.DataType = 'Scalar';
% AO.Screen.Lamp.ChannelNames = getname_ltb(AO.Screen.FamilyName, 'Lamp');
% AO.Screen.Lamp.HW2PhysicsParams = 1;
% AO.Screen.Lamp.Physics2HWParams = 1;
% AO.Screen.Lamp.Units        = 'Hardware';
% AO.Screen.Lamp.HWUnits      = '';
% AO.Screen.Lamp.PhysicsUnits = '';



% Save the AO so that family2dev will work
setao(AO);


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);




% % Solenoid
% AO.SOL.FamilyName = 'SOL';
% AO.SOL.MemberOf = {'Solenoid';};
% AO.SOL.DeviceList = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 2 4];
% AO.SOL.ElementList = (1:size(AO.SOL.DeviceList,1))';
% AO.SOL.Status = ones(size(AO.SOL.DeviceList,1),1);
% AO.SOL.Position = (1:size(AO.SOL.DeviceList,1))';
% AO.SOL.CommonNames = [
%     'GTL SOL1'
%     'GTL SOL2'
%     'GTL SOL3'
%     'LN SOL1 '
%     'LN SOL2 '
%     'LN SOL3 '
%     'LN SOL4 '
%     ];
%
% AO.SOL.Monitor.MemberOf = {'SOL'; 'Monitor'; 'PlotFamily'; 'Save';};
% AO.SOL.Monitor.Mode = 'Simulator';
% AO.SOL.Monitor.DataType = 'Scalar';
% AO.SOL.Monitor.ChannelNames = [
%     'GTL_____SOL1___AM00'	% B
%     'GTL_____SOL2___AM01'	% G
%     'GTL_____SOL3___AM02'	% L
%     'LN______SOL1___AM00'	% B
%     'LN______SOL2___AM01'	% G
%     'LN______SOL3___AM02'	% B
%     'LN______SOL4___AM03'	% B
%     ];
% AO.SOL.Monitor.HW2PhysicsParams = 1;
% AO.SOL.Monitor.Physics2HWParams = 1;
% AO.SOL.Monitor.Units        = 'Hardware';
% AO.SOL.Monitor.HWUnits      = '';
% AO.SOL.Monitor.PhysicsUnits = '';
%
% AO.SOL.Setpoint.MemberOf = {'SOL'; 'Save/Restore'; 'Setpoint'};
% AO.SOL.Setpoint.Mode = 'Simulator';
% AO.SOL.Setpoint.DataType = 'Scalar';
% AO.SOL.Setpoint.ChannelNames = [
%     'GTL_____SOL1___AC00'	% A
%     'GTL_____SOL2___AC01'	% F
%     'GTL_____SOL3___AC02'	% K
%     'LN______SOL1___AC00'	% A
%     'LN______SOL2___AC01'	% F
%     'LN______SOL3___AC02'	% A
%     'LN______SOL4___AC03'	% A
%     ];
% AO.SOL.Setpoint.HW2PhysicsParams = 1;
% AO.SOL.Setpoint.Physics2HWParams = 1;
% AO.SOL.Setpoint.Units        = 'Hardware';
% AO.SOL.Setpoint.HWUnits      = '';
% AO.SOL.Setpoint.PhysicsUnits = '';
% AO.SOL.Setpoint.Range = [
%     0    115
%     0    115
%     0    115
%     0    495
%     0    446
%     0    492
%     0    503
%     ];
% AO.SOL.Setpoint.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units
%
% AO.SOL.OnControl.MemberOf = {'SOL'; 'OnControl'; 'Boolean Control'; 'PlotFamily';};
% AO.SOL.OnControl.Mode = 'Simulator';
% AO.SOL.OnControl.DataType = 'Scalar';
% AO.SOL.OnControl.ChannelNames = [
%     'GTL_____SOL1___BC23'	% C
%     'GTL_____SOL2___BC22'	% H
%     'GTL_____SOL3___BC21'	% M
%     'LN______SOL1___BC23'	% C
%     'LN______SOL2___BC22'	% G
%     'LN______SOL3___BC21'	% C
%     'LN______SOL4___BC20'	% C
%     ];
% AO.SOL.OnControl.HW2PhysicsParams = 1;
% AO.SOL.OnControl.Physics2HWParams = 1;
% AO.SOL.OnControl.Units        = 'Hardware';
% AO.SOL.OnControl.HWUnits      = '';
% AO.SOL.OnControl.PhysicsUnits = '';
% AO.SOL.OnControl.Range = [-Inf Inf];
% AO.SOL.OnControl.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units
%
% AO.SOL.Fault.MemberOf = {'SOL'; 'Fault'; 'Boolean Monitor'; 'PlotFamily';};
% AO.SOL.Fault.Mode = 'Simulator';
% AO.SOL.Fault.DataType = 'Scalar';
% AO.SOL.Fault.ChannelNames = [
%     'GTL_____SOL1___BM15' %	D
%     'GTL_____SOL2___BM13' %	I
%     'GTL_____SOL3___BM11' %	N
%     'LN______SOL1___BM15' %	D
%     'LN______SOL2___BM13' %	H
%     'LN______SOL3___BM11' %	D
%     'LN______SOL4___BM09' %	D
%     ];
% AO.SOL.Fault.HW2PhysicsParams = 1;
% AO.SOL.Fault.Physics2HWParams = 1;
% AO.SOL.Fault.Units        = 'Hardware';
% AO.SOL.Fault.HWUnits      = '';
% AO.SOL.Fault.PhysicsUnits = '';
%
% AO.SOL.On.MemberOf = {'SOL'; 'On'; 'Boolean Monitor'; 'PlotFamily';};
% AO.SOL.On.Mode = 'Simulator';
% AO.SOL.On.DataType = 'Scalar';
% AO.SOL.On.ChannelNames = [
%     'GTL_____SOL1___BM14' %	E
%     'GTL_____SOL2___BM12' %	J
%     'GTL_____SOL3___BM10' %	O
%     'LN______SOL1___BM14' %	E
%     'LN______SOL2___BM12' %	H
%     'LN______SOL3___BM10' %	E
%     'LN______SOL4___BM08' %	E
%     ];
% AO.SOL.On.HW2PhysicsParams = 1;
% AO.SOL.On.Physics2HWParams = 1;
% AO.SOL.On.Units        = 'Hardware';
% AO.SOL.On.HWUnits      = '';
% AO.SOL.On.PhysicsUnits = '';
%
% % 'LN______SOLIN1_BC19'	% LN SOL MOD1 INTLK
% % 'LN______SOLIN2_BC18'	% LN SOL MOD2 INTLK
%
%
%
% AO.ICT.FamilyName = 'ICT';
% AO.ICT.MemberOf = {'ICT';};
% AO.ICT.DeviceList = [1 1;1 2];
% AO.ICT.ElementList = [1;2];
% AO.ICT.Status = [1;1;];
% AO.ICT.Position = [0;35];  % ???
%
% AO.ICT.MemberOf = {'ICT'; 'Monitor';};
% AO.ICT.Monitor.Mode = 'Simulator';
% AO.ICT.Monitor.DataType = 'Scalar';
% AO.ICT.Monitor.ChannelNames = [''; ''];
% AO.ICT.Monitor.HW2PhysicsParams = 1;
% AO.ICT.Monitor.Physics2HWParams = 1;
% AO.ICT.Monitor.Units        = 'Hardware';
% AO.ICT.Monitor.HWUnits      = 'mAmps';
% AO.ICT.Monitor.PhysicsUnits = 'mAmps';
% %AO.ICT.Monitor.SpecialFunctionGet = 'getict_ltb';


% % Sub-Harmonic Buncher
% AO.SHB.FamilyName = 'SHB';
% AO.SHB.MemberOf = {'SHB'; 'Subharmonic Buncher';};
% AO.SHB.DeviceList = [1 1; 1 2;];
% AO.SHB.ElementList = (1:size(AO.SHB.DeviceList,1))';
% AO.SHB.Status = ones(size(AO.SHB.DeviceList,1),1);
% AO.SHB.Position = (1:size(AO.SHB.DeviceList,1))';
% AO.SHB.CommonNames = [
%     'GTL 125 MHz SHB1'
%     'GTL 500 MHz SHB2'
%     ];
%
% AO.SHB.HV.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'High Voltage'; 'Monitor'; 'PlotFamily'; 'Save';};
% AO.SHB.HV.Mode = 'Simulator';
% AO.SHB.HV.DataType = 'Scalar';
% AO.SHB.HV.ChannelNames = [
%     'GTL_____SHB1_HVAM01' % 125MHZ HV MON.
%     'GTL_____SHB2_HVAM01' % 500MHZ HV MON.
%     ];
% AO.SHB.HV.HW2PhysicsParams = 1;
% AO.SHB.HV.Physics2HWParams = 1;
% AO.SHB.HV.Units        = 'Hardware';
% AO.SHB.HV.HWUnits      = '';
% AO.SHB.HV.PhysicsUnits = '';
%
% AO.SHB.HVControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'High Voltage'; 'Save/Restore'; 'Setpoint';};
% AO.SHB.HVControl.Mode = 'Simulator';
% AO.SHB.HVControl.DataType = 'Scalar';
% AO.SHB.HVControl.ChannelNames = [
%     'GTL_____SHB1_HVAC01' % 125MHZ HV REF.
%     'GTL_____SHB2_HVAC01' % 500MHZ HV REF.
%     ];
% AO.SHB.HVControl.HW2PhysicsParams = 1;
% AO.SHB.HVControl.Physics2HWParams = 1;
% AO.SHB.HVControl.Units        = 'Hardware';
% AO.SHB.HVControl.HWUnits      = '';
% AO.SHB.HVControl.PhysicsUnits = '';
% AO.SHB.HVControl.Range = [-Inf Inf];
% AO.SHB.HVControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units
%
% AO.SHB.Phase.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Phase'; 'Monitor'; 'PlotFamily'; 'Save';};
% AO.SHB.Phase.Mode = 'Simulator';
% AO.SHB.Phase.DataType = 'Scalar';
% AO.SHB.Phase.ChannelNames = [
%     'GTL_____SHB1_PHAM00' % PHASE MONITOR
%     'GTL_____SHB2_PHAM00' % PHASE MONITOR
%     ];
% AO.SHB.Phase.HW2PhysicsParams = 1;
% AO.SHB.Phase.Physics2HWParams = 1;
% AO.SHB.Phase.Units        = 'Hardware';
% AO.SHB.Phase.HWUnits      = '';
% AO.SHB.Phase.PhysicsUnits = '';
%
% AO.SHB.PhaseControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Phase'; 'Save/Restore'; 'Setpoint';};
% AO.SHB.PhaseControl.Mode = 'Simulator';
% AO.SHB.PhaseControl.DataType = 'Scalar';
% AO.SHB.PhaseControl.ChannelNames = [
%     'GTL_____SHB1_PHAC00' % PHASE REFERENCE
%     'GTL_____SHB2_PHAC00' % PHASE REFERENCE
%     ];
% AO.SHB.PhaseControl.HW2PhysicsParams = 1;
% AO.SHB.PhaseControl.Physics2HWParams = 1;
% AO.SHB.PhaseControl.Units        = 'Hardware';
% AO.SHB.PhaseControl.HWUnits      = '';
% AO.SHB.PhaseControl.PhysicsUnits = '';
% AO.SHB.PhaseControl.Range = [-Inf Inf];
% AO.SHB.PhaseControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units
%
% AO.SHB.Fault.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Fault'; 'Boolean Monitor';};
% AO.SHB.Fault.Mode = 'Simulator';
% AO.SHB.Fault.DataType = 'Scalar';
% AO.SHB.Fault.ChannelNames = [
%     'GTL_____SHB1_HVBM19' % SHB1 HV Fault
%     'GTL_____SHB2_HVBM19' % SHB2 HV Fault
%     ];
% AO.SHB.Fault.HW2PhysicsParams = 1;
% AO.SHB.Fault.Physics2HWParams = 1;
% AO.SHB.Fault.Units        = 'Hardware';
% AO.SHB.Fault.HWUnits      = '';
% AO.SHB.Fault.PhysicsUnits = '';
%
% AO.SHB.OnControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'OnControl'; 'Boolean Control';};
% AO.SHB.OnControl.Mode = 'Simulator';
% AO.SHB.OnControl.DataType = 'Scalar';
% AO.SHB.OnControl.ChannelNames = [
%     'GTL_____SHB1_HVBC23' % HV ON/OFF
%     'GTL_____SHB2_HVBC23' % HV ON/OFF
%     ];
% AO.SHB.OnControl.HW2PhysicsParams = 1;
% AO.SHB.OnControl.Physics2HWParams = 1;
% AO.SHB.OnControl.Units        = 'Hardware';
% AO.SHB.OnControl.HWUnits      = '';
% AO.SHB.OnControl.PhysicsUnits = '';
% AO.SHB.OnControl.Range = [0 1];
% AO.SHB.OnControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units
%
% AO.SHB.On.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'On'; 'Boolean Monitor';};
% AO.SHB.On.Mode = 'Simulator';
% AO.SHB.On.DataType = 'Scalar';
% AO.SHB.On.ChannelNames = [
%     'GTL_____SHB1_HVBM18' % SHB1 HV ON
%     'GTL_____SHB2_HVBM18' % SHB2 HV ON'
%     ];
% AO.SHB.On.HW2PhysicsParams = 1;
% AO.SHB.On.Physics2HWParams = 1;
% AO.SHB.On.Units        = 'Hardware';
% AO.SHB.On.HWUnits      = '';
% AO.SHB.On.PhysicsUnits = '';
%
% AO.SHB.PulsingControl.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingControl'; 'Boolean Control';};
% AO.SHB.PulsingControl.Mode = 'Simulator';
% AO.SHB.PulsingControl.DataType = 'Scalar';
% AO.SHB.PulsingControl.ChannelNames = [
%     'GTL_____SHB1_PHBC22' % PULSING ON/OFF
%     'GTL_____SHB2_PHBC22' % PULSING ON/OFF
%     ];
% AO.SHB.PulsingControl.HW2PhysicsParams = 1;
% AO.SHB.PulsingControl.Physics2HWParams = 1;
% AO.SHB.PulsingControl.Units        = 'Hardware';
% AO.SHB.PulsingControl.HWUnits      = '';
% AO.SHB.PulsingControl.PhysicsUnits = '';
% AO.SHB.PulsingControl.Range = [0 1];
% AO.SHB.PulsingControl.Tolerance = ones(length(AO.SHB.ElementList), 1);  % Hardware units
%
% AO.SHB.PulsingOn.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingOn'; 'Boolean Monitor';};
% AO.SHB.PulsingOn.Mode = 'Simulator';
% AO.SHB.PulsingOn.DataType = 'Scalar';
% AO.SHB.PulsingOn.ChannelNames = [
%     'GTL_____SHB1_PHBM16' % SHB1 PULSING ON
%     'GTL_____SHB2_PHBM16' % SHB2 PULSING ON
%     ];
% AO.SHB.PulsingOn.HW2PhysicsParams = 1;
% AO.SHB.PulsingOn.Physics2HWParams = 1;
% AO.SHB.PulsingOn.Units        = 'Hardware';
% AO.SHB.PulsingOn.HWUnits      = '';
% AO.SHB.PulsingOn.PhysicsUnits = '';
%
% AO.SHB.PulsingFault.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PulsingFault'; 'Boolean Monitor';};
% AO.SHB.PulsingFault.Mode = 'Simulator';
% AO.SHB.PulsingFault.DataType = 'Scalar';
% AO.SHB.PulsingFault.ChannelNames = [
%     'GTL_____SHB1_PHBM17' % SHB1 PULSING Fault
%     'GTL_____SHB2_PHBM17' % SHB2 PULSING Fault
%     ];
% AO.SHB.PulsingFault.HW2PhysicsParams = 1;
% AO.SHB.PulsingFault.Physics2HWParams = 1;
% AO.SHB.PulsingFault.Units        = 'Hardware';
% AO.SHB.PulsingFault.HWUnits      = '';
% AO.SHB.PulsingFault.PhysicsUnits = '';
%
% AO.SHB.DriveAmp.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'DriveAmp'; 'Boolean Monitor';};
% AO.SHB.DriveAmp.Mode = 'Simulator';
% AO.SHB.DriveAmp.DataType = 'Scalar';
% AO.SHB.DriveAmp.ChannelNames = [
%     'GTL_____SHB1_HVBM06' % SHB1 DRV AMP ON
%     'GTL_____SHB2_HVBM06' % SHB2 DRV AMP ON
%     ];
% AO.SHB.DriveAmp.HW2PhysicsParams = 1;
% AO.SHB.DriveAmp.Physics2HWParams = 1;
% AO.SHB.DriveAmp.Units        = 'Hardware';
% AO.SHB.DriveAmp.HWUnits      = '';
% AO.SHB.DriveAmp.PhysicsUnits = '';
%
% AO.SHB.Local.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Local'; 'Boolean Monitor';};
% AO.SHB.Local.Mode = 'Simulator';
% AO.SHB.Local.DataType = 'Scalar';
% AO.SHB.Local.ChannelNames = [
%     'GTL_____SHB1_HVBM05' % SHB1 IN LOCAL
%     'GTL_____SHB2_HVBM05' % SHB2 IN LOCAL
%     ];
% AO.SHB.Local.HW2PhysicsParams = 1;
% AO.SHB.Local.Physics2HWParams = 1;
% AO.SHB.Local.Units        = 'Hardware';
% AO.SHB.Local.HWUnits      = '';
% AO.SHB.Local.PhysicsUnits = '';
%
% AO.SHB.LocalPhase.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'LocalPhase'; 'Boolean Monitor';};
% AO.SHB.LocalPhase.Mode = 'Simulator';
% AO.SHB.LocalPhase.DataType = 'Scalar';
% AO.SHB.LocalPhase.ChannelNames = [
%     'GTL_____SHB1_HVBM02' % SHB1 PH IN LOCAL
%     'GTL_____SHB2_HVBM02' % SHB2 PH IN LOCAL
%     ];
% AO.SHB.LocalPhase.HW2PhysicsParams = 1;
% AO.SHB.LocalPhase.Physics2HWParams = 1;
% AO.SHB.LocalPhase.Units        = 'Hardware';
% AO.SHB.LocalPhase.HWUnits      = '';
% AO.SHB.LocalPhase.PhysicsUnits = '';
%
% AO.SHB.Comp.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Comp'; 'Boolean Monitor';};
% AO.SHB.Comp.Mode = 'Simulator';
% AO.SHB.Comp.DataType = 'Scalar';
% AO.SHB.Comp.ChannelNames = [
%     'GTL_____SHB1_HVBM03' % SHB1 PH IN COMP
%     'GTL_____SHB2_HVBM03' % SHB2 PH IN COMP
%
%     ];
% AO.SHB.Comp.HW2PhysicsParams = 1;
% AO.SHB.Comp.Physics2HWParams = 1;
% AO.SHB.Comp.Units        = 'Hardware';
% AO.SHB.Comp.HWUnits      = '';
% AO.SHB.Comp.PhysicsUnits = '';
%
% AO.SHB.Computer.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Computer'; 'Boolean Monitor';};
% AO.SHB.Computer.Mode = 'Simulator';
% AO.SHB.Computer.DataType = 'Scalar';
% AO.SHB.Computer.ChannelNames = [
%     'GTL_____SHB1_HVBM04' % SHB1 IN COMPUTER
%     'GTL_____SHB2_HVBM04' % SHB2 IN COMPUTER
%     ];
% AO.SHB.Computer.HW2PhysicsParams = 1;
% AO.SHB.Computer.Physics2HWParams = 1;
% AO.SHB.Computer.Units        = 'Hardware';
% AO.SHB.Computer.HWUnits      = '';
% AO.SHB.Computer.PhysicsUnits = '';
%
% AO.SHB.ExtInterlock1.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock1'; 'Boolean Monitor';};
% AO.SHB.ExtInterlock1.Mode = 'Simulator';
% AO.SHB.ExtInterlock1.DataType = 'Scalar';
% AO.SHB.ExtInterlock1.ChannelNames = [
%     'GTL_____SHB1_HVBM09' % SHB1 EXT INTRLK 1
%     'GTL_____SHB2_HVBM09' % SHB2 EXT INTRLK 1
%     ];
% AO.SHB.ExtInterlock1.HW2PhysicsParams = 1;
% AO.SHB.ExtInterlock1.Physics2HWParams = 1;
% AO.SHB.ExtInterlock1.Units        = 'Hardware';
% AO.SHB.ExtInterlock1.HWUnits      = '';
% AO.SHB.ExtInterlock1.PhysicsUnits = '';
%
% AO.SHB.ExtInterlock2.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock2'; 'Boolean Monitor';};
% AO.SHB.ExtInterlock2.Mode = 'Simulator';
% AO.SHB.ExtInterlock2.DataType = 'Scalar';
% AO.SHB.ExtInterlock2.ChannelNames = [
%     'GTL_____SHB1_HVBM08' % SHB1 EXT INTRLK 2
%     'GTL_____SHB2_HVBM08' % SHB2 EXT INTRLK 2
%     ];
% AO.SHB.ExtInterlock2.HW2PhysicsParams = 1;
% AO.SHB.ExtInterlock2.Physics2HWParams = 1;
% AO.SHB.ExtInterlock2.Units        = 'Hardware';
% AO.SHB.ExtInterlock2.HWUnits      = '';
% AO.SHB.ExtInterlock2.PhysicsUnits = '';
%
% AO.SHB.ExtInterlock3.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'ExtInterlock3'; 'Boolean Monitor';};
% AO.SHB.ExtInterlock3.Mode = 'Simulator';
% AO.SHB.ExtInterlock3.DataType = 'Scalar';
% AO.SHB.ExtInterlock3.ChannelNames = [
%     'GTL_____SHB1_HVBM07' % SHB1 EXT INTRLK 3
%     'GTL_____SHB2_HVBM07' % SHB2 EXT INTRLK 3
%     ];
% AO.SHB.ExtInterlock3.HW2PhysicsParams = 1;
% AO.SHB.ExtInterlock3.Physics2HWParams = 1;
% AO.SHB.ExtInterlock3.Units        = 'Hardware';
% AO.SHB.ExtInterlock3.HWUnits      = '';
% AO.SHB.ExtInterlock3.PhysicsUnits = '';
%
% AO.SHB.FilamentTimeOut.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'FilamentTimeOut'; 'Boolean Monitor';};
% AO.SHB.FilamentTimeOut.Mode = 'Simulator';
% AO.SHB.FilamentTimeOut.DataType = 'Scalar';
% AO.SHB.FilamentTimeOut.ChannelNames = [
%     'GTL_____SHB1_HVBM10' % SHB1 FIL TIME OUT
%     'GTL_____SHB2_HVBM10' % SHB2 FIL TIME OUT
%     ];
% AO.SHB.FilamentTimeOut.HW2PhysicsParams = 1;
% AO.SHB.FilamentTimeOut.Physics2HWParams = 1;
% AO.SHB.FilamentTimeOut.Units        = 'Hardware';
% AO.SHB.FilamentTimeOut.HWUnits      = '';
% AO.SHB.FilamentTimeOut.PhysicsUnits = '';
%
% AO.SHB.PlugInterlock.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'PlugInterlock'; 'Boolean Monitor';};
% AO.SHB.PlugInterlock.Mode = 'Simulator';
% AO.SHB.PlugInterlock.DataType = 'Scalar';
% AO.SHB.PlugInterlock.ChannelNames = [
%     'GTL_____SHB1_HVBM11' % SHB1 PLUG INTRLK
%     'GTL_____SHB2_HVBM11' % SHB2 PLUG INTRLK
%     ];
% AO.SHB.PlugInterlock.HW2PhysicsParams = 1;
% AO.SHB.PlugInterlock.Physics2HWParams = 1;
% AO.SHB.PlugInterlock.Units        = 'Hardware';
% AO.SHB.PlugInterlock.HWUnits      = '';
% AO.SHB.PlugInterlock.PhysicsUnits = '';
%
% AO.SHB.Thermal.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'Thermal'; 'Boolean Monitor';};
% AO.SHB.Thermal.Mode = 'Simulator';
% AO.SHB.Thermal.DataType = 'Scalar';
% AO.SHB.Thermal.ChannelNames = [
%     'GTL_____SHB1_HVBM12' % SHB1 THERMAL
%     'GTL_____SHB2_HVBM12' % SHB2 THERMAL
%     ];
% AO.SHB.Thermal.HW2PhysicsParams = 1;
% AO.SHB.Thermal.Physics2HWParams = 1;
% AO.SHB.Thermal.Units        = 'Hardware';
% AO.SHB.Thermal.HWUnits      = '';
% AO.SHB.Thermal.PhysicsUnits = '';
%
% AO.SHB.AirFlow.MemberOf = {'SHB'; 'Subharmonic Buncher'; 'AirFlow'; 'Boolean Monitor';};
% AO.SHB.AirFlow.Mode = 'Simulator';
% AO.SHB.AirFlow.DataType = 'Scalar';
% AO.SHB.AirFlow.ChannelNames = [
%     'GTL_____SHB1_HVBM13' % SHB1 AIR FLOW
%     'GTL_____SHB2_HVBM13' % SHB2 AIR FLOW
%     ];
% AO.SHB.AirFlow.HW2PhysicsParams = 1;
% AO.SHB.AirFlow.Physics2HWParams = 1;
% AO.SHB.AirFlow.Units        = 'Hardware';
% AO.SHB.AirFlow.HWUnits      = '';
% AO.SHB.AirFlow.PhysicsUnits = '';
%
