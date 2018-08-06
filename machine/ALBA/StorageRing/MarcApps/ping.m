kickx=0;
kicky=0.95E-3;
x0=[ 0 kickx 0 kicky 0 0]';
color='krbgcymkrbgcymkrbgcymkrbgcym';
global THERING;
n_elements= length(THERING) ;
xout=x0;
L=0;
Nturns=13;
the_sh=family2atindex('S_ID');
for i=1:the_sh(1)
    METHOD= THERING{i}.PassMethod;
   xtracked(1,i)= 0;
    ytracked(1,i)= 0;
    si=THERING{i}.Length;
    L=L+si;
    s(i)=L;
end
for i=the_sh(1):n_elements
    METHOD= THERING{i}.PassMethod;
    xout=feval(METHOD, THERING{i}, xout);
    xtracked(1,i)= xout(1);
    ytracked(1,i)= xout(3);
    si=THERING{i}.Length;
    L=L+si;
    s(i)=L;
end
figure (1)
hold on
plot(s,ytracked(1,:),color(1))
xaxis([ 0 s(length(s))])
drawlattice(-0.02, 0.005)
for j=2:Nturns
    for i=1:n_elements
        METHOD= THERING{i}.PassMethod;
        xout=feval(METHOD, THERING{i}, xout);
        xtracked(j,i)= xout(1);
        ytracked(j,i)= xout(3);
    end
    plot(s,ytracked(j,:), color(j))
end

