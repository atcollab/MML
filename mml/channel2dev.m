function [DeviceList, FamilyName, Field, ErrorFlag] = channel2dev(ChannelNames, FamilyList)
%CHANNEL2DEV - Converts a channel name list to a device list
%  [DeviceList, Family, Field, ErrorFlag] = channel2dev(ChannelNames, Family)
%
%  INPUTS
%  1. ChannelNames - List of channel names (string, matrix, cell array)
%  2. Family - Family Names to to limit search (string or cell of strings)
%              Accelerator Object
%              '' search all families until 1 match is found {Default}
%
%  OUTPUTS
%  1. DeviceList - DeviceList corresponding to the channel name
%                  If a channel name match is not found, an empty matrix is returned. 
%                  For a matrix input, if only some for channel names are not found, 
%                  [NaN NaN] will be inserted into the device list where they are not found.
%  2. Family - Family Name (since input Family can be empty)
%              If the channel name cannot be found an empty strings 
%              (or a blank string for matrix inputs) is returned
%  3. Field - Field Name
%  4. ErrorFlag - Number of errors found
%
%  See also channel2family, family2dev, common2channel

%  Written by Greg Portmann


ErrorFlag = 0;


if nargin < 1
    error('Must have 1 input (''ChannelNames'')');
end
if nargin < 2
    FamilyList = '';
end

% Cell inputs
if iscell(ChannelNames)
    if iscell(FamilyList)
        if length(FamilyList) ~= length(ChannelNames)
            error('Family and ChannelNames must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(ChannelNames)
        if iscell(FamilyList)
            [DeviceList{i}, ErrorTmp] = channel2dev(ChannelNames{i}, FamilyList{i});
        else
            [DeviceList{i}, ErrorTmp] = channel2dev(ChannelNames{i}, FamilyList);
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return;
end
% End cell input



% Determine what is in Input #2
if isstruct(FamilyList)
    if isfield(FamilyList,'FamilyName') && isfield(FamilyList,'Field')
        % Data structure input - select the FamilyName from the structure
        AO = getao;
        FamilyCell = {FamilyList.FamilyName};
    else
        % AO structure input
        FamilyCell = {FamilyList.FamilyName};
        AO.(FamilyCell{1}) = FamilyList;
    end
elseif isempty(FamilyList)
    % Search in all families
    AO = getao;
    FamilyCell = fieldnames(AO);
elseif iscell(FamilyList)
    % Search in all families in FamilyList
    AO = getao;
elseif ischar(FamilyList)
    % Only search in one family
    AO = getao;
    FamilyCell = {FamilyList};
end



% Start the search
FamilyName = '';
Field = '';
DeviceList = [];


for i = 1:size(ChannelNames,1)
    Found = 0;
    for j = 1:length(FamilyCell)
        FamilyTest = deblank(FamilyCell{j});
        Fields = fieldnames(AO.(FamilyTest));
        for k = 1:length(Fields)
            if isfield(AO.(FamilyTest).(Fields{k}), 'ChannelNames')
                ChannelNamesTotal = AO.(FamilyTest).(Fields{k}).ChannelNames;

                Name = deblank(ChannelNames(i,:));
                if iscell(ChannelNamesTotal)
                    [name,jj,n] = intersect(Name, ChannelNamesTotal);
                else
                    [name,jj,n] = intersect(Name, ChannelNamesTotal, 'rows');
                end
                
                if ~isempty(n)
                    Found = 1;
                    break
                end
            end
        end
        if Found
            break
        end
    end

    if Found
        FamilyName = strvcat(FamilyName, FamilyTest);
        Field = strvcat(Field, Fields{k});
        DeviceList = [DeviceList; AO.(FamilyTest).DeviceList(n,:)];
    else
        FamilyName = strvcat(FamilyName, ' ');
        Field = strvcat(Field, ' ');
        DeviceList = [DeviceList; [NaN NaN]];
        ErrorFlag = ErrorFlag + 1;
    end
end


FamilyName = deblank(FamilyName);
Field = deblank(Field);

if all(isnan(DeviceList))
    DeviceList = [];
end
