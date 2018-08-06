function [Amps, t, DataTime, ErrorFlag] = getsp_quadsum(Family, varargin)
% [Amps, tout, DataTime, ErrorFlag] = getsp_quadsum(Family, DeviceList)
% [Amps, tout, DataTime, ErrorFlag] = getsp_quadsum(Family, Field, DeviceList)
%
% Returns the sum of summing junctions for correctors.
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


[Amps , t, DataTime, ErrorFlag ] = getpv(Family, 'Setpoint', 'Hardware', varargin{:});
[Amps1, t, DataTime, ErrorFlag1] = getpv(Family, 'FF',       'Hardware', varargin{:});

FFMultiplier = getpv(Family, 'FFMultiplier', varargin{:});

Amps(isnan(Amps))   = 0;
Amps1(isnan(Amps1)) = 0;
FFMultiplier(isnan(FFMultiplier)) = 1;
Amps = Amps + FFMultiplier .* Amps1;

ErrorFlag = ErrorFlag | ErrorFlag1;