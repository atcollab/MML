%  calcul chrom avec foucault



pi=3.14159;
bro=9.175;
rho=12.377;
B0=0.740;
E0=2750;
Einj=110;


w=2*pi*50/17;
t=0.0219:0.0001:0.320;
B=B0/2*(1-cos(w*t));
Bdot=B0/2*(w*sin(w*t));
R=  (Bdot)./(B)  ;
E=E0/2*(1-cos(w*t));

dK=1.2e-04*R;
dnux=31*dK;
dnuz=-43*dK;

figure(1)
subplot(2,1,1)
plot(t,dnux,t,dnuz)
subplot(2,1,2)
plot(dnux,dnuz)