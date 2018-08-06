function [Handle, ErrorFlag] = channel2handle(ChannelNames, FamilyList)
%CHANNEL2HANDLE - Returns the MCA handle (obsolete)
%  [Handle, ErrorFlag] = channel2handle(ChannelNames, Family)
%
%  INPUTS
%  1. ChannelNames - List of channel names (string, matrix, cell array)
%  2. Family - Family Name 
%              Data Structure
%              Accelerator Object
%
%  OUTPUTS
%  1. Handle - Handles corresponding to the channel name
%              0 if channel name cannot be found
%  2. ErrorFlag - Number of errors found

%  Written by Greg Portmann



if nargin < 1
    error('Must have 1 input (''ChannelNames'')');
end
if nargin < 2
    FamilyList = [];
end

% Cell inputs
if iscell(ChannelNames)
    if iscell(FamilyList)
        if length(FamilyList) ~= length(CommonNames)
            error('Family and CommonNames must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(ChannelNames)
        if iscell(FamilyList)
            [Handle{i}, ErrorFlag{i}] = channel2handle(ChannelNames{i}, FamilyList{i});
        else
            [Handle{i}, ErrorFlag{i}] = channel2handle(ChannelNames{i}, FamilyList);
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

for i = 1:size(ChannelNames,1)
    Found = 0;
    for l = 1:size(FamilyList, 1)
        
        FamilyTest = deblank(FamilyList(l,:));
        
        Fields = fieldnames(getfamilydata(FamilyTest));
        for m = 1:length(Fields)
            ChannelNamesTotal = getfamilydata(FamilyTest, Fields{m}, 'ChannelNames');
            
            if ~isempty(ChannelNamesTotal)
                Name = deblank(ChannelNames(i,:));
                [name,j,k] = intersect(Name, ChannelNamesTotal, 'rows');
                
                if isempty(name) & length(Name)~=size(ChannelNamesTotal)
                    Name = [repmat(' ',size(Name,1),size(ChannelNamesTotal,2)-size(Name,2)) Name];
                    [name,j,k] = intersect(Name, ChannelNamesTotal, 'rows');
                end
                
                if isempty(name)
                    Name = deblank(ChannelNames(i,:));
                    if length(Name)~=size(ChannelNamesTotal)
                        Name = [Name repmat(' ',size(Name,1),size(ChannelNamesTotal,2)-size(Name,2))];
                        [name,j,k] = intersect(Name, ChannelNamesTotal, 'rows');
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



