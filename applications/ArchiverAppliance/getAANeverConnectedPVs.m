function [ output ] = getAANeverConnectedPVs()
%getAANeverConnectedPVs Get a list of PVs that have never
%connected.
% Copyright (c) Lawrence Berkeley National Laboratory

	aa = ArchAppliance();
	output = aa.getNeverConnectedPVs();

end

