function varargout = showtfb(varargin)
%SHOWTFB - Show some TFB data to the command window
%  [ConfigSetpoint, ConfigMonitor] = showtfb
%  
%  OUTPUTS
%  1. ConfigSetpoint - Setpoint structure
%  2. ConfigMonitor  - Monitor  structure
%  3. FileName - If data was archived, filename where the data was saved (including the path)
%
%  See also gettfbconfig

%  Written by Greg Portmann


% Golden
FileName = getfamilydata('OpsData','TFBFile');
[DirectoryName, FileName] = fileparts(FileName);
if isempty(DirectoryName)
    DirectoryName = getfamilydata('Directory', 'OpsData');
end
FileName = fullfile(DirectoryName,[FileName, '.mat']);
if ~exist(FileName,'file')
    error('The TFB golden orbit file does not exist.');
else
    load(FileName);
end


% Get the setpoint
TFB_SP = getpv('TFB', 'Setpoint', 'Struct');

% Get the monitors
TFB_AM = getpv('TFB', 'Monitor', 'Struct');


fprintf('  *****  TRANSVERSE FEEDBACK PARAMETERS  *****\n');
fprintf('               Golden     Setpoint     Monitor\n');
fprintf('   X1 Bias   %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(1), TFB_SP.Data(1), TFB_AM.Data(1));
fprintf('   Y1 Bias   %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(2), TFB_SP.Data(2), TFB_AM.Data(2));
fprintf('   X2 Bias   %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(3), TFB_SP.Data(3), TFB_AM.Data(3));
fprintf('   Y2 Bias   %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(4), TFB_SP.Data(4), TFB_AM.Data(4));

fprintf('   X ATTN    %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(5), TFB_SP.Data(5), TFB_AM.Data(5));
fprintf('   Y ATTN    %9.4f   %9.4f   %9.4f\n', ConfigSetpoint.Data(6), TFB_SP.Data(6), TFB_AM.Data(6));

fprintf('   X Delay %6d      %6d        %9.4fe-12\n', ConfigSetpoint.Data(7), TFB_SP.Data(7), TFB_AM.Data(7)/1e-12);
fprintf('   Y Delay %6d      %6d        %9.4fe-12\n', ConfigSetpoint.Data(8), TFB_SP.Data(8), TFB_AM.Data(8)/1e-12);

if getpv('tbds:X:LoopRem:Ctrl') == 0
    fprintf('   Horizontal Loop is Open\n');
else
    fprintf('   Horizontal Loop is Closed\n');
end
if getpv('tbds:Y:LoopRem:Ctrl') == 0
    fprintf('   Vertical   Loop is Open\n');
else
    fprintf('   Vertical   Loop is Closed\n');
end

fprintf('\n');


if nargout > 0
    varargout{1} = ConfigSetpoint;
    varargout{2} = ConfigMonitor;
end