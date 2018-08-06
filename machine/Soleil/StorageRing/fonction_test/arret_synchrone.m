% test  arret synchrone

% arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'};
% arg.lvalue=int32([5 5 5 5])
% tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg) 


for i=1:20
    
    fprintf('ite =%g\n',i)
    arg.lvalue=int32([1 1 1 1]); 
    fprintf('adress =%g\n',1)
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);
    pause(2)
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','Update');
    pause(2)
    
    arg.lvalue=int32([5 5 5 5]); 
    fprintf('adress =%g\n',5)
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);
    pause(2)
    tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','Update');
    pause(2)
    
end