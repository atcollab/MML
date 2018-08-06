function iHinkson = rmhinksonbpms(DisplayFlag)
%Turn off the status of the old Hinkson's BPMs

n  = family2channel('BPMx');
dev = getbpmlist('BPMx');

iHinkson = [];
for i = 1:size(dev,1)
    ii = strfind(n(i,:), '_X_');
    if ~isempty(ii)
        iHinkson = [iHinkson; i];
        setfamilydata(0, 'BPMx', 'Status', dev(i,:));
        setfamilydata(0, 'BPMy', 'Status', dev(i,:));
    end
end


% xstat = getfamilydata('BPMx', 'Status');
% xdev  = family2dev('BPMx');
% 
% hdev = getbpmlist('BPMx','Hinkson','IgnoreStatus');
% i = find(hdev(:,2)==9);
% hdev(i,:) = [];
% 
% i = findrowindex(hdev, xdev);
% if ~isempty(i)
%     setfamilydata(0, 'BPMx', 'Status', xdev(i,:));
% end
% 
% ystat = getfamilydata('BPMy', 'Status');
% ydev  = family2dev('BPMy');
% hdev = getbpmlist('BPMy','Hinkson','IgnoreStatus');
% i = find(hdev(:,2)==9);
% hdev(i,:) = [];
% i = findrowindex(hdev, ydev);
% if ~isempty(i)
%     setfamilydata(0, 'BPMy', 'Status', ydev(i,:));
% end
