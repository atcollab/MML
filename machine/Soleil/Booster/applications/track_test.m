function track

%[D1 D2 QF QD time]=gettrackinghall('nodisplay');

QVG=10/0.2 ;    %  volt -> T/M
QVB=0.74/0.55 ; %  volt -> T
RHO=12.376;


QF_cur  =tango_read_attribute('BOO/AE/Tracking','channel2');
QF_field=tango_read_attribute('BOO/AE/TrackingHall','channel1');
QD_cur  =tango_read_attribute('BOO/AE/Tracking','channel3');
QD_field=tango_read_attribute('BOO/AE/TrackingHall','channel2');
DI_cur  =tango_read_attribute('BOO/AE/Tracking','channel1');
DI_field=tango_read_attribute('BOO/AE/TrackingHall','channel0');

ncur=length(QF_cur.value);
nfield=length(QF_field.value);

m=100;
%lissage field
fx=fft(QF_field.value);
fx(m:(nfield-m))=0; % suppression haute fr�quence
DQF_field=-real(ifft(fx));
fx=fft(QD_field.value);
fx(m:(nfield-m))=0; % suppression haute fr�quence
DQD_field=real(ifft(fx));
fx=fft(DI_field.value);
fx(m:(nfield-m))=0; % suppression haute fr�quence
DDI_field=real(ifft(fx));

%lissage cur
fx=fft(QF_cur.value);
fx(m:(ncur-m))=0; % suppression haute fr�quence
DQF_cur=real(ifft(fx));
fx=fft(QD_cur.value);
fx(m:(ncur-m))=0; % suppression haute fr�quence
DQD_cur=real(ifft(fx));
fx=fft(DI_cur.value);
fx(m:(ncur-m))=0; % suppression haute fr�quence
DDI_cur=real(ifft(fx));



qf_ratio=(DQF_field - 0.2/200)./DQF_cur;
millieu=qf_ratio(1750)
qf_ratio=qf_ratio-millieu;

di_ratio=(DDI_field - 0.0015)./DQF_cur;
millieu=di_ratio(1750)
di_ratio=di_ratio-millieu;

% plot(qf_ratio(300:3300),'-r'); hold on;
% plot(di_ratio(300:3300),'-k'); hold off;
% ylim([-0.01 0.01]);
 
 
 Kx=DQF_field./DDI_field*(QVG/QVB/RHO);
 Kz=DQD_field./DDI_field*(QVG/QVB/RHO);
 K0x=Kx(1750);
 K0z=Kz(1750);
 dnux=10*(Kx-K0x)./Kx;
 dnuz=10*(Kz-K0z)./Kz;
 
 [C,IQF]=max((DQF_field));
 [C,IQD]=max((DQD_field));
 [C,IDI]=max((DDI_field));
 sprintf('max = %d %d %d',IQF,IQD,IDI)
 
 plot(DQF_field/200,'-r'); hold on;
 plot(DQD_field/150,'-b'); hold on;
 plot(DDI_field/550,'-k'); hold off;
 
%  plot(dnux(300:3300),'-r'); hold on;
%  plot(dnuz(300:3300),'-b'); hold off;
%  ylim([-0.2 0.4]);ylabel('dnux');
%  xlim([0 3300]);
%  grid on;
 
 