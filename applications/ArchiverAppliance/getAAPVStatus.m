function [ output_args ] = getAAPVStatus( pvnames )
%getAAPVStatus Get the status of a PV
%Retrieves the archiving status of one or more pvs.
%param pvnames: the name(s)of the pv for which status
%is to be determined. If a pv is not being archived, 
%the returned status will be "Not being archived."
%You can also pass in GLOB wildcards here and
%multiple PVs as vector.
% See also ArchAppliance.getPVStatus

	aa = ArchAppliance();
	output_args = aa.getPVStatus(pvnames);

end

