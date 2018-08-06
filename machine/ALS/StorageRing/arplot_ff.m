function arplot_ff(Sector,t1,t2);
% function arplot_ff(Sector, StartTime [Hours], EndTime [Hours]);

arglobal


% Inputs
if (Sector < 10)
   HCM1str = ['SR0',num2str(Sector), 'C___HCM1___AC'];
   VCM1str = ['SR0',num2str(Sector), 'C___VCM1___AC'];
   GAPstr  = ['SR0',num2str(Sector), 'U___GDS1PS_AM'];
else
   HCM1str = ['SR',num2str(Sector), 'C___HCM1___AC'];
   VCM1str = ['SR',num2str(Sector), 'C___VCM1___AC'];
   GAPstr  = ['SR',num2str(Sector), 'U___GDS1PS_AM'];
end

if (Sector-1 < 10)
   HCM4str = ['SR0',num2str(Sector-1), 'C___HCM4___AC'];
   VCM4str = ['SR0',num2str(Sector-1), 'C___VCM4___AC']; 
else
   HCM4str = ['SR',num2str(Sector-1), 'C___HCM4___AC'];
   VCM4str = ['SR',num2str(Sector-1), 'C___VCM4___AC'];
end


% Time vector (find t1<t<t2)
if nargin == 1
   ivec  = 1:max(size(ARt));
elseif nargin == 2
  ivec = find(ARt>t1*60*60);
elseif nargin == 3
  ivec = find(ARt>t1*60*60 & ARt<t2*60*60);
else
  error('ARPLOTFF: input error.');
end


% Horizontal Plane
[HCM4, iHCM4] = arselect(HCM4str);
[HCM1, iHCM1] = arselect(HCM1str);
[GAP,  iGAP]  = arselect(GAPstr);

if Sector == 4
   [EPU,iEPU]=arselect('SR04U___ODS1PS_AM00');
else
   EPU = zeros(size(GAP));
end

[DelHCM, DelVCM, DelQF, DelQD, HCM, VCM, QF, QD] = ffdeltasp(Sector,GAP, EPU);   
   
      
figure
subplot(5,1,1);
if Sector == 4
   plot(ARt(ivec)/60/60, GAP(ivec), 'b', ARt(ivec)/60/60, EPU(ivec),'r');
else  
   plot(ARt(ivec)/60/60, GAP(ivec));
end
title(ARDate);
ylabel('Gap Position [mm]');
axis tight

subplot(5,1,2);
plot(ARt(ivec)/60/60, HCM4(ivec));
ylabel(sprintf('HCM(%d,4) [amps]', Sector-1));
axis tight

subplot(5,1,3);
plot(ARt(ivec)/60/60,HCM1(ivec));
ylabel(sprintf('HCM(%d,1) [amps]', Sector));
axis tight


% Vertical Plane
[VCM4, iVCM4] = arselect(VCM4str);
[VCM1, iVCM1] = arselect(VCM1str);

subplot(5,1,4);
plot(ARt(ivec)/60/60, VCM4(ivec));
ylabel(sprintf('VCM(%d,4) [amps]', Sector-1));
axis tight

subplot(5,1,5);
plot(ARt(ivec)/60/60,VCM1(ivec));
ylabel(sprintf('VCM(%d,1) [amps]', Sector));
xlabel(['Time since midnight [hours]']);
axis tight

orient tall


figure
subplot(5,1,1);
if Sector == 4
   plot(ARt(ivec)/60/60, GAP(ivec), 'b', ARt(ivec)/60/60, EPU(ivec),'r');
else  
   plot(ARt(ivec)/60/60, GAP(ivec));
end
title(ARDate);
ylabel(sprintf('Gap(%d) [mm]',Sector));
axis tight

subplot(5,1,2);
plot(ARt(ivec)/60/60, HCM4(ivec)-HCM4(ivec(1)), ARt(ivec)/60/60, HCM(1,ivec)-HCM(1,ivec(1)),'--r');
ylabel(sprintf('HCM(%d,4) [amps]', Sector-1));
axis tight

subplot(5,1,3);
plot(ARt(ivec)/60/60, HCM1(ivec)-HCM1(ivec(1)), ARt(ivec)/60/60, HCM(2,ivec)-HCM(2,ivec(1)),'--r');
ylabel(sprintf('HCM(%d,1) [amps]', Sector));
axis tight


% Vertical Plane
[VCM4, iVCM4] = arselect(VCM4str);
[VCM1, iVCM1] = arselect(VCM1str);

subplot(5,1,4);
plot(ARt(ivec)/60/60, VCM4(ivec)-VCM4(ivec(1)), ARt(ivec)/60/60, VCM(1,ivec)-VCM(1,ivec(1)),'--r');
ylabel(sprintf('VCM(%d,4) [amps]', Sector-1));
axis tight

subplot(5,1,5);
plot(ARt(ivec)/60/60, VCM1(ivec)-VCM1(ivec(1)), ARt(ivec)/60/60, VCM(2,ivec)-VCM(2,ivec(1)),'--r');
ylabel(sprintf('VCM(%d,1) [amps]', Sector));
xlabel(['Time since midnight [hours]']);
axis tight

orient tall