function boosterinit(OperationalMode)
% Initialize parameters for ALBA Booster control in MATLAB
% 20 Nov 06: 44 BPMs, Horiz. Correctors 44, Vert. Corr. 28

% Modified by Gabriele Benedetti - 27 June 2007

if nargin < 1
    OperationalMode = 1;
end

global GLOBVAL THERING

%==============================
% load AcceleratorData structure
%==============================

Mode             = 'Simulator';
setad([]);       %clear AcceleratorData memory
AD.SubMachine = 'Booster';   % Will already be defined if setpathmml was used
AD.Energy        = 3.0; % Energy in GeV needed for magnet calibration. Do not remove!

setad(AD);

%%%%%%%%%%%%%%%%%%%%
% ACCELERATOR OBJECT
%%%%%%%%%%%%%%%%%%%%

setao([]);   %clear previous AcceleratorObjects

%=============================================
%% BPMx data: status field designates if BPM in use
%=============================================
iFam = 'BPMx';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).FamilyType               = 'BPM';
AO.(iFam).MemberOf                 = {'PlotFamily'; 'HBPM'; 'BPM'; 'Diagnostics'};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'mm';
AO.(iFam).Monitor.PhysicsUnits     = 'meter';

bpm={
     1,	'BO/DI-BPM/B01_01', 1, [1  1], '01BPM01'
     2,	'BO/DI-BPM/B01_02', 1, [1  2], '01BPM02'
     3,	'BO/DI-BPM/B01_03', 1, [1  3], '01BPM03'
     4,	'BO/DI-BPM/B01_04', 1, [1  4], '01BPM04'
     5,	'BO/DI-BPM/B01_05', 1, [1  5], '01BPM05'
     6,	'BO/DI-BPM/B01_06', 1, [1  6], '01BPM06'
     7,	'BO/DI-BPM/B01_07', 1, [1  7], '01BPM07'
     8,	'BO/DI-BPM/B01_08', 1, [1  8], '01BPM08'
     9,	'BO/DI-BPM/B01_09', 1, [1  9], '01BPM09'
    10,	'BO/DI-BPM/B01_10', 1, [1 10], '01BPM10'
    11,	'BO/DI-BPM/B01_11', 1, [1 11], '01BPM11'
    12,	'BO/DI-BPM/B02_01', 1, [2  1], '02BPM01'
    13,	'BO/DI-BPM/B02_02', 1, [2  2], '02BPM02'
    14,	'BO/DI-BPM/B02_03', 1, [2  3], '02BPM03'
    15,	'BO/DI-BPM/B02_04', 1, [2  4], '02BPM04'
    16,	'BO/DI-BPM/B02_05', 1, [2  5], '02BPM05'
    17,	'BO/DI-BPM/B02_06', 1, [2  6], '02BPM06'
    18,	'BO/DI-BPM/B02_07', 1, [2  7], '02BPM07'
    19,	'BO/DI-BPM/B02_08', 1, [2  8], '02BPM08'
    20,	'BO/DI-BPM/B02_09', 1, [2  9], '02BPM09'
    21,	'BO/DI-BPM/B02_10', 1, [2 10], '02BPM10'
    22,	'BO/DI-BPM/B02_11', 1, [2 11], '02BPM11'
    23,	'BO/DI-BPM/B03_01', 1, [3  1], '03BPM01'
    24,	'BO/DI-BPM/B03_02', 1, [3  2], '03BPM02'
    25,	'BO/DI-BPM/B03_03', 1, [3  3], '03BPM03'
    26,	'BO/DI-BPM/B03_04', 1, [3  4], '03BPM04'
    27,	'BO/DI-BPM/B03_05', 1, [3  5], '03BPM05'
    28,	'BO/DI-BPM/B03_06', 1, [3  6], '03BPM06'
    29,	'BO/DI-BPM/B03_07', 1, [3  7], '03BPM07'
    30,	'BO/DI-BPM/B03_08', 1, [3  8], '03BPM08'
    31,	'BO/DI-BPM/B03_09', 1, [3  9], '03BPM09'
    32,	'BO/DI-BPM/B03_10', 1, [3 10], '03BPM10'
    33,	'BO/DI-BPM/B03_11', 1, [3 11], '03BPM11'
    34,	'BO/DI-BPM/B04_01', 1, [4  1], '04BPM01'
    35,	'BO/DI-BPM/B04_02', 1, [4  2], '04BPM02'
    36,	'BO/DI-BPM/B04_03', 1, [4  3], '04BPM03'
    37,	'BO/DI-BPM/B04_04', 1, [4  4], '04BPM04'
    38,	'BO/DI-BPM/B04_05', 1, [4  5], '04BPM05'
    39,	'BO/DI-BPM/B04_06', 1, [4  6], '04BPM06'
    40,	'BO/DI-BPM/B04_07', 1, [4  7], '04BPM07'
    41,	'BO/DI-BPM/B04_08', 1, [4  8], '04BPM08'
    42,	'BO/DI-BPM/B04_09', 1, [4  9], '04BPM09'
    43,	'BO/DI-BPM/B04_10', 1, [4 10], '04BPM10'
    44,	'BO/DI-BPM/B04_11', 1, [4 11], '04BPM11'
    };

% Load fields from data block
for ii=1:size(bpm,1)
    AO.(iFam).ElementList(ii,:)        = bpm{ii,1};
    AO.(iFam).DeviceName(ii,:)         = bpm(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(bpm(ii,2), '/XposSA');
    AO.(iFam).Status(ii,:)             = bpm{ii,3};  
    AO.(iFam).DeviceList(ii,:)         = bpm{ii,4};
    AO.(iFam).CommonNames(ii,:)        = bpm(ii,5);
    AO.(iFam).Monitor.HW2PhysicsParams(ii,:) = 1e-3;
    AO.(iFam).Monitor.Physics2HWParams(ii,:) = 1e3;
end

% Scalar channel method
AO.(iFam).Monitor.DataType = 'Scalar';
AO.(iFam).Monitor.Handles = NaN * ones(size(AO.(iFam).DeviceList,1),1);

%=============================================
%% BPMy data: status field designates if BPM in use
%=============================================

iFam = 'BPMy';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).FamilyType               = 'BPM';
AO.(iFam).MemberOf                 = {'PlotFamily'; 'VBPM'; 'BPM'; 'Diagnostics'};
AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'mm';
AO.(iFam).Monitor.PhysicsUnits     = 'meter';

bpm={
     1,	'BO/DI-BPM/B01_01', 1, [1  1], '01BPM01'
     2,	'BO/DI-BPM/B01_02', 1, [1  2], '01BPM02'
     3,	'BO/DI-BPM/B01_03', 1, [1  3], '01BPM03'
     4,	'BO/DI-BPM/B01_04', 1, [1  4], '01BPM04'
     5,	'BO/DI-BPM/B01_05', 1, [1  5], '01BPM05'
     6,	'BO/DI-BPM/B01_06', 1, [1  6], '01BPM06'
     7,	'BO/DI-BPM/B01_07', 1, [1  7], '01BPM07'
     8,	'BO/DI-BPM/B01_08', 1, [1  8], '01BPM08'
     9,	'BO/DI-BPM/B01_09', 1, [1  9], '01BPM09'
    10,	'BO/DI-BPM/B01_10', 1, [1 10], '01BPM10'
    11,	'BO/DI-BPM/B01_11', 1, [1 11], '01BPM11'
    12,	'BO/DI-BPM/B02_01', 1, [2  1], '02BPM01'
    13,	'BO/DI-BPM/B02_02', 1, [2  2], '02BPM02'
    14,	'BO/DI-BPM/B02_03', 1, [2  3], '02BPM03'
    15,	'BO/DI-BPM/B02_04', 1, [2  4], '02BPM04'
    16,	'BO/DI-BPM/B02_05', 1, [2  5], '02BPM05'
    17,	'BO/DI-BPM/B02_06', 1, [2  6], '02BPM06'
    18,	'BO/DI-BPM/B02_07', 1, [2  7], '02BPM07'
    19,	'BO/DI-BPM/B02_08', 1, [2  8], '02BPM08'
    20,	'BO/DI-BPM/B02_09', 1, [2  9], '02BPM09'
    21,	'BO/DI-BPM/B02_10', 1, [2 10], '02BPM10'
    22,	'BO/DI-BPM/B02_11', 1, [2 11], '02BPM11'
    23,	'BO/DI-BPM/B03_01', 1, [3  1], '03BPM01'
    24,	'BO/DI-BPM/B03_02', 1, [3  2], '03BPM02'
    25,	'BO/DI-BPM/B03_03', 1, [3  3], '03BPM03'
    26,	'BO/DI-BPM/B03_04', 1, [3  4], '03BPM04'
    27,	'BO/DI-BPM/B03_05', 1, [3  5], '03BPM05'
    28,	'BO/DI-BPM/B03_06', 1, [3  6], '03BPM06'
    29,	'BO/DI-BPM/B03_07', 1, [3  7], '03BPM07'
    30,	'BO/DI-BPM/B03_08', 1, [3  8], '03BPM08'
    31,	'BO/DI-BPM/B03_09', 1, [3  9], '03BPM09'
    32,	'BO/DI-BPM/B03_10', 1, [3 10], '03BPM10'
    33,	'BO/DI-BPM/B03_11', 1, [3 11], '03BPM11'
    34,	'BO/DI-BPM/B04_01', 1, [4  1], '04BPM01'
    35,	'BO/DI-BPM/B04_02', 1, [4  2], '04BPM02'
    36,	'BO/DI-BPM/B04_03', 1, [4  3], '04BPM03'
    37,	'BO/DI-BPM/B04_04', 1, [4  4], '04BPM04'
    38,	'BO/DI-BPM/B04_05', 1, [4  5], '04BPM05'
    39,	'BO/DI-BPM/B04_06', 1, [4  6], '04BPM06'
    40,	'BO/DI-BPM/B04_07', 1, [4  7], '04BPM07'
    41,	'BO/DI-BPM/B04_08', 1, [4  8], '04BPM08'
    42,	'BO/DI-BPM/B04_09', 1, [4  9], '04BPM09'
    43,	'BO/DI-BPM/B04_10', 1, [4 10], '04BPM10'
    44,	'BO/DI-BPM/B04_11', 1, [4 11], '04BPM11'
    };

%Load fields from data block
for ii=1:size(bpm,1)
    AO.(iFam).ElementList(ii,:)        = bpm{ii,1};
    AO.(iFam).DeviceName(ii,:)         = bpm(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(bpm(ii,2), '/YposSA');
    AO.(iFam).Status(ii,:)             = bpm{ii,3};  
    AO.(iFam).DeviceList(ii,:)         = bpm{ii,4};
    AO.(iFam).CommonNames(ii,:)        = bpm(ii,5);
    AO.(iFam).Monitor.HW2PhysicsParams(ii,:) = 1e-3;
    AO.(iFam).Monitor.Physics2HWParams(ii,:) = 1e3;
end

% Scalar channel method
AO.(iFam).Monitor.DataType = 'Scalar';
AO.(iFam).Monitor.Handles = NaN * ones(size(AO.(iFam).DeviceList,1),1);

%===========================================================
%% HCM
%===========================================================

iFam ='HCM';
AO.(iFam).FamilyName               = iFam;
AO.(iFam).FamilyType               = 'COR';
AO.(iFam).MemberOf                 = {'MachineConfig'; 'PlotFamily';  'HCOR'; 'COR'; 'MCOR'; 'HCM'; 'Magnet'};

AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.DataType         = 'Scalar';
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'A';
AO.(iFam).Monitor.PhysicsUnits     = 'radian';
AO.(iFam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn = @k2amp;

AO.(iFam).Setpoint.Mode            = Mode;
AO.(iFam).Setpoint.DataType        = 'Scalar';
AO.(iFam).Setpoint.Units           = 'Hardware';
AO.(iFam).Setpoint.HWUnits         = 'A';
AO.(iFam).Setpoint.PhysicsUnits    = 'radian';
AO.(iFam).Setpoint.HW2PhysicsFcn = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn = @k2amp;

cor={
     1,	'BO/PC-CORH/B01_01', 1, [1  1], '01HCM01'
     2,	'BO/PC-CORH/B01_02', 1, [1  2], '01HCM02'
     3,	'BO/PC-CORH/B01_03', 1, [1  3], '01HCM03'
     4,	'BO/PC-CORH/B01_04', 1, [1  4], '01HCM04'
     5,	'BO/PC-CORH/B01_05', 1, [1  5], '01HCM05'
     6,	'BO/PC-CORH/B01_06', 1, [1  6], '01HCM06'
     7,	'BO/PC-CORH/B01_07', 1, [1  7], '01HCM07'
     8,	'BO/PC-CORH/B01_08', 1, [1  8], '01HCM08'
     9,	'BO/PC-CORH/B01_09', 1, [1  9], '01HCM09'
    10,	'BO/PC-CORH/B01_10', 1, [1 10], '01HCM10'
    11,	'BO/PC-CORH/B01_11', 1, [1 11], '01HCM11'
    12,	'BO/PC-CORH/B02_01', 1, [2  1], '02HCM01'
    13,	'BO/PC-CORH/B02_02', 1, [2  2], '02HCM02'
    14,	'BO/PC-CORH/B02_03', 1, [2  3], '02HCM03'
    15,	'BO/PC-CORH/B02_04', 1, [2  4], '02HCM04'
    16,	'BO/PC-CORH/B02_05', 1, [2  5], '02HCM05'
    17,	'BO/PC-CORH/B02_06', 1, [2  6], '02HCM06'
    18,	'BO/PC-CORH/B02_07', 1, [2  7], '02HCM07'
    19,	'BO/PC-CORH/B02_08', 1, [2  8], '02HCM08'
    20,	'BO/PC-CORH/B02_09', 1, [2  9], '02HCM09'
    21,	'BO/PC-CORH/B02_10', 1, [2 10], '02HCM10'
    22,	'BO/PC-CORH/B02_11', 1, [2 11], '02HCM11'
    23,	'BO/PC-CORH/B03_01', 1, [3  1], '03HCM01'
    24,	'BO/PC-CORH/B03_02', 1, [3  2], '03HCM02'
    25,	'BO/PC-CORH/B03_03', 1, [3  3], '03HCM03'
    26,	'BO/PC-CORH/B03_04', 1, [3  4], '03HCM04'
    27,	'BO/PC-CORH/B03_05', 1, [3  5], '03HCM05'
    28,	'BO/PC-CORH/B03_06', 1, [3  6], '03HCM06'
    29,	'BO/PC-CORH/B03_07', 1, [3  7], '03HCM07'
    30,	'BO/PC-CORH/B03_08', 1, [3  8], '03HCM08'
    31,	'BO/PC-CORH/B03_09', 1, [3  9], '03HCM09'
    32,	'BO/PC-CORH/B03_10', 1, [3 10], '03HCM10'
    33,	'BO/PC-CORH/B03_11', 1, [3 11], '03HCM11'
    34,	'BO/PC-CORH/B04_01', 1, [4  1], '04HCM01'
    35,	'BO/PC-CORH/B04_02', 1, [4  2], '04HCM02'
    36,	'BO/PC-CORH/B04_03', 1, [4  3], '04HCM03'
    37,	'BO/PC-CORH/B04_04', 1, [4  4], '04HCM04'
    38,	'BO/PC-CORH/B04_05', 1, [4  5], '04HCM05'
    39,	'BO/PC-CORH/B04_06', 1, [4  6], '04HCM06'
    40,	'BO/PC-CORH/B04_07', 1, [4  7], '04HCM07'
    41,	'BO/PC-CORH/B04_08', 1, [4  8], '04HCM08'
    42,	'BO/PC-CORH/B04_09', 1, [4  9], '04HCM09'
    43,	'BO/PC-CORH/B04_10', 1, [4 10], '04HCM10'
    44,	'BO/PC-CORH/B04_11', 1, [4 11], '04HCM11'
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
    AO.(iFam).CommonNames(ii,:)        = cor(ii,5);
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(cor(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = coefficients;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = coefficients;
    AO.(iFam).Monitor.Handles(ii,1)    = NaN;
    AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%% VCM

iFam ='VCM';

AO.(iFam).FamilyName               = iFam;
AO.(iFam).FamilyType               = 'COR';
AO.(iFam).MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'VCOR'; 'MCOR'; 'VCM'; 'Magnet'};

AO.(iFam).Monitor.Mode             = Mode;
AO.(iFam).Monitor.DataType         = 'Scalar';
AO.(iFam).Monitor.Units            = 'Hardware';
AO.(iFam).Monitor.HWUnits          = 'A';
AO.(iFam).Monitor.PhysicsUnits     = 'radian';
AO.(iFam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn = @k2amp;

AO.(iFam).Setpoint.Mode            = Mode;
AO.(iFam).Setpoint.DataType        = 'Scalar';
AO.(iFam).Setpoint.Units           = 'Hardware';
AO.(iFam).Setpoint.HWUnits         = 'A';
AO.(iFam).Setpoint.PhysicsUnits    = 'radian';
AO.(iFam).Setpoint.HW2PhysicsFcn = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn = @k2amp;

cor={
     1,	'BO/PC-CORV/B01_01', 1, [1  1], '01VCM01'
     2,	'BO/PC-CORV/B01_02', 1, [1  2], '01VCM02'
     3,	'BO/PC-CORV/B01_03', 1, [1  3], '01VCM03'
     4,	'BO/PC-CORV/B01_04', 1, [1  4], '01VCM04'
     5,	'BO/PC-CORV/B01_05', 1, [1  5], '01VCM05'
     6,	'BO/PC-CORV/B01_06', 1, [1  6], '01VCM06'
     7,	'BO/PC-CORV/B01_07', 1, [1  7], '01VCM07'
     8,	'BO/PC-CORV/B01_08', 1, [1  8], '01VCM08'
     9,	'BO/PC-CORV/B01_09', 1, [1  9], '01VCM09'
    10,	'BO/PC-CORV/B01_10', 1, [1 10], '01VCM10'
    11,	'BO/PC-CORV/B01_11', 1, [1 11], '01VCM11'
    12,	'BO/PC-CORV/B02_01', 1, [2  1], '02VCM01'
    13,	'BO/PC-CORV/B02_02', 1, [2  2], '02VCM02'
    14,	'BO/PC-CORV/B02_03', 1, [2  3], '02VCM03'
    15,	'BO/PC-CORV/B02_04', 1, [2  4], '02VCM04'
    16,	'BO/PC-CORV/B02_05', 1, [2  5], '02VCM05'
    17,	'BO/PC-CORV/B02_06', 1, [2  6], '02VCM06'
    18,	'BO/PC-CORV/B02_07', 1, [2  7], '02VCM07'
    19,	'BO/PC-CORV/B02_08', 1, [2  8], '02VCM08'
    20,	'BO/PC-CORV/B02_09', 1, [2  9], '02VCM09'
    21,	'BO/PC-CORV/B02_10', 1, [2 10], '02VCM10'
    22,	'BO/PC-CORV/B02_11', 1, [2 11], '02VCM11'
    23,	'BO/PC-CORV/B03_01', 1, [3  1], '03VCM01'
    24,	'BO/PC-CORV/B03_02', 1, [3  2], '03VCM02'
    25,	'BO/PC-CORV/B03_03', 1, [3  3], '03VCM03'
    26,	'BO/PC-CORV/B03_04', 1, [3  4], '03VCM04'
    27,	'BO/PC-CORV/B03_05', 1, [3  5], '03VCM05'
    28,	'BO/PC-CORV/B03_06', 1, [3  6], '03VCM06'
    29,	'BO/PC-CORV/B03_07', 1, [3  7], '03VCM07'
    30,	'BO/PC-CORV/B03_08', 1, [3  8], '03VCM08'
    31,	'BO/PC-CORV/B03_09', 1, [3  9], '03VCM09'
    32,	'BO/PC-CORV/B03_10', 1, [3 10], '03VCM10'
    33,	'BO/PC-CORV/B03_11', 1, [3 11], '03VCM11'
    34,	'BO/PC-CORV/B04_01', 1, [4  1], '04VCM01'
    35,	'BO/PC-CORV/B04_02', 1, [4  2], '04VCM02'
    36,	'BO/PC-CORV/B04_03', 1, [4  3], '04VCM03'
    37,	'BO/PC-CORV/B04_04', 1, [4  4], '04VCM04'
    38,	'BO/PC-CORV/B04_05', 1, [4  5], '04VCM05'
    39,	'BO/PC-CORV/B04_06', 1, [4  6], '04VCM06'
    40,	'BO/PC-CORV/B04_07', 1, [4  7], '04VCM07'
    41,	'BO/PC-CORV/B04_08', 1, [4  8], '04VCM08'
    42,	'BO/PC-CORV/B04_09', 1, [4  9], '04VCM09'
    43,	'BO/PC-CORV/B04_10', 1, [4 10], '04VCM10'
    44,	'BO/PC-CORV/B04_11', 1, [4 11], '04VCM11'
    };

% Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients('VCM');

for ii=1:size(cor,1)
    AO.(iFam).ElementList(ii,:)        = cor{ii,1};
    AO.(iFam).DeviceName(ii,:)         = cor(ii,2);
    AO.(iFam).Monitor.TangoNames(ii,:) = strcat(cor(ii,2), '/current');
    AO.(iFam).Status(ii,:)             = cor{ii,3};  
    AO.(iFam).DeviceList(ii,:)         = cor{ii,4};
    AO.(iFam).CommonNames(ii,:)        = cor(ii,5);
    AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
    AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(cor(ii,2), '/currentPM');
    AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
    AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
    AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
    AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = coefficients;
    AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = coefficients;
    AO.(iFam).Monitor.Handles(ii,1)    = NaN;
    AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
end

AO.(iFam).Status = AO.(iFam).Status(:);

%=============================
%        MAIN MAGNETS
%=============================

%===========
% Dipole data
%===========
%% *** BEND ***
iFam = 'BEND';
AO.(iFam).FamilyName                 = 'BEND';
AO.(iFam).MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('BEND');
Physics2HWParams                    = HW2PhysicsParams;

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @bend2gev;
AO.(iFam).Monitor.Physics2HWFcn      = @gev2bend;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'rad';

AO.(iFam).DeviceName(:,:) = {'BO/PC-BEND/B0'};
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

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.05;

%============
% QUADRUPOLES
%============
%% *** QF1 ***
iFam = 'QF1';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

% %                                                                                                               delta-k
% %common             monitor                setpoint           stat devlist  elem        range   tol  respkick
% quad={
%      1,	'BO/PC-QH01/B01-01', 1, [1 1], '01_QH01_01'
%      2,	'BO/PC-QH01/B01-02', 1, [1 2], '01_QH01_02'
%      3,	'BO/PC-QH01/B02-01', 1, [2 1], '02_QH01_01'
%      4,	'BO/PC-QH01/B02-02', 1, [2 2], '02_QH01_02'
%      5,	'BO/PC-QH01/B03-01', 1, [3 1], '03_QH01_01'
%      6,	'BO/PC-QH01/B03-02', 1, [3 2], '03_QH01_02'
%      7,	'BO/PC-QH01/B04-01', 1, [4 1], '04_QH01_01'
%      8,	'BO/PC-QH01/B04-01', 1, [4 2], '04_QH01_01'
%     };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);

% for ii=1:size(quad,1)
%     AO.(iFam).ElementList(ii,:)        = quad{ii,1};
%     AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
%     AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
%     AO.(iFam).Status(ii,:)             = quad{ii,3};  
%     AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
%     AO.(iFam).CommonNames(ii,:)        = quad(ii,5);
%     AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
%     AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
%     AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
%     AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
%     AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
%     AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
%     AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
%     AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
%     AO.(iFam).Monitor.Handles(ii,1)    = NaN;
%     AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
% end
%
% AO.(iFam).Status = AO.(iFam).Status(:);

AO.(iFam).DeviceName(:,:) = {'BO/PC-QH01/B0'};
AO.(iFam).Monitor.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName(:,:),'/current');

AO.(iFam).DeviceList(:,:) = [1 1];
AO.(iFam).ElementList(:,:)= 1;
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles(:,1) = NaN;

val = 1;
AO.(iFam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(iFam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(iFam).Monitor.Range(:,:) = [0 200]; %... A for ...Tm-1

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 300]; %... A for ...Tm-1
AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.02;
    
%% *** QF2 ***
iFam = 'QF2';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

% %                                                                                                               delta-k
% %common             monitor                setpoint           stat devlist  elem        range   tol  respkick
% quad={
%       1,	'BO/PC-QH02/B01-01', 1, [1 1], 'B01_QH02_01'
%       2,	'BO/PC-QH02/B01-02', 1, [1 2], 'B01_QH02_02'
%       3,	'BO/PC-QH02/B01-03', 1, [1 3], 'B01_QH02_03'
%       4,	'BO/PC-QH02/B01-04', 1, [1 4], 'B01_QH02_04'
%       5,	'BO/PC-QH02/B01-05', 1, [1 5], 'B01_QH02_05'
%       6,	'BO/PC-QH02/B01-06', 1, [1 6], 'B01_QH02_06'
%       7,	'BO/PC-QH02/B01-07', 1, [1 7], 'B01_QH02_07'
%       8,	'BO/PC-QH02/B01-08', 1, [1 8], 'B01_QH02_08'
%       9,	'BO/PC-QH02/B01-09', 1, [1 9], 'B01_QH02_09'
%      10,	'BO/PC-QH02/B02-01', 1, [2 1], 'B02_QH02_01'
%      11,	'BO/PC-QH02/B02-02', 1, [2 2], 'B02_QH02_02'
%      12,	'BO/PC-QH02/B02-03', 1, [2 3], 'B02_QH02_03'
%      13,	'BO/PC-QH02/B02-04', 1, [2 4], 'B02_QH02_04'
%      14,	'BO/PC-QH02/B02-05', 1, [2 5], 'B02_QH02_05'
%      15,	'BO/PC-QH02/B02-06', 1, [2 6], 'B02_QH02_06'
%      16,	'BO/PC-QH02/B02-07', 1, [2 7], 'B02_QH02_07'
%      17,	'BO/PC-QH02/B02-08', 1, [2 8], 'B02_QH02_08'
%      18,	'BO/PC-QH02/B02-09', 1, [2 9], 'B02_QH02_09'
%      19,	'BO/PC-QH02/B03-01', 1, [3 1], 'B03_QH02_01'
%      20,	'BO/PC-QH02/B03-02', 1, [3 2], 'B03_QH02_02'
%      21,	'BO/PC-QH02/B03-03', 1, [3 3], 'B03_QH02_03'
%      22,	'BO/PC-QH02/B03-04', 1, [3 4], 'B03_QH02_04'
%      23,	'BO/PC-QH02/B03-05', 1, [3 5], 'B03_QH02_05'
%      24,	'BO/PC-QH02/B03-06', 1, [3 6], 'B03_QH02_06'
%      25,	'BO/PC-QH02/B03-07', 1, [3 7], 'B03_QH02_07'
%      26,	'BO/PC-QH02/B03-08', 1, [3 8], 'B03_QH02_08'
%      27,	'BO/PC-QH02/B03-09', 1, [3 9], 'B03_QH02_09'
%      28,	'BO/PC-QH02/B04-01', 1, [4 1], 'B04_QH02_01'
%      29,	'BO/PC-QH02/B04-02', 1, [4 2], 'B04_QH02_02'
%      30,	'BO/PC-QH02/B04-03', 1, [4 3], 'B04_QH02_03'
%      31,	'BO/PC-QH02/B04-04', 1, [4 4], 'B04_QH02_04'
%      32,	'BO/PC-QH02/B04-05', 1, [4 5], 'B04_QH02_05'
%      33,	'BO/PC-QH02/B04-06', 1, [4 6], 'B04_QH02_06'
%      34,	'BO/PC-QH02/B04-07', 1, [4 7], 'B04_QH02_07'
%      35,	'BO/PC-QH02/B04-08', 1, [4 8], 'B04_QH02_08'
%      36,	'BO/PC-QH02/B04-09', 1, [4 9], 'B04_QH02_09'
%     };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);


% for ii=1:size(quad,1)
%     AO.(iFam).ElementList(ii,:)        = quad{ii,1};
%     AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
%     AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
%     AO.(iFam).Status(ii,:)             = quad{ii,3};  
%     AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
%     AO.(iFam).CommonNames(ii,:)        = quad(ii,5);
%     AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
%     AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
%     AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
%     AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
%     AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
%     AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
%     AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
%     AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
%     AO.(iFam).Monitor.Handles(ii,1)    = NaN;
%     AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
% end
% 
% AO.(iFam).Status = AO.(iFam).Status(:);

AO.(iFam).DeviceName(:,:) = {'BO/PC-QH02/B0'};
AO.(iFam).Monitor.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName(:,:),'/current');

AO.(iFam).DeviceList(:,:) = [1 1];
AO.(iFam).ElementList(:,:)= 1;
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles(:,1) = NaN;

val = 1;
AO.(iFam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(iFam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(iFam).Monitor.Range(:,:) = [0 200]; %... A for ...Tm-1

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 300]; %... A for ...Tm-1
AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.02;

%% *** QD1 ***
iFam = 'QD1';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

% %                                                                                                               delta-k
% %common             monitor                setpoint           stat devlist  elem        range   tol  respkick
% quad={
%      1,	'BO/PC-QV01/B01-01', 1, [1 1], '01_QV01_01'
%      2,	'BO/PC-QV01/B01-02', 1, [1 2], '01_QV01_02'
%      3,	'BO/PC-QV01/B02-01', 1, [2 1], '02_QV01_01'
%      4,	'BO/PC-QV01/B02-02', 1, [2 2], '02_QV01_02'
%      5,	'BO/PC-QV01/B03-01', 1, [3 1], '03_QV01_01'
%      6,	'BO/PC-QV01/B03-02', 1, [3 2], '03_QV01_02'
%      7,	'BO/PC-QV01/B04-01', 1, [4 1], '04_QV01_01'
%      8,	'BO/PC-QV01/B04-01', 1, [4 2], '04_QV01_01'
%     };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);

% for ii=1:size(quad,1)
%     AO.(iFam).ElementList(ii,:)        = quad{ii,1};
%     AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
%     AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
%     AO.(iFam).Status(ii,:)             = quad{ii,3};  
%     AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
%     AO.(iFam).CommonNames(ii,:)        = quad(ii,5);
%     AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
%     AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
%     AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
%     AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
%     AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
%     AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
%     AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
%     AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
%     AO.(iFam).Monitor.Handles(ii,1)    = NaN;
%     AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
% end
% 
% AO.(iFam).Status = AO.(iFam).Status(:);

AO.(iFam).DeviceName(:,:) = {'BO/PC-QV01/B0'};
AO.(iFam).Monitor.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName(:,:),'/current');

AO.(iFam).DeviceList(:,:) = [1 1];
AO.(iFam).ElementList(:,:)= 1;
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles(:,1) = NaN;

val = 1;
AO.(iFam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(iFam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(iFam).Monitor.Range(:,:) = [0 200]; %... A for ...Tm-1

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 300]; %... A for ...Tm-1
AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.02;

%% *** QD2 ***
iFam = 'QD2';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'meter^-2';

AO.(iFam).Setpoint.Mode              = Mode;
AO.(iFam).Setpoint.DataType          = 'Scalar';
AO.(iFam).Setpoint.Units             = 'Hardware';
AO.(iFam).Setpoint.HW2PhysicsFcn     = @amp2k;
AO.(iFam).Setpoint.Physics2HWFcn     = @k2amp;
AO.(iFam).Setpoint.HWUnits           = 'A';
AO.(iFam).Setpoint.PhysicsUnits      = 'meter^-2';

% %                                                                                                               delta-k
% %common             monitor                setpoint           stat devlist  elem        range   tol  respkick
% quad={
%      1,	'BO/PC-QV02/B01-01', 1, [1 1], '01_QV02_01'
%      2,	'BO/PC-QV02/B01-02', 1, [1 2], '01_QV02_02'
%      3,	'BO/PC-QV02/B02-01', 1, [2 1], '02_QV02_01'
%      4,	'BO/PC-QV02/B02-02', 1, [2 2], '02_QV02_02'
%      5,	'BO/PC-QV02/B03-01', 1, [3 1], '03_QV02_01'
%      6,	'BO/PC-QV02/B03-02', 1, [3 2], '03_QV02_02'
%      7,	'BO/PC-QV02/B04-01', 1, [4 1], '04_QV02_01'
%      8,	'BO/PC-QV02/B04-01', 1, [4 2], '04_QV02_01'
%     };

HW2PhysicsParams  = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams  = magnetcoefficients(AO.(iFam).FamilyName);

% for ii=1:size(quad,1)
%     AO.(iFam).ElementList(ii,:)        = quad{ii,1};
%     AO.(iFam).DeviceName(ii,:)         = quad(ii,2);
%     AO.(iFam).Monitor.TangoNames(ii,:) = strcat(quad(ii,2), '/current');
%     AO.(iFam).Status(ii,:)             = quad{ii,3};  
%     AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
%     AO.(iFam).CommonNames(ii,:)        = quad(ii,5);
%     AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
%     AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
%     AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
%     AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
%     AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
%     AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
%     AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
%     AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
%     AO.(iFam).Monitor.Handles(ii,1)    = NaN;
%     AO.(iFam).Setpoint.Handles(ii,1)   = NaN;
% end
% 
% AO.(iFam).Status = AO.(iFam).Status(:);

AO.(iFam).DeviceName(:,:) = {'BO/PC-QV02/B0'};
AO.(iFam).Monitor.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName(:,:),'/current');

AO.(iFam).DeviceList(:,:) = [1 1];
AO.(iFam).ElementList(:,:)= 1;
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles(:,1) = NaN;

val = 1;
AO.(iFam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(iFam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(iFam).Monitor.Range(:,:) = [0 200]; %... A for ...Tm-1

AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint.TangoNames(:,:)  = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Range(:,:) = [0 300]; %... A for ...Tm-1
AO.(iFam).Setpoint.Tolerance(:,:) = 0.05;
AO.(iFam).Setpoint.DeltaRespMat(:,:) = 0.02;

%     AO.(iFam).DeviceList(ii,:)         = quad{ii,4};
%     AO.(iFam).CommonNames(ii,:)        = quad(ii,5);
%     AO.(iFam).Monitor.HW2PhysicsParams{1}(ii,:)  = HW2PhysicsParams;
%     AO.(iFam).Monitor.Physics2HWParams{1}(ii,:)  = Physics2HWParams;
%     AO.(iFam).Setpoint.TangoNames(ii,:) = strcat(quad(ii,2), '/currentPM');
%     AO.(iFam).Setpoint.Range(ii,:)        = [-10 10]; 
%     AO.(iFam).Setpoint.Tolerance(ii,1)    = 1E-7;
%     AO.(iFam).Setpoint.DeltaRespMat(ii,1) = 1;
%     AO.(iFam).Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
%     AO.(iFam).Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
%     AO.(iFam).Monitor.Handles(ii,1)    = NaN;
%     AO.(iFam).Setpoint.Handles(ii,1)   = NaN;


%===============
% Sextupole data
%===============
%% *** SF ***
iFam = 'SF';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
AO.(iFam).FamilyType                 = 'SEXT';
HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).DeviceList                = [1 1];
AO.(iFam).ElementList               = 1;

AO.(iFam).DeviceName    = 'BO/PC-SH01/B0';
AO.(iFam).CommonNames   = iFam;
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles = NaN;

val = 1.0; % scaling factor

AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;
AO.(iFam).Monitor.Range(:,:) = [0 215]; 

AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = 2e7; % Physics units for a thin sextupole

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(iFam).Setpoint.DeltaRespMat=physics2hw(AO.(iFam).FamilyName,'Setpoint',AO.(iFam).Setpoint.DeltaRespMat,AO.(iFam).DeviceList);

%% *** SD ***
iFam = 'SD';

AO.(iFam).FamilyName                 = iFam;
AO.(iFam).MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';};
AO.(iFam).FamilyType                 = 'SEXT';
HW2PhysicsParams                     = magnetcoefficients(AO.(iFam).FamilyName);
Physics2HWParams                     = HW2PhysicsParams;

AO.(iFam).Monitor.Mode               = Mode;
AO.(iFam).Monitor.DataType           = 'Scalar';
AO.(iFam).Monitor.Units              = 'Hardware';
AO.(iFam).Monitor.HW2PhysicsFcn      = @amp2k;
AO.(iFam).Monitor.Physics2HWFcn      = @k2amp;
AO.(iFam).Monitor.HWUnits            = 'A';
AO.(iFam).Monitor.PhysicsUnits       = 'm^-2';
AO.(iFam).DeviceList                = [1 1];
AO.(iFam).ElementList               = 1;

AO.(iFam).DeviceName    = 'BO/PC-SV01/B0';
AO.(iFam).CommonNames   = iFam;
AO.(iFam).Monitor.TangoNames  = strcat(AO.(iFam).DeviceName,'/current');
AO.(iFam).Status          = 1;
AO.(iFam).Monitor.Handles = NaN;

val = 1.0; % scaling factor

AO.(iFam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
AO.(iFam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
AO.(iFam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
AO.(iFam).Monitor.Physics2HWParams{2}(1,:)               = val;
AO.(iFam).Monitor.Range(:,:) = [0 215]; 

AO.(iFam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(iFam).Setpoint = AO.(iFam).Monitor;
AO.(iFam).Desired  = AO.(iFam).Monitor;
AO.(iFam).Setpoint.TangoNames   = strcat(AO.(iFam).DeviceName,'/currentPM');

AO.(iFam).Setpoint.Tolerance     = 0.05;
AO.(iFam).Setpoint.DeltaRespMat  = 2e7; % Physics units for a thin sextupole

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(iFam).Setpoint.DeltaRespMat=physics2hw(AO.(iFam).FamilyName,'Setpoint',AO.(iFam).Setpoint.DeltaRespMat,AO.(iFam).DeviceList);

%====
%% DCCT
%====
AO.DCCT.FamilyName                     = 'DCCT';
AO.DCCT.MemberOf                       = {'DCCT'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = [1]';
AO.DCCT.Status                         = AO.DCCT.ElementList;

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = '';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;

%============
%% RF System
%============
AO.RF.FamilyName                  = 'RF';
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
AO.RF.Monitor.ChannelNames        = '';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = '';     
AO.RF.Setpoint.Range              = [0 Inf];
AO.RF.Setpoint.Tolerance          = 100.0;

%====
%% TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.MemberOf    = {'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';

AO.TUNE.Monitor.Mode                   = 'Simulator'; 
AO.TUNE.Monitor.DataType               = 'Scalar';
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';

%============
% Kicker magnets
%============
%% *** IK ***
% AO.IK.FamilyName                 = 'IK';
% AO.IK.FamilyType                 = 'Kicker';
% 
% AO.IK.MemberOf                   = {'Magnet';'Injection';};
% 
% AO.IK.Monitor.Mode               = Mode;
% AO.IK.Monitor.DataType           = 'Scalar';
% AO.QS.Monitor.Units              = 'Hardware';
% AO.IK.Monitor.HWUnits            = 'A';
% AO.IK.Monitor.PhysicsUnits       = 'rad';
% 
% AO.IK.Setpoint.Mode              = Mode;
% AO.IK.Setpoint.DataType          = 'Scalar';
% AO.IK.Setpoint.Units             = 'Hardware';
% AO.IK.Setpoint.HWUnits           = 'A';
% AO.IK.Setpoint.PhysicsUnits      = 'rad';
% 
% %                                                                                                               delta-k
% %common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
% ScaleFactor = 1.0;
% HW2Physics=1.0;
% for ii=1:2,
%     name=sprintf('IK0%d',ii) ;
%     AO.IK.CommonNames(ii,:)          = name;
%     name=sprintf('CIK0%d',ii);
%     AO.IK.Monitor.TangoNames(ii,:) = name;
%     name=sprintf('CIK0%d',ii);
%     AO.IK.Setpoint.TangoNames(ii,:)= name;
%     val =1;                        AO.IK.Status(ii,1)               = val;
%     val =[ii i];                   AO.IK.DeviceList(ii,:)           = val;
%     val =ii;                       AO.IK.ElementList(ii,1)          = val;
%     val =[0 5E4];                  AO.IK.Setpoint.Range(ii,:)       = val;
%     val =5;                       AO.IK.Setpoint.Tolerance(ii,1)   = val;
%     val =100;                      AO.IK.Setpoint.DeltaRespMat(ii,1)= val;
%     AO.IK.HW2PhysicsParams(ii,:) = ScaleFactor*HW2Physics;
%     AO.IK.Physics2HWParams(ii,:) = ScaleFactor/HW2Physics;
% end

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);

%======================================================================
%% Append Accelerator Toolbox information
%======================================================================
%======================================================================
disp('** Initializing Accelerator Toolbox information');

AO = getao;

ATindx = atindex(THERING);  %structure with fields containing indices

s = findspos(THERING,1:length(THERING)+1)';

%% Horizontal BPMs
iFam = ('BPMx');
AO.(iFam).AT.ATType  = iFam;
AO.(iFam).AT.ATIndex = ATindx.BPM(:);
AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);

%% Vertical BPMs
iFam = ('BPMy');
AO.(iFam).AT.ATType  = iFam;
AO.(iFam).AT.ATIndex = ATindx.BPM(:);
AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);  

%% HORIZONTAL CORRECTORS
iFam = ('HCM');
AO.(iFam).AT.ATType  = iFam;
AO.(iFam).AT.ATIndex = ATindx.(iFam)(:);
AO.(iFam).AT.ATIndex = AO.(iFam).AT.ATIndex(AO.(iFam).ElementList);   %not all correctors used
AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);

%% VERTICAL CORRECTORS
iFam = ('VCM');
AO.(iFam).AT.ATType  = iFam;
AO.(iFam).AT.ATIndex = ATindx.(iFam)(:);
AO.(iFam).AT.ATIndex = AO.(iFam).AT.ATIndex(AO.(iFam).ElementList);   %not all correctors used
AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);

%% BENDING magnets
iFam = ('BEND');
AO.(iFam).AT.ATType  = iFam;
AO.(iFam).AT.ATIndex = ATindx.BEND(:);
%AT.(iFam).Position   = s(AT.(iFam).AT.ATIndex);
% One group of all dipoles
AO.(iFam).Position   = reshape(s(AO.(iFam).AT.ATIndex),1,40);
%AT.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AT.(iFam).AT.ATIndex,'K2');

%% QUADRUPOLES
for k = 1:2,
    iFam = ['QF' num2str(k)];
    AO.(iFam).AT.ATType  = 'QUAD';
    AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
    AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
end

for k = 1:2,
    iFam = ['QD' num2str(k)];
    AO.(iFam).AT.ATType  = 'QUAD';
    AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
    AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
end

%% SEXTUPOLES
    iFam = 'SD';
    AO.(iFam).AT.ATType  = 'SEXT';
    AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
    AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
    AO.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AO.(iFam).AT.ATIndex,'K2');

    iFam = 'SF';
    AO.(iFam).AT.ATType  = 'SEXT';
    AO.(iFam).AT.ATIndex = eval(['ATindx.' iFam '(:)']);
    AO.(iFam).Position   = s(AO.(iFam).AT.ATIndex);
    AO.(iFam).AT.ATParamGroup = mkparamgroup(THERING,AO.(iFam).AT.ATIndex,'K2');


AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', 1e-4, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', 1e-4, AO.VCM.DeviceList);

AO.QF1.Setpoint.DeltaRespMat  = physics2hw('QF1', 'Setpoint', AO.QF1.Setpoint.DeltaRespMat,  AO.QF1.DeviceList);
AO.QF2.Setpoint.DeltaRespMat  = physics2hw('QF2', 'Setpoint', AO.QF2.Setpoint.DeltaRespMat,  AO.QF2.DeviceList);
AO.QD1.Setpoint.DeltaRespMat  = physics2hw('QD1', 'Setpoint', AO.QD1.Setpoint.DeltaRespMat,  AO.QD1.DeviceList);
AO.QD2.Setpoint.DeltaRespMat  = physics2hw('QD2', 'Setpoint', AO.QD1.Setpoint.DeltaRespMat,  AO.QD2.DeviceList);

AO.SF.Setpoint.DeltaRespMat  = physics2hw('SF', 'Setpoint', AO.SF.Setpoint.DeltaRespMat,  AO.SF.DeviceList);
AO.SD.Setpoint.DeltaRespMat  = physics2hw('SD', 'Setpoint', AO.SD.Setpoint.DeltaRespMat,  AO.SD.DeviceList);

setao(AO);

% reference values
global RefOptics;
%disp '    Reference optics, tunes and AO stored in RefOptics'
RefOptics.AO=getao();
RefOptics.twiss=gettwiss();
RefOptics.tune= gettune();
