function varargout = mcaopen(varargin);
%MCAOPEN      - open a Channel Access connection to an EPICS Process Variable
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
%       HANDLES is a numeric array of assigned handles
%       NAMES is a cell array of strings with PV names
%   
%   [HANDLES, NAMES] = MCAOPEN with no arguments returns a list of PV Names for all open connections. 
%       HANDLES is a numeric array of handles
%       NAMES is a cell array of strings with PV names
%
%   Note:
%   When done, one should probably use MCACLOSE on the handle.
%   When you use the same channel again "later", you might keep it open.
%   See MCACHECKOPEN for a lazy person's bookkeeping helper.
%
%   See also: MCACHECKOPEN, MCAISOPEN, MCACLOSE

if nargin>1  &&  nargin ~= nargout
    error('Number of outputs must match the number of inputs')
end

if nargin==0
    [varargout{1} varargout{2}] = mca(3); 
elseif iscellstr(varargin) 
    [varargout{1:nargin}] = mca(1,varargin{:}); 
elseif nargin==1 && iscell(varargin{1})
    varargout{1} = mca(2,varargin{1});
else
    error('All arguments must be strings')
end

    
