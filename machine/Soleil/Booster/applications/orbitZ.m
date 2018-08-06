% Correction orbite vertivale 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncell=44;
betaz=13.5;
b2   =13.5;
b1   =3.0;
nuz=4.67*2*pi;    % avance de phase
dnuz=nuz/ncell;  % avance de phase par maille 
ds=3.5595;       % longueur maille
ncorrz=22;
nbpmz=22;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=1.;         % correction progressive
maxvp=0;           % valeur propre
istart = 27;     % depart lecture BPM
iend = 1000;      % fin lecture BPM

% table BPMz
clear loc
loc(1) =01;loc(2) =04;loc(3) =05;loc(4) =08;loc(5) =09;loc(6)=11;
loc(7) =13;loc(8) =14;loc(9) =17;loc(10)=18;loc(11)=21;
loc(12)=23;loc(13)=26;loc(14)=27;loc(15)=30;loc(16)=31;loc(17)=33;
loc(18)=35;loc(19)=36;loc(20)=39;loc(21)=40;loc(22)=43;
clear bet
bet(1) =b1;bet(2) =b2;bet(3) =b1;bet(4) =b2;bet(5) =b1;bet(6)=b1;
bet(7) =b1;bet(8) =b2;bet(9) =b1;bet(10)=b2;bet(11)=b1;
bet(12)=b1;bet(13)=b2;bet(14)=b1;bet(15)=b2;bet(16)=b1;bet(17)=b1;
bet(18)=b1;bet(19)=b2;bet(20)=b1;bet(21)=b2;bet(22)=b1;

% table on BPM et correcteurs
clear hs1 hs2 hs
%        H         V   H         V   H      H      H   V         H   V         H
%           1         2   3         4   5      6      7   8         9   10        11
hs1= [   1         1   1         1   1      1      0   1         1   1         1];
%        12        13  14        15  16     17     18  19        20  21        22   
hs2= [   1         1   1         1   1      1      0   1         1   1         1];
hs=[hs1 hs2];

clear on1 on2 on
%     1      2      3      4      5      6      7      8      9      10     11       
on1= [1      1      1      1      1      1      1      1      1      1      1 ];
%     12     13     14     15     16     17     18     19     20     21     22     
on2= [1      1      1      1      1      1      1      1      1      1      1 ];
on=[on1 on2];

clear beta_corrz phi_corrz s_corrz
clear s_bz bz s_cz cz
for i=1:nbpmz,
    s_bz(i)=ds*loc(i)   ; bz(i)=0;
    s_cz(i)=(2*ds)*(i-1); cz(i)=0;
end



% on rempli la matrice C tel que X=C.K
% cot� bpm sur chaque qp foc, on commence sur un qd (inj booster)
i=0;
clear beta_bpmz  phi_bpmz s_bpmz
for j=1:nbpmz
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmz(i)=bet(j);
       phi_bpmz(i)=dnuz*loc(j);
       s_bpmz(i)=ds*loc(j);
    end    
end
nbpmzr=i;
% cot� correcteurs sur chaque qp def% setsp('VCOR',0.4,[1 1])oc, on commence sur un qd (inj booster)
i=0;
clear beta_corrz phi_corrz s_corrz
for j=1:ncorrz
    if (on(j)==1)
       i=i+1; 
       beta_corrz(i)=betaz;
       phi_corrz(i)=(2*dnuz)*(j-1);
       s_corrz(i)=(2*ds)*(j-1);
    end   
end
ncorrzr=i;
% matrice Cc cas ferm� cyclique
clear Cc
c3=2*sin(nuz/2);
for i = 1:nbpmzr,
   for j = 1:ncorrzr
      c1=sqrt(beta_bpmz(i)*beta_corrz(j));
      c2=cos(nuz/2-abs(phi_bpmz(i)-phi_corrz(j)));
      Cc(i,j) = c1*c2/c3;
   end
end
sprintf(' Nombre de BPM : %g ', nbpmzr);
sprintf(' Nombre de COR : %g ', ncorrzr);


%  cot� vecteur X repesentant les defaut d'orbites mesur� en mm
%  bloc = offset a retrancher
clear Zm Xm
for i=1:22
    xm=0;
    zm=0;
    if     (hs(i)==0)       % cas de BPM HS
        Xm(i)=0;Zm(i)=0;
    else
        a=getbpmrawdata(i,'nodisplay','struct');
        for j=istart:iend,
           xm=xm+a.Data.X(j); % en mm
           zm=zm+a.Data.Z(j);
        end
        Xm(i)=xm/(iend-istart+1);
        Zm(i)=zm/(iend-istart+1);
    end    
end
i=0;
clear Zr
Zr2=0;
for j=1:nbpmz,
    if (hs(j)==1) 
       i=i+1; 
       Zr(i)=Zm(j);
       Zr2 = Zr2 + Zr(i)*Zr(i);
    end    
end
Zr2=Zr2/i;

% offset = [0.44 2.82 4.28 3.57 2.45 1.63 1.85 3.10 1.74 2.42 2.93]
% figure(2)
% plot(Zr(1:11), offset(1:11))

% R�solution par SVD matrice Cc cyclique sur X
clear Zcorr Cci K
[U,S,V] = svds(Cc,ncorrzr);
diag(S)
for i=1:min(nbpmzr,ncorrzr)
    if(S(i,i)<maxvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end   
Cci=V*S*U';
K=-Cci*transpose(Zr);                % en mrad
Zcorr= transpose(Zr) + Cc*K*step;
sprintf(' Ecart type orbite : %g ', Zr2)

clear nb K0 K1 K2
j=0;
for i=1:ncorrz,
    nb(i)=i;
end
j=0;
sumcorr=0;
for i=1:ncorrz
    if(on(i)==0)
        K1(i)=0;
        K2(i)=0;
    else
        j=j+1;
        K1(i)=K(j)/1.2*step;           % en Ampere
        K2(i)=K(j)/1.2;
        sumcorr =sumcorr + K1(i);
    end    
end
K1

K2=getam('VCOR')
for i=1:ncorrz,
    if (K1(i)<1.5)
       stepsp('VCOR',K1(i),[i 1]);
    end    
end 



% plot 
figure(1);
subplot(2,1,1);
plot(s_bz, bz, 'sr' , s_bpmz,Zr,'-ok',s_bpmz,Zcorr,'--ok');
title('Correction verticale mode anneau');
suptitle(['BPM= ' num2str(nbpmzr) '    CORR= ' num2str(ncorrzr)])
%legend('BPM','Z','Z corrig�e',2); 
xlim([0 156]); ylim([-4 4]);
ylabel('Orbite');
grid on
subplot(2,1,2);
%bar(s_cz ,  K2 , 0.1);xlim([0 156]); ylim([-1. 1.]);
KB=[K2 K1'];
bar(s_cz ,KB , 0.8);xlim([0 156]); ylim([-1. 1.]);
ylabel('I (A)');xlabel('Position S');
grid on