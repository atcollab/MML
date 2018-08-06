function Alpha = locomcf(RINGData)
%LOCOMCF - Returns the momentum compaction factor
%  Alpha = locomcf(RINGData)
%  Momentum compaction factor
%
%  Written by Greg Portmann

Alpha = mcf(RINGData.Lattice);
