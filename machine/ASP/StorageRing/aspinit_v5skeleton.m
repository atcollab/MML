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
%   Changed the BPM PVs to ...:SA_HPOS_MONITOR and ...:SA_VPOS_MONITOR
%
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

%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=98;
AO.BPMx.FamilyName               = 'BPMx'; dispobject(AO,AO.BPMx.FamilyName);
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy'; dispobject(AO,AO.BPMy.FamilyName);
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name             x-chname              xstat y-name               y-chname           ystat DevList Elem
bpm={
% INSERT BPM HERE
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
% % Definition above for horizontal. Replicate for vertical.
% AO.BPMy.Sum = AO.BPMx.Sum;
% AO.BPMy.Q   = AO.BPMx.Q;



%=============================================
% First Turn BPM data from Libera
%=============================================
ntbpm=98;
AO.FTx.FamilyName               = 'FTx'; dispobject(AO,AO.FTx.FamilyName);
AO.FTx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.FTx.Monitor.Mode             = Mode;
AO.FTx.Monitor.DataType         = 'Scalar';
AO.FTx.Monitor.Units            = 'Hardware';
AO.FTx.Monitor.HWUnits          = 'mm';
AO.FTx.Monitor.PhysicsUnits     = 'meter';

AO.FTy.FamilyName               = 'FTy'; dispobject(AO,AO.FTy.FamilyName);
AO.FTy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.FTy.Monitor.Mode             = Mode;
AO.FTy.Monitor.DataType         = 'Scalar';
AO.FTy.Monitor.Units            = 'Hardware';
AO.FTy.Monitor.HWUnits          = 'mm';
AO.FTy.Monitor.PhysicsUnits     = 'meter';

% x-name             x-chname              xstat y-name               y-chname           ystat DevList Elem
bpm={
% INSERT FT HERE
};

%Load fields from data block
for ii=1:size(bpm,1)
name=bpm{ii,1};      AO.FTx.CommonNames(ii,:)         = name;
name=bpm{ii,2};      AO.FTx.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,3};      AO.FTx.Status(ii,:)              = val;  
name=bpm{ii,4};      AO.FTy.CommonNames(ii,:)         = name;
name=bpm{ii,5};      AO.FTy.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,6};      AO.FTy.Status(ii,:)              = val;  
val =bpm{ii,7};      AO.FTx.DeviceList(ii,:)          = val;   
                     AO.FTy.DeviceList(ii,:)          = val;
val =bpm{ii,8};      AO.FTx.ElementList(ii,:)         = val;   
                     AO.FTy.ElementList(ii,:)         = val;
                     AO.FTx.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.FTx.Monitor.Physics2HWParams(ii,:) = 1000;
                     AO.FTy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.FTy.Monitor.Physics2HWParams(ii,:) = 1000;
end
AO.FTx.Status = AO.BPMx.Status;
AO.FTy.Status = AO.BPMy.Status;

% % Get sum value from button. Don't need handles and PV namelist as
% % parameters are the same as the 'monitor' subcategory.
AO.FTx.Offset.Mode               = 'Special';
AO.FTx.Offset.Units              = 'Hardware';
AO.FTx.Offset.DataType           = 'Scalar';
AO.FTx.Offset.SpecialFunction    = 'getftoffset';
AO.FTx.Offset.SpecialFunctionSet = 'setftoffset';
AO.FTx.Offset.HWUnits          = '32ns samples';
AO.FTx.Offset.PhysicsUnits     = '32ns samples';
AO.FTx.Offset.HW2PhysicsParams = 1;
AO.FTx.Offset.Physics2HWParams = 1;

AO.FTx.Length.Mode               = 'Special';
AO.FTx.Length.Units              = 'Hardware';
AO.FTx.Length.DataType           = 'Scalar';
AO.FTx.Length.SpecialFunction    = 'getftlength';
AO.FTx.Length.SpecialFunctionSet = 'setftlength';
AO.FTx.Length.HWUnits          = '32ns samples';
AO.FTx.Length.PhysicsUnits     = '32ns samples';
AO.FTx.Length.HW2PhysicsParams = 1;
AO.FTx.Length.Physics2HWParams = 1;

AO.FTx.Maxadc.Mode               = 'Special';
AO.FTx.Maxadc.Units              = 'Hardware';
AO.FTx.Maxadc.DataType           = 'Scalar';
AO.FTx.Maxadc.SpecialFunction    = 'getftmaxadc';
AO.FTx.Maxadc.HWUnits          = 'ADC counts';
AO.FTx.Maxadc.PhysicsUnits     = 'ADC counts';
AO.FTx.Maxadc.HW2PhysicsParams = 1;
AO.FTx.Maxadc.Physics2HWParams = 1;

% AO.FTx.Sum.Mode               = 'Special';
% AO.FTx.Sum.Units              = 'Hardware';
% AO.FTx.Sum.DataType           = 'Scalar';
% AO.FTx.Sum.SpecialFunction    = 'getftsum';
% AO.FTx.Sum.HWUnits          = 'ADC counts';
% AO.FTx.Sum.PhysicsUnits     = 'ADC counts';
% AO.FTx.Sum.HW2PhysicsParams = 1;
% AO.FTx.Sum.Physics2HWParams = 1;


AO.FTsum.FamilyName               = 'FTsum'; dispobject(AO,AO.FTsum.FamilyName);
AO.FTsum.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.FTsum.Monitor.Mode               = 'Special';
AO.FTsum.Monitor.Units              = 'Hardware';
AO.FTsum.Monitor.DataType           = 'Scalar';
AO.FTsum.Monitor.SpecialFunction    = 'getftsum';
AO.FTsum.Monitor.HWUnits          = 'ADC counts';
AO.FTsum.Monitor.PhysicsUnits     = 'ADC counts';
AO.FTsum.Monitor.HW2PhysicsParams = 1;
AO.FTsum.Monitor.Physics2HWParams = 1;


%===========================================================
% Corrector data: status field designates if corrector in use
% ASP corrector coils wound into sextupoles. Not dynamic correctors.
%===========================================================

AO.HCM.FamilyName               = 'HCM'; dispobject(AO,AO.HCM.FamilyName);
AO.HCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};

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
% INSERT HCM HERE
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
% y-common          y-monitor                 y-setpoint         stat  devlist elem
cor={
% INSERT VCM HERE
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
% INSERT BEND HERE
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

AO.BEND.Setpoint.Range(ii,:)        = [0 500];
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
% INSERT QFA HERE
};

for ii=1:size(qfa,1)
name=qfa{ii,1};      AO.QFA.CommonNames(ii,:)           = name;            
name=qfa{ii,2};      AO.QFA.Monitor.ChannelNames(ii,:)  = name;
name=qfa{ii,3};      AO.QFA.Setpoint.ChannelNames(ii,:) = name;     
val =qfa{ii,4};      AO.QFA.Status(ii,1)                = val;
val =qfa{ii,5};      AO.QFA.DeviceList(ii,:)            = val;
val =qfa{ii,6};      AO.QFA.ElementList(ii,1)           = val;
val =qfa{ii,7};      % This is the scale factor
AO.QFA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QFA.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.QFA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.QFA.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.QFA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QFA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.QFA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.QFA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qfa{ii,8};     AO.QFA.Setpoint.Tolerance(ii,1)    = val;

AO.QFA.Setpoint.Range(ii,:)        = [0 180];
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
% INSERT QDA HERE
};   
 
for ii=1:size(qda,1)
name=qda{ii,1};      AO.QDA.CommonNames(ii,:)           = name;            
name=qda{ii,2};      AO.QDA.Monitor.ChannelNames(ii,:)  = name;
name=qda{ii,3};      AO.QDA.Setpoint.ChannelNames(ii,:) = name;     
val =qda{ii,4};      AO.QDA.Status(ii,1)                = val;
val =qda{ii,5};      AO.QDA.DeviceList(ii,:)            = val;
val =qda{ii,6};      AO.QDA.ElementList(ii,1)           = val;
val =qda{ii,7};      % This is the scale factor
AO.QDA.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QDA.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.QDA.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.QDA.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.QDA.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QDA.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.QDA.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.QDA.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =qda{ii,8};      AO.QDA.Setpoint.Tolerance(ii,1)   = val;

AO.QDA.Setpoint.Range(ii,:)        = [0 100];
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
% INSERT QFB HERE
};
 
for ii=1:size(qfb,1)
name=qfb{ii,1};      AO.QFB.CommonNames(ii,:)           = name;            
name=qfb{ii,2};      AO.QFB.Monitor.ChannelNames(ii,:)  = name;
name=qfb{ii,3};      AO.QFB.Setpoint.ChannelNames(ii,:) = name;     
val =qfb{ii,4};      AO.QFB.Status(ii,1)                = val;
val =qfb{ii,5};      AO.QFB.DeviceList(ii,:)            = val;
val =qfb{ii,6};      AO.QFB.ElementList(ii,1)           = val;
val =qfb{ii,7};      % This is the scale factor
AO.QFB.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.QFB.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
AO.QFB.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.QFB.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
AO.QFB.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.QFB.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO.QFB.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.QFB.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =qfb{ii,8};     AO.QFB.Setpoint.Tolerance(ii,1)     = val;

AO.QFB.Setpoint.Range(ii,:)        = [0 180];
end


%===============
%Sextupole data
%===============
% *** SFA ***
AO.SFA.FamilyName                = 'SFA'; dispobject(AO,AO.SFA.FamilyName);
AO.SFA.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
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
% INSERT SFA HERE
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

AO.SFA.Setpoint.Range(ii,:)        = [0 140];
end



% *** SDA ***
AO.SDA.FamilyName                = 'SDA'; dispobject(AO,AO.SDA.FamilyName);
AO.SDA.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
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
% INSERT SDA HERE
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

AO.SDA.Setpoint.Range(ii,:)        = [0 140];
end


% *** SDB ***
AO.SDB.FamilyName                = 'SDB'; dispobject(AO,AO.SDB.FamilyName);
AO.SDB.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
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
% INSERT SDB HERE
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

AO.SDB.Setpoint.Range(ii,:)       = [0 140];
end



% *** SFB ***
AO.SFB.FamilyName                = 'SFB'; dispobject(AO,AO.SFB.FamilyName);
AO.SFB.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector';};
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
% INSERT SFB HERE
};

for ii=1:size(sfb,1)
name=sfb{ii,1};     AO.SFB.CommonNames(ii,:)          = name;            
name=sfb{ii,2};     AO.SFB.Monitor.ChannelNames(ii,:) = name; 
name=sfb{ii,3};     AO.SFB.Setpoint.ChannelNames(ii,:)= name;     
val =sfb{ii,4};     AO.SFB.Status(ii,1)               = val;
val =sfb{ii,5};     AO.SFB.DeviceList(ii,:)           = val;
val =sfb{ii,6};     AO.SFB.ElementLsist(ii,1)         = val;
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

AO.SFB.Setpoint.Range(ii,:)       = val;
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
% INSERT SKQ HERE
};

for ii=1:size(sq,1)
name=sq{ii,1};     AO.SKQ.CommonNames(ii,:)           = name;            
name=sq{ii,2};     AO.SKQ.Monitor.ChannelNames(ii,:)  = name;
name=sq{ii,3};     AO.SKQ.Setpoint.ChannelNames(ii,:) = name;     
val =sq{ii,4};     AO.SKQ.Status(ii,1)                = val;
val =sq{ii,5};     AO.SKQ.DeviceList(ii,:)            = val;
val =sq{ii,6};     AO.SKQ.ElementList(ii,1)           = val;
val =sq{ii,7};     AO.SKQ.Setpoint.Tolerance(ii,1)    = val;
AO.SKQ.Monitor.HW2PhysicsParams(ii,:)              = HW2PhysicsParams;
AO.SKQ.Setpoint.HW2PhysicsParams(ii,:)             = HW2PhysicsParams;
AO.SKQ.Monitor.Physics2HWParams(ii,:)              = Physics2HWParams;
AO.SKQ.Setpoint.Physics2HWParams(ii,:)             = Physics2HWParams;

AO.SKQ.Setpoint.Range(ii,:)        = [-5 +5];
end


%===============
%Kicker data
%===============
AO.KICK.FamilyName                     = 'KICK'; dispobject(AO,AO.KICK.FamilyName);
AO.KICK.MemberOf                       = {'Injection','MachineConfig'};

AO.KICK.Monitor.Mode                   = Mode;
AO.KICK.Monitor.DataType               = 'Scalar';
AO.KICK.Monitor.Units                  = 'Hardware';
AO.KICK.Monitor.HWUnits                = 'kVolts';           
AO.KICK.Monitor.PhysicsUnits           = 'mradian';

AO.KICK.Setpoint.Mode                  = Mode;
AO.KICK.Setpoint.DataType              = 'Scalar';
AO.KICK.Setpoint.Units                 = 'Hardware';
AO.KICK.Setpoint.HWUnits               = 'kVolts';           
AO.KICK.Setpoint.PhysicsUnits          = 'mradian';

hw2physics_conversionfactor = 1;

%common        monitor                  setpoint                stat  devlist elem  tol
kickeramp={ 
% INSERT KICKERS HERE
};

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO.KICK.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO.KICK.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO.KICK.Setpoint.ChannelNames(ii,:)= name;     
val =kickeramp{ii,4};     AO.KICK.Status(ii,1)               = val;
val =kickeramp{ii,5};     AO.KICK.DeviceList(ii,:)           = val;
val =kickeramp{ii,6};     AO.KICK.ElementList(ii,1)          = val;
val =kickeramp{ii,7};     AO.KICK.Setpoint.Tolerance(ii,1)   = val;

AO.KICK.Setpoint.Range(ii,:)       = [0 3];

if ii==1||ii==4
    AO.KICK.Monitor.HW2PhysicsParams = -hw2physics_conversionfactor;
    AO.KICK.Monitor.Physics2HWParams = -1/hw2physics_conversionfactor;
    AO.KICK.Setpoint.HW2PhysicsParams = -hw2physics_conversionfactor;
    AO.KICK.Setpoint.Physics2HWParams = -1/hw2physics_conversionfactor;
else
    AO.KICK.Monitor.HW2PhysicsParams = hw2physics_conversionfactor;
    AO.KICK.Monitor.Physics2HWParams = 1/hw2physics_conversionfactor;
    AO.KICK.Setpoint.HW2PhysicsParams = hw2physics_conversionfactor;
    AO.KICK.Setpoint.Physics2HWParams = 1/hw2physics_conversionfactor;
end
end

% *** KICK Delay ***
% AO.KICK.Delay
% >> removed >> see previous versions if info needed


%============
%RF System
%============
AO.RF.FamilyName                  = 'RF'; dispobject(AO,AO.RF.FamilyName);
AO.RF.MemberOf                    = {'MachineConfig'; 'RF'; 'RFSystem'};

if OperationalMode == 3
%-------------------------------- 4 cavity Case
%common      stat  devlist    elem   
rfcommon={ 
'RF1   '	 1	   [6,1]       1		; ...
'RF2   '	 1	   [6,2]       2		; ...
'RF3   '	 1	   [7,1]       3		; ...
'RF4   '	 1	   [7,2]       4	    ; ...
  };

%FreqMon             FreqSetpoint      HW2PhysicsParams  Physics2HWParams Range    Tolerance 
rffreq={ 
'ASP:RFFreq1 '	'ASP:RFFreqSetpt1'       1e+6             1e-6        [0 2500]  100.0; ...
'ASP:RFFreq2 '	'ASP:RFFreqSetpt2'       1e+6             1e-6        [0 2500]  100.0; ...
'ASP:RFFreq3 '	'ASP:RFFreqSetpt3'       1e+6             1e-6        [0 2500]  100.0; ...
'ASP:RFFreq4 '	'ASP:RFFreqSetpt4'       1e+6             1e-6        [0 2500]  100.0; ...
  };

%      PhaseCtrl           PhaseMon       HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfphase={ 
'SRF1:STN:PHASE'	'SRF1:STN:PHASE:CALC'       1             1          [-200 200]     inf   ; ...
'SRF2:STN:PHASE'	'SRF2:STN:PHASE:CALC'       1             1          [-200 200]     inf   ; ...
'SRF3:STN:PHASE'	'SRF3:STN:PHASE:CALC'       1             1          [-200 200]     inf   ; ...
'SRF4:STN:PHASE'	'SRF4:STN:PHASE:CALC'       1             1          [-200 200]     inf   ; ...
  };

%   VoltCtrl           VoltMon       HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfvolt={ 
'SRF1:STN:VOLT:CTRL '	'SRF1:STN:VOLT'       1             1      [-inf inf]     inf   ; ...
'SRF2:STN:VOLT:CTRL '	'SRF2:STN:VOLT'       1             1      [-inf inf]     inf   ; ...
'SRF3:STN:VOLT:CTRL '	'SRF3:STN:VOLT'       1             1      [-inf inf]     inf   ; ...
'SRF4:STN:VOLT:CTRL '	'SRF4:STN:VOLT'       1             1      [-inf inf]     inf   ; ...
  };
%               PowerCtrl           PowerMon                 Klystronpower     HW2PhysicsParams Physics2HWParams Range    Tolerance 
rfpower={ 
'SRF1:KLYSDRIVFRWD:POWER:ON '	'SRF1:KLYSDRIVFRWD:POWER'   'SRF1:KLYSOUTFRWD:POWER'    1             1      [-inf inf]     inf   ; ...
'SRF2:KLYSDRIVFRWD:POWER:ON '	'SRF2:KLYSDRIVFRWD:POWER'   'SRF2:KLYSOUTFRWD:POWER'    1             1      [-inf inf]     inf   ; ...
'SRF3:KLYSDRIVFRWD:POWER:ON '	'SRF3:KLYSDRIVFRWD:POWER'   'SRF3:KLYSOUTFRWD:POWER'    1             1      [-inf inf]     inf   ; ...
'SRF4:KLYSDRIVFRWD:POWER:ON '	'SRF4:KLYSDRIVFRWD:POWER'   'SRF4:KLYSOUTFRWD:POWER'    1             1      [-inf inf]     inf   ; ...
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


for ii=1:size(rfvolt,1)
name=rfvolt{ii,1};     AO.RF.VoltageCtrl.ChannelNames(ii,:)     = name;
name=rfvolt{ii,2};     AO.RF.Voltage.ChannelNames(ii,:)         = name;
val =rfvolt{ii,3};     AO.RF.VoltageCtrl.HW2PhysicsParams(ii,1) = val;
                       AO.RF.Voltage.HW2PhysicsParams(ii,1)     = val;
val =rfvolt{ii,4};     AO.RF.VoltageCtrl.Physics2HWParams(ii,1) = val;
                       AO.RF.Voltage.Physics2HWParams(ii,1)     = val;                       
val =rfvolt{ii,5};     AO.RF.VoltageCtrl.Range(ii,:)            = val;
                       AO.RF.Voltage.Range(ii,:)                = val;
val =rfvolt{ii,6};     AO.RF.VoltageCtrl.Tolerance(ii,1)        = val;
                       AO.RF.Voltage.Tolerance(ii,1)            = val;
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
AO.RF.Monitor.HWUnits             = 'MHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';
%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';

%Voltage control
AO.RF.VoltageCtrl.Mode               = Mode;
AO.RF.VoltageCtrl.DataType           = 'Scalar';
AO.RF.VoltageCtrl.Units              = 'Hardware';
AO.RF.VoltageCtrl.HWUnits            = 'Volts';           
AO.RF.VoltageCtrl.PhysicsUnits       = 'Volts';

%Voltage monitor
AO.RF.Voltage.Mode               = Mode;
AO.RF.Voltage.DataType           = 'Scalar';
AO.RF.Voltage.Units              = 'Hardware';
AO.RF.Voltage.HWUnits            = 'Volts';           
AO.RF.Voltage.PhysicsUnits       = 'Volts';

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
AO.RF.Power.HWUnits            = 'MWatts';           
AO.RF.Power.PhysicsUnits       = 'MWatts';

%Klystron Forward Power
AO.RF.KlysPower.Mode               = Mode;
AO.RF.KlysPower.DataType           = 'Scalar';
AO.RF.KlysPower.Units              = 'Hardware';
AO.RF.KlysPower.HWUnits            = 'MWatts';           
AO.RF.KlysPower.PhysicsUnits       = 'MWatts';

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


else
%------------------------------------- 1 Cavity Case
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
AO.RF.Monitor.ChannelNames        = 'ASP:RFFreqSetpt';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = 'ASP:RFFreqSetpt';     
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
end



%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE'; dispobject(AO,AO.TUNE.FamilyName);
AO.TUNE.MemberOf    = {'Tune'; 'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';

AO.TUNE.Monitor.Mode                   = Mode; 
AO.TUNE.Monitor.DataType               = 'Vector';
AO.TUNE.Monitor.DataTypeIndex          = [1 2 3]';
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
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
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', .15e-3 / 3, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', .15e-3 / 3, AO.VCM.DeviceList);

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
AO.FTx.Position  = findspos(THERING, AO.FTx.AT.ATIndex(:,1))';
AO.FTy.Position  = findspos(THERING, AO.FTy.AT.ATIndex(:,1))';
AO.HCM.Position  = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';
AO.VCM.Position  = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
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