function varargout = mcaopen(varargin);
%MCAOPEN open a Channel Acceess connection to an EPICS Process Variable
%
%   H = MCAOPEN(PVNAME);
%       If successful H is a unique nonzero integer handle associated with this PV.
%       Returned handle is 0 if a connection could not be established
%       
%   [H1, ... ,Hn] = MCAOPEN(PVNAME1, ... ,PVNAMEn);
%       Is equivalent to but more efficient than multiple single-argument calls
%           H1 = MCAOPEN(PVNAME1);
%           ...
%           Hn = MCAOPEN(PVNAMEn);
%        
%   HANDLES  = MCAOPEN(NAMES) is convenient when working with long lists of PV names
%       HADLES is a numeric array of assigned handles
%       NAMES is a cell array of strings with PV names
%
%   MCAOPEN with no arguments returns a cell array of PV names for
%       all open connections. 
%   
%   See also: MCACLOSE



if nargin>1 & ne(nargin,nargout)
    error('Number of outputs must match the number of inputs')
end

if nargin==0
    varargout{1} = mcamain(3); 
elseif  iscellstr(varargin) 
    [varargout{1:nargin}] = mcamain(1,varargin{:}); 
elseif nargin==1 & iscell(varargin{1})
    varargout{1} = mcamain(2,varargin{1});
else
    error('All arguments must be strings')
end

    
