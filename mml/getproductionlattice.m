function [ConfigSetpoint, ConfigMonitor, FileName] = getproductionlattice(varargin)
%GETPRODUCTIONLATTICE - Get data from the production (golden) lattice file
%  [ConfigSetpoint, ConfigMonitor, FileName] = getproductionlattice(Field1, Field2, ...)
%
%  INPUTS
%  1. Family - Selected families (Default: All)
%
%  OUTPUTS
%  1. ConfigSetpoint - Setpoint structure
%  2. ConfigMonitor  - Monitor  structure
%  3. FileName       - Name of the file where the data was retrived
%
%  See also getinjectionlattice, getlattice, getmachineconfig, setmachineconfig

%  Written by Greg Portmann


% Get the production file name (full path)
% AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
FileName = getfamilydata('OpsData','LatticeFile');
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

if isempty(ConfigSetpoint)
    return
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

