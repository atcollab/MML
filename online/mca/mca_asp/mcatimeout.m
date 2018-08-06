function varargout = mcatimeout(varargin)
%MCATIMEOUT set or display MCA timeout setings
%   
%   MCATIMEOUT('open', t1)  
%       'open' option sets the internal variable MCA_SEARCH_TIMEOUT to t1 (sec)
%
%   MCATIMEOUT('get', t1)  
%       'get' option sets the internal variable MCA_GET_TIMEOUT to t1 (sec)
%
%   MCATIMEOUT('put', t1)  
%       'put' option sets the internal variable MCA_PUT_TIMEOUT to t1 (sec)
%
%   MCATIMEOUT('default') sets the default values
%       MCA_SEARCH_TIMEOUT = 1.0 (sec)
%       MCA_GET_TIMEOUT = 5.0 (sec)
%       MCA_PUT_TIMEOUT = 0.01 (sec)
%   
%   TIMEOUTS = MCATIMEOUT with no arguments returns a vector of currently set timeouts
%       in the format [MCA_SEARCH_TIMEOUT MCA_GET_TIMEOUT  MCA_PUT_TIMEOUT]  
% 
%   Notes: 
%   See also: MCA.cpp
%
switch nargin
    case 0
        varargout{1} = mca(1000);
    case 1
        if strcmp(varargin{1}, 'default')
            varargout{1} = mca(1004);
        else
            error ('Invalid command option.')
        end
    case 2
        if strcmp(varargin{1}, 'open')
            mca(1001,varargin{2});
        elseif strcmp(varargin{1}, 'get')
            mca(1002,varargin{2});
        elseif strcmp(varargin{1}, 'put')
            mca(1003,varargin{2});
        else
            error('Invalid command option.')
        end       
    otherwise
        error ('Invalid number of arguments.')
end
