function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber =   1. '100 MeV'
%               101. 'Model'
%               999. 'Test'
%
%  See also aoinit, updateatindex


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
    ModeCell = {'100 MeV Injection', 'Model', 'Test'};
    [ModeNumber, OKFlag] = listdlg('Name','NSLS-II','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 2
        ModeNumber = 101;  % Model
    elseif ModeNumber == 3
        ModeNumber = 999;  % Test
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'NSLS2';          % Will already be defined if setpathmml was used
AD.SubMachine = 'LTB';         % Will already be defined if setpathmml was used
AD.MachineType = 'Transport';  % Will already be defined if setpathmml was used
AD.OperationalMode = '';       % Gets filled in later
AD.HarmonicNumber = [];


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = 0.0;  % ???


% The offset and golden orbits are stored at the end of this file
%BuildOffsetAndGoldenOrbits;  % Local function


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
MachineName = lower(AD.Machine);

AD.Energy          = .2;  % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = .2;

% AT lattice
AD.ATModel = 'nsls2ltb';
nsls2ltb(AD.Energy*1e9);

if ModeNumber == 1
    % 200 MeV Injection
    AD.OperationalMode = '200 MeV';
    ModeName = '50MEV';
    OpsFileExtension = '_LTB';
        
elseif 101
    
    % Model mode
    AD.OperationalMode = 'Model LTB Mode';
    ModeName = 'Model';
    OpsFileExtension = '_LTB';

elseif 999
    
    % Test mode
    AD.OperationalMode = 'Test LTB Mode';
    ModeName = 'Test';
    OpsFileExtension = '_LTB';
        
else
    error('Unknown operational mode.');
end



% Set MMLRoot to the standard local path when in standalone mode (must end in a file separator)
% Otherwise it will be set to someplace in the standalone directory location
if isdeployed
    if ispc
        AD.MMLRoot = '?:\???';
    else
        AD.MMLRoot = '/???';
    end
end
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% NSLS-II specific path changes

% Make the injection and production lattices the same
AD.OpsData.LatticeFile = AD.OpsData.InjectionFile;

% Remove PhysDataFile
if isfield(AD.OpsData, 'PhysDataFile')
    AD.OpsData = rmfield(AD.OpsData, 'PhysDataFile');
end

% DataRoot Location
% This is a bit of a cluge to know if the user is on the NSLS-II file system or say a laptop
% If so, the location of DataRoot will be different from the middle layer default
if isempty(findstr(lower(MMLROOT),'physbase')) && isempty(findstr(lower(MMLROOT),'n:\'))
    % Keep the normal middle layer directory structure
    switch2sim;
    
else
    % Use MMLROOT and DataRoot on the NSLS-II filer
    if strcmp(computer,'PCWIN') == 1
        AD.Directory.DataRoot = ['\\???', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    else
        AD.Directory.DataRoot = ['/???/', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    end
    
    % Data Archive Directories
    AD.Directory.BPMData        = [AD.Directory.DataRoot 'BPM', filesep];
    AD.Directory.TuneData       = [AD.Directory.DataRoot 'Tune', filesep];
    AD.Directory.ChroData       = [AD.Directory.DataRoot 'Chromaticity', filesep];
    AD.Directory.DispData       = [AD.Directory.DataRoot 'Dispersion', filesep];
    AD.Directory.ConfigData     = [AD.Directory.DataRoot 'MachineConfig', filesep];
    
    % Response Matrix Directories
    AD.Directory.BPMResponse    = [AD.Directory.DataRoot 'Response', filesep, 'BPM', filesep];
    AD.Directory.TuneResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Tune', filesep];
    AD.Directory.ChroResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Chromaticity', filesep];
    AD.Directory.DispResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Dispersion', filesep];
    AD.Directory.SkewResponse   = [AD.Directory.DataRoot 'Response', filesep, 'Skew', filesep];
    
    % If using the NSLS-II filer, I'm assuming you want to be online
    switch2online;
    
    % labca setup
    setlabcadefaults;
end


% This function runs at the end of setmachineconfig & getmachineconfig
%AD.setmachineconfigfunction = @setmachineconfig_ltb;
%AD.getmachineconfigfunction = @setmachineconfig_ltb;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Radiation
%setradiation off;
%fprintf('   Radiation is off.  Use setradiation to modify. \n'); 


% Add Gain & Offsets for magnet family
% try
%     setgainsandoffsets;
%     fprintf('   BEND, Quadrupole, HCM, and VCM gains.\n');
% catch
%     fprintf('   Error setting BEND, Quadrupole, HCM, and VCM gains.\n');
% end


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = -0.144918378375109;
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
    % User mode - 50 MeV
else
end



fprintf('   Middlelayer setup for LTB operational mode: %s\n', AD.OperationalMode);




function BuildOffsetAndGoldenOrbits

Offset = [
    1   1   0   0 
    1   2   0   0 
   %1   3   0   0 
   %2   1   0   0 
    2   2   0   0 
    3   1   0   0 
    3   2   0   0 
   %3   3   0   0 
    3   4   0   0 
    3   5   0   0 
    3   6   0   0 
    3   7   0   0 
];


Golden = [
    1   1   0   0 
    1   2   0   0 
   %1   3   0   0 
   %2   1   0   0 
    2   2   0   0 
    3   1   0   0 
    3   2   0   0 
   %3   3   0   0 
    3   4   0   0 
    3   5   0   0 
    3   6   0   0 
    3   7   0   0 
];


% Save the data
AO = getao;


% Offset orbits
[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Offset = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Offset(i) = Offset(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Offset = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Offset(i) = Offset(iFoundList,4);


% Golden orbits
[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Golden = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Golden(i) = Golden(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Golden = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Golden(i) = Golden(iFoundList,4);

setao(AO);
