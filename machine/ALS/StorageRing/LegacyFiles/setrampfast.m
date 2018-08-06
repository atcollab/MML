function setrampfast
% setrampfast
%
% This routine sets the ramprates of the HCSD, HCSF, and VCSF corrector
% magnets to their "fast" speed. It uses setramp.m, which uses the compiled
% function vecsetrp. This function only works on Windows PCs.
% (Sometimes it can take two tries to get all magnets set.)

if strcmp(computer,'PCWIN')
   setramp('HCM',1);
   disp('  ');
   setramp('VCM',1);
   disp('  ');
else
   disp('  This routine only works on Windows PCs!');
end
