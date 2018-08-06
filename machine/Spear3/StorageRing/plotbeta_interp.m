%this routine computes interpolated ring betafunctions

sp3v81resp_interp;
%sp3v82_pinhole
%load optics
Optics=gettwiss(THERING,0.0);

s=Optics.s;
bx=Optics.betax;
by=Optics.betay;
ex=Optics.etax;
exp=Optics.etapx;

%eliminate adjacent points for interpolation
sok=[];   nok=0;
  for ii=1:size(s)-1
    if(s(ii+1)-s(ii)~=0)
     nok=nok+1;
     sok=[sok;ii];
    end
  end

nok=nok+1;
sok=[sok;ii+1];
sp=s(sok);        %make s column
si=0:0.05:s(nok);   %uniform s-grid

%interpolations
bxi=spline(sp,[0; bx(sok); 0],si);
byi=spline(sp,[0; by(sok); 0],si);
exi=spline(sp,[0; ex(sok); 0],si);
expi=spline(sp,[0; exp(sok); 0],si);

%interpolated plot for 1/4 of ring
pts=1:round(length(si)/4);
plot(si(pts),bxi(pts),'r');
hold on
plot(si(pts),byi(pts),'b');
plot(si(pts),10*exi(pts),'k');

%interpolated betafunction plot for standard cell
close all
pts=820:1060;
plot(si(pts),bxi(pts),'r');
hold on
plot(si(pts),byi(pts),'b');
plot(si(pts),10*exi(pts),'k');

title('SPEAR3 \beta-functions');
ylabel(['\beta [m]     10*eta [m]']);
xlabel('s - position [m]');

%interpolated beamsize plot for standard cell
%close all
figure
eps=15e-9;
dp=0.001;
chi=0.001;
pts=820:1060;
subplot(2,1,1)
plot(si(pts),1e6*sqrt(eps*bxi(pts)+(exi(pts)*dp).^2),'r');
hold on
plot(si(pts),1e6*sqrt(eps*bxi(pts)),'b--');
plot(si(pts),1e6*(exi(pts)*dp),'k--');


title('SPEAR3 beam size: epsx=15nm-rad, 0.1% coupling');
ylabel(['horizontal [micron]']);
xlabel('s - position [m]');

subplot(2,1,2)
plot(si(pts),1e6*sqrt(chi*eps*byi(pts)),'b');
%plot(si(pts),10*exi(pts),'k');

title('SPEAR3 beam size: epsx=15nm-rad, 0.1% coupling');
ylabel(['vertical [micron]']);
xlabel('s - position [m]');

%plot the vertical aperture for 4.5 mm-mrad
Ay=4.5e-6;
y=sqrt(Ay*byi);
figure
pts=1:round(length(si)/40);
plot(si(pts),1000*y(pts),'b');
title('vertical aperture through racetrack straight for 4.5 mm-mrad');
h=ylabel(['aperture [mm]']);
xlabel('s - position [m]');

close all
figure
len=round(length(si)/40); len=300;
half=round(length(si)/2);
pts=[(half-len):(half+len)];
plot(si(pts),1000*y(pts),'b');



