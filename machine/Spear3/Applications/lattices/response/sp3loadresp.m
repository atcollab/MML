load xmat;
%pick off horizontal correctors for spear 3
cors=[1 3 4];  indx=zeros(1,54);       %54 horizontal correctors in 1,3,4 slots
for kk=0:17 indx(3*kk+[1:3])=cors+kk*4; end
xmat=xmat(:,indx); 
%size(xmat);    

load ymat;  
%pick off vertical correctors for spear 3
cors=[1 2 4];  indx=zeros(1,54);       %54 horizontal correctors in 1,3,4 slots
for kk=0:17 indx(3*kk+[1:3])=cors+kk*4; end
ymat=ymat(:,indx);

clear ans comment kk ts ntcor ntbpm cors indx;
%size(ymat);    
