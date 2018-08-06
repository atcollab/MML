function copytunerespfile(DataFileName, ToFileName)
%COPYTUNERESPFILE - Copies a tune response matrix file to the golden file 
%  copytunerespfile(FromFileName, ToFileName)
%
%  INPUTS
%  1. FromFileName - File name to get data from
%  2. ToFileName - File name to write data to (Default: Golden Filename) 
%
%  See also copychrorespfile, copybpmsigmafile, copydispersionfile,
%           copydisprespfile, copymachineconfigfile, copybpmrespfile

%  Written by Greg Portmann


if nargin < 1
    DataFileName = '';
end

if nargin < 2
    ToFileName = 'Golden';
end


% Get the file
if isempty(DataFileName)
    DataDirectoryName = getfamilydata('Directory','TuneResponse');
    if isempty(DataDirectoryName)
        DataDirectoryName = getfamilydata('Directory','DataRoot');
    end
    [DataFileName, DataDirectoryName, FilterIndex] = uigetfile('*.mat','Select the TUNE Response Matrix File to Copy', DataDirectoryName);
    if FilterIndex == 0 
        fprintf('   File not copied (copytunerespfile)\n');
        return;
    end
else
    [DataDirectoryName, DataFileName, ExtName] = fileparts(DataFileName);
    DataDirectoryName = [DataDirectoryName, filesep];
    DataFileName = [DataFileName, ExtName];
end


% Where is it going
if strcmpi(ToFileName, 'Golden')
    FileName = [getfamilydata('OpsData','TuneRespFile'),'.mat'];
    DirectoryName = getfamilydata('Directory','OpsData');

    if exist([DirectoryName FileName],'file')
        AnswerString = questdlg(strvcat(strvcat(strvcat('Are you sure you want to overwrite the default TUNE response matrix file?',sprintf('%s',[DirectoryName FileName])),'With file:'),[DataDirectoryName, DataFileName]),'Default Tune Response','Yes','No','No');
    else
        AnswerString = 'Yes';
    end

    if strcmp(AnswerString,'Yes')
        DirStart = pwd;
        [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        cd(DirStart);
    else
        fprintf('   File not copied (copytunerespfile)\n');
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
