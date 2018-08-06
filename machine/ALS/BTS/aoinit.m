function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path should not be modified in standalone mode
if isdeployed
    % Two ways to MML setup for standalone application
    
    % 1. Hard link at compile (-a <OpsData>GoldenMMLSetup.mat)
    loadmml('Golden');
    
    % 2. Allow changes to the MML setup even after a compile
    %    Note: Operational mode is being hardcoded with this method!!!  Best to move the default mode setup to this file (presently in btsinit)
    %if ispc
    %    loadmml('n:\machine\ALS\BTSOpsData\19INJ\GoldenMMLSetup.mat');
    %else
    %    loadmml('/home/als/physbase/machine/ALS/BTSOpsData/19INJ/GoldenMMLSetup.mat');
    %end
    
    % LabCA setup
    if strcmpi(getfamilydata('HCM','Monitor','Mode'),'Online')
        setlabcadefaults;
    end
    
else

    % Regular Matlab Session
    MMLROOT = getmmlroot('IgnoreTheAD');

    % Add users directories
    %CommonDirectory = fullfile(MMLROOT,'users','portmann','commands');
    %if exist(CommonDirectory) == 7
    %    addpath(CommonDirectory, '-begin');
    %end
    %CommonDirectory = fullfile(MMLROOT,'users','chris','commands');
    %if exist(CommonDirectory) == 7
    %    addpath(CommonDirectory, '-begin');
    %end

    % TCP & UDP library
    Directory = fullfile(MMLROOT, 'applications', 'tcp_udp_ip');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'tcp_udp_ip'), '-end');
    end

    % Add ALS/Booster (so I can change ramp tables)
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Booster'),'-begin');

    % Put the booster ring directory there as well
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Booster'),'-begin');

    % Put the storage ring directory there as well
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LegacyFiles'),'-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing'),'-begin');

    % Make sure mml is high on the path
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    % New BPM
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common', 'BPM'), '-begin');

    % Make the BTS first on the path
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common'), '-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'BTS'),'-begin');
    
    % Archive appliance (SLAC)
    Directory = fullfile(MMLROOT, 'applications', 'ArchiverAppliance');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'ArchiverAppliance'), '-end');
    end
end

btsinit;

