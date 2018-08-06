% saut Uper period
clear

boucle = 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ; % nombre de boucle
nshot  = 1; % shot par quart consécutifs

n      = 3;  % 1 ,2,3 ou 4 quarts 



if    (n==4)
   bunch=[0 104 208 312] +1 ;  
   npulse=length(bunch);
   nshot = nshot*[1 1 1 1];
elseif (n==3)   
   bunch=[0 104 208] +1 ;  
   npulse=length(bunch);
   nshot = nshot*[1 1 1];
elseif (n==2)   
   bunch=[0 104] +1 ;  
   npulse=length(bunch);
   nshot = nshot*[1 1];
elseif (n==1)   
   bunch=[0] +1 ;  
   npulse=length(bunch);
   nshot = nshot*[1];
end

bunch
nshot


[dtour,dpaquet]=bucketnumber(bunch);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');clk1=temp.value(1);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');clk2=temp.value(1);
clk_pc  =int32(dtour) +  int32(clk1);
clk_soft=int32(dtour)  + int32(clk2);

for k=1:boucle
    for i=1:npulse
        clk_pc(i)
        tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(i));
        tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(i));
        
        for j=1:nshot(i)
            tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
            pause(0.4)
        end   
    end
    %pause(600)
end

tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(1));
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(1));



