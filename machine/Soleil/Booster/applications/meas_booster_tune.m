% Mesure nombte d'onde booster
% En mode SPM, le faisceau est exité le long du cycle = possible mesure du nombre d'onde

clear
istart=3000;
npoint=1024;

device   ='BOO-C01/DG/BPM.01';
attribute='ZPosDD';
temp=tango_read_attribute2(device,attribute);
X=temp.value;
plot(X)

n1=istart;
n2=n1+npoint;
m1 = int16(npoint/10);
m2 = int16(npoint-m1);
Xseg=X(n1:n2);
Xfft     = fft(Xseg,npoint);
PXfft    = Xfft.* conj(Xfft) / npoint;
f = (1:npoint)/npoint;
mx    = max(PXfft(m1:m2));
nux   = (find(PXfft==mx)-1)/ npoint;
nux=nux(2)

plot(f,PXfft)
ylim([0 1.5*mx])


