
%%
etax = modeldisp('BPMx');

%%
num = 10
deltaX = AM.Data.X(:,15+num)-AM.Data.X(:,15);

deltaE = deltaX*1e-3./etax/num;

hist(deltaE)
xlabel('DeltaE/E')
legend(sprintf('mean = %2.2e',mean(deltaE)));

%%
[AX,H1,H2]= plotyy((1:120),deltaE,(1:120),etax);
grid on
set(AX(1),'ylim',[-0.5 0.5]*1e-3)