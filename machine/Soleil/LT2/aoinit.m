function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)
%
%
%  See Also soleilinit, setpathsoleil 

% Written by Laurent S. Nadolski


if exist('SubMachineName', 'var') && ~strcmpi(SubMachineName, 'LT2')
    error('Wrong SubMachine %s', SubMachineName)
end

% The path should not be modified in standalone mode
if ~isdeployed_local

    MMLROOT = getmmlroot;
    
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT2OpsData'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT2'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT2', 'Lattices'));
    %addpath(fullfile(cdappli, 'LT1'));
    addpath(fullfile(MMLROOT, 'machine', 'Soleil', 'LT2', 'emittance'));

    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    disp(['TANGO/MATLAB binding version: ' tango_version])
    disp('Startup file for Matlab Middle Layer read with success');

end

% Initialize the MML for machine

LT2init;

function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2double(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end
