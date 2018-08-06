function injec
x0=[0.01 0 0 0 0 0]';
color='krbgcymkrbgcymkrbgcymkrbgcym';
global THERING;
n_elements= length(THERING) ;
xout=x0;
L=0;
Nturns=13;
for i=1:n_elements
    METHOD= THERING{i}.PassMethod;
    xout=feval(METHOD, THERING{i}, xout);
    xtracked(1,i)= xout(1);
    si=THERING{i}.Length;
    L=L+si;
    s(i)=L;
end
figure (1)
hold on
plot(s,xtracked(1,:),color(1))
xaxis([ 0 s(length(s))])
drawlattice(-0.02, 0.005)
for j=2:Nturns
    for i=1:n_elements
        METHOD= THERING{i}.PassMethod;
        xout=feval(METHOD, THERING{i}, xout);
        xtracked(j,i)= xout(1);
    end
    plot(s,xtracked(j,:), color(j))
end

