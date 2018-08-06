% Correction orbite horizontale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncell=44;
betax=11.5;
b2   =11.5;
b1   =1.7;
nux=6.8*2*pi;    % avance de phase
dnux=nux/ncell;  % avance de phase par maille
ds=3.5595;       % longueur maille
ncorrx=22;
nbpmx=22;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=0.5;         % correction progressive
maxvp=4;           % valeur propre
istart = 27;     % depart lecture BPM
iend = 200;      % fin lecture BPM

% table BPM
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
hs1= [   1         1   1         1   1      1      1   1         1   1         1];
%          12        13  14        15  16     17     18  19        20  21        22   
hs2= [   1         1   1         1   1      1      1   1         1   1         1];
hs=[hs1 hs2];

clear on1 on2 on
%     1      2      3      4      5      6      7      8      9      10     11       
on1= [1      1      1      1      1      1      1      1      1      1      1 ];
%     12     13     14     15     16     17     18     19     20     21     22     
on2= [1      1      1      1      1      1      1      1      1      1      1 ];
on=[on1 on2];

clear beta_corrx phi_corrx s_corrx
clear s_bx bx s_cx cx
for i=1:nbpmx,
    s_bx(i)=ds*loc(i)   ; bx(i)=0;
    s_cx(i)=(2*ds)*(i-1); cx(i)=0;
end



% on rempli la matrice C tel que X=C.K
% cot� bpm sur chaque qp foc, on commence sur un qd (inj booster)
i=0;
clear beta_bpmx  phi_bpmx s_bpmx
for j=1:nbpmx
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmx(i)=bet(j);
       phi_bpmx(i)=dnux*loc(j);
       s_bpmx(i)=ds*loc(j);
    end    
end
nbpmxr=i;
% cot� correcteurs sur chaque qp def% setsp('VCOR',0.4,[1 1])oc, on commence sur un qd (inj booster)
i=0;
clear beta_corrx phi_corrx s_corrx
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
clear Cc
c3=2*sin(nux/2);
for i = 1:nbpmxr,
   for j = 1:ncorrxr
      c1=sqrt(beta_bpmx(i)*beta_corrx(j));
      c2=cos(nux/2-abs(phi_bpmx(i)-phi_corrx(j)));
      Cc(i,j) = c1*c2/c3;
   end
end
sprintf(' Nombre de BPM : %g ', nbpmxr);
sprintf(' Nombre de COR : %g ', ncorrxr);


%  cot� vecteur X repesentant les defaut d'orbites mesur� en mm
%  bloc = offset a retrancher
clear Zm Xm
for i=1:22
    xm=0;
    zm=0;
    if     (hs(i)==0)       % cas de BPM HS
        Xm(i)=0;Zm(i)=0;
    else
%         a=getbpmrawdata(i,'nodisplay','struct');
%         for j=istart:iend,
%            xm=xm+a.Data.X(j); % en mm
%            zm=zm+a.Data.Z(j);
%         end
%         Xm(i)=xm/(iend-istart+1);
%         Zm(i)=zm/(iend-istart+1);
        Xm(i)=(1-2*rand(1))*3;
        Zm(i)=(1-2*rand(1))*3;
    end    
end
i=0;
clear Xr Xr2
Xr2=0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1;
       Xr(i)=Xm(j);
       Xr2 = Xr2 + Xr(i)*Xr(i);
    end    
end
Xr2=Xr2/i;   % ecart type orbite

% R�solution par SVD matrice Cc cyclique sur X
clear Xcorr Cci K
[U,S,V] = svds(Cc,ncorrxr);
diag(S)
for i=1:min(nbpmxr,ncorrxr)
    if(S(i,i)<maxvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end   
Cci=V*S*U';
K=-Cci*transpose(Xr);                % en mrad
Xcorr= transpose(Xr) + Cc*K*step;
sprintf(' Ecart type orbite : %g ', Xr2)

clear nb K0 K1 K2
j=0;
for i=1:ncorrx,
    nb(i)=i;
end
j=0;
sumcorr=0;
for i=1:ncorrx
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

K2=getam('HCOR');
for i=1:ncorrx,
    if (K1(i)<1.5)
       stepsp('HCOR',K1(i),[i 1]);
    end    
end 



% plot 
figure(1);
subplot(2,1,1);
plot(s_bx, bx, 'sr' , s_bpmx,Xr,'-ok',s_bpmx,Xcorr,'--ok');
grid on
title('Correction horizontale mode anneau');
suptitle(['BPM= ' num2str(nbpmxr) '    CORR= ' num2str(ncorrxr)])
%legend('BPM','X','X corrig�e',2); 
xlim([0 156]); ylim([-4 4]);
ylabel('Orbite');
subplot(2,1,2);
%bar(s_cx , K2 ,0.1);xlim([0 156]); ylim([-1. 1.]);
KB=[K2 K1'];
bar(s_cx ,KB , 0.8);xlim([0 156]); ylim([-1. 1.]);
ylabel('I (A)');xlabel('Position S');
grid on