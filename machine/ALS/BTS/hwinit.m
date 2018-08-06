function hwinit(varargin)
%HWINIT - Hardware initialization script for the BTS


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


fprintf('   Initializing BTS parameters (hwinit)\n')


% SCAN Rates
% 4 -> 5 seconds
% 5 -> 2 seconds
% 6 -> 1 second
% 7 -> .5 seconds
% 8 -> .2 seconds
% 9 -> .1 seconds
try
    fprintf('   1. Setting BTS BEND magnet setpoint scan rate to 2 Hz ... ');
    setpv(family2channel('BEND', 'Setpoint'), 'SCAN', 7);  % Seemed to fix the monitor???
    setpv(family2channel('BEND', 'Monitor'),  'SCAN', 7);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting .SCAN field of one the BTS BEND Setpoint.\n');
end

% Ramp Rates
% Note: the scan rate must be set first
try
    RampRate = 20;
    fprintf('   2. Setting BTS BEND magnet ramp rate to %.1f amps / seconds ... ', RampRate);
    setpv('BEND', 'RampRate', RampRate);
    fprintf('Done\n');
catch
    fprintf(2, '\n   Error setting .SCAN field of one the BTS BEND Setpoint.\n');
end



% Commented here since it's a menu choice in btbcontrol
%setcaen('Init BTS');


fprintf('   HWINIT is complete.\n');






% Set all UDF fields (labca WarnLevel=14 seems to have removed the need for this!)
% try
%     fprintf('   0. Setting the UDF fields for all families ... ');
%     resetudferrors;
%     fprintf('Done\n');
% catch
%     fprintf(2, '\n   Error setting the UDF for all families\n');
% end

