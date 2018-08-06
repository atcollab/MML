% ajuste disp sur 16 points



x_longue = ones(8,1)*1.;
x_moyenne = ones(8,1)*2.;
x1=[dx_longue ; dx_moyenne];

%x=getx;
x0=[];
for i=1:length(target)
   x0=[x0 ; x(target(i))];
end

dx=x1-x0;
Q = lscov(M,dx)