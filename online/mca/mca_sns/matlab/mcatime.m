function varargout = mcatime(varargin)
%MCATIME      - read timestamps for PVs previously read with MCAGET or MCAMON
%
% The timestamp is returned as a MATLAB serial date number suitable
% for use in the DATESTR function.
%
% The original time stamp is in the UTC timezone,
% but since Matlab doesn't handle timezones in datenum/datastr,
% it's converted to the 'local' timezone, so that
%    datestr(mcatime(pv))
% should give a time that is close to the wall clock
% for channels that changed recently.
%
% VALUE = MCATIME(HANDLE) 
%    returns the timestamp of a PV specified by integer HANDLE.
%
% [VALUE1, ... VALUEN] = MCATIME(HANDLE1, ... , HANDLEN)
%    returns timestamps of multiple PVs of any type and length
%    Number of outputs must match the number of inputs
%       
%   See also MCAGET, MCAMON.
%
for i=1:nargin
	% We get y/m/d H:M:S plus nanosecs...
    pieces = mca(60,varargin{i});
    % but datenum doesn't handle nanosecs
    varargout{i} = datenum(pieces(1:6));
end

