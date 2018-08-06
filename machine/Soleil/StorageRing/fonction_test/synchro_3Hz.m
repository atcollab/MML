% saut Uper period

laps=5            % en seconde
nbunch=416;
div=7;
npulse=2;

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset=temp.value(1)*52;
bunch=(0:(npulse-1)).*nbunch/div + 1;
[dtour,dpaquet]=bucketnumber(bunch);
table=int32([length(bunch) dtour dpaquet]);
tango_command_inout('ANS/SY/CENTRAL','SetTables',table);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TablesCurrentDepth');
n=temp.value;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionDelayTable');
table=temp.value(1:n)-offset


tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1', 'Update'); 
tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2', 'Update'); 
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',int32(2)); 
pause(laps)
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',int32(0)); 
tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2', 'Reset');
tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1', 'Reset'); 
