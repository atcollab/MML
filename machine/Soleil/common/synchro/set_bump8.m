function set_bump8

% deuxième optimisation du bump

delai0 =31522246;  
voltage0=3000;  
r=0.98
r1=1.0

k=0;

 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-0  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+4  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+5  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0+1  + k);


tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(6200*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',((6200-0)*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',((6039+0)*r)*r1);
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(6197*r)*r1);



return



