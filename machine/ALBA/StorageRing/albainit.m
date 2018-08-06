function albainit(OperationalMode)
% Initialize parameters for ALBA control in MATLAB
% 26 June 07 Change the number of BPMs and Correctors to 88

% Modified by Laurent S. Nadolski

if nargin < 1
    OperationalMode = 1;
end

Mode = 'Simulator';

setad([]);     %clear AcceleratorData memory
setao([]);     %clear previous AcceleratorObjects

%=============================================
%% BPMx data: status field designates if BPM in use
%=============================================
iFam = 'BPMx';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).MemberOf                 = {'PlotFamily'; 'HBPM'; 'BPM'; 'Diagnostics'};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'mm';
AO.(iFam).Monitor.PhysicsUnits     = 'meter';


%  ElemList TangoName    Status DevList Common name
bpm={
    1,	'SR/DI-BPM/S01_01', 1, [1 1], '01BPM01'
    2,	'SR/DI-BPM/S01_02', 1, [1 2], '01BPM02'
    3,	'SR/DI-BPM/S01_03', 0, [1 3], '01BPM03'
    4,	'SR/DI-BPM/S01_04', 1, [1 4], '01BPM04'
    5,	'SR/DI-BPM/S01_05', 0, [1 5], '01BPM05'
    6,	'SR/DI-BPM/S01_06', 1, [1 6], '01BPM06'
    7,	'SR/DI-BPM/S01_07', 1, [1 7], '01BPM07'
    8,	'SR/DI-BPM/S02_01', 1, [2 1], '02BPM01'
    9,	'SR/DI-BPM/S02_02', 1, [2 2], '02BPM02'
    10,	'SR/DI-BPM/S02_03', 0, [2 3], '02BPM03'
    11,	'SR/DI-BPM/S02_04', 1, [2 4], '02BPM04'
    12,	'SR/DI-BPM/S02_05', 1, [2 5], '02BPM05'
    13,	'SR/DI-BPM/S02_06', 0, [2 6], '02BPM06'
    14,	'SR/DI-BPM/S02_07', 1, [2 7], '02BPM07'
    15,	'SR/DI-BPM/S02_08', 1, [2 8], '02BPM08'
    16,	'SR/DI-BPM/S03_01', 1, [3 1], '03BPM01'
    17,	'SR/DI-BPM/S03_02', 1, [3 2], '03BPM02'
    18,	'SR/DI-BPM/S03_03', 0, [3 3], '03BPM03'
    19,	'SR/DI-BPM/S03_04', 1, [3 4], '03BPM04'
    20,	'SR/DI-BPM/S03_05', 1, [3 5], '03BPM05'
    21,	'SR/DI-BPM/S03_06', 0, [3 6], '03BPM06'
    22,	'SR/DI-BPM/S03_07', 1, [3 7], '03BPM07'
    23,	'SR/DI-BPM/S03_08', 1, [3 8], '03BPM08'
    24,	'SR/DI-BPM/S04_01', 1, [4 1], '01BPM01'
    25,	'SR/DI-BPM/S04_02', 1, [4 2], '04BPM02'
    26,	'SR/DI-BPM/S04_03', 0, [4 3], '04BPM03'
    27,	'SR/DI-BPM/S04_04', 1, [4 4], '04BPM04'
    28,	'SR/DI-BPM/S04_05', 0, [4 5], '04BPM05'
    29,	'SR/DI-BPM/S04_06', 1, [4 6], '04BPM06'
    30,	'SR/DI-BPM/S04_07', 1, [4 7], '04BPM07'
    31,	'SR/DI-BPM/S05_01', 1, [5 1], '05BPM01'
    32,	'SR/DI-BPM/S05_02', 1, [5 2], '05BPM02'
    33,	'SR/DI-BPM/S05_03', 0, [5 3], '05BPM03'
    34,	'SR/DI-BPM/S05_04', 1, [5 4], '05BPM04'
    35,	'SR/DI-BPM/S05_05', 0, [5 5], '05BPM05'
    36,	'SR/DI-BPM/S05_06', 1, [5 6], '05BPM06'
    37,	'SR/DI-BPM/S05_07', 1, [5 7], '05BPM07'
    38,	'SR/DI-BPM/S06_01', 1, [6 1], '06BPM01'
    39,	'SR/DI-BPM/S06_02', 1, [6 2], '06BPM02'
    40,	'SR/DI-BPM/S06_03', 0, [6 3], '06BPM03'
    41,	'SR/DI-BPM/S06_04', 1, [6 4], '06BPM04'
    42,	'SR/DI-BPM/S06_05', 1, [6 5], '06BPM05'
    43,	'SR/DI-BPM/S06_06', 0, [6 6], '06BPM06'
    44,	'SR/DI-BPM/S06_07', 1, [6 7], '06BPM07'
    45,	'SR/DI-BPM/S06_08', 1, [6 8], '06BPM08'
    46,	'SR/DI-BPM/S07_01', 1, [7 1], '07BPM01'
    47,	'SR/DI-BPM/S07_02', 1, [7 2], '07BPM02'
    48,	'SR/DI-BPM/S07_03', 0, [7 3], '07BPM03'
    49,	'SR/DI-BPM/S07_04', 1, [7 4], '07BPM04'
    50,	'SR/DI-BPM/S07_05', 1, [7 5], '07BPM05'
    51,	'SR/DI-BPM/S07_06', 0, [7 6], '07BPM06'
    52,	'SR/DI-BPM/S07_07', 1, [7 7], '07BPM07'
    53,	'SR/DI-BPM/S07_08', 1, [7 8], '07BPM08'
    54,	'SR/DI-BPM/S08_01', 1, [8 1], '08BPM01'
    55,	'SR/DI-BPM/S08_02', 1, [8 2], '08BPM02'
    56,	'SR/DI-BPM/S08_03', 0, [8 3], '08BPM03'
    57,	'SR/DI-BPM/S08_04', 1, [8 4], '08BPM04'
    58,	'SR/DI-BPM/S08_05', 0, [8 5], '08BPM05'
    59,	'SR/DI-BPM/S08_06', 1, [8 6], '08BPM06'
    60,	'SR/DI-BPM/S08_07', 1, [8 7], '08BPM07'
    61,	'SR/DI-BPM/S09_01', 1, [9 1], '09BPM01'
    62,	'SR/DI-BPM/S09_02', 1, [9 2], '09BPM02'
    63,	'SR/DI-BPM/S09_03', 0, [9 3], '09BPM03'
    64,	'SR/DI-BPM/S09_04', 1, [9 4], '09BPM04'
    65,	'SR/DI-BPM/S09_05', 0, [9 5], '09BPM05'
    66,	'SR/DI-BPM/S09_06', 1, [9 6], '09BPM06'
    67,	'SR/DI-BPM/S09_07', 1, [9 7], '09BPM07'
    68,	'SR/DI-BPM/S10_01', 1, [10 1],'10BPM01'
    69,	'SR/DI-BPM/S10_02', 1, [10 2],'10BPM02'
    70,	'SR/DI-BPM/S10_03', 0, [10 3],'10BPM03'
    71,	'SR/DI-BPM/S10_04', 1, [10 4],'10BPM04'
    72,	'SR/DI-BPM/S10_05', 1, [10 5],'10BPM05'
    73,	'SR/DI-BPM/S10_06', 0, [10 6],'10BPM06'
    74,	'SR/DI-BPM/S10_07', 1, [10 7],'10BPM07'
    75,	'SR/DI-BPM/S10_08', 1, [10 8],'10BPM08'
    76,	'SR/DI-BPM/S11_01', 1, [11 1],'11BPM01'
    77,	'SR/DI-BPM/S11_02', 1, [11 2],'11BPM02'
    78,	'SR/DI-BPM/S11_03', 0, [11 3],'11BPM03'
    79,	'SR/DI-BPM/S11_04', 1, [11 4],'11BPM04'
    80,	'SR/DI-BPM/S11_05', 1, [11 5],'11BPM05'
    81,	'SR/DI-BPM/S11_06', 0, [11 6],'11BPM06'
    82,	'SR/DI-BPM/S11_07', 1, [11 7],'11BPM07'
    83,	'SR/DI-BPM/S11_08', 1, [11 8],'11BPM08'
    84,	'SR/DI-BPM/S12_01', 1, [12 1],'12BPM01'
    85,	'SR/DI-BPM/S12_02', 1, [12 2],'12BPM02'
    86,	'SR/DI-BPM/S12_03', 0, [12 3],'12BPM03'
    87,	'SR/DI-BPM/S12_04', 1, [12 4],'12BPM04'
    88,	'SR/DI-BPM/S12_05', 0, [12 5],'12BPM05'
    89,	'SR/DI-BPM/S12_06', 1, [12 6],'12BPM06'
    90,	'SR/DI-BPM/S12_07', 1, [12 7],'12BPM07'
    91,	'SR/DI-BPM/S13_01', 1, [13 1],'13BPM01'
    92,	'SR/DI-BPM/S13_02', 1, [13 2],'13BPM02'
    93,	'SR/DI-BPM/S13_03', 0, [13 3],'13BPM03'
    94,	'SR/DI-BPM/S13_04', 1, [13 4],'13BPM04'
    95,	'SR/DI-BPM/S13_05', 0, [13 5],'13BPM05'
    96,	'SR/DI-BPM/S13_06', 1, [13 6],'13BPM06'
    97,	'SR/DI-BPM/S13_07', 1, [13 7],'13BPM07'
    98,	'SR/DI-BPM/S14_01', 1, [14 1],'14BPM01'
    99,	'SR/DI-BPM/S14_02', 1, [14 2],'14BPM02'
    100,	'SR/DI-BPM/S14_03', 0, [14 3],'14BPM03'
    101,	'SR/DI-BPM/S14_04', 1, [14 4],'14BPM04'
    102,	'SR/DI-BPM/S14_05', 1, [14 5],'14BPM05'
    103,	'SR/DI-BPM/S14_06', 0, [14 6],'14BPM06'
    104,	'SR/DI-BPM/S14_07', 1, [14 7],'14BPM07'
    105,	'SR/DI-BPM/S14_08', 1, [14 8],'14BPM08'
    106,	'SR/DI-BPM/S15_01', 1, [15 1],'15BPM01'
    107,	'SR/DI-BPM/S15_02', 1, [15 2],'15BPM02'
    108,	'SR/DI-BPM/S15_03', 0, [15 3],'15BPM03'
    109,	'SR/DI-BPM/S15_04', 1, [15 4],'15BPM04'
    110,	'SR/DI-BPM/S15_05', 1, [15 5],'15BPM05'
    111,	'SR/DI-BPM/S15_06', 0, [15 6],'15BPM06'
    112,	'SR/DI-BPM/S15_07', 1, [15 7],'15BPM07'
    113,	'SR/DI-BPM/S15_08', 1, [15 8],'15BPM08'
    114,	'SR/DI-BPM/S16_01', 1, [16 1],'16BPM01'
    115,	'SR/DI-BPM/S16_02', 1, [16 2],'16BPM02'
    116,	'SR/DI-BPM/S16_03', 0, [16 3],'16BPM03'
    117,	'SR/DI-BPM/S16_04', 1, [16 4],'16BPM04'
    118,	'SR/DI-BPM/S16_05', 0, [16 5],'16BPM05'
    119,	'SR/DI-BPM/S16_06', 1, [16 6],'16BPM06'
    120,	'SR/DI-BPM/S16_07', 1, [16 7],'16BPM07'
    };

% bpm={
%      1,	'SR/DI-BPM/S01_01', 1, [1 1], '01BPM01'
%      2,	'SR/DI-BPM/S01_02', 1, [1 2], '01BPM02'
%      4,	'SR/DI-BPM/S01_04', 1, [1 4], '01BPM04'
%      6,	'SR/DI-BPM/S01_06', 1, [1 6], '01BPM06'
%      7,	'SR/DI-BPM/S01_07', 1, [1 7], '01BPM07'
%      8,	'SR/DI-BPM/S02_01', 1, [2 1], '02BPM01'
%      9,	'SR/DI-BPM/S02_02', 1, [2 2], '02BPM02'
%     11,	'SR/DI-BPM/S02_04', 1, [2 4], '02BPM04'
%     12,	'SR/DI-BPM/S02_05', 1, [2 5], '02BPM05'
%     14,	'SR/DI-BPM/S02_07', 1, [2 7], '02BPM07'
%     15,	'SR/DI-BPM/S02_08', 1, [2 8], '02BPM08'
%     16,	'SR/DI-BPM/S03_01', 1, [3 1], '03BPM01'
%     17,	'SR/DI-BPM/S03_02', 1, [3 2], '03BPM02'
%     19,	'SR/DI-BPM/S03_04', 1, [3 4], '03BPM04'
%     20,	'SR/DI-BPM/S03_05', 1, [3 5], '03BPM05'
%     22,	'SR/DI-BPM/S03_07', 1, [3 7], '03BPM07'
%     23,	'SR/DI-BPM/S03_08', 1, [3 8], '03BPM08'
%     24,	'SR/DI-BPM/S04_01', 1, [4 1], '01BPM01'
%     25,	'SR/DI-BPM/S04_02', 1, [4 2], '04BPM02'
%     27,	'SR/DI-BPM/S04_04', 1, [4 4], '04BPM04'
%     29,	'SR/DI-BPM/S04_06', 1, [4 6], '04BPM06'
%     30,	'SR/DI-BPM/S04_07', 1, [4 7], '04BPM07'
%     31,	'SR/DI-BPM/S05_01', 1, [5 1], '05BPM01'
%     32,	'SR/DI-BPM/S05_02', 1, [5 2], '05BPM02'
%     34,	'SR/DI-BPM/S05_04', 1, [5 4], '05BPM04'
%     36,	'SR/DI-BPM/S05_06', 1, [5 6], '05BPM06'
%     37,	'SR/DI-BPM/S05_07', 1, [5 7], '05BPM07'
%     38,	'SR/DI-BPM/S06_01', 1, [6 1], '06BPM01'
%     39,	'SR/DI-BPM/S06_02', 1, [6 2], '06BPM02'
%     41,	'SR/DI-BPM/S06_04', 1, [6 4], '06BPM04'
%     42,	'SR/DI-BPM/S06_05', 1, [6 5], '06BPM05'
%     44,	'SR/DI-BPM/S06_07', 1, [6 7], '06BPM07'
%     45,	'SR/DI-BPM/S06_08', 1, [6 8], '06BPM08'
%     46,	'SR/DI-BPM/S07_01', 1, [7 1], '07BPM01'
%     47,	'SR/DI-BPM/S07_02', 1, [7 2], '07BPM02'
%     49,	'SR/DI-BPM/S07_04', 1, [7 4], '07BPM04'
%     50,	'SR/DI-BPM/S07_05', 1, [7 5], '07BPM05'
%     52,	'SR/DI-BPM/S07_07', 1, [7 7], '07BPM07'
%     53,	'SR/DI-BPM/S07_08', 1, [7 8], '07BPM08'
%     54,	'SR/DI-BPM/S08_01', 1, [8 1], '08BPM01'
%     55,	'SR/DI-BPM/S08_02', 1, [8 2], '08BPM02'
%     57,	'SR/DI-BPM/S08_04', 1, [8 4], '08BPM04'
%     59,	'SR/DI-BPM/S08_06', 1, [8 6], '08BPM06'
%     60,	'SR/DI-BPM/S08_07', 1, [8 7], '08BPM07'
%     61,	'SR/DI-BPM/S09_01', 1, [9 1], '09BPM01'
%     62,	'SR/DI-BPM/S09_02', 1, [9 2], '09BPM02'
%     64,	'SR/DI-BPM/S09_04', 1, [9 4], '09BPM04'
%     66,	'SR/DI-BPM/S09_06', 1, [9 6], '09BPM06'
%     67,	'SR/DI-BPM/S09_07', 1, [9 7], '09BPM07'
%     68,	'SR/DI-BPM/S10_01', 1, [10 1],'10BPM01'
%     69,	'SR/DI-BPM/S10_02', 1, [10 2],'10BPM02'
%     71,	'SR/DI-BPM/S10_04', 1, [10 4],'10BPM04'
%     72,	'SR/DI-BPM/S10_05', 1, [10 5],'10BPM05'
%     74,	'SR/DI-BPM/S10_07', 1, [10 7],'10BPM07'
%     75,	'SR/DI-BPM/S10_08', 1, [10 8],'10BPM08'
%     76,	'SR/DI-BPM/S11_01', 1, [11 1],'11BPM01'
%     77,	'SR/DI-BPM/S11_02', 1, [11 2],'11BPM02'
%     79,	'SR/DI-BPM/S11_04', 1, [11 4],'11BPM04'
%     80,	'SR/DI-BPM/S11_05', 1, [11 5],'11BPM05'
%     82,	'SR/DI-BPM/S11_07', 1, [11 7],'11BPM07'
%     83,	'SR/DI-BPM/S11_08', 1, [11 8],'11BPM08'
%     84,	'SR/DI-BPM/S12_01', 1, [12 1],'12BPM01'
%     85,	'SR/DI-BPM/S12_02', 1, [12 2],'12BPM02'
%     87,	'SR/DI-BPM/S12_04', 1, [12 4],'12BPM04'
%     89,	'SR/DI-BPM/S12_06', 1, [12 6],'12BPM06'
%     90,	'SR/DI-BPM/S12_07', 1, [12 7],'12BPM07'
%     91,	'SR/DI-BPM/S13_01', 1, [13 1],'13BPM01'
%     92,	'SR/DI-BPM/S13_02', 1, [13 2],'13BPM02'
%     94,	'SR/DI-BPM/S13_04', 1, [13 4],'13BPM04'
%     96,	'SR/DI-BPM/S13_06', 1, [13 6],'13BPM06'
%     97,	'SR/DI-BPM/S13_07', 1, [13 7],'13BPM07'
%     98,	'SR/DI-BPM/S14_01', 1, [14 1],'14BPM01'
%     99,	'SR/DI-BPM/S14_02', 1, [14 2],'14BPM02'
%    101,	'SR/DI-BPM/S14_04', 1, [14 4],'14BPM04'
%    102,	'SR/DI-BPM/S14_05', 1, [14 5],'14BPM05'
%    104,	'SR/DI-BPM/S14_07', 1, [14 7],'14BPM07'
%    105,	'SR/DI-BPM/S14_08', 1, [14 8],'14BPM08'
%    106,	'SR/DI-BPM/S15_01', 1, [15 1],'15BPM01'
%    107,	'SR/DI-BPM/S15_02', 1, [15 2],'15BPM02'
%    109,	'SR/DI-BPM/S15_04', 1, [15 4],'15BPM04'
%    110,	'SR/DI-BPM/S15_05', 1, [15 5],'15BPM05'
%    112,	'SR/DI-BPM/S15_07', 1, [15 7],'15BPM07'
%    113,	'SR/DI-BPM/S15_08', 1, [15 8],'15BPM08'
%    114,	'SR/DI-BPM/S16_01', 1, [16 1],'16BPM01'
%    115,	'SR/DI-BPM/S16_02', 1, [16 2],'16BPM02'
%    117,	'SR/DI-BPM/S16_04', 1, [16 4],'16BPM04'
%    119,	'SR/DI-BPM/S16_06', 1, [16 6],'16BPM06'
%    120,	'SR/DI-BPM/S16_07', 1, [16 7],'16BPM07'
%     };

%Load fields from data block
for ii=1:size(bpm,1)
    AO.(iFam).ElementList(ii,:)        = bpm{ii,1};
    AO.(iFam).DeviceName(ii,:)         = bpm(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(bpm(ii,2), '/XposSA');
    AO.(iFam).Status(ii,:)             = bpm{ii,3};
    AO.(iFam).DeviceList(ii,:)         = bpm{ii,4};
    AO.(iFam).CommonNames(ii,:)        = bpm{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams(ii,:) = 1e-3;
    AO.(iFam).Monitor.Physics2HWParams(ii,:) = 1e3;
end

% Scalar channel method
AO.(iFam).Monitor.DataType = 'Scalar';

%=============================================
%% BPMy data: status field designates if BPM in use
%=============================================

iFam = 'BPMy';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).MemberOf                 = {'PlotFamily'; 'VBPM'; 'BPM'; 'Diagnostics'};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'mm';
AO.(iFam).Monitor.PhysicsUnits     = 'meter';
%  ElemList TangoName    Status DevList Common name
bpm={
    1,	'SR/DI-BPM/S01_01', 1, [1 1], '01BPM01'
    2,	'SR/DI-BPM/S01_02', 1, [1 2], '01BPM02'
    3,	'SR/DI-BPM/S01_03', 0, [1 3], '01BPM03'
    4,	'SR/DI-BPM/S01_04', 1, [1 4], '01BPM04'
    5,	'SR/DI-BPM/S01_05', 0, [1 5], '01BPM05'
    6,	'SR/DI-BPM/S01_06', 1, [1 6], '01BPM06'
    7,	'SR/DI-BPM/S01_07', 1, [1 7], '01BPM07'
    8,	'SR/DI-BPM/S02_01', 1, [2 1], '02BPM01'
    9,	'SR/DI-BPM/S02_02', 1, [2 2], '02BPM02'
    10,	'SR/DI-BPM/S02_03', 0, [2 3], '02BPM03'
    11,	'SR/DI-BPM/S02_04', 1, [2 4], '02BPM04'
    12,	'SR/DI-BPM/S02_05', 1, [2 5], '02BPM05'
    13,	'SR/DI-BPM/S02_06', 0, [2 6], '02BPM06'
    14,	'SR/DI-BPM/S02_07', 1, [2 7], '02BPM07'
    15,	'SR/DI-BPM/S02_08', 1, [2 8], '02BPM08'
    16,	'SR/DI-BPM/S03_01', 1, [3 1], '03BPM01'
    17,	'SR/DI-BPM/S03_02', 1, [3 2], '03BPM02'
    18,	'SR/DI-BPM/S03_03', 0, [3 3], '03BPM03'
    19,	'SR/DI-BPM/S03_04', 1, [3 4], '03BPM04'
    20,	'SR/DI-BPM/S03_05', 1, [3 5], '03BPM05'
    21,	'SR/DI-BPM/S03_06', 0, [3 6], '03BPM06'
    22,	'SR/DI-BPM/S03_07', 1, [3 7], '03BPM07'
    23,	'SR/DI-BPM/S03_08', 1, [3 8], '03BPM08'
    24,	'SR/DI-BPM/S04_01', 1, [4 1], '01BPM01'
    25,	'SR/DI-BPM/S04_02', 1, [4 2], '04BPM02'
    26,	'SR/DI-BPM/S04_03', 0, [4 3], '04BPM03'
    27,	'SR/DI-BPM/S04_04', 1, [4 4], '04BPM04'
    28,	'SR/DI-BPM/S04_05', 0, [4 5], '04BPM05'
    29,	'SR/DI-BPM/S04_06', 1, [4 6], '04BPM06'
    30,	'SR/DI-BPM/S04_07', 1, [4 7], '04BPM07'
    31,	'SR/DI-BPM/S05_01', 1, [5 1], '05BPM01'
    32,	'SR/DI-BPM/S05_02', 1, [5 2], '05BPM02'
    33,	'SR/DI-BPM/S05_03', 0, [5 3], '05BPM03'
    34,	'SR/DI-BPM/S05_04', 1, [5 4], '05BPM04'
    35,	'SR/DI-BPM/S05_05', 0, [5 5], '05BPM05'
    36,	'SR/DI-BPM/S05_06', 1, [5 6], '05BPM06'
    37,	'SR/DI-BPM/S05_07', 1, [5 7], '05BPM07'
    38,	'SR/DI-BPM/S06_01', 1, [6 1], '06BPM01'
    39,	'SR/DI-BPM/S06_02', 1, [6 2], '06BPM02'
    40,	'SR/DI-BPM/S06_03', 0, [6 3], '06BPM03'
    41,	'SR/DI-BPM/S06_04', 1, [6 4], '06BPM04'
    42,	'SR/DI-BPM/S06_05', 1, [6 5], '06BPM05'
    43,	'SR/DI-BPM/S06_06', 0, [6 6], '06BPM06'
    44,	'SR/DI-BPM/S06_07', 1, [6 7], '06BPM07'
    45,	'SR/DI-BPM/S06_08', 1, [6 8], '06BPM08'
    46,	'SR/DI-BPM/S07_01', 1, [7 1], '07BPM01'
    47,	'SR/DI-BPM/S07_02', 1, [7 2], '07BPM02'
    48,	'SR/DI-BPM/S07_03', 0, [7 3], '07BPM03'
    49,	'SR/DI-BPM/S07_04', 1, [7 4], '07BPM04'
    50,	'SR/DI-BPM/S07_05', 1, [7 5], '07BPM05'
    51,	'SR/DI-BPM/S07_06', 0, [7 6], '07BPM06'
    52,	'SR/DI-BPM/S07_07', 1, [7 7], '07BPM07'
    53,	'SR/DI-BPM/S07_08', 1, [7 8], '07BPM08'
    54,	'SR/DI-BPM/S08_01', 1, [8 1], '08BPM01'
    55,	'SR/DI-BPM/S08_02', 1, [8 2], '08BPM02'
    56,	'SR/DI-BPM/S08_03', 0, [8 3], '08BPM03'
    57,	'SR/DI-BPM/S08_04', 1, [8 4], '08BPM04'
    58,	'SR/DI-BPM/S08_05', 0, [8 5], '08BPM05'
    59,	'SR/DI-BPM/S08_06', 1, [8 6], '08BPM06'
    60,	'SR/DI-BPM/S08_07', 1, [8 7], '08BPM07'
    61,	'SR/DI-BPM/S09_01', 1, [9 1], '09BPM01'
    62,	'SR/DI-BPM/S09_02', 1, [9 2], '09BPM02'
    63,	'SR/DI-BPM/S09_03', 0, [9 3], '09BPM03'
    64,	'SR/DI-BPM/S09_04', 1, [9 4], '09BPM04'
    65,	'SR/DI-BPM/S09_05', 0, [9 5], '09BPM05'
    66,	'SR/DI-BPM/S09_06', 1, [9 6], '09BPM06'
    67,	'SR/DI-BPM/S09_07', 1, [9 7], '09BPM07'
    68,	'SR/DI-BPM/S10_01', 1, [10 1],'10BPM01'
    69,	'SR/DI-BPM/S10_02', 1, [10 2],'10BPM02'
    70,	'SR/DI-BPM/S10_03', 0, [10 3],'10BPM03'
    71,	'SR/DI-BPM/S10_04', 1, [10 4],'10BPM04'
    72,	'SR/DI-BPM/S10_05', 1, [10 5],'10BPM05'
    73,	'SR/DI-BPM/S10_06', 0, [10 6],'10BPM06'
    74,	'SR/DI-BPM/S10_07', 1, [10 7],'10BPM07'
    75,	'SR/DI-BPM/S10_08', 1, [10 8],'10BPM08'
    76,	'SR/DI-BPM/S11_01', 1, [11 1],'11BPM01'
    77,	'SR/DI-BPM/S11_02', 1, [11 2],'11BPM02'
    78,	'SR/DI-BPM/S11_03', 0, [11 3],'11BPM03'
    79,	'SR/DI-BPM/S11_04', 1, [11 4],'11BPM04'
    80,	'SR/DI-BPM/S11_05', 1, [11 5],'11BPM05'
    81,	'SR/DI-BPM/S11_06', 0, [11 6],'11BPM06'
    82,	'SR/DI-BPM/S11_07', 1, [11 7],'11BPM07'
    83,	'SR/DI-BPM/S11_08', 1, [11 8],'11BPM08'
    84,	'SR/DI-BPM/S12_01', 1, [12 1],'12BPM01'
    85,	'SR/DI-BPM/S12_02', 1, [12 2],'12BPM02'
    86,	'SR/DI-BPM/S12_03', 0, [12 3],'12BPM03'
    87,	'SR/DI-BPM/S12_04', 1, [12 4],'12BPM04'
    88,	'SR/DI-BPM/S12_05', 0, [12 5],'12BPM05'
    89,	'SR/DI-BPM/S12_06', 1, [12 6],'12BPM06'
    90,	'SR/DI-BPM/S12_07', 1, [12 7],'12BPM07'
    91,	'SR/DI-BPM/S13_01', 1, [13 1],'13BPM01'
    92,	'SR/DI-BPM/S13_02', 1, [13 2],'13BPM02'
    93,	'SR/DI-BPM/S13_03', 0, [13 3],'13BPM03'
    94,	'SR/DI-BPM/S13_04', 1, [13 4],'13BPM04'
    95,	'SR/DI-BPM/S13_05', 0, [13 5],'13BPM05'
    96,	'SR/DI-BPM/S13_06', 1, [13 6],'13BPM06'
    97,	'SR/DI-BPM/S13_07', 1, [13 7],'13BPM07'
    98,	'SR/DI-BPM/S14_01', 1, [14 1],'14BPM01'
    99,	'SR/DI-BPM/S14_02', 1, [14 2],'14BPM02'
    100,	'SR/DI-BPM/S14_03', 0, [14 3],'14BPM03'
    101,	'SR/DI-BPM/S14_04', 1, [14 4],'14BPM04'
    102,	'SR/DI-BPM/S14_05', 1, [14 5],'14BPM05'
    103,	'SR/DI-BPM/S14_06', 0, [14 6],'14BPM06'
    104,	'SR/DI-BPM/S14_07', 1, [14 7],'14BPM07'
    105,	'SR/DI-BPM/S14_08', 1, [14 8],'14BPM08'
    106,	'SR/DI-BPM/S15_01', 1, [15 1],'15BPM01'
    107,	'SR/DI-BPM/S15_02', 1, [15 2],'15BPM02'
    108,	'SR/DI-BPM/S15_03', 0, [15 3],'15BPM03'
    109,	'SR/DI-BPM/S15_04', 1, [15 4],'15BPM04'
    110,	'SR/DI-BPM/S15_05', 1, [15 5],'15BPM05'
    111,	'SR/DI-BPM/S15_06', 0, [15 6],'15BPM06'
    112,	'SR/DI-BPM/S15_07', 1, [15 7],'15BPM07'
    113,	'SR/DI-BPM/S15_08', 1, [15 8],'15BPM08'
    114,	'SR/DI-BPM/S16_01', 1, [16 1],'16BPM01'
    115,	'SR/DI-BPM/S16_02', 1, [16 2],'16BPM02'
    116,	'SR/DI-BPM/S16_03', 0, [16 3],'16BPM03'
    117,	'SR/DI-BPM/S16_04', 1, [16 4],'16BPM04'
    118,	'SR/DI-BPM/S16_05', 0, [16 5],'16BPM05'
    119,	'SR/DI-BPM/S16_06', 1, [16 6],'16BPM06'
    120,	'SR/DI-BPM/S16_07', 1, [16 7],'16BPM07'
    };

% bpm={
%      1,	'SR/DI-BPM/S01_01', 1, [1 1], '01BPM01'
%      2,	'SR/DI-BPM/S01_02', 1, [1 2], '01BPM02'
%      4,	'SR/DI-BPM/S01_04', 1, [1 4], '01BPM04'
%      6,	'SR/DI-BPM/S01_06', 1, [1 6], '01BPM06'
%      7,	'SR/DI-BPM/S01_07', 1, [1 7], '01BPM07'
%      8,	'SR/DI-BPM/S02_01', 1, [2 1], '02BPM01'
%      9,	'SR/DI-BPM/S02_02', 1, [2 2], '02BPM02'
%     11,	'SR/DI-BPM/S02_04', 1, [2 4], '02BPM04'
%     12,	'SR/DI-BPM/S02_05', 1, [2 5], '02BPM05'
%     14,	'SR/DI-BPM/S02_07', 1, [2 7], '02BPM07'
%     15,	'SR/DI-BPM/S02_08', 1, [2 8], '02BPM08'
%     16,	'SR/DI-BPM/S03_01', 1, [3 1], '03BPM01'
%     17,	'SR/DI-BPM/S03_02', 1, [3 2], '03BPM02'
%     19,	'SR/DI-BPM/S03_04', 1, [3 4], '03BPM04'
%     20,	'SR/DI-BPM/S03_05', 1, [3 5], '03BPM05'
%     22,	'SR/DI-BPM/S03_07', 1, [3 7], '03BPM07'
%     23,	'SR/DI-BPM/S03_08', 1, [3 8], '03BPM08'
%     24,	'SR/DI-BPM/S04_01', 1, [4 1], '01BPM01'
%     25,	'SR/DI-BPM/S04_02', 1, [4 2], '04BPM02'
%     27,	'SR/DI-BPM/S04_04', 1, [4 4], '04BPM04'
%     29,	'SR/DI-BPM/S04_06', 1, [4 6], '04BPM06'
%     30,	'SR/DI-BPM/S04_07', 1, [4 7], '04BPM07'
%     31,	'SR/DI-BPM/S05_01', 1, [5 1], '05BPM01'
%     32,	'SR/DI-BPM/S05_02', 1, [5 2], '05BPM02'
%     34,	'SR/DI-BPM/S05_04', 1, [5 4], '05BPM04'
%     36,	'SR/DI-BPM/S05_06', 1, [5 6], '05BPM06'
%     37,	'SR/DI-BPM/S05_07', 1, [5 7], '05BPM07'
%     38,	'SR/DI-BPM/S06_01', 1, [6 1], '06BPM01'
%     39,	'SR/DI-BPM/S06_02', 1, [6 2], '06BPM02'
%     41,	'SR/DI-BPM/S06_04', 1, [6 4], '06BPM04'
%     42,	'SR/DI-BPM/S06_05', 1, [6 5], '06BPM05'
%     44,	'SR/DI-BPM/S06_07', 1, [6 7], '06BPM07'
%     45,	'SR/DI-BPM/S06_08', 1, [6 8], '06BPM08'
%     46,	'SR/DI-BPM/S07_01', 1, [7 1], '07BPM01'
%     47,	'SR/DI-BPM/S07_02', 1, [7 2], '07BPM02'
%     49,	'SR/DI-BPM/S07_04', 1, [7 4], '07BPM04'
%     50,	'SR/DI-BPM/S07_05', 1, [7 5], '07BPM05'
%     52,	'SR/DI-BPM/S07_07', 1, [7 7], '07BPM07'
%     53,	'SR/DI-BPM/S07_08', 1, [7 8], '07BPM08'
%     54,	'SR/DI-BPM/S08_01', 1, [8 1], '08BPM01'
%     55,	'SR/DI-BPM/S08_02', 1, [8 2], '08BPM02'
%     57,	'SR/DI-BPM/S08_04', 1, [8 4], '08BPM04'
%     59,	'SR/DI-BPM/S08_06', 1, [8 6], '08BPM06'
%     60,	'SR/DI-BPM/S08_07', 1, [8 7], '08BPM07'
%     61,	'SR/DI-BPM/S09_01', 1, [9 1], '09BPM01'
%     62,	'SR/DI-BPM/S09_02', 1, [9 2], '09BPM02'
%     64,	'SR/DI-BPM/S09_04', 1, [9 4], '09BPM04'
%     66,	'SR/DI-BPM/S09_06', 1, [9 6], '09BPM06'
%     67,	'SR/DI-BPM/S09_07', 1, [9 7], '09BPM07'
%     68,	'SR/DI-BPM/S10_01', 1, [10 1],'10BPM01'
%     69,	'SR/DI-BPM/S10_02', 1, [10 2],'10BPM02'
%     71,	'SR/DI-BPM/S10_04', 1, [10 4],'10BPM04'
%     72,	'SR/DI-BPM/S10_05', 1, [10 5],'10BPM05'
%     74,	'SR/DI-BPM/S10_07', 1, [10 7],'10BPM07'
%     75,	'SR/DI-BPM/S10_08', 1, [10 8],'10BPM08'
%     76,	'SR/DI-BPM/S11_01', 1, [11 1],'11BPM01'
%     77,	'SR/DI-BPM/S11_02', 1, [11 2],'11BPM02'
%     79,	'SR/DI-BPM/S11_04', 1, [11 4],'11BPM04'
%     80,	'SR/DI-BPM/S11_05', 1, [11 5],'11BPM05'
%     82,	'SR/DI-BPM/S11_07', 1, [11 7],'11BPM07'
%     83,	'SR/DI-BPM/S11_08', 1, [11 8],'11BPM08'
%     84,	'SR/DI-BPM/S12_01', 1, [12 1],'12BPM01'
%     85,	'SR/DI-BPM/S12_02', 1, [12 2],'12BPM02'
%     87,	'SR/DI-BPM/S12_04', 1, [12 4],'12BPM04'
%     89,	'SR/DI-BPM/S12_06', 1, [12 6],'12BPM06'
%     90,	'SR/DI-BPM/S12_07', 1, [12 7],'12BPM07'
%     91,	'SR/DI-BPM/S13_01', 1, [13 1],'13BPM01'
%     92,	'SR/DI-BPM/S13_02', 1, [13 2],'13BPM02'
%     94,	'SR/DI-BPM/S13_04', 1, [13 4],'13BPM04'
%     96,	'SR/DI-BPM/S13_06', 1, [13 6],'13BPM06'
%     97,	'SR/DI-BPM/S13_07', 1, [13 7],'13BPM07'
%     98,	'SR/DI-BPM/S14_01', 1, [14 1],'14BPM01'
%     99,	'SR/DI-BPM/S14_02', 1, [14 2],'14BPM02'
%    101,	'SR/DI-BPM/S14_04', 1, [14 4],'14BPM04'
%    102,	'SR/DI-BPM/S14_05', 1, [14 5],'14BPM05'
%    104,	'SR/DI-BPM/S14_07', 1, [14 7],'14BPM07'
%    105,	'SR/DI-BPM/S14_08', 1, [14 8],'14BPM08'
%    106,	'SR/DI-BPM/S15_01', 1, [15 1],'15BPM01'
%    107,	'SR/DI-BPM/S15_02', 1, [15 2],'15BPM02'
%    109,	'SR/DI-BPM/S15_04', 1, [15 4],'15BPM04'
%    110,	'SR/DI-BPM/S15_05', 1, [15 5],'15BPM05'
%    112,	'SR/DI-BPM/S15_07', 1, [15 7],'15BPM07'
%    113,	'SR/DI-BPM/S15_08', 1, [15 8],'15BPM08'
%    114,	'SR/DI-BPM/S16_01', 1, [16 1],'16BPM01'
%    115,	'SR/DI-BPM/S16_02', 1, [16 2],'16BPM02'
%    117,	'SR/DI-BPM/S16_04', 1, [16 4],'16BPM04'
%    119,	'SR/DI-BPM/S16_06', 1, [16 6],'16BPM06'
%    120,	'SR/DI-BPM/S16_07', 1, [16 7],'16BPM07'
%     };

%Load fields from data block
for ii=1:size(bpm,1)
    AO.(iFam).ElementList(ii,:)        = bpm{ii,1};
    AO.(iFam).DeviceName(ii,:)         = bpm(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(bpm(ii,2), '/ZposSA');
    AO.(iFam).Status(ii,:)             = bpm{ii,3};
    AO.(iFam).DeviceList(ii,:)         = bpm{ii,4};
    AO.(iFam).CommonNames(ii,:)        = bpm{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams(ii,:) = 1e-3;
    AO.(iFam).Monitor.Physics2HWParams(ii,:) = 1e3;
end


% Scalar channel method
AO.(iFam).Monitor.DataType = 'Scalar';

%===========================================================
%% HCM
%===========================================================

iFam ='HCM';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).MemberOf                 = {'HCOR'; 'COR'; 'HCM'; 'Magnet'};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.DataType         = 'Scalar';
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'A';
AO.(iFam).Monitor.PhysicsUnits     = 'radian';
AO.(iFam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn = @k2amp;

AO.(iFam).Setpoint.MemberOf        = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode            = Mode;
AO.(iFam).Setpoint.DataType        = 'Scalar';
AO.(iFam).Setpoint.Units           = 'Hardware';
AO.(iFam).Setpoint.HWUnits         = 'A';
AO.(iFam).Setpoint.PhysicsUnits    = 'radian';
AO.(iFam).Setpoint.HW2PhysicsFcn = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn = @k2amp;



%  ElemList TangoName    Status DevList Common name
cor={
    1,	'SR/PC-CORH/S01_01', 1, [01 01], '01HCM01'
    2,	'SR/PC-CORH/S01_02', 1, [01 02], '01HCM02'
    3,	'SR/PC-CORH/S01_03', 1, [01 03], '01HCM03'
    4,	'SR/PC-CORH/S01_04', 1, [01 04], '01HCM04'
    5,	'SR/PC-CORH/S01_05', 1, [01 05], '01HCM05'
    6,	'SR/PC-CORH/S02_01', 1, [02 01], '02HCM01'
    7,	'SR/PC-CORH/S02_02', 1, [02 02], '02HCM02'
    8,	'SR/PC-CORH/S02_03', 1, [02 03], '02HCM03'
    9,	'SR/PC-CORH/S02_04', 1, [02 04], '02HCM04'
    10,	'SR/PC-CORH/S02_05', 1, [02 05], '02HCM05'
    11,	'SR/PC-CORH/S02_06', 1, [02 06], '02HCM06'
    12,	'SR/PC-CORH/S03_01', 1, [03 01], '03HCM01'
    13,	'SR/PC-CORH/S03_02', 1, [03 02], '03HCM02'
    14,	'SR/PC-CORH/S03_03', 1, [03 03], '03HCM03'
    15,	'SR/PC-CORH/S03_04', 1, [03 04], '03HCM04'
    16,	'SR/PC-CORH/S03_05', 1, [03 05], '03HCM05'
    17,	'SR/PC-CORH/S03_06', 1, [03 06], '03HCM06'
    18,	'SR/PC-CORH/S04_01', 1, [04 01], '04HCM01'
    19,	'SR/PC-CORH/S04_02', 1, [04 02], '04HCM02'
    20,	'SR/PC-CORH/S04_03', 1, [04 03], '04HCM03'
    21,	'SR/PC-CORH/S04_04', 1, [04 04], '04HCM04'
    22,	'SR/PC-CORH/S04_05', 1, [04 05], '04HCM05'
    23,	'SR/PC-CORH/S05_01', 1, [05 01], '05HCM01'
    24,	'SR/PC-CORH/S05_02', 1, [05 02], '05HCM02'
    25,	'SR/PC-CORH/S05_03', 1, [05 03], '05HCM03'
    26,	'SR/PC-CORH/S05_04', 1, [05 04], '05HCM04'
    27,	'SR/PC-CORH/S05_05', 1, [05 05], '05HCM05'
    28,	'SR/PC-CORH/S06_01', 1, [06 01], '06HCM01'
    29,	'SR/PC-CORH/S06_02', 1, [06 02], '06HCM02'
    30,	'SR/PC-CORH/S06_03', 1, [06 03], '06HCM03'
    31,	'SR/PC-CORH/S06_04', 1, [06 04], '06HCM04'
    32,	'SR/PC-CORH/S06_05', 1, [06 05], '06HCM05'
    33,	'SR/PC-CORH/S06_06', 1, [06 06], '06HCM06'
    34,	'SR/PC-CORH/S07_01', 1, [07 01], '07HCM01'
    35,	'SR/PC-CORH/S07_02', 1, [07 02], '07HCM02'
    36,	'SR/PC-CORH/S07_03', 1, [07 03], '07HCM03'
    37,	'SR/PC-CORH/S07_04', 1, [07 04], '07HCM04'
    38,	'SR/PC-CORH/S07_05', 1, [07 05], '07HCM05'
    39,	'SR/PC-CORH/S07_06', 1, [07 06], '07HCM06'
    40,	'SR/PC-CORH/S08_01', 1, [08 01], '08HCM01'
    41,	'SR/PC-CORH/S08_02', 1, [08 02], '08HCM02'
    42,	'SR/PC-CORH/S08_03', 1, [08 03], '08HCM03'
    43,	'SR/PC-CORH/S08_04', 1, [08 04], '08HCM04'
    44,	'SR/PC-CORH/S08_05', 1, [08 05], '08HCM05'
    45,	'SR/PC-CORH/S09_01', 1, [09 01], '09HCM01'
    46,	'SR/PC-CORH/S09_02', 1, [09 02], '09HCM02'
    47,	'SR/PC-CORH/S09_03', 1, [09 03], '09HCM03'
    48,	'SR/PC-CORH/S09_04', 1, [09 04], '09HCM04'
    49,	'SR/PC-CORH/S09_05', 1, [09 05], '09HCM05'
    50,	'SR/PC-CORH/S10_01', 1, [10 01], '10HCM01'
    51,	'SR/PC-CORH/S10_02', 1, [10 02], '10HCM02'
    52,	'SR/PC-CORH/S10_03', 1, [10 03], '10HCM03'
    53,	'SR/PC-CORH/S10_04', 1, [10 04], '10HCM04'
    54,	'SR/PC-CORH/S10_05', 1, [10 05], '10HCM05'
    55,	'SR/PC-CORH/S10_06', 1, [10 06], '10HCM06'
    56,	'SR/PC-CORH/S11_01', 1, [11 01], '11HCM01'
    57,	'SR/PC-CORH/S11_02', 1, [11 02], '11HCM02'
    58,	'SR/PC-CORH/S11_03', 1, [11 03], '11HCM03'
    59,	'SR/PC-CORH/S11_04', 1, [11 04], '11HCM04'
    60,	'SR/PC-CORH/S11_05', 1, [11 05], '11HCM05'
    61,	'SR/PC-CORH/S11_06', 1, [11 06], '11HCM06'
    62,	'SR/PC-CORH/S12_01', 1, [12 01], '12HCM01'
    63,	'SR/PC-CORH/S12_02', 1, [12 02], '12HCM02'
    64,	'SR/PC-CORH/S12_03', 1, [12 03], '12HCM03'
    65,	'SR/PC-CORH/S12_04', 1, [12 04], '12HCM04'
    66,	'SR/PC-CORH/S12_05', 1, [12 05], '12HCM05'
    67,	'SR/PC-CORH/S13_01', 1, [13 01], '13HCM01'
    68,	'SR/PC-CORH/S13_02', 1, [13 02], '13HCM02'
    69,	'SR/PC-CORH/S13_03', 1, [13 03], '13HCM03'
    70,	'SR/PC-CORH/S13_04', 1, [13 04], '13HCM04'
    71,	'SR/PC-CORH/S13_05', 1, [13 05], '13HCM05'
    72,	'SR/PC-CORH/S14_01', 1, [14 01], '14HCM01'
    73,	'SR/PC-CORH/S14_02', 1, [14 02], '14HCM02'
    74,	'SR/PC-CORH/S14_03', 1, [14 03], '14HCM03'
    75,	'SR/PC-CORH/S14_04', 1, [14 04], '14HCM04'
    76,	'SR/PC-CORH/S14_05', 1, [14 05], '14HCM05'
    77,	'SR/PC-CORH/S02_06', 1, [14 06], '14HCM06'
    78,	'SR/PC-CORH/S15_01', 1, [15 01], '15HCM01'
    79,	'SR/PC-CORH/S15_02', 1, [15 02], '15HCM02'
    80,	'SR/PC-CORH/S15_03', 1, [15 03], '15HCM03'
    81,	'SR/PC-CORH/S15_04', 1, [15 04], '15HCM04'
    82,	'SR/PC-CORH/S15_05', 1, [15 05], '15HCM05'
    83,	'SR/PC-CORH/S15_06', 1, [15 06], '15HCM06'
    84,	'SR/PC-CORH/S16_01', 1, [16 01], '16HCM01'
    85,	'SR/PC-CORH/S16_02', 1, [16 02], '16HCM02'
    86,	'SR/PC-CORH/S16_03', 1, [16 03], '16HCM03'
    87,	'SR/PC-CORH/S16_04', 1, [16 04], '16HCM04'
    88,	'SR/PC-CORH/S16_05', 1, [16 05], '16HCM05'
    };


%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients('HCM');

for ii=1:size(cor,1)
    AO.(iFam).ElementList(ii,:)        = cor{ii,1};
    AO.(iFam).DeviceName(ii,:)         = cor(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(cor(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = cor{ii,3};
    AO.(iFam).DeviceList(ii,:)         = cor{ii,4};
    AO.(iFam).CommonNames(ii,:)        = cor{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(cor(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-10 10];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = coefficients;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = coefficients;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%% VCM

iFam ='VCM';

AO.(iFam).FamilyName               = iFam;
AO.(iFam).MemberOf                 = {'COR'; 'VCOR'; 'VCM'; 'Magnet'};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.DataType         = 'Scalar';
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'A';
AO.(iFam).Monitor.PhysicsUnits     = 'radian';
AO.(iFam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn = @k2amp;

AO.(iFam).Setpoint.MemberOf        = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode            = Mode;
AO.(iFam).Setpoint.DataType        = 'Scalar';
AO.(iFam).Setpoint.Units           = 'Hardware';
AO.(iFam).Setpoint.HWUnits         = 'A';
AO.(iFam).Setpoint.PhysicsUnits    = 'radian';
AO.(iFam).Setpoint.HW2PhysicsFcn = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn = @k2amp;

%  ElemList TangoName    Status DevList Common name
cor={
    1,	'SR/PC-CORV/S01_01', 1, [01 01], '01VCM01'
    2,	'SR/PC-CORV/S01_02', 1, [01 02], '01VCM02'
    3,	'SR/PC-CORV/S01_03', 1, [01 03], '01VCM03'
    4,	'SR/PC-CORV/S01_04', 1, [01 04], '01VCM04'
    5,	'SR/PC-CORV/S01_05', 1, [01 05], '01VCM05'
    6,	'SR/PC-CORV/S02_01', 1, [02 01], '02VCM01'
    7,	'SR/PC-CORV/S02_02', 1, [02 02], '02VCM02'
    8,	'SR/PC-CORV/S02_03', 1, [02 03], '02VCM03'
    9,	'SR/PC-CORV/S02_04', 1, [02 04], '02VCM04'
    10,	'SR/PC-CORV/S02_05', 1, [02 05], '02VCM05'
    11,	'SR/PC-CORV/S02_06', 1, [02 06], '02VCM06'
    12,	'SR/PC-CORV/S03_01', 1, [03 01], '03VCM01'
    13,	'SR/PC-CORV/S03_02', 1, [03 02], '03VCM02'
    14,	'SR/PC-CORV/S03_03', 1, [03 03], '03VCM03'
    15,	'SR/PC-CORV/S03_04', 1, [03 04], '03VCM04'
    16,	'SR/PC-CORV/S03_05', 1, [03 05], '03VCM05'
    17,	'SR/PC-CORV/S03_06', 1, [03 06], '03VCM06'
    18,	'SR/PC-CORV/S04_01', 1, [04 01], '04VCM01'
    19,	'SR/PC-CORV/S04_02', 1, [04 02], '04VCM02'
    20,	'SR/PC-CORV/S04_03', 1, [04 03], '04VCM03'
    21,	'SR/PC-CORV/S04_04', 1, [04 04], '04VCM04'
    22,	'SR/PC-CORV/S04_05', 1, [04 05], '04VCM05'
    23,	'SR/PC-CORV/S05_01', 1, [05 01], '05VCM01'
    24,	'SR/PC-CORV/S05_02', 1, [05 02], '05VCM02'
    25,	'SR/PC-CORV/S05_03', 1, [05 03], '05VCM03'
    26,	'SR/PC-CORV/S05_04', 1, [05 04], '05VCM04'
    27,	'SR/PC-CORV/S05_05', 1, [05 05], '05VCM05'
    28,	'SR/PC-CORV/S06_01', 1, [06 01], '06VCM01'
    29,	'SR/PC-CORV/S06_02', 1, [06 02], '06VCM02'
    30,	'SR/PC-CORV/S06_03', 1, [06 03], '06VCM03'
    31,	'SR/PC-CORV/S06_04', 1, [06 04], '06VCM04'
    32,	'SR/PC-CORV/S06_05', 1, [06 05], '06VCM05'
    33,	'SR/PC-CORV/S06_06', 1, [06 06], '06VCM06'
    34,	'SR/PC-CORV/S07_01', 1, [07 01], '07VCM01'
    35,	'SR/PC-CORV/S07_02', 1, [07 02], '07VCM02'
    36,	'SR/PC-CORV/S07_03', 1, [07 03], '07VCM03'
    37,	'SR/PC-CORV/S07_04', 1, [07 04], '07VCM04'
    38,	'SR/PC-CORV/S07_05', 1, [07 05], '07VCM05'
    39,	'SR/PC-CORV/S07_06', 1, [07 06], '07VCM06'
    40,	'SR/PC-CORV/S08_01', 1, [08 01], '08VCM01'
    41,	'SR/PC-CORV/S08_02', 1, [08 02], '08VCM02'
    42,	'SR/PC-CORV/S08_03', 1, [08 03], '08VCM03'
    43,	'SR/PC-CORV/S08_04', 1, [08 04], '08VCM04'
    44,	'SR/PC-CORV/S08_05', 1, [08 05], '08VCM05'
    45,	'SR/PC-CORV/S09_01', 1, [09 01], '09VCM01'
    46,	'SR/PC-CORV/S09_02', 1, [09 02], '09VCM02'
    47,	'SR/PC-CORV/S09_03', 1, [09 03], '09VCM03'
    48,	'SR/PC-CORV/S09_04', 1, [09 04], '09VCM04'
    49,	'SR/PC-CORV/S09_05', 1, [09 05], '09VCM05'
    50,	'SR/PC-CORV/S10_01', 1, [10 01], '10VCM01'
    51,	'SR/PC-CORV/S10_02', 1, [10 02], '10VCM02'
    52,	'SR/PC-CORV/S10_03', 1, [10 03], '10VCM03'
    53,	'SR/PC-CORV/S10_04', 1, [10 04], '10VCM04'
    54,	'SR/PC-CORV/S10_05', 1, [10 05], '10VCM05'
    55,	'SR/PC-CORV/S10_06', 1, [10 06], '10VCM06'
    56,	'SR/PC-CORV/S11_01', 1, [11 01], '11VCM01'
    57,	'SR/PC-CORV/S11_02', 1, [11 02], '11VCM02'
    58,	'SR/PC-CORV/S11_03', 1, [11 03], '11VCM03'
    59,	'SR/PC-CORV/S11_04', 1, [11 04], '11VCM04'
    60,	'SR/PC-CORV/S11_05', 1, [11 05], '11VCM05'
    61,	'SR/PC-CORV/S11_06', 1, [11 06], '11VCM06'
    62,	'SR/PC-CORV/S12_01', 1, [12 01], '12VCM01'
    63,	'SR/PC-CORV/S12_02', 1, [12 02], '12VCM02'
    64,	'SR/PC-CORV/S12_03', 1, [12 03], '12VCM03'
    65,	'SR/PC-CORV/S12_04', 1, [12 04], '12VCM04'
    66,	'SR/PC-CORV/S12_05', 1, [12 05], '12VCM05'
    67,	'SR/PC-CORV/S13_01', 1, [13 01], '13VCM01'
    68,	'SR/PC-CORV/S13_02', 1, [13 02], '13VCM02'
    69,	'SR/PC-CORV/S13_03', 1, [13 03], '13VCM03'
    70,	'SR/PC-CORV/S13_04', 1, [13 04], '13VCM04'
    71,	'SR/PC-CORV/S13_05', 1, [13 05], '13VCM05'
    72,	'SR/PC-CORV/S14_01', 1, [14 01], '14VCM01'
    73,	'SR/PC-CORV/S14_02', 1, [14 02], '14VCM02'
    74,	'SR/PC-CORV/S14_03', 1, [14 03], '14VCM03'
    75,	'SR/PC-CORV/S14_04', 1, [14 04], '14VCM04'
    76,	'SR/PC-CORV/S14_05', 1, [14 05], '14VCM05'
    77,	'SR/PC-CORV/S14_06', 1, [14 06], '02VCM06'
    78,	'SR/PC-CORV/S15_01', 1, [15 01], '15VCM01'
    79,	'SR/PC-CORV/S15_02', 1, [15 02], '15VCM02'
    80,	'SR/PC-CORV/S15_03', 1, [15 03], '15VCM03'
    81,	'SR/PC-CORV/S15_04', 1, [15 04], '15VCM04'
    82,	'SR/PC-CORV/S15_05', 1, [15 05], '15VCM05'
    83,	'SR/PC-CORV/S15_06', 1, [15 06], '15VCM06'
    84,	'SR/PC-CORV/S16_01', 1, [16 01], '16VCM01'
    85,	'SR/PC-CORV/S16_02', 1, [16 02], '16VCM02'
    86,	'SR/PC-CORV/S16_03', 1, [16 03], '16VCM03'
    87,	'SR/PC-CORV/S16_04', 1, [16 04], '16VCM04'
    88,	'SR/PC-CORV/S16_05', 1, [16 05], '16VCM05'
    };


%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients('VCM');

for ii=1:size(cor,1)
    AO.(iFam).ElementList(ii,:)        = cor{ii,1};
    AO.(iFam).DeviceName(ii,:)         = cor(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(cor(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = cor{ii,3};
    AO.(iFam).DeviceList(ii,:)         = cor{ii,4};
    AO.(iFam).CommonNames(ii,:)        = cor{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(cor(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-10 10];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = coefficients;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = coefficients;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%=============================
%        MAIN MAGNETS
%=============================

%===========
%%Dipole data
%===========

%% *** BEND ***
iFam = 'BEND';
AO.(iFam).FamilyName                 = 'BEND';
AO.(iFam).MemberOf                   = {'BEND'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('BEND');
Physics2HWParams                    = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @bend2gev;
AO.(iFam).Monitor.Physics2HWFcn      = @gev2bend;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'rad';


AO.(iFam).DeviceName(:,:) = {'SR/PC-BEND/B0'};
AO.(iFam).Monitor.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName(:,:),'/current');

AO.(iFam).DeviceList(:,:) = [1 1];
AO.(iFam).ElementList(:,:)= 1;
AO.(iFam).Status          = 1;

val = 1;
AO.(iFam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(iFam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(iFam).Monitor.Range(:,:) = [0 600]; % 580 A for 1.4214 T @ 3 GeV

AO.(iFam).Setpoint.MemberOf        = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.05;

%QUADRUPOLES
%% *** QF1 ***
iFam = 'QF1';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH01/S01-02', 1, [01 1], '01_QH01_02'
    2,	'SR/PC-QH01/S04-07', 1, [04 1], '04_QH01_07'
    3,	'SR/PC-QH01/S05-02', 1, [05 1], '05_QH01_02'
    4,	'SR/PC-QH01/S08-07', 1, [08 1], '08_QH01_07'
    5,	'SR/PC-QH01/S09-02', 1, [09 1], '09_QH01_02'
    6,	'SR/PC-QH01/S12-07', 1, [12 1], '12_QH01_07'
    7,	'SR/PC-QH01/S13-02', 1, [13 1], '13_QH01_02'
    8,	'SR/PC-QH01/S16-07', 1, [16 1], '16_QH01_07'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF2 ***
iFam = 'QF2';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH02/S01-03', 1, [01 1], '01_QH02_03'
    2,	'SR/PC-QH02/S04-06', 1, [04 1], '04_QH02_06'
    3,	'SR/PC-QH02/S05-03', 1, [05 1], '05_QH02_03'
    4,	'SR/PC-QH02/S08-06', 1, [08 1], '06_QH02_06'
    5,	'SR/PC-QH02/S09-03', 1, [09 1], '09_QH02_03'
    6,	'SR/PC-QH02/S12-06', 1, [12 1], '12_QH02_06'
    7,	'SR/PC-QH02/S13-03', 1, [13 1], '13_QH02_03'
    8,	'SR/PC-QH02/S16-06', 1, [16 1], '16_QH02_06'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF3 ***
iFam = 'QF3';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH03/S01-04', 1, [01 1], '01_QH03_04'
    2,	'SR/PC-QH03/S04-05', 1, [04 1], '04_QH03_05'
    3,	'SR/PC-QH03/S05-04', 1, [05 1], '05_QH03_04'
    4,	'SR/PC-QH03/S08-05', 1, [08 1], '08_QH03_05'
    5,	'SR/PC-QH03/S09-04', 1, [09 1], '09_QH03_04'
    6,	'SR/PC-QH03/S12-05', 1, [12 1], '12_QH03_05'
    7,	'SR/PC-QH03/S13-04', 1, [13 1], '13_QH03_04'
    8,	'SR/PC-QH03/S16-05', 1, [16 1], '16_QH03_05'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);

for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);



%% *** QF4 ***
iFam = 'QF4';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH04/S01-05', 1, [01 1], '01_QH04_05'
    2,	'SR/PC-QH04/S04-04', 1, [04 1], '04_QH04_04'
    3,	'SR/PC-QH04/S05-05', 1, [05 1], '05_QH04_05'
    4,	'SR/PC-QH04/S08-04', 1, [08 1], '08_QH04_04'
    5,	'SR/PC-QH04/S09-05', 1, [09 1], '09_QH04_05'
    6,	'SR/PC-QH04/S12-04', 1, [12 1], '12_QH04_04'
    7,	'SR/PC-QH04/S13-05', 1, [13 1], '13_QH04_05'
    8,	'SR/PC-QH04/S16-04', 1, [16 1], '16_QH04_04'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF5 ***
iFam = 'QF5';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH05/S01-06', 1, [01 1], '01_QH05_06'
    2,	'SR/PC-QH05/S04-03', 1, [04 1], '04_QH05_03'
    3,	'SR/PC-QH05/S05-06', 1, [05 1], '05_QH05_06'
    4,	'SR/PC-QH05/S08-03', 1, [08 1], '08_QH05_03'
    5,	'SR/PC-QH05/S09-06', 1, [09 1], '09_QH05_06'
    6,	'SR/PC-QH05/S12-03', 1, [12 1], '12_QH05_03'
    7,	'SR/PC-QH05/S13-06', 1, [13 1], '13_QH05_06'
    8,	'SR/PC-QH05/S16-03', 1, [16 1], '16_QH05_03'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF6 ***
iFam = 'QF6';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH06/S01-07', 1, [01 1], '01_QH06_07'
    2,	'SR/PC-QH06/S04-02', 1, [04 1], '04_QH06_02'
    3,	'SR/PC-QH06/S05-07', 1, [05 1], '05_QH06_07'
    4,	'SR/PC-QH06/S08-02', 1, [08 1], '08_QH06_02'
    5,	'SR/PC-QH06/S09-07', 1, [09 1], '09_QH06_07'
    6,	'SR/PC-QH06/S12-02', 1, [12 1], '12_QH06_02'
    7,	'SR/PC-QH06/S13-07', 1, [13 1], '13_QH06_07'
    8,	'SR/PC-QH06/S16-02', 1, [16 1], '16_QH06_02'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 225];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF7 ***
iFam = 'QF7';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH07/S02-02', 1, [02 1], '02_QH07_02'
    2,	'SR/PC-QH07/S02-02', 1, [02 2], '02_QH07_02'
    3,	'SR/PC-QH07/S03-05', 1, [03 1], '03_QH07_05'
    4,	'SR/PC-QH07/S03-05', 1, [03 2], '03_QH07_05'
    5,	'SR/PC-QH07/S06-02', 1, [06 1], '06_QH07_02'
    6,	'SR/PC-QH07/S06-02', 1, [06 2], '06_QH07_02'
    7,	'SR/PC-QH07/S07-05', 1, [07 1], '07_QH07_05'
    8,	'SR/PC-QH07/S07-05', 1, [07 2], '07_QH07_05'
    9,	'SR/PC-QH07/S10-02', 1, [10 1], '10_QH07_02'
   10,	'SR/PC-QH07/S10-02', 1, [10 2], '10_QH07_02'
   11,	'SR/PC-QH07/S11-05', 1, [11 1], '11_QH07_05'
   12,	'SR/PC-QH07/S11-05', 1, [11 2], '11_QH07_05'
   13,	'SR/PC-QH07/S14-02', 1, [14 1], '14_QH07_02'
   14,	'SR/PC-QH07/S14-02', 1, [14 2], '14_QH07_02'
   15,	'SR/PC-QH07/S15-05', 1, [15 1], '15_QH07_05'
   16,	'SR/PC-QH07/S15-05', 1, [15 2], '15_QH07_05'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 225];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QF8 ***
iFam = 'QF8';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QH08/S02-03', 1, [02 1], '02_QH08_03'
    2,	'SR/PC-QH08/S02-03', 1, [02 2], '02_QH08_03'
    3,	'SR/PC-QH08/S03-04', 1, [03 1], '03_QH08_04'
    4,	'SR/PC-QH08/S03-04', 1, [03 2], '03_QH08_04'
    5,	'SR/PC-QH08/S06-03', 1, [06 1], '06_QH08_03'
    6,	'SR/PC-QH08/S06-03', 1, [06 2], '06_QH08_03'
    7,	'SR/PC-QH08/S07-04', 1, [07 1], '07_QH08_04'
    8,	'SR/PC-QH08/S07-04', 1, [07 2], '07_QH08_04'
    9,	'SR/PC-QH08/S10-03', 1, [10 1], '10_QH08_03'
   10,	'SR/PC-QH08/S10-03', 1, [10 2], '10_QH08_03'
   11,	'SR/PC-QH08/S11-04', 1, [11 1], '11_QH08_04'
   12,	'SR/PC-QH08/S11-04', 1, [11 2], '11_QH08_04'
   13,	'SR/PC-QH08/S14-03', 1, [14 1], '14_QH08_03'
   14,	'SR/PC-QH08/S14-03', 1, [14 2], '14_QH08_03'
   15,	'SR/PC-QH08/S15-04', 1, [15 1], '15_QH08_04'
   16,	'SR/PC-QH08/S15-04', 1, [15 2], '15_QH08_04'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [0 200];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%% *** QD1 ***
iFam = 'QD1';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QV01/S01-01', 1, [01 1], '01_QV01_01'
    2,	'SR/PC-QV01/S04-08', 1, [04 1], '04_QV01_08'
    3,	'SR/PC-QV01/S05-01', 1, [05 1], '05_QV01_01'
    4,	'SR/PC-QV01/S08-08', 1, [08 1], '08_QV01_08'
    5,	'SR/PC-QV01/S09-01', 1, [09 1], '09_QV01_01'
    6,	'SR/PC-QV01/S12-08', 1, [12 1], '12_QV01_08'
    7,	'SR/PC-QV01/S13-01', 1, [13 1], '13_QV01_01'
    8,	'SR/PC-QV01/S16-08', 1, [16 1], '16_QV01_08'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-200 0];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);



%% *** QD2 ***
iFam = 'QD2';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QV02/S01-08', 1, [01 1], '01_QV02_08'
    2,	'SR/PC-QV02/S04-01', 1, [04 1], '04_QV02_01'
    3,	'SR/PC-QV02/S05-08', 1, [05 1], '05_QV02_08'
    4,	'SR/PC-QV02/S08-01', 1, [08 1], '08_QV02_01'
    5,	'SR/PC-QV02/S09-08', 1, [09 1], '09_QV02_08'
    6,	'SR/PC-QV02/S12-01', 1, [12 1], '12_QV02_01'
    7,	'SR/PC-QV02/S13-08', 1, [13 1], '13_QV02_08'
    8,	'SR/PC-QV02/S16-01', 1, [16 1], '16_QV02_01'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-200 0];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);


%% *** QD3 ***
iFam = 'QD3';
AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
quad={
    1,	'SR/PC-QV03/S02-01', 1, [02 1], '02_QV03_01'
    2,	'SR/PC-QV03/S02-01', 1, [02 2], '02_QV03_01'
    3,	'SR/PC-QV03/S03-06', 1, [03 1], '03_QV03_06'
    4,	'SR/PC-QV03/S03-06', 1, [03 2], '03_QV03_06'
    5,	'SR/PC-QV03/S06-01', 1, [06 1], '06_QV03_01'
    6,	'SR/PC-QV03/S06-01', 1, [06 2], '06_QV03_01'
    7,	'SR/PC-QV03/S07-06', 1, [07 1], '07_QV03_06'
    8,	'SR/PC-QV03/S07-06', 1, [07 2], '07_QV03_06'
    9,	'SR/PC-QV03/S10-01', 1, [10 1], '10_QV03_01'
   10,	'SR/PC-QV03/S10-01', 1, [10 2], '10_QV03_01'
   11,	'SR/PC-QV03/S11-06', 1, [11 1], '11_QV03_06'
   12,	'SR/PC-QV03/S11-06', 1, [11 2], '11_QV03_06'
   13,	'SR/PC-QV03/S14-01', 1, [14 1], '14_QV03_01'
   14,	'SR/PC-QV03/S14-01', 1, [14 2], '14_QV03_01'
   15,	'SR/PC-QV03/S15-06', 1, [15 1], '15_QV03_06'
   16,	'SR/PC-QV03/S15-06', 1, [15 2], '15_QV03_06'
    };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


for ii=1:size(quad,1)
    AO.(iFam).ElementList(ii,:)        = quad{ii,1};
    AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = quad{ii,3};
    AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
    AO.(iFam).CommonNames(ii,:)        = quad{ii,5};
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-200 0];
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%===============
%Sextupole data
%===============
%% *** SF1 ***
iFam = 'SF1';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 1
    4 2
    5 1
    8 2
    9 1
    12 2
    15 1
    16 2
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SH1/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


%% *** SF2 ***
iFam = 'SF2';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 1
    4 1
    5 1
    8 1
    9 1
    12 1
    15 1
    16 1
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SH2/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


%% *** SF3 ***
iFam = 'SF3';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 2
    2 1
    2 2
    3 1
    3 2
    4 1
    5 2
    6 1
    6 2
    7 1
    7 2
    8 1
    9 2
    10 1
    10 2
    11 1
    11 2
    12 1
    13 2
    14 1
    14 2
    15 1
    15 2
    16 1
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SH3/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


%% *** SF4 ***
iFam = 'SF4';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    2 1
    2 2
    3 1
    3 2
    6 1
    6 2
    7 1
    7 2
    10 1
    10 2
    11 1
    11 2
    14 1
    14 2
    15 1
    15 2 ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SH4/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


%% *** SD1 ***
iFam = 'SD1';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 1
    4 2
    5 1
    8 2
    9 1
    12 2
    15 1
    16 2
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SV1/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 



%% *** SD2 ***
iFam = 'SD2';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 1
    4 2
    5 1
    8 2
    9 1
    12 2
    13 1
    16 2
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SV2/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


% *** SD3 ***
iFam = 'SD3';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet';};
AO.(iFam).DeviceList                 = [
    1 2
    4 1
    5 2
    8 1
    9 2
    12 1
    13 2
    16 1
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SV3/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 



%% *** SD4 ***
iFam = 'SD4';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    1 2
    2 1
    2 2
    3 1
    3 2
    4 1
    5 2
    6 1
    6 2
    7 1
    7 2
    8 1
    9 2
    10 1
    10 2
    11 1
    11 2
    12 1
    13 2
    14 1
    14 2
    15 1
    15 2
    16 1
    ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SV4/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');
AO.(iFam).Setpoint.Range = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 


%% *** SD5 ***
iFam = 'SD5';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
AO.(iFam).DeviceList                 = [
    2 1
    2 2
    3 1
    3 2
    6 1
    6 2
    7 1
    7 2
    10 1
    10 2
    11 1
    11 2
    14 1
    14 2
    15 1
    15 2 ];
AO.(iFam).ElementList                = (1:size(AO.(iFam).DeviceList,1))';
AO.(iFam).Status          = 1;
AO.(iFam).DeviceName    = 'SR/PC-SV5/S0';
%AO.(iFam).CommonNames   = iFam;

HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.MemberOf           = {'PlotFamily';};
AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');

val = 1.0; % scaling factor
AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf     = {'MachineConfig'; 'PlotFamily';};
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');
AO.(iFam).Setpoint.Range = [0 215];
AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = NaN; % Hardware units (gets set later) 



%=====
%% SKEW Quad
%=====
% *** QS ***
AO.QS.FamilyName                 = 'QS';
AO.QS.MemberOf                   = {'SkewQuad'; 'Magnet'; 'Coupling Corrector';};

AO.QS.Monitor.MemberOf           = {'PlotFamily';};
AO.QS.Monitor.Mode               = Mode;
AO.QS.Monitor.DataType           = 'Scalar';
AO.QS.Monitor.Units              = 'Hardware';
%AO.QS.Monitor.HW2PhysicsFcn      = @amp2k;
%AO.QS.Monitor.Physics2HWFcn      = @k2amp;
AO.QS.Monitor.HWUnits            = 'A';
AO.QS.Monitor.PhysicsUnits       = 'meter^';

AO.QS.Setpoint.MemberOf          = {'MachineConfig'; 'PlotFamily';};
AO.QS.Setpoint.Mode              = Mode;
AO.QS.Setpoint.DataType          = 'Scalar';
AO.QS.Setpoint.Units             = 'Hardware';
%AO.QS.Setpoint.HW2PhysicsFcn     = @amp2k;
%AO.QS.Setpoint.Physics2HWFcn     = @k2amp;
AO.QS.Setpoint.HWUnits           = 'A';
AO.QS.Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
ScaleFactor = 1.0;
HW2Physics=1.0;
for ii=1:9,
    name=sprintf('QS00%d',ii) ;
    AO.QS.CommonNames(ii,:)          = name;
    name=sprintf('CQS00%d',ii);
    AO.QS.Monitor.TangoNames(ii,:) = name;
    name=sprintf('CSQS00%d',ii);
    AO.QS.Setpoint.TangoNames(ii,:)= name;
    val =1;                        AO.QS.Status(ii,1)               = val;
    val =[ii i];                   AO.QS.DeviceList(ii,:)           = val;
    val =ii;                       AO.QS.ElementList(ii,1)          = val;
    val =[-5E5 5E5];                  AO.QS.Setpoint.Range(ii,:)       = val;
    val =5;                       AO.QS.Setpoint.Tolerance(ii,1)   = val;
    val =100;                      AO.QS.Setpoint.DeltaRespMat(ii,1)= val;
    AO.QS.HW2PhysicsParams(ii,:) = ScaleFactor*HW2Physics;
    AO.QS.Physics2HWParams(ii,:) = ScaleFactor/HW2Physics;
end
for ii=10:32,
    name=sprintf('QS0%d',ii) ;
    AO.QS.CommonNames(ii,:)          = name;
    name=sprintf('CQ0S%d',ii);
    AO.QS.Monitor.TangoNames(ii,:) = name;
    name=sprintf('CSQ0S%d',ii);
    AO.QS.Setpoint.TangoNames(ii,:)= name;
    val =1;                        AO.QS.Status(ii,1)               = val;
    val =[ii i];                   AO.QS.DeviceList(ii,:)           = val;
    val =ii;                       AO.QS.ElementList(ii,1)          = val;
    val =[-5E5 5E5];               AO.QS.Setpoint.Range(ii,:)       = val;
    val =5;                        AO.QS.Setpoint.Tolerance(ii,1)   = val;
    val =100;                      AO.QS.Setpoint.DeltaRespMat(ii,1)= val;
    AO.QS.HW2PhysicsParams(ii,:) = ScaleFactor*HW2Physics;
    AO.QS.Physics2HWParams(ii,:) = ScaleFactor/HW2Physics;
end

%
%% Kickers magnet
%
% *** IK ***
AO.IK.FamilyName                 = 'IK';
AO.IK.MemberOf                   = {'Kicker';'Injection';};

AO.IK.Monitor.MemberOf           = {'PlotFamily';};
AO.IK.Monitor.Mode               = Mode;
AO.IK.Monitor.DataType           = 'Scalar';
AO.IK.Monitor.Units              = 'Hardware';
AO.IK.Monitor.HWUnits            = 'A';
AO.IK.Monitor.PhysicsUnits       = 'rad';

AO.IK.Setpoint.MemberOf          = {'PlotFamily';};
AO.IK.Setpoint.Mode              = Mode;
AO.IK.Setpoint.DataType          = 'Scalar';
AO.IK.Setpoint.Units             = 'Hardware';
AO.IK.Setpoint.HWUnits           = 'A';
AO.IK.Setpoint.PhysicsUnits      = 'rad';

for ii=1:4
    AO.IK.CommonNames(ii,:)         = sprintf('IK0%d',ii);
    AO.IK.Monitor.TangoNames(ii,:)  = sprintf('CIK0%d',ii);
    AO.IK.Setpoint.TangoNames(ii,:) = sprintf('CIK0%d',ii);
    AO.IK.Status(ii,1)               = 1;
    AO.IK.DeviceList(ii,:)           = [ii i];
    AO.IK.ElementList(ii,1)          = ii;
    AO.IK.Setpoint.Range(ii,:)       = [0 5E4];
    AO.IK.Setpoint.Tolerance(ii,1)   = 5;
    AO.IK.Setpoint.DeltaRespMat(ii,1)= 100;
    AO.IK.HW2PhysicsParams(ii,:) = 1;
    AO.IK.Physics2HWParams(ii,:) = 1;
end


%====
%% DCCT
%====
AO.DCCT.FamilyName                     = 'DCCT';
AO.DCCT.MemberOf                       = {'DCCT'};
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = 1;
AO.DCCT.Status                         = AO.DCCT.ElementList;
AO.DCCT.DeviceName                     = '';
AO.DCCT.CommonNames                    = 'DCCT';

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.TangoNames             = '';
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-A';
AO.DCCT.Monitor.PhysicsUnits           = 'A';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;
AO.DCCT.Monitor.Physics2HWParams       = 1;


%============
%% RF System
%============
AO.RF.FamilyName                  = 'RF';
AO.RF.MemberOf                    = {'RF'};
AO.RF.DeviceList                  = [1 1];
AO.RF.ElementList                 = 1;
AO.RF.Status                      = 1;
AO.RF.DeviceName                     = '';
AO.RF.CommonNames                 = 'RF';

AO.RF.Monitor.MemberOf           = {};
AO.RF.Monitor.Mode                = Mode;
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+6;
AO.RF.Monitor.Physics2HWParams    = 1e-6;
AO.RF.Monitor.HWUnits             = 'MHz';
AO.RF.Monitor.PhysicsUnits        = 'Hz';
AO.RF.Monitor.TangoNames        = '';

AO.RF.Setpoint.MemberOf           = {'MachineConfig';};
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.TangoNames       = '';
AO.RF.Setpoint.Range              = [0 501];
AO.RF.Setpoint.Tolerance          = 1;


%====
%% TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.MemberOf    = {'TUNE'};
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];

AO.TUNE.Monitor.MemberOf         = {};
AO.TUNE.Monitor.Mode             = Mode;
AO.TUNE.Monitor.DataType         = 'Scalar';
AO.TUNE.Monitor.TangoNames       = ['ANS/DG/BPM-TUNEX/Nu';'ANS/DG/BPM-TUNEZ/Nu';'ANS/DG/BPM-TUNEZ/Nu'];
AO.TUNE.Monitor.Units            = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.HWUnits          = 'fractional tune';
AO.TUNE.Monitor.PhysicsUnits     = 'fractional tune';



% Marker for the id source. Behave like a bpm
% ntxrs=15;
% AO.XRS.FamilyName               = 'XRS';
% AO.XRS.MemberOf                 = {'PlotFamily';  'Diagnostics'};
% AO.XRS.Monitor.Mode             = Mode;
% AO.XRS.Monitor.DataType         = 'Vector';
% AO.XRS.Monitor.DataTypeIndex    = [1:ntxrs];
% AO.XRS.Monitor.Units            = 'Hardware';
% AO.XRS.Monitor.HWUnits          = 'mm';
% AO.XRS.Monitor.PhysicsUnits     = 'meter';
% AO.XRS.Monitor.HW2PhysicsParams = 1e-3;
% AO.XRS.Monitor.Physics2HWParams = 1000;


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


%======================================================================
%======================================================================
%% Append Accelerator Toolbox information   --->>> this gets done in updateatindex (GP)
%======================================================================
%======================================================================
% disp('   Initializing Accelerator Toolbox information');
% 
% ATindx = atindex(THERING);  %structure with fields containing indices
% 
% s = findspos(THERING,1:length(THERING)+1)';
% 
% %% Horizontal BPMs
% % WARNING: BPM1 is the one before the injection straigth section
% %          since a cell begins from begin of Straigths
% % CELL1 BPM1 to BPM7
% iFam = ('BPMx');
% AO.(iFam).AT.ATType  = iFam;
% AO.(iFam).AT.ATIndex = ATindx.BPM(:);
% AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% 
% %% Vertical BPMs
% iFam = ('BPMy');
% AO.(iFam).AT.ATType  = iFam;
% AO.(iFam).AT.ATIndex = ATindx.BPM(:);
% AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% 
% %% SLOW HORIZONTAL CORRECTORS
% iFam = ('HCM');
% AO.(iFam).AT.ATType  = iFam;
% AO.(iFam).AT.ATIndex = ATindx.COR(:);
% AO.(iFam).AT.ATIndex = AO.(iFam).AT.ATIndex(AO.(iFam).ElementList);   %not all correctors used
% AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% 
% %% SLOW VERTICAL CORRECTORS
% iFam = ('VCM');
% AO.(iFam).AT.ATType  = iFam;
% AO.(iFam).AT.ATIndex = ATindx.COR(:);
% AO.(iFam).AT.ATIndex = AO.(iFam).AT.ATIndex(AO.(iFam).ElementList);   %not all correctors used
% AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);  %for SPEAR 3 horizontal and vertical correctors at same s-position
% 
% 
% %% SKEW QUADS
% iFam = ('QS');
% AO.(iFam).AT.ATType  = 'SkewQuad';
% AO.(iFam).AT.ATIndex = ATindx.(iFam)(:);
% AO.(iFam).AT.ATIndex = AO.(iFam).AT.ATIndex(AO.(iFam).ElementList);   %not all correctors used
% AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% 
% %% BENDING magnets
% iFam = ('BEND');
% AO.(iFam).AT.ATType  = iFam;
% AO.(iFam).AT.ATIndex = ATindx.BEND(:);
% %AT.(iFam).Position   = s(AT.(iFam).AT.ATIndex);
% % One group of all dipoles
% AO.(iFam).Position   = reshape(s(AO.(iFam).AT.ATIndex),1,32);
% %AT.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AT.(iFam).AT.ATIndex,'K2');
% 
% 
% %% QUADRUPOLES
% for k = 1:3,
%     iFam = ['QD' num2str(k)];
%     AO.(iFam).AT.ATType  = 'QUAD';
%     AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
%     AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% end
% 
% for k = 1:8,
%     iFam = ['QF' num2str(k)];
%     AO.(iFam).AT.ATType  = 'QUAD';
%     AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
%     AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
% end
% 
% %% SEXTUPOLES
% for k = 1:5,
%     iFam = ['SD' num2str(k)];
%     AO.(iFam).AT.ATType  = 'SEXT';
%     AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
%     AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
%     AO.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AO.(iFam).AT.ATIndex,'K2');
% end
% 
% for k = 1:4,
%     iFam = ['SF' num2str(k)];
%     AO.(iFam).AT.ATType  = 'SEXT';
%     AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
%     AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
%     AO.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AO.(iFam).AT.ATIndex,'K2');
% end


%======================================================================
%% Set the deltas used when getting a response matrix
%======================================================================
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', 1e-4, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', 1e-4, AO.VCM.DeviceList);

% AO.QF1.Setpoint.DeltaRespMat  = physics2hw('QF1', 'Setpoint', AO.QF1.Setpoint.DeltaRespMat,  AO.QF1.DeviceList);
% AO.QF2.Setpoint.DeltaRespMat  = physics2hw('QF2', 'Setpoint', AO.QF2.Setpoint.DeltaRespMat,  AO.QF2.DeviceList);
% AO.QF3.Setpoint.DeltaRespMat  = physics2hw('QF3', 'Setpoint', AO.QF3.Setpoint.DeltaRespMat,  AO.QF3.DeviceList);
% AO.QF4.Setpoint.DeltaRespMat  = physics2hw('QF4', 'Setpoint', AO.QF4.Setpoint.DeltaRespMat,  AO.QF4.DeviceList);
% AO.QF5.Setpoint.DeltaRespMat  = physics2hw('QF5', 'Setpoint', AO.QF5.Setpoint.DeltaRespMat,  AO.QF5.DeviceList);
% AO.QF6.Setpoint.DeltaRespMat  = physics2hw('QF6', 'Setpoint', AO.QF6.Setpoint.DeltaRespMat,  AO.QF6.DeviceList);
% AO.QF7.Setpoint.DeltaRespMat  = physics2hw('QF7', 'Setpoint', AO.QF7.Setpoint.DeltaRespMat,  AO.QF7.DeviceList);
% AO.QF8.Setpoint.DeltaRespMat  = physics2hw('QF8', 'Setpoint', AO.QF8.Setpoint.DeltaRespMat,  AO.QF8.DeviceList);
%
% AO.QD1.Setpoint.DeltaRespMat  = physics2hw('QD1', 'Setpoint', AO.QD1.Setpoint.DeltaRespMat,  AO.QD1.DeviceList);
% AO.QD2.Setpoint.DeltaRespMat  = physics2hw('QD2', 'Setpoint', AO.QD2.Setpoint.DeltaRespMat,  AO.QD2.DeviceList);
% AO.QD3.Setpoint.DeltaRespMat  = physics2hw('QD3', 'Setpoint', AO.QD3.Setpoint.DeltaRespMat,  AO.QD3.DeviceList);

% AO.SF1.Setpoint.DeltaRespMat  = physics2hw('SF1', 'Setpoint', AO.SF1.Setpoint.DeltaRespMat,  AO.SF1.DeviceList);
% AO.SF2.Setpoint.DeltaRespMat  = physics2hw('SF2', 'Setpoint', AO.SF2.Setpoint.DeltaRespMat,  AO.SF2.DeviceList);
% AO.SF3.Setpoint.DeltaRespMat  = physics2hw('SF3', 'Setpoint', AO.SF3.Setpoint.DeltaRespMat,  AO.SF3.DeviceList);
% AO.SF4.Setpoint.DeltaRespMat  = physics2hw('SF4', 'Setpoint', AO.SF4.Setpoint.DeltaRespMat,  AO.SF4.DeviceList);
% 
% AO.SD1.Setpoint.DeltaRespMat  = physics2hw('SD1', 'Setpoint', AO.SD1.Setpoint.DeltaRespMat,  AO.SD1.DeviceList);
% AO.SD2.Setpoint.DeltaRespMat  = physics2hw('SD2', 'Setpoint', AO.SD2.Setpoint.DeltaRespMat,  AO.SD2.DeviceList);
% AO.SD3.Setpoint.DeltaRespMat  = physics2hw('SD3', 'Setpoint', AO.SD3.Setpoint.DeltaRespMat,  AO.SD3.DeviceList);
% AO.SD4.Setpoint.DeltaRespMat  = physics2hw('SD4', 'Setpoint', AO.SD4.Setpoint.DeltaRespMat,  AO.SD4.DeviceList);
% AO.SD5.Setpoint.DeltaRespMat  = physics2hw('SD5', 'Setpoint', AO.SD5.Setpoint.DeltaRespMat,  AO.SD5.DeviceList);
setao(AO);


% reference values
global refOptic;
disp '   Reference optics, tunes and AO stored in refOptic'
refOptic.AO=getao();
refOptic.twiss=gettwiss();
refOptic.tune= gettune();


