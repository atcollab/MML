function ElementList = family2elem(Family, varargin);
%FAMILY2elem - Returns the element list for a family
%  ElementList = family2elem(FamilyName, StatusFlag)
%
%  INPUTS
%  1. Family = Family name ('BEND', 'Q1', 'S1', 'S2', 'HCOR', 'VCOR', etc.)
%              Data Structure (only the FamilyName field is used)
%              Accelerator Object (only the FamilyName field is used)
%              Cell Array
%  2. StatusFlag - 0 return all elements
%                  1 return only elements with good status {Default}
%
%  OUTPUTS
%  1. ElementList - Element list corresponding to the Family
%                  Empty if not found
%
%  EXAMPLES
%  1. family2elem('HCOR')
%  2. family2elem({'HCOR','VCOR'})
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
    StatusFlag = varargin{1};
else
    % This choice changes the default behavior for the entire middle layer !!!!
    StatusFlag = 1;  % Only return good status devices
end

%%%%%%%%%%%%%%%%%%%%%
%% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if iscell(StatusFlag)
            ElementList{i} = family2elem(Family{i}, StatusFlag{i});
        else
            ElementList{i} = family2elem(Family{i}, StatusFlag);
        end
    end
    return    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Family or data structure inputs beyond this point %
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

% gets device list for Family
[DeviceList, ErrorFlag] = getfamilydata(Family, 'DeviceList');
if isempty(DeviceList)
    error(sprintf('%s family not found', Family));
end

% return all elements whatever status
ElementList = dev2elem(Family,DeviceList);

% return status 1 elements
if StatusFlag
    Status = getfamilydata(Family, 'Status', DeviceList);
    if isempty(Status)
        fprintf('   WARNING:  Status field not in the AO, hence ignored.\n');
    else
        ElementList = dev2elem(Family,DeviceList(find(Status),:));
    end
end
