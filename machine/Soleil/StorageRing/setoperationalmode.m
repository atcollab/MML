function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 2.7391 GeV, lattice 18.2 10.3
%                  2. 2.7391 GeV, Chasmann-Green
%                  3. 2.7391 GeV, Low-alpha (alpha/15)
%
%                100. Laurent's Mode
%
%  See also aoinit, updateatindex, soleilinit

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
    ModeCell = {'2.7391 GeV, 18.2 10.3', '2.7391 GeV, Chasmann-Green', ...
        '2.7391 GeV, Low Alpha alpha1/15','Laurent''s Mode'};
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
AD.SubMachine  = 'StorageRing';   % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.HarmonicNumber = 416;

% Defaults RF for dispersion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 100e-6;
AD.DeltaRFChro = [-100 -50 0 50 150] * 1e-6;

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
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '2.7391 GeV, 18.2 10.3';
    AD.Energy = 2.7391; % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'solamor2';
    OpsFileExtension = '_solamor2';

    % AT lattice
    AD.ATModel = 'solamor2linb';
    eval(AD.ATModel);  %run model for compilersolamor2linb;

    % Golden TUNE is with the TUNE family
    % 18.20 / 10.30
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.20
        0.30
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [2; 2]; 

    switch2hw;

elseif ModeNumber == 2
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '2.7391 GeV, 18.2 10.3';
    AD.Energy = 2.7391;     % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'chasmann_green';
    OpsFileExtension = '_chasmann_green';

    % AT lattice
    AD.ATModel = 'chasman_green';
    eval(AD.ATModel);  %run model for compilersolamor2linb;

    % Golden TUNE is with the TUNE family
    % 18.20 / 10.30
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.20
        0.30
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [2; 2]; 

    switch2hw;

elseif ModeNumber == 3
    % Low Alpha alpha_nominal/15
    AD.OperationalMode = '2.7391 GeV, 20.72 9.2, lowalpha1/15';
    AD.Energy = 2.7391;     % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'lowalpha1by15';
    OpsFileExtension = '_lowalpha1by15';

    % AT lattice
    AD.ATModel = 'lowalpha1by15';
    eval(AD.ATModel);  %run model for compilersolamor2linb;

    % Defaults RF for dispersion and chromaticity measurements (must be in Hardware units)
    AD.DeltaRFDisp = 100e-6/15*3;
    AD.DeltaRFChro = [-100 -50 0 50 150] * 1e-6/15*3;

    % Golden TUNE is with the TUNE family
    % 20.72 / 9.20
    AO = getao;
    
    AO.TUNE.Monitor.Golden = [
        0.72
        0.20
        NaN];
    
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [2; 2]; 

    switch2hw;


elseif ModeNumber == 100
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '2.7391 GeV, 18.2 10.3';
    AD.Energy = 2.7391;     % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'chasmann_green';
    OpsFileExtension = '_chasmann_green';

    % AT lattice
    AD.ATModel = 'chasman_green';
    chasman_green;

    % Golden TUNE is with the TUNE family
    % 18.20 / 10.30
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.20
        0.30
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [2; 2]; 

    setfamilydata(ones(120,1)*1e-5, 'HCOR', 'Setpoint', 'DeltaRespMat');
    setfamilydata(ones(120,1)*1e-5, 'VCOR', 'Setpoint', 'DeltaRespMat');
    % AO.(ifam).Setpoint.DeltaRespMat(:,:) = ones(nb,1)*0.5e-4*1; % 2*25 urad (half used for kicking)
    switch2hw;

else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

% SOLEIL specific path changes

 % Top Level Directories

AD.Directory.DataRoot       = fullfile(MMLROOT, 'measdata', 'Ringdata', filesep);
AD.Directory.OpsData        = fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRingOpsData', filesep);
AD.Directory.Lattice        = fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'Lattices', filesep);
AD.Directory.Orbit          = fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing',  'orbit', filesep);

% Data Archive Directories
AD.Directory.BeamUser       = fullfile(AD.Directory.DataRoot, 'BPM', 'BeamUser', filesep); %store saved orbit for operation (every new beam)
AD.Directory.BPMData        = fullfile(AD.Directory.DataRoot, 'BPM', filesep);
AD.Directory.TuneData       = fullfile(AD.Directory.DataRoot, 'Tune', filesep);
AD.Directory.ChroData       = fullfile(AD.Directory.DataRoot, 'Chromaticity', filesep);
AD.Directory.DispData       = fullfile(AD.Directory.DataRoot, 'Dispersion', filesep);
AD.Directory.ConfigData     = fullfile(AD.Directory.DataRoot, 'MachineConfig', filesep);
AD.Directory.BumpData       = fullfile(AD.Directory.DataRoot, 'Bumps', filesep);
AD.Directory.Archiving      = fullfile(AD.Directory.DataRoot, 'ArchivingData', filesep);
AD.Directory.QUAD           = fullfile(AD.Directory.DataRoot, 'QUAD', filesep);
AD.Directory.BBA            = fullfile(AD.Directory.DataRoot, 'BBA', filesep);
AD.Directory.PINHOLE        = fullfile(AD.Directory.DataRoot, 'PINHOLE', filesep);
AD.Directory.Synchro        = fullfile(MMLROOT, 'machine', 'Soleil', 'common', 'synchro', filesep);

% Insertion Devices
HOMEDIR = getenv('HOME');
AD.Directory.HU80_TEMPO     = fullfile(HOMEDIR, 'GrpGMI', 'HU80_TEMPO', filesep);
AD.Directory.HU80_PLEIADES  = fullfile(HOMEDIR, 'GrpGMI', 'HU80_PLEIADES', filesep);
AD.Directory.HU80_CASSIOPEE = fullfile(HOMEDIR, 'GrpGMI', 'HU80_CASSIOPEE', filesep);
AD.Directory.U20_PROXIMA1   = fullfile(HOMEDIR, 'GrpGMI', 'U20_PROXIMA1', filesep);
AD.Directory.U20_SWING      = fullfile(HOMEDIR, 'GrpGMI', 'U20_SWING', filesep);
AD.Directory.U20_CRISTAL    = fullfile(HOMEDIR, 'GrpGMI', 'U20_CRISTAL', filesep);
AD.Directory.HU640_DESIRS   = fullfile(HOMEDIR, 'GrpGMI', 'HU640_DESIRS', filesep);

% AD.Directory.InterlockData  = fullfile(AD.Directory.DataRoot, 'Interlock/'];

%Response Matrix Directories
AD.Directory.BPMResponse    = fullfile(AD.Directory.DataRoot, 'Response', 'BPM', filesep);
AD.Directory.TuneResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Tune', filesep);
AD.Directory.ChroResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Chrom', filesep);
AD.Directory.DispResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Disp', filesep);
AD.Directory.SkewResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Skew', filesep);

% used by energytunette
AD.Directory.BPMTransport   = fullfile(AD.Directory.DataRoot, 'Transport', 'BPM', filesep);
% used by MAT's Steerette application
AD.Directory.Steerette     = fullfile(AD.Directory.DataRoot, 'Transport', 'Steerette', filesep);


%Default Data File Prefix
AD.Default.BPMArchiveFile      = 'BPM';                %file in AD.Directory.BPM               orbit data
AD.Default.TuneArchiveFile     = 'Tune';               %file in AD.Directory.Tune              tune data
AD.Default.ChroArchiveFile     = 'Chro';               %file in AD.Directory.Chromaticity       chromaticity data
AD.Default.DispArchiveFile     = 'Disp';               %file in AD.Directory.Dispersion       dispersion data
AD.Default.CNFArchiveFile      = 'CNF';                %file in AD.Directory.CNF               configuration data
AD.Default.QUADArchiveFile     = 'QuadBeta';           %file in AD.Directory.QUAD             betafunction for quadrupoles   
AD.Default.PINHOLEArchiveFile  = 'Pinhole';            %file in AD.Directory.PINHOLE             pinhole data
AD.Default.SkewArchiveFile     = 'SkewQuad';           %file in AD.Directory.SkewQuad             SkewQuad data
AD.Default.BBAArchiveFile      = 'BBA_DKmode';         %file in AD.Directory.BBA             BBA DK mode data

%Default Response Matrix File Prefix
AD.Default.BPMRespFile      = 'BPMRespMat';         %file in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile     = 'TuneRespMat';        %file in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile     = 'ChroRespMat';        %file in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile     = 'DispRespMat';        %file in AD.Directory.DispResponse      dispersion response matrices
AD.Default.SkewRespFile     = 'SkewRespMat';        %file in AD.Directory.SkewResponse      skew quadrupole response matrices

%Operational Files
AD.OpsData.LatticeFile       = 'GoldenLattice';     %Golden Lattice File (setup for users)
AD.OpsData.PhysDataFile      = 'GoldenPhysData';
AD.OpsData.BPMGoldenFile     = 'GoldenBPMOrbit';
AD.OpsData.BPMOffsetFile     = 'OffsetBPMOrbit';
AD.OpsData.BPMSigmaFile      = 'BPMSigma';
AD.OpsData.TuneFile          = 'GoldenTune';
AD.OpsData.ChroFile          = 'GoldenChro';
AD.OpsData.DispFile          = 'GoldenDisp';

%Operational Response Files
AD.OpsData.BPMRespFile       = 'GoldenBPMResp';     
AD.OpsData.TuneRespFile      = 'GoldenTuneResp';    
AD.OpsData.ChroRespFile      = 'GoldenChroResp'; 
AD.OpsData.DispRespFile      = 'GoldenDispResp';
AD.OpsData.SkewRespFile      = 'GoldenSkewResp';
AD.OpsData.RespFiles         = {AD.OpsData.BPMRespFile,  ...
                                AD.OpsData.TuneRespFile, ...
                                AD.OpsData.ChroRespFile, ...
                                AD.OpsData.DispRespFile};

%Orbit Control and Feedback Files
AD.Restore.GlobalFeedback   = 'Restore.m';
%AD.Restore.BeamlineFeedback = 'Restore.m';


%Orbit Control and Feedback Files
AD.Restore.GlobalFeedback   = 'Restore.m';

% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);

% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;

% Set the model energy
setenergymodel(AD.Energy);

% Cavity and radiation
% setcavity off;
% setradiation off;
% fprintf('   Radiation and cavities are off.  Use setradiation / setcavity to modify. \n');

% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 4.498325442923014e-04;  
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


% Add Gain & Offsets for magnet family
fprintf('   Setting magnet monitor gains based on the production lattice.\n');
%setgainsandoffsets;


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add LOCO Parameters to AO and AT-Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%     'SetGains'   - Set gains/coupling from a LOCO file.
%     'SetModel'   - Set the model from a LOCO file.  But it only changes
%                    the part of the model that does not get corrected
%                    in 'Symmetrize' (also does a SetGains).
%     'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
%                    This uses the LOCO AT model!!! And sets all lattice
%                    machines fit in the LOCO run to the model.
%
% Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
%            use 'LOCO2Model' if the LOCO run was made after the final setup
try
    setlocodata('Nominal');
    %LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production'];
    %setlocodata('SetGains', LOCOFile);
    %setlocodata('SetModel', LOCOFile);
    %setlocodata('LOCO2Model', LOCOFile);
catch
    fprintf('\n%s\n\n', lasterr);
    fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

setad(orderfields(AD));

