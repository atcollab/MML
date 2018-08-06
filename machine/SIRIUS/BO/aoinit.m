function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)

% LNLS updated version of MML and AT files
MMLROOT = getmmlroot('IgnoreTheAD');
Directory = fullfile(MMLROOT, 'lnls', 'at-mml_modified_scripts');
if exist(Directory, 'dir')
    addpath(Directory, '-begin');
    addpath(fullfile(MMLROOT, 'machine', 'SIRIUS', 'common'), '-begin');
end
    
% set operational mode to low energy by default.
OperationalMode = 2;

sirius_booster_init;
setoperationalmode(OperationalMode);


