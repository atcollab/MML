% saut Uper period

boucle=5; % nombre de boucle
%nshot=1;  % nombre de tir sur le meme segment
div=4.5;    % = 5 --> remplissage par cinquieme
npulse=3; % 1 à div max

nshot=3*[1 1 1];


nbunch=416;
bunch=(0:(npulse-1)).*nbunch/div + 1;
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
end

tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(1));
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(1));



