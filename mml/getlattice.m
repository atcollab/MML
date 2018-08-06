function [Setpoint, Monitor, FileName] = getlattice(varargin)
%GETLATTICE - Get data from a lattice file 
%  [ConfigSetpoint, ConfigMonitor, FileName] = getlattice(Field1, Field2, ..., 'FileName', 'abc.m')


% Look for keywords on the input line
FileName = '';
Setpoint = [];
Monitor  = [];
Units    = '';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Physics')
        Units = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        Units = 'Hardware';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Golden','Production'}))
        FileName = 'Production';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Injection')
        FileName = 'Injection';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, '.')
        FileName = '.';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Present')
        FileName = 'Present';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FileName')
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        else
            error('File name not on the input line');
        end
        varargin(i) = [];
    end
end


try
    if isempty(FileName)
        % Default file
        % FileName = getfamilydata('Default', 'CNFArchiveFile');
        % Spear has an operator cluge on where to save default files
        if any(strcmpi(getfamilydata('Machine'),{'spear3','spear'}))
            DirectoryName = getfamilydata('Directory', 'GoldenConfigFiles');
        else
            DirectoryName = getfamilydata('Directory', 'ConfigData');
        end
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
        if FileName == 0
            Setpoint=[]; Monitor=[]; FileName='';
            return
        end
        load([DirectoryName FileName]);
        FileName = [DirectoryName FileName];

    elseif strcmpi(FileName,'.')
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load');
        if FileName == 0
            Setpoint=[]; Monitor=[]; FileName='';
            return
        end
        load([DirectoryName FileName]);
        FileName = [DirectoryName FileName];

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
    error('getlattice');
end


if exist('MachineConfigStructure','var')
    % New method
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
end

if isempty(ConfigSetpoint)
    return
end


% Setpoints
if isempty(varargin)
    Setpoint = ConfigSetpoint;
else
    for i = 1:length(varargin)
        if isfield(ConfigSetpoint, varargin{i})
            Setpoint.(varargin{i}) = ConfigSetpoint.(varargin{i});
        else
            fprintf('   %s not found in the setpoint configuration file (%s)\n', varargin{i}, FileName);
        end
    end
end

% Hardware and physics conversions
if ~isempty(Units)
    Families = fieldnames(Setpoint);
    for i = 1:length(Families)
        Fields = fieldnames(Setpoint.(Families{i}));
        for j = 1:length(Fields)
            if strcmpi(Units, 'Hardware')
                Setpoint.(Families{i}).(Fields{j}) = physics2hw(Setpoint.(Families{i}).(Fields{j}));
            elseif strcmpi(Units, 'Physics')
                Setpoint.(Families{i}).(Fields{j}) = hw2physics(Setpoint.(Families{i}).(Fields{j}));
            end
        end
    end
end


% Monitors
if nargout >= 2
    if isempty(varargin)
        Monitor = ConfigMonitor;
    else
        for i = 1:length(varargin)
            if isfield(ConfigMonitor, varargin{i})
                Monitor.(varargin{i}) = ConfigMonitor.(varargin{i});
                %else
                %    fprintf('   %s not found in the monitor configuration file (%s)\n', varargin{i}, FileName);
            end
        end
    end

    % Hardware and physics conversions
    if ~isempty(Units)
        Families = fieldnames(Monitor);
        for i = 1:length(Families)
            Fields = fieldnames(Monitor.(Families{i}));
            for j = 1:length(Fields)
                if strcmpi(Units, 'Hardware')
                    Monitor.(Families{i}).(Fields{j}) = physics2hw(Monitor.(Families{i}).(Fields{j}));
                elseif strcmpi(Units, 'Physics')
                    Monitor.(Families{i}).(Fields{j}) = hw2physics(Monitor.(Families{i}).(Fields{j}));
                end
            end
        end
    end
end

