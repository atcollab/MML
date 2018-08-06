% pulse linac de 70 ns = 24 bunchs

boucle=1; % nombre de boucle
npulse=17 ; % 1 à div max
dbunch=24;

bunch=((1:npulse)-1).*dbunch + 1;
[dtour,dpaquet]=bucketnumber(bunch);
dtour

return
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');clk1=temp.value(1);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');clk2=temp.value(1);
clk_pc  =int32(dtour) +  int32(clk1);
clk_soft=int32(dtour)  + int32(clk2);

for k=1:boucle
    for i=1:npulse
        clk_pc(i)
        tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(i));
        tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(i));
        
        tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
        pause(0.4)
         
    end
end

tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(1));
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(1));



