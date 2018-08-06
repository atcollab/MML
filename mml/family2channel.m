function [ChannelNames, ErrorFlag] = family2channel(varargin)
%FAMILY2CHANNEL - Converts the family name to a channel name
%  ChannelName = family2channel(Family, Field, DeviceList)
%  ChannelName = family2channel(Family, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              or Cell Array of Families
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%  3. DeviceList - ([Sector Device #] or [element #]) {Default: whole family}
%
%  OUTPUTS
%  1. ChannelName - Channel name corresponding to the Family, Field, and DeviceList

%  Written by Greg Portmann


if nargin == 0
    error('Must have at least one input (''Family'')!');
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(varargin{1})
    if length(varargin) >= 3 && iscell(varargin{3})
        if length(varargin{1}) ~= length(varargin{3})
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    if length(varargin) >= 2 && iscell(varargin{2})
        if length(varargin{1}) ~= length(varargin{2})
            error('If Field is a cell array, then must be the same size as Family.');
        end
    end
    
    
    ErrorFlag = 0;
    for i = 1:length(varargin{1})
        if length(varargin) == 1
            [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i});
        elseif length(varargin) == 2
            if iscell(varargin{2})
                [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2}{i});
            else
                [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2});
            end
        else            
            if iscell(varargin{2})
                if iscell(varargin{3})
                    [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2}{i}, varargin{3}{i});
                else
                    [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2}{i}, varargin{3});
                end
            else
                if iscell(varargin{3})
                    [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2}, varargin{3}{i});
                else
                    [ChannelNames{i}, ErrorTmp] = family2channel(varargin{1}{i}, varargin{2}, varargin{3});
                end
            end
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(varargin{1})
    if isfield(varargin{1},'FamilyName') && isfield(varargin{1},'Field')
        % Data structure inputs
        Family = varargin{1}.FamilyName;

        Field = varargin{1}.Field;
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end
    else
        % AO input
        Family = varargin{1}.FamilyName;
        Field = '';
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end
        
        if isempty(Field)
            Field = 'Monitor';
        end
        if isempty(DeviceList)
            DeviceList = varargin{1}.DeviceList;
        end
        if isempty(DeviceList)
            DeviceList = family2dev(Family);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CommonName Input:  Convert common names to a varargin{3} %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ischar(DeviceList) && ~isempty(DeviceList)
            DeviceList = common2dev(DeviceList, Family);
            if isempty(DeviceList)
                error('DeviceList was a string but common names could not be found.');
            end
        end

        [i,iNotFound] = findrowindex(DeviceList, varargin{1}.DeviceList);
        if ~isempty(iNotFound)
            error('Device at found in the input structure');
        end
        ChannelNames = varargin{1}.(Field).ChannelNames(i,:);
        ErrorFlag = 0;

        return;
    end

else
    
    % Family input
    Family = varargin{1};
    
    Field = '';
    if length(varargin) >= 2
        if ischar(varargin{2})
            Field = varargin{2};
            varargin(2) = [];
        end
    end
    if length(varargin) >= 2
        DeviceList = varargin{2};
    else
        DeviceList = [];
    end
    
end

if isempty(Field)
    % Look for the first field with a channel name
    %Field = 'Monitor';
    Field = findfirstfield(Family, 1);
end

if isempty(DeviceList)
    DeviceList = family2dev(Family, Field);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%
[ChannelNames, ErrorFlag] = getfamilydata(Family, Field, 'ChannelNames', DeviceList);


% Remove cell array if one row
if size(ChannelNames,1)== 1 && iscell(ChannelNames)
    ChannelNames = ChannelNames{1};
end

