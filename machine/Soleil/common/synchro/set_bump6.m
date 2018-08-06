function set_bump6

% deuxième optimisation du bump

delai0 =31522246;  
voltage0=3000;  
r=1.05
r1=1

k=0;

 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-0  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+5  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+4  + k);
 tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0+1  + k);



tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(5650*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(5626.8*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(5428.2*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(5481.6*r));

return
tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(5608*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(5560*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(5530*r*r1));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(5594*r*r1));




