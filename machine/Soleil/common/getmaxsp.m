function S = getmaxsp(Family, DeviceList)
%GETMAXSP - Maximum value of the setpoint
%
%  FamilyName/DeviceList Method
%  SPmax = getmaxsp(Family, DeviceList)
%  SPmax = getmaxsp(DataStructure)
%
%  ChannelName Method
%  SPmax = getmaxsp(ChannelNames)
%
%  CommonName Method
%  SPmax = getmaxsp(Family, CommonName)
%
%  INPUTS
%  1. Family = Family Name 
%              Data Structure
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              For CommonNames, Family=[] searches all families
%     ChannelName = Channel access channel name
%                   Matrix of channel names
%                   Cell array of channel names
%     CommonName = Common name
%                  Matrix of common names
%                  Cell array of common names
%  2. DeviceList = [Sector Device #] or [element #] list {default or empty list: whole family}
%                   Cell Array of DeviceList
%
%  OUTPUTS
%  1. SPmax = Maximum setpoint of the device
%             Empty if not found
%
%  See also getminsp, getfamilydata(Family, Field, 'Range')

%
% Written by Gregory J. Portmann
% Modified by Laurent S. Nadolski

S = [];

if nargin == 0
    error('At least one input required');
end

if iscell(Family)
    if nargin >= 2
        if ~iscell(DeviceList)
            error('If Family is a cell array, then DeviceList must be a cell array.');
        end
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(Family)
        if nargin == 1
            S{i} = getmaxsp(Family{i});
        else            
            S{i} = getmaxsp(Family{i}, DeviceList{i});
        end
    end
    return    
end

if isstruct(Family)
    if any(size(Family) > 1)
        error('Only structures of size = [1 1] allowed')
    end                
    if isfield(Family,'FamilyName') & isfield(Family,'Field')
        % Data structure
        S = getfamilydata(Family.FamilyName, Family.Field, 'Range', Family.DeviceList); 
        if ~isempty(S)
            S = S(:,2);
        end
        return
    else
        % AO structure
        if nargin < 2
            S = Family.Setpoint.Range;
        else
            if size(DeviceList,2) == 1
                Index = findrowindex(DeviceList, ElementList);
            else
                Index = findrowindex(DeviceList, Family.DeviceList);
            end
            S = Family.Setpoint.Range(Index,2);
        end
    end
end


if isempty(Family)
    % Common names with no family name
    if nargin < 2
            error('If Family=[], 2 inputs are required.');
    end
    CommonNames = DeviceList;
    for i = 1:size(CommonNames,1)
        Family = common2family(CommonNames(i,:));
        [FamilyIndex, ACCELERATOR_OBJECT] = isfamily(Family);
        DeviceList = common2dev(CommonNames(i,:), ACCELERATOR_OBJECT);
        if isempty(DeviceList) | isempty(DeviceList)
            error('Common name could not be converted to a Family and DeviceList.');
        end
        S(i,:) = getmaxsp(Family, DeviceList);
    end
    return
        
elseif ~isfamily(Family(1,:))
    % Channel name method
    % Try to convert to a family and device
    
    ChannelNames = Family;
    for i = 1:size(ChannelNames,1)
        Family = channel2family(ChannelNames(i,:));
        [FamilyIndex, ACCELERATOR_OBJECT] = isfamily(Family);
        DeviceList = channel2dev(ChannelNames(i,:), ACCELERATOR_OBJECT);
        if isempty(DeviceList) | isempty(DeviceList)
            error('Channel name could not be converted to a Family and DeviceList.');
        end
        S(i,:) = getmaxsp(Family, DeviceList);
    end
    return
end


if nargin == 1
    S = getfamilydata(Family, 'Setpoint', 'Range', []);
else            
    % Convert common name to a DeviceList
    if isstr(DeviceList)
        DeviceList = common2dev(DeviceList, Family);
    end
    S = getfamilydata(Family, 'Setpoint', 'Range', DeviceList);
end
if ~isempty(S)
    S = S(:,2);
end