function addpath_bpm
%ADDPATH_BPM - Add the new BPM software to the Matlab path


% The path should not be modified in standalone mode
if ~isdeployed
    % Regular Matlab Session
    MMLROOT = getmmlroot;
    %addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common', 'BPM'), '-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Common', 'BPM', 'NSLS2'), '-begin');
end

% For the NSLS-II Pilot tone BPM
set_ip_addr;

% For EPICS BPM
setappdata(0, 'EPICS_BPM_PREFIX', 'SR01C:BPM4:');
%setappdata(0, 'EPICS_BPM_PREFIX', 'bpmTest:095:');



% Add BPM to MML
% AO = getao;
% AO.BPMx.Monitor.SpecialFunctionGet = @getam_nsls2;
% AO.BPMy.Monitor.SpecialFunctionGet = @getam_nsls2;
% 
% i = findrowindex([1  5;1  7;], AO.BPMx.DeviceList);   % For NSLS-2 development
% AO.BPMx.Status(i) = 1;    % Add BPMs back
% 
% 
% i = findrowindex([1  5;1  7;], AO.BPMy.DeviceList);   % For NSLS-2 development
% AO.BPMy.Status(i) = 1;    % Add BPMs back
% 
% setao(AO);


