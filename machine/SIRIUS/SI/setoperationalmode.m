function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%
% History
%
% 2012-08-29 Ximenes



% Check if the AO exists
checkforao;

% MODES
ModeCell = { ...
    '3 GeV - S05.01 (default)', ...
    '3 GeV - S10', ...
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
    set_operationalmode_s05_01;
elseif (ModeNumber == 2)
    set_operationalmode_s10;
else
    error('Operational mode unknown');
end

% Set the AD directory path
AD = getad;
setmmldirectories(fullfile('SIRIUS',AD.Machine), AD.SubMachine, AD.ModeName, AD.OpsFileExtension);
% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;

% 2015-09-18 Luana
sirius_set_sextupole_fields;

if AD.SetMultipolesErrors
    sirius_init_multipoles_errors;
end

sirius_set_delays('AT')

% Set the model energy
setenergymodel(AD.Energy);
% Cavity and radiation
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n');




%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add LOCO Parameters to AO and AT-Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%  'SetGains'   - Set gains/coupling from a LOCO file.
%  'SetModel'   - Set the model from a LOCO file.  But it only changes
%                 the part of the model that does not get corrected
%                 in 'Symmetrize' (also does a SetGains).
%  'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
%                 This uses the LOCO AT model!!! And sets all lattice
%                 machines fit in the LOCO run to the model.
%
%   Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
%              use 'LOCO2Model' if the LOCO run was made after the final setup.  Of couse,
%              setlocodata must be written properly for all this to work correctly.

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
%ats = atsummary;
%setappdata(0, 'ATSUMMARY', ats);

function set_operationalmode_s10

global THERING;

AD = getad;
AD.Machine             = 'SI.V22.02';   % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.MachineType         = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'V22.02_S10.01';
AD.Energy              = 3.0;
AD.InjectionEnergy     = 3.0;
AD.ModeName            = 'S10';
AD.ModeVersion         = '01';
AD.OpsFileExtension    = '';

sirius_si_lattice(AD.Energy, AD.ModeName, AD.ModeVersion);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 864;
AD.DeltaRFDisp         = 0.001; % This has to be in Hardware Units 
AD.DeltaRFChro         = linspace(-500,500,11)*1e-6; % This has to be in Hardware Units 

AD.ATModel             = 'sirius_si_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.BeamCurrent         = 0.500; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.010;
AD.OpsData.PrsProfFile = 'sirius_si_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

% 2015-09-18 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;


function set_operationalmode_s05_01

global THERING;

AD = getad;
AD.Machine             = 'SI.V22.02';   % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.MachineType         = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'V22.02_S05.01';
AD.Energy              = 3.0;
AD.InjectionEnergy     = 3.0;
AD.ModeName            = 'S05';
AD.ModeVersion         = '01';
AD.OpsFileExtension    = '';

sirius_si_lattice(AD.Energy, AD.ModeName, AD.ModeVersion);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 864;
AD.DeltaRFDisp         = 0.001; % This has to be in Hardware Units 
AD.DeltaRFChro         = linspace(-500,500,11)*1e-6; % This has to be in Hardware Units 

AD.ATModel             = 'sirius_si_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.BeamCurrent         = 0.500; % [sA]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.010;
AD.OpsData.PrsProfFile = 'sirius_si_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

% 2015-09-18 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw;
