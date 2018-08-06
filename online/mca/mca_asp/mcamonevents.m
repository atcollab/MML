function varargout = mcamonevents(varargin)
%MCAMONEVENTS returns the number of monitor events which have
%             occurred for channels since the last call to MCACACHE.
%
% [HANDLES, EVENTCOUNT] = MCAMONEVENTS
%    Returns handles and event counts for all open channels
%
% EVENTCOUNT = MCAMONEVENTS(HANDLES)
%    Returns event counts for specified channel(s)
%
% See also MCAMON, MCACACHE, MCAGET, MCACLEARMON

[handles, count] = mca(510);
if nargin == 0
    varargout{1} = handles;
    varargout{2} = count;
elseif nargin > 0 & isnumeric(varargin{1})
    for i=1:length(varargin{1})
        ind(i)=find(handles==varargin{1}(i));
    end
    varargout{1} = count(ind);
end