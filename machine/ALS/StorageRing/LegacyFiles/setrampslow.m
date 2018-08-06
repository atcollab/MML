function setrampslow
% setrampslow
%
% This routine sets the ramprates of the HCSD, HCSF, and VCSF corrector
% magnets to their "slow" (i.e., normal) speed. It uses setramp.m, which uses
% the compiled function vecsetrp. This function only works on Windows PCs.
% (Sometimes it can take two tries to get all magnets set.)

if strcmp(computer,'PCWIN')
   setramp('HCM',0);
   disp('  ');
   setramp('VCM',0);
   disp('  ');
else
   disp('  This routine only works on Windows PCs!');
end
