function eff_versus_delai_kicker

% on décale la synchro des 4 kickers
%

n=1;
%set_bump(1);
% Lecture délais initiaux
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay');delais01=temp.value(n);
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay');delais02=temp.value(n);
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay');delais03=temp.value(n);
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay');delais04=temp.value(n);


ddelai=16;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigStepDelay',(delais01+ddelai)); pause(0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigStepDelay',(delais02+ddelai)); pause(0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigStepDelay',(delais03+ddelai)); pause(0);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigStepDelay',(delais04+ddelai)); pause(0);




    
    
    
    

