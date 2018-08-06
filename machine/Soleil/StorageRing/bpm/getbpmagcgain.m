function gain = getbpmagcgain
% GETBPMGAIN - Get automatic Gain from BPM dedicated for tune measurement.
%
%  OUPUTS
%  1. gain : Gain in dBm

%
%% Written by Laurent S.Nadolski

gain = readattribute('ANS-C13/DG/BPM.NOD/Gain');
