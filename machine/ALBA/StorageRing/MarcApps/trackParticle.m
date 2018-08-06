function trackParticle(xin)
%% Track a particle 
global THERING
xout = xin ;
s(1)=0;
nTurns=26;
for j=1:nTurns,
x0(j)=xout(1);
px0(j)=xout(2);
y0(j)=xout(3);
py0(j)=xout(4);
    for i=1:length(THERING),
        METHOD = THERING{i}.PassMethod;
        xout = feval(METHOD, THERING{i}, xout);
        s(i+1)=s(i)+THERING{i}.Length;
        x(i)=xout(1);    
        y(i)=xout(3);
    end

subplot(2,2,1)
plot(s(1:length(THERING)), x, '.r');
hold on
subplot(2,2,3)
plot(s(1:length(THERING)), y, '.b');
hold on
end
subplot(2,2,1)
max_val = max (max(x), max(y));
dl(0.0,max_val/10)
subplot(2,2,3)
dl(0.0,max_val/10)
subplot(2,2,2)
plot(x0,px0,'r.')
subplot(2,2,4)
plot(y0,py0,'b.')