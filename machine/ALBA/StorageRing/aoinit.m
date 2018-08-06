function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)
%
%
%  See Also albainit, setpathalba, updateatindex, setoperationalmode

% Written by Laurent S. Nadolski

if exist('SubMachineName', 'var') && ~strcmpi(SubMachineName, SubMachineName)
    error('Wrong SubMachine %s', SubMachineName)
end

% The path should not be modified in standalone mode
if ~isdeployed_local

    MMLROOT = getmmlroot;
    
    addpath(fullfile(MMLROOT, 'machine', 'ALBA', SubMachineName));
    addpath(fullfile(MMLROOT, 'machine', 'ALBA', SubMachineName, 'orbit'));
    addpath(fullfile(MMLROOT, 'machine', 'ALBA', SubMachineName, 'loco'));
    addpath(fullfile(MMLROOT, 'machine', 'ALBA', [SubMachineName 'OpsData']));
    
    % APPLICATIONS
    addpath(fullfile(MMLROOT, 'machine', 'ALBA', SubMachineName, 'Lattices'));
    addpath(fullfile(MMLROOT, 'applications', 'orbit')); % Jeff appli
    addpath(fullfile(MMLROOT, 'applications', 'orbit', 'lib')); % Jeff appli
        

    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

%    disp(['   TANGO/MATLAB binding version: ' tango_version])
    disp('   Startup file for Matlab Middle Layer read with success');

end

% Initialize the MML for machine

albainit;

function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2double(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

