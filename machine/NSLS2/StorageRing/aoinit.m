function aoinit(varargin)
%AOINIT - Initialization function for the Matlab Middle Layer for the NSLS-II storage ring


% The path should not be modified in standalone mode
if ~isdeployed

    % Regular Matlab Session
    MMLROOT = getmmlroot('IgnoreTheAD');
    
    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    % Add the lattice
    addpath(fullfile(MMLROOT, 'machine', 'NSLS2', 'StorageRing', 'Lattices'),'-begin');

    % Add unit conversion
    addpath(fullfile(MMLROOT, 'machine', 'NSLS2', 'StorageRing', 'Unitconversion'),'-begin');

    % Make the storage ring is first on the path
    addpath(fullfile(MMLROOT, 'machine', 'NSLS2', 'StorageRing'),'-begin');

    nsls2init(varargin{:});
end


