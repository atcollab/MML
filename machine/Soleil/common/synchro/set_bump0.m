function set_bump0

% bump equilibré voltage et synchro

delai0 =31522324;  
voltage0=4000;  
r=1.05


tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0);
tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(voltage0*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(voltage0*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(voltage0*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(voltage0*r));





