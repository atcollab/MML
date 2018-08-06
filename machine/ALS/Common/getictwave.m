function [BR, BTS] = getictwave
%GETICTWAVE - Beam current wavefor the ICT in the booster and BTS line
%  [BR, BTS] = getictwave
%
%  OUTPUTS
%  1. BR  waveform (500 points)
%  2. BTS waveform (500 points)


BR  = getpv('BR1_____ICT1___AT00');
BTS = getpv('BTS_____ICT2___AT00');


