% test load table synchro

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset_ext=temp.value(1)*52;
offset_linac=10*0.5;  % délai fin de réglage en pas de 100 ps

paq=3;
bunch=1:1;

[dtour,dpaquet]=bucketnumber(bunch);
dpaquet=dpaquet*28+offset_linac;
table=int32([length(bunch) dtour dpaquet]);
tango_command_inout2('ANS/SY/CENTRAL','SetTables',table)