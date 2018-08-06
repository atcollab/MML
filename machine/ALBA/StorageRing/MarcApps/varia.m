%%
rm=measbpmresp('Model');
figure(1)
surf(rm)
figure(2)
contour(rm)
%%
rmx=rm(1:88, 1:88);
rmy=rm(89:176, 89:176);
irmx=inv(rmx);
irmy=inv(rmy);
%%
figure(2)
subplot(2,2,1)
surfc(rmx)
xaxis([0 88])
yaxis([0 88])
subplot(2,2,2)
surfc(irmx)
xaxis([0 88])
yaxis([0 88])
subplot(2,2,3)
surfc(rmy)
xaxis([0 88])
yaxis([0 88])
subplot(2,2,4)
surfc(irmy)
xaxis([0 88])
yaxis([0 88])
zaxis([-2 2])
%%
[Ux,Sx,Vx]=svd(rmx);
Sx=diag(Sx);
[Uy,Sy,Vy]=svd(rmy);
Sy=diag(Sy);
for j=1:88
    tx=0;
    ty=0;
    for n=1:88
        tx=tx+Sx(n)*Vx(j,n)*Vx(j,n);
        ty=ty+Sy(n)*Vy(j,n)*Vy(j,n);
    end
    efx(j)=tx;
    efy(j)=ty;
end
%%
global refOptic
vcmlist= family2atindex('VCM');
svcm=refOptic.twiss.s(vcmlist(1:22));
%%
figure(4)
subplot(2,1,2)
stem(svcm , efy(1:22),'db')
hold on
xaxis([0 268.8/4])
drawlattice(0,3)
subplot(2,1,1)
stem(svcm , efx(1:22),'rs')
hold on
xaxis([0 268.8/4])
drawlattice(0,3)
%%
figure(3)
subplot(2,2,1)
semilogy(Sx,'r')
xaxis([0 88])
subplot(2,2,2)
stem(svcm , efx(1:22),'rs')
hold on
xaxis([0 268.8/4])
drawlattice(0,3)
subplot(2,2,3)
semilogy(Sy)
xaxis([0 88])
subplot(2,2,4)
stem(svcm , efy(1:22),'db')
hold on
xaxis([0 268.8/4])
drawlattice(0,3)
%%
kmax=1E-3;
nbits=18;
af=2.5;
ncm = length(family2atindex('HCM'));
kres = kmax/(2^(nbits+1));
bpm_nois=1e6*sqrt(ncm)*kres*af;
disp (bpm_nois)