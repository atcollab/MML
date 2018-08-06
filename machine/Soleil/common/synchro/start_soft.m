% test 3Hz
function start_soft

% Déclenche dans l'ordre les elements pulsés et le linac
    tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Update');    
    tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Update');
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Update');
    
display('Soft started')