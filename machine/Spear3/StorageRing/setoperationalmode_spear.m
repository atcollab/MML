function setoperationalmode(ModeNumber)
%  setoperationalmode(ModeNumber)
%
%  This function is used to set the path and model for a particular operational mode.
%  NOTE: This function assumes that the AO has already setup with spear3init
%
%  INPUTS
%  ModeNumber = 0 Development Lattice
%  ModeNumber = 1  Achromat Optics sp3v82 (18nm bare, 15nm with IDs)
%               2  Low Emittance Optics sp3v82_leps (12nm bare, 10nm with IDs)
%               10 Low Emittance Optics sp3v82_leps (12nm bare, 10nm with IDs)
%               3  Low Alpha Optics sp3v82_la
%               12 Low Alpha Optics sp3v82_la
%               50 Old MiddleLayer
%  
%  Written by Greg Portmann, maintainted for SPEAR3 by Jeff Corbett

global THERING

% Check if the AO exists
checkforao;

if nargin < 1
    % Choose Mode from dialog box
        ModeCell = {'Achromatic (15nm-rad)' ,'Low Emittance (10nm-rad)', 'Low Alpha' };
        [ModeNumber, OKFlag] = listdlg('Name','Spear','PromptString','Select the Operational Mode:',...
            'SelectionMode','single', 'ListString', ModeCell,'InitialValue',2);
        if OKFlag ~= 1
            fprintf('   Operational mode not changed\n');
            return
        end         
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-load AD Structure     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'SPEAR3';
AD.SubMachine = 'StorageRing';
AD.MachineType = 'StorageRing';
AD.OperationalMode = '';          % Gets filled in later
AD.ConfigName = 'ConfigNameField';
AD.Energy = 3.0;  % GeV    
AD.InjectionEnergy = 3.0;  % GeV
AD.HarmonicNumber = 372;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-1000 -500 0 500 1000]*1e-6;

% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing a variable like the RF frequency.
AD.TuneDelay = 0.0;  

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
% MachineName - string used to build directory structure off DataRoot
% ModeName - string used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = 'spear3';

%%%%%  IMPORTANT RE-ROUTINING CONDITIONS  %%%%%%%%%       
if ModeNumber == 2  %Low Emittance
   ModeNumber = 10;
elseif ModeNumber == 3  %Low Alpha
   ModeNumber = 11;
end

if ModeNumber == 0    % Development Lattice
    % Choose AT lattice
    DirectoryName = 'R:\Controls\matlab\applications\lattices\';
    [FileName, DirectoryName] = uigetfile('*.m', 'Select an AT Deck to load', DirectoryName);
    AD.ATModel = FileName;
    FileName = [DirectoryName FileName];
    disp(['   AT Deck selected for development lattice: ' FileName])
    run(FileName);
    AD.OperationalMode = 'Development Lattice';
    ModeName = 'Development';
    OpsFileExtension = '';
    AO = getao;   % Golden TUNE is with the TUNE family (it could be in the AD) 
    AO.TUNE.Monitor.Golden = [0.1300  0.22  NaN]';
    setao(AO);    
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % approx.  [-1.8;-1.8] in hardware units


    switch2hw;

elseif ModeNumber == 1   % Achromat - 18nm bare lattice, 15nm with IDs
    sp3v82;  % AT lattice
    AD.ATModel = 'sp3v82';
    AD.OperationalMode = 'Achromat Optics (15nm)';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel])
    ModeName = 'Achromat';
    AD.ModeName=ModeName;
    OpsFileExtension = ''; 
    AO = getao;   % Golden TUNE is with the TUNE family (it could be in the AD) 
    AO.TUNE.Monitor.Golden = [0.1300  0.22  NaN]';
    setao(AO);    
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % approx.  [-1.8;-1.8] in hardware units
    switch2hw;
    
elseif ModeNumber == 10 %Low Emittance - 12nm bare lattice, 10nm with IDs - eta leak with chicane (12/11/2006)
    sp3v82_leps; % AT lattice
    AD.ATModel = 'sp3v82_leps';
    AD.OperationalMode = 'Low Emittance Optics (10nm-rad)';
    ModeName = 'LowEmittance';
    AD.ModeName=ModeName;
    OpsFileExtension = '_LowEmittance';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel])
    AO = getao;   % Golden TUNE is with the TUNE family (it could be in the AD) 
    AO.TUNE.Monitor.Golden = [0.1300  0.22  NaN]';
    setao(AO);    
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % approx.  [-1.8;-1.8] in hardware units
    switch2hw;
    
elseif ModeNumber == 11   %low alpha with chicane (12/11/2006)
    sp3v82_la; % AT lattice
    AD.ATModel = 'sp3v82_la';
    AD.OperationalMode = 'Low Alpha';
    ModeName = 'LowAlpha';
    OpsFileExtension = '_LowAlpha';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel]) 
    AO = getao;   % Golden TUNE is with the TUNE family (it could be in the AD) 
    AO.TUNE.Monitor.Golden = [0.1300  0.22  NaN]';
    setao(AO);    
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % approx.  [-1.8;-1.8] in hardware units
    switch2hw;
    
elseif ModeNumber == 50 %pre-Chicane Doublet
%     sp3v81fSept; 
%     AD.ATModel = 'sp3v81fSept';
    sp3v81ft; 
    AD.ATModel = 'sp3v81ft';
    AD.OperationalMode = 'SP3V81FT with 112 BPM';
    ModeName = 'SP3V81FT_112BPM';
    OpsFileExtension = '';  
    switch2hw;    
else
    error('Operational mode unknown');
end

%%%%CASE BLOCKS FOR OLD MODES STORED AT BOTTOM OF THIS FILE  %%%%

% Set the AD directory path
setad(AD);
SetDirectoryPathLocal(MachineName, ModeName, OpsFileExtension);
AD = getad;
    
% Chicane response files
AD.Default.ChicaneRespFile  = 'ChicaneRespMat'; % File in AD.Directory.BPMResponse    BPM/Chicane response matrice
AD.OpsData.ChicaneRespFile = ['GoldenChicaneResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.ChicaneRespFile]};

% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;
   
% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1); %= 2.341440127200002e+002;

% Set the model energy
setenergymodel(AD.Energy);

% Cavity and radiation
setcavity off;
setradiation off;   

% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.001187;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (determined by the initial AT model)\n', AD.MCF);
end
setad(AD);

fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directories which define the data and opsdata tree %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SetDirectoryPathLocal(MachineName, ModeName, OpsFileExtension);
AD = getad;
% First check for an environmental variable for the middle layer root directory
MLROOT = '';  %getenv('MLROOT');
if isempty(MLROOT)
    % Base MLROOT on where getsp is located
    [MLROOT, FileName, ExtentionName] = fileparts(which('getsp'));
    
    % Default location for Spear
    %MLROOT = 'r:\controls\matlab\acceleratorcontrol\';
end

i = findstr(MLROOT, filesep);
if length(i) > 0
    MLROOT = MLROOT(1:i(end));
end

% MLROOT must end in a file separator
if ~strcmp(MLROOT(end), filesep)
    MLROOT = [MLROOT, filesep];
end

% % DataRoot Location
% % This is a bit of a cluge to know if the user is on the Spear filer
% % If so, the location of DataRoot will be different from the middle layer default
% if ~isempty(findstr(lower(MLROOT),'y:\controls')) | ~isempty(findstr(lower(MLROOT),'r:\controls'))
%     % Use MLROOT and DataRoot on the Spear file system
%     i = findstr(MLROOT, filesep);
%     AD.Directory.DataRoot   = [MLROOT(1:i(end-1)), MachineName, 'data', filesep, ModeName, filesep];
%     AD.Directory.OpsData    = [MLROOT, MachineName, 'opsdata', filesep, ModeName, filesep];
%     AD.OpsData.PhysDataFile = [MLROOT, MachineName, 'opsdata', filesep, MachineName, 'physdata.mat'];
%     
%     % If using the Spear filer, I'm assuming you want to be online
%     switch2online;
% else
%     % Base on normal middle layer directory structure
%     AD.Directory.DataRoot   = [MLROOT, 'machine', filesep, MachineName, 'data', filesep, ModeName, filesep];
%     AD.Directory.OpsData    = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, ModeName, filesep];
%     AD.OpsData.PhysDataFile = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, MachineName, 'physdata.mat'];
%     %if strcmp(computer,'PCWIN') == 1
%     %    AD.Directory.DataRoot = ['\\Als-filer\physdata\matlab2004\acceleratorcontrol\machine\', MachineName, filesep, ModeName, filesep];
%     %else
%     %    AD.Directory.DataRoot = ['/home/als/physdata/matlab2004/acceleratorcontrol/machine/', MachineName, 'data', filesep, ModeName, filesep];
%     %end
%     
%     % If not using the Spear filer, I'm assuming you want to be simulating
%     switch2sim;
% end

% DataRoot Location
% Base on normal middle layer directory structure
AD.Directory.DataRoot = [MLROOT, 'machine', filesep, MachineName, 'data', filesep, ModeName, filesep];
AD.Directory.OpsData    = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, ModeName, filesep];
AD.OpsData.PhysDataFile = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, MachineName, 'physdata.mat'];
AD.Directory.GoldenConfigFiles = [MLROOT, 'machine', filesep, MachineName, 'opsdata', filesep, 'Configurations', filesep];

% This is a bit of a cluge to know if the user is on the ALS filer
% If so, the location of DataRoot will be different from the middle layer default
if ~isempty(findstr(lower(MLROOT),'y:\controls')) | ~isempty(findstr(lower(MLROOT),'r:\controls'))
    % If using the ALS filer, I'm assuming you want to be online
    switch2online;
else
    % If not using the Spear3 filer, I'm assuming you want to be simulating
    switch2sim;
end

%Data Archive Directories
AD.Directory.BPMData        = [AD.Directory.DataRoot 'BPM', filesep];
AD.Directory.ScraperData    = [AD.Directory.DataRoot 'Scraper', filesep];
AD.Directory.InterferometerData    = [AD.Directory.DataRoot 'Interferometer', filesep];
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
AD.Default.ScraperArchiveFile   = 'Scraper';        % File in AD.Directory.Scraper           scraper data
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
% Spear application parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD.Directory.Lattice  = [MLROOT, 'applications', filesep, 'lattices', filesep, MachineName];
AD.Directory.Orbit    = [MLROOT, 'applications', filesep, 'orbit', filesep, MachineName];
AD.Directory.SOFB     = [MLROOT, 'applications', filesep, 'sofb', filesep, MachineName];
AD.Directory.BTS           = [AD.Directory.DataRoot 'BTS', filesep];
AD.Directory.BumpData      = [AD.Directory.DataRoot 'Bumps', filesep];
AD.Directory.InterlockData = [AD.Directory.DataRoot 'Interlock', filesep];
% Add beamline files
AD.Directory.BLData        = [AD.Directory.DataRoot 'Beamline', filesep];
AD.Directory.BLResponse    = [AD.Directory.DataRoot 'Response', filesep, 'Beamline', filesep];
AD.Default.BLArchiveFile = 'BL';        % file in AD.Directory.BL            beamline data
AD.Default.BLRespFile = 'BLRespMat';    % file in AD.Directory.BLResponse    photon BPM response matrices
AD.OpsData.BLRespFile = ['GoldenBLResp', OpsFileExtension];
AD.OpsData.RespFiles{end+1} = [AD.Directory.OpsData, AD.OpsData.BLRespFile];

% Skeleton Deck files
AD.Deck.ATSkeleton_Group  = 'sp3v81f_ATSkeleton_Group';   %used to create deck with HW2OpticsDeck
AD.Deck.ATSkeleton_All    = 'sp3v81f_ATSkeleton_All';
AD.Deck.MADSkeleton_Group = 'sp3v81f_MADSkeleton_Group';
AD.Deck.MADSkeleton_All   = 'sp3v81f_MADSkeleton_All';

% Orbit Control and Feedback Files
AD.Restore.GlobalFeedback   = 'Restore.m';
AD.Restore.BeamlineFeedback = 'Restore.m';

% Beam line corrector feed-forward 'CurrReference' file
AD.setmachineconfigfunction='setmachineconfig_finis';
AD.getmachineconfigfunction='getmachineconfig_finis';

% Save AD
setad(AD);















% % % elseif ModeNumber == 2
% % %     % Model 
% % %     sp3v81ft; 
% % %     AD.ATModel = 'sp3v81ft';
% % %     AD.OperationalMode = '3.0 GeV, Model';
% % %     ModeName = 'Model';
% % %     OpsFileExtension = '_Model';
% % %     
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 3
% % %     % ID's open 
% % %     sp3v81ft; 
% % %     AD.ATModel = 'sp3v81ft';
% % %     AD.OperationalMode = '3.0 GeV, ID''s Open';
% % %     ModeName = 'IDsOpen';
% % %     OpsFileExtension = '_IDsOpen';
% % %     
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 4
% % %     % Sextupoles Off
% % %     sp3v81ft; 
% % %     AD.ATModel = 'sp3v81ft';
% % %     AD.OperationalMode = '3.0 GeV, Sextupoles Off';
% % %     ModeName = 'SextupolesOff';
% % %     OpsFileExtension = '_SextupolesOff';
% % %     
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 5
% % %     % Eta Leak
% % %     sp3v81ft; 
% % %     AD.ATModel = 'sp3v81ft';
% % %     AD.OperationalMode = '3.0 GeV, Eta Leak';
% % %     ModeName = 'EtaLeak';
% % %     OpsFileExtension = '_EtaLeak';
% % %        
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 6
% % %     % Low Beta (2 meter)
% % %     sp3v81ft; 
% % %     AD.ATModel = 'sp3v81ft';
% % %     AD.OperationalMode = '3.0 GeV, Low Beta';
% % %     ModeName = ['LowBeta', filesep, '2meter'];
% % %     OpsFileExtension = '_2meter';
% % %         
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 7
% % %     % 2005 double waist test with no chicane
% % %     sp3v81fdw; 
% % %     AD.ATModel = 'sp3v81fdw';
% % %     AD.OperationalMode = '3.0 GeV, Double Waist, No Chicane';
% % %     ModeName = ['DoubleWaist05'];
% % %     OpsFileExtension = '';
% % %         
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 8
% % %     % 2005 double waist test with no chicane and no IDs
% % %     sp3v81fdw; 
% % %     AD.ATModel = 'sp3v81fdw';
% % %     AD.OperationalMode = '3.0 GeV, Double Waist, No Chicane, No Ids';
% % %     ModeName = ['DoubleWaist05IDsOpen'];
% % %     OpsFileExtension = '';
% % %         
% % %     switch2hw;
% % %     
% % % elseif ModeNumber == 9
% % %     % Low Alpha
% % %     % AT lattice
% % %     sp3v81fdw; 
% % %     AD.ATModel = 'sp3v81fdw';
% % %     AD.OperationalMode = 'Low Alpha';
% % %     ModeName = 'LowAlpha';
% % %     OpsFileExtension = '';
% % %     
% % %     switch2hw;


