% profil de perte

clear
chambre=10;
sig=3;
zb=-2.;
step=1;

z= -1.5*chambre:step:1.5*chambre;
ch=min(abs(chambre-z-zb),abs(-chambre-z-zb));
for i=1:length(z)
    x=z(i);
    if (x+zb)>chambre
        ch(i)=0;
    elseif (x+zb)<-chambre
        ch(i)=0;
    end
end
profil=erf(ch/sqrt(2)/sig);

profil=90*profil+ randn(size(z))*2;

[estimates, model] = fitprofil(z, profil);
estimates
[sse, FittedCurve] = model(estimates);
plot(z, profil, '*', z, FittedCurve, 'r'); 
ylim([0 100])
grid on

