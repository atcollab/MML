
clear


BiasVoltage = input('   Input the bias voltage = ');
SensitivityRange = input('   Input the sensitivity range = ');


% If in hardware units
switch2hw;
%ybump = -3:.2:3;
%ybump = (-1:.1:1)+.2;
%ybump = (-1:.1:1);
ybump = (-1.5:.1:1.5);

% If in physics units
%switch2physics;
%ybump = (-1.2:.1:-.2)/1000;


xg = getgolden('BPMx',[7 5;7 6]);
yg = getgolden('BPMy',[7 5;7 6]);


DCCT = getdcct;
TimeStamp = clock;

for i = 1:length(ybump)
    fprintf('  %2d. Local bump to %f \n',i,ybump(i));
    OCS = setorbitbump('BPMy',[7 5;7 6],[ybump(i); ybump(i)] + yg, 'VCM', [-3 -2 -1 1 2 3], 4, 'Abs');

    OCS = setorbitbump('BPMx',[7 5;7 6], xg, 'HCM', [-3 -2 -1 1 2 3], 2, 'Abs');
    OCS = setorbitbump('BPMy',[7 5;7 6],[ybump(i); ybump(i)] + yg, 'VCM', [-3 -2 -1 1 2 3], 2, 'Abs');
    

    pause(1);
    pBPM(:,i)          = getam('pBPM');
    y1(:,i)            = getpv('pBPM','Y1');
    y2(:,i)            = getpv('pBPM','Y2');
    TopInside(:,i)     = getpv('pBPM','TopInside');
    BottomInside(:,i)  = getpv('pBPM','BottomInside');
    TopOutside(:,i)    = getpv('pBPM','TopOutside');
    BottomOutside(:,i) = getpv('pBPM','BottomOutside');

    x(:,i) = getx([7 5; 7 6]);
    y(:,i) = gety([7 5; 7 6]);
end
    
OCS = setorbitbump('BPMy',[7 5;7 6],[0;0] + yg, 'VCM', [-3 -2 -1 1 2 3], 'Abs');


save scanbumpdata_2


%pbpm_plotscanbump;



% clf reset
% subplot(2,1,1);
% plot(y(1,:)-yg(1,:),pBPM(1:4,:),'.-');
% %hold on;
% %plot(y(2,:)-yg(2,:),pBPM(1:4,:),'.-');
% %hold off
% grid on;
% ylabel('Blade Current [Volts]');
% legend('Top Inside','Top Outside','Bottom Inside','Bottom Outside');
% title('Local Bump Scan (Bias Voltage -25)');
% 
% subplot(2,1,2);
% plot(y(1,:)-yg(1,:),pBPM([7],:),'.-');
% grid on;
% ylabel('pBPM Gain');
% xlabel('Electron Beam Position from the Golden Orbit [mm]');
% title('Local Bump Scan (Bias Voltage -25)')
% 
% addlabel(1,0,sprintf('%.1f mAmps  %s', DCCT, datestr(TimeStamp,0)));
% 
% orient tall
% 

