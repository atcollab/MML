%script corr_indices.m
%vertical corrector sequence is 1,2,4  5,6,8 ... 69,70,72
tv=[1 2 4];           %row of numbers
v=tv;
%horizontal corrector sequence is 1,3,4  5,7,8 ... 69,71,72
th=[1 3 4];           %row of numbers
h=th;
for ii=1:17
v=[v 4*ii+tv];
h=[h 4*ii+th];
end

v1=sort([1:4:72 2:4:72 4:4:72]);
h1=sort([1:4:72 3:4:72 4:4:72]);
max(v-v1);
max(h-h1);
load ymat;
ymat=ymat(:,v);
%size(ymat)

load xmat;
xmat=xmat(:,h);
%size(xmat)

clear [tv,v,th,h];

