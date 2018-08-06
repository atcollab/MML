function setoperationalmode(ModeNumber)
%  setoperationalmode(ModeNumber)
%
%  This function is used to set the path and model for a particular operational mode.
%  NOTE: This function assumes that the AO has already setup with spear3init
%
%  INPUTS
%  ModeNumber = 1 CDR Optics - User mode
%               2 CDR Optics - Model
%               3 CDR Optics - IDs open
%               4 CDR Optics - Sextupoles off
%               5 CDR Optics - Eta leak
%               6 Low Beta (2 meter)
%               7 Double Waist - Nominal Configuration
%               8 Double Waist - Nominal Configuration/ID's Open
%               9 Double Waist - Low Alpha
%              50 Old MiddleLayer
%  
%  Written by Greg Portmann
%  updated by Jeff Corbett


global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'User Mode', 'Model', 'IDs Open', 'Sextupoles Off', 'Eta Leak', 'Low Beta','Double Waist','Old Middle Layer'};
    ModeCell = {'User Mode', 'Low Emittance', 'Low Alpha' };
        [ModeNumber, OKFlag] = listdlg('Name','Spear','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
        if OKFlag ~= 1
            fprintf('   Operational mode not changed\n');
            return
        end
        
        
%%%%%  IMPORTANT RE-ROUTINING CONDITIONS  %%%%%%%%%       
       if ModeNumber == 2  %Eta Leak
           ModeNumber = 10;
       elseif ModeNumber == 3  %Low Alpha
           ModeNumber = 11;
       end
end


%%%%%%%%%%%%%%%%%%%%
% Accelerator Data %
%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'SPEAR3';
AD.SubMachine = 'StorageRing';
AD.MachineType = 'StorageRing';
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.0;  % GeV    
AD.InjectionEnergy = 3.0;  % GeV
AD.HarmonicNumber = 372;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-1000 -500 0 500 1000]*1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = 0.0;  


% Golden TUNE is with the TUNE family (it could be in the AD)
AO = getao;    
AO.TUNE.Monitor.Golden = [
    0.1900
    0.2300
    NaN];
setao(AO);    


% Golden chromaticity is in the AD (Physics units)
AD.Chromaticity.Golden = [1; 1];   % approx.  [-1.8;-1.8] in hardware units


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

if ModeNumber == 0
    % Development Lattice
    % AT lattice
    DirectoryName = 'R:\Controls\matlab\applications\lattices\';
    [FileName, DirectoryName] = uigetfile('*.m', 'Select an AT Deck to load', DirectoryName);
    AD.ATModel = FileName;
    FileName = [DirectoryName FileName];
    disp(['   AT Deck selected for development lattice: ' FileName])
    run(FileName);
    AD.OperationalMode = 'Development Lattice';
    ModeName = 'Development';
    OpsFileExtension = '';
    
    switch2hw;

elseif ModeNumber == 1
    % User mode
    % AT lattice
    sp3v82; 
    AD.ATModel = 'sp3v82';
    AD.OperationalMode = '3.0 GeV, User Mode';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel])
    ModeName = 'User';
    OpsFileExtension = '';
    
    switch2hw;
    
% elseif ModeNumber == 2
%     % Model 
%     sp3v81ft; 
%     AD.ATModel = 'sp3v81ft';
%     AD.OperationalMode = '3.0 GeV, Model';
%     ModeName = 'Model';
%     OpsFileExtension = '_Model';
%     
%     switch2hw;
%     
% elseif ModeNumber == 3
%     % ID's open 
%     sp3v81ft; 
%     AD.ATModel = 'sp3v81ft';
%     AD.OperationalMode = '3.0 GeV, ID''s Open';
%     ModeName = 'IDsOpen';
%     OpsFileExtension = '_IDsOpen';
%     
%     switch2hw;
%     
% elseif ModeNumber == 4
%     % Sextupoles Off
%     sp3v81ft; 
%     AD.ATModel = 'sp3v81ft';
%     AD.OperationalMode = '3.0 GeV, Sextupoles Off';
%     ModeName = 'SextupolesOff';
%     OpsFileExtension = '_SextupolesOff';
%     
%     switch2hw;
%     
% elseif ModeNumber == 5
%     % Eta Leak
%     sp3v81ft; 
%     AD.ATModel = 'sp3v81ft';
%     AD.OperationalMode = '3.0 GeV, Eta Leak';
%     ModeName = 'EtaLeak';
%     OpsFileExtension = '_EtaLeak';
%        
%     switch2hw;
%     
% elseif ModeNumber == 6
%     % Low Beta (2 meter)
%     sp3v81ft; 
%     AD.ATModel = 'sp3v81ft';
%     AD.OperationalMode = '3.0 GeV, Low Beta';
%     ModeName = ['LowBeta', filesep, '2meter'];
%     OpsFileExtension = '_2meter';
%         
%     switch2hw;
%     
% elseif ModeNumber == 7
%     % 2005 double waist test with no chicane
%     sp3v81fdw; 
%     AD.ATModel = 'sp3v81fdw';
%     AD.OperationalMode = '3.0 GeV, Double Waist, No Chicane';
%     ModeName = ['DoubleWaist05'];
%     OpsFileExtension = '';
%         
%     switch2hw;
%     
% elseif ModeNumber == 8
%     % 2005 double waist test with no chicane and no IDs
%     sp3v81fdw; 
%     AD.ATModel = 'sp3v81fdw';
%     AD.OperationalMode = '3.0 GeV, Double Waist, No Chicane, No Ids';
%     ModeName = ['DoubleWaist05IDsOpen'];
%     OpsFileExtension = '';
%         
%     switch2hw;
%     
% elseif ModeNumber == 9
%     % Low Alpha
%     % AT lattice
%     sp3v81fdw; 
%     AD.ATModel = 'sp3v81fdw';
%     AD.OperationalMode = 'Low Alpha';
%     ModeName = 'LowAlpha';
%     OpsFileExtension = '';
%     
%     switch2hw;

elseif ModeNumber == 10
    %eta leak with chicane (12/11/2006)
    sp3v82_leps; 
    AD.ATModel = 'sp3v82_leps';
    AD.OperationalMode = '3.0 GeV, Eta Leak with Chicane';
    ModeName = 'EtaLeak_CD';
    OpsFileExtension = '_EtaLeak_CD';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel])
    switch2hw;
    
elseif ModeNumber == 11
    %low alpha with chicane (12/11/2006)
  
    sp3v82_la; 
    AD.ATModel = 'sp3v82_la';
    AD.OperationalMode = '3.0 GeV, Low Alpha with Chicane';
    ModeName = 'LowAlpha_CD';
    OpsFileExtension = '_LowAlpha_CD';
    disp(['   MATLAB Middlelayer switching to mode ' AD.OperationalMode ' with AT Deck ' AD.ATModel])
    
    switch2hw;
    
elseif ModeNumber == 50
    % Old AT lattice
    % sp3v81fSept;
    % AD.ATModel = 'sp3v81fSept';
    sp3v81ft;
    AD.ATModel = 'sp3v81ft';
    AD.OperationalMode = 'SP3V81FT with 112 BPM';
    ModeName = 'SP3V81FT_112BPM';
    OpsFileExtension = '';
    
    switch2hw;
        
else
    error('Operational mode unknown');
end


% Set the AD directory path with the default MML settings
setad(AD);
% You can't use AD.Machine because it's "SPEAR", ie, not the directory name
%MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
MMLROOT = setmmldirectories('SPEAR3', AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% This is a bit of a cluge to know if the user is on the Spear3 filer
% If so, the location of DataRoot will be different from the middle layer default
if ~isempty(findstr(lower(MMLROOT),'y:\controls')) || ~isempty(findstr(lower(MMLROOT),'r:\controls'))
    % If using the Spear3 filer, I'm assuming you want to be online
    switch2online;

    AD.Directory.Lattice  = [MMLROOT, 'applications', filesep, 'lattices', filesep, 'spear3'];
    AD.Directory.Orbit    = [MMLROOT, 'applications', filesep, 'orbit',    filesep, 'spear3'];
    AD.Directory.SOFB     = [MMLROOT, 'applications', filesep, 'sofb',     filesep, 'spear3'];

else
    % If not using the Spear3 filer, I'm assuming you want to be simulating
    switch2sim;

    % HCMCurrReference & VCMCurrReference are be simulated at the moment
    AO = getao;
    AO.HCMCurrReference.MemberOf = {};
    AO.VCMCurrReference.MemberOf = {};
    setao(AO);

    AD.Directory.Lattice  = [MMLROOT, 'machine', filesep, 'Spear3', filesep, 'Applications', filesep, 'lattices', filesep, 'spear3'];
    AD.Directory.Orbit    = [MMLROOT, 'machine', filesep, 'Spear3', filesep, 'Applications', filesep, 'orbit',    filesep, 'spear3'];
    AD.Directory.SOFB     = [MMLROOT, 'machine', filesep, 'Spear3', filesep, 'Applications', filesep, 'sofb',     filesep, 'spear3'];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spear only application parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chicane response files
AD.Default.ChicaneRespFile  = 'ChicaneRespMat'; % File in AD.Directory.BPMResponse    BPM/Chicane response matrice
AD.OpsData.ChicaneRespFile = ['GoldenChicaneResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.ChicaneRespFile]};

AD.Default.ScraperArchiveFile = 'Scraper';   
AD.Directory.ScraperData = [AD.Directory.DataRoot 'Scraper', filesep];
AD.Directory.GoldenConfigFiles = [MMLROOT, 'machine', filesep, 'Spear3', filesep, 'StorageRingOpsData', filesep, 'Configurations', filesep];

AD.Directory.BTS           = [AD.Directory.DataRoot 'BTS',       filesep];
AD.Directory.BumpData      = [AD.Directory.DataRoot 'Bumps',     filesep];
AD.Directory.InterlockData = [AD.Directory.DataRoot 'Interlock', filesep];
AD.Directory.SkewResponse  = [AD.Directory.DataRoot 'Response',  filesep, 'Skew', filesep];

% Add beamline files
AD.Directory.BLData        = [AD.Directory.DataRoot 'Beamline', filesep];
AD.Directory.BLResponse    = [AD.Directory.DataRoot 'Response', filesep, 'Beamline', filesep];
AD.Default.BLArchiveFile = 'BL';           % file in AD.Directory.BL            beamline data
AD.Default.BLRespFile    = 'BLRespMat';    % file in AD.Directory.BLResponse    photon BPM response matrices
AD.OpsData.BLRespFile    = ['GoldenBLResp', OpsFileExtension];
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


% Updates the AT indices in the MiddleLayer with the present AT lattice
setad(AD);
updateatindex;
AD = getad;   

% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
%AD.Circumference = 2.341440127200002e+002;


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
    fprintf('   Middlelayer alpha set to %f (determined by the initial AT model)\n', AD.MCF);
end
setad(AD);


% Final mode changes
if ModeNumber < 100
    setlocodata('Defaults');  % ???
    
    %% I put a LocoData.mat file in the same location as spear3physdata.mat
    %% This file is a LOCO run with a good set of BPM and Corrector gains/coupling
    %  LocoFileDirectory = getfamilydata('OpsData','PhysDataFile');
    %  i = findstr(LocoFileDirectory, filesep);
    %  setlocodata([LocoFileDirectory(1:i(end)),'LocoData']);
    %  fprintf('   Loaded gains from LOCO file: %s\n', [LocoFileDirectory(1:i(end)),'LocoData.mat']);
    
elseif ModeNumber == 101
    % Model
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    setsp('HCM', 0, 'Simulator', 'Physics');
    setsp('VCM', 0, 'Simulator', 'Physics');
    setfamilydata(0,'TuneDelay');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

