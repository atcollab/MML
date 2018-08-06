function [BSCcoiltemps, BSCcoilnames] = getsuperbendtemperatures
%GETSUPERBENDTEMPERATURES - Returns the super bend coil temperatures
% [BSCcoiltemps, BSCcoilnames] = getsuperbendtemperatures

BSC4uppercoiltemp  = getpvonline('SR04C___BSC_T2_AM01');
BSC4lowercoiltemp  = getpvonline('SR04C___BSC_T6_AM05');
BSC8uppercoiltemp  = getpvonline('SR08C___BSC_T2_AM01');
BSC8lowercoiltemp  = getpvonline('SR08C___BSC_T6_AM05');
BSC12uppercoiltemp = getpvonline('SR12C___BSC_T2_AM01');
BSC12lowercoiltemp = getpvonline('SR12C___BSC_T6_AM05');

BSCcoiltemps = [BSC4uppercoiltemp BSC4lowercoiltemp BSC8uppercoiltemp BSC8lowercoiltemp BSC12uppercoiltemp BSC12lowercoiltemp];
BSCcoilnames = {'BSC4 Upper Coil','BSC4 Lower Coil','BSC8 Upper Coil','BSC8 Lower Coil','BSC12 Upper Coil','BSC12 Lower Coil'};

