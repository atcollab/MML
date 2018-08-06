%  calcul chrom avec foucault
clear

step =0.000080 ;   % 80 µs
rfouc=3.6    ;     % reduction des foucault issue des mesures de chrom
delai=0.010  ;     % délai déclenche en plus des alim dip et q
tinj=0.030 ;

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
t=0.001:step:3*0.340;
B=B0/2*(1-cos(w*t));
Bdot=B0/2*(w*sin(w*t));
R=Bdot./B;
E=E0/2*(1-cos(w*t));
delta=(delta0*Einj)./E;
mfouc=mfouc0*R/rfouc;
chix0=-1.23;
chiz0=-1.34;
md = -1.7/rho; 
mr = 0.*-2.1/rho*Einj./E;
chix=(chix0 + (md+mr+mfouc)*mx);
chiz=(chiz0 + (md+mr+mfouc)*mz);

% dS=100*((1-cos(w*t))-(1-cos(w*t-0.001)))./(1-cos(w*t));
% figure(1)
% plot(t, mfouc , t, dS)


sext=-m2*[chix ; chiz];
chic=m1*[sext(1,:) ; sext(2,:)];

Ihf= sext(1,:).*B*rho/0.2;
Ihd=-sext(2,:).*B*rho/0.2;

for i=1:length(Ihf);
   if (Ihf(i) > 15) 
      Ihf(i)=15;
   end    
end
chic=m1*[Ihf./B/rho*0.2 ; -Ihd./B/rho*0.2];

chixr=chix + chic(1,:);
chizr=chiz + chic(2,:);
dnux=chixr.*delta*6.8;
dnuz=chizr.*delta*4.8;
% décalge de 10 ms !!
ind1=int32(0.340/step)
ind2=int32(0.680/step)
ind3=int32(delai/step)
Ihf1=Ihf(ind1-ind3 : ind2-ind3);
Ihd1=Ihd(ind1-ind3 : ind2-ind3);

ind1=int32(19/0.08);
ind2=int32(tinj/step);

fprintf('***** \n')
fprintf('Brho = %g \n', B(1)*rho)
fprintf('chix = %g  chiz = %g\n', chix(ind1), chiz(ind1))
%sprintf('HF = %g  HD = %g', sext(1,1), sext(2,1))
%fprintf('IHF = %g A   IHD = %g  A\n', Ihf(ind1), Ihd(ind1))
fprintf('IHF = %g A   IHD = %g  A\n', Ihf1(ind2), Ihd1(ind2))



figure(2)
     plot(Ihf1/15,'-r');hold on;
     plot(Ihd1/10.45,'-b');hold off;
     ylim([-0.5  1.5]);
csvwrite('consigne_sextu.dat', [Ihf1'  Ihd1'])

% subplot(3,1,1)
%     plot(t, Ihf , t , Ihd); 
%     ylim([-5  25.]);
% subplot(3,1,2)
%     plot(t, chixr , t , chizr)
% subplot(3,1,3)
%     plot(t, dnux, t , dnuz)