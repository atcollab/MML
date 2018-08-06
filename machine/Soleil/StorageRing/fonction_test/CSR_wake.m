% wake CSR

clear
a=0.5;
b=-2/3;
c=-1;

pas=0.01;
sig=1;
n=4;

a=0.5*sig;
b=b/sig;
c=c*power(sig,0.6666)

z=-n*sig:pas:n*sig;

%model
dens =exp(-z.*z/2/sig/sig)/sqrt(2*pi);
deriv=diff(dens)/pas;
deriv=[0 deriv];
wake1=c*(-deriv +  b*dens);


%reel
dens =exp(-z.*z/2/sig/sig)/sqrt(2*pi);
deriv=diff(dens)/pas;
j=0;
for x=-n*sig:pas:n*sig;
    i=0;
    intf=0;
    for s=-n*sig:pas:x-pas;
        i=i+1;
        f=1/power((x-s),1/3)*deriv(i);
        intf=intf+f*pas;
    end
    j=j+1;
    wake(j)=intf;
end
plot(z,dens,'--k',z,wake,'-k',(z+a),wake1,'-r')

