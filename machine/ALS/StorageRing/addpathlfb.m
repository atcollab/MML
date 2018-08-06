function addpathlfb
%ADDPATHLFB - Add the LFB software to the Matlab path


% The path should not be modified in standalone mode
if ~isdeployed_local
    % Regular Matlab Session
    MMLROOT = getmmlroot;

    % LFB
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LFB', 'LFBTools'),'-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LFB', 'iGpTools'),'-begin');
end


function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

