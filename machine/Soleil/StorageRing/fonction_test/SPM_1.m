% mesure longueur de paquet SPM

temp=tango_read_attribute2('ans/dg/dcct-ctrl','lifeTime');
lifetime=temp.value;
temp=tango_read_attribute2('ans/dg/dcct-ctrl','current');
current=temp.value;

temp=tango_read_attribute2('ans-c03/rf/lle.1','voltageRF');
V1=temp.value(1);
temp=tango_read_attribute2('ans-c03/rf/lle.2','voltageRF');
V2=temp.value(1);
Vrf=V1+V2;

fprintf('%6.2f  %6.2f  %6.2f\n',current,lifetime,Vrf)


