%  plot energ

dt=0.0001;
tinj=0.0308;
[D1 D2 QF QD time]=gettrackingdata('nodisplay');
tf=QF./(D1+D2)*2;
td=QD./(D1+D2)*2;
n1=int16(tinj/dt)
n2=length(time);
Dm=mean(D1(n2-100: n2));
QFm=mean(QF(n2-100: n2));
QDm=mean(QD(n2-100: n2));
tfm=QFm./Dm;
tdm=QDm./Dm;
tf=1-tf/tfm;
td=1-td/tdm;
figure (20)
plot(time(n1:n2),tf(n1:n2),time(n1:n2),td(n1:n2))

sprintf('courant injection DI =%g  QF = %G  QD = %g  ' ,D1(n1) , QF(n1) , QD(n1) )
