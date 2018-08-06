[X,Y] = mcaget(XOrbitHandle,YOrbitHandle);

XOrbit = X(GoodXbpms) - XOrbitRef;
YOrbit = Y(GoodYbpms) - YOrbitRef;

set(hxl,'YData',XOrbit);
set(hyl,'YData',YOrbit);