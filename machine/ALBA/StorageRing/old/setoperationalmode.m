function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 3.0 GeV, User Mode
%               2. 3.0 GeV, Model


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
AD = getad;    
AD.Machine = 'ALBA';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.0;
AD.InjectionEnergy = 3.0;
AD.HarmonicNumber = 440;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units) ???
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode - High Tune
    AD.OperationalMode = '3.0 GeV, User Mode';
    ModeName = 'User';
    OpsFileExtension = '_User';
    
    % AT lattice
    %AD.ATModel = 'alba03lattice';
    %alba03lattice;
    AD.ATModel = 'a25_Symplectic';
    a25_Symplectic;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.1789
        0.3715
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;  % ???

    % This is a bit of a cluge to know if the user is on the ALBA filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtALBA'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;

elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '3.0 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    %AD.ATModel = 'alba03lattice';
    %alba03lattice;
    AD.ATModel = 'a25_Symplectic';
    a25_Symplectic;

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.1789
        0.3715
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;

    switch2sim;
    switch2hw;

else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;  
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.001187;
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

    setfamilydata(0, 'TuneDelay');

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
    % Base MLROOT on where getsp is located
    [MLROOT, FileName, ExtentionName] = fileparts(which('getsp'));
end

i = findstr(MLROOT, filesep);
if length(i) > 1
    MLROOT = MLROOT(1:i(end));
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
AD.Directory.Lattice  = [MLROOT(1:i(end-1)), 'applications', filesep, 'lattices', filesep, MachineName];
AD.Directory.Orbit    = [MLROOT(1:i(end-1)), 'applications', filesep, 'orbit', filesep, MachineName];
AD.Directory.SOFB     = [MLROOT(1:i(end-1)), 'applications', filesep, 'sofb', filesep, MachineName];


% Save AD
setad(AD);


