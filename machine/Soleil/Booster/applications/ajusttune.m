% ajusttune
% permet d'ajuster le tune du model au tune demand�

target=[6.75 ; 4.75];
[tune0]=gettune;
dt=target-tune0;

dI=0.01;
stepsp('QF','model',+dI);[tune1]=gettune;stepsp('QF','model',-dI);
stepsp('QD','model',+dI);[tune2]=gettune;stepsp('QD','model',-dI);
A=-[tune0(1)-tune1(1) tune0(1)-tune2(1) ; tune0(2)-tune1(2) tune0(2)-tune2(2)]/dI

stepI = linsolve(A,dt)
% stepsp('QF','model',stepI(1));
% stepsp('QD','model',stepI(2));
gettune