function MeV = famp2mev_down(amp)
%This function computes the correction factor for the beam energy. 
%Input: The current of the bending magnet for the down curve. ELOG 559

a1 = 0.97820;
a2 = -0.20452E-04;
a3 = 0.99451;
a4 = 0.15580E-01;
a5 = 0.94392;
a6 = 0.23877E-01;


ger = a1 + a2 * amp;  
hysks = (a3 - a1 - 105.70 *a2)*exp(-(amp-105.70)*a4); 
hysgs = (a5 - a1 - 665.98 *a2)*exp( (amp-665.98)*a6);

y = ger + hysgs + hysks;
% MeV = y * amp;
MeV = y;