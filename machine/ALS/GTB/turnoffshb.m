function turnoffshb(varargin)
%TURNOFFSHB - Turn off the subharmonic buncher
%
%  See also turnonshb, turnoneg, turnoffeg, turnonmps, turnoffmps

% Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%
% Subharmonic Buncher %
%%%%%%%%%%%%%%%%%%%%%%%
try
    % Pulsing Control (trigger)
    On = getpv('SHB', 'PulsingOn', [1 1]);
    if On == 1
        setpv('SHB', 'PulsingControl', 0, [1 1]);
        fprintf('   Turning off subharmonic buncher #1 pulsing (trigger)\n');
    else
        fprintf('   Subharmonic buncher #1 pulsing (trigger) is already off\n');
        setpv('SHB', 'PulsingControl', 0, [1 1]);  % Set the control anyways
    end
    
    On = getpv('SHB', 'PulsingOn', [1 2]);
    if On == 1
        setpv('SHB', 'PulsingControl', 0, [1 2]);
        fprintf('   Turning off subharmonic buncher #2 pulsing (trigger)\n');
    else
        fprintf('   Subharmonic buncher #2 pulsing (trigger) is already off\n');
        setpv('SHB', 'PulsingControl', 0, [1 2]);  % Set the control anyways
    end
    pause(.2);
    
    % High Voltage Control
    On = getpv('SHB', 'On', [1 1]);
    if On == 1
        setpv('SHB', 'OnControl', 0, [1 1]);
        fprintf('   Turning off subharmonic buncher #1 high voltage control\n');
    else
        fprintf('   Subharmonic buncher #1 high voltage control is already off\n');
        setpv('SHB', 'OnControl', 0, [1 1]);  % Set the control anyways
    end
    
    On = getpv('SHB', 'OnControl', [1 2]);
    if On == 1
        setpv('SHB', 'OnControl', 0, [1 2]);
        fprintf('   Turning off subharmonic buncher #2 high voltage control\n');
    else
        fprintf('   Subharmonic buncher #2 high voltage control is already off\n');
        setpv('SHB', 'OnControl', 0, [1 2]);  % Set the control anyways
    end
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the subharmonic buncher state\n');
end





%%%%%%%%%%%%%%%%%%%%%
% AS1 & AS2 Trigger %
%%%%%%%%%%%%%%%%%%%%%
% try
%     % It's actually the modulator trigger
%     On = getpv('MOD', 'Trigger', [1 1]);
%     if On == 1
%         setpv('MOD', 'Trigger', 0, [1 1]);
%     else
%         fprintf('   MOD1 trigger is already off\n');
%         setpv('MOD', 'Trigger', 0, [1 1]);  % Set the control anyways
%     end
%     
%     On = getpv('MOD', 'Trigger', [1 2]);
%     if On == 1
%         setpv('MOD', 'Trigger', 0, [1 2]);
%     else
%         fprintf('   MOD2 trigger is already off\n');
%         setpv('MOD', 'Trigger', 0, [1 2]);  % Set the control anyways
%     end
% catch
%     fprintf(2, '\n%s\n', lasterr);
%     fprintf(2, '   Error viewing the modulator trigger states\n');
% end
% Then turn off


