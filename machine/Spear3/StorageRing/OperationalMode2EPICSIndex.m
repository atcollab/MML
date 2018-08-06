setoperationalmode
ad=getad;
ad.OperationalMode;
setpv('SPEAR:ConfigMode',ad.OperationalMode);
getpv('SPEAR:ConfigMode');