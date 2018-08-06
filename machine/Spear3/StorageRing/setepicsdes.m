function [Data, ErrorFlag] = setepicsdes(varargin)
%SETGOLDEN - Sets the golden values for a family to the Des channel (EPICS)
%  [Golden, ErrorFlag] = setepicsdes(Family, Field, GoldenValues, DeviceList)
%  [Golden, ErrorFlag] = setepicsdes(Family, GoldenValues, DeviceList)
%  [Golden, ErrorFlag] = setepicsdes(Family, GoldenValues)
%  [Golden, ErrorFlag] = setepicsdes(Family)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3. GoldenValues - Desired values {Default: getgolden}
%  4. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  5. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%
%  OUTPUTS
%  1. GoldenValues - The actual values set
%  2. ErrorFlag
% 
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input parsing %
%%%%%%%%%%%%%%%%%
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model') | strcmpi(varargin{i},'Online') | strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = {'Hardware'};
        varargin(i) = [];
    end
end

if length(varargin) == 0
    error('Must have at least a family name input');
else
    Family = varargin{1};
    if length(varargin) >= 2
        Field = varargin{2};
    end
    if length(varargin) >= 3
        GoldenValues = varargin{3};
    end
    if length(varargin) >= 4
        DeviceList = varargin{4};
    end
end


%%%%%%%%%%%%%%
% Cell input %
%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if length(varargin) < 2
            [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, UnitsFlag{:});
        elseif length(varargin) < 3
            if iscell(Field)
                [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, UnitsFlag{:});
            else
                [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, UnitsFlag{:});
            end
        elseif length(varargin) < 4
            if iscell(Field)
                if iscell(GoldenValues)
                    [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues{i}, UnitsFlag{:});
                else
                    [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues, UnitsFlag{:});
                end
            else
                if iscell(GoldenValues)
                    [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues{i}, UnitsFlag{:});
                else
                    [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues, UnitsFlag{:});
                end
            end
        else
            if iscell(Field)
                if iscell(GoldenValues)
                    if iscell(DeviceList)
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues{i}, DeviceList{i}, UnitsFlag{:});
                    else
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues{i}, DeviceList, UnitsFlag{:});
                    end
                else
                    if iscell(DeviceList)
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues, DeviceList{i}, UnitsFlag{:});
                    else
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field{i}, GoldenValues, DeviceList, UnitsFlag{:});
                    end
                end
            else
                if iscell(GoldenValues)
                    if iscell(DeviceList)
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues{i}, DeviceList{i}, UnitsFlag{:});
                    else
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues{i}, DeviceList, UnitsFlag{:});
                    end
                else
                    if iscell(DeviceList)
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues, DeviceList{i}, UnitsFlag{:});
                    else
                        [Data{i}, ErrorFlag{i}] = setepicsdes(Family{i}, Field, GoldenValues, DeviceList, UnitsFlag{:});
                    end
                end
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
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
            GoldenValues = Family.Data;
        else
            error('GoldenValues input required (or a .Data field must exist for data structure inputs)');
        end
    end
    if length(varargin) < 4
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        else
            DeviceList = [];
        end
    end
    if isempty(UnitsFlag)
        if isfield(Family,'Units')
            UnitsFlag{1} = Family.Units; 
        end
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        error('For data structure inputs FamilyName field must exist')
    end
else
    % Family string input
    if length(varargin) < 2
        Field = '';
    end
    if length(varargin) < 3
        GoldenValues = [];
    end
    if length(varargin) < 4
        DeviceList = [];
    end
end

if isempty(GoldenValues)
    GoldenValues = getgolden(Family, Field, DeviceList, 'numeric', UnitsFlag{:});
end

if isnumeric(Field)
    DeviceList = GoldenValues;
    GoldenValues = Field;
    Field = '';
end
if isempty(Field)
    if ismemberof(Family,'BPM')
        % Spear 3 only
        if strcmpi(getfamilydata('Machine'), 'SPEAR') | strcmpi(getfamilydata('Machine'), 'SPEAR3')
            if strcmpi(Family,'BPMx')
                Field = 'UDes';
            elseif strcmpi(Family,'BPMy')
                Field = 'VDes';
            else
                Field = 'Monitor';
            end
        else
            error('User setorbit to set a golden value for a BPM family');
        end
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CommonName Input:  Convert common names to a DeviceList %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstr(DeviceList)
    DeviceList = common2dev(DeviceList, Family);
    if isempty(DeviceList)
        error('DeviceList was a string but common names could not be found.');
    end
end


if isempty(GoldenValues)
    error('No golden values found');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the setpoint change %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ErrorFlag = setpv(Family, Field, GoldenValues, UnitsFlag{:});


