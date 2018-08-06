function [MC_Restore, MC_Save, SPcell] = machineconfigsort(MachineConfigStructure, FamilyName)
%MACHINECONFIGSORT - Separates the configuration file into restore values and just for viewing 
% [MC_Restore, MC_Save, SPCell] = machineconfigsort(MachineConfigStructure, FamilyName {opt.})
% [MC_Restore, MC_Save, SPCell] = machineconfigsort(FileName, FamilyName {opt.})

MC_Restore = []; 
MC_Save = [];
SPcell = {};

if nargin < 1
    error('Input #1: Configuration structure or filename required.');
elseif ischar(MachineConfigStructure)
    load(MachineConfigStructure);
    if exist('ConfigSetpoint', 'var')
        % Change to new method
        MC_Restore = ConfigSetpoint;
        MC_Save    = ConfigMonitor;
        return;
    end
end


if nargin < 2
    FamilyName = {};
elseif iscell(FamilyName)
    FamilyNameCell = FamilyName;
elseif ischar(FamilyName)
    for i = 1:size(FamilyName,1)
        FamilyNameCell{i} = deblank(FamilyName(i,:));
    end
end

if isempty(FamilyName)
    if isempty(MachineConfigStructure)
        return
    end
    FamilyNameCell = fieldnames(MachineConfigStructure);
end


% Build the structure and cell array
j = 0;
NameList = '';
for i = 1:length(FamilyNameCell)
    FamilyNameCell{i} = deblank(FamilyNameCell{i});
    if isfield(MachineConfigStructure, FamilyNameCell{i})
        FamilyStruct = MachineConfigStructure.(FamilyNameCell{i});
        if isfield(FamilyStruct,'Data') && isfield(FamilyStruct,'FamilyName')
            % Very legacy: there have been fields in the MachineConfigStructure structure for a while
            j = j + 1;
            SPcell{j} = FamilyStruct;
            MC_Restore.(FamilyStruct.FamilyName).(FamilyStruct.Field) = FamilyStruct;
            NameList = strvcat(NameList, sprintf('%s',FamilyNameCell{i}));
        else
            % Find all the subfields that are data structures and a restore field in the AO
            FieldNameCell = fieldnames(FamilyStruct);
            for ii = 1:length(FieldNameCell)
                DataStruct = FamilyStruct.(FieldNameCell{ii});
                if isfield(DataStruct,'Data') && isfield(DataStruct,'FamilyName')
                    % Only restore if the present MML requests it                    
                    %isRestore = any(strcmpi(AOFamily.(FieldNameCell{ii}).MemberOf, 'Save/Restore')) | any(strcmpi(AOFamily.(FieldNameCell{ii}).MemberOf, 'Save')) | any(strcmpi(AOFamily.(FieldNameCell{ii}).MemberOf, 'MachineConfig'));
                    isRestore = ismemberof(FamilyNameCell{i}, FieldNameCell{ii}, 'Save/Restore') | ismemberof(FamilyNameCell{i}, FieldNameCell{ii}, 'MachineConfig');
                    if ~isRestore && strcmpi(FieldNameCell{ii}, 'Setpoint')
                        % Special case: if setpoint, then also check the main field
                        if ismemberof(FamilyNameCell{i},'Save/Restore') || ismemberof(FamilyNameCell{i},'MachineConfig');
                            isRestore = 1;
                        end
                    end
                    if isRestore
                        j = j + 1;
                        SPcell{j} = DataStruct;
                        MC_Restore.(FamilyNameCell{i}).(FieldNameCell{ii}) = DataStruct;
                    else
                        % Add to save only struct
                        MC_Save.(FamilyNameCell{i}).(FieldNameCell{ii}) = DataStruct;
                    end
                end
            end
        end
    else
        fprintf('   %s field does not exist for family, hence ignored (machineconfigsort)\n', deblank(FamilyNameCell{i}));
    end
end
