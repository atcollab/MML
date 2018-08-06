function varargout = mcaget(varargin)
%MCAGET read values from PV's
%
% VALUE = MCAGET(HANDLE) returns a value of a PV specified by integer HANDLE.
%    Type of return value depends on the native type and the number of elements
%    in the EPICS record:
%    
%    EPICS strings are returned as MATLAB strings
%    EPICS array of strings - MATLAB cell array of strings
%    All numeric EPICS types returned are as MATLAB double arrays
%
% VALUES = MCAGET(HANDLES) an easy get for a group of scalar numeric PV's
%    HANDLES - array of handles
%    VALUES  - numeric array of values. 
%              If any of the PV's is a waveform, 
%              only the first element is returned
%
% [VALUE1, ... VALUEN] = MCAGET(HANDLE1, ... , HANDLEN)
%    returns values of multiple PV's of any type and length
%    Number of outputs must match the number of inputs
%       
%   Notes:
%   1. Timeout
%
%   See also MCAPUT
if nargin<1
    error('No arguments were specified in mcaget')
elseif nargin==1
    if length(varargin{1})>1
        varargout{1} = mca(51,varargin{1});
    else
        varargout{1} = mca(50,varargin{1});
    end
elseif nargin>1 
    if ne(nargin,nargout)
        error('Number of outputs must match the number of inputs')
    end
    [varargout{1:nargin}] = mca(50,varargin{:});
end

