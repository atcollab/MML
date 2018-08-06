function [Data, ErrorFlag] = family2tol(varargin)
%FAMILY2TOL - Return the (SP-AM) tolerance for a family
%  [Tol, ErrorFlag] = family2tol(Family, Field, DeviceList)
%  [Tol, ErrorFlag] = family2tol(Family, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Setpoint', etc) {Default: 'Setpoint'}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: Entire family}
%  4. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%  5. 'Numeric' - Numeric output {Default}
%     'Struct'  - Data structure output
%
%  OUTPUTS
%  1. Tol = Tolerance field corresponding to the Family, Field, and DeviceList
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays

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


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(varargin{1})
    for i = 1:length(varargin{1})
        if length(varargin) < 2
            [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{2})
                if iscell(varargin{3})
                    [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
                else
                    [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
                end
            else
                if iscell(varargin{3})
                    [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}, varargin{3}{i}, UnitsFlagCell{:});
                else
                    [Data{i}, ErrorFlag{i}] = family2tol(varargin{1}{i}, varargin{2}, varargin{3}, UnitsFlagCell{:});
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


% Default field is Setpoint
if isempty(Field)
    Field = 'Setpoint';
end


%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%
[Data, ErrorFlag] = getfamilydata(Family, Field, 'Tolerance', DeviceList);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to physics units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(UnitsFlag,'Physics')
    Data = hw2physics(Family, Field, Data, DeviceList);
end


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
    Data.DataDescriptor = sprintf('%s.%s Tolerance', Family, Field);
    Data.CreatedBy = 'family2tol';
end

