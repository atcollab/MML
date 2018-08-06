function p = AccObj(Family, Field, DeviceList)
%AccObj - Class constructor for middle layer data objects
%
%  Written by Greg Portmann


AO = getao;
Families = fieldnames(AO);
for i = 1:length(Families)
    DataStruct.(Families{i}) = [];
end

if nargin == 0
    % Empty struture
    %error('Family name input required');

elseif isa(Family,'AccObj')
    if nargin >= 2
        Family.DeviceList = DeviceList;
    end
    p = get(Family);
    return;

elseif nargin == 1
    Field = 'Monitor';

    if iscell(Family)
        for i = 1:length(Family)
            if isstruct(Family{i})
                DataStruct.(Family{i}.FamilyName) = Family{i};
            elseif ischar(Family{i})
                DataStruct.(Family{i}) = family2datastruct(Family{i}, Field);
            end
        end
    elseif isstruct(Family)
        Families = fieldnames(Family);
        if any(strcmp(Families,'FamilyName'))
            % Data Structure
            DataStruct.(Family.FamilyName) = Family;
        else
            % AO structure
            DataStruct = Family;
        end
    elseif ischar(Family)
        DataStruct.(Family) = family2datastruct(Family, Field);
    else
        % Default AccObj
        DeviceList = Family;
        Family = findmemberof({'BPM','BPMx'});
        if isempty(Family)
            Family = 'BPMx';
        else
            Family = Family{1};
        end
        DataStruct.(Family) = family2datastruct(Family, Field, DeviceList);
    end

elseif nargin == 2
    if ischar(Field)
        DataStruct.(Family) = family2datastruct(Family, Field);
    else
        DeviceList = Field;
        Field = 'Monitor';
        DataStruct.(Family) = family2datastruct(Family, Field, DeviceList);
    end
    
elseif nargin >=3
    DataStruct.(Family) = family2datastruct(Family, Field, DeviceList);
end


% % Order fields (you can't change the field order of an object!!!)
% i = find(strcmp(Family, Families) == 1);
% Families(i) = [];
% Families = [{Family}; Families];
% DataStruct = orderfields(DataStruct, Families);


p = class(DataStruct, 'AccObj');

