function Data = rmoffset(varargin)
%RMOFFSET - Remove the offset values for data set
%  Data = rmoffset(DataStructure)
%  Data = rmoffset(Family, DataIn, DeviceList)
%  Data = rmoffset(Family, Field, DataIn, DeviceList)
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Accelerator Object
%  2. Field - MML field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor' for BPM, 'Setpoint' for magnet}
%  3. DataIn - Input data
%  4. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  5. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%  6. 'Struct'  - Return a data structure
%     'Numeric' - Return numeric outputs  {Default}
%     'Object'  - Return a accelerator object (AccObj)
%
%  OUTPUTS
%  1. Data - Input data with a offset value removed
%
%  See also rmgolden, getoffset, getgolden 

%  Written by Greg Portmann



%%%%%%%%%%%%%%%%%
% Input parsing %
%%%%%%%%%%%%%%%%%
UnitsFlagCell = {};
StructFlag = 0;
NumericFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        StructFlag = 1;
        NumericFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        StructFlag = 0;
        NumericFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlagCell = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlagCell = {'Hardware'};
        varargin(i) = [];
    end
end


if isempty(varargin)
    error('Must have at least a family name input');
elseif iscell(varargin{1})
    % Cell input
    for i = 1:length(varargin{1})
        if length(varargin) == 1
            Data{i} = rmoffset(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) == 2
            Data{i} = rmoffset(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
        elseif length(varargin) == 3
            Data{i} = rmoffset(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
        else
            Data{i} = rmoffset(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, varargin{4}{i}, UnitsFlagCell{:});
        end
    end
    return
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Family = varargin{1};
if isstruct(Family)
    if ~NumericFlag
        StructFlag = 1;
        StructOut = Family; 
    end
    
    % Data structure inputs
    if length(varargin) < 2
        if isfield(Family,'Field')
            Field = Family.Field;
        else
            Field = '';
        end
    end
    if length(varargin) < 3 
        if isfield(Family,'Data')
            Data = Family.Data;
        else
            error('A .Data field must exist for data structure inputs.');
        end
    end
    if length(varargin) < 4
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        else
            DeviceList = [];
        end
    end
    if isempty(UnitsFlagCell)
        if isfield(Family,'Units')
            UnitsFlagCell{1} = Family.Units; 
        end
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        error('For data structure inputs FamilyName field must exist')
    end
else
    % Family string input
    if length(varargin) >= 2 && ischar(varargin{2})
        Field = varargin{2};
        varargin(2) = [];
    else
        Field = '';
    end
    if length(varargin) >= 2
        Data = varargin{2};
    else
        Data = '';
    end
    if length(varargin) >= 3
        DeviceList = varargin{3};
    else
        DeviceList = [];
    end

    StructOut = [];
end

if isnumeric(Field)
    DeviceList = Data;
    Data = Field;
    Field = '';
end
if isempty(Field)
    if ismemberof(Family,'BPM') || ismemberof(Family,'TUNE') || strcmpi(Family, 'TUNE')
        Field = 'Monitor';
    else
        Field = 'Setpoint';
    end
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end

if isempty(Data) || ~isnumeric(Data)
    %error('Data input required');   
    Data = getpv(Family, Field, DeviceList);
end

if size(Data,1) == 1
    Data = ones(size(DeviceList,1),1) * Data;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


%%%%%%%%%%%%
% rmoffset %
%%%%%%%%%%%%

Offset = getoffset(Family, Field, DeviceList, UnitsFlagCell{:});

for i = 1:size(Data,1)
    Data(i,:) = Data(i,:) - Offset(i,:); 
end


if StructFlag
    if isempty(StructOut)
        StructOut = family2datastruct(Family, Field, DeviceList);
        StructOut.DataDescriptor = 'rmoffset';
    end
    StructOut.Data = Data;
    Data = StructOut;
end


