% test 3Hz
function stop_3Hz

% Stop dans l'ordre le linac et les elements pulsés 
   %tango_command_inout2('LT1/SY/LOCAL.DG.1',  'Reset');
   
   tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',int32(0));
   tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(0));
   
   tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Reset');
   tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Reset');
   tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Reset');
   tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Reset');   

display('3Hz stopped')