function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. '1.9   GeV Injection'
%               2. '1.23  GeV Injection
%               3. '1.522 GeV Injection
%             999. 'Greg's Mode'
%
%  See also aoinit, updateatindex, alsinit


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
    ModeCell = {'1.9 GeV Injection', '1.23 GeV Injection', '1.522 GeV Injection', 'Greg''s Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 4
        ModeNumber = 101;  % Model
    elseif ModeNumber == 5
        ModeNumber = 999;  % Greg
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'ALS';            % Will already be defined if setpathmml was used
AD.MachineType = 'Transport';  % Will already be defined if setpathmml was used
AD.SubMachine = 'BTS';         % Will already be defined if setpathmml was used
AD.OperationalMode = '';       % Gets filled in later
AD.HarmonicNumber = [];


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = 20.0;


% The offset and golden orbits are stored at the end of this file
BuildOffsetAndGoldenOrbits;  % Local function


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;


% Set the status of all the corrector on
% This is needed because some operational modes may have changed the .Status field
%setfamilydata(ones(size(family2dev('HCM',0),1),1),'HCM','Status');   Remove the HCM converted to skew quad before uncommenting this. 
%setfamilydata(ones(size(family2dev('VCM',0),1),1),'VCM','Status');

%i = findrowindex([3 10; 5 10; 10 10], HCMlist);
% i = findrowindex([5 10], HCMlist);
% AO.HCM.Status(i) = 0;
% i = findrowindex([10 10], HCMlist);
% AO.HCM.Status(i) = 0;

%i = findrowindex([3 10; 5 10; 10 10], VCMlist);
% i = findrowindex([5 10], VCMlist);
% AO.VCM.Status(i) = 0;
% i = findrowindex([10 10], VCMlist);
% AO.VCM.Status(i) = 0;



%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % 1.9 GeV Injection
    AD.OperationalMode = '1.9 GeV Injection';
    ModeName = '19INJ';
    OpsFileExtension = '_BTS';
    
    AD.Energy          = 1.89086196873342;  % make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    
    % AT lattice
    AD.ATModel = 'btslattice';
    btslattice(AD.Energy*1e9);
    
elseif ModeNumber == 2
    % 1.23 GeV Injection
    AD.OperationalMode = '1.23 GeV Injection';
    ModeName = '123INJ';
    OpsFileExtension = '_BTS';
    
    AD.Energy          = 1.23;  % make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.23;

    % AT lattice
    AD.ATModel = 'btslattice';
    btslattice(AD.Energy*1e9);
    
elseif ModeNumber == 3
    % 1.5 GeV Injection
    AD.OperationalMode = '1.5 GeV Injection';
    ModeName = '15INJ';
    OpsFileExtension = '_BTS';
    
    AD.Energy          = 1.522;  % make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;

    % AT lattice
    AD.ATModel = 'btslattice';
    btslattice(AD.Energy*1e9);

elseif 999
    
    % Greg's mode
    AD.OperationalMode = 'Greg''s BTS Mode';
    ModeName = 'Greg';
    OpsFileExtension = '_BTS';
    
    AD.Energy          = 1.89086196873342;  % make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;

    % AT lattice
    AD.ATModel = 'btslattice';
    btslattice(AD.Energy*1e9);
    
else
    
    % Test mode
    AD.OperationalMode = 'BTS Test Mode';
    ModeName = 'Test';
    OpsFileExtension = '_BTS';
    
    AD.Energy          = 1.89086196873342;  % make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;

    % AT lattice
    AD.ATModel = 'btslattice';
    btslattice(AD.Energy*1e9);
end


% Set MMLRoot to the standard local path when in standalone mode (must end in a file separator)
% Otherwise it will be set to someplace in the standalone directory location
if isdeployed
    if ispc
        AD.MMLRoot = 'N:\';
    else
        AD.MMLRoot = '/home/als/physbase/';
    end
end
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% ALS specific path changes

% Make the injection and production lattices the same
AD.OpsData.LatticeFile   = AD.OpsData.InjectionFile;

% Remove PhysDataFile
if isfield(AD.OpsData, 'PhysDataFile')
    AD.OpsData = rmfield(AD.OpsData, 'PhysDataFile');
end

% DataRoot Location
% This is a bit of a cluge to know if the user is on the ALS filer
% If so, the location of DataRoot will be different from the middle layer default
if isempty(findstr(lower(MMLROOT),'physbase')) && isempty(findstr(lower(MMLROOT),'n:\'))
    % Keep the normal middle layer directory structure and using the simulator
    OnlineFlag = 0;
    
else
    % Use MMLROOT and DataRoot on the ALS filer
    % If using the ALS filer, I'm assuming you want to be online
    OnlineFlag = 1; 

    if ispc
       %AD.Directory.DataRoot = ['m:\matlab\',                   AD.SubMachine, 'Data', filesep, ModeName, filesep];
        AD.Directory.DataRoot = ['\\als-filer\physdata\matlab\', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    elseif ismac
        AD.Directory.DataRoot = ['/Volumes/physdata/matlab/', AD.SubMachine, 'Data', filesep, ModeName, filesep];        
    else
        AD.Directory.DataRoot = ['/home/als/physdata/matlab/', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    end

    % Data Archive Directories
    AD.Directory.BPMData        = [AD.Directory.DataRoot, 'BPM', filesep];
    AD.Directory.TuneData       = [AD.Directory.DataRoot, 'Tune', filesep];
    AD.Directory.ChroData       = [AD.Directory.DataRoot, 'Chromaticity', filesep];
    AD.Directory.DispData       = [AD.Directory.DataRoot, 'Dispersion', filesep];
    AD.Directory.ConfigData     = [AD.Directory.DataRoot, 'MachineConfig', filesep];
    AD.Directory.LFBData        = [AD.Directory.DataRoot, 'LFB', filesep];
    AD.Directory.TFBData        = [AD.Directory.DataRoot, 'TFB', filesep];
    AD.Directory.THCData        = [AD.Directory.DataRoot, 'THC', filesep];
    AD.Directory.QMS            = [AD.Directory.DataRoot, 'QMS', filesep];

    % Response Matrix Directories
    AD.Directory.BPMResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'BPM', filesep];
    AD.Directory.TuneResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Tune', filesep];
    AD.Directory.ChroResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Chromaticity', filesep];
    AD.Directory.DispResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Dispersion', filesep];
    AD.Directory.SkewResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Skew', filesep];
end
setad(AD);


% This function runs at the end of setmachineconfig & getmachineconfig
AD.setmachineconfigfunction = @setmachineconfig_bts;
AD.getmachineconfigfunction = @setmachineconfig_bts;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Radiation
setradiation off;
fprintf('   Radiation is off.  Use setradiation to modify. \n'); 


% Momentum compaction factor
AD.MCF = getmcf('Model');
% if isnan(MCF)
%     AD.MCF = [];
%     fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
% else
%     AD.MCF = MCF;
%     fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
% end
setad(AD);


if OnlineFlag
    switch2online;
    
    % labca setup
    if islabca
        % Note: for some weird reason, for Matlab 2017b setlabcadefaults must be called after findorbit4(THERING,0) (like in getmcf)!!!???
        setlabcadefaults;
        
        % Time zone difference from UTC [hours]
        try
            % Best to base this on a PV
            AD.TimeZone = gettimezone('cmm:beam_current');
        catch
            AD.TimeZone = gettimezone;
            fprintf('  Time zone difference not based on a PV!\n');
            fprintf('  Set to %.1f hours from UTC.\n', AD.TimeZone);
        end
    else
        % MCA doesn't actually use it.
        AD.TimeZone = -8 + isdaylightsavings;
    end
else
    switch2sim;
    
    % Time zone difference from UTC [hours]
    AD.TimeZone = gettimezone;
end
setad(AD);


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if ModeNumber == 1
    % User mode - 1.9 GeV Injection
else
end



fprintf('   Middlelayer setup for BTS operational mode: %s\n', AD.OperationalMode);




function BuildOffsetAndGoldenOrbits
% x = getpv('BPM','X')
x = [
    2.3661
   -2.5353
    2.2257
    5.2408
   -1.3326
    4.2089];

% y = getpv('BPM','Y')
y = [
    0.5075
    1.0722
    1.3629
    4.0281
    2.3344
    1.9706];
    
Offset = [
    1   1   0   0 
    1   2   0   0 
    1   3   0   0 
    1   4   0   0 
    1   5   0   0 
    1   6   0   0 
];
Offset(:,3) = x;
Offset(:,4) = y;

Golden = [
    1   1   0   0 
    1   2   0   0 
    1   3   0   0 
    1   4   0   0 
    1   5   0   0 
    1   6   0   0 
];
Golden(:,3) = x;
Golden(:,4) = y;


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

AO.BPM.X.Offset = AO.BPMx.Offset;
AO.BPM.Y.Offset = AO.BPMy.Offset;


AO.BPM.X.Golden = AO.BPMx.Golden;
AO.BPM.Y.Golden = AO.BPMy.Golden;

setao(AO);
