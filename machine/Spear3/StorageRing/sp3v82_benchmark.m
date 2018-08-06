sp3v82;

global THERING

s=findspos(THERING,length(THERING)+1)

plotbeta

figure

Optics=GetTwiss(THERING,0);
plot(Optics.etax)