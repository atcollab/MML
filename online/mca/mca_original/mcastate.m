function status = mcastate(varargin);
%MCASTATE returns an array of connection states for open channels
% MCASTATE is used as diagnostics prior to issuing other
% MCA commands such as MCAGET, MCAPUT and MCAMON
%
% STATE = MCASTATE(H1,H2,...,HN) is an array of states of 
%   channels  previously opened with MCAOPEN identified 
%   by integer handles.
%
% STATE = MCASTATE is an array of states of all 
%   previously open channels.
%
% Possible values
% 1 - Connected: MCAGET, MCAPUT and MCAMON are valid
% 0 - Disconnected: MCAGET, MCAPUT and MCAMON will return invalid
%     data or fail. This may be due to a server/network problem or
%     if the channel was previously closed by the user with MCACLOSE
%
% See also MCAINFO, MCAOPEN, MCACLOSE.

status = mcamain(12);
if nargin>0
    handles = cat(1,varargin{:});
    status = status(handles);
end
