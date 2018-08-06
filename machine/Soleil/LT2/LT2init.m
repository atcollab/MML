function LT2init(OperationalMode)
% LT2INIT - Contructs an accelerator Object describing LT2
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
AD.SubMachine    = 'LT2'; % Machine Name
AD.Energy        = 2.75 ; % Energy in GeV


setad(AD);   %load AcceleratorData

%%%%%%%%%%%%%%%%%%%%
% ACCELERATOR OBJECT
%%%%%%%%%%%%%%%%%%%%

setao([]);   %clear previous AcceleratorObjects


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BPM data
% status field designates if BPM in use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifam = 'BPMx';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'BPM';
AO.(ifam).MemberOf                 = {'BPM'; 'HBPM'; 'PlotFamily'; 'Archivable'};
AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'mm';
AO.(ifam).Monitor.PhysicsUnits     = 'meter';

nb = 3;
AO.(ifam).DeviceList =[1 1; 1 2; 1 3]; 
AO.(ifam).ElementList = (1:nb)';
AO.(ifam).DeviceName(:,:)               = {'LT2/DG/BPM.1'; 'LT2/DG/BPM.2'; 'LT2/DG/BPM.3'};
AO.(ifam).Monitor.TangoNames(:,:)       = strcat(AO.(ifam).DeviceName, '/XPosSA');
AO.(ifam).CommonNames(:,:)              = [repmat('BPMx',nb,1) num2str((1:nb)','%03d')];

AO.(ifam).Status                        = ones(nb,1);
AO.(ifam).Monitor.HW2PhysicsParams(:,:) = 1e-3*ones(nb,1);
AO.(ifam).Monitor.Physics2HWParams(:,:) = 1e3*ones(nb,1);

% 2 lignes ajoutes pour test debug bpm versus le reste du monde
AO.(ifam).Monitor.Handles(:,1)       = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType         = 'Scalar';


% Vertical plane
ifam = 'BPMz'; 
AO.(ifam) = AO.BPMx; % the same as BPMx
% except those fields
AO.(ifam).MemberOf                 = {'BPM'; 'VBPM'; 'PlotFamily'; 'Archivable'};
AO.(ifam).FamilyName              = ifam;
AO.(ifam).Monitor.TangoNames(:,:)  = strcat(AO.(ifam).DeviceName,'/ZPosSA');
AO.(ifam).CommonNames(:,:) = [repmat('BPMz',nb,1) num2str((1:nb)','%03d')];

% 2 lignes ajoutes pour test debug bpm versus le reste du monde
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);

AO.(ifam).Status = AO.(ifam).Status(:);
AO.(ifam).Status = AO.(ifam).Status(:);


setao(AO); % mandatory to avoid empty AO message with magnetcoefficients

%% Dipole
ifam = 'BEND';

AO.(ifam).FamilyName             = 'BEND';
AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'BEND'; 'Archivable'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).DeviceName{1}          = 'LT2/AE/D.1';
AO.(ifam).CommonNames{1}         = 'DIP';
AO.(ifam).Monitor.Range(:,:)     = [0 580];
AO.(ifam).DeviceList(1,:)        = [1 1];
AO.(ifam).ElementList            = 1;
AO.(ifam).Status                 = 1;
AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/currentPM');
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

%% Quadrupoles QP
ifam = 'QP';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'QUAD'; 'Archivable'};
AO.(ifam).Mode                   = Mode;

for ik = 1:7    
    AO.(ifam).DeviceName{ik}  = ['LT2/AE/Q.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = [ifam num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
AO.(ifam).CommonNames            = AO.(ifam).CommonNames';
AO.(ifam).Monitor.Range(:,:)     = [0 270;-270 0;-270 0;0 270;0 270;-270 0;0 270]; %
nb                               = length(AO.(ifam).DeviceName);
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
AO.(ifam).Setpoint.TangoNames(:,:)  = strcat(AO.(ifam).DeviceName,'/currentPM');


% %% Quadrupoles QF
% ifam = 'QF';
% 
% AO.(ifam).FamilyName             = ifam;
% AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'QP'; 'Archivable'};
% AO.(ifam).Mode                   = Mode;
% 
% for ik = 1:7    
%     AO.(ifam).DeviceName{ik}  = ['LT2/AE/Q.' num2str(ik)];
%     AO.(ifam).CommonNames{ik} = [ifam num2str(ik)];
%     AO.(ifam).DeviceList(ik,:) = [1 ik];
% end
% AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
% AO.(ifam).CommonNames            = AO.(ifam).CommonNames';
% 
% nb                               = length(AO.(ifam).DeviceName);
% AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/current');
% AO.(ifam).Status                 = ones(nb,1);
% AO.(ifam).Monitor.ModelVal       = zeros(1,nb);
% AO.(ifam).Monitor.TangoVal       = AO.(ifam).Monitor.ModelVal;
% AO.(ifam).ElementList            = 1:nb;
% 
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
% AO.(ifam).Monitor.DataType       = 'Scalar';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'ampere';
% AO.(ifam).Monitor.PhysicsUnits   = 'radian';
% AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
% AO.(ifam).Monitor.Physics2HWFcn = @k2amp;
% 
% C = magnetcoefficients(AO.(ifam).FamilyName);
% 
% for ii=1:nb,
%     if ii == 2 || ii == 3 || ii == 6
%         % Defocusing quads
%         AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
%         AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
%     else
%         % Focusing quad
%         AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C;
%         AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C;
%     end
% end
% 
% %AO.(ifam).Monitor.Range(:,:) = repmat([-5 5],nb,1); % 10 A for 0.8 mrad
% AO.(ifam).Setpoint = AO.(ifam).Monitor;
% AO.(ifam).Desired = AO.(ifam).Monitor;
% 
% 
% %% Quadrupoles QD
% ifam = 'QD';
% 
% AO.(ifam).FamilyName             = ifam;
% AO.(ifam).MemberOf               = {'MachineConfig'; 'Magnet'; 'QP'; 'Archivable'};
% AO.(ifam).Mode                   = Mode;
% 
% for ik = 1:7    
%     AO.(ifam).DeviceName{ik}  = ['LT2/AE/Q.' num2str(ik)];
%     AO.(ifam).CommonNames{ik} = [ifam num2str(ik)];
%     AO.(ifam).DeviceList(ik,:) = [1 ik];
% end
% AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
% AO.(ifam).CommonNames            = AO.(ifam).CommonNames';
% 
% nb                               = length(AO.(ifam).DeviceName);
% AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/current');
% AO.(ifam).Status                 = ones(nb,1);
% AO.(ifam).Monitor.ModelVal       = zeros(1,nb);
% AO.(ifam).Monitor.TangoVal       = AO.(ifam).Monitor.ModelVal;
% AO.(ifam).ElementList            = 1:nb;
% 
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
% AO.(ifam).Monitor.DataType       = 'Scalar';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'ampere';
% AO.(ifam).Monitor.PhysicsUnits   = 'radian';
% AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
% AO.(ifam).Monitor.Physics2HWFcn = @k2amp;
% 
% C = magnetcoefficients(AO.(ifam).FamilyName);
% 
% for ii=1:nb,
%     if ii == 2 || ii == 3 || ii == 6
%         % Defocusing quads
%         AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
%         AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C.*[1 -1 1 -1 1 -1 1 -1];
%     else
%         % Focusing quad
%         AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = C;
%         AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = C;
%     end
% end
% 
% %AO.(ifam).Monitor.Range(:,:) = repmat([-5 5],nb,1); % 10 A for 0.8 mrad
% AO.(ifam).Setpoint = AO.(ifam).Monitor;
% AO.(ifam).Desired = AO.(ifam).Monitor;
% 


%% Horizontal Correctors
ifam = 'CH';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'MachineConfig'; 'Magnet'; 'HCM'; 'CH'; 'Archivable'};

for ik = 1:3    
    AO.(ifam).DeviceName{ik}  = ['LT2/AE/CH.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = [ifam num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
AO.(ifam).CommonNames            = AO.(ifam).CommonNames';


nb                         = length(AO.(ifam).DeviceName);
AO.(ifam).Monitor.Range(:,:)     = repmat([-10 10],nb,1);
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
%AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/currentPM');

%% Vertical Correctors
ifam = 'CV';

AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'MachineConfig'; 'Magnet'; 'VCM'; 'CV'; 'Archivable'};
AO.(ifam).Mode                 = Mode;

for ik = 1:5,
    AO.(ifam).DeviceName{ik}  = ['LT2/AE/CV.' num2str(ik)];
    AO.(ifam).CommonNames{ik} = [ifam num2str(ik)];
    AO.(ifam).DeviceList(ik,:) = [1 ik];
end
AO.(ifam).DeviceName             = AO.(ifam).DeviceName';
AO.(ifam).CommonNames            = AO.(ifam).CommonNames';

nb                             = length(AO.(ifam).DeviceName);
AO.(ifam).Monitor.Range(:,:)     = repmat([-10 10],nb,1);
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
%AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/currentPM');
setao(AO);

%%%%%%%%%%%%%%%%%%
%% CYCLAGE
%%%%%%%%%%%%%%%%%

%% cycleramp For dipole magnet
ifam = 'CycleBEND';
ifamQ = 'BEND';

AO.(ifam).FamilyName             = 'CycleBEND';
AO.(ifam).MemberOf               = {'CycleBEND'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/D','/cycleD');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
AO.(ifam).GroupId                = tango_group_create('Dipole'); 
AO.(ifam).DeviceName             = 'LT2/AE/cycleD.1';
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName);
%AO.(ifam).Inom = 180;
AO.(ifam).Imax = 580;
AO.(ifam).Status = 1;
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(7,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');



%% cycleramp For H-corrector magnets
ifam = 'CycleCH';
ifamQ = 'CH';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleCOR'; 'CycleCH'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/C','/cycleC');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create('COR'); 
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
ifamQ = 'CH';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleCOR'; 'CycleCV'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/C','/cycleC');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create('COR'); 
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
ifamQ = 'QP';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create('Quadrupole'); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = [274  -349  -274  274  274  -274  274 ];
AO.(ifam).Status = ones(7,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(7,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'radian';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

% %%%%%%%%%%%%%%%%%%
% %%% Diagnostics
% %%%%%%%%%%%%%%%%%%
% 
% %% Charge Monitor - Moniteur de charge
% ifam = 'MC';
% 
% AO.(ifam).FamilyName             = 'MC';
% AO.(ifam).MemberOf               = {'Diag'; 'MC'; 'Archivable'};
% AO.(ifam).Mode                   = Mode;
% AO.(ifam).DeviceName             = {'LT2/DG/MC'; 'LT2/DG/MC'};
% AO.(ifam).CommonNames            = ['mc1';'mc2';];
% AO.(ifam).DeviceList(:,:)        = [1 1; 1 2];
% AO.(ifam).ElementList            = [1 2]';
% AO.(ifam).Status                 = [1 1]';
% AO.(ifam).Monitor.TangoNames     = [strcat(AO.(ifam).DeviceName(1,:), '/qIct1'); ...
%                                     strcat(AO.(ifam).DeviceName(2,:), '/qIct2')];
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = [NaN; NaN]';
% AO.(ifam).Monitor.DataType       = 'Vector';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'nC';
% AO.(ifam).Monitor.PhysicsUnits   = 'nC';
% AO.(ifam).Monitor.HW2PhysicsParams = 1.0;
% AO.(ifam).Monitor.Physics2HWParams = 1.0;

%%%%%%%%%%%%%%%%%%
%% Vacuum system
%%%%%%%%%%%%%%%%%%

%% IonPump
ifam = 'PI';
AO.(ifam).FamilyName           = 'PI';
AO.(ifam).MemberOf             = {'PlotFamily'; 'IonPump'; 'Pressure'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

for ik = 1:15    
    if ik >= 10
        AO.(ifam).DeviceName{ik}  = ['LT2/VI/PI.' num2str(ik)];
    else
        AO.(ifam).DeviceName{ik}  = ['LT2/VI/PI.0' num2str(ik)];
    end
    AO.(ifam).CommonNames{ik} = ['PI' num2str(ik)];
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
ifam = 'JPEN';
AO.(ifam).FamilyName           = 'JPEN';
AO.(ifam).MemberOf             = {'PlotFamily'; 'PenningGauge'; 'Pressure'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

for ik = 1:3 
    AO.(ifam).DeviceName{ik}  = ['LT2/VI/JPEN.' num2str(ik)];
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

for ik = 1:3    
    AO.(ifam).DeviceName{ik}  = ['LT2/VI/JPIR.' num2str(ik)];
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
% AO.(ifam).DeviceName{ik}  = ['LT2/VI/JPIR.' num2str(ik)];
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
ifam = ('CH');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% VERTICAL CORRECTORS
ifam = ('CV');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex); 

%% BENDING magnets
ifam = ('BEND');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.(ifam)(:);
AO.(ifam).Position   = reshape(s(AO.(ifam).AT.ATIndex),1,4);

%% QUADRUPOLES
ifam = 'QP';
AO.(ifam).AT.ATType  = 'QUAD';
AO.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
AO.(ifam).AT.ATIndex = reshape(AO.(ifam).AT.ATIndex,1,7)';
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);


% %% QUADRUPOLES
% ifam = 'QF';
% AT.(ifam).AT.ATType  = 'QUAD';
% AT.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
% AT.(ifam).AT.ATIndex = reshape(AT.(ifam).AT.ATIndex,1,4)';
% AT.(ifam).Position   = s(AT.(ifam).AT.ATIndex);
% 
% %% QUADRUPOLES
% ifam = 'QD';
% AT.(ifam).AT.ATType  = 'QUAD';
% AT.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
% AT.(ifam).AT.ATIndex = reshape(AT.(ifam).AT.ATIndex,1,3)';
% AT.(ifam).Position   = s(AT.(ifam).AT.ATIndex);

% Save AO
setao(AO);

if iscontrolroom
    switch2online;
else
    switch2sim;
end
