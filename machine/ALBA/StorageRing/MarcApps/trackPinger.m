function [xout] = trackPinger(hkick, vkick)
%% Track a particle 
global THERING
atindx = atindex(THERING);
THERING{atindx.Pinger}.KickAngle = [hkick*1E-3 vkick*1E-3];
xoutP = [0 hkick 0 vkick 0 0]' ;
xout = [0 0 0 0 0 0]' ;
s(1)=0;
for i=1:length(THERING),
    if (i==atindx.Pinger) 
        xout=xoutP;
    end
    METHOD = THERING{i}.PassMethod;
    xout = feval(METHOD, THERING{i}, xout);
    s(i+1)=s(i)+THERING{i}.Length;
    x(i)=xout(1);    
    y(i)=xout(3);
end
plot(s(1:length(x)), 1e3*x, 'r');
hold on
plot(s(1:length(y)), 1e3*y, 'b');
max_val = 1e3*max (max(x), max(y));
ylabel ('Oscillation [mm]')
dl(-max_val*0.66666,max_val/10)
hold off