function varargout = mcacheck(varargin)
%MCACHECK     - Same as MCASTATE
%   See also MCAOPEN

if nargin > 0
    varargout{1} = mca(13,varargin{:});
else
    [varargout{1}, varargout{2}] = mca(12);
end