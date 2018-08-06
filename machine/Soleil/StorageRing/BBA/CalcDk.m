function [DK]=CalcDK(famQ,locQ,famB,locB,Plane)



%Dx(s)=(-Dk(sQp) x(sQp))*[1/{1-k(sQp)*l Bet(sQp)/(2 tan(Pi nux))}]*
%[rac(Bet(sBpm))*rac(Bet(sQp))]/(2 sin(pi nux))*
%cos(fix(sBpm)-fix(sQp)-pi nux)
% clear
 %famQ='Q1'
 %locQ=[4 1]
 %famB='BPMx'

%% position longitudinale du quadrupole considéré
% sQp=getspos(famQ,locQ);
% [famresB,locB,sBpm]=proche2(famB,famQ,locQ,0);
% 
%% extration du nombre d'onde

 %tune=gettune;
 nux=18+0.4;%tune(1)
 nuz=10+0.3;%tune(2)
% 
%% extraction des fonctions béta au Qp considéré:
 [bxQ,bzQ]=modelbeta(famQ,locQ);
%% extraction des fonctions b�ta au BPM considéré:
 [bxB,bzB]=modelbeta(famB,locB);
% 
%% extraction des phases au Qp considéré:
 [fixQ,fizQ]=modelphase(famQ,locQ);
%% extraction des phases au BPM considéré:
 [fixB,fizB]=modelphase(famB,locB);
%%

 
 if Plane==1 %plan horizontal
    BetQ=bxQ;
    BetB=bxB;
    fiQ=fixQ;
    fiB=fixB;
    nu=nux;
 elseif Plane==2 %plan vertical
    BetQ=bzQ;
    BetB=bzB;
    fiQ=fizQ;
    fiB=fizB;
    nu=nuz;
 end

keff=getkleff(famQ,locQ);
leff=getleff(famQ,locQ);

%DK=1e-3*(1-keff*leff*BetQ/(2*tan(pi*nu)))*(2*sin(pi*nu))/((BetB)^(1/2)*(BetQ)^(1/2)*cos(fiB-fiQ-pi*nu)*keff)/Dx; % DI/I
Deltax=0.01e-3; %(déplacement)
Dx=0.1e-3;
%Dx défaut initial
getam(famQ,locQ);
kef=keff;
DK=Deltax*(1+keff*BetQ/(2*tan(pi*nu)))/(BetQ/(2*tan(pi*nu))*Dx); % DI/I
rel=DK/(50*keff);
DK=rel;

%Dx2=Deltax*(1+keff*BetQ/(2*tan(pi*nu)))/(BetQ/(2*tan(pi*nu))*0.10*keff);




