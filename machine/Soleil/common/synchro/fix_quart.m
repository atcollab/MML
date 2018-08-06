% fix premier quart

function [clk_pc,clk_soft]=fix_quart


n=1;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');
clk1=temp.value(n);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
clk2=temp.value(n);

jump=int32([0 39 26 13]);
clk_pc  =jump +  int32(clk1);
clk_soft=jump  + int32(clk2);

