function [BPM, Error] = getxsoleil(Family, DeviceList)
%GETXSOLEIL - Gets horizontal position tinto BPMs 
% [BPM, Error] = getxsoleil(Family, DeviceList)
%  
% EXAMPLE
%  getxsoleil('BPMx', [1 2])
%
% See also getbpmsoleil, getzsoleil

%
% Written by Laurent S. Nadolski

[BPM, Error] = getbpmsoleil('Horizontal', DeviceList);