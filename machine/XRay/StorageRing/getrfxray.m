function [RF, tout, DataTime, ErrorFlag] = getrfxray(varargin)
% [RF, tout, DataTime, ErrorFlag] = getrfxray(Field) [MHz]
%


% [RF, tout, DataTime, ErrorFlag] = getrfxray(Family, Field, DeviceList, t)

if nargin < 2
    Field = 'Monitor';
else
    Field = varargin{2};
end
if nargin < 4
    t = 0;
else
    t = varargin{4};
end


% For xray ring: hi [kHz], lo [Hz/10]

if strcmp(Field, 'Monitor')
    [f, tout, DataTime, ErrorFlag] = getpv(['xfreqhi:am'; 'xfreqlo:am'], t);
else
    [f, tout, DataTime, ErrorFlag] = getpv(['xfreqhi:sp'; 'xfreqlo:sp'], t);
end
RF = f(1,:)/1000 + f(2,:)/1e7;


