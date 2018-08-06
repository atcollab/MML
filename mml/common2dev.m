function [DeviceList, FamilyName, ErrorFlag] = common2dev(CommonNames, FamilyList)
%COMMON2DEV - Converts a common name to a device list
% [DeviceList, Family, ErrorFlag] = common2dev(CommonNames, Family)
%
%  INPUTS
%  1. CommonNames - List of common names (string, matrix, cell array)
%  2. Family - Family Names to to limit search (string or cell of strings)
%              Accelerator Object
%              '' search all families {Default}
%
%  OUTPUTS
%  1. DeviceList - DeviceList corresponding to the common name
%                  If no common names are found, an empty matrix is returned 
%                  If only some common names are not found, [NaN NaN] will be 
%                  inserted into the device list where they are not found.
%  2. Family - Family Name (since input Family can be empty)
%  3. ErrorFlag - Number of errors found
%
%  See also common2family, common2channel

%  Written by Greg Portmann


ErrorFlag = 0;


if nargin == 0
    error('Must have at least 1 input (''CommonNames'')');
end
if nargin < 2
    FamilyList = '';
end


% Cell inputs
if iscell(CommonNames)
    for i = 1:length(CommonNames)
        if iscell(FamilyList)
            [DeviceList{i}, FamilyName{i}, ErrorTmp] = common2dev(CommonNames{i}, FamilyList{i});
        else
            [DeviceList{i}, FamilyName{i}, ErrorTmp] = common2dev(CommonNames{i}, FamilyList);
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return
end
% End cell input



%%%%%%%%%%%%%%%%
% Main Program %
%%%%%%%%%%%%%%%%

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
DeviceList = [];


for i = 1:size(CommonNames,1)
    Name = deblank(CommonNames(i,:));
    Found = 0;
    for j = 1:length(FamilyCell)
        Family = FamilyCell{j};

        % Get the common name list for this family
        %CommonNamesTotal = family2common(Family);  % This is very slow if common list are not defined!!!
        if isfield(AO.(Family), 'CommonNames')
            % Real common names exist
            CommonNamesTotal = AO.(Family).CommonNames;
        else
            % Default common names 
            % Empty is used for speed.  Without predefined common names, this function
            % will slow down getpv and setpv way too much!!!
            CommonNamesTotal = ''; %family2common(Family, AO.(Family).DeviceList);
        end

        if ~isempty(CommonNamesTotal)
            % Look for the common name in the list
            if iscell(CommonNamesTotal)
                % Common names stored as a cell array
                [name,n,k] = intersect(Name, CommonNamesTotal);
            else
                [name,n,k] = intersect(Name, CommonNamesTotal, 'rows');
            end

            if ~isempty(k)
                Found = 1;
                break
            end
        end
    end
    if Found
        FamilyName = strvcat(FamilyName, Family);
        DeviceList = [DeviceList; AO.(Family).DeviceList(k,:)];
    else
        FamilyName = strvcat(FamilyName, ' ');
        DeviceList = [DeviceList; [NaN NaN]];
        ErrorFlag = ErrorFlag + 1;
    end
end


FamilyName = deblank(FamilyName);

% Only return one row if they are all the same
FamilyNameTmp = unique(FamilyName, 'rows');
if size(FamilyNameTmp,1) == 1
    FamilyName = deblank(FamilyNameTmp);
end

if all(isnan(DeviceList))
    DeviceList = [];
end
