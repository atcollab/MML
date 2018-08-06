function turnonshb(varargin)
%TURNONSHB - Turn on the subharmonic buncher
%
%  See also turnoffshb, turnoneg, turnoffeg, turnonmps, turnoffmps

% Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%
% Subharmonic Buncher %
%%%%%%%%%%%%%%%%%%%%%%%

% Read HV
% Zero HV
% turn on HV
% Turn on phase (trigger)
% Ramp HV in 5 steps 

try
    % High Voltage Control
    NSteps = 5;
    
    Dev = [1 1];
    On = getpv('SHB', 'On', Dev);
    sp = getpv('SHB', 'HVControl', Dev);          % Get the HVControl
    if On == 0
        %fprintf('   Subharmonic buncher #1 high voltage control is off (turn on manually)\n');
        setpv('SHB', 'HVControl', 0, Dev);            % Set the HVControl to zero
    end
    
    % Make sure the pulsing control (trigger) is on
    OnTrigger = getpv('SHB', 'PulsingOn', [1 1]);
    if OnTrigger == 0
        %fprintf('   Subharmonic buncher #1 pulsing (trigger) is off (turn on manually)\n');
        fprintf('   Turning on subharmonic buncher #1 trigger\n');
        setpv('SHB', 'PulsingControl', 1, Dev);
    else
        %fprintf('   Subharmonic buncher #1 pulsing (trigger) is already on\n');
        setpv('SHB', 'PulsingControl', 1, Dev);  % Set the control anyways
    end
    
    % Turn on
    if On == 0
        fprintf('   Turning on subharmonic buncher #1 and ramping up the high voltage\n');
        pause(.25);
        setpv('SHB', 'OnControl', 1, Dev);
        
        for i = 1:NSteps
            setpv('SHB', 'HVControl', sp*(i/NSteps), Dev); % Ramp the voltage in steps
            pause(.3);
        end
    else
        fprintf('   Subharmonic buncher #1 high voltage control is already on\n');
        %setpv('SHB', 'OnControl', 1, Dev);  % Set the control anyways
    end
    
    
    Dev = [1 2];
    On = getpv('SHB', 'On', Dev);
    sp = getpv('SHB', 'HVControl', Dev);          % Get the HVControl
    if On == 0
        %fprintf('   Subharmonic buncher #2 high voltage control is off (turn on manually)\n');
        setpv('SHB', 'HVControl', 0, Dev);            % Set the HVControl to zero
    end
    
    % Make sure the pulsing control (trigger) is on
    OnTrigger = getpv('SHB', 'PulsingOn', [1 1]);
    if OnTrigger == 0
        %fprintf('   Subharmonic buncher #2 pulsing (trigger) is off (turn on manually)\n');
        fprintf('   Turning on subharmonic buncher #2 trigger\n');
        setpv('SHB', 'PulsingControl', 1, Dev);
    else
        %fprintf('   Subharmonic buncher #1 pulsing (trigger) is already on\n');
        setpv('SHB', 'PulsingControl', 1, Dev);  % Set the control anyways
    end
    
    % Turn on
    if On == 0
        fprintf('   Turning on subharmonic buncher #2 and ramping up the high voltage\n');
        pause(.25);
        setpv('SHB', 'OnControl', 1, Dev);
        
        for i = 1:NSteps
            setpv('SHB', 'HVControl', sp*(i/NSteps), Dev); % Ramp the voltage in steps
            pause(.3);
        end
    else
        fprintf('   Subharmonic buncher #2 high voltage control is already on\n');
        %setpv('SHB', 'OnControl', 1, Dev);  % Set the control anyways
    end
    
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error viewing the subharmonic buncher state\n');
end





%%%%%%%%%%%%%%%%%%%%%
% AS1 & AS2 Trigger %
%%%%%%%%%%%%%%%%%%%%%

% High voltage on the modulators
% LN MD2HV  ->  turn on/off/on  (why ask why)
