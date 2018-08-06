function [y, t, DataTime, ErrorFlag] = getykickremoved(Family, varargin)
% [y, tout, DataTime, ErrorFlag] = getykickremoved(Family, DeviceList)
% [y, tout, DataTime, ErrorFlag] = getykickremoved(Family, Field, DeviceList)
%
% Returns the vertical orbit with the cam-kicker orbit removed.
% Note: the Field input is ignored but special functions must have Family, Field, DeviceList


if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

tout = [];
DataTime = [];
ErrorFlag = 0;


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
end

DeviceList = varargin{1};

[y , t, DataTime, ErrorFlag] = getpv('BPMy', 'Monitor', 'Hardware', DeviceList);
[xKick, yKick, PSBFlag, KickDevList] = getpseudosinglebunchkick;

[iFound, iNotFound, iFoundList1] = findrowindex(DeviceList, KickDevList);

y(iFoundList1) = y(iFoundList1) - yKick(iFound);


