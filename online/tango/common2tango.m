function [TangoNames, ErrorFlag] = common2tango(CommonNames, Field, Family);
%COMMON2TANGO - Converts common name to TANGO name
% [TangoNames, ErrorFlag] = common2tango(CommonNames, Field, Family)
%
% INPUTS  
% 1. CommonNames = List of common names (string, matrix, cell array)
% 2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
% 3. Family = Family Name 
%             Accelerator Object
%             Cell Array of Accelerator Objects or Family Names
%             [] search all families {default}
%
% OUTPUTS 
% 1. TangoNames = Channel name corresponding to the common name
%                 If the common name cannot be found an empty strings 
%                 (or a blank string for matrix inputs) is returned
% 2. ErrorFlag = Number of errors found
%
% NOTES
% 1. CommonNames can be a cell array when Field and Family are not
% 2. Returns only status 1 devices -- See StatusFlag (not done)
%
% EXAMPLES
% 1. common2tango('BPMx001')
%
% See also tango2common

%
% Written by Laurent S. Nadolski

% Status input
StatusFlag = 1;  % Only return good status devices

if nargin < 1
    error('Must have at least 1 input (''CommonNames'')');
end
if nargin < 2
    Field = 'Monitor';
end
if isempty(Field)
    Field = 'Monitor';
end
if nargin < 3
    Family = [];
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
                [TangoNames{i}, ErrorFlag{i}] = common2tango(CommonNames{i}, Field{i}, Family{i});
            else
                [TangoNames{i}, ErrorFlag{i}] = common2tango(CommonNames{i}, Field, Family{i});
            end
        else
            if iscell(Field)
                [TangoNames{i}, ErrorFlag{i}] = common2tango(CommonNames{i}, Field{i}, Family);
            else
                [TangoNames{i}, ErrorFlag{i}] = common2tango(CommonNames{i}, Field, Family);
            end
        end
    end
    return    
end
% End cell input


% If Family=[], search all families
ErrorFlag = 0;
if isempty(Family)
    TangoNames = [];
    FamilyList = getfamilylist;
    
    for i = 1:size(CommonNames,1)
        Name = deblank(CommonNames(i,:));
        Found = 0;
        for j = 1:size(FamilyList, 1)
            TangoName = common2tango(Name, Field, deblank(FamilyList(j,:)));
            if ~isempty(TangoName)
                Found = 1;
                break
            end
        end
        if Found
            NewTangoName = TangoName;
        else
            NewTangoName = ' ';
            ErrorFlag = ErrorFlag + 1;
        end
        TangoNames = strvcat(TangoNames, NewTangoName);
    end
    TangoNames = deblank(TangoNames);
    return
end
% End all family search


% Common2Tango for scalar inputs
ErrorFlag = 0;
TangoNames = [];
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
        TangoNamesTotal = getfamilydata(Family, Field, 'TangoNames');
        
        if isempty(TangoNamesTotal)
            NewTangoName = ' ';
            ErrorFlag = ErrorFlag + 1;
        else
            if size(TangoNamesTotal,1) == 1
                NewTangoName = TangoNamesTotal;
            else
                NewTangoName = TangoNamesTotal(k,:);
            end
        end
    else
        NewTangoName = ' ';
        ErrorFlag = ErrorFlag + 1;
    end
    TangoNames = strvcat(TangoNames, NewTangoName);
end

TangoNames = deblank(TangoNames);

% if ~isempty(TangoNames)
%     if (StatusFlag)
%         if ~exist('DeviceList')
%             Status = getfamilydata(Family,'Status');
%         else
%             Status = getfamilydata(Family,'Status', DeviceList);
%         end
%         TangoNames = TangoNames(find(Status));
%     end
% end
