function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 104 MeV, User Mode {Default}
%               2. 104 MeV, Model


global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'104 MeV, User Mode', '104 MeV, Model'};
    [ModeNumber, OKFlag] = listdlg('Name','Elettra: Preinjector-to-Booster','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 2
        ModeNumber = 2;  % Model
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'Elettra';     % Will already be defined if setpathmml was used
AD.SubMachine = 'PTB';      % Will already be defined if setpathmml was used
AD.MachineType = 'Transport';
AD.OperationalMode = '';      % Gets filled in later
AD.Energy = 0.104;
AD.InjectionEnergy = 0.104;
AD.HarmonicNumber = NaN;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = .1;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - string used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode - High Tune
    AD.OperationalMode = '104 MeV, User Mode';
    ModeName = 'User';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'ptblattice';
    ptblattice;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.7721 % ???
        1.7150
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

    % This is a bit of a cluge to know if the user is on the Elettra filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtPTB'))
        switch2sim;
    else
        switch2online;
    end
    
    switch2hw;

elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '104 MeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    AD.ATModel = 'ptblattice';
    ptblattice;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.7721 % ???
        1.7150
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

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


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Cavity and radiation
% setcavity off;
% setradiation off;
% fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n');


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = -0.399176680971;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end


setad(AD);
fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

