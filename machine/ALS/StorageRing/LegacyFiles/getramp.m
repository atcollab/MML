function RampFlag = getramp(Family, DeviceList)   
%   RampFlag = getramp('Family', DeviceList)
%
%   Inputs:  Family = 'BEND', 'QFA', 'SF', 'SD', 'HCM', 'VCM', 'BPMx', or 'BPMy'
%            DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%   Outputs: RampFlag = 0 - slow mode
%                       1 - fast setpoints
%
%   Note:  initdll needs to be run before running this function

if nargin == 0,
   error('Must have atleast one input (''Family'')');
elseif nargin == 1,
   DeviceList = family2dev(Family);
end                    

RampFlag = getpv(Family, 'RampRate', DeviceList);

RampFlag = RampFlag > 2;


% if (size(DeviceList,2) == 1) 
%     DeviceList = elem2dev(Family, DeviceList);
% end
% 
% if strcmp(Family,'HCM') == 1
%     DeviceList = DeviceList(find(DeviceList(:,2)==3 | DeviceList(:,2)==4 | DeviceList(:,2)==5 | DeviceList(:,2)==6),:);
% elseif strcmp(Family,'VCM') == 1
%     DeviceList = DeviceList(find(DeviceList(:,2)==3 | DeviceList(:,2)==4 | DeviceList(:,2)==5 | DeviceList(:,2)==6),:);
% end
% 
% % Look for devices that have ramp rates, ie, not DMM ramp rate
% ChannelNames = family2channel(Family, 'RampRate', DeviceList);
% ii = find(ChannelNames(:,1)~=' ');
% DeviceList(ii,:) = [];
% 
% 
% % % Look for problems
% % for i = 1:size(DeviceList,1)
% %     DeviceList(i,:)
% %     RampFlag = vecgetrp(Family, DeviceList(i,1), DeviceList(i,2));
% % end
% 
% try
%     RampFlag = vecgetrp(Family, DeviceList(:,1), DeviceList(:,2));
% catch
%     if strcmp(lasterr, 'initdll may need to be run.')
%         fprintf('Please wait.  Trying to clear error by running initdll.\n'); pause(0);
%         initdll;
%         fprintf('Trying getramp again.\n');
%         RampFlag = vecgetrp(Family, DeviceList(:,1), DeviceList(:,2));
%     else
%         fprintf('%s\n', lasterr);
%         error('error in vecgetrp');
%     end
% end
% 
% if nargout == 0 && nargin == 1
%     numfast = length(find(RampFlag==1));
%     if strcmp(Family,'HCM') == 1
%         fprintf('   %d of %d horizontal correctors (HCMs [3456] = HCSD''s and HCSF''s) are in fast mode.\n', numfast, size(DeviceList,1));
%     elseif strcmp(Family,'VCM') == 1
%         fprintf('   %d of %d vertical correctors (VCMs [45] = VCSF''s) are in fast mode.\n', numfast, size(DeviceList,1));
%     end
% end
