function varargout = mcacheck(varargin)
%MCACHECK check if PV connected.  Return of 0 = not connected.
%
%   VALUE = MCACHECK(HANDLE) returns status given integer HANDLE
%	
%
%   [ VALUE1 , ... VALUEN ] = MCACHECK(HANDLE1, ... , HANDLEN)
%       returns connect states of multiple PV's.
%       Naumber of outputs must match the number of inputs
%       
%   Return values are matlab doubles.
%
%   Notes:
%   1.It may be more convenient to arrange handles and values in cell arrays 
%   HANDLES = {HANDLE1, ... , HANDLEN }
%   [VAUES{1:N}] = MCACHECK(HANDLES{:}) See MATLAB documentation on the use of 
%   comma separated lists and cell arrays as function arguments
%
%   See also MCAOPEN

if nargin>1 & ne(nargin,nargout)
    error('Number of outputs must match the number of inputs')
end
[varargout{1:nargin}] = mca(4,varargin{:});

