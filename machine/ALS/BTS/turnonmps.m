function turnonmps(varargin)
%TURNONMPS - Turn on all the BTS magnet power supplies
%
%  See also turnoffmps



% Turn the magnets on
ExtraDelayOff = 1;
try
    setpv('HCM', 'OnControl', 1);
    fprintf('   HCM family is on\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on HCM\n');
end
try
    setpv('VCM', 'OnControl', 1);
    fprintf('   VCM family is on\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on VCM\n');
end
try
    setpv('Q', 'OnControl', 1);
    fprintf('   Quadrupole family is on\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on the quadrupole family.\n');
end
try
    setpv('BEND', 'OnControl', 1);
    fprintf('   BEND family on control set to on\n');
    pause(ExtraDelayOff);
catch
    fprintf(2, '\n%s\n', lasterr);
    fprintf(2, '   Error turning on the BEND family.\n');
end

