function varargout = mcatime(varargin)
%MCAGET read timestamps for PVs previously read with MCAGET or MCAMON
%
% The timestamp is returned as a MATLAB serial date number suitable
% for use in the DATESTR function.
%
% VALUE = MCATIME(HANDLE) 
%    returns the timestamp of a PV specified by integer HANDLE.
%
% [VALUE1, ... VALUEN] = MCATIME(HANDLE1, ... , HANDLEN)
%    returns timestamps of multiple PVs of any type and length
%    Number of outputs must match the number of inputs
%       
%   See also MCAGET, MCAMON.
%
if nargin<1
    error('No arguments were specified in mcatime')
elseif nargin==1
        result{1} = mca(60,varargin{1});
        day = result{1}(1,1);
        secs = result{1}(1,2)/1000000000;
        % The EPICS epoch is 1-Jan-1990
        varargout{1} = ((24*3600*datenum('1-Jan-1990') + day)+secs)/(24*3600);
elseif nargin>1 
    if ne(nargin,nargout)
        error('Number of outputs must match the number of inputs')
    end
    [result{1:nargin}] = mca(60,varargin{:});
    for k = 1:nargin
        day=result{k}(1,1);
        secs=result{k}(1,2)/1000000000;
        % The EPICS epoch is 1-Jan-1990
        varargout{k} = ((24*3600*datenum('1-Jan-1990') + day)+secs)/(24*3600);
    end
end

