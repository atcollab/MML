
switch2sim;

% Shift a quad
ati= family2atindex('QH1');
setshift(ati(10), 0, -1/1000);

x = getpvmodel('BPMx','TBT',[],30);

figure(1);
clf reset
subplot(2,1,1);
plot(x(:,1));
title('Turn One');

subplot(2,1,2);
plot(x(:,2))
title('Turn Two');

% Try plotfamily (BPMx->TBT) for different turns
% with different turns