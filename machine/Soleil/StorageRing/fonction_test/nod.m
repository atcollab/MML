% test NOD

temp=tango_read_attribute2('ANS-C13/DG/BPM.NOD','XPosDD');
x=temp.value;
n=temp.n;  %14

%n=power(2,15);

% fft
X=fft(x,n); Pxx = X.* conj(X) / n;
f=(1:n)/n;
subplot(3,1,1)
plot(x)
subplot(3,1,2)
plot(f,log(Pxx),'-b');xlim([0.18 0.22]);hold off
subplot(3,1,3)
plot(f,Pxx,'-b');xlim([0.18 0.22])

