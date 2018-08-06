
%nux=0.41, nz=0.3, bump 14.5mm, cz=0 eff en mA
cx=[-2.16 -1.2 0 0.44 1.1 1.5 2.1 2.66 3.1 3.42 4]
effx=[0.2 1.2 1.2 1.2 1.1 0.6 0.7 0.8 0.8 0.4 0.1]
%nux=0.41, nz=0.3, bump 14.5mm, cx=0.5
cz=[0 0.5 0.9 1.6 2.16 3.3 4.3]
effz=[1.2 1.1 1 1.1 1.1 0.8 0.1]
figure(1)
subplot(1,2,1)
plot ( cx, effx)
subplot(1,2,2)
plot ( cz, effz)
%variation groupée des sextupoles, chz=0.4, Chx=0.6
cgx=[ 0.44 1.1 2 3 4 5 ]
effgx=[1.2 1 0.76 1.1 0.65 0.2]
cgz=[0.3 1.25 2.35 3.44 4.3 5.3 6.3]
effgz=[1.2 1.05 1.05 0.9 0.8 1.05 0.9]
figure(2)
subplot(2,2,1)
plot ( cgx, effgx)
subplot(2,2,2)
plot ( cgz, effgz)
