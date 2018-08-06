function makephysdata(varargin)
%MAKEPHYSDATA - Make a starting physics data file
%
%  NOTE: MML creators are phasing out the use of physdata.

%  Written by Greg Portmann

FamilyName = getfamilylist;
N = size(FamilyName,1);

for i = 1:N
    Family = deblank(FamilyName(i,:));
    
    if ismemberof(Family,'BPM')        
        PhysData.(Family).Golden = 0;        
        PhysData.(Family).Gain = 1;        
        PhysData.(Family).Offset = 0;        
        PhysData.(Family).Coupling = 0;        
        
    elseif ismemberof(Family,'COR') | ...
            ismemberof(Family,'QUAD') | ...
            ismemberof(Family,'SEXT') | ...
            ismemberof(Family,'BEND')
        
        PhysData.(Family).Gain = 1;        
        PhysData.(Family).Offset = 0;        
        PhysData.(Family).Coupling = 0;        
    end
end


% if strcmpi(getfamilydata('Machine'), 'ALS');
%     PhysData.TUNE.Golden = [.25; .20; NaN]; 
%     PhysData.CHRO.Golden = [.4; 1.2];
% elseif strcmpi(getfamilydata('Machine'), 'SPEAR') | strcmpi(getfamilydata('Machine'), 'SPEAR3')
%     PhysData.TUNE.Golden = [.19; .23; NaN];
%     PhysData.CHRO.Golden = [1; 1];
% elseif strcmpi(getfamilydata('Machine'), 'PLS')
%     PhysData.TUNE.Golden = [.19; .23; NaN];   % ???
%     PhysData.CHRO.Golden = [1; 1];
% elseif strcmpi(getfamilydata('Machine'), 'NSRRC')
%     PhysData.TUNE.Golden = [.2026; .1650; NaN];
%     PhysData.CHRO.Golden = [1; 1];
% end
        

% All calibation data is saved in this file
FileName = getfamilydata('OpsData','PhysDataFile');

%DirectoryName = getfamilydata('Directory','DataRoot'); 
%Machine = lower(getfamilydata('Machine'));
%[DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
%DirectoryName = fullfile(DirectoryName, Machine, filesep);
%FileName = [Machine, 'physdata'];

if exist([FileName, '.mat'], 'file')
    tmp = questdlg({...
            sprintf('%s.mat', FileName), ...
            'is where many important parameters are saved to operate', ...
            'saved to operate this machine. You are about to completely', ...
            'overwrite this file with no backup!', ...
            'Are you sure you want to change the Physics Data Structure?'},...
        'SETPHYSDATA','YES','NO','NO');
    if ~strcmpi(tmp,'YES')
        fprintf('   No change made to the Physics Data Structure\n');
        return
    end
end


save(FileName, 'PhysData');    
fprintf('   A new Physics Data Structure has been saved to %s\n', FileName);
