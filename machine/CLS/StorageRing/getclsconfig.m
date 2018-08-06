function [ConfigSetpoint, ConfigMonitor] = getmachineconfig(varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getclsconfig.m 1.2 2007/03/02 09:03:18CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%GETMACHINECONFIG - Returns the present storage ring setpoints and monitors 
%  [ConfigSetpoint, ConfigMonitor] = getmachineconfig(Family, FileName, ExtraInputs ...)
%  
%  INPUTS
%  1. Family = string, string matrix, cell array of families
%              {default: all families (as returned by getfamilylist)}
%  2. FileName = File name to storage data (if necessary, include full path)
%                'Archive' will archive to the default <Directory\ConfigData\CNFArchiveFile>
%                'Golden' will make the present lattice the "golden lattice" which is
%                         stored in <OpsData.LatticeFile>
%                If FileName is not input, then the configuration will not be saved to file.
%  3. ExtraInputs - Extra inputs get passed to getsp and getam (like 'Online' or 'Simulator')
%
%  OUTPUTS
%  1. ConfigSetpoint = structure of setpoint structures
%                      each field being a family 
%  2. ConfigMonitor = structure of monitor structures
%                     each field being a family 
%
%  NOTE
%  1. Use setmachineconfig to save a configuration to file
%  2. Unknown families will be ignored
%  3. Use getmachineconfig('Golden') to store the default golden lattice
%  3. Use getmachineconfig('Archive') to archive a lattice
%
%  See also setmachineconfig
%
%  Writen by Jeff Corbett and Greg Portmann
% ----------------------------------------------------------------------------------------------


ConfigSetpoint = [];
ConfigMonitor = [];
ArchiveFlag = 0;    

% Look if 'struct' or 'numeric' in on the input line
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


if length(varargin) == 0
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


if ArchiveFlag
    % Determine file and directory name
    if strcmpi(FileName,'Archive')
        % Default file
        FileName = getfamilydata('Default','CNFArchiveFile');
        DirectoryName = getfamilydata('Directory','ConfigData');
        FileName = appendtimestamp(FileName, clock);
        [FileName, DirectoryName] = uiputfile('*.mat','Select a Lattice File', [DirectoryName FileName]);
        if FileName == 0 
            fprintf('   File not saved (getmachineconfig)\n');
            return;
        end
    elseif strcmpi(FileName, 'Golden')
        FileName = getfamilydata('OpsData','LatticeFile');
        DirectoryName = getfamilydata('Directory','OpsData');
        AnswerString = questdlg(strvcat('Are you sure you want to overwrite the default lattice file?',sprintf('File: %s',[DirectoryName FileName])),'Default Lattice','Yes','No','No');
        if strcmp(AnswerString,'Yes')
            [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);            
        else
            fprintf('   File not saved (getmachineconfig)\n');
            return;
        end
    else
        DirectoryName = '.';
    end
end


if iscell(FamilyName)
    N = length(FamilyName);
else
    N = size(FamilyName,1);
end

for i = 1:N
    if iscell(FamilyName)
        Family = deblank(FamilyName{i});        
    else
        Family = deblank(FamilyName(i,:));
    end
    
    %if strcmpi(Family, 'TUNE')
    %    continue;
    %end
    %if strcmpi(Family, 'MachineParameters')
    %    continue;
    %end
    
    FamilyType = getfamilytype(Family);
    if strcmpi(FamilyType,'BPM') | ...
            strcmpi(FamilyType,'COR') | ...
            strcmpi(FamilyType,'QUAD') | ...
            strcmpi(FamilyType,'BEND') | ...
            strcmpi(FamilyType,'STEER') | ...  
            strcmpi(FamilyType,'SEPT') | ...              
            strcmpi(FamilyType,'KICK') | ...              
            strcmpi(FamilyType,'SCRAPE') | ...              
            strcmpi(FamilyType,'CHICANE') | ... 
            strcmpi(FamilyType,'SEXT')
        %    strcmpi(FamilyType,'RF') | ...
        %    strcmpi(Family,'DCCT')
        %    strcmpi(FamilyType,'SKEWQUAD') | ...
        %    strcmpi(FamilyType,'SKEWSEXT') | ...
        % Kicker, Septum?        
        
        % Get the setpoint
        try
            if ~isempty(getfamilydata(Family,'Setpoint'))
                ConfigSetpoint.(Family) = getsp(Family, 'Struct', InputFlags{:});
            end
        catch
            fprintf('   Trouble with getsp(%s), hence ignored (getmachineconfig)\n', Family);
        end
       %skip the Monitors only what setpoints 
        %try
        %    if ~isempty(getfamilydata(Family,'Monitor'))
        %        ConfigMonitor.(Family) = getam(Family, 'Struct', InputFlags{:});
        %    end
        % catch
       %     fprintf('   Trouble with getam(%s), hence ignored (getmachineconfig)\n', Family);
       % end
    end
end


% If DCCT is not a family, then get it to the monitor output structure (only for default)
% if nargin == 0
%     if ~isfield(ConfigMonitor,'DCCT')
%         ConfigMonitor.DCCT = getdcct; 
%     end
% end


% Put fields in alphabetical order
if ~isempty(ConfigMonitor)
    ConfigMonitor = orderfields(ConfigMonitor);
end
if ~isempty(ConfigSetpoint)
    ConfigSetpoint = orderfields(ConfigSetpoint);
end


if ArchiveFlag
    % Save to file
    DirStart = pwd;
    [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);            
    save(FileName, 'ConfigMonitor', 'ConfigSetpoint');
    cd(DirStart);
    if DirectoryErrorFlag
        fprintf('   The lattice file was saved, but it did not go the desired directory (srsave)');
        fprintf('   Check %s for your data\n', DirectoryName);
    end
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getclsconfig.m  $
% Revision 1.2 2007/03/02 09:03:18CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
