function [LimitFlag, LimitList] = checklimits(varargin)
%CHECKLIMITS - Checks if the setpoint will exceed a limit 
%  [LimitFlag, LimitList] = checklimits(Family, Field, Setpoints, DeviceList)
%  [LimitFlag, LimitList] = checklimits(Family, Setpoints, DeviceList)
%  [LimitFlag, LimitList] = checklimits(DataStructure)
%
%  INPUTS 
%  1. Family or Data Structure
%  2. Field - MML field {Default: 'Setpoint'}
%  3. Setpoints - desired setpoint
%  4. DeviceList {Default: []}
%  5. Optional override of the units:
%     'Physics'  - Setpoints are in physics  units
%     'Hardware' - Setpoints are in hardware units
%
%  OUTPUTS
%  1. LimitFlag - 0 if a limit will not be exceeded
%                 1 if a limit will be exceeded
%  2. LimitList - Index of which devices would exceed a limit
%
%  NOTES
%  1. For changes in setpoints use: 
%     [LimitFlag, LimitList] = checklimits(Family, DeviceList, getsp(Family, DeviceList)+DeltaSetpoints)
%  2. By default, limits are stored in MML setup in hardware units.
%
%  See also maxsp, minsp, maxpv, minpv

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input parsing %
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
elseif iscell(varargin{1})
    % Cell input
    for i = 1:length(varargin{1})
        if length(varargin) == 1
            [LimitFlag{i}, LimitList{i}] = checklimits(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) == 2
            [LimitFlag{i}, LimitList{i}] = checklimits(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
        elseif length(varargin) == 3
            [LimitFlag{i}, LimitList{i}] = checklimits(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
        else
            [LimitFlag{i}, LimitList{i}] = checklimits(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, varargin{4}{i}, UnitsFlagCell{:});
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Family = varargin{1};
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
            Setpoints = Family.Data;
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
        Setpoints = varargin{2};
    else
        Setpoints = '';
    end
    if length(varargin) >= 3
        DeviceList = varargin{3};
    else
        DeviceList = [];
    end
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

if isempty(Setpoints) || ~isnumeric(Setpoints)
    error('Setpoint input required');        
end

if size(Setpoints,1) == 1
    Setpoints = ones(size(DeviceList,1),1) * Setpoints;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


%%%%%%%%%%%%%%%%
% Check Limits %
%%%%%%%%%%%%%%%%

% Sometimes the sign gets reversed in physics units (like for defocusing quadrupoles or reverse 
% wired power supplies), so just check if it is between min and max.

MinPV = minpv(Family, Field, UnitsFlagCell{:});
MaxPV = maxpv(Family, Field, UnitsFlagCell{:});
if isempty(MinPV) || isempty(MaxPV)
    warning('%s limits unknown for %s family, hence no limits check made.', Field, Family);
    return
end

[tmp, SortIndex] = sort([MinPV Setpoints MaxPV], 2);


% 2 means the setpoint stayed in the middle column
LimitList = find(SortIndex(:,2)~=2);

if isempty(LimitList)
    LimitFlag = 0;
else
    % Limit problem
    LimitFlag = 1;
end


% MinPV = minpv(Family, Field, 'Hardware');
% MaxPV = maxpv(Family, Field, 'Hardware');
% 
% % Setpoint must be in hardware units
% if isempty(UnitsFlagCell)
%     UnitsFlagCell{1} = getunits(Family, Field);
% end
% if strcmpi(UnitsFlagCell{1}, 'Physics')
%     Setpoints = physics2hw(Family, Field, Setpoints, DeviceList);
% end

% iMax = (Setpoints > MaxPV);
% iMin = (Setpoints < MinPV);
% if any(iMin) || any(iMax) 
%     LimitFlag = 1;
%     LimitList = find(max([iMax iMin]')'==1);
% else
%     LimitFlag = 0;
%     LimitList = [];
% end
