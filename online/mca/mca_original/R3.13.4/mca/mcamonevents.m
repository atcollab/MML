function eventcount = mcamonevents(varargin)
%MCAMON install or repalace monitor on a PV
%
% EVENTCOUNT = MCAMONEVENTS
% EVENTCOUNT = MCAMONEVENTS(HANDLES)
%
% See also MCAMON MCACACHE, MCAGET, MCACLEARMON.

eventcount = mcamain(510);

if nargin > 0 & isnumeric(varargin{1})
    eventcount = eventcount(varargin{1});
end