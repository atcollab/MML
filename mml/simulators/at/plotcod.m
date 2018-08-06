function varargout = plotcod(RING,DP)
%PLOTCOD Closed Orbit Distortion
% PLOTCOD(RING,DP) finds and plots closed orbit for a given momentum 
%  deviation DP. It calls FINDORBIT4 which assumes a lattice
%  with NO accelerating cavities and NO radiation
%
%  INPUTS
%  1. RING - At structure
%  2. DP   - Energy offset
%
%  OUTPUTS (Optional)
%  1. orbit - (x,px,y,py) closed orbit along the ring 
%
%  See also plotbeta

%  Written by Andrei Terebilo
%  Modified by Laurent S. Nadolski
%  March 27, 2005 - Default input arguments added 

switch nargin
    case 0
        global THERING;
        RING = THERING;
        DP = 0.0; % on mometum closed orbit
    case 1
        DP = 0; % on momentum closed orbit
    otherwise
        %do nothing
end
    

localspos = findspos(RING,1:length(RING)+1);
%orbit = findorbit4(RING,DP,1:length(RING)+1);
orbit = findorbit6(RING,1:length(RING)+1);

plot(localspos,orbit(1,:)*1e3,'.-r');
title('Closed Orbit Distortion')
hold on
plot(localspos,orbit(3,:)*1e3,'.-b');
hold off

A = axis;
A(1:2) =  [0, localspos(end)];
axis(A);

legend('Horizontal','Vertical');
xlabel('s - position [m]');
ylabel('orbit [mm]');

grid on

if nargout > 0
	varargout{1} = orbit;
end