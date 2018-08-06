function tlsboosterinit


% NOTES & COMMENTS
% 1. Magnet positions get overwritten in updateatindex.  
%    Ie, positions come directly from the AT model.
% 2. Make sure the BPM and magnes are in the correct location in the AT model 
%    or LOCO will have trouble.  
% 3. Try viewfamily, plotfamily, mmlviewer to view and check the MML setup.
% 4. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 5. Try setorbitgui, steptune, stepchro, ...
% 6. To run LOCO
%    1. Measure new data
%       >> measlocodata
%       For the model use
%       >> measlocodata('model');
%    2. Build the LOCO input file
%       >> buildlocoinput
%    3. Run LOCO
%       >> loco
%    4. To set back to the machine see setlocodata (may need some work)
%       >> setlocodata
%
%
% TO-D0 LIST:
% 0. Channel names must be added to getname_tls and tlsinit (RF, TUNE, DCCT)!!!
% 1. tls2at and tls2at need some work
% 2. bend2gev and gev2bend need some work
% 3. Check .Ranges, .Tolerances, and .DeltaRespMat
% 4. run monmags to check the .Tolerance field
% 5. Measurements - monbpm, measbpmresp, measdisp
%    Copy them to the StorageRingOpsData directory using plotfamily.
% 6. Get the tune family working
% 7. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)


if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);


% Get the device lists (local function)
[BPMlist, HCMlist, VCMlist, QFlist, BDlist, TwoPerSector, FourPerSector] = buildthedevicelists;

ntbpm=60;
% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = BPMlist;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_tls(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = BPMlist;
AO.BPMy.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMy.Position    = [];

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_tls(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';


% x-name             x-chname              xstat y-name               y-chname           ystat DevList Elem
bpm={
'1BPMx1  '	    'R1BPM0X '	1	'1BPMy1  '	    'R1BPM0Y '	1	[1,1]	1	; ...
'1BPMx2  '	    'R1BPM1X ' 	1	'1BPMy2  '	    'R1BPM1Y ' 	1	[1,2]	2	; ...
'2BPMx1  '	    'R2BPM0X ' 	1	'2BPMy1  '	    'R2BPM0Y ' 	1	[2,1]	3	; ...
'2BPMx2  '	    'R2BPM1X ' 	1	'2BPMy2  '	    'R2BPM1Y ' 	1	[2,2]	4	; ...
'3BPMx1  '	    'R3BPM0X ' 	1	'3BPMy1  '	    'R3BPM0Y ' 	1	[3,1]	5	; ...
'3BPMx2  '	    'R3BPM1X ' 	1	'3BPMy2  '	    'R3BPM1Y ' 	1	[3,2]	6	; ...
'4BPMx1  '	    'R4BPM0X '  1	'4BPMy1  '	    'R4BPM0Y '  1	[4,1]   7	; ...
'4BPMx2  '	    'R4BPM1X ' 	1	'4BPMy2  '	    'R4BPM1Y ' 	1	[4,2]	8	; ...
'5BPMx1  '	    'R5BPM0X ' 	1	'5BPMy1  '	    'R5BPM0Y ' 	1	[5,1]	9	; ...
'5BPMx2  '	    'R5BPM1X ' 	1	'5BPMy2  '	    'R5BPM1Y ' 	1	[5,2]	10	; ...
'6BPMx1  '	    'R6BPM0X ' 	1	'6BPMy1  '	    'R6BPM0Y ' 	1	[6,1]	11	; ...
'6BPMx2  '	    'R6BPM1X ' 	1	'6BPMy2  '	    'R6BPM1Y ' 	1	[6,2]	12	; ...
'7BPMx1  '	    'R7BPM0X '	1	'7BPMy1  '	    'R7BPM0Y '	1	[7,1]	13	; ...
'7BPMx2  '	    'R7BPM1X ' 	1	'7BPMy2  '	    'R7BPM1Y ' 	1	[7,2]	14	; ...
'8BPMx1  '	    'R8BPM0X ' 	1	'8BPMy1  '	    'R8BPM0Y ' 	1	[8,1]	15	; ...
'8BPMx2  '	    'R8BPM1X ' 	1	'8BPMy2  '	    'R8BPM1Y ' 	1	[8,2]	16	; ...
'9BPMx1  '	    'R9BPM0X ' 	1	'9BPMy1  '	    'R9BPM0Y ' 	1	[9,1]	17	; ...
'9BPMx2  '	    'R9BPM1X ' 	1	'9BPMy2  '	    'R9BPM1Y ' 	1	[9,2]	18	; ...
'10BPMx1 '	    'R10BPM0X'  1	'10BPMy1 '	    'R10BPM0Y'  1	[10,1]  19	; ...
'10BPMx2 '	    'R10BPM1X' 	1	'10BPMy2 '	    'R10BPM1Y' 	1	[10,2]	20	; ...
'11BPMx1 '	    'R11BPM0X' 	1	'11BPMy1 '	    'R11BPM0Y' 	1	[11,1]	21	; ...
'11BPMx2 '	    'R11BPM1X' 	1	'11BPMy2 '	    'R11BPM1Y' 	1	[11,2]	22	; ...
'12BPMx1 '	    'R12BPM0X' 	1	'12BPMy1 '	    'R12BPM0Y' 	1	[12,1]	23	; ...
'12BPMx2 '	    'R12BPM1X' 	1	'12BPMy2 '	    'R12BPM1Y' 	1	[12,2]	24	; ...
};
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
                     AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1e+3;
                     AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1e+3;
end

%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = HCMlist;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];

AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_tls(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @tls2at;
AO.HCM.Monitor.Physics2HWFcn = @at2tls;
% AO.HCM.Monitor.HW2PhysicsParams = 1;
% AO.HCM.Monitor.Physics2HWParams = 1;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_tls(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2tls;
% AO.HCM.Setpoint.HW2PhysicsParams = 1;
% AO.HCM.Setpoint.Physics2HWParams = 1;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-10 10];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 100e-6;
 
% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat  devlist elem tol
cor={
'HCM1   '	    'HCM0 '	        'HCM0 '	    1	[1,1]	1	0.2	; ...
'HCM2   '	    'HCM1 ' 	    'HCM1 ' 	1	[1,2]	2	0.2	; ...
'HCM3   '	    'HCM2 ' 	    'HCM2 ' 	1	[1,3]	3	0.2	; ...
'HCM4   '	    'HCM3 ' 	    'HCM3 ' 	1	[1,4]	4	0.2	; ...
'HCM5   '	    'HCM4 ' 	    'HCM4 ' 	1	[1,5]	5	0.2	; ...
'HCM6   '	    'HCM5 ' 	    'HCM5 ' 	1	[1,6]	6	0.2	; ...
'HCM7   '	    'HCM6 ' 	    'HCM6 ' 	1	[1,7]	7	0.2	; ...
'HCM8   '	    'HCM7 '	        'HCM7 '	    1	[1,8]	8	0.2	; ...
'HCM9   '	    'HCM8 ' 	    'HCM8 ' 	1	[1,9]	9	0.2	; ...
'HCM10  '	    'HCM9 '	        'HCM9 '	    1	[1,10]	10	0.2	; ...
'HCM11  '	    'HCM10' 	    'HCM10' 	1	[1,11]	11	0.2	; ...
'HCM12  '	    'HCM11'	        'HCM11'	    1	[1,12]	12	0.2	; ...
};

for ii=1:size(cor,1)
name=cor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;     
% val =cor{ii,4};     AO.HCM.Status(ii,1)                = val;
% val =cor{ii,5};     AO.HCM.DeviceList(ii,:)            = val;
% val =cor{ii,6};     AO.HCM.ElementList(ii,1)           = val;
% val =cor{ii,7};     AO.HCM.Setpoint.Tolerance(ii,1)    = val;
end

% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = VCMlist;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];

AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_tls(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @tls2at;
AO.VCM.Monitor.Physics2HWFcn = @at2tls;
% AO.VCM.Monitor.HW2PhysicsParams = 1;
% AO.VCM.Monitor.Physics2HWParams = 1;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_tls(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2tls;
% AO.VCM.Setpoint.HW2PhysicsParams = 1;
% AO.VCM.Setpoint.Physics2HWParams = 1;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-10 10];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 100e-6;

% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat  devlist elem tol
cor={
'VCM1   '	    'VCM0 '	        'VCM0 '   	1	[1,1]	1	0.2	; ...
'VCM2   '	    'VCM1 ' 	    'VCM1 ' 	1	[1,2]	2	0.2	; ...
'VCM3   '	    'VCM2 ' 	    'VCM2 ' 	1	[1,3]	3	0.2	; ...
'VCM4   '	    'VCM3 ' 	    'VCM3 ' 	1	[1,4]	4	0.2	; ...
'VCM5   '	    'VCM4 ' 	    'VCM4 ' 	1	[1,5]	5	0.2	; ...
'VCM6   '	    'VCM5 ' 	    'VCM5 ' 	1	[1,6]	6	0.2	; ...
'VCM7   '	    'VCM6 '	        'VCM6 '  	1	[1,7]	7	0.2	; ...
'VCM8   '	    'VCM7 ' 	    'VCM7 ' 	1	[1,8]	8	0.2	; ...
'VCM9   '	    'VCM8 ' 	    'VCM8 ' 	1	[1,9]	9	0.2	; ...
'VCM10  '	    'VCM9 ' 	    'VCM9 ' 	1	[1,10]	10	0.2	; ...
'VCM11  '	    'VCM10' 	    'VCM10' 	1	[1,11]	11	0.2	; ...
'VCM12  '	    'VCM11' 	    'VCM11' 	1	[1,12]	12	0.2	; ...
};

for ii=1:size(cor,1)
name=cor{ii,1};     AO.VCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;     
% val =cor{ii,4};     AO.VCM.Status(ii,1)                = val;
% val =cor{ii,5};     AO.VCM.DeviceList(ii,:)            = val;
% val =cor{ii,6};     AO.VCM.ElementList(ii,1)           = val;
% val =cor{ii,7};     AO.VCM.Setpoint.Tolerance(ii,1)    = val;
end

%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
AO.QF.FamilyName  = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector';};
AO.QF.DeviceList  = QFlist;
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status      = ones(size(AO.QF.DeviceList,1),1);
AO.QF.Position    = [];

AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_tls(AO.QF.FamilyName, 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsFcn = @tls2at;
AO.QF.Monitor.Physics2HWFcn = @at2tls;
% AO.QF.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
% AO.QF.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_tls(AO.QF.FamilyName, 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsFcn = @tls2at;
AO.QF.Setpoint.Physics2HWFcn = @at2tls;
% AO.QF.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
% AO.QF.Setpoint.Physics2HWParams = (188.89/2.5447); 
AO.QF.Setpoint.Units        = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF.Setpoint.Range        = [-Inf Inf];
AO.QF.Setpoint.Tolerance    = .1;
AO.QF.Setpoint.DeltaRespMat = .01;


AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD';  'QUAD'; 'Magnet'; 'Tune Corrector';};
AO.QD.DeviceList  = QFlist;
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status      = ones(size(AO.QD.DeviceList,1),1);
AO.QD.Position    = [];

AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_tls(AO.QD.FamilyName, 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsFcn = @tls2at;
AO.QD.Monitor.Physics2HWFcn = @at2tls;
% AO.QD.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
% AO.QD.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_tls(AO.QD.FamilyName, 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsFcn = @tls2at;
AO.QD.Setpoint.Physics2HWFcn = @at2tls;
% AO.QD.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
% AO.QD.Setpoint.Physics2HWParams = (188.89/2.5447);
AO.QD.Setpoint.Units        = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD.Setpoint.Range        = [-Inf Inf];
AO.QD.Setpoint.Tolerance    = .1;
AO.QD.Setpoint.DeltaRespMat = -0.01;


AO.SFQ.FamilyName  = 'SFQ';
AO.SFQ.MemberOf    = {'PlotFamily'; 'Magnet'; };
AO.SFQ.DeviceList  = TwoPerSector;
AO.SFQ.ElementList = (1:size(AO.SFQ.DeviceList,1))';
AO.SFQ.Status      = ones(size(AO.SFQ.DeviceList,1),1);
AO.SFQ.Position    = [];

AO.SFQ.Monitor.MemberOf = {};
AO.SFQ.Monitor.Mode = 'Simulator';
AO.SFQ.Monitor.DataType = 'Scalar';
AO.SFQ.Monitor.ChannelNames = getname_tls(AO.SFQ.FamilyName, 'Monitor', AO.SFQ.DeviceList);
AO.SFQ.Monitor.HW2PhysicsFcn = @tls2at;
AO.SFQ.Monitor.Physics2HWFcn = @at2tls;
% AO.SFQ.Monitor.HW2PhysicsParams = (-1.6840/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.SFQ.Monitor.Physics2HWParams = (125.148/-1.6840);
AO.SFQ.Monitor.Units        = 'Hardware';
AO.SFQ.Monitor.HWUnits      = 'Ampere';
AO.SFQ.Monitor.PhysicsUnits = 'meter^-2';

AO.SFQ.Setpoint.MemberOf = {'MachineConfig';};
AO.SFQ.Setpoint.Mode = 'Simulator';
AO.SFQ.Setpoint.DataType = 'Scalar';
AO.SFQ.Setpoint.ChannelNames = getname_tls(AO.SFQ.FamilyName, 'Setpoint', AO.SFQ.DeviceList);
AO.SFQ.Setpoint.HW2PhysicsFcn = @tls2at;
AO.SFQ.Setpoint.Physics2HWFcn = @at2tls;
% AO.SFQ.Setpoint.HW2PhysicsParams = (-1.6840/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.SFQ.Setpoint.Physics2HWParams = (125.148/-1.6840);
AO.SFQ.Setpoint.Units        = 'Hardware';
AO.SFQ.Setpoint.HWUnits      = 'Ampere';
AO.SFQ.Setpoint.PhysicsUnits = 'meter^-2';
AO.SFQ.Setpoint.Range        = [-Inf Inf];
AO.SFQ.Setpoint.Tolerance    = .1;
AO.SFQ.Setpoint.DeltaRespMat = -0.01;


AO.SDQ.FamilyName  = 'SDQ';
AO.SDQ.MemberOf    = {'PlotFamily'; 'Magnet';};
AO.SDQ.DeviceList  = TwoPerSector;
AO.SDQ.ElementList = (1:size(AO.SDQ.DeviceList,1))';
AO.SDQ.Status      = ones(size(AO.SDQ.DeviceList,1),1);
AO.SDQ.Position    = [];

AO.SDQ.Monitor.MemberOf = {};
AO.SDQ.Monitor.Mode = 'Simulator';
AO.SDQ.Monitor.DataType = 'Scalar';
AO.SDQ.Monitor.ChannelNames = getname_tls(AO.SDQ.FamilyName, 'Monitor', AO.SDQ.DeviceList);
AO.SDQ.Monitor.HW2PhysicsFcn = @tls2at;
AO.SDQ.Monitor.Physics2HWFcn = @at2tls;
% AO.SDQ.Monitor.HW2PhysicsParams = (-1.7374/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.SDQ.Monitor.Physics2HWParams = (125.148/-1.7374);
AO.SDQ.Monitor.Units        = 'Hardware';
AO.SDQ.Monitor.HWUnits      = 'Ampere';
AO.SDQ.Monitor.PhysicsUnits = 'meter^-2';

AO.SDQ.Setpoint.MemberOf = {'MachineConfig';};
AO.SDQ.Setpoint.Mode = 'Simulator';
AO.SDQ.Setpoint.DataType = 'Scalar';
AO.SDQ.Setpoint.ChannelNames = getname_tls(AO.SDQ.FamilyName, 'Setpoint', AO.SDQ.DeviceList);
AO.SDQ.Setpoint.HW2PhysicsFcn = @tls2at;
AO.SDQ.Setpoint.Physics2HWFcn = @at2tls;
% AO.SDQ.Setpoint.HW2PhysicsParams = (-1.7374/125.148);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.SDQ.Setpoint.Physics2HWParams = (125.148/-1.7374);
AO.SDQ.Setpoint.Units        = 'Hardware';
AO.SDQ.Setpoint.HWUnits      = 'Ampere';
AO.SDQ.Setpoint.PhysicsUnits = 'meter^-2';
AO.SDQ.Setpoint.Range        = [-Inf Inf];
AO.SDQ.Setpoint.Tolerance    = .1;
AO.SDQ.Setpoint.DeltaRespMat = .01;


%%%%%%%%%%%%%%
% Sextupoles %
%%%%%%%%%%%%%%
% AO.S1.FamilyName  = 'S1';
% AO.S1.MemberOf    = {'PlotFamily'; 'S1'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
% for i=1:24
%     S1List(i,:)= [i 1];
% end
% AO.S1.DeviceList  = TwoPerSector;
% AO.S1.ElementList = (1:size(AO.S1.DeviceList,1))';
% AO.S1.Status      = ones(size(AO.S1.DeviceList,1),1);
% AO.S1.Position    = [];
% 
% AO.S1.Monitor.MemberOf = {};
% AO.S1.Monitor.Mode = 'Simulator';
% AO.S1.Monitor.DataType = 'Scalar';
% AO.S1.Monitor.ChannelNames = getname_tls(AO.S1.FamilyName, 'Monitor', AO.S1.DeviceList);
% AO.S1.Monitor.HW2PhysicsFcn = @tls2at;
% AO.S1.Monitor.Physics2HWFcn = @at2tls;
% % AO.S1.Monitor.HW2PhysicsParams = (50.852/195.465);
% % AO.S1.Monitor.Physics2HWParams = (195.465/50.852);
% AO.S1.Monitor.Units        = 'Hardware';
% AO.S1.Monitor.HWUnits      = 'Ampere';
% AO.S1.Monitor.PhysicsUnits = 'meter^-3';
% 
% AO.S1.Setpoint.MemberOf = {'MachineConfig';};
% AO.S1.Setpoint.Mode = 'Simulator';
% AO.S1.Setpoint.DataType = 'Scalar';
% AO.S1.Setpoint.ChannelNames = getname_tls(AO.S1.FamilyName, 'Setpoint', AO.S1.DeviceList);
% AO.S1.Setpoint.HW2PhysicS1cn = @tls2at;
% AO.S1.Setpoint.Physics2HWFcn = @at2tls;
% % AO.S1.Setpoint.HW2PhysicsParams = (50.852/195.465);
% % AO.S1.Setpoint.Physics2HWParams = (195.465/50.852);
% AO.S1.Setpoint.Units        = 'Hardware';
% AO.S1.Setpoint.HWUnits      = 'Ampere';
% AO.S1.Setpoint.PhysicsUnits = 'meter^-3';
% AO.S1.Setpoint.Range        = [-Inf Inf];
% AO.S1.Setpoint.Tolerance    = .1;
% AO.S1.Setpoint.DeltaRespMat = -0.01;
% 
% 
% AO.S2.FamilyName  = 'S2';
% AO.S2.MemberOf    = {'PlotFamily'; 'S2'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
% AO.S2.DeviceList  = TwoPerSector;
% AO.S2.ElementList = (1:size(AO.S2.DeviceList,1))';
% AO.S2.Status      = ones(size(AO.S2.DeviceList,1),1);
% AO.S2.Position    = [];
% 
% AO.S2.Monitor.MemberOf = {};
% AO.S2.Monitor.Mode = 'Simulator';
% AO.S2.Monitor.DataType = 'Scalar';
% AO.S2.Monitor.ChannelNames = getname_tls(AO.S2.FamilyName, 'Monitor', AO.S2.DeviceList);
% AO.S2.Monitor.HW2PhysicsFcn = @tls2at;
% AO.S2.Monitor.Physics2HWFcn = @at2tls;
% % AO.S2.Monitor.HW2PhysicsParams = (-38.837/146.246);
% % AO.S2.Monitor.Physics2HWParams = (146.246/-38.837);
% AO.S2.Monitor.Units        = 'Hardware';
% AO.S2.Monitor.HWUnits      = 'Ampere';
% AO.S2.Monitor.PhysicsUnits = 'meter^-3';
% 
% AO.S2.Setpoint.MemberOf = {'MachineConfig';};
% AO.S2.Setpoint.Mode = 'Simulator';
% AO.S2.Setpoint.DataType = 'Scalar';
% AO.S2.Setpoint.ChannelNames = getname_tls(AO.S2.FamilyName, 'Setpoint', AO.S2.DeviceList);
% AO.S2.Setpoint.HW2PhysicS1cn = @tls2at;
% AO.S2.Setpoint.Physics2HWFcn = @at2tls;
% % AO.S2.Setpoint.HW2PhysicsParams = (-38.837/146.246);
% % AO.S2.Setpoint.Physics2HWParams = (146.246/-38.837);
% AO.S2.Setpoint.Units        = 'Hardware';
% AO.S2.Setpoint.HWUnits      = 'Ampere';
% AO.S2.Setpoint.PhysicsUnits = 'meter^-3';
% AO.S2.Setpoint.Range        = [-Inf Inf];
% AO.S2.Setpoint.Tolerance    = .1;
% AO.S2.Setpoint.DeltaRespMat = .01;


%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
AO.BD.FamilyName  = 'BD';
AO.BD.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BD.DeviceList  = BDlist;
AO.BD.ElementList = (1:size(AO.BD.DeviceList,1))';
AO.BD.Status      = ones(size(AO.BD.DeviceList,1),1);
AO.BD.Position    = [];

AO.BD.Monitor.MemberOf = {};
AO.BD.Monitor.Mode = 'Simulator';
AO.BD.Monitor.DataType = 'Scalar';
AO.BD.Monitor.ChannelNames = getname_tls(AO.BD.FamilyName, 'Monitor', AO.BD.DeviceList);
AO.BD.Monitor.HW2PhysicsFcn = @tls2at;
AO.BD.Monitor.Physics2HWFcn = @at2tls;
% AO.BD.Monitor.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.BD.Monitor.Physics2HWParams = (1.200/-0.3693);
AO.BD.Monitor.Units        = 'Hardware';
AO.BD.Monitor.HWUnits      = 'KA';
AO.BD.Monitor.PhysicsUnits = 'Radian';

AO.BD.Setpoint.MemberOf = {'MachineConfig';};
AO.BD.Setpoint.Mode = 'Simulator';
AO.BD.Setpoint.DataType = 'Scalar';
AO.BD.Setpoint.ChannelNames = getname_tls(AO.BD.FamilyName, 'Setpoint', AO.BD.DeviceList);
AO.BD.Setpoint.HW2PhysicsFcn = @tls2at;
AO.BD.Setpoint.Physics2HWFcn = @at2tls;
% AO.BD.Setpoint.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.BD.Setpoint.Physics2HWParams = (1.200/-0.3693);
AO.BD.Setpoint.Units        = 'Hardware';
AO.BD.Setpoint.HWUnits      = 'KA';
AO.BD.Setpoint.PhysicsUnits = 'Radian';
AO.BD.Setpoint.Range        = [-Inf Inf];
AO.BD.Setpoint.Tolerance    = .1;
AO.BD.Setpoint.DeltaRespMat = .01;


% AO.BH.FamilyName  = 'BH';
% AO.BH.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
% AO.BH.DeviceList  = TwoPerSector;
% AO.BH.ElementList = (1:size(AO.BH.DeviceList,1))';
% AO.BH.Status      = ones(size(AO.BH.DeviceList,1),1);
% AO.BH.Position    = [];
% 
% AO.BH.Monitor.MemberOf = {};
% AO.BH.Monitor.Mode = 'Simulator';
% AO.BH.Monitor.DataType = 'Scalar';
% AO.BH.Monitor.ChannelNames = getname_tls(AO.BH.FamilyName, 'Monitor', AO.BH.DeviceList);
% AO.BH.Monitor.HW2PhysicsFcn = @tls2at;
% AO.BH.Monitor.Physics2HWFcn = @at2tls;
% % AO.BH.Monitor.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.BH.Monitor.Physics2HWParams = (1.200/-0.3693);
% AO.BH.Monitor.Units        = 'Hardware';
% AO.BH.Monitor.HWUnits      = 'KA';
% AO.BH.Monitor.PhysicsUnits = 'Radian';
% 
% AO.BH.Setpoint.MemberOf = {'MachineConfig';};
% AO.BH.Setpoint.Mode = 'Simulator';
% AO.BH.Setpoint.DataType = 'Scalar';
% AO.BH.Setpoint.ChannelNames = getname_tls(AO.BH.FamilyName, 'Setpoint', AO.BH.DeviceList);
% AO.BH.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.BH.Setpoint.Physics2HWFcn = @at2tls;
% % AO.BH.Setpoint.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.BH.Setpoint.Physics2HWParams = (1.200/-0.3693);
% AO.BH.Setpoint.Units        = 'Hardware';
% AO.BH.Setpoint.HWUnits      = 'KA';
% AO.BH.Setpoint.PhysicsUnits = 'Radian';
% AO.BH.Setpoint.Range        = [-Inf Inf];
% AO.BH.Setpoint.Tolerance    = .1;
% AO.BH.Setpoint.DeltaRespMat = .01;


%%%%%%%%%%
%   RF   %
%%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'; 'PlotFamily';};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = [];

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.ChannelNames      = getname_tls(AO.RF.FamilyName, 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.HW2PhysicsParams  = 1e+3;
AO.RF.Monitor.Physics2HWParams  = 1e-3;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'kHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = getname_tls(AO.RF.FamilyName, 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e+3;
AO.RF.Setpoint.Physics2HWParams = 1e-3;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'kHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [-Inf Inf];
AO.RF.Setpoint.Tolerance        = 1.0;

% AO.RF.VoltageCtrl.MemberOf          = {};
% AO.RF.VoltageCtrl.Mode              = 'Simulator';
% AO.RF.VoltageCtrl.DataType          = 'Scalar';
% AO.RF.VoltageCtrl.ChannelNames      = '';
% AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
% AO.RF.VoltageCtrl.Physics2HWParams  = 1;
% AO.RF.VoltageCtrl.Units             = 'Hardware';
% AO.RF.VoltageCtrl.HWUnits           = 'Volts';
% AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';
% 
% AO.RF.Voltage.MemberOf          = {};
% AO.RF.Voltage.Mode              = 'Simulator';
% AO.RF.Voltage.DataType          = 'Scalar';
% AO.RF.Voltage.ChannelNames      = '';
% AO.RF.Voltage.HW2PhysicsParams  = 1;
% AO.RF.Voltage.Physics2HWParams  = 1;
% AO.RF.Voltage.Units             = 'Hardware';
% AO.RF.Voltage.HWUnits           = 'Volts';
% AO.RF.Voltage.PhysicsUnits      = 'Volts';
% 
% AO.RF.Power.MemberOf          = {};
% AO.RF.Power.Mode              = 'Simulator';
% AO.RF.Power.DataType          = 'Scalar';
% AO.RF.Power.ChannelNames      = '';          % ???
% AO.RF.Power.HW2PhysicsParams  = 1;         
% AO.RF.Power.Physics2HWParams  = 1;
% AO.RF.Power.Units             = 'Hardware';
% AO.RF.Power.HWUnits           = 'MWatts';           
% AO.RF.Power.PhysicsUnits      = 'MWatts';
% AO.RF.Power.Range             = [-inf inf];  % ???  
% AO.RF.Power.Tolerance         = inf;  % ???  
% 
% AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
% AO.RF.Phase.Mode              = 'Simulator';
% AO.RF.Phase.DataType          = 'Scalar';
% AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???  
% AO.RF.Phase.Units             = 'Hardware';
% AO.RF.Phase.HW2PhysicsParams  = 1; 
% AO.RF.Phase.Physics2HWParams  = 1;
% AO.RF.Phase.HWUnits           = 'Degrees';  
% AO.RF.Phase.PhysicsUnits      = 'Degrees';
% 
% AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
% AO.RF.PhaseCtrl.Mode              = 'Simulator';
% AO.RF.PhaseCtrl.DataType          = 'Scalar';
% AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???     
% AO.RF.PhaseCtrl.Units             = 'Hardware';
% AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;         
% AO.RF.PhaseCtrl.Physics2HWParams  = 1;
% AO.RF.PhaseCtrl.HWUnits           = 'Degrees';  
% AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees'; 
% AO.RF.PhaseCtrl.Range             = [-200 200];    % ??? 
% AO.RF.PhaseCtrl.Tolerance         = 10;    % ??? 



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = getname_tls(AO.DCCT.FamilyName, 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'milli-ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'milli-ampere';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];

AO.TUNE.Monitor.MemberOf   = {'TUNE';};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.ChannelNames = getname_tls(AO.TUNE.FamilyName, 'Monitor', AO.TUNE.DeviceList);
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
% AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_tls';



% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Convert to hardware units
% 'NoEnergyScaling' is needed so that the BEND is not read to get the energy (this is a setup file)  
AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat,  AO.HCM.DeviceList,  'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat,  AO.VCM.DeviceList,  'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat   = physics2hw('QF',  'Setpoint', AO.QF.Setpoint.DeltaRespMat,   AO.QF.DeviceList,   'NoEnergyScaling');
AO.QD.Setpoint.DeltaRespMat   = physics2hw('QD',  'Setpoint', AO.QD.Setpoint.DeltaRespMat,   AO.QD.DeviceList,   'NoEnergyScaling');
AO.SFQ.Setpoint.DeltaRespMat   = physics2hw('SFQ',  'Setpoint', AO.SFQ.Setpoint.DeltaRespMat,   AO.SFQ.DeviceList,   'NoEnergyScaling');
AO.SDQ.Setpoint.DeltaRespMat   = physics2hw('SDQ',  'Setpoint', AO.SDQ.Setpoint.DeltaRespMat,   AO.SDQ.DeviceList,   'NoEnergyScaling');
% AO.S1.Setpoint.DeltaRespMat   = physics2hw('S1',  'Setpoint', AO.S1.Setpoint.DeltaRespMat,   AO.S1.DeviceList,   'NoEnergyScaling');
% AO.S2.Setpoint.DeltaRespMat   = physics2hw('S2',  'Setpoint', AO.S2.Setpoint.DeltaRespMat,   AO.S2.DeviceList,   'NoEnergyScaling');
setao(AO);


 
function [BPMlist, HCMlist, VCMlist, QFlist, BDlist, TwoPerSector, FourPerSector] = buildthedevicelists

NSector = 12;

HCMlist = [];
for i = 1:12
    HCMlist(i,:) = [ 1 i ];
end

BPMlist = [];
x = 1;
for i = 1:12
    for j = 1:2
        BPMlist(x,:) = [ i j ];
        x = x+1;
    end
end

VCMlist = [];
for i = 1:12
   VCMlist(i,:) = [ 1 i ];
end
     

QFlist = [];
for i =1:12
    QFlist(i,:) = [ i 1];
end

BDlist = [];
x = 1;
for i = 1:12
    for j = 1:2
        BDlist(x,:) = [ i j ];
        x = x+1;
    end
end

    
         
TwoPerSector=[];
FourPerSector=[];
for Sector =1:NSector  
    TwoPerSector = [TwoPerSector;
        Sector 1;
        Sector 2;];
    
    FourPerSector = [FourPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];	
end

