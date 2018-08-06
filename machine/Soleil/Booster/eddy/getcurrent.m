% read current from alim


Grf = 0.0465 ;           % gradient remanent  T/m 
Grd = 0.0485 ;           % gradient remanent  T/m
a  = 0.0517 ;           % G/I   T/m/A
Br = 0.0020 ;           % Champ remanent T
b  = 0.0013051 ;       % B/I  T/A
rho=12.3759 ;           % rayon dipole
brhom = 8.86 ;  

clear time D1 D2 QF QD
load 'current' time D1 D2 QF QD;
n=length(D1);
dt=0.0001/6; %step temp 16 �s

clear DF Df1 Df2 Dqf Dqd 

fx=fft(D1);
fx(1000:19000)=0; % suppression haute fr�quence
Df1=real(ifft(fx));

fx=fft(D2);
fx(1000:19000)=0;
Df2=real(ifft(fx));
fx=fft(QF);
fx(1000:19000)=0; % suppression haute fr�quence
Dqf=real(ifft(fx));
fx=fft(QD);
fx(1000:19000)=0;
Dqd=real(ifft(fx));

Df=(Df1+Df2)*2;
tf=Dqf./(Df1+Df2)*2;
td=Dqd./(Df1+Df2)*2;
n=int16(0.180/dt);
tf0=tf(n);
td0=td(n);
tf=tf/tf0-1;
td=td/td0-1;
% tracking
n1=int16(0.030/dt);
n2=int16(0.300/dt);
 figure(1)
 plot(time(n1:n2)*1000,tf(n1:n2)*1000,time(n1:n2)*1000,td(n1:n2)*1000)


Iqf0 =201.65;    Iqfc = -0.617 ;          
Iqd0 =162.43  ;  Iqdc = -0.672  ;           
Id0  =545;       Ibc  = -0.0 ; 
delf=0.0001;              % avance si positif
deld=-0.010;

% Iqf0 =200.11;  Iqfc = -0.432 ;          
% Iqd0 =160.35;  Iqdc = -0.454 ;           
% Id0  =545;  Ibc  = -0.1 ;
% delf =0.00005 ;          % avance si positif
% deld =-.00025 ;          % avance si positif 

%courant en manipe 18-10-05
% Iqf0 =201.33;  Iqfc = -0.236 ;          
% Iqd0 =162.28;  Iqdc = -0.338 ;           
% Id0  =545;  Ibc  = -0. ;    
% delf =-0.0001 ;          % avance si positif
% deld =-0.0003 ;          

%courant en manipe 18-10-05 bis
% Iqf0 =201.474;  Iqfc = -0.324 ;          
% Iqd0 =162.851;  Iqdc = -0.55 ;           
% Id0  =545;  Ibc  = -0. ;    
% delf =0.000 ;          
% deld =0.000 ;          

% calcul d�calage table pour d�lai
clear qf qd
k1=int16(delf/dt);
if (k1>0)
   k2=length(Df1)-k1; 
   for i=(k1+1):length(Df1)
       qf(i-k1)=Dqf(i);
   end
   for i=1:k1
       qf(k2+i)=Dqf(i);       
   end
else
   k2=length(Df1)+k1; 
   for i=1:k2
       qf(i-k1)=Dqf(i);
   end
   for i=k2+1:length(Df1)
       qf(i-k2)=Dqf(i);       
   end   
end
k1=int16(deld/dt);
if (k1>0)
   k2=length(Df1)-k1; 
   for i=(k1+1):length(Df1)
       qd(i-k1)=Dqd(i);
   end
   for i=1:k1
       qd(k2+i)=Dqd(i);       
   end
else
   k2=length(Df1)+k1; 
   for i=1:k2
       qd(i-k1)=Dqd(i);
   end
   for i=k2+1:length(Df1)
       qd(i-k2)=Dqd(i);       
   end   
end
Dqf1=qf';
Dqd1=qd';



clear Id Iqf Iqd
Id =Id0*(Df1+Df2)*(-28)/553.6 +Ibc;
Iqf=Iqf0*Dqf1*(-25)/201.3 + Iqfc;
Iqd=Iqd0*Dqd1*(-25)/151.04 + Iqdc;

clear pf pd p0 rf rd
pf=Grf + a*(Iqf);
pd=Grd + a*(Iqd);
p0=Br +  b*(Id);
rf=pf./(p0*rho);
rd=pd./(p0*rho);

n=int16((0.03075+0.000000)/dt);

n1=int16(0.0001/dt);
n2=int16(0.050/dt);
Idt=Id0/2*(1-cos(18.48*time));
inj1=[0 0.050]; inj2=[20.85  20.85];zero=[0 0];
figure(2)
plot(time(n1:n2),qd(n1:n2),time(n1:n2),Dqd(n1:n2))
% plot(time(n1:n2),Id(n1:n2),time(n1:n2),Idt(n1:n2), inj1,inj2,'--k',inj1,zero, '-k')
% legend({'Measured dipole current','Pure biased sine wave'});
[Dqd(1) Dqd(20000)] 