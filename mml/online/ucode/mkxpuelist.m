% Make xpue list
N = 48; 
clear A
[A{1:N}] = deal('xpue00');
A = char(A');

A(1:9,6) = str2mat(int2str((1:9)'));

A(10:N,[5 6]) = str2mat(int2str((10:N)'));
XPUEHam = cellstr(strcat(A,'h:am'));
XPUEHsp = cellstr(strcat(A,'h:sp'));


clear A
[A{1:N}] = deal('xpue00');
A = char(A');

A(1:9,6) = str2mat(int2str((1:9)'));

A(10:N,[5 6]) = str2mat(int2str((10:N)'));
XPUEVam = cellstr(strcat(A,'v:am'));
XPUEVsp = cellstr(strcat(A,'v:sp'));

subplot(2,1,1)

plot(ucodegetpv(XPUEHsp));
title('Horizontal');
hold on
plot(ucodegetpv(XPUEHam),'r');
legend({'Setpoint','Readback'});



subplot(2,1,2)
plot(ucodegetpv(XPUEVsp));
title('Vertical');
hold on
plot(ucodegetpv(XPUEVam),'r');
legend({'Setpoint','Readback'})