function elem=atmonitor(fname,varargin)
%ATMONITOR(FAMNAME)
%	creates a Beam Position Monitor element with Class 'Monitor'
%
%FAMNAME		family name
%
%ATMONITOR(FAMNAME,'FIELDNAME1',VALUE1,...)
%   Each pair {'FIELDNAME',VALUE} is added to the element
%
%See also: ATDRIFT, ATSEXTUPOLE, ATSBEND, ATRBEND
%          ATMULTIPOLE, ATTHINMULTIPOLE, ATMARKER, ATCORRECTOR

[rsrc,method,~]=decodeatargs({'IdentityPass',''},varargin);
[method,rsrc]=getoption(rsrc,'PassMethod',method);
[cl,rsrc]=getoption(rsrc,'Class','Monitor');
elem=atbaselem(fname,method,'Class',cl,rsrc{:});
end
