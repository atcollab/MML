function [T, T2] = getrfcavitytemperature
% T = getrfcavitytemperature
%           or
% [T1, T2] = getrfcavitytemperature
%
%   T1 or T(1,1) = storage ring RF water temperature for cavity #1 (degrees C)
%   T2 or T(2,1) = storage ring RF water temperature for cavity #2 (degrees C)
%

T(1,1) = getpv('SR03S___C1TEMP_AM00');

if nargout > 1
   T2(1) = getpv('SR03S___C2TEMP_AM00');
else
   T(2,1) = getpv('SR03S___C2TEMP_AM00');
end
