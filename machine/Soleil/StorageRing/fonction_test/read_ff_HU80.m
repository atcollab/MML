function getffwdtable
dev='ANS-C08/EI/M-HU80.2';

temp = tango_read_attribute2(dev,'correction1ParallelMode');
tab1r = temp.value

temp = tango_read_attribute2(dev,'correction2ParallelMode');
tab2r = temp.value

temp = tango_read_attribute2(dev,'correction3ParallelMode');
tab3r = temp.value

temp = tango_read_attribute2(dev,'correction4ParallelMode');
tab4r = temp.value

%%
temp = tango_read_attribute2(dev,'correction1ParallelMode');
tab1r = temp.value

%%
tab =[ 
    0  -20 0 20
    30  1   2  3
    50 -1  -2 -3
    ]
%%
for k1=1:size(tab,1),
for k2=1:size(tab,2),    
argin.dvalue = [1 1];
argin.svalue = {'correction1ParallelMode'};
    
argin.dvalue = [1 1];
argin.svalue = {'correction1ParallelMode'};
tango_command_inout2(dev,'GetCorrectionAt',argin)
%%


tango_write_attribute2(dev,'correction1ParallelMode',tab');

%%
tango_write_attribute2('tmp/test/tangotest_1','double_image',tab');
