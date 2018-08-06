function switch2notbergoz(DisplayFlag)
%SWITCH2NOTBERGOZ - Turn off the status of the Bergoz BPMs



setfamilydata(0, 'BPMx', 'Status', getbpmlist('BPMx','Bergoz','IgnoreStatus'));
setfamilydata(0, 'BPMy', 'Status', getbpmlist('BPMy','Bergoz','IgnoreStatus'));

if isfamily('BPMyCam')
    setfamilydata(0, 'BPMyCam', 'Status', getbpmlist('BPMy','Bergoz','IgnoreStatus'));
end

% Set BPMx & BPMy status flag to Bergoz style BPMs
% setfamilydata(1, 'BPMx', 'Status', family2dev('BPMx',0));
% DevList = getbpmlist('Bergoz');
% setfamilydata(0, 'BPMx', 'Status', family2dev('BPMx',0));
% setfamilydata(1, 'BPMx', 'Status', DevList);
% 
% setfamilydata(1, 'BPMy', 'Status', family2dev('BPMy',0));
% DevList = getbpmlist('Bergoz');
% setfamilydata(0, 'BPMy', 'Status', family2dev('BPMy',0));
% setfamilydata(1, 'BPMy', 'Status', DevList);

if nargin >= 1 && strcmpi(DisplayFlag,'Display')
    disp('   Using only the Bergoz style BPM''s.');
end