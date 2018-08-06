function [ConfigSetpoint, ConfigMonitor, FileName, MachineConfigStructure] = getmachineconfig(varargin)
%GETMACHINECONFIG - Returns or saves to file the present storage ring setpoints and monitors 
%  [ConfigSetpoint, ConfigMonitor, FileName, MachineConfig] = getmachineconfig(Family, FileName, ExtraInputs ...)
%  [ConfigSetpoint, ConfigMonitor, FileName, MachineConfig] = getmachineconfig(FileName, ExtraInputs ...)
%  
%  INPUTS
%  1. Family - String, string matrix, cell array of families
%              {Default: all families that are a memberof 'MachineConfig'}
%  2. FileName - File name to storage data (if necessary, include full path)
%                'Archive' will archive to the default <Directory\ConfigData\CNFArchiveFile>
%                          use '' to browse for a directory and file.  As usual, 'Archive',''
%                          and 'Archive', Filename will also work.
%                'Golden' will make the present lattice the "golden lattice" which is
%                         stored in <OpsData.LatticeFile>
%                If FileName is not input, then the configuration will not be saved to file.
%  3. ExtraInputs - Extra inputs get passed to getsp and getam (like 'Online' or 'Simulator')
%
%  OUTPUTS
%  1. ConfigSetpoint - Structure of setpoint structures
%                      each field being a family 
%  2. ConfigMonitor - Structure of monitor structures
%                     each field being a family 
%  3. FileName - If data was archived, filename where the data was saved (including the path)
%  4. MachineConfig - ConfigSetpoint & ConfigMonitor combined into one structure (this is the
%                     the structure that is saved to file)
%
%  NOTE
%  1. Use setmachineconfig to save a configuration to file
%  2. Unknown families will be ignored
%  3. Use getmachineconfig('Golden') to store the default golden lattice
%  4. Use getmachineconfig('Archive') to archive a lattice
%
%  See also setmachineconfig, machineconfig, machineconfigsort, getproductionlattice, getinjectionlattice

%  Written by Jeff Corbett & Greg Portmann


DirStart = pwd;

MachineConfigStructure = [];
if nargout == 0
    ArchiveFlag = 1;
    FileName = '';
else
    ArchiveFlag = 0;
    FileName = -1;
end

DisplayFlag = 1;
ErrorFlag = 0;
FileName = '';

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
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
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
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'archive')
        ArchiveFlag = 1;
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        else
            FileName = -1;
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'noarchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    end
end


if isempty(varargin)
    FamilyName = getfamilylist;
else
    if iscell(varargin{1})
        FamilyName = varargin{1};
    elseif size(varargin{1},1) > 1
        FamilyName = varargin{1};
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
    else
        FamilyName = getfamilylist;
        FileName = varargin{1};
        ArchiveFlag = 1;
    end
    varargin(1) = [];
end
if length(varargin) >= 1
    FileName = varargin{1};
    varargin(1) = [];
    ArchiveFlag = 1;
end



% Archive data structure
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'CNFArchiveFile'));
        DirectoryName = getfamilydata('Directory','ConfigData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'MachineConfig', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Save Lattice to ...', [DirectoryName FileName]);
        if FileName == 0
            disp('   Lattice configuration not saved (getmachineconfig).');
            return
        end
        FileName = [DirectoryName, FileName];

    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'CNFArchiveFile'));
        DirectoryName = getfamilydata('Directory','ConfigData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'MachineConfig', filesep];
        end
        FileName = [DirectoryName, FileName];

    elseif strcmpi(FileName, 'Golden') || strcmpi(FileName, 'Production')
        % Get the production file name (full path)
        % AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
        FileName = getfamilydata('OpsData','LatticeFile');
        [DirectoryName, FileName, Ext] = fileparts(FileName);
        if isempty(DirectoryName)
            DirectoryName = getfamilydata('Directory', 'OpsData');
        end

        FullFileName = fullfile(DirectoryName,[FileName, '.mat']);
        if exist(FullFileName,'file')
            AnswerString = questdlg({'Are you sure you want to overwrite the default lattice file?',sprintf('%s',FullFileName)},'Default Lattice','Yes','No','No');
        else
            AnswerString = 'Yes';
        end
        if ~strcmp(AnswerString,'Yes')
            disp('   Lattice configuration not saved (getmachineconfig).');
            return;
        end
        drawnow;

        % Backup first
        BackupFileName = CreateBackupFile(DirectoryName, FileName);
        FileName = FullFileName;

    elseif strcmpi(FileName, 'Injection')
        % Get the injection file name (full path)
        % AD.OpsData.InjectionFile could have the full path else default to AD.Directory.OpsData
        FileName = getfamilydata('OpsData','InjectionFile');
        [DirectoryName, FileName, Ext] = fileparts(FileName);
        if isempty(DirectoryName)
            DirectoryName = getfamilydata('Directory', 'OpsData');
        end

        FullFileName = fullfile(DirectoryName,[FileName, '.mat']);
        if exist(FullFileName,'file')
            AnswerString = questdlg({'Are you sure you want to overwrite the default injection file?',sprintf('%s',FullFileName)},'Default Lattice','Yes','No','No');
        else
            AnswerString = 'Yes';
        end
        if ~strcmp(AnswerString,'Yes')
            disp('   Injection configuration not saved (getmachineconfig).');
            return;
        end
        drawnow;

        % Backup first
        BackupFileName = CreateBackupFile(DirectoryName, FileName);
        FileName = FullFileName;
    end
end


% Get the number of families
if iscell(FamilyName)
    N = length(FamilyName);
else
    N = size(FamilyName,1);
end


% Loop over all families
for i = 1:N
    if iscell(FamilyName)
        Family = deblank(FamilyName{i});
    else
        Family = deblank(FamilyName(i,:));
    end

    % The main family MemberOf field defaults to the setpoint field
    if ismemberof(Family, 'Save/Restore') || ismemberof(Family, 'Save') || ismemberof(Family, 'MachineConfig')
        % Get the Setpoint field
        Field = 'Setpoint';
        try
            if ~isempty(getfamilydata(Family, Field))
                MachineConfigStructure.(Family).(Field) = getpv(Family, Field, 'Struct', InputFlags{:});
            end
        catch
            ErrorFlag = 1;
            fprintf('   Trouble with getpv(''%s'',''%s''), hence ignored (getmachineconfig)\n', Family, Field);
        end
    end

    % Look if any other fields are part of the 'Save/Restore', 'Save' or the legacy 'MachineConfig'
    AOFamily = getfamilydata(Family);
    FieldNameCell = fieldnames(AOFamily);
    for j = 1:size(FieldNameCell,1)
        if isfield(AOFamily.(FieldNameCell{j}),'MemberOf')
            if any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, 'Save/Restore')) || any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, 'Save')) || any(strcmpi(AOFamily.(FieldNameCell{j}).MemberOf, 'MachineConfig'))
                try
                    MachineConfigStructure.(Family).(FieldNameCell{j}) = getpv(Family, FieldNameCell{j}, 'Struct', InputFlags{:});
                catch
                    ErrorFlag = 1;
                    fprintf('   Trouble with getpv(''%s'',''%s''), hence ignored (getmachineconfig)\n', Family, FieldNameCell{j});
                end
            end
        end
    end

    % Save monitors (should be done above)
    %if nargout >= 2 || ArchiveFlag
    %    if ismemberof(Family, 'MachineConfig') || ismemberof(Family, 'Setpoint', 'MachineConfig') || ismemberof(Family, 'Monitor', 'MachineConfig') || ismemberof(Family, 'BPM') || strcmp(Family, 'DCCT')
    %        try
    %            if ~isempty(getfamilydata(Family, 'Monitor'))
    %                ConfigMonitor.(Family).Monitor = getam(Family, 'Struct', InputFlags{:});
    %            end
    %        catch
    %            fprintf('   Trouble with getam(%s), hence ignored (getmachineconfig)\n', Family);
    %        end
    %    end
    %end
end


% Put fields in alphabetical order
% (Not a good idea to change the set order)
% if ~isempty(MachineConfigStructure)
%     MachineConfigStructure = orderfields(MachineConfigStructure);
% end


if ArchiveFlag
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    save(FileName, 'MachineConfigStructure');
    cd(DirStart);
    FileName = [DirectoryName FileName];

    if DisplayFlag
        fprintf('   Machine configuration data saved to %s.mat\n', FileName);
        if ErrorFlag
            fprintf('   Warning:  The lattice file was saved, but it did not go the desired directory');
            fprintf('   Check %s for your data\n', DirectoryName);
        end
    end
else
    FileName = '';
end


% 
if nargout >= 1
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
end


% Special function call for further updates
% Note that the eval allows one to run it has a script (for better or worse).
ExtraGetFunction = getfamilydata('getmachineconfigfunction');

if ~isempty(ExtraGetFunction)
    try
        feval(ExtraGetFunction, FileName);
    catch
        fprintf('\n%s\n', lasterr);
        fprintf('   Warning: %s did not complete without error in getmachineconfig.', ExtraGetFunction);
    end
end

if DisplayFlag
    if ErrorFlag
        if ArchiveFlag
            fprintf('   Machine configuration save complete with errors!\n\n');
        else
            fprintf('   Error getting a machine configuration!\n\n');
        end
    else
        if ArchiveFlag
            fprintf('   Machine configuration save complete.\n\n');
        else
            %fprintf('   Machine configuration complete.\n\n');
        end
    end
    drawnow;
end


function BackupFileName = CreateBackupFile(DirectoryName, FileName)

BackupFileName = '';
FileName = [FileName, '.mat'];
FullFileName = fullfile(DirectoryName, FileName);

% Build the backup filename
if exist(FullFileName, 'file')
    % Append the creation time stamp to the backup file
    try
        % Check for legacy save/restore file
        load(FullFileName);
        if exist('ConfigSetpoint', 'var')
            % Change to new method
            Fields = fieldnames(ConfigSetpoint);
            TimeStamp = ConfigSetpoint.(Fields{1}).Setpoint.TimeStamp;
        else
            % New method
            if ~exist('MachineConfigStructure', 'var')
                error('Machine configuration variable not found.')
            end
            [MC_Restore, MC_Save, SPcell] = machineconfigsort(MachineConfigStructure);
            if isempty(SPcell)
                % Try the monitor structure
                Field1 = fieldnames(MC_Save);
                Field2 = fieldnames(MC_Save.(Field1{1}));
                TimeStamp = MC_Save.(Field1{1}).(Field2{1}).TimeStamp;
            else
                TimeStamp = SPcell{1}.TimeStamp;
            end
        end
        
        BackupFileName = prependtimestamp(FileName, TimeStamp);
        
    catch
        fprintf('   Unknown time stamp on the old injection lattice file, so backup file has the present time in the filename.\n');
        BackupFileName = prependtimestamp(FileName);
    end

    % Spear3 requested that the machine config backups go to a subdirectory of ConfigData instead of the normal DataRoot/Backup
    DirStart = pwd;
    %BackupDirectoryName = [getfamilydata('Directory','DataRoot') 'Backup' filesep];
    BackupDirectoryName = [getfamilydata('Directory','ConfigData'), 'GoldenBackup', filesep];
    [FinalDir, ErrorFlag] = gotodirectory(BackupDirectoryName);
    if ~ErrorFlag
        copyfile(FullFileName, [BackupDirectoryName, BackupFileName], 'f');
        fprintf('   File %s backup to %s\n', FileName, [BackupDirectoryName, BackupFileName]);
    else
        fprintf('   Problem finding/creating backup directory, hence backup made to the present directory.\n');
        copyfile(FullFileName, BackupFileName, 'f');
    end
    cd(DirStart);
end
