function set_bump3

% deuxième optimisation du bump

delai0 =31522244;  
voltage0=3000;  
r=1.4*1.35

tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0+2);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+6);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+6);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0+5);
tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(3000*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(2970*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(2880*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(2895*r));




