function turnoffmps(varargin)
%TURNOFFMPS - Turn off all the GTB magnet power supplies
%
%  See also turnonmps


% Ramp down magnets
ExtraDelayRamp = 5;

%[T, T_BC]  = getramptime('BuckingCoil', 0);
[T, T_HCM]  = getramptime('HCM',  0);
[T, T_VCM]  = getramptime('VCM',  0);
[T, T_Q]    = getramptime('Q',    0);
[T, T_BEND] = getramptime('BEND', 0);

T_HCM  = T_HCM  .* getpv('HCM',  'On');
T_VCM  = T_VCM  .* getpv('VCM',  'On');
T_Q    = T_Q    .* getpv('Q',    'On');
T_BEND = T_BEND .* getpv('BEND', 'On');

T = max([T_HCM; T_VCM; T_Q; T_BEND;]);   % 120 is probably the maximum


% Zero the setpoints
setsp('BuckingCoil',  0, [], 0);
setsp('HCM',  0, [], 0);
setsp('VCM',  0, [], 0);
setsp('BEND', 0, [], 0);
setsp('Q',    0, [], 0);
setsp('SOL',  0, [], 0);


% Wait for the setpoints (if needed)
if T > 0
    a = clock;
    fprintf('   Pausing %.1f seconds for GTB magnets to ramp down to zero (%d:%d:%.0f) ...', T+ExtraDelayRamp, a(4), a(5), a(6));
    drawnow;
    pause(T + ExtraDelayRamp);
    a = clock;
    fprintf('  Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
end


% Turn the magnets off
ExtraDelayOff = 0.1;
try
    % Power supply off
    setpv('BuckingCoil', 'OnControl', 0);
    pause(.2);
    
    % Bulks off
    setpv('BuckingCoil', 'BulkControl', 0);
    
    fprintf('   BuckingCoil family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on Bucking Coils\n');
end

try
    % Power supply off
    setpv('HCM', 'OnControl', 0);
    pause(.2);
    
    % Bulks off
    setpv('HCM', 'BulkControl', 0);
    
    fprintf('   HCM family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off HCM\n');
end

try
    % Power supply off
    setpv('VCM', 'OnControl', 0);
    pause(.2);
    
    % Bulks off
    setpv('VCM', 'BulkControl', 0);

    fprintf('   VCM family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off VCM\n');
end

try
    % Power supply off
    setpv('Q', 'OnControl', 0);
    pause(.2);
    
    % Bulks off
    setpv('Q', 'BulkControl', 0);

    fprintf('   Quadrupole family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off the quadrupole family\n');
end

try
    setpv('BEND', 'OnControl', 0);
    fprintf('   BEND family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off the BEND family\n');
end

try
    setpv('SOL', 'OnControl', 0);
    fprintf('   Solenoids are off\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off solenoids\n');
end


