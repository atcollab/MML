function turnoffeg(varargin)
%TURNOFFEG - Turn off the electron gun
%
%  See also turnoneg, turnonshb, turnoffshb, turnonmps, turnoffmps

% Written by Greg Portmann


%%%%%%%%%%%%%%%%
% Electron Gun %
%%%%%%%%%%%%%%%%
try
    % High Voltage
    On = getpv('EG______HV_____BC23');
    if On == 1
        setpv('EG______HV_____BC23', 0);
        fprintf('   Turning EG high voltage off\n');
    else
        fprintf('   EG high voltage is already off\n');
    end
    
    % Heater
    % Don't turn off the heater, since it takes 5-minutes to turn back on
    % On = getpv('EG______HTR____BC22');
    % if On == 1
    %     setpv('EG______HTR____BC22', 0);
    %     fprintf('   Turning EG heater off\n');
    % else
    %     fprintf('   EG heater is already off\n');
    % end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the subharmonic buncher state\n');
end


% Never turn off the auxilary power (even on shutdown days)
% try
%     % 'AUX On/Off'
%     setpv('EG______AUX____BC23', 0);
%     fprintf('   EG auxilary power off\n');
% catch
%     fprintf(2, '\n%s\n', lasterr);
%     fprintf(2, '   Error turning off EG auxilary power\n');
% end


