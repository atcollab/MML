% energie_perte

clear
%load('boo_2006-04-23_16-59-31.mat ', 'boo');
current=tango_read_attribute2('BOO-C01/DG/DCCT','iV');
cur=current.value;
time=1:340;

time400 =31 + [272 272];
time300 =31 + [278 278];
time200 =31 + [285 285];
time100 =31 + [293.5 293.5];


bar=[0 -5];

plot(time100,bar); hold on;
plot(time200,bar); hold on;
plot(time300,bar); hold on;
plot(time400,bar); hold on;
plot(time(300:340),cur(300:340));hold off;
text(time100(1),0,'100 MeV' );
text(time200(1),0,'200 MeV' );
text(time300(1),0,'300 MeV' );
text(time400(1),0,'400 MeV' );
xlabel('Temps (ms)');
ylabel('Courant (A)');
grid on;
