function [Amps, t, DataTime, ErrorFlag] = getsp_cmsum(Family, varargin)
% [Amps, tout, DataTime, ErrorFlag] = getsp_cmsum(Family, DeviceList)
% [Amps, tout, DataTime, ErrorFlag] = getsp_cmsum(Family, Field, DeviceList)
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



[SP,   t, DataTime, ErrorFlag1] = getpv(Family, 'Setpoint', 'Hardware', varargin{:});
[FF1,  t, DataTime, ErrorFlag2] = getpv(Family, 'FF1',      'Hardware', varargin{:});
[FF2,  t, DataTime, ErrorFlag3] = getpv(Family, 'FF2',      'Hardware', varargin{:});
[Trim, t, DataTime, ErrorFlag4] = getpv(Family, 'Trim',     'Hardware', varargin{:});
FFMultiplier = getpv(Family, 'FFMultiplier', varargin{:});

%[AM,   t, DataTime, ErrorFlag ] = getpv(Family, 'Monitor',  'Hardware', varargin{:});
%[DAC,  t, DataTime, ErrorFlag5] = getpv(Family, 'DAC',      'Hardware', varargin{:});
% DAC(isnan(DAC)) = 0;

SP(isnan(SP))   = 0;
FF1(isnan(FF1)) = 0;
FF2(isnan(FF2)) = 0;
Trim(isnan(Trim)) = 0;
FFMultiplier(isnan(FFMultiplier)) = 1;

Amps = SP + Trim + FFMultiplier.*(FF1 + FF2);

ErrorFlag = ErrorFlag1 | ErrorFlag2 | ErrorFlag3 | ErrorFlag4;

