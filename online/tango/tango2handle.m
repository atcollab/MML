function [Handle, ErrorFlag] = tango2handle(TangoNames, FamilyList);
% TANGO2HANDLE - Converts TANGO name to handle name
% [Handle, ErrorFlag] = tango2handle(TangoNames, Family)
%
% INPUTS
% 1. TangoNames = List of Tango names (string, matrix, or cell array)
% 2. Family = optional input to limit the search (string, matrix, structure, or cell array)
%
% OUTPUTS 
% 1. Handle = Handles corresponding to the Tango name
%             0 if Tango name cannot be found
% 2. ErrorFlag = Number of errors found
%
% Written by Laurent S. Nadolski

if nargin < 1
    error('Must have 1 input (''TangoNames'')');
end
if nargin < 2
    FamilyList = [];
end

% Cell inputs
if iscell(TangoNames)
    if iscell(FamilyList)
        if length(FamilyList) ~= length(CommonNames)
            error('Family and CommonNames must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(TangoNames)
        if iscell(FamilyList)
            [Handle{i}, ErrorFlag{i}] = tango2handle(TangoNames{i}, FamilyList{i});
        else
            [Handle{i}, ErrorFlag{i}] = tango2handle(TangoNames{i}, FamilyList);
        end
        return    
    end
end
% End cell input


ErrorFlag = 0;
Handle = [];
if isempty(FamilyList)
    FamilyList = getfamilylist;
elseif isstruct(FamilyList)
    % Structures are ok
    FamilyList = FamilyList.FamilyName;
end

for i = 1:size(TangoNames,1)
    Found = 0;
    for l = 1:size(FamilyList, 1)
        
        FamilyTest = deblank(FamilyList(l,:));
        
        Fields = fieldnames(getfamilydata(FamilyTest));
        for m = 1:length(Fields)
            TangoNamesTotal = getfamilydata(FamilyTest, Fields{m}, 'TangoNames');
            
            if ~isempty(TangoNamesTotal)
                Name = deblank(TangoNames(i,:));
                [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                
                if isempty(name) & length(Name)~=size(TangoNamesTotal)
                    Name = [repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2)) Name];
                    [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                end
                
                if isempty(name)
                    Name = deblank(TangoNames(i,:));
                    if length(Name)~=size(TangoNamesTotal)
                        Name = [Name repmat(' ',size(Name,1),size(TangoNamesTotal,2)-size(Name,2))];
                        [name,j,k] = intersect(Name, TangoNamesTotal, 'rows');
                    end
                end
                
                if ~isempty(k)
                    Found = 1;
                    break
                end
            end
            if Found
                break
            end
        end
        if Found
            break
        end
    end
    if Found
        HandleTotal = getfamilydata(FamilyTest, Fields{m}, 'Handles');
        h = HandleTotal(k,:);
    else
        h = 0;
        ErrorFlag = ErrorFlag + 1;
    end
    
    Handle = [Handle; h];
end
% if all(~Handle)
%     Handle = [];
% end
% End all family search



