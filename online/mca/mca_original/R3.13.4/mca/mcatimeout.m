function varargout = mcatimeout(varargin)
%MCATIMEOUT set or display MCA timeoot setings
%   
%   MCATIMEOUT('io',t1, 'poll',t2, 'event', t3)  
%       'io' option sets the internal variable MCA_IO_TIMEOUT to t1 (sec)
%       'event' option sets MCA_EVENT_TIMEOUT to t2 (sec)
%       'poll' option sets MCA_POLL_TIMEOUT to t3 (sec)
%       Can set any combination or all parameters at once
%
%   MCATIMEOUT('default') sets the default values
%       MCA_IO_TIMEOUT = 1.0 (sec)
%       MCA_EVENT_TIMEOUT = 0.1 (sec)
%       MCA_POLL_TIMEOUT = 0.001 (sec)
%   
%   MCATIMEOUT with no arguments returns a vector of currently set timeouts
%       in the format [MCA_IO_TIMEOUT MCA_EVENT_TIMEOUT  MCA_POLL_TIMEOUT]  
% 
%   Notes: 
%   See also: MCAMAIN