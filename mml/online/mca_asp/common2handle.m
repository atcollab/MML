function [Handles, ErrorFlag] = common2handle(CommonNames, Field, Family);
%COMMON2HANDLE - Converts a common name to a MCA handle (Obsolete function)
%  [Handles, ErrorFlag] = common2handle(CommonNames, Field, Family)
%
%  INPUTS
%  1. CommonNames - List of common names (string, matrix, cell array)
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3. Family - Family Name
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              [] search all families {Default}
%
%  OUTPUTS
%  1. Handles - Handle name corresponding to the common name
%               If the common name or handle cannot be found, NaN is returned
%  2. ErrorFlag - Number of errors found
%
%  NOTES
%  1. CommonNames can be a cell array even if Field and Family are not.

% Written by Greg Portmann

if nargin < 1
    error('Must have at least 1 input (''CommonNames'')');
end
if nargin < 2
    Field = 'Monitor';
end
if nargin < 3
    Family = [];
end
if isempty(Field)
    Field = 'Monitor';
end


% Cell inputs
if iscell(CommonNames)
    if iscell(Family)
        if length(Family) ~= length(CommonNames)
            error('Family and CommonNames must be the same size cell arrays.');
        end
    end
    if iscell(Field)
        if length(Field) ~= length(CommonNames)
            error('Field and CommonNames must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(CommonNames)
        if iscell(Family)
            if iscell(Field)
                [Handles{i}, ErrorFlag{i}] = common2handle(CommonNames{i}, Field{i}, Family{i});
            else
                [Handles{i}, ErrorFlag{i}] = common2handle(CommonNames{i}, Field, Family{i});
            end
        else
            if iscell(Field)
                [Handles{i}, ErrorFlag{i}] = common2handle(CommonNames{i}, Field{i}, Family);
            else
                [Handles{i}, ErrorFlag{i}] = common2handle(CommonNames{i}, Field, Family);
            end
        end
    end
    return    
end
% End cell input



% If Family=[], search all families
if isempty(Family)
    ErrorFlag = 0;
    Handles = [];
    FamilyList = getfamilylist;
    
    for i = 1:size(CommonNames,1)
        Name = deblank(CommonNames(i,:));
        Found = 0;
        for j = 1:size(FamilyList, 1)
            [Handle, ErrorFlag1] = common2handle(Name, Field, deblank(FamilyList(j,:)));
            if ~isnan(Handle)
                Found = 1;
                break
            end
        end
        Handles = [Handles; Handle];
        ErrorFlag = ErrorFlag + ErrorFlag1;
    end
    return
end
% End all family search


% Common2handle for scalar inputs
Handles = [];
ErrorFlag = 0;
for i = 1:size(CommonNames,1)
    Name = deblank(CommonNames(i,:));
    CommonNamesTotal = getfamilydata(Family, 'CommonNames');
    
    [name,j,k] = intersect(Name, CommonNamesTotal, 'rows');

    if isempty(name) & length(Name)~=size(CommonNamesTotal)
        Name = [repmat(' ',size(Name,1),size(CommonNamesTotal,2)-size(Name,2)) Name];
        [name,j,k] = intersect(Name, CommonNamesTotal, 'rows');
    end
    
    if isempty(name)
        Name = deblank(CommonNames(i,:));
        if length(Name)~=size(CommonNamesTotal)
            Name = [Name repmat(' ',size(Name,1),size(CommonNamesTotal,2)-size(Name,2))];
            [name,j,k] = intersect(Name, CommonNamesTotal, 'rows');
        end
    end
    
    if ~isempty(k)
        HandlesTotal = getfamilydata(Family, Field, 'Handles');
        
        if isempty(HandlesTotal)
            Handle = NaN;
            ErrorFlag = ErrorFlag + 1;
        else
            if size(HandlesTotal,1) == 1
                Handle = HandlesTotal;
            else
                Handle = HandlesTotal(k,:);
            end
        end
    else
        Handle = NaN;
        ErrorFlag = ErrorFlag + 1;
    end
    Handles = [Handles; Handle];
end

