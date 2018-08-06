function RampRate = getramprate(varargin)
%GETRAMPRATESPEAR - Returns the ramp rate for a family at Spear
%  RampRate = getrampratespear(Family, Field, DeviceList)
%  RampRate = getrampratespear(Family, Field)
%  RampRate = getrampratespear(Family, DeviceList)
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
%  2. For HCM and VCM it's not the actual ramprate, it's the rate for a 1 ampere step
%  3. If Family is a cell array, then DeviceList and Field can also be a cell arrays
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
        DeviceList = varargin{3};
    end
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if length(varargin) < 2
            RampRate{i} = getramprate(Family{i}, UnitsFlag{:});
        elseif length(varargin) < 3
            if iscell(Field)
                RampRate{i} = getramprate(Family{i}, Field{i}, UnitsFlag{:});
            else
                RampRate{i} = getramprate(Family{i}, Field, UnitsFlag{:});
            end
        else
            if iscell(DeviceList)
                RampRate{i} = getramprate(Family{i}, Field{i}, DeviceList{i}, UnitsFlag{:});
            else
                RampRate{i} = getramprate(Family{i}, Field{i}, DeviceList, UnitsFlag{:});
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
        DeviceList = [];
    end
end
if isnumeric(Field)
    DeviceList = Field;
    Field = '';
end
if isempty(Field)
    Field = 'Setpoint';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end

if isempty(UnitsFlag)
    UnitsFlag = '';
else
    UnitsFlag = UnitsFlag{1};    
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


switch Family
    case {'HCM', 'VCM'}
        % For correctors, 2000 steps in 1 second
        % But it doesn't matter how big the step is so the ramprate cannot be determined
        % I'll make the default be for a 1 amp step
        NSteps = getpv(Family, 'CurrInterSteps', DeviceList);
        RampRate = NSteps / 2000;
    otherwise
        RampRate = [];
        return
end

% Change to physics units if requested
if strcmpi(UnitsFlag,'Physics')
    RampRate = hw2physics(Family, Field, RampRate, DeviceList);
end


