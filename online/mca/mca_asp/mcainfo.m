function varargout = mcainfo(varargin);
%MCAINFO get connection status and other information about a PV 
% INFO = MCAINFO(PV) returns information on a single PV
%   PV can be a string PV name or an integer handle
%   Returns a 1-by-1 structure with fields:
%
%       Handle
%       PVName
%       ElementCount:
%       NativeType { STRING | INT |  FLOAT | ENUM | CHAR | DOUBLE }
%       State { connected | disconnected }
%       MCAMessage
%       Host
%
% [HANDLES, INFO] = MCAINFO with no argument returns information on
%   all open channels in a structure array.
%       HANDLES is a numeric array of handles
%       INFO is a structure array of inoformation on the PV in the
%            same format as above
%
% Note: A channel may become disconnected for two reasons:
%   1. (Temporary) Due to a server or network problem. This will be reflected in 
%   MCAMessage field. Any attempts to read, write or monitor this channel
%   will return an error. CA library will periodically attempt to reestablish
%   connection without any action required from the user.
%   2. (Permanent) When the connection is closed by the user with MCACLOSE. 
%   
% Note: Some of these fields become unavailable when a channel 
%   becomes temporarily disconnected or cleared by the user.
%   In this case 0 or 'unknown' is returned
%
%   See also: MCAOPEN MCACLOSE

if nargin>0
    if ischar(varargin{1})
        [handles, names] = mca(3);
        matchfound = find(strcmp(varargin{1},names));
        if isempty(matchfound)
            error(['No open channels found for a PV: ',varargin{1}]);
        end
        
        h = handles(matchfound);
    elseif isnumeric(varargin{1})
        h=(varargin{1});
    else 
        error('Argument must be a string PV Name or an integer handle');
    end
    varargout{1} = mca(11,h);
else % Return info on all channels
    [varargout{1} varargout{2}] = mca(10);
end
