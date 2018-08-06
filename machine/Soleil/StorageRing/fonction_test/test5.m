%

temp=tango_read_attribute2('BOO-C11/EP/AL_SEP_P.Ext.1','voltage');
passif0=temp.value(1);
temp=tango_read_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage');
actif0=temp.value(1);

passif0=115.72
actif0=99.59

dv=+1;

passif=passif0+dv
actif=actif0-dv/10

writeattribute('BOO-C11/EP/AL_SEP_P.Ext.1/voltage',passif);
writeattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage,',actif);