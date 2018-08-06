function [MC_Restore, FileName] = setmachineconfig(varargin)
%SETMACHINECONFIG - Sets the storage ring setpoints from a file or configuration data structure
%  [ConfigSetpoint, FileName] = setmachineconfig(FamilyName, FileName, WaitFlag, ExtraInputs ...)
%  [ConfigSetpoint, FileName] = setmachineconfig(FileName, WaitFlag, ExtraInputs ...)
%  [ConfigSetpoint, FileName] = setmachineconfig(MachineConfigStructure, WaitFlag, ExtraInputs ...)
%  
%  INPUTS
%  1. FamilyName - Name of family/families to set (string, string matrix, cell array of families)
%                 {Default: all families that are members of 'save/restore' and in the save configuration}
%  2. FileName - File name to get setpoint data (if necessary, include full path)
%                'Production' or 'Golden' will get the lattice from the "golden lattice" which stored in <OpsData.LatticeFile>
%                'Injection' will get the injection lattice stored in <OpsData.InjectionFile>
%                {Default: browse for the desired file}
%       or
%     MachineConfigStructure - A configuration structure as returned by getmachineconfig can also be used.
%  3. WaitFlag - {optional} (see getpv for details)
%  4. ExtraInputs - 'Display' - Dialog box prompting for what to set
%                   Extra inputs get passed to setpv (like 'Online', 'Simulator','Hardware','Physics')
%                   See >> help setpv for more details
%
%  OUTPUTS
%  1. ConfigSetpoint - Structure of data structures, each field being a family/field that was set using setmachineconfig 
%  2. FileName - Filename where the data came from (if the data came from a file)
%
%  NOTES
%  1. Since some accelerators need to do non-standard things after setting a configuration,
%     setmachineconfig looks for the existence of getfamilydata('setmachineconfigfile').  
%     If not empty, the result is sent to feval.
%  2. This function only setpoint values that are in the present 'Save/Restore' 
%
%  EXAMPLES  
%  1.  To browse for a configuration to set:
%      >> setmachineconfig; 
%
%  2.  To set to golden configuration:
%      >> setmachineconfig('Golden'); 
%      >> setmachineconfig('Golden','Display');  % To interactively change what is set
%
%  3.  To only restore the HCM and VCM corrector families from the golden lattice:
%      >> setmachineconfig('HCM', 'Golden'); 
%                or
%      >> setmachineconfig({'HCM','VCM'}, 'Golden'); 
%
%  See also getmachineconfig, machineconfigsort, machineconfig

%  Written by Greg Portmann


WaitFlag = -1;
FamilyName = [];
FileName = '';
DisplayFlag = 0;
MachineConfigStructure = [];
ErrorFlag = 0;

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
    end
end

if length(varargin) >= 1
    if iscell(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif size(varargin{1},1) > 1 && ischar(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        MachineConfigStructure = varargin{1};
        varargin(1) = [];
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end
if length(varargin) >= 1
    if iscell(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif size(varargin{1},1) > 1 && ischar(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        MachineConfigStructure = varargin{1};
        varargin(1) = [];
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end


% WaitFlag
if length(varargin) >= 1
    if isnumeric(varargin{1})
        WaitFlag = varargin{1};
        varargin(1) = [];
    end
end


% Get config structure
if isempty(MachineConfigStructure)
    AskStartQuestion = 1;
    try
        if isempty(FileName)
            % Default file
            %FileName = getfamilydata('Default', 'CNFArchiveFile');
            % Spear has an operator cluge on where to save default files
            if any(strcmpi(getfamilydata('Machine'),{'spear3','spear'}))
                DirectoryName = getfamilydata('Directory', 'GoldenConfigFiles');
            else
                DirectoryName = getfamilydata('Directory', 'ConfigData');
            end
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
            if FileName == 0
                fprintf('   No change to lattice (setmachineconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        
        elseif strcmpi(FileName,'.')
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load');
            if FileName == 0
                fprintf('   No change to lattice (setmachineconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;

        elseif any(strcmpi(FileName, {'Golden','Production'}))
            % Get the production file name (full path)
            % AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
            FileName = getfamilydata('OpsData','LatticeFile');
            [DirectoryName, FileName, Ext] = fileparts(FileName);
            if isempty(DirectoryName)
                DirectoryName = getfamilydata('Directory', 'OpsData');
            end
            FileName = fullfile(DirectoryName,[FileName, '.mat']);
            load(FileName);

        elseif strcmpi(FileName, 'Injection')
            % Get the injection file name (full path)
            % AD.OpsData.InjectionFile could have the full path else default to AD.Directory.OpsData
            FileName = getfamilydata('OpsData','InjectionFile');
            [DirectoryName, FileName, Ext] = fileparts(FileName);
            if isempty(DirectoryName)
                DirectoryName = getfamilydata('Directory', 'OpsData');
            end
            FileName = fullfile(DirectoryName,[FileName, '.mat']);
            load(FileName);
            
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
    if DisplayFlag && ~isempty(FileName) && AskStartQuestion
        tmp = questdlg(sprintf('Change the lattice to %s?', FileName),'setmachineconfig','Yes','No','No');
        if ~strcmpi(tmp,'Yes')
            fprintf('  No change made to lattice (setmachineconfig)\n');
            return
        end
    end
end


% Legacy
if exist('ConfigSetpoint', 'var')
    % Change to new method
    MachineConfigStructure = ConfigSetpoint;
end


% Build the cell array
[MC_Restore, MC_Save, SPcell] = machineconfigsort(MachineConfigStructure, FamilyName);


if DisplayFlag
    NameList = '';
    for i = 1:length(SPcell)
        NameList = strvcat(NameList, sprintf('%s.%s',SPcell{i}.FamilyName, SPcell{i}.Field));
    end
    [NameList, i, CloseFlag] = editlist(NameList,'',ones(size(NameList,1),1));
    if CloseFlag
        fprintf('   setmachinconfig canceled.\n');
        return;
    end
    SPcell = SPcell(i);
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
        ErrorFlag = 1;
        fprintf('%s\n', lasterr)
        fprintf('Trouble with setpv(''%s'',''%s''), hence ignored (setmachineconfig)\n', SPcell{k}.FamilyName, SPcell{k}.Field);
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
            catch
            end
        end
        if DisplayFlag 
            Time = clock;
            fprintf('   %s %d:%d:%.2f Lattice change complete (setmachineconfig)\n\n', datestr(clock,1), Time(4), Time(5), Time(6));
            drawnow;
        end
    catch
        ErrorFlag = 1;
        fprintf('%s\n', lasterr)
        fprintf('Error occurred waiting for Setpoint-Monitor comparison.\n');
        fprintf('Lattice is in an unknown state! (setmachineconfig)\n\n');
    end
end



% Special function call for further updates
% Note that the eval allows one to run it has a script (for better or worse).
ExtraSetFunction = getfamilydata('setmachineconfigfunction');

if ~isempty(ExtraSetFunction)
    try
        feval(ExtraSetFunction, FileName,  WaitFlag, InputFlags);
    catch
        fprintf('\n%s\n', lasterr);
        fprintf('   Warning: %s did not complete without error in setmachineconfig.', ExtraSetFunction);
    end
end

if DisplayFlag
    if ErrorFlag
        fprintf('   Machine configuration load complete with errors!!!\n\n');
    else
        fprintf('   Machine configuration load complete.\n\n');
    end
    drawnow;
end

