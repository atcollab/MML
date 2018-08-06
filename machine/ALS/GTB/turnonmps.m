function turnonmps(varargin)
%TURNONMPS - Turn on all the GTB magnet power supplies
%
%  See also turnoffmps



% Turn the magnets on
ExtraDelayOn = .2;

try
    % Bulks on
    setpv('BuckingCoil', 'BulkControl', 1);
    
    % Power supply on
    setpv('BuckingCoil', 'OnControl', 1);
    fprintf('   BuckingCoil family is on\n');
    pause(ExtraDelayOn);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on Bucking Coils\n');
end

try
    % Bulks on
    setpv('HCM', 'BulkControl', 1);
    
    % Power supply on
    setpv('HCM', 'OnControl', 1);
    fprintf('   HCM family is on\n');
    pause(ExtraDelayOn);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on HCM\n');
end

try
    % Bulks on
    setpv('VCM', 'BulkControl', 1);
    
    % Power supply on
    setpv('VCM', 'OnControl', 1);
    fprintf('   VCM family is on\n');
    pause(ExtraDelayOn);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on VCM\n');
end

try
    % Bulks on
    setpv('Q', 'BulkControl', 1);
    
    % Power supply on
    setpv('Q', 'OnControl', 1);
    fprintf('   Quadrupole family is on\n');
    pause(ExtraDelayOn);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on the quadrupole family.\n');
end

try
    setpv('BEND', 'OnControl', 1);
    fprintf('   BEND family is on\n');
    pause(ExtraDelayOn);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on the BEND family.\n');
end

try
    setpv('SOL', 'OnControl', 1);
    fprintf('   Solenoids are on\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on solenoids\n');
end




% High voltage on the modulators
% LN MD2HV  ->  turn on/off/on  (why ask why)
