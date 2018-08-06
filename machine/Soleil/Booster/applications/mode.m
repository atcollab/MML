

tango_write_attribute2('BOO/SY/LOCAL.Bext.1','k.trigEvent',int32(0));pause(2)
tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(2)
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',int32(5));