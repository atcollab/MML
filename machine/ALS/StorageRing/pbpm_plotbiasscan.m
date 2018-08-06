
h = clf; %figure;
subfig(1,2,1, h);
clf reset

subplot(2,1,1);
plot(BiasVoltage, pBPM(1:4,:),'.-');
grid on;

xlabel('Bias Voltage');
ylabel('Blade Voltage');
title('Bias Voltage Scan');
legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside',0);   % Normal


a = axis;
axis tight;
yaxis(a(3:4));
a = axis;


subplot(2,1,2);
Gain = 1; 
py1 = Gain * (pBPM(1,:) - pBPM(3,:)) ./ (pBPM(1,:) + pBPM(3,:));
py2 = Gain * (pBPM(2,:) - pBPM(4,:)) ./ (pBPM(2,:) + pBPM(4,:));

[ax, h1, h2] = plotyy(BiasVoltage, py1, BiasVoltage, py2);
grid on;
xlabel('Electron Beam Position from the Golden Orbit [mm]');
set(get(ax(1),'Ylabel'), 'String', 'Inside (Top-Bottom)/(Top+Bottom)');
set(get(ax(2),'Ylabel'), 'String', 'Outside (Top-Bottom)/(Top+Bottom)');
set(h1,'Marker','.');
set(h2,'Marker','.');
axes(ax(1));
aa = axis;
aa(1) = a(1);
aa(2) = a(2);
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = a(1);
aa(2) = a(2);
axis(aa);

if exist('DCCT','var') & exist('TimeStamp','var')
    addlabel(1,0,sprintf('%.1f mAmps  %s', DCCT, datestr(TimeStamp,0)));
end

yaxesposition(1.25);
orient tall

