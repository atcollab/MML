function [DataStruct, ErrorFlag] = family2datastruct(varargin)
%FAMILY2DATASTRUCTURE
%  [DataStruct, ErrorFlag] = family2datastruct(Family, Field, DeviceList)
%  [DataStruct, ErrorFlag] = family2datastruct(Family, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: getfirstfield}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  4. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%
%  OUTPUTS
%  1. DataStruct - Date structure corresponding to the Family, Field, and DeviceList
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%
UnitsFlagCell = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignore structures
    elseif iscell(varargin{i})
        % Ignore cells
    elseif strcmpi(varargin{i},'struct')
        % Remove and ignore
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove and ignore
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignore
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


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(varargin{1})
    for i = 1:length(varargin{1})
        if length(varargin) < 2
            [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{2})
                if iscell(varargin{3})
                    [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
                else
                    [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
                end
            else
                if iscell(varargin{3})
                    [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}, varargin{3}{i}, UnitsFlagCell{:});
                else
                    [DataStruct{i}, ErrorFlag{i}]  = family2datastruct(varargin{1}{i}, varargin{2}, varargin{3}, UnitsFlagCell{:});
                end
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


% Default field
if isempty(Field)
    %Field = 'Monitor';
    Field = findfirstfield(Family);
end



if isempty(UnitsFlag)
    UnitsFlag = getfamilydata(Family, Field, 'Units');
end
if isempty(UnitsFlag)
    error('Cannot find the units type');
end



%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%
ErrorFlag = 0;
DataStruct.Data = [];  % Gets filed with NaN later
DataStruct.FamilyName = Family;
DataStruct.Field = Field;
if isempty(DeviceList)
    DataStruct.DeviceList = family2dev(Family);
else
    DataStruct.DeviceList = DeviceList;
end
DataStruct.Data = ones(size( DataStruct.DeviceList,1),1) * NaN;
DataStruct.Status = family2status(Family, DataStruct.DeviceList);
DataStruct.Mode = getmode(Family, Field);
DataStruct.t = [];
DataStruct.tout = [];
DataStruct.DataTime = [];
DataStruct.TimeStamp = [];

DataStruct.Units = UnitsFlag;
if strcmpi(UnitsFlag,'Hardware')
    DataStruct.UnitsString = getfamilydata(Family, Field, 'HWUnits');    
elseif strcmpi(UnitsFlag,'Physics')
    DataStruct.UnitsString = getfamilydata(Family, Field, 'PhysicsUnits');    
else
    error('Units unknown');
end
DataStruct.DataDescriptor = '';
DataStruct.CreatedBy = 'family2datastruct';

