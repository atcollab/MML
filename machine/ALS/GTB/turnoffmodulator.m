function turnoffmodulator(varargin)
%TURNOFFMODULATOR - Turn off the linac modulator
%
%  See also turnonshb, turnoffshb, turnoneg, turnoffeg, turnonmps, turnoffmps

% Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%
% AS1 & AS2 Trigger %
%%%%%%%%%%%%%%%%%%%%%
try
    % Modulator trigger
    On = getpv('MOD', 'Trigger', [1 1]);
    if On == 1
        setpv('MOD', 'Trigger', 0, [1 1]);
        fprintf('   Turning modulator #1 trigger off\n');
    else
        fprintf('   Modulator #1 trigger is already off\n');
        setpv('MOD', 'Trigger', 0, [1 1]);  % Set the control anyways
    end
    
    On = getpv('MOD', 'Trigger', [1 2]);
    if On == 1
        setpv('MOD', 'Trigger', 0, [1 2]);
        fprintf('   Turning modulator #2 trigger off\n');
    else
        fprintf('   Modulator #2 trigger is already off\n');
        setpv('MOD', 'Trigger', 0, [1 2]);  % Set the control anyways
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the modulator trigger\n');
end


try
    % Modulator off
    On = getpv('MOD', 'HVControl', [1 1]);
    if On == 1
        setpv('MOD', 'HVControl', 0, [1 1]);
        fprintf('   Turning modulator #1 HV off\n');
    else
        fprintf('   Modulator #1 HV control is already off\n');
    end
    
    On = getpv('MOD', 'HVControl', [1 2]);
    if On == 1
        setpv('MOD', 'HVControl', 0, [1 2]);
        fprintf('   Turning modulator #2 HV off\n');
    else
        fprintf('   Modulator #2 HV control is already off\n');
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the modulator HV control\n');
end


try
    % Modulator off
    On = getpv('MOD', 'Start', [1 1]);
    if On == 1
        setpv('MOD', 'Start', 0, [1 1]);
        fprintf('   Turning modulator #1 filament off\n');
    else
        fprintf('   Modulator #1 filament is already off\n');
    end
    
    On = getpv('MOD', 'Start', [1 2]);
    if On == 1
        setpv('MOD', 'Start', 0, [1 2]);
        fprintf('   Turning modulator #2 filament off\n');
    else
        fprintf('   Modulator #2 filament is already off\n');
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the modulator filament\n');
end


