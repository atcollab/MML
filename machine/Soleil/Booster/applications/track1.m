%  reglage tracking simulé injection 113.4 MeV

kf0=1.178  ;              % gradient pour 6.78/4.72
kd0=0.938;

Grf = 0.0610 ;           % gradient remanent  T/m 
Grd = 0.0600 ;           % gradient remanent  T/m
a  = 0.0517 ;           % G/I   T/m/A
Br = 0.0020 ;           % Champ remanent T
b  = 0.00135416 ;       % B/I  T/A
rho=12.3773 ;           % rayon dipole
brhom = 9.175 ;      %  à 2.75 GeV
Iqfc = -0.62 ;             % Offset QPF
Iqdc = -0.71 ;             % Offset QPD
Ibc = 0. ;                 % Offset Dip

Iqf0 =(kf0*brhom-Grf)/a - Iqfc;
Iqd0=(kd0*brhom-Grd)/a -Iqdc ;
Id0  = (brhom/rho-Br)/b - Ibc;
sprintf('Id0= %g   Iqf0= %g  Iqd0= %g ' ,Iqf0, Iqd0 , Id0 )

del =0.000 ;          % délai retard si positif

rd0  = ((Iqd0+Iqfc)*a+Grf)/((Id0*b+Br)*rho) ;
rf0   = ((Iqf0+Iqdc)*a+Grd)/((Id0*b+Br)*rho) ;
sprintf('KF0= %g   KD0= %g', rf0, rd0)

m1   =[ 0.124  0.0176 ; 0.0285  0.1 ] ; % matrice dnu dK=m1*dnu

w=2*3.14159*(50./17.);
i=0;
clear fq fd r time 

i = 1 : 1 : 1700;
t=i/10000;
time=t;
fq = 0.5*(1-cos(w*(t-del)));
fd = 0.5*(1-cos(w*t));
pf=Grf + a*(Iqfc + Iqf0*fq);
pd=Grd + a*(Iqdc + Iqd0*fq);
p0=Br + b*(Ibc + Id0*fd);

%[D1 D2 QF QD time]=gettrackingdata('nodisplay')
%pf=Grf + a*(QF);
%pd=Grd + a*(QD);
%p0=Br + b*(D1+D2)/2;

rf=pf./(p0*rho);
rd=pd./(p0*rho);
dnux= 0. + 8.4045*(rf-rf0) - 01.4792*(rd-rd0);
dnuz= 0. - 2.3953*(rf-rf0) + 10.4216*(rd-rd0);


plot(time(200:1700) , dnux(200:1700) , time(200:1700) , dnuz(200:1700))
ylim([-.5 .5]);

% coutant à l'injection
tt=215;
sprintf('courant injection rampe  : dip= %g   Q= %g   Qd= %g' , Id0*fd(tt) , Iqf0*fq(tt) , Iqd0*fq(tt))
sprintf('courant injection réel      : dip= %g   Q= %g   Qd= %g' , Id0*fd(tt) +Ibc, Iqf0*fq(tt) +Iqfc, Iqd0*fq(tt)+Iqdc)
sprintf('courant injection  : dip= %g   T' , p0(tt))

%Calcul offset sur Qpole en A
testf =  (rf0*p0(20)*rho - (Grf + a*Iqf0*fq(20)))/a;
testd =  (rd0*p0(20)*rho - (Grd + a*Iqd0*fq(20)))/a;
sprintf('courant offset  : If= %g   Id= %g', testf, testd)

