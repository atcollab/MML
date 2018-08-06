function [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice(varargin)
%GETINJECTIONLATTICE - Get data from the injection lattice file
%  [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice(Field1, Field2, ...)
%
%  INPUTS
%  1. Family - Selected families (Default: All)
%
%  OUTPUTS
%  1. ConfigSetpoint - Setpoint structure
%  2. ConfigMonitor  - Monitor  structure
%  3. FileName       - Name of the file where the data was retrived
%
%  See also getproductionlattice, getmachineconfig, setmachineconfig

%  Written by Greg Portmann


% Get the injection file name (full path)
% AD.OpsData.InjectionFile could have the full path else default to AD.Directory.OpsData
FileName = getfamilydata('OpsData','InjectionFile');
[DirectoryName, FileName, Ext] = fileparts(FileName);
if isempty(DirectoryName)
    DirectoryName = getfamilydata('Directory', 'OpsData');
end
FileName = fullfile(DirectoryName,[FileName, '.mat']);


% Load the lattice
load(FileName);


if exist('MachineConfigStructure','var')
    % New method
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
end


% Loop for keeping only requested families
if nargin > 0
    for i = 1:length(varargin)
        if isfield(ConfigSetpoint, varargin{i})
            ConfigSetpoint = ConfigSetpoint.(varargin{i});
        else
            ConfigSetpoint = [];
        end
    end
end

% Loop for keeping only requested fields
if nargout >= 2
    if nargin > 0
        for i = 1:length(varargin)
            if isfield(ConfigMonitor, varargin{i})
                ConfigMonitor = ConfigMonitor.(varargin{i});
            else
                ConfigMonitor = [];
            end
        end
    end
end

