function varargout = mcaalarm(varargin)
%MCAGET read alarm status and severity for PVs previously read with MCAGET or MCAMON
%
% VALUE = MCAALARM(HANDLE) 
%    returns the status and severity of a PV specified by integer HANDLE.
%
% [VALUE1, ... VALUEN] = MCAALARM(HANDLE1, ... , HANDLEN)
%    returns status and severity of multiple PVs of any type and length
%    Number of outputs must match the number of inputs
%       
% Look in EPICS file "alarmString.h" for the definitions of the status and
% severity values returned by this function.
%
%   See also MCAGET, MCAMON.
%
if nargin<1
    error('No arguments were specified in mcaalarm')
elseif nargin==1
    result{1} = mca(61,varargin{1});
    varargout{1}.status = result{1}(1,1);
    varargout{1}.severity = result{1}(1,2);        
elseif nargin>1 
    if ne(nargin,nargout)
        error('Number of outputs must match the number of inputs')
    end
    [result{1:nargin}] = mca(61,varargin{:});
    for k = 1:nargin
        varargout{k}.status=result{k}(1,1);
        varargout{k}.severity=result{k}(1,2);
    end
end

