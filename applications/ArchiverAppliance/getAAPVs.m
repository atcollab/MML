function [ output_args ] = getAAPVs( wildcard )
%getAAPVs Retrieves pv names from the archiver appliance
%getPVs Retrieve the list of pv names
%Retrieves a 1xN array of pv names, limited by an optional
%wildcard.
%Examples:
%   lst = AA.getPVs()
%       Returns all pv names in the archiver appliance.  Note
%       that this can return millions of pvs.
%   lst = AA.getPVs('cmm:*')
%       Returns all pv names that start with "cmm:"
% See also ArchAppliance.getPVs
%
% Copyright (c) Lawrence Berkeley National Laboratory
	aa = ArchAppliance();
	output_args = aa.getPVs(wildcard);

end

