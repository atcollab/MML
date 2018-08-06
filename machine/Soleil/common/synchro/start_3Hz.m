% test 3Hz
function start_3Hz(event)

% Déclenche dans l'ordre les elements pulsés et le linac
    tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Update');    
    tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Update');
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update'); 
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Update');
    
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',int32(event(1)));
    tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(event(2)));
    
    pause(1)
    %tango_command_inout2('LT1/SY/LOCAL.DG.1',  'Update');
    
display('3Hz started')