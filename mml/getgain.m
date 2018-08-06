function Data = getgain(varargin)
%GETGAIN - Returns the gain for a family
%  Gain = getgain(Family, Field, DeviceList)
%  Gain = getgain(Family, DeviceList)
%  Gain = getgain(Family)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor' for BPM, 'Setpoint' for magnet}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  4. 'Numeric' - Numeric output {Default}
%     'Struct'  - Data structure output
%
%  OUTPUTS
%  1. Gain - Gain value for the family {Default: 1}
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList can also be a cell arrays
%
%  See also getroll, getcrunch, getfamilydata, getoffset, getgolden, raw2real, real2raw

%  Written by Greg Portmann


%  5. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)


%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%
UnitsFlagCell = {};
StructOutputFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        StructOutputFlag = 0;
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
end


%%%%%%%%%%%%%%
% Cell input %
%%%%%%%%%%%%%%
if iscell(varargin{1})
    for i = 1:length(varargin{1})
        if length(varargin) < 2
            Data{i} = getgain(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                Data{i} = getgain(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                Data{i} = getgain(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{3})
                Data{i} = getgain(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
            else
                Data{i} = getgain(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Family, Field, DeviceList %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, Field, DeviceList, UnitsFlag] = inputparsingffd(varargin{:});


% Units flag
if isempty(UnitsFlagCell)
    % For structure inputs, use the units in the structure (from inputparsingffd)
    % Else, get the default family value
    if isempty(UnitsFlag)
        UnitsFlag = getunits(Family);
    end
else
    % Input override has priority
    UnitsFlag = UnitsFlagCell{1};
end


% Default field is Monitor for BPMs else Setpoint
if isempty(Field)
    if ismemberof(Family,'BPM')
        Field = 'Monitor';
    else
        Field = 'Setpoint';
    end
end


%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%

% 1. Try the AO and AD
Data = getfamilydata(Family, Field, 'Gain', DeviceList);
if isempty(Data) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
    Data = getfamilydata(Family, 'Gain', DeviceList);
end


% % 2. Then look in the AT model
% ATIndexList = family2atindex(Family, DeviceList);
% for i = 1:length(ATIndexList)
%     if isfield(AT, 'GCR')            
%         GCR(i,:) = THERING{ATIndexList(i)}.GCR;
%     else
%         GCR(i,:) = [1 1 0 0];  % [Gx Gy Crunch Roll]
%     end
% end


% 2. Then look in PhysData
if isempty(Data)
    try
        Data = getphysdata(Family, Field, 'Gain', DeviceList);
    catch
    end
end
if isempty(Data) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
    try
        Data = getphysdata(Family, 'Gain', DeviceList);
    catch
    end
end

% Default offset
if isempty(Data)
    Data = ones(size(DeviceList,1),1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to physics units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if strcmpi(UnitsFlag,'Physics')
%    Data = hw2physics(Family, Field, Data, DeviceList);
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return a data structure if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if StructOutputFlag
    DataNumeric = Data;
    if isempty(UnitsFlag)
        Data = family2datastruct(Family, Field, DeviceList);
    else
        Data = family2datastruct(Family, Field, DeviceList, UnitsFlag);
    end
    Data.Data = DataNumeric;
    Data.DataDescriptor = sprintf('%s.%s Gain', Family, Field);
    Data.CreatedBy = 'getgain';
end