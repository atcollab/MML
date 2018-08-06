function [BPM, Error] = getzsoleil(Family, DeviceList)
%GETZSOLEIL - Get vertical position tinto BPMs 
% [BPM, Error] = getzsoleil(Family, DeviceList)
%  
% EXAMPLE
%  getzsoleil('BPMz', [1 2])
%
% See also getbpmsoleil, getzsoleil

%
% Written by Laurent S. Nadolski

[BPM, Error] = getbpmsoleil('Vertical', DeviceList);