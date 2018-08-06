% read current from alim

% D1=current1(:,1);
% D2=current1(:,2);
% QF=current1(:,3);
% QD=current1(:,4);
% time=0:0.000016666:0.333316;
% plot(time,current1(:,1))
% save 'current' time D1 D2 QF QD;

load 'current' time D1 D2 QF QD;

n0=1000;  % pour filtrage
n1=int16(0.0005/0.0000166666);
nl=12*4;
n2=length(time)/2-nl;

clear D1f D2f QFf QDf
for i=1:n2 
    D1f(i)=0.07;
    D2f(i)=0.07;
    QFf(i)=0.05868;
    QDf(i)=0.04315;
    for j=1:nl
       D1f(i) = D1f(i) - D1(i+j)/nl;
       D2f(i) = D2f(i) - D2(i+j)/nl;
       QFf(i) = QFf(i) - QF(i+j)/nl;
       QDf(i) = QDf(i) - QD(i+j)/nl;    
    end
end    
%plot(D1s(n1:(n1+100)))

% fx=fft(D1);fx(n0:n2)=0;
% Df1=real(ifft(fx));
% fx=fft(D2);fx(n0:n2)=0;
% Df2=real(ifft(fx));
% fx=fft(QF);fx(n0:n2)=0;
% QFf=real(ifft(fx));
% fx=fft(QD);fx(n0:n2)=0;
% QDf=real(ifft(fx));
 

Df=(D1f+D2f)/2;
length(Df)
length(QFf)
TF=QFf./Df;TF=(TF/TF(n2)-1)*100;
TD=QDf./Df;TD=(TD/TD(n2)-1)*100;
Ddot=diff(Df)/0.0000166666;Ddot(length(Ddot)+1) = 0;
S=Ddot./Df;

figure(1)
subplot(2,1,1)
plot(time(n1:n2),TF(n1:n2),time(n1:n2),TD(n1:n2))
subplot(2,1,2)
plot(  time(n1:n2),S(n1:n2) )
 
