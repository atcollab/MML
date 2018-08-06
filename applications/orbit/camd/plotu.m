global RSP


%horizontal
figure
for k=1:16
subplot(4,4,k)
plot(RSP(1).u(:,k))
hold on
plot(RSP(1).v(:,k),'r')
axis([0 16 -1 1])
title(num2str(k))
end

%vertical
figure
for k=1:12
subplot(4,4,k)
plot(RSP(2).u(:,k))
hold on
plot(RSP(2).v(:,k),'r')
axis([0 12 -1 1])
title(num2str(k))
end

