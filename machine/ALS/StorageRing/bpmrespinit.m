hwinit;


% Turn off chicane correctors when getting a response matrix
%fprintf('   \n');
%setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

fprintf('   Setting storage ring corrector magnets HCM and VCM to fast mode (1000 Amp/Sec) (set HCSD, VCSF, and HCSF manually)\n');
setpv('HCM', 'RampRate', 1000, [], 0);
setpv('VCM', 'RampRate', 1000, [], 0);
