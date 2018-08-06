a25_work;
kickx=1E-10;
kicky=0;
nturns=1026;
global THERING;
x=trackPinger(kickx,kicky);

xt=ringpass(THERING, x, nturns);
q=calcnaff(xt(1,1:1026),xt(3,1:1026),1)/(2*pi);
fft_xt = fft(xt(1:1024));
y=fftshift(fft_xt);
P_xt =fft_xt.* conj(fft_xt)
plot((1:512)/1024, P_xt(1:512));
