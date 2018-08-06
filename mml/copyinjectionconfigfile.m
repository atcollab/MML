function copyinjectionconfigfile(DataFileName, ToFileName)
%COPYINJECTIONCONFIGFILE - Copies a lattice file to the golden injection file 
%  copyinjectionconfigfile(FromFileName, ToFileName)
%
%  INPUTS
%  1. FromFileName - File name to get data from
%  2. ToFileName - File name to write data to (Default: Golden Filename) 
%
%  See also copymachineconfigfile, copychrorespfile, copybpmsigmafile,
%           copydispersionfile, copydisprespfile, copybpmrespfile

%  Written by Greg Portmann

if nargin < 1
    DataFileName = '';
end

if nargin < 2
    ToFileName = 'Injection';
end


% Get the file
if isempty(DataFileName)
    DataDirectoryName = getfamilydata('Directory','ConfigData');
    if isempty(DataDirectoryName)
        DataDirectoryName = getfamilydata('Directory','DataRoot');
    end
    [DataFileName, DataDirectoryName, FilterIndex] = uigetfile('*.mat','Select the Injection Lattice File to Copy', DataDirectoryName);
    if FilterIndex == 0 
        fprintf('   File not copied (copyinjectionconfigfile)\n');
        return;
    end
else
    [DataDirectoryName, DataFileName, ExtName] = fileparts(DataFileName);
    DataDirectoryName = [DataDirectoryName, filesep];
    DataFileName = [DataFileName, ExtName];
end


% Where is it going
if strcmpi(ToFileName, 'Injection')
    % Get the injection file name (full path)
    % AD.OpsData.InjectionFile could have the full path else default to AD.Directory.OpsData
    FileName = getfamilydata('OpsData','InjectionFile');
    [DirectoryName, FileName, Ext, VerNumber] = fileparts(FileName);
    if isempty(DirectoryName)
        DirectoryName = getfamilydata('Directory', 'OpsData');
    end
    FileNameGolden = [FileName, '.mat'];
    FileName = fullfile(DirectoryName,[FileName, '.mat']);
    
    if exist(FileName, 'file')
        AnswerString = questdlg(strvcat(strvcat(strvcat('Are you sure you want to overwrite the default injection file?',sprintf('%s', FileName)),'With file:'),[DataDirectoryName, DataFileName]),'Default Lattice','Yes','No','No');
    else
        AnswerString = 'Yes';
    end

    if strcmp(AnswerString,'Yes')
        DirStart = pwd;
        [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        cd(DirStart);
    else
        fprintf('   File not copied (copyinjectionconfigfile)\n');
        return;
    end
else
    FileName = ToFileName;
end


% Backup first
if exist(FileName,'file')
    DirStart = pwd;
    %BackupDirectoryName = [getfamilydata('Directory','DataRoot') 'Backup' filesep];
    %BackupDataFileName  = prependtimestamp(FileNameGolden);
    BackupDirectoryName = [getfamilydata('Directory','ConfigData'), 'GoldenBackup', filesep];

    try
        load(FileName,'ConfigSetpoint');
        Fields = fieldnames(ConfigSetpoint);
        BackupDataFileName = prependtimestamp(FileNameGolden, ConfigSetpoint.(Fields{1}).Setpoint.TimeStamp);
        clear ConfigSetpoint
    catch
        fprintf('   Unknown time stamp on the old injection lattice file, so backup file has the present time in the filename.\n');
        BackupDataFileName = prependtimestamp(FileNameGolden);
    end

    [FinalDir, ErrorFlag] = gotodirectory(BackupDirectoryName);
    if ~ErrorFlag
        copyfile(FileName, [BackupDirectoryName, BackupDataFileName], 'f');
        fprintf('   File %s backup to %s\n', FileName, [BackupDirectoryName, BackupDataFileName]);
    else
        fprintf('   Problem finding/creating backup directory, hence backup made to the present directory.\n');
        copyfile(FileName, BackupDataFileName, 'f');
    end
    cd(DirStart);

    % Backup first
    % BackupDirectoryName = [getfamilydata('Directory','DataRoot') 'Backup' filesep];
    % BackupDataFileName  = prependtimestamp(FileName);
    % DirStart = pwd;
    % [FinalDir, ErrorFlag] = gotodirectory(BackupDirectoryName);
    % if ~ErrorFlag
    %     copyfile([DirectoryName, FileName], [BackupDirectoryName, BackupDataFileName], 'f');
    %     fprintf('   File %s backup to %s\n', [DirectoryName, FileName], [BackupDirectoryName, BackupDataFileName]);
    % else
    %     fprintf('   Problem finding/creating backup directory, hence backup made to ops directory.\n');
    %     copyfile([DirectoryName, FileName], [DirectoryName, BackupDataFileName], 'f');
    % end
end


% Do the copy
copyfile([DataDirectoryName, DataFileName], FileName, 'f');
fprintf('   File %s copied to %s\n', [DataDirectoryName, DataFileName], FileName);

