function [S, IndexList] = family2status(Family, DeviceList)
%FAMILY2STATUS - Returns the device status
%  If using family name, device list method,
%  S = family2status(Family, DeviceList)
%
%  If using channel name method,
%  S = family2status(ChannelNames)
%
%  If using common name method,
%  S = family2status(Family, CommonName)
%
%  INPUTS  
%  1. Family = Family Name 
%              Data Structure
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              For CommonNames, Family=[] searches all families
%              ChannelName = Channel access channel name
%                            Matrix of channel names
%                            Cell array of channel names
%  2. DeviceList = [Sector Device #] or [element #] list (Cell Array of DeviceList)
%                  {Default or empty list: whole family}
%     Note: The default list is different for this function then all other functions. 
%           Usually the default is in service devices which would always be true if
%           that was the default for this function.
%
%  OUTPUTS
%  1. S = 1 - device is in service
%         0 - device is out of service
%         Empty if Family or CommonName is found not found
%  2. IndexList - Index vector relative to the device list where
%                 the device is in service.

%  Written by Greg Portmann



if nargin == 0
    error('At least one input required');
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if nargin < 2
            [S{i}, IndexList{i}] = family2status(Family{i});
        else
            if iscell(DeviceList)
                [S{i}, IndexList{i}] = family2status(Family{i}, DeviceList{i});
            else
                [S{i}, IndexList{i}] = family2status(Family{i}, DeviceList);
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
    % Data structure inputs
    if nargin < 2
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        else
            DeviceList = [];
        end
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        error('For data structure inputs FamilyName field must exist')
    end
else
    % Family string input
    if nargin < 2
        DeviceList = [];
    end
end

% Note: This is a different default than normal good status only
if isempty(DeviceList)
    DeviceList = family2dev(Family, 0);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%
% Channel name method %
%%%%%%%%%%%%%%%%%%%%%%%
if ~isfamily(Family(1,:))
    % Try to convert to a family and device
    
    ChannelNames = Family;
    for i = 1:size(ChannelNames,1)
        Family = channel2family(ChannelNames(i,:));
        if isempty(Family)
            error('Channel name could not be converted to a Family.');
        end
        [FamilyIndex, ACCELERATOR_OBJECT] = isfamily(Family);
        DeviceList = channel2dev(ChannelNames(i,:), ACCELERATOR_OBJECT);
        if isempty(DeviceList) || isempty(DeviceList)
            error('Channel name could not be converted to a Family and DeviceList.');
        end
        S(i,:) = family2status(Family, DeviceList);
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);

   
%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%
S = getfamilydata(Family, 'Status', DeviceList);
S = S(:);
if nargout >= 2
    IndexList = find(S==1);
end