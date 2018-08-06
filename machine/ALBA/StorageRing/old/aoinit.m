function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% % The path should not be modified in standalone mode
% if ~isdeployed_local
% 
%     % Regular Matlab Session
%     MMLROOT = getmmlroot;
% 
%     % TuneMovePanel
%     addpath(fullfile(MMLROOT, 'machine', 'ALBA', 'StorageRing', 'TuneMovePanel'),'-begin');
% end


% Initialize the MML
albainit;


function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end
