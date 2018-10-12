function [ConfigSetpoint, FileName] = setmachineconfig(varargin)
%SETMACHINECONFIG - Sets the storage ring setpoints from a file or configuratino data structure
%  [ConfigSetpoint, FileName] = setmachineconfig(FamilyName, FileName, WaitFlag, ExtraInputs ...)
%  [ConfigSetpoint, FileName] = setmachineconfig(FileName, WaitFlag, ExtraInputs ...)
%  [ConfigSetpoint, FileName] = setmachineconfig(ConfigSetpoint, WaitFlag, ExtraInputs ...)
%  
%  INPUTS
%  1. FamilyName - Name of family/families to set (string, string matrix, cell array of families)
%                  {Default: all families (as returned by getfamilylist)}
%  2. FileName - File name to get setpoint data (if necessary, include full path)
%                'Production' or 'Golden' will get the lattice from the "golden lattice" which stored in <OpsData.LatticeFile>
%                'Injection' will get the injection lattice stored in <OpsData.InjectionFile>
%                {Default: browse for the desired file}
%       or
%     ConfigSetpoint - A configuration structure as returned by getmachineconfig can also be used.
%  3. WaitFlag - {optional} (see getpv for details)
%  4. ExtraInputs - Extra inputs get passed to setpv (like 'Online', 'Simulator', 'Display')
%                   See >> help setpv for more details
%
%  OUTPUTS
%  1. ConfigSetpoint - structure of setpoint structures
%                      each field being a family 
%  2. FileName - filename where the data came from (if the data came from a file)
%
%  EXAMPLES  
%  1.  To browse for a configuration to set:
%      >> setmachineconfig; 
%  2.  To set to golden configuration:
%      >> setmachineconfig('Golden'); 
%  3.  To only restore the HCM and VCM corrector families from the golden lattice:
%      >> setmachineconfig('HCM', 'Golden'); 
%                or
%      >> setmachineconfig({'HCM','VCM'}, 'Golden'); 
%
%  See also getmachineconfig
%
%  Written by Greg Portmann


WaitFlag = -1;
FamilyName = [];
FileName = '';
DisplayFlag = 0;
ConfigSetpoint = [];


% Look for keywords on the input line
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    if iscell(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif size(varargin{1},1) > 1 & ischar(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        ConfigSetpoint = varargin{1};
        varargin(1) = [];
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end
% if length(varargin) >= 1
%     if iscell(varargin{1})
%         FamilyName = varargin{1};
%         varargin(1) = [];
%     elseif size(varargin{1},1) > 1 & ischar(varargin{1})
%         FamilyName = varargin{1};
%         varargin(1) = [];
%     elseif isfamily(varargin{1})
%         FamilyName = varargin{1};
%         varargin(1) = [];
%     elseif isstruct(varargin{1})
%         ConfigSetpoint = varargin{1};
%         varargin(1) = [];
%     elseif ischar(varargin{1})
%         FileName = varargin{1};
%         varargin(1) = [];
%     end
% end

% WaitFlag
if length(varargin) >= 1
    if isnumeric(varargin{1})
        WaitFlag = varargin{1};
        varargin(1) = [];
    end
end


% Get config structure
if isempty(ConfigSetpoint)
    AskStartQuestion = 1;
    try
        if isempty(FileName)
            % Default file
            %FileName = getfamilydata('Default', 'CNFArchiveFile');
            DirectoryName = getfamilydata('Directory', 'ConfigData');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
            if FileName == 0
                fprintf('   No change to lattice (setmachineconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        elseif any(strcmpi(FileName, {'Golden','Production'}))
            FileName = getfamilydata('OpsData', 'LatticeFile');
            DirectoryName = getfamilydata('Directory', 'OpsData');
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
        elseif strcmpi(FileName, 'Injection')
            FileName = getfamilydata('OpsData', 'InjectionFile');
            DirectoryName = getfamilydata('Directory', 'OpsData');
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
        else
            % Input file name
            load(FileName);
        end
    catch
        fprintf('%s\n', lasterr)
        fprintf('No change made to lattice (setmachineconfig)\n');
        return
    end

    % Query to begin measurement
    if DisplayFlag & ~isempty(FileName) & AskStartQuestion
        tmp = questdlg(sprintf('Change the lattice to %s?', FileName),'setmachineconfig','Yes','No','No');
        if ~strcmpi(tmp,'Yes')
            fprintf('  No change made to lattice (setmachineconfig)\n');
            return
        end
    end
end


if isempty(FamilyName)
    FieldNameCell = fieldnames(ConfigSetpoint);
elseif iscell(FamilyName)
    FieldNameCell = FamilyName;
elseif size(FamilyName,1) > 1
    for i = 1:size(FamilyName,1)
        FieldNameCell{i} = FamilyName(i,:);
    end
else
    FieldNameCell = {FamilyName};
end


% Build the cell array
j = 0;
for i = 1:length(FieldNameCell)
    FieldNameCell{i} = deblank(FieldNameCell{i});
    if isfield(ConfigSetpoint, FieldNameCell{i})
        if isfield(ConfigSetpoint.(FieldNameCell{i}),'Data') & isfield(ConfigSetpoint.(FieldNameCell{i}),'FamilyName')
            j = j + 1;
            SPcell{j} = ConfigSetpoint.(FieldNameCell{i});
        else
            % Find all the subfields that are data structures
            SubFieldNameCell = fieldnames(ConfigSetpoint.(FieldNameCell{i}));
            for ii = 1:length(SubFieldNameCell)
                if isfield(ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii}),'Data') & isfield(ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii}),'FamilyName')
                    j = j + 1;
                    SPcell{j} = ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii});
                end
            end
        end
    else
        fprintf('   %s field does not exist for family, hence ignored (setmachineconfig)\n', deblank(FieldNameCell{i}));
    end
end


% Make the setpoint change w/o a WaitFlag
for k = 1:length(SPcell)
    try
        if DisplayFlag 
            Time = clock;
            %fprintf('   Setting family %s (%s %d:%d:%.2f)\n', SPcell{k}.FamilyName, datestr(clock,1), Time(4), Time(5), Time(6));
            fprintf('   %s %d:%d:%.2f Setting family %s.%s\n', datestr(clock,1), Time(4), Time(5), Time(6), SPcell{k}.FamilyName, SPcell{k}.Field);
            drawnow;
        end
        setpv(SPcell{k}, 0, InputFlags{:});
    catch
        fprintf('%s\n', lasterr)
        fprintf('Trouble with setsp(''%s'',''%s''), hence ignored (setmachineconfig)\n', SPcell{k}.FamilyName, SPcell{k}.Field);
    end
end


% Make the setpoint change with a WaitFlag
if WaitFlag ~= 0 
    try
        if DisplayFlag 
            fprintf('   Waiting for Setpoint-Monitor to be within tolerance\n');
            drawnow;
        end
        for k = 1:length(SPcell)
            try
                setpv(SPcell{k}, WaitFlag, InputFlags{:});
            end
        end
        if DisplayFlag 
            Time = clock;
            fprintf('   %s %d:%d:%.2f Lattice change complete (setmachineconfig)\n\n', datestr(clock,1), Time(4), Time(5), Time(6));
            drawnow;
        end
    catch
        fprintf('%s\n', lasterr)
        fprintf('Error occurred waiting for Setpoint-Monitor comparison.\n');
        fprintf('Lattice is in an unknown state! (setmachineconfig)\n\n');
    end
end
