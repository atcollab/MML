%
rf=getrf;
temp=tango_read_attribute2('ANS/DG/PUB-LifeTime','double_scalar');
life=temp.value(1);
tune=gettune;
tunex=tune(1);
tunez=tune(2);
cur=getdcct
x=getx;
xmean=mean(x);
xmax=max(x);
xmin=min(x);
x=getz;
zmean=mean(x);
zmax=max(x);
zmin=min(x);

fprintf('%f  %g  %g  %g  %g  %g  %g  %g  %g  %g  %g\n' ,...
        rf, tunex, tunez , cur, life, xmean, xmax, xmin,zmean, zmax, zmin)