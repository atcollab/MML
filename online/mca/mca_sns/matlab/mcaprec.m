function varargout = mcaprec(varargin)
%MCAPREC       - read precision from PV's
%
% VALUES = MCAPREC(HANDLE) returns the precision field of a channel as a double
%
% The function does not handle arrays of PV handles, but only a single PV at at time.
%
%
% Error handling:
% An empty cell string array will be returned if the PV type is not ENUM.
% A matlab exception will be thrown when the PV handle is invalid,
% i.e. not the result of a successful MCAOPEN.
% Furthermore, an error can result from a 'get' timeout,
% configurable via MCATIMEOUT.
% In addition, an error can result from a network disconnect.
% In principle, one can check beforehand via MCASTATE, but since
% a disconnect might happen just between the sucessful MCASTATE call
% and the following MCAGET, the only safe thing might be to surround
% MCAGET calls with TRY....CATCH.
%
%   See also TRY, CATCH, MCASTATE, MCATIMEOUT, MCAPUT
if nargin<1
    error('No arguments were specified in mcaget')
elseif nargin==1
    if length(varargin{1})>1
        error('Only single PV can be handled at a time')
    else
        varargout{1} = mca(42,varargin{1});
    end
elseif nargin>1
    error('Only single PV can be handled at a time')
end
 
