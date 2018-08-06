

py1 = (pBPM(1,:) - pBPM(3,:)) ./ (pBPM(1,:) + pBPM(3,:));
py2 = (pBPM(2,:) - pBPM(4,:)) ./ (pBPM(2,:) + pBPM(4,:));


% y1-y2 should equal .978 mm (6/2006 distance between the blades)
Gain = .978 ./ (py2 - py1);
py = Gain .* py1;


figure(1);
clf reset
subplot(2,1,1);
plot(DCCT, pBPM(1:4,:),'.-');
ylabel('Blade Current [Volts]');
legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside',0); 
title(sprintf('pBPM Position vs. Beam Current (%.1f Bias Voltage,  %.1f \\muA Sensitivity Range)', BiasVoltage, 1e6*SensitivityRange));
grid on;
a = axis;
axis tight;
yaxis(a(3:4));


subplot(2,1,2);
%plot(y(1,:)-yg(1,:), [py1; py2],'.-');
[ax,h1,h2] = plotyy(DCCT, [py1; py2], DCCT, py);
set(get(ax(1),'Ylabel'),'String','(Top-Bottom)/(Top+Bottom)') 
set(get(ax(2),'Ylabel'),'String','Calibrated Vertical Position [mm]') 
%set(h1,'LineStyle','-');
%set(h2,'LineStyle','-');
set(h1,'Marker','.');
set(h2,'Marker','.');
%set(ax(2), 'YColor', RightGraphColor);
%set(h2, 'Color', RightGraphColor);
% axes(ax(1));
% aa = axis;
% aa(1) = 0;
% aa(2) = xmax;
% axis(aa);
% axes(ax(2));
% aa = axis;
% aa(1) = 0;
% aa(2) = xmax;
% axis(aa);

axes(ax(1));
a = axis;
axis tight;
yaxis(a(3:4));

xlabel('Electron Beam Current [mA]');
legend('Inside Blades', 'Outside Blades', 'Location','NorthWest');
grid on;


axes(ax(2));
a = axis;
axis tight;
yaxis(a(3:4));

%a = axis;
%axis tight;
%yaxis(a(3:4));


addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));
yaxesposition(1.2);
orient tall



i = findrowindex(getbpmlist('Bergoz'), family2dev('BPMx'));

for j = size(x,2):-1:1
    x(:,j) = x(:,j) - x(:,1);
    y(:,j) = y(:,j) - y(:,1);
end


figure(2);
clf reset
subplot(2,1,1);
plot(DCCT, x(i,:),'.-');
ylabel('Horizontal Bergoz BPMs [mm]');
title(sprintf('BPM Position vs. Beam Current', BiasVoltage, 1e6*SensitivityRange));
grid on;


subplot(2,1,2);
plot(DCCT, y(i,:),'.-');
ylabel('Vertical Bergoz BPMs [mm]');
grid on;


addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));
yaxesposition(1.2);
orient tall



