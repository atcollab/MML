function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)
%
%
%  See Also soleilinit, setpathsoleil, updateatindex, setoperationalmode

% Written by Laurent S. Nadolski

if exist('SubMachineName', 'var') && ~strcmpi(SubMachineName, 'StorageRing')
    error('Wrong SubMachine %s', SubMachineName)
end

% The path should not be modified in standalone mode
if ~isdeployed_local

    MMLROOT = getmmlroot;
    
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'common'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'bpm'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'quad'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'tune'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'feedforward'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'fonction_test'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'fonction_test','couplage'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'insertions'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'orbit'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRingOpsData'));
    
    % APPLICATIONS
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing', 'Lattices'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing','BBA'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing','steerette'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'StorageRing','energytunette'));        

    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    %disp(['TANGO/MATLAB binding version: ' tango_version])
    %disp('Startup file for Matlab Middle Layer read with success');

end

% Initialize the MML for machine

%soleilinit;

% When not at Soleil!
% soleilinit must be connected to tango
disp('   Initializing MML using GoldenMMLSetup (no server option)');
loadao('Golden');
%loadao('GoldenMMLSetup.mat');
setoperationalmode(1);
switch2sim;


function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2double(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

