
DeviceList = [14 4];

a = getbpm4k(DeviceList);
BPM = squeeze(a(:,1,:));
BPM1 = BPM(1,:)/14.0;
BPM2 = BPM(2,:)/16.6;
BPM3 = BPM(3,:);
BPM4 = BPM(4,:);
v1 = ( BPM1(1,:).*BPM3(1,:) + BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) + BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
v2 = (-BPM1(1,:).*BPM3(1,:) + BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) - BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
v3 = (-BPM1(1,:).*BPM3(1,:) - BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) + BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;
v4 = ( BPM1(1,:).*BPM3(1,:) - BPM2(1,:).*BPM3(1,:)  +  BPM3(1,:) - BPM4(1,:).*BPM3(1,:) ) / 4 / 1000;


subplot(2,1,1)
plot((1:4000)/4000, BPM(1,:)-BPM(1,1),'b', (1:4000)/4000, BPM(2,:)-BPM(2,1),'r');
xlabel('Time [Seconds]');
ylabel('Position [mm]');
title(sprintf('BPM(%d,%d)', DeviceList));


subplot(2,1,2)
plot((1:4000)/4000,v1-v1(1),'b', (1:4000)/4000,v2-v2(1),'r',(1:4000)/4000,v3-v3(1),'g',(1:4000)/4000,v4-v4(1),'k');
xlabel('Time [Seconds]');
ylabel('Voltage [Seconds]');


