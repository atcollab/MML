function albainit
% Initialize parameters for ALBA control in MATLAB
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
% Handles               monitor handle
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
% Handles               setpoint handle
% 
%=============================================  
% Accelerator Toolbox Simulation Fields
%=============================================
% ATType                Quad, Sext, etc
% ATIndex               index in THERING
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
%    QF
%    QD
%    SF
%    SD

Mode = 'SIMULATOR';


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
 '1BPM2   '    '01G-BPM2:U   '  1  '1BPM2   '    '01G-BPM2:V   '  1  [1 ,2]    2    'E'    ; ...
 '1BPM3   '    '01G-BPM3:U   '  1  '1BPM3   '    '01G-BPM3:V   '  1  [1 ,3]    3    'E'    ; ...
 '1BPM4   '    '01G-BPM4:U   '  1  '1BPM4   '    '01G-BPM4:V   '  1  [1 ,4]    4    'B'    ; ...
 '1BPM5   '    '01G-BPM5:U   '  1  '1BPM5   '    '01G-BPM5:V   '  1  [1 ,5]    5    'E'    ; ...
 '1BPM6   '    '01G-BPM6:U   '  1  '1BPM6   '    '01G-BPM6:V   '  1  [1 ,6]    6    'E'    ; ...
 '1BPM7   '    '01G-BPM7:U   '  1  '1BPM7   '    '01G-BPM7:V   '  1  [1 ,7]    7    'B'    ; ...
 '2BPM1   '    '02G-BPM1:U   '  1  '2BPM1   '    '02G-BPM1:V   '  1  [2 ,1]    8    'B'    ; ...
 '2BPM2   '    '02G-BPM2:U   '  1  '2BPM2   '    '02G-BPM2:V   '  1  [2 ,2]    9    'E'    ; ...
 '2BPM3   '    '02G-BPM3:U   '  1  '2BPM3   '    '02G-BPM3:V   '  1  [2 ,3]    10   'E'    ; ...
 '2BPM4   '    '02G-BPM4:U   '  1  '2BPM4   '    '02G-BPM4:V   '  1  [2 ,4]    11   'B'    ; ...
 '2BPM5   '    '02G-BPM5:U   '  1  '2BPM5   '    '02G-BPM5:V   '  1  [2 ,5]    12   'E'    ; ...
 '2BPM6   '    '02G-BPM6:U   '  1  '2BPM6   '    '02G-BPM6:V   '  1  [2 ,6]    13   'B'    ; ...
 '2BPM7   '    '02G-BPM7:U   '  1  '2BPM7   '    '02G-BPM7:V   '  1  [2 ,7]    14   'B'    ; ...
 '3BPM1   '    '03G-BPM1:U   '  1  '3BPM1   '    '03G-BPM1:V   '  1  [3 ,1]    15   'B'    ; ...
 '3BPM2   '    '03G-BPM2:U   '  1  '3BPM2   '    '03G-BPM2:V   '  1  [3 ,2]    16   'E'    ; ...
 '3BPM3   '    '03G-BPM3:U   '  1  '3BPM3   '    '03G-BPM3:V   '  1  [3 ,3]    17   'E'    ; ...
 '3BPM4   '    '03G-BPM4:U   '  1  '3BPM4   '    '03G-BPM4:V   '  1  [3 ,4]    18   'B'    ; ...
 '3BPM5   '    '03G-BPM5:U   '  1  '3BPM5   '    '03G-BPM5:V   '  1  [3 ,5]    19   'E'    ; ...
 '3BPM6   '    '03G-BPM6:U   '  1  '3BPM6   '    '03G-BPM6:V   '  1  [3 ,6]    20   'B'    ; ...
 '3BPM7   '    '03G-BPM7:U   '  1  '3BPM7   '    '03G-BPM7:V   '  1  [3 ,7]    21   'B'    ; ...
 '4BPM1   '    '04G-BPM1:U   '  1  '4BPM1   '    '04G-BPM1:V   '  1  [4 ,1]    22   'B'    ; ...
 '4BPM2   '    '04G-BPM2:U   '  1  '4BPM2   '    '04G-BPM2:V   '  1  [4 ,2]    23   'E'    ; ...
 '4BPM3   '    '04G-BPM3:U   '  1  '4BPM3   '    '04G-BPM3:V   '  1  [4 ,3]    24   'E'    ; ...
 '4BPM4   '    '04G-BPM4:U   '  1  '4BPM4   '    '04G-BPM4:V   '  1  [4 ,4]    25   'B'    ; ...
 '4BPM5   '    '04G-BPM5:U   '  1  '4BPM5   '    '04G-BPM5:V   '  1  [4 ,5]    26   'E'    ; ...
 '4BPM6   '    '04G-BPM6:U   '  1  '4BPM6   '    '04G-BPM6:V   '  1  [4 ,6]    27   'B'    ; ...
 '4BPM7   '    '04G-BPM7:U   '  1  '4BPM7   '    '04G-BPM7:V   '  1  [4 ,7]    28   'B'    ; ...
 '5BPM1   '    '05G-BPM1:U   '  1  '5BPM1   '    '05G-BPM1:V   '  1  [5 ,1]    29   'B'    ; ...
 '5BPM2   '    '05G-BPM2:U   '  1  '5BPM2   '    '05G-BPM2:V   '  1  [5 ,2]    30   'E'    ; ...
 '5BPM3   '    '05G-BPM3:U   '  1  '5BPM3   '    '05G-BPM3:V   '  1  [5 ,3]    31   'E'    ; ...
 '5BPM4   '    '05G-BPM4:U   '  1  '5BPM4   '    '05G-BPM4:V   '  1  [5 ,4]    32   'B'    ; ...
 '5BPM5   '    '05G-BPM5:U   '  1  '5BPM5   '    '05G-BPM5:V   '  1  [5 ,5]    33   'E'    ; ...
 '5BPM6   '    '05G-BPM6:U   '  1  '5BPM6   '    '05G-BPM6:V   '  1  [5 ,6]    34   'B'    ; ...
 '5BPM7   '    '05G-BPM7:U   '  1  '5BPM7   '    '05G-BPM7:V   '  1  [5 ,7]    35   'B'    ; ...
 '6BPM1   '    '06G-BPM1:U   '  1  '6BPM1   '    '06G-BPM1:V   '  1  [6 ,1]    36   'B'    ; ...
 '6BPM2   '    '06G-BPM2:U   '  1  '6BPM2   '    '06G-BPM2:V   '  1  [6 ,2]    37   'E'    ; ...
 '6BPM3   '    '06G-BPM3:U   '  1  '6BPM3   '    '06G-BPM3:V   '  1  [6 ,3]    38   'E'    ; ...
 '6BPM4   '    '06G-BPM4:U   '  1  '6BPM4   '    '06G-BPM4:V   '  1  [6 ,4]    39   'B'    ; ...
 '6BPM5   '    '06G-BPM5:U   '  1  '6BPM5   '    '06G-BPM5:V   '  1  [6 ,5]    40   'E'    ; ...
 '6BPM6   '    '06G-BPM6:U   '  1  '6BPM6   '    '06G-BPM6:V   '  1  [6 ,6]    41   'B'    ; ...
 '6BPM7   '    '06G-BPM7:U   '  1  '6BPM7   '    '06G-BPM7:V   '  1  [6 ,7]    42   'B'    ; ...
 '7BPM1   '    '07G-BPM1:U   '  1  '7BPM1   '    '07G-BPM1:V   '  1  [7 ,1]    43   'B'    ; ...
 '7BPM2   '    '07G-BPM2:U   '  1  '7BPM2   '    '07G-BPM2:V   '  1  [7 ,2]    44   'E'    ; ...
 '7BPM3   '    '07G-BPM3:U   '  1  '7BPM3   '    '07G-BPM3:V   '  1  [7 ,3]    45   'E'    ; ...
 '7BPM4   '    '07G-BPM4:U   '  1  '7BPM4   '    '07G-BPM4:V   '  1  [7 ,4]    46   'B'    ; ...
 '7BPM5   '    '07G-BPM5:U   '  1  '7BPM5   '    '07G-BPM5:V   '  1  [7 ,5]    47   'E'    ; ...
 '7BPM6   '    '07G-BPM6:U   '  1  '7BPM6   '    '07G-BPM6:V   '  1  [7 ,6]    48   'B'    ; ...
 '7BPM7   '    '07G-BPM7:U   '  1  '7BPM7   '    '07G-BPM7:V   '  1  [7 ,7]    49   'B'    ; ...
 '8BPM1   '    '08G-BPM1:U   '  1  '8BPM1   '    '08G-BPM1:V   '  1  [8 ,1]    50   'B'    ; ...
 '8BPM2   '    '08G-BPM2:U   '  1  '8BPM2   '    '08G-BPM2:V   '  1  [8 ,2]    51   'E'    ; ...
 '8BPM3   '    '08G-BPM3:U   '  1  '8BPM3   '    '08G-BPM3:V   '  1  [8 ,3]    52   'E'    ; ...
 '8BPM4   '    '08G-BPM4:U   '  1  '8BPM4   '    '08G-BPM4:V   '  1  [8 ,4]    53   'B'    ; ...
 '8BPM5   '    '08G-BPM5:U   '  1  '8BPM5   '    '08G-BPM5:V   '  1  [8 ,5]    54   'E'    ; ...
 '8BPM6   '    '08G-BPM6:U   '  1  '8BPM6   '    '08G-BPM6:V   '  1  [8 ,6]    55   'B'    ; ...
 '8BPM6   '    '08G-BPM6:U   '  1  '8BPM6   '    '08G-BPM6:V   '  1  [8 ,7]    56   'B'    ; ...
 '9BPM1   '    '09G-BPM1:U   '  1  '9BPM1   '    '09G-BPM1:V   '  1  [9 ,1]    57   'B'    ; ...
 '9BPM2   '    '09G-BPM2:U   '  1  '9BPM2   '    '09G-BPM2:V   '  1  [9 ,2]    58   'B'    ; ...
 '9BPM3   '    '09G-BPM3:U   '  1  '9BPM3   '    '09G-BPM3:V   '  1  [9 ,3]    59   'E'    ; ...
 '9BPM4   '    '09G-BPM4:U   '  1  '9BPM4   '    '09G-BPM4:V   '  1  [9 ,4]    60   'B'    ; ...
 '9BPM5   '    '09G-BPM5:U   '  1  '9BPM5   '    '09G-BPM5:V   '  1  [9 ,5]    61   'E'    ; ...
 '9BPM6   '    '09G-BPM6:U   '  1  '9BPM6   '    '09G-BPM6:V   '  1  [9 ,6]    62   'E'    ; ...
 '9BPM7   '    '09G-BPM7:U   '  1  '9BPM7   '    '09G-BPM7:V   '  1  [9 ,7]    63   'B'    ; ...
 '10BPM1  '    '10G-BPM1:U   '  1  '10BPM1  '    '10G-BPM1:V   '  1  [10,1]    64   'B'    ; ...
 '10BPM2  '    '10G-BPM2:U   '  1  '10BPM2  '    '10G-BPM2:V   '  1  [10,2]    65   'E'    ; ...
 '10BPM3  '    '10G-BPM3:U   '  1  '10BPM3  '    '10G-BPM3:V   '  1  [10,3]    66   'E'    ; ...
 '10BPM4  '    '10G-BPM4:U   '  1  '10BPM4  '    '10G-BPM4:V   '  1  [10,4]    67   'B'    ; ...
 '10BPM5  '    '10G-BPM5:U   '  1  '10BPM5  '    '10G-BPM5:V   '  1  [10,5]    68   'E'    ; ...
 '10BPM6  '    '10G-BPM6:U   '  1  '10BPM6  '    '10G-BPM6:V   '  1  [10,6]    69   'E'    ; ...
 '10BPM7  '    '10G-BPM7:U   '  1  '10BPM7  '    '10G-BPM7:V   '  1  [10,7]    70   'B'    ; ...
 '11BPM1  '    '11G-BPM1:U   '  1  '11BPM1  '    '11G-BPM1:V   '  1  [11,1]    71   'B'    ; ...
 '11BPM2  '    '11G-BPM2:U   '  1  '11BPM2  '    '11G-BPM2:V   '  1  [11,2]    72   'E'    ; ...
 '11BPM3  '    '11G-BPM3:U   '  1  '11BPM3  '    '11G-BPM3:V   '  1  [11,3]    73   'E'    ; ...
 '11BPM4  '    '11G-BPM4:U   '  1  '11BPM4  '    '11G-BPM4:V   '  1  [11,4]    74   'B'    ; ...
 '11BPM5  '    '11G-BPM5:U   '  1  '11BPM5  '    '11G-BPM5:V   '  1  [11,5]    75   'E'    ; ...
 '11BPM6  '    '11G-BPM6:U   '  1  '11BPM6  '    '11G-BPM6:V   '  1  [11,6]    76   'B'    ; ...
 '11BPM7  '    '11G-BPM7:U   '  1  '11BPM7  '    '11G-BPM7:V   '  1  [11,7]    77   'B'    ; ...
 '12BPM1  '    '12G-BPM1:U   '  1  '12BPM1  '    '12G-BPM1:V   '  1  [12,1]    78   'B'    ; ...
 '12BPM2  '    '12G-BPM2:U   '  1  '12BPM2  '    '12G-BPM2:V   '  1  [12,2]    79   'E'    ; ...
 '12BPM3  '    '12G-BPM3:U   '  1  '12BPM3  '    '12G-BPM3:V   '  1  [12,3]    80   'E'    ; ...
 '12BPM4  '    '12G-BPM4:U   '  1  '12BPM4  '    '12G-BPM4:V   '  1  [12,4]    81   'B'    ; ...
 '12BPM5  '    '12G-BPM5:U   '  1  '12BPM5  '    '12G-BPM5:V   '  1  [12,5]    82   'E'    ; ...
 '12BPM6  '    '12G-BPM6:U   '  1  '12BPM6  '    '12G-BPM6:V   '  1  [12,6]    83   'B'    ; ...
 '12BPM7  '    '12G-BPM7:U   '  1  '12BPM7  '    '12G-BPM7:V   '  1  [12,7]    84   'B'    ; ...
 '13BPM1  '    '13G-BPM1:U   '  1  '13BPM1  '    '13G-BPM1:V   '  1  [13,1]    85   'B'    ; ...
 '13BPM2  '    '13G-BPM2:U   '  1  '13BPM2  '    '13G-BPM2:V   '  1  [13,2]    86   'E'    ; ...
 '13BPM3  '    '13G-BPM3:U   '  1  '13BPM3  '    '13G-BPM3:V   '  1  [13,3]    87   'E'    ; ...
 '13BPM4  '    '13G-BPM4:U   '  1  '13BPM4  '    '13G-BPM4:V   '  1  [13,4]    88   'B'    ; ...
 '13BPM5  '    '13G-BPM5:U   '  1  '13BPM5  '    '13G-BPM5:V   '  1  [13,5]    89   'E'    ; ...
 '13BPM6  '    '13G-BPM6:U   '  1  '13BPM6  '    '13G-BPM6:V   '  1  [13,6]    90   'B'    ; ...
 '13BPM7  '    '13G-BPM6:U   '  1  '13BPM7  '    '13G-BPM7:V   '  1  [13,7]    91   'B'    ; ...
 '14BPM1  '    '14G-BPM1:U   '  1  '14BPM1  '    '14G-BPM1:V   '  1  [14,1]    92   'B'    ; ...
 '14BPM2  '    '14G-BPM2:U   '  1  '14BPM2  '    '14G-BPM2:V   '  1  [14,2]    93   'E'    ; ...
 '14BPM3  '    '14G-BPM3:U   '  1  '14BPM3  '    '14G-BPM3:V   '  1  [14,3]    94   'E'    ; ...
 '14BPM4  '    '14G-BPM4:U   '  1  '14BPM4  '    '14G-BPM4:V   '  1  [14,4]    95   'B'    ; ...
 '14BPM5  '    '14G-BPM5:U   '  1  '14BPM5  '    '14G-BPM5:V   '  1  [14,5]    96   'E'    ; ...
 '14BPM6  '    '14G-BPM6:U   '  1  '14BPM6  '    '14G-BPM6:V   '  1  [14,6]    97   'B'    ; ...
 '14BPM7  '    '14G-BPM7:U   '  1  '14BPM7  '    '14G-BPM7:V   '  1  [14,7]    98   'B'    ; ...
 '15BPM1  '    '15G-BPM1:U   '  1  '15BPM1  '    '15G-BPM1:V   '  1  [15,1]    99   'B'    ; ...
 '15BPM2  '    '15G-BPM2:U   '  1  '15BPM2  '    '15G-BPM2:V   '  1  [15,2]    100  'E'    ; ...
 '15BPM3  '    '15G-BPM3:U   '  1  '15BPM3  '    '15G-BPM3:V   '  1  [15,3]    101  'E'    ; ...
 '15BPM4  '    '15G-BPM4:U   '  1  '15BPM4  '    '15G-BPM4:V   '  1  [15,4]    102  'B'    ; ...
 '15BPM5  '    '15G-BPM5:U   '  1  '15BPM5  '    '15G-BPM5:V   '  1  [15,5]    103  'E'    ; ...
 '15BPM6  '    '15G-BPM6:U   '  1  '15BPM6  '    '15G-BPM6:V   '  1  [15,6]    104  'B'    ; ...
 '15BPM7  '    '15G-BPM7:U   '  1  '15BPM7  '    '15G-BPM7:V   '  1  [15,7]    105  'B'    ; ...
 '16BPM1  '    '16G-BPM1:U   '  1  '16BPM1  '    '16G-BPM1:V   '  1  [16,1]    106  'B'    ; ...
 '16BPM2  '    '16G-BPM2:U   '  1  '16BPM2  '    '16G-BPM2:V   '  1  [16,2]    107  'E'    ; ...
 '16BPM3  '    '16G-BPM3:U   '  1  '16BPM3  '    '16G-BPM3:V   '  1  [16,3]    108  'E'    ; ...
 '16BPM4  '    '16G-BPM4:U   '  1  '16BPM4  '    '16G-BPM4:V   '  1  [16,4]    109  'B'    ; ...
 '16BPM5  '    '16G-BPM5:U   '  1  '16BPM5  '    '16G-BPM5:V   '  1  [16,5]    110  'E'    ; ...
 '16BPM6  '    '16G-BPM6:U   '  1  '16BPM6  '    '16G-BPM6:V   '  1  [16,6]    111  'B'    ; ...
 '16BPM7  '    '16G-BPM7:U   '  1  '16BPM7  '    '16G-BPM7:V   '  1  [16,7]    112  'B'    ; ...
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

    % Scalar channel method
    AO{1}.Monitor.DataType = 'Scalar';
    AO{2}.Monitor.DataType = 'Scalar';

    AO{1}.Monitor = rmfield(AO{1}.Monitor, 'DataTypeIndex');
    AO{2}.Monitor = rmfield(AO{2}.Monitor, 'DataTypeIndex');
    
    AO{1}.Monitor.Handles = NaN * ones(size(AO{1}.DeviceList,1),1);
    AO{2}.Monitor.Handles = NaN * ones(size(AO{1}.DeviceList,1),1);


%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================
%horizontal corrector windings on SPEAR 3 cores 1,3,4
%vertical   corrector windings on SPEAR 3 cores 1,2,4

% NOTE: HCMGain and VCMGain are not used anymore!!!
%       k2amp and amp2k are use so that energy scaling works
HCMGain                        = 1; %0.0015/30.0;                  %0.0015  radian/30 ampere @ 3.0 GeV
VCMGain                        = 1; %0.00075/30.0;                 %0.00075 radian/30 ampere @ 3.0 GeV
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
 '1CX1    ' '01G-COR1H:Curr1' '01G-COR1H:CurrSetpt'  1  '1CY1    ' '01G-COR1V:Curr1' '01G-COR1V:CurrSetpt'  1   [1 ,1]  1  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX2    ' '01G-COR2H:Curr1' '01G-COR2H:CurrSetpt'  1  '1CY2    ' '01G-COR2V:Curr1' '01G-COR2V:CurrSetpt'  1   [1 ,2]  2  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX3    ' '01G-COR3H:Curr1' '01G-COR3H:CurrSetpt'  1  '1CY3    ' '01G-COR3V:Curr1' '01G-COR3V:CurrSetpt'  1   [1 ,3]  3  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX4    ' '01G-COR4H:Curr1' '01G-COR4H:CurrSetpt'  1  '1CY4    ' '01G-COR4V:Curr1' '01G-COR4V:CurrSetpt'  1   [1 ,4]  4  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX1    ' '02G-COR1H:Curr1' '02G-COR1H:CurrSetpt'  1  '2CY1    ' '02G-COR1V:Curr1' '02G-COR1V:CurrSetpt'  1   [2 ,1]  5  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX2    ' '02G-COR2H:Curr1' '02G-COR2H:CurrSetpt'  1  '2CY2    ' '02G-COR2V:Curr1' '02G-COR2V:CurrSetpt'  1   [2 ,2]  6  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX3    ' '02G-COR3H:Curr1' '02G-COR3H:CurrSetpt'  1  '2CY3    ' '02G-COR3V:Curr1' '02G-COR3V:CurrSetpt'  1   [2 ,3]  7  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX4    ' '02G-COR4H:Curr1' '02G-COR4H:CurrSetpt'  1  '2CY4    ' '02G-COR4V:Curr1' '02G-COR4V:CurrSetpt'  1   [2 ,4]  8  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX1    ' '03G-COR1H:Curr1' '03G-COR1H:CurrSetpt'  1  '3CY1    ' '03G-COR1V:Curr1' '03G-COR1V:CurrSetpt'  1   [3 ,1]  9  [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX2    ' '03G-COR2H:Curr1' '03G-COR2H:CurrSetpt'  1  '3CY2    ' '03G-COR2V:Curr1' '03G-COR2V:CurrSetpt'  1   [3 ,2]  10 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX3    ' '03G-COR3H:Curr1' '03G-COR3H:CurrSetpt'  1  '3CY3    ' '03G-COR3V:Curr1' '03G-COR3V:CurrSetpt'  1   [3 ,3]  11 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX4    ' '03G-COR4H:Curr1' '03G-COR4H:CurrSetpt'  1  '3CY4    ' '03G-COR4V:Curr1' '03G-COR4V:CurrSetpt'  1   [3 ,4]  12 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX1    ' '04G-COR1H:Curr1' '04G-COR1H:CurrSetpt'  1  '4CY1    ' '04G-COR1V:Curr1' '04G-COR1V:CurrSetpt'  1   [4 ,1]  13 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX2    ' '04G-COR2H:Curr1' '04G-COR2H:CurrSetpt'  1  '4CY2    ' '04G-COR2V:Curr1' '04G-COR2V:CurrSetpt'  1   [4 ,2]  14 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX3    ' '04G-COR3H:Curr1' '04G-COR3H:CurrSetpt'  1  '4CY3    ' '04G-COR3V:Curr1' '04G-COR3V:CurrSetpt'  1   [4 ,3]  15 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX4    ' '04G-COR4H:Curr1' '04G-COR4H:CurrSetpt'  1  '4CY4    ' '04G-COR4V:Curr1' '04G-COR4V:CurrSetpt'  1   [4 ,4]  16 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX1    ' '05G-COR1H:Curr1' '05G-COR1H:CurrSetpt'  1  '5CY1    ' '05G-COR1V:Curr1' '05G-COR1V:CurrSetpt'  1   [5 ,1]  17 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX2    ' '05G-COR2H:Curr1' '05G-COR2H:CurrSetpt'  1  '5CY2    ' '05G-COR2V:Curr1' '05G-COR2V:CurrSetpt'  1   [5 ,2]  18 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX3    ' '05G-COR3H:Curr1' '05G-COR3H:CurrSetpt'  1  '5CY3    ' '05G-COR3V:Curr1' '05G-COR3V:CurrSetpt'  1   [5 ,3]  19 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX4    ' '05G-COR4H:Curr1' '05G-COR4H:CurrSetpt'  1  '5CY4    ' '05G-COR4V:Curr1' '05G-COR4V:CurrSetpt'  1   [5 ,4]  20 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX1    ' '06G-COR1H:Curr1' '06G-COR1H:CurrSetpt'  1  '6CY1    ' '06G-COR1V:Curr1' '06G-COR1V:CurrSetpt'  1   [6 ,1]  21 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX2    ' '06G-COR2H:Curr1' '06G-COR2H:CurrSetpt'  1  '6CY2    ' '06G-COR2V:Curr1' '06G-COR2V:CurrSetpt'  1   [6 ,2]  22 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX3    ' '06G-COR3H:Curr1' '06G-COR3H:CurrSetpt'  1  '6CY3    ' '06G-COR3V:Curr1' '06G-COR3V:CurrSetpt'  1   [6 ,3]  23 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX4    ' '06G-COR4H:Curr1' '06G-COR4H:CurrSetpt'  1  '6CY4    ' '06G-COR4V:Curr1' '06G-COR4V:CurrSetpt'  1   [6 ,4]  24 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX1    ' '07G-COR1H:Curr1' '07G-COR1H:CurrSetpt'  1  '7CY1    ' '07G-COR1V:Curr1' '07G-COR1V:CurrSetpt'  1   [7 ,1]  25 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX2    ' '07G-COR2H:Curr1' '07G-COR2H:CurrSetpt'  1  '7CY2    ' '07G-COR2V:Curr1' '07G-COR2V:CurrSetpt'  1   [7 ,2]  26 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX3    ' '07G-COR3H:Curr1' '07G-COR3H:CurrSetpt'  1  '7CY3    ' '07G-COR3V:Curr1' '07G-COR3V:CurrSetpt'  1   [7 ,3]  27 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX4    ' '07G-COR4H:Curr1' '07G-COR4H:CurrSetpt'  1  '7CY4    ' '07G-COR4V:Curr1' '07G-COR4V:CurrSetpt'  1   [7 ,4]  28 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX1    ' '08G-COR1H:Curr1' '08G-COR1H:CurrSetpt'  1  '8CY1    ' '08G-COR1V:Curr1' '08G-COR1V:CurrSetpt'  1   [8 ,1]  29 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX2    ' '08G-COR2H:Curr1' '08G-COR2H:CurrSetpt'  1  '8CY2    ' '08G-COR2V:Curr1' '08G-COR2V:CurrSetpt'  1   [8 ,2]  30 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX3    ' '08G-COR3H:Curr1' '08G-COR3H:CurrSetpt'  1  '8CY3    ' '08G-COR3V:Curr1' '08G-COR3V:CurrSetpt'  1   [8 ,3]  31 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX4    ' '08G-COR4H:Curr1' '08G-COR4H:CurrSetpt'  1  '8CY4    ' '08G-COR4V:Curr1' '08G-COR4V:CurrSetpt'  1   [8 ,4]  32 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX1    ' '09G-COR1H:Curr1' '09G-COR1H:CurrSetpt'  1  '9CY1    ' '09G-COR1V:Curr1' '09G-COR1V:CurrSetpt'  1   [9 ,1]  33 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX2    ' '09G-COR2H:Curr1' '09G-COR2H:CurrSetpt'  1  '9CY2    ' '09G-COR2V:Curr1' '09G-COR2V:CurrSetpt'  1   [9 ,2]  34 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX3    ' '09G-COR3H:Curr1' '09G-COR3H:CurrSetpt'  1  '9CY3    ' '09G-COR3V:Curr1' '09G-COR3V:CurrSetpt'  1   [9 ,3]  35 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX4    ' '09G-COR4H:Curr1' '09G-COR4H:CurrSetpt'  1  '9CY4    ' '09G-COR4V:Curr1' '09G-COR4V:CurrSetpt'  1   [9 ,4]  36 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX1   ' '10G-COR1H:Curr1' '10G-COR1H:CurrSetpt'  1  '10CY1   ' '10G-COR1V:Curr1' '10G-COR1V:CurrSetpt'  1   [10,1]  37 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX2   ' '10G-COR2H:Curr1' '10G-COR2H:CurrSetpt'  1  '10CY2   ' '10G-COR2V:Curr1' '10G-COR2V:CurrSetpt'  1   [10,2]  38 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX3   ' '10G-COR3H:Curr1' '10G-COR3H:CurrSetpt'  1  '10CY3   ' '10G-COR3V:Curr1' '10G-COR3V:CurrSetpt'  1   [10,3]  39 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX4   ' '10G-COR4H:Curr1' '10G-COR4H:CurrSetpt'  1  '10CY4   ' '10G-COR4V:Curr1' '10G-COR4V:CurrSetpt'  1   [10,4]  40 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX1   ' '11G-COR1H:Curr1' '11G-COR1H:CurrSetpt'  1  '11CY1   ' '11G-COR1V:Curr1' '11G-COR1V:CurrSetpt'  1   [11,1]  41 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX2   ' '11G-COR2H:Curr1' '11G-COR2H:CurrSetpt'  1  '11CY2   ' '11G-COR2V:Curr1' '11G-COR2V:CurrSetpt'  1   [11,2]  42 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX3   ' '11G-COR3H:Curr1' '11G-COR3H:CurrSetpt'  1  '11CY3   ' '11G-COR3V:Curr1' '11G-COR3V:CurrSetpt'  1   [11,3]  43 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX4   ' '11G-COR4H:Curr1' '11G-COR4H:CurrSetpt'  1  '11CY4   ' '11G-COR4V:Curr1' '11G-COR4V:CurrSetpt'  1   [11,4]  44 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX1   ' '12G-COR1H:Curr1' '12G-COR1H:CurrSetpt'  1  '12CY1   ' '12G-COR1V:Curr1' '12G-COR1V:CurrSetpt'  1   [12,1]  45 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX2   ' '12G-COR2H:Curr1' '12G-COR2H:CurrSetpt'  1  '12CY2   ' '12G-COR2V:Curr1' '12G-COR2V:CurrSetpt'  1   [12,2]  46 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX3   ' '12G-COR3H:Curr1' '12G-COR3H:CurrSetpt'  1  '12CY3   ' '12G-COR3V:Curr1' '12G-COR3V:CurrSetpt'  1   [12,3]  47 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX4   ' '12G-COR4H:Curr1' '12G-COR4H:CurrSetpt'  1  '12CY4   ' '12G-COR4V:Curr1' '12G-COR4V:CurrSetpt'  1   [12,4]  48 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX1   ' '13G-COR1H:Curr1' '13G-COR1H:CurrSetpt'  1  '13CY1   ' '13G-COR1V:Curr1' '13G-COR1V:CurrSetpt'  1   [13,1]  49 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX2   ' '13G-COR2H:Curr1' '13G-COR2H:CurrSetpt'  1  '13CY2   ' '13G-COR2V:Curr1' '13G-COR2V:CurrSetpt'  1   [13,2]  50 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX3   ' '13G-COR3H:Curr1' '13G-COR3H:CurrSetpt'  1  '13CY3   ' '13G-COR3V:Curr1' '13G-COR3V:CurrSetpt'  1   [13,3]  51 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '13CX4   ' '13G-COR4H:Curr1' '13G-COR4H:CurrSetpt'  1  '13CY4   ' '13G-COR4V:Curr1' '13G-COR4V:CurrSetpt'  1   [13,4]  52 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX1   ' '14G-COR1H:Curr1' '14G-COR1H:CurrSetpt'  1  '14CY1   ' '14G-COR1V:Curr1' '14G-COR1V:CurrSetpt'  1   [14,1]  53 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX2   ' '14G-COR2H:Curr1' '14G-COR2H:CurrSetpt'  1  '14CY2   ' '14G-COR2V:Curr1' '14G-COR2V:CurrSetpt'  1   [14,2]  54 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX3   ' '14G-COR3H:Curr1' '14G-COR3H:CurrSetpt'  1  '14CY3   ' '14G-COR3V:Curr1' '14G-COR3V:CurrSetpt'  1   [14,3]  55 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '14CX4   ' '14G-COR4H:Curr1' '14G-COR4H:CurrSetpt'  1  '14CY4   ' '14G-COR4V:Curr1' '14G-COR4V:CurrSetpt'  1   [14,4]  56 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX1   ' '15G-COR1H:Curr1' '15G-COR1H:CurrSetpt'  1  '15CY1   ' '15G-COR1V:Curr1' '15G-COR1V:CurrSetpt'  1   [15,1]  57 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX2   ' '15G-COR2H:Curr1' '15G-COR2H:CurrSetpt'  1  '15CY2   ' '15G-COR2V:Curr1' '15G-COR2V:CurrSetpt'  1   [15,2]  58 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX3   ' '15G-COR3H:Curr1' '15G-COR3H:CurrSetpt'  1  '15CY3   ' '15G-COR3V:Curr1' '15G-COR3V:CurrSetpt'  1   [15,3]  59 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '15CX4   ' '15G-COR4H:Curr1' '15G-COR4H:CurrSetpt'  1  '15CY4   ' '15G-COR4V:Curr1' '15G-COR4V:CurrSetpt'  1   [15,4]  60 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX1   ' '16G-COR1H:Curr1' '16G-COR1H:CurrSetpt'  1  '16CY1   ' '16G-COR1V:Curr1' '16G-COR1V:CurrSetpt'  1   [16,1]  61 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX2   ' '16G-COR2H:Curr1' '16G-COR2H:CurrSetpt'  1  '16CY2   ' '16G-COR2V:Curr1' '16G-COR2V:CurrSetpt'  1   [16,2]  62 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX3   ' '16G-COR3H:Curr1' '16G-COR3H:CurrSetpt'  1  '16CY3   ' '16G-COR3V:Curr1' '16G-COR3V:CurrSetpt'  1   [16,3]  63 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '16CX4   ' '16G-COR4H:Curr1' '16G-COR4H:CurrSetpt'  1  '16CY4   ' '16G-COR4V:Curr1' '16G-COR4V:CurrSetpt'  1   [16,4]  64 [-30.0 +30.0]  0.101  1.5e-4    1.5e-4    0.5e-4  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
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

% AO{3}.Monitor.HW2PhysicsParams(ii,:)    = cor{ii,16}(1);          
% AO{3}.Monitor.Physics2HWParams(ii,:)    = cor{ii,17}(1);
% AO{3}.Setpoint.HW2PhysicsParams(ii,:)   = cor{ii,16}(1);         
% AO{3}.Setpoint.Physics2HWParams(ii,:)   = cor{ii,17}(1);
% 
% AO{4}.Monitor.HW2PhysicsParams(ii,:)    = cor{ii,18}(1);          % 
% AO{4}.Monitor.Physics2HWParams(ii,:)    = cor{ii,19}(1);
% AO{4}.Setpoint.HW2PhysicsParams(ii,:)   = cor{ii,18}(1);         
% AO{4}.Setpoint.Physics2HWParams(ii,:)   = cor{ii,19}(1); 

AO{3}.Monitor.Handles(ii,1)    = NaN;
AO{3}.Setpoint.Handles(ii,1)   = NaN;
AO{4}.Monitor.Handles(ii,1)    = NaN;
AO{4}.Setpoint.Handles(ii,1)   = NaN;
end

AO{3}.Status=AO{3}.Status(:);
AO{4}.Status=AO{4}.Status(:);

ifam=4;
%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========

% *** BM BEND ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'BM';
AO{ifam}.FamilyType                 = 'BM';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet';};

AO{ifam}.Monitor.Mode               = Mode;
AO{ifam}.Monitor.DataType           = 'Scalar';
AO{ifam}.Monitor.Units              = 'Hardware';
AO{ifam}.Monitor.HW2PhysicsFcn      = @amp2k;  %@bend2gev;
AO{ifam}.Monitor.Physics2HWFcn      = @k2amp;  %@gev2bend;
AO{ifam}.Monitor.HWUnits            = 'ampere';           
AO{ifam}.Monitor.PhysicsUnits       = 'radian';  %'energy';

AO{ifam}.Setpoint.Mode              = Mode;
AO{ifam}.Setpoint.DataType          = 'Scalar';
AO{ifam}.Setpoint.Units             = 'Hardware';
AO{ifam}.Setpoint.HW2PhysicsFcn     = @amp2k;  %@bend2gev;
AO{ifam}.Setpoint.Physics2HWFcn     = @k2amp;  %@gev2bend;
AO{ifam}.Setpoint.HWUnits           = 'ampere';           
AO{ifam}.Setpoint.PhysicsUnits      = 'radian';  %'energy';
%                                                                                                        delta-k
%common              monitor              setpoint           stat devlist elem   scalefactor    range    tol   respkick
bend={
 '1BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [1 ,1]  1         1.0        [0, 500] 0.050   0.05     ; ...
 '2BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [2 ,1]  2         1.0        [0, 500] 0.050   0.05     ; ...
 '2BEND2    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [2 ,2]  3         1.0        [0, 500] 0.050   0.05     ; ...
 '3BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [3 ,1]  4         1.0        [0, 500] 0.050   0.05     ; ...
 '3BEND2    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [3 ,2]  5         1.0        [0, 500] 0.050   0.05     ; ...
 '4BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [4 ,1]  6         1.0        [0, 500] 0.050   0.05     ; ...
 '5BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [5 ,1]  7         1.0        [0, 500] 0.050   0.05     ; ...
 '6BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [6 ,1]  8         1.0        [0, 500] 0.050   0.05     ; ...
 '6BEND2    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [6 ,2]  9         1.0        [0, 500] 0.050   0.05     ; ...
 '7BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [7 ,1]  10        1.0        [0, 500] 0.050   0.05     ; ...
 '7BEND2    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [7 ,2]  11        1.0        [0, 500] 0.050   0.05     ; ...
 '8BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [8 ,1]  12        1.0        [0, 500] 0.050   0.05     ; ...
 '9BEND1    '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [9 ,1]  13        1.0        [0, 500] 0.050   0.05     ; ...
 '10BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [10,1]  14        1.0        [0, 500] 0.050   0.05     ; ...
 '10BEND2   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [10,2]  15        1.0        [0, 500] 0.050   0.05     ; ...
 '11BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [11,1]  16        1.0        [0, 500] 0.050   0.05     ; ...
 '11BEND2   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [11,2]  17        1.0        [0, 500] 0.050   0.05     ; ...
 '12BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [12,1]  18        1.0        [0, 500] 0.050   0.05     ; ...
 '13BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [13,1]  19        1.0        [0, 500] 0.050   0.05     ; ...
 '14BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [14,1]  20        1.0        [0, 500] 0.050   0.05     ; ...
 '14BEND2   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [14,2]  21        1.0        [0, 500] 0.050   0.05     ; ...
 '15BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [15,1]  22        1.0        [0, 500] 0.050   0.05     ; ...
 '15BEND2   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [15,2]  23        1.0        [0, 500] 0.050   0.05     ; ...
 '16BEND1   '       'MS1-BD:Curr    '    'MS1-BD:CurrSetpt  '  1   [16,1]  24        1.0        [0, 500] 0.050   0.05     ; ...
};

for ii=1:size(bend,1)
name=bend{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=bend{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=bend{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =bend{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =bend{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =bend{ii,6};      AO{ifam}.ElementList(ii,1)           = val;

% The BEND comes in two different lengths
if any(AO{ifam}.DeviceList(ii,1) == [1 4 5 8 9 12 13 16])
    HW2PhysicsParams = magnetcoefficients('BEND');
    Physics2HWParams = HW2PhysicsParams;
else
    HW2PhysicsParams = magnetcoefficients('BEND');
    Physics2HWParams = HW2PhysicsParams;
end

val =bend{ii,7};
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)                = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)                 = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)                = val;
val =bend{ii,8};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =bend{ii,9};      AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =bend{ii,10};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;

AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end



% *** BE ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'BE';
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
be={ 
 '1b2       '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [1  ,1]  1     1.0       [0 500]  0.050   0.25      ; ...
 '4b2       '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [4  ,1]  2     1.0       [0 500]  0.050   0.25      ; ...
 '5b2       '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [5  ,1]  3     1.0       [0 500]  0.050   0.25      ; ...
 '8b2       '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [8  ,1]  4     1.0       [0 500]  0.050   0.25      ; ...
 '9b2       '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [9  ,1]  5     1.0       [0 500]  0.050   0.25      ; ...
 '12b2      '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [12 ,1]  6     1.0       [0 500]  0.050   0.25      ; ...
 '13b2      '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [13 ,1]  7     1.0       [0 500]  0.050   0.25      ; ...
 '16b2      '    'MS1-BDMT:Curr1'     'MS1-BDMT:CurrSetpt'  1   [16 ,1]  8     1.0       [0 500]  0.050   0.25      ; ...
  }; 

for ii=1:size(be,1)
name=be{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=be{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=be{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =be{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =be{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =be{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
val =be{ii,7};
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =be{ii,8};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =be{ii,9};     AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =be{ii,10};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)        = val;
AO{ifam}.Monitor.Handles(ii,1) =NaN;
AO{ifam}.Setpoint.Handles(ii,1)=NaN;
end

%QUADRUPOLES
% *** QF1 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF1';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');

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
   
%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
qf1={  
 '1QF1     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QF1     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QF1     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QF1     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QF1     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QF1    '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QF1    '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QF1    '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf1,1)
name=qf1{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qf1{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qf1{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qf1{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qf1{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qf1{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qf1{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qf1{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qf1{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QF2 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF2';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; };
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');

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
   

%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qf2={  
 '1QF21     '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QF21     '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QF21     '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QF21     '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QF21     '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QF21    '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QF21    '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QF21    '    'MS1-qf2:Curr     '     'MS1-qf2:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf2,1)
name=qf2{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qf2{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qf2{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qf2{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qf2{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qf2{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qf2{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qf2{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qf2{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QF3 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF3';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');

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

%                                                                                                               delta-k
%common            monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qf3={  
 '1QF31     '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QF31     '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QF31     '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QF31     '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QF31     '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QF31    '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QF31    '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QF31    '    'MS1-qf3:Curr     '     'MS1-qf3:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf3,1)
name=qf3{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qf3{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qf3{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qf3{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qf3{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qf3{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qf3{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qf3{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qf3{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QF4 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF4';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QFX');
Physics2HWParams                    = magnetcoefficients('QFX');

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
   

%                                                                                                               delta-k
%common                 monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qf4={  
 '1QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QF41    '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QF41    '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QF41    '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf4,1)
name=qf4{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qf4{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qf4{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qf4{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qf4{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qf4{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qf4{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qf4{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qf4{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QF5 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF5';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QF');
Physics2HWParams                    = magnetcoefficients('QF');

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

%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
qf5={
 '1QF51    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [1 ,1]    1          [0, 500] 0.050  0.002; ...
 '2QF51    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [2 ,1]    2          [0, 500] 0.050  0.002; ...
 '2QF52    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [2 ,2]    3          [0, 500] 0.050  0.002; ...
 '3QF51    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [3 ,1]    4          [0, 500] 0.050  0.002; ...
 '3QF52    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [3 ,2]    5          [0, 500] 0.050  0.002; ...
 '4QF51    '    'MS1-qf5:Curr     '    'MS1-qf5:CurrSetpt   '  1   [4 ,1]    6          [0, 500] 0.050  0.002; ...
 '5QF51    '    '05G-qf5:Curr     '    '05G-qf5:CurrSetpt   '  1   [5 ,1]    7          [0, 500] 0.050  0.002; ...
 '6QF51    '    '06G-qf5:Curr     '    '06G-qf5:CurrSetpt   '  1   [6 ,1]    8          [0, 500] 0.050  0.002; ...
 '6QF52    '    '06G-qf5:Curr     '    '06G-qf5:CurrSetpt   '  1   [6 ,2]    9          [0, 500] 0.050  0.002; ...
 '7QF51    '    '07G-qf5:Curr     '    '07G-qf5:CurrSetpt   '  1   [7 ,1]    10         [0, 500] 0.050  0.002; ...
 '7QF52    '    '07G-qf5:Curr     '    '07G-qf5:CurrSetpt   '  1   [7 ,2]    11         [0, 500] 0.050  0.002; ...
 '8QF51    '    '08G-qf5:Curr     '    '08G-qf5:CurrSetpt   '  1   [8 ,1]    12         [0, 500] 0.050  0.002; ...
 '9QF51    '    '07G-qf5:Curr     '    '07G-qf5:CurrSetpt   '  1   [9 ,1]    13         [0, 500] 0.050  0.002; ...
 '10QF51   '    '11G-qf5:Curr     '    '11G-qf5:CurrSetpt   '  1   [10,1]    14         [0, 500] 0.050  0.002; ...
 '10QF52   '    '11G-qf5:Curr     '    '11G-qf5:CurrSetpt   '  1   [10,2]    15         [0, 500] 0.050  0.002; ...
 '11QF51   '    '11G-qf5:Curr     '    '11G-qf5:CurrSetpt   '  1   [11,1]    16         [0, 500] 0.050  0.002; ...
 '11QF52   '    '11G-qf5:Curr     '    '11G-qf5:CurrSetpt   '  1   [11,2]    17         [0, 500] 0.050  0.002; ...
 '12QF51   '    '12G-qf5:Curr     '    '12G-qf5:CurrSetpt   '  1   [12,1]    18         [0, 500] 0.050  0.002; ...
 '13QF51   '    '13G-qf5:Curr     '    '13G-qf5:CurrSetpt   '  1   [13,1]    19         [0, 500] 0.050  0.002; ...
 '14QF51   '    '14G-qf5:Curr     '    '14G-qf5:CurrSetpt   '  1   [14,1]    20         [0, 500] 0.050  0.002; ...
 '14QF52   '    '14G-qf5:Curr     '    '14G-qf5:CurrSetpt   '  1   [14,2]    21         [0, 500] 0.050  0.002; ...
 '15QF51   '    '15G-qf5:Curr     '    '15G-qf5:CurrSetpt   '  1   [15,1]    22         [0, 500] 0.050  0.002; ...
 '15QF52   '    '15G-qf5:Curr     '    '15G-qf5:CurrSetpt   '  1   [15,2]    23         [0, 500] 0.050  0.002; ...
 '16QF51   '    '16G-qf5:Curr     '    '16G-qf5:CurrSetpt   '  1   [16,1]    24         [0, 500] 0.050  0.002; ...
};

for ii=1:size(qf5,1)
name=qf5{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qf5{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qf5{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qf5{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =qf5{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =qf5{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =qf5{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qf5{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qf5{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QF6 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QF6';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QF');
Physics2HWParams                    = magnetcoefficients('QF');

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
%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
qf6={
 '2QF61    '    'MS1-qf6:Curr     '    'MS1-qf6:CurrSetpt   '  1   [2 ,1]    1          [0, 500] 0.050  0.002; ...
 '2QF62    '    'MS1-qf6:Curr     '    'MS1-qf6:CurrSetpt   '  1   [2 ,2]    2          [0, 500] 0.050  0.002; ...
 '3QF61    '    'MS1-qf6:Curr     '    'MS1-qf6:CurrSetpt   '  1   [3 ,1]    3          [0, 500] 0.050  0.002; ...
 '3QF62    '    'MS1-qf6:Curr     '    'MS1-qf6:CurrSetpt   '  1   [3 ,2]    4          [0, 500] 0.050  0.002; ...
 '6QF61    '    '06G-qf6:Curr     '    '06G-qf6:CurrSetpt   '  1   [6 ,1]    5          [0, 500] 0.050  0.002; ...
 '6QF62    '    '06G-qf6:Curr     '    '06G-qf6:CurrSetpt   '  1   [6 ,2]    6          [0, 500] 0.050  0.002; ...
 '7QF61    '    '07G-qf6:Curr     '    '07G-qf6:CurrSetpt   '  1   [7 ,1]    7          [0, 500] 0.050  0.002; ...
 '7QF62    '    '07G-qf6:Curr     '    '07G-qf6:CurrSetpt   '  1   [7 ,2]    8          [0, 500] 0.050  0.002; ...
 '10QF61   '    '11G-qf6:Curr     '    '11G-qf6:CurrSetpt   '  1   [10,1]    9          [0, 500] 0.050  0.002; ...
 '10QF62   '    '11G-qf6:Curr     '    '11G-qf6:CurrSetpt   '  1   [10,2]    10         [0, 500] 0.050  0.002; ...
 '11QF61   '    '11G-qf6:Curr     '    '11G-qf6:CurrSetpt   '  1   [11,1]    11         [0, 500] 0.050  0.002; ...
 '11QF62   '    '11G-qf6:Curr     '    '11G-qf6:CurrSetpt   '  1   [11,2]    12         [0, 500] 0.050  0.002; ...
 '14QF61   '    '14G-qf6:Curr     '    '14G-qf6:CurrSetpt   '  1   [14,1]    13         [0, 500] 0.050  0.002; ...
 '14QF62   '    '14G-qf6:Curr     '    '14G-qf6:CurrSetpt   '  1   [14,2]    14         [0, 500] 0.050  0.002; ...
 '15QF61   '    '15G-qf6:Curr     '    '15G-qf6:CurrSetpt   '  1   [15,1]    15         [0, 500] 0.050  0.002; ...
 '15QF62   '    '15G-qf6:Curr     '    '15G-qf6:CurrSetpt   '  1   [15,2]    16         [0, 500] 0.050  0.002; ...
};

for ii=1:size(qf6,1)
name=qf6{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qf6{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qf6{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qf6{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =qf6{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =qf6{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =qf6{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qf6{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qf6{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QD1 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QD1';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QD');
Physics2HWParams                    = magnetcoefficients('QD');

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
   
%                                                                                                               delta-k
%common            monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qd1={  
 '1QD11     '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QD11     '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QD11     '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QD11     '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QD11     '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QD11    '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QD11    '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QD11    '    'MS1-qd1:Curr     '     'MS1-qd1:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qd1,1)
name=qd1{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qd1{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qd1{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qd1{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qd1{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qd1{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qd1{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qd1{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qd1{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QD2 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QD2';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QD');
Physics2HWParams                    = magnetcoefficients('QD');

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
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qd2={  
 '1QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QD21    '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QD21    '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QD21    '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qd2,1)
name=qd2{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qd2{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qd2{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qd2{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qd2{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qd2{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qd2{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qd2{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qd2{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QD3 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QD3';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QD');
Physics2HWParams                    = magnetcoefficients('QD');

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
   
%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qd3={  
 '1QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12QD31    '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13QD31    '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16QD31    '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qd3,1)
name=qd3{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=qd3{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=qd3{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =qd3{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =qd3{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =qd3{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =qd3{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =qd3{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =qd3{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** QD4 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'QD4';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'Bitbus';};
HW2PhysicsParams                    = magnetcoefficients('QD');
Physics2HWParams                    = magnetcoefficients('QD');

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

%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
qd4={
 '1QD41    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [1 ,1]    1          [0, 500] 0.050  0.002; ...
 '2QD41    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [2 ,1]    2          [0, 500] 0.050  0.002; ...
 '2QD42    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [2 ,2]    3          [0, 500] 0.050  0.002; ...
 '3QD41    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [3 ,1]    4          [0, 500] 0.050  0.002; ...
 '3QD42    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [3 ,2]    5          [0, 500] 0.050  0.002; ...
 '4QD41    '    'MS1-qd4:Curr     '    'MS1-qd4:CurrSetpt   '  1   [4 ,1]    6          [0, 500] 0.050  0.002; ...
 '5QD41    '    '05G-qd4:Curr     '    '05G-qd4:CurrSetpt   '  1   [5 ,1]    7          [0, 500] 0.050  0.002; ...
 '6QD41    '    '06G-qd4:Curr     '    '06G-qd4:CurrSetpt   '  1   [6 ,1]    8          [0, 500] 0.050  0.002; ...
 '6QD42    '    '06G-qd4:Curr     '    '06G-qd4:CurrSetpt   '  1   [6 ,2]    9          [0, 500] 0.050  0.002; ...
 '7QD41    '    '07G-qd4:Curr     '    '07G-qd4:CurrSetpt   '  1   [7 ,1]    10         [0, 500] 0.050  0.002; ...
 '7QD42    '    '07G-qd4:Curr     '    '07G-qd4:CurrSetpt   '  1   [7 ,2]    11         [0, 500] 0.050  0.002; ...
 '8QD41    '    '08G-qd4:Curr     '    '08G-qd4:CurrSetpt   '  1   [8 ,1]    12         [0, 500] 0.050  0.002; ...
 '9QD41    '    '07G-qd4:Curr     '    '07G-qd4:CurrSetpt   '  1   [9 ,1]    13         [0, 500] 0.050  0.002; ...
 '10QD41   '    '11G-qd4:Curr     '    '11G-qd4:CurrSetpt   '  1   [10,1]    14         [0, 500] 0.050  0.002; ...
 '10QD42   '    '11G-qd4:Curr     '    '11G-qd4:CurrSetpt   '  1   [10,2]    15         [0, 500] 0.050  0.002; ...
 '11QD41   '    '11G-qd4:Curr     '    '11G-qd4:CurrSetpt   '  1   [11,1]    16         [0, 500] 0.050  0.002; ...
 '11QD42   '    '11G-qd4:Curr     '    '11G-qd4:CurrSetpt   '  1   [11,2]    17         [0, 500] 0.050  0.002; ...
 '12QD41   '    '12G-qd4:Curr     '    '12G-qd4:CurrSetpt   '  1   [12,1]    18         [0, 500] 0.050  0.002; ...
 '13QD41   '    '13G-qd4:Curr     '    '13G-qd4:CurrSetpt   '  1   [13,1]    19         [0, 500] 0.050  0.002; ...
 '14QD41   '    '14G-qd4:Curr     '    '14G-qd4:CurrSetpt   '  1   [14,1]    20         [0, 500] 0.050  0.002; ...
 '14QD42   '    '14G-qd4:Curr     '    '14G-qd4:CurrSetpt   '  1   [14,2]    21         [0, 500] 0.050  0.002; ...
 '15QD41   '    '15G-qd4:Curr     '    '15G-qd4:CurrSetpt   '  1   [15,1]    22         [0, 500] 0.050  0.002; ...
 '15QD42   '    '15G-qd4:Curr     '    '15G-qd4:CurrSetpt   '  1   [15,2]    23         [0, 500] 0.050  0.002; ...
 '16QD41   '    '16G-qd4:Curr     '    '16G-qd4:CurrSetpt   '  1   [16,1]    24         [0, 500] 0.050  0.002; ...
};

for ii=1:size(qd4,1)
name=qd4{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=qd4{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=qd4{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =qd4{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =qd4{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =qd4{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =qd4{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =qd4{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =qd4{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

%===============
%Sextupole data
%===============
% *** SF1 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SF1';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SF');
Physics2HWParams                    = magnetcoefficients('SF');

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
   
%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sf1={  
 '1SF11    '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4SF11    '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5SF11    '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8SF11    '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9SF11    '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12SF11   '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13SF11   '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16SF11   '    'MS1-sf1:Curr     '     'MS1-sf1:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sf1,1)
name=sf1{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sf1{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sf1{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sf1{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =sf1{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =sf1{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =sf1{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sf1{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sf1{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SF2 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SF2';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SF');
Physics2HWParams                    = magnetcoefficients('SF');

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
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sf2={  
 '1SF2     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4SF2     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5SF2     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8SF2     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9SF2     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12SF1    '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13SF1    '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16SF2    '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sf2,1)
name=sf2{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sf2{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sf2{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sf2{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =sf2{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =sf2{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =sf2{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sf2{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sf2{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SF3 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SF3';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SF');
Physics2HWParams                    = magnetcoefficients('SF');

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

%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
sf3={
 '1SF31    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [1 ,1]    1          [0, 500] 0.050  0.002; ...
 '2SF31    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [2 ,1]    2          [0, 500] 0.050  0.002; ...
 '2SF32    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [2 ,2]    3          [0, 500] 0.050  0.002; ...
 '3SF31    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [3 ,1]    4          [0, 500] 0.050  0.002; ...
 '3SF32    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [3 ,2]    5          [0, 500] 0.050  0.002; ...
 '4SF31    '    'MS1-sf3:Curr     '    'MS1-sf3:CurrSetpt   '  1   [4 ,1]    6          [0, 500] 0.050  0.002; ...
 '5SF31    '    '05G-sf3:Curr     '    '05G-sf3:CurrSetpt   '  1   [5 ,1]    7          [0, 500] 0.050  0.002; ...
 '6SF31    '    '06G-sf3:Curr     '    '06G-sf3:CurrSetpt   '  1   [6 ,1]    8          [0, 500] 0.050  0.002; ...
 '6SF32    '    '06G-sf3:Curr     '    '06G-sf3:CurrSetpt   '  1   [6 ,2]    9          [0, 500] 0.050  0.002; ...
 '7SF31    '    '07G-sf3:Curr     '    '07G-sf3:CurrSetpt   '  1   [7 ,1]    10         [0, 500] 0.050  0.002; ...
 '7SF32    '    '07G-sf3:Curr     '    '07G-sf3:CurrSetpt   '  1   [7 ,2]    11         [0, 500] 0.050  0.002; ...
 '8SF31    '    '08G-sf3:Curr     '    '08G-sf3:CurrSetpt   '  1   [8 ,1]    12         [0, 500] 0.050  0.002; ...
 '9SF31    '    '07G-sf3:Curr     '    '07G-sf3:CurrSetpt   '  1   [9 ,1]    13         [0, 500] 0.050  0.002; ...
 '10SF31   '    '11G-sf3:Curr     '    '11G-sf3:CurrSetpt   '  1   [10,1]    14         [0, 500] 0.050  0.002; ...
 '10SF32   '    '11G-sf3:Curr     '    '11G-sf3:CurrSetpt   '  1   [10,2]    15         [0, 500] 0.050  0.002; ...
 '11SF31   '    '11G-sf3:Curr     '    '11G-sf3:CurrSetpt   '  1   [11,1]    16         [0, 500] 0.050  0.002; ...
 '11SF32   '    '11G-sf3:Curr     '    '11G-sf3:CurrSetpt   '  1   [11,2]    17         [0, 500] 0.050  0.002; ...
 '12SF31   '    '12G-sf3:Curr     '    '12G-sf3:CurrSetpt   '  1   [12,1]    18         [0, 500] 0.050  0.002; ...
 '13SF31   '    '13G-sf3:Curr     '    '13G-sf3:CurrSetpt   '  1   [13,1]    19         [0, 500] 0.050  0.002; ...
 '14SF31   '    '14G-sf3:Curr     '    '14G-sf3:CurrSetpt   '  1   [14,1]    20         [0, 500] 0.050  0.002; ...
 '14SF32   '    '14G-sf3:Curr     '    '14G-sf3:CurrSetpt   '  1   [14,2]    21         [0, 500] 0.050  0.002; ...
 '15SF31   '    '15G-sf3:Curr     '    '15G-sf3:CurrSetpt   '  1   [15,1]    22         [0, 500] 0.050  0.002; ...
 '15SF32   '    '15G-sf3:Curr     '    '15G-sf3:CurrSetpt   '  1   [15,2]    23         [0, 500] 0.050  0.002; ...
 '16SF31   '    '16G-sf3:Curr     '    '16G-sf3:CurrSetpt   '  1   [16,1]    24         [0, 500] 0.050  0.002; ...
};

for ii=1:size(sf3,1)
name=sf3{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sf3{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sf3{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sf3{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =sf3{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =sf3{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =sf3{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sf3{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sf3{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SF4 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SF4';
AO{ifam}.FamilyType                 = 'QUAD';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Tune Corrector'; };
HW2PhysicsParams                    = magnetcoefficients('SF');
Physics2HWParams                    = magnetcoefficients('SF');

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
%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
sf4={
 '2SF41    '    'MS1-sf4:Curr     '    'MS1-sf4:CurrSetpt   '  1   [2 ,1]    1          [0, 500] 0.050  0.002; ...
 '2SF42    '    'MS1-sf4:Curr     '    'MS1-sf4:CurrSetpt   '  1   [2 ,2]    2          [0, 500] 0.050  0.002; ...
 '3SF41    '    'MS1-sf4:Curr     '    'MS1-sf4:CurrSetpt   '  1   [3 ,1]    3          [0, 500] 0.050  0.002; ...
 '3SF42    '    'MS1-sf4:Curr     '    'MS1-sf4:CurrSetpt   '  1   [3 ,2]    4          [0, 500] 0.050  0.002; ...
 '6SF41    '    '06G-sf4:Curr     '    '06G-sf4:CurrSetpt   '  1   [6 ,1]    5          [0, 500] 0.050  0.002; ...
 '6SF42    '    '06G-sf4:Curr     '    '06G-sf4:CurrSetpt   '  1   [6 ,2]    6          [0, 500] 0.050  0.002; ...
 '7SF41    '    '07G-sf4:Curr     '    '07G-sf4:CurrSetpt   '  1   [7 ,1]    7          [0, 500] 0.050  0.002; ...
 '7SF42    '    '07G-sf4:Curr     '    '07G-sf4:CurrSetpt   '  1   [7 ,2]    8          [0, 500] 0.050  0.002; ...
 '10SF41   '    '11G-sf4:Curr     '    '11G-sf4:CurrSetpt   '  1   [10,1]    9          [0, 500] 0.050  0.002; ...
 '10SF42   '    '11G-sf4:Curr     '    '11G-sf4:CurrSetpt   '  1   [10,2]    10         [0, 500] 0.050  0.002; ...
 '11SF41   '    '11G-sf4:Curr     '    '11G-sf4:CurrSetpt   '  1   [11,1]    11         [0, 500] 0.050  0.002; ...
 '11SF42   '    '11G-sf4:Curr     '    '11G-sf4:CurrSetpt   '  1   [11,2]    12         [0, 500] 0.050  0.002; ...
 '14SF41   '    '14G-sf4:Curr     '    '14G-sf4:CurrSetpt   '  1   [14,1]    13         [0, 500] 0.050  0.002; ...
 '14SF42   '    '14G-sf4:Curr     '    '14G-sf4:CurrSetpt   '  1   [14,2]    14         [0, 500] 0.050  0.002; ...
 '15SF41   '    '15G-sf4:Curr     '    '15G-sf4:CurrSetpt   '  1   [15,1]    15         [0, 500] 0.050  0.002; ...
 '15SF42   '    '15G-sf4:Curr     '    '15G-sf4:CurrSetpt   '  1   [15,2]    16         [0, 500] 0.050  0.002; ...
};

for ii=1:size(sf4,1)
name=sf4{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sf4{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sf4{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sf4{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =sf4{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =sf4{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =sf4{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sf4{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sf4{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SD1 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SD1';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SF');
Physics2HWParams                    = magnetcoefficients('SF');

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
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sd1={  
 '1SD1     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4SD1     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5SD1     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8SD1     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9SD1     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12SD1    '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13SD1    '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16SD1    '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sd1,1)
name=sd1{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sd1{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sd1{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sd1{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =sd1{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =sd1{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =sd1{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sd1{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sd1{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SD2 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SD2';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SD');
Physics2HWParams                    = magnetcoefficients('SD');

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
   
%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sd2={  
 '1SD2     '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4SD2     '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5SD2     '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8SD2     '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9SD2     '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12SD2    '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13SD2    '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16SD2    '    'MS1-sd2:Curr     '     'MS1-sd2:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sd2,1)
name=sd2{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sd2{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sd2{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sd2{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =sd2{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =sd2{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = 1.0;
val =sd2{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sd2{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sd2{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SD3 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SD3';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SD');
Physics2HWParams                    = magnetcoefficients('SD');

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
   
%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sd3={  
 '1SD3     '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '4SD3     '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [4  ,1]  2         [0 500]  0.050    0.05; ...
 '5SD3     '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [5  ,1]  3         [0 500]  0.050    0.05; ...
 '8SD3     '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [8  ,1]  4         [0 500]  0.050    0.05; ...
 '9SD3     '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [9  ,1]  5         [0 500]  0.050    0.05; ...
 '12SD3    '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [12 ,1]  6         [0 500]  0.050    0.05; ...
 '13SD3    '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [13 ,1]  7         [0 500]  0.050    0.05; ...
 '16SD3    '    'MS1-sd3:Curr     '     'MS1-sd3:CurrSetpt   '  1   [16 ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sd3,1)
name=sd3{ii,1};     AO{ifam}.CommonNames(ii,:)          = name;            
name=sd3{ii,2};     AO{ifam}.Monitor.ChannelNames(ii,:) = name; 
name=sd3{ii,3};     AO{ifam}.Setpoint.ChannelNames(ii,:)= name;     
val =sd3{ii,4};     AO{ifam}.Status(ii,1)               = val;
val =sd3{ii,5};     AO{ifam}.DeviceList(ii,:)           = val;
val =sd3{ii,6};     AO{ifam}.ElementList(ii,1)          = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)             = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)              = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =sd3{ii,7};     AO{ifam}.Setpoint.Range(ii,:)       = val;
val =sd3{ii,8};    AO{ifam}.Setpoint.Tolerance(ii,1)   = val;
val =sd3{ii,9};    AO{ifam}.Setpoint.DeltaRespMat(ii,1)= val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

% *** SD4 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SD4';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('SD');
Physics2HWParams                    = magnetcoefficients('SD');

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

%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
sd4={
 '1SD41    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [1 ,1]    1          [0, 500] 0.050  0.002; ...
 '2SD41    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [2 ,1]    2          [0, 500] 0.050  0.002; ...
 '2SD42    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [2 ,2]    3          [0, 500] 0.050  0.002; ...
 '3SD41    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [3 ,1]    4          [0, 500] 0.050  0.002; ...
 '3SD42    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [3 ,2]    5          [0, 500] 0.050  0.002; ...
 '4SD41    '    'MS1-sd4:Curr     '    'MS1-sd4:CurrSetpt   '  1   [4 ,1]    6          [0, 500] 0.050  0.002; ...
 '5SD41    '    '05G-sd4:Curr     '    '05G-sd4:CurrSetpt   '  1   [5 ,1]    7          [0, 500] 0.050  0.002; ...
 '6SD41    '    '06G-sd4:Curr     '    '06G-sd4:CurrSetpt   '  1   [6 ,1]    8          [0, 500] 0.050  0.002; ...
 '6SD42    '    '06G-sd4:Curr     '    '06G-sd4:CurrSetpt   '  1   [6 ,2]    9          [0, 500] 0.050  0.002; ...
 '7SD41    '    '07G-sd4:Curr     '    '07G-sd4:CurrSetpt   '  1   [7 ,1]    10         [0, 500] 0.050  0.002; ...
 '7SD42    '    '07G-sd4:Curr     '    '07G-sd4:CurrSetpt   '  1   [7 ,2]    11         [0, 500] 0.050  0.002; ...
 '8SD41    '    '08G-sd4:Curr     '    '08G-sd4:CurrSetpt   '  1   [8 ,1]    12         [0, 500] 0.050  0.002; ...
 '9SD41    '    '07G-sd4:Curr     '    '07G-sd4:CurrSetpt   '  1   [9 ,1]    13         [0, 500] 0.050  0.002; ...
 '10SD41   '    '11G-sd4:Curr     '    '11G-sd4:CurrSetpt   '  1   [10,1]    14         [0, 500] 0.050  0.002; ...
 '10SD42   '    '11G-sd4:Curr     '    '11G-sd4:CurrSetpt   '  1   [10,2]    15         [0, 500] 0.050  0.002; ...
 '11SD41   '    '11G-sd4:Curr     '    '11G-sd4:CurrSetpt   '  1   [11,1]    16         [0, 500] 0.050  0.002; ...
 '11SD42   '    '11G-sd4:Curr     '    '11G-sd4:CurrSetpt   '  1   [11,2]    17         [0, 500] 0.050  0.002; ...
 '12SD41   '    '12G-sd4:Curr     '    '12G-sd4:CurrSetpt   '  1   [12,1]    18         [0, 500] 0.050  0.002; ...
 '13SD41   '    '13G-sd4:Curr     '    '13G-sd4:CurrSetpt   '  1   [13,1]    19         [0, 500] 0.050  0.002; ...
 '14SD41   '    '14G-sd4:Curr     '    '14G-sd4:CurrSetpt   '  1   [14,1]    20         [0, 500] 0.050  0.002; ...
 '14SD42   '    '14G-sd4:Curr     '    '14G-sd4:CurrSetpt   '  1   [14,2]    21         [0, 500] 0.050  0.002; ...
 '15SD41   '    '15G-sd4:Curr     '    '15G-sd4:CurrSetpt   '  1   [15,1]    22         [0, 500] 0.050  0.002; ...
 '15SD42   '    '15G-sd4:Curr     '    '15G-sd4:CurrSetpt   '  1   [15,2]    23         [0, 500] 0.050  0.002; ...
 '16SD41   '    '16G-sd4:Curr     '    '16G-sd4:CurrSetpt   '  1   [16,1]    24         [0, 500] 0.050  0.002; ...
};

for ii=1:size(sd4,1)
name=sd4{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sd4{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sd4{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sd4{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =sd4{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =sd4{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =sd4{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sd4{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sd4{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end



% *** SD5 ***
ifam=ifam+1;
AO{ifam}.FamilyName                 = 'SD5';
AO{ifam}.FamilyType                 = 'SEXT';
AO{ifam}.MemberOf                   = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; };
HW2PhysicsParams                    = magnetcoefficients('SD');
Physics2HWParams                    = magnetcoefficients('SD');

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
%                                                                                                        delta-k
%common          monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
sd5={
 '2SD51    '    'MS1-sd5:Curr     '    'MS1-sd5:CurrSetpt   '  1   [2 ,1]    1          [0, 500] 0.050  0.002; ...
 '2SD52    '    'MS1-sd5:Curr     '    'MS1-sd5:CurrSetpt   '  1   [2 ,2]    2          [0, 500] 0.050  0.002; ...
 '3SD51    '    'MS1-sd5:Curr     '    'MS1-sd5:CurrSetpt   '  1   [3 ,1]    3          [0, 500] 0.050  0.002; ...
 '3SD52    '    'MS1-sd5:Curr     '    'MS1-sd5:CurrSetpt   '  1   [3 ,2]    4          [0, 500] 0.050  0.002; ...
 '6SD51    '    '06G-sd5:Curr     '    '06G-sd5:CurrSetpt   '  1   [6 ,1]    5          [0, 500] 0.050  0.002; ...
 '6SD52    '    '06G-sd5:Curr     '    '06G-sd5:CurrSetpt   '  1   [6 ,2]    6          [0, 500] 0.050  0.002; ...
 '7SD51    '    '07G-sd5:Curr     '    '07G-sd5:CurrSetpt   '  1   [7 ,1]    7          [0, 500] 0.050  0.002; ...
 '7SD52    '    '07G-sd5:Curr     '    '07G-sd5:CurrSetpt   '  1   [7 ,2]    8          [0, 500] 0.050  0.002; ...
 '10SD51   '    '11G-sd5:Curr     '    '11G-sd5:CurrSetpt   '  1   [10,1]    9          [0, 500] 0.050  0.002; ...
 '10SD52   '    '11G-sd5:Curr     '    '11G-sd5:CurrSetpt   '  1   [10,2]    10         [0, 500] 0.050  0.002; ...
 '11SD51   '    '11G-sd5:Curr     '    '11G-sd5:CurrSetpt   '  1   [11,1]    11         [0, 500] 0.050  0.002; ...
 '11SD52   '    '11G-sd5:Curr     '    '11G-sd5:CurrSetpt   '  1   [11,2]    12         [0, 500] 0.050  0.002; ...
 '14SD51   '    '14G-sd5:Curr     '    '14G-sd5:CurrSetpt   '  1   [14,1]    13         [0, 500] 0.050  0.002; ...
 '14SD52   '    '14G-sd5:Curr     '    '14G-sd5:CurrSetpt   '  1   [14,2]    14         [0, 500] 0.050  0.002; ...
 '15SD51   '    '15G-sd5:Curr     '    '15G-sd5:CurrSetpt   '  1   [15,1]    15         [0, 500] 0.050  0.002; ...
 '15SD52   '    '15G-sd5:Curr     '    '15G-sd5:CurrSetpt   '  1   [15,2]    16         [0, 500] 0.050  0.002; ...
};

for ii=1:size(sd5,1)
name=sd5{ii,1};      AO{ifam}.CommonNames(ii,:)           = name;            
name=sd5{ii,2};      AO{ifam}.Monitor.ChannelNames(ii,:)  = name;
name=sd5{ii,3};      AO{ifam}.Setpoint.ChannelNames(ii,:) = name;     
val =sd5{ii,4};      AO{ifam}.Status(ii,1)                = val;
val =sd5{ii,5};      AO{ifam}.DeviceList(ii,:)            = val;
val =sd5{ii,6};      AO{ifam}.ElementList(ii,1)           = val;
AO{ifam}.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO{ifam}.Monitor.HW2PhysicsParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO{ifam}.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1.0;
AO{ifam}.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO{ifam}.Monitor.Physics2HWParams{2}(ii,:)               = 1.0;
AO{ifam}.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO{ifam}.Setpoint.Physics2HWParams{2}(ii,:)              = 1.0;
val =sd5{ii,7};      AO{ifam}.Setpoint.Range(ii,:)        = val;
val =sd5{ii,8};     AO{ifam}.Setpoint.Tolerance(ii,1)    = val;
val =sd5{ii,9};     AO{ifam}.Setpoint.DeltaRespMat(ii,1) = val;
AO{ifam}.Monitor.Handles(ii,1)    = NaN;
AO{ifam}.Setpoint.Handles(ii,1)   = NaN;
end

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
AO.DCCT.Monitor.Handles                = NaN;
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(1);  %1=ONLINE, 2=SIMULATOR  ==>for ALBA use ONLINE
AO = getao;




%======================================================================
%======================================================================
            % Append Accelerator Toolbox information
%======================================================================
%======================================================================
disp('   Initializing Accelerator Toolbox information');
global THERING FAMLIST GLOBVAL
ATindx = atindex(THERING);  %structure with fields containing indices
s = findspos(THERING,1:length(THERING)+1)';

%BPMS
AO.BPMx.AT.ATType  = 'BPMx';
AO.BPMx.AT.ATIndex = ATindx.BPM(:);
AO.BPMx.Position   = s(AO.BPMx.AT.ATIndex);

AO.BPMy.AT.ATType  = 'BPMy';
AO.BPMy.AT.ATIndex = ATindx.BPM(:);
AO.BPMy.Position   = s(AO.BPMy.AT.ATIndex);  %for SPEAR 3 horizontal and vertical bpms at same s-position

%CORRECTORS
AO.HCM.AT.ATType  = 'HCM';
AO.HCM.AT.ATIndex = ATindx.COR(:);
AO.HCM.Position = (s(AO.HCM.AT.ATIndex)+s(AO.HCM.AT.ATIndex+1))/2;

AO.VCM.AT.ATType  = 'VCM';
AO.VCM.AT.ATIndex = ATindx.COR(:);
AO.VCM.Position = (s(AO.VCM.AT.ATIndex)+s(AO.VCM.AT.ATIndex+1))/2;

%BM BENDS
AO.BM.AT.ATType  = 'BEND';
AO.BM.AT.ATIndex = ATindx.BM(:);
AO.BM.Position = (s(AO.BM.AT.ATIndex)+s(AO.BM.AT.ATIndex+1))/2;

%BE BENDS
AO.BE.AT.ATType  = 'BEND';
AO.BE.AT.ATIndex = ATindx.BE(:);
AO.BE.Position = (s(AO.BE.AT.ATIndex)+s(AO.BE.AT.ATIndex+1))/2;

%QUADS
AO.QF1.AT.ATType  = 'QUAD';
AO.QF1.AT.ATIndex = ATindx.QF1(:);
AO.QF1.Position = (s(AO.QF1.AT.ATIndex)+s(AO.QF1.AT.ATIndex+1))/2;

AO.QF2.AT.ATType  = 'QUAD';
AO.QF2.AT.ATIndex = ATindx.QF2(:);
AO.QF2.Position = (s(AO.QF2.AT.ATIndex)+s(AO.QF2.AT.ATIndex+1))/2;

AO.QF3.AT.ATType  = 'QUAD';
AO.QF3.AT.ATIndex = ATindx.QF3(:);
AO.QF3.Position = (s(AO.QF3.AT.ATIndex)+s(AO.QF3.AT.ATIndex+1))/2;

AO.QF4.AT.ATType  = 'QUAD';
AO.QF4.AT.ATIndex = ATindx.QF4(:);
AO.QF4.Position = (s(AO.QF4.AT.ATIndex)+s(AO.QF4.AT.ATIndex+1))/2;

AO.QF5.AT.ATType  = 'QUAD';
AO.QF5.AT.ATIndex = ATindx.QF5(:);
AO.QF5.Position = (s(AO.QF5.AT.ATIndex)+s(AO.QF5.AT.ATIndex+1))/2;

AO.QF6.AT.ATType  = 'QUAD';
AO.QF6.AT.ATIndex = ATindx.QF6(:);
AO.QF6.Position = (s(AO.QF6.AT.ATIndex)+s(AO.QF6.AT.ATIndex+1))/2;

AO.QD1.AT.ATType  = 'QUAD';
AO.QD1.AT.ATIndex = ATindx.QD1(:);
AO.QD1.Position = (s(AO.QD1.AT.ATIndex)+s(AO.QD1.AT.ATIndex+1))/2;

AO.QD2.AT.ATType  = 'QUAD';
AO.QD2.AT.ATIndex = ATindx.QD2(:);
AO.QD2.Position = (s(AO.QD2.AT.ATIndex)+s(AO.QD2.AT.ATIndex+1))/2;

AO.QD3.AT.ATType  = 'QUAD';
AO.QD3.AT.ATIndex = ATindx.QD3(:);
AO.QD3.Position = (s(AO.QD3.AT.ATIndex)+s(AO.QD3.AT.ATIndex+1))/2;

AO.QD4.AT.ATType  = 'QUAD';
AO.QD4.AT.ATIndex = ATindx.QD4(:);
AO.QD4.Position = (s(AO.QD4.AT.ATIndex)+s(AO.QD4.AT.ATIndex+1))/2;


%SEXTUPOLES
AO.SF1.AT.ATType  = 'SEXT';
AO.SF1.AT.ATIndex = ATindx.SF1(:);
AO.SF1.Position = (s(AO.SF1.AT.ATIndex)+s(AO.SF1.AT.ATIndex+1))/2;

AO.SF2.AT.ATType  = 'SEXT';
AO.SF2.AT.ATIndex = ATindx.SF2(:);
AO.SF2.Position = (s(AO.SF2.AT.ATIndex)+s(AO.SF2.AT.ATIndex+1))/2;

AO.SF3.AT.ATType  = 'SEXT';
AO.SF3.AT.ATIndex = ATindx.SF3(:);
AO.SF3.Position = (s(AO.SF3.AT.ATIndex)+s(AO.SF3.AT.ATIndex+1))/2;

AO.SF4.AT.ATType  = 'SEXT';
AO.SF4.AT.ATIndex = ATindx.SF4(:);
AO.SF4.Position = (s(AO.SF4.AT.ATIndex)+s(AO.SF4.AT.ATIndex+1))/2;

AO.SD1.AT.ATType  = 'SEXT';
AO.SD1.AT.ATIndex = ATindx.SD1(:);
AO.SD1.Position = (s(AO.SD1.AT.ATIndex)+s(AO.SD1.AT.ATIndex+1))/2;

AO.SD2.AT.ATType  = 'SEXT';
AO.SD2.AT.ATIndex = ATindx.SD2(:);
AO.SD2.Position = (s(AO.SD2.AT.ATIndex)+s(AO.SD2.AT.ATIndex+1))/2;

AO.SD3.AT.ATType  = 'SEXT';
AO.SD3.AT.ATIndex = ATindx.SD3(:);
AO.SD3.Position = (s(AO.SD3.AT.ATIndex)+s(AO.SD3.AT.ATIndex+1))/2;

AO.SD4.AT.ATType  = 'SEXT';
AO.SD4.AT.ATIndex = ATindx.SD4(:);
AO.SD4.Position = (s(AO.SD4.AT.ATIndex)+s(AO.SD4.AT.ATIndex+1))/2;

AO.SD5.AT.ATType  = 'SEXT';
AO.SD5.AT.ATIndex = ATindx.SD5(:);
AO.SD5.Position = (s(AO.SD5.AT.ATIndex)+s(AO.SD5.AT.ATIndex+1))/2;


%Machine Parameters (I'm not use where this are used - Greg)
AO.MachineParameters.AT.ATType = 'MachineParameters';
AO.MachineParameters.AT.ATName(1,:) = 'Energy  ';
AO.MachineParameters.AT.ATName(2,:) = 'Current ';
AO.MachineParameters.AT.ATName(3,:) = 'Lifetime';


% Response matrix kick size (must be in hardware units)
% Note #1: The AO must be setup for the BEND family for physics2hw to work
% Note #2: This is being done in simulate mode so that the BEND will not be
%          accessed to get the energy.  This can be problem when the BEND is 
%          not online or not at the proper setpoint
setao(AO);
ModeBEND = getmode('BM', 'Setpoint');
setfamilydata('Simulator', 'BM', 'Monitor', 'Mode');
setfamilydata('Simulator', 'BM', 'Setpoint', 'Mode');
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList);
AO.VCM.Setpoint.PhotResp     = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.PhotResp,     AO.VCM.DeviceList);

AO.QF1.Setpoint.DeltaRespMat  = physics2hw('QF1', 'Setpoint', AO.QF1.Setpoint.DeltaRespMat,  AO.QF1.DeviceList);
AO.QF2.Setpoint.DeltaRespMat  = physics2hw('QF2', 'Setpoint', AO.QF2.Setpoint.DeltaRespMat,  AO.QF2.DeviceList);
AO.QF3.Setpoint.DeltaRespMat  = physics2hw('QF3', 'Setpoint', AO.QF3.Setpoint.DeltaRespMat,  AO.QF3.DeviceList);
AO.QF4.Setpoint.DeltaRespMat  = physics2hw('QF4', 'Setpoint', AO.QF4.Setpoint.DeltaRespMat,  AO.QF4.DeviceList);
AO.QF5.Setpoint.DeltaRespMat  = physics2hw('QF5', 'Setpoint', AO.QF5.Setpoint.DeltaRespMat,  AO.QF5.DeviceList);
AO.QF6.Setpoint.DeltaRespMat  = physics2hw('QF6', 'Setpoint', AO.QF6.Setpoint.DeltaRespMat,  AO.QF6.DeviceList);

AO.QD1.Setpoint.DeltaRespMat  = physics2hw('QD1', 'Setpoint', AO.QD1.Setpoint.DeltaRespMat,  AO.QD1.DeviceList);
AO.QD2.Setpoint.DeltaRespMat  = physics2hw('QD2', 'Setpoint', AO.QD2.Setpoint.DeltaRespMat,  AO.QD2.DeviceList);
AO.QD3.Setpoint.DeltaRespMat  = physics2hw('QD3', 'Setpoint', AO.QD3.Setpoint.DeltaRespMat,  AO.QD3.DeviceList);
AO.QD4.Setpoint.DeltaRespMat  = physics2hw('QD4', 'Setpoint', AO.QD4.Setpoint.DeltaRespMat,  AO.QD4.DeviceList);

AO.SF1.Setpoint.DeltaRespMat  = physics2hw('SF1', 'Setpoint', AO.SF1.Setpoint.DeltaRespMat,  AO.SF1.DeviceList);
AO.SF2.Setpoint.DeltaRespMat  = physics2hw('SF2', 'Setpoint', AO.SF2.Setpoint.DeltaRespMat,  AO.SF2.DeviceList);
AO.SF3.Setpoint.DeltaRespMat  = physics2hw('SF3', 'Setpoint', AO.SF3.Setpoint.DeltaRespMat,  AO.SF3.DeviceList);
AO.SF4.Setpoint.DeltaRespMat  = physics2hw('SF4', 'Setpoint', AO.SF4.Setpoint.DeltaRespMat,  AO.SF4.DeviceList);

AO.SD1.Setpoint.DeltaRespMat  = physics2hw('SD1', 'Setpoint', AO.SD1.Setpoint.DeltaRespMat,  AO.SD1.DeviceList);
AO.SD2.Setpoint.DeltaRespMat  = physics2hw('SD2', 'Setpoint', AO.SD2.Setpoint.DeltaRespMat,  AO.SD2.DeviceList);
AO.SD3.Setpoint.DeltaRespMat  = physics2hw('SD3', 'Setpoint', AO.SD3.Setpoint.DeltaRespMat,  AO.SD3.DeviceList);
AO.SD4.Setpoint.DeltaRespMat  = physics2hw('SD4', 'Setpoint', AO.SD4.Setpoint.DeltaRespMat,  AO.SD4.DeviceList);
AO.SD5.Setpoint.DeltaRespMat  = physics2hw('SD5', 'Setpoint', AO.SD5.Setpoint.DeltaRespMat,  AO.SD5.DeviceList);


setao(AO);  % setfamilydata works on the saved AO
setfamilydata(ModeBEND, 'BEND', 'Monitor', 'Mode');
setfamilydata(ModeBEND, 'BEND', 'Setpoint', 'Mode');

disp(' ');
