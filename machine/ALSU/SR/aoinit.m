function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path should not be modified in standalone mode
if isdeployed_local
    % Two ways to MML setup for standalone application
    
    % Initialize the MML
    alsuinit;

%     % 1. Hard link at compile (-a <OpsData>GoldenMMLSetup.mat)
%     loadmml('Golden');
%     
%     % 2. Allow changes to the MML setup even after a compile
%     % if ispc
%     %     loadmml('n:\machine\ALSU\StorageRingOpsData\TopOff\GoldenMMLSetup.mat');
%     % else
%     %     loadmml('/home/als/physbase/machine/ALSU/StorageRingOpsData/TopOff/GoldenMMLSetup.mat');
%     % end
%         
%     % Note: 1. Operational mode is being hardcoded with this method!!!
%     %       2. It might be better to run setoperationalmode???  About 2.5 seconds.
%     %       3. Best to move the default mode setup to this file (presently in alsuinit)
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
    
    % Add ALSU/BTS
    %addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'BTS'),'-begin');

    % TCP & UDP library
    %Directory = fullfile(MMLROOT, 'applications', 'tcp_udp_ip');
    %if exist(Directory, 'dir')
    %    addpath(fullfile(MMLROOT, 'applications', 'tcp_udp_ip'), '-end');
    %end
    
    % Add ALSU/Booster
    %addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'BR'),'-begin');

    % New BPM
    %addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'Common', 'BPM'), '-begin');

    % LFB
    %addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'SR', 'LFB', 'iGpTools'),'-begin');
    
    addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'Common'), '-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALSU', 'SR'),'-begin');

    % Christoph's Files
    %Directory = fullfile(MMLROOT, 'matlab', 'chris','commands');
    %if exist(Directory, 'dir')
    %    addpath(Directory, '-end');
    %end

    % Archiver appliance (SLAC)
    Directory = fullfile(MMLROOT, 'applications', 'ArchiverAppliance');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'ArchiverAppliance'), '-end');
    end
    
    % Initialize the MML
    alsuinit;
end



function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

