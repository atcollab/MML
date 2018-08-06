function [Units, UnitsString] = getunits(Family, Field)
%GETUNITS - Return the present family units and units string 
%  [Units, UnitsString] = getunits(Family, Field)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              (or a cell array of the above types)
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: getfirstfield}
%
%  OUTPUTS
%  1. Units - Units ('Physics' or 'Hardware') corresponding to the Family and Field
%  2. UnitsSting - Units string corresponding to the Family and Field
% 
%  NOTES
%  1. If the inputs are cell arrays, then the outputs are cell arrays
%  2. Same as family2units
%
%  See also getmode

%  Written by Greg Portmann


if nargin == 0
    error('Must have at least one input (''Family'')!');
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if nargin < 2
            [Units{i}, UnitsString{i}] = getunits(Family{i});
        elseif nargin < 3
            if iscell(Field)
                [Units{i}, UnitsString{i}] = getunits(Family{i}, Field{i});
            else
                [Units{i}, UnitsString{i}] = getunits(Family{i}, Field);
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
    if nargin < 2
        if isfield(Family,'Field')
            Field = Family.Field;
        else
            Field = '';
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
end

if isempty(Field)
    %Field = 'Monitor';
    Field = findfirstfield(Family);
end

Units = getfamilydata(Family, Field, 'Units');

% Units string
if nargout > 1
    if strcmpi(Units,'Hardware')
        UnitsString = getfamilydata(Family, Field, 'HWUnits');    
    elseif strcmpi(Units,'Physics')
        UnitsString = getfamilydata(Family, Field, 'PhysicsUnits');    
    else
        error('Units unknown');
    end
end
