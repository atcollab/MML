%short routine to calculate amplification factors for quads/dipoles
clear all;
mag(1).name='QF ';
mag(1).l=0.34;
mag(1).k=1.815761626091;
mag(1).bx=10;
mag(1).by=5;

mag(2).name='QD ';
mag(2).l=0.15;
mag(2).k=-1.580407879319;
mag(2).bx=8;
mag(2).by=8;

mag(3).name='QFC';
mag(3).l=0.5;
mag(3).k=1.786614951331;
mag(3).bx=7;
mag(3).by=5;

mag(4).name='QDX';
mag(4).l=0.34;
mag(4).k=-1.437770016116;
mag(4).bx=9;
mag(4).by=11;

mag(5).name='QFX';
mag(5).l=0.6;
mag(5).k=1.588310523065;
mag(5).bx=16;
mag(5).by=6;

mag(6).name='QDY';
mag(6).l=0.34;
mag(6).k=-0.460196515928;
mag(6).bx=10;
mag(6).by=8;

mag(7).name='QFY';
mag(7).l=0.5;
mag(7).k=1.514741504629;
mag(7).bx=5;
mag(7).by=3;

mag(8).name='QDZ';
mag(8).l=0.34;
mag(8).k=-0.905396617422;
mag(8).bx=11;
mag(8).by=8;

mag(9).name='QFZ';
mag(9).l=0.34;
mag(9).k=1.479267960323;
mag(9).bx=11;
mag(9).by=6;

mag(10).name='BND';
mag(10).l=1.45;
mag(10).k=-0.33;
mag(10).bx=1;
mag(10).by=15;

mag(11).name='B34';
mag(11).l=1.09;
mag(11).k=-0.33;
mag(11).bx=2;
mag(11).by=14;

bpmx=10; nux=0.19;
bpmy=14;  nuy=0.23;  %larger beta at dipole bpms
dx=1.0;
dy=1.0;
disp(' ');
for ii=1:11
disp([mag(ii).name ' ampx ampy']);
ampx=sqrt(mag(ii).bx*bpmx)*mag(ii).l*mag(ii).k*dx/...
     (2.0*sin(3.1415*nux));
ampy=sqrt(mag(ii).by*bpmy)*mag(ii).l*mag(ii).k*dy/...
     (2.0*sin(3.1415*nuy));
disp([num2str(abs(ampx)) '   ' num2str(abs(ampy))]);
end
