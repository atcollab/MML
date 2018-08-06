
%plan horizontal
load 'corrx.mat'
Kx=K2*1000/1.2       % corr en A
setsp('HCOR',Kx); 

%plan vertical
 load 'zcorr.mat'
 Kz=K2/1.2       % corr en A
 setsp('VCOR',Kz); 