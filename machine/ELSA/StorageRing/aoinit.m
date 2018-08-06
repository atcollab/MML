function aoinit(varargin)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


MMLROOT = getmmlroot('IgnoreTheAD');
addpath(fullfile(MMLROOT, 'machine', 'ELSA', 'StorageRing', 'Models'),'-begin');

    
%elsainit(varargin{:});
elsainit;
