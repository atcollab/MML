function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path should not be modified in standalone mode
if ~isdeployed

    % Regular Matlab Session
    MMLROOT = getmmlroot('IgnoreTheAD');
    
    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    % Make the LTB first on the path
    addpath(fullfile(MMLROOT, 'machine', 'NSLS2', 'LTB'),'-begin');
end

ltbinit;

