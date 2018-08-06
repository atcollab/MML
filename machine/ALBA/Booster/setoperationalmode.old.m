function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 3.0 GeV, User Mode
%                  2. 3.0 GeV, Model
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
    ModeCell = {'User Mode', 'Model'};
    [ModeNumber, OKFlag] = listdlg('Name','ALBA','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
AD.Machine = 'BOOSTER';
AD.OperationalMode = '';    % Gets filled in later
AD.Energy = 3.0;
AD.InjectionEnergy = 0.1;
AD.HarmonicNumber = 416;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units) ???
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = 'booster';
if ModeNumber == 1
    % User mode - High Tune
    AD.OperationalMode = '3.0 GeV, User Mode';
    ModeName = 'User';
    OpsFileExtension = '_User';
    
    % AT lattice
    AD.ATModel = 'booster';
    eval(AD.ATModel);
    global THERING;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.4200
        0.3800
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;  % ???

    %switch2online;
    switch2sim;    % Until the machine is ready ???
    %switch2hw;
    switch2physics;
    
elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '3.0 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'booster';
    eval(booster);

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.4200
        0.3800
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;

    switch2sim;
    %switch2hw;
    switch2physics;

else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
setdirectorypath(MachineName, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex2;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity on;        % Needed for tune
setradiation off;    % ???


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


% Final mode changes
if ModeNumber == 1
    % User mode - 1.9 GeV, High Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LocoDataSextupolesOn']);
    %setlocodata('Nominal');

elseif ModeNumber == 2
    %setlocogains('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    setsp('HCM', 0, 'Simulator', 'Physics');
    setsp('VCM', 0, 'Simulator', 'Physics');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
return


function setdirectorypath(MachineName, ModeName, OpsFileExtension)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directories which define the data and opsdata tree %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AD = getad;

% First check for an environmental variable for the middle layer root directory
MLROOT = getenv('MLROOT');
if isempty(MLROOT)
    % Base MLROOT one level higher that where getsp is located
    [DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
    i = findstr(DirectoryName,filesep);
    if isempty(i)
       MLROOT = DirectoryName; 
    else
       MLROOT = DirectoryName(1:i(end));
    end
% set MLROOT by hand, it is the safer 
% MLROOT='/home/munoz/Work/Matlab/MiddleLayer/';
end

% MLROOT must end in a file separator
if ~strcmp(MLROOT(end), filesep)
    MLROOT = [MLROOT, filesep];
end

% DataRoot Location
% Base on normal middle layer directory structure
%AD.Directory.DataRoot = [MLROOT, 'machine', filesep, MachineName, 'data', filesep, ModeName, filesep];
%Change to the spear convention
AD.Directory.DataRoot = [MLROOT, 'machine', filesep, MachineName, 'data', filesep, ModeName, filesep];
% Operational directory and physdata file
AD.Directory.OpsData    = [MLROOT, 'machine',  filesep, MachineName, 'opsdata', filesep, ModeName, filesep];
AD.OpsData.PhysDataFile = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, MachineName, 'physdata.mat'];

%Data Archive Directories
AD.Directory.BPMData        = [AD.Directory.DataRoot 'BPM', filesep];
AD.Directory.TuneData       = [AD.Directory.DataRoot 'Tune', filesep];
AD.Directory.ChroData       = [AD.Directory.DataRoot 'Chromaticity', filesep];
AD.Directory.DispData       = [AD.Directory.DataRoot 'Dispersion', filesep];
AD.Directory.ConfigData     = [AD.Directory.DataRoot 'MachineConfig', filesep];

%Response Matrix Directories
AD.Directory.BPMResponse    = [AD.Directory.DataRoot 'Response', filesep, 'BPM', filesep];
AD.Directory.TuneResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Tune', filesep];
AD.Directory.ChroResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Chromaticity', filesep];
AD.Directory.DispResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Dispersion', filesep];
AD.Directory.SkewResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Skew', filesep];

%Default Data File Prefix
AD.Default.BPMArchiveFile   = 'BPM';                % File in AD.Directory.BPM               orbit data
AD.Default.TuneArchiveFile  = 'Tune';               % File in AD.Directory.Tune              tune data
AD.Default.ChroArchiveFile  = 'Chro';               % File in AD.Directory.Chromaticity      chromaticity data
AD.Default.DispArchiveFile  = 'Disp';               % File in AD.Directory.Dispersion        dispersion data
AD.Default.CNFArchiveFile   = 'CNF';                % File in AD.Directory.CNF               configuration data

%Default Response Matrix File Prefix
AD.Default.BPMRespFile      = 'BPMRespMat';         % File in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile     = 'TuneRespMat';        % File in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile     = 'ChroRespMat';        % File in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile     = 'DispRespMat';        % File in AD.Directory.DispResponse      dispersion response matrices
AD.Default.SkewRespFile     = 'SkewRespMat';        % File in AD.Directory.SkewResponse      skew quadrupole response matrices

%Operational Files
AD.OpsData.LatticeFile   = ['GoldenConfig',    OpsFileExtension];
AD.OpsData.InjectionFile = ['InjectionConfig', OpsFileExtension];
AD.OpsData.BPMSigmaFile  = ['GoldenBPMSigma',  OpsFileExtension];
AD.OpsData.DispFile      = ['GoldenDisp',      OpsFileExtension];

%Operational Response Files
AD.OpsData.BPMRespFile  = ['GoldenBPMResp',  OpsFileExtension]; 
AD.OpsData.TuneRespFile = ['GoldenTuneResp', OpsFileExtension];
AD.OpsData.ChroRespFile = ['GoldenChroResp', OpsFileExtension];
AD.OpsData.DispRespFile = ['GoldenDispResp', OpsFileExtension];
AD.OpsData.SkewRespFile = ['GoldenSkewResp', OpsFileExtension];
AD.OpsData.RespFiles     = {...
        [AD.Directory.OpsData, AD.OpsData.BPMRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.TuneRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.ChroRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.DispRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.SkewRespFile]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other alba application parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = findstr(MLROOT, filesep);
% AD.Directory.Lattice  = [MLROOT(1:i(end-1)), 'applications', filesep, 'lattices', filesep, MachineName];
% AD.Directory.Orbit    = [MLROOT(1:i(end-1)), 'applications', filesep, 'orbit', filesep, MachineName];
% AD.Directory.SOFB     = [MLROOT(1:i(end-1)), 'applications', filesep, 'sofb', filesep, MachineName];
AD.Directory.Lattice  = [MLROOT(1:i(end)), 'applications', filesep, 'lattices', filesep, MachineName];
AD.Directory.Orbit    = [MLROOT(1:i(end)), 'applications', filesep, 'orbit', filesep, MachineName];
AD.Directory.SOFB     = [MLROOT(1:i(end)), 'applications', filesep, 'sofb', filesep, MachineName];


% Save AD
setad(AD);


