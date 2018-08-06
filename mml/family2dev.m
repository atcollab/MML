function DeviceList = family2dev(Family, varargin)
%FAMILY2DEV - Return the device list for a family
%  DeviceList = family2dev(FamilyName, StatusFlag, PowerSupplyFlag)
%  DeviceList = family2dev(FamilyName, Field, StatusFlag, PowerSupplyFlag)
%
%  INPUTS
%  1. Family - Family name (ex., 'BEND', 'QFA', 'SF', 'SD', 'HCM', 'VCM', etc.)
%              Data Structure (only the FamilyName field is used)
%              Accelerator Object (only the FamilyName field is used)
%              Cell Array
%  2. Field - Option field input only effects the PowerSupplyFlag
%  3. StatusFlag - 0 return all devices
%                  1 return only devices with good status {Default}
%
%  4. PowerSupplyFlag - 0 return all devices {Default}
%                       1 return only unique channel names (like, power supplies for a magnet)
%
%  OUTPUTS
%  1. DeviceList - Device list corresponding to the Family
%                  Empty if not found
%
%  See also family2elem, family2common, family2status, family2tol, family2units

%  Written by Greg Portmann


if nargin == 0
    error('Must have at least one input.');
end


% Look for a field input
Field = '';
if length(varargin) >= 1
    if ischar(varargin{1}) || iscell(varargin{1})
        Field = varargin{1};
        varargin(1) = [];
    end
end


% StatusFlag
if length(varargin) >= 1
    StatusFlag = varargin{1};
else
    % This choice changes the default behavior for the entire middle layer !!!!
    StatusFlag = 1;  % Only return good status devices
end


% PowerSupplyFlag
if length(varargin) >= 2
    PowerSupplyFlag = varargin{2};
else
    PowerSupplyFlag = 0; 
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    if isempty(Field)
        for i = 1:size(Family,1)
            for j = 1:size(Family,2)
                Field{i,j} = '';
            end
        end
    end
    
    for i = 1:size(Family,1)
        for j = 1:size(Family,2)
            if iscell(StatusFlag) && iscell(PowerSupplyFlag)
                DeviceList{i,j} = family2dev(Family{i}, Field{i}, StatusFlag{i}, PowerSupplyFlag{i});
            elseif iscell(StatusFlag)
                DeviceList{i,j} = family2dev(Family{i}, Field{i}, StatusFlag{i}, PowerSupplyFlag);
            elseif iscell(PowerSupplyFlag)
                DeviceList{i,j} = family2dev(Family{i}, Field{i}, StatusFlag, PowerSupplyFlag{i});
            else
                DeviceList{i,j} = family2dev(Family{i}, Field{i}, StatusFlag, PowerSupplyFlag);
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
    % Structures can be an accelerator object or a data structure (as returned by getpv)
    if isfield(Family, 'FamilyName')
        % Data structure
        if isfield(Family, 'Field')
            Family = Family.Field;
        end
        Family = Family.FamilyName;
    else
        error('Family input of unknown type');
    end
end

% First check if there is a DeviceList at the Field level
if ~isempty(Field)
    DeviceList = getfamilydata(Family, Field, 'DeviceList');
end
if isempty(Field) || isempty(DeviceList)
    DeviceList = getfamilydata(Family, 'DeviceList');
end
if isempty(DeviceList)
    error(sprintf('%s family not found', Family));
end


if StatusFlag
    % First check if there is Status at the Field level
    if ~isempty(Field)
        Status = getfamilydata(Family, Field, 'Status', DeviceList);
    end
    if isempty(Field) || isempty(Status)
        Status = getfamilydata(Family, 'Status', DeviceList);
    end
    if isempty(Status)
        fprintf('   WARNING:  Status field not in the AO, hence ignored.\n');
    else
        DeviceList = DeviceList(find(Status),:);
    end
end


if PowerSupplyFlag
    % There can be multiple channel names due to "ganged" power supplies
    if isempty(Field)
        ChannelNames0 = family2channel(Family, DeviceList);
    else
        ChannelNames0 = family2channel(Family, Field, DeviceList);
    end
    if iscell(ChannelNames0)
        [ChannelNames, ii, jj] = unique(ChannelNames0);
    else
        [ChannelNames, ii, jj] = unique(ChannelNames0, 'rows');
    end
    
    if length(ii) ~= size(ChannelNames0,1)
        % Remove ' ' (' ' should always be the first row)
        if isempty(deblank(ChannelNames(1,:)))
            ii(1) = [];
            jj(jj==1) = [];
            jj = jj - 1;
        end

        ChannelNames = ChannelNames0(ii,:);

        % Unique does a sort and keeps the last device.
        
        % Remove the sort
        jjtmp = jj;
        for i = 1:max(jj)
            iDev(i) = jjtmp(1);
            jjtmp(jjtmp==jjtmp(1)) = [];
        end
        ChannelNames = ChannelNames(iDev,:);
        
        % Find the first device with that name
        i = findrowindex(ChannelNames, ChannelNames0);
        DeviceList = DeviceList(i,:);
    else
        % Remove ' ' (' ' should always be the first row)
        if isempty(deblank(ChannelNames(1,:)))
            iBlank = find(jj==1);
            DeviceList(iBlank,:) = [];
        end
    end
end


% if nargin >= 2
%     if varargin{1}
%         Status = getfamilydata(Family, 'Status', DeviceList);
%         if isempty(Status)
%             fprintf('   WARNING:  Status field not in the AO, hence ignored.\n');
%         else
%             DeviceList = DeviceList(find(Status),:);
%         end
%     end
% end


