function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  Mode = 1. 2.80 Gev, User Mode
%         2. 2.80 Gev, Test Mode
%


global THERING


% Check if the AO exists
checkforao;


if nargin < 1
    ModeCell = {'2.8 Gev, User Mode', '2.8 Gev, Test Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','X-Ray','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load AcceleratorData structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'XRay';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy          = 2.8;  % GeV
AD.InjectionEnergy = 0.743;  % GeV
AD.HarmonicNumber = 30;


% Defaults RF changes for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000*1e-6;
AD.DeltaRFChro = [-500 250 0 250 500]*1e-6;



% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.TuneDelay = 30.0;  % the scan rate is 30 sec/plane



%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - string used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode
    AD.OperationalMode = '2.8 GeV, User Mode';
    ModeName = 'user';
    OpsFileExtension = '';

    % AT lattice
    xrayatlat;
    AD.ATModel = 'xrayatlat';

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1.0; -0.5];

    % Golden Tune
    AO = getao;
    AO.TUNE.Golden = [
        0.8696
        0.6966
        NaN];
    setao(AO);

    % This is a bit of a cluge to know if the user is on the BNL filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtBNL'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;
    
elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '2.8 GeV, Test Mode';
    ModeName = 'Model';
    OpsFileExtension = '_Model';
    
    % AT lattice
    xrayatlat;
    AD.ATModel = 'xrayatlat';

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1.0; -0.5];

    % Golden Tune
    AO = getao;
    AO.TUNE.Golden = [
        0.8696
        0.6966
        NaN];
    setao(AO);

    switch2hw;
    switch2sim;

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


MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.004;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (determined by the initial AT model)\n', AD.MCF);
end

setad(AD);



% I usually put a LocoData.mat file in the same location as xrayphysdata.mat
% This file is a LOCO run with a good set of BPM and Corrector gains/coupling
% LocoFileDirectory = getfamilydata('OpsData','PhysDataFile');
% i = findstr(LocoFileDirectory, filesep);
% setlocodata([LocoFileDirectory(1:i(end)),'LocoData']);

% Set BPM and Corrector gains and coupling
setlocodata('Nominal');



fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);



