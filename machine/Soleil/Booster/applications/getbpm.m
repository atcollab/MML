function [X,Z]=toto(num)
 
filename=['../bpm/bpmdata/bpm_' num2str(num)];
load(filename,'X', 'Z', 'Q', 'Sum', 'Va', 'Vb', 'Vc', 'Vd');
X;
end
% istart = 1;
% iend = 500;
% ifft=256;

% xm=0;
% zm=0;
% j=0;
% for i=istart:iend,
%     xm=xm+X(i);
%     zm=zm+Z(i);
%     j=j+1;
%     tx(j)=X(i);
%     tz(j)=Z(i);
% end
% xm=xm/(iend-istart);
% zm=zm/(iend-istart)
% fx=fft(tx,ifft);px=fx.*conj(fx)/ifft;
% fz=fft(tz,ifft);pz=fz.*conj(fz)/ifft;
% f = (0:ifft/2)/ifft;

% figure(1)
% subplot(3,2,1)
% plot(X(istart:iend))
% ylabel('X')
% grid on
% subplot(3,2,2)
% plot(Z(istart:iend))
% ylabel('Z')
% grid on
% 
% subplot(3,2,3)
% plot(f(2:ifft/2),px(2:ifft/2))
% xlim([0 0.15])
% ylabel('TX')
% grid on
% subplot(3,2,4)
% plot(f(2:ifft/2),pz(2:ifft/2))
% xlim([0 0.15])
% ylabel('TZ')
% grid on
% 
% subplot(3,2,5)
% plot(Sum(istart:iend))
% ylabel('SUM')
% grid on
% subplot(3,2,6)
% plot(Q(istart:iend))
% ylabel('TX')
% grid on
% suptitle(['BPM' num2str(num) '  Xmoy=' num2str(xm) '  Zmoy=' num2str(zm)]);
