function mcaclose(varargin)
%MCACLOSE permanently closes channels
% MCACLOSE(H1,H2,...,HN) closes the channels identified by their
%    integer handles, previously opened with MCAOPEN.
%
% Note:  Once a channel is closed, it can not be used
%    by MCAGET,MCAPUT or MCAMON. It can not be reopened.
%    Use MCAOPEN again in order to connect to the same PV.
%
% See also MCAOPEN, MCASTATE, MCAINFO
if nargin <1
    error('Must specify channel handles to close');
else
    for i=1:nargin
        mca(5,varargin{i})
    end
end
