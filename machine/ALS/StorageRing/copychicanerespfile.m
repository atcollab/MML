function copychicanerespfile(DataFileName, ToFileName)
%COPYCHICANERESPFILE - Copies a chicane magnet to BPM response matrix file to the golden file 
%  copychicanerespfile(DataFileName, ToFileName)
%
%  Written by Greg Portmann

if nargin < 1
    DataFileName = '';
end

if nargin < 2
    ToFileName = 'Golden';
end


if isempty(DataFileName)
    DataDirectoryName = getfamilydata('Directory','BPMResponse');
    if isempty(DataDirectoryName)
        DataDirectoryName = getfamilydata('Directory','DataRoot');
    end
    [DataFileName, DataDirectoryName, FilterIndex] = uigetfile('*.mat','Select the Chicane Magnet Response Matrix File to Copy', DataDirectoryName);
    if FilterIndex == 0 
        fprintf('   File not copied (copychicanerespfile)\n');
        return;
    end
else
    [DataDirectoryName, DataFileName, ExtName] = fileparts(DataFileName);
    DataDirectoryName = [DataDirectoryName, filesep];
    DataFileName = [DataFileName, ExtName];
end


if strcmpi(ToFileName, 'Golden')
    FileName = [getfamilydata('OpsData','ChicaneRespFile'),'.mat'];
    DirectoryName = getfamilydata('Directory','OpsData');
    AnswerString = questdlg(strvcat(strvcat(strvcat('Are you sure you want to overwrite the default chicane magnet response matrix file?',sprintf('%s',[DirectoryName FileName])),'With file:'),[DataDirectoryName, DataFileName]),'Default Chicane Magnet Response','Yes','No','No');
    if strcmp(AnswerString,'Yes')
        DirStart = pwd;
        [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        cd(DirStart);
    else
        fprintf('   File not copied (copychicanerespfile)\n');
        return;
    end
end


% Backup first
BackupDirectoryName = [getfamilydata('Directory','DataRoot') 'Backup' filesep];
BackupDataFileName  = prependtimestamp(FileName);
if exist([DirectoryName, FileName],'file')
    DirStart = pwd;
    [FinalDir, ErrorFlag] = gotodirectory(BackupDirectoryName);
    if ~ErrorFlag
        copyfile([DirectoryName, FileName], [BackupDirectoryName, BackupDataFileName], 'f');
        fprintf('   File %s backup to %s\n', [DirectoryName, FileName], [BackupDirectoryName, BackupDataFileName]);
    else
        fprintf('   Problem finding/creating backup directory, hence backup made to ops directory.\n');
        copyfile([DirectoryName, FileName], [DirectoryName, BackupDataFileName], 'f');
    end
    cd(DirStart);
end


% Do the copy
copyfile([DataDirectoryName, DataFileName], [DirectoryName, FileName], 'f');
fprintf('   File %s copied to %s\n', [DataDirectoryName, DataFileName], [DirectoryName, FileName]);
