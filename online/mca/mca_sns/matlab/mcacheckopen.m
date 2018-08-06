function varargout = mcacheckopen(varargin)
%MCACHECKOPEN - returns handle(s) to PV(s)
% Returns existing handles for PVs already connected,
% opens new connections otherwise.
% Returns 0 for PVs that failed to connect.
%
% HANDLE = MCACHECKOPEN('NAME')
%
% [HANDLE1, ... , HANDLEN] = MCACHECKOPEN('PVNAME1', ... , 'PVNAMEN')
%
% HANDLES = MCACHECKOPEN(NAMES)
%    When NAMES is a cell array of strings, HANDLES is a numeric array of
%    handles
%
% Note:
% In principle, one should open, use, close PVs.
% But in some cases the bookkeeping of PV handles might
% be a bit too much for quick script hacks,
% in which case mcacheckopen can help with re-use of
% existing handles for PVs that were opened earlier yet
% their handles are lost.
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
    