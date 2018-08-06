function varargout = mcacheckopen(varargin)
%MCACHECKOPEN returns handle(s) to PV(s)
% Returns existong numeric handles for PVs already connected.
% Opens new connections otherwise.
% Returns 0 for PVs that failed to connect
%
% HANDLE = MCACHECKOPEN('NAME')
%
% [HANDLE1, ... , HANDLEN] = MCACHECKOPEN('PVNAME1', ... , 'PVNAMEN')
%
% HANDLES = MCACHECKOPEN(NAMES)
%    When NAMES is a cell array of strings, HANDLES is a numeric array of
%    handles
%
% See also MCAOPEN, MCAISOPEN

if iscellstr(varargin{1})
    varargout{1} = zeros(size(varargin{1}));
    for i=1:length(varargin{1})
        varargout{1}(i) = mcaisopen(varargin{1}{i});
        if ~varargout{1}(i)
            varargout{1}(i) = mcaopen(varargin{1}{i});
        end
    end
else
    for i=1:nargin
        varargout{i} = mcaisopen(varargin{i});
        if ~varargout{i}
            varargout{i} = mcaopen(varargin{i});
        end
    end
end
    