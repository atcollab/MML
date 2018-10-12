function aspinit(OperationalMode)
% aspinit(OperationalMode)
%
% Initialize parameters for ASP control in MATLAB
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
%    HFC VFC          - fast corrector magnets wound into sextupoles (FOFB)
%    BEND             - gradient dipoles
%    QFA QDA QFB      - quadrupole magnets
%    SFA SDA SDB SFB  - sextupole magnets
%    SQK              - skew quads wound into SDA magnets
%    KICK             - injection kickers (DELTA type)
%    RF               - 4 cavities (KEK type?)
%    DCCT
%    Septum (Not in model yet)
%
%    Normal cell: d1 bpm s1 hcor d2 q1 d3 s2 d4 bpm dip bpm d4 hcor s3 d5 q2 d6 q3 d2 bpm s4
%                 d2 q3 d6 q2 d5 s3 hcor d4 bpm dip bpm d4 s2 d3 q1 d2 hcor s1 bpm d1

% === Change Log ===
% Mark Boland 2004-02-12
% Eugene Tan  2004-02-23
% Eugene Tan  2004-12-13
% Eugene Tan  2005-09-27 ver 4
%    Updated naming convention of the process variables, use version 4 of
%    the lattice "assr4.m" where the correctors have been merged into the
%    sextupoles. Made the necessary changes to updateatindex. Added skew
%    quadrupoles and updated generate_init.
% Mark Boland 2006-05-27
%   Changed the BPM PVs to ...:SA_X_MONITOR and ...:SA_Y_MONITOR
%
% Mark Boland 2006-08-29
%   Changed range on HCM and VCM from - to + since the polarity of the
%   correctors was physically changed in the last weeks.
% Eugene Tan 2015-09-07
%   Set sensible limits/Range for RF frequency and voltages. 
% Eugene Tan 2015-10-15
%   Added FOFB's HFC and VFC magnets

% === Still to do ===
% - kicker delays
% - BPM names and other possible PVs of interest eg. Q factor etc.
% - clean up and configure the amp2k and k2amp conversion. Control system
%   designed to calculate the strengths and amp values using calc records,
%   therefore we should only need to change the PV name to access for
%   readback at setpoints. Only problem will be in simulation/offline mode
%   where those value are not available online. How do you keep the offline
%   conversion factors up to date with online vals?
%
% === Generated from ===
% aspinit_v5skeleton.m



% When using the compiler add a line like, "%#function <function name>" for
% for special functions that hidden in strings.


% Default operational mode
if nargin < 1
    OperationalMode = 2;
end


%=============================================
% START DEFINITION OF ACCELERATOR OBJECTS
%=============================================
fprintf('   Defining the Accelerator Objects. Objects being defined:\n')


% Clear previous AcceleratorObjects
setao([]);   


Mode = 'Online';  % This gets reset in setoperationalmode

%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=98;
AO.BPMx.FamilyName               = 'BPMx'; dispobject(AO,AO.BPMx.FamilyName);
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMx'; 'Horizontal';};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'nm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy'; dispobject(AO,AO.BPMy.FamilyName);
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMy'; 'Vertical';};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'nm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name             x-chname              xstat y-name               y-chname           ystat DevList Elem
bpm={
'1BPMx1  '	'SR01BPM01:SA_X_MONITOR'	1	'1BPMy1  '	'SR01BPM01:SA_Y_MONITOR'	1	[1,1]	1	; ...
'1BPMx2  '	'SR01BPM02:SA_X_MONITOR'	1	'1BPMy2  '	'SR01BPM02:SA_Y_MONITOR'	1	[1,2]	2	; ...
'1BPMx3  '	'SR01BPM03:SA_X_MONITOR'	1	'1BPMy3  '	'SR01BPM03:SA_Y_MONITOR'	1	[1,3]	3	; ...
'1BPMx4  '	'SR01BPM04:SA_X_MONITOR'	1	'1BPMy4  '	'SR01BPM04:SA_Y_MONITOR'	1	[1,4]	4	; ...
'1BPMx5  '	'SR01BPM05:SA_X_MONITOR'	1	'1BPMy5  '	'SR01BPM05:SA_Y_MONITOR'	1	[1,5]	5	; ...
'1BPMx6  '	'SR01BPM06:SA_X_MONITOR'	1	'1BPMy6  '	'SR01BPM06:SA_Y_MONITOR'	1	[1,6]	6	; ...
'1BPMx7  '	'SR01BPM07:SA_X_MONITOR'	1	'1BPMy7  '	'SR01BPM07:SA_Y_MONITOR'	1	[1,7]	7	; ...
'2BPMx1  '	'SR02BPM01:SA_X_MONITOR'	1	'2BPMy1  '	'SR02BPM01:SA_Y_MONITOR'	1	[2,1]	8	; ...
'2BPMx2  '	'SR02BPM02:SA_X_MONITOR'	1	'2BPMy2  '	'SR02BPM02:SA_Y_MONITOR'	1	[2,2]	9	; ...
'2BPMx3  '	'SR02BPM03:SA_X_MONITOR'	1	'2BPMy3  '	'SR02BPM03:SA_Y_MONITOR'	1	[2,3]	10	; ...
'2BPMx4  '	'SR02BPM04:SA_X_MONITOR'	1	'2BPMy4  '	'SR02BPM04:SA_Y_MONITOR'	1	[2,4]	11	; ...
'2BPMx5  '	'SR02BPM05:SA_X_MONITOR'	1	'2BPMy5  '	'SR02BPM05:SA_Y_MONITOR'	1	[2,5]	12	; ...
'2BPMx6  '	'SR02BPM06:SA_X_MONITOR'	1	'2BPMy6  '	'SR02BPM06:SA_Y_MONITOR'	1	[2,6]	13	; ...
'2BPMx7  '	'SR02BPM07:SA_X_MONITOR'	1	'2BPMy7  '	'SR02BPM07:SA_Y_MONITOR'	1	[2,7]	14	; ...
'3BPMx1  '	'SR03BPM01:SA_X_MONITOR'	1	'3BPMy1  '	'SR03BPM01:SA_Y_MONITOR'	1	[3,1]	15	; ...
'3BPMx2  '	'SR03BPM02:SA_X_MONITOR'	1	'3BPMy2  '	'SR03BPM02:SA_Y_MONITOR'	1	[3,2]	16	; ...
'3BPMx3  '	'SR03BPM03:SA_X_MONITOR'	1	'3BPMy3  '	'SR03BPM03:SA_Y_MONITOR'	1	[3,3]	17	; ...
'3BPMx4  '	'SR03BPM04:SA_X_MONITOR'	1	'3BPMy4  '	'SR03BPM04:SA_Y_MONITOR'	1	[3,4]	18	; ...
'3BPMx5  '	'SR03BPM05:SA_X_MONITOR'	1	'3BPMy5  '	'SR03BPM05:SA_Y_MONITOR'	1	[3,5]	19	; ...
'3BPMx6  '	'SR03BPM06:SA_X_MONITOR'	1	'3BPMy6  '	'SR03BPM06:SA_Y_MONITOR'	1	[3,6]	20	; ...
'3BPMx7  '	'SR03BPM07:SA_X_MONITOR'	1	'3BPMy7  '	'SR03BPM07:SA_Y_MONITOR'	1	[3,7]	21	; ...
'4BPMx1  '	'SR04BPM01:SA_X_MONITOR'	1	'4BPMy1  '	'SR04BPM01:SA_Y_MONITOR'	1	[4,1]	22	; ...
'4BPMx2  '	'SR04BPM02:SA_X_MONITOR'	1	'4BPMy2  '	'SR04BPM02:SA_Y_MONITOR'	1	[4,2]	23	; ...
'4BPMx3  '	'SR04BPM03:SA_X_MONITOR'	1	'4BPMy3  '	'SR04BPM03:SA_Y_MONITOR'	1	[4,3]	24	; ...
'4BPMx4  '	'SR04BPM04:SA_X_MONITOR'	1	'4BPMy4  '	'SR04BPM04:SA_Y_MONITOR'	1	[4,4]	25	; ...
'4BPMx5  '	'SR04BPM05:SA_X_MONITOR'	1	'4BPMy5  '	'SR04BPM05:SA_Y_MONITOR'	1	[4,5]	26	; ...
'4BPMx6  '	'SR04BPM06:SA_X_MONITOR'	1	'4BPMy6  '	'SR04BPM06:SA_Y_MONITOR'	1	[4,6]	27	; ...
'4BPMx7  '	'SR04BPM07:SA_X_MONITOR'	1	'4BPMy7  '	'SR04BPM07:SA_Y_MONITOR'	1	[4,7]	28	; ...
'5BPMx1  '	'SR05BPM01:SA_X_MONITOR'	1	'5BPMy1  '	'SR05BPM01:SA_Y_MONITOR'	1	[5,1]	29	; ...
'5BPMx2  '	'SR05BPM02:SA_X_MONITOR'	1	'5BPMy2  '	'SR05BPM02:SA_Y_MONITOR'	1	[5,2]	30	; ...
'5BPMx3  '	'SR05BPM03:SA_X_MONITOR'	1	'5BPMy3  '	'SR05BPM03:SA_Y_MONITOR'	1	[5,3]	31	; ...
'5BPMx4  '	'SR05BPM04:SA_X_MONITOR'	1	'5BPMy4  '	'SR05BPM04:SA_Y_MONITOR'	1	[5,4]	32	; ...
'5BPMx5  '	'SR05BPM05:SA_X_MONITOR'	1	'5BPMy5  '	'SR05BPM05:SA_Y_MONITOR'	1	[5,5]	33	; ...
'5BPMx6  '	'SR05BPM06:SA_X_MONITOR'	1	'5BPMy6  '	'SR05BPM06:SA_Y_MONITOR'	1	[5,6]	34	; ...
'5BPMx7  '	'SR05BPM07:SA_X_MONITOR'	1	'5BPMy7  '	'SR05BPM07:SA_Y_MONITOR'	1	[5,7]	35	; ...
'6BPMx1  '	'SR06BPM01:SA_X_MONITOR'	1	'6BPMy1  '	'SR06BPM01:SA_Y_MONITOR'	1	[6,1]	36	; ...
'6BPMx2  '	'SR06BPM02:SA_X_MONITOR'	1	'6BPMy2  '	'SR06BPM02:SA_Y_MONITOR'	1	[6,2]	37	; ...
'6BPMx3  '	'SR06BPM03:SA_X_MONITOR'	1	'6BPMy3  '	'SR06BPM03:SA_Y_MONITOR'	1	[6,3]	38	; ...
'6BPMx4  '	'SR06BPM04:SA_X_MONITOR'	1	'6BPMy4  '	'SR06BPM04:SA_Y_MONITOR'	1	[6,4]	39	; ...
'6BPMx5  '	'SR06BPM05:SA_X_MONITOR'	1	'6BPMy5  '	'SR06BPM05:SA_Y_MONITOR'	1	[6,5]	40	; ...
'6BPMx6  '	'SR06BPM06:SA_X_MONITOR'	1	'6BPMy6  '	'SR06BPM06:SA_Y_MONITOR'	1	[6,6]	41	; ...
'6BPMx7  '	'SR06BPM07:SA_X_MONITOR'	1	'6BPMy7  '	'SR06BPM07:SA_Y_MONITOR'	1	[6,7]	42	; ...
'7BPMx1  '	'SR07BPM01:SA_X_MONITOR'	1	'7BPMy1  '	'SR07BPM01:SA_Y_MONITOR'	1	[7,1]	43	; ...
'7BPMx2  '	'SR07BPM02:SA_X_MONITOR'	1	'7BPMy2  '	'SR07BPM02:SA_Y_MONITOR'	1	[7,2]	44	; ...
'7BPMx3  '	'SR07BPM03:SA_X_MONITOR'	1	'7BPMy3  '	'SR07BPM03:SA_Y_MONITOR'	1	[7,3]	45	; ...
'7BPMx4  '	'SR07BPM04:SA_X_MONITOR'	1	'7BPMy4  '	'SR07BPM04:SA_Y_MONITOR'	1	[7,4]	46	; ...
'7BPMx5  '	'SR07BPM05:SA_X_MONITOR'	1	'7BPMy5  '	'SR07BPM05:SA_Y_MONITOR'	1	[7,5]	47	; ...
'7BPMx6  '	'SR07BPM06:SA_X_MONITOR'	1	'7BPMy6  '	'SR07BPM06:SA_Y_MONITOR'	1	[7,6]	48	; ...
'7BPMx7  '	'SR07BPM07:SA_X_MONITOR'	1	'7BPMy7  '	'SR07BPM07:SA_Y_MONITOR'	1	[7,7]	49	; ...
'8BPMx1  '	'SR08BPM01:SA_X_MONITOR'	1	'8BPMy1  '	'SR08BPM01:SA_Y_MONITOR'	1	[8,1]	50	; ...
'8BPMx2  '	'SR08BPM02:SA_X_MONITOR'	1	'8BPMy2  '	'SR08BPM02:SA_Y_MONITOR'	1	[8,2]	51	; ...
'8BPMx3  '	'SR08BPM03:SA_X_MONITOR'	1	'8BPMy3  '	'SR08BPM03:SA_Y_MONITOR'	1	[8,3]	52	; ...
'8BPMx4  '	'SR08BPM04:SA_X_MONITOR'	1	'8BPMy4  '	'SR08BPM04:SA_Y_MONITOR'	1	[8,4]	53	; ...
'8BPMx5  '	'SR08BPM05:SA_X_MONITOR'	1	'8BPMy5  '	'SR08BPM05:SA_Y_MONITOR'	1	[8,5]	54	; ...
'8BPMx6  '	'SR08BPM06:SA_X_MONITOR'	1	'8BPMy6  '	'SR08BPM06:SA_Y_MONITOR'	1	[8,6]	55	; ...
'8BPMx7  '	'SR08BPM07:SA_X_MONITOR'	1	'8BPMy7  '	'SR08BPM07:SA_Y_MONITOR'	1	[8,7]	56	; ...
'9BPMx1  '	'SR09BPM01:SA_X_MONITOR'	1	'9BPMy1  '	'SR09BPM01:SA_Y_MONITOR'	1	[9,1]	57	; ...
'9BPMx2  '	'SR09BPM02:SA_X_MONITOR'	1	'9BPMy2  '	'SR09BPM02:SA_Y_MONITOR'	1	[9,2]	58	; ...
'9BPMx3  '	'SR09BPM03:SA_X_MONITOR'	1	'9BPMy3  '	'SR09BPM03:SA_Y_MONITOR'	1	[9,3]	59	; ...
'9BPMx4  '	'SR09BPM04:SA_X_MONITOR'	1	'9BPMy4  '	'SR09BPM04:SA_Y_MONITOR'	1	[9,4]	60	; ...
'9BPMx5  '	'SR09BPM05:SA_X_MONITOR'	1	'9BPMy5  '	'SR09BPM05:SA_Y_MONITOR'	1	[9,5]	61	; ...
'9BPMx6  '	'SR09BPM06:SA_X_MONITOR'	1	'9BPMy6  '	'SR09BPM06:SA_Y_MONITOR'	1	[9,6]	62	; ...
'9BPMx7  '	'SR09BPM07:SA_X_MONITOR'	1	'9BPMy7  '	'SR09BPM07:SA_Y_MONITOR'	1	[9,7]	63	; ...
'10BPMx1 '	'SR10BPM01:SA_X_MONITOR'	1	'10BPMy1 '	'SR10BPM01:SA_Y_MONITOR'	1	[10,1]	64	; ...
'10BPMx2 '	'SR10BPM02:SA_X_MONITOR'	1	'10BPMy2 '	'SR10BPM02:SA_Y_MONITOR'	1	[10,2]	65	; ...
'10BPMx3 '	'SR10BPM03:SA_X_MONITOR'	1	'10BPMy3 '	'SR10BPM03:SA_Y_MONITOR'	1	[10,3]	66	; ...
'10BPMx4 '	'SR10BPM04:SA_X_MONITOR'	1	'10BPMy4 '	'SR10BPM04:SA_Y_MONITOR'	1	[10,4]	67	; ...
'10BPMx5 '	'SR10BPM05:SA_X_MONITOR'	1	'10BPMy5 '	'SR10BPM05:SA_Y_MONITOR'	1	[10,5]	68	; ...
'10BPMx6 '	'SR10BPM06:SA_X_MONITOR'	1	'10BPMy6 '	'SR10BPM06:SA_Y_MONITOR'	1	[10,6]	69	; ...
'10BPMx7 '	'SR10BPM07:SA_X_MONITOR'	1	'10BPMy7 '	'SR10BPM07:SA_Y_MONITOR'	1	[10,7]	70	; ...
'11BPMx1 '	'SR11BPM01:SA_X_MONITOR'	1	'11BPMy1 '	'SR11BPM01:SA_Y_MONITOR'	1	[11,1]	71	; ...
'11BPMx2 '	'SR11BPM02:SA_X_MONITOR'	1	'11BPMy2 '	'SR11BPM02:SA_Y_MONITOR'	1	[11,2]	72	; ...
'11BPMx3 '	'SR11BPM03:SA_X_MONITOR'	1	'11BPMy3 '	'SR11BPM03:SA_Y_MONITOR'	1	[11,3]	73	; ...
'11BPMx4 '	'SR11BPM04:SA_X_MONITOR'	1	'11BPMy4 '	'SR11BPM04:SA_Y_MONITOR'	1	[11,4]	74	; ...
'11BPMx5 '	'SR11BPM05:SA_X_MONITOR'	1	'11BPMy5 '	'SR11BPM05:SA_Y_MONITOR'	1	[11,5]	75	; ...
'11BPMx6 '	'SR11BPM06:SA_X_MONITOR'	1	'11BPMy6 '	'SR11BPM06:SA_Y_MONITOR'	1	[11,6]	76	; ...
'11BPMx7 '	'SR11BPM07:SA_X_MONITOR'	1	'11BPMy7 '	'SR11BPM07:SA_Y_MONITOR'	1	[11,7]	77	; ...
'12BPMx1 '	'SR12BPM01:SA_X_MONITOR'	1	'12BPMy1 '	'SR12BPM01:SA_Y_MONITOR'	1	[12,1]	78	; ...
'12BPMx2 '	'SR12BPM02:SA_X_MONITOR'	1	'12BPMy2 '	'SR12BPM02:SA_Y_MONITOR'	1	[12,2]	79	; ...
'12BPMx3 '	'SR12BPM03:SA_X_MONITOR'	1	'12BPMy3 '	'SR12BPM03:SA_Y_MONITOR'	1	[12,3]	80	; ...
'12BPMx4 '	'SR12BPM04:SA_X_MONITOR'	1	'12BPMy4 '	'SR12BPM04:SA_Y_MONITOR'	1	[12,4]	81	; ...
'12BPMx5 '	'SR12BPM05:SA_X_MONITOR'	1	'12BPMy5 '	'SR12BPM05:SA_Y_MONITOR'	1	[12,5]	82	; ...
'12BPMx6 '	'SR12BPM06:SA_X_MONITOR'	1	'12BPMy6 '	'SR12BPM06:SA_Y_MONITOR'	1	[12,6]	83	; ...
'12BPMx7 '	'SR12BPM07:SA_X_MONITOR'	1	'12BPMy7 '	'SR12BPM07:SA_Y_MONITOR'	1	[12,7]	84	; ...
'13BPMx1 '	'SR13BPM01:SA_X_MONITOR'	1	'13BPMy1 '	'SR13BPM01:SA_Y_MONITOR'	1	[13,1]	85	; ...
'13BPMx2 '	'SR13BPM02:SA_X_MONITOR'	1	'13BPMy2 '	'SR13BPM02:SA_Y_MONITOR'	1	[13,2]	86	; ...
'13BPMx3 '	'SR13BPM03:SA_X_MONITOR'	1	'13BPMy3 '	'SR13BPM03:SA_Y_MONITOR'	1	[13,3]	87	; ...
'13BPMx4 '	'SR13BPM04:SA_X_MONITOR'	1	'13BPMy4 '	'SR13BPM04:SA_Y_MONITOR'	1	[13,4]	88	; ...
'13BPMx5 '	'SR13BPM05:SA_X_MONITOR'	1	'13BPMy5 '	'SR13BPM05:SA_Y_MONITOR'	1	[13,5]	89	; ...
'13BPMx6 '	'SR13BPM06:SA_X_MONITOR'	1	'13BPMy6 '	'SR13BPM06:SA_Y_MONITOR'	1	[13,6]	90	; ...
'13BPMx7 '	'SR13BPM07:SA_X_MONITOR'	1	'13BPMy7 '	'SR13BPM07:SA_Y_MONITOR'	1	[13,7]	91	; ...
'14BPMx1 '	'SR14BPM01:SA_X_MONITOR'	1	'14BPMy1 '	'SR14BPM01:SA_Y_MONITOR'	1	[14,1]	92	; ...
'14BPMx2 '	'SR14BPM02:SA_X_MONITOR'	1	'14BPMy2 '	'SR14BPM02:SA_Y_MONITOR'	1	[14,2]	93	; ...
'14BPMx3 '	'SR14BPM03:SA_X_MONITOR'	1	'14BPMy3 '	'SR14BPM03:SA_Y_MONITOR'	1	[14,3]	94	; ...
'14BPMx4 '	'SR14BPM04:SA_X_MONITOR'	1	'14BPMy4 '	'SR14BPM04:SA_Y_MONITOR'	1	[14,4]	95	; ...
'14BPMx5 '	'SR14BPM05:SA_X_MONITOR'	1	'14BPMy5 '	'SR14BPM05:SA_Y_MONITOR'	1	[14,5]	96	; ...
'14BPMx6 '	'SR14BPM06:SA_X_MONITOR'	1	'14BPMy6 '	'SR14BPM06:SA_Y_MONITOR'	1	[14,6]	97	; ...
'14BPMx7 '	'SR14BPM07:SA_X_MONITOR'	1	'14BPMy7 '	'SR14BPM07:SA_Y_MONITOR'	1	[14,7]	98	; ...
};
% 'diag    '	'SR15BPM01:SA_X_MONITOR'	0	'diag    '	'SR15BPM01:SA_Y_MONITOR'	0	[-1,-1]	99	; ...
%'14BPMx7 '	'SR01BPM08:SA_X_MONITOR'	1	'14BPMy7 '	'SR01BPM08:SA_Y_MONITOR'	1	[14,7]	98	; ...
%'14BPMx7 '	'SR14BPM07:SA_X_MONITOR'	1	'14BPMy7 '	'SR14BPM07:SA_Y_MONITOR'	1	[14,7]	98	; ...

% NOTE: BPM [-1 -1] IS A DIAGNOSTIC BPM AND IS NOT TO BE PUT IN SERVICE. NOT
% PART OF ORBIT CORRECTION ETC. AND NOT IN THE MODEL PER SE. ET 18/11/2008

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
                     AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1e-9;
                     AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1e+9;
                     AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-9;
                     AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1e+9;
                     % Placeholder for setting software offsets
                     AO.BPMx.Monitor.Offset(ii,:) = 0;
                     AO.BPMy.Monitor.Offset(ii,:) = 0;
end


% % Get sum value from button. Don't need handles and PV namelist as
% % parameters are the same as the 'monitor' subcategory.
% AO.BPMx.Sum.Monitor = AO.BPMx.Monitor;
% AO.BPMx.Sum.SpecialFunction = 'getbpmsumspear';
% AO.BPMx.Sum.HWUnits          = 'ADC Counts';
% AO.BPMx.Sum.PhysicsUnits     = 'ADC Counts';
% AO.BPMx.Sum.HW2PhysicsParams = 1;
% AO.BPMx.Sum.Physics2HWParams = 1;
% % Get q value from BPMs. Don't need handles and PV namelist.
% AO.BPMx.Q = AO.BPMx.Monitor;
% AO.BPMx.Q.SpecialFunction = 'getbpmqspear';
% AO.BPMx.Q.HWUnits          = 'mm';
% AO.BPMx.Q.PhysicsUnits     = 'meter';
% AO.BPMx.Q.HW2PhysicsParams = 1e-3;
% AO.BPMx.Q.Physics2HWParams = 1000;
% 
% % Definition above for horiz0ontal. Replicate for vertical.
% AO.BPMy.Sum = AO.BPMx.Sum;
% AO.BPMy.Q   = AO.BPMx.Q;

%===========================================================
% Corrector data: status field designates if corrector in use
% ASP corrector coils wound into sextupoles. Not dynamic correctors.
%===========================================================

AO.HCM.FamilyName               = 'HCM'; dispobject(AO,AO.HCM.FamilyName);
AO.HCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Horizontal'};

AO.HCM.Monitor.Mode             = Mode;
AO.HCM.Monitor.DataType         = 'Scalar';
AO.HCM.Monitor.Units            = 'Hardware';
AO.HCM.Monitor.HWUnits          = 'ampere';           
AO.HCM.Monitor.PhysicsUnits     = 'radian';
AO.HCM.Monitor.HW2PhysicsFcn    = @amp2k;
AO.HCM.Monitor.Physics2HWFcn    = @k2amp;

AO.HCM.Setpoint.Mode            = Mode;
AO.HCM.Setpoint.DataType        = 'Scalar';
AO.HCM.Setpoint.Units           = 'Hardware';
AO.HCM.Setpoint.HWUnits         = 'ampere';           
AO.HCM.Setpoint.PhysicsUnits    = 'radian';
AO.HCM.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn   = @k2amp;

% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat  devlist elem tol
cor={
'1HCM1   '	'SR01CPS01:CURRENT_MONITOR'	'SR01CPS01:BASE_CURRENT_SP     '	1	[1,1]	1	0.1	; ...
'1HCM2   '	'SR01CPS05:CURRENT_MONITOR'	'SR01CPS05:BASE_CURRENT_SP     '	1	[1,2]	2	0.1	; ...
'1HCM3   '	'SR01CPS09:CURRENT_MONITOR'	'SR01CPS09:BASE_CURRENT_SP     '	1	[1,3]	3	0.1	; ...
'2HCM1   '	'SR02CPS01:CURRENT_MONITOR'	'SR02CPS01:BASE_CURRENT_SP     '	1	[2,1]	4	0.1	; ...
'2HCM2   '	'SR02CPS05:CURRENT_MONITOR'	'SR02CPS05:BASE_CURRENT_SP     '	1	[2,2]	5	0.1	; ...
'2HCM3   '	'SR02CPS09:CURRENT_MONITOR'	'SR02CPS09:BASE_CURRENT_SP     '	1	[2,3]	6	0.1	; ...
'3HCM1   '	'SR03CPS01:CURRENT_MONITOR'	'SR03CPS01:BASE_CURRENT_SP     '	1	[3,1]	7	0.1	; ...
'3HCM2   '	'SR03CPS05:CURRENT_MONITOR'	'SR03CPS05:BASE_CURRENT_SP     '	1	[3,2]	8	0.1	; ...
'3HCM3   '	'SR03CPS09:CURRENT_MONITOR'	'SR03CPS09:BASE_CURRENT_SP     '	1	[3,3]	9	0.1	; ...
'4HCM1   '	'SR04CPS01:CURRENT_MONITOR'	'SR04CPS01:BASE_CURRENT_SP     '	1	[4,1]	10	0.1	; ...
'4HCM2   '	'SR04CPS05:CURRENT_MONITOR'	'SR04CPS05:BASE_CURRENT_SP     '	1	[4,2]	11	0.1	; ...
'4HCM3   '	'SR04CPS09:CURRENT_MONITOR'	'SR04CPS09:BASE_CURRENT_SP     '	1	[4,3]	12	0.1	; ...
'5HCM1   '	'SR05CPS01:CURRENT_MONITOR'	'SR05CPS01:BASE_CURRENT_SP     '	1	[5,1]	13	0.1	; ...
'5HCM2   '	'SR05CPS05:CURRENT_MONITOR'	'SR05CPS05:BASE_CURRENT_SP     '	1	[5,2]	14	0.1	; ...
'5HCM3   '	'SR05CPS09:CURRENT_MONITOR'	'SR05CPS09:BASE_CURRENT_SP     '	1	[5,3]	15	0.1	; ...
'6HCM1   '	'SR06CPS01:CURRENT_MONITOR'	'SR06CPS01:BASE_CURRENT_SP     '	1	[6,1]	16	0.1	; ...
'6HCM2   '	'SR06CPS05:CURRENT_MONITOR'	'SR06CPS05:BASE_CURRENT_SP     '	1	[6,2]	17	0.1	; ...
'6HCM3   '	'SR06CPS09:CURRENT_MONITOR'	'SR06CPS09:BASE_CURRENT_SP     '	1	[6,3]	18	0.1	; ...
'7HCM1   '	'SR07CPS01:CURRENT_MONITOR'	'SR07CPS01:BASE_CURRENT_SP     '	1	[7,1]	19	0.1	; ...
'7HCM2   '	'SR07CPS05:CURRENT_MONITOR'	'SR07CPS05:BASE_CURRENT_SP     '	1	[7,2]	20	0.1	; ...
'7HCM3   '	'SR07CPS09:CURRENT_MONITOR'	'SR07CPS09:BASE_CURRENT_SP     '	1	[7,3]	21	0.1	; ...
'8HCM1   '	'SR08CPS01:CURRENT_MONITOR'	'SR08CPS01:BASE_CURRENT_SP     '	1	[8,1]	22	0.1	; ...
'8HCM2   '	'SR08CPS05:CURRENT_MONITOR'	'SR08CPS05:BASE_CURRENT_SP     '	1	[8,2]	23	0.1	; ...
'8HCM3   '	'SR08CPS09:CURRENT_MONITOR'	'SR08CPS09:BASE_CURRENT_SP     '	1	[8,3]	24	0.1	; ...
'9HCM1   '	'SR09CPS01:CURRENT_MONITOR'	'SR09CPS01:BASE_CURRENT_SP     '	1	[9,1]	25	0.1	; ...
'9HCM2   '	'SR09CPS05:CURRENT_MONITOR'	'SR09CPS05:BASE_CURRENT_SP     '	1	[9,2]	26	0.1	; ...
'9HCM3   '	'SR09CPS09:CURRENT_MONITOR'	'SR09CPS09:BASE_CURRENT_SP     '	1	[9,3]	27	0.1	; ...
'10HCM1  '	'SR10CPS01:CURRENT_MONITOR'	'SR10CPS01:BASE_CURRENT_SP     '	1	[10,1]	28	0.1	; ...
'10HCM2  '	'SR10CPS05:CURRENT_MONITOR'	'SR10CPS05:BASE_CURRENT_SP     '	1	[10,2]	29	0.1	; ...
'10HCM3  '	'SR10CPS09:CURRENT_MONITOR'	'SR10CPS09:BASE_CURRENT_SP     '	1	[10,3]	30	0.1	; ...
'11HCM1  '	'SR11CPS01:CURRENT_MONITOR'	'SR11CPS01:BASE_CURRENT_SP     '	1	[11,1]	31	0.1	; ...
'11HCM2  '	'SR11CPS05:CURRENT_MONITOR'	'SR11CPS05:BASE_CURRENT_SP     '	1	[11,2]	32	0.1	; ...
'11HCM3  '	'SR11CPS09:CURRENT_MONITOR'	'SR11CPS09:BASE_CURRENT_SP     '	1	[11,3]	33	0.1	; ...
'12HCM1  '	'SR12CPS01:CURRENT_MONITOR'	'SR12CPS01:BASE_CURRENT_SP     '	1	[12,1]	34	0.1	; ...
'12HCM2  '	'SR12CPS05:CURRENT_MONITOR'	'SR12CPS05:BASE_CURRENT_SP     '	1	[12,2]	35	0.1	; ...
'12HCM3  '	'SR12CPS09:CURRENT_MONITOR'	'SR12CPS09:BASE_CURRENT_SP     '	1	[12,3]	36	0.1	; ...
'13HCM1  '	'SR13CPS01:CURRENT_MONITOR'	'SR13CPS01:BASE_CURRENT_SP     '	1	[13,1]	37	0.1	; ...
'13HCM2  '	'SR13CPS05:CURRENT_MONITOR'	'SR13CPS05:BASE_CURRENT_SP     '	1	[13,2]	38	0.1	; ...
'13HCM3  '	'SR13CPS09:CURRENT_MONITOR'	'SR13CPS09:BASE_CURRENT_SP     '	1	[13,3]	39	0.1	; ...
'14HCM1  '	'SR14CPS01:CURRENT_MONITOR'	'SR14CPS01:BASE_CURRENT_SP     '	1	[14,1]	40	0.1	; ...
'14HCM2  '	'SR14CPS05:CURRENT_MONITOR'	'SR14CPS05:BASE_CURRENT_SP     '	1	[14,2]	41	0.1	; ...
'14HCM3  '	'SR14CPS09:CURRENT_MONITOR'	'SR14CPS09:BASE_CURRENT_SP     '	1	[14,3]	42	0.1	; ...
};

[C, Leff, MagnetType] = magnetcoefficients('HCM');

for ii=1:size(cor,1)
name=cor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;     
val =cor{ii,4};     AO.HCM.Status(ii,1)                = val;
val =cor{ii,5};     AO.HCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.HCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.HCM.Setpoint.Tolerance(ii,1)    = val;

AO.HCM.Setpoint.Range(ii,:)               = [-90 +90];
AO.HCM.Monitor.HW2PhysicsParams{1}(ii,:)  = C;          
AO.HCM.Monitor.Physics2HWParams{1}(ii,:)  = C;
AO.HCM.Setpoint.HW2PhysicsParams{1}(ii,:) = C;          
AO.HCM.Setpoint.Physics2HWParams{1}(ii,:) = C;
end


AO.VCM.FamilyName               = 'VCM'; dispobject(AO,AO.VCM.FamilyName);
AO.VCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Vertical'};

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
% y-common          y-monitor                 y-setpoint         stat  devlist elem
cor={
'1VCM1   '	'SR01CPS02:CURRENT_MONITOR'	'SR01CPS02:BASE_CURRENT_SP     '	1	[1,1]	1	0.2	; ...
'1VCM2   '	'SR01CPS04:CURRENT_MONITOR'	'SR01CPS04:BASE_CURRENT_SP     '	1	[1,2]	2	0.2	; ...
'1VCM3   '	'SR01CPS06:CURRENT_MONITOR'	'SR01CPS06:BASE_CURRENT_SP     '	1	[1,3]	3	0.2	; ...
'1VCM4   '	'SR01CPS07:CURRENT_MONITOR'	'SR01CPS07:BASE_CURRENT_SP     '	1	[1,4]	4	0.2	; ...
'2VCM1   '	'SR02CPS02:CURRENT_MONITOR'	'SR02CPS02:BASE_CURRENT_SP     '	1	[2,1]	5	0.2	; ...
'2VCM2   '	'SR02CPS04:CURRENT_MONITOR'	'SR02CPS04:BASE_CURRENT_SP     '	1	[2,2]	6	0.2	; ...
'2VCM3   '	'SR02CPS06:CURRENT_MONITOR'	'SR02CPS06:BASE_CURRENT_SP     '	1	[2,3]	7	0.2	; ...
'2VCM4   '	'SR02CPS07:CURRENT_MONITOR'	'SR02CPS07:BASE_CURRENT_SP     '	1	[2,4]	8	0.2	; ...
'3VCM1   '	'SR03CPS02:CURRENT_MONITOR'	'SR03CPS02:BASE_CURRENT_SP     '	1	[3,1]	9	0.2	; ...
'3VCM2   '	'SR03CPS04:CURRENT_MONITOR'	'SR03CPS04:BASE_CURRENT_SP     '	1	[3,2]	10	0.2	; ...
'3VCM3   '	'SR03CPS06:CURRENT_MONITOR'	'SR03CPS06:BASE_CURRENT_SP     '	1	[3,3]	11	0.2	; ...
'3VCM4   '	'SR03CPS07:CURRENT_MONITOR'	'SR03CPS07:BASE_CURRENT_SP     '	1	[3,4]	12	0.2	; ...
'4VCM1   '	'SR04CPS02:CURRENT_MONITOR'	'SR04CPS02:BASE_CURRENT_SP     '	1	[4,1]	13	0.2	; ...
'4VCM2   '	'SR04CPS04:CURRENT_MONITOR'	'SR04CPS04:BASE_CURRENT_SP     '	1	[4,2]	14	0.2	; ...
'4VCM3   '	'SR04CPS06:CURRENT_MONITOR'	'SR04CPS06:BASE_CURRENT_SP     '	1	[4,3]	15	0.2	; ...
'4VCM4   '	'SR04CPS07:CURRENT_MONITOR'	'SR04CPS07:BASE_CURRENT_SP     '	1	[4,4]	16	0.2	; ...
'5VCM1   '	'SR05CPS02:CURRENT_MONITOR'	'SR05CPS02:BASE_CURRENT_SP     '	1	[5,1]	17	0.2	; ...
'5VCM2   '	'SR05CPS04:CURRENT_MONITOR'	'SR05CPS04:BASE_CURRENT_SP     '	1	[5,2]	18	0.2	; ...
'5VCM3   '	'SR05CPS06:CURRENT_MONITOR'	'SR05CPS06:BASE_CURRENT_SP     '	1	[5,3]	19	0.2	; ...
'5VCM4   '	'SR05CPS07:CURRENT_MONITOR'	'SR05CPS07:BASE_CURRENT_SP     '	1	[5,4]	20	0.2	; ...
'6VCM1   '	'SR06CPS02:CURRENT_MONITOR'	'SR06CPS02:BASE_CURRENT_SP     '	1	[6,1]	21	0.2	; ...
'6VCM2   '	'SR06CPS04:CURRENT_MONITOR'	'SR06CPS04:BASE_CURRENT_SP     '	1	[6,2]	22	0.2	; ...
'6VCM3   '	'SR06CPS06:CURRENT_MONITOR'	'SR06CPS06:BASE_CURRENT_SP     '	1	[6,3]	23	0.2	; ...
'6VCM4   '	'SR06CPS07:CURRENT_MONITOR'	'SR06CPS07:BASE_CURRENT_SP     '	1	[6,4]	24	0.2	; ...
'7VCM1   '	'SR07CPS02:CURRENT_MONITOR'	'SR07CPS02:BASE_CURRENT_SP     '	1	[7,1]	25	0.2	; ...
'7VCM2   '	'SR07CPS04:CURRENT_MONITOR'	'SR07CPS04:BASE_CURRENT_SP     '	1	[7,2]	26	0.2	; ...
'7VCM3   '	'SR07CPS06:CURRENT_MONITOR'	'SR07CPS06:BASE_CURRENT_SP     '	1	[7,3]	27	0.2	; ...
'7VCM4   '	'SR07CPS07:CURRENT_MONITOR'	'SR07CPS07:BASE_CURRENT_SP     '	1	[7,4]	28	0.2	; ...
'8VCM1   '	'SR08CPS02:CURRENT_MONITOR'	'SR08CPS02:BASE_CURRENT_SP     '	1	[8,1]	29	0.2	; ...
'8VCM2   '	'SR08CPS04:CURRENT_MONITOR'	'SR08CPS04:BASE_CURRENT_SP     '	1	[8,2]	30	0.2	; ...
'8VCM3   '	'SR08CPS06:CURRENT_MONITOR'	'SR08CPS06:BASE_CURRENT_SP     '	1	[8,3]	31	0.2	; ...
'8VCM4   '	'SR08CPS07:CURRENT_MONITOR'	'SR08CPS07:BASE_CURRENT_SP     '	1	[8,4]	32	0.2	; ...
'9VCM1   '	'SR09CPS02:CURRENT_MONITOR'	'SR09CPS02:BASE_CURRENT_SP     '	1	[9,1]	33	0.2	; ...
'9VCM2   '	'SR09CPS04:CURRENT_MONITOR'	'SR09CPS04:BASE_CURRENT_SP     '	1	[9,2]	34	0.2	; ...
'9VCM3   '	'SR09CPS06:CURRENT_MONITOR'	'SR09CPS06:BASE_CURRENT_SP     '	1	[9,3]	35	0.2	; ...
'9VCM4   '	'SR09CPS07:CURRENT_MONITOR'	'SR09CPS07:BASE_CURRENT_SP     '	1	[9,4]	36	0.2	; ...
'10VCM1  '	'SR10CPS02:CURRENT_MONITOR'	'SR10CPS02:BASE_CURRENT_SP     '	1	[10,1]	37	0.2	; ...
'10VCM2  '	'SR10CPS04:CURRENT_MONITOR'	'SR10CPS04:BASE_CURRENT_SP     '	1	[10,2]	38	0.2	; ...
'10VCM3  '	'SR10CPS06:CURRENT_MONITOR'	'SR10CPS06:BASE_CURRENT_SP     '	1	[10,3]	39	0.2	; ...
'10VCM4  '	'SR10CPS07:CURRENT_MONITOR'	'SR10CPS07:BASE_CURRENT_SP     '	1	[10,4]	40	0.2	; ...
'11VCM1  '	'SR11CPS02:CURRENT_MONITOR'	'SR11CPS02:BASE_CURRENT_SP     '	1	[11,1]	41	0.2	; ...
'11VCM2  '	'SR11CPS04:CURRENT_MONITOR'	'SR11CPS04:BASE_CURRENT_SP     '	1	[11,2]	42	0.2	; ...
'11VCM3  '	'SR11CPS06:CURRENT_MONITOR'	'SR11CPS06:BASE_CURRENT_SP     '	1	[11,3]	43	0.2	; ...
'11VCM4  '	'SR11CPS07:CURRENT_MONITOR'	'SR11CPS07:BASE_CURRENT_SP     '	1	[11,4]	44	0.2	; ...
'12VCM1  '	'SR12CPS02:CURRENT_MONITOR'	'SR12CPS02:BASE_CURRENT_SP     '	1	[12,1]	45	0.2	; ...
'12VCM2  '	'SR12CPS04:CURRENT_MONITOR'	'SR12CPS04:BASE_CURRENT_SP     '	1	[12,2]	46	0.2	; ...
'12VCM3  '	'SR12CPS06:CURRENT_MONITOR'	'SR12CPS06:BASE_CURRENT_SP     '	1	[12,3]	47	0.2	; ...
'12VCM4  '	'SR12CPS07:CURRENT_MONITOR'	'SR12CPS07:BASE_CURRENT_SP     '	1	[12,4]	48	0.2	; ...
'13VCM1  '	'SR13CPS02:CURRENT_MONITOR'	'SR13CPS02:BASE_CURRENT_SP     '	1	[13,1]	49	0.2	; ...
'13VCM2  '	'SR13CPS04:CURRENT_MONITOR'	'SR13CPS04:BASE_CURRENT_SP     '	1	[13,2]	50	0.2	; ...
'13VCM3  '	'SR13CPS06:CURRENT_MONITOR'	'SR13CPS06:BASE_CURRENT_SP     '	1	[13,3]	51	0.2	; ...
'13VCM4  '	'SR13CPS07:CURRENT_MONITOR'	'SR13CPS07:BASE_CURRENT_SP     '	1	[13,4]	52	0.2	; ...
'14VCM1  '	'SR14CPS02:CURRENT_MONITOR'	'SR14CPS02:BASE_CURRENT_SP     '	1	[14,1]	53	0.2	; ...
'14VCM2  '	'SR14CPS04:CURRENT_MONITOR'	'SR14CPS04:BASE_CURRENT_SP     '	1	[14,2]	54	0.2	; ...
'14VCM3  '	'SR14CPS06:CURRENT_MONITOR'	'SR14CPS06:BASE_CURRENT_SP     '	1	[14,3]	55	0.2	; ...
'14VCM4  '	'SR14CPS07:CURRENT_MONITOR'	'SR14CPS07:BASE_CURRENT_SP     '	1	[14,4]	56	0.3	; ...
};

[C, Leff, MagnetType] = magnetcoefficients('VCM');

for ii=1:size(cor,1)
name=cor{ii,1};     AO.VCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;     
val =cor{ii,4};     AO.VCM.Status(ii,1)                = val;
val =cor{ii,5};     AO.VCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.VCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.VCM.Setpoint.Tolerance(ii,1)    = val;

AO.VCM.Setpoint.Range(ii,:)               = [-125 +125];
AO.VCM.Monitor.HW2PhysicsParams{1}(ii,:)  = C;
AO.VCM.Monitor.Physics2HWParams{1}(ii,:)  = C;
AO.VCM.Setpoint.HW2PhysicsParams{1}(ii,:) = C;
AO.VCM.Setpoint.Physics2HWParams{1}(ii,:) = C;
end

% ============================
%  Fast Corrector Magnets
% ============================

AO.HFC.FamilyName               = 'HFC'; dispobject(AO,AO.HFC.FamilyName);
AO.HFC.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HFC'; 'Magnet'; 'Horizontal'};

AO.HFC.Monitor.Mode             = Mode;
AO.HFC.Monitor.DataType         = 'Scalar';
AO.HFC.Monitor.Units            = 'Hardware';
AO.HFC.Monitor.HWUnits          = 'ampere';           
AO.HFC.Monitor.PhysicsUnits     = 'radian';

AO.HFC.Setpoint.Mode            = Mode;
AO.HFC.Setpoint.DataType        = 'Scalar';
AO.HFC.Setpoint.Units           = 'Hardware';
AO.HFC.Setpoint.HWUnits         = 'ampere';           
AO.HFC.Setpoint.PhysicsUnits    = 'radian';

k = 16.5e-6; % rad/A
ind = 1;
for ii=1:14
    for jj=1:3
        AO.HFC.CommonNames(ind,:) = sprintf('%02dHFC%1d',ii,jj);
        AO.HFC.Monitor.ChannelNames(ind,:)  = sprintf('SR%02dHFC%02d:CURRENT_SP_MONITOR',ii,jj);
        AO.HFC.Setpoint.ChannelNames(ind,:) = sprintf('SR%02dHFC%02d:INT_CURRENT_SP',ii,jj);
        AO.HFC.Setpoint.Tolerance(ind,1)    = 0.05;   % 50 mA.
        AO.HFC.Setpoint.Range(ind,:)        = [-1 +1];
        AO.HFC.Status(ind,1)                = 1; % all good for now, will remove later
        AO.HFC.DeviceList(ind,:)            = [ii jj];
        AO.HFC.ElementList(ind,1)           = ind;
        AO.HFC.Monitor.HW2PhysicsParams(ind,:)  = k;
        AO.HFC.Monitor.Physics2HWParams(ind,:)  = 1/k;
        AO.HFC.Setpoint.HW2PhysicsParams(ind,:) = k;
        AO.HFC.Setpoint.Physics2HWParams(ind,:) = 1/k;
        ind = ind+1;
    end
end


AO.VFC.FamilyName               = 'VFC'; dispobject(AO,AO.VFC.FamilyName);
AO.VFC.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VFC'; 'Magnet'; 'Horizontal'};

AO.VFC.Monitor.Mode             = Mode;
AO.VFC.Monitor.DataType         = 'Scalar';
AO.VFC.Monitor.Units            = 'Hardware';
AO.VFC.Monitor.HWUnits          = 'ampere';           
AO.VFC.Monitor.PhysicsUnits     = 'radian';

AO.VFC.Setpoint.Mode            = Mode;
AO.VFC.Setpoint.DataType        = 'Scalar';
AO.VFC.Setpoint.Units           = 'Hardware';
AO.VFC.Setpoint.HWUnits         = 'ampere';           
AO.VFC.Setpoint.PhysicsUnits    = 'radian';

k = 10.0e-6; % rad/A
ind = 1;
for ii=1:14
    for jj=1:3
        AO.VFC.CommonNames(ind,:) = sprintf('%02dVFC%1d',ii,jj);
        AO.VFC.Monitor.ChannelNames(ind,:)  = sprintf('SR%02dVFC%02d:CURRENT_SP_MONITOR',ii,jj);
        AO.VFC.Setpoint.ChannelNames(ind,:) = sprintf('SR%02dVFC%02d:INT_CURRENT_SP',ii,jj);
        AO.VFC.Setpoint.Tolerance(ind,1)    = 0.05;   % 5 mA.
        AO.VFC.Status(ind,1)                = 1; % all good for now, will remove later
        AO.VFC.DeviceList(ind,:)            = [ii jj];
        AO.VFC.ElementList(ind,1)           = ind;
        AO.VFC.Setpoint.Range(ind,:)            = [-1 +1];
        AO.VFC.Monitor.HW2PhysicsParams(ind,:)  = k;
        AO.VFC.Monitor.Physics2HWParams(ind,:)  = 1/k;
        AO.VFC.Setpoint.HW2PhysicsParams(ind,:) = k;
        AO.VFC.Setpoint.Physics2HWParams(ind,:) = 1/k;
        ind = ind+1;
    end
end


%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========

% *** BEND ***
AO.BEND.FamilyName                 = 'BEND'; dispobject(AO,AO.BEND.FamilyName);
AO.BEND.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet';};
HW2PhysicsParams                   = magnetcoefficients('BEND');
Physics2HWParams                   = magnetcoefficients('BEND');

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

% common             monitor                  setpoint            stat devlist elem scale tol
bend={
'1BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[1,1]	1	1.0 0.5	; ...
'1BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[1,2]	2	1.0 0.5	; ...
'2BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[2,1]	3	1.0 0.5	; ...
'2BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[2,2]	4	1.0 0.5	; ...
'3BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[3,1]	5	1.0 0.5	; ...
'3BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[3,2]	6	1.0 0.5	; ...
'4BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[4,1]	7	1.0 0.5	; ...
'4BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[4,2]	8	1.0 0.5	; ...
'5BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[5,1]	9	1.0 0.5	; ...
'5BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[5,2]	10	1.0 0.5	; ...
'6BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[6,1]	11	1.0 0.5	; ...
'6BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[6,2]	12	1.0 0.5	; ...
'7BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[7,1]	13	1.0 0.5	; ...
'7BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[7,2]	14	1.0 0.5	; ...
'8BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[8,1]	15	1.0 0.5	; ...
'8BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[8,2]	16	1.0 0.5	; ...
'9BEND1  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[9,1]	17	1.0 0.5	; ...
'9BEND2  '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[9,2]	18	1.0 0.5	; ...
'10BEND1 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[10,1]	19	1.0 0.5	; ...
'10BEND2 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[10,2]	20	1.0 0.5	; ...
'11BEND1 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[11,1]	21	1.0 0.5	; ...
'11BEND2 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[11,2]	22	1.0 0.5	; ...
'12BEND1 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[12,1]	23	1.0 0.5	; ...
'12BEND2 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[12,2]	24	1.0 0.5	; ...
'13BEND1 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[13,1]	25	1.0 0.5	; ...
'13BEND2 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[13,2]	26	1.0 0.5	; ...
'14BEND1 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[14,1]	27	1.0 0.5	; ...
'14BEND2 '	'SR00DPS01:CURRENT_MONITOR'	'SR00DPS01:CURRENT_SP     '	1	[14,2]	28	1.0 0.5	; ...
};

for ii=1:size(bend,1)
name=bend{ii,1};      AO.BEND.CommonNames(ii,:)           = name;            
name=bend{ii,2};      AO.BEND.Monitor.ChannelNames(ii,:)  = name;
name=bend{ii,3};      AO.BEND.Setpoint.ChannelNames(ii,:) = name;     
val =bend{ii,4};      AO.BEND.Status(ii,1)                = val;
val =bend{ii,5};      AO.BEND.DeviceList(ii,:)            = val;
val =bend{ii,6};      AO.BEND.ElementList(ii,1)           = val;
val =bend{ii,7};      % This is the scale factor
AO.BEND.Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
AO.BEND.Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
AO.BEND.Setpoint.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.BEND.Setpoint.HW2PhysicsParams{2}(ii,:)                = val;
AO.BEND.Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
AO.BEND.Monitor.Physics2HWParams{2}(ii,:)                 = val;
AO.BEND.Setpoint.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.BEND.Setpoint.Physics2HWParams{2}(ii,:)                = val;
val =bend{ii,8};      AO.BEND.Setpoint.Tolerance(ii,1)    = val;

AO.BEND.Setpoint.Range(ii,:)        = [50 695];
end

%===============
%Quadrupole data
%===============

% *** QFA ***
AO.QFA.FamilyName                 = 'QFA'; dispobject(AO,AO.QFA.FamilyName);
AO.QFA.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'QF';};
HW2PhysicsParams                  = magnetcoefficients('QFA');
Physics2HWParams                  = magnetcoefficients('QFA');

AO.QFA.Monitor.Mode               = Mode;
AO.QFA.Monitor.DataType           = 'Scalar';
AO.QFA.Monitor.Units              = 'Hardware';
AO.QFA.Monitor.HWUnits            = 'ampere';           
AO.QFA.Monitor.PhysicsUnits       = 'meter^-2';
AO.QFA.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QFA.Monitor.Physics2HWFcn      = @k2amp;

AO.QFA.Setpoint.Mode              = Mode;
AO.QFA.Setpoint.DataType          = 'Scalar';
AO.QFA.Setpoint.Units             = 'Hardware';
AO.QFA.Setpoint.HWUnits           = 'ampere';           
AO.QFA.Setpoint.PhysicsUnits      = 'meter^-2';
AO.QFA.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QFA.Setpoint.Physics2HWFcn     = @k2amp;

% common            monitor                  setpoint             stat devlist elem scale tol
qfa={
'1QFA1   '	'SR01QPS01:CURRENT_MONITOR'	'SR01QPS01:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.5	; ...
'1QFA2   '	'SR01QPS06:CURRENT_MONITOR'	'SR01QPS06:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.5	; ...
'2QFA1   '	'SR02QPS01:CURRENT_MONITOR'	'SR02QPS01:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.5	; ...
'2QFA2   '	'SR02QPS06:CURRENT_MONITOR'	'SR02QPS06:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.5	; ...
'3QFA1   '	'SR03QPS01:CURRENT_MONITOR'	'SR03QPS01:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.5	; ...
'3QFA2   '	'SR03QPS06:CURRENT_MONITOR'	'SR03QPS06:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.5	; ...
'4QFA1   '	'SR04QPS01:CURRENT_MONITOR'	'SR04QPS01:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.5	; ...
'4QFA2   '	'SR04QPS06:CURRENT_MONITOR'	'SR04QPS06:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.5	; ...
'5QFA1   '	'SR05QPS01:CURRENT_MONITOR'	'SR05QPS01:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.5	; ...
'5QFA2   '	'SR05QPS06:CURRENT_MONITOR'	'SR05QPS06:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.5	; ...
'6QFA1   '	'SR06QPS01:CURRENT_MONITOR'	'SR06QPS01:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.5	; ...
'6QFA2   '	'SR06QPS06:CURRENT_MONITOR'	'SR06QPS06:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  0.5	; ...
'7QFA1   '	'SR07QPS01:CURRENT_MONITOR'	'SR07QPS01:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.5	; ...
'7QFA2   '	'SR07QPS06:CURRENT_MONITOR'	'SR07QPS06:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.5	; ...
'8QFA1   '	'SR08QPS01:CURRENT_MONITOR'	'SR08QPS01:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.5	; ...
'8QFA2   '	'SR08QPS06:CURRENT_MONITOR'	'SR08QPS06:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.5	; ...
'9QFA1   '	'SR09QPS01:CURRENT_MONITOR'	'SR09QPS01:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.5	; ...
'9QFA2   '	'SR09QPS06:CURRENT_MONITOR'	'SR09QPS06:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.5	; ...
'10QFA1  '	'SR10QPS01:CURRENT_MONITOR'	'SR10QPS01:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.5	; ...
'10QFA2  '	'SR10QPS06:CURRENT_MONITOR'	'SR10QPS06:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.5	; ...
'11QFA1  '	'SR11QPS01:CURRENT_MONITOR'	'SR11QPS01:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.5	; ...
'11QFA2  '	'SR11QPS06:CURRENT_MONITOR'	'SR11QPS06:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.5	; ...
'12QFA1  '	'SR12QPS01:CURRENT_MONITOR'	'SR12QPS01:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.5	; ...
'12QFA2  '	'SR12QPS06:CURRENT_MONITOR'	'SR12QPS06:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.5	; ...
'13QFA1  '	'SR13QPS01:CURRENT_MONITOR'	'SR13QPS01:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.5	; ...
'13QFA2  '	'SR13QPS06:CURRENT_MONITOR'	'SR13QPS06:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.5	; ...
'14QFA1  '	'SR14QPS01:CURRENT_MONITOR'	'SR14QPS01:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.5	; ...
'14QFA2  '	'SR14QPS06:CURRENT_MONITOR'	'SR14QPS06:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.5	; ...
};

% Calculate the individual magnet scaling factors from the LOCO run below.
%load c:/middlelayer2/middleLayer/machine/ASP/StorageRingData/User1/LOCO/2010-06-29_after_cycling_to_golden/11-22-12/locoin00.mat
%qfascale = mean(FitParameters(end).Values(1:28))./FitParameters(end).Values(1:28)*1.006893859274983;



% data = load('/asp/usr/middleLayer/machine/ASP/StorageRingData/User1/LOCO/2011-03-27/18-17-53/locoin00.mat','LocoMeasData','FitParameters');
% qfascale = 

for ii=1:size(qfa,1)
name=qfa{ii,1};      AO.QFA.CommonNames(ii,:)           = name;            
name=qfa{ii,2};      AO.QFA.Monitor.ChannelNames(ii,:)  = name;
name=qfa{ii,3};      AO.QFA.Setpoint.ChannelNames(ii,:) = name;     
val =qfa{ii,4};      AO.QFA.Status(ii,1)                = val;
val =qfa{ii,5};      AO.QFA.DeviceList(ii,:)            = val;
val =qfa{ii,6};      AO.QFA.ElementList(ii,1)           = val;
val = 1;%qfascale(ii);      % This is the scale factor
AO.QFA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QFA.Monitor.HW2PhysicsParams{2}(ii,:)               = 1/val;
AO.QFA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.QFA.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1/val;
AO.QFA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QFA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.QFA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.QFA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qfa{ii,8};     AO.QFA.Setpoint.Tolerance(ii,1)    = val;

% Important! This determines the cycling range
AO.QFA.Setpoint.Range(ii,:)        = [0 160];
end


% *** QDA ***
AO.QDA.FamilyName               = 'QDA'; dispobject(AO,AO.QDA.FamilyName);
AO.QDA.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'QD';};
HW2PhysicsParams                = magnetcoefficients('QDA');
Physics2HWParams                = magnetcoefficients('QDA');

AO.QDA.Monitor.Mode             = Mode;
AO.QDA.Monitor.DataType         = 'Scalar';
AO.QDA.Monitor.Units            = 'Hardware';
AO.QDA.Monitor.HWUnits          = 'ampere';           
AO.QDA.Monitor.PhysicsUnits     = 'meter^-2';
AO.QDA.Monitor.HW2PhysicsFcn    = @amp2k;
AO.QDA.Monitor.Physics2HWFcn    = @k2amp;

AO.QDA.Setpoint.Mode            = Mode;
AO.QDA.Setpoint.DataType        = 'Scalar';
AO.QDA.Setpoint.Units           = 'Hardware';
AO.QDA.Setpoint.HWUnits         = 'ampere';           
AO.QDA.Setpoint.PhysicsUnits    = 'meter^-2';
AO.QDA.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.QDA.Setpoint.Physics2HWFcn   = @k2amp;

% common            monitor                  setpoint             stat devlist elem scale tol
qda={
'1QDA1   '	'SR01QPS02:CURRENT_MONITOR'	'SR01QPS02:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.25	; ...
'1QDA2   '	'SR01QPS05:CURRENT_MONITOR'	'SR01QPS05:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.25	; ...
'2QDA1   '	'SR02QPS02:CURRENT_MONITOR'	'SR02QPS02:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.25	; ...
'2QDA2   '	'SR02QPS05:CURRENT_MONITOR'	'SR02QPS05:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.25	; ...
'3QDA1   '	'SR03QPS02:CURRENT_MONITOR'	'SR03QPS02:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.25	; ...
'3QDA2   '	'SR03QPS05:CURRENT_MONITOR'	'SR03QPS05:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.25	; ...
'4QDA1   '	'SR04QPS02:CURRENT_MONITOR'	'SR04QPS02:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.25	; ...
'4QDA2   '	'SR04QPS05:CURRENT_MONITOR'	'SR04QPS05:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.25	; ...
'5QDA1   '	'SR05QPS02:CURRENT_MONITOR'	'SR05QPS02:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.25	; ...
'5QDA2   '	'SR05QPS05:CURRENT_MONITOR'	'SR05QPS05:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.25	; ...
'6QDA1   '	'SR06QPS02:CURRENT_MONITOR'	'SR06QPS02:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.25	; ...
'6QDA2   '	'SR06QPS05:CURRENT_MONITOR'	'SR06QPS05:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  1.00	; ...
'7QDA1   '	'SR07QPS02:CURRENT_MONITOR'	'SR07QPS02:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.25	; ...
'7QDA2   '	'SR07QPS05:CURRENT_MONITOR'	'SR07QPS05:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.25	; ...
'8QDA1   '	'SR08QPS02:CURRENT_MONITOR'	'SR08QPS02:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.25	; ...
'8QDA2   '	'SR08QPS05:CURRENT_MONITOR'	'SR08QPS05:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.25	; ...
'9QDA1   '	'SR09QPS02:CURRENT_MONITOR'	'SR09QPS02:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.25	; ...
'9QDA2   '	'SR09QPS05:CURRENT_MONITOR'	'SR09QPS05:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.25	; ...
'10QDA1  '	'SR10QPS02:CURRENT_MONITOR'	'SR10QPS02:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.25	; ...
'10QDA2  '	'SR10QPS05:CURRENT_MONITOR'	'SR10QPS05:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.25	; ...
'11QDA1  '	'SR11QPS02:CURRENT_MONITOR'	'SR11QPS02:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.25	; ...
'11QDA2  '	'SR11QPS05:CURRENT_MONITOR'	'SR11QPS05:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.25	; ...
'12QDA1  '	'SR12QPS02:CURRENT_MONITOR'	'SR12QPS02:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.25	; ...
'12QDA2  '	'SR12QPS05:CURRENT_MONITOR'	'SR12QPS05:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.25	; ...
'13QDA1  '	'SR13QPS02:CURRENT_MONITOR'	'SR13QPS02:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.25	; ...
'13QDA2  '	'SR13QPS05:CURRENT_MONITOR'	'SR13QPS05:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.25	; ...
'14QDA1  '	'SR14QPS02:CURRENT_MONITOR'	'SR14QPS02:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.25	; ...
'14QDA2  '	'SR14QPS05:CURRENT_MONITOR'	'SR14QPS05:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.25	; ...
};   
 
% qdascale = mean(FitParameters(end).Values(29:56))./FitParameters(end).Values(29:56);


for ii=1:size(qda,1)
name=qda{ii,1};      AO.QDA.CommonNames(ii,:)           = name;            
name=qda{ii,2};      AO.QDA.Monitor.ChannelNames(ii,:)  = name;
name=qda{ii,3};      AO.QDA.Setpoint.ChannelNames(ii,:) = name;     
val =qda{ii,4};      AO.QDA.Status(ii,1)                = val;
val =qda{ii,5};      AO.QDA.DeviceList(ii,:)            = val;
val =qda{ii,6};      AO.QDA.ElementList(ii,1)           = val;
val =1; %qdascale(ii);      % This is the scale factor
AO.QDA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QDA.Monitor.HW2PhysicsParams{2}(ii,:)               = 1/val;
AO.QDA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.QDA.Setpoint.HW2PhysicsParams{2}(ii,:)              = 1/val;
AO.QDA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QDA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.QDA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.QDA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qda{ii,8};      AO.QDA.Setpoint.Tolerance(ii,1)   = val;

% Important! This determines the cycling range
AO.QDA.Setpoint.Range(ii,:)        = [0 90];
end



% *** QFB ***
AO.QFB.FamilyName               = 'QFB'; dispobject(AO,AO.QFB.FamilyName);
AO.QFB.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'Tune Corrector'; 'QF';};
HW2PhysicsParams                = magnetcoefficients('QFB');
Physics2HWParams                = magnetcoefficients('QFB');

AO.QFB.Monitor.Mode             = Mode;
AO.QFB.Monitor.DataType         = 'Scalar';
AO.QFB.Monitor.Units            = 'Hardware';
AO.QFB.Monitor.HW2PhysicsFcn    = @amp2k;
AO.QFB.Monitor.Physics2HWFcn    = @k2amp;
AO.QFB.Monitor.HWUnits          = 'ampere';           
AO.QFB.Monitor.PhysicsUnits     = 'meter^-2';

AO.QFB.Setpoint.Mode            = Mode;
AO.QFB.Setpoint.DataType        = 'Scalar';
AO.QFB.Setpoint.Units           = 'Hardware';
AO.QFB.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.QFB.Setpoint.Physics2HWFcn   = @k2amp;
AO.QFB.Setpoint.HWUnits         = 'ampere';           
AO.QFB.Setpoint.PhysicsUnits    = 'meter^-2';
 
% common            monitor                  setpoint             stat  devlist elem scale tol
qfb={
'1QFB1   '	'SR01QPS03:CURRENT_MONITOR'	'SR01QPS03:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.35	; ...
'1QFB2   '	'SR01QPS04:CURRENT_MONITOR'	'SR01QPS04:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.35	; ...
'2QFB1   '	'SR02QPS03:CURRENT_MONITOR'	'SR02QPS03:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.35	; ...
'2QFB2   '	'SR02QPS04:CURRENT_MONITOR'	'SR02QPS04:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.35	; ...
'3QFB1   '	'SR03QPS03:CURRENT_MONITOR'	'SR03QPS03:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.35	; ...
'3QFB2   '	'SR03QPS04:CURRENT_MONITOR'	'SR03QPS04:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.35	; ...
'4QFB1   '	'SR04QPS03:CURRENT_MONITOR'	'SR04QPS03:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.35	; ...
'4QFB2   '	'SR04QPS04:CURRENT_MONITOR'	'SR04QPS04:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.35	; ...
'5QFB1   '	'SR05QPS03:CURRENT_MONITOR'	'SR05QPS03:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.35	; ...
'5QFB2   '	'SR05QPS04:CURRENT_MONITOR'	'SR05QPS04:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.35	; ...
'6QFB1   '	'SR06QPS03:CURRENT_MONITOR'	'SR06QPS03:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.35	; ...
'6QFB2   '	'SR06QPS04:CURRENT_MONITOR'	'SR06QPS04:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  0.35	; ...
'7QFB1   '	'SR07QPS03:CURRENT_MONITOR'	'SR07QPS03:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.35	; ...
'7QFB2   '	'SR07QPS04:CURRENT_MONITOR'	'SR07QPS04:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.35	; ...
'8QFB1   '	'SR08QPS03:CURRENT_MONITOR'	'SR08QPS03:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.35	; ...
'8QFB2   '	'SR08QPS04:CURRENT_MONITOR'	'SR08QPS04:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.35	; ...
'9QFB1   '	'SR09QPS03:CURRENT_MONITOR'	'SR09QPS03:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.35	; ...
'9QFB2   '	'SR09QPS04:CURRENT_MONITOR'	'SR09QPS04:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.35	; ...
'10QFB1  '	'SR10QPS03:CURRENT_MONITOR'	'SR10QPS03:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.35	; ...
'10QFB2  '	'SR10QPS04:CURRENT_MONITOR'	'SR10QPS04:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.35	; ...
'11QFB1  '	'SR11QPS03:CURRENT_MONITOR'	'SR11QPS03:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.35	; ...
'11QFB2  '	'SR11QPS04:CURRENT_MONITOR'	'SR11QPS04:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.35	; ...
'12QFB1  '	'SR12QPS03:CURRENT_MONITOR'	'SR12QPS03:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.35	; ...
'12QFB2  '	'SR12QPS04:CURRENT_MONITOR'	'SR12QPS04:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.35	; ...
'13QFB1  '	'SR13QPS03:CURRENT_MONITOR'	'SR13QPS03:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.35	; ...
'13QFB2  '	'SR13QPS04:CURRENT_MONITOR'	'SR13QPS04:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.35	; ...
'14QFB1  '	'SR14QPS03:CURRENT_MONITOR'	'SR14QPS03:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.35	; ...
'14QFB2  '	'SR14QPS04:CURRENT_MONITOR'	'SR14QPS04:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.35	; ...
};
 
% qfbscale = mean(FitParameters(end).Values(57:84))./FitParameters(end).Values(57:84);

for ii=1:size(qfb,1)
name=qfb{ii,1};      AO.QFB.CommonNames(ii,:)           = name;            
name=qfb{ii,2};      AO.QFB.Monitor.ChannelNames(ii,:)  = name;
name=qfb{ii,3};      AO.QFB.Setpoint.ChannelNames(ii,:) = name;     
val =qfb{ii,4};      AO.QFB.Status(ii,1)                = val;
val =qfb{ii,5};      AO.QFB.DeviceList(ii,:)            = val;
val =qfb{ii,6};      AO.QFB.ElementList(ii,1)           = val;
val =1; %qfbscale(ii);      % This is the scale factor
AO.QFB.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.QFB.Monitor.HW2PhysicsParams{2}(ii,:)                = 1/val;
AO.QFB.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QFB.Setpoint.HW2PhysicsParams{2}(ii,:)               = 1/val;
AO.QFB.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.QFB.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO.QFB.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QFB.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =qfb{ii,8};     AO.QFB.Setpoint.Tolerance(ii,1)     = val;

% Important! This determines the cycling range
AO.QFB.Setpoint.Range(ii,:)        = [0 160];
end


%===============
%Sextupole data
%===============
% *** SFA ***
AO.SFA.FamilyName                = 'SFA'; dispobject(AO,AO.SFA.FamilyName);
AO.SFA.MemberOf                  = {'PlotFamily'; 'SF'; 'MachineConfig'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
HW2PhysicsParams                 = magnetcoefficients('SFA');
Physics2HWParams                 = magnetcoefficients('SFA');

AO.SFA.Monitor.Mode              = Mode;
AO.SFA.Monitor.DataType          = 'Scalar';
AO.SFA.Monitor.Units             = 'Hardware';
AO.SFA.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SFA.Monitor.Physics2HWFcn     = @k2amp;
AO.SFA.Monitor.HWUnits           = 'ampere';           
AO.SFA.Monitor.PhysicsUnits      = 'meter^-3';

AO.SFA.Setpoint.Mode             = Mode;
AO.SFA.Setpoint.DataType         = 'Scalar';
AO.SFA.Setpoint.Units            = 'Hardware';
AO.SFA.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SFA.Setpoint.Physics2HWFcn    = @k2amp;
AO.SFA.Setpoint.HWUnits          = 'ampere';           
AO.SFA.Setpoint.PhysicsUnits     = 'meter^-3';

% common            monitor                  setpoint             stat devlist elem scale tol
sfa={
'1SFA1   '	'SR01SPS01:CURRENT_MONITOR'	'SR01SPS01:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.15	; ...
'1SFA2   '	'SR01SPS07:CURRENT_MONITOR'	'SR01SPS07:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.15	; ...
'2SFA1   '	'SR02SPS01:CURRENT_MONITOR'	'SR02SPS01:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.15	; ...
'2SFA2   '	'SR02SPS07:CURRENT_MONITOR'	'SR02SPS07:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.15	; ...
'3SFA1   '	'SR03SPS01:CURRENT_MONITOR'	'SR03SPS01:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.15	; ...
'3SFA2   '	'SR03SPS07:CURRENT_MONITOR'	'SR03SPS07:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.15	; ...
'4SFA1   '	'SR04SPS01:CURRENT_MONITOR'	'SR04SPS01:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.15	; ...
'4SFA2   '	'SR04SPS07:CURRENT_MONITOR'	'SR04SPS07:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.15	; ...
'5SFA1   '	'SR05SPS01:CURRENT_MONITOR'	'SR05SPS01:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.15	; ...
'5SFA2   '	'SR05SPS07:CURRENT_MONITOR'	'SR05SPS07:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.15	; ...
'6SFA1   '	'SR06SPS01:CURRENT_MONITOR'	'SR06SPS01:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.15	; ...
'6SFA2   '	'SR06SPS07:CURRENT_MONITOR'	'SR06SPS07:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  0.15	; ...
'7SFA1   '	'SR07SPS01:CURRENT_MONITOR'	'SR07SPS01:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.15	; ...
'7SFA2   '	'SR07SPS07:CURRENT_MONITOR'	'SR07SPS07:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.15	; ...
'8SFA1   '	'SR08SPS01:CURRENT_MONITOR'	'SR08SPS01:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.15	; ...
'8SFA2   '	'SR08SPS07:CURRENT_MONITOR'	'SR08SPS07:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.15	; ...
'9SFA1   '	'SR09SPS01:CURRENT_MONITOR'	'SR09SPS01:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.15	; ...
'9SFA2   '	'SR09SPS07:CURRENT_MONITOR'	'SR09SPS07:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.15	; ...
'10SFA1  '	'SR10SPS01:CURRENT_MONITOR'	'SR10SPS01:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.15	; ...
'10SFA2  '	'SR10SPS07:CURRENT_MONITOR'	'SR10SPS07:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.15	; ...
'11SFA1  '	'SR11SPS01:CURRENT_MONITOR'	'SR11SPS01:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.15	; ...
'11SFA2  '	'SR11SPS07:CURRENT_MONITOR'	'SR11SPS07:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.15	; ...
'12SFA1  '	'SR12SPS01:CURRENT_MONITOR'	'SR12SPS01:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.15	; ...
'12SFA2  '	'SR12SPS07:CURRENT_MONITOR'	'SR12SPS07:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.15	; ...
'13SFA1  '	'SR13SPS01:CURRENT_MONITOR'	'SR13SPS01:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.15	; ...
'13SFA2  '	'SR13SPS07:CURRENT_MONITOR'	'SR13SPS07:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.15	; ...
'14SFA1  '	'SR14SPS01:CURRENT_MONITOR'	'SR14SPS01:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.15	; ...
'14SFA2  '	'SR14SPS07:CURRENT_MONITOR'	'SR14SPS07:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.15	; ...
};

for ii=1:size(sfa,1)
name=sfa{ii,1};      AO.SFA.CommonNames(ii,:)           = name;            
name=sfa{ii,2};      AO.SFA.Monitor.ChannelNames(ii,:)  = name;
name=sfa{ii,3};      AO.SFA.Setpoint.ChannelNames(ii,:) = name;     
val =sfa{ii,4};      AO.SFA.Status(ii,1)                = val;
val =sfa{ii,5};      AO.SFA.DeviceList(ii,:)            = val;
val =sfa{ii,6};      AO.SFA.ElementList(ii,1)           = val;
val =sfa{ii,7};      % This is the scale factor
AO.SFA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.SFA.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.SFA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SFA.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.SFA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.SFA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.SFA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SFA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sfa{ii,8};     AO.SFA.Setpoint.Tolerance(ii,1)    = val;

% AO.SFA.Setpoint.Range(ii,:)        = [0 90]; 
AO.SFA.Setpoint.Range(ii,:)        = [0 120];
end



% *** SDA ***
AO.SDA.FamilyName                = 'SDA'; dispobject(AO,AO.SDA.FamilyName);
AO.SDA.MemberOf                  = {'PlotFamily'; 'SD'; 'SEXT'; 'MachineConfig'; 'Magnet'; 'Chromaticity Corrector';};
HW2PhysicsParams                 = magnetcoefficients('SDA');
Physics2HWParams                 = magnetcoefficients('SDA');
AO.SDA.Monitor.Mode              = Mode;
AO.SDA.Monitor.DataType          = 'Scalar';
AO.SDA.Monitor.Units             = 'Hardware';
AO.SDA.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SDA.Monitor.Physics2HWFcn     = @k2amp;
AO.SDA.Monitor.HWUnits           = 'ampere';           
AO.SDA.Monitor.PhysicsUnits      = 'meter^-3';

AO.SDA.Setpoint.Mode             = Mode;
AO.SDA.Setpoint.DataType         = 'Scalar';
AO.SDA.Setpoint.Units            = 'Hardware';
AO.SDA.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SDA.Setpoint.Physics2HWFcn    = @k2amp;
AO.SDA.Setpoint.HWUnits          = 'ampere';           
AO.SDA.Setpoint.PhysicsUnits     = 'meter^-3';

              
% common            monitor                  setpoint             stat devlist elem scale tol
sda={
'1SDA1   '	'SR01SPS02:CURRENT_MONITOR'	'SR01SPS02:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.2	; ...
'1SDA2   '	'SR01SPS06:CURRENT_MONITOR'	'SR01SPS06:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.2	; ...
'2SDA1   '	'SR02SPS02:CURRENT_MONITOR'	'SR02SPS02:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.2	; ...
'2SDA2   '	'SR02SPS06:CURRENT_MONITOR'	'SR02SPS06:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.2	; ...
'3SDA1   '	'SR03SPS02:CURRENT_MONITOR'	'SR03SPS02:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.2	; ...
'3SDA2   '	'SR03SPS06:CURRENT_MONITOR'	'SR03SPS06:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.2	; ...
'4SDA1   '	'SR04SPS02:CURRENT_MONITOR'	'SR04SPS02:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.2	; ...
'4SDA2   '	'SR04SPS06:CURRENT_MONITOR'	'SR04SPS06:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.2	; ...
'5SDA1   '	'SR05SPS02:CURRENT_MONITOR'	'SR05SPS02:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.2	; ...
'5SDA2   '	'SR05SPS06:CURRENT_MONITOR'	'SR05SPS06:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.2	; ...
'6SDA1   '	'SR06SPS02:CURRENT_MONITOR'	'SR06SPS02:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.2	; ...
'6SDA2   '	'SR06SPS06:CURRENT_MONITOR'	'SR06SPS06:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  0.2	; ...
'7SDA1   '	'SR07SPS02:CURRENT_MONITOR'	'SR07SPS02:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.2	; ...
'7SDA2   '	'SR07SPS06:CURRENT_MONITOR'	'SR07SPS06:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.2	; ...
'8SDA1   '	'SR08SPS02:CURRENT_MONITOR'	'SR08SPS02:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.2	; ...
'8SDA2   '	'SR08SPS06:CURRENT_MONITOR'	'SR08SPS06:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.2	; ...
'9SDA1   '	'SR09SPS02:CURRENT_MONITOR'	'SR09SPS02:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.2	; ...
'9SDA2   '	'SR09SPS06:CURRENT_MONITOR'	'SR09SPS06:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.2	; ...
'10SDA1  '	'SR10SPS02:CURRENT_MONITOR'	'SR10SPS02:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.2	; ...
'10SDA2  '	'SR10SPS06:CURRENT_MONITOR'	'SR10SPS06:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.2	; ...
'11SDA1  '	'SR11SPS02:CURRENT_MONITOR'	'SR11SPS02:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.2	; ...
'11SDA2  '	'SR11SPS06:CURRENT_MONITOR'	'SR11SPS06:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.2	; ...
'12SDA1  '	'SR12SPS02:CURRENT_MONITOR'	'SR12SPS02:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.2	; ...
'12SDA2  '	'SR12SPS06:CURRENT_MONITOR'	'SR12SPS06:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.2	; ...
'13SDA1  '	'SR13SPS02:CURRENT_MONITOR'	'SR13SPS02:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.2	; ...
'13SDA2  '	'SR13SPS06:CURRENT_MONITOR'	'SR13SPS06:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.2	; ...
'14SDA1  '	'SR14SPS02:CURRENT_MONITOR'	'SR14SPS02:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.2	; ...
'14SDA2  '	'SR14SPS06:CURRENT_MONITOR'	'SR14SPS06:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.2	; ...
};

for ii=1:size(sda,1)
name=sda{ii,1};      AO.SDA.CommonNames(ii,:)           = name;            
name=sda{ii,2};      AO.SDA.Monitor.ChannelNames(ii,:)  = name;
name=sda{ii,3};      AO.SDA.Setpoint.ChannelNames(ii,:) = name;     
val =sda{ii,4};      AO.SDA.Status(ii,1)                = val;
val =sda{ii,5};      AO.SDA.DeviceList(ii,:)            = val;
val =sda{ii,6};      AO.SDA.ElementList(ii,1)           = val;
val =sda{ii,7};      % This is the scale factor
AO.SDA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.SDA.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.SDA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SDA.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.SDA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.SDA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.SDA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SDA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sda{ii,8};     AO.SDA.Setpoint.Tolerance(ii,1)    = val;

% AO.SDA.Setpoint.Range(ii,:)        = [0 90];
AO.SDA.Setpoint.Range(ii,:)        = [0 120];
end


% *** SDB ***
AO.SDB.FamilyName                = 'SDB'; dispobject(AO,AO.SDB.FamilyName);
AO.SDB.MemberOf                  = {'PlotFamily'; 'SD'; 'MachineConfig'; 'SEXT'; 'Magnet';  'Chromaticity Corrector';};
HW2PhysicsParams                 = magnetcoefficients('SDB');
Physics2HWParams                 = magnetcoefficients('SDB');
AO.SDB.Monitor.Mode              = Mode;
AO.SDB.Monitor.DataType          = 'Scalar';
AO.SDB.Monitor.Units             = 'Hardware';
AO.SDB.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SDB.Monitor.Physics2HWFcn     = @k2amp;
AO.SDB.Monitor.HWUnits           = 'ampere';           
AO.SDB.Monitor.PhysicsUnits      = 'meter^-3';

AO.SDB.Setpoint.Mode             = Mode;
AO.SDB.Setpoint.DataType         = 'Scalar';
AO.SDB.Setpoint.Units            = 'Hardware';
AO.SDB.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SDB.Setpoint.Physics2HWFcn    = @k2amp;
AO.SDB.Setpoint.HWUnits          = 'ampere';           
AO.SDB.Setpoint.PhysicsUnits     = 'meter^-3';

% common            monitor                  setpoint             stat devlist elem scale tol
sdb={ 
'1SDB1   '	'SR01SPS03:CURRENT_MONITOR'	'SR01SPS03:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.2	; ...
'1SDB2   '	'SR01SPS05:CURRENT_MONITOR'	'SR01SPS05:BASE_CURRENT_SP     '	1	[1,2]	2	1.0  0.2	; ...
'2SDB1   '	'SR02SPS03:CURRENT_MONITOR'	'SR02SPS03:BASE_CURRENT_SP     '	1	[2,1]	3	1.0  0.2	; ...
'2SDB2   '	'SR02SPS05:CURRENT_MONITOR'	'SR02SPS05:BASE_CURRENT_SP     '	1	[2,2]	4	1.0  0.2	; ...
'3SDB1   '	'SR03SPS03:CURRENT_MONITOR'	'SR03SPS03:BASE_CURRENT_SP     '	1	[3,1]	5	1.0  0.2	; ...
'3SDB2   '	'SR03SPS05:CURRENT_MONITOR'	'SR03SPS05:BASE_CURRENT_SP     '	1	[3,2]	6	1.0  0.2	; ...
'4SDB1   '	'SR04SPS03:CURRENT_MONITOR'	'SR04SPS03:BASE_CURRENT_SP     '	1	[4,1]	7	1.0  0.2	; ...
'4SDB2   '	'SR04SPS05:CURRENT_MONITOR'	'SR04SPS05:BASE_CURRENT_SP     '	1	[4,2]	8	1.0  0.2	; ...
'5SDB1   '	'SR05SPS03:CURRENT_MONITOR'	'SR05SPS03:BASE_CURRENT_SP     '	1	[5,1]	9	1.0  0.2	; ...
'5SDB2   '	'SR05SPS05:CURRENT_MONITOR'	'SR05SPS05:BASE_CURRENT_SP     '	1	[5,2]	10	1.0  0.2	; ...
'6SDB1   '	'SR06SPS03:CURRENT_MONITOR'	'SR06SPS03:BASE_CURRENT_SP     '	1	[6,1]	11	1.0  0.2	; ...
'6SDB2   '	'SR06SPS05:CURRENT_MONITOR'	'SR06SPS05:BASE_CURRENT_SP     '	1	[6,2]	12	1.0  0.2	; ...
'7SDB1   '	'SR07SPS03:CURRENT_MONITOR'	'SR07SPS03:BASE_CURRENT_SP     '	1	[7,1]	13	1.0  0.2	; ...
'7SDB2   '	'SR07SPS05:CURRENT_MONITOR'	'SR07SPS05:BASE_CURRENT_SP     '	1	[7,2]	14	1.0  0.2	; ...
'8SDB1   '	'SR08SPS03:CURRENT_MONITOR'	'SR08SPS03:BASE_CURRENT_SP     '	1	[8,1]	15	1.0  0.2	; ...
'8SDB2   '	'SR08SPS05:CURRENT_MONITOR'	'SR08SPS05:BASE_CURRENT_SP     '	1	[8,2]	16	1.0  0.2	; ...
'9SDB1   '	'SR09SPS03:CURRENT_MONITOR'	'SR09SPS03:BASE_CURRENT_SP     '	1	[9,1]	17	1.0  0.2	; ...
'9SDB2   '	'SR09SPS05:CURRENT_MONITOR'	'SR09SPS05:BASE_CURRENT_SP     '	1	[9,2]	18	1.0  0.2	; ...
'10SDB1  '	'SR10SPS03:CURRENT_MONITOR'	'SR10SPS03:BASE_CURRENT_SP     '	1	[10,1]	19	1.0  0.2	; ...
'10SDB2  '	'SR10SPS05:CURRENT_MONITOR'	'SR10SPS05:BASE_CURRENT_SP     '	1	[10,2]	20	1.0  0.2	; ...
'11SDB1  '	'SR11SPS03:CURRENT_MONITOR'	'SR11SPS03:BASE_CURRENT_SP     '	1	[11,1]	21	1.0  0.2	; ...
'11SDB2  '	'SR11SPS05:CURRENT_MONITOR'	'SR11SPS05:BASE_CURRENT_SP     '	1	[11,2]	22	1.0  0.2	; ...
'12SDB1  '	'SR12SPS03:CURRENT_MONITOR'	'SR12SPS03:BASE_CURRENT_SP     '	1	[12,1]	23	1.0  0.2	; ...
'12SDB2  '	'SR12SPS05:CURRENT_MONITOR'	'SR12SPS05:BASE_CURRENT_SP     '	1	[12,2]	24	1.0  0.2	; ...
'13SDB1  '	'SR13SPS03:CURRENT_MONITOR'	'SR13SPS03:BASE_CURRENT_SP     '	1	[13,1]	25	1.0  0.2	; ...
'13SDB2  '	'SR13SPS05:CURRENT_MONITOR'	'SR13SPS05:BASE_CURRENT_SP     '	1	[13,2]	26	1.0  0.2	; ...
'14SDB1  '	'SR14SPS03:CURRENT_MONITOR'	'SR14SPS03:BASE_CURRENT_SP     '	1	[14,1]	27	1.0  0.2	; ...
'14SDB2  '	'SR14SPS05:CURRENT_MONITOR'	'SR14SPS05:BASE_CURRENT_SP     '	1	[14,2]	28	1.0  0.2	; ...
};

for ii=1:size(sdb,1)
name=sdb{ii,1};     AO.SDB.CommonNames(ii,:)          = name;            
name=sdb{ii,2};     AO.SDB.Monitor.ChannelNames(ii,:) = name; 
name=sdb{ii,3};     AO.SDB.Setpoint.ChannelNames(ii,:)= name;     
val =sdb{ii,4};     AO.SDB.Status(ii,1)               = val;
val =sdb{ii,5};     AO.SDB.DeviceList(ii,:)           = val;
val =sdb{ii,6};     AO.SDB.ElementList(ii,1)          = val;
val =sdb{ii,7};      % This is the scale factor
AO.SDB.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SDB.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO.SDB.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO.SDB.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO.SDB.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SDB.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO.SDB.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO.SDB.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =sdb{ii,8};    AO.SDB.Setpoint.Tolerance(ii,1)    = val;

% AO.SDB.Setpoint.Range(ii,:)       = [0 80];
AO.SDB.Setpoint.Range(ii,:)       = [0 120];
end



% *** SFB ***
AO.SFB.FamilyName                = 'SFB'; dispobject(AO,AO.SFB.FamilyName);
AO.SFB.MemberOf                  = {'PlotFamily'; 'SF'; 'MachineConfig'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
HW2PhysicsParams                 = magnetcoefficients('SFB');
Physics2HWParams                 = magnetcoefficients('SFB');

AO.SFB.Monitor.Mode              = Mode;
AO.SFB.Monitor.DataType          = 'Scalar';
AO.SFB.Monitor.Units             = 'Hardware';
AO.SFB.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SFB.Monitor.Physics2HWFcn     = @k2amp;
AO.SFB.Monitor.HWUnits           = 'ampere';           
AO.SFB.Monitor.PhysicsUnits      = 'meter^-3';

AO.SFB.Setpoint.Mode             = Mode;
AO.SFB.Setpoint.DataType         = 'Scalar';
AO.SFB.Setpoint.Units            = 'Hardware';
AO.SFB.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SFB.Setpoint.Physics2HWFcn    = @k2amp;
AO.SFB.Setpoint.HWUnits          = 'ampere';           
AO.SFB.Setpoint.PhysicsUnits     = 'meter^-3';

% common            monitor                  setpoint             stat devlist elem scale tol
sfb={ 
'1SFB1   '	'SR01SPS04:CURRENT_MONITOR'	'SR01SPS04:BASE_CURRENT_SP     '	1	[1,1]	1	1.0  0.2	; ...
'2SFB1   '	'SR02SPS04:CURRENT_MONITOR'	'SR02SPS04:BASE_CURRENT_SP     '	1	[2,1]	2	1.0  0.2	; ...
'3SFB1   '	'SR03SPS04:CURRENT_MONITOR'	'SR03SPS04:BASE_CURRENT_SP     '	1	[3,1]	3	1.0  0.2	; ...
'4SFB1   '	'SR04SPS04:CURRENT_MONITOR'	'SR04SPS04:BASE_CURRENT_SP     '	1	[4,1]	4	1.0  0.2	; ...
'5SFB1   '	'SR05SPS04:CURRENT_MONITOR'	'SR05SPS04:BASE_CURRENT_SP     '	1	[5,1]	5	1.0  0.2	; ...
'6SFB1   '	'SR06SPS04:CURRENT_MONITOR'	'SR06SPS04:BASE_CURRENT_SP     '	1	[6,1]	6	1.0  0.2	; ...
'7SFB1   '	'SR07SPS04:CURRENT_MONITOR'	'SR07SPS04:BASE_CURRENT_SP     '	1	[7,1]	7	1.0  0.2	; ...
'8SFB1   '	'SR08SPS04:CURRENT_MONITOR'	'SR08SPS04:BASE_CURRENT_SP     '	1	[8,1]	8	1.0  0.2	; ...
'9SFB1   '	'SR09SPS04:CURRENT_MONITOR'	'SR09SPS04:BASE_CURRENT_SP     '	1	[9,1]	9	1.0  0.2	; ...
'10SFB1  '	'SR10SPS04:CURRENT_MONITOR'	'SR10SPS04:BASE_CURRENT_SP     '	1	[10,1]	10	1.0  0.2	; ...
'11SFB1  '	'SR11SPS04:CURRENT_MONITOR'	'SR11SPS04:BASE_CURRENT_SP     '	1	[11,1]	11	1.0  0.2	; ...
'12SFB1  '	'SR12SPS04:CURRENT_MONITOR'	'SR12SPS04:BASE_CURRENT_SP     '	1	[12,1]	12	1.0  0.2	; ...
'13SFB1  '	'SR13SPS04:CURRENT_MONITOR'	'SR13SPS04:BASE_CURRENT_SP     '	1	[13,1]	13	1.0  0.2	; ...
'14SFB1  '	'SR14SPS04:CURRENT_MONITOR'	'SR14SPS04:BASE_CURRENT_SP     '	1	[14,1]	14	1.0  0.2	; ...
};

for ii=1:size(sfb,1)
name=sfb{ii,1};     AO.SFB.CommonNames(ii,:)          = name;            
name=sfb{ii,2};     AO.SFB.Monitor.ChannelNames(ii,:) = name; 
name=sfb{ii,3};     AO.SFB.Setpoint.ChannelNames(ii,:)= name;     
val =sfb{ii,4};     AO.SFB.Status(ii,1)               = val;
val =sfb{ii,5};     AO.SFB.DeviceList(ii,:)           = val;
val =sfb{ii,6};     AO.SFB.ElementList(ii,1)          = val;
val =sfb{ii,7};     % This is the scale factor
AO.SFB.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SFB.Monitor.HW2PhysicsParams{2}(ii,:)              = val;
AO.SFB.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO.SFB.Setpoint.HW2PhysicsParams{2}(ii,:)             = val;
AO.SFB.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SFB.Monitor.Physics2HWParams{2}(ii,:)              = val;
AO.SFB.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;
AO.SFB.Setpoint.Physics2HWParams{2}(ii,:)             = val;
val =sfb{ii,8};    AO.SFB.Setpoint.Tolerance(ii,1)    = val;

% AO.SFB.Setpoint.Range(ii,:)       = [0 60];
AO.SFB.Setpoint.Range(ii,:)       = [0 120];
end

%===============
%Skew Quad data
%===============
% *** Skew quadrupoles *** 2005/09/27 Eugene
AO.SKQ.FamilyName                = 'SKQ'; dispobject(AO,AO.SKQ.FamilyName);
AO.SKQ.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SkewQuad'; 'Magnet';};
HW2PhysicsParams                 = magnetcoefficients('SKQ');
Physics2HWParams                 = magnetcoefficients('SKQ');

AO.SKQ.Monitor.Mode              = Mode;
AO.SKQ.Monitor.DataType          = 'Scalar';
AO.SKQ.Monitor.Units             = 'Hardware';
AO.SKQ.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SKQ.Monitor.Physics2HWFcn     = @k2amp;
AO.SKQ.Monitor.HWUnits           = 'ampere';           
AO.SKQ.Monitor.PhysicsUnits      = 'meter^-2';

AO.SKQ.Setpoint.Mode             = Mode;
AO.SKQ.Setpoint.DataType         = 'Scalar';
AO.SKQ.Setpoint.Units            = 'Hardware';
AO.SKQ.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SKQ.Setpoint.Physics2HWFcn    = @k2amp;
AO.SKQ.Setpoint.HWUnits          = 'ampere';           
AO.SKQ.Setpoint.PhysicsUnits     = 'meter^-2';

% common            monitor                  setpoint             stat devlist elem scale tol
sq={ 
'1SKQ1   '	'SR01CPS03:CURRENT_MONITOR'	'SR01CPS03:BASE_CURRENT_SP     '	1	[1,1]	1	0.2	; ...
'1SKQ2   '	'SR01CPS08:CURRENT_MONITOR'	'SR01CPS08:BASE_CURRENT_SP     '	1	[1,2]	2	0.2	; ...
'2SKQ1   '	'SR02CPS03:CURRENT_MONITOR'	'SR02CPS03:BASE_CURRENT_SP     '	1	[2,1]	3	0.2	; ...
'2SKQ2   '	'SR02CPS08:CURRENT_MONITOR'	'SR02CPS08:BASE_CURRENT_SP     '	1	[2,2]	4	0.2	; ...
'3SKQ1   '	'SR03CPS03:CURRENT_MONITOR'	'SR03CPS03:BASE_CURRENT_SP     '	1	[3,1]	5	0.2	; ...
'3SKQ2   '	'SR03CPS08:CURRENT_MONITOR'	'SR03CPS08:BASE_CURRENT_SP     '	1	[3,2]	6	0.2	; ...
'4SKQ1   '	'SR04CPS03:CURRENT_MONITOR'	'SR04CPS03:BASE_CURRENT_SP     '	1	[4,1]	7	0.2	; ...
'4SKQ2   '	'SR04CPS08:CURRENT_MONITOR'	'SR04CPS08:BASE_CURRENT_SP     '	1	[4,2]	8	0.2	; ...
'5SKQ1   '	'SR05CPS03:CURRENT_MONITOR'	'SR05CPS03:BASE_CURRENT_SP     '	1	[5,1]	9	0.2	; ...
'5SKQ2   '	'SR05CPS08:CURRENT_MONITOR'	'SR05CPS08:BASE_CURRENT_SP     '	1	[5,2]	10	0.2	; ...
'6SKQ1   '	'SR06CPS03:CURRENT_MONITOR'	'SR06CPS03:BASE_CURRENT_SP     '	1	[6,1]	11	0.2	; ...
'6SKQ2   '	'SR06CPS08:CURRENT_MONITOR'	'SR06CPS08:BASE_CURRENT_SP     '	1	[6,2]	12	0.2	; ...
'7SKQ1   '	'SR07CPS03:CURRENT_MONITOR'	'SR07CPS03:BASE_CURRENT_SP     '	1	[7,1]	13	0.2	; ...
'7SKQ2   '	'SR07CPS08:CURRENT_MONITOR'	'SR07CPS08:BASE_CURRENT_SP     '	1	[7,2]	14	0.2	; ...
'8SKQ1   '	'SR08CPS03:CURRENT_MONITOR'	'SR08CPS03:BASE_CURRENT_SP     '	1	[8,1]	15	0.2	; ...
'8SKQ2   '	'SR08CPS08:CURRENT_MONITOR'	'SR08CPS08:BASE_CURRENT_SP     '	1	[8,2]	16	0.2	; ...
'9SKQ1   '	'SR09CPS03:CURRENT_MONITOR'	'SR09CPS03:BASE_CURRENT_SP     '	1	[9,1]	17	0.2	; ...
'9SKQ2   '	'SR09CPS08:CURRENT_MONITOR'	'SR09CPS08:BASE_CURRENT_SP     '	1	[9,2]	18	0.2	; ...
'10SKQ1  '	'SR10CPS03:CURRENT_MONITOR'	'SR10CPS03:BASE_CURRENT_SP     '	1	[10,1]	19	0.2	; ...
'10SKQ2  '	'SR10CPS08:CURRENT_MONITOR'	'SR10CPS08:BASE_CURRENT_SP     '	1	[10,2]	20	0.2	; ...
'11SKQ1  '	'SR11CPS03:CURRENT_MONITOR'	'SR11CPS03:BASE_CURRENT_SP     '	1	[11,1]	21	0.2	; ...
'11SKQ2  '	'SR11CPS08:CURRENT_MONITOR'	'SR11CPS08:BASE_CURRENT_SP     '	1	[11,2]	22	0.2	; ...
'12SKQ1  '	'SR12CPS03:CURRENT_MONITOR'	'SR12CPS03:BASE_CURRENT_SP     '	1	[12,1]	23	0.2	; ...
'12SKQ2  '	'SR12CPS08:CURRENT_MONITOR'	'SR12CPS08:BASE_CURRENT_SP     '	1	[12,2]	24	0.2	; ...
'13SKQ1  '	'SR13CPS03:CURRENT_MONITOR'	'SR13CPS03:BASE_CURRENT_SP     '	1	[13,1]	25	0.2	; ...
'13SKQ2  '	'SR13CPS08:CURRENT_MONITOR'	'SR13CPS08:BASE_CURRENT_SP     '	1	[13,2]	26	0.2	; ...
'14SKQ1  '	'SR14CPS03:CURRENT_MONITOR'	'SR14CPS03:BASE_CURRENT_SP     '	1	[14,1]	27	0.2	; ...
'14SKQ2  '	'SR14CPS08:CURRENT_MONITOR'	'SR14CPS08:BASE_CURRENT_SP     '	1	[14,2]	28	0.2	; ...
};

for ii=1:size(sq,1)
name=sq{ii,1};     AO.SKQ.CommonNames(ii,:)           = name;            
name=sq{ii,2};     AO.SKQ.Monitor.ChannelNames(ii,:)  = name;
name=sq{ii,3};     AO.SKQ.Setpoint.ChannelNames(ii,:) = name;     
val =sq{ii,4};     AO.SKQ.Status(ii,1)                = val;
val =sq{ii,5};     AO.SKQ.DeviceList(ii,:)            = val;
val =sq{ii,6};     AO.SKQ.ElementList(ii,1)           = val;
val =sq{ii,7};     AO.SKQ.Setpoint.Tolerance(ii,1)    = val;
AO.SKQ.Monitor.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SKQ.Setpoint.HW2PhysicsParams{1}(ii,:)             = HW2PhysicsParams;
AO.SKQ.Monitor.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SKQ.Setpoint.Physics2HWParams{1}(ii,:)             = Physics2HWParams;

AO.SKQ.Setpoint.Range(ii,:)        = [-5 +5];
end


%===============
%Kicker data
%===============
AO.KICK.FamilyName                     = 'KICK'; dispobject(AO,AO.KICK.FamilyName);
AO.KICK.MemberOf                       = {'Injection'; 'MachineConfig'; 'Plotfamily'; 'HCM'; 'Horizontal'};

AO.KICK.Monitor.Mode                   = Mode;
AO.KICK.Monitor.DataType               = 'Scalar';
AO.KICK.Monitor.Units                  = 'Hardware';
AO.KICK.Monitor.HWUnits                = 'kVolts';           
AO.KICK.Monitor.PhysicsUnits           = 'mradian';

AO.KICK.Setpoint.Mode                  = Mode;
AO.KICK.Setpoint.DataType              = 'Scalar';
AO.KICK.Setpoint.Units                 = 'Hardware';
AO.KICK.Setpoint.HWUnits               = 'Volts';           
AO.KICK.Setpoint.PhysicsUnits          = 'radian';

AO.KICK.Delay.Mode                  = Mode;
AO.KICK.Delay.MemberOf              = {'MachineConfig'};
AO.KICK.Delay.DataType              = 'Scalar';
AO.KICK.Delay.Units                 = 'Hardware';
AO.KICK.Delay.HWUnits               = 'Second';           
AO.KICK.Delay.PhysicsUnits          = 'Second';


% From kicker deisgn review the kickers are rated to 4380 Amps giving 0.038
% Tesla converting this to kickangle. Also convert voltage into amps for
% the conversion?
%
% 2780 V on the capacitor banks will create 5240 A delivered to the kicker
% magnets.
% From simulations 4380 A creates 0.038607 T over a length of 0.7 m.
% Therefore 4380 A => 2.7006 mrad. Therefore 2323.740 V => 2.7006 mrad.
% HW2PHYSICS conversion factor (kV to rad) is therefore 0.0027006/2.32374 =
% 0.00116217821271. The Ps also goes through a 1:3 transformer therefore
% the conversion factor increases by 3. Ie 0.00348653463813
% For V to rad then 0.00000348653463813.
% hw2physics_conversionfactor = 0.00000348653463813;

% Factory test reports give a 1200 v (1223 V average) setting on the panel
% gives 4200 A. The curve is pretty much linear up to 1000 V, after which
% it starts to taper off. Data for one of the curves is shown below. The
% conversion factor for this data is 2.1366e-6.
% v = [139 378 618 860 984 1111 1249 1396]; 
% a = [420 1260 2100 2940 3360 3780 4200 4620]; 
% mrad = a*0.0027006/4380;
% figure; plot(v,mrad,'.-')
% conversiontfactor = (mrad(5)-mrad(2))/(v(5) - v(2));

% Measured (before fixing the kicker charging unit)
% Kicker1 100 V =  0.176 mrad
% Kicker2 100 V = -0.138 mrad
% Kicker3 100 V = -0.134 mrad
% Kicker4 100 V =  0.176 mrad

%common        monitor                  setpoint                kickerdelay  stat  devlist elem  tol
kickeramp={ 
'KICK1   '	'SR14KPS01:VOLTAGE_MONITOR'	'SR14KPS01:VOLTAGE_SP     '	'TS01EVR06:TTL00_TIME_DELAY_SP' 1	[1,1]	1	0.10	; ...
'KICK2   '	'SR01KPS01:VOLTAGE_MONITOR'	'SR01KPS01:VOLTAGE_SP     '	'TS01EVR06:TTL01_TIME_DELAY_SP' 1	[1,2]	2	0.10	; ...
'KICK3   '	'SR01KPS02:VOLTAGE_MONITOR'	'SR01KPS02:VOLTAGE_SP     '	'TS01EVR06:TTL02_TIME_DELAY_SP' 1	[1,3]	3	0.10	; ...
'KICK4   '	'SR02KPS01:VOLTAGE_MONITOR'	'SR02KPS01:VOLTAGE_SP     '	'TS01EVR06:TTL03_TIME_DELAY_SP' 1	[1,4]	4	0.10	; ...
};

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO.KICK.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO.KICK.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO.KICK.Setpoint.ChannelNames(ii,:)= name; 
name=kickeramp{ii,4};     AO.KICK.Delay.ChannelNames(ii,:)   = name; 
val =kickeramp{ii,5};     AO.KICK.Status(ii,1)               = val;
val =kickeramp{ii,6};     AO.KICK.DeviceList(ii,:)           = val;
val =kickeramp{ii,7};     AO.KICK.ElementList(ii,1)          = val;
val =kickeramp{ii,8};     AO.KICK.Setpoint.Tolerance(ii,1)   = val;

% changed back to one calibration value after kickers 2 and 3 had their
% charging units repaired
% Mark Boland 2007-09-17
if ii==2 || ii==3
    isign = -1;
else
    isign = 1;
end
% scaling factor 0.72 arrived by comparing measured with dynamic model
% where the kick strenght changes like a half sin function.
hw2physics_conversionfactor = isign*1.7600e-06*0.7211; 
AO.KICK.Monitor.HW2PhysicsParams(ii,:)  = hw2physics_conversionfactor;
AO.KICK.Monitor.Physics2HWParams(ii,:)  = 1/hw2physics_conversionfactor;
AO.KICK.Setpoint.HW2PhysicsParams(ii,:) = hw2physics_conversionfactor;
AO.KICK.Setpoint.Physics2HWParams(ii,:) = 1/hw2physics_conversionfactor;
AO.KICK.Setpoint.Range(ii,:)       = [-1300 +1300];
AO.KICK.Delay.HW2PhysicsParams(ii,:) = 1;
AO.KICK.Delay.Physics2HWParams(ii,:) = 1;
AO.KICK.Delay.Range(ii,:)       = [0 1];
end

% Add kick profile for dynamic modelling
% Kick profile from measured data to be used as the profile for the kickers
t = [-0.1 -0.05 0 0.4 1 2 2.5 4 4.8 5.0 5.2 5.4 6.0 7.05 7.1]*1e-6;
amp = [0 0 0 1000 3000 5500 5900 3000 -200 -400 0 50 0 0 0];
tspline = [-0.1:0.05:7.1]*1e-6;
ampspline = spline(t,amp,tspline);
tspline = [tspline(1)-1.5e-6, tspline, tspline(end)+0.720e-6*10]; % add zeros to ends for interpolation
ampspline = [0, ampspline, 0];

AO.KICK.profile_t = tspline;
AO.KICK.profile_amp = ampspline/max(ampspline); % Normalise profile


% *** KICK Delay ***
% AO.KICK.Delay
% >> removed >> see previous versions if info needed


%============
%RF System
%============
AO.RF.FamilyName                  = 'RF'; dispobject(AO,AO.RF.FamilyName);
AO.RF.MemberOf                    = {'MachineConfig'; 'RF'; 'RFSystem'};

%-------------------------------- 4 cavity Case
%common      stat  devlist    elem   
rfcommon={ 
'RF1   '	 1	   [1,1]       1		; ...
'RF2   '	 1	   [1,2]       2		; ...
'RF3   '	 1	   [1,3]       3		; ...
'RF4   '	 1	   [1,4]       4	    ; ...
  };

% Set frequency range to be +-30kHz (dP/P = +-2.8%) about 499.674 MHz 
%FreqMon             FreqSetpoint      HW2PhysicsParams  Physics2HWParams Range    Tolerance 
rffreq={ 
'SR00MOS01:FREQUENCY_MONITOR'	'SR00MOS01:FREQUENCY_SP'       1             1        [499.644e6 499.704e6]  100.0; ...
'SR00MOS01:FREQUENCY_MONITOR'	'SR00MOS01:FREQUENCY_SP'       1             1        [499.644e6 499.704e6]  100.0; ...
'SR00MOS01:FREQUENCY_MONITOR'	'SR00MOS01:FREQUENCY_SP'       1             1        [499.644e6 499.704e6]  100.0; ...
'SR00MOS01:FREQUENCY_MONITOR'	'SR00MOS01:FREQUENCY_SP'       1             1        [499.644e6 499.704e6]  100.0; ...
  };

%      PhaseCtrl           PhaseMon       HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfphase={ 
'SRF1:STN:PHASE'	'SR07RF01LLE01:MASTER_PHASE_MONITOR'       1             1          [-200 200]     inf   ; ...
'SRF2:STN:PHASE'	'SR07RF01LLE01:MASTER_PHASE_MONITOR'       1             1          [-200 200]     inf   ; ...
'SRF3:STN:PHASE'	'SR07RF01LLE01:MASTER_PHASE_MONITOR'       1             1          [-200 200]     inf   ; ...
'SRF4:STN:PHASE'	'SR07RF01LLE01:MASTER_PHASE_MONITOR'       1             1          [-200 200]     inf   ; ...
  };

%   VoltCtrl           VoltMon       HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfvolt_sp={ 
'SR06RF01CAV01:VOLTAGE_REFERENCE_SP'   754.3/677; ...
'SR06RF02CAV01:VOLTAGE_REFERENCE_SP'   748.1/664; ...
'SR07RF01CAV01:VOLTAGE_REFERENCE_SP'   753.4/687; ...
'SR07RF02CAV01:VOLTAGE_REFERENCE_SP'   754.4/698; ...
  };
rfvolt_monitor={ 
'SR06RF01CAV01:VOLTAGE_MONITOR'       754.3/707.7; ...
'SR06RF02CAV01:VOLTAGE_MONITOR'       748.1/701.5; ...
'SR07RF01CAV01:VOLTAGE_MONITOR'       753.4/726.2; ...
'SR07RF02CAV01:VOLTAGE_MONITOR'       754.4/727.7; ...
  };

%               PowerCtrl           PowerMon                 Klystronpower     HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfpower={ 
'SRF1:KLYSDRIVFRWD:POWER:ON '	'SR06RF01CAV01:FWD_MONITOR'   'SR06RF01KLY01:FWD_MONITOR'    1             1      [-inf inf]     inf   ; ...
'SRF2:KLYSDRIVFRWD:POWER:ON '	'SR06RF02CAV01:FWD_MONITOR'   'SR06RF02KLY01:FWD_MONITOR'    1             1      [-inf inf]     inf   ; ...
'SRF3:KLYSDRIVFRWD:POWER:ON '	'SR07RF01CAV01:FWD_MONITOR'   'SR07RF01KLY01:FWD_MONITOR'    1             1      [-inf inf]     inf   ; ...
'SRF4:KLYSDRIVFRWD:POWER:ON '	'SR07RF02CAV01:FWD_MONITOR'   'SR07RF02KLY01:FWD_MONITOR'    1             1      [-inf inf]     inf   ; ...
  };

for ii=1:size(rfcommon,1)
name=rfcommon{ii,1};     AO.RF.CommonNames(ii,:)          = name;             
val =rfcommon{ii,2};     AO.RF.Status(ii,1)               = val;
val =rfcommon{ii,3};     AO.RF.DeviceList(ii,:)           = val;
val =rfcommon{ii,4};     AO.RF.ElementList(ii,1)          = val;
end

for ii=1:size(rffreq,1)
name=rffreq{ii,1};     AO.RF.Monitor.ChannelNames(ii,:)      = name;
name=rffreq{ii,2};     AO.RF.Setpoint.ChannelNames(ii,:)     = name;
val =rffreq{ii,3};     AO.RF.Monitor.HW2PhysicsParams(ii,1)  = val;
                       AO.RF.Setpoint.HW2PhysicsParams(ii,1) = val;
val =rffreq{ii,4};     AO.RF.Monitor.Physics2HWParams(ii,1)  = val;
                       AO.RF.Setpoint.Physics2HWParams(ii,1) = val;                       
val =rffreq{ii,5};     AO.RF.Setpoint.Range(ii,:)            = val;
val =rffreq{ii,6};     AO.RF.Setpoint.Tolerance(ii,1)        = val;
end


for ii=1:size(rfphase,1)
name=rfphase{ii,1};    AO.RF.PhaseCtrl.ChannelNames(ii,:)      = name;
name=rfphase{ii,2};    AO.RF.Phase.ChannelNames(ii,:)          = name;
val =rfphase{ii,3};    AO.RF.PhaseCtrl.HW2PhysicsParams(ii,1)  = val;
                       AO.RF.Phase.HW2PhysicsParams(ii,1)      = val;
val =rfphase{ii,4};    AO.RF.PhaseCtrl.Physics2HWParams(ii,1)  = val;
                       AO.RF.Phase.Physics2HWParams(ii,1)      = val;                       
val =rfphase{ii,5};    AO.RF.PhaseCtrl.Range(ii,:)             = val;
                       AO.RF.Phase.Range(ii,:)                 = val;
val =rfphase{ii,6};    AO.RF.PhaseCtrl.Tolerance(ii,1)         = val;
                       AO.RF.Phase.Tolerance(ii,1)             = val;
end


for ii=1:size(rfvolt_sp,1)
AO.RF.VoltageSP.ChannelNames(ii,:)     = rfvolt_sp{ii,1};
AO.RF.Voltage.ChannelNames(ii,:)       = rfvolt_monitor{ii,1};

AO.RF.VoltageSP.HW2PhysicsParams(ii,1)   = rfvolt_sp{ii,2};
AO.RF.Voltage.HW2PhysicsParams(ii,1)     = rfvolt_monitor{ii,2};

AO.RF.VoltageSP.Physics2HWParams(ii,1)   = 1/rfvolt_sp{ii,2};
AO.RF.Voltage.Physics2HWParams(ii,1)     = 1/rfvolt_monitor{ii,2};

AO.RF.VoltageSP.Range(ii,:)              = [0 800];
AO.RF.Voltage.Range(ii,:)                = [0 800];

AO.RF.VoltageSP.Tolerance(ii,1)          = 2;
AO.RF.Voltage.Tolerance(ii,1)            = 2;
end


for ii=1:size(rfpower,1)
name=rfpower{ii,1};    AO.RF.PowerCtrl.ChannelNames(ii,:)      = name;
name=rfpower{ii,2};    AO.RF.Power.ChannelNames(ii,:)          = name;
name=rfpower{ii,3};    AO.RF.KlysPower.ChannelNames(ii,:)      = name;
val =rfpower{ii,4};    AO.RF.PowerCtrl.HW2PhysicsParams(ii,1)  = val;
                       AO.RF.Power.HW2PhysicsParams(ii,1)      = val;
                       AO.RF.KlysPower.HW2PhysicsParams(ii,1)  = val;
val =rfpower{ii,5};    AO.RF.PowerCtrl.Physics2HWParams(ii,1)  = val;
                       AO.RF.Power.Physics2HWParams(ii,1)      = val; 
                       AO.RF.KlysPower.Physics2HWParams(ii,1)  = val; 
val =rfpower{ii,6};    AO.RF.PowerCtrl.Range(ii,:)             = val;
                       AO.RF.Power.Range(ii,:)                 = val;
                       AO.RF.KlysPower.Range(ii,:)             = val;
val =rfpower{ii,7};    AO.RF.PowerCtrl.Tolerance(ii,1)         = val;
                       AO.RF.Power.Tolerance(ii,1)             = val;
                       AO.RF.KlysPower.Tolerance(ii,1)         = val;
end

%Frequency Readback
AO.RF.Monitor.Mode                = Mode;
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HWUnits             = 'Hz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';
%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HWUnits            = 'Hz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';

%Voltage control
AO.RF.VoltageSP.Mode               = Mode;
AO.RF.VoltageSP.DataType           = 'Scalar';
AO.RF.VoltageSP.Units              = 'Hardware';
AO.RF.VoltageSP.HWUnits            = 'Volts';           
AO.RF.VoltageSP.PhysicsUnits       = 'Volts';
AO.RF.VoltageSP.MemberOf           = {'MachineConfig'; 'RF'; 'RFSystem'};

%Voltage monitor
AO.RF.Voltage.Mode               = Mode;
AO.RF.Voltage.DataType           = 'Scalar';
AO.RF.Voltage.Units              = 'Hardware';
AO.RF.Voltage.HWUnits            = 'kVolts';           
AO.RF.Voltage.PhysicsUnits       = 'Volts';
AO.RF.Voltage.MemberOf           = {'MachineConfig'; 'RF'; 'RFSystem'};

%Power Control
AO.RF.PowerCtrl.Mode               = Mode;
AO.RF.PowerCtrl.DataType           = 'Scalar';
AO.RF.PowerCtrl.Units              = 'Hardware';
AO.RF.PowerCtrl.HWUnits            = 'MWatts';           
AO.RF.PowerCtrl.PhysicsUnits       = 'MWatts';

%Power Monitor
AO.RF.Power.Mode               = Mode;
AO.RF.Power.DataType           = 'Scalar';
AO.RF.Power.Units              = 'Hardware';
AO.RF.Power.HWUnits            = 'kWatts';           
AO.RF.Power.PhysicsUnits       = 'kWatts';
AO.RF.Power.MemberOf           = {'MachineConfig'; 'RF'; 'RFSystem'};

%Klystron Forward Power
AO.RF.KlysPower.Mode               = Mode;
AO.RF.KlysPower.DataType           = 'Scalar';
AO.RF.KlysPower.Units              = 'Hardware';
AO.RF.KlysPower.HWUnits            = 'kWatts';           
AO.RF.KlysPower.PhysicsUnits       = 'kWatts';
AO.RF.KlysPower.MemberOf           = {'MachineConfig'; 'RF'; 'RFSystem'};

%Station Phase Control
AO.RF.PhaseCtrl.Mode               = Mode;
AO.RF.PhaseCtrl.DataType           = 'Scalar';
AO.RF.PhaseCtrl.Units              = 'Hardware';
AO.RF.PhaseCtrl.HWUnits            = 'Degrees';           
AO.RF.PhaseCtrl.PhysicsUnits       = 'Degrees';

%Station Phase Monitor
AO.RF.Phase.Mode               = Mode;
AO.RF.Phase.DataType           = 'Scalar';
AO.RF.Phase.Units              = 'Hardware';
AO.RF.Phase.HWUnits            = 'Degrees';           
AO.RF.Phase.PhysicsUnits       = 'Degrees';

%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE'; dispobject(AO,AO.TUNE.FamilyName);
AO.TUNE.MemberOf    = {'Tune'; 'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2];
AO.TUNE.ElementList = [1 2]';
AO.TUNE.Status      = [1 1]';

AO.TUNE.Monitor.Mode                   = 'Special'; 
AO.TUNE.Monitor.SpecialFunction        = 'meastune';
AO.TUNE.Monitor.DataType               = 'Vector';
AO.TUNE.Monitor.DataTypeIndex          = [1 2]';
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
AO.DCCT.ElementList                    = [1];
AO.DCCT.Status                         = [1];

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = 'SR11BCM01:CURRENT_MONITOR';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1e-3;          
AO.DCCT.Monitor.Physics2HWParams       = 1000;


% %==================
% %Machine Parameters
% %==================
% Removed in this version, see pervious version for more info

%======
%Septum
%======
% ifam=ifam+1;
% AO.Septum.FamilyName                  = 'Septum'; dispobject(AO,AO.Septum.FamilyName);
% AO.Septum.MemberOf                    = {'Injection'};
% AO.Septum.Status                      = 1;
% 
% AO.Septum.CommonNames                 = 'Septum  ';
% AO.Septum.DeviceList                  = [3 1];
% AO.Septum.ElementList                 = [1];
% 
% AO.Septum.Monitor.Mode                = Mode;
% AO.Septum.Monitor.DataType            = 'Scalar';
% AO.Septum.Monitor.Units               = 'Hardware';
% AO.Septum.Monitor.HWUnits             = 'ampere';           
% AO.Septum.Monitor.PhysicsUnits        = 'radian';
% AO.Septum.Monitor.ChannelNames        = 'BTS-B9V:Curr';     
% 
% AO.Septum.Setpoint.Mode               = Mode;
% AO.Septum.Setpoint.DataType           = 'Scalar';
% AO.Septum.Setpoint.Units              = 'Hardware';
% AO.Septum.Setpoint.HWUnits            = 'ampere';           
% AO.Septum.Setpoint.PhysicsUnits       = 'radian';
% AO.Septum.Setpoint.ChannelNames       = 'BTS-B9V:CurrSetpt';    
% AO.Septum.Setpoint.Range              = [0, 2500];
% AO.Septum.Setpoint.Tolerance          = 100.0;
% 
% AO.Septum.Monitor.HW2PhysicsParams    = 1;          
% AO.Septum.Monitor.Physics2HWParams    = 1;
% AO.Septum.Setpoint.HW2PhysicsParams   = 1;         
% AO.Septum.Setpoint.Physics2HWParams   = 1;


%====================
%Photon Beamline Data
%====================
% >> removed >> see previous versions if info needed

%====================
%BPLD Data
%====================
% >> removed >> see previous versions if info needed

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

% I remove the physics2hw conversion because the physics2hw is
% is calibrated yet.  

% Set response matrix kick size in hardware units (amps)
%AO = getao;
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', 1.8e-5, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', 0.9e-5, AO.VCM.DeviceList);
%setao(AO);
%AD = getad;
%AD.DeltaRFDisp = 500;
%setad(AD);

AO.HFC.Setpoint.DeltaRespMat = 0.5;
AO.VFC.Setpoint.DeltaRespMat = 0.5;

AO.KICK.Setpoint.DeltaRespMat = 50;

%% 'NoEnergyScaling' because I don't want to force a BEND magnet read at this point
%AO.HCM.Setpoint.DeltaRespMat = mm2amps('HCM', .5, AO.HCM.DeviceList, 'NoEnergyScaling');
%AO.VCM.Setpoint.DeltaRespMat = mm2amps('VCM', .5, AO.VCM.DeviceList, 'NoEnergyScaling');


AO.QFA.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QFA.FamilyName, 'Setpoint', AO.QFA.Setpoint.DeltaRespMat, AO.QFA.DeviceList);
AO.QFB.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QFB.FamilyName, 'Setpoint', AO.QFB.Setpoint.DeltaRespMat, AO.QFB.DeviceList);
AO.QDA.Setpoint.DeltaRespMat = .2;  %physics2hw(AO.QDA.FamilyName, 'Setpoint', AO.QDA.Setpoint.DeltaRespMat, AO.QDA.DeviceList);


AO.SFA.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SFA.FamilyName, 'Setpoint', AO.SFA.Setpoint.DeltaRespMat, AO.SFA.DeviceList);
AO.SFB.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SFB.FamilyName, 'Setpoint', AO.SFB.Setpoint.DeltaRespMat, AO.SFB.DeviceList);
AO.SDA.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SDA.FamilyName, 'Setpoint', AO.SDA.Setpoint.DeltaRespMat, AO.SDA.DeviceList);
AO.SDB.Setpoint.DeltaRespMat = 3;  %physics2hw(AO.SDB.FamilyName, 'Setpoint', AO.SDB.Setpoint.DeltaRespMat, AO.SDB.DeviceList);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using ...ATIndex(:,1) will accomodata for split elements where the first
% of a group of elements is put in the first column ie, if SFA is split in
% two then ATIndex will look like [2 3; 11 12; ...] where each row is a
% magnet and column represents each split.
global THERING
AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex(:,1))';
AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex(:,1))';
AO.HCM.Position  = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';
AO.VCM.Position  = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
AO.HFC.Position  = findspos(THERING, AO.HFC.AT.ATIndex(:,1))';
AO.VFC.Position  = findspos(THERING, AO.VFC.AT.ATIndex(:,1))';
AO.QFA.Position  = findspos(THERING, AO.QFA.AT.ATIndex(:,1))';
AO.QDA.Position  = findspos(THERING, AO.QDA.AT.ATIndex(:,1))';
AO.QFB.Position  = findspos(THERING, AO.QFB.AT.ATIndex(:,1))';
AO.SFA.Position  = findspos(THERING, AO.SFA.AT.ATIndex(:,1))';
AO.SFB.Position  = findspos(THERING, AO.SFB.AT.ATIndex(:,1))';
AO.SDA.Position  = findspos(THERING, AO.SDA.AT.ATIndex(:,1))';
AO.SDB.Position  = findspos(THERING, AO.SDB.AT.ATIndex(:,1))';
AO.SKQ.Position  = findspos(THERING, AO.SKQ.AT.ATIndex(:,1))';
AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
AO.RF.Position   = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
AO.KICK.Position = findspos(THERING, AO.KICK.AT.ATIndex(:,1))';
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
