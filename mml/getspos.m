function S = getspos(Family, DeviceList)
%GETSPOS - Returns the longitudinal position in meters
%
%  If using family name, device list method,
%  S = getspos(Family, DeviceList)
%
%  If using AT family name
%  S = getspos(FamName, IndexVector)
%
%  If using channel name method,
%  S = getspos(ChannelNames)
%
%  If using common name method,
%  S = getspos(Family, CommonName)
%
%  INPUTS
%  1. Family = MiddleLayer or AT Family Name 
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              For CommonNames, Family=[] searches all families
%     ChannelName = Channel access channel name
%                   Matrix of channel names
%                   Cell array of channel names
%     CommonName = Common name
%                  Matrix of common names
%                  Cell array of common names
%     DeviceList = [Sector Device #] or [element #] list {default or empty list: whole family}
%                   Cell Array of DeviceList
%
%  OUTPUTS
%  1. S = the position of the device along the ring (S) [meters]
%         Empty if Family or CommonName is found not found

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
            S{i} = getspos(Family{i});
        else
            if iscell(DeviceList)
                S{i} = getspos(Family{i}, DeviceList{i});
            else
                S{i} = getspos(Family{i}, DeviceList);
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


if isfamily(Family(1,:))
    %%%%%%%%%%%%%%%%%%%%%%
    % Family name method %
    %%%%%%%%%%%%%%%%%%%%%%

    if isempty(DeviceList)
        DeviceList = family2dev(Family);
    end
    % if (size(DeviceList,2) == 1)
    %     DeviceList = elem2dev(Family, DeviceList);
    % end

    % Get data
    S = getfamilydata(Family, 'Position', DeviceList);

else

    %%%%%%%%%%%%%%%%%%%%%%%
    % Channel name method %
    %%%%%%%%%%%%%%%%%%%%%%%
    ATIndex = family2atindex(Family(1,:), DeviceList);

    global THERING
    if ~isempty(ATIndex)
        S = findspos(THERING, ATIndex);
        S = S(:);
    else

        %%%%%%%%%%%%%%%%%%%%%%%
        % Channel name method %
        %%%%%%%%%%%%%%%%%%%%%%%
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
    end
end


