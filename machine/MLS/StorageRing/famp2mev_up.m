function y = famp2mev_up(amp)
%This function computes the correction factor for the beam energy.
%Input: The current of the bendin magnet for the up curve. ELOG 559

a1 = 0.96009;
a2 = -0.69526E-10;
a3 = 0.99451;
a4 = 0.38157E-01;
a5 = 0.94392;
a6 = 0.13181E-01;


ger = a1 + a2 * amp;  
hysks = (a3 - a1 -105.70 *a2)*exp(-(amp-105.70)*a4); 
hysgs = (a5 - a1 - 665.98 *a2)*exp( (amp-665.98)*a6);

y = ger + hysgs + hysks;
