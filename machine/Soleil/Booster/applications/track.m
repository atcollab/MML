%  reglage tracking simulé

Gr = 0.0435 ;           % gradient remanent  T/m 
a  = 0.0517 ;           % G/I   T/m/A
Br = 0.0020 ;           % Champ remanent T
b  = 0.00135416 ;       % B/I  T/A
rho=12.3773 ;           % rayon dipole
Iqfc = -0.24 ;             % Offset QPF
Iqdc = -0.36 ;             % Offset QPD
Ibc = 0. ;              % Offset Dip
Iqf0 = 198.38 ;
Iqd0 = 157.28 ;
Id0  = 546.76 ;
phi =-0.0001 ;
rd0  = (Iqd0*a)/(Id0*b*rho) ;
rf0  = (Iqf0*a)/(Id0*b*rho) ;
sprintf('KF0= %g   KD0= %g', rf0, rd0)

m1   =[ 0.124  0.0176 ; 0.0285  0.1 ] ; % matrice dnu dK=m1*dnu

w=2*3.14159*(50./17.);
i=0;
clear fq fd r time 

i = 1 : 1 : 340;
t=i/1000;
time=t;
fq = 0.5*(1-cos(w*(t+phi)));
fd = 0.5*(1-cos(w*t));

pf=Gr + a*(Iqfc + Iqf0*fq);
pd=Gr + a*(Iqdc + Iqd0*fq);
p0=Br + b*(Ibc + Id0*fd);
rf=pf./(p0*rho);
rd=pd./(p0*rho);
dnux= 0.4 + 8.4045*(rf-rf0) - 01.4792*(rd-rd0);
dnuz= 0.4 - 2.3953*(rf-rf0) + 10.4216*(rd-rd0);


plot(time(20:170) , dnux(20:170) , time(20:170) , dnuz(20:170))
ylim([0 .5]);

%Calcul offset sur Qpole en A
testf =  (rf0*p0(20)*rho - (Gr + a*Iqf0*fq(20)))/a;
testd =  (rd0*p0(20)*rho - (Gr + a*Iqd0*fq(20)))/a;
sprintf('courant offset  : If= %g   Id= %g', testf, testd)

