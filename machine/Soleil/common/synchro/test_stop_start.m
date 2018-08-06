

%start_3Hz;

tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',int32(2));
pause(1)
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',int32(0));

%stop_3Hz;
