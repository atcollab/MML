function [Setpoint, Monitor, FileName] = getlattice_als(varargin)
%GETLATTICE_ALS - Get data from a StorageRingOpsData lattice file
%  [ConfigSetpoint, ConfigMonitor, FileName] = getlattice_als(Field1, Field2, ...)
%


FileName = menu('Load which lattice?','Production lattice','Injection lattice','Load from file','Exit');

% if isstr(FileName)
%    DirName = [];

if FileName == 1
    fprintf('   Loading production lattice.\n');
    [ConfigSetpoint, ConfigMonitor, FileName] = getlattice('Production');

elseif FileName == 2
    fprintf('   Loading injection lattice.\n');
    [ConfigSetpoint, ConfigMonitor, FileName] = getlattice('Injection');
    
elseif FileName == 3
    [ConfigSetpoint, ConfigMonitor, FileName] = getlattice('');

elseif FileName == 4
    Setpoint = [];
    return
else
    error('FileName did not make sense.');
end

if isempty(ConfigSetpoint)
    return
end


if nargin == 0
    Setpoint = ConfigSetpoint;
else
    for i = 1:length(varargin)
        if isfield(ConfigSetpoint, varargin{i})
            Setpoint.(varargin{i}) = ConfigSetpoint.(varargin{i});
        end
    end
end

if nargout >= 2
    if nargin == 0
        Monitor = ConfigMonitor;
    else
        for i = 1:length(varargin)
            if isfield(ConfigMonitor, varargin{i})
                ConfigMonitor.(varargin{i}) = ConfigMonitor.(varargin{i});
            end
        end
    end
end
