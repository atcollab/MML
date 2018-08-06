
figure(2);
clf reset
subplot(2,1,1);
plot(y(1,:)-yg(1,:), [TopInside; BottomInside; TopOutside; BottomOutside;],'.-');
ylabel('Blade Current [Volts]');
legend('Top Inside','Bottom Inside','Top Outside','Bottom Outside',0);
title(sprintf('Local Bump Scan (%.1f Bias Voltage,  %.1f \\muA Sensitivity Range,  %.1f mA Beam Current)', BiasVoltage, 1e6*SensitivityRange, DCCT));
grid on;
a = axis;
axis tight;
yaxis(a(3:4));


subplot(2,1,2);
%plot(y(1,:)-yg(1,:), [py1; py2],'.-');
[ax,h1,h2] = plotyy(y(1,:)-yg(1,:), [y1; y2], y(1,:)-yg(1,:), pBPM);
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

xlabel('Electron Beam Position from the Golden Orbit Around BEND 7.2 [mm]');
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
yaxesposition(1.15);
orient tall








% 
% % if abs(y(1,1)-y(1,end)) < .1
% %     % Change Physics units to mm
% %     y = y*1000;
% %     yg = yg * 1000;
% % end
% 
% 
% py1 = (pBPM(1,:) - pBPM(3,:)) ./ (pBPM(1,:) + pBPM(3,:));
% py2 = (pBPM(2,:) - pBPM(4,:)) ./ (pBPM(2,:) + pBPM(4,:));
% 
% 
% % y1-y2 should equal .978 mm (6/2006 distance between the blades)
% Gain = .978 ./ (py2 - py1);   
% py = Gain .* py1;
% 
% 
% figure(1);
% clf reset
% subplot(2,1,1);
% plot(y(1,:)-yg(1,:), pBPM(1:4,:),'.-');
% ylabel('Blade Current [Volts]');
% legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside',0);
% title(sprintf('Local Bump Scan (%.1f Bias Voltage,  %.1f \\muA Sensitivity Range,  %.1f mA Beam Current)', BiasVoltage, 1e6*SensitivityRange, DCCT));
% grid on;
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% 
% subplot(2,1,2);
% %plot(y(1,:)-yg(1,:), [py1; py2],'.-');
% [ax,h1,h2] = plotyy(y(1,:)-yg(1,:), [py1; py2], y(1,:)-yg(1,:), py);
% set(get(ax(1),'Ylabel'),'String','(Top-Bottom)/(Top+Bottom)')
% set(get(ax(2),'Ylabel'),'String','Calibrated Vertical Position [mm]')
% %set(h1,'LineStyle','-');
% %set(h2,'LineStyle','-');
% set(h1,'Marker','.');
% set(h2,'Marker','.');
% %set(ax(2), 'YColor', RightGraphColor);
% %set(h2, 'Color', RightGraphColor);
% % axes(ax(1));
% % aa = axis;
% % aa(1) = 0;
% % aa(2) = xmax;
% % axis(aa);
% % axes(ax(2));
% % aa = axis;
% % aa(1) = 0;
% % aa(2) = xmax;
% % axis(aa);
% 
% axes(ax(1));
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% xlabel('Electron Beam Position from the Golden Orbit Around BEND 7.2 [mm]');
% legend('Inside Blades', 'Outside Blades', 'Location','NorthWest');
% grid on;
% 
% 
% axes(ax(2));
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% %a = axis;
% %axis tight;
% %yaxis(a(3:4));
% 
% 
% addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));
% yaxesposition(1.15);
% orient tall
% 
% 
% if ~exist('ypBPMmodel','var')
% 
%     % Must have the split dipole lattice loaded
%     if ~strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, Model')
%         setoperationalmode(101);
%     end
%     switch2sim;
% 
%     setsp('HCM', 0, 'Physics');
%     setsp('VCM', 0, 'Physics');
% 
%     iAT = family2atindex('BEND',[7 2]);
% 
% 
%     % LOCO gains need to be added since setoperationalmode(101) has unity gains
%     % However, make sure the LOCO gains are correct
%     %Xgain = getgain('BPMx', [7 5; 7 6])
%     %Xgain = [
%     %    0.9809
%     %    0.9888];
%     %Ygain = getgain('BPMy', [7 5; 7 6])
%     %Ygain = [
%     %    0.8989
%     %    0.8696];
%     %Ygain = [
%     %    1
%     %    1];
% 
%     % 2006-08-27 LOCO gains
%     Ygain = [
%         0.9482;
%         0.9313];
% 
%     setfamilydata(Ygain, 'BPMy', 'Gain', [7 5; 7 6]);
% 
%     clear Orbit1 Orbit2 Orbit3 xm ym
% 
%     for i = 1:length(ybump)
%         % Add a local bump to the model (physics) which is the same as what was put on the machine (real units)
%         fprintf('  %2d. Local bump to %f \n', i, ybump(i));
%         OCSmodel = setorbitbump('BPMy', [7 5;7 6], [Ygain(1)*ybump(i); Ygain(2)*ybump(i)]/1000, 'VCM', [-3 -2 -1 1 2 3], 3, 'Physics', 'Abs');
%         OCSmodel = setorbitbump('BPMx', [7 5;7 6], [0 0],                                       'HCM', [-3 -2 -1 1 2 3], 2, 'Physics', 'Abs');
%         OCSmodel = setorbitbump('BPMy', [7 5;7 6], [Ygain(1)*ybump(i); Ygain(2)*ybump(i)]/1000, 'VCM', [-3 -2 -1 1 2 3], 3, 'Physics', 'Abs');
% 
%         xm(:,i) = getx([7 5; 7 6]);
%         ym(:,i) = gety([7 5; 7 6]);
% 
%         tmp = getpvmodel('All', 'ClosedOrbit');
% 
%         Orbit1(:,i) = tmp(iAT(1),:)';
%         Orbit2(:,i) = tmp(iAT(2),:)';
%         Orbit3(:,i) = tmp(iAT(3),:)';
%     end
%     clear tmp
% 
%     setsp('HCM', 0, 'Physics');
%     setsp('VCM', 0, 'Physics');
% 
% 
%     ypBPMmodel = 1000*Orbit2(3,:) + Orbit2(4,:) * 6000;  % mm
% 
% end
% 
% 
% figure(2);
% clf reset
% 
% subplot(2,1,1);
% plot(ypBPMmodel, pBPM(1:4,:),'.-');
% ylabel('Blade Current [Volts]');
% legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside',0);
% title(sprintf('Local Bump Scan (%.1f Bias Voltage,  %.1f \\muA Sensitivity Range,  %.1f mA Beam Current)', BiasVoltage, 1e6*SensitivityRange, DCCT));
% grid on;
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% 
% subplot(2,1,2);
% %plot(ypBPMmodel, [py1; py2],'.-');
% [ax,h1,h2] = plotyy(ypBPMmodel, [py1; py2], ypBPMmodel, py);
% set(get(ax(1),'Ylabel'),'String','(Top-Bottom)/(Top+Bottom)')
% set(get(ax(2),'Ylabel'),'String','Calibrated Vertical Position [mm]')
% %set(h1,'LineStyle','-');
% %set(h2,'LineStyle','-');
% set(h1,'Marker','.');
% set(h2,'Marker','.');
% %set(ax(2), 'YColor', RightGraphColor);
% %set(h2, 'Color', RightGraphColor);
% % axes(ax(1));
% % aa = axis;
% % aa(1) = 0;
% % aa(2) = xmax;
% % axis(aa);
% % axes(ax(2));
% % aa = axis;
% % aa(1) = 0;
% % aa(2) = xmax;
% % axis(aa);
% 
% axes(ax(1));
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% grid on;
% xlabel('Electron Beam Position Projected to the Photon BPM [mm]');
% legend('Inside Blades', 'Outside Blades', 'Location','NorthWest');
% 
% axes(ax(2));
% a = axis;
% axis tight;
% yaxis(a(3:4));
% 
% addlabel(1,0,sprintf('%s', datestr(TimeStamp,0)));
% yaxesposition(1.15);
% orient tall
% 
% 
% N1 = 1;
% N2 = 5;
% Slope1 = (py1(N2) - py1(N1)) / (ypBPMmodel(N2)-ypBPMmodel(N1));
% Slope2 = (py2(N2) - py2(N1)) / (ypBPMmodel(N2)-ypBPMmodel(N1));
% Slope  = (py(N2)  - py(N1))  / (ypBPMmodel(N2)-ypBPMmodel(N1));
% % text(a(1)+.1*(a(2)-a(1)), a(4)-.1*(a(4)-a(3)), sprintf('(%.2f - %.2f)/(%.2f - %.2f) = %.2f Inside  pBPM Slope (Point %d to Point %d)', py1(N2), py1(N1), ypBPMmodel(N2), ypBPMmodel(N1), Slope1, N1, N2));
% % text(a(1)+.1*(a(2)-a(1)), a(4)-.2*(a(4)-a(3)), sprintf('(%.2f - %.2f)/(%.2f - %.2f) = %.2f Outside pBPM Slope (Point %d to Point %d)', py2(N2), py2(N1), ypBPMmodel(N2), ypBPMmodel(N1), Slope2, N1, N2));
% % text(a(1)+.1*(a(2)-a(1)), a(4)-.3*(a(4)-a(3)), sprintf('(%.2f - %.2f)/(%.2f - %.2f) = %.2f pBPM Slope (Point %d to Point %d)', py2(N2), py2(N1), ypBPMmodel(N2), ypBPMmodel(N1), Slope2, N1, N2));
% 
% fprintf('Calibrated pBPM Slope: (%5.2f - %5.2f)/(%5.2f - %5.2f) = %5.3f  (Point %d to Point %d)\n', py(N2),  py(N1),  ypBPMmodel(N2), ypBPMmodel(N1), Slope, N1, N2);
% fprintf('Inside     pBPM Slope: (%5.2f - %5.2f)/(%5.2f - %5.2f) = %5.3f  (Point %d to Point %d)\n', py1(N2), py1(N1), ypBPMmodel(N2), ypBPMmodel(N1), Slope1, N1, N2);
% fprintf('Outside    pBPM Slope: (%5.2f - %5.2f)/(%5.2f - %5.2f) = %5.3f  (Point %d to Point %d)\n', py2(N2), py2(N1), ypBPMmodel(N2), ypBPMmodel(N1), Slope2, N1, N2);
% 
% 
% clear a ax h1 h2
