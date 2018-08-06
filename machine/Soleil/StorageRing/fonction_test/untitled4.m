
for i=1:1000
    
    pause(1);
    tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');

end