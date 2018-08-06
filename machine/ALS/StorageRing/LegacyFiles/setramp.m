function [RampFlag] = setramp(Family, newRampFlag, DeviceList)
%   [RampFlag] = setramp('Family', newRampFlag, DeviceList);
%
%   Inputs:  Family = 'BEND', 'QFA', 'SF', 'SD', 'HCM', 'VCM', 'BPMx', or 'BPMy'
%            DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%   RampFlag = 0 - slow mode
%              1 - fast setpoints
%
%   Note:  initdll needs to be run before running this function


if nargin == 0,
   error('Must have at least one input (''Family'')');
elseif nargin == 1;
   newRampFlag = 0;		
   DeviceList = getlist(Family);
elseif nargin == 2;		
   DeviceList = getlist(Family);
end 

if RampFlag == 0
    setpv(Family, 'RampRate', 1, DeviceList);
else
    setpv(Family, 'RampRate', 10, DeviceList);
end

% if (size(DeviceList,2) == 1)    %if # of columns == 1 (2 is a dimension)
%    DeviceList = elem2dev(Family, DeviceList);
% end
% 
% if strcmp(Family,'HCM') == 1
% 	DeviceList = DeviceList(find(DeviceList(:,2)==3 |DeviceList(:,2)==4 |DeviceList(:,2)==5 |DeviceList(:,2)==6),:);
% elseif strcmp(Family,'VCM') == 1
% 	DeviceList = DeviceList(find(DeviceList(:,2)==3 |DeviceList(:,2)==4 |DeviceList(:,2)==5 |DeviceList(:,2)==6),:);
% end
% 
% 
% if size(newRampFlag) == [1 1]
%    newRampFlag = newRampFlag*ones(size(DeviceList,1),1);
% elseif size(newRampFlag) == [size(DeviceList,1) 1]
%    % input OK 
% else
%    error('Size of newRampFlag must be equal to the DeviceList or a scalar!');
% end
% 
% 
% % Look for devices that have ramp rates, ie, not DMM ramp rate
% ChannelNames = family2channel(Family, 'RampRate', DeviceList);
% ii = find(ChannelNames(:,1)~=' ');
% DeviceList(ii,:) = [];
% newRampFlag(ii) = [];
% 
% 
% try
%     RampFlag = vecsetrp(Family, DeviceList(:,1), DeviceList(:,2), newRampFlag);
% catch
%     if strcmp(lasterr, 'initdll may need to be run.')
%         fprintf('Please wait.  Trying to clear error by running initdll.\n'); pause(0);
%         initdll;
%         fprintf('Trying getramp again.\n');
%         RampFlag = vecsetrp(Family, DeviceList(:,1), DeviceList(:,2), newRampFlag);
%     else
%         fprintf('   %s\n', lasterr);
%         error('error in vecsetrp');
%     end
% end
% 
% sleep(.1);


if nargout >= 1
    RampFlag = getramp(Family, DeviceList);
end