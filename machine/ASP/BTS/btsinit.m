function btsinit(OperationalMode)
% btsinit(OperationalMode)
%
% Initialize parameters for BTS control in MATLAB
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


Mode = 'Online';  %'Simulator'; % This gets reset in setoperationalmode


%--------------- START OF BTS ------------


% *** BTS QUADS ***
AO.BTS_Q.FamilyName                 = 'BTS_Q'; 
dispobject(AO,AO.BTS_Q.FamilyName);
AO.BTS_Q.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'BTS';};

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
AO.BTS_BEND.FamilyName                 = 'BTS_BEND'; 
dispobject(AO,AO.BTS_BEND.FamilyName);
AO.BTS_BEND.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet'; 'BTS';};

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
AO.BTS_SEE.FamilyName                     = 'BTS_SEE'; 
dispobject(AO,AO.BTS_SEE.FamilyName);
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
BTS_SEE={'SEE'      'PS-SEE-2:CURRENT_MONITOR'     'PS-SEE-2:CURRENT_SP'   1     [1,1]   1    [0,800]  0.05;};
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


% *** BTS SEP & SEI  ***
% pre-septum and injection septum
AO.BTS_SEI.FamilyName                     = 'BTS_SEI'; 
dispobject(AO,AO.BTS_SEI.FamilyName);
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

% *** BTS COR ***
%
% Vertical Correctors
%
% For calibration just using the scale factor now, not magnetcoeffcients.m
% - markjb 7/7/2006
AO.BTS_VCOR.FamilyName               = 'BTS_VCOR'; 
dispobject(AO,AO.BTS_VCOR.FamilyName);
AO.BTS_VCOR.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'Magnet'; 'BTS'; 'VCM'};

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
% *** end LTB COR ***

%--------------- END OF BTS ------------


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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using ...ATIndex(:,1) will accomodata for split elements where the first
% of a group of elements is put in the first column ie, if SF is split in
% two then ATIndex will look like [2 3; 11 12; ...] where each row is a
% magnet and column represents each split.
global THERING

AO.BTS_SEE.Position  = findspos(THERING, AO.BTS_SEE.AT.ATIndex(:,1))';
AO.BTS_BEND.Position = findspos(THERING, AO.BTS_BEND.AT.ATIndex(:,1))';
AO.BTS_Q.Position    = findspos(THERING, AO.BTS_Q.AT.ATIndex(:,1))';

% Save AO
setao(AO);




function dispobject(AO,name)

n = length(fieldnames(AO));

if n > 0
    fprintf('  %10s  ',name);
    if mod(n,5) == 0
        fprintf('\n');
    end
end