function [Handles, ErrorFlag] = family2handle(Family, Field, DeviceList)
%FAMILY2HANDLE - Return the MCA handle for a family
%  [Handles, ErrorFlag] = family2handle(Family, Field, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              Cell Array
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3. DeviceList - ([Sector Device #] or [element #]) {default: whole family}
%
%  OUTPUTS 
%  1. Handles - Handles corresponding to the Family, Field, and DeviceList
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field must also be a cell arrays
%
%  Written by Greg Portmann


if nargin == 0
    error('Must have at least one input (''Family'')!');
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    if nargin >= 3
        if ~iscell(DeviceList)
            error('If Family is a cell array, then DeviceList must be a cell array.');
        end
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    if nargin >= 2
        if ~iscell(Field)
            error('If Family is a cell array, then Field must be a cell array.');
        end
        if length(Family) ~= length(Field)
            error('If Field is a cell array, then must be the same size as Family.');
        end
    end
    
    for i = 1:length(Family)
        if nargin == 1
            [Handles{i}, ErrorFlag{i}] = family2handle(Family{i});
        elseif nargin == 2
            [Handles{i}, ErrorFlag{i}] = family2handle(Family{i}, Field{i});
        else            
            [Handles{i}, ErrorFlag{i}] = family2handle(Family{i}, Field{i}, DeviceList{i});
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
        if isfield(Family,'Field')
            Field = Family.Field;
        else
            Field = '';
        end
    end
    if nargin < 3 
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
        Field = '';
    end
    if nargin < 3
        DeviceList = [];
    end
end
if isempty(Field)
    Field = 'Monitor';
end
if isnumeric(Field)
     DeviceList = Field;
     Field = 'Monitor';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%

% MCA handles are no longer stored in the AO
%[Handles, ErrorFlag] = getfamilydata(Family, Field, 'Handles', DeviceList);

[ChannelNames, ErrorFlag] = family2channel(Family, Field, DeviceList);

for i = 1:size(ChannelNames)
    Handles(i,1) = mcaisopen(deblank(ChannelNames(i,:)));
    if Handles(i,1) == 0
        Handles(i,1) = NaN;
    end
end
