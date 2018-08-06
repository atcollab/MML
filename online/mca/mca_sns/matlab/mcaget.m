function varargout = mcaget(varargin)
%MCAGET       - read values from PV's
%
% VALUE = MCAGET(HANDLE) returns a value of a PV specified by integer HANDLE.
%    Type of return value depends on the native type and the number of elements
%    in the EPICS record:
%    
%    EPICS strings are returned as MATLAB strings
%    EPICS array of strings - MATLAB cell array of strings
%    All numeric EPICS types are returned as MATLAB double arrays
%
% VALUES = MCAGET(HANDLES) an easy get for a group of scalar numeric PV's
%    HANDLES - array of handles
%    VALUES  - numeric array of values. 
%              If any of the PVs is a waveform, 
%              only the first element is returned
%
% [VALUE1, ... VALUEN] = MCAGET(HANDLE1, ... , HANDLEN)
%    returns values of multiple PV's of any type and length
%    Number of outputs must match the number of inputs
% 
% Error handling:
% A matlab exception will be thrown when any of the PVs are invalid,
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
        varargout{1} = mca(51,varargin{1});
    else
        varargout{1} = mca(50,varargin{1});
    end
elseif nargin>1 
    if nargin ~= nargout
        error('Number of outputs must match the number of inputs')
    end
    [varargout{1:nargin}] = mca(50,varargin{:});
end

