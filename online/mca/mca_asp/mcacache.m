function varargout = mcacache(varargin)
%MCACACHE reads locally cached value of a PV. 
%   MCACACHE does NOT communicate with the server or use resources of CA library  
%   
%   VALUE = MCACACHE(HANDLE) returns a value of a PV by integer HANDLE
%       The type (EPICS strings are returned as MATLAB strings)
%       All numeric EPICS types returned are as MATLAB double
%       If a PV is is a waveform VALUE is a vector
%
%   [ VALUE1 , ... VALUEN ] = MCACACHE(HANDLE1, ... , HANDLEN)
%       returns values of multiple PV's.
%       Naumber of outputs must match the number of inputs
%       
%   Notes: The cache value for a PV does not exist until the first use of a
%   monitor on that PV
%   See also: MCAMON

if nargin>1 & ne(nargin,nargout)
    error('Number of outputs must match the number of inputs')
end
[varargout{1:nargin}] = mca(300,varargin{:});

