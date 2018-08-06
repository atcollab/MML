function set_bump2

% deuxième optimisation du bump

delai0 =31522324;  
voltage0=4000;  
r=1.4

tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-3);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(3000*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(2960*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(2900*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(2880*r));



