% Open Channels, get handles
OrbitCounterHandle = mcaopen('spr:zc1/xx1(32)');
[XOrbitHandle, YOrbitHandle] = mcaopen('spr:zc1/xx1','spr:zc2/xx1'); 

%Read orbit for the first time
[X,Y] = mcaget(XOrbitHandle,YOrbitHandle);

% Used BPMs mask
GoodXbpms = [(2:17) (19:22) (25:31)];
GoodYbpms = [(2:17) (19:22) (25:31)];
XOrbitRef = X(GoodXbpms);
YOrbitRef = Y(GoodYbpms);

% Prepare graphics *************************************************
hf = figure;
set(hf,'MenuBar','none','DoubleBuffer','on','Name','SPEAR Orbit Display');
ha = axes;
set(ha,'XLim',[1 27],'XTick',(1:27));
set(ha,'YLim',[-0.1 0.1]);
hxl = line((1:27),zeros(1,27));
set(hxl,'Color','blue','Marker','o');
hyl = line((1:27),zeros(1,27));
set(hyl,'Color','red','Marker','square');
xlabel('BPM index');
ylabel('Beam Position [mm]');
legend('Hrizontal','Vertical');
title('Live Orbit - replot every time it is updated on the server');
set(hf,'HandleVisibility','off');
% End graphics ******************************************************


% Place a monitor on the Orbit Counter PV 'spr:zc1/xx1(32)
% The monitor callback schedules 'replotorbit' to run once
% See reploptorbit.m script
mcamon(OrbitCounterHandle,'timereval(1,10,''replotorbit'');')