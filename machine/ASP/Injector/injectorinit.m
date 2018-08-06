function asbosterinit(OperationalMode)
% aspinit(OperationalMode)
%
% Initialize parameters for AS injector (LTB, Booster, & BTS) control in MATLAB
% NOTE: 'plotfamily' is only a MemberOf the booster
%
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% CommonNames           Shortcut name for each element (optional)
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet starting position
%
% MONITOR FIELDS
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
% SETPOINT FIELDS
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
%    BPMx BPMy        - beam position monitors
%    HCM VCM          - corrector magnets wound into sextupoles
%    BEND BD            - gradient dipoles
%    QF QD            - quadrupole magnets
%    SF SD            - sextupole magnets
%    KICK             - injection kickers
%    RF               - 1 cavity 5 cells
%    DCCT
%    Septum (Not in model yet)
%
%    four cells.
%    Normal cell: d0 d1c bpm d1cc hcor dqxd qf dqxd d2 d2 dd bd d2 qd dd
%    d2c bpm d2cc BEND dqxd1 sexh dqxd2 bd dd1 hcor d21 BEND d22 vcor dd2c bpm
%    d2cc bd dd d2 d2 BEND d23 hcor d23c bpm d2cc bd dqxd3 dqxd3 sexv dqxd4 
% dqxd4 BEND dqxd3 dqxd3 sexv dqxd4c dqxd4c bpm d2cc bd d23 hcor d23 BEND d22 
% vcor dd2 bd d23 hcor d23c bpm d2cc BEND d2 d2 ddc bpm d2cc bd dqxd5 sexh 
% dqxd6 BEND d2 dd qd dd ddc bpm d2cc bd dd d2 d2 dqxd qf dqxd hcor d27 vcor 
% d11 d0

% === Change Log ===
% Mark Boland 2006-02-09
% Mark Boland 2006-07-07 Added rest of LTB PVs
% Mark Boland 2006-08-14 Added scale values for BTS from Danfysik
% spreadsheet.
%
% === Still to do ===
% -check calibrations of magnets so we can use model with machine
% -check the bends that bend to the left in stead of to the right
% -get the LTB to use the right energy of 100 MeV
% -check the direction of the bends, some give positive kicks in the
% transfer lines

% Default operational mode
if nargin < 1
    OperationalMode = 1;
end


%=============================================
% START DEFINITION OF ACCELERATOR OBJECTS
%=============================================
fprintf('   Defining the Accelerator Objects. Objects being defined:\n')


% Clear previous AcceleratorObjects
setao([]);   


Mode = 'Online';  % This gets reset in setoperationalmode
% Mode = 'simulator';  % This gets reset in setoperationalmode


%--------------- START OF LTB ------------
% With LTB elements there is only one data point. Therefore assume a single
% scaling factor between physics and hardware units.

% *** LTB COR ***
%
% Horizontal Correctors
%
% For calibration just using the scale factor now, not magnetcoeffcients.m
% - markjb 7/7/2006
AO.LTB_HCOR.FamilyName               = 'LTB_HCOR'; dispobject(AO,AO.LTB_HCOR.FamilyName);
AO.LTB_HCOR.MemberOf                 = {'MachineConfig'; 'COR'; 'Magnet'; 'LTB';};

AO.LTB_HCOR.Monitor.Mode             = Mode;
AO.LTB_HCOR.Monitor.DataType         = 'Scalar';
AO.LTB_HCOR.Monitor.Units            = 'Hardware';
AO.LTB_HCOR.Monitor.HWUnits          = 'ampere';           
AO.LTB_HCOR.Monitor.PhysicsUnits     = 'radian';

AO.LTB_HCOR.Setpoint.Mode            = Mode;
AO.LTB_HCOR.Setpoint.DataType        = 'Scalar';
AO.LTB_HCOR.Setpoint.Units           = 'Hardware';
AO.LTB_HCOR.Setpoint.HWUnits         = 'ampere';           
AO.LTB_HCOR.Setpoint.PhysicsUnits    = 'radian';

%common                    monitor              setpoint           stat devlist elem hw2physics range    tol   respkick
LTB_HCOR={
'HCOR1'     'PS-OCH-A-1-1:CURRENT_MONITOR'  'PS-OCH-A-1-1:CURRENT_SP' 1  [1,1]  1  1   [0,15]  0.05 0.05;...
'HCOR2'     'PS-OCH-A-1-2:CURRENT_MONITOR'  'PS-OCH-A-1-2:CURRENT_SP' 1  [1,2]  2  1   [0,15]  0.05 0.05;...
};

for ii=1:size(LTB_HCOR,1)
name=LTB_HCOR{ii,1};     AO.LTB_HCOR.CommonNames(ii,:)           = name;            
name=LTB_HCOR{ii,3};     AO.LTB_HCOR.Setpoint.ChannelNames(ii,:) = name;     
name=LTB_HCOR{ii,2};     AO.LTB_HCOR.Monitor.ChannelNames(ii,:)  = name;
val =LTB_HCOR{ii,4};     AO.LTB_HCOR.Status(ii,1)                = val;

val =LTB_HCOR{ii,5};     AO.LTB_HCOR.DeviceList(ii,:)            = val;
val =LTB_HCOR{ii,6};     AO.LTB_HCOR.ElementList(ii,1)           = val;
val =LTB_HCOR{ii,7};     AO.LTB_HCOR.Monitor.HW2PhysicsParams(ii,:) = val;
                         AO.LTB_HCOR.Monitor.Physics2HWParams(ii,:) = 1/val;
                         AO.LTB_HCOR.Setpoint.HW2PhysicsParams(ii,:)= val;
                         AO.LTB_HCOR.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =LTB_HCOR{ii,8};     AO.LTB_HCOR.Setpoint.Range(ii,:)        = val;
val =LTB_HCOR{ii,9};     AO.LTB_HCOR.Setpoint.Tolerance(ii,1)    = val;
val =LTB_HCOR{ii,10};    AO.LTB_HCOR.Setpoint.DeltaRespMat(ii,1) = val;
end


% Vertical Correctors
AO.LTB_VCOR.FamilyName               = 'LTB_VCOR'; dispobject(AO,AO.LTB_VCOR.FamilyName);
AO.LTB_VCOR.MemberOf                 = {'MachineConfig'; 'COR'; 'Magnet'; 'LTB';};

AO.LTB_VCOR.Monitor.Mode             = Mode;
AO.LTB_VCOR.Monitor.DataType         = 'Scalar';
AO.LTB_VCOR.Monitor.Units            = 'Hardware';
AO.LTB_VCOR.Monitor.HWUnits          = 'ampere';           
AO.LTB_VCOR.Monitor.PhysicsUnits     = 'radian';


AO.LTB_VCOR.Setpoint.Mode            = Mode;
AO.LTB_VCOR.Setpoint.DataType        = 'Scalar';
AO.LTB_VCOR.Setpoint.Units           = 'Hardware';
AO.LTB_VCOR.Setpoint.HWUnits         = 'ampere';           
AO.LTB_VCOR.Setpoint.PhysicsUnits    = 'radian';

%common                    monitor              setpoint           stat devlist elem hw2physics range    tol   respkick
LTB_VCOR={
'VCOR1'     'PS-OCV-A-1-1:CURRENT_MONITOR'  'PS-OCV-A-1-1:CURRENT_SP' 1  [1,1]  1  1   [0,15]  0.05 0.05;...   
'VCOR2'     'PS-OCV-A-1-2:CURRENT_MONITOR'  'PS-OCV-A-1-2:CURRENT_SP' 1  [1,2]  2  1   [0,15]  0.05 0.05;...   
'VCOR3'     'PS-OCV-A-1-3:CURRENT_MONITOR'  'PS-OCV-A-1-3:CURRENT_SP' 1  [1,3]  3  1   [0,15]  0.05 0.05;...   
'VCOR4'     'PS-OCV-A-1-4:CURRENT_MONITOR'  'PS-OCV-A-1-4:CURRENT_SP' 1  [1,4]  4  1   [0,15]  0.05 0.05;...   
};

for ii=1:size(LTB_VCOR,1)
name=LTB_VCOR{ii,1};     AO.LTB_VCOR.CommonNames(ii,:)           = name;            
name=LTB_VCOR{ii,3};     AO.LTB_VCOR.Setpoint.ChannelNames(ii,:) = name;     
name=LTB_VCOR{ii,2};     AO.LTB_VCOR.Monitor.ChannelNames(ii,:)  = name;
val =LTB_VCOR{ii,4};     AO.LTB_VCOR.Status(ii,1)                = val;

val =LTB_VCOR{ii,5};     AO.LTB_VCOR.DeviceList(ii,:)            = val;
val =LTB_VCOR{ii,6};     AO.LTB_VCOR.ElementList(ii,1)           = val;
val =LTB_VCOR{ii,7};     AO.LTB_HCOR.Monitor.HW2PhysicsParams(ii,:) = val;
                         AO.LTB_VCOR.Monitor.Physics2HWParams(ii,:) = 1/val;
                         AO.LTB_VCOR.Setpoint.HW2PhysicsParams(ii,:)= val;
                         AO.LTB_VCOR.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =LTB_VCOR{ii,8};     AO.LTB_VCOR.Setpoint.Range(ii,:)        = val;
val =LTB_VCOR{ii,9};     AO.LTB_VCOR.Setpoint.Tolerance(ii,1)    = val;
val =LTB_VCOR{ii,10};    AO.LTB_VCOR.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end LTB COR ***


% *** LTB BENDS ***
AO.LTB_BEND.FamilyName                 = 'LTB_BEND'; dispobject(AO,AO.LTB_BEND.FamilyName);
AO.LTB_BEND.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet'; 'LTB';};

AO.LTB_BEND.Monitor.Mode               = Mode;
AO.LTB_BEND.Monitor.DataType           = 'Scalar';
AO.LTB_BEND.Monitor.Units              = 'Hardware';
AO.LTB_BEND.Monitor.HWUnits            = 'ampere';           
AO.LTB_BEND.Monitor.PhysicsUnits       = 'energy';

AO.LTB_BEND.Setpoint.Mode              = Mode;
AO.LTB_BEND.Setpoint.DataType          = 'Scalar';
AO.LTB_BEND.Setpoint.Units             = 'Hardware';
AO.LTB_BEND.Setpoint.HWUnits           = 'ampere';           
AO.LTB_BEND.Setpoint.PhysicsUnits      = 'energy';
%
% hw2physics are from Danfysik's magnet acceptance documentation spreadsheet
%common monitor                         setpoint                stat devlist    elem   hw2physics    range     tol    respkick
LTB_BEND={
'B1  '	'PS-B-A-1-1:CURRENT_MONITOR'	'PS-B-A-1-1:CURRENT_SP'	1	 [1,1]  	1	   -0.00304255   [0, 500]  0.05   0.05	; ...
'B2  '	'PS-B-A-1-2:CURRENT_MONITOR'	'PS-B-A-1-2:CURRENT_SP'	1	 [1,2]	    2      -0.00304868   [0, 500]  0.05   0.05	; ...
'B3  '	'PS-B-B-1:CURRENT_MONITOR  '	'PS-B-B-1:CURRENT_SP  '	1	 [1,3]  	3       0.00079462   [0, 500]  0.05   0.05	; ...
}; 

for ii=1:size(LTB_BEND,1)
name=LTB_BEND{ii,1};      AO.LTB_BEND.CommonNames(ii,:)           = name;            
name=LTB_BEND{ii,2};      AO.LTB_BEND.Monitor.ChannelNames(ii,:)  = name;
name=LTB_BEND{ii,3};      AO.LTB_BEND.Setpoint.ChannelNames(ii,:) = name;     
val =LTB_BEND{ii,4};      AO.LTB_BEND.Status(ii,1)                = val;
val =LTB_BEND{ii,5};      AO.LTB_BEND.DeviceList(ii,:)            = val;
val =LTB_BEND{ii,6};      AO.LTB_BEND.ElementList(ii,1)           = val;
val =LTB_BEND{ii,7};      AO.LTB_BEND.Monitor.HW2PhysicsParams(ii,:) = val;
                          AO.LTB_BEND.Monitor.Physics2HWParams(ii,:) = 1/val;
                          AO.LTB_BEND.Setpoint.HW2PhysicsParams(ii,:)= val;
                          AO.LTB_BEND.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =LTB_BEND{ii,8};      AO.LTB_BEND.Setpoint.Range(ii,:)        = val;
val =LTB_BEND{ii,9};      AO.LTB_BEND.Setpoint.Tolerance(ii,1)    = val;
val =LTB_BEND{ii,10};     AO.LTB_BEND.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end LTB BENDS ***

% *** LTB QUADS ***
% Quadrupoles
% QF & QD
% markjb - this may not be the best way physics wise, but it is following
% the control system for now.
% NB uses scale factor column to differentiate between QF and QD
AO.LTB_Q.FamilyName                 = 'LTB_Q'; dispobject(AO,AO.LTB_Q.FamilyName);
AO.LTB_Q.MemberOf                   = {'MachineConfig'; 'QUAD'; 'Magnet'; 'LTB';};

AO.LTB_Q.Monitor.Mode               = Mode;
AO.LTB_Q.Monitor.DataType           = 'Scalar';
AO.LTB_Q.Monitor.Units              = 'Hardware';
AO.LTB_Q.Monitor.HWUnits            = 'ampere';           
AO.LTB_Q.Monitor.PhysicsUnits       = 'meter^-2';

AO.LTB_Q.Setpoint.Mode              = Mode;
AO.LTB_Q.Setpoint.DataType          = 'Scalar';
AO.LTB_Q.Setpoint.Units             = 'Hardware';
AO.LTB_Q.Setpoint.HWUnits           = 'ampere';           
AO.LTB_Q.Setpoint.PhysicsUnits      = 'meter^-2';
%
% hw2physics are from Danfysik's magnet acceptance documentation spreadsheet
%common                    monitor              setpoint          stat devlist elem hw2physics        range    tol   respkick
LTB_Q={
'Q11 '      'PS-Q-1-1:CURRENT_MONITOR '     'PS-Q-1-1:CURRENT_SP '   1    [1,1]   1    1.349      [0,15]  0.05 0.05 ;...
'Q12 '      'PS-Q-1-2:CURRENT_MONITOR '     'PS-Q-1-2:CURRENT_SP '   1    [1,2]   2   -1.349      [0,15]  0.05 0.05 ;...
'Q13 '      'PS-Q-1-3:CURRENT_MONITOR '     'PS-Q-1-3:CURRENT_SP '   1    [1,3]   3   -1.349      [0,15]  0.05 0.05 ;...
'Q2  '      'PS-Q-1-4:CURRENT_MONITOR '     'PS-Q-1-4:CURRENT_SP '   1    [1,4]   4    1.349      [0,15]  0.05 0.05 ;...
'Q31 '      'PS-Q-1-5:CURRENT_MONITOR '     'PS-Q-1-5:CURRENT_SP '   1    [1,5]   5    1.349      [0,15]  0.05 0.05 ;...
'Q32 '      'PS-Q-1-6:CURRENT_MONITOR '     'PS-Q-1-6:CURRENT_SP '   1    [1,6]   6   -1.349      [0,15]  0.05 0.05 ;...
'Q33 '      'PS-Q-1-7:CURRENT_MONITOR '     'PS-Q-1-7:CURRENT_SP '   1    [1,7]   7   -1.349      [0,15]  0.05 0.05 ;...
'Q34 '      'PS-Q-1-8:CURRENT_MONITOR '     'PS-Q-1-8:CURRENT_SP '   1    [1,8]   8    1.349      [0,15]  0.05 0.05 ;...
'Q41 '      'PS-Q-1-9:CURRENT_MONITOR '     'PS-Q-1-9:CURRENT_SP '   1    [1,9]   9   -1.349      [0,15]  0.05 0.05 ;...
'Q42 '      'PS-Q-1-10:CURRENT_MONITOR'     'PS-Q-1-10:CURRENT_SP'   1    [1,10] 10    1.349      [0,15]  0.05 0.05 ;...
'Q43 '      'PS-Q-1-11:CURRENT_MONITOR'     'PS-Q-1-11:CURRENT_SP'   1    [1,11] 11   -1.349      [0,15]  0.05 0.05 ;...
};
for ii=1:size(LTB_Q,1)
name=LTB_Q{ii,1};      AO.LTB_Q.CommonNames(ii,:)           = name;            
name=LTB_Q{ii,2};      AO.LTB_Q.Monitor.ChannelNames(ii,:)  = name;
name=LTB_Q{ii,3};      AO.LTB_Q.Setpoint.ChannelNames(ii,:) = name;     
val =LTB_Q{ii,4};      AO.LTB_Q.Status(ii,1)                = val;
val =LTB_Q{ii,5};      AO.LTB_Q.DeviceList(ii,:)            = val;
val =LTB_Q{ii,6};      AO.LTB_Q.ElementList(ii,1)           = val;
val =LTB_Q{ii,7};      AO.LTB_Q.Monitor.HW2PhysicsParams(ii,:) = val;
                       AO.LTB_Q.Monitor.Physics2HWParams(ii,:) = 1/val;
                       AO.LTB_Q.Setpoint.HW2PhysicsParams(ii,:)= val;
                       AO.LTB_Q.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =LTB_Q{ii,8};      AO.LTB_Q.Setpoint.Range(ii,:)        = val;
val =LTB_Q{ii,9};      AO.LTB_Q.Setpoint.Tolerance(ii,1)    = val;
val =LTB_Q{ii,10};     AO.LTB_Q.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end LTB QUADS ***


% *** LTB SEPI  ***
% septum
AO.LTB_SEPI.FamilyName                     = 'LTB_SEPI'; dispobject(AO,AO.LTB_SEPI.FamilyName);
AO.LTB_SEPI.MemberOf                       = {'Injection'; 'LTB';};

AO.LTB_SEPI.Monitor.Mode                   = Mode;
AO.LTB_SEPI.Monitor.DataType               = 'Scalar';
AO.LTB_SEPI.Monitor.Units                  = 'Hardware';
AO.LTB_SEPI.Monitor.HWUnits                = 'Volts';           
AO.LTB_SEPI.Monitor.PhysicsUnits           = 'mradian';

AO.LTB_SEPI.Setpoint.Mode                  = Mode;
AO.LTB_SEPI.Setpoint.DataType              = 'Scalar';
AO.LTB_SEPI.Setpoint.Units                 = 'Hardware';
AO.LTB_SEPI.Setpoint.HWUnits               = 'Volts';           
AO.LTB_SEPI.Setpoint.PhysicsUnits          = 'mradian';

hw2physics_conversionfactor = 1;

%common     monitor                        setpoint                stat  devlist elem range    tol
LTB_SEPI={
'SEPI'      'PS-SEI-2:CURRENT_MONITOR'     'PS-SEI-2:CURRENT_SP'   1     [1,1]   1    [0,800]  0.05;...   
};
for ii=1:size(LTB_SEPI,1)
name=LTB_SEPI{ii,1};     AO.LTB_SEPI.CommonNames(ii,:)          = name;            
name=LTB_SEPI{ii,2};     AO.LTB_SEPI.Monitor.ChannelNames(ii,:) = name; 
name=LTB_SEPI{ii,3};     AO.LTB_SEPI.Setpoint.ChannelNames(ii,:)= name;     
val =LTB_SEPI{ii,4};     AO.LTB_SEPI.Status(ii,1)               = val;
val =LTB_SEPI{ii,5};     AO.LTB_SEPI.DeviceList(ii,:)           = val;
val =LTB_SEPI{ii,6};     AO.LTB_SEPI.ElementList(ii,1)          = val;
val =LTB_SEPI{ii,7};     AO.LTB_SEPI.Setpoint.Range(ii,:)       = val;
val =LTB_SEPI{ii,8};     AO.LTB_SEPI.Setpoint.Tolerance(ii,1)   = val;

AO.LTB_SEPI.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
AO.LTB_SEPI.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
end


% kicker
AO.LTB_KI.FamilyName                     = 'LTB_KI'; dispobject(AO,AO.LTB_KI.FamilyName);
AO.LTB_KI.MemberOf                       = {'Injection'; 'LTB';};

AO.LTB_KI.Monitor.Mode                   = Mode;
AO.LTB_KI.Monitor.DataType               = 'Scalar';
AO.LTB_KI.Monitor.Units                  = 'Hardware';
AO.LTB_KI.Monitor.HWUnits                = 'kVolts';           
AO.LTB_KI.Monitor.PhysicsUnits           = 'mradian';

AO.LTB_KI.Setpoint.Mode                  = Mode;
AO.LTB_KI.Setpoint.DataType              = 'Scalar';
AO.LTB_KI.Setpoint.Units                 = 'Hardware';
AO.LTB_KI.Setpoint.HWUnits               = 'kVolts';           
AO.LTB_KI.Setpoint.PhysicsUnits          = 'mradian';

hw2physics_conversionfactor = 1;

%common  monitor                         setpoint                  stat  devlist elem range      tol
LTB_KI={
'KI'     'PS-KI-2:HIGHVOLTAGE_MONITOR'   'PS-KI-2:HIGHVOLTAGE_SP'  1     [1,1]   1    [0,12000]  0.05;...  
};
for ii=1:size(LTB_KI,1)
name=LTB_KI{ii,1};     AO.LTB_KI.CommonNames(ii,:)          = name;            
name=LTB_KI{ii,2};     AO.LTB_KI.Monitor.ChannelNames(ii,:) = name; 
name=LTB_KI{ii,3};     AO.LTB_KI.Setpoint.ChannelNames(ii,:)= name;     
val =LTB_KI{ii,4};     AO.LTB_KI.Status(ii,1)               = val;
val =LTB_KI{ii,5};     AO.LTB_KI.DeviceList(ii,:)           = val;
val =LTB_KI{ii,6};     AO.LTB_KI.ElementList(ii,1)          = val;
val =LTB_KI{ii,7};     AO.LTB_KI.Setpoint.Range(ii,:)       = val;
val =LTB_KI{ii,8};     AO.LTB_KI.Setpoint.Tolerance(ii,1)   = val;

AO.LTB_KI.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
AO.LTB_KI.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
end

%--------------- END OF LTB ------------







%--------------- START OF BOOSTER ------------

%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=32;
AO.BPMx.FamilyName               = 'BPMx'; dispobject(AO,AO.BPMx.FamilyName);
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMx'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy'; dispobject(AO,AO.BPMy.FamilyName);
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMy'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name       x-chname       xstat y-name       y-chname     ystat DevList Elem
bpm={
'BPMx1  '	'BPM01:HPOS_MONITOR   '	1	'BPMy1  '	'BPM01:VPOS_MONITOR   '	1	[1,1]	1	; ...
'BPMx2  '	'BPM02:HPOS_MONITOR   '	1	'BPMy2  '	'BPM02:VPOS_MONITOR   '	1	[1,2]	2	; ...
'BPMx3  '	'BPM03:HPOS_MONITOR   '	1	'BPMy3  '	'BPM03:VPOS_MONITOR   '	1	[1,3]	3	; ...
'BPMx4  '	'BPM04:HPOS_MONITOR   '	1	'BPMy4  '	'BPM04:VPOS_MONITOR   '	1	[1,4]	4	; ...
'BPMx5  '	'BPM05:HPOS_MONITOR   '	1	'BPMy5  '	'BPM05:VPOS_MONITOR   '	1	[1,5]	5	; ...
'BPMx6  '	'BPM06:HPOS_MONITOR   '	1	'BPMy6  '	'BPM06:VPOS_MONITOR   '	1	[1,6]	6	; ...
'BPMx7  '	'BPM07:HPOS_MONITOR   '	0	'BPMy7  '	'BPM07:VPOS_MONITOR   '	0	[1,7]	7	; ...
'BPMx8  '	'BPM08:HPOS_MONITOR   '	1	'BPMy8  '	'BPM08:VPOS_MONITOR   '	1	[1,8]	8	; ...
'BPMx9  '	'BPM09:HPOS_MONITOR   '	1	'BPMy9  '	'BPM09:VPOS_MONITOR   '	1	[2,1]	9	; ...
'BPMx10 '	'BPM10:HPOS_MONITOR   '	1	'BPMy10 '	'BPM10:VPOS_MONITOR   '	1	[2,2]	10	; ...
'BPMx11 '	'BPM11:HPOS_MONITOR   '	1	'BPMy11 '	'BPM11:VPOS_MONITOR   '	1	[2,3]	11	; ...
'BPMx12 '	'BPM12:HPOS_MONITOR   '	1	'BPMy12 '	'BPM12:VPOS_MONITOR   '	1	[2,4]	12	; ...
'BPMx13 '	'BPM13:HPOS_MONITOR   '	1	'BPMy13 '	'BPM13:VPOS_MONITOR   '	1	[2,5]	13	; ...
'BPMx14 '	'BPM14:HPOS_MONITOR   '	0	'BPMy14 '	'BPM14:VPOS_MONITOR   '	0	[2,6]	14	; ...
'BPMx15 '	'BPM15:HPOS_MONITOR   '	1	'BPMy15 '	'BPM15:VPOS_MONITOR   '	1	[2,7]	15	; ...
'BPMx16 '	'BPM16:HPOS_MONITOR   '	1	'BPMy16 '	'BPM16:VPOS_MONITOR   '	1	[2,8]	16	; ...
'BPMx17 '	'BPM17:HPOS_MONITOR   '	1	'BPMy17 '	'BPM17:VPOS_MONITOR   '	1	[3,1]	17	; ...
'BPMx18 '	'BPM18:HPOS_MONITOR   '	1	'BPMy18 '	'BPM18:VPOS_MONITOR   '	1	[3,2]	18	; ...
'BPMx19 '	'BPM19:HPOS_MONITOR   '	1	'BPMy19 '	'BPM19:VPOS_MONITOR   '	1	[3,3]	19	; ...
'BPMx20 '	'BPM20:HPOS_MONITOR   '	1	'BPMy20 '	'BPM20:VPOS_MONITOR   '	1	[3,4]	20	; ...
'BPMx21 '	'BPM21:HPOS_MONITOR   '	1	'BPMy21 '	'BPM21:VPOS_MONITOR   '	1	[3,5]	21	; ...
'BPMx22 '	'BPM22:HPOS_MONITOR   '	1	'BPMy22 '	'BPM22:VPOS_MONITOR   '	1	[3,6]	22	; ...
'BPMx23 '	'BPM23:HPOS_MONITOR   '	1	'BPMy23 '	'BPM23:VPOS_MONITOR   '	1	[3,7]	23	; ...
'BPMx24 '	'BPM24:HPOS_MONITOR   '	1	'BPMy24 '	'BPM24:VPOS_MONITOR   '	1	[3,8]	24	; ...
'BPMx25 '	'BPM25:HPOS_MONITOR   '	1	'BPMy25 '	'BPM25:VPOS_MONITOR   '	1	[4,1]	25	; ...
'BPMx26 '	'BPM26:HPOS_MONITOR   '	1	'BPMy26 '	'BPM26:VPOS_MONITOR   '	1	[4,2]	26	; ...
'BPMx27 '	'BPM27:HPOS_MONITOR   '	1	'BPMy27 '	'BPM27:VPOS_MONITOR   '	1	[4,3]	27	; ...
'BPMx28 '	'BPM28:HPOS_MONITOR   '	1	'BPMy28 '	'BPM28:VPOS_MONITOR   '	1	[4,4]	28	; ...
'BPMx29 '	'BPM29:HPOS_MONITOR   '	1	'BPMy29 '	'BPM29:VPOS_MONITOR   '	1	[4,5]	29	; ...
'BPMx30 '	'BPM30:HPOS_MONITOR   '	1	'BPMy30 '	'BPM30:VPOS_MONITOR   '	1	[4,6]	30	; ...
'BPMx31 '	'BPM31:HPOS_MONITOR   '	1	'BPMy31 '	'BPM31:VPOS_MONITOR   '	1	[4,7]	31	; ...
'BPMx32 '	'BPM32:HPOS_MONITOR   '	1	'BPMy32 '	'BPM32:VPOS_MONITOR   '	1	[4,8]	32	; ...
};

%Load fields from data block
for ii=1:size(bpm,1)
name=bpm{ii,1};      AO.BPMx.CommonNames(ii,:)         = name;
name=bpm{ii,2};      AO.BPMx.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,3};      AO.BPMx.Status(ii,:)              = val;  
name=bpm{ii,4};      AO.BPMy.CommonNames(ii,:)         = name;
name=bpm{ii,5};      AO.BPMy.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,6};      AO.BPMy.Status(ii,:)              = val;  
val =bpm{ii,7};      AO.BPMx.DeviceList(ii,:)          = val;   
                     AO.BPMy.DeviceList(ii,:)          = val;
val =bpm{ii,8};      AO.BPMx.ElementList(ii,:)         = val;   
                     AO.BPMy.ElementList(ii,:)         = val;
                     AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1000;
                     AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1000;
end

%===========================================================
% Corrector data: status field designates if corrector in use
% 
%===========================================================

AO.HCM.FamilyName               = 'HCM'; dispobject(AO,AO.HCM.FamilyName);
AO.HCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};

AO.HCM.Monitor.Mode             = Mode;
AO.HCM.Monitor.DataType         = 'Scalar';
AO.HCM.Monitor.Units            = 'Hardware';
AO.HCM.Monitor.HWUnits          = 'ampere';           
AO.HCM.Monitor.PhysicsUnits     = 'radian';
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;

AO.HCM.Setpoint.Mode            = Mode;
AO.HCM.Setpoint.DataType        = 'Scalar';
AO.HCM.Setpoint.Units           = 'Hardware';
AO.HCM.Setpoint.HWUnits         = 'ampere';           
AO.HCM.Setpoint.PhysicsUnits    = 'radian';
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%x-common      x-monitor           x-setpoint     xstat devlist elem range(ampere) tol   x-kick y-kick
cor={
'HCM1   '	'PS-OCH-B-2-1:CURRENT_MONITOR '	'PS-OCH-B-2-1:CURRENT_SP      '	1	[1,1]	1	[-10, +10]  1  1.5e-4 	; ...
'HCM2   '	'PS-OCH-B-2-2:CURRENT_MONITOR '	'PS-OCH-B-2-2:CURRENT_SP      '	1	[1,2]	2	[-10, +10]  1  1.5e-4 	; ...
'HCM3   '	'PS-OCH-B-2-3:CURRENT_MONITOR '	'PS-OCH-B-2-3:CURRENT_SP      '	1	[1,3]	3	[-10, +10]  1  1.5e-4 	; ...
'HCM4   '	'PS-OCH-B-2-4:CURRENT_MONITOR '	'PS-OCH-B-2-4:CURRENT_SP      '	1	[1,4]	4	[-10, +10]  1  1.5e-4 	; ...
'HCM5   '	'PS-OCH-B-2-5:CURRENT_MONITOR '	'PS-OCH-B-2-5:CURRENT_SP      '	1	[1,5]	5	[-10, +10]  1  1.5e-4 	; ...
'HCM6   '	'PS-OCH-B-2-6:CURRENT_MONITOR '	'PS-OCH-B-2-6:CURRENT_SP      '	1	[1,6]	6	[-10, +10]  1  1.5e-4 	; ...
'HCM7   '	'PS-OCH-B-2-7:CURRENT_MONITOR '	'PS-OCH-B-2-7:CURRENT_SP      '	1	[1,7]	7	[-10, +10]  1  1.5e-4 	; ...
'HCM8   '	'PS-OCH-B-2-8:CURRENT_MONITOR '	'PS-OCH-B-2-8:CURRENT_SP      '	1	[1,8]	8	[-10, +10]  1  1.5e-4 	; ...
'HCM9   '	'PS-OCH-B-2-9:CURRENT_MONITOR '	'PS-OCH-B-2-9:CURRENT_SP      '	1	[1,9]	9	[-10, +10]  1  1.5e-4 	; ...
'HCM10  '	'PS-OCH-B-2-10:CURRENT_MONITOR'	'PS-OCH-B-2-10:CURRENT_SP     '	1	[1,10]	10	[-10, +10]  1  1.5e-4 	; ...
'HCM11  '	'PS-OCH-B-2-11:CURRENT_MONITOR'	'PS-OCH-B-2-11:CURRENT_SP     '	1	[1,11]	11	[-10, +10]  1  1.5e-4 	; ...
'HCM12  '	'PS-OCH-B-2-12:CURRENT_MONITOR'	'PS-OCH-B-2-12:CURRENT_SP     '	1	[1,12]	12	[-10, +10]  1  1.5e-4 	; ...
'HCM13  '	'PS-OCH-B-2-13:CURRENT_MONITOR'	'PS-OCH-B-2-13:CURRENT_SP     '	1	[1,13]	13	[-10, +10]  1  1.5e-4 	; ...
'HCM14  '	'PS-OCH-B-2-14:CURRENT_MONITOR'	'PS-OCH-B-2-14:CURRENT_SP     '	1	[1,14]	14	[-10, +10]  1  1.5e-4 	; ...
'HCM15  '	'PS-OCH-B-2-15:CURRENT_MONITOR'	'PS-OCH-B-2-15:CURRENT_SP     '	1	[1,15]	15	[-10, +10]  1  1.5e-4 	; ...
'HCM16  '	'PS-OCH-B-2-16:CURRENT_MONITOR'	'PS-OCH-B-2-16:CURRENT_SP     '	1	[1,16]	16	[-10, +10]  1  1.5e-4 	; ...
'HCM17  '	'PS-OCH-B-2-17:CURRENT_MONITOR'	'PS-OCH-B-2-17:CURRENT_SP     '	1	[1,17]	17	[-10, +10]  1  1.5e-4 	; ...
'HCM18  '	'PS-OCH-B-2-18:CURRENT_MONITOR'	'PS-OCH-B-2-18:CURRENT_SP     '	1	[1,18]	18	[-10, +10]  1  1.5e-4 	; ...
'HCM19  '	'PS-OCH-B-2-19:CURRENT_MONITOR'	'PS-OCH-B-2-19:CURRENT_SP     '	1	[1,19]	19	[-10, +10]  1  1.5e-4 	; ...
'HCM20  '	'PS-OCH-B-2-20:CURRENT_MONITOR'	'PS-OCH-B-2-20:CURRENT_SP     '	1	[1,20]	20	[-10, +10]  1  1.5e-4 	; ...
'HCM21  '	'PS-OCH-B-2-21:CURRENT_MONITOR'	'PS-OCH-B-2-21:CURRENT_SP     '	1	[1,21]	21	[-10, +10]  1  1.5e-4 	; ...
'HCM22  '	'PS-OCH-B-2-22:CURRENT_MONITOR'	'PS-OCH-B-2-22:CURRENT_SP     '	1	[1,22]	22	[-10, +10]  1  1.5e-4 	; ...
'HCM23  '	'PS-OCH-B-2-23:CURRENT_MONITOR'	'PS-OCH-B-2-23:CURRENT_SP     '	1	[1,23]	23	[-10, +10]  1  1.5e-4 	; ...
'HCM24  '	'PS-OCH-B-2-24:CURRENT_MONITOR'	'PS-OCH-B-2-24:CURRENT_SP     '	1	[1,24]	24	[-10, +10]  1  1.5e-4 	; ...
};

% Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset. These are
% coefficients that define the magnet amp to K profile and is used in the
% conversion between HW units and physics units. 'Matnetcoefficients' is a
% custom file taylored specifically for the magnets.
HCMcoefficients = magnetcoefficients('HCM');

for ii=1:size(cor,1)
name=cor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;            
name=cor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;     
name=cor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
val =cor{ii,4};     AO.HCM.Status(ii,1)                = val;

val =cor{ii,5};     AO.HCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.HCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.HCM.Setpoint.Range(ii,:)        = val;
val =cor{ii,8};     AO.HCM.Setpoint.Tolerance(ii,1)    = val;
val =cor{ii,9};     AO.HCM.Setpoint.DeltaRespMat(ii,1) = val;

AO.HCM.Monitor.HW2PhysicsParams{1}(ii,:)           = HCMcoefficients;          
AO.HCM.Monitor.HW2PhysicsParams{2}(ii,:)           = 1;
AO.HCM.Monitor.Physics2HWParams{1}(ii,:)           = HCMcoefficients;
AO.HCM.Monitor.Physics2HWParams{2}(ii,:)           = 1;
AO.HCM.Setpoint.HW2PhysicsParams{1}(ii,:)          = HCMcoefficients;          
AO.HCM.Setpoint.HW2PhysicsParams{2}(ii,:)          = 1;          
AO.HCM.Setpoint.Physics2HWParams{1}(ii,:)          = HCMcoefficients;
AO.HCM.Setpoint.Physics2HWParams{2}(ii,:)          = 1;

end
AO.HCM.Status=AO.HCM.Status(:);


AO.VCM.FamilyName               = 'VCM'; dispobject(AO,AO.VCM.FamilyName);
AO.VCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'};

AO.VCM.Monitor.Mode             = Mode;
AO.VCM.Monitor.DataType         = 'Scalar';
AO.VCM.Monitor.Units            = 'Hardware';
AO.VCM.Monitor.HWUnits          = 'ampere';           
AO.VCM.Monitor.PhysicsUnits     = 'radian';
AO.VCM.Monitor.HW2PhysicsFcn    = @amp2k;
AO.VCM.Monitor.Physics2HWFcn    = @k2amp;

AO.VCM.Setpoint.Mode            = Mode;
AO.VCM.Setpoint.DataType        = 'Scalar';
AO.VCM.Setpoint.Units           = 'Hardware';
AO.VCM.Setpoint.HWUnits         = 'ampere';           
AO.VCM.Setpoint.PhysicsUnits    = 'radian';
AO.VCM.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn   = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%y-common      y-monitor           y-setpoint     ystat y-common      y-monitor          y-setpoint      ystat devlist elem range (ampere) tol   x-kick y-kick y-phot   H2P_X          P2H_X          H2P_Y        P2H_Y 
cor={
'VCM1   '	'PS-OCV-B-2-1:CURRENT_MONITOR  '	'PS-OCV-B-2-1:CURRENT_SP      '	1	[1,1]	1	[-10, +10]  1  1.5e-4	; ...
'VCM2   '	'PS-OCV-B-2-2:CURRENT_MONITOR  '	'PS-OCV-B-2-2:CURRENT_SP      '	1	[1,2]	2	[-10, +10]  1  1.5e-4	; ...
'VCM3   '	'PS-OCV-B-2-3:CURRENT_MONITOR  '	'PS-OCV-B-2-3:CURRENT_SP      '	1	[1,3]	3	[-10, +10]  1  1.5e-4	; ...
'VCM4   '	'PS-OCV-B-2-4:CURRENT_MONITOR  '	'PS-OCV-B-2-4:CURRENT_SP      '	1	[1,4]	4	[-10, +10]  1  1.5e-4	; ...
'VCM5   '	'PS-OCV-B-2-5:CURRENT_MONITOR  '	'PS-OCV-B-2-5:CURRENT_SP      '	1	[1,5]	5	[-10, +10]  1  1.5e-4	; ...
'VCM6   '	'PS-OCV-E-2-01:CURRENT_MONITOR '	'PS-OCV-E-2-01:CURRENT_SP     '	1	[1,6]	6	[-10, +10]  1  1.5e-4	; ...
'VCM7   '	'PS-OCV-B-2-6:CURRENT_MONITOR  '	'PS-OCV-B-2-6:CURRENT_SP      '	1	[1,7]	7	[-10, +10]  1  1.5e-4	; ...
'VCM8   '	'PS-OCV-B-2-7:CURRENT_MONITOR  '	'PS-OCV-B-2-7:CURRENT_SP      '	1	[1,8]	8	[-10, +10]  1  1.5e-4	; ...
'VCM9   '	'PS-OCV-B-2-8:CURRENT_MONITOR  '	'PS-OCV-B-2-8:CURRENT_SP      '	1	[1,9]	9	[-10, +10]  1  1.5e-4	; ...
'VCM10  '	'PS-OCV-B-2-09:CURRENT_MONITOR '	'PS-OCV-B-2-09:CURRENT_SP     '	1	[1,10]	10	[-10, +10]  1  1.5e-4	; ...
'VCM11  '	'PS-OCV-B-2-10:CURRENT_MONITOR '	'PS-OCV-B-2-10:CURRENT_SP     '	1	[1,11]	11	[-10, +10]  1  1.5e-4	; ...
'VCM12  '	'PS-OCV-B-2-11:CURRENT_MONITOR '	'PS-OCV-B-2-11:CURRENT_SP     '	1	[1,12]	12	[-10, +10]  1  1.5e-4	; ...
};


% Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset. These are
% coefficients that define the magnet amp to K profile and is used in the
% conversion between HW units and physics units. 'Matnetcoefficients' is a
% custom file taylored specifically for the magnets.
VCMcoefficients = magnetcoefficients('VCM');

for ii=1:size(cor,1)
name=cor{ii,1};     AO.VCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.VCM.Monitor.ChannelNames(ii,:) = name;     
name=cor{ii,3};     AO.VCM.Setpoint.ChannelNames(ii,:)  = name;
val =cor{ii,4};     AO.VCM.Status(ii,1)                = val;

val =cor{ii,5};     AO.VCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.VCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.VCM.Setpoint.Range(ii,:)        = val;
val =cor{ii,8};     AO.VCM.Setpoint.Tolerance(ii,1)    = val;
val =cor{ii,9};     AO.VCM.Setpoint.DeltaRespMat(ii,1) = val;

AO.VCM.Monitor.HW2PhysicsParams{1}(ii,:)           = VCMcoefficients;          
AO.VCM.Monitor.HW2PhysicsParams{2}(ii,:)           = 1;
AO.VCM.Monitor.Physics2HWParams{1}(ii,:)           = VCMcoefficients;
AO.VCM.Monitor.Physics2HWParams{2}(ii,:)           = 1;
AO.VCM.Setpoint.HW2PhysicsParams{1}(ii,:)          = VCMcoefficients;          
AO.VCM.Setpoint.HW2PhysicsParams{2}(ii,:)          = 1;          
AO.VCM.Setpoint.Physics2HWParams{1}(ii,:)          = VCMcoefficients;
AO.VCM.Setpoint.Physics2HWParams{2}(ii,:)          = 1;
end


%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========

% *** BEND ***
AO.BEND.FamilyName                 = 'BEND'; dispobject(AO,AO.BEND.FamilyName);
%AO.BEND.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet';};
AO.BEND.MemberOf                   = {'BEND'; 'Magnet';};   % Devicelist needs to be fixed  [60 bends]  (GJP)

AO.BEND.Monitor.Mode               = Mode;
AO.BEND.Monitor.DataType           = 'Scalar';
AO.BEND.Monitor.Units              = 'Hardware';
AO.BEND.Monitor.HW2PhysicsFcn      = @bend2gev;   % @bend2gev ???
AO.BEND.Monitor.Physics2HWFcn      = @gev2bend;
AO.BEND.Monitor.HWUnits            = 'ampere';           
AO.BEND.Monitor.PhysicsUnits       = 'energy';

AO.BEND.Setpoint.Mode              = Mode;
AO.BEND.Setpoint.DataType          = 'Scalar';
AO.BEND.Setpoint.Units             = 'Hardware';
AO.BEND.Setpoint.HW2PhysicsFcn     = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn     = @gev2bend;
AO.BEND.Setpoint.HWUnits           = 'ampere';           
AO.BEND.Setpoint.PhysicsUnits      = 'energy';
%                                                                                                        delta-k
%common           desired                   monitor              setpoint           stat devlist elem   scalefactor    range    tol   respkick
BEND={
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,1]	1	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[1,2]	2	1.0005     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,3]	3	1.0        [0, 500]  0.05   0.05	; ...
}; 

for ii=1:size(BEND,1)
name=BEND{ii,1};      AO.BEND.CommonNames(ii,:)           = name;            
name=BEND{ii,2};      AO.BEND.Monitor.ChannelNames(ii,:)  = name;
name=BEND{ii,3};      AO.BEND.Setpoint.ChannelNames(ii,:) = name;     
val =BEND{ii,4};      AO.BEND.Status(ii,1)                = val;
val =BEND{ii,5};      AO.BEND.DeviceList(ii,:)            = val;
val =BEND{ii,6};      AO.BEND.ElementList(ii,1)           = val;
% val =BEND{ii,7};      AO.BEND.Monitor.HW2PhysicsParams(ii,:) = val;
%                       AO.BEND.Monitor.Physics2HWParams(ii,:) = val;
%                       AO.BEND.Setpoint.HW2PhysicsParams(ii,:)= val;
%                       AO.BEND.Setpoint.Physics2HWParams(ii,:)= val;
val =BEND{ii,8};      AO.BEND.Setpoint.Range(ii,:)        = val;
val =BEND{ii,9};      AO.BEND.Setpoint.Tolerance(ii,1)    = val;
val =BEND{ii,10};     AO.BEND.Setpoint.DeltaRespMat(ii,1) = val;
end
AO.BEND.Monitor.HW2PhysicsParams{1}(1,:) = magnetcoefficients('BF');
AO.BEND.Monitor.HW2PhysicsParams{1}(2,:) = magnetcoefficients('BD1');
AO.BEND.Monitor.HW2PhysicsParams{1}(3,:) = magnetcoefficients('BD2');
AO.BEND.Setpoint.HW2PhysicsParams{1}(1,:) = magnetcoefficients('BF');
AO.BEND.Setpoint.HW2PhysicsParams{1}(2,:) = magnetcoefficients('BD1');
AO.BEND.Setpoint.HW2PhysicsParams{1}(3,:) = magnetcoefficients('BD2');

AO.BEND.Monitor.Physics2HWParams{1}(1,:) = magnetcoefficients('BF');
AO.BEND.Monitor.Physics2HWParams{1}(2,:) = magnetcoefficients('BD1');
AO.BEND.Monitor.Physics2HWParams{1}(3,:) = magnetcoefficients('BD2');
AO.BEND.Setpoint.Physics2HWParams{1}(1,:) = magnetcoefficients('BF');
AO.BEND.Setpoint.Physics2HWParams{1}(2,:) = magnetcoefficients('BD1');
AO.BEND.Setpoint.Physics2HWParams{1}(3,:) = magnetcoefficients('BD2');



%===============
%Quadrupole data
%===============

% *** QF ***
AO.QF.FamilyName                 = 'QF'; dispobject(AO,AO.QF.FamilyName);
AO.QF.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'QF';};

AO.QF.Monitor.Mode               = Mode;
AO.QF.Monitor.DataType           = 'Scalar';
AO.QF.Monitor.Units              = 'Hardware';
AO.QF.Monitor.HWUnits            = 'ampere';           
AO.QF.Monitor.PhysicsUnits       = 'meter^-2';
AO.QF.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QF.Monitor.Physics2HWFcn      = @k2amp;

AO.QF.Setpoint.Mode              = Mode;
AO.QF.Setpoint.DataType          = 'Scalar';
AO.QF.Setpoint.Units             = 'Hardware';
AO.QF.Setpoint.HWUnits           = 'ampere';           
AO.QF.Setpoint.PhysicsUnits      = 'meter^-2';
AO.QF.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QF.Setpoint.Physics2HWFcn     = @k2amp;

%                                                                                                        delta-k
%common         desired                    monitor               setpoint            stat devlist  elem  scalefactor    range    tol  respkick
qf={
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[1,1]	1	1.0   [0, 500] 0.05  0.05	; ...
};

for ii=1:size(qf,1)
name=qf{ii,1};      AO.QF.CommonNames(ii,:)           = name;            
name=qf{ii,2};      AO.QF.Monitor.ChannelNames(ii,:)  = name;
name=qf{ii,3};      AO.QF.Setpoint.ChannelNames(ii,:) = name;     
val =qf{ii,4};      AO.QF.Status(ii,1)                = val;
val =qf{ii,5};      AO.QF.DeviceList(ii,:)            = val;
val =qf{ii,6};      AO.QF.ElementList(ii,1)           = val;
% val =qf{ii,7};      AO.QF.Monitor.HW2PhysicsParams(ii,:) = val;
%                     AO.QF.Monitor.Physics2HWParams(ii,:) = val;
%                     AO.QF.Setpoint.HW2PhysicsParams(ii,:)= val;
%                     AO.QF.Setpoint.Physics2HWParams(ii,:)= val;
val =qf{ii,8};      AO.QF.Setpoint.Range(ii,:)        = val;
val =qf{ii,9};      AO.QF.Setpoint.Tolerance(ii,1)    = val;
val =qf{ii,10};     AO.QF.Setpoint.DeltaRespMat(ii,1) = val;
end
AO.QF.Monitor.HW2PhysicsParams{1}                        = magnetcoefficients('QF');
AO.QF.Setpoint.HW2PhysicsParams{1}                       = magnetcoefficients('QF');
AO.QF.Monitor.Physics2HWParams{1}                        = magnetcoefficients('QF');
AO.QF.Setpoint.Physics2HWParams{1}                       = magnetcoefficients('QF');

% *** QD ***
AO.QD.FamilyName               = 'QD'; dispobject(AO,AO.QD.FamilyName);
AO.QD.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'QD';};

AO.QD.Monitor.Mode             = Mode;
AO.QD.Monitor.DataType         = 'Scalar';
AO.QD.Monitor.Units            = 'Hardware';
AO.QD.Monitor.HWUnits          = 'ampere';           
AO.QD.Monitor.PhysicsUnits     = 'meter^-2';
AO.QD.Monitor.HW2PhysicsFcn    = @amp2k;
AO.QD.Monitor.Physics2HWFcn    = @k2amp;

AO.QD.Setpoint.Mode            = Mode;
AO.QD.Setpoint.DataType        = 'Scalar';
AO.QD.Setpoint.Units           = 'Hardware';
AO.QD.Setpoint.HWUnits         = 'ampere';           
AO.QD.Setpoint.PhysicsUnits    = 'meter^-2';
AO.QD.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.QD.Setpoint.Physics2HWFcn   = @k2amp;

%                                                                                                                                     delta-k
%common         desired                    monitor               setpoint           stat  devlist  elem  scalefactor    range    tol  respkick
qd={
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[1,1]	1	1.0   [-100, 100] 0.05  0.05	; ...
};   
 
for ii=1:size(qd,1)
name=qd{ii,1};      AO.QD.CommonNames(ii,:)           = name;            
name=qd{ii,2};      AO.QD.Monitor.ChannelNames(ii,:)  = name;
name=qd{ii,3};      AO.QD.Setpoint.ChannelNames(ii,:) = name;     
val =qd{ii,4};      AO.QD.Status(ii,1)                = val;
val =qd{ii,5};      AO.QD.DeviceList(ii,:)            = val;
val =qd{ii,6};      AO.QD.ElementList(ii,1)           = val;
% val =qd{ii,7};      AO.QD.Monitor.HW2PhysicsParams(ii,:) = val;
%                     AO.QD.Monitor.Physics2HWParams(ii,:) = val;
%                     AO.QD.Setpoint.HW2PhysicsParams(ii,:)= val;
%                     AO.QD.Setpoint.Physics2HWParams(ii,:)= val;
val =qd{ii,8};      AO.QD.Setpoint.Range(ii,:)        = val;
val =qd{ii,9};      AO.QD.Setpoint.Tolerance(ii,1)    = val;
val =qd{ii,10};     AO.QD.Setpoint.DeltaRespMat(ii,1) = val;
end
AO.QD.Monitor.HW2PhysicsParams{1}                        = magnetcoefficients('QD');
AO.QD.Setpoint.HW2PhysicsParams{1}                       = magnetcoefficients('QD');
AO.QD.Monitor.Physics2HWParams{1}                        = magnetcoefficients('QD');
AO.QD.Setpoint.Physics2HWParams{1}                       = magnetcoefficients('QD');

%===============
%Sextupole data
%===============
% *** SF ***
AO.SF.FamilyName                = 'SF'; dispobject(AO,AO.SF.FamilyName);
AO.SF.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};

AO.SF.Monitor.Mode              = Mode;
AO.SF.Monitor.DataType          = 'Scalar';
AO.SF.Monitor.Units             = 'Hardware';
AO.SF.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SF.Monitor.Physics2HWFcn     = @k2amp;
AO.SF.Monitor.HWUnits           = 'ampere';           
AO.SF.Monitor.PhysicsUnits      = 'meter^-3';

AO.SF.Setpoint.Mode             = Mode;
AO.SF.Setpoint.DataType         = 'Scalar';
AO.SF.Setpoint.Units            = 'Hardware';
AO.SF.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SF.Setpoint.Physics2HWFcn    = @k2amp;
AO.SF.Setpoint.HWUnits          = 'ampere';           
AO.SF.Setpoint.PhysicsUnits     = 'meter^-3';

%                                                                                                      delta-k
%common            desired            monitor               setpoint        stat  devlist  elem  scalefactor    range   tol  respkick
sf={
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[1,1]	1	1.0   [0, 19] 0.05  0.05	; ...
};

for ii=1:size(sf,1)
name=sf{ii,1};      AO.SF.CommonNames(ii,:)           = name;            
name=sf{ii,2};      AO.SF.Monitor.ChannelNames(ii,:)  = name;
name=sf{ii,3};      AO.SF.Setpoint.ChannelNames(ii,:) = name;     
val =sf{ii,4};      AO.SF.Status(ii,1)                = val;
val =sf{ii,5};      AO.SF.DeviceList(ii,:)            = val;
val =sf{ii,6};      AO.SF.ElementList(ii,1)           = val;
% val =sf{ii,7};      AO.SF.Monitor.HW2PhysicsParams(ii,:) = val;
%                     AO.SF.Monitor.Physics2HWParams(ii,:) = val;
%                     AO.SF.Setpoint.HW2PhysicsParams(ii,:)= val;
%                     AO.SF.Setpoint.Physics2HWParams(ii,:)= val;
val =sf{ii,8};      AO.SF.Setpoint.Range(ii,:)        = val;
val =sf{ii,9};      AO.SF.Setpoint.Tolerance(ii,1)    = val;
val =sf{ii,10};     AO.SF.Setpoint.DeltaRespMat(ii,1)         = val;
end
AO.SF.Monitor.HW2PhysicsParams{1}                     = magnetcoefficients('SF');
AO.SF.Setpoint.HW2PhysicsParams{1}                    = magnetcoefficients('SF');

AO.SF.Monitor.Physics2HWParams{1}                     = magnetcoefficients('SF');
AO.SF.Setpoint.Physics2HWParams{1}                    = magnetcoefficients('SF');


% *** SD ***
AO.SD.FamilyName                = 'SD'; dispobject(AO,AO.SD.FamilyName);
AO.SD.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
HW2PhysicsParams                 = magnetcoefficients('SD');
Physics2HWParams                 = magnetcoefficients('SD');

AO.SD.Monitor.Mode              = Mode;
AO.SD.Monitor.DataType          = 'Scalar';
AO.SD.Monitor.Units             = 'Hardware';
AO.SD.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SD.Monitor.Physics2HWFcn     = @k2amp;
AO.SD.Monitor.HWUnits           = 'ampere';           
AO.SD.Monitor.PhysicsUnits      = 'meter^-3';

AO.SD.Setpoint.Mode             = Mode;
AO.SD.Setpoint.DataType         = 'Scalar';
AO.SD.Setpoint.Units            = 'Hardware';
AO.SD.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SD.Setpoint.Physics2HWFcn    = @k2amp;
AO.SD.Setpoint.HWUnits          = 'ampere';           
AO.SD.Setpoint.PhysicsUnits     = 'meter^-3';

              
%                                                                                                      delta-k
%common           desired             monitor               setpoint        stat  devlist  elem  scalefactor    range   tol  respkick
sd={
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[1,1]	1	1.0   [-20, 20] 0.05  0.05	; ...
};

for ii=1:size(sd,1)
name=sd{ii,1};      AO.SD.CommonNames(ii,:)           = name;            
name=sd{ii,2};      AO.SD.Monitor.ChannelNames(ii,:)  = name;
name=sd{ii,3};      AO.SD.Setpoint.ChannelNames(ii,:) = name;     
val =sd{ii,4};      AO.SD.Status(ii,1)                = val;
val =sd{ii,5};      AO.SD.DeviceList(ii,:)            = val;
val =sd{ii,6};      AO.SD.ElementList(ii,1)           = val;
% val =sd{ii,7};      AO.SD.Monitor.HW2PhysicsParams(ii,:) = val;
%                     AO.SD.Monitor.Physics2HWParams(ii,:) = val;
%                     AO.SD.Setpoint.HW2PhysicsParams(ii,:)= val;
%                     AO.SD.Setpoint.Physics2HWParams(ii,:)= val;
val =sd{ii,8};      AO.SD.Setpoint.Range(ii,:)        = val;
val =sd{ii,9};      AO.SD.Setpoint.Tolerance(ii,1)    = val;
val =sd{ii,10};     AO.SD.Setpoint.DeltaRespMat(ii,1) = val;
end
AO.SD.Monitor.HW2PhysicsParams{1}                        = magnetcoefficients('SD');
AO.SD.Setpoint.HW2PhysicsParams{1}                       = magnetcoefficients('SD');

AO.SD.Monitor.Physics2HWParams{1}                        = magnetcoefficients('SD');
AO.SD.Setpoint.Physics2HWParams{1}                       = magnetcoefficients('SD');

% *** KICK Amplitude ***
% AO.KICK.FamilyName                     = 'KICK'; dispobject(AO,AO.KICK.FamilyName);
% AO.KICK.MemberOf                       = {'Injection'};
% 
% AO.KICK.Monitor.Mode                   = Mode;
% AO.KICK.Monitor.DataType               = 'Scalar';
% AO.KICK.Monitor.Units                  = 'Hardware';
% AO.KICK.Monitor.HWUnits                = 'Volts';           
% AO.KICK.Monitor.PhysicsUnits           = 'mradian';
% 
% AO.KICK.Setpoint.Mode                  = Mode;
% AO.KICK.Setpoint.DataType              = 'Scalar';
% AO.KICK.Setpoint.Units                 = 'Hardware';
% AO.KICK.Setpoint.HWUnits               = 'Volts';           
% AO.KICK.Setpoint.PhysicsUnits          = 'mradian';
% 
% hw2physics_conversionfactor = 1;
% 
% %common        monitor                  setpoint                stat  devlist elem range    tol
% kickeramp={ 
% 'KICK1   '	'PS-SEI-2:VOLTAGE_MONITOR'	'PS-SEI-2:VOLTAGE_SP     '	1	[1,1]	1	[0 9] 0.10	; ...
% 'KICK2   '	'PS-SEE-2:VOLTAGE_MONITOR'	'PS-SEE-2:VOLTAGE_SP     '	1	[1,2]	2	[0 9] 0.10	; ...
% 'KICK3   '	'PS-KI-2:VOLTAGE_MONITOR '	'PS-KI-2:VOLTAGE_SP      '	1	[1,3]	3	[0 9] 0.10	; ...
% 'KICK4   '	'PS-KE-2:VOLTAGE_MONITOR '	'PS-KE-2:VOLTAGE_SP      '	1	[1,4]	4	[0 9] 0.10	; ...
% 'KICK5   '	'PS-BMP-2:VOLTAGE_MONITOR'	'PS-BMP-2:VOLTAGE_SP     '	1	[1,5]	5	[0 9] 0.10	; ...
% };
% 
% for ii=1:size(kickeramp,1)
% name=kickeramp{ii,1};     AO.KICK.CommonNames(ii,:)          = name;            
% name=kickeramp{ii,2};     AO.KICK.Monitor.ChannelNames(ii,:) = name; 
% name=kickeramp{ii,3};     AO.KICK.Setpoint.ChannelNames(ii,:)= name;     
% val =kickeramp{ii,4};     AO.KICK.Status(ii,1)               = val;
% val =kickeramp{ii,5};     AO.KICK.DeviceList(ii,:)           = val;
% val =kickeramp{ii,6};     AO.KICK.ElementList(ii,1)          = val;
% val =kickeramp{ii,7};     AO.KICK.Setpoint.Range(ii,:)       = val;
% val =kickeramp{ii,8};     AO.KICK.Setpoint.Tolerance(ii,1)   = val;
% 
% AO.KICK.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
% AO.KICK.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
% end

% *** KICK Delay ***
% AO.KICK.Delay
% >> removed >> see previous versions if info needed


%============
%RF System
%============
AO.RF.FamilyName                  = 'RF'; dispobject(AO,AO.RF.FamilyName);
AO.RF.MemberOf                    = {'MachineConfig'; 'RF'; 'RFSystem'};

% %------------------------------------- 1 Cavity Case
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
AO.RF.Monitor.ChannelNames        = 'SR00MOS01:FREQUENCY_MONITOR';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = 'SR00MOS01:FREQUENCY_SP';     
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
AO.RF.Voltage.HWUnits            = 'Volts';           
AO.RF.Voltage.PhysicsUnits       = 'Volts';
AO.RF.Voltage.ChannelNames       = 'SRF1:STN:VOLT';     
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


%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE'; dispobject(AO,AO.TUNE.FamilyName);
AO.TUNE.MemberOf    = {'Tune'; 'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';

AO.TUNE.Monitor.Mode                   = Mode; 
AO.TUNE.Monitor.DataType               = 'Vector';
AO.TUNE.Monitor.DataTypeIndex          = [1 2 3]';
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';


%====
%DCCT
%====
AO.DCCT.FamilyName                     = 'DCCT'; dispobject(AO,AO.DCCT.FamilyName);
AO.DCCT.MemberOf                       = {'Diagnostics'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = [1]';
AO.DCCT.Status                         = AO.DCCT.ElementList;

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = 'ASP:BeamCurrAvg';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;

%--------------- END OF BOOSTER ------------





%--------------- START OF BTS ------------

% *** BTS QUADS ***
AO.BTS_Q.FamilyName                 = 'BTS_Q'; dispobject(AO,AO.BTS_Q.FamilyName);
AO.BTS_Q.MemberOf                   = {'MachineConfig'; 'QUAD'; 'Magnet'; 'BTS';};

AO.BTS_Q.Monitor.Mode               = Mode;
AO.BTS_Q.Monitor.DataType           = 'Scalar';
AO.BTS_Q.Monitor.Units              = 'Hardware';
AO.BTS_Q.Monitor.HWUnits            = 'ampere';           
AO.BTS_Q.Monitor.PhysicsUnits       = 'meter^-2';

AO.BTS_Q.Setpoint.Mode              = Mode;
AO.BTS_Q.Setpoint.DataType          = 'Scalar';
AO.BTS_Q.Setpoint.Units             = 'Hardware';
AO.BTS_Q.Setpoint.HWUnits           = 'ampere';           
AO.BTS_Q.Setpoint.PhysicsUnits      = 'meter^-2';
                      
%common                    monitor              setpoint                stat devlist  elem   hw2physics    range    tol     respkick
BTS_Q={
'Q21 '      'PS-QFA-3-1:CURRENT_MONITOR '     'PS-QFA-3-1:CURRENT_SP '   1    [1,1]    1      1.64/78.86   [0,15]   0.05    0.05 ;...
'Q22 '      'PS-QFA-3-2:CURRENT_MONITOR '     'PS-QFA-3-2:CURRENT_SP '   1    [2,1]    2     -1.73/85.36   [0,15]   0.05    0.05 ;...
'Q31 '      'PS-QFB-3-1:CURRENT_MONITOR '     'PS-QFB-3-1:CURRENT_SP '   1    [1,2]    3      2.03/113.66  [0,15]   0.05    0.05 ;...
'Q32 '      'PS-QFA-3-3:CURRENT_MONITOR '     'PS-QFA-3-3:CURRENT_SP '   1    [2,2]    4     -2.55/125.58  [0,15]   0.05    0.05 ;...
'Q33 '      'PS-QFA-3-4:CURRENT_MONITOR '     'PS-QFA-3-4:CURRENT_SP '   1    [1,3]    5      1.53/75.79   [0,15]   0.05    0.05 ;...
'Q41 '      'PS-QFA-3-5:CURRENT_MONITOR '     'PS-QFA-3-5:CURRENT_SP '   1    [2,3]    6     -1.13/55.69   [0,15]   0.05    0.05 ;...
'Q42 '      'PS-QFA-3-6:CURRENT_MONITOR '     'PS-QFA-3-6:CURRENT_SP '   1    [1,4]    7      1.67/82.36   [0,15]   0.05    0.05 ;...
'Q43 '      'PS-QFA-3-7:CURRENT_MONITOR '     'PS-QFA-3-7:CURRENT_SP '   1    [3,4]    8     -2.66/131.14  [0,15]   0.05    0.05 ;...
'Q44 '      'PS-QFB-3-2:CURRENT_MONITOR '     'PS-QFB-3-2:CURRENT_SP '   1    [4,1]    9      2.38/134.16  [0,15]   0.05    0.05 ;...
'Q51 '      'PS-QFB-3-3:CURRENT_MONITOR '     'PS-QFB-3-3:CURRENT_SP '   1    [4,2]   10     -2.14/114.10  [0,15]   0.05    0.05 ;...
'Q52 '      'PS-QFC-3-1:CURRENT_MONITOR '     'PS-QFC-3-1:CURRENT_SP '   1    [4,3]   11      2.06/113.86  [0,15]   0.05    0.05 ;...
'Q53 '      'PS-QFA-3-8:CURRENT_MONITOR '     'PS-QFA-3-8:CURRENT_SP '   1    [4,3]   12      0.55/27.42   [0,15]   0.05    0.05 ;...
};
for ii=1:size(BTS_Q,1)
name=BTS_Q{ii,1};      AO.BTS_Q.CommonNames(ii,:)           = name;            
name=BTS_Q{ii,2};      AO.BTS_Q.Monitor.ChannelNames(ii,:)  = name;
name=BTS_Q{ii,3};      AO.BTS_Q.Setpoint.ChannelNames(ii,:) = name;     
val =BTS_Q{ii,4};      AO.BTS_Q.Status(ii,1)                = val;
val =BTS_Q{ii,5};      AO.BTS_Q.DeviceList(ii,:)            = val;
val =BTS_Q{ii,6};      AO.BTS_Q.ElementList(ii,1)           = val;
val =BTS_Q{ii,7};      AO.BTS_Q.Monitor.HW2PhysicsParams(ii,:) = val;
                       AO.BTS_Q.Monitor.Physics2HWParams(ii,:) = 1/val;
                       AO.BTS_Q.Setpoint.HW2PhysicsParams(ii,:)= val;
                       AO.BTS_Q.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =BTS_Q{ii,8};      AO.BTS_Q.Setpoint.Range(ii,:)        = val;
val =BTS_Q{ii,9};      AO.BTS_Q.Setpoint.Tolerance(ii,1)    = val;
val =BTS_Q{ii,10};     AO.BTS_Q.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end BTS QUADS ***


% dipoles
% *** BTS BENDS ***
AO.BTS_BEND.FamilyName                 = 'BTS_BEND'; dispobject(AO,AO.BTS_BEND.FamilyName);
AO.BTS_BEND.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet'; 'BTS';};

AO.BTS_BEND.Monitor.Mode               = Mode;
AO.BTS_BEND.Monitor.DataType           = 'Scalar';
AO.BTS_BEND.Monitor.Units              = 'Hardware';
AO.BTS_BEND.Monitor.HWUnits            = 'ampere';           
AO.BTS_BEND.Monitor.PhysicsUnits       = 'energy';

AO.BTS_BEND.Setpoint.Mode              = Mode;
AO.BTS_BEND.Setpoint.DataType          = 'Scalar';
AO.BTS_BEND.Setpoint.Units             = 'Hardware';
AO.BTS_BEND.Setpoint.HWUnits           = 'ampere';           
AO.BTS_BEND.Setpoint.PhysicsUnits      = 'energy';
%                                                                                                        
%common   monitor                       setpoint                stat devlist elem   hw2physics    range     tol    respkick
BTS_BEND={
'BA  '	  'PS-SEP-A-3:CURRENT_MONITOR'	'PS-SEP-A-3:CURRENT_SP'	1	 [1,1]   1	     1.0           [0, 500]  0.05   0.05	; ...
'B1  '	  'PS-BA-3-1:CURRENT_MONITOR '	'PS-BA-3-1:CURRENT_SP '	1	 [1,2]   2	     1.0           [0, 500]  0.05   0.05	; ...
'B2  '	  'PS-BA-3-2:CURRENT_MONITOR '	'PS-BA-3-2:CURRENT_SP '	1	 [1,3]	 3	     1.0           [0, 500]  0.05   0.05	; ...
'B3  '	  'PS-BA-3-3:CURRENT_MONITOR '	'PS-BA-3-3:CURRENT_SP '	1	 [1,4]	 4	     1.0           [0, 500]  0.05   0.05	; ...
'B4  '	  'PS-BA-3-4:CURRENT_MONITOR '	'PS-BA-3-4:CURRENT_SP '	1	 [1,5]	 5	     1.0           [0, 500]  0.05   0.05	; ...
'BB  '	  'PS-SEP-B-3:CURRENT_MONITOR'	'PS-SEP-B-3:CURRENT_SP'	1	 [1,6]	 6	     1.0           [0, 500]  0.05   0.05	; ...
}; 

for ii=1:size(BTS_BEND,1)
name=BTS_BEND{ii,1};      AO.BTS_BEND.CommonNames(ii,:)           = name;            
name=BTS_BEND{ii,2};      AO.BTS_BEND.Monitor.ChannelNames(ii,:)  = name;
name=BTS_BEND{ii,3};      AO.BTS_BEND.Setpoint.ChannelNames(ii,:) = name;     
val =BTS_BEND{ii,4};      AO.BTS_BEND.Status(ii,1)                = val;
val =BTS_BEND{ii,5};      AO.BTS_BEND.DeviceList(ii,:)            = val;
val =BTS_BEND{ii,6};      AO.BTS_BEND.ElementList(ii,1)           = val;
val =BTS_BEND{ii,7};      AO.BTS_BEND.Monitor.HW2PhysicsParams(ii,:) = val;
                          AO.BTS_BEND.Monitor.Physics2HWParams(ii,:) = 1/val;
                          AO.BTS_BEND.Setpoint.HW2PhysicsParams(ii,:)= val;
                          AO.BTS_BEND.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =BTS_BEND{ii,8};      AO.BTS_BEND.Setpoint.Range(ii,:)        = val;
val =BTS_BEND{ii,9};      AO.BTS_BEND.Setpoint.Tolerance(ii,1)    = val;
val =BTS_BEND{ii,10};     AO.BTS_BEND.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end BTS BENDS ***


% *** BTS SEE ***
% extraction septum
AO.BTS_SEE.FamilyName                     = 'BTS_SEE'; dispobject(AO,AO.BTS_SEE.FamilyName);
AO.BTS_SEE.MemberOf                       = {'Injection'; 'BTS';};

AO.BTS_SEE.Monitor.Mode                   = Mode;
AO.BTS_SEE.Monitor.DataType               = 'Scalar';
AO.BTS_SEE.Monitor.Units                  = 'Hardware';
AO.BTS_SEE.Monitor.HWUnits                = 'Volts';           
AO.BTS_SEE.Monitor.PhysicsUnits           = 'mradian';

AO.BTS_SEE.Setpoint.Mode                  = Mode;
AO.BTS_SEE.Setpoint.DataType              = 'Scalar';
AO.BTS_SEE.Setpoint.Units                 = 'Hardware';
AO.BTS_SEE.Setpoint.HWUnits               = 'Volts';           
AO.BTS_SEE.Setpoint.PhysicsUnits          = 'mradian';

hw2physics_conversionfactor = 1;

%common     monitor                        setpoint                stat  devlist elem range    tol
BTS_SEE={
'SEE'      'PS-SEE-2:CURRENT_MONITOR'     'PS-SEE-2:CURRENT_SP'   1     [1,1]   1    [0,800]  0.05;...   
};
for ii=1:size(BTS_SEE,1)
name=BTS_SEE{ii,1};     AO.BTS_SEE.CommonNames(ii,:)          = name;            
name=BTS_SEE{ii,2};     AO.BTS_SEE.Monitor.ChannelNames(ii,:) = name; 
name=BTS_SEE{ii,3};     AO.BTS_SEE.Setpoint.ChannelNames(ii,:)= name;     
val =BTS_SEE{ii,4};     AO.BTS_SEE.Status(ii,1)               = val;
val =BTS_SEE{ii,5};     AO.BTS_SEE.DeviceList(ii,:)           = val;
val =BTS_SEE{ii,6};     AO.BTS_SEE.ElementList(ii,1)          = val;
val =BTS_SEE{ii,7};     AO.BTS_SEE.Setpoint.Range(ii,:)       = val;
val =BTS_SEE{ii,8};     AO.BTS_SEE.Setpoint.Tolerance(ii,1)   = val;

AO.BTS_SEE.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
AO.BTS_SEE.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
end


% *** BTS COR ***
%
% Vertical Correctors
%
% For calibration just using the scale factor now, not magnetcoeffcients.m
% - markjb 7/7/2006
AO.BTS_VCOR.FamilyName               = 'BTS_VCOR'; dispobject(AO,AO.BTS_VCOR.FamilyName);
AO.BTS_VCOR.MemberOf                 = {'MachineConfig'; 'COR'; 'Magnet'; 'BTS';};

AO.BTS_VCOR.Monitor.Mode             = Mode;
AO.BTS_VCOR.Monitor.DataType         = 'Scalar';
AO.BTS_VCOR.Monitor.Units            = 'Hardware';
AO.BTS_VCOR.Monitor.HWUnits          = 'ampere';           
AO.BTS_VCOR.Monitor.PhysicsUnits     = 'radian';


AO.BTS_VCOR.Setpoint.Mode            = Mode;
AO.BTS_VCOR.Setpoint.DataType        = 'Scalar';
AO.BTS_VCOR.Setpoint.Units           = 'Hardware';
AO.BTS_VCOR.Setpoint.HWUnits         = 'ampere';           
AO.BTS_VCOR.Setpoint.PhysicsUnits    = 'radian';

%common                    monitor              setpoint           stat devlist elem   hw2physics    range    tol   respkick
BTS_VCOR={
'VCOR1'     'PS-OC-3-1:CURRENT_MONITOR'  'PS-OC-3-1:CURRENT_SP'    1    [1,1]    1     1             [0,15]   0.05   0.05;...   
'VCOR2'     'PS-OC-3-2:CURRENT_MONITOR'  'PS-OC-3-2:CURRENT_SP'    1    [1,2]    2     1             [0,15]   0.05   0.05;...   
'VCOR3'     'PS-OC-3-3:CURRENT_MONITOR'  'PS-OC-3-3:CURRENT_SP'    1    [1,3]    3     1             [0,15]   0.05   0.05;...   
'VCOR4'     'PS-OC-3-4:CURRENT_MONITOR'  'PS-OC-3-4:CURRENT_SP'    1    [1,4]    4     1             [0,15]   0.05   0.05;...   
'VCOR4'     'PS-OC-3-5:CURRENT_MONITOR'  'PS-OC-3-5:CURRENT_SP'    1    [1,5]    5     1             [0,15]   0.05   0.05;...   
};

for ii=1:size(BTS_VCOR,1)
name=BTS_VCOR{ii,1};     AO.BTS_VCOR.CommonNames(ii,:)           = name;            
name=BTS_VCOR{ii,3};     AO.BTS_VCOR.Setpoint.ChannelNames(ii,:) = name;     
name=BTS_VCOR{ii,2};     AO.BTS_VCOR.Monitor.ChannelNames(ii,:)  = name;
val =BTS_VCOR{ii,4};     AO.BTS_VCOR.Status(ii,1)                = val;

val =BTS_VCOR{ii,5};     AO.BTS_VCOR.DeviceList(ii,:)            = val;
val =BTS_VCOR{ii,6};     AO.BTS_VCOR.ElementList(ii,1)           = val;
val =BTS_VCOR{ii,7};     AO.BTS_VCOR.Monitor.HW2PhysicsParams(ii,:) = val;
                         AO.BTS_VCOR.Monitor.Physics2HWParams(ii,:) = 1/val;
                         AO.BTS_VCOR.Setpoint.HW2PhysicsParams(ii,:)= val;
                         AO.BTS_VCOR.Setpoint.Physics2HWParams(ii,:)= 1/val;
val =BTS_VCOR{ii,8};     AO.BTS_VCOR.Setpoint.Range(ii,:)        = val;
val =BTS_VCOR{ii,9};     AO.BTS_VCOR.Setpoint.Tolerance(ii,1)    = val;
val =BTS_VCOR{ii,10};    AO.BTS_VCOR.Setpoint.DeltaRespMat(ii,1) = val;
end
% *** end BTS COR ***


% *** BTS SEP & SEI  ***
% pre-septum and injection septum
AO.BTS_SEI.FamilyName                     = 'BTS_SEI'; dispobject(AO,AO.BTS_SEI.FamilyName);
AO.BTS_SEI.MemberOf                       = {'Injection'; 'BTS';};

AO.BTS_SEI.Monitor.Mode                   = Mode;
AO.BTS_SEI.Monitor.DataType               = 'Scalar';
AO.BTS_SEI.Monitor.Units                  = 'Hardware';
AO.BTS_SEI.Monitor.HWUnits                = 'Volts';           
AO.BTS_SEI.Monitor.PhysicsUnits           = 'mradian';

AO.BTS_SEI.Setpoint.Mode                  = Mode;
AO.BTS_SEI.Setpoint.DataType              = 'Scalar';
AO.BTS_SEI.Setpoint.Units                 = 'Hardware';
AO.BTS_SEI.Setpoint.HWUnits               = 'Volts';           
AO.BTS_SEI.Setpoint.PhysicsUnits          = 'mradian';

hw2physics_conversionfactor = 1;

%common     monitor                        setpoint                stat  devlist elem range    tol
BTS_SEI={
'SEP'      'PS-SEP-3:CURRENT_MONITOR'     'PS-SEP-3:CURRENT_SP'   1     [1,1]   1    [0,800]  0.05;...   
'SEI'      'PS-SEI-3:CURRENT_MONITOR'     'PS-SEI-3:CURRENT_SP'   1     [1,1]   1    [0,800]  0.05;...   
};
for ii=1:size(BTS_SEI,1)
name=BTS_SEI{ii,1};     AO.BTS_SEI.CommonNames(ii,:)          = name;            
name=BTS_SEI{ii,2};     AO.BTS_SEI.Monitor.ChannelNames(ii,:) = name; 
name=BTS_SEI{ii,3};     AO.BTS_SEI.Setpoint.ChannelNames(ii,:)= name;     
val =BTS_SEI{ii,4};     AO.BTS_SEI.Status(ii,1)               = val;
val =BTS_SEI{ii,5};     AO.BTS_SEI.DeviceList(ii,:)           = val;
val =BTS_SEI{ii,6};     AO.BTS_SEI.ElementList(ii,1)          = val;
val =BTS_SEI{ii,7};     AO.BTS_SEI.Setpoint.Range(ii,:)       = val;
val =BTS_SEI{ii,8};     AO.BTS_SEI.Setpoint.Tolerance(ii,1)   = val;

AO.BTS_SEI.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
AO.BTS_SEI.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
end

%--------------- END OF BTS ------------



%%%%%%%%%%%%%%%%%%%%%%
% Machine Parameters %
%%%%%%%%%%%%%%%%%%%%%%


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
fprintf('\n');
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


%%%%%%%%%%%%%%%%
% DeltaRespMat %
%%%%%%%%%%%%%%%%

% Set response matrix kick size in hardware units (amps)
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', .15e-3 / 3, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', .15e-3 / 3, AO.VCM.DeviceList);


AO.QF.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QF.FamilyName, 'Setpoint', AO.QF.Setpoint.DeltaRespMat, AO.QF.DeviceList);
AO.QD.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QD.FamilyName, 'Setpoint', AO.QD.Setpoint.DeltaRespMat, AO.QD.DeviceList);


AO.SF.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SF.FamilyName, 'Setpoint', AO.SF.Setpoint.DeltaRespMat, AO.SF.DeviceList);
AO.SD.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SD.FamilyName, 'Setpoint', AO.SD.Setpoint.DeltaRespMat, AO.SD.DeviceList);


% Save AO
setao(AO);



% The middle creates directories as needed (GJP).
% function checkDIR(AD)
% 
% dirfields = fieldnames(AD.Directory);
% for i=1:length(dirfields)
%     if exist(AD.Directory.(dirfields{i}),'dir') == 0
%         a = input([strrep(AD.Directory.(dirfields{i}),'\', '\\') ' does not exist. Create y/(n)? '],'s');
%         if strcmpi(a,'y')
%             currdir = pwd;
%             [a b] = strtok(AD.Directory.(dirfields{i}),filesep);
%             mkdir(a,b);
%         end
%     end
% end


function dispobject(AO,name)

n = length(fieldnames(AO));

if n > 0
    fprintf('  %10s  ',name);
    if mod(n,5) == 0
        fprintf('\n');
    end
end