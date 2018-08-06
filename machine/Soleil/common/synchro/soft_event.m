%

for i=1:100
   fprintf('n=%g\n',i)
   tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
   pause(1)
end

%