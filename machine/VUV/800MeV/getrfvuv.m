function [RF, tout, DataTime, ErrorFlag] = getrfvuv(varargin)
%GETRFVUV - Returns the RF frequency in the VUV ring
%  [RF, tout, DataTime, ErrorFlag] = getrfvuv(Field) [MHz]
%


% [RF, tout, DataTime, ErrorFlag] = getrfvuv(Family, Field, DeviceList, t)

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


% For vuv ring: hi [MHz], lo [Hz]

if strcmp(Field, 'Monitor')
    [f, tout, DataTime, ErrorFlag] = getpv(['ufreqhi:am'; 'ufreqlo:am'], t);
else
    [f, tout, DataTime, ErrorFlag] = getpv(['ufreqhi:sp'; 'ufreqlo:sp'], t);
end
RF = f(1) + 0.000001 * f(2);
