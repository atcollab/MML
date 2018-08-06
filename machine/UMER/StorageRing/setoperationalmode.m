function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  See also aoinit, updateatindex, mlsinit

% to do
% 1. golden chro?
% 2. hw2physics converstions
% 3. channel names
% 4. tolerances


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
    %ModeNumber = 1;
    ModeCell = {'UMER Operations', 'UMER Model'};
    [ModeNumber, OKFlag] = listdlg('Name','UMER','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
       fprintf('   Operational mode not changed\n');
       return
    end
    if ModeNumber == 2
       ModeNumber = 101;  % Model
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'UMER';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.MachineType = 'StorageRing';   % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 0.105;                % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = 0.105;
AD.HarmonicNumber = 80;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-3;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-3;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
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
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = lower(AD.Machine);
if ModeNumber == 1
    % User mode
    AD.OperationalMode = 'UMER';
    ModeName = 'User';
    OpsFileExtension = '_UMER';

    % AT lattice
    AD.ATModel = 'umeratlattice';
    umeratlattice;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.8130
        0.6117
        NaN];
    setao(AO);
    
    % Golden chromaticity is in the AD (must be in Physics units!)
    AD.Chromaticity.Golden = [.5; .5];  % ???
    
    % Server location
    %AD.server = 'http://192.168.1.3:8000/';
    AD.server = 'http://127.0.0.1:8000/';
    fprintf(['   Using server located at: ',AD.server,'\n'])
    
    % MagnetSetpoints
    AD.magnetSetpointsfile = 'kiersten_6mA_170712.csv';
    fprintf(['   Using magnet settings in: ',AD.magnetSetpointsfile,'\n'])

    % BPM scope settings
    % init scopes
    disp(['** Initializing bpm scope **'])
    try
        AD.scope = initialize_scope;
        disp(['OK, use ''getad'' to find scope object'])
    catch
        warning 'Scope could not be loaded'
    end
    disp(['** Initializing wcm scope **'])
    try
        AD.wcm = initialize_wcm;
        disp(['OK, use ''getad'' to find wcm object'])
    catch
        warning 'scope could not be loaded'
    end
    % define constants
    AD.scope_var = [160,160,20]; % t_o t_oo and window
    AD.rev_time = 197.39; % in ns    
    
    % This is a bit of a cluge to know if the user is on the UMER filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    %if isempty(findstr(lower(MMLROOT),'matlabmiddlelayer'))
    %    switch2sim;
    %else
    %    switch2online;
    %end
    
    switch2hw;

elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = 'UMER-Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    AD.ATModel = 'umeratlattice';
    umeratlattice;

    % Golden TUNE is with the TUNE family???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.8130
        0.6117
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (must be in Physics units!)
    AD.Chromaticity.Golden = [.5; .5];  % ???

    switch2hw;
    switch2sim;
else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

% Add some extra data directories
% is there a better way to add folders without changing setmmldirectories?
AD.Directory.EarthFieldData = [AD.Directory.OpsData,'EarthField',filesep];

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
    AD.MCF = 0.035089062542878;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


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
        % I typically store the LOCO file in the StorageRingOpsData directory
        LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_User'];
        setlocodata('Nominal');
        %setlocodata('SetGains',   LOCOFile);
        %setlocodata('SetModel',   LOCOFile);
        %setlocodata('LOCO2Model', LOCOFile);
    catch
        fprintf('   Problem with setting the LOCO calibration.\n');
    end
    
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
    setfamilydata(0,'TuneDelay');
    
elseif ModeNumber == 101
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
    setfamilydata(0,'TuneDelay');
else
    setlocodata('Nominal');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

