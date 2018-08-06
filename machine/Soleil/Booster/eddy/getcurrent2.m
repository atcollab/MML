% read current from alim and track

% D1=current1(:,1); 553.6 A max
% D2=current1(:,2); 553.6 A max
% QF=current1(:,3); 201.3 A max
% QD=current1(:,4); 151.04 A max
% 
% time=0:0.000016666:0.333316;
% plot(time,current1(:,1))
% save 'current' time D1 D2 QF QD;

Grf = 0.0465 +0.013 + 0.002;           % gradient remanent  T/m 
Grd = 0.0490 +0.0093+ 0.0015;           % gradient remanent  T/m
af  = 0.0520 ;          % G/I   T/m/A
ad  = 0.0517;
Br = 0.0020 ;           % Champ remanent T
b  = 0.0013516 ;       % B/I  T/A
rho=12.3759 ;           % rayon dipole
brhom = 9.17 ;  

clear time D1 D2 QF QD
load 'current' time D1 D2 QF QD;
clear time Df1 Df2 Dqf Dqd;
load 'current_ttf' time Df1 Df2 Dqf Dqd;

n=length(Df1);
dt=0.0001/6; %step temp 16 �s

% clear Df1 Df2 Dqf Dqd 
% fx=fft(D1);
% fx(1000:19000)=0; % suppression haute fr�quence
% Df1=real(ifft(fx));
% fx=fft(D2);
% fx(1000:19000)=0;
% Df2=real(ifft(fx));
% fx=fft(QF);
% fx(1000:19000)=0; % suppression haute fr�quence
% Dqf=real(ifft(fx));
% fx=fft(QD);
% fx(1000:19000)=0;
% Dqd=real(ifft(fx));
% save 'current_ttf' time Df1 Df2 Dqf Dqd;
% 
% tf=Dqf./(Df1+Df2)*2;
% td=Dqd./(Df1+Df2)*2;
% n=int16(0.180/dt);
% tf0=tf(n);
% td0=td(n);
% tf=tf/tf0-1;
% td=td/td0-1;
% n1=int16(0.030/dt);
% n2=19000;
% 
% figure(1)
% plot(time(n1:n2),tf(n1:n2),time(n1:n2),td(n1:n2))

%courant en manipe 09-04-06
dtf=-0.00025;
dtd=-0.00005;
nuxm=6.6 ; nuzm=4.6;
Iqf0 =201.65 ;    Iqfc = -0.617 -0.050;          
Iqd0 =162.43 ;  Iqdc = -0.700  -0.070 ;           
Id0  =545;       Ibc  = -0.01 ; 
delf=dtf+0.0002 + 0.00007;              % avance si positif
deld=dtd+0.0001 - 0.00002;

%courant en manipe 20-10-05
% nuxm=6.6 ; nuzm=4.6;
% Iqf0 =201.65 + 0  ;  Iqfc = -0.617 - 0/27.5 ;          
% Iqd0 =162.43 + 0  ;  Iqdc = -0.672 - 0/27.5 ;           
% Id0  =545;       Ibc  = -0.1 ; 
% delf=0.0001 + 0.00000;              % avance si positif
% deld=0.0000 + 0.00000;

% %courant en manipe 19-10-05
% nuxm=6.77 ; nuzm=4.85;
% Iqf0 =200.11;  Iqfc = -0.432 ;          
% Iqd0 =160.35;  Iqdc = -0.454 ;           
% Id0  =545;  Ibc  = -0.1 ;
% delf =0.0001 + 0.000000 ;          % avance si positif
% deld =0.0001 + 0.000000 ;          % avance si positif 
% 
% %courant en manipe 19-10-05 premiere
% nuxm=6.77 ; nuzm=4.85;% pas sur !
% Iqf0 =200.43;  Iqfc = -0.445 ;          
% Iqd0 =162.22;  Iqdc = -0.529 ;           
% Id0  =545;  Ibc  = -0.1 ;
% delf =0.0001 ;          % avance si positif
% deld =0.0001 ;          % avance si positif 
% 
% %courant en manipe 18-10-05
% nuxm=6.8 ; nuzm=4.7;
% Iqf0 =201.33;  Iqfc = -0.236 ;          
% Iqd0 =162.28;  Iqdc = -0.338 ;           
%  
% Id0  =545;  Ibc  = -0. ;    
% delf =-0.0001 ;          % avance si positif
% deld =-0.0001 ;          
% 
% %courant en manipe 18-10-05 bis
% % Iqf0 =201.474;  Iqfc = -0.324 ;          
% % Iqd0 =162.851;  Iqdc = -0.55 ;           
% % Id0  =545;  Ibc  = -0. ;    
% % delf =0.000 ;          
% % deld =0.000 ;          

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
pf=Grf + af*(Iqf);
pd=Grd + ad*(Iqd);
bb=b;   %+(0.00005*(Id-20)/540);
p0=Br +  bb.*(Id);
rf=pf./(p0*rho);
rd=pd./(p0*rho);

n=int16((0.031+0.00000)/dt);

global THERING
clear dnux dnuz tt
%switch2sim
QFI = findcells(THERING,'FamName','QPF');
QDI = findcells(THERING,'FamName','QPD');
i=0;
for n1=n:500:n+17500
   i=i+1;
   tt(i)=single(n1)*dt ;
   KQF=rf(n1);
   KQD=-rd(n1);
   THERING = setcellstruct(THERING,'K',QFI,KQF);
   THERING = setcellstruct(THERING,'K',QDI,KQD);
   THERING = setcellstruct(THERING,'PolynomB',QFI, KQF,2);
   THERING = setcellstruct(THERING,'PolynomB',QDI, KQD,2);
   [TD, tune] = twissring(THERING,0,1:(length(THERING)+1));
   dnux(i)=tune(1);dnuz(i)=tune(2);
end
fprintf('\n');
fprintf(' ******** Summary for getcurrent1 ********\n');
fprintf(' Tune � l injection        %g   %g: \n', dnux(1), dnuz(1))
fprintf(' Courant � l injection     %g   %g  %g: \n', (Id(n)),(Iqf(n)),(Iqd(n)))
fprintf(' Courant � la redescente   %g   %g  %g: \n', (Id(n1)),(Iqf(n1)),(Iqd(n1)))



resx11=[6 7]; resy11=[4 5];
resx12=[6.5 6.5]; resy12=[4 5];
resx13=[6 7]; resy13=[4.5 4.5];
resx31=[6.667 6.667]; resy31=[4 5];
resx32=[6 7]; resy32=[4.667 4.667];
resx33=[6 8]; resy33=[5 4];
resx41=[6 7]; resy41=[4.5 5];
resx42=[6.5 7]; resy42=[4 5];

figure(1)
% subplot(1 ,1, 1)
% plot(resx11 , resy11 , '-k' ,...
%      resx12 , resy12 , '-k' ,... 
%      resx13 , resy13 , '-k' ,... 
%      resx31 , resy31 , '-r' ,...
%      resx32 , resy32 , '-r', ...
%      resx33 , resy33 , '-r', ...
%      resx41 , resy41 , '-b', ...
%      resx42 , resy42 , '-b'); hold on
% plot(dnux ,dnuz  , '-ok'); hold on
% plot(dnux(1) ,dnuz(1)  , '-ok','MarkerFaceColor','r'); hold on
% plot(dnux(11) ,dnuz(11)  , '-ok','MarkerFaceColor','b'); hold on
% plot(nuxm ,nuzm  , 'ok','MarkerFaceColor','r','MarkerSize',20); hold off
% text((nuxm+0.01) ,nuzm ,'\leftarrow Mesure 100 MeV','HorizontalAlignment','left')
% text( dnux(1) ,dnuz(1),'\leftarrow Model 100 MeV','HorizontalAlignment','left')
% %text( dnux(11) ,dnuz(11),'\leftarrow Model 2.75 GeV','HorizontalAlignment','left')
% 
% % text( dnux(11) ,dnuz(11),'Model 2.75 GeV \rightarrow','HorizontalAlignment','right')
% % xlim([6.4 7]);ylim([4.4 5]);
% % subplot(2 ,1, 2)
% % plot(tt,(dnux-dnux(11)) ,'-or', tt,(dnuz-dnuz(11)) , '-ob')


time1 = [0     20   40   60   80   100   150   200   220   240   260    280  281];
nux  = [0.56  0.54 0.56 0.58 0.59 0.60  0.59  0.624 0.637 0.642 0.644 0.659 0.666];
nuz  = [0.69  0.60 0.59 0.60 0.61 0.62 0.61  0.625  0.636 0.639  0.638 0.640 0.639];

time1=(time1+30)/1000;
plot(time1,nux,'-or',time1,nuz,'-ob'); hold on;
plot(tt,dnux-6, '-r',tt , dnuz-4,'-b'); hold off;
