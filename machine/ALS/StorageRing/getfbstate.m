function [StateFlagTotal, StateBySector] = getfbstate
%GETFBSTATE - Returns the state of the fast feedback system
%
%  [StateFlagTotal, StateBySector] = getfbstate
%    
%  OUTPUTS
%  StateFlagTotal - 1 On in all sectors
%                   0 Off in at least one sector
%
%  StateBySector  - 1 On 
%  (12x1 vector)    0 Off
%
%  Written by Greg Portmann

for Sector = 1:12
    ChanNames(Sector,:) = sprintf('SR%02d____FFBON__BM00', Sector);
end

StateBySector = getpv(ChanNames);
StateFlagTotal = all(StateBySector);