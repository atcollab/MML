function XRayInit(OperationalMode)
%
% Initialize NSLS X-Ray Ring parameters for control in MATLAB
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
% HW2PhysicsFcn         function handle used to convert from hardware to physics units
%                       ==> inline will not compile, see below
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
%    SQ
%    BEND
%    BDM
%    QA
%    QB
%    QC
%    QD
%    SF
%    SD
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
% MATCH    (7 BPM): BPM-QDX-HVCM-QFX-QDY-BEND-SDM-VCM-SFM-QFY-SFM-HCM-SDM-BEND-QDZ-HVCM-QFZ-BPM
% STANDARD (6 BPM): BPM-QF-HVCM-QD-BEND-SD-VCM-SF-QDC-SF-HCM-SD-BEND-QD-HVCM-QF-BPM
% NOTES: 
%   all sextupoles have skew quadrupole windings
%   all quadrupoles have trim/modulation windings


if nargin == 0
    OperationalMode = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the AO structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

Mode = 'ONLINE';

% Clear previous AcceleratorObjects
setao([]);


%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=48;
AO.BPMx.FamilyName               = 'BPMx';
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMx'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.DataTypeIndex    = [1:ntbpm];
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'm';

AO.BPMy.FamilyName               = 'BPMy';
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMy'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.DataTypeIndex    = [1:ntbpm];
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'm';

%  x-name       x-ch   xstat  y-name      y-ch    ystat DevList Elem

bpm={
  'xpue01h' 'xpue01h:am' 1 'xpue01v' 'xpue01v:am' 1 [1, 1]  1; ...
  'xpue02h' 'xpue02h:am' 1 'xpue02v' 'xpue02v:am' 1 [1, 2]  2; ...
  'xpue03h' 'xpue03h:am' 1 'xpue03v' 'xpue03v:am' 1 [1, 3]  3; ...
  'xpue04h' 'xpue04h:am' 1 'xpue04v' 'xpue04v:am' 1 [1, 4]  4; ...
  'xpue05h' 'xpue05h:am' 1 'xpue05v' 'xpue05v:am' 1 [1, 5]  5; ...
  'xpue06h' 'xpue06h:am' 1 'xpue06v' 'xpue06v:am' 1 [1, 6]  6; ...
  'xpue07h' 'xpue07h:am' 1 'xpue07v' 'xpue07v:am' 1 [2, 1]  7; ...
  'xpue08h' 'xpue08h:am' 1 'xpue08v' 'xpue08v:am' 1 [2, 2]  8; ...
  'xpue09h' 'xpue09h:am' 1 'xpue09v' 'xpue09v:am' 1 [2, 3]  9; ...
  'xpue10h' 'xpue10h:am' 1 'xpue10v' 'xpue10v:am' 1 [2, 4] 10; ...
  'xpue11h' 'xpue11h:am' 1 'xpue11v' 'xpue11v:am' 1 [2, 5] 11; ...
  'xpue12h' 'xpue12h:am' 1 'xpue12v' 'xpue12v:am' 1 [2, 6] 12; ...
  'xpue13h' 'xpue13h:am' 1 'xpue13v' 'xpue13v:am' 1 [3, 1] 13; ...
  'xpue14h' 'xpue14h:am' 1 'xpue14v' 'xpue14v:am' 1 [3, 2] 14; ...
  'xpue15h' 'xpue15h:am' 1 'xpue15v' 'xpue15v:am' 1 [3, 3] 15; ...
  'xpue16h' 'xpue16h:am' 1 'xpue16v' 'xpue16v:am' 1 [3, 4] 16; ...
  'xpue17h' 'xpue17h:am' 1 'xpue17v' 'xpue17v:am' 1 [3, 5] 17; ...
  'xpue18h' 'xpue18h:am' 1 'xpue18v' 'xpue18v:am' 1 [3, 6] 18; ...
  'xpue19h' 'xpue19h:am' 1 'xpue19v' 'xpue19v:am' 1 [4, 1] 19; ...
  'xpue20h' 'xpue20h:am' 1 'xpue20v' 'xpue20v:am' 1 [4, 2] 20; ...
  'xpue21h' 'xpue21h:am' 1 'xpue21v' 'xpue21v:am' 1 [4, 3] 21; ...
  'xpue22h' 'xpue22h:am' 1 'xpue22v' 'xpue22v:am' 1 [4, 4] 22; ...
  'xpue23h' 'xpue23h:am' 1 'xpue23v' 'xpue23v:am' 1 [4, 5] 23; ...
  'xpue24h' 'xpue24h:am' 1 'xpue24v' 'xpue24v:am' 1 [4, 6] 24; ...
  'xpue25h' 'xpue25h:am' 1 'xpue25v' 'xpue25v:am' 1 [5, 1] 25; ...
  'xpue26h' 'xpue26h:am' 1 'xpue26v' 'xpue26v:am' 1 [5, 2] 26; ...
  'xpue27h' 'xpue27h:am' 1 'xpue27v' 'xpue27v:am' 1 [5, 3] 27; ...
  'xpue28h' 'xpue28h:am' 1 'xpue28v' 'xpue28v:am' 1 [5, 4] 28; ...
  'xpue29h' 'xpue29h:am' 1 'xpue29v' 'xpue29v:am' 1 [5, 5] 29; ...
  'xpue30h' 'xpue30h:am' 1 'xpue30v' 'xpue30v:am' 1 [5, 6] 30; ...
  'xpue31h' 'xpue31h:am' 1 'xpue31v' 'xpue31v:am' 1 [6, 1] 31; ...
  'xpue32h' 'xpue32h:am' 1 'xpue32v' 'xpue32v:am' 1 [6, 2] 32; ...
  'xpue33h' 'xpue33h:am' 1 'xpue33v' 'xpue33v:am' 1 [6, 3] 33; ...
  'xpue34h' 'xpue34h:am' 1 'xpue34v' 'xpue34v:am' 1 [6, 4] 34; ...
  'xpue35h' 'xpue35h:am' 1 'xpue35v' 'xpue35v:am' 1 [6, 5] 35; ...
  'xpue36h' 'xpue36h:am' 1 'xpue36v' 'xpue36v:am' 1 [6, 6] 36; ...
  'xpue37h' 'xpue37h:am' 1 'xpue37v' 'xpue37v:am' 1 [7, 1] 37; ...
  'xpue38h' 'xpue38h:am' 1 'xpue38v' 'xpue38v:am' 1 [7, 2] 38; ...
  'xpue39h' 'xpue39h:am' 1 'xpue39v' 'xpue39v:am' 1 [7, 3] 39; ...
  'xpue40h' 'xpue40h:am' 1 'xpue40v' 'xpue40v:am' 1 [7, 4] 40; ...
  'xpue41h' 'xpue41h:am' 1 'xpue41v' 'xpue41v:am' 1 [7, 5] 41; ...
  'xpue42h' 'xpue42h:am' 1 'xpue42v' 'xpue42v:am' 1 [7, 6] 42; ...
  'xpue43h' 'xpue43h:am' 1 'xpue43v' 'xpue43v:am' 1 [8, 1] 43; ...
  'xpue44h' 'xpue44h:am' 1 'xpue44v' 'xpue44v:am' 1 [8, 2] 44; ...
  'xpue45h' 'xpue45h:am' 1 'xpue45v' 'xpue45v:am' 1 [8, 3] 45; ...
  'xpue46h' 'xpue46h:am' 1 'xpue46v' 'xpue46v:am' 1 [8, 4] 46; ...
  'xpue47h' 'xpue47h:am' 1 'xpue47v' 'xpue47v:am' 1 [8, 5] 47; ...
  'xpue48h' 'xpue48h:am' 1 'xpue48v' 'xpue48v:am' 1 [8, 6] 48; ...
};

%Load fields from data block
for ii=1:size(bpm, 1)
  AO.BPMx.CommonNames(ii, :)              = bpm{ii, 1};
  AO.BPMx.Monitor.ChannelNames(ii, :)     = bpm{ii, 2};
  AO.BPMx.Status(ii, :)                   = bpm{ii, 3};  
  AO.BPMy.CommonNames(ii, :)              = bpm{ii, 4};
  AO.BPMy.Monitor.ChannelNames(ii, :)     = bpm{ii, 5};
  AO.BPMy.Status(ii, :)                   = bpm{ii, 6};  
  AO.BPMx.DeviceList(ii, :)               = bpm{ii, 7};   
  AO.BPMy.DeviceList(ii, :)               = bpm{ii, 7};
  AO.BPMx.ElementList(ii, :)              = bpm{ii, 8};   
  AO.BPMy.ElementList(ii, :)              = bpm{ii, 8};
  AO.BPMx.Monitor.HW2PhysicsParams(ii, :) = 1e-3;
  AO.BPMx.Monitor.Physics2HWParams(ii, :) = 1e3;
  AO.BPMy.Monitor.HW2PhysicsParams(ii, :) = 1e-3;
  AO.BPMy.Monitor.Physics2HWParams(ii, :) = 1e3;
end

AO.BPMx.Status = AO.BPMx.Status(:); AO.BPMy.Status = AO.BPMy.Status(:);

% Scalar channel method
AO.BPMx.Monitor.DataType = 'Scalar'; AO.BPMy.Monitor.DataType = 'Scalar';

AO.BPMx.Monitor = rmfield(AO.BPMx.Monitor, 'DataTypeIndex');
AO.BPMy.Monitor = rmfield(AO.BPMy.Monitor, 'DataTypeIndex');
   


%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================

AO.HCM.FamilyName             = 'HCM';
AO.HCM.MemberOf               = {'MachineConfig'; 'PlotFamily';  'COR'; 'HCM'; 'Magnet'};

AO.HCM.Monitor.Mode           = Mode;
AO.HCM.Monitor.DataType       = 'Scalar';
AO.HCM.Monitor.Units          = 'Hardware';
AO.HCM.Monitor.HWUnits        = 'A';           
AO.HCM.Monitor.PhysicsUnits   = 'rad';
%AO.HCM.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.HCM.Monitor.Physics2HWFcn  = @k2amp;

AO.HCM.Setpoint.Mode          = Mode;
AO.HCM.Setpoint.DataType      = 'Scalar';
AO.HCM.Setpoint.Units         = 'Hardware';
AO.HCM.Setpoint.HWUnits       = 'A';           
AO.HCM.Setpoint.PhysicsUnits  = 'rad';
%AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.HCM.Setpoint.Physics2HWFcn = @k2amp;

HCMRange  = 10.0;  % [A]
HCMGain_L = 337*0.19/93.4e3/HCMRange;  % [rad/A]
HCMGain_S = 337*0.135/93.4e3/HCMRange;  % [rad/A]
% HCMGain_L = 2.80/.745*337*0.19/93.4e3/HCMRange;  % [rad/A]
% HCMGain_S = 2.80/.745*337*0.135/93.4e3/HCMRange;  % [rad/A]
 RMHKICK    = 2*0.5;  % Kick size for orbit response matrix measurement [A]
% RMHKICK    = 2*1.0;  % Kick size for orbit response matrix measurement [A]
% RMHKICK    = 2*1.5;  % Kick size for orbit response matrix measurement [A]
% RMHKICK    = 2*0.3 ;  % Kick size for orbit response matrix measurement [A] for injection energy

HCMTol    = 0.10; % Tolerance [A]

% x[1..8]h5       long
% x[1..8]h14

% x[1..8]h6       dipole backleg winding
% x[1..8]h13

% x[1,3,5,7]h16   skew quadrupole
% x[2,4,6,8]h3

% x[1..8]h8       short

% HW units in [A], Physics units in [rad]  ** [rad] converted to [A] below ***
%  x-name   x-mon       x-SP xstat devlist elem     range          tol   x-kick    H2P_X        P2H_X 
hcor = {
  'x1h2 ' 'x1h2:am ' 'x1h2:sp ' 1 [1, 1]  1 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x1h5 ' 'x1h5:am ' 'x1h5:sp ' 1 [1, 2]  2 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x1h6 ' 'x1h6:am ' 'x1h6:sp ' 1 [1, 3]  . [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x1h8 ' 'x1h8:am ' 'x1h8:sp ' 1 [1, 4]  3 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  not defined in lattice
%  'x1h12' 'x1h12:am' 'x1h12:sp' 1 [1, 5]  . [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x1h13' 'x1h13:am' 'x1h13:sp' 1 [1, 6]  . [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x1h14' 'x1h14:am' 'x1h14:sp' 1 [1, 7]  4 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x1h16' 'x1h16:am' 'x1h16:sp' 1 [1, 8]  5 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  ... 
  'x2h3 ' 'x2h3:am ' 'x2h3:sp ' 1 [2, 1]  6 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x2h5 ' 'x2h5:am ' 'x2h5:sp ' 1 [2, 2]  7 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x2h6 ' 'x2h6:am ' 'x2h6:sp ' 1 [2, 3] . [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x2h8 ' 'x2h8:am ' 'x2h8:sp ' 1 [2, 4]  8 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x2h13' 'x2h13:am' 'x2h13:sp' 1 [2, 5] . [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x2h14' 'x2h14:am' 'x2h14:sp' 1 [2, 6] 9 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x2h16' 'x2h16:am' 'x2h16:sp' 1 [2, 7] 10 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x2h17' 'x2h17:am' 'x2h17:sp' 1 [2, 8] 11 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
 ... 
  'x3h2 ' 'x3h2:am ' 'x3h2:sp ' 1 [3, 1] 12 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h3 ' 'x3h3:am ' 'x3h3:sp ' 1 [3, 2] 13 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h5 ' 'x3h5:am ' 'x3h5:sp ' 1 [3, 3] 14 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x3h6 ' 'x3h6:am ' 'x3h6:sp ' 1 [3, 4] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h8 ' 'x3h8:am ' 'x3h8:sp ' 1 [3, 5] 15 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x3h13' 'x3h13:am' 'x3h13:sp' 1 [3, 6] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h14' 'x3h14:am' 'x3h14:sp' 1 [3, 7] 16 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h16' 'x3h16:am' 'x3h16:sp' 1 [3, 8] 17 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x3h17' 'x3h17:am' 'x3h17:sp' 1 [3, 9] 18 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  ... 
  'x4h2 ' 'x4h2:am ' 'x4h2:sp ' 1 [4, 1] 19 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h3 ' 'x4h3:am ' 'x4h3:sp ' 1 [4, 2] 20 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h5 ' 'x4h5:am ' 'x4h5:sp ' 1 [4, 3] 21 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x4h6 ' 'x4h6:am ' 'x4h6:sp ' 1 [4, 4] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h8 ' 'x4h8:am ' 'x4h8:sp ' 0 [4, 5] 22 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x4h13' 'x4h13:am' 'x4h13:sp' 1 [4, 6] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h14' 'x4h14:am' 'x4h14:sp' 1 [4, 7] 23 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h16' 'x4h16:am' 'x4h16:sp' 1 [4, 8] 24 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x4h17' 'x4h17:am' 'x4h17:sp' 1 [4, 9] 25 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  ... 
  'x5h2 ' 'x5h2:am ' 'x5h2:sp ' 1 [5, 1] 26 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h3 ' 'x5h3:am ' 'x5h3:sp ' 1 [5, 2] 27 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h5 ' 'x5h5:am ' 'x5h5:sp ' 1 [5, 3] 28 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x5h6 ' 'x5h6:am ' 'x5h6:sp ' 1 [5, 4] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h8 ' 'x5h8:am ' 'x5h8:sp ' 1 [5, 5] 29 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x5h13' 'x5h13:am' 'x5h13:sp' 1 [5, 6] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h14' 'x5h14:am' 'x5h14:sp' 1 [5, 7] 30 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h16' 'x5h16:am' 'x5h16:sp' 1 [5, 8] 31 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x5h17' 'x5h17:am' 'x5h17:sp' 1 [5, 9] 32 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
 ... 
  'x6h2 ' 'x6h2:am ' 'x6h2:sp ' 1 [6, 1] 33 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x6h3 ' 'x6h3:am ' 'x6h3:sp ' 1 [6, 2] 34 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x6h5 ' 'x6h5:am ' 'x6h5:sp ' 1 [6, 3] 35 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x6h6 ' 'x6h6:am ' 'x6h6:sp ' 1 [6, 4] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x6h8 ' 'x6h8:am ' 'x6h8:sp ' 1 [6, 5] 36 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x6h13' 'x6h13:am' 'x6h13:sp' 1 [6, 6] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x6h14' 'x6h14:am' 'x6h14:sp' 1 [6, 7] 37 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L;...
  'x6h16' 'x6h16:am' 'x6h16:sp' 1 [6, 8] 38 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  ... 
  'x7h3 ' 'x7h3:am ' 'x7h3:sp ' 1 [7, 1] 39 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x7h5 ' 'x7h5:am ' 'x7h5:sp ' 1 [7, 2] 40 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x7h6 ' 'x7h6:am ' 'x7h6:sp ' 1 [7, 3] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x7h8 ' 'x7h8:am ' 'x7h8:sp ' 1 [7, 4] 41 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x7h13' 'x7h13:am' 'x7h13:sp' 1 [7, 5] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x7h14' 'x7h14:am' 'x7h14:sp' 1 [7, 6] 42 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x7h16' 'x7h16:am' 'x7h16:sp' 1 [7, 7] 43 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x7h17' 'x7h17:am' 'x7h17:sp' 1 [7, 8] 44 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
 ... 
  'x8h2 ' 'x8h2:am ' 'x8h2:sp ' 1 [8, 1] 45 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h3 ' 'x8h3:am ' 'x8h3:sp ' 1 [8, 2] 46 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h5 ' 'x8h5:am ' 'x8h5:sp ' 1 [8, 3] 47 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
%  'x8h6 ' 'x8h6:am ' 'x8h6:sp ' 1 [8, 4] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h8 ' 'x8h8:am ' 'x8h8:sp ' 1 [8, 5] 48 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_S 1/HCMGain_S; ...
%  'x8h13' 'x8h13:am' 'x8h13:sp' 1 [8, 6] .. [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h14' 'x8h14:am' 'x8h14:sp' 1 [8, 7] 49 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h16' 'x8h16:am' 'x8h16:sp' 1 [8, 8] 50 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
  'x8h17' 'x8h17:am' 'x8h17:sp' 1 [8, 9] 51 [-HCMRange +HCMRange] HCMTol RMHKICK HCMGain_L 1/HCMGain_L; ...
};

for ii=1:size(hcor, 1)
  AO.HCM.CommonNames(ii, :)               = hcor{ii, 1};            
  AO.HCM.Monitor.ChannelNames(ii, :)      = hcor{ii, 2};
  AO.HCM.Setpoint.ChannelNames(ii, :)     = hcor{ii, 3};     
  AO.HCM.Status(ii, 1)                    = hcor{ii, 4};

  AO.HCM.DeviceList(ii, :)                = hcor{ii, 5};
  AO.HCM.ElementList(ii, 1)               = hcor{ii, 6};
  AO.HCM.Setpoint.Range(ii, :)            = hcor{ii, 7};
  AO.HCM.Setpoint.Tolerance(ii, 1)        = hcor{ii, 8};
  AO.HCM.Setpoint.DeltaRespMat(ii, 1)     = hcor{ii, 9};
  
  AO.HCM.Monitor.HW2PhysicsParams(ii, 1)  = hcor{ii, 10};          
  AO.HCM.Monitor.Physics2HWParams(ii, 1)  = hcor{ii, 11};
  AO.HCM.Setpoint.HW2PhysicsParams(ii, 1) = hcor{ii, 10};          
  AO.HCM.Setpoint.Physics2HWParams(ii, 1) = hcor{ii, 11};
end



AO.VCM.FamilyName             = 'VCM';
AO.VCM.MemberOf               = {'MachineConfig'; 'PlotFamily';  'COR'; 'VCM'; 'Magnet'};

AO.VCM.Monitor.Mode           = Mode;
AO.VCM.Monitor.DataType       = 'Scalar';
AO.VCM.Monitor.Units          = 'Hardware';
AO.VCM.Monitor.HWUnits        = 'A';           
AO.VCM.Monitor.PhysicsUnits   = 'rad';
%AO.VCM.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.VCM.Monitor.Physics2HWFcn  = @k2amp;

AO.VCM.Setpoint.Mode          = Mode;
AO.VCM.Setpoint.DataType      = 'Scalar';
AO.VCM.Setpoint.Units         = 'Hardware';
AO.VCM.Setpoint.HWUnits       = 'A';           
AO.VCM.Setpoint.PhysicsUnits  = 'rad';
%AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.VCM.Setpoint.Physics2HWFcn = @k2amp;

VCMRange  = 10.0; % [A]
VCMGain_L = 337*0.19/93.4e3/VCMRange; % [rad/A]
VCMGain_S = 337*0.135/93.4e3/VCMRange; % [rad/A]
% VCMGain_L = 2.80/0.745*337*0.19/93.4e3/VCMRange; % [rad/A]
% VCMGain_S = 2.80/0.745*337*0.135/93.4e3/VCMRange; % [rad/A]
% RMVKICK    = 2*0.5;  % Kick size for orbit response matrix measurement 
RMVKICK    = 2*1.0;  % Kick size for orbit response matrix measurement 
% RMVKICK    = 2*1.5;  % Kick size for orbit response matrix measurement 
% RMVKICK    = 2*0.1 ;  % Kick size for orbit response matrix measurement [A] for injection energy

VCMTol    = 0.15; % Tolerance [A]

% x[1..8]v5       long
% x[1..8]v14

% x[1,3,5,7]v16   skew quadrupole
% x[2,4,6,8]v3

% x[1..8]v8       short

%  y-name   y-mon       y-SP ystat devlist elem range     tol y-kick   H2P_Y       P2H_Y 
vcor = {
  'x1v5 ' 'x1v5:am ' 'x1v5:sp ' 1 [1, 1]  1 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x1v8 ' 'x1v8:am ' 'x1v8:sp ' 1 [1, 2]  2 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x1v14' 'x1v14:am' 'x1v14:sp' 1 [1, 3]  3 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x1v16' 'x1v16:am' 'x1v16:sp' 1 [1, 4]  4 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  ... 
  'x2v3 ' 'x2v3:am ' 'x2v3:sp ' 1 [2, 1]  5 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x2v5 ' 'x2v5:am ' 'x2v5:sp ' 1 [2, 2]  6 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x2v8 ' 'x2v8:am ' 'x2v8:sp ' 1 [2, 3]  7 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x2v14' 'x2v14:am' 'x2v14:sp' 1 [2, 4]  8 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x2v16' 'x2v16:am' 'x2v16:sp' 1 [2, 5]  9 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
 ... 
  'x3v3 ' 'x3v3:am ' 'x3v3:sp ' 1 [3, 1] 10 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x3v5 ' 'x3v5:am ' 'x3v5:sp ' 1 [3, 2] 11 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x3v8 ' 'x3v8:am ' 'x3v8:sp ' 1 [3, 3] 12 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x3v14' 'x3v14:am' 'x3v14:sp' 1 [3, 4] 13 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x3v16' 'x3v16:am' 'x3v16:sp' 1 [3, 5] 14 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  ... 
  'x4v3 ' 'x4v3:am ' 'x4v3:sp ' 1 [4, 1] 15 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x4v5 ' 'x4v5:am ' 'x4v5:sp ' 1 [4, 2] 16 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x4v8 ' 'x4v8:am ' 'x4v8:sp ' 1 [4, 3] 17 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x4v14' 'x4v14:am' 'x4v14:sp' 1 [4, 4] 18 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x4v16' 'x4v16:am' 'x4v16:sp' 1 [4, 5] 19 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  ... 
  'x5v3 ' 'x5v3:am ' 'x5v3:sp ' 1 [5, 1] 20 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x5v5 ' 'x5v5:am ' 'x5v5:sp ' 1 [5, 2] 21 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x5v8 ' 'x5v8:am ' 'x5v8:sp ' 1 [5, 3] 22 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x5v14' 'x5v14:am' 'x5v14:sp' 1 [5, 4] 23 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x5v16' 'x5v16:am' 'x5v16:sp' 1 [5, 5] 24 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
 ... 
  'x6v3 ' 'x6v3:am ' 'x6v3:sp ' 1 [6, 1] 25 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x6v5 ' 'x6v5:am ' 'x6v5:sp ' 1 [6, 2] 26 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x6v8 ' 'x6v8:am ' 'x6v8:sp ' 1 [6, 3] 27 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x6v14' 'x6v14:am' 'x6v14:sp' 1 [6, 4] 28 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L;...
  'x6v16' 'x6v16:am' 'x6v16:sp' 1 [6, 5] 29 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
 ... 
  'x7v3 ' 'x7v3:am ' 'x7v3:sp ' 1 [7, 1] 30 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x7v5 ' 'x7v5:am ' 'x7v5:sp ' 1 [7, 2] 31 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x7v8 ' 'x7v8:am ' 'x7v8:sp ' 1 [7, 3] 32 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  'x7v14' 'x7v14:am' 'x7v14:sp' 1 [7, 4] 33 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x7v16' 'x7v16:am' 'x7v16:sp' 1 [7, 5] 34 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
 ... 
  'x8v3 ' 'x8v3:am ' 'x8v3:sp ' 1 [8, 1] 35 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x8v5 ' 'x8v5:am ' 'x8v5:sp ' 1 [8, 2] 36 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x8v8 ' 'x8v8:am ' 'x8v8:sp ' 1 [8, 3] 37 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_S 1/VCMGain_S; ...
  % often disabled
  'x8v14' 'x8v14:am' 'x8v14:sp' 1 [8, 4] 38 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
  'x8v16' 'x8v16:am' 'x8v16:sp' 1 [8, 5] 39 [-VCMRange +VCMRange] VCMTol RMVKICK VCMGain_L 1/VCMGain_L; ...
};

for ii=1:size(vcor, 1)
  AO.VCM.CommonNames(ii, :)               = vcor{ii, 1};            
  AO.VCM.Monitor.ChannelNames(ii, :)      = vcor{ii, 2};
  AO.VCM.Setpoint.ChannelNames(ii, :)     = vcor{ii, 3};     
  AO.VCM.Status(ii, 1)                    = vcor{ii, 4};

  AO.VCM.DeviceList(ii, :)                = vcor{ii, 5};
  AO.VCM.ElementList(ii, 1)               = vcor{ii, 6};;
  AO.VCM.Setpoint.Range(ii, :)            = vcor{ii, 7};
  AO.VCM.Setpoint.Tolerance(ii, 1)        = vcor{ii, 8};
  AO.VCM.Setpoint.DeltaRespMat(ii, 1)     = vcor{ii, 9};

  AO.VCM.Monitor.HW2PhysicsParams(ii, 1)  = vcor{ii, 10};          
  AO.VCM.Monitor.Physics2HWParams(ii, 1)  = vcor{ii, 11};
  AO.VCM.Setpoint.HW2PhysicsParams(ii, 1) = vcor{ii, 10};          
  AO.VCM.Setpoint.Physics2HWParams(ii, 1) = vcor{ii, 11};
end

AO.HCM.Status=AO.HCM.Status(:); AO.VCM.Status=AO.VCM.Status(:);

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList);
%AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList);


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
AO.BEND.Monitor.HWUnits        = 'A';           
AO.BEND.Monitor.PhysicsUnits   = 'rad';
%AO.BEND.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.BEND.Monitor.Physics2HWFcn  = @k2amp;

AO.BEND.Setpoint.Mode          = Mode;
AO.BEND.Setpoint.DataType      = 'Scalar';
AO.BEND.Setpoint.Units         = 'Hardware';
AO.BEND.Setpoint.HWUnits       = 'A';           
AO.BEND.Setpoint.PhysicsUnits  = 'rad';
%AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.BEND.Setpoint.Physics2HWFcn = @k2amp;

bendrange = 1470;

BENDGain = 2.372e-4;  %  rad/A
AO.BEND.Monitor.HW2PhysicsParams  = BENDGain;          
AO.BEND.Monitor.Physics2HWParams  = 1.0/BENDGain;
AO.BEND.Setpoint.HW2PhysicsParams = BENDGain;          
AO.BEND.Setpoint.Physics2HWParams = 1.0/BENDGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
bend={
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [1, 1]  1 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [1, 2]  2 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [2, 1]  3 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [2, 2]  4 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [3, 1]  5 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [3, 2]  6 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [4, 1]  7 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [4, 2]  8 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [5, 1]  9 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [5, 2] 10 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [6, 1] 11 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [6, 2] 12 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [7, 1] 13 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [7, 2] 14 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [8, 1] 15 NaN [0, bendrange] 1.0 0.04; ...
  'xdip' 'xdip:CurrSetptDes' 'xdip:am' 'xdip:sp' 1 [8, 2] 16 NaN [0, bendrange] 1.0 0.04; ...
};

for ii=1:size(bend, 1)
  AO.BEND.CommonNames(ii, :)           = bend{ii, 1};            
  AO.BEND.Monitor.ChannelNames(ii, :)  = bend{ii, 3};
  AO.BEND.Setpoint.ChannelNames(ii, :) = bend{ii, 4};     
  AO.BEND.Status(ii, 1)                = bend{ii, 5};
  AO.BEND.DeviceList(ii, :)            = bend{ii, 6};
  AO.BEND.ElementList(ii, 1)           = bend{ii, 7};

  AO.BEND.Setpoint.Range(ii, :)        = bend{ii, 9};
  AO.BEND.Setpoint.Tolerance(ii, 1)    = bend{ii, 10};
%  AO.BEND.Setpoint.DeltaRespMat(ii, 1) = bend{ii, 11};
end


%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.BEND.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.BEND.FamilyName, 'Setpoint', AO.BEND.Setpoint.DeltaRespMat, AO.BEND.DeviceList);


%===============
%Quadrupole data
%===============

% *** QA ***
AO.QA.FamilyName = 'QA';
AO.QA.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.QA.Monitor.Mode           = Mode;
AO.QA.Monitor.DataType       = 'Scalar';
AO.QA.Monitor.Units          = 'Hardware';
AO.QA.Monitor.HWUnits        = 'A';           
AO.QA.Monitor.PhysicsUnits   = 'm^-2';
%AO.QA.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QA.Monitor.Physics2HWFcn  = @k2amp;

AO.QA.Setpoint.Mode          = Mode;
AO.QA.Setpoint.DataType      = 'Scalar';
AO.QA.Setpoint.Units         = 'Hardware';
AO.QA.Setpoint.HWUnits       = 'A';           
AO.QA.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QA.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QA.Setpoint.Physics2HWFcn = @k2amp;

qarange = 300;

%QAGain = -6.36e-3;  %  m^-2/A
QAGain = -5.88e-3;  %  m^-2/A
AO.QA.Monitor.HW2PhysicsParams  = QAGain;          
AO.QA.Monitor.Physics2HWParams  = 1.0/QAGain;
AO.QA.Setpoint.HW2PhysicsParams = QAGain;          
AO.QA.Setpoint.Physics2HWParams = 1.0/QAGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
qa={
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [1, 1]  1 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [1, 2]  2 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [2, 1]  3 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [2, 2]  4 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [3, 1]  5 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [3, 2]  6 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [4, 1]  7 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [4, 2]  8 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [5, 1]  9 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [5, 2] 10 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [6, 1] 11 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [6, 2] 12 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [7, 1] 13 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [7, 2] 14 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [8, 1] 15 NaN [0, qarange] 0.20 0.04; ...
  'xqa' 'xqa:CurrSetptDes' 'xqa:am' 'xqa:sp' 1 [8, 2] 16 NaN [0, qarange] 0.20 0.04; ...
};

for ii=1:size(qa, 1)
  AO.QA.CommonNames(ii, :)           = qa{ii, 1};            
  AO.QA.Monitor.ChannelNames(ii, :)  = qa{ii, 3};
  AO.QA.Setpoint.ChannelNames(ii, :) = qa{ii, 4};     
  AO.QA.Status(ii, 1)                = qa{ii, 5};
  AO.QA.DeviceList(ii, :)            = qa{ii, 6};
  AO.QA.ElementList(ii, 1)           = qa{ii, 7};

  AO.QA.Setpoint.Range(ii, :)        = qa{ii, 9};
  AO.QA.Setpoint.Tolerance(ii, 1)    = qa{ii, 10};
  AO.QA.Setpoint.DeltaRespMat(ii, 1) = qa{ii, 11};
end


%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.QA.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.QA.FamilyName, 'Setpoint', AO.QA.Setpoint.DeltaRespMat, AO.QA.DeviceList);


% *** QB ***
AO.QB.FamilyName = 'QB';
AO.QB.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.QB.Monitor.Mode           = Mode;
AO.QB.Monitor.DataType       = 'Scalar';
AO.QB.Monitor.Units          = 'Hardware';
AO.QB.Monitor.HWUnits        = 'A';           
AO.QB.Monitor.PhysicsUnits   = 'm^-2';
%AO.QB.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QB.Monitor.Physics2HWFcn  = @k2amp;

AO.QB.Setpoint.Mode          = Mode;
AO.QB.Setpoint.DataType      = 'Scalar';
AO.QB.Setpoint.Units         = 'Hardware';
AO.QB.Setpoint.HWUnits       = 'A';           
AO.QB.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QB.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QB.Setpoint.Physics2HWFcn = @k2amp;

qbrange = 300;

%QBGain = 6.36e-3;  %  m^-2/A
QBGain = 6.50e-3;  %  m^-2/A
AO.QB.Monitor.HW2PhysicsParams  = QBGain;          
AO.QB.Monitor.Physics2HWParams  = 1.0/QBGain;
AO.QB.Setpoint.HW2PhysicsParams = QBGain;          
AO.QB.Setpoint.Physics2HWParams = 1.0/QBGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
qb={
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [1, 1]  1 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [1, 2]  2 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [2, 1]  3 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [2, 2]  4 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [3, 1]  5 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [3, 2]  6 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [4, 1]  7 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [4, 2]  8 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [5, 1]  9 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [5, 2] 10 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [6, 1] 11 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [6, 2] 12 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [7, 1] 13 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [7, 2] 14 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [8, 1] 15 NaN [0, qbrange] 0.25 0.04; ...
  'xqb' 'xqb:CurrSetptDes' 'xqb:am' 'xqb:sp' 1 [8, 2] 16 NaN [0, qbrange] 0.25 0.04; ...
};

for ii=1:size(qb, 1)
  AO.QB.CommonNames(ii, :)           = qb{ii, 1};            
  AO.QB.Monitor.ChannelNames(ii, :)  = qb{ii, 3};
  AO.QB.Setpoint.ChannelNames(ii, :) = qb{ii, 4};     
  AO.QB.Status(ii, 1)                = qb{ii, 5};
  AO.QB.DeviceList(ii, :)            = qb{ii, 6};
  AO.QB.ElementList(ii, 1)           = qb{ii, 7};
 
  AO.QB.Setpoint.Range(ii, :)        = qb{ii, 9};
  AO.QB.Setpoint.Tolerance(ii, 1)    = qb{ii, 10};
  AO.QB.Setpoint.DeltaRespMat(ii, 1) = qb{ii, 11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.QB.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.QB.FamilyName, 'Setpoint', AO.QB.Setpoint.DeltaRespMat, AO.QB.DeviceList);


% *** QC ***
AO.QC.FamilyName = 'QC';
AO.QC.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.QC.Monitor.Mode           = Mode;
AO.QC.Monitor.DataType       = 'Scalar';
AO.QC.Monitor.Units          = 'Hardware';
AO.QC.Monitor.HWUnits        = 'A';           
AO.QC.Monitor.PhysicsUnits   = 'm^-2';
%AO.QC.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QC.Monitor.Physics2HWFcn  = @k2amp;

AO.QC.Setpoint.Mode          = Mode;
AO.QC.Setpoint.DataType      = 'Scalar';
AO.QC.Setpoint.Units         = 'Hardware';
AO.QC.Setpoint.HWUnits       = 'A';           
AO.QC.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QC.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QC.Setpoint.Physics2HWFcn = @k2amp;

qcrange = 500;

%QCGain = -4.03e-3;  %  m^-2/A
QCGain = -3.54e-3;  %  m^-2/A
AO.QC.Monitor.HW2PhysicsParams  = QCGain;          
AO.QC.Monitor.Physics2HWParams  = 1.0/QCGain;
AO.QC.Setpoint.HW2PhysicsParams = QCGain;          
AO.QC.Setpoint.Physics2HWParams = 1.0/QCGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
qc={
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [1, 1]  1 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [1, 2]  2 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [2, 1]  3 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [2, 2]  4 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [3, 1]  5 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [3, 2]  6 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [4, 1]  7 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [4, 2]  8 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [5, 1]  9 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [5, 2] 10 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [6, 1] 11 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [6, 2] 12 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [7, 1] 13 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [7, 2] 14 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [8, 1] 15 NaN [0, qcrange] 0.25 0.06; ...
  'xqc' 'xqc:CurrSetptDes' 'xqc:am' 'xqc:sp' 1 [8, 2] 16 NaN [0, qcrange] 0.25 0.06; ...
};

for ii=1:size(qc, 1)
  AO.QC.CommonNames(ii, :)           = qc{ii, 1};            
  AO.QC.Monitor.ChannelNames(ii, :)  = qc{ii, 3};
  AO.QC.Setpoint.ChannelNames(ii, :) = qc{ii, 4};     
  AO.QC.Status(ii, 1)                = qc{ii, 5};
  AO.QC.DeviceList(ii, :)            = qc{ii, 6};
  AO.QC.ElementList(ii, 1)           = qc{ii, 7};
 
  AO.QC.Setpoint.Range(ii, :)        = qc{ii, 9};
  AO.QC.Setpoint.Tolerance(ii, 1)    = qc{ii, 10};
  AO.QC.Setpoint.DeltaRespMat(ii, 1) = qc{ii, 11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.QC.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.QC.FamilyName, 'Setpoint', AO.QC.Setpoint.DeltaRespMat, AO.QC.DeviceList);


% *** QD ***
AO.QD.FamilyName = 'QD';
AO.QD.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet';};

AO.QD.Monitor.Mode           = Mode;
AO.QD.Monitor.DataType       = 'Scalar';
AO.QD.Monitor.Units          = 'Hardware';
AO.QD.Monitor.HWUnits        = 'A';           
AO.QD.Monitor.PhysicsUnits   = 'm^-2';
%AO.QD.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QD.Monitor.Physics2HWFcn  = @k2amp;

AO.QD.Setpoint.Mode          = Mode;
AO.QD.Setpoint.DataType      = 'Scalar';
AO.QD.Setpoint.Units         = 'Hardware';
AO.QD.Setpoint.HWUnits       = 'A';           
AO.QD.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QD.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QD.Setpoint.Physics2HWFcn = @k2amp;

qdrange=300;

%QDGain = 6.36e-3;  %  m^-2/A
QDGain = 6.11e-3;  %  m^-2/A
AO.QD.Monitor.HW2PhysicsParams  = QDGain;          
AO.QD.Monitor.Physics2HWParams  = 1.0/QDGain;
AO.QD.Setpoint.HW2PhysicsParams = QDGain;          
AO.QD.Setpoint.Physics2HWParams = 1.0/QDGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
qd={
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [1, 1] 1 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [2, 1] 2 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [3, 1] 3 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [4, 1] 4 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [5, 1] 5 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [6, 1] 6 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [7, 1] 7 NaN [0, qdrange] 0.500 0.05; ...
  'xqd' 'xqd:CurrSetptDes' 'xqd:am' 'xqd:sp' 1 [8, 1] 8 NaN [0, qdrange] 0.500 0.05; ...
};

for ii=1:size(qd, 1)
  AO.QD.CommonNames(ii, :)           = qd{ii, 1};            
  AO.QD.Monitor.ChannelNames(ii, :)  = qd{ii, 3};
  AO.QD.Setpoint.ChannelNames(ii, :) = qd{ii, 4};     
  AO.QD.Status(ii, 1)                = qd{ii, 5};
  AO.QD.DeviceList(ii, :)            = qd{ii, 6};
  AO.QD.ElementList(ii, 1)           = qd{ii, 7};

  AO.QD.Setpoint.Range(ii, :)        = qd{ii, 9};
  AO.QD.Setpoint.Tolerance(ii, 1)    = qd{ii, 10};
  AO.QD.Setpoint.DeltaRespMat(ii, 1) = qd{ii, 11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.QD.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.QD.FamilyName, 'Setpoint', AO.QD.Setpoint.DeltaRespMat, AO.QD.DeviceList);


% *** QD Trims ***
AO.QDT.FamilyName = 'QDT';
AO.QDT.MemberOf = {'MachineConfig'; 'PlotFamily'; 'TRIMQUAD'; 'Magnet';};

AO.QDT.Monitor.Mode           = Mode;
AO.QDT.Monitor.DataType       = 'Scalar';
AO.QDT.Monitor.Units          = 'Hardware';
AO.QDT.Monitor.HWUnits        = 'A';           
AO.QDT.Monitor.PhysicsUnits   = 'm^-2';
%AO.QDT.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QDT.Monitor.Physics2HWFcn  = @k2amp;

AO.QDT.Setpoint.Mode          = Mode;
AO.QDT.Setpoint.DataType      = 'Scalar';
AO.QDT.Setpoint.Units         = 'Hardware';
AO.QDT.Setpoint.HWUnits       = 'A';           
AO.QDT.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QDT.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QDT.Setpoint.Physics2HWFcn = @k2amp;

AO.QDT.Setpoint.RampRate = 1;  % amps/sec


qdtrange = 11.5;

QDTGain = -2.26e-3;  %  m^-1/A
AO.QDT.Monitor.HW2PhysicsParams  = QDTGain;          
AO.QDT.Monitor.Physics2HWParams  = 1.0/QDTGain;
AO.QDT.Setpoint.HW2PhysicsParams = QDTGain;          
AO.QDT.Setpoint.Physics2HWParams = 1.0/QDTGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
qdt={
  'xqdtrim1' 'xqdtrim1:CurrSetptDes' 'xqdtrim1:am' 'xqdtrim1:sp' 1 [1, 1] 1 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim2' 'xqdtrim2:CurrSetptDes' 'xqdtrim2:am' 'xqdtrim2:sp' 1 [2, 1] 2 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim3' 'xqdtrim3:CurrSetptDes' 'xqdtrim3:am' 'xqdtrim3:sp' 1 [3, 1] 3 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim4' 'xqdtrim4:CurrSetptDes' 'xqdtrim4:am' 'xqdtrim4:sp' 1 [4, 1] 4 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim5' 'xqdtrim5:CurrSetptDes' 'xqdtrim5:am' 'xqdtrim5:sp' 1 [5, 1] 5 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim6' 'xqdtrim6:CurrSetptDes' 'xqdtrim6:am' 'xqdtrim6:sp' 1 [6, 1] 6 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim7' 'xqdtrim7:CurrSetptDes' 'xqdtrim7:am' 'xqdtrim7:sp' 1 [7, 1] 7 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
  'xqdtrim8' 'xqdtrim8:CurrSetptDes' 'xqdtrim8:am' 'xqdtrim8:sp' 1 [8, 1] 8 NaN [-qdtrange, qdtrange] 0.05 0.002; ...
};

for ii=1:size(qdt, 1)
  AO.QDT.CommonNames(ii, :)           = qdt{ii, 1};            
  AO.QDT.Monitor.ChannelNames(ii, :)  = qdt{ii, 3};
  AO.QDT.Setpoint.ChannelNames(ii, :) = qdt{ii, 4};     
  AO.QDT.Status(ii, 1)                = qdt{ii, 5};
  AO.QDT.DeviceList(ii, :)            = qdt{ii, 6};
  AO.QDT.ElementList(ii, 1)           = qdt{ii, 7};

  AO.QDT.Setpoint.Range(ii, :)        = qdt{ii, 9};
  AO.QDT.Setpoint.Tolerance(ii, 1)    = qdt{ii, 10};
  AO.QDT.Setpoint.DeltaRespMat(ii, 1) = qdt{ii, 11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.QDT.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.QDT.FamilyName, 'Setpoint', AO.QDT.Setpoint.DeltaRespMat, AO.QDT.DeviceList);


% *** SQ ***
AO.SQ.FamilyName = 'SQ';
AO.SQ.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SKEWQUAD'; 'Magnet';};

AO.SQ.Monitor.Mode           = Mode;
AO.SQ.Monitor.DataType       = 'Scalar';
AO.SQ.Monitor.Units          = 'Hardware';
AO.SQ.Monitor.HWUnits        = 'A';           
AO.SQ.Monitor.PhysicsUnits   = 'm^-2';
%AO.SQ.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SQ.Monitor.Physics2HWFcn  = @k2amp;

AO.SQ.Setpoint.Mode          = Mode;
AO.SQ.Setpoint.DataType      = 'Scalar';
AO.SQ.Setpoint.Units         = 'Hardware';
AO.SQ.Setpoint.HWUnits       = 'A';           
AO.SQ.Setpoint.PhysicsUnits  = 'm^-2';
%AO.SQ.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SQ.Setpoint.Physics2HWFcn = @k2amp;

sqrange=10.0;

SQGain = 1.2e-3;  %  m^-2/A
AO.SQ.Monitor.HW2PhysicsParams  = SQGain;          
AO.SQ.Monitor.Physics2HWParams  = 1.0/SQGain;
AO.SQ.Setpoint.HW2PhysicsParams = SQGain;          
AO.SQ.Setpoint.Physics2HWParams = 1.0/SQGain;

%common  desired           monitor  setpoint  stat devlist elem scalefactor range tol respkick
sq={
  'x1sq16' 'x1sq16:CurrSetptDes' 'x1sq16:am' 'x1sq16:sp' 1 [1, 1]  1 NaN [0, qdrange] 0.500 0.05; ...
  'x2sq3 ' 'x2sq3:CurrSetptDes ' 'x2sq3:am ' 'x2sq3:sp ' 1 [2, 1]  2 NaN [0, qdrange] 0.500 0.05; ...
  'x2sq8 ' 'x2sq8:CurrSetptDes ' 'x2sq8:am ' 'x2sq8:sp ' 1 [2, 2]  3 NaN [0, qdrange] 0.500 0.05; ...
  'x2sq16' 'x2sq16:CurrSetptDes' 'x2sq16:am' 'x2sq16:sp' 1 [2, 3]  4 NaN [0, qdrange] 0.500 0.05; ...
  'x3sq8 ' 'x3sq8:CurrSetptDes ' 'x3sq8:am ' 'x3sq8:sp ' 1 [3, 1]  5 NaN [0, qdrange] 0.500 0.05; ...
  'x3sq16' 'x3sq16:CurrSetptDes' 'x3sq16:am' 'x3sq16:sp' 1 [3, 2]  6 NaN [0, qdrange] 0.500 0.05; ...
  'x4sq3 ' 'x4sq3:CurrSetptDes ' 'x4sq3:am ' 'x4sq3:sp ' 1 [4, 1]  7 NaN [0, qdrange] 0.500 0.05; ...
  'x4sq16' 'x4sq16:CurrSetptDes' 'x4sq16:am' 'x4sq16:sp' 1 [4, 2]  8 NaN [0, qdrange] 0.500 0.05; ...
  'x5sq3 ' 'x5sq3:CurrSetptDes ' 'x5sq3:am ' 'x5sq3:sp ' 1 [5, 1]  9 NaN [0, qdrange] 0.500 0.05; ...
  'x5sq16' 'x5sq16:CurrSetptDes' 'x5sq16:am' 'x5sq16:sp' 1 [5, 2] 10 NaN [0, qdrange] 0.500 0.05; ...
  'x6sq3 ' 'x6sq3:CurrSetptDes ' 'x6sq3:am ' 'x6sq3:sp ' 1 [6, 1] 11 NaN [0, qdrange] 0.500 0.05; ...
  'x6sq16' 'x6sq16:CurrSetptDes' 'x6sq16:am' 'x6sq16:sp' 1 [6, 2] 12 NaN [0, qdrange] 0.500 0.05; ...
  'x7sq8 ' 'x7sq8:CurrSetptDes ' 'x7sq8:am ' 'x7sq8:sp ' 1 [7, 1] 13 NaN [0, qdrange] 0.500 0.05; ...
  'x7sq16' 'x7sq16:CurrSetptDes' 'x7sq16:am' 'x7sq16:sp' 1 [7, 2] 14 NaN [0, qdrange] 0.500 0.05; ...
  'x8sq3 ' 'x8sq3:CurrSetptDes ' 'x8sq3:am ' 'x8sq3:sp ' 1 [8, 1] 15 NaN [0, qdrange] 0.500 0.05; ...
  'x8sq8 ' 'x8sq8:CurrSetptDes ' 'x8sq8:am ' 'x8sq8:sp ' 1 [8, 2] 16 NaN [0, qdrange] 0.500 0.05; ...
  'x8sq16' 'x8sq16:CurrSetptDes' 'x8sq16:am' 'x8sq16:sp' 1 [8, 3] 17 NaN [0, qdrange] 0.500 0.05; ...
};

for ii=1:size(sq, 1)
  AO.SQ.CommonNames(ii, :)           = sq{ii, 1};            
  AO.SQ.Monitor.ChannelNames(ii, :)  = sq{ii, 3};
  AO.SQ.Setpoint.ChannelNames(ii, :) = sq{ii, 4};     
  AO.SQ.Status(ii, 1)                = sq{ii, 5};
  AO.SQ.DeviceList(ii, :)            = sq{ii, 6};
  AO.SQ.ElementList(ii, 1)           = sq{ii, 7};

  AO.SQ.Setpoint.Range(ii, :)        = sq{ii, 9};
  AO.SQ.Setpoint.Tolerance(ii, 1)    = sq{ii, 10};
  AO.SQ.Setpoint.DeltaRespMat(ii, 1) = sq{ii, 11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.SQ.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.SQ.FamilyName, 'Setpoint', AO.SQ.Setpoint.DeltaRespMat, AO.SQ.DeviceList);


%===============
%Sextupole data
%===============

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

sfrange = 500;

SFGain = 3.33e-2;  %  m^-3/A
AO.SF.Monitor.HW2PhysicsParams  = SFGain;          
AO.SF.Monitor.Physics2HWParams  = 1.0/SFGain;
AO.SF.Setpoint.HW2PhysicsParams = SFGain;          
AO.SF.Setpoint.Physics2HWParams = 1.0/SFGain;

% common      desired         monitor  setpoint stat devlist elem scalefactor range tol respkick
sf={
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [1, 1]  1 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [1, 2]  2 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [2, 1]  3 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [2, 2]  4 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [3, 1]  5 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [3, 2]  6 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [4, 1]  7 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [4, 2]  8 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [5, 1]  9 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [5, 2] 10 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [6, 1] 11 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [6, 2] 12 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [7, 1] 13 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [7, 2] 14 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [8, 1] 15 NaN [0, sfrange] 1.0 2.5; ...
  'xsxf' 'xsxf:CurrSetptDes' 'xsxf:am' 'xsxf:sp' 1 [8, 2] 16 NaN [0, sfrange] 1.0 2.5; ...
};

for ii=1:size(sf,1)
  AO.SF.CommonNames(ii,:)           = sf{ii,1};            
  AO.SF.Monitor.ChannelNames(ii,:)  = sf{ii,3};
  AO.SF.Setpoint.ChannelNames(ii,:) = sf{ii,4};     
  AO.SF.Status(ii,1)                = sf{ii,5};
  AO.SF.DeviceList(ii,:)            = sf{ii,6};
  AO.SF.ElementList(ii,1)           = sf{ii,7};

  AO.SF.Setpoint.Range(ii,:)        = sf{ii,9};
  AO.SF.Setpoint.Tolerance(ii,1)    = sf{ii,10};
  AO.SF.Setpoint.DeltaRespMat(ii,1) = sf{ii,11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.SF.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.SF.FamilyName, 'Setpoint', AO.SF.Setpoint.DeltaRespMat, AO.SF.DeviceList);


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

sdrange = 1000;

SDGain = -3.33e-2;  %  m^-3/A
AO.SD.Monitor.HW2PhysicsParams  = SDGain;          
AO.SD.Monitor.Physics2HWParams  = 1.0/SDGain;
AO.SD.Setpoint.HW2PhysicsParams = SDGain;          
AO.SD.Setpoint.Physics2HWParams = 1.0/SDGain;

% common      desired         monitor  setpoint stat devlist elem scalefactor range tol respkick
sd={
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [1, 1]  1 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [1, 2]  2 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [2, 1]  3 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [2, 2]  4 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [3, 1]  5 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [3, 2]  6 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [4, 1]  7 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [4, 2]  8 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [5, 1]  9 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [5, 2] 10 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [6, 1] 11 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [6, 2] 12 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [7, 1] 13 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [7, 2] 14 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [8, 1] 15 NaN [0, sdrange] 1.0 2.5; ...
  'xsxd' 'xsxd:CurrSetptDes' 'xsxd:am' 'xsxd:sp' 1 [8, 2] 16 NaN [0, sdrange] 1.0 2.5; ...
};

for ii=1:size(sd,1)
  AO.SD.CommonNames(ii,:)           = sd{ii,1};            
  AO.SD.Monitor.ChannelNames(ii,:)  = sd{ii,3};
  AO.SD.Setpoint.ChannelNames(ii,:) = sd{ii,4};     
  AO.SD.Status(ii,1)                = sd{ii,5};
  AO.SD.DeviceList(ii,:)            = sd{ii,6};
  AO.SD.ElementList(ii,1)           = sd{ii,7};
 
  AO.SD.Setpoint.Range(ii,:)        = sd{ii,9};
  AO.SD.Setpoint.Tolerance(ii,1)    = sd{ii,10};
  AO.SD.Setpoint.DeltaRespMat(ii,1) = sd{ii,11};
end

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
%AO.SD.Setpoint.DeltaRespMat = ...
%  physics2hw(AO.SD.FamilyName, 'Setpoint', AO.SD.Setpoint.DeltaRespMat, AO.SD.DeviceList);


%============
%RF System
%============
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf = {'MachineConfig'; 'PlotFamily';  'RF'; 'RFSystem'};
AO.RF.Status = 1;
AO.RF.CommonNames = 'RF';
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = [1];

%Frequency Readback
AO.RF.Monitor.Mode                = 'Special';
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.SpecialFunctionGet  = 'getrfxray';
%AO.RF.Monitor.ChannelNames        = 'xfreqhi:AM';     
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+6;
AO.RF.Monitor.Physics2HWParams    = 1e-6;
AO.RF.Monitor.HWUnits             = 'MHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';

%Frequency Setpoint
AO.RF.Setpoint.Mode               = 'Special';
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.SpecialFunctionSet = 'setrfxray';
AO.RF.Setpoint.SpecialFunctionGet = 'getrfxray';
%AO.RF.Setpoint.ChannelNames       = 'xfreqhi:SP';     
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.Range              = [0 2000];
AO.RF.Setpoint.Tolerance          = 100.0;


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
%AO.TUNE.Monitor.ChannelNames           = ['xtuneh:am'; 'xtunev:am'; '         '];
AO.TUNE.Monitor.SpecialFunctionGet     = 'gettune_xray';
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
AO.DCCT.ElementList              = [1];
AO.DCCT.Status                   = [1];
AO.DCCT.Position                 = 0;

AO.DCCT.Monitor.Mode             = Mode;
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'xrcurr:am';    
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'mA';           
AO.DCCT.Monitor.PhysicsUnits     = 'mA';
AO.DCCT.Monitor.HW2PhysicsParams = 1;          
AO.DCCT.Monitor.Physics2HWParams = 1;


setao(AO);


setoperationalmode(OperationalMode);


