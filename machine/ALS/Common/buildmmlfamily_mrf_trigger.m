function AO = buildmmlfamily_mrf_trigger

%  1-39 -> No changes
% 40-47 -> Diagnostic triggers

AO.FamilyName = 'Trigger';
AO.MemberOf = {'Timing';'Trigger';};
AO.DeviceList = [];
AO.ElementList = [];
AO.Status = ones(size(AO.DeviceList,1),1);
AO.Position = [0 1 2 3 4]';
AO.CommonNames = {
    'BR Magnet'
    'BR RF'
    'BR RF Tuner Servo Inhibit'
    'BR RF Scope'
    'Peaking Strip (GC)'
    'LN Modulator Scope'
    'GTB CCD'
    'BR CCD'
    'User Gate'
    'BR Injection Field Monitor'
    'GTL Buncher Scope'
    'Wall Current Monitor'   % / TWE Scope'
    'Linac RF Master'
    'BR Injection Field (GC)'
    'Gun Gate Monitor'
    'BR Injection Kicker Scope'
    'BR Injection Kicker'
    'LTB ICT Scope'
    'BR ICT Scope'
    'Gun On'
    'Gun Off'
    'BR Extraction Field (GC)'
    'BR Bump'
    'BTS CCD'
    'BTS ICT Scope'
    'BR Bump Scope'
    'BR Extraction Kicker Scope'
    'BR Extraction Kicker'
    'BR Extraction Field Monitor'
    'BR Septa Scope'
    'BR Thin Septum'
    'BR Thick Septum'
    'Target Bucket Monitor'
    'SR Bump Scope'
    'SR Bump'
    'SR Septa Scope'
    'SR Thin Septum'
    'SR Thick Septum'
    'PS Ready'
    
    'DOE Kicker'
    'LFB'
    'TFB Y'
    'TFB X'
    'Beam Loss Monitor'
    
    'LI11 Prog1 Mon'
    'LI11 Prog2 Mon'
    'B0215 Prog1 Mon'
    'B0215 Prog2 Mon'
    'S0817 Prog1 Mon'
    'S0817 Prog2 Mon'
    'S0123 Prog1 Mon'
    'S0123 Prog2 Mon'
    };

%     'BR Magnet Trigger'
%     'BR RF Trigger'
%     'BR RF Tuner Servo Inhibit'
%     'BR RF Scope'
%     'Peaking Strip Trigger (GC)'
%     'LN Modulator Scope'
%     'GTB CCD Trigger'
%     'BR CCD Trigger'
%     'User Gating Trigger'
%     'BR Injection Field Monitor'
%     'GTL Buncher Scope'
%     'Wall Current / TWE Scope'
%     'Linac RF Master Trigger'
%     'BR Injection Field (GC)'
%     'Gun Gate Monitor'
%     'BR Injection Kicker Scope'
%     'BR Injection Kicker Trigger'
%     'LTB ICT Scope'
%     'BR ICT Scope'
%     'Gun On'
%     'Gun Off'
%     'BR Extraction Field (GC)'
%     'BR Bump Trigger'
%     'BTS CCD Trigger'
%     'BTS ICT Scope'
%     'BR Bump Scope'
%     'BR Extraction Kicker Scope'
%     'BR Extraction Kicker Trigger'
%     'BR Extraction Field Monitor'
%     'BR Septa Scope'
%     'BR Thin Septum Trigger'
%     'BR Thick Septum Trigger'
%     'Target Bucket Monitor'
%     'SR Bump Scope'
%     'SR Bump Trigger'
%     'SR Septa Scope'
%     'SR Thin Septum Trigger'
%     'SR Thick Septum Trigger'
%     'PS Ready'


AO.EvtNumber = [
    10
    10
    10
    10
    10
    12
    14
    15
    16
    18
    20
    22
    24
    26
    28
    30
    30
    32
    34
    36
    37
    38
    40
    42
    44
    46
    48
    48
    50
    52
    52
    54
    56
    58
    60
    62
    64
    66
%    68  % What crate????
%    70  % What crate????
    100
    
    68
    68
    68
    68
    68
    
    NaN
    NaN
    NaN
    NaN
    NaN
    NaN
    NaN
    NaN
    ];

AO.Crate = {
    'B0215'
    'LI11'
    'LI11'
    'LI11'
    'LI11'
    'LI11'
    'S0817'
    'B0215'
    'S0123'
    'S0817'
    'LI11'
    'LI11'
    'LI11'
    'LI11'
    'LI11'
    'S0817'
    'S0817'
    'B0215'
    'B0215'
    'LI11'
    'LI11'
    'LI11'
    'B0215'
    'B0215'
    'B0215'
    'B0215'
    'B0215'
    'B0215'
    'B0215'
    'B0215'
    'LI11'
    'LI11'
    'LI11'
    'S0123'
    'S0123'
    'S0123'
    'S0123'
    'S0123'
    'LI11'

    'S0220'
    'S0220'
    'S0220'
    'S0220'
    'S0220'

    'LI11'
    'LI11'
    'B0215'
    'B0215'
    'S0817'
    'S0817'
    'S0123'
    'S0123'
    };

AO.EVR = [
    1
    1
    1
    1
    2
    1
    1
    1
    1
    1
    1
    1
    2
    2
    2
    1
    1
    1
    1
    1
    1
    2
    1
    1
    1
    1
    1
    1
    1
    1
    1
    1
    2
    1
    1
    1
    1
    1
    2

    1
    1
    1
    1
    1

    1
    2
    1
    1
    1
    1
    1
    1
    ];

% PulseGenerator
AO.PG = [
    2
    4
    3   % was 5
   10
    3
    9
    3
    4
    6
    4
   11
   12
    0
    1
    4
    2
    0
    6
    7
    0
    1
    2
    0
    5
    8
    9
   10
    1
    3
   11
    2
    5  % was 3
    5
    3
    0
    4
    1
    2
    6
    
    0
    1
    2
    3
    4

    13
    7
    12
    13
    1
    5
    5
    7
    ];

AO.Port = {
'FP1'
'FP0'
'FP1'
'RB02'
'FP3'
'RB01'
'FP1'
'RB00'
'FP3'
'FP2'
'RB03'
'RB04'
'FPUV0'
'FP1'
'FPUV1'
'FP0'
'FPUV0'
'RB02'
'RB03'
'FPUV0'
'FPUV1'
'FP2'
'FP0'
'RB01'
'RB04'
'RB05'
'RB06'
'FPUV0'
'FP2'
'RB07'
'FPUV2'
'FPUV3'
'FPUV2'
'FP0'
'FPUV0'
'FP1'
'FPUV1'
'FPUV2'
'FPUV3'

'FPUV0'
'FP0'
'FP1'
'FP2'
'FP3'

'RB05'
'FP0'
'RB08'
'RB09'
'FPUV1'
'FP3'
'FP2'
'FPUV3'
};


AO.FD = [
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'    '
'UDC0'
'    '
'UDC1'
'    '
'UDC0'
'    '
'    '
'UDC0'
'UDC1'
'    '
'    '
'    '
'    '
'    '
'    '
'UDC0'
'    '
'    '
'UDC2'
'UDC3'
'UDC2'
'    '
'UDC0'
'    '
'UDC1'
'UDC2'
'UDC3'

'UDC0'
'    '
'    '
'    '
'    '

'    '
'    '
'    '
'    '
'UDC1'
'    '
'    '
'UDC3'
];

n = length(AO.CommonNames);
AO.DeviceList = [ones(n,1) (1:n)'];
AO.ElementList = (1:n)';
AO.Status = ones(size(AO.DeviceList,1),1);
AO.Position = (1:n)';

% Pulse generator setup
% getpv('S0817:EVR1-DlyGen:0:Evt:Trig0-SP')         %  Evt select
% getpv('S0817:EVR1-DlyGen:0:Ena-Sel')
% getpv('S0817:EVR1-DlyGen:0:Delay-SP')
% getpv('S0817:EVR1-DlyGen:0:Width-SP')             % usec
% getpv('S0817:EVR1-DlyGen:0:Width-RB')             % usec
% getpv('S0817:EVR1-DlyGen:0:Polarity-Sel')         % 0-Active high, 1-Active low

% Counter
%  PVcounter = [aa, ':EVR', num2str(bb), ':Evt', num2str(Evt), 'Cnt-I'];

AO.EvtCounter.MemberOf = {'Timing'; 'EvtCounter'; 'Save';};
AO.EvtCounter.Mode = 'Simulator';
AO.EvtCounter.DataType = 'Scalar';
AO.EvtCounter.ChannelNames = '';
for i = 1:n
    if isnan(AO.EvtNumber(i))
        AO.EvtCounter.ChannelNames = char(AO.EvtCounter.ChannelNames, '');
    else
        if AO.EvtNumber(i) == 68 || AO.EvtNumber(i) == 68
            % I'm not sure why, but the <crate>:EVR1:Evt68Cnt-I PV only exists in LI11
            Crate = 'LI11';
        else
            Crate =  deblank(AO.Crate{i});
        end
        
        AO.EvtCounter.ChannelNames = char(AO.EvtCounter.ChannelNames, sprintf('%s:EVR%d:Evt%dCnt-I', Crate, AO.EVR(i), AO.EvtNumber(i)));
    end
end
AO.EvtCounter.ChannelNames(1,:) = [];
AO.EvtCounter.HW2PhysicsParams = 1;
AO.EvtCounter.Physics2HWParams = 1;
AO.EvtCounter.Units        = 'Hardware';
AO.EvtCounter.HWUnits      = '#';
AO.EvtCounter.PhysicsUnits = '#';


% Event used by the pulse generator
AO.Evt.MemberOf = {'Timing'; 'Evt'; 'Save';};
AO.Evt.Mode = 'Simulator';
AO.Evt.DataType = 'Scalar';
AO.Evt.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Evt.ChannelNames = char(AO.Evt.ChannelNames, '');
    else
        AO.Evt.ChannelNames = char(AO.Evt.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Evt:Trig0-SP', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Evt.ChannelNames(1,:) = [];
AO.Evt.HW2PhysicsParams = 1;
AO.Evt.Physics2HWParams = 1;
AO.Evt.Units        = 'Hardware';
AO.Evt.HWUnits      = '#';
AO.Evt.PhysicsUnits = '#';

AO.Enable.MemberOf = {'Timing'; 'Enable'; 'Save';};
AO.Enable.Mode = 'Simulator';
AO.Enable.DataType = 'Scalar';
AO.Enable.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Enable.ChannelNames = char(AO.Enable.ChannelNames, '');
    else
        AO.Enable.ChannelNames = char(AO.Enable.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Ena-Sel', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Enable.ChannelNames(1,:) = [];
AO.Enable.HW2PhysicsParams = 1;
AO.Enable.Physics2HWParams = 1;
AO.Enable.Units        = 'Hardware';
AO.Enable.HWUnits      = '';
AO.Enable.PhysicsUnits = '';

AO.Prescaler.MemberOf = {'Timing'; 'Width Prescaler'; 'Save';};
AO.Prescaler.Mode = 'Simulator';
AO.Prescaler.DataType = 'Scalar';
AO.Prescaler.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Prescaler.ChannelNames = char(AO.Prescaler.ChannelNames, '');
    else
        AO.Prescaler.ChannelNames = char(AO.Prescaler.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Prescaler-SP', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Prescaler.ChannelNames(1,:) = [];
AO.Prescaler.HW2PhysicsParams = 1;
AO.Prescaler.Physics2HWParams = 1;
AO.Prescaler.Units        = 'Hardware';
AO.Prescaler.HWUnits      = '';
AO.Prescaler.PhysicsUnits = '';

AO.Delay.MemberOf = {'Timing'; 'Delay'; 'Save';};
AO.Delay.Mode = 'Simulator';
AO.Delay.DataType = 'Scalar';
AO.Delay.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Delay.ChannelNames = char(AO.Delay.ChannelNames, '');
    else
        AO.Delay.ChannelNames = char(AO.Delay.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Delay-SP', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Delay.ChannelNames(1,:) = [];
AO.Delay.HW2PhysicsParams = 1;
AO.Delay.Physics2HWParams = 1;
AO.Delay.Units        = 'Hardware';
AO.Delay.HWUnits      = 'Ticks';
AO.Delay.PhysicsUnits = 'Ticks';

AO.DelayRB.MemberOf = {'Timing'; 'DelayRB'; 'Save';};
AO.DelayRB.Mode = 'Simulator';
AO.DelayRB.DataType = 'Scalar';
AO.DelayRB.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.DelayRB.ChannelNames = char(AO.DelayRB.ChannelNames, '');
    else
        AO.DelayRB.ChannelNames = char(AO.DelayRB.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Delay-RB', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.DelayRB.ChannelNames(1,:) = [];
AO.DelayRB.HW2PhysicsParams = 1;
AO.DelayRB.Physics2HWParams = 1;
AO.DelayRB.Units        = 'Hardware';
AO.DelayRB.HWUnits      = 'Ticks';
AO.DelayRB.PhysicsUnits = 'Ticks';

AO.Width.MemberOf = {'Timing'; 'Width'; 'Save';};
AO.Width.Mode = 'Simulator';
AO.Width.DataType = 'Scalar';
AO.Width.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Width.ChannelNames = char(AO.Width.ChannelNames, '');
    else
        AO.Width.ChannelNames = char(AO.Width.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Width-SP', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Width.ChannelNames(1,:) = [];
AO.Width.HW2PhysicsParams = 1;
AO.Width.Physics2HWParams = 1;
AO.Width.Units        = 'Hardware';
AO.Width.HWUnits      = 'usec';
AO.Width.PhysicsUnits = 'usec';

AO.WidthRB.MemberOf = {'Timing'; 'WidthRB'; 'Save';};
AO.WidthRB.Mode = 'Simulator';
AO.WidthRB.DataType = 'Scalar';
AO.WidthRB.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.WidthRB.ChannelNames = char(AO.WidthRB.ChannelNames, '');
    else
        AO.WidthRB.ChannelNames = char(AO.WidthRB.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Width-RB', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.WidthRB.ChannelNames(1,:) = [];
AO.WidthRB.HW2PhysicsParams = 1;
AO.WidthRB.Physics2HWParams = 1;
AO.WidthRB.Units        = 'Hardware';
AO.WidthRB.HWUnits      = 'usec';
AO.WidthRB.PhysicsUnits = 'usec';

AO.Polarity.MemberOf = {'Timing'; 'Polarity'; 'Save';};
AO.Polarity.Mode = 'Simulator';
AO.Polarity.DataType = 'Scalar';
AO.Polarity.ChannelNames = '';
for i = 1:n
    if isnan(AO.PG(i))
        AO.Polarity.ChannelNames = char(AO.Polarity.ChannelNames, '');
    else
        AO.Polarity.ChannelNames = char(AO.Polarity.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:Polarity-Sel', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
    end
end
AO.Polarity.ChannelNames(1,:) = [];
AO.Polarity.HW2PhysicsParams = 1;
AO.Polarity.Physics2HWParams = 1;
AO.Polarity.Units        = 'Hardware';
AO.Polarity.HWUnits      = '';
AO.Polarity.PhysicsUnits = '';


% Output channel setup
% getpv('S0817:EVR1-Out:FPUV0:Src:Pulse-SP','char') % = 0 or Pulser 0
% getpv('S0817:EVR1-Out:UDC0:Delay-SP')             % Fine delay [inits???]

AO.Pulser.MemberOf = {'Timing'; 'Pulser'; 'Save';};
AO.Pulser.Mode = 'Simulator';
AO.Pulser.DataType = 'Scalar';
AO.Pulser.ChannelNames = '';
for i = 1:n
    if isempty(AO.Port{i})
        AO.Pulser.ChannelNames = char(AO.Pulser.ChannelNames, '');
    else
        AO.Pulser.ChannelNames = char(AO.Pulser.ChannelNames, sprintf('%s:EVR%d-Out:%s:Src:Pulse-SP', AO.Crate{i}, AO.EVR(i), AO.Port{i}));
    end
end
AO.Pulser.ChannelNames(1,:) = [];
AO.Pulser.HW2PhysicsParams = 1;
AO.Pulser.Physics2HWParams = 1;
AO.Pulser.Units        = 'Hardware';
AO.Pulser.HWUnits      = '#';
AO.Pulser.PhysicsUnits = '#';

AO.FineDelay.MemberOf = {'Timing'; 'FineDelay'; 'Save';};
AO.FineDelay.Mode = 'Simulator';
AO.FineDelay.DataType = 'Scalar';
AO.FineDelay.ChannelNames = '';
for i = 1:n
    if AO.FD(i,1) == ' '
        AO.FineDelay.ChannelNames = char(AO.FineDelay.ChannelNames, '');
    else
        AO.FineDelay.ChannelNames = char(AO.FineDelay.ChannelNames, sprintf('%s:EVR%d-Out:%s:Delay-SP', AO.Crate{i}, AO.EVR(i), AO.FD(i,:)));
    end
end
AO.FineDelay.ChannelNames(1,:) = [];
AO.FineDelay.HW2PhysicsParams = 1;
AO.FineDelay.Physics2HWParams = 1;
AO.FineDelay.Units        = 'Hardware';
AO.FineDelay.HWUnits      = '';
AO.FineDelay.PhysicsUnits = '';



%AO.Monitor  = AO.Delay;
%AO.Setpoint = AO.Delay;


% AO.xxxyyy.MemberOf = {'Timing'; 'xxxyyy'; 'Save';};
% AO.xxxyyy.Mode = 'Simulator';
% AO.xxxyyy.DataType = 'Scalar';
% AO.xxxyyy.ChannelNames = '';
% for i = 1:n
%     if isnan(AO.PG(i))
%         AO.xxxyyy.ChannelNames = char(AO.xxxyyy.ChannelNames, '');
%     else
%         AO.xxxyyy.ChannelNames = char(AO.xxxyyy.ChannelNames, sprintf('%s:EVR%d-DlyGen:%d:', AO.Crate{i}, AO.EVR(i), AO.PG(i)));
%     end
% end
% AO.xxxyyy.ChannelNames(1,:) = [];
% AO.xxxyyy.HW2PhysicsParams = 1;
% AO.xxxyyy.Physics2HWParams = 1;
% AO.xxxyyy.Units        = 'Hardware';
% AO.xxxyyy.HWUnits      = '';
% AO.xxxyyy.PhysicsUnits = '';
