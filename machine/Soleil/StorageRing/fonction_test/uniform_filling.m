%test

boucle=1*13;


bunch0=1;
dbunch=4*8;


fprintf('***************************************\n')
fprintf('boucle, dbunch = %d %d \n',boucle,dbunch)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');clk1=temp.value(1)
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');clk2=temp.value(1)


for k=1:boucle
    
    bunch=bunch0 + (k-1)*dbunch;
    [dtour,dpaquet]=bucketnumber(bunch);    
    clk_pc  =int32(dtour) +  int32(clk1);
    clk_soft=int32(dtour)  + int32(clk2);
    
    fprintf('bunch, dtour, dpaquet,    pc,soft = %d %d %d     %d %d\n',mod(bunch,416),dtour,dpaquet,clk_pc,clk_soft)
    
    tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft);
    tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');

    pause(0.4)

end

tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',int32(clk1));
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',int32(clk2));