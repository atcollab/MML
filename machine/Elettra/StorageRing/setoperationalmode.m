function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber =  1. 1.0 GeV, User Mode {Default}
%              101. 1.0 GeV, Model


global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'1.0 GeV User Mode', '1.0 GeV Model'};
    [ModeNumber, OKFlag] = listdlg('Name','Elettra','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
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
AD.Machine = 'Elettra';           % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 1.0;
AD.InjectionEnergy = 1.0;
AD.HarmonicNumber = 432; 

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 200e-6;  % MHz
AD.DeltaRFChro = [-1000 -500 0 500 1000] * 1e-6;  % MHz


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = .1;  % ????  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - string used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode - High Tune
    AD.OperationalMode = '1.0 GeV, User Mode';
    ModeName = 'User';
    OpsFileExtension = '';
    
    % AT lattice
    AD.ATModel = 'mad2at_elettra';
    %mad2at_elettra;
    
    % Golden TUNE is with the TUNE family (14.3/8.2)
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        .3
        .2
        NaN];
    setao(AO);
       
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.2; .2];
    
    % This is a bit of a cluge to know if the user is on the Elettra filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'/Elettra???/'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;
     
elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = '1.0 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';
    
    % AT lattice
    AD.ATModel = 'mad2at_elettra';
    %mad2at_elettra;
    
    % Golden TUNE is with the TUNE family (14.3/8.2)
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        .3
        .2
        NaN];
    setao(AO);
       
    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.2; .2];

    AD.TuneDelay = 0.0;
    switch2hw;
    switch2sim;
       
else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

AD.Circumference = findspos(THERING,length(THERING)+1);


% Time zone difference from UTC [hours]
AD.TimeZone = gettimezone;


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
    AD.MCF = 0.00181;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);



% Final mode changes
if ModeNumber == 1
    % User mode

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    setlocodata('Nominal');
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LocoData']);

    
    % Add the golden orbit and offset orbit in the MML  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    setfamilydata(0, 'BPMx', 'Offset');
    setfamilydata(0, 'BPMy', 'Offset');
    setfamilydata(0, 'BPMx', 'Golden');
    setfamilydata(0, 'BPMy', 'Golden');

elseif ModeNumber == 101
    % Model
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    setsp('HCM', 0, 'Simulator', 'Physics');
    setsp('VCM', 0, 'Simulator', 'Physics');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
