function AO = buildmml_sextupole_harmonic(AO, Field)

AO.SQSHF.FamilyName = 'SQSHF';
AO.SQSHF.DeviceList  = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 4 1; 4 2; 5 1; 5 2; 6 1; 6 2; 7 1; 7 2; 8 1; 8 2; 9 1; 9 2; 10 1; 10 2; 11 1; 11 2; 12 1; 12 2; ];
AO.SQSHF.BaseName = getname_local('Caen');
AO.SQSHF.DeviceType = {
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    'Caen SY3662'
    };
AO.SQSHF = buildmmlcaen(AO.SQSHF, 4);
AO.SQSHF.MemberOf    = {'SQSHF'; 'Magnet'; 'SkewQuad';};
AO.SQSHF.ElementList = (1:size(AO.SQSHF.DeviceList,1))';
AO.SQSHF.Status      = ones(size(AO.SQSHF.DeviceList,1),1);

% Broken?
% i = findrowindex([2 1], AO.SQSHF.DeviceList);
% AO.SQSHF.Status(i)=0;
% disp('   Set Status for SQSHF(2.1) to zero');
% i = findrowindex([2 2], AO.SQSHF.DeviceList);
% AO.SQSHF.Status(i)=0;
% disp('   Set Status for SQSHF(2.2) to zero');

AO.SQSHF.Position = (1:24)';   % ???

AO.SQSHF.Monitor.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'Monitor'; 'PlotFamily'; 'Save';};
AO.SQSHF.Monitor = rmfield(AO.SQSHF.Monitor, 'HW2PhysicsParams');
AO.SQSHF.Monitor = rmfield(AO.SQSHF.Monitor, 'Physics2HWParams');
AO.SQSHF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SQSHF.Monitor.Physics2HWFcn = @k2amp;
AO.SQSHF.Monitor.Units        = 'Hardware';
AO.SQSHF.Monitor.HWUnits      = 'Ampere';
AO.SQSHF.Monitor.PhysicsUnits = '1/Meter^2';

AO.SQSHF.Setpoint.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'Save/Restore'; 'Setpoint'};
AO.SQSHF.Setpoint = rmfield(AO.SQSHF.Setpoint, 'HW2PhysicsParams');
AO.SQSHF.Setpoint = rmfield(AO.SQSHF.Setpoint, 'Physics2HWParams');
AO.SQSHF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SQSHF.Setpoint.Physics2HWFcn = @k2amp;
AO.SQSHF.Setpoint.Units        = 'Hardware';
AO.SQSHF.Setpoint.HWUnits      = 'Ampere';
AO.SQSHF.Setpoint.PhysicsUnits = '1/Meter^2';
AO.SQSHF.Setpoint.Range = [-50 50];
AO.SQSHF.Setpoint.Tolerance  = .1 * ones(length(AO.SQSHF.ElementList), 1);  % Hardware units
AO.SQSHF.Setpoint.DeltaRespMat = 1;

AO.SQSHF.RampRate.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'Ramprate'; 'PlotFamily'; 'Save';};

AO.SQSHF.OnControl.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'PlotFamily'; 'Boolean Control';};
AO.SQSHF.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SQSHF.On.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'PlotFamily'; 'Boolean Monitor';};

AO.SQSHF.Reset.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'PlotFamily'; 'Boolean Control';};

AO.SQSHF.Ready.MemberOf = {'SQSHF'; 'Magnet'; 'SkewQuad'; 'PlotFamily'; 'Boolean Monitor';};
AO.SQSHF.Ready.Mode = 'Simulator';
AO.SQSHF.Ready.DataType = 'Scalar';
AO.SQSHF.Ready.ChannelNames = [];
AO.SQSHF.Ready.HW2PhysicsParams = 1;
AO.SQSHF.Ready.Physics2HWParams = 1;
AO.SQSHF.Ready.Units        = 'Hardware';
AO.SQSHF.Ready.HWUnits      = 'Second';
AO.SQSHF.Ready.PhysicsUnits = 'Second';


AO.SQSHF.CommonNames            = getname_local('CommonName');
%AO.SQSHF.Setpoint.ChannelNames  = getname_local('Setpoint');
%AO.SQSHF.Monitor.ChannelNames   = getname_local('Monitor');
%AO.SQSHF.RampRate.ChannelNames  = getname_local('RampRate');
%AO.SQSHF.OnControl.ChannelNames = getname_local('OnControl');
%AO.SQSHF.On.ChannelNames        = getname_local('On');
AO.SQSHF.Ready.ChannelNames     = getname_local('Ready');     % Not a direct channel conversion (Invert Caen General Fault)
%AO.SQSHF.Reset.ChannelNames     = getname_local('Reset');


% Change to mat since not all programs are setup for cells
%AO.SQSHF.CommonNames = cell2mat(AO.SQSHF.CommonNames);
AO.SQSHF.Setpoint.ChannelNames=cell2mat(AO.SQSHF.Setpoint.ChannelNames);
AO.SQSHF.Monitor.ChannelNames =cell2mat(AO.SQSHF.Monitor.ChannelNames);



function PV = getname_local(Field)

BasicName = [
'SR01C___SQSHF1_'  % Gets removed later
'SR01C___SQSHD1_'
'SR01C___SQSHD2_'
'SR01C___SQSHF2_'
'SR02C___SQSHF1_'
'SR02C___SQSHD1_'
'SR02C___SQSHD2_'
'SR02C___SQSHF2_'
'SR03C___SQSHF1_'
'SR03C___SQSHD1_'
'SR03C___SQSHD2_'
'SR03C___SQSHF2_'
'SR04C___SQSHF1_'
'SR04C___SQSHD1_'
'SR04C___SQSHD2_'
'SR04C___SQSHF2_'
'SR05C___SQSHF1_'
'SR05C___SQSHD1_'
'SR05C___SQSHD2_'
'SR05C___SQSHF2_'
'SR06C___SQSHF1_'
'SR06C___SQSHD1_'
'SR06C___SQSHD2_'
'SR06C___SQSHF2_'
'SR07C___SQSHF1_'
'SR07C___SQSHD1_'
'SR07C___SQSHD2_'
'SR07C___SQSHF2_'
'SR08C___SQSHF1_'
'SR08C___SQSHD1_'
'SR08C___SQSHD2_'
'SR08C___SQSHF2_'
'SR09C___SQSHF1_'
'SR09C___SQSHD1_'
'SR09C___SQSHD2_'
'SR09C___SQSHF2_'
'SR10C___SQSHF1_'
'SR10C___SQSHD1_'
'SR10C___SQSHD2_'
'SR10C___SQSHF2_'
'SR11C___SQSHF1_'
'SR11C___SQSHD1_'
'SR11C___SQSHD2_'
'SR11C___SQSHF2_'
'SR12C___SQSHF1_'
'SR12C___SQSHD1_'
'SR12C___SQSHD2_'
'SR12C___SQSHF2_'
];

if strcmpi(Field,'Caen')
    BasicName(:,6) = ':';
    BasicName(:,[7 8 end]) = [];
    for i = 1:size(BasicName,1)
        PV{i,1} = BasicName(i,:);
    end
elseif strcmpi(Field,'CommonName')
    for i = 1:size(BasicName,1)
        if str2num(BasicName(i,3:4)) < 10
            PV{i,1} = [BasicName(i,9:13), '(',BasicName(i,4),   ',', BasicName(i,14), ')'];
        else
            PV{i,:} = [BasicName(i,9:13), '(',BasicName(i,3:4), ',', BasicName(i,14), ')'];
        end
    end
elseif strcmpi(Field,'Setpoint')
    %AC = [0 1 2 3];
    AC = [0 0 0 0];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('AC%02d',AC(mod(i-1,4)+1))];
    end
elseif strcmpi(Field,'RampRate')
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) 'AC30'];
    end
elseif strcmpi(Field,'Monitor')
    %AM = [0 1 2 3];
    AM = [0 0 0 0];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('AM%02d',AM(mod(i-1,4)+1))];
    end
elseif strcmpi(Field,'OnControl')
    %BC = [16 18 20 22];
    BC = [0 0 0 0];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('BC%02d',BC(mod(i-1,4)+1))];
    end
elseif strcmpi(Field,'Reset')
    %BC = [17 19 21 23];
    BC = [1 1 1 1];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('BC%02d',BC(mod(i-1,4)+1))];   % No room for the R
    end
elseif strcmpi(Field,'On')
    %BM = [2 5 8 11];
    BM = [0 0 0 0];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('BM%02d',BM(mod(i-1,4)+1))];
    end
elseif strcmpi(Field,'Ready')
    %BM = [1 4 7 10];
    BM = [1 1 1 1];
    for i = 1:size(BasicName,1)
        PV(i,:) = [BasicName(i,:) sprintf('BM%02d',BM(mod(i-1,4)+1))];
    end
end


% Power supplies
% 1	SQSHD1
% 1	SQSHF2
% 2-11	SQSHF1
% 2-11	SQSHF2
% 12	SQSHF1
% 12	SQSHD2
iPS = [];
for s = 2:11
    iPS = [iPS [1 4]+4*(s-1)];
end
iPS = [2 4 iPS 45 47];
PV = PV(iPS,:);


