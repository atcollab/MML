% mettre synchro OFF

for i=1:1000
  tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
  pause(0.6)
end
