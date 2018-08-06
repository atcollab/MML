% A method to determine the delay required when using betameas.m, using
% the spectrum analyser to measure the tune.
%

h1 = mcaopen('SR01QPS01:CURRENT_SP');
qfa1 = mcaget(h1);
temp = qfa1;

for i = 1:20
    p = 1+(0.01*i);
    mcaput(h1,temp*p);
    pause(10);
    x = meastune;
    xx(i) = x(1);
end

E = 1.01:.01:1.2

figure(654);
plot(E,xx)

mcaput(h1,qfa1);    
mcaclose(h1);