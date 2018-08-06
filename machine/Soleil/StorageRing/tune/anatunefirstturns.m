function anatunefirstturns
%% Search for tunes using 4 turn by turn data

%
%  Laurent S. Nadolski, 22 mars 2005

% [closeOrb] = findorbit4initial(THERING,ampe,[ampe*0.06;0;0;0;ampe;0]);
% X0=X0+[closeOrb;0;0];

%Simulation
if isempty(whos('global','variable'))
    global THERING
end

% number of turns
nturn = 4;
% initial condition
x0 = [1e-3;0;0e-3;0;0;0];

% Orbit at ring entrance
BPMindex= buildatindex('BPMx','BPM');

orbit = ringpass(THERING,x0,nturn);

out = linepass(THERING,x0,BPMindex)

y=out(1,[1 31 61 91])
[nu ycod] = anaorbit(y)

y=[];

iobs = BPMindex(1); % location of observation

% tracking in TRANSPORT mode over nturn
for k = 1:nturn
    out = linepass(THERING,x0,[1 iobs length(THERING)]);
    x0 = out(:,end);
    y(k)= out(2,1);
end

%plot(orbit(1,:));
y = orbit(1,:);
[nu ycod] = anaorbit(y)

num=7
% on turn
x0=[1e-3;0;0;0;0;0]
out = linepass(THERING,x0,[1 BPMindex([num num+30 num+60 num+90])' length(THERING)]);
y = out(1,[2:end-1]);
[nu ycod] = anaorbit(y);
20-4*nu

function [nu ycod] = anaorbit(y)
%
%
%  Algorithm
%  based on orbit computed on 4 turns
%  Reference ...

cosphi = 0.5*(y(2) - y(1)+ y(4) - y(3))/(y(3)-y(2));
nu = 0.5/pi*acos(cosphi);
ycod2 = (y(3) + y(1) - 2*y(2)*cosphi)/2/(1-cosphi);
ycod = (y(3)*(y(1)+y(3))-y(2)*(y(2)+y(4)))/((y(1)-y(4))+3*(y(3)-y(2)));

