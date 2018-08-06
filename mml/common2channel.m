function [ChannelNames, FamilyName, Field, DeviceList, ErrorFlag] = common2channel(CommonNames, Field, Family)
%COMMON2CHANNEL - Convert a common name to a channel name
%  [ChannelNames, FamilyName, Field, DeviceList, ErrorFlag] = common2channel(CommonNames, Field, Family)
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
%  1. ChannelNames - Channel name corresponding to the common name
%                  If the common name cannot be found a blank string is returned 
%  2. Family - Family Name
%  3. Field - MML field name
%  4. DeviceList - Device list
%  5. ErrorFlag - Number of errors found
%
%  NOTES
%  1. CommonNames can be a cell array even if Field and Family are not.
%
%  See also common2family, common2dev

%  Written by Greg Portmann


ErrorFlag = 0;


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
                [ChannelNames{i}, FamilyName{i}, DeviceList{i}, ErrorTmp] = common2channel(CommonNames{i}, Field{i}, Family{i});
            else
                [ChannelNames{i}, FamilyName{i}, DeviceList{i}, ErrorTmp] = common2channel(CommonNames{i}, Field, Family{i});
            end
        else
            if iscell(Field)
                [ChannelNames{i}, FamilyName{i}, DeviceList{i}, ErrorTmp] = common2channel(CommonNames{i}, Field{i}, Family);
            else
                [ChannelNames{i}, FamilyName{i}, DeviceList{i}, ErrorTmp] = common2channel(CommonNames{i}, Field, Family);
            end
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return
end
% End cell input



%%%%%%%%%%%%%%%%
% Main Program %
%%%%%%%%%%%%%%%%

% If Family=[], search all families
if isempty(Family)
    FamilyList = getfamilylist;
else
    FamilyList = Family;
end

ChannelNames = [];
FamilyName = '';
DeviceList = [];

AO = getao;

for i = 1:size(CommonNames,1)
    Name = deblank(CommonNames(i,:));
    Found = 0;
    for j = 1:size(FamilyList, 1)
        Family = deblank(FamilyList(j,:));

        % Get the common name list for this family
        if isfield(AO.(Family), 'CommonNames')
            CommonNamesTotal = AO.(Family).CommonNames;
        else
            CommonNamesTotal = '';
        end

        if ~isempty(CommonNamesTotal)
            % Look for the common name in the list
            [name, n, k] = intersect(Name, CommonNamesTotal, 'rows');

            % % Add blank spaces for missing common names
            % if isempty(name) & length(Name)~=size(CommonNamesTotal)
            %     Name = [repmat(' ',size(Name,1),size(CommonNamesTotal,2)-size(Name,2)) Name];
            %     [name,n,k] = intersect(Name, CommonNamesTotal, 'rows');
            % end
            %
            % if isempty(name)
            %     if length(Name)~=size(CommonNamesTotal)
            %         Name = [Name repmat(' ',size(Name,1),size(CommonNamesTotal,2)-size(Name,2))];
            %         [name,n,k] = intersect(Name, CommonNamesTotal, 'rows');
            %     end
            % end


            % Find the correstponding channel name
            if ~isempty(k)
                ChannelNamesTotal = AO.(Family).(Field).ChannelNames;

                if isempty(ChannelNamesTotal)
                    NewChannelName = ' ';
                    ErrorFlag = ErrorFlag + 1;
                else
                    if size(ChannelNamesTotal,1) == 1
                        NewChannelName = ChannelNamesTotal;
                    else
                        NewChannelName = ChannelNamesTotal(k,:);
                    end
                end
         
                ChannelNames = strvcat(ChannelNames, NewChannelName);
                FamilyName = strvcat(FamilyName, Family);
                DeviceList = [DeviceList; AO.(Family).DeviceList(k,:)];
                Found = 1;
                break
            end
        end
    end
    if ~Found
        ChannelNames = strvcat(ChannelNames, ' ');
        FamilyName = strvcat(FamilyName, ' ');
        DeviceList = [DeviceList; [NaN NaN]];
        ErrorFlag = ErrorFlag + 1;
    end
end

ChannelNames = deblank(ChannelNames);
FamilyName = deblank(FamilyName);

if all(isnan(DeviceList))
    DeviceList = [];
end
