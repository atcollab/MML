function turnoffmps(varargin)
%TURNOFFMPS - Turn off all the BTS magnet power supplies
%
%  See also turnonmps


% Ramp down magnets
ExtraDelayRamp = 5;

%[T, T_HCM]  = getramptime('HCM',  0);
%[T, T_VCM]  = getramptime('VCM', 0);
[T, T_Q]    = getramptime('Q',    0);
[T, T_BEND] = getramptime('BEND', 0);

%T_HCM  = T_HCM  .* getpv('HCM',  'On');
%T_VCM  = T_VCM  .* getpv('VCM',  'On');
T_Q    = T_Q    .* getpv('Q',    'On');
T_BEND = T_BEND .* getpv('BEND', 'On');

%T = max([T_HCM; T_VCM; T_Q; T_BEND;]); 
T = max([T_Q; T_BEND;]); 

% Zero the setpoints
setsp('HCM',  0, [], 0);
setsp('VCM',  0, [], 0);
setsp('BEND', 0, [], 0);
setsp('Q',    0, [], 0);

% Wait for the setpoints (if needed)
if T > 0
    a = clock;
    fprintf('   Pausing %.1f seconds for BTS magnets to ramp down to zero (%d:%d:%.0f) ...', T+ExtraDelayRamp, a(4), a(5), a(6));
    drawnow;
    pause(T + ExtraDelayRamp);
    a = clock;
    fprintf('  Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
end


% Turn the magnets off
ExtraDelayOff = 1.5;
try
    setpv('HCM', 'OnControl', 0);
    fprintf('   HCM family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off HCM\n');
end
try
    setpv('VCM', 'OnControl', 0);
    fprintf('   VCM family is off\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning off VCM\n');
end
try
    setpv('Q', 'OnControl', 0);
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

