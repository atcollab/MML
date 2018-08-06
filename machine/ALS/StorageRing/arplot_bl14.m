function arplot_bl14(DateStr)
%ARPLOT_BL14 - Plots the orbit on BL 1.4
%  arplot_bl14(DateStr)
%
%  Written by Greg Portmann


DataStr = datestr(DateStr,30);
DataStr = DataStr(1:8);
arread(DataStr);

global ARt


xg = getgolden('BPMx',[1 5;1 6;1 10]);
yg = getgolden('BPMy',[1 5;1 6;1 10]);


[x, xivec] = arselect(family2channel('BPMx',[1 5;1 6;1 10]), 1);
[y, yivec] = arselect(family2channel('BPMy',[1 5;1 6;1 10]), 1);


clf reset

subplot(2,1,1);
plot(ARt/60/60, x(1,:)-xg(1), 'b')
hold on;
plot(ARt/60/60, x(2,:)-xg(2), 'r')
plot(ARt/60/60, x(3,:)-xg(3), 'g')
title(datestr(DateStr,1));
ylabel('Horzontal Orbit [mm]');
legend('BPM(1,5)','BPM(1,6)', 'BPM(1,10)', 0);
yaxis([-.05 .05]);
grid on;

subplot(2,1,2)
plot(ARt/60/60, y(1,:)-yg(1), 'b')
hold on;
plot(ARt/60/60, y(2,:)-yg(2), 'r')
plot(ARt/60/60, y(3,:)-yg(3), 'g')
xlabel('Time [Hours]');
ylabel('Vertical Orbit [mm]');
legend('BPM(1,5)','BPM(1,6)', 'BPM(1,10)', 0);
yaxis([-.015 .015]);
grid on;

orient tall
