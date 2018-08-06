function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 2.7391 GeV, multibunch
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
    ModeCell = {'2.7391 GeV, multibunch',  ...
        'Laurent''s Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','SOLEIL','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    elseif ModeNumber == 2
        ModeNumber = 100;  % Laurent
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'SOLEIL';            % Will already be defined if setpathmml was used
AD.MachineType = 'StorageRing';   % Will already be defined if setpathmml was used
AD.SubMachine  = 'Booster';       % Will already be defined if setpathmml was used
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
    % Booster Nominal Lattice
    AD.OperationalMode = '2.7391 GeV, multibunch';
    AD.Energy = 2.7391; % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'boosterreal';
    OpsFileExtension = '_boosterreal';

    % AT lattice
    %AD.ATModel       = 'boostersteerer'; % lattice file
    AD.ATModel = 'boosterreal';
    eval(AD.ATModel);  %run model for compilersolamor2linb;

    switch2hw;
    
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

AD.Directory.DataRoot       = fullfile(MMLROOT, 'measdata', 'Boosterdata', filesep);
AD.Directory.OpsData        = fullfile(MMLROOT, 'machine', 'Soleil', 'BoosterOpsData', filesep);
AD.Directory.Lattice        = fullfile(MMLROOT, 'machine', 'Soleil', 'Booster', 'Lattices', filesep);
AD.Directory.Orbit          = fullfile(MMLROOT, 'applications', 'orbit', filesep);

% Data Archive Directories
AD.Directory.BPMData        = fullfile(AD.Directory.DataRoot, 'BPM', filesep);
AD.Directory.TuneData       = fullfile(AD.Directory.DataRoot, 'Tune', filesep);
AD.Directory.ChroData       = fullfile(AD.Directory.DataRoot, 'Chromaticity', filesep);
AD.Directory.DispData       = fullfile(AD.Directory.DataRoot, 'Dispersion', filesep);
AD.Directory.ConfigData     = fullfile(AD.Directory.DataRoot, 'MachineConfig', filesep);
AD.Directory.BumpData       = fullfile(AD.Directory.DataRoot, 'Bumps', filesep);
AD.Directory.Archiving      = fullfile(AD.Directory.DataRoot, 'ArchivingData', filesep);
AD.Directory.TurnByTurnTune = fullfile(AD.Directory.DataRoot, 'BPM', 'turnbyturntune');
AD.Directory.Synchro        = fullfile(MMLROOT, 'machine', 'Soleil', 'common', 'synchro', filesep);


% quick fix (dixit Alex)
AD.Directory.Timing         = fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'LT1data', 'Timing', filesep);

%Response Matrix Directories
AD.Directory.BPMResponse    = fullfile(AD.Directory.DataRoot, 'Response', 'BPM', filesep);
AD.Directory.TuneResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Tune', filesep);
AD.Directory.ChroResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Chrom', filesep);
AD.Directory.DispResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Disp', filesep);

%Default Data File Prefix
AD.Default.BPMArchiveFile   = 'BPM';                %file in AD.Directory.BPM               orbit data
AD.Default.TuneArchiveFile  = 'Tune';               %file in AD.Directory.Tune              tune data
AD.Default.ChroArchiveFile  = 'Chro';               %file in AD.Directory.Chromaticity       chromaticity data
AD.Default.DispArchiveFile  = 'Disp';               %file in AD.Directory.Dispersion       dispersion data
AD.Default.CNFArchiveFile   = 'CNF';                %file in AD.Directory.CNF               configuration data
AD.Default.QUADArchiveFile  = 'QuadBeta';           %file in AD.Directory.QUAD             betafunction for quadrupoles   

%Default Response Matrix File Prefix
AD.Default.BPMRespFile      = 'BPMRespMat';         %file in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile     = 'TuneRespMat';        %file in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile     = 'ChroRespMat';        %file in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile     = 'DispRespMat';        %file in AD.Directory.DispResponse      dispersion response matrices

%Operational Files
AD.OpsData.LatticeFile       = 'GoldenLattice';     %Golden Lattice File (setup for users)
AD.OpsData.PhysDataFile      = 'GoldenPhysData';
%AD.OpsData.BPMGoldenFile     = 'GoldenBPMOrbit';
%AD.OpsData.BPMOffsetFile     = 'OffsetBPMOrbit';
AD.OpsData.BPMSigmaFile      = 'BPMSigma';
%AD.OpsData.TuneFile          = 'GoldenTune';
%AD.OpsData.ChroFile          = 'GoldenChro';
%AD.OpsData.DispFile          = 'GoldenDisp';

%Operational Response Files
AD.OpsData.BPMRespFile       = 'GoldenBPMResp';     
AD.OpsData.TuneRespFile      = 'GoldenTuneResp';    
AD.OpsData.ChroRespFile      = 'GoldenChroResp'; 
AD.OpsData.DispRespFile      = 'GoldenDispResp';
AD.OpsData.RespFiles         = {AD.OpsData.BPMRespFile,  ...
                                AD.OpsData.TuneRespFile, ...
                                AD.OpsData.ChroRespFile, ...
                                AD.OpsData.DispRespFile};

% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);

% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;

% Set the model energy
setenergymodel(AD.Energy);


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.0150;  
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


fprintf('   lattice files have changed or if the AT lattice has changed.\n');
fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

setad(orderfields(AD));
