%  reglage tracking simulé injection 110 MeV et Br=0.00095 G



Grf = 0.0465 ;           % gradient remanent  T/m 
Grd = 0.0485 ;           % gradient remanent  T/m
a  = 0.0517 ;           % G/I   T/m/A
Br = 0.0020 ;           % Champ remanent T
b  = 0.0013051 ;       % B/I  T/A
rho=12.3773 ;           % rayon dipole
brhom = 8.86 ;          %  à 2.75 GeV

% % courant th�orique
% Iqfc = -0.327757 ;             % Offset QPF
% Iqdc = -0.488591 ;             % Offset QPD
% Ibc = 0. ;                     % Offset Dip
% Iqf0 =(kf0*brhom-Grf)/a - Iqfc;
% Iqd0=(kd0*brhom-Grd)/a -Iqdc ;
% Id0  = (brhom/rho-Br)/b - Ibc;

%courant en manipe 20-10-05
Iqf0 =201.65;  Iqfc = -0.617 ;          
Iqd0 =162.43  ;  Iqdc = -0.672  ;           
Id0  =545;  Ibc  = -0.1 ;                   
delf =-0.0001 ;          % délai retard si positif
deld =-0.000 ;          % délai retard si positif

%courant en manipe 19-10-05
Iqf0 =200.11;  Iqfc = -0.432 ;          
Iqd0 =160.35;  Iqdc = -0.454 ;           
Id0  =545;  Ibc  = -0.1 ;
delf =-0.0001 ;          % délai retard si positif
deld =-0.0001 ;          % délai retard si positif 
   
%courant en manipe 18-10-05
Iqf0 =201.33;  Iqfc = -0.236 ;          
Iqd0 =162.28;  Iqdc = -0.338 ;           
Id0  =545;  Ibc  = -0. ;    
delf =0.0001 ;          % délai retard si positif
deld =0.0001 ;          % délai retard si positif 

%courant en manipe 18-10-05 bis
% Iqf0 =201.474;  Iqfc = -0.324 ;          
% Iqd0 =162.851;  Iqdc = -0.55 ;           
% Id0  =545;  Ibc  = -0. ;    
% delf =0.000 ;          % délai retard si positif
% deld =0.000 ;          % délai retard si positif 

%sprintf('Id0= %g   Iqf0= %g  Iqd0= %g ' ,Iqf0, Iqd0 , Id0 )



w=2*3.14159*(50./17.);
i=0;
clear fq fd r time 

i = 1 : 1 : 340;
t=i/1000;
time=t;
% rampe
fqf = 0.5*(1-cos(w*(t-delf)));
fqd = 0.5*(1-cos(w*(t-deld)));
fd = 0.5*(1-cos(w*t));
fddot=0.5*w*sin(w*t);
% gradient et champ B
pf=Grf + a*(Iqfc + Iqf0*fqf);
pd=Grd + a*(Iqdc + Iqd0*fqd);
p0=Br + b*(Ibc + Id0*fd);
p0dot=b*Id0*fddot;
R=p0dot./p0;
% ratios G/B
rf=pf./(p0*rho);
rd=pd./(p0*rho);
% tune via model booster AT

global THERING
%switch2sim
QFI = findcells(THERING,'FamName','QPF');
QDI = findcells(THERING,'FamName','QPD');

for i=1:340
   KQF=rf(i);KQD=-rd(i);
   THERING = setcellstruct(THERING,'K',QFI,KQF);
   THERING = setcellstruct(THERING,'K',QDI,KQD);
   THERING = setcellstruct(THERING,'PolynomB',QFI, KQF,2);
   THERING = setcellstruct(THERING,'PolynomB',QDI, KQD,2);
   tune=modeltune;
   dnux(i)=tune(1);dnuz(i)=tune(2);
end   

% eddy QP in dipole
dK=+1.2e-04*R/3.6*0;
dnux=dnux+31*dK;
dnuz=dnuz-43*dK;

resx11=[6 7]; resy11=[4 5];
resx12=[6.5 6.5]; resy12=[4 5];
resx13=[6 7]; resy13=[4.5 4.5];
resx31=[6.667 6.667]; resy31=[4 5];
resx32=[6 7]; resy32=[4.667 4.667];
resx33=[6 8]; resy33=[5 4];
resx41=[6 7]; resy41=[4.5 5];
resx42=[6.5 7]; resy42=[4 5];

n1=21;
startx=dnux(n1);
startz=dnuz(n1);
n2=170;
emaxx=dnux(n2);
emaxz=dnuz(n2);

n1=21;
n2=340-21;
clear ylim xlim
figure(1)
subplot(2,1,1)
plot((dnux(n1:n2)) , (dnuz(n1:n2)) , '-k' , ...
    startx, startz, 'ok', ...
    emaxx, emaxz, 'ok', ...
    resx11 , resy11 , '-k' ,... 
    resx12 , resy12 , '-k' ,... 
    resx13 , resy13 , '-k' ,... 
    resx31 , resy31 , '-r' ,...
    resx32 , resy32 , '-r', ...
    resx33 , resy33 , '-r', ...
    resx41 , resy41 , '-b', ...
    resx42 , resy42 , '-b')

xlim([6.4 7]);ylim([4.4 5]);
subplot(2,1,2)
plot(time(n1:n2) , (dnux(n1:n2)-emaxx) , time(n1:n2) , (dnuz(n1:n2)-emaxz))
ylim([-0.1 0.1]);

% coutant à l'injection
 sprintf(' Courant injection rampe: dip= %g   Qf= %g   Qd= %g \n Courant injection reel : dip= %g   Qf= %g   Qd= %g \n Champ dipole injection : %g',...
         Id0*fd(21) , Iqf0*fqf(21) , Iqd0*fqd(21) , ...
         Id0*fd(21) +Ibc, Iqf0*fqf(21) +Iqfc, Iqd0*fqd(21)+Iqdc, p0(21) )
sprintf(' Injection  : nux =%g  nuz=%g \n Extraction : nux =%g  nuz=%g', ...
        startx, startz, emaxx, emaxz)
    
% %Calcul offset sur Qpole en A
% testf =  (rf0*p0(20)*rho - (Grf + a*Iqf0*fqf(20)))/a;
% testd =  (rd0*p0(20)*rho - (Grd + a*Iqd0*fqd(20)))/a;
% %sprintf('courant offset : If= %g  Id= %g')
