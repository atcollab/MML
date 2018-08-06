function pd(i,ks)
global THERING
ati=atindex(THERING);
qsi=sort([ati.QS]);
ls=THERING{qsi(1)}.Length;
%for j=1:length(qsi),
%    THERING{qsi(j)}.PolynomA=[0 0 0 0]; 
%end
the_ks=ks/ls;
THERING{qsi(i)}.PolynomA=[0 the_ks 0 0]; 
THERING{qsi(i+8)}.PolynomA=[0 the_ks 0 0]; 
THERING{qsi(i+16)}.PolynomA=[0 the_ks 0 0]; 
THERING{qsi(i+24)}.PolynomA=[0 the_ks 0 0]; 

[TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
spos = findspos(THERING,1:length(THERING)+1);
mu=cat(1,TwissData.mu);
beta = cat(1,TwissData.beta);
eta = cat(2,TwissData.Dispersion);

%figure(74)
title('Dispersion')

%plot(spos, eta(1,:),'r')
plot(spos, eta(3,:))
hold on
drawlattice(0, 0.1*max(eta(3,:)))
xaxis([0 spos(end)/4])
ylabel('m')
xlabel('s [m]')
hold off
e=getemit; 
fprintf(1, '%f  %f  %f\n', 1e9*e(1), 1e9*e(2), 100*e(2)/e(1));