% mettre synchro OFF

for i=1:1000
  tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
  pause(2)
end
