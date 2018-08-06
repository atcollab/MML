function RampRate = getramprate(varargin)
%GETRAMPRATE - Returns the ramp rate for a family
%  RampRate = getramprate(Family, Field, DeviceList)
%  RampRate = getramprate(Family, Field)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Setpoint'}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  4. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%
%  OUTPUTS
%  1. RampRate - Ramp rate for the family
% 
%  NOTES
%  1. If the ramprate is not known, then pick a value should be used that makes the delay when  
%     waiting one tolerance step resonable.   That is, Tol = family2tol is used by setpv and steppv
%     when the WaitFlag = -2.  After the setpoint is within tolerance, an extra delay of 
%     Tol / RampRate is done.  
%  2. If Family is a cell array, then DeviceList and Field can also be a cell arrays

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%
UnitsFlagCell = {};
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
            RampRate{i} = getramprate(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                RampRate{i} = getramprate(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                RampRate{i} = getramprate(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{3})
                RampRate{i} = getramprate(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
            else
                RampRate{i} = getramprate(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look for the data in the following order %                                         
% 1. RampRateFcn                           %
% 2. Channelname (if Field = 'Setpoint')   %
% 3. Constant in the AO                    %
% 4. Physdata file                         %
%                                          %
% Note: Data is stored in hardware units   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Look for a .RampRateFcn function
RampRateFcn = getfamilydata(Family, Field, 'RampRateFcn');
if ~isempty(RampRateFcn)
    RampRate = feval(RampRateFcn, Family, Field, DeviceList);
    
    % Change to physics units if requested
    if strcmpi(UnitsFlag,'Physics')
        RampRate = hw2physics(Family, Field, RampRate, DeviceList);
    end
    return
end

% 2. Channelname
if strcmp(Field, 'Setpoint')
    AORampRate = getfamilydata(Family, 'RampRate');
    if ~isempty(AORampRate)
        if isfield(AORampRate, 'ChannelNames') || isfield(AORampRate, 'SpecialFunction') || isfield(AORampRate, 'SpecialFunctionGet')  
            RampRate = getpv(Family, 'RampRate', DeviceList);
    
            % Change to physics units if requested
            if strcmpi(UnitsFlag,'Physics')
                RampRate = hw2physics(Family, Field, RampRate, DeviceList);
            end
            return
        end
    end
end


% 3. Constant in the AO
RampRate = getfamilydata(Family, Field, 'RampRate', DeviceList);
if isempty(RampRate) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
    RampRate = getfamilydata(Family, 'RampRate', DeviceList);
end

% Change to physics units if requested
if strcmpi(UnitsFlag,'Physics')
    RampRate = hw2physics(Family, Field, RampRate, DeviceList);
end
if ~isempty(RampRate) && isnumeric(RampRate)
    return
end


% 4. Physdata file
try
    RampRate = getphysdata(Family, Field, 'RampRate', DeviceList);
    if isempty(RampRate) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
        RampRate = getphysdata(Family, 'RampRate', DeviceList);
    end

    % Change to physics units if requested
    if strcmpi(UnitsFlag,'Physics')
        RampRate = hw2physics(Family, Field, RampRate, DeviceList);
    end
catch
    RampRate = [];
end


