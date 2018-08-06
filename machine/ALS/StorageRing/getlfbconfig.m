function [ConfigSetpoint, ConfigMonitor, FileName] = getlfbconfig(varargin)
%GETLFBCONFIG - Returns or saves to file the present LFB setpoints
%  [ConfigSetpoint, ConfigMonitor, FileName] = getlfbconfig(FileName)
%  
%  INPUTS
%  1. FileName - File name to storage data (if necessary, include full path)
%                'Archive' will archive to the default <Directory\LFBData\LFBArchiveFile>
%                          use '' to browse for a directory and file.  As usual, 'Archive',''
%                          and 'Archive', Filename will also work.
%                'Golden' - Save to the "Golden file"
%                If FileName is not input, then the configuration will not be saved to file.
%
%  OUTPUTS
%  1. ConfigSetpoint - Setpoint structure
%  2. ConfigMonitor  - Monitor  structure
%  3. FileName - If data was archived, filename where the data was saved (including the path)
%
%  NOTE
%  1. Use getlfbconfig('Golden') to store the default golden lattice
%  2. Use getlfbconfig('Archive') to archive
%
%  See also setlfbconfig, showlfb, getmachineconfig, getproductionlattice, getinjectionlattice

%  Written by Greg Portmann


ConfigSetpoint = [];
ConfigMonitor  = [];

if nargout == 0
    ArchiveFlag = 1;
    FileName = '';
else
    ArchiveFlag = 0;
    FileName = -1;
end
DisplayFlag = 1;

FileName = '';

% Look for keywords on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'archive')
        ArchiveFlag = 1;
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'noarchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    FileName = varargin{1};
    varargin(1) = [];
    ArchiveFlag = 1;
end



% Archive data structure
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'LFBArchiveFile'));
        DirectoryName = getfamilydata('Directory','LFBData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'LFB', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Save LFB config to ...', [DirectoryName FileName]);
        if FileName == 0
            disp('   LFB configuration not saved (getlfbconfig).');
            return
        end
        FileName = [DirectoryName, FileName];
        
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'LFBArchiveFile'));
        DirectoryName = getfamilydata('Directory', 'LFBData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'LFB', filesep];
        end
        FileName = [DirectoryName, FileName];
        
    elseif strcmpi(FileName, 'Golden') || strcmpi(FileName, 'Production')
        % Get the production file name (full path)
        % AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
        FileName = getfamilydata('OpsData','LFBFile');
        [DirectoryName, FileName, Ext] = fileparts(FileName);
        if isempty(DirectoryName)
            DirectoryName = getfamilydata('Directory', 'OpsData');
        end
        FileNameGolden = [FileName, '.mat'];
        FileName = fullfile(DirectoryName,[FileName, '.mat']);
        
        if exist(FileName,'file')
            AnswerString = questdlg({'Are you sure you want to overwrite the default lattice file?',sprintf('%s',FileName)},'Default Lattice','Yes','No','No');
        else
            AnswerString = 'Yes';
        end

        if ~strcmp(AnswerString,'Yes')
            disp('   Lattice configuration not saved (getlfbconfig).');
            return;
        end
        
        % Backup first
        if exist(FileName,'file')
            DirStart = pwd;
            BackupDirectoryName = [getfamilydata('Directory','DataRoot') 'Backup' filesep];

            try
                load(FileName, 'ConfigSetpoint');
                BackupDataFileName = prependtimestamp(FileNameGolden, ConfigSetpoint.TimeStamp);
                clear TimeStamp
            catch
                fprintf('   Unknown time stamp on the old production lattice file, so backup file has the present time in the filename.\n');
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
        end
    end
end


% Get the setpoint
[LFBMonitor, LFBSetpoint, LFBMonitorNames, LFBSetpointNames] = getlfb;
 

if ArchiveFlag
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    save(FileName, 'LFBMonitor', 'LFBSetpoint', 'LFBMonitorNames', 'LFBSetpointNames');
    cd(DirStart);
    FileName = [DirectoryName FileName];
    
    if DisplayFlag
        fprintf('   Machine configuration data saved to %s.mat\n', FileName);
        if ErrorFlag
            fprintf('   Warning:  The LFB config file was saved, but it did not go the desired directory');
            fprintf('   Check %s for your data\n', DirectoryName);
        end
    end
else
    FileName = '';
end

