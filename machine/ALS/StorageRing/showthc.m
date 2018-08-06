function varargout = showthc(varargin)
%SHOWTHC - Show some THC data to the command window
%  [ConfigSetpoint, ConfigMonitor] = showthc
%  
%  OUTPUTS
%  1. ConfigSetpoint - Setpoint structure
%  2. ConfigMonitor  - Monitor  structure
%  3. FileName - If data was archived, filename where the data was saved (including the path)
%
%  See also getthcconfig

%  Written by Greg Portmann


% Golden
FileName = getfamilydata('OpsData','THCFile');
[DirectoryName, FileName, Ext] = fileparts(FileName);
if isempty(DirectoryName)
    DirectoryName = getfamilydata('Directory', 'OpsData');
end
FileName = fullfile(DirectoryName,[FileName, '.mat']);
if ~exist(FileName,'file')
    error('The THC golden orbit file does not exist.');
else
    load(FileName);
end


% Get the setpoint
THC_SP  = getpv('THC', 'Setpoint', 'Struct');
THC_Err = getpv('THC', 'Error',    'Struct');

% Get the monitors
THC_AM = getpv('THC', 'Monitor', 'Struct');


fprintf('   ***  THIRD HARMONIC CAVITY PARAMETERS  ***\n');
fprintf('               Golden     Setpoint    Monitor\n');
fprintf('   C1       %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Setpoint.Data(1), THC_SP.Data(1), THC_AM.Data(1));
fprintf('   C2       %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Setpoint.Data(2), THC_SP.Data(2), THC_AM.Data(2));
fprintf('   C3       %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Setpoint.Data(3), THC_SP.Data(3), THC_AM.Data(3));
fprintf('   C1_Error %9.4f   %9.4f\n', ConfigSetpoint.Error.Data(1), THC_Err.Data(1));
fprintf('   C2_Error %9.4f   %9.4f\n', ConfigSetpoint.Error.Data(2), THC_Err.Data(2));
fprintf('   C3_Error %9.4f   %9.4f\n', ConfigSetpoint.Error.Data(3), THC_Err.Data(3));

% if getpv('tbds:X:LoopRem:Ctrl') == 0
%     fprintf('   Horizontal Loop is Open\n');
% else
%     fprintf('   Horizontal Loop is Closed\n');
% end
% if getpv('tbds:Y:LoopRem:Ctrl') == 0
%     fprintf('   Vertical   Loop is Open\n');
% else
%     fprintf('   Vertical   Loop is Closed\n');
% end

fprintf('\n');


if nargout > 0
    varargout{1} = ConfigSetpoint;
    varargout{2} = ConfigMonitor;
end