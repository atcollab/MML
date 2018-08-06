function tlsbtsinit


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
[BPMlist, HCMlist, VCMlist, QMlist] = buildthedevicelists;

ntbpm=6;
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
'1BPMx1  '	    'BTSBPM1X ' 	1	'1BPMy1  '	    'BTSBPM1Y ' 	1	[1,1]	1	; ...
'1BPMx2  '	    'BTSBPM2X ' 	1	'1BPMy2  '	    'BTSBPM2Y ' 	1	[1,2]	2	; ...
'1BPMx3  '	    'BTSBPM3X ' 	1	'1BPMy3  '	    'BTSBPM3Y ' 	1	[1,3]	3	; ...
'1BPMx4  '	    'BTSBPM4X ' 	1	'1BPMy4  '	    'BTSBPM4Y ' 	1	[1,4]	4	; ...
'1BPMx5  '	    'BTSBPM5X ' 	1	'1BPMy5  '	    'BTSBPM5Y ' 	1	[1,5]	5	; ...
'1BPMx6  '	    'BTSBPM6X ' 	1	'1BPMy6  '	    'BTSBPM6Y ' 	1	[1,6]	6	; ...
'1BPMx7  '	    'BTSBPM7X ' 	1	'1BPMy7  '	    'BTSBPM7Y ' 	1	[1,7]	7	; ...
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
AO.HCM.Setpoint.Range        = [-20 20];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 100e-6;
 
% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat  devlist elem tol
cor={
'THC1    '	    'RCTHCPS1 '	    'RCTHCPS1 '	1	[1,1]	1	0.2	; ...
'THC1A   '	    'RCTHCPS1A'	    'RCTHCPS1A'	1	[1,2]	2	0.2	; ...
'TTHC2   '	    'RCTHCDPS2'	    'RCTHCDPS2'	1	[1,3]	3	0.2	; ...
'THC2    '	    'RCTHCPS2 '	    'RCTHCPS2 '	1	[1,4]	4	0.2	; ...
'THC3    '	    'RCTHCPS3 '	    'RCTHCPS3 '	1	[1,5]	5	0.2	; ...
'THC3A   '	    'RCTHCPS3A'	    'RCTHCPS3A'	1	[1,6]	6	0.2	; ...
'TTHC7   '	    'RCTHCDPS7'	    'RCTHCDPS7'	1	[1,7]	7	0.2	; ...
};
for ii=1:size(cor,1)
name=cor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;     
val =cor{ii,4};     AO.HCM.Status(ii,1)                = val;
val =cor{ii,5};     AO.HCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.HCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.HCM.Setpoint.Tolerance(ii,1)    = val;
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
AO.VCM.Setpoint.Range        = [-20 20];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 100e-6;

% HW in ampere, Physics in radian. Respmat settings below AO definitions.
% x-common          x-monitor                 x-setpoint         stat  devlist elem tol
cor={
'TVC1    '	    'RCTVCPS1 '	    'RCTVCPS1 '	1	[1,1]	1	0.2	; ...
'TVC1A   '	    'RCTVCPS1A'	    'RCTVCPS1A'	1	[1,2]	2	0.2	; ...
'TVC2    '	    'RCTVCPS2 '	    'RCTVCPS2 '	1	[1,3]	3	0.2	; ...
'TVC3    '	    'RCTVCPS3 '	    'RCTVCPS3 '	1	[1,4]	4	0.2	; ...
'TVC4    '	    'RCTVCPS4 '	    'RCTVCPS4 '	1	[1,5]	5	0.2	; ...
'TTVC4   '	    'RCTVCDPS4'	    'RCTVCDPS4'	1	[1,6]	6	0.2	; ...
'TTVC5   '	    'RCTVCDPS5'	    'RCTVCDPS5'	1	[1,7]	7	0.2	; ...
'TVC4A   '	    'RCTVCPS4A'	    'RCTVCPS4A'	1	[1,8]	8	0.2	; ...
'TVC5    '	    'RCTVCPS5 '	    'RCTVCPS5 '	1	[1,9]	9	0.2	; ...
};
for ii=1:size(cor,1)
name=cor{ii,1};     AO.VCM.CommonNames(ii,:)           = name;            
name=cor{ii,2};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
name=cor{ii,3};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;     
val =cor{ii,4};     AO.VCM.Status(ii,1)                = val;
val =cor{ii,5};     AO.VCM.DeviceList(ii,:)            = val;
val =cor{ii,6};     AO.VCM.ElementList(ii,1)           = val;
val =cor{ii,7};     AO.VCM.Setpoint.Tolerance(ii,1)    = val;
end


% AO.KICKER.FamilyName  = 'KICKER';
% AO.KICKER.MemberOf    = {'PlotFamily'; 'COR'; 'KICKER'; 'Magnet'};
% AO.KICKER.DeviceList  = [1 1];
% AO.KICKER.ElementList = (1:size(AO.KICKER.DeviceList,1))';
% AO.KICKER.Status      = ones(size(AO.KICKER.DeviceList,1),1);
% AO.KICKER.Position    = [];
% 
% AO.KICKER.Monitor.MemberOf = {'COR'; 'KICKER'; 'Magnet'; 'Monitor';};
% AO.KICKER.Monitor.Mode = 'Simulator';
% AO.KICKER.Monitor.DataType = 'Scalar';
% AO.KICKER.Monitor.ChannelNames = getname_tls(AO.KICKER.FamilyName, 'Monitor', AO.KICKER.DeviceList);
% AO.KICKER.Monitor.HW2PhysicsFcn = @tls2at;
% AO.KICKER.Monitor.Physics2HWFcn = @at2tls;
% % AO.KICKER.Monitor.HW2PhysicsParams = 1;
% % AO.KICKER.Monitor.Physics2HWParams = 1;
% AO.KICKER.Monitor.Units        = 'Hardware';
% AO.KICKER.Monitor.HWUnits      = 'Ampere';
% AO.KICKER.Monitor.PhysicsUnits = 'Radian';
% 
% AO.KICKER.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'KICKER'; 'Magnet'; 'Setpoint';};
% AO.KICKER.Setpoint.Mode = 'Simulator';
% AO.KICKER.Setpoint.DataType = 'Scalar';
% AO.KICKER.Setpoint.ChannelNames = getname_tls(AO.KICKER.FamilyName, 'Setpoint', AO.KICKER.DeviceList);
% AO.KICKER.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.KICKER.Setpoint.Physics2HWFcn = @at2tls;
% % AO.KICKER.Setpoint.HW2PhysicsParams = 1;
% % AO.KICKER.Setpoint.Physics2HWParams = 1;
% AO.KICKER.Setpoint.Units        = 'Hardware';
% AO.KICKER.Setpoint.HWUnits      = 'Ampere';
% AO.KICKER.Setpoint.PhysicsUnits = 'Radian';
% AO.KICKER.Setpoint.Range        = [-10 10];
% AO.KICKER.Setpoint.Tolerance    = .1;
% AO.KICKER.Setpoint.DeltaRespMat = 100e-6;

%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
AO.QM.FamilyName  = 'QM';
AO.QM.MemberOf    = {'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector';};
AO.QM.DeviceList  = QMlist;
AO.QM.ElementList = (1:size(AO.QM.DeviceList,1))';
AO.QM.Status      = ones(size(AO.QM.DeviceList,1),1);
AO.QM.Position    = [];

AO.QM.Monitor.MemberOf = {};
AO.QM.Monitor.Mode = 'Simulator';
AO.QM.Monitor.DataType = 'Scalar';
AO.QM.Monitor.ChannelNames = getname_tls(AO.QM.FamilyName, 'Monitor', AO.QM.DeviceList);
AO.QM.Monitor.HW2PhysicsFcn = @tls2at;
AO.QM.Monitor.Physics2HWFcn = @at2tls;
% AO.QM.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
% AO.QM.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.QM.Monitor.Units        = 'Hardware';
AO.QM.Monitor.HWUnits      = 'Ampere';
AO.QM.Monitor.PhysicsUnits = 'meter^-2';

AO.QM.Setpoint.MemberOf = {'MachineConfig';};
AO.QM.Setpoint.Mode = 'Simulator';
AO.QM.Setpoint.DataType = 'Scalar';
AO.QM.Setpoint.ChannelNames = getname_tls(AO.QM.FamilyName, 'Setpoint', AO.QM.DeviceList);
AO.QM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.QM.Setpoint.Physics2HWFcn = @at2tls;
% AO.QM.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
% AO.QM.Setpoint.Physics2HWParams = (188.89/2.5447); 
AO.QM.Setpoint.Units        = 'Hardware';
AO.QM.Setpoint.HWUnits      = 'Ampere';
AO.QM.Setpoint.PhysicsUnits = 'meter^-2';
AO.QM.Setpoint.Range        = [-Inf Inf];
AO.QM.Setpoint.Tolerance    = .1;
AO.QM.Setpoint.DeltaRespMat = .01;


AO.SQ.FamilyName  = 'SQ';
AO.SQ.MemberOf    = {'PlotFamily'; 'QUAD'; 'Magnet';};
AO.SQ.DeviceList  = [1 1];
AO.SQ.ElementList = (1:size(AO.SQ.DeviceList,1))';
AO.SQ.Status      = ones(size(AO.SQ.DeviceList,1),1);
AO.SQ.Position    = [];

AO.SQ.Monitor.MemberOf = {};
AO.SQ.Monitor.Mode = 'Simulator';
AO.SQ.Monitor.DataType = 'Scalar';
AO.SQ.Monitor.ChannelNames = getname_tls(AO.SQ.FamilyName, 'Monitor', AO.SQ.DeviceList);
AO.SQ.Monitor.HW2PhysicsFcn = @tls2at;
AO.SQ.Monitor.Physics2HWFcn = @at2tls;
% AO.SQ.Monitor.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K
% AO.SQ.Monitor.Physics2HWParams = (188.89/2.5447); 
AO.SQ.Monitor.Units        = 'Hardware';
AO.SQ.Monitor.HWUnits      = 'Ampere';
AO.SQ.Monitor.PhysicsUnits = 'meter^-2';

AO.SQ.Setpoint.MemberOf = {'MachineConfig';};
AO.SQ.Setpoint.Mode = 'Simulator';
AO.SQ.Setpoint.DataType = 'Scalar';
AO.SQ.Setpoint.ChannelNames = getname_tls(AO.SQ.FamilyName, 'Setpoint', AO.SQ.DeviceList);
AO.SQ.Setpoint.HW2PhysicsFcn = @tls2at;
AO.SQ.Setpoint.Physics2HWFcn = @at2tls;
% AO.SQ.Setpoint.HW2PhysicsParams = (2.5447/188.89);    % K/amps:  HW2Physics*Amps=K  ???
% AO.SQ.Setpoint.Physics2HWParams = (188.89/2.5447); 
AO.SQ.Setpoint.Units        = 'Hardware';
AO.SQ.Setpoint.HWUnits      = 'Ampere';
AO.SQ.Setpoint.PhysicsUnits = 'meter^-2';
AO.SQ.Setpoint.Range        = [-Inf Inf];
AO.SQ.Setpoint.Tolerance    = .1;
AO.SQ.Setpoint.DeltaRespMat = .01;


%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
AO.BM.FamilyName  = 'BM';
AO.BM.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BM.DeviceList  = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 4 1; 4 2; 5 1; 5 2; 6 1; 6 2; 7 1; 7 2; 8 1; 8 2;];
AO.BM.ElementList = (1:size(AO.BM.DeviceList,1))';
AO.BM.Status      = [0;0;1;1;1;1;1;1;1;1;1;1;1;1;0;0;];
AO.BM.Position    = [];

AO.BM.Monitor.MemberOf = {};
AO.BM.Monitor.Mode = 'Simulator';
AO.BM.Monitor.DataType = 'Scalar';
AO.BM.Monitor.ChannelNames = getname_tls(AO.BM.FamilyName, 'Monitor', AO.BM.DeviceList);
AO.BM.Monitor.HW2PhysicsFcn = @tls2at;
AO.BM.Monitor.Physics2HWFcn = @at2tls;
% AO.BM.Monitor.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.BM.Monitor.Physics2HWParams = (1.200/-0.3693);
AO.BM.Monitor.Units        = 'Hardware';
AO.BM.Monitor.HWUnits      = 'KA';
AO.BM.Monitor.PhysicsUnits = 'Radian';

AO.BM.Setpoint.MemberOf = {'MachineConfig';};
AO.BM.Setpoint.Mode = 'Simulator';
AO.BM.Setpoint.DataType = 'Scalar';
AO.BM.Setpoint.ChannelNames = getname_tls(AO.BM.FamilyName, 'Setpoint', AO.BM.DeviceList);
AO.BM.Setpoint.HW2PhysicsFcn = @tls2at;
AO.BM.Setpoint.Physics2HWFcn = @at2tls;
% AO.BM.Setpoint.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% AO.BM.Setpoint.Physics2HWParams = (1.200/-0.3693);
AO.BM.Setpoint.Units        = 'Hardware';
AO.BM.Setpoint.HWUnits      = 'KA';
AO.BM.Setpoint.PhysicsUnits = 'Radian';
AO.BM.Setpoint.Range        = [-Inf Inf];
AO.BM.Setpoint.Tolerance    = .1;
AO.BM.Setpoint.DeltaRespMat = .01;


% AO.SE.FamilyName  = 'SE';
% AO.SE.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
% AO.SE.DeviceList  = [1 1; 1 2; 1 3];
% AO.SE.ElementList = (1:size(AO.SE.DeviceList,1))';
% AO.SE.Status      = ones(size(AO.SE.DeviceList,1),1);
% AO.SE.Position    = [];
% 
% AO.SE.Monitor.MemberOf = {};
% AO.SE.Monitor.Mode = 'Simulator';
% AO.SE.Monitor.DataType = 'Scalar';
% AO.SE.Monitor.ChannelNames = getname_tls(AO.SE.FamilyName, 'Monitor', AO.SE.DeviceList);
% AO.SE.Monitor.HW2PhysicsFcn = @tls2at;
% AO.SE.Monitor.Physics2HWFcn = @at2tls;
% % AO.SE.Monitor.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.SE.Monitor.Physics2HWParams = (1.200/-0.3693);
% AO.SE.Monitor.Units        = 'Hardware';
% AO.SE.Monitor.HWUnits      = 'KA';
% AO.SE.Monitor.PhysicsUnits = 'Radian';
% 
% AO.SE.Setpoint.MemberOf = {'MachineConfig';};
% AO.SE.Setpoint.Mode = 'Simulator';
% AO.SE.Setpoint.DataType = 'Scalar';
% AO.SE.Setpoint.ChannelNames = getname_tls(AO.SE.FamilyName, 'Setpoint', AO.SE.DeviceList);
% AO.SE.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.SE.Setpoint.Physics2HWFcn = @at2tls;
% % AO.SE.Setpoint.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.SE.Setpoint.Physics2HWParams = (1.200/-0.3693);
% AO.SE.Setpoint.Units        = 'Hardware';
% AO.SE.Setpoint.HWUnits      = 'KA';
% AO.SE.Setpoint.PhysicsUnits = 'Radian';
% AO.SE.Setpoint.Range        = [-Inf Inf];
% AO.SE.Setpoint.Tolerance    = .1;
% AO.SE.Setpoint.DeltaRespMat = .01;
% 
% 
% AO.SI.FamilyName  = 'SI';
% AO.SI.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
% AO.SI.DeviceList  = [1 1; 1 2; 1 3];
% AO.SI.ElementList = (1:size(AO.SI.DeviceList,1))';
% AO.SI.Status      = ones(size(AO.SI.DeviceList,1),1);
% AO.SI.Position    = [];
% 
% AO.SI.Monitor.MemberOf = {};
% AO.SI.Monitor.Mode = 'Simulator';
% AO.SI.Monitor.DataType = 'Scalar';
% AO.SI.Monitor.ChannelNames = getname_tls(AO.SI.FamilyName, 'Monitor', AO.SI.DeviceList);
% AO.SI.Monitor.HW2PhysicsFcn = @tls2at;
% AO.SI.Monitor.Physics2HWFcn = @at2tls;
% % AO.SI.Monitor.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.SI.Monitor.Physics2HWParams = (1.200/-0.3693);
% AO.SI.Monitor.Units        = 'Hardware';
% AO.SI.Monitor.HWUnits      = 'KA';
% AO.SI.Monitor.PhysicsUnits = 'Radian';
% 
% AO.SI.Setpoint.MemberOf = {'MachineConfig';};
% AO.SI.Setpoint.Mode = 'Simulator';
% AO.SI.Setpoint.DataType = 'Scalar';
% AO.SI.Setpoint.ChannelNames = getname_tls(AO.SI.FamilyName, 'Setpoint', AO.SI.DeviceList);
% AO.SI.Setpoint.HW2PhysicsFcn = @tls2at;
% AO.SI.Setpoint.Physics2HWFcn = @at2tls;
% % AO.SI.Setpoint.HW2PhysicsParams = (-0.3693/1.200);    % K/amps:  HW2Physics*Amps=K     % ???
% % AO.SI.Setpoint.Physics2HWParams = (1.200/-0.3693);
% AO.SI.Setpoint.Units        = 'Hardware';
% AO.SI.Setpoint.HWUnits      = 'KA';
% AO.SI.Setpoint.PhysicsUnits = 'Radian';
% AO.SI.Setpoint.Range        = [-Inf Inf];
% AO.SI.Setpoint.Tolerance    = .1;
% AO.SI.Setpoint.DeltaRespMat = .01;


% %%%%%%%%%%%%%%
% %    DCCT    %
% %%%%%%%%%%%%%%
% AO.DCCT.FamilyName               = 'DCCT';
% AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
% AO.DCCT.DeviceList               = [1 1];
% AO.DCCT.ElementList              = 1;
% AO.DCCT.Status                   = 1;
% 
% AO.DCCT.Monitor.MemberOf         = {};
% AO.DCCT.Monitor.Mode             = 'Simulator';
% AO.DCCT.Monitor.DataType         = 'Scalar';
% AO.DCCT.Monitor.ChannelNames     = getname_tls(AO.DCCT.FamilyName, 'Monitor', AO.DCCT.DeviceList);
% AO.DCCT.Monitor.HW2PhysicsParams = 1;    
% AO.DCCT.Monitor.Physics2HWParams = 1;
% AO.DCCT.Monitor.Units            = 'Hardware';
% AO.DCCT.Monitor.HWUnits          = 'milli-ampere';     
% AO.DCCT.Monitor.PhysicsUnits     = 'milli-ampere';



%%%%%%%%
% Tune %
%%%%%%%%
% AO.TUNE.FamilyName = 'TUNE';
% AO.TUNE.MemberOf = {'TUNE';};
% AO.TUNE.DeviceList = [1 1;1 2;1 3];
% AO.TUNE.ElementList = [1;2;3];
% AO.TUNE.Status = [1; 1; 0];
% 
% AO.TUNE.Monitor.MemberOf   = {'TUNE';};
% AO.TUNE.Monitor.Mode = 'Simulator'; 
% AO.TUNE.Monitor.DataType = 'Scalar';
% AO.TUNE.Monitor.ChannelNames = getname_tls(AO.TUNE.FamilyName, 'Monitor', AO.TUNE.DeviceList);
% AO.TUNE.Monitor.HW2PhysicsParams = 1;
% AO.TUNE.Monitor.Physics2HWParams = 1;
% AO.TUNE.Monitor.Units        = 'Hardware';
% AO.TUNE.Monitor.HWUnits      = 'Tune';
% AO.TUNE.Monitor.PhysicsUnits = 'Tune';
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
AO.SQ.Setpoint.DeltaRespMat  = physics2hw('SQ', 'Setpoint', AO.SQ.Setpoint.DeltaRespMat,  AO.SQ.DeviceList,  'NoEnergyScaling');
AO.QM.Setpoint.DeltaRespMat   = physics2hw('QM',  'Setpoint', AO.QM.Setpoint.DeltaRespMat,   AO.QM.DeviceList,   'NoEnergyScaling');
% AO.Q12.Setpoint.DeltaRespMat   = physics2hw('Q12',  'Setpoint', AO.Q12.Setpoint.DeltaRespMat,   AO.Q12.DeviceList,   'NoEnergyScaling');
% AO.Q13.Setpoint.DeltaRespMat   = physics2hw('Q13',  'Setpoint', AO.Q13.Setpoint.DeltaRespMat,   AO.Q13.DeviceList,   'NoEnergyScaling');
% AO.Q21.Setpoint.DeltaRespMat   = physics2hw('Q21',  'Setpoint', AO.Q21.Setpoint.DeltaRespMat,   AO.Q21.DeviceList,   'NoEnergyScaling');
% AO.Q22.Setpoint.DeltaRespMat   = physics2hw('Q22',  'Setpoint', AO.Q22.Setpoint.DeltaRespMat,   AO.Q22.DeviceList,   'NoEnergyScaling');
% AO.Q23.Setpoint.DeltaRespMat   = physics2hw('Q23',  'Setpoint', AO.Q23.Setpoint.DeltaRespMat,   AO.Q23.DeviceList,   'NoEnergyScaling');
% AO.Q31.Setpoint.DeltaRespMat   = physics2hw('Q31',  'Setpoint', AO.Q31.Setpoint.DeltaRespMat,   AO.Q31.DeviceList,   'NoEnergyScaling');
setao(AO);


 
function [BPMlist, HCMlist, VCMlist, QMlist] = buildthedevicelists


BPMlist = [];

for i = 1:7
    BPMlist(i,:) = [ 1 i ];
end

HCMlist = [];
for i = 1:7
    HCMlist(i,:) = [ 1 i ];
end


VCMlist = [];
for i = 1:9
    VCMlist(i,:) = [ 1 i ];
end

QMlist = [];
for i = 1:17
    QMlist(i,:) = [ 1 i ];
end

       

