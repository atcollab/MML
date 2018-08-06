%  calcul chrom avec foucault



pi=3.14159;
mu0=4*pi*1e-07;
sig=1.3e+06;
h=0.011;
ep=0.001;
bro=9.175;
rho=12.377;
B0=0.740;
E0=2750;
Einj=110;
delta0=0.01;
mfouc0=(mu0*sig*ep)/(h*rho);

mx=7.72;
mz=-11.30;
m1=[3.39 0.38 ; -1.32 -3.5]; %chromp versus sextu (HL/BRHO)
m2=inv(m1);                  %sextu versus chrom

w=2*pi*50/17;
t=0.0219:0.0001:0.170;
B=B0/2*(1-cos(w*t));
Bdot=B0/2*(w*sin(w*t));
R=  (Bdot)./(B)  ;
R=R*25/R(1);
E=E0/2*(1-cos(w*t));
delta=(delta0*Einj)./E;
mfouc=mfouc0*R;
chix0=-1.23;
chiz0=-1.34;
md = -1.7/rho; 
mr = -2.1/rho*Einj./E;
chix=(chix0 + (md+mr+mfouc)*mx);
chiz=(chiz0 + (md+mr+mfouc)*mz);
sext=-m2*[chix ; chiz];
chic=m1*[sext(1,:) ; sext(2,:)];

I1=0.;
I2=0.;
chic1=m1*[I1*0.2/B(1)/rho ;-I2*0.2/B(1)/rho ];


chixr=chix + chic1(1)*Einj./E;
chizr=chiz + chic1(2)*Einj./E;


dnux=chixr.*delta*6.8;
dnuz=chizr.*delta*4.8;
sprintf('Brho = %g ', B(1)*rho)
sprintf('chix = %g  chiz = %g', chix(1), chiz(2))
sprintf('HF/Brho = %g  HD/Brho = %g', sext(1,1), sext(2,1))
Ihf=sext(1,:).*B*rho/0.2;
Ihd=-sext(2,:).*B*rho/0.2;
sprintf('I_HF = %g A   I_HD = %g  A', Ihf(1), Ihd(1))
plot(t, Ihf , t , Ihd)
figure(1)
subplot(3,1,1)
plot(t, R)
subplot(3,1,2)
plot(t, Ihf, t , Ihd)
subplot(3,1,3)
plot(t, dnux, t , dnuz)

%Ihf=sext(1)*B(1)*rho/0.2
%Ihf*0.2/rho/B(1)