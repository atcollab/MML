function [tunex tunez] = getnu(ibpm1,ibpm2)

istart=27;
iend=istart+1*512+1;
val =getbpmrawdata( [1 2] ,'nodisplay','struct');

xt=val.Data.X(1,istart:iend);
zt=val.Data.Z(2,istart:iend) ;

nf=iend-istart+1;
fx=fft(xt); px=fx.*conj(fx)/nf; xf=(1:nf)/nf;
fz=fft(zt); pz=fz.*conj(fz)/nf; zf=(1:nf)/nf;
tunex=find(px==max(px))/nf
tunez=find(pz==max(pz))/nf

figure(110)
subplot(1,2,1)
plot(xf(2:nf/2),px(2:nf/2)); 
%ylim([0 1]);
grid on
subplot(1,2,2)
plot(zf(2:nf/2),pz(2:nf/2))
suptitle(['TuneX= ' num2str(tunex) '            TuneZ= ' num2str(tunez)]);
grid on

