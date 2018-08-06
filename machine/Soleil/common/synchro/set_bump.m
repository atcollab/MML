function set_bump1

% bump equilibré voltage et synchro

delai0 =31522324;  
voltage0=4000;  
r=1.05



tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',delai0-4+1);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',delai0+0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',delai0+1-1);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',delai0-1);
tango_write_attribute2('ANS-C01/EP/AL_K.1', 'voltage',(4130*r));
tango_write_attribute2('ANS-C01/EP/AL_K.2', 'voltage',(3980*r));
tango_write_attribute2('ANS-C01/EP/AL_K.3', 'voltage',(4080*r));
tango_write_attribute2('ANS-C01/EP/AL_K.4', 'voltage',(4000*r));
    
    

    

