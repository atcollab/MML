function LT1init(OperationalMode)
% LT1INIT - Contructs an accelerator Object describing LT1
%
% Written by Laurent S. Nadolski, Synchrotron SOLEIL
%
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            CH, CV, QP, Bend
% CommonNames           Shortcut name for each element
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, magnet center
%
% MONITOR FIELD
% Mode                  online/manual/special/simulator
% TangoNames            Tango device name for monitor
% Units                 Physics or HW
% HW2PhysicsFcn         function handle used to convert from hardware to physics units ==> inline will not compile, see below
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';
% PhysicsUnits          units for physics 'Rad';
% Handles               monitor handle
%
% SETPOINT FIELDS
% Mode                  online/manual/special/simulator
% TangoNames            PV for monitor
% Units                 hardware or physics
% HW2PhysicsFcn         function handle used to convert from hardware to physics units
% HW2PhysicsParams      parameters used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      parameters used for conversion function
% HWUnits               units for Hardware 'ampere';
% PhysicsUnits          units for physics 'Rad';
% Range                 minsetpoint, maxsetpoint;
% Tolerance             setpoint-monitor
% Handles               setpoint handle
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
%    CH
%    CV
%    BEND
%    QP
%    Machine Parameters
%
%  See Also aoinit, setoperationalmode, updateatindex, setpathsoleil

%==============================
%load AcceleratorData structure
%==============================

if nargin < 1
    OperationalMode = 1;
end

global GLOBVAL THERING

Mode             = 'online';
setad([]);       %clear AcceleratorData memory
AD.SubMachine    = 'LT1'; % Will already be defined if setpathmml was used
AD.Energy        = 0.110; % Energy in GeV

setad(AD);   %load AcceleratorData

%%%%%%%%%%%%%%%%%%%%
% ACCELERATOR OBJECT
%%%%%%%%%%%%%%%%%%%%

setao([]);   %clear previous AcceleratorObjects

%% Dipole
ifam = 'BEND';

AO.(ifam).FamilyName             = 'BEND';
AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'BEND'; 'Archivable'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).DeviceName{1}          = 'LT1/AE/D.1';
AO.(ifam).CommonNames{1}         = 'DIP';
AO.(ifam).DeviceList(1,:)        = [1 1];
AO.(ifam).ElementList            = 1;
AO.(ifam).Status                 = 1;
AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/current');
AO.(ifam).Monitor.ModelVal       = 0;
AO.(ifam).Monitor.TangoVal       = 0;
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN;
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.HW2PhysicsFcn  = @bend2gev;
AO.(ifam).Monitor.Physics2HWFcn  = @gev2bend;
setao(AO);
[C Leff Type coefficients] = magnetcoefficients(AO.(ifam).FamilyName );
AO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = coefficients;
AO.(ifam).Monitor.Physics2HWParams = AO.(ifam).Monitor.HW2PhysicsParams;

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired  = AO.(ifam).Monitor;

%% Quadrupoles
ifam = 'QP';

AO.(ifam).FamilyName             = 'QP';
AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'QP'; 'Archivable'};
AO.(ifam).Mode                   = Mode;
for ik = 1:7    
    AO.(ifam).DeviceName{ik}  = ['LT1/AE/Q.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['QP' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
AO.(ifam).CommonNames            = AO.(ifam).CommonNames';

nb                               = length(AO.(ifam).DeviceName);
AO.(ifam).Monitor.Range(:,:)     = repmat([-10 10],nb,1);
AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/current');
AO.(ifam).Status                 = ones(nb,1);
AO.(ifam).Monitor.ModelVal       = zeros(1,nb);
AO.(ifam).Monitor.TangoVal       = AO.(ifam).Monitor.ModelVal;
AO.(ifam).ElementList            = 1:nb;

AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn = @k2amp;

%C = magnetcoefficients4LT1(AO.(ifam).FamilyName);
C = magnetcoefficients(AO.(ifam).FamilyName);

for ii=1:nb,
    if ii == 2 || ii == 3 || ii == 6
        % Defocusing quads
        AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
        AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
    else
        % Focusing quad
        AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C;
        AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C;
    end
end

%AO.(ifam).Monitor.Range(:,:) = repmat([-5 5],nb,1); % 10 A for 0.8 mrad
AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;



%% Horizontal Correctors
ifam = 'CH';
AO.(ifam).FamilyName           = 'CH';
AO.(ifam).MemberOf             = {'MachineConfig'; 'HCM'; 'Magnet'; 'CH'; 'Archivable'};

for ik = 1:3    
    AO.(ifam).DeviceName{ik}  = ['LT1/AE/CH.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['CH' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName               = AO.(ifam).DeviceName';
AO.(ifam).CommonNames              = AO.(ifam).CommonNames';

nb                         = length(AO.(ifam).DeviceName);
AO.(ifam).Monitor.Range(:,:)     = repmat([-1.5 1.5],nb,1);
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/current');
AO.(ifam).Status               = ones(nb,1);
AO.(ifam).Monitor.ModelVal     = zeros(1,nb);
AO.(ifam).Monitor.TangoVal     = AO.(ifam).Monitor.ModelVal;
AO.(ifam).ElementList           = 1:nb;

AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.HW2PhysicsFcn  = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn  = @k2amp;
[C Leff Type coefficients] = magnetcoefficients(AO.(ifam).FamilyName );
AO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = coefficients;
AO.(ifam).Monitor.Physics2HWParams = AO.(ifam).Monitor.HW2PhysicsParams;

AO.(ifam).Setpoint = AO.(ifam).Monitor;


%% Vertical Correctors
ifam = 'CV';

AO.(ifam).FamilyName           = 'CV';
AO.(ifam).MemberOf             = {'MachineConfig'; 'Magnet'; 'VCM'; 'CV'; 'Archivable'};
AO.(ifam).Mode                 = Mode;

for ik = 1:3    
    AO.(ifam).DeviceName{ik}  = ['LT1/AE/CV.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['CV' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName               = AO.(ifam).DeviceName';
AO.(ifam).CommonNames              = AO.(ifam).CommonNames';

nb                             = length(AO.(ifam).DeviceName);
AO.(ifam).Monitor.Range(:,:)     = repmat([-1.5 1.5],nb,1);
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/current');
AO.(ifam).Status               = ones(nb,1);
AO.(ifam).Monitor.ModelVal     = zeros(1,nb);
AO.(ifam).Monitor.TangoVal     = AO.(ifam).Monitor.ModelVal;
AO.(ifam).ElementList          = 1:nb;

AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.HW2PhysicsFcn  = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn  = @k2amp;
[C Leff Type coefficients] = magnetcoefficients(AO.(ifam).FamilyName );
AO.(ifam).Monitor.HW2PhysicsParams{1}(1,:) = coefficients;
AO.(ifam).Monitor.Physics2HWParams = AO.(ifam).Monitor.HW2PhysicsParams;

AO.(ifam).Setpoint = AO.(ifam).Monitor;

%%%%%%%%%%%%%%%%%%
%% cycleramp
%%%%%%%%%%%%%%%%%

%% cycleramp For dipole magnet
ifam = 'CycleBEND';

AO.(ifam).FamilyName             = 'CycleBEND';
AO.(ifam).MemberOf               = {'CycleBEND'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create('Dipole'); 
AO.(ifam).DeviceName             = 'LT1/AE/cycleD.1';
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName);
AO.(ifam).Inom = 180;
AO.(ifam).Imax = 250;
AO.(ifam).Status = 1;

%% cycleramp For H-corrector magnets
ifam = 'CycleCH';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleCOR'; 'CycleCH'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create('COR'); 
AO.(ifam).DeviceName             = {'LT1/AE/cycleCH.1'; 'LT1/AE/cycleCH.2'; 'LT1/AE/cycleCH.3'};
AO.(ifam).DeviceList             = [1 1; 1 2; 1 3];
AO.(ifam).ElementList            = (1:3)';
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
AO.(ifam).Inom = [1 2 3];
AO.(ifam).Imax = 10*ones(1,3);
AO.(ifam).Status = ones(3,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(3,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% cycleramp For V-corrector magnets
ifam = 'CycleCV';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleCOR'; 'CycleCV'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create('COR'); 
AO.(ifam).DeviceName             = {'LT1/AE/cycleCV.1'; 'LT1/AE/cycleCV.2'; 'LT1/AE/cycleCV.3'};
AO.(ifam).DeviceList             = [1 1; 1 2; 1 3];
AO.(ifam).ElementList            = [1 2 3]';
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
AO.(ifam).Inom = [1 2 3];
AO.(ifam).Imax = 10*ones(1,3);
AO.(ifam).Status = ones(3,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(3,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% cycleramp For quadrupoles magnets
ifam = 'CycleQP';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create('Quadrupole'); 
AO.(ifam).DeviceList             = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7];
AO.(ifam).ElementList            = (1:7)';
AO.(ifam).DeviceName             = {'LT1/AE/cycleQ.1';'LT1/AE/cycleQ.2'; ...
                                    'LT1/AE/cycleQ.3';'LT1/AE/cycleQ.4'; ...
                                    'LT1/AE/cycleQ.5';'LT1/AE/cycleQ.6'; ...
                                    'LT1/AE/cycleQ.7'};
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
%AO.(ifam).Imax = 8*ones(1,7);
% modification mars 2006
AO.(ifam).Imax = [8  -8  -8  8  8  -8  8 ];
AO.(ifam).Status = ones(7,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(7,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%%%%%%%%%%%%%%%%%%
%%% Diagnostics
%%%%%%%%%%%%%%%%%%

%% Charge Monitor - Moniteur de charge
ifam = 'MC';

AO.(ifam).FamilyName             = 'MC';
AO.(ifam).MemberOf               = {'Diag'; 'MC'; 'Archivable'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).DeviceName             = {'LT1/DG/MC'; 'LT1/DG/MC'};
AO.(ifam).CommonNames            = ['mc1';'mc2';];
AO.(ifam).DeviceList(:,:)        = [1 1; 1 2];
AO.(ifam).ElementList            = [1 2]';
AO.(ifam).Status                 = [1 1]';
AO.(ifam).Monitor.TangoNames     = [strcat(AO.(ifam).DeviceName(1,:), '/qIct1'); ...
                                    strcat(AO.(ifam).DeviceName(2,:), '/qIct2')];
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = [NaN; NaN]';
AO.(ifam).Monitor.DataType       = 'Vector';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'nC';
AO.(ifam).Monitor.PhysicsUnits   = 'nC';
AO.(ifam).Monitor.HW2PhysicsParams = 1.0;
AO.(ifam).Monitor.Physics2HWParams = 1.0;

%%%%%%%%%%%%%%%%%%
%% Vacuum system
%%%%%%%%%%%%%%%%%%

%% IonPump
ifam = 'PI';
AO.(ifam).FamilyName           = 'PI';
AO.(ifam).MemberOf             = {'PlotFamily'; 'IonPump'; 'Pressure'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

for ik = 1:9    
    AO.(ifam).DeviceName{ik}  = ['LT1/VI/PI55.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['PI' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
    if (ik == 8)
        AO.(ifam).DeviceName{ik} = ['LT1/VI/PI150.' num2str(ik)];
    end
end
nb = size(AO.(ifam).DeviceList,1);
AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = AO.(ifam).DeviceName';
AO.(ifam).CommonNames              = AO.(ifam).CommonNames';
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mBar';
AO.(ifam).Monitor.PhysicsUnits     = 'mBar';

%% PenningGauge
ifam = 'JPEN';
AO.(ifam).FamilyName           = 'JPEN';
AO.(ifam).MemberOf             = {'PlotFamily'; 'PenningGauge'; 'Pressure'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

for ik = 1:2    
    AO.(ifam).DeviceName{ik}  = ['LT1/VI/JPEN.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['JPEN' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end

nb = size(AO.(ifam).DeviceList,1);
AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = AO.(ifam).DeviceName';
AO.(ifam).CommonNames              = AO.(ifam).CommonNames';
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mBar';
AO.(ifam).Monitor.PhysicsUnits     = 'mBar';

%% PenningGauge
ifam = 'JPIR';
AO.(ifam).FamilyName           = 'JPIR';
AO.(ifam).MemberOf             = {'PlotFamily'; 'PiraniGauge'; 'Pressure'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

for ik = 1:2    
    AO.(ifam).DeviceName{ik}  = ['LT1/VI/JPIR.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = ['JPIR' num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end

nb = size(AO.(ifam).DeviceList,1);
AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = AO.(ifam).DeviceName';
AO.(ifam).CommonNames              = AO.(ifam).CommonNames';
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mBar';
AO.(ifam).Monitor.PhysicsUnits     = 'mBar';

%% Synchronisation
% ifam = 'SYNC'
% AO.(ifam).FamilyName           = 'SYNC';
% AO.(ifam).MemberOf             = {'Timing'};
% AO.(ifam).Monitor.Mode         = Mode;
% AO.(ifam).Monitor.DataType     = 'Scalar';
% 
% AO.(ifam).DeviceName{ik}  = ['LT1/VI/JPIR.' num2str(ik)];
% 
% AO.(ifam).Monitor.HWUnits      = 's';

setao(AO);

% The operational mode sets the path, filenames, and other important params
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode

setoperationalmode(OperationalMode);

%======================================================================
%======================================================================
%% Append Accelerator Toolbox information
%======================================================================
%======================================================================
disp('** Initializing Accelerator Toolbox information');

AO = getao;

ATindx = atindex(THERING);  %structure with fields containing indices

s = findspos(THERING,1:length(THERING)+1)';

%% HORIZONTAL CORRECTORS
ifam = 'CH';
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% VERTICAL CORRECTORS
ifam = 'CV';
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex); 

%% BENDING magnets
ifam = 'BEND';
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).Position   = reshape(s(AO.(ifam).AT.ATIndex),1,2);

%% QUADRUPOLES
ifam = 'QP';
AO.(ifam).AT.ATType  = 'QUAD';
AO.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
AO.(ifam).AT.ATIndex = reshape(AO.(ifam).AT.ATIndex,2,7)';
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

% Save AO
setao(AO);

if iscontrolroom
    switch2online;
else
    switch2sim;
end

