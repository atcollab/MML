% test kicker


for i=1:100
    i
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
    pause(2)
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Reset');
    pause(2)
end