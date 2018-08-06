function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)
%
%
%  See Also LT1init, setpathsoleil, setoperationalmode, updateatindex

% Written by Laurent S. Nadolski


if exist('SubMachineName', 'var') && ~strcmpi(SubMachineName, 'LT1')
    error('Wrong SubMachine %s', SubMachineName)
end

% The path should not be modified in standalone mode
if ~isdeployed_local

    MMLROOT = getmmlroot;
    
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT1OpsData'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT1'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'Lattices'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'fae'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT1', 'emittance'));

    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    disp(['TANGO/MATLAB binding version: ' tango_version])
    disp('Startup file for Matlab Middle Layer read with success');

end

% Initialize the MML for machine

LT1init;

function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2double(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

