% test kicker

arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}
%arg.svalue={'sep-p.trig','sep.pc','sep-a.trig','libre.1'}
for i=1:1000
    i
    arg.lvalue=int32([0 0 0 0]); 
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);
    pause(2);tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');pause(2)
    
    
    arg.lvalue=int32([3 3 3 3]); 
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);
    pause(2);tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update'); pause(2)
    
    
end


