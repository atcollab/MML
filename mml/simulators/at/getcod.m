function orbit = getcod(RING, DP)
% GETCOD Closed Orbit Distortion
% GETCOD(RING,DP) finds closed orbit for a given momentum 
% deviation DP. It calls FINDORBIT4 which assumes a lattice
% with NO accelerating cavities and NO radiation


if nargin < 1
	global THERING
else
    THERING = RING;
end
if nargin < 2
    DP = 0.0;
end

%localspos = findspos(THERING,1:length(RING)+1);
orbit = findorbit4(THERING,DP,1:length(RING)+1);
