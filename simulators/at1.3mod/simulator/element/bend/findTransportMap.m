function [R,T] = findTransportMap(LINE,delta,orbit_in)
%find the transfer matrix R and the second order transport map (T tensor)
%for a LINE of elements through numerical differentiation
%[R,T] = findTransportMap(LINE,delta,orbit_in)
%Input:
%   LINE, element cells. 
%   delta, the change of variable for transfer matrix, =1e-8 by default,
%       the change for transport map calculation is sqrt(delta).
%   orbit_in, orbit around which the map is to be calculated
%Output:
%   R, the usual 6x6 matrix in AT coordinate convention (x, px,y,py,dp/p,z)
%   T, the 6x6x6 tensor in AT convention, $X_i = R_{ij} X_j+T_{ijk} X_j X_k$,
%       note that T(:,j,k) = T(:,k,j)
%usage:
%   [R,T] = findTransportMap(LINE), 
%   [R,T] = findTransportMap({BEND}), where BEND is a single element.
%Author:    Xiaobiao Huang, 
%Created on 2/12/2009
%

if nargin<2
    delta = 1e-8;
end
if nargin<3
    orbit_in = zeros(6,1);
end

R = findlinem66(LINE, delta,orbit_in);

X1=linepass(LINE,zeros(6,1)); %sometimes zeros(6,1) is passed to nonzero, such as BndMPoleSymplectic4PassEdgeX
Delta = sqrt(delta);
T = zeros(6,6,6);
for jj=1:6
    D6 = zeros(6,2);
    D6(jj,:) = [Delta,-Delta];
    RIN = orbit_in*ones(1,2) + D6;
    ROUT = linepass(LINE,RIN);
    T(:,jj,jj) = (ROUT(:,1)+ROUT(:,2)-2*X1)/2/Delta^2;
    
    for kk=1:jj-1
        D6 = zeros(6,4);
        D6(jj,:) = [Delta,Delta, -Delta,-Delta];
        D6(kk,:) = [Delta,-Delta,+Delta,-Delta];
        RIN = orbit_in*ones(1,4) + D6;
        ROUT = linepass(LINE,RIN);
        T(:,jj,kk) = (ROUT(:,1)+ROUT(:,4)-ROUT(:,2)-ROUT(:,3))/4/Delta^2/2;
        T(:,kk,jj) = T(:,jj,kk);
    end
end


function M66 = findlinem66(LINE, delta,orbit_in)
%
if nargin<2
    delta = 1e-8;
end
dt = delta;
dl = delta;

% Build a diagonal matrix of initial conditions
D6 = [dt*eye(4),zeros(4,2);zeros(2,4), dl*eye(2)];
% Add to the orbit_in
RIN = orbit_in*ones(1,12) + [D6, -D6];
% Propagate through the element
ROUT = linepass(LINE,RIN);
% Calculate numerical derivative
M66 = [(ROUT(:,1:4)-ROUT(:,7:10))./(2*dt), (ROUT(:,5:6)-ROUT(:,11:12))./(2*dl)];
