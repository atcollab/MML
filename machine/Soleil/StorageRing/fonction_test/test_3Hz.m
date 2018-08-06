% test 3Hz


event=int32(2);
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',event);
pause(0.3);
event=int32(0);
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',event);