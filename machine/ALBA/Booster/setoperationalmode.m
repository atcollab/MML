function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 0.1 GeV, Injection
%                  2. 3.0 GeV, Extraction
%
%  See also aoinit, updateatindex, boosterinit

%
% Written by Gabriele Benedetti

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
    ModeCell = {'0.1 GeV, 11.42 7.38, Injection', '3.0 GeV, 11.42 7.38, Extraction'};
    [ModeNumber, OKFlag] = listdlg('Name','ALBA','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'ALBA';            % Will already be defined if setpathmml was used
AD.MachineType = 'Booster';   % Will already be defined if setpathmml was used
AD.SubMachine  = 'Booster';   % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.HarmonicNumber = 416;

% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.BPMDelay  = 0.25; % use [N, BPMDelay]=getbpmsaverages (AD.BPMDelay will disappear)
AD.TuneDelay = 0.1;

% The offset and golden orbits are stored at the end of this file


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
    % User mode - High Tune
    AD.OperationalMode = '3.0 GeV, 11.42 7.38, Extraction';
    ModeName = 'Extraction';
    OpsFileExtension = '_Ext';
    
    % AT lattice
    AD.ATModel = 'booster_ext';
    eval(AD.ATModel);  %run model for compiler;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.4200
        0.3800
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

    % Defaults RF for dispersion and chromaticity measurements (must be in Hardware units)
    AD.DeltaRFDisp = 100e-6;
    AD.DeltaRFChro = [-100 -50 0 50 150] * 1e-6;

    %switch2online;
    switch2sim;    % Until the machine is ready ???
    switch2hw;
    %switch2physics;
    
elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '0.1 GeV, 11.42 7.38, Injection';
    ModeName = 'Extraction';
    OpsFileExtension = '_Inj';

    % AT lattice
    AD.ATModel = 'booster_inj';
    eval(AD.ATModel);  %run model for compiler;

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.4200
        0.3800
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Defaults RF for dispersion and chromaticity measurements (must be in Hardware units)
    AD.DeltaRFDisp = 100e-6;
    AD.DeltaRFChro = [-100 -50 0 50 150] * 1e-6;

    %switch2online;
    switch2sim;    % Until the machine is ready ???
    switch2hw;
    %switch2physics;
else
    error('Operational mode unknown');
end

%Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

%MMLROOT = getmmlroot;

% Top Level Directories

AD.Directory.DataRoot       = fullfile(MMLROOT, 'measdata', AD.Machine, 'Booster', filesep);
AD.Directory.OpsData        = fullfile(MMLROOT, 'machine', AD.Machine, 'BoosterOpsData', filesep);
AD.Directory.Lattice        = fullfile(MMLROOT, 'machine', AD.Machine, 'Booster', 'Lattices', filesep);
AD.Directory.Orbit          = fullfile(MMLROOT, 'machine', AD.Machine, 'Booster',  'orbit', filesep);

% Data Archive Directories
AD.Directory.BPMData        = fullfile(AD.Directory.DataRoot, 'BPM', filesep);
AD.Directory.TuneData       = fullfile(AD.Directory.DataRoot, 'Tune', filesep);
AD.Directory.ChroData       = fullfile(AD.Directory.DataRoot, 'Chromaticity', filesep);
AD.Directory.DispData       = fullfile(AD.Directory.DataRoot, 'Dispersion', filesep);
AD.Directory.ConfigData     = fullfile(AD.Directory.DataRoot, 'MachineConfig', filesep);
AD.Directory.BumpData       = fullfile(AD.Directory.DataRoot, 'Bumps', filesep);
AD.Directory.Archiving      = fullfile(AD.Directory.DataRoot, 'ArchivingData', filesep);
AD.Directory.QUAD           = fullfile(AD.Directory.DataRoot, 'QUAD', filesep);

% AD.Directory.InterlockData  = fullfile(AD.Directory.DataRoot, 'Interlock/'];

%Response Matrix Directories
AD.Directory.BPMResponse    = fullfile(AD.Directory.DataRoot, 'Response', 'BPM', filesep);
AD.Directory.TuneResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Tune', filesep);
AD.Directory.ChroResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Chrom', filesep);
AD.Directory.DispResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Disp', filesep);
AD.Directory.SkewResponse   = fullfile(AD.Directory.DataRoot, 'Response', 'Skew', filesep);

%Default Data File Prefix
AD.Default.BPMArchiveFile      = 'BPM';                %file in AD.Directory.BPM               orbit data
AD.Default.TuneArchiveFile     = 'Tune';               %file in AD.Directory.Tune              tune data
AD.Default.ChroArchiveFile     = 'Chro';               %file in AD.Directory.Chromaticity       chromaticity data
AD.Default.DispArchiveFile     = 'Disp';               %file in AD.Directory.Dispersion       dispersion data
AD.Default.CNFArchiveFile      = 'CNF';                %file in AD.Directory.CNF               configuration data
AD.Default.QUADArchiveFile     = 'QuadBeta';           %file in AD.Directory.QUAD             betafunction for quadrupoles   

%Default Response Matrix File Prefix
AD.Default.BPMRespFile      = 'BPMRespMat';         %file in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile     = 'TuneRespMat';        %file in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile     = 'ChroRespMat';        %file in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile     = 'DispRespMat';        %file in AD.Directory.DispResponse      dispersion response matrices

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
    AD.MCF = 0.00358;  
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);

% Add Gain & Offsets for magnet family
fprintf('   Setting magnet monitor gains based on the production lattice.\n');


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if any(ModeNumber == [1 2])
    % User mode - Nominal lattice

    % Tune actuactors
    MemberOf = getfamilydata('QF1','MemberOf');
    setfamilydata({MemberOf{:} 'Tune Corrector'}','QF1','MemberOf');
    MemberOf = getfamilydata('QD1','MemberOf');
    setfamilydata({MemberOf{:} 'Tune Corrector'}','QD1','MemberOf');
    MemberOf = getfamilydata('QD2','MemberOf');
    setfamilydata({MemberOf{:} 'Tune Corrector'}','QD2','MemberOf');
    
    % Chromaticity actuators
    MemberOf = getfamilydata('SD','MemberOf');
    setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD','MemberOf');
    MemberOf = getfamilydata('SF','MemberOf');
    setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SF','MemberOf');
end

fprintf('   lattice files have changed or if the AT lattice has changed.\n');
fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

setad(orderfields(AD));
