function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1.  3 GeV {Default}
%               2.  150 MeV
%
%
% History
%
% 2011-06-02 new version (Ximenes)




% Check if the AO exists
%checkforao;

% MODES
ModeCell = { ...
    '3 GeV'; ...
    '150 MeV'; ...
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

if ModeNumber == 1
    set_operationalmode_High;
elseif ModeNumber == 2
    set_operationalmode_Low;
else
     error('Operational mode unknown');
end

% Set the AD directory path
AD = getad;
setmmldirectories(AD.Machine, AD.SubMachine, AD.ModeName, AD.OpsFileExtension);
% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% 2015-09-18 Luana
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
if ModeNumber == 1
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

elseif ModeNumber == 101
    setlocodata('Nominal');
    setfamilydata(0,'bpmx','Offset');
    setfamilydata(0,'bpmy','Offset');
    setfamilydata(0,'bpmx','Golden');
    setfamilydata(0,'bpmy','Golden');
    %setsp('HCM', 0, 'Simulator', 'Physics');
    %setsp('VCM', 0, 'Simulator', 'Physics');
    setfamilydata(0,'TuneDelay');
else
    try
        setlocodata('Nominal');
    catch
        fprintf('   Problem with setting the LOCO calibration.\n');
    end
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
%ats = atsummary;
%setappdata(0, 'ATSUMMARY', ats);

function set_operationalmode_High

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';     % Will already be defined if setpathmml was used
AD.SubMachine          = 'BO.E02.02';  % Will already be defined if setpathmml was used
AD.MachineType         = 'Booster';    % Will already be defined if setpathmml was used
AD.OperationalMode     = '3 GeV';
AD.Energy              = 3.0;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'HighE';
AD.OpsFileExtension    = '';

sirius_bo_lattice(AD.Energy);


AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 828;
AD.DeltaRFDisp         = 2000e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.TuneDelay           = 0.0;  
AD.ATModel             = 'sirius_bo_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.BeamCurrent         = 0.002; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0002;
AD.OpsData.PrsProfFile = 'sirius_bo_pressure_profile.txt';
AD.AveragePressure     = 1.5e-8; % [mbar]

% 2015-09-21 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw; 

function set_operationalmode_Low

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';     % Will already be defined if setpathmml was used
AD.SubMachine          = 'BO.E02.02';  % Will already be defined if setpathmml was used
AD.MachineType         = 'Booster';    % Will already be defined if setpathmml was used
AD.OperationalMode     = '150 MeV';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'LowE';
AD.OpsFileExtension    = '';

sirius_bo_lattice(AD.Energy);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 828;
AD.DeltaRFDisp         = 2000e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.TuneDelay           = 0.0;  
AD.ATModel             = 'sirius_bo_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.BeamCurrent         = 0.002; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0002;
AD.OpsData.PrsProfFile = 'sirius_bo_pressure_profile.txt';
AD.AveragePressure     = 1.5e-8; % [mbar]

% 2015-09-21 Luana
AD.SetMultipolesErrors = false;

setad(AD);
switch2sim;
switch2hw; 



