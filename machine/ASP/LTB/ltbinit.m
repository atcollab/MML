function asbosterinit(OperationalMode)
% aspinit(OperationalMode)
%
% Initialize parameters for AS Booster control in MATLAB
%
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% CommonNames           Shortcut name for each element (optional)
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet center
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
AO.LTB_HCOR.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'Magnet'; 'LTB'; 'HCM'};

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
AO.LTB_VCOR.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'Magnet'; 'LTB';'VCM'};

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
AO.LTB_BEND.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet'; 'LTB';};

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
AO.LTB_Q.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'LTB';};

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


% %==================
% %Machine Parameters
% %==================


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using ...ATIndex(:,1) will accomodata for split elements where the first
% of a group of elements is put in the first column ie, if SF is split in
% two then ATIndex will look like [2 3; 11 12; ...] where each row is a
% magnet and column represents each split.
global THERING
    AO.LTB_BEND.Position = findspos(THERING, AO.LTB_BEND.AT.ATIndex(:,1))';
    AO.LTB_Q.Position = findspos(THERING, AO.LTB_Q.AT.ATIndex(:,1))';
    AO.LTB_HCOR.Position = findspos(THERING, AO.LTB_HCOR.AT.ATIndex(:,1))';
    AO.LTB_VCOR.Position = findspos(THERING, AO.LTB_VCOR.AT.ATIndex(:,1))';
    AO.LTB_SEPI.Position = findspos(THERING, AO.LTB_SEPI.AT.ATIndex(:,1))';
    AO.LTB_KI.Position = findspos(THERING, AO.LTB_KI.AT.ATIndex(:,1))';

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