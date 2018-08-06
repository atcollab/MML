function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Set all the variables associated with an operational mode
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 3.0 GeV, User Mode
%               2. 3.0 GeV, User Mode with Split Bend in the model
%               3. 3.0 GeV, Model
%
%  See also aoinit, updateatindex

global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'Commissioning Mode','User Mode', 'Model', 'Test'};
    [ModeNumber, OKFlag] = listdlg('Name','ASP','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;    
AD.Machine = 'ASP';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.0;
AD.InjectionEnergy = 3.0;
AD.HarmonicNumber = 360;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units) ???
AD.DeltaRFDisp = 2000/4;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000]/2;
AD.DeltaRFChro = [0:-500:-4000 -3500:500:0 500:500:4000 3500:-500:0];


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
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = 'asp';
if ModeNumber == 1
    % User mode
    AD.OperationalMode = '3.0 GeV, Prelim Commissioning Mode';
    ModeName = 'Comm';
    OpsFileExtension = '_Comm';
    
    % AT lattice
%     AD.ATModel = 'aspsr_msrf1cav';
%     aspsr_msrf1cav;
    AD.ATModel = 'assr4_splitbends';
    assr4_splitbends cavity4ring;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.  Setpv will wait
    % 2.2 * TuneDelay to be guaranteed a fresh data point.
    AD.TuneDelay = 2.5; 

    switch2online;
%     switch2sim; 
    switch2hw;

elseif ModeNumber == 2
    
    % User mode - Distributed Dispersion
    AD.OperationalMode = '3.0 GeV, Prelim User Mode';
    ModeName = 'CommUser';
    OpsFileExtension = '_CommUser';
    
    % AT lattice
%     AD.ATModel = 'aspsr_msrf1cav';
%     aspsr_msrf1cav;
    AD.ATModel = 'assr4_disp';
    assr4_disp cavity4ring;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.  Setpv will wait
    % 2.2 * TuneDelay to be guaranteed a fresh data point.
    AD.TuneDelay = 2.5; 

    switch2online;
%     switch2sim;
    switch2hw;
    
    
elseif ModeNumber == 3
    % Model mode
    AD.OperationalMode = '3.0 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
%     AD.ATModel = 'aspsr_msrf1cav';
%     aspsr_msrf1cav;
    AD.ATModel = 'assr4';
    assr4;

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.  Setpv will wait
    % 2.2 * TuneDelay to be guaranteed a fresh data point.
    AD.TuneDelay = 2.5;

    switch2sim;
    switch2hw;

elseif ModeNumber == 4
    % Model mode
    AD.OperationalMode = '3.0 GeV, test';
    ModeName = 'test';
    OpsFileExtension = '';
    
    % AT lattice
%     AD.ATModel = 'aspsr_msrf';
%     aspsr_msrf;
    AD.ATModel = 'assr4_id';
    assr4_wiggler;

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.29
        0.216
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.  Setpv will wait
    % 2.2 * TuneDelay to be guaranteed a fresh data point.
    AD.TuneDelay = 0;

    switch2sim;
    switch2hw;    
    
else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

%Application Programs WJC Sept 18, 2006
AD.Directory.Orbit = [MMLROOT, 'applications', filesep, 'orbit', filesep, 'asp', filesep];
AD.Directory.SOFB  = [MMLROOT, 'applications', filesep, 'SOFB', filesep];


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;
setradiation off;    
fprintf('   Radiation and Cavities are OFF. Use setcavity/setradiation to modify\n'); 

% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.0020;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


% Final mode changes
% Note: setlocogains was changed to setlocodata
if ModeNumber == 1
    % Commissionign Mode

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LOCOFilename?']);
    %setlocodata('LOCO2Model',[LocoFileDirectory,'LOCOFilename']);
    setlocodata('Nominal');

elseif ModeNumber == 2
    % User Mode
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    setsp('HCM', 0, 'Simulator', 'Physics');
    setsp('VCM', 0, 'Simulator', 'Physics');
    
elseif ModeNumber == 3
    % Model Mode
    setlocodata('Nominal');
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


% Change defaults for LabCA if using it
try
    if exist('lcaSetRetryCount','file')
        % read dummy pv to initialize labca
        % ChannelName = family2channel('BPMx');
        % lcaGet(family2channel(ChannelName(1,:));

        % Retry count
        RetryCountNew = 1000;  % Default: 599-old labca, 299-labca_2_1_beta
        RetryCount = lcaGetRetryCount;
        lcaSetRetryCount(RetryCountNew);
        if RetryCount ~= RetryCountNew
            fprintf('   Setting LabCA retry count to %d (was %d)\n', RetryCountNew, RetryCount);
        end

        % Timeout
        TimeoutNew = .005;  % Defaul: .05-old labca, .1-labca_2_1_beta
        Timeout = lcaGetTimeout;
        lcaSetTimeout(TimeoutNew);
        if abs(Timeout - TimeoutNew) > 1e-5
            fprintf('   Setting LabCA TimeOut to %f (was %f)\n', TimeoutNew, Timeout);
        end
            
        % To avoid UDF errors, set the WarnLevel to 4 (Default is 3)
        lcaSetSeverityWarnLevel(4);
        fprintf('   Setting lcaSetSeverityWarnLevel to 4 to avoid annoying UDF errors.\n');
    end
catch
    fprintf('   LabCA Timeout not set, need to run lcaSetRetryCount(1000), lcaSetTimeout(.01).\n');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);


