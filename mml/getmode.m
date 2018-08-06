function Mode = getmode(Family, Field)
%GETMODE - Returns the present family mode ('Online', 'Simulator', 'Manual', 'Special', etc)
%  Mode = getmode(Family, Field)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              (or a cell array of the above types)
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: getfirstfield}
%
%  OUTPUTS
%  1. Mode - Mode string corresponding to the Family and Field
% 
%  NOTES
%  1. If the inputs are cell arrays, then the outputs are cell arrays
%
%  See also getunits

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
            Mode{i} = getmode(Family{i});
        elseif nargin < 3
            if iscell(Field)
                Mode{i} = getmode(Family{i}, Field{i});
            else
                Mode{i} = getmode(Family{i}, Field);
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

Mode = getfamilydata(Family, Field, 'Mode');


