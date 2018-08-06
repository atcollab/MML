function mlsinit(OperationalMode)
%MLSINIT - MML initialization program for MLS


%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCM, etc
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet center  (often overwritten in updateatindex)
% CommonNames           Shortcut name for each element
%
% Monitor Fields
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


% NOTES & COMMENTS
% 1. Magnet positions get overwritten in updateatindex.  
%    Ie, positions will come directly from the AT model.
% 2. ElemList in the cell arrays are ignored.
% 3. The units from .DeltaRespMat in the cell arrays are physics units 
% 4. I split the SF, SD, HSD families so that correctors can be put in the middle.
% 5. I notice the DeviceList didn't start at sector 1 yet the AT appears to. 
%    I changed the order so that all sector 1 devices are at the start of the ring.
%    Make sure you check that all the channel names are correct.
% 6. Make sure the BPM and magnes are in the correct location in the AT model 
%    or LOCO will have trouble.  
% 7. I picked HSD as the family name for the harmonic sextupoles.  This might
%    not be what you want.  It's easy to change it. (mlsatdeck, mlsinit, updateatindex)
% 8. I put all the QF, QD, etc. magnets in one family.  This can be changed
%    but I personally like to do it this way.  You can select the magnets within
%    a family using the device list.  There are only 8 magnets in these families.
% 9. If you are not already doing it, I would recommend using LabCA!!!


% Functions to test:
% 1. Try mmlviewer to view and check the MML setup.
% 2. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 3. Try setorbitgui, steptune, stepchro, ...
% 4. To run LOCO
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
% 5. Try meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model.


% To-Do:
% 1. The BPMs the the AT-deck are right next to the magnets.  Is this correct?
% 2. Check .Ranges, .Tolerances, and .DeltaRespMat
% 3. hw2physics conversions - everything is done in mls2at and at2mls.
%    It's does not seem right.  For instance,
%    r = mls2at('HCM','Setpoint',1,[1 1])
%        0.0033
%    k = mls2at('QF','Setpoint',1,[1 1])
%        -0.4331
%    That looks large for a 1 ampere change.
% 4. Functions gev2bend needs work to be the inverser of bend2gev.
%    The hystersis loop in bend2gev look a little odd.
% 5. run monmags to check the .Tolerance field
% 6. Measurements - monbpm, measbpmresp, measdisp
% 7  Copy them to the StorageRingOpsData directory using plotfamily.
% 8. Get tune family working
% 9. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)



if nargin < 1
    OperationalMode = 1;
end


% Clear the AO 
setao([]); 


%%%%%%%%%%%%%%%
%  BPMx/BPMy  %
%%%%%%%%%%%%%%%

% x-name       x-chname   xstat y-name    y-chname   ystat DevList Elem   Pos
BPMcell={
'BPMZ1K1RP'	'BPMZ1K1RP:rdX'	1	'BPMZ1K1RP'	'BPMZ1K1RP:rdY'	1	[1,1]	25	'BPM'	42.9790
'BPMZ2K1RP'	'BPMZ2K1RP:rdX'	1	'BPMZ2K1RP'	'BPMZ2K1RP:rdY'	1	[1,2]	26	'BPM'	43.9540
'BPMZ3K1RP'	'BPMZ3K1RP:rdX'	0	'BPMZ3K1RP'	'BPMZ3K1RP:rdY'	0	[1,3]	27	'BPM'	45.9372
'BPMZ4K1RP'	'BPMZ4K1RP:rdX'	1	'BPMZ4K1RP'	'BPMZ4K1RP:rdY'	1	[1,4]	28	'BPM'	46.7966
'BPMZ5K1RP'	'BPMZ5K1RP:rdX'	1	'BPMZ5K1RP'	'BPMZ5K1RP:rdY'	1	[1,5]	1	'BPM'	 1.2034
'BPMZ6K1RP'	'BPMZ6K1RP:rdX'	0	'BPMZ6K1RP'	'BPMZ6K1RP:rdY'	0	[1,6]	2	'BPM'	 2.1040
'BPMZ7K1RP'	'BPMZ7K1RP:rdX'	1	'BPMZ7K1RP'	'BPMZ7K1RP:rdY'	1	[1,7]	3	'BPM'	 4.2490
'BPMZ1L2RP'	'BPMZ1L2RP:rdX'	1	'BPMZ1L2RP'	'BPMZ1L2RP:rdY'	1	[2,1]	4	'BPM'	 5.2290
'BPMZ2L2RP'	'BPMZ2L2RP:rdX'	1	'BPMZ2L2RP'	'BPMZ2L2RP:rdY'	1	[2,2]	5	'BPM'	 6.2040
'BPMZ3L2RP'	'BPMZ3L2RP:rdX'	0	'BPMZ3L2RP'	'BPMZ3L2RP:rdY'	0	[2,3]	6	'BPM'	 8.1872
'BPMZ4L2RP'	'BPMZ4L2RP:rdX'	1	'BPMZ4L2RP'	'BPMZ4L2RP:rdY'	1	[2,4]	7	'BPM'	 9.0466
'BPMZ5L2RP'	'BPMZ5L2RP:rdX'	1	'BPMZ5L2RP'	'BPMZ5L2RP:rdY'	1	[2,5]	8	'BPM'	14.9534
'BPMZ6L2RP'	'BPMZ6L2RP:rdX'	0	'BPMZ6L2RP'	'BPMZ6L2RP:rdY'	0	[2,6]	9	'BPM'	15.8540
'BPMZ7L2RP'	'BPMZ7L2RP:rdX'	1	'BPMZ7L2RP'	'BPMZ7L2RP:rdY'	1	[2,7]	10	'BPM'	17.9990
'BPMZ1K3RP'	'BPMZ1K3RP:rdX'	1	'BPMZ1K3RP'	'BPMZ1K3RP:rdY'	1	[3,1]	11	'BPM'	18.9790
'BPMZ2K3RP'	'BPMZ2K3RP:rdX'	1	'BPMZ2K3RP'	'BPMZ2K3RP:rdY'	1	[3,2]	12	'BPM'	19.9540
'BPMZ3K3RP'	'BPMZ3K3RP:rdX'	0	'BPMZ3K3RP'	'BPMZ3K3RP:rdY'	0	[3,3]	13	'BPM'	21.9372
'BPMZ4K3RP'	'BPMZ4K3RP:rdX'	1	'BPMZ4K3RP'	'BPMZ4K3RP:rdY'	1	[3,4]	14	'BPM'	22.7966
'BPMZ5K3RP'	'BPMZ5K3RP:rdX'	1 	'BPMZ5K3RP'	'BPMZ5K3RP:rdY'	1	[3,5]	15	'BPM'	25.2034
'BPMZ6K3RP'	'BPMZ6K3RP:rdX'	0	'BPMZ6K3RP'	'BPMZ6K3RP:rdY'	0	[3,6]	16	'BPM'	26.1040
'BPMZ7K3RP'	'BPMZ7K3RP:rdX'	1	'BPMZ7K3RP'	'BPMZ7K3RP:rdY'	1	[3,7]	17	'BPM'	28.2490
'BPMZ1L4RP'	'BPMZ1L4RP:rdX'	1	'BPMZ1L4RP'	'BPMZ1L4RP:rdY'	1	[4,1]	18	'BPM'	29.2290
'BPMZ2L4RP'	'BPMZ2L4RP:rdX'	1	'BPMZ2L4RP'	'BPMZ2L4RP:rdY'	1	[4,2]	19	'BPM'	30.2040
'BPMZ3L4RP'	'BPMZ3L4RP:rdX'	0	'BPMZ3L4RP'	'BPMZ3L4RP:rdY'	0	[4,3]	20	'BPM'	32.1872
'BPMZ4L4RP'	'BPMZ4L4RP:rdX'	1	'BPMZ4L4RP'	'BPMZ4L4RP:rdY'	1	[4,4]	21	'BPM'	33.0466
'BPMZ5L4RP'	'BPMZ5L4RP:rdX'	1	'BPMZ5L4RP'	'BPMZ5L4RP:rdY'	1	[4,5]	22	'BPM'	38.9534
'BPMZ6L4RP'	'BPMZ6L4RP:rdX'	0	'BPMZ6L4RP'	'BPMZ6L4RP:rdY' 0	[4,6]	23	'BPM'	39.8540
'BPMZ7L4RP'	'BPMZ7L4RP:rdX'	1	'BPMZ7L4RP'	'BPMZ7L4RP:rdY'	1	[4,7]	24	'BPM'	41.9990
};

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = cell2mat(BPMcell(:,7));
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';  %cell2mat(BPMcell(:,8));
AO.BPMx.Status      = cell2mat(BPMcell(:,3));
AO.BPMx.Position    = cell2mat(BPMcell(:,10));
AO.BPMx.CommonNames = cell2mat(BPMcell(:,1));

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = cell2mat(BPMcell(:,2));
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';

AO.BPMx.Cross.Mode = 'Simulator';
AO.BPMx.Cross.DataType = 'Vector';
AO.BPMx.Cross.DataTypeIndex = [1:size(AO.BPMx.DeviceList,1)];
AO.BPMx.Cross.ChannelNames = [];
AO.BPMx.Cross.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Cross.Physics2HWParams = 1000;
AO.BPMx.Cross.Units        = 'Hardware';
AO.BPMx.Cross.HWUnits      = 'mm';
AO.BPMx.Cross.PhysicsUnits = 'meter';
AO.BPMx.Cross.SpecialFunctionGet = 'getbpmq';

AO.BPMx.Sum.Mode = 'Simulator';
AO.BPMx.Sum.DataType = 'Vector';
AO.BPMx.Sum.DataTypeIndex = [1:size(AO.BPMx.DeviceList,1)];
AO.BPMx.Sum.ChannelNames = [];
AO.BPMx.Sum.HW2PhysicsParams = 1;
AO.BPMx.Sum.Physics2HWParams = 1;
AO.BPMx.Sum.Units        = 'Hardware';
AO.BPMx.Sum.HWUnits      = 'ADC Counts';
AO.BPMx.Sum.PhysicsUnits = 'ADC Counts';
AO.BPMx.Sum.SpecialFunctionGet = 'getbpmsum';  % Returns the BPM button voltage sum


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = cell2mat(BPMcell(:,7));
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';  %cell2mat(BPMcell(:,8));
AO.BPMy.Status      = cell2mat(BPMcell(:,6));
AO.BPMy.Position    = cell2mat(BPMcell(:,10));
AO.BPMy.CommonNames = cell2mat(BPMcell(:,1));

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = cell2mat(BPMcell(:,5));
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';

AO.BPMy.Cross.Mode = 'Simulator';
AO.BPMy.Cross.DataType = 'Vector';
AO.BPMy.Cross.DataTypeIndex = [1:size(AO.BPMy.DeviceList,1)];
AO.BPMy.Cross.ChannelNames = [];
AO.BPMy.Cross.HW2PhysicsParams = 1e-3;
AO.BPMy.Cross.Physics2HWParams = 1000;
AO.BPMy.Cross.Units        = 'Hardware';
AO.BPMy.Cross.HWUnits      = 'mm';
AO.BPMy.Cross.PhysicsUnits = 'meter';
AO.BPMy.Cross.SpecialFunctionGet = 'getbpmq';

AO.BPMy.Sum.Mode = 'Simulator';
AO.BPMy.Sum.DataType = 'Vector';
AO.BPMy.Sum.DataTypeIndex = [1:size(AO.BPMy.DeviceList,1)];
AO.BPMy.Sum.ChannelNames = [];
AO.BPMy.Sum.HW2PhysicsParams = 1;
AO.BPMy.Sum.Physics2HWParams = 1;
AO.BPMy.Sum.Units        = 'Hardware';
AO.BPMy.Sum.HWUnits      = 'ADC Counts';
AO.BPMy.Sum.PhysicsUnits = 'ADC Counts';
AO.BPMy.Sum.SpecialFunctionGet = 'getbpmsum';  % Returns the BPM button voltage sum



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
HCMcell= {
'HS1M1K1RP'	'HS1P1K1RP:rdCur'	'HS1P1K1RP:setCur'	1	[1,1]	11	43.450 [-3.51 3.51] 0.4 100e-6
'HS3M1K1RP'	'HS3P1K1RP:rdCur'	'HS3P1K1RP:setCur'	1	[1,3]	12	46.700 [-3.51 3.51] 0.4 100e-6
'HS3M2K1RP'	'HS3P2K1RP:rdCur'	'HS3P2K1RP:setCur'	1	[1,4]	1	1.300  [-3.51 3.51] 0.4 100e-6
'HS1M2K1RP'	'HS1P2K1RP:rdCur'	'HS1P2K1RP:setCur'	1	[1,6]	2	4.550  [-3.51 3.51] 0.4 100e-6
'HS3M1L2RP'	'HS3P1L2RP:rdCur'	'HS3P1L2RP:setCur'	1	[2,3]	3	8.950  [-3.51 3.51] 0.4 100e-6
'HS3M2L2RP'	'HS3P2L2RP:rdCur'	'HS3P2L2RP:setCur'	1	[2,4]	4	15.050 [-3.51 3.51] 0.4 100e-6
'HS1M1K3RP'	'HS1P1K3RP:rdCur'	'HS1P1K3RP:setCur'	1	[3,1]	5	19.450 [-3.51 3.51] 0.4 100e-6
'HS3M1K3RP'	'HS3P1K3RP:rdCur'	'HS3P1K3RP:setCur'	1	[3,3]	6	22.700 [-3.51 3.51] 0.4 100e-6
'HS3M2K3RP'	'HS3P2K3RP:rdCur'	'HS3P2K3RP:setCur'	1	[3,4]	7	25.300 [-3.51 3.51] 0.4 100e-6
'HS1M2K3RP'	'HS1P2K3RP:rdCur'	'HS1P2K3RP:setCur'	1	[3,6]	8	28.550 [-3.51 3.51] 0.4 100e-6
'HS3M1L4RP'	'HS3P1L4RP:rdCur'	'HS3P1L4RP:setCur'	1	[4,3]	9	32.950 [-3.51 3.51] 0.4 100e-6
'HS3M2L4RP'	'HS3P2L4RP:rdCur'	'HS3P2L4RP:setCur'	1	[4,4]	10	39.050 [-3.51 3.51] 0.4 100e-6
};

AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = cell2mat(HCMcell(:,5));
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';  %cell2mat(HCMcell(:,6));
AO.HCM.Status      = cell2mat(HCMcell(:,4));
AO.HCM.Position    = cell2mat(HCMcell(:,7));
AO.HCM.CommonNames = cell2mat(HCMcell(:,1));

AO.HCM.Monitor.MemberOf = {'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = cell2mat(HCMcell(:,2));
AO.HCM.Monitor.HW2PhysicsFcn = @mls2at;
AO.HCM.Monitor.Physics2HWFcn = @at2mls;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = cell2mat(HCMcell(:,3));
AO.HCM.Setpoint.HW2PhysicsFcn = @mls2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2mls;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range = cell2mat(HCMcell(:,8));
AO.HCM.Setpoint.Tolerance = cell2mat(HCMcell(:,9));
AO.HCM.Setpoint.DeltaRespMat = cell2mat(HCMcell(:,10));
 

% VCM
VCMcell={
'VS2M1K1RP'	'VS2P1K1RP:rdCur'	'VS2P1K1RP:setCur'	1	[1,2]	15	43.850  [-7 7] 0.4 100e-6 
'VS3M1K1RP'	'VS3P1K1RP:rdCur'	'VS3P1K1RP:setCur'	1	[1,3]	16	46.700  [-7 7] 0.4 100e-6
'VS3M2K1RP'	'VS3P2K1RP:rdCur'	'VS3P2K1RP:setCur'	1	[1,4]	1	1.300   [-7 7] 0.4 100e-6    
'VS2M2K1RP'	'VS2P2K1RP:rdCur'	'VS2P2K1RP:setCur'	1	[1,5]	2	4.150   [-7 7] 0.4 100e-6
'VS2M1L2RP'	'VS2P1L2RP:rdCur'	'VS2P1L2RP:setCur'	1	[2,2]	3	6.100   [-7 7] 0.4 100e-6 
'VS3M1L2RP'	'VS3P1L2RP:rdCur'	'VS3P1L2RP:setCur'	1	[2,3]	4	8.950	[-7 7] 0.4 100e-6
'VS3M2L2RP'	'VS3P2L2RP:rdCur'	'VS3P2L2RP:setCur'	1	[2,4]	5	15.050  [-7 7] 0.4 100e-6
'VS2M2L2RP'	'VS2P2L2RP:rdCur'	'VS2P2L2RP:setCur'	1	[2,5]	6	17.900  [-7 7] 0.4 100e-6
'VS2M1K3RP'	'VS2P1K3RP:rdCur'	'VS2P1K3RP:setCur'	1	[3,2]	7	19.850  [-7 7] 0.4 100e-6
'VS3M1K3RP'	'VS3P1K3RP:rdCur'	'VS3P1K3RP:setCur'	1	[3,3]	8	22.700  [-7 7] 0.4 100e-6
'VS3M2K3RP'	'VS3P2K3RP:rdCur'	'VS3P2K3RP:setCur'	1	[3,4]	9	25.300  [-7 7] 0.4 100e-6
'VS2M2K3RP'	'VS2P2K3RP:rdCur'	'VS2P2K3RP:setCur'	1	[3,5]	10	28.150  [-7 7] 0.4 100e-6
'VS2M1L4RP'	'VS2P1L4RP:rdCur'	'VS2P1L4RP:setCur'	1	[4,2]	11	30.100  [-7 7] 0.4 100e-6
'VS3M1L4RP'	'VS3P1L4RP:rdCur'	'VS3P1L4RP:setCur'	1	[4,3]	12	32.950  [-7 7] 0.4 100e-6
'VS3M2L4RP'	'VS3P2L4RP:rdCur'	'VS3P2L4RP:setCur'	1	[4,4]	13	39.050  [-7 7] 0.4 100e-6
'VS2M2L4RP'	'VS2P2L4RP:rdCur'	'VS2P2L4RP:setCur'	1	[4,5]	14	41.900  [-7 7] 0.4 100e-6
};

AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = cell2mat(VCMcell(:,5));
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';  %cell2mat(VCMcell(:,6));
AO.VCM.Status      = cell2mat(VCMcell(:,4));
AO.VCM.Position    = cell2mat(VCMcell(:,7));
AO.VCM.CommonNames = cell2mat(VCMcell(:,1));

AO.VCM.Monitor.MemberOf = {'COR'; 'Horizontal'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = cell2mat(VCMcell(:,2));
AO.VCM.Monitor.HW2PhysicsFcn = @mls2at;
AO.VCM.Monitor.Physics2HWFcn = @at2mls;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Horizontal'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = cell2mat(VCMcell(:,3));
AO.VCM.Setpoint.HW2PhysicsFcn = @mls2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2mls;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range = cell2mat(VCMcell(:,8));
AO.VCM.Setpoint.Tolerance = cell2mat(VCMcell(:,9));
AO.VCM.Setpoint.DeltaRespMat = cell2mat(VCMcell(:,10));



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%

% QF
QFcell={
'Q3M1K1RP'	'Q3PKRP:rdCur '	'Q3PKRP:setCur '	1	[1,3]	4	46.400  [0 92.7] 0.4 0.005  2
'Q3M2K1RP'	'Q3PKRP:rdCur '	'Q3PKRP:setCur '	1	[1,4]	1	1.600   [0 92.7] 0.4 0.005  3
'Q3M1L2RP'	'Q3PL2RP:rdCur'	'Q3PL2RP:setCur'	1	[2,3]	1	8.650   [0 92.7] 0.4 0.005  8
'Q3M2L2RP'	'Q3PL2RP:rdCur'	'Q3PL2RP:setCur'	1	[2,4]	2	15.350  [0 92.7] 0.4 0.005  9
'Q3M1K3RP'	'Q3PKRP:rdCur '	'Q3PKRP:setCur '	1	[3,3]	2	22.400  [0 92.7] 0.4 0.005 14
'Q3M2K3RP'	'Q3PKRP:rdCur '	'Q3PKRP:setCur '	1	[3,4]	3	25.600  [0 92.7] 0.4 0.005 15
'Q3M1L4RP'	'Q3PL4RP:rdCur'	'Q3PL4RP:setCur'	1	[4,3]	1	32.650  [0 92.7] 0.4 0.005 20
'Q3M2L4RP'	'Q3PL4RP:rdCur'	'Q3PL4RP:setCur'	1	[4,4]	2	39.350  [0 92.7] 0.4 0.005 21
};

AO.QF.FamilyName  = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QF.DeviceList  = cell2mat(QFcell(:,5));
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';  %cell2mat(QFcell(:,6));
AO.QF.Status      = cell2mat(QFcell(:,4));
AO.QF.Position    = cell2mat(QFcell(:,7));
AO.QF.CommonNames = cell2mat(QFcell(:,1));

AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = cell2mat(QFcell(:,2));
AO.QF.Monitor.HW2PhysicsFcn = @mls2at;
AO.QF.Monitor.Physics2HWFcn = @at2mls;
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = cell2mat(QFcell(:,3));
AO.QF.Setpoint.HW2PhysicsFcn = @mls2at;
AO.QF.Setpoint.Physics2HWFcn = @at2mls;
AO.QF.Setpoint.Units        = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = 'meter^-2';
AO.QF.Setpoint.Range = cell2mat(QFcell(:,8));
AO.QF.Setpoint.Tolerance = cell2mat(QFcell(:,9));
AO.QF.Setpoint.DeltaRespMat = cell2mat(QFcell(:,10));


% QD
QDcell={
'Q2M1K1RP'	'Q2PKRP:rdCur '	'Q2PKRP:setCur '	1	[1,2]	4	46.050  [0 92.7] 0.4 0.005  1
'Q2M2K1RP'	'Q2PKRP:rdCur '	'Q2PKRP:setCur '	1	[1,5]	1	1.950   [0 92.7] 0.4 0.005  4
'Q2M1L2RP'	'Q2PL2RP:rdCur'	'Q2PL2RP:setCur'	1	[2,2]	1	8.300   [0 92.7] 0.4 0.005  7
'Q2M2L2RP'	'Q2PL2RP:rdCur'	'Q2PL2RP:setCur'	1	[2,5]	2	15.700  [0 92.7] 0.4 0.005 10
'Q2M1K3RP'	'Q2PKRP:rdCur '	'Q2PKRP:setCur '	1	[3,2]	2	22.050  [0 92.7] 0.4 0.005 13
'Q2M2K3RP'	'Q2PKRP:rdCur '	'Q2PKRP:setCur '	1	[3,5]	3	25.950  [0 92.7] 0.4 0.005 16
'Q2M1L4RP'	'Q2PL4RP:rdCur'	'Q2PL4RP:setCur'	1	[4,2]	1	32.300  [0 92.7] 0.4 0.005 19
'Q2M2L4RP'	'Q2PL4RP:rdCur'	'Q2PL4RP:setCur'	1	[4,5]	2	39.700  [0 92.7] 0.4 0.005 22
};

AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD.DeviceList  = cell2mat(QDcell(:,5));
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';  %cell2mat(QDcell(:,6));
AO.QD.Status      = cell2mat(QDcell(:,4));
AO.QD.Position    = cell2mat(QDcell(:,11));
AO.QD.CommonNames = cell2mat(QDcell(:,1));

AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = cell2mat(QDcell(:,2));
AO.QD.Monitor.HW2PhysicsFcn = @mls2at;
AO.QD.Monitor.Physics2HWFcn = @at2mls;
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = cell2mat(QDcell(:,3));
AO.QD.Setpoint.HW2PhysicsFcn = @mls2at;
AO.QD.Setpoint.Physics2HWFcn = @at2mls;
AO.QD.Setpoint.Units        = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = 'meter^-2';
AO.QD.Setpoint.Range = cell2mat(QDcell(:,8));
AO.QD.Setpoint.Tolerance = cell2mat(QDcell(:,9));
AO.QD.Setpoint.DeltaRespMat = cell2mat(QDcell(:,10));


% QFA
QFAcell={
'Q1M1K1RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[1,1]	8	43.150  [0 65.55] 0.4  0.005  0
'Q1M2K1RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[1,6]	1	4.850   [0 65.55] 0.4  0.005  5
'Q1M1L2RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[2,1]	2	5.400   [0 65.55] 0.4  0.005  6
'Q1M2L2RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[2,6]	3	18.600  [0 65.55] 0.4  0.005 11
'Q1M1K3RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[3,1]	4	19.150  [0 65.55] 0.4  0.005 12
'Q1M2K3RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[3,6]	5	28.850  [0 65.55] 0.4  0.005 17
'Q1M1L4RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[4,1]	6	29.400  [0 65.55] 0.4  0.005 18
'Q1M2L4RP'	'Q1PRP:rdCur'	'Q1PRP:setCur'	1	[4,6]	7	42.600  [0 65.55] 0.4  0.005 23
};

AO.QFA.FamilyName  = 'QFA';
AO.QFA.MemberOf    = {'PlotFamily'; 'QFA'; 'QUAD'; 'Magnet'; 'Dispersion Corrector';};
AO.QFA.DeviceList  = cell2mat(QFAcell(:,5));
AO.QFA.ElementList = (1:size(AO.QFA.DeviceList,1))';  %cell2mat(QFAcell(:,6));
AO.QFA.Status      = cell2mat(QFAcell(:,4));
AO.QFA.Position    = cell2mat(QFAcell(:,7));
AO.QFA.CommonNames = cell2mat(QFAcell(:,1));

AO.QFA.Monitor.MemberOf = {};
AO.QFA.Monitor.Mode = 'Simulator';
AO.QFA.Monitor.DataType = 'Scalar';
AO.QFA.Monitor.ChannelNames = cell2mat(QFAcell(:,2));
AO.QFA.Monitor.HW2PhysicsFcn = @mls2at;
AO.QFA.Monitor.Physics2HWFcn = @at2mls;
AO.QFA.Monitor.Units        = 'Hardware';
AO.QFA.Monitor.HWUnits      = 'Ampere';
AO.QFA.Monitor.PhysicsUnits = 'meter^-2';

AO.QFA.Setpoint.MemberOf = {'MachineConfig';};
AO.QFA.Setpoint.Mode = 'Simulator';
AO.QFA.Setpoint.DataType = 'Scalar';
AO.QFA.Setpoint.ChannelNames = cell2mat(QFAcell(:,3));
AO.QFA.Setpoint.HW2PhysicsFcn = @mls2at;
AO.QFA.Setpoint.Physics2HWFcn = @at2mls;
AO.QFA.Setpoint.Units        = 'Hardware';
AO.QFA.Setpoint.HWUnits      = 'Ampere';
AO.QFA.Setpoint.PhysicsUnits = 'meter^-2';
AO.QFA.Setpoint.Range = cell2mat(QFAcell(:,8));
AO.QFA.Setpoint.Tolerance = cell2mat(QFAcell(:,9));
AO.QFA.Setpoint.DeltaRespMat = cell2mat(QFAcell(:,10));



%===========
% Sextupoles
%===========

% SF
SFcell={
'S1M1K1RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[1,1]	8	43.450  [0 34] 0.4 0.4e-3
'S1M2K1RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[1,6]	1	4.550   [0 34] 0.4 0.4e-3
'S1M1L2RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[2,1]	2	5.700   [0 34] 0.4 0.4e-3 
'S1M2L2RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[2,6]	3	18.300  [0 34] 0.4 0.4e-3
'S1M1K3RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[3,1]	4	19.450  [0 34] 0.4 0.4e-3
'S1M2K3RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[3,6]	5	28.550  [0 34] 0.4 0.4e-3
'S1M1L4RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[4,1]	6	29.700  [0 34] 0.4 0.4e-3
'S1M2L4RP'	'S1PRP:rdCur'	'S1PRP:setCur'	1	[4,6]	7	42.300  [0 34] 0.4 0.4e-3
};

AO.SF.FamilyName  = 'SF';
AO.SF.MemberOf    = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SF.DeviceList  = cell2mat(SFcell(:,5));
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';  %cell2mat(SFcell(:,6));
AO.SF.Status      = cell2mat(SFcell(:,4));
AO.SF.Position    = cell2mat(SFcell(:,7));
AO.SF.CommonNames = cell2mat(SFcell(:,1));

AO.SF.Monitor.MemberOf = {};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = cell2mat(SFcell(:,2));
AO.SF.Monitor.HW2PhysicsFcn = @mls2at;
AO.SF.Monitor.Physics2HWFcn = @at2mls;
AO.SF.Monitor.Units        = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = 'meter^-3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = cell2mat(SFcell(:,3));
AO.SF.Setpoint.HW2PhysicsFcn = @mls2at;
AO.SF.Setpoint.Physics2HWFcn = @at2mls;
AO.SF.Setpoint.Units        = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = 'meter^-3';
AO.SF.Setpoint.Range = cell2mat(SFcell(:,8));
AO.SF.Setpoint.Tolerance = cell2mat(SFcell(:,9));
AO.SF.Setpoint.DeltaRespMat = cell2mat(SFcell(:,10));


% SD
SDcell={
'S2M1K1RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[1,2]	8	43.850  [0 34] 0.4 0.4e-3
'S2M2K1RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[1,5]	1	4.150   [0 34] 0.4 0.4e-3
'S2M1L2RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[2,2]	2	6.100   [0 34] 0.4 0.4e-3
'S2M2L2RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[2,5]	3	17.900  [0 34] 0.4 0.4e-3
'S2M1K3RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[3,2]	4	19.850  [0 34] 0.4 0.4e-3
'S2M2K3RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[3,5]	5	28.150  [0 34] 0.4 0.4e-3
'S2M1L4RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[4,2]	6	30.100  [0 34] 0.4 0.4e-3
'S2M2L4RP'	'S2PRP:rdCur'	'S2PRP:setCur'	1	[4,5]	7	41.900  [0 34] 0.4 0.4e-3
};

AO.SD.FamilyName  = 'SD';
AO.SD.MemberOf    = {'PlotFamily'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SD.DeviceList  = cell2mat(SDcell(:,5));
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';  %cell2mat(SDcell(:,6));
AO.SD.Status      = cell2mat(SDcell(:,4));
AO.SD.Position    = cell2mat(SDcell(:,7));
AO.SD.CommonNames = cell2mat(SDcell(:,1));

AO.SD.Monitor.MemberOf = {};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = cell2mat(SDcell(:,2));
AO.SD.Monitor.HW2PhysicsFcn = @mls2at;
AO.SD.Monitor.Physics2HWFcn = @at2mls;
AO.SD.Monitor.Units        = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = 'meter^-3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = cell2mat(SDcell(:,3));
AO.SD.Setpoint.HW2PhysicsFcn = @mls2at;
AO.SD.Setpoint.Physics2HWFcn = @at2mls;
AO.SD.Setpoint.Units        = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = 'meter^-3';
AO.SD.Setpoint.Range = cell2mat(SDcell(:,8));
AO.SD.Setpoint.Tolerance = cell2mat(SDcell(:,9));
AO.SD.Setpoint.DeltaRespMat = cell2mat(SDcell(:,10));


% HSD
HSDcell={
'S3M1K1RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[1,3]	8	46.700  [0 34] 0.4 0.4e-3
'S3M2K1RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[1,4]	1	1.300   [0 34] 0.4 0.4e-3
'S3M1L2RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[2,3]	2	8.950   [0 34] 0.4 0.4e-3
'S3M2L2RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[2,5]	3	15.050  [0 34] 0.4 0.4e-3
'S3M1K3RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[3,3]	4	22.700  [0 34] 0.4 0.4e-3
'S3M2K3RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[3,4]	5	25.300  [0 34] 0.4 0.4e-3
'S3M1L4RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[4,3]	6	32.950  [0 34] 0.4 0.4e-3
'S3M2L4RP'	'S3PRP:rdCur'	'S3PRP:setCur'	1	[4,4]	7	39.050  [0 34] 0.4 0.4e-3
};

AO.HSD.FamilyName  = 'HSD';
AO.HSD.MemberOf    = {'PlotFamily'; 'HSD'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole';};
AO.HSD.DeviceList  = cell2mat(HSDcell(:,5));
AO.HSD.ElementList = (1:size(AO.HSD.DeviceList,1))';  %cell2mat(HSDcell(:,6));
AO.HSD.Status      = cell2mat(HSDcell(:,4));
AO.HSD.Position    = cell2mat(HSDcell(:,7));
AO.HSD.CommonNames = cell2mat(HSDcell(:,1));

AO.HSD.Monitor.MemberOf = {};
AO.HSD.Monitor.Mode = 'Simulator';
AO.HSD.Monitor.DataType = 'Scalar';
AO.HSD.Monitor.ChannelNames = cell2mat(HSDcell(:,2));
AO.HSD.Monitor.HW2PhysicsFcn = @mls2at;
AO.HSD.Monitor.Physics2HWFcn = @at2mls;
AO.HSD.Monitor.Units        = 'Hardware';
AO.HSD.Monitor.HWUnits      = 'Ampere';
AO.HSD.Monitor.PhysicsUnits = 'meter^-3';

AO.HSD.Setpoint.MemberOf = {'MachineConfig';};
AO.HSD.Setpoint.Mode = 'Simulator';
AO.HSD.Setpoint.DataType = 'Scalar';
AO.HSD.Setpoint.ChannelNames = cell2mat(HSDcell(:,3));
AO.HSD.Setpoint.HW2PhysicsFcn = @mls2at;
AO.HSD.Setpoint.Physics2HWFcn = @at2mls;
AO.HSD.Setpoint.Units        = 'Hardware';
AO.HSD.Setpoint.HWUnits      = 'Ampere';
AO.HSD.Setpoint.PhysicsUnits = 'meter^-3';
AO.HSD.Setpoint.Range = cell2mat(HSDcell(:,8));
AO.HSD.Setpoint.Tolerance = cell2mat(HSDcell(:,9));
AO.HSD.Setpoint.DeltaRespMat = cell2mat(HSDcell(:,10));


%%%%%%%%%%%%
% Octupole %
%%%%%%%%%%%%
OCTUcell = {
'OML4RP'	'OPRP:rdCur'	'OPRP:setCur'	1	[1,1]	4	42.875  [0 6] 0.4  0.03
'OMK1RP'	'OPRP:rdCur'	'OPRP:setCur'	1	[2,1]	1	5.125   [0 6] 0.4  0.03
'OML2RP'	'OPRP:rdCur'	'OPRP:setCur'	1	[3,1]	2	18.875  [0 6] 0.4  0.03
'OMK3RP'	'OPRP:rdCur'	'OPRP:setCur'	1	[4,1]	3	29.125  [0 6] 0.4  0.03
};

AO.OCTU.FamilyName  = 'OCTU';
AO.OCTU.MemberOf    = {'PlotFamily'; 'MachineConfig'; 'OCTU'; 'Octupole'; 'Magnet'};
AO.OCTU.DeviceList  = cell2mat(OCTUcell(:,5));
AO.OCTU.ElementList = (1:size(AO.OCTU.DeviceList,1))';  %cell2mat(OCTUcell(:,6));
AO.OCTU.Status      = cell2mat(OCTUcell(:,4));
AO.OCTU.Position    = cell2mat(OCTUcell(:,7));
AO.OCTU.CommonNames = cell2mat(OCTUcell(:,1));

AO.OCTU.Monitor.MemberOf = {};
AO.OCTU.Monitor.Mode = 'Simulator';
AO.OCTU.Monitor.DataType = 'Scalar';
AO.OCTU.Monitor.ChannelNames = cell2mat(OCTUcell(:,2));
AO.OCTU.Monitor.HW2PhysicsFcn = @mls2at;
AO.OCTU.Monitor.Physics2HWFcn = @at2mls;
AO.OCTU.Monitor.Units        = 'Hardware';
AO.OCTU.Monitor.HWUnits      = 'Ampere';
AO.OCTU.Monitor.PhysicsUnits = 'meter^-4';

AO.OCTU.Setpoint.MemberOf = {'MachineConfig';};
AO.OCTU.Setpoint.Mode = 'Simulator';
AO.OCTU.Setpoint.DataType = 'Scalar';
AO.OCTU.Setpoint.ChannelNames = cell2mat(OCTUcell(:,3));
AO.OCTU.Setpoint.HW2PhysicsFcn = @mls2at;
AO.OCTU.Setpoint.Physics2HWFcn = @at2mls;
AO.OCTU.Setpoint.Units        = 'Hardware';
AO.OCTU.Setpoint.HWUnits      = 'Ampere';
AO.OCTU.Setpoint.PhysicsUnits = 'meter^-4';
AO.OCTU.Setpoint.Range        = cell2mat(OCTUcell(:,8));
AO.OCTU.Setpoint.Tolerance    = cell2mat(OCTUcell(:,9));
AO.OCTU.Setpoint.DeltaRespMat = cell2mat(OCTUcell(:,10));



%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
BENDcell = {
'BM1K1RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[1,1]	8	44.925   [0 630] 0.5 0.5 'BPRP:stoCur'
'BM2K1RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[1,2]	1	3.075    [0 630] 0.5 0.5 'BPRP:stoCur'
'BM1L2RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[2,1]	2	7.175    [0 630] 0.5 0.5 'BPRP:stoCur'
'BM2L2RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[2,2]	3	16.825   [0 630] 0.5 0.5 'BPRP:stoCur'
'BM1K3RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[3,1]	4	20.925   [0 630] 0.5 0.5 'BPRP:stoCur'
'BM2K3RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[3,2]	5	27.075   [0 630] 0.5 0.5 'BPRP:stoCur'
'BM1L4RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[4,1]	6	31.175   [0 630] 0.5 0.5 'BPRP:stoCur'
'BM2L4RP'	'BPRP:rdCur'	'BPRP:setCur'	1	[4,2]	7	40.825   [0 630] 0.5 0.5 'BPRP:stoCur'
};

AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = cell2mat(BENDcell(:,5));
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';  %cell2mat(BENDcell(:,6));
AO.BEND.Status      = cell2mat(BENDcell(:,4));
AO.BEND.Position    = cell2mat(BENDcell(:,7));
AO.BEND.CommonNames = cell2mat(BENDcell(:,1));

AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = cell2mat(BENDcell(:,2));
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = cell2mat(BENDcell(:,3));
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = cell2mat(BENDcell(:,8));
AO.BEND.Setpoint.Tolerance    = cell2mat(BENDcell(:,9));
AO.BEND.Setpoint.DeltaRespMat = cell2mat(BENDcell(:,10));



%%%%%%%%%%%%%
% Skew Quad %
%%%%%%%%%%%%%
CQScell = {
'CQS1M1L2RP'	'CQS1P1L2RP:rdCur'	'CQS1P1L2RP:setCur'	1	[2,1]	1	5.700  [-Inf Inf] .1 .1
'CQS1M2L2RP'	'CQS1P2L2RP:rdCur'	'CQS1P2L2RP:setCur'	1	[2,6]	2	18.300 [-Inf Inf] .1 .1
'CQS1M1L4RP'	'CQS1P1L4RP:rdCur'	'CQS1P1L4RP:setCur'	1	[4,1]	3	29.700 [-Inf Inf] .1 .1
'CQS1M2L4RP'	'CQS1P2L4RP:rdCur'	'CQS1P2L4RP:setCur'	1	[4,6]	4	42.300 [-Inf Inf] .1 .1
};

AO.CQS.FamilyName  = 'CQS';
AO.CQS.MemberOf    = {'PlotFamily'; 'CQS'; 'SKEWQUAD'; 'Magnet';};
AO.CQS.DeviceList  = cell2mat(CQScell(:,5));
AO.CQS.ElementList = (1:size(AO.CQS.DeviceList,1))';  %cell2mat(CQScell(:,6));
AO.CQS.Status      = cell2mat(CQScell(:,4));
AO.CQS.Position    = cell2mat(CQScell(:,7));
AO.CQS.CommonNames = cell2mat(CQScell(:,1));

AO.CQS.Monitor.MemberOf = {};
AO.CQS.Monitor.Mode = 'Simulator';
AO.CQS.Monitor.DataType = 'Scalar';
AO.CQS.Monitor.ChannelNames = cell2mat(CQScell(:,2));
AO.CQS.Monitor.HW2PhysicsFcn = @mls2at;
AO.CQS.Monitor.Physics2HWFcn = @at2mls;
AO.CQS.Monitor.Units        = 'Hardware';
AO.CQS.Monitor.HWUnits      = 'Ampere';
AO.CQS.Monitor.PhysicsUnits = 'meter^-2';

AO.CQS.Setpoint.MemberOf = {'MachineConfig';};
AO.CQS.Setpoint.Mode = 'Simulator';
AO.CQS.Setpoint.DataType = 'Scalar';
AO.CQS.Setpoint.ChannelNames = cell2mat(CQScell(:,3));
AO.CQS.Setpoint.HW2PhysicsFcn = @mls2at;
AO.CQS.Setpoint.Physics2HWFcn = @at2mls;
AO.CQS.Setpoint.Units        = 'Hardware';
AO.CQS.Setpoint.HWUnits      = 'Ampere';
AO.CQS.Setpoint.PhysicsUnits = 'meter^-2';
AO.CQS.Setpoint.Range        = cell2mat(CQScell(:,8));
AO.CQS.Setpoint.Tolerance    = cell2mat(CQScell(:,9));
AO.CQS.Setpoint.DeltaRespMat = cell2mat(CQScell(:,10));



%%%%%%%%%
%   RF  %
%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;
AO.RF.CommonNames               = 'RF';

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.ChannelNames      = 'MCLKHGP:rdFrq';
AO.RF.Monitor.HW2PhysicsParams  = 1e+3;
AO.RF.Monitor.Physics2HWParams  = 1e-3;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'kHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = 'MCLKHGP:setFrq';
AO.RF.Setpoint.HW2PhysicsParams = 1e+3;
AO.RF.Setpoint.Physics2HWParams = 1e-3;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'kHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [0 500000];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageCtrl.Mode              = 'Simulator';
AO.RF.VoltageCtrl.DataType          = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames      = 'PAHRP:setVoltCav';
AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
AO.RF.VoltageCtrl.Physics2HWParams  = 1;
AO.RF.VoltageCtrl.Units             = 'Hardware';
AO.RF.VoltageCtrl.HWUnits           = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;
AO.DCCT.CommonNames            = 'DCCT';

AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'CUM1ZK3RP:rdCur';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'milli-ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'ampere';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = 'TUNE';

AO.TUNE.Monitor.MemberOf   = {'TUNE';};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_mls';


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
AO.QFA.Setpoint.DeltaRespMat  = physics2hw('QFA', 'Setpoint', AO.QFA.Setpoint.DeltaRespMat,  AO.QFA.DeviceList,  'NoEnergyScaling');
AO.CQS.Setpoint.DeltaRespMat  = physics2hw('CQS', 'Setpoint', AO.CQS.Setpoint.DeltaRespMat,  AO.CQS.DeviceList,  'NoEnergyScaling');
AO.SF.Setpoint.DeltaRespMat   = physics2hw('SF',  'Setpoint', AO.SF.Setpoint.DeltaRespMat,   AO.SF.DeviceList,   'NoEnergyScaling');
AO.SD.Setpoint.DeltaRespMat   = physics2hw('SD',  'Setpoint', AO.SD.Setpoint.DeltaRespMat,   AO.SD.DeviceList,   'NoEnergyScaling');
AO.HSD.Setpoint.DeltaRespMat  = physics2hw('HSD', 'Setpoint', AO.HSD.Setpoint.DeltaRespMat,  AO.HSD.DeviceList,  'NoEnergyScaling');
AO.OCTU.Setpoint.DeltaRespMat = physics2hw('OCTU','Setpoint', AO.OCTU.Setpoint.DeltaRespMat, AO.OCTU.DeviceList, 'NoEnergyScaling');
setao(AO);


