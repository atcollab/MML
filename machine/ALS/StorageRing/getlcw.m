function LCW = getlcw
%  LCW = getlcw
%
%     LCW = storage ring water temperature (degrees C)
%

LCW = scaget('SR03S___LCWTMP_AM00');
