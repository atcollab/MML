%used to compare MAD produced orbit file with MATLAB orbit
%matlab orbits are produced with MADORBCOMP.M
%and saved in qf_x/ymat, b34_x/ymat
%To use this file
%(1) edit file name to pick up MAD file
%(2) edit MATLAB vector for comparison
%(3) note orbits have opposite sign for 1 mm offset of element
%(4) comparison exact for quad, gradient dipole 8/4/00 if sextupoles off both cases

filename='qfx.dat'
[fid,message]=fopen(filename,'r');
header=fgetl(fid);            %*** read comment line***
header=fgetl(fid);            %*** read comment line***
header=fgetl(fid);            %*** read comment line***
header=fgetl(fid);            %*** read comment line***
header=fgetl(fid);            %*** read comment line***
header=fgetl(fid);            %*** read comment line***
for ii=1:90
bpm=fscanf(fid,'%s',[1]);
x(ii)=fscanf(fid,'%f',[1]);
y(ii)=fscanf(fid,'%f',[1]);
null=fscanf(fid,'%d',[1]);
end
tplot=1000*[qf_xmat]+x;
plot(1000*qf_xmat);
hold on;
plot(-x,'r');