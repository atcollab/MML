function aoinit(varargin)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path does not needs to be set in Standalone mode
if ~isdeployed
    MMLROOT = getmmlroot('IgnoreTheAD');
    
    % Put Gun at the end.  Needed for LLRF stuff.
    addpath(fullfile(MMLROOT, 'machine', 'APEX', 'Gun'),'-end');

    addpath(fullfile(MMLROOT, 'machine', 'APEX', 'Gun', 'ImageProcessing'),'-end');

    % BPMs
    addpath(fullfile(MMLROOT, 'machine', 'APEX', 'Common', 'BPM'), '-end');

    % Archiver
    addpath(fullfile(MMLROOT, 'applications', 'ArchiverAppliance'), '-end');
end
uedinit;
