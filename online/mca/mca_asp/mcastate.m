function varargout = mcastate(varargin);
%MCASTATE returns an array of connection states for open channels
% MCASTATE is used as diagnostics prior to issuing other
% MCA commands such as MCAGET, MCAPUT and MCAMON
%
% STATES = MCASTATE(H1,H2,...,HN) returns the states of 
%   the specified channels previously opened with MCAOPEN.
%   STATES = an array of the states of the channels listed in the HANDLES
%   array
%
% [HANDLES, STATES] = MCASTATE is an array of states of all 
%   currently open channels.
%   HANDLES = an array of all the currently open channels
%   STATES = an array of the states of the channels listed in the HANDLES
%   array
%
% Possible values
% 1 - Connected: MCAGET, MCAPUT and MCAMON are valid
% 0 - Disconnected: MCAGET, MCAPUT and MCAMON will return invalid
%     data or fail. This may be due to a server/network problem or
%     if the channel was previously closed by the user with MCACLOSE
%
% See also MCAINFO, MCAOPEN, MCACLOSE.

if nargin > 0
    varargout{1} = mca(13,varargin{:});
else
    [varargout{1}, varargout{2}] = mca(12);
end
