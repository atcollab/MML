function vuvinit(OperationalMode)
%VUVINIT - Initialize NSLS VUV ring parameters for control in MATLAB
%
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              s, magnet center
%
% Monitor Fields
% Mode                  online/manual/special/simulator
% ChannelNames          PV for monitor
% Units                 Physics or HW
% HW2PhysicsFcn         function handle used to convert from hardware to physics units ==> inline will not compile, see below
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'Ampere';           
% PhysicsUnits          units for physics 'radian';
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
% HWUnits               units for Hardware 'Ampere';           
% PhysicsUnits          units for physics 'radian';
% Range                 minsetpoint, maxsetpoint;
% Tolerance             Allowable differnce between setpoint and monitor
% 
%=============================================  
% Accelerator Toolbox Simulation Fields
%=============================================
% ATType                Quad, Sext, etc
% ATIndex               index in THERING
% ATParameterGroup      parameter group


if nargin < 1
    OperationalMode = 1;  % Often set in aoinit
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the AO structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear previous AcceleratorObjects
setao([]);

Mode = 'ONLINE';

%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=24;
AO.BPMx.FamilyName               = 'BPMx';
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMx'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.DataTypeIndex    = 1:ntbpm;
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy';
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMy'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.DataTypeIndex    = 1:ntbpm;
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name     x-chname  xstat y-name     y-chname  ystat DevList Elem

bpm={
 'upue01h' 'upue01h:am'  1  'upue01v' 'upue01v:am'  1   [1 1]    1; ...
 'upue02h' 'upue02h:am'  1  'upue02v' 'upue02v:am'  1   [1 2]    2; ...
 'upue03h' 'upue03h:am'  1  'upue03v' 'upue03v:am'  1   [1 3]    3; ...
 'upue04h' 'upue04h:am'  1  'upue04v' 'upue04v:am'  1   [1 4]    4; ...
 'upue05h' 'upue05h:am'  1  'upue05v' 'upue05v:am'  1   [1 5]    5; ...
 'upue06h' 'upue06h:am'  1  'upue06v' 'upue06v:am'  1   [1 6]    6; ...
 'upue07h' 'upue07h:am'  1  'upue07v' 'upue07v:am'  1   [2 1]    7; ...
 'upue08h' 'upue08h:am'  1  'upue08v' 'upue08v:am'  1   [2 2]    8; ...
 'upue09h' 'upue09h:am'  1  'upue09v' 'upue09v:am'  1   [2 3]    9; ...
 'upue10h' 'upue10h:am'  1  'upue10v' 'upue10v:am'  1   [2 4]   10; ...
 'upue11h' 'upue11h:am'  1  'upue11v' 'upue11v:am'  1   [2 5]   11; ...
 'upue12h' 'upue12h:am'  1  'upue12v' 'upue12v:am'  1   [2 6]   12; ...
 'upue13h' 'upue13h:am'  1  'upue13v' 'upue13v:am'  1   [3 1]   13; ...
 'upue14h' 'upue14h:am'  1  'upue14v' 'upue14v:am'  1   [3 2]   14; ...
 'upue15h' 'upue15h:am'  1  'upue15v' 'upue15v:am'  1   [3 3]   15; ...
 'upue16h' 'upue16h:am'  1  'upue16v' 'upue16v:am'  1   [3 4]   16; ...
 'upue17h' 'upue17h:am'  1  'upue17v' 'upue17v:am'  1   [3 5]   17; ...
 'upue18h' 'upue18h:am'  1  'upue18v' 'upue18v:am'  1   [3 6]   18; ...
 'upue19h' 'upue19h:am'  1  'upue19v' 'upue19v:am'  1   [4 1]   19; ...
 'upue20h' 'upue20h:am'  1  'upue20v' 'upue20v:am'  1   [4 2]   20; ...
 'upue21h' 'upue21h:am'  1  'upue21v' 'upue21v:am'  1   [4 3]   21; ...
 'upue22h' 'upue22h:am'  1  'upue22v' 'upue22v:am'  1   [4 4]   22; ...
 'upue23h' 'upue23h:am'  1  'upue23v' 'upue23v:am'  1   [4 5]   23; ...
 'upue24h' 'upue24h:am'  1  'upue24v' 'upue24v:am'  1   [4 6]   24; ...
 
};

%Load fields from data block
for ii=1:size(bpm,1)
      %AO.BPMx.CommonNames(ii,:)         = bpm{ii,1};
      AO.BPMx.Monitor.ChannelNames(ii,:)= bpm{ii,2};
      AO.BPMx.Status(ii,:)              = bpm{ii,3};   
      %AO.BPMy.CommonNames(ii,:)         = bpm{ii,4};
      AO.BPMy.Monitor.ChannelNames(ii,:)= bpm{ii,5};
      AO.BPMy.Status(ii,:)              = bpm{ii,6};  
      AO.BPMx.DeviceList(ii,:)          = bpm{ii,7};   
      AO.BPMy.DeviceList(ii,:)          = bpm{ii,7};
      AO.BPMx.ElementList(ii,:)         = bpm{ii,8};   
      AO.BPMy.ElementList(ii,:)         = bpm{ii,8};
      AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
      AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1000;
      AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
      AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1000;
end

AO.BPMx.Status = AO.BPMx.Status(:);
AO.BPMy.Status = AO.BPMy.Status(:);


% Scalar channel method
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.DataType = 'Scalar';

AO.BPMx.Monitor = rmfield(AO.BPMx.Monitor, 'DataTypeIndex');
AO.BPMy.Monitor = rmfield(AO.BPMy.Monitor, 'DataTypeIndex');



%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================

AO.HCM.FamilyName               = 'HCM';
AO.HCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'MCOR'; 'HCM'; 'Magnet'};

AO.HCM.Monitor.Mode             = Mode;
AO.HCM.Monitor.DataType         = 'Scalar';
AO.HCM.Monitor.Units            = 'Hardware';
AO.HCM.Monitor.HWUnits          = 'Ampere';           
AO.HCM.Monitor.PhysicsUnits     = 'radian';
%AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
%AO.HCM.Monitor.Physics2HWFcn = @k2amp;

AO.HCM.Setpoint.Mode            = Mode;
AO.HCM.Setpoint.DataType        = 'Scalar';
AO.HCM.Setpoint.Units           = 'Hardware';
AO.HCM.Setpoint.HWUnits         = 'Ampere';           
AO.HCM.Setpoint.PhysicsUnits    = 'radian';
%AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.HCM.Setpoint.Physics2HWFcn = @k2amp;

HCMRange  = 10.0;  % [A]
HCMGain_S = 1.933e-3/HCMRange;   % [rad/A] for standalone
HCMGain_B = 2.264e-3/HCMRange;   % [rad/A] for backleg
RMKICK    = 1.0;  % Kick size for orbit response matrix measurement [A]
HCMTol    = 0.10; % Tolerance [A]

% HW in ampere, Physics in radian                                           ** radian units converted to ampere below ***

%x-common     x-monitor    x-setpoint   xstat  devlist elem   range (Ampere)    tol    x-kick     H2P_X      P2H_X 
hcor={
 'u1hs1   '  'u1hs1:am  '  'u1hs1:sp '    1    [1 ,1]   1   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 'u1hs2   '  'u1hs2:am  '  'u1hs2:sp '    1    [1 ,2]   2   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u1hs3   '  'u1hs3:am  '  'u1hs3:sp '    0    [1 ,3]   3   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u1hs4   '  'u1hs4:am  '  'u1hs4:sp '    0    [1 ,4]   4   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 % u1hs3 and u1hs4 have malfunctioning readbacks
 ... 
 'u2hs5   '  'u2hs5:am  '  'u2hs5:sp '    1    [2 ,1]   5   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 'u2hs6   '  'u2hs6:am  '  'u2hs6:sp '    0    [2 ,2]   6   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u2hs7   '  'u2hs7:am  '  'u2hs7:sp '    0    [2 ,3]   7   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u2hs8   '  'u2hs8:am  '  'u2hs8:sp '    1    [2 ,4]   8   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 ...
 'u3hs9   '  'u3hs9:am  '  'u3hs9:sp '    1    [3 ,1]   9   [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 'u3hs10  '  'u3hs10:am '  'u3hs10:sp'    0    [3 ,2]   10  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u3hs11  '  'u3hs11:am '  'u3hs11:sp'    0    [3 ,3]   11  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u3hs12  '  'u3hs12:am '  'u3hs12:sp'    1    [3 ,4]   12  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 ...
 'u4hs13  '  'u4hs13:am '  'u4hs13:sp'    1    [4 ,1]   13  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
 'u4hs14  '  'u4hs14:am '  'u4hs14:sp'    0    [4 ,2]   14  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u4hs15  '  'u4hs15:am '  'u4hs15:sp'    0    [4 ,3]   15  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_B   1/HCMGain_B; ...
 'u4hs16  '  'u4hs16:am '  'u4hs16:sp'    1    [4 ,4]   16  [-HCMRange +HCMRange]  HCMTol  RMKICK   HCMGain_S   1/HCMGain_S; ...
};

for ii=1:size(hcor,1)
%AO.HCM.CommonNames(ii,:)           = hcor{ii,1};            
AO.HCM.Monitor.ChannelNames(ii,:)  = hcor{ii,2};
AO.HCM.Setpoint.ChannelNames(ii,:) = hcor{ii,3};     
AO.HCM.Status(ii,1)                = hcor{ii,4};
AO.HCM.DeviceList(ii,:)            = hcor{ii,5};
AO.HCM.ElementList(ii,1)           = hcor{ii,6};
AO.HCM.Setpoint.Range(ii,:)        = hcor{ii,7};
AO.HCM.Setpoint.Tolerance(ii,1)    = hcor{ii,8};
AO.HCM.Setpoint.DeltaRespMat(ii,1) = hcor{ii,9};

AO.HCM.Monitor.HW2PhysicsParams(ii,:)  = hcor{ii,10};          
AO.HCM.Monitor.Physics2HWParams(ii,:)  = hcor{ii,11};
AO.HCM.Setpoint.HW2PhysicsParams(ii,:) = hcor{ii,10};          
AO.HCM.Setpoint.Physics2HWParams(ii,:) = hcor{ii,11};
end


AO.VCM.FamilyName               = 'VCM';
AO.VCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'VCM'; 'Magnet'};

AO.VCM.Monitor.Mode             = Mode;
AO.VCM.Monitor.DataType         = 'Scalar';
AO.VCM.Monitor.Units            = 'Hardware';
AO.VCM.Monitor.HWUnits          = 'Ampere';           
AO.VCM.Monitor.PhysicsUnits     = 'radian';
%AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
%AO.VCM.Monitor.Physics2HWFcn = @k2amp;

AO.VCM.Setpoint.Mode            = Mode;
AO.VCM.Setpoint.DataType        = 'Scalar';
AO.VCM.Setpoint.Units           = 'Hardware';
AO.VCM.Setpoint.HWUnits         = 'Ampere';           
AO.VCM.Setpoint.PhysicsUnits    = 'radian';
%AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.VCM.Setpoint.Physics2HWFcn = @k2amp;


VCMRange  = 10.0;  % [A]
VCMGain_S = 1.933e-3/VCMRange;   % [rad/A] for standalone
VCMGain_A = 0.957e-3/VCMRange;   % [rad/A] for aircore
RMKICK    = 1.0;  % Kick size for orbit response matrix measurement [A]
VCMTol    = 0.10; % Tolerance [A]

% HW in ampere, Physics in radian                          ** radian units converted to ampere below ***

%y-common  y-monitor   y-setpoint   ystat devlist elem   range (Ampere)    tol    y-kick     H2P_Y        P2H_Y 
vcor={
 'u1vs1 ' 'u1vs1:am '  'u1vs1:sp '    1    [1 ,1]   1  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 'u1vs2 ' 'u1vs2:am '  'u1vs2:sp '    1    [1 ,2]   2  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u1vs3 ' 'u1vs3:am '  'u1vs3:sp '    1    [1 ,3]   3  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u1vs4 ' 'u1vs4:am '  'u1vs4:sp '    1    [1 ,4]   4  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 ... 
 'u2vs5 ' 'u2vs5:am '  'u2vs5:sp '    1    [2 ,1]   5  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 'u2vs6 ' 'u2vs6:am '  'u2vs6:sp '    1    [2 ,2]   6  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u2vs7 ' 'u2vs7:am '  'u2vs7:sp '    1    [2 ,3]   7  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u2vs8 ' 'u2vs8:am '  'u2vs8:sp '    1    [2 ,4]   8  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 ...
 'u3vs9 ' 'u3vs9:am '  'u3vs9:sp '    1    [3 ,1]   9  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 'u3vs10' 'u3vs10:am'  'u3vs10:sp'    1    [3 ,2]  10  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u3vs11' 'u3vs11:am'  'u3vs11:sp'    1    [3 ,3]  11  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u3vs12' 'u3vs12:am'  'u3vs12:sp'    1    [3 ,4]  12  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 ...
 'u4vs13' 'u4vs13:am'  'u4vs13:sp'    1    [4 ,1]  13  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
 'u4vs14' 'u4vs14:am'  'u4vs14:sp'    1    [4 ,2]  14  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u4vs15' 'u4vs15:am'  'u4vs15:sp'    1    [4 ,3]  15  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_A  1/VCMGain_A; ...
 'u4vs16' 'u4vs16:am'  'u4vs16:sp'    1    [4 ,4]  16  [-VCMRange +VCMRange]  VCMTol  RMKICK  VCMGain_S  1/VCMGain_S; ...
};


for ii=1:size(vcor,1)

%AO.VCM.CommonNames(ii,:)           = vcor{ii,1};            
AO.VCM.Monitor.ChannelNames(ii,:)  = vcor{ii,2};
AO.VCM.Setpoint.ChannelNames(ii,:) = vcor{ii,3};     
AO.VCM.Status(ii,1)                = vcor{ii,4};
AO.VCM.DeviceList(ii,:)            = vcor{ii,5};
AO.VCM.ElementList(ii,1)           = vcor{ii,6};
AO.VCM.Setpoint.Range(ii,:)        = vcor{ii,7};
AO.VCM.Setpoint.Tolerance(ii,1)    = vcor{ii,8};
AO.VCM.Setpoint.DeltaRespMat(ii,1) = vcor{ii,9};

AO.VCM.Monitor.HW2PhysicsParams(ii,:)  = vcor{ii,10};          
AO.VCM.Monitor.Physics2HWParams(ii,:)  = vcor{ii,11};
AO.VCM.Setpoint.HW2PhysicsParams(ii,:) = vcor{ii,10};          
AO.VCM.Setpoint.Physics2HWParams(ii,:) = vcor{ii,11};
end  


AO.HCM.Status=AO.HCM.Status(:);
AO.VCM.Status=AO.VCM.Status(:);



%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
% AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList);
% AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList);




%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========

% *** BEND ***
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf = {'MachineConfig'; 'PlotFamily'; 'BEND'; 'Magnet';};

AO.BEND.Monitor.Mode           = Mode;
AO.BEND.Monitor.DataType       = 'Scalar';
AO.BEND.Monitor.Units          = 'Hardware';
AO.BEND.Monitor.HWUnits        = 'Ampere';           
AO.BEND.Monitor.PhysicsUnits   = 'radian';
%AO.BEND.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.BEND.Monitor.Physics2HWFcn  = @k2amp;

AO.BEND.Setpoint.Mode          = Mode;
AO.BEND.Setpoint.DataType      = 'Scalar';
AO.BEND.Setpoint.Units         = 'Hardware';
AO.BEND.Setpoint.HWUnits       = 'Ampere';           
AO.BEND.Setpoint.PhysicsUnits  = 'radian';
%AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.BEND.Setpoint.Physics2HWFcn = @k2amp;

bendrange = 2000;  % setpoint (1891.5 for readback)

BENDGain = 4.532e-4;  %  rad/A  for setpoint (for readback 4.792e-4)
AO.BEND.Monitor.HW2PhysicsParams  = BENDGain;          
AO.BEND.Monitor.Physics2HWParams  = 1.0/BENDGain;
AO.BEND.Setpoint.HW2PhysicsParams = BENDGain;          
AO.BEND.Setpoint.Physics2HWParams = 1.0/BENDGain;


%common    monitor   setpoint stat devlist elem  range   tol 
bend={
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [1, 1]  1  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [1, 2]  2  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [2, 1]  3  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [2, 2]  4  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [3, 1]  5  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [3, 2]  6  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [4, 1]  7  [0 bendrange] 1.0; ...
  'uvdip' 'uvdip:am' 'uvdip:sp'  1  [4, 2]  8  [0 bendrange] 1.0; ...
};

for ii=1:size(bend, 1)
  %AO.BEND.CommonNames(ii, :)           = bend{ii, 1};            
  AO.BEND.Monitor.ChannelNames(ii, :)  = bend{ii, 2};
  AO.BEND.Setpoint.ChannelNames(ii, :) = bend{ii, 3};     
  AO.BEND.Status(ii, 1)                = bend{ii, 4};
  AO.BEND.DeviceList(ii, :)            = bend{ii, 5};
  AO.BEND.ElementList(ii, 1)           = bend{ii, 6};

  AO.BEND.Setpoint.Range(ii, :)        = bend{ii, 7};
  AO.BEND.Setpoint.Tolerance(ii, 1)    = bend{ii, 8};
end

setao(AO);


%===============
%Quadrupole data
%===============

Qrange = 200;
QGain = 1.418e-2;  %  m^-2/A ??

% *** Q1 ***
AO.Q1.FamilyName = 'Q1';
AO.Q1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; };

AO.Q1.Monitor.Mode           = Mode;
AO.Q1.Monitor.DataType       = 'Scalar';
AO.Q1.Monitor.Units          = 'Hardware';
AO.Q1.Monitor.HWUnits        = 'A';           
AO.Q1.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q1.Monitor.Physics2HWFcn  = @k2amp;

AO.Q1.Setpoint.Mode          = Mode;
AO.Q1.Setpoint.DataType      = 'Scalar';
AO.Q1.Setpoint.Units         = 'Hardware';
AO.Q1.Setpoint.HWUnits       = 'A';           
AO.Q1.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q1.Setpoint.Physics2HWFcn = @k2amp;

AO.Q1.Monitor.HW2PhysicsParams  = QGain;          
AO.Q1.Monitor.Physics2HWParams  = 1.0/QGain;
AO.Q1.Setpoint.HW2PhysicsParams = QGain;          
AO.Q1.Setpoint.Physics2HWParams = 1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q1={
  'uvq1' 'uvq1:CurrSetptDes' 'uvq1:am' 'uvq1:sp'  1  [1, 1]   1  [0  Qrange] 0.20 0.4; ...
  'uvq1' 'uvq1:CurrSetptDes' 'uvq1:am' 'uvq1:sp'  1  [2, 1]   2  [0  Qrange] 0.20 0.4; ...
  'uvq1' 'uvq1:CurrSetptDes' 'uvq1:am' 'uvq1:sp'  1  [3, 1]   3  [0  Qrange] 0.20 0.4; ...
  'uvq1' 'uvq1:CurrSetptDes' 'uvq1:am' 'uvq1:sp'  1  [4, 1]   4  [0  Qrange] 0.20 0.4; ...
  };

for ii=1:size(q1, 1)
  %AO.Q1.CommonNames(ii, :)           = q1{ii, 1};            
  AO.Q1.Monitor.ChannelNames(ii, :)  = q1{ii, 3};
  AO.Q1.Setpoint.ChannelNames(ii, :) = q1{ii, 4};     
  AO.Q1.Status(ii, 1)                = q1{ii, 5};
  AO.Q1.DeviceList(ii, :)            = q1{ii, 6};
  AO.Q1.ElementList(ii, 1)           = q1{ii, 7};
  AO.Q1.Setpoint.Range(ii, :)        = q1{ii, 8};
  AO.Q1.Setpoint.Tolerance(ii, 1)    = q1{ii, 9};
  AO.Q1.Setpoint.DeltaRespMat(ii, 1) = q1{ii, 10};
end

setao(AO);


% *** Q2 ***
AO.Q2.FamilyName = 'Q2';
AO.Q2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'; };

AO.Q2.Monitor.Mode           = Mode;
AO.Q2.Monitor.DataType       = 'Scalar';
AO.Q2.Monitor.Units          = 'Hardware';
AO.Q2.Monitor.HWUnits        = 'A';           
AO.Q2.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q2.Monitor.Physics2HWFcn  = @k2amp;

AO.Q2.Setpoint.Mode          = Mode;
AO.Q2.Setpoint.DataType      = 'Scalar';
AO.Q2.Setpoint.Units         = 'Hardware';
AO.Q2.Setpoint.HWUnits       = 'A';           
AO.Q2.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q2.Setpoint.Physics2HWFcn = @k2amp;

AO.Q2.Monitor.HW2PhysicsParams  = -QGain;          
AO.Q2.Monitor.Physics2HWParams  = -1.0/QGain;
AO.Q2.Setpoint.HW2PhysicsParams = -QGain;          
AO.Q2.Setpoint.Physics2HWParams = -1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q2={
  'uvq2' 'uvq2:CurrSetptDes' 'uvq2:am' 'uvq2:sp'  1  [1, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq2' 'uvq2:CurrSetptDes' 'uvq2:am' 'uvq2:sp'  1  [2, 1]   2  [0,  Qrange] 0.20 0.4; ...
  'uvq2' 'uvq2:CurrSetptDes' 'uvq2:am' 'uvq2:sp'  1  [3, 1]   3  [0,  Qrange] 0.20 0.4; ...
  'uvq2' 'uvq2:CurrSetptDes' 'uvq2:am' 'uvq2:sp'  1  [4, 1]   4  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q2, 1)
  %AO.Q2.CommonNames(ii, :)           = q2{ii, 1};            
  AO.Q2.Monitor.ChannelNames(ii, :)  = q2{ii, 3};
  AO.Q2.Setpoint.ChannelNames(ii, :) = q2{ii, 4};     
  AO.Q2.Status(ii, 1)                = q2{ii, 5};
  AO.Q2.DeviceList(ii, :)            = q2{ii, 6};
  AO.Q2.ElementList(ii, 1)           = q2{ii, 7};
  AO.Q2.Setpoint.Range(ii, :)        = q2{ii, 8};
  AO.Q2.Setpoint.Tolerance(ii, 1)    = q2{ii, 9};
  AO.Q2.Setpoint.DeltaRespMat(ii, 1) = q2{ii, 10};
end 

setao(AO);


% *** Q3 ***
AO.Q3.FamilyName = 'Q3';
AO.Q3.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.Q3.Monitor.Mode           = Mode;
AO.Q3.Monitor.DataType       = 'Scalar';
AO.Q3.Monitor.Units          = 'Hardware';
AO.Q3.Monitor.HWUnits        = 'A';           
AO.Q3.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q3.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q3.Monitor.Physics2HWFcn  = @k2amp;

AO.Q3.Setpoint.Mode          = Mode;
AO.Q3.Setpoint.DataType      = 'Scalar';
AO.Q3.Setpoint.Units         = 'Hardware';
AO.Q3.Setpoint.HWUnits       = 'A';           
AO.Q3.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q3.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q3.Setpoint.Physics2HWFcn = @k2amp;

AO.Q3.Monitor.HW2PhysicsParams  = QGain;          
AO.Q3.Monitor.Physics2HWParams  = 1.0/QGain;
AO.Q3.Setpoint.HW2PhysicsParams = QGain;          
AO.Q3.Setpoint.Physics2HWParams = 1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q3={
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [1, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [1, 2]   2  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [2, 1]   3  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [2, 2]   4  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [3, 1]   5  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [3, 2]   6  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [4, 1]   7  [0,  Qrange] 0.20 0.4; ...
  'uvq3' 'uvq3:CurrSetptDes' 'uvq3:am' 'uvq3:sp'  1  [4, 2]   8  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q3, 1)
  %AO.Q3.CommonNames(ii, :)           = q3{ii, 1};            
  AO.Q3.Monitor.ChannelNames(ii, :)  = q3{ii, 3};
  AO.Q3.Setpoint.ChannelNames(ii, :) = q3{ii, 4};     
  AO.Q3.Status(ii, 1)                = q3{ii, 5};
  AO.Q3.DeviceList(ii, :)            = q3{ii, 6};
  AO.Q3.ElementList(ii, 1)           = q3{ii, 7};
  AO.Q3.Setpoint.Range(ii, :)        = q3{ii, 8};
  AO.Q3.Setpoint.Tolerance(ii, 1)    = q3{ii, 9};
  AO.Q3.Setpoint.DeltaRespMat(ii, 1) = q3{ii, 10};
end 

setao(AO);

% *** Q4 ***
AO.Q4.FamilyName = 'Q4';
AO.Q4.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.Q4.Monitor.Mode           = Mode;
AO.Q4.Monitor.DataType       = 'Scalar';
AO.Q4.Monitor.Units          = 'Hardware';
AO.Q4.Monitor.HWUnits        = 'A';           
AO.Q4.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q4.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q4.Monitor.Physics2HWFcn  = @k2amp;

AO.Q4.Setpoint.Mode          = Mode;
AO.Q4.Setpoint.DataType      = 'Scalar';
AO.Q4.Setpoint.Units         = 'Hardware';
AO.Q4.Setpoint.HWUnits       = 'A';           
AO.Q4.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q4.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q4.Setpoint.Physics2HWFcn = @k2amp;

AO.Q4.Monitor.HW2PhysicsParams  = -QGain;          
AO.Q4.Monitor.Physics2HWParams  = -1.0/QGain;
AO.Q4.Setpoint.HW2PhysicsParams = -QGain;          
AO.Q4.Setpoint.Physics2HWParams = -1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q4={
  'uvq4' 'uvq4:CurrSetptDes' 'uvq4:am' 'uvq4:sp'  1  [1, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq4' 'uvq4:CurrSetptDes' 'uvq4:am' 'uvq4:sp'  1  [2, 1]   2  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q4, 1)
  %AO.Q4.CommonNames(ii, :)           = q4{ii, 1};            
  AO.Q4.Monitor.ChannelNames(ii, :)  = q4{ii, 3};
  AO.Q4.Setpoint.ChannelNames(ii, :) = q4{ii, 4};     
  AO.Q4.Status(ii, 1)                = q4{ii, 5};
  AO.Q4.DeviceList(ii, :)            = q4{ii, 6};
  AO.Q4.ElementList(ii, 1)           = q4{ii, 7};
  AO.Q4.Setpoint.Range(ii, :)        = q4{ii, 8};
  AO.Q4.Setpoint.Tolerance(ii, 1)    = q4{ii, 9};
  AO.Q4.Setpoint.DeltaRespMat(ii, 1) = q4{ii, 10};
end 

setao(AO);

% *** Q5 ***
AO.Q5.FamilyName = 'Q5';
AO.Q5.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.Q5.Monitor.Mode           = Mode;
AO.Q5.Monitor.DataType       = 'Scalar';
AO.Q5.Monitor.Units          = 'Hardware';
AO.Q5.Monitor.HWUnits        = 'A';           
AO.Q5.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q5.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q5.Monitor.Physics2HWFcn  = @k2amp;

AO.Q5.Setpoint.Mode          = Mode;
AO.Q5.Setpoint.DataType      = 'Scalar';
AO.Q5.Setpoint.Units         = 'Hardware';
AO.Q5.Setpoint.HWUnits       = 'A';           
AO.Q5.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q5.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q5.Setpoint.Physics2HWFcn = @k2amp;

AO.Q5.Monitor.HW2PhysicsParams  = QGain;          
AO.Q5.Monitor.Physics2HWParams  = 1.0/QGain;
AO.Q5.Setpoint.HW2PhysicsParams = QGain;          
AO.Q5.Setpoint.Physics2HWParams = 1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q5={
  'uvq5' 'uvq5:CurrSetptDes' 'uvq5:am' 'uvq5:sp'  1  [1, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq5' 'uvq5:CurrSetptDes' 'uvq5:am' 'uvq5:sp'  1  [2, 1]   2  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q5, 1)
  %AO.Q5.CommonNames(ii, :)           = q5{ii, 1};            
  AO.Q5.Monitor.ChannelNames(ii, :)  = q5{ii, 3};
  AO.Q5.Setpoint.ChannelNames(ii, :) = q5{ii, 4};     
  AO.Q5.Status(ii, 1)                = q5{ii, 5};
  AO.Q5.DeviceList(ii, :)            = q5{ii, 6};
  AO.Q5.ElementList(ii, 1)           = q5{ii, 7};
  AO.Q5.Setpoint.Range(ii, :)        = q5{ii, 8};
  AO.Q5.Setpoint.Tolerance(ii, 1)    = q5{ii, 9};
  AO.Q5.Setpoint.DeltaRespMat(ii, 1) = q5{ii, 10};
end 

setao(AO);

% *** Q6 ***
AO.Q6.FamilyName = 'Q6';
AO.Q6.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.Q6.Monitor.Mode           = Mode;
AO.Q6.Monitor.DataType       = 'Scalar';
AO.Q6.Monitor.Units          = 'Hardware';
AO.Q6.Monitor.HWUnits        = 'A';           
AO.Q6.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q6.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q6.Monitor.Physics2HWFcn  = @k2amp;

AO.Q6.Setpoint.Mode          = Mode;
AO.Q6.Setpoint.DataType      = 'Scalar';
AO.Q6.Setpoint.Units         = 'Hardware';
AO.Q6.Setpoint.HWUnits       = 'A';           
AO.Q6.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q6.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q6.Setpoint.Physics2HWFcn = @k2amp;

AO.Q6.Monitor.HW2PhysicsParams  = -QGain;          
AO.Q6.Monitor.Physics2HWParams  = -1.0/QGain;
AO.Q6.Setpoint.HW2PhysicsParams = -QGain;          
AO.Q6.Setpoint.Physics2HWParams = -1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q6={
  'uvq6' 'uvq6:CurrSetptDes' 'uvq6:am' 'uvq6:sp'  1  [3, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq6' 'uvq6:CurrSetptDes' 'uvq6:am' 'uvq6:sp'  1  [4, 1]   2  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q6, 1)
  %AO.Q6.CommonNames(ii, :)           = q6{ii, 1};            
  AO.Q6.Monitor.ChannelNames(ii, :)  = q6{ii, 3};
  AO.Q6.Setpoint.ChannelNames(ii, :) = q6{ii, 4};     
  AO.Q6.Status(ii, 1)                = q6{ii, 5};
  AO.Q6.DeviceList(ii, :)            = q6{ii, 6};
  AO.Q6.ElementList(ii, 1)           = q6{ii, 7};
  AO.Q6.Setpoint.Range(ii, :)        = q6{ii, 8};
  AO.Q6.Setpoint.Tolerance(ii, 1)    = q6{ii, 9};
  AO.Q6.Setpoint.DeltaRespMat(ii, 1) = q6{ii, 10};
end 

setao(AO);


% *** Q7 ***
AO.Q7.FamilyName = 'Q7';
AO.Q7.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.Q7.Monitor.Mode           = Mode;
AO.Q7.Monitor.DataType       = 'Scalar';
AO.Q7.Monitor.Units          = 'Hardware';
AO.Q7.Monitor.HWUnits        = 'A';           
AO.Q7.Monitor.PhysicsUnits   = 'm^-2';
%AO.Q7.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Q7.Monitor.Physics2HWFcn  = @k2amp;

AO.Q7.Setpoint.Mode          = Mode;
AO.Q7.Setpoint.DataType      = 'Scalar';
AO.Q7.Setpoint.Units         = 'Hardware';
AO.Q7.Setpoint.HWUnits       = 'A';           
AO.Q7.Setpoint.PhysicsUnits  = 'm^-2';
%AO.Q7.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.Q7.Setpoint.Physics2HWFcn = @k2amp;

AO.Q7.Monitor.HW2PhysicsParams  = QGain;          
AO.Q7.Monitor.Physics2HWParams  = 1.0/QGain;
AO.Q7.Setpoint.HW2PhysicsParams = QGain;          
AO.Q7.Setpoint.Physics2HWParams = 1.0/QGain;

% common      desired         monitor  setpoint stat devlist elem  range     tol respkick
q7={
  'uvq7' 'uvq7:CurrSetptDes' 'uvq7:am' 'uvq7:sp'  1  [3, 1]   1  [0,  Qrange] 0.20 0.4; ...
  'uvq7' 'uvq7:CurrSetptDes' 'uvq7:am' 'uvq7:sp'  1  [4, 1]   2  [0,  Qrange] 0.20 0.4; ...
};

for ii=1:size(q7, 1)
  %AO.Q7.CommonNames(ii, :)           = q7{ii, 1};            
  AO.Q7.Monitor.ChannelNames(ii, :)  = q7{ii, 3};
  AO.Q7.Setpoint.ChannelNames(ii, :) = q7{ii, 4};     
  AO.Q7.Status(ii, 1)                = q7{ii, 5};
  AO.Q7.DeviceList(ii, :)            = q7{ii, 6};
  AO.Q7.ElementList(ii, 1)           = q7{ii, 7};
  AO.Q7.Setpoint.Range(ii, :)        = q7{ii, 8};
  AO.Q7.Setpoint.Tolerance(ii, 1)    = q7{ii, 9};
  AO.Q7.Setpoint.DeltaRespMat(ii, 1) = q7{ii, 10};
end 

setao(AO);



%===============
%Sextupole data
%===============

Srange = 100; % 95 ?

% *** SF ***

AO.SF.FamilyName = 'SF';
AO.SF.MemberOf = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Chromaticity Corrector';};

AO.SF.Monitor.Mode           = Mode;
AO.SF.Monitor.DataType       = 'Scalar';
AO.SF.Monitor.Units          = 'Hardware';
AO.SF.Monitor.HWUnits        = 'A';           
AO.SF.Monitor.PhysicsUnits   = 'm^-3';
%AO.SF.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SF.Monitor.Physics2HWFcn  = @k2amp;

AO.SF.Setpoint.Mode          = Mode;
AO.SF.Setpoint.DataType      = 'Scalar';
AO.SF.Setpoint.Units         = 'Hardware';
AO.SF.Setpoint.HWUnits       = 'A';           
AO.SF.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SF.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SF.Setpoint.Physics2HWFcn = @k2amp;

SFGain = 0.403; % 0.3925 m^-3/A ??
AO.SF.Monitor.HW2PhysicsParams  = SFGain;          
AO.SF.Monitor.Physics2HWParams  = 1.0/SFGain;
AO.SF.Setpoint.HW2PhysicsParams = SFGain;          
AO.SF.Setpoint.Physics2HWParams = 1.0/SFGain;

% common      desired            monitor   setpoint stat devlist elem  range    tol respkick
sf={
  'usxf' 'usxf:CurrSetptDes' 'usxf:am' 'usxf:sp'  1  [1, 1]  1  [0, Srange] 1.0 2.5; ...
  'usxf' 'usxf:CurrSetptDes' 'usxf:am' 'usxf:sp'  1  [2, 1]  2  [0, Srange] 1.0 2.5; ...
  'usxf' 'usxf:CurrSetptDes' 'usxf:am' 'usxf:sp'  1  [3, 1]  3  [0, Srange] 1.0 2.5; ...
  'usxf' 'usxf:CurrSetptDes' 'usxf:am' 'usxf:sp'  1  [4, 1]  4  [0, Srange] 1.0 2.5; ...
};

for ii=1:size(sf,1)
  %AO.SF.CommonNames(ii,:)           = sf{ii,1};            
  AO.SF.Monitor.ChannelNames(ii,:)  = sf{ii,3};
  AO.SF.Setpoint.ChannelNames(ii,:) = sf{ii,4};     
  AO.SF.Status(ii,1)                = sf{ii,5};
  AO.SF.DeviceList(ii,:)            = sf{ii,6};
  AO.SF.ElementList(ii,1)           = sf{ii,7};

  AO.SF.Setpoint.Range(ii,:)        = sf{ii,8};
  AO.SF.Setpoint.Tolerance(ii,1)    = sf{ii,9};
  AO.SF.Setpoint.DeltaRespMat(ii,1) = sf{ii,10};
end

setao(AO);


% *** SD ***
AO.SD.FamilyName = 'SD';
AO.SD.MemberOf = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet'; 'Chromaticity Corrector';};

AO.SD.Monitor.Mode           = Mode;
AO.SD.Monitor.DataType       = 'Scalar';
AO.SD.Monitor.Units          = 'Hardware';
AO.SD.Monitor.HWUnits        = 'A';           
AO.SD.Monitor.PhysicsUnits   = 'm^-3';
%AO.SD.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SD.Monitor.Physics2HWFcn  = @k2amp;

AO.SD.Setpoint.Mode          = Mode;
AO.SD.Setpoint.DataType      = 'Scalar';
AO.SD.Setpoint.Units         = 'Hardware';
AO.SD.Setpoint.HWUnits       = 'A';           
AO.SD.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SD.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SD.Setpoint.Physics2HWFcn = @k2amp;

SDGain = -0.403;  %  m^-3/A
AO.SD.Monitor.HW2PhysicsParams  = SDGain;          
AO.SD.Monitor.Physics2HWParams  = 1.0/SDGain;
AO.SD.Setpoint.HW2PhysicsParams = SDGain;          
AO.SD.Setpoint.Physics2HWParams = 1.0/SDGain;

% common      desired           monitor    setpoint stat devlist elem  range    tol respkick
sd={
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [1, 1]  1  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [1, 2]  2  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [2, 1]  3  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [2, 2]  4  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [3, 1]  5  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [3, 2]  6  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [4, 1]  7  [0, Srange] 1.0 2.5; ...
  'usxd' 'usxd:CurrSetptDes' 'usxd:am' 'usxd:sp'  1  [4, 2]  8  [0, Srange] 1.0 2.5; ...
};

for ii=1:size(sd,1)
  %AO.SD.CommonNames(ii,:)           = sd{ii,1};            
  AO.SD.Monitor.ChannelNames(ii,:)  = sd{ii,3};
  AO.SD.Setpoint.ChannelNames(ii,:) = sd{ii,4};     
  AO.SD.Status(ii,1)                = sd{ii,5};
  AO.SD.DeviceList(ii,:)            = sd{ii,6};
  AO.SD.ElementList(ii,1)           = sd{ii,7};
 
  AO.SD.Setpoint.Range(ii,:)        = sd{ii,8};
  AO.SD.Setpoint.Tolerance(ii,1)    = sd{ii,9};
  AO.SD.Setpoint.DeltaRespMat(ii,1) = sd{ii,10};
end

setao(AO);


%============
%RF System
%============
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf = {'MachineConfig'; 'PlotFamily';  'RF'; 'RFSystem'};
AO.RF.Status = 1;
AO.RF.CommonNames = 'RF';
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

%Frequency Readback
AO.RF.Monitor.Mode                = 'Special';
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.SpecialFunctionGet  = 'getrfvuv';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+6;
AO.RF.Monitor.Physics2HWParams    = 1e-6;
AO.RF.Monitor.HWUnits             = 'MHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';

%Frequency Setpoint
AO.RF.Setpoint.Mode               = 'Special';
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.SpecialFunctionSet = 'setrfvuv';
AO.RF.Setpoint.SpecialFunctionGet = 'getrfvuv';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.Range              = [52.760000 53.010000]; %10% acceptance
%                                    52.885 MHz central frequency
AO.RF.Setpoint.Tolerance          = 1;


%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.MemberOf    = {'Diagnostics'};
AO.TUNE.CommonNames = ['xtune'; 'ytune'; 'stune'];
AO.TUNE.DeviceList  = [1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';
AO.TUNE.Position    = 0;

AO.TUNE.Monitor.Mode                   = 'Special';
AO.TUNE.Monitor.DataType               = 'Scalar';
AO.TUNE.Monitor.ChannelNames           = ['utuneh:am'; 'utunev:am'; '         '];    
%AO.TUNE.Monitor.SpecialFunctionGet     = 'gettune_vuv';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';


%====
%DCCT
%====
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'DCCT'; 'Beam Current'; 'Diagnostics'};
AO.DCCT.CommonNames              = 'DCCT';
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 0;

AO.DCCT.Monitor.Mode             = Mode;
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'uvcurr:am';    
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'mA';           
AO.DCCT.Monitor.PhysicsUnits     = 'A';
AO.DCCT.Monitor.HW2PhysicsParams = 0.001;          
AO.DCCT.Monitor.Physics2HWParams = 1000.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AcceleratorData structure, AT indices, etc %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Set response matrix kick size in hardware units
% AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .15e-3 / 3, AO.HCM.DeviceList);
% AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .15e-3 / 3, AO.VCM.DeviceList);
% 
% AO.QF.Setpoint.DeltaRespMat = .15;
% AO.QD.Setpoint.DeltaRespMat = .1;
% 
% AO.SF.Setpoint.DeltaRespMat = 5;  % 10
% AO.SD.Setpoint.DeltaRespMat = 5; % 10;


setao(AO);

