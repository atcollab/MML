function [CommonNames, ErrorFlag] = channel2common(ChannelNames, Field, Family)
%CHANNEL2COMMON - Convert a channel name to a common name
%  [CommonNames, ErrorFlag] = channel2common(ChannelNames, Field, Family)
%
%  INPUTS
%  1. ChannelNames - List of channel names (string, matrix, cell array)
%  2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%  3. Family - Family Name 
%              Data Structure
%              Accelerator Object
%
%  OUTPUTS
%  1. CommonNames - Common names corresponding to the common name
%                   If the common name cannot be found an empty strings 
%                   (or a blank string for matrix inputs) is returned
%  2. ErrorFlag - Number of errors found
%
%  NOTES
%  1. For DataType='vector' only the first common names is returned (DeviceList would be needed as an input)

%  Written by Greg Portmann


if nargin < 1
    error('Must have at least 1 input (''CommonNames'')');
end
if nargin < 2
    Field = '';
end
if isempty(Field)
    Field = 'Monitor';
end
if nargin < 3
    Family = '';
end

% Cell inputs
if iscell(ChannelNames)
    if iscell(Family)
        if length(Family) ~= length(ChannelNames)
            error('Family and ChannelNames must be the same size cell arrays.');
        end
    end
    if iscell(Field)
        if length(Field) ~= length(ChannelNames)
            error('Field and ChannelNames must be the same size cell arrays.');
        end
    end
    
    ErrorFlag = 0;
    for i = 1:length(ChannelNames)
        if iscell(Family)
            if iscell(Field)
                [CommonNames{i}, ErrorTmp] = channel2common(ChannelNames{i}, Field{i}, Family{i});
            else
                [CommonNames{i}, ErrorTmp] = channel2common(ChannelNames{i}, Field, Family{i});
            end
        else
            if iscell(Field)
                [CommonNames{i}, ErrorTmp] = channel2common(ChannelNames{i}, Field{i}, Family);
            else
                [CommonNames{i}, ErrorTmp] = channel2common(ChannelNames{i}, Field, Family);
            end
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return    
end
% End cell input




% Search all families
if isempty(Family)
    CommonNames = [];
    ErrorFlag = 0;
    FamilyList = getfamilylist;
    
    for i = 1:size(ChannelNames,1)
        Name = deblank(ChannelNames(i,:));
        Found = 0;
        for j = 1:size(FamilyList, 1)
            CommonName = channel2common(Name, Field, deblank(FamilyList(j,:)));
            if ~isempty(CommonName)
                Found = 1;
                break
            end
        end
        if Found
            NewCommonName = CommonName;
        else
            NewCommonName = ' ';
            ErrorFlag = ErrorFlag + 1;
        end
        CommonNames = strvcat(CommonNames, NewCommonName);
    end
    CommonNames = deblank(CommonNames);
    return
end


% CommonNames can be a matrix
CommonNames = [];
ErrorFlag = 0;
for i = 1:size(ChannelNames,1)
    Name = deblank(ChannelNames(i,:));
    
    ChannelNamesTotal = getfamilydata(Family, Field, 'ChannelNames');
    
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
        CommonNamesTotal = getfamilydata(Family, 'CommonNames');
        
        if isempty(CommonNamesTotal)
            NewCommonName = ' ';
            ErrorFlag = ErrorFlag + 1;
        else
            NewCommonName = CommonNamesTotal(k,:);
        end
    else
        NewCommonName = ' ';
        ErrorFlag = ErrorFlag + 1;
    end
    CommonNames = strvcat(CommonNames, NewCommonName);
end

CommonNames = deblank(CommonNames);
