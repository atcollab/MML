% test kicker


for i=1:100
    i
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(10));
    pause(2);
    
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(240));
    pause(2);
    
    
end