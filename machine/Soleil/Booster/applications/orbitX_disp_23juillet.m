% Correction orbite mesur�e 18 BPM 18 corr
% nux = 5.95

clear beta_bpmx  phi_bpmx s_bpmx
clear beta_corrx phi_corrx s_corrx
clear beta_defx  phi_defx
clear Cc K  X Xr
ncell=44;
betax=10.5;
b1   =10.5;
b2   =2.;
nux=5.95*2*pi;
dnux=nux/ncell;
ds=3.5595;
ncorrx=22;
nbpmx=22;
% table BPM
loc(1) =01;loc(2) =04;loc(3) =05;loc(4) =08;loc(5) =09;loc(6)=11;
loc(7) =13;loc(8) =14;loc(9) =17;loc(10)=18;loc(11)=21;
loc(12)=23;loc(13)=26;loc(14)=27;loc(15)=30;loc(16)=31;loc(17)=33;
loc(18)=35;loc(19)=36;loc(20)=39;loc(21)=40;loc(22)=43;

bet(1) =b1;bet(2) =b2;bet(3) =b1;bet(4) =b2;bet(5) =b1;bet(6)=b1;
bet(7) =b1;bet(8) =b2;bet(9) =b1;bet(10)=b2;bet(11)=b1;
bet(12)=b1;bet(13)=b2;bet(14)=b1;bet(15)=b2;bet(16)=b1;bet(17)=b1;
bet(18)=b1;bet(19)=b2;bet(20)=b1;bet(21)=b2;bet(22)=b1;

hs(1) =01;hs(2) =01;hs(3) =01;hs(4) =01;hs(5) =01;hs(6)=01;
hs(7) =01;hs(8) =01;hs(9) =01;hs(10)=01;hs(11)=00;
hs(12)=01;hs(13)=01;hs(14)=00;hs(15)=01;hs(16)=01;hs(17)=01;
hs(18)=00;hs(19)=01;hs(20)=00;hs(21)=01;hs(22)=01;

%table correcteurs
on(1) =01;on(2) =01;on(3) =01;on(4) =01;on(5) =01;on(6)=01;
on(7) =01;on(8) =01;on(9) =01;on(10)=01;on(11)=01;
on(12)=01;on(13)=01;on(14)=01;on(15)=01;on(16)=01;on(17)=01;
on(18)=01;on(19)=01;on(20)=01;on(21)=01;on(22)=01;


% on rempli la matrice C tel que X=C.K
% cot� bpm sur chaque qp foc, on commence sur un qd (inj booster)
i=0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmx(i)=bet(j);
       phi_bpmx(i)=dnux*loc(j);
       s_bpmx(i)=ds*loc(j);
    end    
end
nbpmxr=i;
% cot� correcteurs sur chaque qp foc, on commence sur un qd (inj booster)
i=0;
for j=1:ncorrx,
    if (on(j)==1)
       i=i+1; 
       beta_corrx(i)=betax;
       phi_corrx(i)=(2*dnux)*(j-0.5);
       s_corrx(i)=(2*ds)*(j-0.5);
    end   
end
ncorrxr=i;
% matrice Cc cas ferm� cyclique
c3=2*sin(nux/2);
for i = 1:nbpmxr,
   for j = 1:ncorrxr
      c1=sqrt(beta_bpmx(i)*beta_corrx(j));
      c2=cos(nux/2-abs(phi_bpmx(i)-phi_corrx(j)));
      Cc(i,j) = c1*c2/c3;
   end
end
sprintf(' Nombre de BPM : %g ', nbpmxr)
sprintf(' Nombre de COR : %g ', ncorrxr)

% % cot� vecteur X repesentant les defaut d'orbites mesur� en mm
% dispsersion donn� avec beta (def + corr inclus)

X(1)=1.2;       d(1)=1.8;
X(2)=-3.45;     d(2)=-0.1;
X(3)=-4.5 ;     d(3)=0.1;
X(4)=0.7;       d(4)=1.6;
X(5)=-7.2;      d(5)=2.1;
X(6)=1.8;       d(6)=-0.6;
X(7)=-0.3;     d(7)=1.2;
X(8)=-1.16;    d(8)=1.3;
X(9)=-6.8;    d(9)=1.3;
X(10)=-1.05;  d(10)=0.;
X(11)=0;      d(11)=1.;

X(12)=-4;     d(12)=1.8;
X(13)=-4.3;   d(13)=-.1;
X(14)=0;      d(14)=0.1;
X(15)= -0.25;  d(15)=1.6;
X(16)=-2.4;   d(16)=2.1;
X(17)=-8.8;   d(17)=0.6;
X(18)=0;      d(18)=1.2;
X(19)= 0.74;   d(19)=1.3;
X(20)=0;      d(20)=1.3;
X(21)=-4.8;   d(21)=0.;
X(22)=5.5;    d(22)=1.;

%cas avec delatE 
i=0;
for i=1:nbpmx,
    X(i)=X(i)+d(i)*(0.002)*1000;   
end

i=0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1; 
       Xr(i)=X(j);
    end    
end

% R�solution par SVD matrice Cc cyclique sur X
[U,S,V] = svds(Cc,ncorrxr);
diag(S)
minvp=10;
for i=1:min(nbpmxr,ncorrxr)
    if(S(i,i)<minvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end    
Cci=V*S*U';
K=Cci*transpose(Xr);
Xcorr= transpose(-Xr) + Cc*K;
figure(2);plot(s_bpmx,Xr,'-ok',s_bpmx,Xcorr,'--ok');
legend('X','X corrig�e',2);
title('Correction mode anneau');ylabel('Orbite');xlabel('Position S');

clear nb
j=0;
for i=1:ncorrx,
    nb(i)=i;
end
j=0;
sumcorr=0;
for i=1:ncorrx
    if(on(i)==0)
        K1(i)=0;
    else
        j=j+1;
        K1(i)=K(j)/1000;
        sumcorr =sumcorr + K1(i);
    end     
end
sprintf('Somme corrcteurs=%d',sumcorr);
sprintf('CH%d    HC  %d \n',[nb ; K1]);
    
    
%  correcteurs du 23 juillet
for i=1:ncorrx,
    K0(i)=0;
end 
K0(1)=0.073/1000;
K0(6)=0.65/1000;
K0(13)=-0.43/1000;
K0(22)=-0.13/1000;
sprintf('CH%d    HC  %d \n',[nb ; (K1-K0)]);

K2 = (K1-K0);
save 'corrx.mat' K2
figure(4);bar(K2 ,0.6);
title('Correcteurs');ylabel('Deviation');xlabel('Position S');