function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path does not needs to be set in Standalone mode
if ~isdeployed_local

    MMLROOT = getmmlroot;


    % Add users directories
    %CommonDirectory = fullfile(MMLROOT,'users','portmann','commands');
    %if exist(CommonDirectory) == 7
    %    addpath(CommonDirectory, '-begin');
    %end

    % mca (since some people use mca directly)
    %addpath(fullfile(MMLROOT, 'links', 'mca_asp'));

    % orbit
    addpath(fullfile(MMLROOT, 'applications', 'orbit'), '-begin');
    addpath(fullfile(MMLROOT, 'applications', 'orbit', 'asp'), '-begin');
    addpath(fullfile(MMLROOT, 'applications', 'orbit', 'lib'), '-begin');

    % SOFB
    %addpath(fullfile(MMLROOT, 'applications', 'SOFB'), '-begin');

    % Add magnet_calibration_curves
    addpath(fullfile(MMLROOT, 'machine', 'ASP', 'StorageRing', 'magnet_calibration_curves'),'-begin');

    % Magnet cycling directory
    addpath(fullfile(MMLROOT, 'machine', 'ASP', 'StorageRing', 'magnetcycling'),'-begin');

    % BPM scripts
    %addpath(fullfile(MMLROOT, 'machine', 'ASP', 'StorageRing', 'bpm_scripts'),'-begin');

    % Add measurements directory
    %dirs = {'beamsize','betas','emittance','iccd','ltb','screens','stability','streakcamera','tunes'};
    %for i=1:length(dirs)
    %    addpath(fullfile([filesep 'asp'],'usr','measurements',dirs{i}),'-begin');
    %end

    % Make ASP first on the path
    addpath(fullfile(MMLROOT, 'machine', 'ASP', 'StorageRing'),'-begin');

end


% Initialize
aspinit;





function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end
