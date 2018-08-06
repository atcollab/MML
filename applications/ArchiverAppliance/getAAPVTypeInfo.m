function [ output ] = getAAPVTypeInfo( pvname )
%GETAAPVTYPEINFO Get the type info for a given PV.
%In the archiver appliance terminology, the PVTypeInfo
%contains the various archiving parameters for a PV.
% Copyright (c) Lawrence Berkeley National Laboratory

	aa = ArchAppliance();
	output = aa.getPVTypeInfo(pvname);
end

