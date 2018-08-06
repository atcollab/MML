function info = getAACurrentlyDisconnectedPVs()
%GETAACURRENTLYDISCONNECTEDPVS Get a list of PVs that are
%currently disconnected.
% Copyright (c) Lawrence Berkeley National Laboratory

	aa = ArchAppliance();
	info = aa.getCurrentlyDisconnectedPVs();

end

