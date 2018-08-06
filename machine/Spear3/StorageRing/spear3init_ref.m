                                                                    function spear3init
% Initialize parameters for SPEAR 3 control in MATLAB
%
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% CommonNames           Shortcut name for each element
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet center
%
% Monitor Fields
% Mode                  online/manual/special/simulator
% ChannelNames          PV for monitor
% Units                 Physics or HW
% HW2PhysicsFcn         function handle used to convert from hardware to physics units ==> inline will not compile, see below
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';           
% PhysicsUnits          units for physics 'Rad';
%
% Setpoint Fields
% Mode                  online/manual/special/simulator
% ChannelNames          PV for monitor
% Units                 hardware or physics
% HW2PhysicsFcn         function handle used to convert from hardware to physics units
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';           
% PhysicsUnits          units for physics 'Rad';
% Range                 minsetpoint, maxsetpoint;
% Tolerance             setpoint-monitor
% 
%=============================================  
% Accelerator Toolbox Simulation Fields
%=============================================
% ATType                Quad, Sext, etc
% ATIndex               index in THERING
% ATParameterGroup      parameter group
%
%============  
% Family List
%============
%    BPMx
%    BPMy
%    HCM
%    VCM
%    SkewQuad
%    BEND
%    BDM
%    QDX
%    QFX
%    QDY
%    QFY
%    QDZ
%    QFZ
%    QF
%    QD
%    QFC
%    SF
%    SD
%    SFM
%    SDM
%    Kickers
%    RF
%    DCCT
%    Septum
%    Machine Parameters
%    BLOpen
%    BLErr
%    BLSum
%    Mains
%    Shunt Current
%    Shunt Relay
% MATCH    (7 BPM):    BPM-QDX-HVCM-QFX-QDY-BEND-SDM-VCM-SFM-QFY-SFM-HCM-SDM-BEND-QDZ-HVCM-QFZ-BPM
% STANDARD (6 BPM):    BPM-QF-HVCM-QD-BEND-SD-VCM-SF-QDC-SF-HCM-SD-BEND-QD-HVCM-QF-BPM
% NOTES: 
%       all sextupoles have skew quadrupole windings
%       all quadrupoles have trim/modulation windings



Mode = 'ONLINE';


%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=112;
AO{1}.FamilyName               = 'BPMx';
AO{1}.FamilyType               = 'BPM';
AO{1}.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO{1}.Monitor.Mode             = Mode;
AO{1}.Monitor.DataType         = 'Vector';
AO{1}.Monitor.DataTypeIndex    = [1:ntbpm];
AO{1}.Monitor.Units            = 'Hardware';
AO{1}.Monitor.HWUnits          = 'mm';
AO{1}.Monitor.PhysicsUnits     = 'meter';

AO{2}.FamilyName               = 'BPMy';
AO{2}.FamilyType               = 'BPM';
AO{2}.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO{2}.Monitor.Mode             = Mode;
AO{2}.Monitor.DataType         = 'Vector';
AO{2}.Monitor.DataTypeIndex    = [1:ntbpm];
AO{2}.Monitor.Units            = 'Hardware';
AO{2}.Monitor.HWUnits          = 'mm';
AO{2}.Monitor.PhysicsUnits     = 'meter';

% x-name      x-chname   xstat y-name       y-chname ystat DevList Elem  Type 
%                                                                  (Bergoz/Ecotek)
bpm={
 '1BPM1   '    '01G-BPM1:U   '  1  '1BPM1   '    '01G-BPM1:V   '  1  [1 ,1]    1    'B'    ; ...
 '1BPM2   '    '01G-BPM2:U   '  0  '1BPM2   '    '01G-BPM2:V   '  0  [1 ,2]    2    'E'    ; ...
 '1BPM3   '    '01G-BPM3:U   '  0  '1BPM3   '    '01G-BPM3:V   '  0  [1 ,3]    3    'E'    ; ...
 '1BPM4   '    '01G-BPM4:U   '  1  '1BPM4   '    '01G-BPM4:V   '  1  [1 ,4]    4    'B'    ; ...
 '1BPM5   '    '01G-BPM5:U   '  0  '1BPM5   '    '01G-BPM5:V   '  0  [1 ,5]    5    'E'    ; ...
 '1BPM6   '    '01G-BPM6:U   '  0  '1BPM6   '    '01G-BPM6:V   '  0  [1 ,6]    6    'E'    ; ...
 '1BPM7   '    '01G-BPM7:U   '  1  '1BPM7   '    '01G-BPM7:V   '  1  [1 ,7]    7    'B'    ; ...
 '2BPM1   '    '02G-BPM1:U   '  1  '2BPM1   '    '02G-BPM1:V   '  1  [2 ,1]    8    'B'    ; ...
 '2BPM2   '    '02G-BPM2:U   '  0  '2BPM2   '    '02G-BPM2:V   '  0  [2 ,2]    9    'E'    ; ...
 '2BPM3   '    '02G-BPM3:U   '  0  '2BPM3   '    '02G-BPM3:V   '  0  [2 ,3]    10   'E'    ; ...
 '2BPM4   '    '02G-BPM4:U   '  1  '2BPM4   '    '02G-BPM4:V   '  1  [2 ,4]    11   'B'    ; ...
 '2BPM5   '    '02G-BPM5:U   '  0  '2BPM5   '    '02G-BPM5:V   '  0  [2 ,5]    12   'E'    ; ...
 '2BPM6   '    '02G-BPM6:U   '  1  '2BPM6   '    '02G-BPM6:V   '  1  [2 ,6]    13   'B'    ; ...
 '3BPM1   '    '03G-BPM1:U   '  1  '3BPM1   '    '03G-BPM1:V   '  1  [3 ,1]    14   'B'    ; ...
 '3BPM2   '    '03G-BPM2:U   '  0  '3BPM2   '    '03G-BPM2:V   '  0  [3 ,2]    15   'E'    ; ...
 '3BPM3   '    '03G-BPM3:U   '  0  '3BPM3   '    '03G-BPM3:V   '  0  [3 ,3]    16   'E'    ; ...
 '3BPM4   '    '03G-BPM4:U   '  1  '3BPM4   '    '03G-BPM4:V   '  1  [3 ,4]    17   'B'    ; ...
 '3BPM5   '    '03G-BPM5:U   '  0  '3BPM5   '    '03G-BPM5:V   '  0  [3 ,5]    18   'E'    ; ...
 '3BPM6   '    '03G-BPM6:U   '  1  '3BPM6   '    '03G-BPM6:V   '  1  [3 ,6]    19   'B'    ; ...
 '4BPM1   '    '04G-BPM1:U   '  1  '4BPM1   '    '04G-BPM1:V   '  1  [4 ,1]    20   'B'    ; ...
 '4BPM2   '    '04G-BPM2:U   '  0  '4BPM2   '    '04G-BPM2:V   '  0  [4 ,2]    21   'E'    ; ...
 '4BPM3   '    '04G-BPM3:U   '  0  '4BPM3   '    '04G-BPM3:V   '  0  [4 ,3]    22   'E'    ; ...
 '4BPM4   '    '04G-BPM4:U   '  1  '4BPM4   '    '04G-BPM4:V   '  1  [4 ,4]    23   'B'    ; ...
 '4BPM5   '    '04G-BPM5:U   '  0  '4BPM5   '    '04G-BPM5:V   '  0  [4 ,5]    24   'E'    ; ...
 '4BPM6   '    '04G-BPM6:U   '  1  '4BPM6   '    '04G-BPM6:V   '  1  [4 ,6]    25   'B'    ; ...
 '5BPM1   '    '05G-BPM1:U   '  1  '5BPM1   '    '05G-BPM1:V   '  1  [5 ,1]    26   'B'    ; ...
 '5BPM2   '    '05G-BPM2:U   '  0  '5BPM2   '    '05G-BPM2:V   '  0  [5 ,2]    27   'E'    ; ...
 '5BPM3   '    '05G-BPM3:U   '  0  '5BPM3   '    '05G-BPM3:V   '  0  [5 ,3]    28   'E'    ; ...
 '5BPM4   '    '05G-BPM4:U   '  1  '5BPM4   '    '05G-BPM4:V   '  1  [5 ,4]    29   'B'    ; ...
 '5BPM5   '    '05G-BPM5:U   '  0  '5BPM5   '    '05G-BPM5:V   '  0  [5 ,5]    30   'E'    ; ...
 '5BPM6   '    '05G-BPM6:U   '  1  '5BPM6   '    '05G-BPM6:V   '  1  [5 ,6]    31   'B'    ; ...
 '6BPM1   '    '06G-BPM1:U   '  1  '6BPM1   '    '06G-BPM1:V   '  1  [6 ,1]    32   'B'    ; ...
 '6BPM2   '    '06G-BPM2:U   '  0  '6BPM2   '    '06G-BPM2:V   '  0  [6 ,2]    33   'E'    ; ...
 '6BPM3   '    '06G-BPM3:U   '  0  '6BPM3   '    '06G-BPM3:V   '  0  [6 ,3]    34   'E'    ; ...
 '6BPM4   '    '06G-BPM4:U   '  1  '6BPM4   '    '06G-BPM4:V   '  1  [6 ,4]    35   'B'    ; ...
 '6BPM5   '    '06G-BPM5:U   '  0  '6BPM5   '    '06G-BPM5:V   '  0  [6 ,5]    36   'E'    ; ...
 '6BPM6   '    '06G-BPM6:U   '  1  '6BPM6   '    '06G-BPM6:V   '  1  [6 ,6]    37   'B'    ; ...
 '7BPM1   '    '07G-BPM1:U   '  1  '7BPM1   '    '07G-BPM1:V   '  1  [7 ,1]    38   'B'    ; ...
 '7BPM2   '    '07G-BPM2:U   '  0  '7BPM2   '    '07G-BPM2:V   '  0  [7 ,2]    39   'E'    ; ...
 '7BPM3   '    '07G-BPM3:U   '  0  '7BPM3   '    '07G-BPM3:V   '  0  [7 ,3]    40   'E'    ; ...
 '7BPM4   '    '07G-BPM4:U   '  1  '7BPM4   '    '07G-BPM4:V   '  1  [7 ,4]    41   'B'    ; ...
 '7BPM5   '    '07G-BPM5:U   '  0  '7BPM5   '    '07G-BPM5:V   '  0  [7 ,5]    42   'E'    ; ...
 '7BPM6   '    '07G-BPM6:U   '  1  '7BPM6   '    '07G-BPM6:V   '  1  [7 ,6]    43   'B'    ; ...
 '8BPM1   '    '08G-BPM1:U   '  1  '8BPM1   '    '08G-BPM1:V   '  1  [8 ,1]    44   'B'    ; ...
 '8BPM2   '    '08G-BPM2:U   '  0  '8BPM2   '    '08G-BPM2:V   '  0  [8 ,2]    45   'E'    ; ...
 '8BPM3   '    '08G-BPM3:U   '  0  '8BPM3   '    '08G-BPM3:V   '  0  [8 ,3]    46   'E'    ; ...
 '8BPM4   '    '08G-BPM4:U   '  1  '8BPM4   '    '08G-BPM4:V   '  1  [8 ,4]    47   'B'    ; ...
 '8BPM5   '    '08G-BPM5:U   '  0  '8BPM5   '    '08G-BPM5:V   '  0  [8 ,5]    48   'E'    ; ...
 '8BPM6   '    '08G-BPM6:U   '  1  '8BPM6   '    '08G-BPM6:V   '  1  [8 ,6]    49   'B'    ; ...
 '9BPM1   '    '09G-BPM1:U   '  1  '9BPM1   '    '09G-BPM1:V   '  1  [9 ,1]    50   'B'    ; ...
 '9BPM2   '    '09G-BPM2:U   '  0  '9BPM2   '    '09G-BPM2:V   '  0  [9 ,2]    51   'B'    ; ...
 '9BPM3   '    '09G-BPM3:U   '  0  '9BPM3   '    '09G-BPM3:V   '  0  [9 ,3]    52   'E'    ; ...
 '9BPM4   '    '09G-BPM4:U   '  1  '9BPM4   '    '09G-BPM4:V   '  1  [9 ,4]    53   'B'    ; ...
 '9BPM5   '    '09G-BPM5:U   '  0  '9BPM5   '    '09G-BPM5:V   '  0  [9 ,5]    54   'E'    ; ...
 '9BPM6   '    '09G-BPM6:U   '  0  '9BPM6   '    '09G-BPM6:V   '  0  [9 ,6]    55   'E'    ; ...
 '9BPM7   '    '09G-BPM7:U   '  1  '9BPM7   '    '09G-BPM7:V   '  1  [9 ,7]    56   'B'    ; ...
 '10BPM1  '    '10G-BPM1:U   '  1  '10BPM1  '    '10G-BPM1:V   '  1  [10,1]    57   'B'    ; ...
 '10BPM2  '    '10G-BPM2:U   '  0  '10BPM2  '    '10G-BPM2:V   '  0  [10,2]    58   'E'    ; ...
 '10BPM3  '    '10G-BPM3:U   '  0  '10BPM3  '    '10G-BPM3:V   '  0  [10,3]    59   'E'    ; ...
 '10BPM4  '    '10G-BPM4:U   '  1  '10BPM4  '    '10G-BPM4:V   '  1  [10,4]    60   'B'    ; ...
 '10BPM5  '    '10G-BPM5:U   '  0  '10BPM5  '    '10G-BPM5:V   '  0  [10,5]    61   'E'    ; ...
 '10BPM6  '    '10G-BPM6:U   '  0  '10BPM6  '    '10G-BPM6:V   '  0  [10,6]    62   'E'    ; ...
 '10BPM7  '    '10G-BPM7:U   '  1  '10BPM7  '    '10G-BPM7:V   '  1  [10,7]    63   'B'    ; ...
 '11BPM1  '    '11G-BPM1:U   '  1  '11BPM1  '    '11G-BPM1:V   '  1  [11,1]    64   'B'    ; ...
 '11BPM2  '    '11G-BPM2:U   '  0  '11BPM2  '    '11G-BPM2:V   '  0  [11,2]    65   'E'    ; ...
 '11BPM3  '    '11G-BPM3:U   '  0  '11BPM3  '    '11G-BPM3:V   '  0  [11,3]    66   'E'    ; ...
 '11BPM4  '    '11G-BPM4:U   '  1  '11BPM4  '    '11G-BPM4:V   '  1  [11,4]    67   'B'    ; ...
 '11BPM5  '    '11G-BPM5:U   '  0  '11BPM5  '    '11G-BPM5:V   '  0  [11,5]    68   'E'    ; ...
 '11BPM6  '    '11G-BPM6:U   '  1  '11BPM6  '    '11G-BPM6:V   '  1  [11,6]    69   'B'    ; ...
 '12BPM1  '    '12G-BPM1:U   '  1  '12BPM1  '    '12G-BPM1:V   '  1  [12,1]    70   'B'    ; ...
 '12BPM2  '    '12G-BPM2:U   '  0  '12BPM2  '    '12G-BPM2:V   '  0  [12,2]    71   'E'    ; ...
 '12BPM3  '    '12G-BPM3:U   '  0  '12BPM3  '    '12G-BPM3:V   '  0  [12,3]    72   'E'    ; ...
 '12BPM4  '    '12G-BPM4:U   '  0  '12BPM4  '    '12G-BPM4:V   '  0  [12,4]    73   'B'    ; ...
 '12BPM5  '    '12G-BPM5:U   '  1  '12BPM5  '    '12G-BPM5:V   '  1  [12,5]    74   'E'    ; ...
 '12BPM6  '    '12G-BPM6:U   '  1  '12BPM6  '    '12G-BPM6:V   '  1  [12,6]    75   'B'    ; ...
 '13BPM1  '    '13G-BPM1:U   '  1  '13BPM1  '    '13G-BPM1:V   '  1  [13,1]    76   'B'    ; ...
 '13BPM2  '    '13G-BPM2:U   '  0  '13BPM2  '    '13G-BPM2:V   '  0  [13,2]    77   'E'    ; ...
 '13BPM3  '    '13G-BPM3:U   '  0  '13BPM3  '    '13G-BPM3:V   '  0  [13,3]    78   'E'    ; ...
 '13BPM4  '    '13G-BPM4:U   '  1  '13BPM4  '    '13G-BPM4:V   '  1  [13,4]    79   'B'    ; ...
 '13BPM5  '    '13G-BPM5:U   '  0  '13BPM5  '    '13G-BPM5:V   '  0  [13,5]    80   'E'    ; ...
 '13BPM6  '    '13G-BPM6:U   '  1  '13BPM6  '    '13G-BPM6:V   '  1  [13,6]    81   'B'    ; ...
 '14BPM1  '    '14G-BPM1:U   '  1  '14BPM1  '    '14G-BPM1:V   '  1  [14,1]    82   'B'    ; ...
 '14BPM2  '    '14G-BPM2:U   '  0  '14BPM2  '    '14G-BPM2:V   '  0  [14,2]    83   'E'    ; ...
 '14BPM3  '    '14G-BPM3:U   '  0  '14BPM3  '    '14G-BPM3:V   '  0  [14,3]    84   'E'    ; ...
 '14BPM4  '    '14G-BPM4:U   '  0  '14BPM4  '    '14G-BPM4:V   '  0  [14,4]    85   'B'    ; ...
 '14BPM5  '    '14G-BPM5:U   '  0  '14BPM5  '    '14G-BPM5:V   '  0  [14,5]    86   'E'    ; ...
 '14BPM6  '    '14G-BPM6:U   '  1  '14BPM6  '    '14G-BPM6:V   '  1  [14,6]    87   'B'    ; ...
 '15BPM1  '    '15G-BPM1:U   '  1  '15BPM1  '    '15G-BPM1:V   '  1  [15,1]    88   'B'    ; ...
 '15BPM2  '    '15G-BPM2:U   '  0  '15BPM2  '    '15G-BPM2:V   '  0  [15,2]    89   'E'    ; ...
 '15BPM3  '    '15G-BPM3:U   '  0  '15BPM3  '    '15G-BPM3:V   '  0  [15,3]    90   'E'    ; ...
 '15BPM4  '    '15G-BPM4:U   '  1  '15BPM4  '    '15G-BPM4:V   '  1  [15,4]    91   'B'    ; ...
 '15BPM5  '    '15G-BPM5:U   '  0  '15BPM5  '    '15G-BPM5:V   '  0  [15,5]    92   'E'    ; ...
 '15BPM6  '    '15G-BPM6:U   '  1  '15BPM6  '    '15G-BPM6:V   '  1  [15,6]    93   'B'    ; ...
 '16BPM1  '    '16G-BPM1:U   '  1  '16BPM1  '    '16G-BPM1:V   '  1  [16,1]    94   'B'    ; ...
 '16BPM2  '    '16G-BPM2:U   '  0  '16BPM2  '    '16G-BPM2:V   '  0  [16,2]    95   'E'    ; ...
 '16BPM3  '    '16G-BPM3:U   '  0  '16BPM3  '    '16G-BPM3:V   '  0  [16,3]    96   'E'    ; ...
 '16BPM4  '    '16G-BPM4:U   '  1  '16BPM4  '    '16G-BPM4:V   '  1  [16,4]    97   'B'    ; ...
 '16BPM5  '    '16G-BPM5:U   '  0  '16BPM5  '    '16G-BPM5:V   '  0  [16,5]    98   'E'    ; ...
 '16BPM6  '    '16G-BPM6:U   '  1  '16BPM6  '    '16G-BPM6:V   '  1  [16,6]    99   'B'    ; ...
 '17BPM1  '    '17G-BPM1:U   '  1  '17BPM1  '    '17G-BPM1:V   '  1  [17,1]    100  'B'    ; ...
 '17BPM2  '    '17G-BPM2:U   '  0  '17BPM2  '    '17G-BPM2:V   '  0  [17,2]    101  'E'    ; ...
 '17BPM3  '    '17G-BPM3:U   '  0  '17BPM3  '    '17G-BPM3:V   '  0  [17,3]    102  'E'    ; ...
 '17BPM4  '    '17G-BPM4:U   '  1  '17BPM4  '    '17G-BPM4:V   '  1  [17,4]    103  'B'    ; ...
 '17BPM5  '    '17G-BPM5:U   '  0  '17BPM5  '    '17G-BPM5:V   '  0  [17,5]    104  'E'    ; ...
 '17BPM6  '    '17G-BPM6:U   '  1  '17BPM6  '    '17G-BPM6:V   '  1  [17,6]    105  'B'    ; ...
 '18BPM1  '    '18G-BPM1:U   '  1  '18BPM1  '    '18G-BPM1:V   '  1  [18,1]    106  'B'    ; ...
 '18BPM2  '    '18G-BPM2:U   '  0  '18BPM2  '    '18G-BPM2:V   '  0  [18,2]    107  'E'    ; ...
 '18BPM3  '    '18G-BPM3:U   '  0  '18BPM3  '    '18G-BPM3:V   '  0  [18,3]    108  'E'    ; ...
 '18BPM4  '    '18G-BPM4:U   '  1  '18BPM4  '    '18G-BPM4:V   '  1  [18,4]    109  'B'    ; ...
 '18BPM5  '    '18G-BPM5:U   '  0  '18BPM5  '    '18G-BPM5:V   '  0  [18,5]    110  'E'    ; ...
 '18BPM6  '    '18G-BPM6:U   '  0  '18BPM6  '    '18G-BPM6:V   '  0  [18,6]    111  'E'    ; ...
 '18BPM7  '    '18G-BPM7:U   '  1  '18BPM7  '    '18G-BPM7:V   '  1  [18,7]    112  'B'    ; ...
};

%Load fields from data block
for ii=1:size(bpm,1)
name=bpm{ii,1};      AO{1}.CommonNames(ii,:)         = name;
name=bpm{ii,2};      AO{1}.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,3};      AO{1}.Status(ii,:)              = val;  
name=bpm{ii,4};      AO{2}.CommonNames(ii,:)         = name;
name=bpm{ii,5};      AO{2}.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,6};      AO{2}.Status(ii,:)              = val;  
val =bpm{ii,7};      AO{1}.DeviceList(ii,:)          = val;   
                     AO{2}.DeviceList(ii,:)          = val;
val =bpm{ii,8};      AO{1}.ElementList(ii,:)         = val;   
                     AO{2}.ElementList(ii,:)         = val;
                     AO{1}.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO{1}.Monitor.Physics2HWParams(ii,:) = 1000;
                     AO{2}.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO{2}.Monitor.Physics2HWParams(ii,:) = 1000;
end

AO{1}.Status = AO{1}.Status(:);
AO{2}.Status = AO{2}.Status(:);

if 0 % change from 'if 1' to 'if 0' to invoke orbit, instead of u,v calls
    % Scalar channel method
    AO{1}.Monitor.DataType = 'Scalar';
    AO{2}.Monitor.DataType = 'Scalar';

    AO{1}.Monitor = rmfield(AO{1}.Monitor, 'DataTypeIndex');
    AO{2}.Monitor = rmfield(AO{2}.Monitor, 'DataTypeIndex');
    
else
    % Special function
    AO{1}.Monitor.Mode            = 'Special';
    AO{1}.Monitor.SpecialFunctionGet = 'getxspear';
    AO{2}.Monitor.Mode            = 'Special';
    AO{2}.Monitor.SpecialFunctionGet = 'getyspear';
end


AO{1}.Sum.Mode             = Mode;
AO{1}.Sum.Units            = 'Hardware';
AO{1}.Sum.DataType         = 'Vector';
AO{1}.Sum.DataTypeIndex    = [1:ntbpm];
AO{1}.Sum.SpecialFunctionGet  = 'getbpmsum';
AO{1}.Sum.HWUnits          = 'ADC Counts';
AO{1}.Sum.PhysicsUnits     = 'ADC Counts';
AO{1}.Sum.HW2PhysicsParams = 1;
AO{1}.Sum.Physics2HWParams = 1;
AO{1}.Sum.Units            = 'Hardware';

AO{1}.Q.Mode             = Mode;
AO{1}.Q.Units            = 'Hardware';
AO{1}.Q.DataType         = 'Vector';
AO{1}.Q.DataTypeIndex    = [1:ntbpm];
AO{1}.Q.SpecialFunctionGet  = 'getbpmq';
AO{1}.Q.HWUnits          = 'mm';
AO{1}.Q.PhysicsUnits     = 'meter';
AO{1}.Q.HW2PhysicsParams = 1e-3;
AO{1}.Q.Physics2HWParams = 1000;

AO{2}.Sum = AO{1}.Sum;
AO{2}.Q   = AO{1}.Q;



%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================
%horizontal corrector windings on SPEAR 3 cores 1,3,4
%vertical   corrector windings on SPEAR 3 cores 1,2,4

% NOTE: HCMGain and VCMGain are not used anymore!!!
%       k2amp and amp2k are use so that energy scaling works
HCMGain                        = 0.0015/30.0;                  %0.0015  radian/30 ampere @ 3.0 GeV - 0.15 about right as per elog 12/22/03 23:48
HCMGain_noshield               = HCMGain*0.188/0.15;           %x-correctors with no shield stronger as per elog 12/22/03 23:48
VCMGain                        = (0.00075/30.0)*(0.125/0.15);  %0.00075 radian/30 ampere @ 3.0 GeV - derate as per elog 12/22/03 23:48
VCMGain_noshield               = VCMGain*0.16/0.125;           %y-correctors with no shield stronger as per elog 12/22/03 23:48

AO{3}.FamilyName               = 'HCM';
AO{3}.FamilyType               = 'COR';
AO{3}.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'MCOR'; 'HCM'; 'Magnet'};

AO{3}.Monitor.Mode             = Mode;
AO{3}.Monitor.DataType         = 'Scalar';
AO{3}.Monitor.Units            = 'Hardware';
AO{3}.Monitor.HWUnits          = 'ampere';           
AO{3}.Monitor.PhysicsUnits     = 'radian';
AO{3}.Monitor.HW2PhysicsFcn = @amp2k;
AO{3}.Monitor.Physics2HWFcn = @k2amp;

AO{3}.Setpoint.Mode            = Mode;
AO{3}.Setpoint.DataType        = 'Scalar';
AO{3}.Setpoint.Units           = 'Hardware';
AO{3}.Setpoint.HWUnits         = 'ampere';           
AO{3}.Setpoint.PhysicsUnits    = 'radian';
AO{3}.Setpoint.HW2PhysicsFcn = @amp2k;
AO{3}.Setpoint.Physics2HWFcn = @k2amp;


AO{4}.FamilyName               = 'VCM';
AO{4}.FamilyType               = 'COR';
AO{4}.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'MCOR'; 'VCM'; 'Magnet'};

AO{4}.Monitor.Mode             = Mode;
AO{4}.Monitor.DataType         = 'Scalar';
AO{4}.Monitor.Units            = 'Hardware';
AO{4}.Monitor.HWUnits          = 'ampere';           
AO{4}.Monitor.PhysicsUnits     = 'radian';
AO{4}.Monitor.HW2PhysicsFcn = @amp2k;
AO{4}.Monitor.Physics2HWFcn = @k2amp;

AO{4}.Setpoint.Mode            = Mode;
AO{4}.Setpoint.DataType        = 'Scalar';
AO{4}.Setpoint.Units           = 'Hardware';
AO{4}.Setpoint.HWUnits         = 'ampere';           
AO{4}.Setpoint.PhysicsUnits    = 'radian';
AO{4}.Setpoint.HW2PhysicsFcn = @amp2k;
AO{4}.Setpoint.Physics2HWFcn = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%x-common      x-monitor           x-setpoint     xstat y-common      y-monitor          y-setpoint      ystat devlist elem range (ampere) tol   x-kick    y-kick    y-phot   H2P_X          P2H_X          H2P_Y        P2H_Y 
cor={
 '1CX1    ' '01G-COR1H:Curr1' '01G-COR1H:CurrSetpt'  1  '1CY1    ' '01G-COR1V:Curr1' '01G-COR1V:CurrSetpt'  1   [1 ,1]  1  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain_noshield 0]  [1/HCMGain_noshield 0]  [VCMGain_noshield 0]  [1/VCMGain_noshield 0]; ...
 '1CX2    ' '01G-COR2H:Curr1' '01G-COR2H:CurrSetpt'  0  '1CY2    ' '01G-COR2V:Curr1' '01G-COR2V:CurrSetpt'  1   [1 ,2]  2  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX3    ' '01G-COR3H:Curr1' '01G-COR3H:CurrSetpt'  1  '1CY3    ' '01G-COR3V:Curr1' '01G-COR3V:CurrSetpt'  0   [1 ,3]  3  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX4    ' '01G-COR4H:Curr1' '01G-COR4H:CurrSetpt'  1  '1CY4    ' '01G-COR4V:Curr1' '01G-COR4V:CurrSetpt'  1   [1 ,4]  4  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX1    ' '02G-COR1H:Curr1' '02G-COR1H:CurrSetpt'  1  '2CY1    ' '02G-COR1V:Curr1' '02G-COR1V:CurrSetpt'  1   [2 ,1]  5  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX2    ' '02G-COR2H:Curr1' '02G-COR2H:CurrSetpt'  0  '2CY2    ' '02G-COR2V:Curr1' '02G-COR2V:CurrSetpt'  1   [2 ,2]  6  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX3    ' '02G-COR3H:Curr1' '02G-COR3H:CurrSetpt'  1  '2CY3    ' '02G-COR3V:Curr1' '02G-COR3V:CurrSetpt'  0   [2 ,3]  7  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX4    ' '02G-COR4H:Curr1' '02G-COR4H:CurrSetpt'  1  '2CY4    ' '02G-COR4V:Curr1' '02G-COR4V:CurrSetpt'  1   [2 ,4]  8  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX1    ' '03G-COR1H:Curr1' '03G-COR1H:CurrSetpt'  1  '3CY1    ' '03G-COR1V:Curr1' '03G-COR1V:CurrSetpt'  1   [3 ,1]  9  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX2    ' '03G-COR2H:Curr1' '03G-COR2H:CurrSetpt'  0  '3CY2    ' '03G-COR2V:Curr1' '03G-COR2V:CurrSetpt'  1   [3 ,2]  10 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX3    ' '03G-COR3H:Curr1' '03G-COR3H:CurrSetpt'  1  '3CY3    ' '03G-COR3V:Curr1' '03G-COR3V:CurrSetpt'  0   [3 ,3]  11 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX4    ' '03G-COR4H:Curr1' '03G-COR4H:CurrSetpt'  1  '3CY4    ' '03G-COR4V:Curr1' '03G-COR4V:CurrSetpt'  1   [3 ,4]  12 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX1    ' '04G-COR1H:Curr1' '04G-COR1H:CurrSetpt'  1  '4CY1    ' '04G-COR1V:Curr1' '04G-COR1V:CurrSetpt'  1   [4 ,1]  13 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX2    ' '04G-COR2H:Curr1' '04G-COR2H:CurrSetpt'  0  '4CY2    ' '04G-COR2V:Curr1' '04G-COR2V:CurrSetpt'  1   [4 ,2]  14 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX3    ' '04G-COR3H:Curr1' '04G-COR3H:CurrSetpt'  1  '4CY3    ' '04G-COR3V:Curr1' '04G-COR3V:CurrSetpt'  0   [4 ,3]  15 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX4    ' '04G-COR4H:Curr1' '04G-COR4H:CurrSetpt'  1  '4CY4    ' '04G-COR4V:Curr1' '04G-COR4V:CurrSetpt'  1   [4 ,4]  16 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX1    ' '05G-COR1H:Curr1' '05G-COR1H:CurrSetpt'  1  '5CY1    ' '05G-COR1V:Curr1' '05G-COR1V:CurrSetpt'  1   [5 ,1]  17 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX2    ' '05G-COR2H:Curr1' '05G-COR2H:CurrSetpt'  0  '5CY2    ' '05G-COR2V:Curr1' '05G-COR2V:CurrSetpt'  1   [5 ,2]  18 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX3    ' '05G-COR3H:Curr1' '05G-COR3H:CurrSetpt'  1  '5CY3    ' '05G-COR3V:Curr1' '05G-COR3V:CurrSetpt'  0   [5 ,3]  19 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX4    ' '05G-COR4H:Curr1' '05G-COR4H:CurrSetpt'  1  '5CY4    ' '05G-COR4V:Curr1' '05G-COR4V:CurrSetpt'  1   [5 ,4]  20 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX1    ' '06G-COR1H:Curr1' '06G-COR1H:CurrSetpt'  1  '6CY1    ' '06G-COR1V:Curr1' '06G-COR1V:CurrSetpt'  1   [6 ,1]  21 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX2    ' '06G-COR2H:Curr1' '06G-COR2H:CurrSetpt'  0  '6CY2    ' '06G-COR2V:Curr1' '06G-COR2V:CurrSetpt'  1   [6 ,2]  22 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX3    ' '06G-COR3H:Curr1' '06G-COR3H:CurrSetpt'  1  '6CY3    ' '06G-COR3V:Curr1' '06G-COR3V:CurrSetpt'  0   [6 ,3]  23 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX4    ' '06G-COR4H:Curr1' '06G-COR4H:CurrSetpt'  1  '6CY4    ' '06G-COR4V:Curr1' '06G-COR4V:CurrSetpt'  1   [6 ,4]  24 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX1    ' '07G-COR1H:Curr1' '07G-COR1H:CurrSetpt'  1  '7CY1    ' '07G-COR1V:Curr1' '07G-COR1V:CurrSetpt'  1   [7 ,1]  25 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX2    ' '07G-COR2H:Curr1' '07G-COR2H:CurrSetpt'  0  '7CY2    ' '07G-COR2V:Curr1' '07G-COR2V:CurrSetpt'  1   [7 ,2]  26 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX3    ' '07G-COR3H:Curr1' '07G-COR3H:CurrSetpt'  1  '7CY3    ' '07G-COR3V:Curr1' '07G-COR3V:CurrSetpt'  0   [7 ,3]  27 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX4    ' '07G-COR4H:Curr1' '07G-COR4H:CurrSetpt'  1  '7CY4    ' '07G-COR4V:Curr1' '07G-COR4V:CurrSetpt'  1   [7 ,4]  28 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX1    ' '08G-COR1H:Curr1' '08G-COR1H:CurrSetpt'  1  '8CY1    ' '08G-COR1V:Curr1' '08G-COR1V:CurrSetpt'  1   [8 ,1]  29 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX2    ' '08G-COR2H:Curr1' '08G-COR2H:CurrSetpt'  0  '8CY2    ' '08G-COR2V:Curr1' '08G-COR2V:CurrSetpt'  1   [8 ,2]  30 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX3    ' '08G-COR3H:Curr1' '08G-COR3H:CurrSetpt'  1  '8CY3    ' '08G-COR3V:Curr1' '08G-COR3V:CurrSetpt'  0   [8 ,3]  31 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX4    ' '08G-COR4H:Curr1' '08G-COR4H:CurrSetpt'  1  '8CY4    ' '08G-COR4V:Curr1' '08G-COR4V:CurrSetpt'  1   [8 ,4]  32 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX1    ' '09G-COR1H:Curr1' '09G-COR1H:CurrSetpt'  1  '9CY1    ' '09G-COR1V:Curr1' '09G-COR1V:CurrSetpt'  1   [9 ,1]  33 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX2    ' '09G-COR2H:Curr1' '09G-COR2H:CurrSetpt'  0  '9CY2    ' '09G-COR2V:Curr1' '09G-COR2V:CurrSetpt'  1   [9 ,2]  34 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX3    ' '09G-COR3H:Curr1' '09G-COR3H:CurrSetpt'  1  '9CY3    ' '09G-COR3V:Curr1' '09G-COR3V:CurrSetpt'  0   [9 ,3]  35 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX4    ' '09G-COR4H:Curr1' '09G-COR4H:CurrSetpt'  1  '9CY4    ' '09G-COR4V:Curr1' '09G-COR4V:CurrSetpt'  1   [9 ,4]  36 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain_noshield 0]  [1/HCMGain_noshield 0]  [VCMGain_noshield 0]  [1/VCMGain_noshield 0]; ...
 '10CX1   ' '10G-COR1H:Curr1' '10G-COR1H:CurrSetpt'  1  '10CY1   ' '10G-COR1V:Curr1' '10G-COR1V:CurrSetpt'  1   [10,1]  37 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain_noshield 0]  [1/HCMGain_noshield 0]  [VCMGain_noshield 0]  [1/VCMGain_noshield 0]; ...
 '10CX2   ' '10G-COR2H:Curr1' '10G-COR2H:CurrSetpt'  0  '10CY2   ' '10G-COR2V:Curr1' '10G-COR2V:CurrSetpt'  1   [10,2]  38 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX3   ' '10G-COR3H:Curr1' '10G-COR3H:CurrSetpt'  1  '10CY3   ' '10G-COR3V:Curr1' '10G-COR3V:CurrSetpt'  0   [10,3]  39 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX4   ' '10G-COR4H:Curr1' '10G-COR4H:CurrSetpt'  1  '10CY4   ' '10G-COR4V:Curr1' '10G-COR4V:CurrSetpt'  1   [10,4]  40 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX1   ' '11G-COR1H:Curr1' '11G-COR1H:CurrSetpt'  1  '11CY1   ' '11G-COR1V:Curr1' '11G-COR1V:CurrSetpt'  1   [11,1]  41 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX2   ' '11G-COR2H:Curr1' '11G-COR2H:CurrSetpt'  0  '11CY2   ' '11G-COR2V:Curr1' '11G-COR2V:CurrSetpt'  1   [11,2]  42 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX3   ' '11G-COR3H:Curr1' '11G-COR3H:CurrSetpt'  1  '11CY3   ' '11G-COR3V:Curr1' '11G-COR3V:CurrSetpt'  0   [11,3]  43 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX4   ' '11G-COR4H:Curr1' '11G-COR4H:CurrSetpt'  1  '11CY4   ' '11G-COR4V:Curr1' '11G-COR4V:CurrSetpt'  1   [11,4]  44 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX1   ' '12G-COR1H:Curr1' '12G-COR1H:CurrSetpt'  1  '12CY1   ' '12G-COR1V:Curr1' '12G-COR1V:CurrSetpt'  1   [12,1]  45 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX2   ' '12G-COR2H:Curr1' '12G-COR2H:CurrSetpt'  0  '12CY2   ' '12G-COR2V:Curr1' '12G-COR2V:CurrSetpt'  1   [12,2]  46 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX3   ' '12G-COR3H:Curr1' '12G-COR3H:CurrSetpt'  1  '12CY3   ' '12G-COR3V:Curr1' '12G-COR3V:CurrSetpt'  0   [12,3]  47 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX4   ' '12G-COR4H:Curr1' '12G-COR4H:CurrSetpt'  1  '12CY4   ' '12G-COR4V:Curr1' '12G-COR4V:CurrSetpt'  1   [12,4]  48 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX1   ' '13G-COR1H:Curr1' '13G-COR1H:CurrSetpt'  1  '13CY1   ' '13G-COR1V:Curr1' '13G-COR1V:CurrSetpt'  1   [13,1]  49 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX2   ' '13G-COR2H:Curr1' '13G-COR2H:CurrSetpt'  0  '13CY2   ' '13G-COR2V:Curr1' '13G-COR2V:CurrSetpt'  1   [13,2]  50 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX3   ' '13G-COR3H:Curr1' '13G-COR3H:CurrSetpt'  1  '13CY3   ' '13G-COR3V:Curr1' '13G-COR3V:CurrSetpt'  0   [13,3]  51 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX4   ' '13G-COR4H:Curr1' '13G-COR4H:CurrSetpt'  1  '13CY4   ' '13G-COR4V:Curr1' '13G-COR4V:CurrSetpt'  1   [13,4]  52 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX1   ' '14G-COR1H:Curr1' '14G-COR1H:CurrSetpt'  1  '14CY1   ' '14G-COR1V:Curr1' '14G-COR1V:CurrSetpt'  1   [14,1]  53 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX2   ' '14G-COR2H:Curr1' '14G-COR2H:CurrSetpt'  0  '14CY2   ' '14G-COR2V:Curr1' '14G-COR2V:CurrSetpt'  1   [14,2]  54 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX3   ' '14G-COR3H:Curr1' '14G-COR3H:CurrSetpt'  1  '14CY3   ' '14G-COR3V:Curr1' '14G-COR3V:CurrSetpt'  0   [14,3]  55 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX4   ' '14G-COR4H:Curr1' '14G-COR4H:CurrSetpt'  1  '14CY4   ' '14G-COR4V:Curr1' '14G-COR4V:CurrSetpt'  1   [14,4]  56 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX1   ' '15G-COR1H:Curr1' '15G-COR1H:CurrSetpt'  1  '15CY1   ' '15G-COR1V:Curr1' '15G-COR1V:CurrSetpt'  1   [15,1]  57 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX2   ' '15G-COR2H:Curr1' '15G-COR2H:CurrSetpt'  0  '15CY2   ' '15G-COR2V:Curr1' '15G-COR2V:CurrSetpt'  1   [15,2]  58 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX3   ' '15G-COR3H:Curr1' '15G-COR3H:CurrSetpt'  1  '15CY3   ' '15G-COR3V:Curr1' '15G-COR3V:CurrSetpt'  0   [15,3]  59 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX4   ' '15G-COR4H:Curr1' '15G-COR4H:CurrSetpt'  1  '15CY4   ' '15G-COR4V:Curr1' '15G-COR4V:CurrSetpt'  1   [15,4]  60 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX1   ' '16G-COR1H:Curr1' '16G-COR1H:CurrSetpt'  1  '16CY1   ' '16G-COR1V:Curr1' '16G-COR1V:CurrSetpt'  1   [16,1]  61 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX2   ' '16G-COR2H:Curr1' '16G-COR2H:CurrSetpt'  0  '16CY2   ' '16G-COR2V:Curr1' '16G-COR2V:CurrSetpt'  1   [16,2]  62 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX3   ' '16G-COR3H:Curr1' '16G-COR3H:CurrSetpt'  1  '16CY3   ' '16G-COR3V:Curr1' '16G-COR3V:CurrSetpt'  0   [16,3]  63 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX4   ' '16G-COR4H:Curr1' '16G-COR4H:CurrSetpt'  1  '16CY4   ' '16G-COR4V:Curr1' '16G-COR4V:CurrSetpt'  1   [16,4]  64 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '17CX1   ' '17G-COR1H:Curr1' '17G-COR1H:CurrSetpt'  1  '17CY1   ' '17G-COR1V:Curr1' '17G-COR1V:CurrSetpt'  1   [17,1]  65 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '17CX2   ' '17G-COR2H:Curr1' '17G-COR2H:CurrSetpt'  0  '17CY2   ' '17G-COR2V:Curr1' '17G-COR2V:CurrSetpt'  1   [17,2]  66 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '17CX3   ' '17G-COR3H:Curr1' '17G-COR3H:CurrSetpt'  1  '17CY3   ' '17G-COR3V:Curr1' '17G-COR3V:CurrSetpt'  0   [17,3]  67 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '17CX4   ' '17G-COR4H:Curr1' '17G-COR4H:CurrSetpt'  1  '17CY4   ' '17G-COR4V:Curr1' '17G-COR4V:CurrSetpt'  1   [17,4]  68 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '18CX1   ' '18G-COR1H:Curr1' '18G-COR1H:CurrSetpt'  1  '18CY1   ' '18G-COR1V:Curr1' '18G-COR1V:CurrSetpt'  1   [18,1]  69 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '18CX2   ' '18G-COR2H:Curr1' '18G-COR2H:CurrSetpt'  0  '18CY2   ' '18G-COR2V:Curr1' '18G-COR2V:CurrSetpt'  1   [18,2]  70 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '18CX3   ' '18G-COR3H:Curr1' '18G-COR3H:CurrSetpt'  1  '18CY3   ' '18G-COR3V:Curr1' '18G-COR3V:CurrSetpt'  0   [18,3]  71 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '18CX4   ' '18G-COR4H:Curr1' '18G-COR4H:CurrSetpt'  1  '18CY4   ' '18G-COR4V:Curr1' '18G-COR4V:CurrSetpt'  1   [18,4]  72 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain_noshield 0]  [1/HCMGain_noshield 0]  [VCMGain_noshield 0]  [1/VCMGain_noshield 0]; ...
};


%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, HCMcoefficients] = magnetcoefficients('HCM');
HCMcoefficients = [HCMcoefficients 0];
[C, Leff, MagnetType, VCMcoefficients] = magnetcoefficients('VCM');
VCMcoefficients = [VCMcoefficients 0];

for ii=1:size(cor,1)
name=cor{ii,1};     AO{3}.CommonNames(ii,:)           = name;            
name=cor{ii,3};     AO{3}.Setpoint.ChannelNames(ii,:) = name;     
name=cor{ii,2};     AO{3}.Monitor.ChannelNames(ii,:)  = name;
val =cor{ii,4};     AO{3}.Status(ii,1)                = val;

name=cor{ii,5};     AO{4}.CommonNames(ii,:)           = name;            
name=cor{ii,7};     AO{4}.Setpoint.ChannelNames(ii,:) = name;     
name=cor{ii,6};     AO{4}.Monitor.ChannelNames(ii,:)  = name;
val =cor{ii,8};     AO{4}.Status(ii,1)                = val;

val =cor{ii,9};     AO{3}.DeviceList(ii,:)            = val;
                    AO{4}.DeviceList(ii,:)            = val;
val =cor{ii,10};    AO{3}.ElementList(ii,1)           = val;
                    AO{4}.ElementList(ii,1)           = val;
val =cor{ii,11};    AO{3}.Setpoint.Range(ii,:)        = val;
                    AO{4}.Setpoint.Range(ii,:)        = val;
val =cor{ii,12};    AO{3}.Setpoint.Tolerance(ii,1)    = val;
                    AO{4}.Setpoint.Tolerance(ii,1)    = val;
val =cor{ii,13};    AO{3}.Setpoint.DeltaRespMat(ii,1) = val;
val =cor{ii,14};    AO{4}.Setpoint.DeltaRespMat(ii,1) = val;
val =cor{ii,15};    AO{4}.Setpoint.PhotResp(ii,1)     = val;

AO{3}.Monitor.HW2PhysicsParams{1}(ii,:)  = HCMcoefficients;          
AO{3}.Monitor.Physics2HWParams{1}(ii,:)  = HCMcoefficients;
AO{3}.Setpoint.HW2PhysicsParams{1}(ii,:) = HCMcoefficients;          
AO{3}.Setpoint.Physics2HWParams{1}(ii,:) = HCMcoefficients;

AO{4}.Monitor.HW2PhysicsParams{1}(ii,:)  = VCMcoefficients;          
AO{4}.Monitor.Physics2HWParams{1}(ii,:)  = VCMcoefficients;
AO{4}.Setpoint.HW2PhysicsParams{1}(ii,:) = VCMcoefficients;          
AO{4}.Setpoint.Physics2HWParams{1}(ii,:) = VCMcoefficients;

end

AO{3}.Status=AO{3}.Status(:);
AO{4}.Status=AO{4}.Status(:);


ifam=4;

%============================================================
%CurrReference: Insertion Device Correctors for 'Restore' function
%This only happens on beam lines that use SPEAR 3 correctors
%in addition to or in place of ID trims
%03/15/06 WJC BL 5 horizontal and vertical trims only
%============================================================
%HCMCurrReference
ifam=ifam+1;
AO{ifam}.FamilyName               = 'HCMCurrReference';
AO{ifam}.FamilyType               = 'CorrectorReference';
AO{ifam}.MemberOf                 = {'MachineConfig'; 'PlotFamily'};

AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'radian';

cor={
'BL5_12_3CRH' '12G-COR3H:CurrReference' 1  [12,3] 47
'BL5_12_4CRH' '12G-COR4H:CurrReference' 1  [12,4] 48
'BL5_13_1CRH' '13G-COR1H:CurrReference' 1  [13,1] 49
'BL5_13_3CRH' '13G-COR3H:CurrReference' 1  [13,3] 51
};


for ii=1:size(cor,1)
name=cor{ii,1};     AO{ifam}.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:)  = name;     
val =cor{ii,3};     AO{ifam}.Status(ii,1)                = val;
val =cor{ii,4};     AO{ifam}.DeviceList(ii,:)            = val;
val =cor{ii,5};     AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams(ii,:)  = [1 0];          
AO{ifam}.Monitor.Physics2HWParams(ii,:)  = [1 0];
end

ifam=ifam+1;
AO{ifam}.FamilyName               = 'VCMCurrReference';
AO{ifam}.FamilyType               = 'CorrectorReference';
AO{ifam}.MemberOf                 = {'MachineConfig'; 'PlotFamily'};

AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'radian';

cor={
'BL5_12_2CRV' '12G-COR2V:CurrReference' 1  [12,2] 46
'BL5_12_4CRV' '12G-COR4V:CurrReference' 1  [12,4] 48
'BL5_13_1CRV' '13G-COR1V:CurrReference' 1  [13,1] 49
'BL5_13_2CRV' '13G-COR2V:CurrReference' 1  [13,2] 50
};

for ii=1:size(cor,1)
name=cor{ii,1};     AO{ifam}.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:)  = name;   
val =cor{ii,3};     AO{ifam}.Status(ii,1)                = val;
val =cor{ii,4};     AO{ifam}.DeviceList(ii,:)            = val;
val =cor{ii,5};     AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams(ii,:)  = [1 0];          
AO{ifam}.Monitor.Physics2HWParams(ii,:)  = [1 0];
end

%======================
%Insertion Device Trims
%======================
ifam=ifam+1;
AO{ifam}.FamilyName               = 'IDTrim';
AO{ifam}.FamilyType               = 'IDTrim';
AO{ifam}.MemberOf                 = {'PlotFamily'};

AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'radian';

%note: Field SetpointName is used instead of Setpoint to avoid triggering get/set machineconfig
AO{ifam}.SetpointName.Mode        = Mode;
AO{ifam}.SetpointName.DataType    = 'Scalar';
AO{ifam}.SetpointName.Units       = 'Hardware';
AO{ifam}.SetpointName.HWUnits     = 'ampere';           
AO{ifam}.SetpointName.PhysicsUnits= 'radian';

AO{ifam}.CurrRef.Mode            = Mode;
AO{ifam}.CurrRef.DataType        = 'Scalar';
AO{ifam}.CurrRef.Units           = 'Hardware';
AO{ifam}.CurrRef.HWUnits         = 'ampere';           
AO{ifam}.CurrRef.PhysicsUnits    = 'radian';

% 'ID07_TH '  '05S-ID7TH:Curr1  '    '05S-ID7TH:CurrSetpt  '  '05S-ID7TH:CurrReference  '      1  [5,1]   1
% 'ID07_TO '  '05S-ID7TO:Curr1  '    '05S-ID7TO:CurrSetpt  '  '05S-ID7TO:CurrReference  '      1  [5,2]   2
% 'ID07_TV '  '05S-ID7TV:Curr1  '    '05S-ID7TV:CurrSetpt  '  '05S-ID7TV:CurrReference  '      1  [5,3]   3

idtrim={
'ID10_TH1'  '06S-ID10TH1:Curr1'    '06S-ID10TH1:CurrSetpt'  '06S-ID10TH1:CurrReference'      1  [6,1]   1
'ID10_TH2'  '06S-ID10TH2:Curr1'    '06S-ID10TH2:CurrSetpt'  '06S-ID10TH2:CurrReference'      1  [6,2]   2
'ID09_TH '  '07S-ID9TH:Curr1  '    '07S-ID9TH:CurrSetpt  '  '07S-ID9TH:CurrReference  '      1  [7,1]   3
'ID06_TH '  '11S-ID6TH:Curr1  '    '11S-ID6TH:CurrSetpt  '  '11S-ID6TH:CurrReference  '      1  [11,1]  4
'ID04_TH '  '13S-ID4TH:Curr1  '    '13S-ID4TH:CurrSetpt  '  '13S-ID4TH:CurrReference  '      1  [13,2]  5
'ID04_TV '  '13S-ID4TV:Curr1  '    '13S-ID4TV:CurrSetpt  '  '13S-ID4TV:CurrReference  '      1  [13,2]  6
'ID11_TH '  '15S-ID11TH:Curr1 '    '15S-ID11TH:CurrSetpt '  '15S-ID11TH:CurrReference '      1  [15,1]  7
'ID11_TV '  '15S-ID11TV:Curr1 '    '15S-ID11TV:CurrSetpt '  '15S-ID11TV:CurrReference '      1  [15,2]  8
};

for ii=1:size(idtrim,1)
name=idtrim{ii,1};     AO{ifam}.CommonNames(ii,:)           = name;            
name=idtrim{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:)  = name;     
name=idtrim{ii,3};     AO{ifam}.SetpointName.ChannelNames(ii,:) = name;     
name=idtrim{ii,4};     AO{ifam}.CurrRef.ChannelNames(ii,:)  = name;     
val =idtrim{ii,5};     AO{ifam}.Status(ii,1)                = val;
val =idtrim{ii,6};     AO{ifam}.DeviceList(ii,:)            = val;
val =idtrim{ii,7};     AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams(ii,:) = [1 0];          
AO{ifam}.Monitor.Physics2HWParams(ii,:) = [1 0];
AO{ifam}.CurrRef.HW2PhysicsParams(ii,:) = [1 0];          
AO{ifam}.CurrRef.Physics2HWParams(ii,:) = [1 0];
end

%====================
%Skew Quadrupole data
%====================
%load Setpoints
ifam=ifam+1;
AO{ifam}.FamilyName               = 'SkewQuad';
AO{ifam}.FamilyType               = 'SkewQuad';
AO{ifam}.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'Magnet'; 'SkewQuad';  'MCOR';};

HW2Physics=1.0;
AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'meter^-2';

AO{ifam}.Setpoint.Mode            = Mode;
AO{ifam}.Setpoint.DataType        = 'Scalar';
AO{ifam}.Setpoint.Units           = 'Hardware';
AO{ifam}.Setpoint.HWUnits         = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits    = 'meter^-2';
AO{ifam}.Setpoint.Tolerance       = 1.0;
%ActiveSubset = [4 7 11 19 26 30 33 40 43 47 54 62 66 69];  %symmetric CW or CCW 
%                                                                                                        delta-k
%common         monitor               setpoint         stat devlist elem  scalefactor    range     tol  respkick
sq={
 '1SQ1    '    '01G-QSS1:Curr1' '01G-QSS1:CurrSetpt'    0   [1 ,1]   1        1.0     [-30 , 30]   0.25    0.01; ...
 '1SQ2    '    '01G-QSS2:Curr1' '01G-QSS2:CurrSetpt'    0   [1 ,2]   2        1.0     [-30 , 30]   0.25    0.01; ...
 '1SQ3    '    '01G-QSS3:Curr1' '01G-QSS3:CurrSetpt'    0   [1 ,3]   3        1.0     [-30 , 30]   0.25    0.01; ...
 '1SQ4    '    '01G-QSS4:Curr1' '01G-QSS4:CurrSetpt'    1   [1 ,4]   4        1.0     [-30 , 30]   0.25    0.01; ...
 '2SQ1    '    '02G-QSS1:Curr1' '02G-QSS1:CurrSetpt'    0   [2 ,1]   5        1.0     [-30 , 30]   0.25    0.01; ...
 '2SQ2    '    '02G-QSS2:Curr1' '02G-QSS2:CurrSetpt'    0   [2 ,2]   6        1.0     [-30 , 30]   0.25    0.01; ...
 '2SQ3    '    '02G-QSS3:Curr1' '02G-QSS3:CurrSetpt'    1   [2 ,3]   7        1.0     [-30 , 30]   0.25    0.01; ...
 '2SQ4    '    '02G-QSS4:Curr1' '02G-QSS4:CurrSetpt'    0   [2 ,4]   8        1.0     [-30 , 30]   0.25    0.01; ...
 '3SQ1    '    '03G-QSS1:Curr1' '03G-QSS1:CurrSetpt'    0   [3 ,1]   9        1.0     [-30 , 30]   0.25    0.01; ...
 '3SQ2    '    '03G-QSS2:Curr1' '03G-QSS2:CurrSetpt'    0   [3 ,2]   10       1.0     [-30 , 30]   0.25    0.01; ...
 '3SQ3    '    '03G-QSS3:Curr1' '03G-QSS3:CurrSetpt'    1   [3 ,3]   11       1.0     [-30 , 30]   0.25    0.01; ...
 '3SQ4    '    '03G-QSS4:Curr1' '03G-QSS4:CurrSetpt'    0   [3 ,4]   12       1.0     [-30 , 30]   0.25    0.01; ...
 '4SQ1    '    '04G-QSS1:Curr1' '04G-QSS1:CurrSetpt'    0   [4 ,1]   13       1.0     [-30 , 30]   0.25    0.01; ...
 '4SQ2    '    '04G-QSS2:Curr1' '04G-QSS2:CurrSetpt'    0   [4 ,2]   14       1.0     [-30 , 30]   0.25    0.01; ...
 '4SQ3    '    '04G-QSS3:Curr1' '04G-QSS3:CurrSetpt'    0   [4 ,3]   15       1.0     [-30 , 30]   0.25    0.01; ...
 '4SQ4    '    '04G-QSS4:Curr1' '04G-QSS4:CurrSetpt'    0   [4 ,4]   16       1.0     [-30 , 30]   0.25    0.01; ...
 '5SQ1    '    '05G-QSS1:Curr1' '05G-QSS1:CurrSetpt'    0   [5 ,1]   17       1.0     [-30 , 30]   0.25    0.01; ...
 '5SQ2    '    '05G-QSS2:Curr1' '05G-QSS2:CurrSetpt'    0   [5 ,2]   18       1.0     [-30 , 30]   0.25    0.01; ...
 '5SQ3    '    '05G-QSS3:Curr1' '05G-QSS3:CurrSetpt'    1   [5 ,3]   19       1.0     [-30 , 30]   0.25    0.01; ...
 '5SQ4    '    '05G-QSS4:Curr1' '05G-QSS4:CurrSetpt'    0   [5 ,4]   20       1.0     [-30 , 30]   0.25    0.01; ...
 '6SQ1    '    '06G-QSS1:Curr1' '06G-QSS1:CurrSetpt'    0   [6 ,1]   21       1.0     [-30 , 30]   0.25    0.01; ...
 '6SQ2    '    '06G-QSS2:Curr1' '06G-QSS2:CurrSetpt'    0   [6 ,2]   22       1.0     [-30 , 30]   0.25    0.01; ...
 '6SQ3    '    '06G-QSS3:Curr1' '06G-QSS3:CurrSetpt'    0   [6 ,3]   23       1.0     [-30 , 30]   0.25    0.01; ...
 '6SQ4    '    '06G-QSS4:Curr1' '06G-QSS4:CurrSetpt'    0   [6 ,4]   24       1.0     [-30 , 30]   0.25    0.01; ...
 '7SQ1    '    '07G-QSS1:Curr1' '07G-QSS1:CurrSetpt'    0   [7 ,1]   25       1.0     [-30 , 30]   0.25    0.01; ...
 '7SQ2    '    '07G-QSS2:Curr1' '07G-QSS2:CurrSetpt'    1   [7 ,2]   26       1.0     [-30 , 30]   0.25    0.01; ...
 '7SQ3    '    '07G-QSS3:Curr1' '07G-QSS3:CurrSetpt'    0   [7 ,3]   27       1.0     [-30 , 30]   0.25    0.01; ...
 '7SQ4    '    '07G-QSS4:Curr1' '07G-QSS4:CurrSetpt'    0   [7 ,4]   28       1.0     [-30 , 30]   0.25    0.01; ...
 '8SQ1    '    '08G-QSS1:Curr1' '08G-QSS1:CurrSetpt'    0   [8 ,1]   29       1.0     [-30 , 30]   0.25    0.01; ...
 '8SQ2    '    '08G-QSS2:Curr1' '08G-QSS2:CurrSetpt'    1   [8 ,2]   30       1.0     [-30 , 30]   0.25    0.01; ...
 '8SQ3    '    '08G-QSS3:Curr1' '08G-QSS3:CurrSetpt'    0   [8 ,3]   31       1.0     [-30 , 30]   0.25    0.01; ...
 '8SQ4    '    '08G-QSS4:Curr1' '08G-QSS4:CurrSetpt'    0   [8 ,4]   32       1.0     [-30 , 30]   0.25    0.01; ...
 '9SQ1    '    '09G-QSS1:Curr1' '09G-QSS1:CurrSetpt'    1   [9 ,1]   33       1.0     [-30 , 30]   0.25    0.01; ...
 '9SQ2    '    '09G-QSS2:Curr1' '09G-QSS2:CurrSetpt'    0   [9 ,2]   34       1.0     [-30 , 30]   0.25    0.01; ...
 '9SQ3    '    '09G-QSS3:Curr1' '09G-QSS3:CurrSetpt'    0   [9 ,3]   35       1.0     [-30 , 30]   0.25    0.01; ...
 '9SQ4    '    '09G-QSS4:Curr1' '09G-QSS4:CurrSetpt'    0   [9 ,4]   36       1.0     [-30 , 30]   0.25    0.01; ...
 '10SQ1   '    '10G-QSS1:Curr1' '10G-QSS1:CurrSetpt'    0   [10,1]   37       1.0     [-30 , 30]   0.25    0.01; ...
 '10SQ2   '    '10G-QSS2:Curr1' '10G-QSS2:CurrSetpt'    0   [10,2]   38       1.0     [-30 , 30]   0.25    0.01; ...
 '10SQ3   '    '10G-QSS3:Curr1' '10G-QSS3:CurrSetpt'    0   [10,3]   39       1.0     [-30 , 30]   0.25    0.01; ...
 '10SQ4   '    '10G-QSS4:Curr1' '10G-QSS4:CurrSetpt'    1   [10,4]   40       1.0     [-30 , 30]   0.25    0.01; ...
 '11SQ1   '    '11G-QSS1:Curr1' '11G-QSS1:CurrSetpt'    0   [11,1]   41       1.0     [-30 , 30]   0.25    0.01; ...
 '11SQ2   '    '11G-QSS2:Curr1' '11G-QSS1:CurrSetpt'    0   [11,2]   42       1.0     [-30 , 30]   0.25    0.01; ...
 '11SQ3   '    '11G-QSS3:Curr1' '11G-QSS3:CurrSetpt'    1   [11,3]   43       1.0     [-30 , 30]   0.25    0.01; ...
 '11SQ4   '    '11G-QSS4:Curr1' '11G-QSS4:CurrSetpt'    0   [11,4]   44       1.0     [-30 , 30]   0.25    0.01; ...
 '12SQ1   '    '12G-QSS1:Curr1' '12G-QSS1:CurrSetpt'    0   [12,1]   45       1.0     [-30 , 30]   0.25    0.01; ...
 '12SQ2   '    '12G-QSS2:Curr1' '12G-QSS2:CurrSetpt'    0   [12,2]   46       1.0     [-30 , 30]   0.25    0.01; ...
 '12SQ3   '    '12G-QSS3:Curr1' '12G-QSS3:CurrSetpt'    1   [12,3]   47       1.0     [-30 , 30]   0.25    0.01; ...
 '12SQ4   '    '12G-QSS4:Curr1' '12G-QSS4:CurrSetpt'    0   [12,4]   48       1.0     [-30 , 30]   0.25    0.01; ...
 '13SQ1   '    '13G-QSS1:Curr1' '13G-QSS1:CurrSetpt'    0   [13,1]   49       1.0     [-30 , 30]   0.25    0.01; ...
 '13SQ2   '    '13G-QSS2:Curr1' '13G-QSS2:CurrSetpt'    0   [13,2]   50       1.0     [-30 , 30]   0.25    0.01; ...
 '13SQ3   '    '13G-QSS3:Curr1' '13G-QSS3:CurrSetpt'    0   [13,3]   51       1.0     [-30 , 30]   0.25    0.01; ...
 '13SQ4   '    '13G-QSS4:Curr1' '13G-QSS4:CurrSetpt'    0   [13,4]   52       1.0     [-30 , 30]   0.25    0.01; ...
 '14SQ1   '    '14G-QSS1:Curr1' '14G-QSS1:CurrSetpt'    0   [14,1]   53       1.0     [-30 , 30]   0.25    0.01; ...
 '14SQ2   '    '14G-QSS2:Curr1' '14G-QSS2:CurrSetpt'    1   [14,2]   54       1.0     [-30 , 30]   0.25    0.01; ...
 '14SQ3   '    '14G-QSS3:Curr1' '14G-QSS3:CurrSetpt'    0   [14,3]   55       1.0     [-30 , 30]   0.25    0.01; ...
 '14SQ4   '    '14G-QSS4:Curr1' '14G-QSS4:CurrSetpt'    0   [14,4]   56       1.0     [-30 , 30]   0.25    0.01; ...
 '15SQ1   '    '15G-QSS1:Curr1' '15G-QSS1:CurrSetpt'    0   [15,1]   57       1.0     [-30 , 30]   0.25    0.01; ...
 '15SQ2   '    '15G-QSS2:Curr1' '15G-QSS2:CurrSetpt'    0   [15,2]   58       1.0     [-30 , 30]   0.25    0.01; ...
 '15SQ3   '    '15G-QSS3:Curr1' '15G-QSS3:CurrSetpt'    0   [15,3]   59       1.0     [-30 , 30]   0.25    0.01; ...
 '15SQ4   '    '15G-QSS4:Curr1' '15G-QSS4:CurrSetpt'    0   [15,4]   60       1.0     [-30 , 30]   0.25    0.01; ...
 '16SQ1   '    '16G-QSS1:Curr1' '16G-QSS1:CurrSetpt'    0   [16,1]   61       1.0     [-30 , 30]   0.25    0.01; ...
 '16SQ2   '    '16G-QSS2:Curr1' '16G-QSS2:CurrSetpt'    1   [16,2]   62       1.0     [-30 , 30]   0.25    0.01; ...
 '16SQ3   '    '16G-QSS3:Curr1' '16G-QSS3:CurrSetpt'    0   [16,3]   63       1.0     [-30 , 30]   0.25    0.01; ...
 '16SQ4   '    '16G-QSS4:Curr1' '16G-QSS4:CurrSetpt'    0   [16,4]   64       1.0     [-30 , 30]   0.25    0.01; ...
 '17SQ1   '    '17G-QSS1:Curr1' '17G-QSS1:CurrSetpt'    0   [17,1]   65       1.0     [-30 , 30]   0.25    0.01; ...
 '17SQ2   '    '17G-QSS2:Curr1' '17G-QSS2:CurrSetpt'    1   [17,2]   66       1.0     [-30 , 30]   0.25    0.01; ...
 '17SQ3   '    '17G-QSS3:Curr1' '17G-QSS3:CurrSetpt'    0   [17,3]   67       1.0     [-30 , 30]   0.25    0.01; ...
 '17SQ4   '    '17G-QSS4:Curr1' '17G-QSS4:CurrSetpt'    0   [17,4]   68       1.0     [-30 , 30]   0.25    0.01; ...
 '18SQ1   '    '18G-QSS1:Curr1' '18G-QSS1:CurrSetpt'    1   [18,1]   69       1.0     [-30 , 30]   0.25    0.01; ...
 '18SQ2   '    '18G-QSS2:Curr1' '18G-QSS2:CurrSetpt'    0   [18,2]   70       1.0     [-30 , 30]   0.25    0.01; ...
 '18SQ3   '    '18G-QSS3:Curr1' '18G-QSS3:CurrSetpt'    0   [18,3]   71       1.0     [-30 , 30]   0.25    0.01; ...
 '18SQ4   '    '18G-QSS4:Curr1' '18G-QSS4:CurrSetpt'    0   [18,4]   72       1.0     [-30 , 30]   0.25    0.01; ...
}; 

for ii=1:size(sq,1)
name=sq{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sq{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;     
name=sq{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;
val =sq{ii,4};      AO{ifam}.Status(ii,1)                = val;

val =sq{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =sq{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
val =sq{ii,8};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sq{ii,9};      AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sq{ii,10};     AO{ifam}.Setpoint.DeltaRespMat(ii,1)         = val;

ScaleFactor =sq{ii,7};

AO{ifam}.Monitor.HW2PhysicsParams(ii,:)                  = HW2Physics*ScaleFactor;          
AO{ifam}.Monitor.Physics2HWParams(ii,:)                  = ScaleFactor/HW2Physics;

AO{ifam}.Setpoint.HW2PhysicsParams(ii,:)                 = HW2Physics*ScaleFactor;         
AO{ifam}.Setpoint.Physics2HWParams(ii,:)                 = ScaleFactor/HW2Physics;

end



%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========

% *** BEND ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'BEND';
AO{ifam}.FamilyType                 = 'BEND';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet'; 'Bitbus';};

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;  %@bend2gev;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;  %@gev2bend;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'radian';  %'energy';

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;  %@bend2gev;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;  %@gev2bend;
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'radian';  %'energy';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;  %@bend2gev;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;  %@gev2bend;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'radian';  %'energy';
%                                                                                                        delta-k
%common           desired                   monitor              setpoint           stat devlist elem   scalefactor    range    tol   respkick
bend={
 '1BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [1 ,1]  1         1.0        [0, 500] 0.050   0.05     ; ...
 '1BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [1 ,2]  2         1.0        [0, 500] 0.050   0.05     ; ...
 '2BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [2 ,1]  3         1.0        [0, 500] 0.050   0.05     ; ...
 '2BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [2 ,2]  4         1.0        [0, 500] 0.050   0.05     ; ...
 '3BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [3 ,1]  5         1.0        [0, 500] 0.050   0.05     ; ...
 '3BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [3 ,2]  6         1.0        [0, 500] 0.050   0.05     ; ...
 '4BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [4 ,1]  7         1.0        [0, 500] 0.050   0.05     ; ...
 '4BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [4 ,2]  8         1.0        [0, 500] 0.050   0.05     ; ...
 '5BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [5 ,1]  9         1.0        [0, 500] 0.050   0.05     ; ...
 '5BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [5 ,2]  10        1.0        [0, 500] 0.050   0.05     ; ...
 '6BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [6 ,1]  11        1.0        [0, 500] 0.050   0.05     ; ...
 '6BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [6 ,2]  12        1.0        [0, 500] 0.050   0.05     ; ...
 '7BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [7 ,1]  13        1.0        [0, 500] 0.050   0.05     ; ...
 '7BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [7 ,2]  14        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [8 ,1]  15        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [8 ,2]  16        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [9 ,1]  17        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [9 ,2]  18        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND1    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [10,1]  19        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND2    '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [10,2]  20        1.0        [0, 500] 0.050   0.05     ; ...
 '11BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [11,1]  21        1.0        [0, 500] 0.050   0.05     ; ...
 '11BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [11,2]  22        1.0        [0, 500] 0.050   0.05     ; ...
 '12BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [12,1]  23        1.0        [0, 500] 0.050   0.05     ; ...
 '12BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [12,2]  24        1.0        [0, 500] 0.050   0.05     ; ...
 '13BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [13,1]  25        1.0        [0, 500] 0.050   0.05     ; ...
 '13BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [13,2]  26        1.0        [0, 500] 0.050   0.05     ; ...
 '14BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [14,1]  27        1.0        [0, 500] 0.050   0.05     ; ...
 '14BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [14,2]  28        1.0        [0, 500] 0.050   0.05     ; ...
 '15BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [15,1]  29        1.0        [0, 500] 0.050   0.05     ; ...
 '15BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [15,2]  30        1.0        [0, 500] 0.050   0.05     ; ...
 '16BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [16,1]  31        1.0        [0, 500] 0.050   0.05     ; ...
 '16BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [16,2]  32        1.0        [0, 500] 0.050   0.05     ; ...
 '17BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [17,1]  33        1.0        [0, 500] 0.050   0.05     ; ...
 '17BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [17,2]  34        1.0        [0, 500] 0.050   0.05     ; ...
 '18BEND1   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [18,1]  35        1.0        [0, 500] 0.050   0.05     ; ...
 '18BEND2   '    'MS1-BD:CurrSetptDes '    'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [18,2]  36        1.0        [0, 500] 0.050   0.05     ; ...
};

for ii=1:size(bend,1)
name=bend{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=bend{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=bend{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=bend{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =bend{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =bend{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =bend{ii,7};      AO{ifam}.ElementList(ii,1)           = val;

% The BEND comes in two different lengths
if any(AO{ifam}.DeviceList(ii,1) == [1 9 10 18])
    HW2PhysicsParams = magnetcoefficients('BDM');
    Physics2HWParams = HW2PhysicsParams;
else
    HW2PhysicsParams = magnetcoefficients('BEND');
    Physics2HWParams = HW2PhysicsParams;
end

val =bend{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)                 = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)                = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)                 = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)                 = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)                = val;
val =bend{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =bend{ii,10};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =bend{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;

end



% *** BDM ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'BDM';
AO{ifam}.FamilyType                 = 'COR';
AO{ifam}.MemberOf                   = {'COR'; 'BEND'; 'MCOR';};

HW2PhysicsParams                    = magnetcoefficients('BDM');
Physics2HWParams                    = magnetcoefficients('BDM');

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'radian';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'radian';

%                                                                                                        delta-k
%common           monitor              setpoint           stat devlist  elem scalefactor range     tol   respkick
bdm={ 
 '1bdm1     '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [1  ,1]  1     1.0       [0 500]  0.050   0.25      ; ...
 '1bdm2     '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [1  ,2]  2     1.0       [0 500]  0.050   0.25      ; ...
 '9bdm1     '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [9  ,1]  3     1.0       [0 500]  0.050   0.25      ; ...
 '9bdm2     '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [9  ,2]  4     1.0       [0 500]  0.050   0.25      ; ...
 '10bdm1    '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [10 ,1]  5     1.0       [0 500]  0.050   0.25      ; ...
 '10bdm2    '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [10 ,2]  6     1.0       [0 500]  0.050   0.25      ; ...
 '18bdm1    '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [18 ,1]  7     1.0       [0 500]  0.050   0.25      ; ...
 '18bdm2    '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [18 ,2]  8     1.0       [0 500]  0.050   0.25      ; ...
  }; 

for ii=1:size(bdm,1)
name=bdm{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=bdm{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=bdm{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =bdm{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =bdm{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =bdm{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
val =bdm{ii,7};
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =bdm{ii,8};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =bdm{ii,9};     AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =bdm{ii,10};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)        = val;
end

% *** QF ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QF');
Physics2HWParams                    = magnetcoefficients('QF');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;

AO{ifam}.QMS.Mode                   = 'Special';
AO{ifam}.QMS.DataType               = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet     = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet     = 'getspquad';
AO{ifam}.QMS.HWUnits                = 'ampere';           
AO{ifam}.QMS.Units                  = 'Hardware';
AO{ifam}.QMS.HWUnits                = 'ampere';           
AO{ifam}.QMS.PhysicsUnits           = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn          = @amp2k;
AO{ifam}.QMS.Physics2HWFcn          = @k2amp;

qf1factor= 1/0.9928;
qf2factor= 1/0.9945;
qf1to6factor=0.5* (1/qf1factor   +   1/qf2factor);
qf1to6factor=1/qf1to6factor;
%                                                                                                        delta-k
%common         desired                    monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
qf={
 '2QF1    '    '02G-QF1:CurrSetptDes '    '02G-QF1:Curr    '    '02G-QF1:CurrSetpt  '  1   [2 ,1]    1   qf1factor      [0, 500] 0.050  0.002; ...
 '2QF2    '    '02G-QF2:CurrSetptDes '    '02G-QF2:Curr    '    '02G-QF2:CurrSetpt  '  1   [2 ,2]    2   qf2factor      [0, 500] 0.050  0.002; ...
 '3QF1    '    'MS1-QF:CurrSetptDes  '    'MS1-QF:Curr     '    'MS1-QF:CurrSetpt   '  1   [3 ,1]    3   qf1to6factor   [0, 500] 0.050  0.002; ...
 '3QF2    '    'MS1-QF:CurrSetptDes  '    'MS1-QF:Curr     '    'MS1-QF:CurrSetpt   '  1   [3 ,2]    4   qf1to6factor   [0, 500] 0.050  0.002; ...
 '4QF1    '    'MS1-QF:CurrSetptDes  '    'MS1-QF:Curr     '    'MS1-QF:CurrSetpt   '  1   [4 ,1]    5   qf1to6factor   [0, 500] 0.050  0.002; ...
 '4QF2    '    'MS1-QF:CurrSetptDes  '    'MS1-QF:Curr     '    'MS1-QF:CurrSetpt   '  1   [4 ,2]    6   qf1to6factor   [0, 500] 0.050  0.002; ...
 '5QF1    '    '05G-QF1:CurrSetptDes '    '05G-QF1:Curr    '    '05G-QF1:CurrSetpt  '  1   [5 ,1]    7   qf1factor      [0, 500] 0.050  0.002; ...
 '5QF2    '    '05G-QF2:CurrSetptDes '    '05G-QF2:Curr    '    '05G-QF2:CurrSetpt  '  1   [5 ,2]    8   qf2factor      [0, 500] 0.050  0.002; ...
 '6QF1    '    '06G-QF1:CurrSetptDes '    '06G-QF1:Curr    '    '06G-QF1:CurrSetpt  '  1   [6 ,1]    9   qf1factor      [0, 500] 0.050  0.002; ...
 '6QF2    '    '06G-QF2:CurrSetptDes '    '06G-QF2:Curr    '    '06G-QF2:CurrSetpt  '  1   [6 ,2]    10  qf2factor      [0, 500] 0.050  0.002; ...
 '7QF1    '    '07G-QF1:CurrSetptDes '    '07G-QF1:Curr    '    '07G-QF1:CurrSetpt  '  1   [7 ,1]    11  qf1factor      [0, 500] 0.050  0.002; ...
 '7QF2    '    '07G-QF2:CurrSetptDes '    '07G-QF2:Curr    '    '07G-QF2:CurrSetpt  '  1   [7 ,2]    12  qf2factor      [0, 500] 0.050  0.002; ...
 '8QF1    '    '08G-QF1:CurrSetptDes '    '08G-QF1:Curr    '    '08G-QF1:CurrSetpt  '  1   [8 ,1]    13  qf1factor      [0, 500] 0.050  0.002; ...
 '8QF2    '    '08G-QF2:CurrSetptDes '    '08G-QF2:Curr    '    '08G-QF2:CurrSetpt  '  1   [8 ,2]    14  qf2factor      [0, 500] 0.050  0.002; ...
 '11QF1   '    '11G-QF1:CurrSetptDes '    '11G-QF1:Curr    '    '11G-QF1:CurrSetpt  '  1   [11,1]    15  qf1factor      [0, 500] 0.050  0.002; ...
 '11QF2   '    '11G-QF2:CurrSetptDes '    '11G-QF2:Curr    '    '11G-QF2:CurrSetpt  '  1   [11,2]    16  qf2factor      [0, 500] 0.050  0.002; ...
 '12QF1   '    '12G-QF1:CurrSetptDes '    '12G-QF1:Curr    '    '12G-QF1:CurrSetpt  '  1   [12,1]    17  qf1factor      [0, 500] 0.050  0.002; ...
 '12QF2   '    '12G-QF2:CurrSetptDes '    '12G-QF2:Curr    '    '12G-QF2:CurrSetpt  '  1   [12,2]    18  qf2factor      [0, 500] 0.050  0.002; ...
 '13QF1   '    '13G-QF1:CurrSetptDes '    '13G-QF1:Curr    '    '13G-QF1:CurrSetpt  '  1   [13,1]    19  qf1factor      [0, 500] 0.050  0.002; ...
 '13QF2   '    '13G-QF2:CurrSetptDes '    '13G-QF2:Curr    '    '13G-QF2:CurrSetpt  '  1   [13,2]    20  qf2factor      [0, 500] 0.050  0.002; ...
 '14QF1   '    '14G-QF1:CurrSetptDes '    '14G-QF1:Curr    '    '14G-QF1:CurrSetpt  '  1   [14,1]    21  qf1factor      [0, 500] 0.050  0.002; ...
 '14QF2   '    '14G-QF2:CurrSetptDes '    '14G-QF2:Curr    '    '14G-QF2:CurrSetpt  '  1   [14,2]    22  qf2factor      [0, 500] 0.050  0.002; ...
 '15QF1   '    '15G-QF1:CurrSetptDes '    '15G-QF1:Curr    '    '15G-QF1:CurrSetpt  '  1   [15,1]    23  qf1factor      [0, 500] 0.050  0.002; ...
 '15QF2   '    '15G-QF2:CurrSetptDes '    '15G-QF2:Curr    '    '15G-QF2:CurrSetpt  '  1   [15,2]    24  qf2factor      [0, 500] 0.050  0.002; ...
 '16QF1   '    '16G-QF1:CurrSetptDes '    '16G-QF1:Curr    '    '16G-QF1:CurrSetpt  '  1   [16,1]    25  qf1factor      [0, 500] 0.050  0.002; ...
 '16QF2   '    '16G-QF2:CurrSetptDes '    '16G-QF2:Curr    '    '16G-QF2:CurrSetpt  '  1   [16,2]    26  qf2factor      [0, 500] 0.050  0.002; ...
 '17QF1   '    '17G-QF1:CurrSetptDes '    '17G-QF1:Curr    '    '17G-QF1:CurrSetpt  '  1   [17,1]    27  qf1factor      [0, 500] 0.050  0.002; ...
 '17QF2   '    '17G-QF2:CurrSetptDes '    '17G-QF2:Curr    '    '17G-QF2:CurrSetpt  '  1   [17,2]    28  qf2factor      [0, 500] 0.050  0.002; ...
};

for ii=1:size(qf,1)
name=qf{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qf{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=qf{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qf{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qf{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =qf{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =qf{ii,7};      AO{ifam}.ElementList(ii,1)           = val;
val =qf{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qf{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qf{ii,10};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qf{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** QD ***
ifam=ifam+1;
AO{ifam}.FamilyName               = 'QD';
AO{ifam}.FamilyType               = 'QUAD';
AO{ifam}.MemberOf                 = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'Bitbus';};
HW2PhysicsParams                  = magnetcoefficients('QD');
Physics2HWParams                  = magnetcoefficients('QD');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'meter^-2';
AO{ifam}.Monitor.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn    = @k2amp;

AO{ifam}.Setpoint.Mode            = Mode;
AO{ifam}.Setpoint.DataType        = 'Scalar';
AO{ifam}.Setpoint.Units           = 'Hardware';
AO{ifam}.Setpoint.HWUnits         = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits    = 'meter^-2';
AO{ifam}.Setpoint.HW2PhysicsFcn   = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn   = @k2amp;

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;

qd1factor= 1/0.9835;
qd2factor= 1/0.9795;
qd1to6factor=(qd1factor+qd2factor)/2;
%                                                                                                                                     delta-k
%common         desired                    monitor               setpoint           stat  devlist  elem  scalefactor    range    tol  respkick
qd={
 '2QD1    '    '02G-QD1:CurrSetptDes '    '02G-QD1:Curr    '    '02G-QD1:CurrSetpt  '  1   [2 ,1]    1    qd1factor        [0, 500] 0.050  0.004; ...
 '2QD2    '    '02G-QD2:CurrSetptDes '    '02G-QD2:Curr    '    '02G-QD2:CurrSetpt  '  1   [2 ,2]    2    qd2factor        [0, 500] 0.050  0.004; ...
 '3QD1    '    'MS1-QD:CurrSetptDes  '    'MS1-QD:Curr     '    'MS1-QD:CurrSetpt   '  1   [3 ,1]    3    qd1to6factor     [0, 500] 0.050  0.004; ...
 '3QD2    '    'MS1-QD:CurrSetptDes  '    'MS1-QD:Curr     '    'MS1-QD:CurrSetpt   '  1   [3 ,2]    4    qd1to6factor     [0, 500] 0.050  0.004; ...
 '4QD1    '    'MS1-QD:CurrSetptDes  '    'MS1-QD:Curr     '    'MS1-QD:CurrSetpt   '  1   [4 ,1]    5    qd1to6factor     [0, 500] 0.050  0.004; ...
 '4QD2    '    'MS1-QD:CurrSetptDes  '    'MS1-QD:Curr     '    'MS1-QD:CurrSetpt   '  1   [4 ,2]    6    qd1to6factor     [0, 500] 0.050  0.004; ...
 '5QD1    '    '05G-QD1:CurrSetptDes '    '05G-QD1:Curr    '    '05G-QD1:CurrSetpt  '  1   [5 ,1]    7    qd1factor        [0, 500] 0.050  0.004; ...
 '5QD2    '    '05G-QD2:CurrSetptDes '    '05G-QD2:Curr    '    '05G-QD2:CurrSetpt  '  1   [5 ,2]    8    qd2factor        [0, 500] 0.050  0.004; ...
 '6QD1    '    '06G-QD1:CurrSetptDes '    '06G-QD1:Curr    '    '06G-QD1:CurrSetpt  '  1   [6 ,1]    9    qd1factor        [0, 500] 0.050  0.004; ...
 '6QD2    '    '06G-QD2:CurrSetptDes '    '06G-QD2:Curr    '    '06G-QD2:CurrSetpt  '  1   [6 ,2]    10   qd2factor        [0, 500] 0.050  0.004; ...
 '7QD1    '    '07G-QD1:CurrSetptDes '    '07G-QD1:Curr    '    '07G-QD1:CurrSetpt  '  1   [7 ,1]    11   qd1factor        [0, 500] 0.050  0.004; ...
 '7QD2    '    '07G-QD2:CurrSetptDes '    '07G-QD2:Curr    '    '07G-QD2:CurrSetpt  '  1   [7 ,2]    12   qd2factor        [0, 500] 0.050  0.004; ...
 '8QD1    '    '08G-QD1:CurrSetptDes '    '08G-QD1:Curr    '    '08G-QD1:CurrSetpt  '  1   [8 ,1]    13   qd1factor        [0, 500] 0.050  0.004; ...
 '8QD2    '    '08G-QD2:CurrSetptDes '    '08G-QD2:Curr    '    '08G-QD2:CurrSetpt  '  1   [8 ,2]    14   qd2factor        [0, 500] 0.050  0.004; ...
 '11QD1   '    '11G-QD1:CurrSetptDes '    '11G-QD1:Curr    '    '11G-QD1:CurrSetpt  '  1   [11,1]    15   qd1factor        [0, 500] 0.050  0.004; ...
 '11QD2   '    '11G-QD2:CurrSetptDes '    '11G-QD2:Curr    '    '11G-QD2:CurrSetpt  '  1   [11,2]    16   qd2factor        [0, 500] 0.050  0.004; ...
 '12QD1   '    '12G-QD1:CurrSetptDes '    '12G-QD1:Curr    '    '12G-QD1:CurrSetpt  '  1   [12,1]    17   qd1factor        [0, 500] 0.050  0.004; ...
 '12QD2   '    '12G-QD2:CurrSetptDes '    '12G-QD2:Curr    '    '12G-QD2:CurrSetpt  '  1   [12,2]    18   qd2factor        [0, 500] 0.050  0.004; ...
 '13QD1   '    '13G-QD1:CurrSetptDes '    '13G-QD1:Curr    '    '13G-QD1:CurrSetpt  '  1   [13,1]    19   qd1factor        [0, 500] 0.050  0.004; ...
 '13QD2   '    '13G-QD2:CurrSetptDes '    '13G-QD2:Curr    '    '13G-QD2:CurrSetpt  '  1   [13,2]    20   qd2factor        [0, 500] 0.050  0.004; ...
 '14QD1   '    '14G-QD1:CurrSetptDes '    '14G-QD1:Curr    '    '14G-QD1:CurrSetpt  '  1   [14,1]    21   qd1factor        [0, 500] 0.050  0.004; ...
 '14QD2   '    '14G-QD2:CurrSetptDes '    '14G-QD2:Curr    '    '14G-QD2:CurrSetpt  '  1   [14,2]    22   qd2factor        [0, 500] 0.050  0.004; ...
 '15QD1   '    '15G-QD1:CurrSetptDes '    '15G-QD1:Curr    '    '15G-QD1:CurrSetpt  '  1   [15,1]    23   qd1factor        [0, 500] 0.050  0.004; ...
 '15QD2   '    '15G-QD2:CurrSetptDes '    '15G-QD2:Curr    '    '15G-QD2:CurrSetpt  '  1   [15,2]    24   qd2factor        [0, 500] 0.050  0.004; ...
 '16QD1   '    '16G-QD1:CurrSetptDes '    '16G-QD1:Curr    '    '16G-QD1:CurrSetpt  '  1   [16,1]    25   qd1factor        [0, 500] 0.050  0.004; ...
 '16QD2   '    '16G-QD2:CurrSetptDes '    '16G-QD2:Curr    '    '16G-QD2:CurrSetpt  '  1   [16,2]    26   qd2factor        [0, 500] 0.050  0.004; ...
 '17QD1   '    '17G-QD1:CurrSetptDes '    '17G-QD1:Curr    '    '17G-QD1:CurrSetpt  '  1   [17,1]    27   qd1factor        [0, 500] 0.050  0.004; ...
 '17QD2   '    '17G-QD2:CurrSetptDes '    '17G-QD2:Curr    '    '17G-QD2:CurrSetpt  '  1   [17,2]    28   qd2factor        [0, 500] 0.050  0.004; ...
};   
 
for ii=1:size(qd,1)
name=qd{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qd{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=qd{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qd{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qd{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =qd{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =qd{ii,7};      AO{ifam}.ElementList(ii,1)           = val;
val =qd{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qd{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qd{ii,10};      AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qd{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** QFC ***
ifam=ifam+1;
AO{ifam}.FamilyName               = 'QFC';
AO{ifam}.FamilyType               = 'QUAD';
AO{ifam}.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                  = magnetcoefficients('QFC');
Physics2HWParams                  = magnetcoefficients('QFC');

AO{ifam}.Desired.Mode             = Mode;
AO{ifam}.Desired.DataType         = 'Scalar';
AO{ifam}.Desired.Units            = 'Hardware';
AO{ifam}.Desired.HWUnits          = 'ampere';           
AO{ifam}.Desired.PhysicsUnits     = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Desired.Physics2HWFcn    = @k2amp;

AO{ifam}.Monitor.Mode             = Mode;
AO{ifam}.Monitor.DataType         = 'Scalar';
AO{ifam}.Monitor.Units            = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn    = @k2amp;
AO{ifam}.Monitor.HWUnits          = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits     = 'meter^-2';

AO{ifam}.Setpoint.Mode            = Mode;
AO{ifam}.Setpoint.DataType        = 'Scalar';
AO{ifam}.Setpoint.Units           = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn   = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn   = @k2amp;
AO{ifam}.Setpoint.HWUnits         = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits    = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;
 
%                                                                                                                                    delta-k
%common          desired                monitor                  setpoint           stat  devlist  elem  scalefactor    range   tol  respkick
qfc={
'2QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [2 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'3QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [3 ,1]  2         1.0         [0 500] 0.050   0.05; ... 
'4QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [4 ,1]  3         1.0         [0 500] 0.050   0.05; ... 
'5QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [5 ,1]  4         1.0         [0 500] 0.050   0.05; ... 
'6QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [6 ,1]  5         1.0         [0 500] 0.050   0.05; ... 
'7QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [7 ,1]  6         1.0         [0 500] 0.050   0.05; ...
'8QFC1    '    'MS1-QFC:CurrSetptDes '    'MS1-QFC:Curr    '    'MS1-QFC:CurrSetpt  '  1  [8 ,1]  7         1.0         [0 500] 0.050   0.05; ...
'11QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [11,1]  8         1.0         [0 500] 0.050   0.05; ... 
'12QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [12,1]  9         1.0         [0 500] 0.050   0.05; ...
'13QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [13,1]  10        1.0         [0 500] 0.050   0.05; ...
'14QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [14,1]  11        1.0         [0 500] 0.050   0.05; ...
'15QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [15,1]  12        1.0         [0 500] 0.050   0.05; ... 
'16QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [16,1]  13        1.0         [0 500] 0.050   0.05; ... 
'17QFC2   '    'MS2-QFC:CurrSetptDes '    'MS2-QFC:Curr    '    'MS2-QFC:CurrSetpt  '  1  [17,1]  14        1.0         [0 500] 0.050   0.05; ...
};
 
for ii=1:size(qfc,1)
name=qfc{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qfc{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=qfc{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qfc{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qfc{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =qfc{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =qfc{ii,7};      AO{ifam}.ElementList(ii,1)           = val;
val =qfc{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)                = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)                = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =qfc{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qfc{ii,10};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qfc{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
end


%===============
%Quadrupole data
%===============
% *** QDX ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QDX';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QDX');
Physics2HWParams                    = magnetcoefficients('QDX');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;

qdxfactor= 1/0.9973;
%                                                                                                               delta-k
%common            desired                   monitor               setpoint                 stat devlist elem scalefactor   range   tol     respkick
qdx={ 
 '1QDX1     '    'MS1-QDX:CurrSetptDes  '    'MS1-QDX:Curr     '     'MS1-QDX:CurrSetpt   '  1   [1  ,1]  1   qdxfactor     [0 500]  0.050    0.05; ...
 '9QDX1     '    'MS2-QDX:CurrSetptDes  '    'MS2-QDX:Curr     '     'MS2-QDX:CurrSetpt   '  1   [9  ,1]  2   qdxfactor     [0 500]  0.050    0.05; ...
 '10QDX1    '    'MS2-QDX:CurrSetptDes  '    'MS2-QDX:Curr     '     'MS2-QDX:CurrSetpt   '  1   [10 ,1]  3   qdxfactor     [0 500]  0.050    0.05; ...
 '18QDX1    '    'MS1-QDX:CurrSetptDes  '    'MS1-QDX:Curr     '     'MS1-QDX:CurrSetpt   '  1   [18 ,1]  4   qdxfactor     [0 500]  0.050    0.05; ...
  };

for ii=1:size(qdx,1)
name=qdx{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qdx{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qdx{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qdx{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qdx{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qdx{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qdx{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qdx{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qdx{ii,9};     AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qdx{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qdx{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end


% *** QFX ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QFX';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;
   
qfxfactor=1/0.9984;
%                                                                                                               delta-k
%common              desired                     monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qfx={  
 '1QFX1     '    'MS1-QFX:CurrSetptDes  '    'MS1-QFX:Curr     '     'MS1-QFX:CurrSetpt   '  1   [1  ,1]  1    qfxfactor    [0 500]  0.050    0.05; ...
 '9QFX1     '    'MS2-QFX:CurrSetptDes  '    'MS2-QFX:Curr     '     'MS2-QFX:CurrSetpt   '  1   [9  ,1]  2    qfxfactor    [0 500]  0.050    0.05; ...
 '10QFX1    '    'MS2-QFX:CurrSetptDes  '    'MS2-QFX:Curr     '     'MS2-QFX:CurrSetpt   '  1   [10 ,1]  3    qfxfactor    [0 500]  0.050    0.05; ...
 '18QFX1    '    'MS1-QFX:CurrSetptDes  '    'MS1-QFX:Curr     '     'MS1-QFX:CurrSetpt   '  1   [18 ,1]  4    qfxfactor    [0 500]  0.050    0.05; ...
  };

for ii=1:size(qfx,1)
name=qfx{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qfx{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qfx{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qfx{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qfx{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qfx{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qfx{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qfx{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =qfx{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qfx{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qfx{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end


% *** QDY ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QDY';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QDY');
Physics2HWParams                    = magnetcoefficients('QDY');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;
    
%                                                                                                          delta-k
%common             desired                monitor               setpoint          stat devlist  elem   scalefactor      range   tol  respkick
qdy={ 
 '1QDY1     '    'MS1-QDY:CurrSetptDes  '    'MS1-QDY:Curr     '     'MS1-QDY:CurrSetpt   '  1   [1  ,1]  1     1.0         [0 500]  0.050    0.05; ...
 '9QDY1     '    'MS2-QDY:CurrSetptDes  '    'MS2-QDY:Curr     '     'MS2-QDY:CurrSetpt   '  1   [9  ,1]  2     1.0         [0 500]  0.050    0.05; ...
 '10QDY1    '    'MS2-QDY:CurrSetptDes  '    'MS2-QDY:Curr     '     'MS2-QDY:CurrSetpt   '  1   [10 ,1]  3     1.0         [0 500]  0.050    0.05; ...
 '18QDY1    '    'MS1-QDY:CurrSetptDes  '    'MS1-QDY:Curr     '     'MS1-QDY:CurrSetpt   '  1   [18 ,1]  4     1.0         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qdy,1)
name=qdy{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qdy{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qdy{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qdy{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qdy{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qdy{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qdy{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qdy{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =qdy{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qdy{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qdy{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end


% *** QFY ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QFY';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QFY');
Physics2HWParams                    = magnetcoefficients('QFY');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;

%                                                                                                          delta-k
%common               desired               monitor               setpoint          stat devlist  elem   scalefactor      range   tol  respkick
qfy={ 
 '1QFY1     '    'MS1-QFY:CurrSetptDes  '    'MS1-QFY:Curr     '     'MS1-QFY:CurrSetpt   '  1   [1  ,1]  1     1.0         [0 500]  0.050    0.05; ...
 '9QFY1     '    'MS2-QFY:CurrSetptDes  '    'MS2-QFY:Curr     '     'MS2-QFY:CurrSetpt   '  1   [9  ,1]  2     1.0         [0 500]  0.050    0.05; ...
 '10QFY1    '    'MS2-QFY:CurrSetptDes  '    'MS2-QFY:Curr     '     'MS2-QFY:CurrSetpt   '  1   [10 ,1]  3     1.0         [0 500]  0.050    0.05; ...
 '18QFY1    '    'MS1-QFY:CurrSetptDes  '    'MS1-QFY:Curr     '     'MS1-QFY:CurrSetpt   '  1   [18 ,1]  4     1.0         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qfy,1)
name=qfy{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qfy{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qfy{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qfy{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qfy{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qfy{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qfy{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qfy{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =qfy{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qfy{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qfy{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end


% *** QDZ ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QDZ';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QDZ');
Physics2HWParams                    = magnetcoefficients('QDZ');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;
  
qdzafactor=1/0.9915;
qdzbfactor=1/0.994;
%                                                                                                                 delta-k
%common             desired                     monitor               setpoint              stat devlist elem   scalefactor  range   tol     respkick
qdz={ 
 '1QDZ1     '    'MS1-QDZ:CurrSetptDes  '    'MS1-QDZ:Curr     '     'MS1-QDZ:CurrSetpt   '  1   [1  ,1]  1     qdzafactor  [0 500]  0.050    0.05; ...
 '9QDZ1     '    'MS2-QDZ:CurrSetptDes  '    'MS2-QDZ:Curr     '     'MS2-QDZ:CurrSetpt   '  1   [9  ,1]  2     qdzbfactor  [0 500]  0.050    0.05; ...
 '10QDZ1    '    'MS2-QDZ:CurrSetptDes  '    'MS2-QDZ:Curr     '     'MS2-QDZ:CurrSetpt   '  1   [10 ,1]  3     qdzafactor  [0 500]  0.050    0.05; ...
 '18QDZ1    '    'MS1-QDZ:CurrSetptDes  '    'MS1-QDZ:Curr     '     'MS1-QDZ:CurrSetpt   '  1   [18 ,1]  4     qdzbfactor  [0 500]  0.050    0.05; ...
  };

for ii=1:size(qdz,1)
name=qdz{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qdz{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qdz{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qdz{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qdz{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qdz{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qdz{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qdz{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =qdz{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qdz{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qdz{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end


% *** QFZ ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QFZ';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QFZ');
Physics2HWParams                    = magnetcoefficients('QFZ');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

AO{ifam}.QMS.Mode              = 'Special';
AO{ifam}.QMS.DataType          = 'Scalar';
AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.Units             = 'Hardware';
AO{ifam}.QMS.HWUnits           = 'ampere';           
AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
AO{ifam}.QMS.Physics2HWFcn     = @k2amp;

qfzafactor=1/0.9957;
qfzbfactor=1/0.9935;
%                                                                                                               delta-k
%common               desired                  monitor                   setpoint          stat devlist  elem   scalefactor    range   tol     respkick
qfz={ 
 '1QFZ1     '    'MS1-QFZ:CurrSetptDes  '    'MS1-QFZ:Curr     '     'MS1-QFZ:CurrSetpt   '  1   [1  ,1]  1     qfzafactor    [0 500]  0.050    0.05; ...
 '9QFZ1     '    'MS2-QFZ:CurrSetptDes  '    'MS2-QFZ:Curr     '     'MS2-QFZ:CurrSetpt   '  1   [9  ,1]  2     qfzbfactor    [0 500]  0.050    0.05; ...
 '10QFZ1    '    'MS2-QFZ:CurrSetptDes  '    'MS2-QFZ:Curr     '     'MS2-QFZ:CurrSetpt   '  1   [10 ,1]  3     qfzafactor    [0 500]  0.050    0.05; ...
 '18QFZ1    '    'MS1-QFZ:CurrSetptDes  '    'MS1-QFZ:Curr     '     'MS1-QFZ:CurrSetpt   '  1   [18 ,1]  4     qfzbfactor    [0 500]  0.050    0.05; ...
  };

for ii=1:size(qfz,1)
name=qfz{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qfz{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qfz{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qfz{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qfz{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qfz{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qfz{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qfz{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =qfz{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qfz{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qfz{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end

% *** QDW ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QDW';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'meter^-2';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'meter^-2';

% AO{ifam}.QMS.Mode              = 'Special';
% AO{ifam}.QMS.DataType          = 'Scalar';
% AO{ifam}.QMS.SpecialFunctionSet = 'setspquad';
% AO{ifam}.QMS.SpecialFunctionGet = 'getspquad';
% AO{ifam}.QMS.HWUnits           = 'ampere';           
% AO{ifam}.QMS.Units             = 'Hardware';
% AO{ifam}.QMS.HWUnits           = 'ampere';           
% AO{ifam}.QMS.PhysicsUnits      = 'meter^-2';
% AO{ifam}.QMS.HW2PhysicsFcn     = @amp2k;
% AO{ifam}.QMS.Physics2HWFcn     = @k2amp;

%                                                                                            
%common               desired                  monitor                   setpoint          stat devlist  elem    calib  range    tol     respkick
qdw={ 
 '9QF1     '    '09S-QF1:CurrSetptDes '    '09S-QF1:Curr     '     '09S-QF1:CurrSetpt   '   1   [9  ,1]   1      1.0    [0 500]  0.050    0.05; ...
 '9QD1     '    '09S-QD1:CurrSetptDes '    '09S-QD1:Curr     '     '09S-QD1:CurrSetpt   '   1   [9  ,2]   2      1.0    [0 500]  0.050    0.05; ...
 '9QF2     '    '09S-QF2:CurrSetptDes '    '09S-QF2:Curr     '     '09S-QF2:CurrSetpt   '   1   [9  ,3]   3      1.0    [0 500]  0.050    0.05; ...
  };

for ii=1:size(qdw,1)
name=qdw{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qdw{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=qdw{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qdw{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qdw{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =qdw{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =qdw{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =qdw{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qdw{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qdw{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
end

%load magnet coefficient data for Q34's
HW2PhysicsParams                    = magnetcoefficients('QF');
Physics2HWParams                    = magnetcoefficients('QF');
val =qdw{ii,8};
for ii=[1 3]
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = 1;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1;
end

%load magnet coefficient data for Q60
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');
val =qdw{ii,8};
ii=2;
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = 1;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1;


%===============
%Sextupole data
%===============
% *** SF ***
ifam=ifam+1;
AO{ifam}.FamilyName                = 'SF';
AO{ifam}.FamilyType                = 'SEXT';
AO{ifam}.MemberOf                  = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Chromaticity Corrector'; 'Bitbus';};
HW2PhysicsParams                   = magnetcoefficients('SF');
Physics2HWParams                   = magnetcoefficients('SF');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode              = Mode;
AO{ifam}.Monitor.DataType          = 'Scalar';
AO{ifam}.Monitor.Units             = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn     = @k2amp;
AO{ifam}.Monitor.HWUnits           = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits      = 'meter^-3';

AO{ifam}.Setpoint.Mode             = Mode;
AO{ifam}.Setpoint.DataType         = 'Scalar';
AO{ifam}.Setpoint.Units            = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn    = @k2amp;
AO{ifam}.Setpoint.HWUnits          = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits     = 'meter^-3';

%                                                                                                      delta-k
%common            desired            monitor               setpoint        stat  devlist  elem      scalefactor      range   tol  respkick
sf={
 '2SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [2 ,1]  1          1.0       [0, 500] 0.050   0.75; ...
 '2SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [2 ,2]  2          1.0       [0, 500] 0.050   0.75; ...
 '3SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [3 ,1]  3          1.0       [0, 500] 0.050   0.75; ...
 '3SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [3 ,2]  4          1.0       [0, 500] 0.050   0.75; ...
 '4SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [4 ,1]  5          1.0       [0, 500] 0.050   0.75; ...
 '4SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [4 ,2]  6          1.0       [0, 500] 0.050   0.75; ...
 '5SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [5 ,1]  7          1.0       [0, 500] 0.050   0.75; ...
 '5SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [5 ,2]  8          1.0       [0, 500] 0.050   0.75; ...
 '6SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [6 ,1]  9          1.0       [0, 500] 0.050   0.75; ...
 '6SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [6 ,2]  10         1.0       [0, 500] 0.050   0.75; ...
 '7SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [7 ,1]  11         1.0       [0, 500] 0.050   0.75; ...
 '7SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [7 ,2]  12         1.0       [0, 500] 0.050   0.75; ...
 '8SF1    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [8 ,1]  13         1.0       [0, 500] 0.050   0.75; ...
 '8SF2    '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [8 ,2]  14         1.0       [0, 500] 0.050   0.75; ...
 '11SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [11,1]  15         1.0       [0, 500] 0.050   0.75; ...
 '11SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [11,2]  16         1.0       [0, 500] 0.050   0.75; ...
 '12SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [12,1]  17         1.0       [0, 500] 0.050   0.75; ...
 '12SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [12,2]  18         1.0       [0, 500] 0.050   0.75; ...
 '13SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [13,1]  19         1.0       [0, 500] 0.050   0.75; ...
 '13SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [13,2]  20         1.0       [0, 500] 0.050   0.75; ...
 '14SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [14,1]  21         1.0       [0, 500] 0.050   0.75; ...
 '14SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [14,2]  22         1.0       [0, 500] 0.050   0.75; ...
 '15SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [15,1]  23         1.0       [0, 500] 0.050   0.75; ...
 '15SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [15,2]  24         1.0       [0, 500] 0.050   0.75; ...
 '16SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [16,1]  25         1.0       [0, 500] 0.050   0.75; ...
 '16SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [16,2]  26         1.0       [0, 500] 0.050   0.75; ...
 '17SF1   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [17,1]  27         1.0       [0, 500] 0.050   0.75; ...
 '17SF2   '    'MS1-SF:CurrSetptDes '    'MS1-SF:Curr    '    'MS1-SF:CurrSetpt  '  1   [17,2]  28         1.0       [0, 500] 0.050   0.75; ...
};

for ii=1:size(sf,1)
name=sf{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sf{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=sf{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sf{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sf{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =sf{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =sf{ii,7};      AO{ifam}.ElementList(ii,1)           = val;
val =sf{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sf{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sf{ii,10};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sf{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1)         = val;
end


% *** SD ***
ifam=ifam+1;
AO{ifam}.FamilyName                = 'SD';
AO{ifam}.FamilyType                = 'SEXT';
AO{ifam}.MemberOf                  = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Chromaticity Corrector'; 'Bitbus';};
HW2PhysicsParams                   = magnetcoefficients('SD');
Physics2HWParams                   = magnetcoefficients('SD');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode              = Mode;
AO{ifam}.Monitor.DataType          = 'Scalar';
AO{ifam}.Monitor.Units             = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn     = @k2amp;
AO{ifam}.Monitor.HWUnits           = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits      = 'meter^-3';

AO{ifam}.Setpoint.Mode             = Mode;
AO{ifam}.Setpoint.DataType         = 'Scalar';
AO{ifam}.Setpoint.Units            = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn    = @k2amp;
AO{ifam}.Setpoint.HWUnits          = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits     = 'meter^-3';

              
%                                                                                                      delta-k
%common           desired             monitor               setpoint        stat  devlist  elem  scalefactor    range   tol  respkick
sd={
 '2SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [2 ,1]  1          1.0       [0, 500] 0.050   -0.75; ...
 '2SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [2 ,2]  2          1.0       [0, 500] 0.050   -0.75; ...
 '3SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [3 ,1]  3          1.0       [0, 500] 0.050   -0.75; ...
 '3SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [3 ,2]  4          1.0       [0, 500] 0.050   -0.75; ...
 '4SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [4 ,1]  5          1.0       [0, 500] 0.050   -0.75; ...
 '4SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [4 ,2]  6          1.0       [0, 500] 0.050   -0.75; ...
 '5SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [5 ,1]  7          1.0       [0, 500] 0.050   -0.75; ...
 '5SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [5 ,2]  8          1.0       [0, 500] 0.050   -0.75; ...
 '6SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [6 ,1]  9          1.0       [0, 500] 0.050   -0.75; ...
 '6SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [6 ,2]  10         1.0       [0, 500] 0.050   -0.75; ...
 '7SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [7 ,1]  11         1.0       [0, 500] 0.050   -0.75; ...
 '7SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [7 ,2]  12         1.0       [0, 500] 0.050   -0.75; ...
 '8SD1    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [8 ,1]  13         1.0       [0, 500] 0.050   -0.75; ...
 '8SD2    '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [8 ,2]  14         1.0       [0, 500] 0.050   -0.75; ...
 '11SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [11,1]  15         1.0       [0, 500] 0.050   -0.75; ...
 '11SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [11,2]  16         1.0       [0, 500] 0.050   -0.75; ...
 '12SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [12,1]  17         1.0       [0, 500] 0.050   -0.75; ...
 '12SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [12,2]  18         1.0       [0, 500] 0.050   -0.75; ...
 '13SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [13,1]  19         1.0       [0, 500] 0.050   -0.75; ...
 '13SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [13,2]  20         1.0       [0, 500] 0.050   -0.75; ...
 '14SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [14,1]  21         1.0       [0, 500] 0.050   -0.75; ...
 '14SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [14,2]  22         1.0       [0, 500] 0.050   -0.75; ...
 '15SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [15,1]  23         1.0       [0, 500] 0.050   -0.75; ...
 '15SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [15,2]  24         1.0       [0, 500] 0.050   -0.75; ...
 '16SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [16,1]  25         1.0       [0, 500] 0.050   -0.75; ...
 '16SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [16,2]  26         1.0       [0, 500] 0.050   -0.75; ...
 '17SD1   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [17,1]  27         1.0       [0, 500] 0.050   -0.75; ...
 '17SD2   '    'MS1-SD:CurrSetptDes '    'MS1-SD:Curr    '    'MS1-SD:CurrSetpt  '  1   [17,2]  28         1.0       [0, 500] 0.050   -0.75; ...
};

for ii=1:size(sd,1)
name=sd{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sd{ii,2};      AO{ifam}.Desired.ChannelNames(ii,:)  = name;
name=sd{ii,3};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sd{ii,4};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sd{ii,5};      AO{ifam}.Status(ii,1)                = val;
val =sd{ii,6};      AO{ifam}.DeviceList(ii,:)            = val;
val =sd{ii,7};      AO{ifam}.ElementList(ii,1)           = val;
val =sd{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sd{ii,9};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sd{ii,10};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sd{ii,11};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
end



% *** SFM ***
ifam=ifam+1;
AO{ifam}.FamilyName                = 'SFM';
AO{ifam}.FamilyType                = 'SEXT';
AO{ifam}.MemberOf                  = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                   = magnetcoefficients('SFM');
Physics2HWParams                   = magnetcoefficients('SFM');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode              = Mode;
AO{ifam}.Monitor.DataType          = 'Scalar';
AO{ifam}.Monitor.Units             = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn     = @k2amp;
AO{ifam}.Monitor.HWUnits           = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits      = 'meter^-3';

AO{ifam}.Setpoint.Mode             = Mode;
AO{ifam}.Setpoint.DataType         = 'Scalar';
AO{ifam}.Setpoint.Units            = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn    = @k2amp;
AO{ifam}.Setpoint.HWUnits          = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits     = 'meter^-3';

%                                                                                                             delta-k
%common            desired                monitor                setpoint              stat devlist elem    scalefactor    range   tol  respkick
sfm={ 
 '1SFM1     '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [1  ,1]  1          1.0      [0 500]  0.050   0.75; ...
 '1SFM2     '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [1  ,2]  2          1.0      [0 500]  0.050   0.75; ...
 '9SFM1     '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [9  ,1]  3          1.0      [0 500]  0.050   0.75; ...
 '9SFM2     '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [9  ,2]  4          1.0      [0 500]  0.050   0.75; ...
 '10SFM1    '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [10 ,1]  5          1.0      [0 500]  0.050   0.75; ...
 '10SFM2    '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [10 ,2]  6          1.0      [0 500]  0.050   0.75; ...
 '18SFM1    '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [18 ,1]  7          1.0      [0 500]  0.050   0.75; ...
 '18SFM2    '    'MS1-SFM:CurrSetptDes  '    'MS1-SFM:Curr     '     'MS1-SFM:CurrSetpt   '  1   [18 ,2]  8          1.0      [0 500]  0.050   0.75; ...
  };

for ii=1:size(sfm,1)
name=sfm{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sfm{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=sfm{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sfm{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sfm{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =sfm{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =sfm{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =sfm{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =sfm{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sfm{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sfm{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)        = val;
end


% *** SDM ***
ifam=ifam+1;
AO{ifam}.FamilyName                = 'SDM';
AO{ifam}.FamilyType                = 'SEXT';
AO{ifam}.MemberOf                  = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                   = magnetcoefficients('SDM');
Physics2HWParams                   = magnetcoefficients('SDM');

AO{ifam}.Desired.Mode               = Mode;
AO{ifam}.Desired.DataType           = 'Scalar';
AO{ifam}.Desired.Units              = 'Hardware';
AO{ifam}.Desired.HWUnits            = 'ampere';           
AO{ifam}.Desired.PhysicsUnits       = 'meter^-2';
AO{ifam}.Desired.HW2PhysicsFcn      = @amp2k;
AO{ifam}.Desired.Physics2HWFcn      = @k2amp;

AO{ifam}.Monitor.Mode              = Mode;
AO{ifam}.Monitor.DataType          = 'Scalar';
AO{ifam}.Monitor.Units             = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn     = @amp2k;
AO{ifam}.Monitor.Physics2HWFcn     = @k2amp;
AO{ifam}.Monitor.HWUnits           = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits      = 'meter^-3';

AO{ifam}.Setpoint.Mode             = Mode;
AO{ifam}.Setpoint.DataType         = 'Scalar';
AO{ifam}.Setpoint.Units            = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn    = @amp2k;
AO{ifam}.Setpoint.Physics2HWFcn    = @k2amp;
AO{ifam}.Setpoint.HWUnits          = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits     = 'meter^-3';
%                                                                                                         delta-k
%common              desired              monitor                 setpoint             stat  devlist elem   scalefactor   range  tol  respkick
sdm={ 
 '1SDM1     '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [1  ,1]  1          1.0     [0 500]  0.050   -0.75; ...
 '1SDM2     '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [1  ,2]  2          1.0     [0 500]  0.050   -0.75; ...
 '9SDM1     '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [9  ,1]  3          1.0     [0 500]  0.050   -0.75; ...
 '9SDM2     '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [9  ,2]  4          1.0     [0 500]  0.050   -0.75; ...
 '10SDM1    '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [10 ,1]  5          1.0     [0 500]  0.050   -0.75; ...
 '10SDM2    '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [10 ,2]  6          1.0     [0 500]  0.050   -0.75; ...
 '18SDM1    '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [18 ,1]  7          1.0     [0 500]  0.050   -0.75; ...
 '18SDM2    '    'MS1-SDM:CurrSetptDes  '    'MS1-SDM:Curr     '     'MS1-SDM:CurrSetpt   '  1   [18 ,2]  8          1.0     [0 500]  0.050   -0.75; ...
  };

for ii=1:size(sdm,1)
name=sdm{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sdm{ii,2};     AO{ifam}.Desired.ChannelNames(ii,:) = name; 
name=sdm{ii,3};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sdm{ii,4};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sdm{ii,5};     AO{ifam}.Status(ii,1)               = val;
val =sdm{ii,6};     AO{ifam}.DeviceList(ii,:)           = val;
val =sdm{ii,7};     AO{ifam}.ElementList(ii,1)          = val;
val =sdm{ii,8};
AO{ifam}.Desired.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Desired.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Desired.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Desired.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =sdm{ii,9};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sdm{ii,10};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sdm{ii,11};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)        = val;
end


% *** Kicker Amplitude ***
ifam=ifam+1;
AO{ifam}.FamilyName                     = 'KickerAmp';
AO{ifam}.FamilyType                     = 'KickerAmp';
AO{ifam}.MemberOf                       = {'Injection'};

AO{ifam}.Monitor.Mode                   = Mode;
AO{ifam}.Monitor.DataType               = 'Scalar';
AO{ifam}.Monitor.Units                  = 'Hardware';
AO{ifam}.Monitor.HWUnits                = 'DAC';           
AO{ifam}.Monitor.PhysicsUnits           = 'mradian';

AO{ifam}.Setpoint.Mode                  = Mode;
AO{ifam}.Setpoint.DataType              = 'Scalar';
AO{ifam}.Setpoint.Units                 = 'Hardware';
AO{ifam}.Setpoint.HWUnits               = 'DAC';           
AO{ifam}.Setpoint.PhysicsUnits          = 'mradian';

%common        monitor                  setpoint                stat  devlist elem range    tol
kickeramp={ 
 'K1     '    '02S-K1:PulseAmpl  '     '02S-K1:PulseAmplSetpt  '  1   [2  ,1]  1  [0 9]  0.10 ; ...
 'K2     '    '03S-K2:PulseAmpl  '     '03S-K2:PulseAmplSetpt  '  1   [3  ,1]  2  [0 9]  0.10 ; ...
 'K3     '    '04S-K3:PulseAmpl  '     '04S-K3:PulseAmplSetpt  '  1   [4  ,1]  3  [0 9]  0.10 ; ...
  };

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =kickeramp{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =kickeramp{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =kickeramp{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
val =kickeramp{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =kickeramp{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)   = val;


end


k1hw2physics=1/8691;
k2hw2physics=1/17171;
k3hw2physics=1/8691;
AO{ifam}.Monitor.HW2PhysicsParams(1,:)    = [k1hw2physics 0];     
AO{ifam}.Monitor.Physics2HWParams(1,:)    = [1/k1hw2physics 0];
AO{ifam}.Setpoint.HW2PhysicsParams(1,:)   = [k1hw2physics 0];         
AO{ifam}.Setpoint.Physics2HWParams(1,:)   = [1/k1hw2physics 0];
AO{ifam}.Monitor.HW2PhysicsParams(2,:)    = [k2hw2physics 0];          
AO{ifam}.Monitor.Physics2HWParams(2,:)    = [1/k2hw2physics 0];
AO{ifam}.Setpoint.HW2PhysicsParams(2,:)   = [k2hw2physics 0];         
AO{ifam}.Setpoint.Physics2HWParams(2,:)   = [1/k2hw2physics 0];
AO{ifam}.Monitor.HW2PhysicsParams(3,:)    = [k3hw2physics 0];          
AO{ifam}.Monitor.Physics2HWParams(3,:)    = [1/k3hw2physics 0];
AO{ifam}.Setpoint.HW2PhysicsParams(3,:)   = [k3hw2physics 0];         
AO{ifam}.Setpoint.Physics2HWParams(3,:)   = [1/k3hw2physics 0];


% *** Kicker Delay ***
ifam=ifam+1;
AO{ifam}.FamilyName                     = 'KickerDelay';
AO{ifam}.FamilyType                     = 'KickerDelay';
AO{ifam}.MemberOf                       = {'Injection'};

AO{ifam}.Monitor.Mode                   = Mode;
AO{ifam}.Monitor.DataType               = 'Scalar';
AO{ifam}.Monitor.Units                  = 'Hardware';
AO{ifam}.Monitor.HWUnits                = 'volts';           
AO{ifam}.Monitor.PhysicsUnits           = 'radian';

AO{ifam}.Setpoint.Mode                  = Mode;
AO{ifam}.Setpoint.DataType              = 'Scalar';
AO{ifam}.Setpoint.Units                 = 'Hardware';
AO{ifam}.Setpoint.HWUnits               = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits          = 'radian';

%common        monitor                  setpoint                  stat  devlist elem range tol
kickeramp={ 
 'K1     '    '02S-K1:PulseDelay  '     '02S-K1:PulseDelaySetpt  '  1   [2  ,1]  1  [0 9]  0.10 ; ...
 'K2     '    '03S-K2:PulseDelay  '     '03S-K2:PulseDelaySetpt  '  1   [3  ,1]  2  [0 9]  0.10 ; ...
 'K3     '    '04S-K3:PulseDelay  '     '04S-K3:PulseDelaySetpt  '  1   [4  ,1]  3  [0 9]  0.10 ; ...
  };

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =kickeramp{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =kickeramp{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =kickeramp{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
val =kickeramp{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =kickeramp{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)   = val;

AO{ifam}.Monitor.HW2PhysicsParams(ii,:)    = [1 0];          
AO{ifam}.Monitor.Physics2HWParams(ii,:)    = [1 0];
AO{ifam}.Setpoint.HW2PhysicsParams(ii,:)   = [1 0];         
AO{ifam}.Setpoint.Physics2HWParams(ii,:)   = [1 0];

end


% Convert to new format
AO = cell2field(AO);


%============
%RF System
%============
AO.RF.FamilyName                  = 'RF';
AO.RF.FamilyType                  = 'RF';
AO.RF.MemberOf                    = {'MachineConfig'; 'PlotFamily';  'RF'; 'RFSystem'};
AO.RF.Status                      = 1;
AO.RF.CommonNames                 = 'RF';
AO.RF.DeviceList                  = [1 1];
AO.RF.ElementList                 = [1];

%Frequency Readback
AO.RF.Monitor.Mode                = Mode;
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+6;       %no hw2physics function necessary   
AO.RF.Monitor.Physics2HWParams    = 1e-6;
AO.RF.Monitor.HWUnits             = 'MHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';
AO.RF.Monitor.ChannelNames        = 'SPEAR:RFFreqSetpt';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = 'SPEAR:RFFreqSetpt';     
AO.RF.Setpoint.Range              = [0 2500];
AO.RF.Setpoint.Tolerance          = 100.0;

%Voltage control
AO.RF.VoltageCtrl.Mode               = Mode;
AO.RF.VoltageCtrl.DataType           = 'Scalar';
AO.RF.VoltageCtrl.Units              = 'Hardware';
AO.RF.VoltageCtrl.HW2PhysicsParams   = 1;         
AO.RF.VoltageCtrl.Physics2HWParams   = 1;
AO.RF.VoltageCtrl.HWUnits            = 'Volts';           
AO.RF.VoltageCtrl.PhysicsUnits       = 'Volts';
AO.RF.VoltageCtrl.ChannelNames       = 'SRF1:STN:VOLT:CTRL';     
AO.RF.VoltageCtrl.Range              = [-inf inf];
AO.RF.VoltageCtrl.Tolerance          = inf;

%Voltage monitor
AO.RF.Voltage.Mode               = Mode;
AO.RF.Voltage.DataType           = 'Scalar';
AO.RF.Voltage.Units              = 'Hardware';
AO.RF.Voltage.HW2PhysicsParams   = 1;         
AO.RF.Voltage.Physics2HWParams   = 1;
AO.RF.Voltage.HWUnits            = 'kV';           
AO.RF.Voltage.PhysicsUnits       = 'kV';
AO.RF.Voltage.ChannelNames       = 'SRF1:STN:VOLT';     %UNITS ARE KILOVOLTS JC 10/9/04
AO.RF.Voltage.Range              = [-inf inf];
AO.RF.Voltage.Tolerance          = inf;

%Power Control
AO.RF.PowerCtrl.Mode               = Mode;
AO.RF.PowerCtrl.DataType           = 'Scalar';
AO.RF.PowerCtrl.Units              = 'Hardware';
AO.RF.PowerCtrl.HW2PhysicsParams   = 1;         
AO.RF.PowerCtrl.Physics2HWParams   = 1;
AO.RF.PowerCtrl.HWUnits            = 'MWatts';           
AO.RF.PowerCtrl.PhysicsUnits       = 'MWatts';
AO.RF.PowerCtrl.ChannelNames       = 'SRF1:KLYSDRIVFRWD:POWER:ON';     
AO.RF.PowerCtrl.Range              = [-inf inf];
AO.RF.PowerCtrl.Tolerance          = inf;

%Power Monitor
AO.RF.Power.Mode               = Mode;
AO.RF.Power.DataType           = 'Scalar';
AO.RF.Power.Units              = 'Hardware';
AO.RF.Power.HW2PhysicsParams   = 1;         
AO.RF.Power.Physics2HWParams   = 1;
AO.RF.Power.HWUnits            = 'MWatts';           
AO.RF.Power.PhysicsUnits       = 'MWatts';
AO.RF.Power.ChannelNames       = 'SRF1:KLYSDRIVFRWD:POWER';     
AO.RF.Power.Range              = [-inf inf];
AO.RF.Power.Tolerance          = inf;

%Station Phase Control
AO.RF.PhaseCtrl.Mode               = Mode;
AO.RF.PhaseCtrl.DataType           = 'Scalar';
AO.RF.PhaseCtrl.Units              = 'Hardware';
AO.RF.PhaseCtrl.HW2PhysicsParams   = 1;         
AO.RF.PhaseCtrl.Physics2HWParams   = 1;
AO.RF.PhaseCtrl.HWUnits            = 'Degrees';           
AO.RF.PhaseCtrl.PhysicsUnits       = 'Degrees';
AO.RF.PhaseCtrl.ChannelNames       = 'SRF1:STN:PHASE';     
AO.RF.PhaseCtrl.Range              = [-200 200];
AO.RF.PhaseCtrl.Tolerance          = inf;

%Station Phase Monitor
AO.RF.Phase.Mode               = Mode;
AO.RF.Phase.DataType           = 'Scalar';
AO.RF.Phase.Units              = 'Hardware';
AO.RF.Phase.HW2PhysicsParams   = 1;         
AO.RF.Phase.Physics2HWParams   = 1;
AO.RF.Phase.HWUnits            = 'Degrees';           
AO.RF.Phase.PhysicsUnits       = 'Degrees';
AO.RF.Phase.ChannelNames       = 'SRF1:STN:PHASE:CALC';     
AO.RF.Phase.Range              = [-200 200];
AO.RF.Phase.Tolerance          = inf;

%Klystron Forward Power
AO.RF.KlysPower.Mode               = Mode;
AO.RF.KlysPower.DataType           = 'Scalar';
AO.RF.KlysPower.Units              = 'Hardware';
AO.RF.KlysPower.HW2PhysicsParams   = 1;         
AO.RF.KlysPower.Physics2HWParams   = 1;
AO.RF.KlysPower.HWUnits            = 'MWatts';           
AO.RF.KlysPower.PhysicsUnits       = 'MWatts';
AO.RF.KlysPower.ChannelNames       = 'SRF1:KLYSOUTFRWD:POWER';     
AO.RF.KlysPower.Range              = [-inf inf];
AO.RF.KlysPower.Tolerance          = inf;


%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.FamilyType  = 'Diagnostic';
AO.TUNE.MemberOf    = {'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';

AO.TUNE.Monitor.Mode                   = 'Manual'; %'Simulator';  % Mode;
AO.TUNE.Monitor.DataType               = 'Vector';
AO.TUNE.Monitor.DataTypeIndex          = [1 2 3];
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';


%====
%DCCT
%====
ifam=ifam+1;
AO.DCCT.FamilyName                     = 'DCCT';
AO.DCCT.FamilyType                     = 'Diagnostic';
AO.DCCT.MemberOf                       = {'Diagnostics'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = [1]';
AO.DCCT.Status                         = AO.DCCT.ElementList;

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = 'SPEAR:BeamCurrAvg';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;


%===============================
%Quadrupole Shunt Supply Current
%===============================
AO.ShuntCurrent.FamilyName                     = 'ShuntCurrent';
AO.ShuntCurrent.FamilyType                     = 'Diagnostic';
AO.ShuntCurrent.MemberOf                       = {'QMS'; 'Diagnostics'};

AO.ShuntCurrent.CommonNames                    = 'ShuntCurrent';
AO.ShuntCurrent.DeviceList                     = [1 1];
AO.ShuntCurrent.ElementList                    = 1;
AO.ShuntCurrent.Status=AO.ShuntCurrent.ElementList;

AO.ShuntCurrent.Monitor.Mode                   = Mode;
AO.ShuntCurrent.Monitor.DataType               = 'Scalar';
AO.ShuntCurrent.Monitor.ChannelNames           = 'ShuntCurrent';    %Hz
AO.ShuntCurrent.Monitor.Units                  = 'Hardware';
AO.ShuntCurrent.Monitor.HWUnits                = 'ampere';           
AO.ShuntCurrent.Monitor.PhysicsUnits           = 'm-2';
AO.ShuntCurrent.Monitor.HW2PhysicsParams       = 1;          
AO.ShuntCurrent.Monitor.Physics2HWParams       = 1;

AO.ShuntCurrent.Setpoint.Mode                  = Mode;
AO.ShuntCurrent.Setpoint.DataType              = 'Scalar';
AO.ShuntCurrent.Setpoint.ChannelNames          = 'ShuntCurrent';
AO.ShuntCurrent.Setpoint.Units                 = 'Hardware';
AO.ShuntCurrent.Setpoint.HWUnits               = 'ampere';           
AO.ShuntCurrent.Setpoint.PhysicsUnits          = 'm-2';
AO.ShuntCurrent.Setpoint.HW2PhysicsParams      = 1;          
AO.ShuntCurrent.Setpoint.Physics2HWParams      = 1;


%===============================
%Quadrupole Shunt Supply Relay
%===============================
AO.ShuntRelay.FamilyName                     = 'ShuntRelay';
AO.ShuntRelay.FamilyType                     = 'Diagnostic';
AO.ShuntRelay.MemberOf                       = {'QMS'; 'Diagnostics'};

AO.ShuntRelay.CommonNames                    = 'ShuntRelay';
AO.ShuntRelay.DeviceList                     = [1 1];
AO.ShuntRelay.ElementList                    = [1]';
AO.ShuntRelay.Status                         = AO.ShuntRelay.ElementList;

AO.ShuntRelay.Monitor.Mode                   = Mode;
AO.ShuntRelay.Monitor.DataType               = 'Scalar';
AO.ShuntRelay.Monitor.ChannelNames           = '118-QMS:ChanSelect';    
AO.ShuntRelay.Monitor.Units                  = 'Hardware';
AO.ShuntRelay.Monitor.HWUnits                = 'quadrupole number';           
AO.ShuntRelay.Monitor.PhysicsUnits           = 'quadrupole number';
AO.ShuntRelay.Monitor.HW2PhysicsParams       = 1;          
AO.ShuntRelay.Monitor.Physics2HWParams       = 1;

AO.ShuntRelay.Setpoint.Mode                  = Mode;
AO.ShuntRelay.Setpoint.DataType              = 'Scalar';
AO.ShuntRelay.Setpoint.ChannelNames          = '118-QMS:ChanSelect';
AO.ShuntRelay.Setpoint.Units                 = 'Hardware';
AO.ShuntRelay.Setpoint.HWUnits               = 'quadrupole number';           
AO.ShuntRelay.Setpoint.PhysicsUnits          = 'quadrupole number';
AO.ShuntRelay.Setpoint.HW2PhysicsParams      = 1;          
AO.ShuntRelay.Setpoint.Physics2HWParams      = 1;


%==================
%Machine Parameters
%==================
AO.MachineParameters.FamilyName                = 'MachineParameters';
AO.MachineParameters.FamilyType                = 'Parameter';
AO.MachineParameters.MemberOf                  = {'Diagnostics'};
AO.MachineParameters.Status                    = [1 1 1 1]';

AO.MachineParameters.Monitor.Mode              = Mode;
AO.MachineParameters.Monitor.DataType          = 'Scalar';
AO.MachineParameters.Monitor.Units             = 'Hardware';

%use spear2 process variable names
mp={
'mode    '    'SPEAR:BeamStatus  '          [1 1]  1; ...
'energy  '    'SPEAR:Energy      '          [1 2]  2; ...
'current '    'SPEAR:BeamCurrAvg '          [1 3]  3; ...
'lifetime'    'SPEAR:BeamLifetime'          [1 4]  4; ...
};
AO.MachineParameters.Monitor.HWUnits          = ' ';           
AO.MachineParameters.Monitor.PhysicsUnits     = ' ';

AO.MachineParameters.Setpoint.HWUnits         = ' ';           
AO.MachineParameters.Setpoint.PhysicsUnits    = ' ';

for ii=1:size(mp,1)
    name  =mp(ii,1);    AO.MachineParameters.CommonNames(ii,:)            = char(name{1}); 
    name  =mp(ii,2);    AO.MachineParameters.Monitor.ChannelNames(ii,:)   = char(name{1});
    name  =mp(ii,2);    AO.MachineParameters.Setpoint.ChannelNames(ii,:)  = char(name{1});
    val   =mp(ii,3);    AO.MachineParameters.DeviceList(ii,:)             = val{1};
    val   =mp(ii,4);    AO.MachineParameters.ElementList(ii,:)            = val{1};
    
    AO.MachineParameters.Monitor.HW2PhysicsParams(ii,:)    = 1;          
    AO.MachineParameters.Monitor.Physics2HWParams(ii,:)    = 1;
    AO.MachineParameters.Setpoint.HW2PhysicsParams(ii,:)   = 1;         
    AO.MachineParameters.Setpoint.Physics2HWParams(ii,:)   = 1;
end


%======
%Septum
%======
AO.Septum.FamilyName                  = 'Septum';
AO.Septum.FamilyType                  = 'Septum';
AO.Septum.MemberOf                    = {'PlotFamily'; 'Injection'};
AO.Septum.Status                      = 1;

AO.Septum.CommonNames                 = 'Septum  ';
AO.Septum.DeviceList                  = [3 1];
AO.Septum.ElementList                 = [1];

AO.Septum.Monitor.Mode                = Mode;
AO.Septum.Monitor.DataType            = 'Scalar';
AO.Septum.Monitor.Units               = 'Hardware';
AO.Septum.Monitor.HWUnits             = 'ampere';           
AO.Septum.Monitor.PhysicsUnits        = 'radian';
AO.Septum.Monitor.ChannelNames        = 'BTS-B9V:Curr';     

AO.Septum.Setpoint.Mode               = Mode;
AO.Septum.Setpoint.DataType           = 'Scalar';
AO.Septum.Setpoint.Units              = 'Hardware';
AO.Septum.Setpoint.HWUnits            = 'ampere';           
AO.Septum.Setpoint.PhysicsUnits       = 'radian';
AO.Septum.Setpoint.ChannelNames       = 'BTS-B9V:CurrSetpt';    
AO.Septum.Setpoint.Range              = [0, 2500];
AO.Septum.Setpoint.Tolerance          = 100.0;

AO.Septum.Monitor.HW2PhysicsParams    = 1;          
AO.Septum.Monitor.Physics2HWParams    = 1;
AO.Septum.Setpoint.HW2PhysicsParams   = 1;         
AO.Septum.Setpoint.Physics2HWParams   = 1;


%===================
% Ion Gauge Pressure 
%===================
AO.IonGauge.FamilyName = 'IonGauge';
AO.IonGauge.FamilyType = 'IonGauge';
AO.IonGauge.MemberOf   = {'PlotFamily'; 'IonGauge'; 'Vacuum';};
AO.IonGauge.Status     = 1;
AO.IonGauge.DeviceList = [ ...
        1 1
        1 2
        2 1
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
        5 1
        5 2
        5 3
        6 1
        6 2
        6 3
        7 1
        7 2
        7 3
        7 4
        8 1
        8 2
        9 1
        9 2
        10 1
        10 2
        11 1
        11 2
        12 1
        12 2
        12 3
        13 1
        13 2
        13 3
        14 1
        14 2
        14 3
        14 4
        14 5
        14 6
        14 7
        14 8
        14 9
        15 1
        15 2
        16 1
        16 2
        17 1
        18 1
        18 2
        18 3 ];
AO.IonGauge.ElementList = (1:55)';
AO.IonGauge.Monitor.Mode         = Mode;
AO.IonGauge.Monitor.DataType     = 'Scalar';
AO.IonGauge.Monitor.Units        = 'Hardware';
AO.IonGauge.Monitor.HWUnits      = 'Torr';           
AO.IonGauge.Monitor.PhysicsUnits = 'Torr';
AO.IonGauge.Monitor.ChannelNames = [];
for i = 1:length(AO.IonGauge.ElementList)
    AO.IonGauge.Monitor.ChannelNames = strvcat(AO.IonGauge.Monitor.ChannelNames, sprintf('spr:VG%02d/AM1',AO.IonGauge.ElementList(i)));
end
AO.IonGauge.Monitor.HW2PhysicsParams = 1;          
AO.IonGauge.Monitor.Physics2HWParams = 1;
% The Positions here are a cluge
AO.IonGauge.Position = 234.1440 * (1:length(AO.IonGauge.ElementList))' / length(AO.IonGauge.ElementList);


%==================
% Ion Pump Pressure 
%==================
AO.IonPump.FamilyName = 'IonPump';
AO.IonPump.FamilyType = 'IonPump';
AO.IonPump.MemberOf   = {'PlotFamily'; 'IonPump'; 'Vacuum';};
AO.IonPump.Status     = ones(28,1);
%AO.IonPump.Status([14 21 28]) = 0;
AO.IonPump.DeviceList = [ ...
        1 1
        1 2
        2 1
        2 2
        3 1
        3 2
        4 1
        5 1
        5 2
        6 1
        6 2
        7 1
        7 2
        8 1
        9 1
        9 2
        10 1
        10 2
        11 1
        11 2
        12 1
        13 1
        13 2
        14 1
        14 2
        15 1
        15 2
        16 1
];
AO.IonPump.ElementList = (1:28)';
AO.IonPump.Monitor.Mode         = Mode;
AO.IonPump.Monitor.DataType     = 'Scalar';
AO.IonPump.Monitor.Units        = 'Hardware';
AO.IonPump.Monitor.HWUnits      = 'mircoAmp';           
AO.IonPump.Monitor.PhysicsUnits = 'mircoAmp';
AO.IonPump.Monitor.ChannelNames = [];
for i = 1:28
    AO.IonPump.Monitor.ChannelNames = strvcat(AO.IonPump.Monitor.ChannelNames, sprintf('spr:VP%02d/AM1',i));
end
%AO.IonPump.Monitor.ChannelNames([6 27],:) = [];
AO.IonPump.Monitor.HW2PhysicsParams = 1;          
AO.IonPump.Monitor.Physics2HWParams = 1;
% The Positions here are a cluge
AO.IonPump.Position = 234.1440 * (1:length(AO.IonPump.ElementList))' / length(AO.IonPump.ElementList);



%====================
%Photon Beamline Data
%====================

insdevGapsPV = {'spr:ID04M1/AM1';'spr:ID05M1/AM1';'spr:ID06M1/AM1';'spr:ID07M1/AM1';'spr:ID09M1/AM1';'spr:ID10M1/AM1';'spr:ID11M1/AM1'};
insdevTrimsPV  = {'05S-ID7TH:CurrSetpt'; '05S-ID7TO:CurrSetpt'; '05S-ID7TV:CurrSetpt';...
                     '06S-ID10TH1:CurrSetpt'; '06S-ID10TH2:CurrSetpt';...
                     '07S-ID9TH:CurrSetpt';...
                     '11S-ID6TH:CurrSetpt';...
                     '12S-ID5TH1:CurrSetpt'; '12S-ID5TH2:CurrSetpt';...
                     '13S-ID4TH:CurrSetpt';  '13S-ID4TV:CurrSetpt';...
                     '15S-ID11TH:CurrSetpt'; '15S-ID11TV:CurrSetpt'};
             
%Name    status   openpv             sumpv           errorpv        normpv      devlist  elemlist  type   upstream bpm       dBPM       BLLength
bl={
'BL1 '     0     'BL01:OpenState'   'BL01-BPM1:S'   'BL01-BPM1:V' 'BL01-BPM1:N'  [1 1 ]     1     'DIPOLE'   [4  2]       0.0000000000   10.0; ...
'BL2 '     0     'BL02:OpenState'   'BL02-BPM1:S'   'BL02-BPM1:V' 'BL02-BPM1:N'  [1 2 ]     2     'DIPOLE'   [5  2]       0.0000000000   10.0; ...
'BL3 '     0     'BL03:OpenState'   'BL03-BPM1:S'   'BL03-BPM1:V' 'BL03-BPM1:N'  [1 3 ]     3     'DIPOLE'   [14 6]       0.0000000000   10.0; ...
'BL4 '     0     'BL04:OpenState'   'BL04-BPM1:S'   'BL04-BPM1:V' 'BL04-BPM1:N'  [1 4 ]     4     'ID    '   [13 6]       2.8118680000   10.0; ...
'BL5 '     0     'BL05:OpenState'   'BL05-BPM1:S'   'BL05-BPM1:V' 'BL05-BPM1:N'  [1 5 ]     5     'ID    '   [12 6]       2.8118680000   10.0; ...
'BL6 '     0     'BL06:OpenState'   'BL06-BPM1:S'   'BL06-BPM1:V' 'BL06-BPM1:N'  [1 6 ]     6     'ID    '   [11 6]       2.8118680000   10.0; ...
'BL7 '     0     'BL07:OpenState'   'BL07-BPM1:S'   'BL07-BPM1:V' 'BL07-BPM1:N'  [1 7 ]     7     'ID    '   [5  6]       2.8118680000   10.0; ...
'BL8 '     0     'BL08:OpenState'   'BL08-BPM1:S'   'BL08-BPM1:V' 'BL08-BPM1:N'  [1 8 ]     8     'DIPOLE'   [7  2]       0.0000000000   10.0; ...
'BL9 '     1     'BL09:OpenState'   'BL09-BPM1:S'   'BL09-BPM1:V' 'BL09-BPM1:N'  [1 9 ]     9     'ID    '   [7  6]       2.8118680000   10.0; ...
'BL10'     0     'BL10:OpenState'   'BL10-BPM1:S'   'BL10-BPM1:V' 'BL10-BPM1:N'  [1 10]    10     'ID    '   [6  6]       2.8118680000   10.0; ...
'BL11'     0     'BL11:OpenState'   'BL11-BPM1:S'   'BL11-BPM1:V' 'BL11-BPM1:N'  [1 11]    11     'ID    '   [15 6]       2.8118680000   10.0; ...
};
% NOTE: dBPM=distance between ID BPMs. To compute dBPM (1) s=findspos('BPMy') (2) s(2:end)-s(1:end-1)
% NOTE: BLLength=distance from source point to photon BPM
%Photon Beamline Open Signal
AO.BLOpen.FamilyName                     = 'BLOpen';
AO.BLOpen.FamilyType                     = 'Beamline';
AO.BLOpen.MemberOf                       = {'PlotFamily'; 'Beamlines'};
AO.BLOpen.Monitor.Mode                   = 'ONLINE';
AO.BLOpen.Monitor.DataType               = 'Scalar';
AO.BLOpen.Monitor.Units                  = 'Hardware';
AO.BLOpen.Monitor.HWUnits                = 'open';           
AO.BLOpen.Monitor.PhysicsUnits           = 'open';

for ii=1:size(bl,1) 
name=bl{ii,1};     AO.BLOpen.CommonNames(ii,:)                  = name;     
stat=bl{ii,2};     AO.BLOpen.Status(ii,1)                       = stat;
name=bl{ii,3};     AO.BLOpen.Monitor.ChannelNames(ii,:)         = name; 
val =bl{ii,7};     AO.BLOpen.DeviceList(ii,:)                   = val;
val =bl{ii,8};     AO.BLOpen.ElementList(ii,1)                  = val;
type=bl{ii,9};     AO.BLOpen.BLType(ii,:)                       = type;     
AO.BLOpen.Monitor.HW2PhysicsParams(ii,:) = 1;          
AO.BLOpen.Monitor.Physics2HWParams(ii,:) = 1;
end

%Photon Beamline Sum Signal
AO.BLSum.FamilyName                     = 'BLSum';
AO.BLSum.FamilyType                     = 'Beamline';
AO.BLSum.MemberOf                       = {'PlotFamily'; 'Beamlines'};
AO.BLSum.Monitor.Mode                   = 'ONLINE';
AO.BLSum.Monitor.DataType               = 'Scalar';
AO.BLSum.Monitor.Units                  = 'Hardware';
AO.BLSum.Monitor.HWUnits                = 'au';           
AO.BLSum.Monitor.PhysicsUnits           = 'au';

for ii=1:size(bl,1) 
name=bl{ii,1};     AO.BLSum.CommonNames(ii,:)                  = name;            
stat=bl{ii,2};     AO.BLSum.Status(ii,1)                       = stat;
name=bl{ii,4};     AO.BLSum.Monitor.ChannelNames(ii,:)         = name; 
val =bl{ii,7};     AO.BLSum.DeviceList(ii,:)                   = val;
val =bl{ii,8};     AO.BLSum.ElementList(ii,1)                  = val;
type=bl{ii,9};     AO.BLSum.BLType(ii,:)                       = type;     

AO.BLSum.Monitor.HW2PhysicsParams(ii,:) = 1;          
AO.BLSum.Monitor.Physics2HWParams(ii,:) = 1;
end

%Photon Beamline Error Signal
AO.BLErr.FamilyName                     = 'BLErr';
AO.BLErr.FamilyType                     = 'Beamline';
AO.BLErr.MemberOf                       = {'PlotFamily'; 'Beamlines'};
AO.BLErr.Monitor.Mode                   = 'ONLINE';
AO.BLErr.Monitor.DataType               = 'Scalar';
AO.BLErr.Monitor.Units                  = 'Hardware';
AO.BLErr.Monitor.HWUnits                = 'au';           
AO.BLErr.Monitor.PhysicsUnits           = 'au';


% Save the AO so that dev2elem will work
setao(AO);

for ii=1:size(bl,1) 
name=bl{ii,1};     AO.BLErr.CommonNames(ii,:)                  = name;            
stat=bl{ii,2};     AO.BLErr.Status(ii,1)                       = stat;
name=bl{ii,5};     AO.BLErr.Monitor.ChannelNames(ii,:)         = name; 
val =bl{ii,7};     AO.BLErr.DeviceList(ii,:)                   = val;
val =bl{ii,8};     AO.BLErr.ElementList(ii,1)                  = val;
type=bl{ii,9};     AO.BLErr.BLType(ii,:)                       = type;     
val =bl{ii,10};    AO.BLErr.UpstreamBPM(ii,:)                  = dev2elem('BPMy',val);
val =bl{ii,11};    AO.BLErr.dBPM(ii,1)                         = val;
val =bl{ii,12};    AO.BLErr.BLLength(ii,1)                     = val;

AO.BLErr.Monitor.HW2PhysicsParams(ii,:) = 1;          
AO.BLErr.Monitor.Physics2HWParams(ii,:) = 1;
end

%====================
%BPLD Data
%====================
%Name            channel       status    devlist   elemlist  chan beamline      up-bpm  down-bpm  alt-bpm   dBPM     x     xp       y    yp       xalt   yalt
bpld={
'CH01'   'OrbInt:Ch01BpldState'  1       [1 1 ]       1       1  'none  '      [ 1  7]   [ 2  1]  [ 1  4]    4.500   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH02'   'OrbInt:Ch02BpldState'  1       [1 2 ]       2       2  'none  '      [ 2  6]   [ 3  1]  [ 2  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH03'   'OrbInt:Ch03BpldState'  1       [1 3 ]       3       3  'BL1   '      [ 3  6]   [ 4  1]  [ 3  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH04'   'OrbInt:Ch04BpldState'  1       [1 4 ]       4       4  'BL2   '      [ 4  6]   [ 5  1]  [ 4  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH05'   'OrbInt:Ch05BpldState'  1       [1 5 ]       5       5  'BL7   '      [ 5  6]   [ 6  1]  [ 5  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH06'   'OrbInt:Ch06BpldState'  1       [1 6 ]       6       6  'BL8/10'      [ 6  6]   [ 7  1]  [ 6  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH07'   'OrbInt:Ch07BpldState'  1       [1 7 ]       7       7  'BL9   '      [ 7  6]   [ 8  1]  [ 7  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH08'   'OrbInt:Ch08BpldState'  1       [1 8 ]       8       8  'none  '      [ 8  6]   [ 9  1]  [ 8  4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH09'   'OrbInt:Ch09BpldState'  1       [1 9 ]       9       9  'BL12  '      [ 9  4]   [ 9  7]  [10  1]    5.952   3.0   1.00     1.00  0.33     1.0    1.0; ...
'CH10'   'OrbInt:Ch10BpldState'  1       [1 10]      10       10 'none  '      [10  7]   [11  1]  [ 10 4]    4.500   4.7   0.70    1.16  0.36     1.0    1.0; ...
'CH11'   'OrbInt:Ch11BpldState'  1       [1 11]      11       11 'BL6   '      [11  6]   [12  1]  [ 11 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH12'   'OrbInt:Ch12BpldState'  1       [1 12]      12       12 'BL5   '      [12  6]   [13  1]  [ 12 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH13'   'OrbInt:Ch13BpldState'  1       [1 13]      13       13 'BL3/4 '      [13  6]   [14  1]  [ 13 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH14'   'OrbInt:Ch14BpldState'  1       [1 14]      14       14 'none  '      [14  6]   [15  1]  [ 14 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH15'   'OrbInt:Ch15BpldState'  1       [1 15]      15       15 'BL11  '      [15  6]   [16  1]  [ 15 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH16'   'OrbInt:Ch16BpldState'  1       [1 16]      16       16 'none  '      [16  6]   [17  1]  [ 16 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH17'   'OrbInt:Ch17BpldState'  1       [1 17]      17       17 'none  '      [17  6]   [18  1]  [ 17 4]    2.812   4.7   1.10    1.16  0.36     1.0    1.0; ...
'CH18'   'OrbInt:Ch18BpldState'  1       [1 18]      18       18 'none  '      [18  7]   [ 1  1]  [ 18 4]    4.500   4.7   1.10    1.16  0.36     1.0    1.0; ...
};
%BPLD
AO.BPLD.FamilyName                     = 'BPLD';
AO.BPLD.FamilyType                     = 'BPLD';
AO.BPLD.MemberOf                       = {'Beamlines'; 'Interlock'};
AO.BPLD.Monitor.Mode                   = 'ONLINE';
AO.BPLD.Monitor.DataType               = 'Scalar';
AO.BPLD.Monitor.Units                  = 'Hardware';
AO.BPLD.Monitor.HWUnits                = 'mm';           
AO.BPLD.Monitor.PhysicsUnits           = 'mm';

for ii=1:size(bpld,1) 
name=bpld{ii,1};     AO.BPLD.CommonNames(ii,:)                  = name;     
name=bpld{ii,2};     AO.BPLD.Monitor.ChannelNames(ii,:)         = name;
stat=bpld{ii,3};     AO.BPLD.Status(ii,1)                       = stat;
val =bpld{ii,4};     AO.BPLD.DeviceList(ii,:)                   = val;
val =bpld{ii,5};     AO.BPLD.ElementList(ii,1)                  = val;
val =bpld{ii,6};     AO.BPLD.Channel(ii,1)                      = val;
name=bpld{ii,7};     AO.BPLD.Beamline(ii,:)                     = name;     
val =bpld{ii,8};     AO.BPLD.UpStreamBPM(ii,:)                  = val;
val =bpld{ii,9};     AO.BPLD.DownStreamBPM(ii,:)                = val;
val =bpld{ii,10};    AO.BPLD.AltBPM(ii,:)                       = val;   %alternate BPM in case one BPM fails
val =bpld{ii,11};    AO.BPLD.dBPM(ii,1)                         = val;
val =bpld{ii,12};    AO.BPLD.x(ii,1)                            = val;
val =bpld{ii,13};    AO.BPLD.xp(ii,1)                           = val;
val =bpld{ii,14};    AO.BPLD.y(ii,1)                            = val;
val =bpld{ii,15};    AO.BPLD.yp(ii,1)                           = val;
val =bpld{ii,16};    AO.BPLD.xalt(ii,1)                         = val;   %alternate BPM limit in case one BPM fails
val =bpld{ii,17};    AO.BPLD.yalt(ii,1)                         = val;
AO.BPLD.Monitor.HW2PhysicsParams(ii,:)                          = 1;          
AO.BPLD.Monitor.Physics2HWParams(ii,:)                          = 1;
end


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(1);



%Machine Parameters (I'm not sure where this are used - Greg)
AO = getao;
AO.MachineParameters.AT.ATType = 'MachineParameters';
AO.MachineParameters.AT.ATName(1,:) = 'Energy  ';
AO.MachineParameters.AT.ATName(2,:) = 'Current ';
AO.MachineParameters.AT.ATName(3,:) = 'Lifetime';
setao(AO);



% Response matrix kick size must be in hardware units.
% Since they were set in physics units, they must be converted.
% Note #1: The AO must be setup for the BEND family for physics2hw to work
% Note #2: This is being done in simulate mode so that the BEND will not be
%          accessed to get the energy.  This can be problem when the BEND is 
%          not online or not at the proper setpoint
ModeBEND = getmode('BEND', 'Setpoint');
setfamilydata('Simulator', 'BEND', 'Monitor', 'Mode');
setfamilydata('Simulator', 'BEND', 'Setpoint', 'Mode');
AO = getao;
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList);
AO.VCM.Setpoint.PhotResp     = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.PhotResp,     AO.VCM.DeviceList);
AO.QF.Setpoint.DeltaRespMat  = physics2hw('QF', 'Setpoint', AO.QF.Setpoint.DeltaRespMat,  AO.QF.DeviceList);
AO.QD.Setpoint.DeltaRespMat  = physics2hw('QD', 'Setpoint', AO.QD.Setpoint.DeltaRespMat,  AO.QD.DeviceList);
AO.QFC.Setpoint.DeltaRespMat = physics2hw('QFC','Setpoint', AO.QFC.Setpoint.DeltaRespMat, AO.QFC.DeviceList);
AO.QFX.Setpoint.DeltaRespMat = physics2hw('QFX','Setpoint', AO.QFX.Setpoint.DeltaRespMat, AO.QFX.DeviceList);
AO.QFY.Setpoint.DeltaRespMat = physics2hw('QFY','Setpoint', AO.QFY.Setpoint.DeltaRespMat, AO.QFY.DeviceList);
AO.QFZ.Setpoint.DeltaRespMat = physics2hw('QFZ','Setpoint', AO.QFZ.Setpoint.DeltaRespMat, AO.QFZ.DeviceList);
AO.QDX.Setpoint.DeltaRespMat = physics2hw('QDX','Setpoint', AO.QDX.Setpoint.DeltaRespMat, AO.QDX.DeviceList);
AO.QDY.Setpoint.DeltaRespMat = physics2hw('QDY','Setpoint', AO.QDY.Setpoint.DeltaRespMat, AO.QDY.DeviceList);
AO.QDZ.Setpoint.DeltaRespMat = physics2hw('QDZ','Setpoint', AO.QDZ.Setpoint.DeltaRespMat, AO.QDZ.DeviceList);
%AO.QDW.Setpoint.DeltaRespMat = physics2hw('QDW','Setpoint', AO.QDW.Setpoint.DeltaRespMat, AO.QDW.DeviceList);
AO.SF.Setpoint.DeltaRespMat  = physics2hw('SF', 'Setpoint', AO.SF.Setpoint.DeltaRespMat,  AO.SF.DeviceList);
AO.SD.Setpoint.DeltaRespMat  = physics2hw('SD', 'Setpoint', AO.SD.Setpoint.DeltaRespMat,  AO.SD.DeviceList);
AO.SFM.Setpoint.DeltaRespMat = physics2hw('SFM','Setpoint', AO.SFM.Setpoint.DeltaRespMat, AO.SFM.DeviceList);
AO.SDM.Setpoint.DeltaRespMat = physics2hw('SDM','Setpoint', AO.SDM.Setpoint.DeltaRespMat, AO.SDM.DeviceList);
AO.SkewQuad.Setpoint.DeltaRespMat = physics2hw('SkewQuad', 'Setpoint', AO.SkewQuad.Setpoint.DeltaRespMat, AO.SkewQuad.DeviceList);
setao(AO);  % setfamilydata works on the saved AO
setfamilydata(ModeBEND, 'BEND', 'Monitor', 'Mode');
setfamilydata(ModeBEND, 'BEND', 'Setpoint', 'Mode');

