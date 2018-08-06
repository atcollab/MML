function Data = getcrunch(varargin)
%GETCRUNCH- Returns the crunch values for a family (radians)
%  Crunch = getcrunch(Family, Field, DeviceList)
%  Crunch = getcrunch(Family, DeviceList)
%  Crunch = getcrunch(Family)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor' for BPM, 'Setpoint' for magnet}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  4. 'Physics' or 'Hardware' inputs are ignored
%  5. 'Numeric' - Numeric output {Default}
%     'Struct'  - Data structure output
%
%  OUTPUTS
%  1. Crunch - Crunch value for the family {Default: 0}
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList can also be a cell arrays
%
%  See also getgain, getroll, getfamilydata, getgolden, raw2real, real2raw

%  Written by Greg Portmann


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
            Data{i} = getcrunch(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                Data{i} = getcrunch(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                Data{i} = getcrunch(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{3})
                Data{i} = getcrunch(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
            else
                Data{i} = getcrunch(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
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
Data = getfamilydata(Family, Field, 'Crunch', DeviceList);
if isempty(Data)
    Data = getfamilydata(Family, 'Crunch', DeviceList);
end

% 2. Then look in PhysData
if isempty(Data)
    try
        Data = getphysdata(Family, 'Crunch', DeviceList);
    catch
        % Default
        Data = zeros(size(DeviceList,1),1);
    end
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
    Data.DataDescriptor = sprintf('%s.%s Crunch', Family, Field);
    Data.CreatedBy = 'getcrunch';
end

