function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% Just for debug
%system('path')


% The path should not be modified in standalone mode
if isdeployed_local
    % Two ways to MML setup for standalone application
    
    % Initialize the MML
    alsinit;

%     % 1. Hard link at compile (-a <OpsData>GoldenMMLSetup.mat)
%     loadmml('Golden');
%     
%     % 2. Allow changes to the MML setup even after a compile
%     % if ispc
%     %     loadmml('n:\machine\ALS\StorageRingOpsData\TopOff\GoldenMMLSetup.mat');
%     % else
%     %     loadmml('/home/als/physbase/machine/ALS/StorageRingOpsData/TopOff/GoldenMMLSetup.mat');
%     % end
%         
%     % Note: 1. Operational mode is being hardcoded with this method!!!
%     %       2. It might be better to run setoperationalmode???  About 2.5 seconds.
%     %       3. Best to move the default mode setup to this file (presently in alsinit)
% 
%     % LabCA setup (added here if setoperationmode is not run)
%     if strcmpi(getfamilydata('BPMx','Monitor','Mode'),'Online')
%         setlabcadefaults;
%     end
%     
%     % Time zone difference from UTC [hours]
%     try
%         % Best to base this on a PV
%         AD.TimeZone = gettimezone('cmm:beam_current');
%     catch
%         AD.TimeZone = gettimezone;
%         fprintf('  Time zone difference not based on a PV!\n');
%         fprintf('  Set to %.1f hours from UTC.\n', AD.TimeZone);
%     end
    
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
        
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LegacyFiles'),'-begin');      % Add LegacyFiles then put ALS first on the path
    %addpath(fullfile(MMLROOT, 'machine', 'ALS', 'BTS'),'-begin');                            % Add ALS/BTS
    %addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Booster'),'-begin');                        % Add ALS/Booster
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common', 'BPM'), '-begin');                  % BPM Functions
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LFB', 'iGpTools'),'-begin');  % LFB
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'Lattices'),'-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common'), '-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing'),'-begin');

    % Christoph's Files
    Directory = fullfile(MMLROOT, 'matlab', 'chris','commands');
    if exist(Directory, 'dir')
        addpath(Directory, '-end');
    end

    % Archiver appliance (SLAC)
    Directory = fullfile(MMLROOT, 'applications', 'ArchiverAppliance');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'ArchiverAppliance'), '-end');
    end
    
    % Initialize the MML
    alsinit;
end



function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

