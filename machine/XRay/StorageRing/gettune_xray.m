function [Tune, ErrorFlag] = gettunes_xray(FamilyName, DeviceList, Freq0)
[AM, tout, DataTime, ErrorFlag] = gettunes_xray(Family, Field, DeviceList, varargin)
%  X-Ray Ring Tune Measurement
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune(FamilyName, DeviceList, Fundamental Frequency {1.53336 MHz});
% |  Lower Fractional Tune, usually Vertical   |
%
%  Since the 2nd sideband is used:
%
%   nu = (f - 2*f_RF)/f_0
%


[f_h, tout, DataTime, ErrorFlag1] = getpv('xfastfreqh:am'); 
f_h = 1e-2*f_h;

[f_v, tout, DataTime, ErrorFlag2] = getpv('xfastfreqv:am'); 
f_v = 1e-2*f_v;

[f_RF_h, tout, DataTime, ErrorFlag3] = getpv('xfreqhi:am');
[f_RF_l, tout, DataTime, ErrorFlag4] = getpv('xfreqlo:am');

f_RF = 1e-3*f_RF_h + 1e-7*f_RF_l;

[f0, tout, DataTime, ErrorFlag5] = getpv('xfreq0:am');

nu_x = (f_h-2*f_RF)/f0; 
nu_y = (f_v-2*f_RF)/f0;

Tune = [nu_x; nu_y];


ErrorFlag = ErrorFlag1 | ErrorFlag2 | ErrorFlag3 | ErrorFlag4 | ErrorFlag5;
