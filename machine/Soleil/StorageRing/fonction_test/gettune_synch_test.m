% lecture nus



temp=tango_read_attribute2('ANS/DG/BPM-TUNEZ','FFTabs');table_nu  =temp.value;
temp=tango_read_attribute2('ANS/DG/BPM-TUNEZ','FFTord');table_freq=log10(temp.value);
temp=tango_read_attribute2('ANS/DG/BPM-TUNEZ','Nu');tunez0=temp.value;
tunez0=0.2836;
dnu=0.002;
I0=int16(length(table_nu)*tunez0/0.5);
DI0=int16(length(table_nu)*dnu/0.5);

[C,I]=max(table_freq(I0-DI0 : I0+DI0));
I=I+I0-DI0-1;
tunez=table_nu(I);

DIS=int16(length(table_nu)*0.0025/0.5);

ISmoins = I-2*DIS;
[Cm,Im]=max(table_freq(ISmoins-DIS : ISmoins+DIS));
ISmoins= Im+ISmoins-DIS-1;
tunezmoins=table_nu(ISmoins);
tunesmoins = tunez-tunezmoins;

ISplus = I+2*DIS;
[Cp,Ip]=max(table_freq(ISplus-DIS : ISplus+DIS));
ISplus= Ip+ISplus-DIS-1;
tunezplus=table_nu(ISplus);
tunesplus = tunezplus-tunez;


plot(table_nu,table_freq); hold on;
plot(tunez,C,'ok')
plot(tunezmoins,Cm,'ok')
plot(tunezplus,Cp,'ok'); hold off
xlim([tunez-0.006, tunez+0.006])

cur=getdcct;
data=[cur tunesmoins tunez tunesplus];
fprintf('%g %g %g %g\n',data)
