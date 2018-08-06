function soleilinit(OperationalMode)
%SOLEILINIT - Initializes params for SOLEIL control in MATLAB
%
% Written by Laurent S. Nadolski, Synchrotron SOLEIL
% 
%==========================
% Accelerator Family Fields
%==========================
% FamilyName            BPMx, HCOR, etc
% CommonNames           Shortcut name for each element
% DeviceList            [Sector, Number]
% ElementList           number in list
% Position              m, if thick, it is not the magnet center
%
% MONITOR FIELD
% Mode                  online/manual/special/simulator
% TangoNames            Device Tango Names
% Units                 Physics or HW
% HW2PhysicsFcn         function handle used to convert from hardware to physics units ==> inline will not compile, see below
% HW2PhysicsParams      params used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      params used for conversion function
% HWUnits               units for Hardware 'A';
% PhysicsUnits          units for physics 'Rad';
% Handles               monitor handle
%
% SETPOINT FIELDS
% Mode                  online/manual/special/simulator
% TangoNames            Devices tango names
% Units                 hardware or physics
% HW2PhysicsFcn         function handle used to convert from hardware to physics units
% HW2PhysicsParams      params used for conversion function
% Physics2HWFcn         function handle used to convert from physics to hardware units
% Physics2HWParams      params used for conversion function
% HWUnits               units for Hardware 'A';
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
% ATParamGroup      param group
%
%============
% Family List
%============
%    BPMx
%    BPMz
%    HCOR
%    VCOR
%    BEND
%    Q1 to Q10
%    S1 to S10
%    RF
%    TUNE
%    DCCT
%    Machine Params
%
% NOTES
%   All sextupoles have H and V corrector and skew quadrupole windings
%
%  See Also setpathsoleil, setpathmml, aoinit, setoperionalmode, updateatindex

%
%
% TODO, Deltakick for BPM orbit response matrix  Warning optics dependent cf. Low alpha lattice
%       to be put into setoperationalmode

if nargin < 1
    OperationalMode = 1;
end

global GLOBVAL THERING

h = waitbar(0,'soleilinit initialization, please wait');

%==============================
%% load AcceleratorData structure
%==============================

Mode             = 'Online';
setad([]);       %clear AcceleratorData memory
AD.SubMachine = 'StorageRing';   % Will already be defined if setpathmml was used
AD.Energy        = 2.7391; % Energy in GeV needed for magnet calibration. Do not remove!

setad(AD);

%%%%%%%%%%%%%%%%%%%%
% ACCELERATOR OBJECT
%%%%%%%%%%%%%%%%%%%%

setao([]);   %clear previous AcceleratorObjects

waitbar(0.05,h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BPM
% status field designates if BPM in use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BPMX Horizontal plane
ifam = 'BPMx';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'BPM';
AO.(ifam).MemberOf                 = {'BPM'; 'HBPM'; 'PlotFamily'; 'Archivable'};
AO.(ifam).Monitor.Mode             = Mode;
%AO.(ifam).Monitor.Mode             = 'Special';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'mm';
AO.(ifam).Monitor.PhysicsUnits     = 'm';
AO.(ifam).Monitor.SpecialFunctionGet = 'gethbpmgroup';
%AO.(ifam).Monitor.SpecialFunctionGet = 'gethbpmaverage';
%AO.(ifam).Monitor.SpecialFunctionGet = 'gethturnbyturn';
% Get mapping from TANGO static database
map = tango_get_db_property('anneau','tracy_bpm_mapping');

cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;
elemindex = cell2mat(regexpi(map,'BPM[0-9]','once'))+3;
sep       = cell2mat(regexpi(map,'::','once'))-1;
dev       = regexprep(map,'^BPM\d*::','')';

nb = size(map,2);

for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
    AO.(ifam).ElementList(k,:) = str2double(map{k}(elemindex(k):sep(k)));
end

AO.(ifam).ElementList = (1:120)';
AO.(ifam).DeviceName(:,:)               = dev;
AO.(ifam).Monitor.TangoNames(:,:)       = strcat(dev, '/XPosSA');
AO.(ifam).CommonNames(:,:)              = [repmat('BPMx',nb,1) num2str((1:nb)','%03d')];

AO.(ifam).Status                        = ones(nb,1);
AO.(ifam).Monitor.HW2PhysicsParams(:,:) = 1e-3*ones(nb,1);
AO.(ifam).Monitor.Physics2HWParams(:,:) = 1e3*ones(nb,1);

% 2 lignes ajoutes pour test debug bpm versus le reste du monde
AO.(ifam).Monitor.Handles(:,1)       = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType         = 'Scalar';

% Group
AO.(ifam).GroupId = tango_group_create2('BPM');
tango_group_add(AO.(ifam).GroupId,AO.(ifam).DeviceName');

AO.(ifam).History = AO.(ifam).Monitor;
AO.(ifam).History.TangoNames(:,:)       = strcat(dev, '/XPosSAHistory');
AO.(ifam).History.MemberOf = {'Plotfamily'};

AO.(ifam).Va = AO.(ifam).Monitor;
AO.(ifam).Va.TangoNames(:,:)       = strcat(dev, '/VaSA');
AO.(ifam).Va.MemberOf = {'Plotfamily'};

AO.(ifam).Vb = AO.(ifam).Monitor;
AO.(ifam).Vb.TangoNames(:,:)       = strcat(dev, '/VbSA');
AO.(ifam).Vb.MemberOf = {'Plotfamily'};

AO.(ifam).Vc = AO.(ifam).Monitor;
AO.(ifam).Vc.TangoNames(:,:)       = strcat(dev, '/VcSA');
AO.(ifam).Vc.MemberOf = {'Plotfamily'};

AO.(ifam).Vd = AO.(ifam).Monitor;
AO.(ifam).Vd.TangoNames(:,:)       = strcat(dev, '/VdSA');
AO.(ifam).Vd.MemberOf = {'Plotfamily'};

AO.(ifam).Sum = AO.(ifam).Monitor;
AO.(ifam).Sum.TangoNames(:,:)       = strcat(dev, '/SumSA');
AO.(ifam).Sum.MemberOf = {'Plotfamily'};


AO.(ifam).Quad = AO.(ifam).Monitor;
AO.(ifam).Quad.TangoNames(:,:)       = strcat(dev, '/QuadSA');
AO.(ifam).Quad.MemberOf = {'Plotfamily'};

%% BPMZ Vertical plane
ifam = 'BPMz'; 
AO.(ifam) = AO.BPMx; % the same as BPMx
AO.(ifam).MemberOf                 = {'BPM'; 'VBPM'; 'PlotFamily'; 'Archivable'};
AO.(ifam).Monitor.Mode             = 'Online';
%AO.(ifam).Monitor.Mode             = 'Special';
% except those fields
AO.(ifam).FamilyName              = ifam;
AO.(ifam).Monitor.TangoNames(:,:)  = strcat(dev,'/ZPosSA');
AO.(ifam).CommonNames(:,:) = [repmat('BPMz',nb,1) num2str((1:nb)','%03d')];
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
%AO.(ifam).Monitor.SpecialFunctionGet = 'getvturnbyturn';
AO.(ifam).Monitor.SpecialFunctionGet = 'getvbpmgroup';
%AO.(ifam).Monitor.SpecialFunctionGet = 'getvbpmaverage';

AO.(ifam).Status = AO.(ifam).Status(:);
AO.(ifam).Status = AO.(ifam).Status(:);

%TODO
% AO.(ifam).Sum.Monitor = AO.(ifam).Monitor;
% AO.(ifam).Q = AO.(ifam).Monitor;

setao(AO); % mandatory to avoid empty AO message with magnetcoefficients

% Make BPM group
% AO.(ifam).GroupID = tango_group_create('BPM');
% AO.(ifam).GroupID = AO.(ifam).GroupID;
% name = lower(getfamilydata(BPMFamily{1},'DeviceName'));
% tango_group_add(AO.(ifam).GroupID,{name{:}});
% tango_group_dump(AO.(ifam).GroupID)
% tango_group_size(AO.(ifam).GroupID,0)

%===========================================================
% Corrector data: status field designates if corrector in use
%===========================================================

%% BLx : Source points
ifam = 'BeamLine';

AO.(ifam).FamilyName  = ifam;
AO.(ifam).FamilyType  = 'Diagnostic';
AO.(ifam).CommonNames = {'nux';'nuz';'ODE'; 'SAMBA'; 'DIFFABS'}; % to be completed
AO.(ifam).MemberOf    = {'DG'; 'PlotFamily'; 'Archivable'};
AO.(ifam).DeviceList  = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 4 1; ...
                         5 1; 6 1; 6 2; 7 1; 7 2; 8 1; ...
                         9 1; 9 2; 10 1; 10 2; 11 1; 11 2; 12 1; ...
                         13 1; 13 2;14 1; 14 2; 15 1; 15 2; 16 1];
                         
AO.(ifam).DeviceName             = { ...
    'ANS-C01/DG/CALC-SDL-POSITION-ANGLE'; ...
    'ANS-C01/DG/CALC-D2-POSITION-ANGLE'; ...
    'ANS-C02/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C02/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C03/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C03/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C04/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C05/DG/CALC-SDL-POSITION-ANGLE'; ...
    'ANS-C06/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C06/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C07/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C07/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C08/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C09/DG/CALC-SDL-POSITION-ANGLE'; ...
    'ANS-C09/DG/CALC-D2-POSITION-ANGLE'; ...
    'ANS-C10/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C10/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C11/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C11/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C12/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C13/DG/CALC-SDL-POSITION-ANGLE'; ...
    'ANS-C13/DG/CALC-D2-POSITION-ANGLE' ; ... 
    'ANS-C14/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C14/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C15/DG/CALC-SDC-POSITION-ANGLE'; ...
    'ANS-C15/DG/CALC-SDM-POSITION-ANGLE'; ...
    'ANS-C16/DG/CALC-SDM-POSITION-ANGLE'};

AO.(ifam).ElementList = (1:size(AO.(ifam).DeviceList,1))';
AO.(ifam).Status      = ones(size(AO.(ifam).DeviceList,1),1);

AO.(ifam).Monitor.Mode                   = Mode; %'Simulator';  % Mode;
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames(:,:)        = strcat(AO.(ifam).DeviceName, '/positionX');

AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HW2PhysicsParams       = 1e-6;
AO.(ifam).Monitor.Physics2HWParams       = 1e6;
AO.(ifam).Monitor.HWUnits                = 'µm';
AO.(ifam).Monitor.PhysicsUnits           = 'm';

% ID based BLs
%spos = getspos('BPMx',getidbpmlist)
%spos2 = zeros(24,1);
%spos2(2:end) = (spos(3:2:end)+spos(2:2:end-1))/2;
% ODE, SAMBA, DIFFABS
% dippos = getspos('BEND',[1 1])
% Position = [spos2(1); dippos(2); spos2(2:13); dippos(18); spos2(14:19); dippos(26); spos2(20:end)];
AO.(ifam).Position                       = [0   14.7752   22.0301   33.1454   44.2619   55.3772   66.4936   88.5230  ...
                                            110.5530  121.6689  132.7853  143.9012  155.0177  177.0476  191.8227  ...
                                            199.0776 210.1934  221.3099  232.4258  243.5422  265.5721  280.3473  ...
                                            287.6022  298.7180  309.8345  320.9503  332.0668]';

AO.(ifam).Positionx = AO.(ifam).Monitor;
AO.(ifam).Positionx.MemberOf            = {'PlotFamily'};

AO.(ifam).Anglex = AO.(ifam).Positionx;

AO.(ifam).Anglex.HWUnits                = 'µrad';
AO.(ifam).Anglex.PhysicsUnits           = 'rad';
AO.(ifam).Anglex.TangoNames(:,:)        = strcat(AO.(ifam).DeviceName, '/angleX');

AO.(ifam).Positionz = AO.(ifam).Positionx;
AO.(ifam).Positionz.TangoNames(:,:)     = strcat(AO.(ifam).DeviceName, '/positionZ');

AO.(ifam).Anglez = AO.(ifam).Anglex;
AO.(ifam).Anglez.TangoNames(:,:)        = strcat(AO.(ifam).DeviceName, '/angleZ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SLOW HORIZONTAL CORRECTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifam = 'HCOR';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'COR';
AO.(ifam).MemberOf                 = {'MachineConfig'; 'HCOR'; 'COR'; 'Magnet'; 'PlotFamily'; 'Archivable'};

AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'A';
AO.(ifam).Monitor.PhysicsUnits     = 'rad';
AO.(ifam).Monitor.HW2PhysicsFcn    = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn    = @k2amp;

% Get mapping from TANGO static database
map  = tango_get_db_property('anneau','tracy_correctorH_mapping');
devC = regexprep(map,'^CH\d*::','')';

% Get all potential correctors (in each sextupoles)
mapS = tango_get_db_property('anneau','tracy_sextupole_mapping');
cellindex  = cell2mat(regexpi(mapS,'C[0-9]','once'))+1;
devS = regexprep(mapS,'^SX\d*::','')';

nb = size(mapS,2);

% Create full list of 120 potential correctors
cellnum0 = 1; num = 0;
for k = 1:nb,
   cellnum = str2double(mapS{k}(cellindex(k):cellindex(k)+1));       
   if (cellnum ~= cellnum0)
       cellnum0 = cellnum;
       num = 1;
   else
       num = num + 1;
   end
   AO.(ifam).DeviceList(k,:) = [cellnum num];
end
AO.(ifam).ElementList(:,:)= (1:nb)';

dev = strcat(devS,'-CH');

% Select working correctors
AO.(ifam).Status = ones(nb,1);
jk = 1;
for k = 1:nb,
        if isempty(strmatch(devC{jk},dev{k}))
            AO.(ifam).Status(k) = 0;
        else
            if (jk < size(devC,1)), jk = jk + 1; end;
        end
end

AO.(ifam).DeviceName(:,:)            = dev;
AO.(ifam).CommonNames(:,:)           = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','%03d')];
AO.(ifam).Monitor.TangoNames(:,:)    = strcat(dev,'/current');

AO.(ifam).Monitor.Range(:,:)        = repmat([-11 11],nb,1); % 11 A for 0.8 mrad
AO.(ifam).Monitor.Handles(:,1)       = NaN*ones(nb,1);

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients(AO.(ifam).FamilyName);

for ii = 1:nb,
    AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
end


AO.(ifam).Status = AO.(ifam).Status(:);

AO.(ifam).Setpoint = AO.(ifam).Monitor; 
AO.(ifam).Desired  = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.TangoNames(:,:)    = strcat(dev,'/currentPM');

AO.(ifam).Setpoint.Tolerance(:,:)    = 1e-2*ones(nb,1);
% Warning optics dependent cf. Low alpha lattice
AO.(ifam).Setpoint.DeltaRespMat(:,:) = ones(nb,1)*0.5e-4*1; % 2*25 urad (half used for kicking)

AO.(ifam).Voltage.TangoNames(:,:)    = strcat(dev,'/voltage');
AO.(ifam).Monitor.MemberOf           = {'PlotFamily'};
% AO.(ifam).SumOffset.TangoNames(:,:)     = strcat(dev,'/ecart2');
% AO.(ifam).SumOffset.MemberOf           = {'PlotFamily'};
% AO.(ifam).Ecart.TangoNames(:,:)      = strcat(dev,'/ecart1');
% AO.(ifam).Ecart.MemberOf           = {'PlotFamily'};

AO.(ifam).Profibus.BoardNumber = int32(0);
AO.(ifam).Profibus.Group       = int32(1);
AO.(ifam).Profibus.DeviceName  = 'ANS/AE/DP.CH';

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName,'Setpoint', ...
    AO.(ifam).Setpoint.DeltaRespMat, AO.(ifam).DeviceList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SLOW VERTICAL CORRECTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifam = 'VCOR';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'COR';
AO.(ifam).MemberOf                 = {'MachineConfig'; 'VCOR'; 'COR'; 'Magnet'; 'PlotFamily'; 'Archivable'};

AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'A';
AO.(ifam).Monitor.PhysicsUnits     = 'rad';
AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn = @k2amp;

% Get mapping from TANGO static database
map = tango_get_db_property('anneau','tracy_correctorV_mapping');
devC = regexprep(map,'^CV\d*::','')';

% Create full list of 120 potential correctors
cellnum0 = 1; num = 0;
for k = 1:nb,
   cellnum = str2double(mapS{k}(cellindex(k):cellindex(k)+1));       
   if (cellnum ~= cellnum0)
       cellnum0 = cellnum;
       num = 1;
   else
       num = num + 1;
   end
   AO.(ifam).DeviceList(k,:) = [cellnum num];
end
AO.(ifam).ElementList(:,:)= (1:nb)';

dev = strcat(devS,'-CV');

% Select working correctors
AO.(ifam).Status = ones(nb,1);
jk = 1;
for k = 1:nb,
    if isempty(strmatch(devC{jk},dev{k}))
        AO.(ifam).Status(k) = 0;
    else
        if (jk < size(devC,1)), jk = jk + 1; end;
    end
end

AO.(ifam).DeviceName(:,:)            = dev;
AO.(ifam).CommonNames(:,:)           = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','%03d')];
AO.(ifam).Monitor.TangoNames(:,:)    = strcat(dev,'/current');
AO.(ifam).Monitor.Range(:,:)      = repmat([-14 14],nb,1); % 10 A for 0.8 mrad
AO.(ifam).Monitor.Handles(:,1)    = NaN*ones(nb,1);

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients(AO.(ifam).FamilyName);

for ii = 1:nb,
    AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
end

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;

AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.TangoNames(:,:)   = strcat(dev,'/currentPM');
AO.(ifam).Setpoint.Tolerance(:,:)    = 1e-2*ones(nb,1);
% Warinig optics dependent cf. Low alpha lattice
%AO.(ifam).Setpoint.DeltaRespMat(:,:) = ones(nb,1)*1e-5*2; % 2*25 urad (half used for kicking)
AO.(ifam).Setpoint.DeltaRespMat(:,:) = ones(nb,1)*1e-4*2; % 2*25 urad (half used for kicking)

AO.(ifam).Profibus.BoardNumber = int32(0);
AO.(ifam).Profibus.Group       = int32(1);
AO.(ifam).Profibus.DeviceName  = 'ANS/AE/DP.CV';

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName,'Setpoint', ...
    AO.(ifam).Setpoint.DeltaRespMat, AO.(ifam).DeviceList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Skew Quadrupole data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ifam = 'QT';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'SkewQuad';
AO.(ifam).MemberOf                 = {'MachineConfig'; 'Magnet'; 'PlotFamily'; 'Archivable'};

HW2Physics = 1.0;
AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'A';
AO.(ifam).Monitor.PhysicsUnits     = 'meter^-2';
AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn = @k2amp;

% Get mapping from TANGO static database
map = tango_get_db_property('anneau','tracy_QT_mapping');
devC = regexprep(map,'^QT\d*::','')';

% Create full list of 120 potential correctors
cellnum0 = 1; num = 0;
for k = 1:nb,
   cellnum = str2double(mapS{k}(cellindex(k):cellindex(k)+1));       
   if (cellnum ~= cellnum0)
       cellnum0 = cellnum;
       num = 1;
   else
       num = num + 1;
   end
   AO.(ifam).DeviceList(k,:) = [cellnum num];
end
AO.(ifam).ElementList(:,:)= (1:nb)';

dev = strcat(devS,'-QT');

% Select working correctors
AO.(ifam).Status = ones(nb,1);
jk = 1;
for k = 1:nb,
    if k == 24
        AO.(ifam).Status(k) = 0; %%%%%%%%%%%%%%%%%%% situation du 11 mars  2007 S1 [12 7] en quad
    end

    if isempty(strmatch(devC{jk},dev{k}))
        AO.(ifam).Status(k) = 0;
    else
        if (jk < size(devC,1)), jk = jk + 1; end;
    end
end

AO.(ifam).DeviceName(:,:)            = dev;
AO.(ifam).CommonNames(:,:)           = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','%03d')];
AO.(ifam).Monitor.TangoNames(:,:)    = strcat(dev,'/current');
AO.(ifam).Monitor.Range(:,:) = repmat([-7 7],nb,1); % 10 A for 0.8 mrad
AO.(ifam).Monitor.Handles(:,1)    = NaN*ones(nb,1);

% Load coeeficients fot thin element
coefficients = magnetcoefficients(AO.(ifam).FamilyName);

for ii=1:nb,
    AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
end

% AO.(ifam).Monitor.HW2PhysicsParams(ii,:)                  = HW2Physics*ScaleFactor;
% AO.(ifam).Monitor.Physics2HWParams(ii,:)                  = ScaleFactor/HW2Physics;

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.TangoNames(:,:)    = strcat(dev,'/currentPM');

AO.(ifam).Setpoint.Tolerance(:,:) = 1000*ones(nb,1);
AO.(ifam).Setpoint.DeltaRespMat(:,:) = 3*ones(nb,1);
AO.(ifam).Setpoint.DeltaSkewK = 1; % for SkewQuad efficiency toward dispersion .

AO.(ifam).Profibus.BoardNumber = int32(0);
AO.(ifam).Profibus.Group       = int32(1);
AO.(ifam).Profibus.DeviceName  = 'ANS/AE/DP.QT';

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName, 'Setpoint', ...
                       AO.(ifam).Setpoint.DeltaRespMat, AO.(ifam).DeviceList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FAST HORIZONTAL CORRECTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifam = 'FHCOR';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'FCOR';
AO.(ifam).MemberOf                 = {'FCOR'; 'Magnet'; 'PlotFamily'; 'Archivable'};

AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'A';
AO.(ifam).Monitor.PhysicsUnits     = 'rad';
AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn = @k2amp;

% Get mapping from TANGO static database
map = tango_get_db_property('anneau','tracy_fastcorrectorH_mapping');
cellindex  = cell2mat(regexpi(map,'-C[0-9]','once'))+2;
numindex = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

elemindex = cell2mat(regexpi(map,'CH[0-9]','once'))+2;
sep = cell2mat(regexpi(map,'::','once'))-1;
% dev = deblank(regexprep(char(map),'^CH\d*::',''));
dev = regexprep(map,'^FCH\d*::','')';

nb = size(map,2);
cellnum0 = 1;
indexmagnet = 0;

for k = 1:nb,
    cellnum = str2double(map{k}(cellindex(k):cellindex(k)+1));
    if (cellnum == cellnum0)
        indexmagnet = indexmagnet + 1;
    else
        indexmagnet = 1;
        cellnum0 = cellnum;
    end
    AO.(ifam).DeviceList(k,:)        = [cellnum indexmagnet];
    AO.(ifam).ElementList(k,:)       = str2double(map{k}(elemindex(k):sep(k)));
end

AO.(ifam).DeviceName(:,:)            = dev;
AO.(ifam).CommonNames(:,:)           = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','%02d')];

AO.(ifam).Monitor.TangoNames(:,:)    = strcat(dev,'/current');
AO.(ifam).Status = ones(nb,1);

AO.(ifam).Monitor.Range(:,:)        = repmat([-10 10],nb,1); % 10 A for 280 urad
AO.(ifam).Monitor.Handles(:,1)       = NaN*ones(nb,1);

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, HCMcoefficients] = magnetcoefficients(AO.(ifam).FamilyName);

for ii=1:nb,
    AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = HCMcoefficients;
    AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = HCMcoefficients;

end

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.Tolerance(:,:)    = 1000*ones(nb,1);
AO.(ifam).Setpoint.DeltaRespMat(:,:) = 3*ones(nb,1);

AO.(ifam).Status=AO.(ifam).Status(:);

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName,'Setpoint', ...
    AO.(ifam).Setpoint.DeltaRespMat, AO.(ifam).DeviceList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FAST VERTICAL CORRECTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifam = 'FVCOR';
AO.(ifam).FamilyName               = ifam;
AO.(ifam).FamilyType               = 'FCOR';
AO.(ifam).MemberOf                 = {'FCOR'; 'Magnet'; 'PlotFamily'; 'Archivable'};

AO.(ifam).Monitor.Mode             = Mode;
AO.(ifam).Monitor.DataType         = 'Scalar';
AO.(ifam).Monitor.Units            = 'Hardware';
AO.(ifam).Monitor.HWUnits          = 'A';
AO.(ifam).Monitor.PhysicsUnits     = 'rad';
AO.(ifam).Monitor.HW2PhysicsFcn = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn = @k2amp;

% Get mapping from TANGO static database
map = tango_get_db_property('anneau','tracy_fastcorrectorV_mapping');
cellindex  = cell2mat(regexpi(map,'-C[0-9]','once'))+2;
elemindex = cell2mat(regexpi(map,'CV[0-9]','once'))+2;
sep = cell2mat(regexpi(map,'::','once'))-1;
% dev = deblank(regexprep(char(map),'^CV\d*::',''));
dev = regexprep(map,'^FCV\d*::','')';

nb = size(map,2);
cellnum0 = 1;
indexmagnet = 0;

for k = 1:nb,
    cellnum = str2double(map{k}(cellindex(k):cellindex(k)+1));
    if (cellnum == cellnum0)
        indexmagnet = indexmagnet + 1;
    else
        indexmagnet = 1;
        cellnum0 = cellnum;
    end
    AO.(ifam).DeviceList(k,:)      = [cellnum indexmagnet];
    AO.(ifam).ElementList(k,:)       = str2double(map{k}(elemindex(k):sep(k)));
end

AO.(ifam).DeviceName(:,:)            = dev;
AO.(ifam).CommonNames(:,:)           = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','%02d')];

AO.(ifam).Monitor.TangoNames(:,:)    = strcat(dev,'/current');
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Range(:,:) = repmat([-14 14],nb,1); % 10 A for 240 urad
AO.(ifam).Monitor.Handles(:,1)    = NaN*ones(nb,1);

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, coefficients] = magnetcoefficients(AO.(ifam).FamilyName);

for ii=1:nb,
    AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)  = coefficients;
    AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)  = coefficients;
end

AO.(ifam).Status=AO.(ifam).Status(:);

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.Tolerance(:,:)    = 1000*ones(nb,1);
AO.(ifam).Setpoint.DeltaRespMat(:,:) = 3*ones(nb,1);

%convert response matrix kicks to HWUnits (after AO is loaded to AppData)
setao(AO);   %required to make physics2hw function
AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName,'Setpoint', ...
    AO.(ifam).Setpoint.DeltaRespMat, AO.(ifam).DeviceList);

%=============================
%        MAIN MAGNETS
%=============================

%==============
%% DIPOLES
%==============

% *** BEND ***
ifam='BEND';
AO.(ifam).FamilyName                 = ifam;
AO.(ifam).FamilyType                 = 'BEND';
AO.(ifam).MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet'; 'PlotFamily'; 'Archivable'};
HW2PhysicsParams                    = magnetcoefficients('BEND');
Physics2HWParams                    = HW2PhysicsParams;

AO.(ifam).Monitor.Mode               = Mode;
AO.(ifam).Monitor.DataType           = 'Scalar';
AO.(ifam).Monitor.Units              = 'Hardware';
% AO.(ifam).Monitor.HW2PhysicsFcn      = @amp2k;
% AO.(ifam).Monitor.Physics2HWFcn      = @k2amp;
% waiting for energy calibration
AO.(ifam).Monitor.HW2PhysicsFcn      = @bend2gev;
AO.(ifam).Monitor.Physics2HWFcn      = @gev2bend;
AO.(ifam).Monitor.HWUnits            = 'A';
AO.(ifam).Monitor.PhysicsUnits       = 'GeV';


% % Get mapping from TANGO static database
% map       = tango_get_db_property('anneau','tracy_dipole_mapping');
% cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
% numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;
% elemindex = cell2mat(regexpi(map,'BEND[0-9]','once'))+4;
% sep       = cell2mat(regexpi(map,'::','once'))-1;
% dev       = regexprep(map,'^BEND\d*::','')';
% 
% nb = size(map,2);
% for k = 1:nb,
%     AO.(ifam).DeviceList(k,:) = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
%     AO.(ifam).ElementList(k,:)= str2double(map{k}(elemindex(k):sep(k)));
% end
% AO.(ifam).DeviceName(:,:)    = dev;
% AO.(ifam).Monitor.TangoNames(:,:)  = strcat(dev,'/current');
% AO.(ifam).Status = ones(nb,1);
% AO.(ifam).Monitor.Handles(:,1) = NaN*ones(nb,1);
% 
% for ii=1:nb,
%     val = 1.0;
%     AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
%     AO.(ifam).Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
%     AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
%     AO.(ifam).Monitor.Physics2HWParams{2}(ii,:)                 = val;
% end

AO.(ifam).DeviceName(:,:) = {'ANS/AE/Dipole'};
AO.(ifam).Monitor.TangoNames(:,:)  = strcat(AO.(ifam).DeviceName(:,:),'/current');

AO.(ifam).DeviceList(:,:) = [1 1];
AO.(ifam).ElementList(:,:)= 1;
AO.(ifam).Status          = 1;

val = 1;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = val;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = val;
AO.(ifam).Monitor.Range(:,:) = [0 560]; % 525 A for 1.71T

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired  = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
AO.(ifam).Setpoint.TangoNames(:,:)  = strcat(AO.(ifam).DeviceName,'/currentPM');

AO.(ifam).Setpoint.Tolerance(:,:) = 0.05;
AO.(ifam).Setpoint.DeltaRespMat(:,:) = 0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QUADRUPOLE MAGNETS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

map=tango_get_db_property('anneau','tracy_quadrupole_mapping');
iifam = cell2mat(regexpi(map,'/Q','once'))+2;

% build mapping for the ten families
% cleanup
for k = 1:10,
    eval([['map' num2str(k)] '= [];']);
end

% do the job
for k = 1:size(map,2)
    fam = map{k}(iifam(k));
    if ((fam == '1') && (~isempty(regexpi(map{k},'/Q10'))))
        fam = '10';
    end
    eval([['map' fam ] '=' '[' ['map' fam] '  ' 'map(k)' ' ];' ]')
end

% quadrupole step for tune response matrix measurement for DNU = 1e-2
% (depends on plane).
tune = [ 4e-3 1.4e-3 4e-3 1.5e-3 1.6e-3 1.3e-3 7e-4 1.9e-3 1.5e-3 1.5e-3]; 
    
for k = 1:10,
    cellindex  = cell2mat(regexpi(eval(['map' num2str(k)]),'-C[0-9]','once'))+2;
    % sep = cell2mat(regexpi(eval(['map' num2str(k)]),'::','once'))-1;
    % dev = deblank(regexprep(char(eval(['map' num2str(k)])),'^QP\d*::',''));
    dev = regexprep(eval(['map' num2str(k)]),'^QP\d*::','')';
    numindex = regexpi(eval(['map' num2str(k)]),'\.[0-9]','once');

    ifam = ['Q' num2str(k)];

    AO.(ifam).FamilyName                 = ifam;
    AO.(ifam).FamilyType                 = 'QUAD';
    AO.(ifam).MemberOf                   = {'MachineConfig'; 'QUAD'; 'Magnet'; 'PlotFamily'; 'Archivable'};
    HW2PhysicsParams                    = magnetcoefficients(AO.(ifam).FamilyName);
    Physics2HWParams                    = magnetcoefficients(AO.(ifam).FamilyName);

    AO.(ifam).Monitor.Mode               = Mode;
    AO.(ifam).Monitor.DataType           = 'Scalar';
    AO.(ifam).Monitor.Units              = 'Hardware';
    AO.(ifam).Monitor.HWUnits            = 'A';
    AO.(ifam).Monitor.PhysicsUnits       = 'meter^-2';
    AO.(ifam).Monitor.HW2PhysicsFcn      = @amp2k;
    AO.(ifam).Monitor.Physics2HWFcn      = @k2amp;

    nb = size(eval(['map' num2str(k)]),2);
    for kk = 1:nb,
        if isempty(numindex{kk})
            AO.(ifam).DeviceList(kk,:) = [str2double(eval(['map' num2str(k) ...
                '{kk}(cellindex(kk):cellindex(kk)+1)'])) 1];
        else
            AO.(ifam).DeviceList(kk,:) = [str2double(eval(['map' num2str(k) ...
                '{kk}(cellindex(kk):cellindex(kk)+1)'])) ...
                str2double(eval(['map' num2str(k) '{kk}(numindex{kk}+1:end)']))];
        end
        AO.(ifam).ElementList(kk,:)  = kk;
    end

    AO.(ifam).DeviceName(:,:)    = dev;
    %% Build common names
    if (nb >= 10)
        AO.(ifam).CommonNames(:,:)   = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','.%02d')];
    else
        AO.(ifam).CommonNames(:,:)   = [repmat(AO.(ifam).FamilyName,nb,1) num2str((1:nb)','.%1d')];
    end

    AO.(ifam).Monitor.TangoNames(:,:)  = strcat(dev,'/current');
    AO.(ifam).Status = ones(nb,1);
    AO.(ifam).Monitor.Handles(:,1) = NaN*ones(nb,1);

    for ii=1:nb,
        val = 1.0;
        AO.(ifam).Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
        AO.(ifam).Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
        AO.(ifam).Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
        AO.(ifam).Monitor.Physics2HWParams{2}(ii,:)                 = val;
    end

    % Greg Portmann, visit mai
    %     AO.Q1.Monitor.HW2PhysicsParams{1} = 'Q1';
    %     AO.Q1.Monitor.Physics2HWParams{1} = 'Q1';

    AO.(ifam).Setpoint = AO.(ifam).Monitor;
    AO.(ifam).Desired  = AO.(ifam).Monitor;
    AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
    AO.(ifam).Setpoint.TangoNames(:,:)  = strcat(dev,'/currentPM');
    
    AO.(ifam).Setpoint.Tolerance(:,:) = 0.05*ones(nb,1);
    AO.(ifam).Setpoint.DeltaRespMat(:,:) = tune(k)*ones(nb,1);
    if k < 6
        AO.(ifam).Profibus.BoardNumber = int32(1);
        AO.(ifam).Profibus.Group       = int32(k);
    else
        AO.(ifam).Profibus.BoardNumber = int32(0);
        AO.(ifam).Profibus.Group       = int32(k-5);
    end        
    AO.(ifam).Profibus.DeviceName  = 'ANS/AE/DP.QP';
    
    %convert response matrix kicks to HWUnits (after AO is loaded to AppData)
    setao(AO);   %required to make physics2hw function
%     AO.(ifam).Setpoint.DeltaRespMat = physics2hw(AO.(ifam).FamilyName, ...
%         'Setpoint',AO.(ifam).Setpoint.DeltaRespMat,AO.(ifam).DeviceList,2.75);
    AO.(ifam).Setpoint.DeltaKBeta = 1; % for betatron function measurement.
    AO.(ifam).Setpoint.DeltaRespMat = 1; % A
end

% TODO : this is lattice dependent !
% step for tuneshift of 1-e-2 in one of the planes
AO.Q1.Setpoint.DeltaRespMat = 0.4; %A
AO.Q2.Setpoint.DeltaRespMat = 0.15;%A
AO.Q3.Setpoint.DeltaRespMat = 0.5; %A
AO.Q4.Setpoint.DeltaRespMat = 0.2; %A
AO.Q5.Setpoint.DeltaRespMat = 0.2; %A
AO.Q6.Setpoint.DeltaRespMat = 0.2; %A
AO.Q7.Setpoint.DeltaRespMat = 0.2; %A
AO.Q8.Setpoint.DeltaRespMat = 0.2; %A
AO.Q9.Setpoint.DeltaRespMat = 0.2; %A
AO.Q10.Setpoint.DeltaRespMat = 0.2; %A

%% QC13
ifam = 'QC13';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'PlotFamily'};
AO.(ifam).FamilyType             = 'QUADC13';
AO.(ifam).Mode                   = Mode;
AO.(ifam).DeviceName             = {'ANS-C13/AE/Q1'; 'ANS-C13/AE/Q2'; 'ANS-C13/AE/Q3';  'ANS-C13/AE/Q4.1'; 
                                    'ANS-C13/AE/Q5.1'; 'ANS-C13/AE/Q5.2'; 'ANS-C13/AE/Q4.2'; 'ANS-C13/AE/Q6'; 
                                    'ANS-C13/AE/Q7'; 'ANS-C13/AE/Q8' };
AO.(ifam).DeviceList             = [13 1; 13 2; 13 3; 13 4; 13 5; 13 6; 13 7; 13 8; 13 9; 13 10];
nb = length(AO.(ifam).DeviceList);
AO.(ifam).ElementList            = (1:nb)';
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'meter^-2';
AO.(ifam).Monitor.HW2PhysicsFcn  = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn  = @k2amp;
AO.(ifam).Monitor.TangoNames     = strcat(AO.(ifam).DeviceName, '/current');
AO.(ifam).Setpoint               = AO.(ifam).Monitor;
AO.(ifam).Desired                = AO.(ifam).Monitor;
AO.(ifam).Setpoint.MemberOf      = {'PlotFamily'};
AO.(ifam).Setpoint.TangoNames(:,:)  = strcat(AO.(ifam).DeviceName,'/currentPM');


clear tune

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SEXTUPOLE MAGNETS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:10,
    ifam = ['S' num2str(k)];

    AO.(ifam).FamilyName                = ifam;
    AO.(ifam).FamilyType                = 'SEXT';
    AO.(ifam).MemberOf                  = {'MachineConfig'; 'SEXT'; 'Magnet'; 'PlotFamily'; 'Archivable'};
    [C, Leff, MagnetType, coefficients]= magnetcoefficients(AO.(ifam).FamilyName);
    HW2PhysicsParams                   = C;
    Physics2HWParams                   = HW2PhysicsParams;

    AO.(ifam).Monitor.Mode              = Mode;
    AO.(ifam).Monitor.DataType          = 'Scalar';
    AO.(ifam).Monitor.Units             = 'Hardware';
    AO.(ifam).Monitor.HW2PhysicsFcn     = @amp2k;
    AO.(ifam).Monitor.Physics2HWFcn     = @k2amp;
    AO.(ifam).Monitor.HWUnits           = 'A';
    AO.(ifam).Monitor.PhysicsUnits      = 'meter^-3';
    AO.(ifam).DeviceList                = [1 1];
    AO.(ifam).ElementList               = 1;

    AO.(ifam).DeviceName    = ['ANS/AE/S' num2str(k)];
    AO.(ifam).CommonNames   = ifam;

    dev = AO.(ifam).DeviceName;
    AO.(ifam).Monitor.TangoNames  = strcat(dev,'/current');
 
    AO.(ifam).Status          = 1;
    AO.(ifam).Monitor.Handles = NaN;
    
    val = 1.0; % scaling factor
    
    AO.(ifam).Monitor.HW2PhysicsParams{1}(1,:)               = HW2PhysicsParams;
    AO.(ifam).Monitor.HW2PhysicsParams{2}(1,:)               = val;
    AO.(ifam).Monitor.Physics2HWParams{1}(1,:)               = Physics2HWParams;
    AO.(ifam).Monitor.Physics2HWParams{2}(1,:)               = val;

    AO.(ifam).Monitor.Range(:,:) = [0 400]; % 343 A for 320 Tm-2

    AO.(ifam).Setpoint.MemberOf  = {'PlotFamily'};
    AO.(ifam).Setpoint = AO.(ifam).Monitor;
    AO.(ifam).Desired  = AO.(ifam).Monitor;
    AO.(ifam).Setpoint.TangoNames   = strcat(dev,'/currentPM');
    
    AO.(ifam).Setpoint.Tolerance     = 0.05;
    AO.(ifam).Setpoint.DeltaRespMat  = 2e7; % Physics units for a thin sextupole
 
    %convert response matrix kicks to HWUnits (after AO is loaded to AppData)
    setao(AO);   %required to make physics2hw function
    AO.(ifam).Setpoint.DeltaRespMat=physics2hw(AO.(ifam).FamilyName,'Setpoint',AO.(ifam).Setpoint.DeltaRespMat,AO.(ifam).DeviceList);
end

%%%%%%%%%%%%%%%%%%
%% Pulsed Magnet
%%%%%%%%%%%%%%%%%%

%% All Injection kicker 
ifam = 'K_INJ'; 
AO.(ifam).FamilyName           = ifam;
AO.(ifam).FamilyType           = ifam;
AO.(ifam).MemberOf             = {'Injection';'Archivable';'EP'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

AO.(ifam).Status                   = ones(4,1);
AO.(ifam).DeviceName               = ['ANS-C01/EP/AL_K.1'; 'ANS-C01/EP/AL_K.2'; 'ANS-C01/EP/AL_K.3'; 'ANS-C01/EP/AL_K.4'];
AO.(ifam).CommonNames              = ifam;
AO.(ifam).ElementList              = [1 2 3 4]';
AO.(ifam).DeviceList(:,:)          = [1 1; 1 2; 1 3; 1 4];
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(4,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/voltage');
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'V';
AO.(ifam).Monitor.PhysicsUnits     = 'mrad';
AO.(ifam).Monitor.HW2PhysicsFcn     = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn     = @k2amp;
HW2PhysicsParams                    = magnetcoefficients(ifam);
Physics2HWParams                    = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = 1;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = 1;
AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;

%% K1 and K4 Injection kicker
ifam = 'K_INJ1'; 
AO.(ifam).FamilyName           = ifam;
AO.(ifam).FamilyType           = ifam;
AO.(ifam).MemberOf             = {'Injection';'Archivable';'EP'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

AO.(ifam).Status                   = ones(2,1);
AO.(ifam).DeviceName               = ['ANS-C01/EP/AL_K.1'; 'ANS-C01/EP/AL_K.4'];
AO.(ifam).CommonNames              = ifam;
AO.(ifam).ElementList              = [1 2]';
AO.(ifam).DeviceList(:,:)          = [1 1;  1 4];
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(2,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/voltage');
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'V';
AO.(ifam).Monitor.PhysicsUnits     = 'mrad';
AO.(ifam).Monitor.HW2PhysicsFcn     = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn     = @k2amp;
HW2PhysicsParams                    = magnetcoefficients(ifam);
Physics2HWParams                    = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = 1;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = 1;
AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;

%% K2 and K3 Injection kicker
ifam = 'K_INJ2'; 
AO.(ifam).FamilyName           = ifam;
AO.(ifam).FamilyType           = ifam;
AO.(ifam).MemberOf             = {'Injection';'Archivable';'EP'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

AO.(ifam).Status                   = ones(2,1);
AO.(ifam).DeviceName               = ['ANS-C01/EP/AL_K.2'; 'ANS-C01/EP/AL_K.3'];
AO.(ifam).CommonNames              = ifam;
AO.(ifam).ElementList              = [1 2]';
AO.(ifam).DeviceList(:,:)          = [1 2;  1 3];
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(2,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/voltage');
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'V';
AO.(ifam).Monitor.PhysicsUnits     = 'mrad';
AO.(ifam).Monitor.HW2PhysicsFcn     = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn     = @k2amp;
HW2PhysicsParams                    = magnetcoefficients(ifam);
Physics2HWParams                    = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = 1;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = 1;
AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;

%% Septum Passif
ifam = 'SEP_P'; 
AO.(ifam).FamilyName           =  ifam;
AO.(ifam).FamilyType           =  ifam;
AO.(ifam).MemberOf             =  {'Injection';'Archivable';'EP'};
AO.(ifam).Monitor.Mode         =   Mode;
AO.(ifam).Monitor.DataType     =  'Scalar';

AO.(ifam).Status                   = 1;
AO.(ifam).DeviceName               = cellstr('ANS-C01/EP/AL_SEP_P.1');
AO.(ifam).CommonNames              = ifam;
AO.(ifam).ElementList              = 1;
AO.(ifam).DeviceList(:,:)          = [1 1];
AO.(ifam).Monitor.Handles(:,1)     = NaN;
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/serialVoltage');
AO.(ifam).Monitor.HW2PhysicsFcn    = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn    = @k2amp;
HW2PhysicsParams                   = magnetcoefficients(ifam);
Physics2HWParams                   = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = 1;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'V';
AO.(ifam).Monitor.PhysicsUnits     = 'mrad';
AO.(ifam).Desired  = AO.(ifam).Monitor;
AO.(ifam).Setpoint = AO.(ifam).Monitor;


%% Septum Actif
ifam = 'SEP_A'; 
AO.(ifam).FamilyName           = ifam;
AO.(ifam).FamilyType           = ifam;
AO.(ifam).MemberOf             = {'Injection';'Archivable';'EP'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

AO.(ifam).Status                   = 1;
AO.(ifam).DeviceName               = cellstr('ANS-C01/EP/AL_SEP_A');
AO.(ifam).CommonNames              = 'SEP_A_INJ';
AO.(ifam).ElementList              = 1;
AO.(ifam).DeviceList(:,:)           = [1 1];
AO.(ifam).Monitor.Handles(:,1)     = NaN;
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/voltage');
AO.(ifam).Monitor.HW2PhysicsFcn     = @amp2k;
AO.(ifam).Monitor.Physics2HWFcn     = @k2amp;
HW2PhysicsParams                    = magnetcoefficients(ifam);
Physics2HWParams                    = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{1}(:,:) = HW2PhysicsParams;
AO.(ifam).Monitor.HW2PhysicsParams{2}(:,:) = 1;
AO.(ifam).Monitor.Physics2HWParams{1}(:,:) = Physics2HWParams;
AO.(ifam).Monitor.Physics2HWParams{2}(:,:) = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'V';
AO.(ifam).Monitor.PhysicsUnits     = 'mrad';
AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired = AO.(ifam).Monitor;


%% tune correctors
AO.Q7.MemberOf  = {AO.Q7.MemberOf{:} 'Tune Corrector'}';
AO.Q9.MemberOf = {AO.Q9.MemberOf{:} 'Tune Corrector'}';

%% chromaticity correctors
AO.S9.MemberOf  = {AO.S9.MemberOf{:} 'Chromaticity Corrector'}';
AO.S10.MemberOf = {AO.S10.MemberOf{:} 'Chromaticity Corrector'}';


%%%%%%%%%%%%%%%%%%
%% CYCLAGE
%%%%%%%%%%%%%%%%%

disp('cycling configuration ...');

%% cycleramp For dipole magnet
ifam = 'CycleBEND';

AO.(ifam).FamilyName             = 'CycleBEND';
AO.(ifam).MemberOf               = {'CycleBEND'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create('Dipole'); 
AO.(ifam).DeviceName             = 'ANS/AE/cycleDipole';
AO.(ifam).DeviceList             = [1 1]; 
AO.(ifam).ElementList            = 1;
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName);
AO.(ifam).Inom = 541.789;
AO.(ifam).Imax = 579.9;
AO.(ifam).Status = 1;

% %% cycleramp For H-corrector magnets
% ifam  = 'CycleHCOR';
% ifamQ = 'HCOR';
% 
% AO.(ifam).FamilyName             = ifam;
% AO.(ifam).MemberOf               = {'CycleCOR'; ifam; 'Cyclage'};
% AO.(ifam).Mode                   = Mode;
% AO.(ifam).GroupId                = tango_group_create('COR'); 
% dev = getfamilydata(ifamQ,'DeviceName');
% AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
% AO.(ifam).DeviceList             = family2dev(ifamQ);
% AO.(ifam).ElementList            = family2elem(ifamQ);
% %add devices to group
% tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
% nb = length(AO.(ifam).ElementList);
% AO.(ifam).Inom = 1.*ones(1,nb);
% AO.(ifam).Imax = 13.99*ones(1,nb);
% AO.(ifam).Status = ones(nb,1);
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
% AO.(ifam).Monitor.DataType       = 'Scalar';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'ampere';
% AO.(ifam).Monitor.PhysicsUnits   = 'rad';
% AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');
% 
% %% cycleramp For V-corrector magnets
% ifam = 'CycleVCOR';
% ifamQ = 'VCOR';
% 
% AO.(ifam).FamilyName             = ifam;
% AO.(ifam).MemberOf               = {'CycleCOR'; ifam; 'Cyclage'};
% AO.(ifam).Mode                   = Mode;
% dev = getfamilydata(ifamQ,'DeviceName');
% AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
% AO.(ifam).DeviceList             = family2dev(ifamQ);
% AO.(ifam).ElementList            = family2elem(ifamQ);
% %add devices to group
% AO.(ifam).GroupId                = tango_group_create('COR'); 
% tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
% nb = length(AO.(ifam).ElementList);
% AO.(ifam).Inom = 1.*ones(1,nb);
% AO.(ifam).Imax = 13.99*ones(1,nb);
% AO.(ifam).Status = ones(nb,1);
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
% AO.(ifam).Monitor.DataType       = 'Scalar';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'ampere';
% AO.(ifam).Monitor.PhysicsUnits   = 'rad';
% AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

% cycleramp For quadrupoles magnets
%% CYCLEQ1  
ifam = 'CycleQ1';
ifamQ = 'Q1';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 200.*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ2  
ifam = 'CycleQ2';
ifamQ = 'Q2';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = 249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ3
ifam = 'CycleQ3';
ifamQ = 'Q3';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ4
ifam = 'CycleQ4';
ifamQ = 'Q4';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ5
ifam = 'CycleQ5';
ifamQ = 'Q5';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = 249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ6
ifam = 'CycleQ6';
ifamQ = 'Q6';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ7
ifam = 'CycleQ7';
ifamQ = 'Q7';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = 249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ8
ifam = 'CycleQ8';
ifamQ = 'Q8';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ9
ifam = 'CycleQ9';
ifamQ = 'Q9';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = -249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQ10
ifam = 'CycleQ10';
ifamQ = 'Q10';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/Q','/cycleQ');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
%AO.(ifam).Inom = 150*ones(1,nb);
AO.(ifam).Imax = 249*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLEQC13
ifam = 'CycleQC13';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam;'CycleQP'; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
AO.(ifam).GroupId                = tango_group_create(ifam); 
%dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = {'ANS-C13/AE/cycleQ1'; 'ANS-C13/AE/cycleQ2'; 'ANS-C13/AE/cycleQ3';  'ANS-C13/AE/cycleQ4.1'; 
                                    'ANS-C13/AE/cycleQ5.1'; 'ANS-C13/AE/cycleQ5.2'; 'ANS-C13/AE/cycleQ4.2'; ...
                                    'ANS-C13/AE/cycleQ6'; 'ANS-C13/AE/cycleQ7'; 'ANS-C13/AE/cycleQ8' };
AO.(ifam).DeviceList             = [13 1; 13 2; 13 3; 13 4; 13 5; 13 6; 13 7; 13 8; 13 9; 13 10];
AO.(ifam).ElementList            = (1:10)';
%add devices to group
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 249*[-1 1 -1 -1 1 1 -1 -1 1 -1];
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% cycleramp for sextupole magnets
%% CYCLES1  
ifam = 'CycleS1';
ifamQ = 'S1';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES2  
ifam = 'CycleS2';
ifamQ = 'S2';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = -349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES3  
ifam = 'CycleS3';
ifamQ = 'S3';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = -349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES4  
ifam = 'CycleS4';
ifamQ = 'S4';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES5  
ifam = 'CycleS5';
ifamQ = 'S5';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = -349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES6  
ifam = 'CycleS6';
ifamQ = 'S6';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES7  
ifam = 'CycleS7';
ifamQ = 'S7';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = -349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES8  
ifam = 'CycleS8';
ifamQ = 'S8';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES9  
ifam = 'CycleS9';
ifamQ = 'S9';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = -349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%% CYCLES10  
ifam = 'CycleS10';
ifamQ = 'S10';

AO.(ifam).FamilyName             = ifam;
AO.(ifam).MemberOf               = {ifam; 'Cyclage'};
AO.(ifam).Mode                   = Mode;
dev = getfamilydata(ifamQ,'DeviceName');
AO.(ifam).DeviceName             = regexprep(dev,'/S','/cycleS');
AO.(ifam).DeviceList             = family2dev(ifamQ);
AO.(ifam).ElementList            = family2elem(ifamQ);
%add devices to group
AO.(ifam).GroupId                = tango_group_create(ifamQ); 
tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
nb = length(AO.(ifam).ElementList);
AO.(ifam).Imax = 349*ones(1,nb);
AO.(ifam).Status = ones(nb,1);
AO.(ifam).Monitor.Mode           = Mode;
AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(nb,1);
AO.(ifam).Monitor.DataType       = 'Scalar';
AO.(ifam).Monitor.Units          = 'Hardware';
AO.(ifam).Monitor.HWUnits        = 'ampere';
AO.(ifam).Monitor.PhysicsUnits   = 'rad';
AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%============
%% RF System
%============
ifam = 'RF';
AO.(ifam).FamilyName                = ifam;
AO.(ifam).FamilyType                = 'RF';
AO.(ifam).MemberOf                  = {'RF','RFSystem'};
AO.(ifam).Status                    = 1;
AO.(ifam).CommonNames               = 'RF';
AO.(ifam).DeviceList                = [1 1];
AO.(ifam).ElementList               = 1;
AO.(ifam).DeviceName(:,:)           = {'ANS/RF/MasterClock/'};

%Frequency Readback
AO.(ifam).Monitor.Mode                = Mode;
% AO.(ifam).Monitor.Mode                = 'Special';
% AO.(ifam).Monitor.SpecialFunctionGet = 'getrf2';
AO.(ifam).Monitor.DataType            = 'Scalar';
AO.(ifam).Monitor.Units               = 'Hardware';
AO.(ifam).Monitor.HW2PhysicsParams    = 1e+6;       %no hw2physics function necessary
AO.(ifam).Monitor.Physics2HWParams    = 1e-6;
AO.(ifam).Monitor.HWUnits             = 'MHz';
AO.(ifam).Monitor.PhysicsUnits        = 'Hz';
AO.(ifam).Monitor.TangoNames          = {'ANS/RF/MasterClock/frequency'};
AO.(ifam).Monitor.Handles             = NaN;
AO.(ifam).Monitor.Range               = [351 353];

AO.(ifam).Setpoint = AO.(ifam).Monitor;
AO.(ifam).Desired  = AO.(ifam).Monitor;

%Voltage control
AO.(ifam).VoltageCtrl.Mode               = Mode;
AO.(ifam).VoltageCtrl.DataType           = 'Scalar';
AO.(ifam).VoltageCtrl.Units              = 'Hardware';
AO.(ifam).VoltageCtrl.HW2PhysicsParams   = 1;
AO.(ifam).VoltageCtrl.Physics2HWParams   = 1;
AO.(ifam).VoltageCtrl.HWUnits            = 'Volts';
AO.(ifam).VoltageCtrl.PhysicsUnits       = 'Volts';
% AO.(ifam).VoltageCtrl.ChannelNames       = 'SRF1:STN:VOLT:CTRL';
AO.(ifam).VoltageCtrl.TangoNames          = 'ANS/DGsim/tracy/nux';
AO.(ifam).VoltageCtrl.Range              = [-inf inf];
AO.(ifam).VoltageCtrl.Tolerance          = inf;
AO.(ifam).VoltageCtrl.Handles            = NaN;

%Voltage monitor
AO.(ifam).Voltage.Mode               = Mode;
AO.(ifam).Voltage.DataType           = 'Scalar';
AO.(ifam).Voltage.Units              = 'Hardware';
AO.(ifam).Voltage.HW2PhysicsParams   = 1;
AO.(ifam).Voltage.Physics2HWParams   = 1;
AO.(ifam).Voltage.HWUnits            = 'Volts';
AO.(ifam).Voltage.PhysicsUnits       = 'Volts';
% AO.(ifam).Voltage.ChannelNames       = 'SRF1:STN:VOLT';
AO.(ifam).Voltage.Range              = [-inf inf];
AO.(ifam).Voltage.Tolerance          = inf;
AO.(ifam).Voltage.Handles            = NaN;

% %Power Control
% AO.(ifam).PowerCtrl.Mode               = Mode;
% AO.(ifam).PowerCtrl.DataType           = 'Scalar';
% AO.(ifam).PowerCtrl.Units              = 'Hardware';
% AO.(ifam).PowerCtrl.HW2PhysicsParams   = 1;
% AO.(ifam).PowerCtrl.Physics2HWParams   = 1;
% AO.(ifam).PowerCtrl.HWUnits            = 'MWatts';
% AO.(ifam).PowerCtrl.PhysicsUnits       = 'MWatts';
% AO.(ifam).PowerCtrl.ChannelNames       = 'SRF1:KLYSDRIVFRWD:POWER:ON';
% AO.(ifam).PowerCtrl.Range              = [-inf inf];
% AO.(ifam).PowerCtrl.Tolerance          = inf;
% AO.(ifam).PowerCtrl.Handles            = NaN;
%
% %Power Monitor
% AO.(ifam).Power.Mode               = Mode;
% AO.(ifam).Power.DataType           = 'Scalar';
% AO.(ifam).Power.Units              = 'Hardware';
% AO.(ifam).Power.HW2PhysicsParams   = 1;
% AO.(ifam).Power.Physics2HWParams   = 1;
% AO.(ifam).Power.HWUnits            = 'MWatts';
% AO.(ifam).Power.PhysicsUnits       = 'MWatts';
% AO.(ifam).Power.ChannelNames       = 'SRF1:KLYSDRIVFRWD:POWER';
% AO.(ifam).Power.Range              = [-inf inf];
% AO.(ifam).Power.Tolerance          = inf;
% AO.(ifam).Power.Handles            = NaN;
%
% %Station Phase Control
% AO.(ifam).PhaseCtrl.Mode               = Mode;
% AO.(ifam).PhaseCtrl.DataType           = 'Scalar';
% AO.(ifam).PhaseCtrl.Units              = 'Hardware';
% AO.(ifam).PhaseCtrl.HW2PhysicsParams   = 1;
% AO.(ifam).PhaseCtrl.Physics2HWParams   = 1;
% AO.(ifam).PhaseCtrl.HWUnits            = 'Degrees';
% AO.(ifam).PhaseCtrl.PhysicsUnits       = 'Degrees';
% AO.(ifam).PhaseCtrl.ChannelNames       = 'SRF1:STN:PHASE';
% AO.(ifam).PhaseCtrl.Range              = [-200 200];
% AO.(ifam).PhaseCtrl.Tolerance          = inf;
% AO.(ifam).PhaseCtrl.Handles            = NaN;
%
% %Station Phase Monitor
% AO.(ifam).Phase.Mode               = Mode;
% AO.(ifam).Phase.DataType           = 'Scalar';
% AO.(ifam).Phase.Units              = 'Hardware';
% AO.(ifam).Phase.HW2PhysicsParams   = 1;
% AO.(ifam).Phase.Physics2HWParams   = 1;
% AO.(ifam).Phase.HWUnits            = 'Degrees';
% AO.(ifam).Phase.PhysicsUnits       = 'Degrees';
% AO.(ifam).Phase.ChannelNames       = 'SRF1:STN:PHASE:CALC';
% AO.(ifam).Phase.Range              = [-200 200];
% AO.(ifam).Phase.Tolerance          = inf;
% AO.(ifam).Phase.Handles            = NaN;

%=======
%% CHROMATICITIES: Soft Family
%=======
ifam = 'CHRO';
AO.(ifam).FamilyName  = ifam;
AO.(ifam).FamilyType  = 'Diagnostic';
AO.(ifam).MemberOf    = {'Diagnostics'};
AO.(ifam).CommonNames = ['xix';'xiz'];
AO.(ifam).DeviceList  = [ 1 1; 1 2;];
AO.(ifam).ElementList = [1; 2];
AO.(ifam).Status      = [1; 1];

%======
%% Dipole B-FIELD from RMN probe
%======
ifam = 'RMN';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'EM';
AO.(ifam).MemberOf                       = {'EM',ifam};
AO.(ifam).CommonNames                    = ifam;
AO.(ifam).DeviceList                     = [1 1];
AO.(ifam).ElementList                    = 1;
AO.(ifam).Status                         = AO.(ifam).ElementList;

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames             = 'ANS-C13/EM/RMN/magneticField'; %afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'mGauss';
AO.(ifam).Monitor.PhysicsUnits           = 'T';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;

%=======
%% TUNE
%=======
ifam = 'TUNE';
AO.(ifam).FamilyName  = ifam;
AO.(ifam).FamilyType  = 'Diagnostic';
AO.(ifam).MemberOf    = {'Diagnostics'};
AO.(ifam).CommonNames = ['nux';'nuz';'nus'];
AO.(ifam).DeviceList  = [1 1; 1 2; 1 3];
AO.(ifam).ElementList = [1 2 3]';
AO.(ifam).Status      = [1 1 1]';

AO.(ifam).Monitor.Mode                   = Mode; %'Simulator';  % Mode;
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.DataTypeIndex          = [1 2];
AO.(ifam).Monitor.TangoNames             = ['ANS/DG/BPM-TUNEX/Nu';'ANS/DG/BPM-TUNEZ/Nu';'ANS/DG/BPM-TUNEZ/Nu'];
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;
AO.(ifam).Monitor.HWUnits                = 'fractional tune';
AO.(ifam).Monitor.PhysicsUnits           = 'fractional tune';


%======
%% DCCT
%======
ifam = 'DCCT';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Diagnostic';
AO.(ifam).MemberOf                       = {'Diagnostics','DCCT'};
AO.(ifam).CommonNames                    = 'DCCT';
AO.(ifam).DeviceList                     = [1 1];
AO.(ifam).ElementList                    = 1;
AO.(ifam).Status                         = AO.(ifam).ElementList;

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = 'DCCT';
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames             = 'ANS-C03/DG/DCCT/current'; %afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'mA';
AO.(ifam).Monitor.PhysicsUnits           = 'A';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;

% On une famille ???
ifam = 'DCCT1';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Diagnostic';
AO.(ifam).MemberOf                       = {'Diagnostics','DCCT'};
AO.(ifam).CommonNames                    = 'DCCT1';
AO.(ifam).DeviceList                     = [1 1];
AO.(ifam).ElementList                    = 1;
AO.(ifam).Status                         = AO.(ifam).ElementList;

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = 'DCCT';
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames              = 'ANS-C03/DG/DCCT/current'; %afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'mA';
AO.(ifam).Monitor.PhysicsUnits           = 'A';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;

ifam = 'DCCT2';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Diagnostic';
AO.(ifam).MemberOf                       = {'Diagnostics','DCCT'};
AO.(ifam).CommonNames                    = 'ANS-C14/DG/DCCT';
AO.(ifam).DeviceList                     = [1 1];
AO.(ifam).ElementList                    = 1;
AO.(ifam).Status                         = AO.(ifam).ElementList;

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = 'DCCT';
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames             = 'ANS-C03/DG/DCCT/current'; %afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'mA';
AO.(ifam).Monitor.PhysicsUnits           = 'A';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;

ifam = 'LifeTime';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Diagnostic';
AO.(ifam).MemberOf                       = {'Diagnostics','DCCT'};
AO.(ifam).CommonNames                    = 'DCCT';
AO.(ifam).DeviceList                     = [1 1];
AO.(ifam).ElementList                    = 1;
AO.(ifam).Status                         = AO.(ifam).ElementList;

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = 'DCCT';
AO.(ifam).Monitor.DataType               = 'Scalar';
AO.(ifam).Monitor.TangoNames             = 'ANS-C03/DG/DCCT/lifeTime'; %afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'Hours';
AO.(ifam).Monitor.PhysicsUnits           = 'Hours';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;


% %% cycleramp For quadrupoles magnets
% ifam = 'CycleQP';
% 
% AO.(ifam).FamilyName             = ifam;
% AO.(ifam).MemberOf               = {'CycleQP'; 'Cyclage'};
% AO.(ifam).Mode                   = Mode;
% AO.(ifam).GroupId                = tango_group_create('Quadrupole'); 
% AO.(ifam).DeviceList             = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7];
% AO.(ifam).ElementList            = (1:7)';
% AO.(ifam).DeviceName             = {'LT1/AE/cycleQ.1';'LT1/AE/cycleQ.2'; ...
%                                     'LT1/AE/cycleQ.3';'LT1/AE/cycleQ.4'; ...
%                                     'LT1/AE/cycleQ.5';'LT1/AE/cycleQ.6'; ...
%                                     'LT1/AE/cycleQ.7'};
% %add devices to group
% tango_group_add(AO.(ifam).GroupId, AO.(ifam).DeviceName');
% %AO.(ifam).Imax = 8*ones(1,7);
% % modification mars 2006
% AO.(ifam).Imax = [8  -8  -8  8  8  -8  8 ];
% AO.(ifam).Status = ones(7,1);
% AO.(ifam).Monitor.Mode           = Mode;
% AO.(ifam).Monitor.Handles(:,1)   = NaN*ones(7,1);
% AO.(ifam).Monitor.DataType       = 'Scalar';
% AO.(ifam).Monitor.Units          = 'Hardware';
% AO.(ifam).Monitor.HWUnits        = 'ampere';
% AO.(ifam).Monitor.PhysicsUnits   = 'rad';
% AO.(ifam).Monitor.TangoNames   = strcat(AO.(ifam).DeviceName, '/totalProgression');

%%%%%%%%%%%%%%%%%%
%% Alignment
%%%%%%%%%%%%%%%%%%

disp('aligment configuration ...')

%% HLS
ifam = 'HLS';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).FamilyType           = ifam;
AO.(ifam).MemberOf             = {'PlotFamily'; 'Alignment'; 'HLS'; 'Archivable'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map       = tango_get_db_property('anneau','HLS');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
%numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

% builds up devicelist
nb = size(map,2);
ik = 0; cellnum = 1;
for k = 1:nb,
    if cellnum - str2double(map{k}(cellindex(k):cellindex(k)+1)) ~=0
        ik = 1;
    else
        ik = ik+1;
    end
    cellnum = str2double(map{k}(cellindex(k):cellindex(k)+1));
    AO.(ifam).DeviceList(k,:)  = [cellnum ik];
    AO.(ifam).CommonNames(k,:)      = map{k}(12:17);
end

AO.(ifam).ElementList = (1:nb)';

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/height');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mm';
AO.(ifam).Monitor.PhysicsUnits     = 'm';
%AO.(ifam).Position = (1:168)'/168*354;

AO.(ifam).Position = [6.000 7.370 9.270 10.323 12.549 14.775 15.828 17.178 18.548 25.512 27.272 28.232 29.284 30.244 31.241 35.051 36.047 37.007 38.059 39.019 40.779 50.262 51.632 53.532 54.585 56.811 59.037 60.090 61.440 62.810 69.774 71.534 72.494 73.546 74.506 75.503 79.313 80.309 81.269 82.322 83.282 85.042 94.524 95.894 97.794 98.847 101.073 103.299 104.352 105.702 107.072 114.036 115.796 116.756 117.809 118.769 119.765 123.575 124.571 125.531 126.584 127.544 129.304 138.786 140.156 142.056 143.109 145.335 147.561 148.614 149.964 151.334 158.298 160.058 161.018 162.071 163.031 164.027 167.837 168.833 169.793 170.846 171.806 173.566 183.049 184.419 186.319 187.371 189.597 191.824 192.876 194.226 195.596 202.560 204.320 205.280 206.333 207.293 208.289 212.099 213.095 214.055 215.108 216.068 217.828 227.311 228.681 230.581 231.633 233.859 236.086 237.138 238.488 239.858 246.822 248.582 249.542 250.595 251.555 252.551 256.361 257.357 258.317 259.370 260.330 262.090 271.573 272.943 274.843 275.895 278.121 280.348 281.400 282.750 284.120 291.085 292.845 293.805 294.857 295.817 296.813 300.623 301.620 302.580 303.632 304.592 306.352 315.835 317.205 319.105 320.157 322.384 324.610 325.662 327.012 328.382 335.347 337.107 338.067 339.119 340.079 341.075 344.885 345.882 346.842 347.894 348.854 350.614];
AO.(ifam).Position = AO.(ifam).Position(:);

AO.(ifam).Mean = AO.(ifam).Monitor;
AO.(ifam).Mean.TangoNames       = strcat(AO.(ifam).DeviceName, '/average');
AO.(ifam).Mean.MemberOf = {'Plotfamily'};

AO.(ifam).Std = AO.(ifam).Monitor;
AO.(ifam).Std.TangoNames       = strcat(AO.(ifam).DeviceName, '/standardDeviation');
AO.(ifam).Std.MemberOf = {'Plotfamily'};

AO.(ifam).Voltage = AO.(ifam).Monitor;
AO.(ifam).Voltage.TangoNames       = strcat(AO.(ifam).DeviceName, '/voltage');
AO.(ifam).Voltage.MemberOf = {'Plotfamily'};

%%%%%%%%%%%%%%%%%%
%% VACUUM SYSTEM
%%%%%%%%%%%%%%%%%%

disp('vacuum configuration ...')

%% IonPump
ifam = 'PI';
AO.(ifam).FamilyName           = 'PI';
AO.(ifam).FamilyType           = 'PI';
AO.(ifam).MemberOf             = {'PlotFamily'; 'IonPump'; 'Pressure'; 'Archivable';};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map       = tango_get_db_property('anneau','pompe_ionique');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;


nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).ElementList = (1:nb)';


AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat('PI',nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mbar';
AO.(ifam).Monitor.PhysicsUnits     = 'mbar';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%% Penning Gauges
ifam = 'JPEN';
AO.(ifam).FamilyName           = 'JPEN';
AO.(ifam).MemberOf             = {'PlotFamily'; 'PenningGauge'; 'Pressure'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','jauge_penning');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).ElementList = (1:nb)';

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat('JPEN',nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mbar';
AO.(ifam).Monitor.PhysicsUnits     = 'mbar';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%% Pirani Gauges
ifam = 'JPIR';
AO.(ifam).FamilyName           = 'JPIR';
AO.(ifam).MemberOf             = {'PlotFamily'; 'PiraniGauge'; 'Pressure'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','jauge_piranni');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat('JPIR',nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mbar';
AO.(ifam).Monitor.PhysicsUnits     = 'mbar';

%% Bayer Albert Gauges
ifam = 'JBA';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'PlotFamily'; 'PiraniGauge'; 'Pressure'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','jauge_bayer_alpert');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat(ifam,nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/pressure');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'mbar';
AO.(ifam).Monitor.PhysicsUnits     = 'mbar';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%% Thermocouples
ifam = 'TC';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'PlotFamily'; 'PiraniGauge'; 'Pressure'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','thermocouple');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat(ifam,nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/temperature');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = '°C';
AO.(ifam).Monitor.PhysicsUnits     = '°C';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%% DEBIMETRES
ifam = 'DEB';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'Vaccuum'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','debitmetre');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat(ifam,nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/temperature');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'au';
AO.(ifam).Monitor.PhysicsUnits     = 'au';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%% VM
ifam = 'VM';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'PlotFamily'; 'Vaccuum'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','vanne_manuelle');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat(ifam,nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/temperature');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'au';
AO.(ifam).Monitor.PhysicsUnits     = 'au';

%% VS
ifam = 'VS';
AO.(ifam).FamilyName           = ifam;
AO.(ifam).MemberOf             = {'PlotFamily'; 'Vaccuum'; 'Archivable';'PlotFamily'};
AO.(ifam).Monitor.Mode         = Mode;
AO.(ifam).Monitor.DataType     = 'Scalar';

map     = tango_get_db_property('anneau','vanne_secteur');
cellindex = cell2mat(regexpi(map,'C[0-9]','once'))+1;
numindex  = cell2mat(regexpi(map,'\.[0-9]','once'))+1;

nb = size(map,2);
for k = 1:nb,
    AO.(ifam).DeviceList(k,:)  = [str2double(map{k}(cellindex(k):cellindex(k)+1)) str2double(map{k}(numindex(k):end))];
end

AO.(ifam).Status                   = ones(nb,1);
AO.(ifam).DeviceName               = map';
AO.(ifam).CommonNames              = [repmat(ifam,nb,1) num2str((1:nb)','%02d')];
AO.(ifam).ElementList              = (1:nb)';
AO.(ifam).Monitor.Handles(:,1)     = NaN*ones(nb,1);
AO.(ifam).Monitor.TangoNames       = strcat(AO.(ifam).DeviceName, '/temperature');
AO.(ifam).Monitor.HW2PhysicsParams = 1;
AO.(ifam).Monitor.Physics2HWParams = 1;
AO.(ifam).Monitor.Units            = 'Hardware';   
AO.(ifam).Monitor.HWUnits          = 'au';
AO.(ifam).Monitor.PhysicsUnits     = 'au';
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%=====================
%% Gamma Monitors DOSE
%====================
ifam = 'CIGdose';
AO.(ifam).FamilyName                     = 'CIGdose';
AO.(ifam).FamilyType                     = 'Radioprotection';
AO.(ifam).MemberOf                       = {'Radioprotection','Archivable','Plotfamily','PlotFamily'};
AO.(ifam).CommonNames                    = 'CIG';

map = tango_get_db_property('anneau','gammamonitor_mapping');
AO.(ifam).DeviceName = map';

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = 'CIGdose';
AO.(ifam).Monitor.DataType               = 'Scalar';

nb = length(AO.(ifam).DeviceName); 
AO.(ifam).DeviceList                     = [ones(1,nb); (1:nb)]';
AO.(ifam).ElementList                    = (1:nb)';
AO.(ifam).Status                         = ones(nb,1);

AO.(ifam).Monitor.TangoNames            = strcat(AO.(ifam).DeviceName,'/dose'); 

%afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'uGy';
AO.(ifam).Monitor.PhysicsUnits           = 'uGy';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;
AO.(ifam).Position                       = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%=========================
%% Gamma Monitors DOSErate
%=========================

ifam = 'CIGrate';
AO.(ifam) = AO.CIGdose;
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).CommonNames                    = ifam;

nb = length(AO.(ifam).DeviceName); 
AO.(ifam).Status                         = ones(nb,1);
AO.(ifam).DeviceList                     = [ones(1,nb); (1:nb)]';
AO.(ifam).ElementList                    = (1:nb)';

AO.(ifam).Monitor.TangoNames            = strcat(AO.(ifam).DeviceName,'/doseRate'); 

%afin de ne pas avoir de bug
AO.CIG.Monitor.HWUnits                = 'uGy/h';
AO.CIG.Monitor.PhysicsUnits           = 'uGy/h';

%=====================
%% Neutron Monitors DOSE
%====================
ifam = 'MONdose';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Radioprotection';
AO.(ifam).MemberOf                       = {'Radioprotection','Archivable','Plotfamily','PlotFamily'};
AO.(ifam).CommonNames                    = 'MON';

map = tango_get_db_property('anneau','neutronmonitor_mapping');
AO.(ifam).DeviceName = map';

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).Monitor.DataType               = 'Scalar';

nb = length(AO.(ifam).DeviceName); 
AO.(ifam).DeviceList                     = [ones(1,nb); (1:nb)]';
AO.(ifam).ElementList                    = (1:nb)';
AO.(ifam).Status                         = ones(nb,1);

AO.(ifam).Monitor.TangoNames            = strcat(AO.(ifam).DeviceName,'/dDoseSinceReset'); 

%afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'uGy';
AO.(ifam).Monitor.PhysicsUnits           = 'uGy';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);

%============================
%% Neutron Monitors DOSE RATE
%============================
ifam = 'MONrate';
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).FamilyType                     = 'Radioprotection';
AO.(ifam).MemberOf                       = {'Radioprotection','Archivable','Plotfamily','PlotFamily'};
AO.(ifam).CommonNames                    = 'MON';

map = tango_get_db_property('anneau','neutronmonitor_mapping');
AO.(ifam).DeviceName = map';

AO.(ifam).Monitor.Mode                   = Mode;
AO.(ifam).FamilyName                     = ifam;
AO.(ifam).Monitor.DataType               = 'Scalar';

nb = length(AO.(ifam).DeviceName); 
AO.(ifam).DeviceList                     = [ones(1,nb); (1:nb)]';
AO.(ifam).ElementList                    = (1:nb)';
AO.(ifam).Status                         = ones(nb,1);

AO.(ifam).Monitor.TangoNames            = strcat(AO.(ifam).DeviceName,'/dCountsSinceReset'); 

%afin de ne pas avoir de bug
AO.(ifam).Monitor.Units                  = 'Hardware';
AO.(ifam).Monitor.Handles                = NaN;
AO.(ifam).Monitor.HWUnits                = 'µGy';
AO.(ifam).Monitor.PhysicsUnits           = 'µGy';
AO.(ifam).Monitor.HW2PhysicsParams       = 1;
AO.(ifam).Monitor.Physics2HWParams       = 1;
AO.(ifam).Position                 = (1:length(AO.(ifam).DeviceName))'*354/length(AO.(ifam).DeviceName);
% %====================
% %% Machine Parameters
% %====================
% AO.MachineParameters.FamilyName                = 'MachineParameters';
% AO.MachineParameters.FamilyType                = 'Parameter';
% AO.MachineParameters.MemberOf                  = {'Diagnostics'};
% AO.MachineParameters.Status                    = [1 1 1 1]';
% 
% AO.MachineParameters.Monitor.Mode              = Mode;
% AO.MachineParameters.Monitor.DataType          = 'Scalar';
% AO.MachineParameters.Monitor.Units             = 'Hardware';
% 
% %use spear2 process variable names
% mp={
%     'mode    '    'SPEAR:BeamStatus  '          [1 1]  1; ...
%     'energy  '    'SPEAR:Energy      '          [1 2]  2; ...
%     'current '    'SPEAR:BeamCurrAvg '          [1 3]  3; ...
%     'lifetime'    'SPEAR:BeamLifetime'          [1 4]  4; ...
%     };
% AO.MachineParameters.Monitor.HWUnits          = ' ';
% AO.MachineParameters.Monitor.PhysicsUnits     = ' ';
% 
% AO.MachineParameters.Setpoint.HWUnits         = ' ';
% AO.MachineParameters.Setpoint.PhysicsUnits    = ' ';
% 
% for ii=1:size(mp,1),
%     name  =mp(ii,1);    AO.MachineParameters.CommonNames(ii,:)            = char(name{1});
%     %     name  =mp(ii,2);    AO.MachineParameters.Monitor.ChannelNames(ii,:)   = char(name{1});
%     %     name  =mp(ii,2);    AO.MachineParameters.Setpoint.ChannelNames(ii,:)  = char(name{1});
%     val   =mp(ii,3);    AO.MachineParameters.DeviceList(ii,:)             = val{1};
%     val   =mp(ii,4);    AO.MachineParameters.ElementList(ii,:)            = val{1};
% 
%     AO.MachineParameters.Monitor.HW2PhysicsParams(ii,:)    = 1;
%     AO.MachineParameters.Monitor.Physics2HWParams(ii,:)    = 1;
%     AO.MachineParameters.Monitor.Handles(ii,1)  = NaN;
%     AO.MachineParameters.Setpoint.HW2PhysicsParams(ii,:)   = 1;
%     AO.MachineParameters.Setpoint.Physics2HWParams(ii,:)   = 1;
%     AO.MachineParameters.Setpoint.Handles(ii,1)  = NaN;
% end


%======
%% Septum
%======
% ifam=ifam+1;
% AO.Septum.FamilyName                  = 'Septum';
% AO.Septum.FamilyType                  = 'Septum';
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
% AO.Septum.Monitor.PhysicsUnits        = 'rad';
% AO.Septum.Monitor.ChannelNames        = 'BTS-B9V:Curr';
% AO.Septum.Monitor.Handles             = NaN;
%
% AO.Septum.Setpoint.Mode               = Mode;
% AO.Septum.Setpoint.DataType           = 'Scalar';
% AO.Septum.Setpoint.Units              = 'Hardware';
% AO.Septum.Setpoint.HWUnits            = 'ampere';
% AO.Septum.Setpoint.PhysicsUnits       = 'rad';
% AO.Septum.Setpoint.ChannelNames       = 'BTS-B9V:CurrSetpt';
% AO.Septum.Setpoint.Range              = [0, 249.90];
% AO.Septum.Setpoint.Tolerance          = 100.0;
% AO.Septum.Setpoint.Handles            = NaN;
%
% AO.Septum.Monitor.HW2PhysicsParams    = 1;
% AO.Septum.Monitor.Physics2HWParams    = 1;
% AO.Septum.Setpoint.HW2PhysicsParams   = 1;
% AO.Septum.Setpoint.Physics2HWParams   = 1;

% Save AO
setao(AO);

% The operational mode sets the path, filenames, and other important params
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode

waitbar(0.4,h);

setoperationalmode(OperationalMode);

waitbar(0.5,h);

%======================================================================
%======================================================================
%% Append Accelerator Toolbox information
%======================================================================
%======================================================================
disp('** Initializing Accelerator Toolbox information');

AO = getao;

ATindx = atindex(THERING);  %structure with fields containing indices

s = findspos(THERING,1:length(THERING)+1)';

%% Horizontal BPMs
% WARNING: BPM1 is the one before the injection straigth section
%          since a cell begins from begin of Straigths
% CELL1 BPM1 to BPM7
ifam = ('BPMx');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.BPM(:);
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% Vertical BPMs
ifam = ('BPMz');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.BPM(:);
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);  

%% SLOW HORIZONTAL CORRECTORS
ifam = ('HCOR');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.COR(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% SLOW VERTICAL CORRECTORS
ifam = ('VCOR');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.COR(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);  %for SPEAR 3 horizontal and vertical correctors at same s-position

%% FAST HORIZONTAL CORRECTORS
ifam = ('FHCOR');
AT.(ifam).AT.ATType  = ifam;
AT.(ifam).AT.ATIndex = ATindx.FCOR([end 1:end-1])';
AT.(ifam).Position   = s(AT.(ifam).AT.ATIndex);

%% FAST VERTICAL CORRECTORS
ifam = ('FVCOR');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.FCOR([end 1:end-1])';
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex); 

%% SKEW QUADS
ifam = ('QT');
AO.(ifam).AT.ATType  = 'SkewQuad';
AO.(ifam).AT.ATIndex = ATindx.SkewQuad(:);
AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% BENDING magnets
ifam = ('BEND');
AO.(ifam).AT.ATType  = ifam;
AO.(ifam).AT.ATIndex = ATindx.BEND(:);
%AT.(ifam).Position   = s(AT.(ifam).AT.ATIndex);
% One group of all dipoles
AO.(ifam).Position   = reshape(s(AO.(ifam).AT.ATIndex),1,32);
%AT.(ifam).AT.ATParamGroup = mkparamgroup(THERING,AT.(ifam).AT.ATIndex,'K2');


%% QUADRUPOLES
for k = 1:10,
    ifam = ['Q' num2str(k)];
    AO.(ifam).AT.ATType  = 'QUAD';
    AO.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
    AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);
end

%% SEXTUPOLES
for k = 1:10,
    ifam = ['S' num2str(k)];
    AO.(ifam).AT.ATType  = 'SEXT';
    AO.(ifam).AT.ATIndex = eval(['ATindx.' ifam '(:)']);
    AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);
    AO.(ifam).AT.ATParamGroup = mkparamgroup(THERING,AO.(ifam).AT.ATIndex,'K2');
end

% %kickeramps
% ifam = ('KickerAmp');
% AT.(ifam).AT.ATType  = 'KickerAmp';
% AT.(ifam).AT.ATIndex = ATindx.KICKER(:);
% AT.(ifam).Position= s(AT.(ifam).AT.ATIndex);
%
% %kickerdelay
% ifam = ('KickerDelay');
% AT.(ifam).AT.ATType  = 'Kicker';
% AT.(ifam).AT.ATIndex = ATindx.KICKER(:);
% AT.(ifam).Position= s(AT.(ifam).AT.ATIndex);
%
% %septum
% ifam = ('Septum');
% AT.(ifam).AT.ATType  = 'Septum';
% AT.(ifam).AT.ATIndex = ATindx.SEPTUM(:);
% AT.(ifam).Position   = s(AT.(ifam).AT.ATIndex);

%% RF Cavity
ifam = ('RF');
AO.(ifam).AT.ATType = 'RF Cavity';
AO.(ifam).AT.ATIndex = findcells(THERING,'Frequency')';
AO.(ifam).Position   = s(AO.(ifam).AT.ATIndex);

%% Machine Params
ifam = ('MachineParams');
AO.(ifam).AT.ATType       = 'MachineParams';
AO.(ifam).AT.ATName(1,:)  = 'Energy  ';
AO.(ifam).AT.ATName(2,:)  = 'current ';
AO.(ifam).AT.ATName(3,:)  = 'Lifetime';

% Save AO
setao(AO);

disp('Setting min max configuration from TANGO static database ...');

% set real min max value read from TANGO
% setrange('HCOR');
% setrange('VCOR');
% %setrange('FHCOR');
% %setrange('FVCOR');
% setrange('BEND');
% setrange('Q1');
% setrange('Q2');
% setrange('Q3');
% setrange('Q4');
% setrange('Q5');
% setrange('Q6');
% setrange('Q7');
% setrange('Q8');
% setrange('Q9');
% setrange('Q10');
% setrange('S1');
% setrange('S2');
% setrange('S3');
% setrange('S4');
% setrange('S5');
% setrange('S6');
% setrange('S7');
% setrange('S8');
% setrange('S9');
% setrange('S10');

%setrange('RF');

waitbar(0.80,h);

disp('Setting gain offset configuration  ...');

setfamilydata([0.20; 0.30; NaN],'TUNE','Golden');
setfamilydata([0.0; 0.0],'CHRO','Golden');
setfamilydata_local('BPMx');
setfamilydata_local('BPMz');
setfamilydata_local('HCOR');
setfamilydata_local('VCOR');
setfamilydata_local('FHCOR');
setfamilydata_local('FVCOR');
setfamilydata_local('Q1');
setfamilydata_local('Q2');
setfamilydata_local('Q3');
setfamilydata_local('Q4');
setfamilydata_local('Q5');
setfamilydata_local('Q6');
setfamilydata_local('Q7');
setfamilydata_local('Q8');
setfamilydata_local('Q9');
setfamilydata_local('Q10');
setfamilydata_local('S1');
setfamilydata_local('S2');
setfamilydata_local('S3');
setfamilydata_local('S4');
setfamilydata_local('S5');
setfamilydata_local('S6');
setfamilydata_local('S7');
setfamilydata_local('S8');
setfamilydata_local('S9');
setfamilydata_local('S10');
setfamilydata_local('BEND');

waitbar(0.95,h);

if iscontrolroom
    switch2online;
else
    switch2sim;
end

close(h);
% set close orbit
% fprintf('%3d %3d  %10.6f  %10.6f\n', [family2dev('BPMx'), getgolden('BPMx'), getgolden('BPMz')]');

% Golden = [
%   1   2   -0.000000   -0.000000
%   1   3   -0.000000   -0.000000
%   1   4    0.000000    0.000000
%   1   5   -0.000000   -0.000000
%   1   6   -0.000000    0.000000
%   1   7    0.000000   -0.000000
%   2   1    0.000000    0.000000
%   2   2    0.000000    0.000000
%   2   3   -0.000000   -0.000000
%   2   4    0.000000   -0.000000
%   2   5   -0.000000    0.000000
%   2   6    0.000000   -0.000000
%   2   7    0.000000   -0.000000
%   2   8    0.000000   -0.000000
%   3   1    0.000000    0.000000
%   3   2   -0.000000   -0.000000
%   3   3    0.000000    0.000000
%   3   4   -0.000000   -0.000000
%   3   5    0.000000   -0.000000
%   3   6    0.000000    0.000000
%   3   7    0.000000   -0.000000
%   3   8    0.000000    0.000000
%   4   1    0.000000   -0.000000
%   4   2    0.000000   -0.000000
%   4   3   -0.000000   -0.000000
%   4   4    0.000000    0.000000
%   4   5    0.000000    0.000000
%   4   6   -0.000000    0.000000
%   4   7   -0.000000   -0.000000
%   5   1   -0.000000    0.000000
%   5   2   -0.000000    0.000000
%   5   3    0.000000    0.000000
%   5   4    0.000000   -0.000000
%   5   5   -0.000000   -0.000000
%   5   6    0.000000    0.000000
%   5   7   -0.000000   -0.000000
%   6   1   -0.000000    0.000000
%   6   2    0.000000   -0.000000
%   6   3    0.000000   -0.000000
%   6   4   -0.000000    0.000000
%   6   5    0.000000    0.000000
%   6   6   -0.000000   -0.000000
%   6   7   -0.000000    0.000000
%   6   8    0.000000    0.000000
%   7   1   -0.000000   -0.000000
%   7   2   -0.000000   -0.000000
%   7   3   -0.000000    0.000000
%   7   4    0.000000   -0.000000
%   7   5   -0.000000   -0.000000
%   7   6    0.000000   -0.000000
%   7   7    0.000000    0.000000
%   7   8    0.000000    0.000000
%   8   1   -0.000000   -0.000000
%   8   2   -0.000000    0.000000
%   8   3    0.000000   -0.000000
%   8   4    0.000000   -0.000000
%   8   5    0.000000   -0.000000
%   8   6    0.000000   -0.000000
%   8   7   -0.000000   -0.000000
%   9   1   -0.000000   -0.000000
%   9   2   -0.000000   -0.000000
%   9   3    0.000000    0.000000
%   9   4   -0.000000    0.000000
%   9   5    0.000000   -0.000000
%   9   6    0.000000    0.000000
%   9   7   -0.000000    0.000000
%  10   1    0.000000   -0.000000
%  10   2    0.000000   -0.000000
%  10   3   -0.000000    0.000000
%  10   4   -0.000000    0.000000
%  10   5   -0.000000    0.000000
%  10   6   -0.000000   -0.000000
%  10   7    0.000000   -0.000000
%  10   8    0.000000    0.000000
%  11   1    0.000000   -0.000000
%  11   2    0.000000   -0.000000
%  11   3    0.000000    0.000000
%  11   4   -0.000000    0.000000
%  11   5   -0.000000   -0.000000
%  11   6    0.000000   -0.000000
%  11   7   -0.000000   -0.000000
%  11   8    0.000000   -0.000000
%  12   1   -0.000000    0.000000
%  12   2   -0.000000    0.000000
%  12   3    0.000000    0.000000
%  12   4    0.000000   -0.000000
%  12   5   -0.000000    0.000000
%  12   6    0.000000   -0.000000
%  12   7    0.000000    0.000000
%  13   1   -0.000000   -0.000000
%  13   2    0.000000   -0.000000
%  13   3   -0.000000    0.000000
%  13   4    0.000000    0.000000
%  13   5   -0.000000   -0.000000
%  13   6    0.000000   -0.000000
%  13   7    0.000000    0.000000
%  14   1   -0.000000    0.000000
%  14   2    0.000000   -0.000000
%  14   3   -0.000000   -0.000000
%  14   4    0.000000    0.000000
%  14   5   -0.000000    0.000000
%  14   6   -0.000000    0.000000
%  14   7   -0.000000   -0.000000
%  14   8    0.000000    0.000000
%  15   1   -0.000000    0.000000
%  15   2    0.000000    0.000000
%  15   3   -0.000000   -0.000000
%  15   4   -0.000000    0.000000
%  15   5   -0.000000   -0.000000
%  15   6    0.000000   -0.000000
%  15   7    0.000000    0.000000
%  15   8   -0.000000   -0.000000
%  16   1   -0.000000   -0.000000
%  16   2    0.000000    0.000000
%  16   3   -0.000000   -0.000000
%  16   4    0.000000    0.000000
%  16   5   -0.000000   -0.000000
%  16   6   -0.000000    0.000000
%  16   7    0.000000   -0.000000
%   1   1   -0.000000    0.000000
% ];
%  Golden = [
%   1   2   -0.016109   -0.029329
%   1   3   -0.004005    0.007886
%   1   4    0.072212    0.062367
%   1   5   -0.024518    0.055139
%   1   6   -0.064471    0.013784
%   1   7    0.013930    0.135550
%   2   1   -0.011554   -0.070312
%   2   2   -0.050394   -0.078194
%   2   3    0.032176    0.082341
%   2   4   -0.029317    0.117253
%   2   5    0.015890   -0.007759
%   2   6    0.016312    0.063036
%   2   7   -0.032808   -0.177137
%   2   8    0.039461   -0.045681
%   3   1   -0.062566   -0.018802
%   3   2   -0.006602    0.184429
%   3   3    0.018723   -0.176785
%   3   4   -0.116008   -0.105529
%   3   5    0.097402   -0.028190
%   3   6    0.045757   -0.097066
%   3   7   -0.066598   -0.175309
%   3   8   -0.007365    0.036844
%   4   1    0.019824    0.142689
%   4   2   -0.000176   -0.068519
%   4   3   -0.006800   -0.041942
%   4   4   -0.034004   -0.022842
%   4   5    0.037034    0.059478
%   4   6   -0.014433   -0.166529
%   4   7   -0.061407    0.017149
%   5   1    0.080897    0.076740
%   5   2   -0.012038    0.040356
%   5   3   -0.013179   -0.002226
%   5   4    0.069290   -0.111001
%   5   5    0.038943    0.008662
%   5   6   -0.129630    0.011481
%   5   7   -0.000920    0.036813
%   6   1    0.016272   -0.052574
%   6   2    0.031234    0.061241
%   6   3   -0.009122   -0.018313
%   6   4   -0.159022    0.006281
%   6   5    0.139226   -0.058757
%   6   6    0.100120   -0.090672
%   6   7   -0.129504   -0.062824
%   6   8    0.006805   -0.001487
%   7   1    0.006808    0.106658
%   7   2   -0.029256   -0.086426
%   7   3    0.005422    0.016194
%   7   4    0.055600    0.003513
%   7   5   -0.042632   -0.001866
%   7   6   -0.126872    0.026082
%   7   7    0.140233   -0.081977
%   7   8   -0.019330    0.079127
%   8   1   -0.012088   -0.008979
%   8   2    0.053612   -0.018187
%   8   3   -0.014107    0.028316
%   8   4   -0.157538   -0.013089
%   8   5   -0.046621   -0.070002
%   8   6    0.207227    0.065337
%   8   7   -0.054266    0.021793
%   9   1    0.017264   -0.015635
%   9   2    0.030052   -0.042293
%   9   3   -0.025084    0.007168
%   9   4   -0.020432    0.075486
%   9   5    0.110440   -0.049762
%   9   6   -0.116610   -0.012532
%   9   7   -0.011486    0.106592
%  10   1    0.024628    0.050707
%  10   2    0.021953   -0.143527
%  10   3   -0.013703   -0.001596
%  10   4   -0.049724    0.108386
%  10   5    0.030980    0.098887
%  10   6    0.108697    0.146079
%  10   7   -0.121358    0.133295
%  10   8   -0.033342   -0.219970
%  11   1    0.062153    0.036616
%  11   2    0.078471    0.011798
%  11   3   -0.032535   -0.064236
%  11   4   -0.225522    0.118926
%  11   5    0.211643    0.060435
%  11   6    0.046324    0.023765
%  11   7   -0.084590   -0.050827
%  11   8    0.003712   -0.108471
%  12   1    0.002993    0.105625
%  12   2    0.004842   -0.084366
%  12   3   -0.001208    0.108071
%  12   4   -0.083760   -0.032507
%  12   5    0.084936   -0.059238
%  12   6   -0.024508    0.018948
%  12   7   -0.029985    0.033101
%  13   1    0.043133    0.026918
%  13   2   -0.034035   -0.122866
%  13   3    0.000740    0.025621
%  13   4    0.095937    0.106642
%  13   5    0.045263    0.013359
%  13   6   -0.171956    0.045738
%  13   7    0.031641    0.052087
%  14   1   -0.027082   -0.000829
%  14   2    0.021254   -0.099073
%  14   3   -0.019560    0.017342
%  14   4   -0.004520    0.162526
%  14   5    0.005853    0.059292
%  14   6    0.008179   -0.047524
%  14   7   -0.001401   -0.102715
%  14   8   -0.055800    0.098121
%  15   1    0.074795    0.023368
%  15   2    0.038731   -0.095221
%  15   3   -0.026061    0.115497
%  15   4   -0.088833   -0.011771
%  15   5    0.084328    0.015239
%  15   6    0.037638   -0.097017
%  15   7   -0.055234   -0.009165
%  15   8    0.021390   -0.027726
%  16   1   -0.036755    0.149702
%  16   2   -0.002163   -0.181339
%  16   3    0.014132    0.013743
%  16   4   -0.133713    0.140012
%  16   5    0.094131    0.004707
%  16   6    0.016469    0.147084
%  16   7   -0.008833   -0.018775
%   1   1    0.001073   -0.109009
% Golden du 27 mars 2007 100 mA

% Golden = [
%   1   2   -0.005797   -0.017312
%   1   3    0.000919   -0.015076
%   1   4    0.016414    0.026510
%   1   5   -0.121497    0.059608
%   1   6    0.119201    0.067078
%   1   7   -0.010365    0.157920
%   2   1   -0.013197   -0.098301
%   2   2    0.027261   -0.062963
%   2   3   -0.015684    0.035225
%   2   4    0.012233    0.143302
%   2   5   -0.009376    0.059353
%   2   6   -0.071856    0.011451
%   2   7    0.063409   -0.081142
%   2   8    0.034665   -0.063435
%   3   1   -0.066037    0.002726
%   3   2   -0.000859    0.136815
%   3   3    0.005278   -0.203492
%   3   4    0.012004   -0.012404
%   3   5   -0.019908    0.055614
%   3   6   -0.002221   -0.089575
%   3   7   -0.001831   -0.125075
%   3   8    0.002154    0.032087
%   4   1   -0.003133    0.071877
%   4   2    0.014281   -0.002156
%   4   3   -0.008564   -0.015328
%   4   4   -0.006155   -0.087721
%   4   5   -0.072595   -0.035561
%   4   6    0.089426   -0.031385
%   4   7   -0.051357    0.030795
%   5   1    0.052918    0.072909
%   5   2   -0.030896   -0.097133
%   5   3    0.008768    0.026373
%   5   4    0.033223    0.053668
%   5   5   -0.007694    0.023427
%   5   6   -0.029986    0.035607
%   5   7   -0.002398    0.014364
%   6   1    0.005333   -0.030141
%   6   2    0.019401    0.023267
%   6   3   -0.013229   -0.071641
%   6   4   -0.038290    0.057127
%   6   5    0.044439    0.032870
%   6   6   -0.033921   -0.006965
%   6   7    0.034656    0.009146
%   6   8   -0.020039   -0.026317
%   7   1    0.021750    0.100296
%   7   2   -0.044471   -0.118606
%   7   3    0.023370   -0.006066
%   7   4   -0.010557    0.077161
%   7   5    0.023680    0.111695
%   7   6   -0.116233    0.089491
%   7   7    0.124305   -0.080779
%   7   8   -0.015208    0.036310
%   8   1   -0.010741   -0.009796
%   8   2    0.020530   -0.024978
%   8   3   -0.008444    0.043667
%   8   4   -0.025326   -0.012376
%   8   5   -0.035473    0.007320
%   8   6    0.065758    0.055126
%   8   7   -0.036453    0.023429
%   9   1    0.029467   -0.053588
%   9   2    0.001633   -0.006234
%   9   3    0.005615    0.007891
%   9   4   -0.062090   -0.002766
%   9   5    0.001910    0.010628
%   9   6    0.058936    0.007838
%   9   7   -0.042798    0.072547
%  10   1    0.045262    0.073408
%  10   2    0.028056   -0.154367
%  10   3   -0.012088   -0.011784
%  10   4   -0.073822    0.088175
%  10   5    0.057591    0.178638
%  10   6    0.064805    0.124674
%  10   7   -0.081578    0.138036
%  10   8   -0.024542   -0.172935
%  11   1    0.046510    0.017614
%  11   2    0.062073    0.000009
%  11   3   -0.037480   -0.060397
%  11   4   -0.041096    0.146472
%  11   5    0.032956    0.081438
%  11   6    0.018984    0.048677
%  11   7   -0.033127   -0.079176
%  11   8   -0.010214   -0.112762
%  12   1    0.024785    0.113373
%  12   2   -0.004146   -0.072407
%  12   3    0.005921    0.070591
%  12   4   -0.068544   -0.015913
%  12   5    0.069606   -0.052789
%  12   6   -0.014413    0.044067
%  12   7   -0.033711    0.029776
%  13   1    0.049872    0.020370
%  13   2   -0.026395   -0.149377
%  13   3    0.003372    0.039093
%  13   4    0.062395    0.114775
%  13   5   -0.023654    0.034983
%  13   6   -0.046041    0.074071
%  13   7    0.015033    0.025198
%  14   1   -0.017785    0.007114
%  14   2    0.014314   -0.103821
%  14   3   -0.007818    0.005819
%  14   4   -0.046975    0.152992
%  14   5    0.040307    0.106990
%  14   6    0.024887    0.000457
%  14   7   -0.030497   -0.099698
%  14   8   -0.015308    0.088554
%  15   1    0.022300    0.006944
%  15   2    0.023296   -0.082432
%  15   3   -0.012034    0.129612
%  15   4   -0.076630    0.008548
%  15   5    0.074119   -0.030656
%  15   6    0.014081   -0.082962
%  15   7   -0.026948    0.012078
%  15   8    0.013663   -0.070121
%  16   1   -0.026518    0.147481
%  16   2    0.002385   -0.127930
%  16   3    0.006044   -0.040092
%  16   4   -0.066371    0.131605
%  16   5    0.044381    0.027604
%  16   6    0.013263    0.111982
%  16   7   -0.018533   -0.015504
%   1   1    0.014970   -0.090054
%  ];

% Golden ci dessous orbite su 23 avril 2007
Golden = [
  1   2   -0.006983   -0.027905
  1   3   -0.003142   -0.015461
  1   4    0.016421    0.040723
  1   5   -0.114860    0.070363
  1   6    0.114470    0.077863
  1   7   -0.017136    0.142959
  2   1   -0.002380   -0.119856
  2   2    0.020268   -0.037834
  2   3   -0.016944    0.036558
  2   4    0.004818    0.125072
  2   5    0.003800    0.055701
  2   6   -0.067714   -0.020920
  2   7    0.064931   -0.124026
  2   8    0.030373   -0.049196
  3   1   -0.067756    0.042688
  3   2    0.005212    0.106980
  3   3   -0.000994   -0.206161
  3   4    0.008764   -0.040780
  3   5   -0.012362    0.065270
  3   6    0.008649   -0.071649
  3   7   -0.010105   -0.116539
  3   8    0.004831    0.033727
  4   1   -0.012951    0.069927
  4   2    0.018719   -0.016921
  4   3   -0.013218   -0.023794
  4   4    0.025955   -0.031911
  4   5   -0.087577   -0.055929
  4   6    0.073246   -0.043108
  4   7   -0.051022    0.013304
  5   1    0.054389    0.066226
  5   2   -0.030216   -0.082380
  5   3    0.014207    0.015782
  5   4    0.018652    0.040588
  5   5    0.007467    0.018579
  5   6   -0.035390    0.023740
  5   7   -0.011514    0.007948
  6   1    0.021412   -0.013609
  6   2    0.019742    0.016051
  6   3   -0.014610   -0.070518
  6   4   -0.012430    0.038418
  6   5    0.011704    0.077612
  6   6   -0.021676   -0.055172
  6   7    0.019028   -0.064592
  6   8   -0.017033   -0.085768
  7   1    0.027233    0.110291
  7   2   -0.044686   -0.035923
  7   3    0.025766   -0.035378
  7   4   -0.018853   -0.022782
  7   5    0.026612    0.040724
  7   6   -0.119231    0.069974
  7   7    0.122805   -0.064904
  7   8   -0.016395    0.040026
  8   1   -0.002400   -0.010129
  8   2    0.022870   -0.036095
  8   3   -0.014112    0.035739
  8   4   -0.020547    0.006218
  8   5   -0.043064    0.018189
  8   6    0.071954    0.071437
  8   7   -0.034260    0.040567
  9   1    0.028537   -0.064069
  9   2   -0.010896   -0.014936
  9   3    0.012216   -0.004277
  9   4   -0.068464    0.027311
  9   5    0.009988    0.010894
  9   6    0.063530    0.017090
  9   7   -0.053769    0.063549
 10   1    0.062576    0.054632
 10   2    0.017741   -0.146863
 10   3   -0.010410   -0.007074
 10   4   -0.074049    0.078694
 10   5    0.064659    0.188452
 10   6    0.069572    0.152665
 10   7   -0.079175    0.118005
 10   8   -0.029903   -0.160250
 11   1    0.050193    0.037427
 11   2    0.055632   -0.042655
 11   3   -0.035655   -0.054405
 11   4   -0.036151    0.149242
 11   5    0.035143    0.116151
 11   6    0.028927    0.086803
 11   7   -0.035726   -0.064940
 11   8   -0.011351   -0.092493
 12   1    0.021298    0.086223
 12   2    0.018891   -0.081681
 12   3   -0.006108    0.093825
 12   4   -0.073790   -0.017286
 12   5    0.077053   -0.049686
 12   6   -0.015203    0.047587
 12   7   -0.030149    0.022547
 13   1    0.046047    0.008691
 13   2   -0.022754   -0.168597
 13   3    0.003678    0.050055
 13   4    0.056820    0.126502
 13   5   -0.025694    0.041400
 13   6   -0.039813    0.096348
 13   7    0.014860    0.042901
 14   1   -0.018464   -0.017584
 14   2    0.025080   -0.093626
 14   3   -0.012440    0.002405
 14   4   -0.057945    0.140560
 14   5    0.051345    0.101783
 14   6    0.024152    0.011598
 14   7   -0.033475   -0.116291
 14   8   -0.001281    0.101211
 15   1   -0.002106    0.013078
 15   2    0.019324   -0.106988
 15   3   -0.007300    0.136143
 15   4   -0.070168    0.021354
 15   5    0.067422   -0.004631
 15   6    0.013393   -0.080552
 15   7   -0.025907    0.012427
 15   8    0.006644   -0.071089
 16   1   -0.015333    0.132740
 16   2    0.007727   -0.131224
 16   3    0.002030   -0.023141
 16   4   -0.067771    0.132597
 16   5    0.044049    0.024878
 16   6    0.014250    0.105506
 16   7   -0.017992   -0.006555
  1   1    0.017883   -0.087854
  ];


setfamilydata(Golden(:,3),'BPMx','Golden',Golden(:,1:2));
setfamilydata(Golden(:,4),'BPMz','Golden',Golden(:,1:2));

function setfamilydata_local(Family)
% set all data in one command

if ismemberof(Family,'QUAD') || ismemberof(Family,'COR') || ...
        ismemberof(Family,'COR') || ismemberof(Family,'SEXT') || ...
        ismemberof(Family,'BPM') || ismemberof(Family,'BEND')
    setfamilydata(1,Family,'Gain');
    setfamilydata(0,Family,'Offset');
    setfamilydata(0,Family,'Coupling');
end

if ismemberof(Family,'BPM')
    setfamilydata(0.001,Family,'Sigma');
    setfamilydata(0.0,Family,'Golden');
    setfamilydata(measdisp(Family,'struct','model'),Family,'Dispersion'); % needed for orbit correction w/ RF
end

% Order fields for all families
AO = getao;
Familylist = getfamilylist;
for k = 1:length(Familylist),
    FamilyName = deblank(Familylist(k,:));
    AO.(FamilyName) = orderfields(AO.(FamilyName));
    FieldNamelist = fieldnames(AO.(FamilyName));
    for k1 = 1:length(FieldNamelist);
        FieldName = FieldNamelist{k1};
        if isstruct((AO.(FamilyName).(FieldName)))
            AO.(FamilyName).(FieldName) = orderfields(AO.(FamilyName).(FieldName));
        end
    end
end
setao(AO)

