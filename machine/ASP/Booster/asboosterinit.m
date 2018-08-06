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
'1BPMx1  '	'BPM01:HPOS_MONITOR   '	1	'1BPMy1  '	'BPM01:VPOS_MONITOR   '	1	[1,1]	1	; ...
'1BPMx2  '	'BPM02:HPOS_MONITOR   '	1	'1BPMy2  '	'BPM02:VPOS_MONITOR   '	1	[1,2]	2	; ...
'1BPMx3  '	'BPM03:HPOS_MONITOR   '	1	'1BPMy3  '	'BPM03:VPOS_MONITOR   '	1	[1,3]	3	; ...
'1BPMx4  '	'BPM04:HPOS_MONITOR   '	1	'1BPMy4  '	'BPM04:VPOS_MONITOR   '	1	[1,4]	4	; ...
'1BPMx5  '	'BPM05:HPOS_MONITOR   '	1	'1BPMy5  '	'BPM05:VPOS_MONITOR   '	1	[1,5]	5	; ...
'1BPMx6  '	'BPM06:HPOS_MONITOR   '	1	'1BPMy6  '	'BPM06:VPOS_MONITOR   '	1	[1,6]	6	; ...
'1BPMx7  '	'BPM07:HPOS_MONITOR   '	1	'1BPMy7  '	'BPM07:VPOS_MONITOR   '	1	[1,7]	7	; ...
'1BPMx8  '	'BPM08:HPOS_MONITOR   '	1	'1BPMy8  '	'BPM08:VPOS_MONITOR   '	1	[1,8]	8	; ...
'2BPMx1  '	'BPM09:HPOS_MONITOR   '	1	'2BPMy1  '	'BPM09:VPOS_MONITOR   '	1	[2,1]	9	; ...
'2BPMx2  '	'BPM10:HPOS_MONITOR   '	1	'2BPMy2  '	'BPM10:VPOS_MONITOR   '	1	[2,2]	10	; ...
'2BPMx3  '	'BPM11:HPOS_MONITOR   '	1	'2BPMy3  '	'BPM11:VPOS_MONITOR   '	1	[2,3]	11	; ...
'2BPMx4  '	'BPM12:HPOS_MONITOR   '	1	'2BPMy4  '	'BPM12:VPOS_MONITOR   '	1	[2,4]	12	; ...
'2BPMx5  '	'BPM13:HPOS_MONITOR   '	1	'2BPMy5  '	'BPM13:VPOS_MONITOR   '	1	[2,5]	13	; ...
'2BPMx6  '	'BPM14:HPOS_MONITOR   '	1	'2BPMy6  '	'BPM14:VPOS_MONITOR   '	1	[2,6]	14	; ...
'2BPMx7  '	'BPM15:HPOS_MONITOR   '	1	'2BPMy7  '	'BPM15:VPOS_MONITOR   '	1	[2,7]	15	; ...
'2BPMx8  '	'BPM16:HPOS_MONITOR   '	1	'2BPMy8  '	'BPM16:VPOS_MONITOR   '	1	[2,8]	16	; ...
'3BPMx1  '	'BPM17:HPOS_MONITOR   '	1	'3BPMy1  '	'BPM17:VPOS_MONITOR   '	1	[3,1]	17	; ...
'3BPMx2  '	'BPM18:HPOS_MONITOR   '	1	'3BPMy2  '	'BPM18:VPOS_MONITOR   '	1	[3,2]	18	; ...
'3BPMx3  '	'BPM19:HPOS_MONITOR   '	1	'3BPMy3  '	'BPM19:VPOS_MONITOR   '	1	[3,3]	19	; ...
'3BPMx4  '	'BPM20:HPOS_MONITOR   '	1	'3BPMy4  '	'BPM20:VPOS_MONITOR   '	1	[3,4]	20	; ...
'3BPMx5  '	'BPM21:HPOS_MONITOR   '	1	'3BPMy5  '	'BPM21:VPOS_MONITOR   '	1	[3,5]	21	; ...
'3BPMx6  '	'BPM22:HPOS_MONITOR   '	1	'3BPMy6  '	'BPM22:VPOS_MONITOR   '	1	[3,6]	22	; ...
'3BPMx7  '	'BPM23:HPOS_MONITOR   '	1	'3BPMy7  '	'BPM23:VPOS_MONITOR   '	1	[3,7]	23	; ...
'3BPMx8  '	'BPM24:HPOS_MONITOR   '	1	'3BPMy8  '	'BPM24:VPOS_MONITOR   '	1	[3,8]	24	; ...
'4BPMx1  '	'BPM25:HPOS_MONITOR   '	1	'4BPMy1  '	'BPM25:VPOS_MONITOR   '	1	[4,1]	25	; ...
'4BPMx2  '	'BPM26:HPOS_MONITOR   '	1	'4BPMy2  '	'BPM26:VPOS_MONITOR   '	1	[4,2]	26	; ...
'4BPMx3  '	'BPM27:HPOS_MONITOR   '	1	'4BPMy3  '	'BPM27:VPOS_MONITOR   '	1	[4,3]	27	; ...
'4BPMx4  '	'BPM28:HPOS_MONITOR   '	1	'4BPMy4  '	'BPM28:VPOS_MONITOR   '	1	[4,4]	28	; ...
'4BPMx5  '	'BPM29:HPOS_MONITOR   '	1	'4BPMy5  '	'BPM29:VPOS_MONITOR   '	1	[4,5]	29	; ...
'4BPMx6  '	'BPM30:HPOS_MONITOR   '	1	'4BPMy6  '	'BPM30:VPOS_MONITOR   '	1	[4,6]	30	; ...
'4BPMx3  '	'BPM31:HPOS_MONITOR   '	1	'4BPMy7  '	'BPM31:VPOS_MONITOR   '	1	[4,7]	31	; ...
'4BPMx8  '	'BPM32:HPOS_MONITOR   '	1	'4BPMy8  '	'BPM32:VPOS_MONITOR   '	1	[4,8]	32	; ...
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
'1HCM1   '	'PS-OCH-B-2-1:CURRENT_MONITOR '	'PS-OCH-B-2-1:CURRENT_SP      '	1	[1,1]	1	[-10, +10]  1  1.5e-4 	; ...
'1HCM2   '	'PS-OCH-B-2-2:CURRENT_MONITOR '	'PS-OCH-B-2-2:CURRENT_SP      '	1	[1,2]	2	[-10, +10]  1  1.5e-4 	; ...
'1HCM3   '	'PS-OCH-B-2-3:CURRENT_MONITOR '	'PS-OCH-B-2-3:CURRENT_SP      '	1	[1,3]	3	[-10, +10]  1  1.5e-4 	; ...
'1HCM4   '	'PS-OCH-B-2-4:CURRENT_MONITOR '	'PS-OCH-B-2-4:CURRENT_SP      '	1	[1,4]	4	[-10, +10]  1  1.5e-4 	; ...
'1HCM5   '	'PS-OCH-B-2-5:CURRENT_MONITOR '	'PS-OCH-B-2-5:CURRENT_SP      '	1	[1,5]	5	[-10, +10]  1  1.5e-4 	; ...
'1HCM6   '	'PS-OCH-B-2-6:CURRENT_MONITOR '	'PS-OCH-B-2-6:CURRENT_SP      '	1	[1,6]	6	[-10, +10]  1  1.5e-4 	; ...
'2HCM1   '	'PS-OCH-B-2-7:CURRENT_MONITOR '	'PS-OCH-B-2-7:CURRENT_SP      '	1	[1,7]	7	[-10, +10]  1  1.5e-4 	; ...
'2HCM2   '	'PS-OCH-B-2-8:CURRENT_MONITOR '	'PS-OCH-B-2-8:CURRENT_SP      '	1	[1,8]	8	[-10, +10]  1  1.5e-4 	; ...
'2HCM3   '	'PS-OCH-B-2-9:CURRENT_MONITOR '	'PS-OCH-B-2-9:CURRENT_SP      '	1	[1,9]	9	[-10, +10]  1  1.5e-4 	; ...
'2HCM4   '	'PS-OCH-B-2-10:CURRENT_MONITOR'	'PS-OCH-B-2-10:CURRENT_SP     '	1	[1,10]	10	[-10, +10]  1  1.5e-4 	; ...
'2HCM5   '	'PS-OCH-B-2-11:CURRENT_MONITOR'	'PS-OCH-B-2-11:CURRENT_SP     '	1	[1,11]	11	[-10, +10]  1  1.5e-4 	; ...
'2HCM6   '	'PS-OCH-B-2-12:CURRENT_MONITOR'	'PS-OCH-B-2-12:CURRENT_SP     '	1	[1,12]	12	[-10, +10]  1  1.5e-4 	; ...
'3HCM1   '	'PS-OCH-B-2-13:CURRENT_MONITOR'	'PS-OCH-B-2-13:CURRENT_SP     '	1	[1,13]	13	[-10, +10]  1  1.5e-4 	; ...
'3HCM2   '	'PS-OCH-B-2-14:CURRENT_MONITOR'	'PS-OCH-B-2-14:CURRENT_SP     '	1	[1,14]	14	[-10, +10]  1  1.5e-4 	; ...
'3HCM3   '	'PS-OCH-B-2-15:CURRENT_MONITOR'	'PS-OCH-B-2-15:CURRENT_SP     '	1	[1,15]	15	[-10, +10]  1  1.5e-4 	; ...
'3HCM4   '	'PS-OCH-B-2-16:CURRENT_MONITOR'	'PS-OCH-B-2-16:CURRENT_SP     '	1	[1,16]	16	[-10, +10]  1  1.5e-4 	; ...
'3HCM5   '	'PS-OCH-B-2-17:CURRENT_MONITOR'	'PS-OCH-B-2-17:CURRENT_SP     '	1	[1,17]	17	[-10, +10]  1  1.5e-4 	; ...
'3HCM6   '	'PS-OCH-B-2-18:CURRENT_MONITOR'	'PS-OCH-B-2-18:CURRENT_SP     '	1	[1,18]	18	[-10, +10]  1  1.5e-4 	; ...
'4HCM1   '	'PS-OCH-B-2-19:CURRENT_MONITOR'	'PS-OCH-B-2-19:CURRENT_SP     '	1	[1,19]	19	[-10, +10]  1  1.5e-4 	; ...
'4HCM2   '	'PS-OCH-B-2-20:CURRENT_MONITOR'	'PS-OCH-B-2-20:CURRENT_SP     '	1	[1,20]	20	[-10, +10]  1  1.5e-4 	; ...
'4HCM3   '	'PS-OCH-B-2-21:CURRENT_MONITOR'	'PS-OCH-B-2-21:CURRENT_SP     '	1	[1,21]	21	[-10, +10]  1  1.5e-4 	; ...
'4HCM4   '	'PS-OCH-B-2-22:CURRENT_MONITOR'	'PS-OCH-B-2-22:CURRENT_SP     '	1	[1,22]	22	[-10, +10]  1  1.5e-4 	; ...
'4HCM5   '	'PS-OCH-B-2-23:CURRENT_MONITOR'	'PS-OCH-B-2-23:CURRENT_SP     '	1	[1,23]	23	[-10, +10]  1  1.5e-4 	; ...
'4HCM6   '	'PS-OCH-B-2-24:CURRENT_MONITOR'	'PS-OCH-B-2-24:CURRENT_SP     '	1	[1,24]	24	[-10, +10]  1  1.5e-4 	; ...
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
'1VCM1   '	'PS-OCV-B-2-1:CURRENT_MONITOR  '	'PS-OCV-B-2-1:CURRENT_SP      '	1	[1,1]	1	[-10, +10]  1  1.5e-4	; ...
'1VCM2   '	'PS-OCV-B-2-2:CURRENT_MONITOR  '	'PS-OCV-B-2-2:CURRENT_SP      '	1	[1,2]	2	[-10, +10]  1  1.5e-4	; ...
'1VCM3   '	'PS-OCV-B-2-3:CURRENT_MONITOR  '	'PS-OCV-B-2-3:CURRENT_SP      '	1	[1,3]	3	[-10, +10]  1  1.5e-4	; ...
'2VCM1   '	'PS-OCV-B-2-4:CURRENT_MONITOR  '	'PS-OCV-B-2-4:CURRENT_SP      '	1	[1,4]	4	[-10, +10]  1  1.5e-4	; ...
'2VCM2   '	'PS-OCV-B-2-5:CURRENT_MONITOR  '	'PS-OCV-B-2-5:CURRENT_SP      '	1	[1,5]	5	[-10, +10]  1  1.5e-4	; ...
'2VCM3   '	'PS-OCV-E-2-01:CURRENT_MONITOR '	'PS-OCV-E-2-01:CURRENT_SP     '	1	[1,6]	6	[-10, +10]  1  1.5e-4	; ...
'3VCM1   '	'PS-OCV-B-2-6:CURRENT_MONITOR  '	'PS-OCV-B-2-6:CURRENT_SP      '	1	[1,7]	7	[-10, +10]  1  1.5e-4	; ...
'3VCM2   '	'PS-OCV-B-2-7:CURRENT_MONITOR  '	'PS-OCV-B-2-7:CURRENT_SP      '	1	[1,8]	8	[-10, +10]  1  1.5e-4	; ...
'3VCM3   '	'PS-OCV-B-2-8:CURRENT_MONITOR  '	'PS-OCV-B-2-8:CURRENT_SP      '	1	[1,9]	9	[-10, +10]  1  1.5e-4	; ...
'4VCM1   '	'PS-OCV-B-2-09:CURRENT_MONITOR '	'PS-OCV-B-2-09:CURRENT_SP     '	1	[1,10]	10	[-10, +10]  1  1.5e-4	; ...
'4VCM2   '	'PS-OCV-B-2-10:CURRENT_MONITOR '	'PS-OCV-B-2-10:CURRENT_SP     '	1	[1,11]	11	[-10, +10]  1  1.5e-4	; ...
'4VCM3   '	'PS-OCV-B-2-11:CURRENT_MONITOR '	'PS-OCV-B-2-11:CURRENT_SP     '	1	[1,12]	12	[-10, +10]  1  1.5e-4	; ...
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
AO.BEND.Monitor.HW2PhysicsFcn      = @bend2gev;
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
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[1,1]	1	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,2]	2	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[1,3]	3	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,4]	4	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[1,5]	5	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,6]	6	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,7]	7	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,8]	8	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,9]	9	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,10]	10  1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,11]	11	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,12]	12	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,13]	13	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[1,14]	14	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[1,15]	15	1.0        [0, 500]  0.05   0.05	; ...

'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,1]	16	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,2]	17	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,3]	18	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,4]	19	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,5]	20	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,6]	21  1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,7]	22	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,8]	23	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,9]	24	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,10]	25	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,11]	26	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,12]	27	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,13]	28	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[2,14]	29	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[2,15]	30	1.0        [0, 500]  0.05   0.05	; ...

'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[3,1]	31	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,2]	32	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[3,3]	33	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,4]	34	1.0305     [0, 500]  0.05   0.05	; ...
'BD2 '	'PS2-BD-2:CURRENT_MONITOR  '	'PS2-BD-2:CURRENT_SP      '	1	[3,5]	35	1.0        [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,6]	36	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[3,7]	37	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,8]	38	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[3,9]	39	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,10]	40	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[3,11]	41	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,12]	42	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[3,13]	43	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[3,14]	44	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[3,15]	45	1.0005     [0, 500]  0.05   0.05	; ...

'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,1]	46	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,2]	47	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,3]	48	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,4]	49	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,5]	50	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,6]	51	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,7]	52	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,8]	53	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,9]	54	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,10]	55	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,11]	56	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,12]	57	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,13]	58	1.0005     [0, 500]  0.05   0.05	; ...
'BF  '	'PS-BF-2:CURRENT_MONITOR   '	'PS-BF-2:CURRENT_SP       '	1	[4,14]	59	1.0305     [0, 500]  0.05   0.05	; ...
'BD1 '	'PS1-BD-2:CURRENT_MONITOR  '	'PS1-BD-2:CURRENT_SP      '	1	[4,15]	60	1.0005     [0, 500]  0.05   0.05	; ...
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
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[1,2]	2	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[2,1]	3	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[2,2]	4	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[3,1]	5	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[3,2]	6	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[4,1]	7	1.0   [0, 500] 0.05  0.05	; ...
'QF   '	'PS-QF-2:CURRENT_MONITOR'	'PS-QF-2:CURRENT_SP     '	1	[4,2]	8	1.0   [0, 500] 0.05  0.05	; ...
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
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[1,2]	2	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[2,1]	3	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[2,2]	4	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[3,1]	5	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[3,2]	6	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[4,1]	7	1.0   [-100, 100] 0.05  0.05	; ...
'QD  '	'PS-QD-2:CURRENT_MONITOR'	'PS-QD-2:CURRENT_SP     '	1	[4,2]	8	1.0   [-100, 100] 0.05  0.05	; ...
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
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[1,2]	2	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[2,1]	3	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[2,2]	4	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[3,1]	5	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[3,2]	6	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[4,1]	7	1.0   [0, 19] 0.05  0.05	; ...
'SF   '	'PS-SF-2:CURRENT_MONITOR'	'PS-SF-2:CURRENT_SP     '	1	[4,2]	8	1.0   [0, 19] 0.05  0.05	; ...
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
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[1,2]	2	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[2,1]	3	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[2,2]	4	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[3,1]	5	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[3,2]	6	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[4,1]	7	1.0   [-20, 20] 0.05  0.05	; ...
'SD   '	'PS-SD-2:CURRENT_MONITOR'	'PS-SD-2:CURRENT_SP     '	1	[4,2]	8	1.0   [-20, 20] 0.05  0.05	; ...
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
AO.TUNE.Position     = 0;

AO.TUNE.Monitor.Mode                   = Mode; 
AO.TUNE.Monitor.DataType               = 'Vector';
AO.TUNE.Monitor.DataTypeIndex          = [1 2 3]';
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';


% %====
% %DCCT
% %====
AO.DCCT.FamilyName                     = 'DCCT'; dispobject(AO,AO.DCCT.FamilyName);
AO.DCCT.MemberOf                       = {'Diagnostics'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = [1]';
AO.DCCT.Status                         = AO.DCCT.ElementList;
AO.DCCT.Position     = 0;

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = 'ASP:BeamCurrAvg';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;

%--------------- END OF BOOSTER ------------


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

% Set response matrix kick size in hardware units (amps)
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', .15e-3 / 3, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', .15e-3 / 3, AO.VCM.DeviceList);


AO.QF.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QF.FamilyName, 'Setpoint', AO.QF.Setpoint.DeltaRespMat, AO.QF.DeviceList);
AO.QFB.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QFB.FamilyName, 'Setpoint', AO.QFB.Setpoint.DeltaRespMat, AO.QFB.DeviceList);
AO.QD.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QD.FamilyName, 'Setpoint', AO.QD.Setpoint.DeltaRespMat, AO.QD.DeviceList);


AO.SF.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SF.FamilyName, 'Setpoint', AO.SF.Setpoint.DeltaRespMat, AO.SF.DeviceList);
AO.SFB.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SFB.FamilyName, 'Setpoint', AO.SFB.Setpoint.DeltaRespMat, AO.SFB.DeviceList);
AO.SD.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SD.FamilyName, 'Setpoint', AO.SD.Setpoint.DeltaRespMat, AO.SD.DeviceList);
AO.SDB.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SDB.FamilyName, 'Setpoint', AO.SDB.Setpoint.DeltaRespMat, AO.SDB.DeviceList);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using ...ATIndex(:,1) will accomodata for split elements where the first
% of a group of elements is put in the first column ie, if SF is split in
% two then ATIndex will look like [2 3; 11 12; ...] where each row is a
% magnet and column represents each split.
global THERING
AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex(:,1))';
AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex(:,1))';
AO.HCM.Position  = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';
AO.VCM.Position  = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
AO.QF.Position  = findspos(THERING, AO.QF.AT.ATIndex(:,1))';
AO.QD.Position  = findspos(THERING, AO.QD.AT.ATIndex(:,1))';
AO.SF.Position  = findspos(THERING, AO.SF.AT.ATIndex(:,1))';
AO.SD.Position  = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
AO.RF.Position   = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
AO.DCCT.Position = 0;
AO.TUNE.Position = 0;

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