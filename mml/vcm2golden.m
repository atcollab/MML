function vcm2golden(nstep)
%VCM2GOLDEN - Set vertical corrector strengths to golden values
%  vcm2golden(nstep)
%
%  INPUTS
%  1. nstep - number of step for setting correctors
%
%  See also vcm2zero, hcm2golden, hcm2zero

%  Written by Gregory J. Portmann
%  Adapted by Laurent S. Nadolski


if nargin < 1
    nstep = 5;
end


CMFamily = getvcmfamily;
CMGolden = getgolden(CMFamily);
CM0 = getsp(CMFamily);

for k = 1:nstep
    setsp(CMFamily, CM0 + k/nstep * (CMGolden-CM0), [], -1);
    pause(0.1);
end