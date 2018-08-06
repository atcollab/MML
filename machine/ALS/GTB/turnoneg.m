function turnoneg(varargin)
%TURNONEG - Turn on the electron gun
%
%  See also turnoffeg, turnonshb, turnoffshb, turnonmps, turnoffmps

% Written by Greg Portmann



%%%%%%%%%%%%%%%%
% Electron Gun %
%%%%%%%%%%%%%%%%
try
    % AUX Power (should always be on)
    if getpv('EG______AUX____BC23') == 0
        setpv('EG______AUX____BC23', 1);
        fprintf('   EG auxilary power on\n');
    else
        fprintf('   EG auxilary power is already on\n');
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on EG auxilary power\n');
end


try
    % Heater
    On = getpv('EG______HTR____BC22');
    if On == 0
        setpv('EG______HTR____BC22', 1);
        fprintf('   Turning EG heater on\n');              
        fprintf('   Since the heater was off, wait 5 minutes before turning on the high voltage on the gun\n');
        return
    else
        fprintf('   EG heater is already on\n');
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error checking the electron gun heater control\n');
end


try
    % High Voltage
    On = getpv('EG______HV_____BC23');
    if On == 0
        setpv('EG______HV_____BC23', 1);
        fprintf('   Turning EG high voltage on\n');
    else
        fprintf('   EG high voltage is already on\n');
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the subharmonic buncher state\n');
end


