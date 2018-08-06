%vertical corrector sequence is 1,2,4  5,6,8 ... 69,70,72
tv=[1 2 4];           %row of numbers
v=tv;
for ii=1:17
v=[v 4*ii+tv];
end
load ymat;
ymat=ymat(:,v);
size(ymat)

%horizontal corrector sequence is 1,3,4  5,7,8 ... 69,71,72
tv=[1 3 4];           %row of numbers
v=tv;
for ii=1:17
v=[v 4*ii+tv];
end
load xmat;
xmat=xmat(:,v);
size(xmat)

