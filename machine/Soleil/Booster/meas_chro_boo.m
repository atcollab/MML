
%%
figure
ploteta
subplot(5,1,[1 2])
hold on
plot(getspos('BPMx'),-(X4-X5)/(352.220-352.180)*352.200/3e-2/1e6,'.r')
subplot(5,1,[4 5])
hold on
plot(getspos('BPMx'),-(Z4-Z5)/(352.220-352.180)*352.200/3e-2/1e6,'.-b')
ylim([-0.1 0.1])

%%
figure
hold
plot(Z5,'r')

