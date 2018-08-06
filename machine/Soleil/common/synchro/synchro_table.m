%tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset=temp.value(1)*52;

bunch=[1 105 209 313];
[dtour,dpaquet]=bucketnumber(bunch);
dtour
table=int32([length(bunch) dtour dpaquet]);
tango_command_inout('ANS/SY/CENTRAL','SetTables',table)
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TablesCurrentDepth');
n=temp.value;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionDelayTable');
temp.value(1:n)-offset