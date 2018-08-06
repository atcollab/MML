function setoperationalmode(ModeNumber)

% Check if the AO exists
checkforao;

% MODES
ModeCell = { ...
    '150 MeV - M1', ...
    '150 MeV - M2', ...
    '150 MeV - M3', ...
    '150 MeV - M4', ...
    '150 MeV - M5', ...
    '150 MeV - M6', ...
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    [ModeNumber, OKFlag] = listdlg('Name','SIRIUS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end

if (ModeNumber == 1)
    set_operationalmode_mode1;
elseif (ModeNumber == 2)
    set_operationalmode_mode2;
elseif (ModeNumber == 3)
    set_operationalmode_mode3;
elseif (ModeNumber == 4)
    set_operationalmode_mode4;
elseif (ModeNumber == 5)
    set_operationalmode_mode5;
elseif (ModeNumber == 6)
    set_operationalmode_mode6;
else
    error('Operational mode unknown');
end

% Set the AD directory path
AD = getad;
setmmldirectories(AD.Machine, AD.SubMachine, AD.ModeName, AD.OpsFileExtension);
% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% 2015-10-23 Luana
if AD.SetMultipolesErrors
    sirius_init_multipoles_errors;
end
sirius_set_delays('AT');
sirius_li_settwissdata(AD.ModeName);

% Set the model energy
setenergymodel(AD.Energy);
% Cavity and radiation
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n');


try
    % I typically place to store the calibration LOCO file in the StorageRingOpsData directory
    %LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_User'];
    setlocodata('Nominal');
    %setlocodata('SetGains',   LOCOFile);
    %setlocodata('SetModel',   LOCOFile);
    %setlocodata('LOCO2Model', LOCOFile);
catch
    fprintf('   Problem with setting the LOCO calibration.\n');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
%atsummary;

function set_operationalmode_mode1

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';      % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M1';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M1';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.01; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode2

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';      % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M2';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M2';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.010; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode3

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';         % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M3';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M3';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.010; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode4

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';         % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M4';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M4';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.010; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode5

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';         % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M5';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M5';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.010; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode6

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';         % Will already be defined if setpathmml was used
AD.SubMachine          = 'LI.V01.01';         % Will already be defined if setpathmml was used
AD.MachineType         = 'TransportLine';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M6';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M6';
AD.OpsFileExtension    = '';

THERING = sirius_li_lattice(AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_li_lattice';
AD.BeamCurrent         = 0.010; % [A]
AD.Coupling            = 0.50;

% 2015-10-01 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;
