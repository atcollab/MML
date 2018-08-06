function set_bump6

% deuxième optimisation du bump

delai0 =31522246;  
voltage0=3000;  
r=1.05
r1=1.0

k=0;

 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-0  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+3  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+5  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0+1  + k);



tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(5932.5*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(5908.14*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(5780.61*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(5876.18*r));



return



