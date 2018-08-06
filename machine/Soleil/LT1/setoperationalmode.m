function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 110 MeV, multibunch
%                  2. LT1 voie directe
%                  3. 80 MeV, backup Linac
%
%                100. Laurent's Mode
%
%  See also aoinit, updateatindex, LT1init

%
% Written by Laurent S. Nadolski

global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = [];
end
if isempty(ModeNumber)
    ModeCell = {'110 MeV, multibunch', 'LT1 voie directe', '80 MeV, backup Linac', ...
        'Laurent''s Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','SOLEIL','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    elseif ModeNumber == 4
        ModeNumber = 100;  % Laurent
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'SOLEIL';            % Will already be defined if setpathmml was used
AD.MachineType = 'StorageRing';   % Will already be defined if setpathmml was used
AD.SubMachine  = 'LT1';           % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.BPMDelay  = 0.25; % use [N, BPMDelay]=getbpmsaverages (AD.BPMDelay will disappear)
AD.TuneDelay = 0.1;


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;

%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names

if ModeNumber == 1
    % LT1 Nominal Lattice
    AD.OperationalMode = '110 MeV, multibunch';
    AD.Energy = 0.110; % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'bareLT1lattice';
    OpsFileExtension = '_bareLT1lattice';

    % AT lattice
    AD.ATModel = 'bareLT1lattice';
    eval(AD.ATModel);  %run model for compilersolamor2linb;

    switch2hw;

elseif ModeNumber == 2
    %  LT1 voie directe - ecran emittance=COLL 
    AD.OperationalMode = '110 MeV, multibunch';
    AD.Energy = 0.110; % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'LT1emittancelattice';
    OpsFileExtension = '_LT1emittancelattice';

    % AT lattice
    AD.ATModel = 'LT1emittancelattice';
    eval(AD.ATModel);

    switch2hw;
   
elseif ModeNumber == 3
    % User mode - High Tune, Top Off injection
    error('To be completed');
    
elseif ModeNumber == 100
    % User mode - High Tune, Top Off injection
    error('To be completed');    

else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

% SOLEIL specific path changes

 % Top Level Directories

AD.Directory.DataRoot       = fullfile(MMLROOT, 'measdata', 'LT1data', filesep);
AD.Directory.OpsData        = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1OpsData', filesep);
AD.Directory.Lattice        = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'Lattices', filesep);

AD.Directory.FAEData        = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'fae', filesep);
AD.Directory.EMITData       = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'emittance', filesep); 
AD.Directory.Timing         = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'Timing', filesep);

AD.Directory.ConfigData     = fullfile(AD.Directory.DataRoot, 'MachineConfig', filesep);
AD.Directory.Archiving      = fullfile(AD.Directory.DataRoot, 'ArchivingData', filesep);
AD.Directory.Synchro        = fullfile(MMLROOT, 'machine', 'Soleil', 'common', 'synchro', filesep);


%Operational Files
AD.OpsData.LatticeFile       = 'GoldenLattice';     %Golden Lattice File (setup for users)
AD.OpsData.PhysDataFile      = 'GoldenPhysData';

% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);

% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;

% Set the model energy
setenergymodel(AD.Energy);

fprintf('   lattice files have changed or if the AT lattice has changed.\n');
fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

setad(orderfields(AD));
