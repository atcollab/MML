% getbpm data alex
% boucle en pas 100 ns


    
for i=1:1000
    
    tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
    pause(1)
%     temp=tango_read_attribute2('ANS-C01/DG/BPM.2','XPosDD');
%     bpm.Xpos=temp.value;
%     plot(bpm.Xpos(1:30),'-ob')
%     ylim([-1 1]); grid on
  
    
end

    