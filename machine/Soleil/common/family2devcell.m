function DeviceList = family2devcell(Family, varargin);
%FAMILY2DEVCELL - Returns the device list for a family and a cell
%  DeviceList = family2dev(FamilyName, StatusFlag)
%
%  INPUTS
%  1. Family = Family name ('BEND', 'Q1', 'S1', 'S2', 'HCOR', 'VCOR', etc.)
%              Data Structure (only the FamilyName field is used)
%              Accelerator Object (only the FamilyName field is used)
%              Cell Array
%  2. CellNumber - Cell number eg. 1, [2 3]
%  3. StatusFlag - 0 return all devices
%                  1 return only devices with good status {Default}
%
%  OUTPUTS
%  1. DeviceList - Device list corresponding to the Family
%                  Empty if not found
%
%  See Also dev2family, family2common, family2dev, family2handle
%          family2status, family2tol, family2units, family2tango

%
%  Written by Laurent S. Nadolski

if nargin == 0
    error('Must have at least one input.');
end

% Status input
if nargin >= 2
    CellNumber = varargin{1};
    if nargin >= 3
        StatusFlag = varargin{2};
    else
        % This choice changes the default behavior for the entire middle layer !!!!
        StatusFlag = 1;  % Only return good status devices
    end
else
    CellNumber = 1;
    StatusFlag = 1;  % Only return good status devices
end

%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if iscell(StatusFlag)
            DeviceList{i} = family2devcell(Family{i}, StatusFlag{i});
        else
            DeviceList{i} = family2devcell(Family{i}, StatusFlag);
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
        Family = Family.FamilyName;   
    else
        error('Family input of unknown type');
    end
end


[DeviceList, ErrorFlag] = getfamilydata(Family, 'DeviceList');
if isempty(DeviceList)
    error(sprintf('%s family not found', Family));
end

ind = [];
for k = 1:length(CellNumber)
    ind = [ind; find(DeviceList(:,1) == CellNumber(k))];
end
DeviceList = DeviceList(ind,:);

if StatusFlag
    Status = getfamilydata(Family, 'Status', DeviceList);
    if isempty(Status)
        fprintf('   WARNING:  Status field not in the AO, hence ignored.\n');
    else
        DeviceList = DeviceList(find(Status),:);
    end
end
