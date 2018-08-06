function makephysdata(varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/makephysdata.m 1.2 2007/03/02 09:03:14CST matiase Exp  $
% ----------------------------------------------------------------------------------------------


FamilyName = getfamilylist;
N = size(FamilyName,1);

for i = 1:N
    Family = deblank(FamilyName(i,:));
    
    if ismemberof(Family,'BPM')        
        PhysData.(Family).Golden = 0;        
        PhysData.(Family).Gain = 1;        
        PhysData.(Family).Offset = 0;        
        PhysData.(Family).Coupling = 0;        
        PhysData.(Family).Sigma = .001;        
        PhysData.(Family).PinCushion = 1;
        PhysData.(Family).Dispersion = measdisp(Family,'struct','model');
        
    elseif ismemberof(Family,'COR') | ...
            ismemberof(Family,'QUAD') | ...
            ismemberof(Family,'SEXT') | ...
            ismemberof(Family,'BEND')
        
        PhysData.(Family).Gain = 1;        
        PhysData.(Family).Offset = 0;        
        PhysData.(Family).Coupling = 0;        
    end
end


if strcmpi(getfamilydata('Machine'), 'ALS');
    PhysData.TUNE.Golden = [.24; .19; NaN];   % ???
    PhysData.CHRO.Golden = [-1; -1];
elseif strcmpi(getfamilydata('Machine'), 'SPEAR') | strcmpi(getfamilydata('Machine'), 'SPEAR3')
    PhysData.TUNE.Golden = [.19; .23; NaN];
    PhysData.CHRO.Golden = [-1; -1];
elseif strcmpi(getfamilydata('Machine'), 'PLS')
    PhysData.TUNE.Golden = [.19; .23; NaN];   % ???
    PhysData.CHRO.Golden = [-1; -1];
elseif strcmpi(getfamilydata('Machine'), 'NSRRC')
    PhysData.TUNE.Golden = [.2026; .1650; NaN];
    PhysData.CHRO.Golden = [-1; -1];
elseif strcmpi(getfamilydata('Machine'), 'CLS')
    PhysData.TUNE.Golden = [.22; .26; NaN];
    PhysData.CHRO.Golden = [0; 0];
end
        

% All calibation data is saved in this file
%FileName = getfamilydata('OpsData','PhysDataFile');
Directory = getfamilydata('Directory','DataRoot'); 
Machine = lower(getfamilydata('Machine'));
FileName = [Machine, 'physdata'];


% tmp = questdlg({sprintf(...
%         '%s.mat is where many important parameters are', FileName), ...
%         'saved to operate this machine. You are about to completely', ...
%         'overwrite this file with no backup!', ...
%         'Are you sure you want to change the Physics Data Structure?'},...
%     'SETPHYSDATA','YES','NO','NO');
% if ~strcmpi(tmp,'YES')
%     fprintf('   No change made to the Physics Data Structure\n');
%     return
% end

save([Directory FileName], 'PhysData');    
fprintf('   A new Physics Data Structure has been saved to %s\n', [Directory FileName]);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/makephysdata.m  $
% Revision 1.2 2007/03/02 09:03:14CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------

