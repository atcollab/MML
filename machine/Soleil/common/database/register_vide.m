function register_vide

%%
dbserver = 'sys/database/dbds';
serverName = 'statecomposer/ANS-VI';
className = 'StateComposer';

deviceName = 
{
'ANS/VI/STATECOMPOSER.1',
'ANS-C01/VI/STATECOMPOSER.1',
'ANS-C02/VI/STATECOMPOSER.1',
'ANS-C03/VI/STATECOMPOSER.1',
'ANS-C04/VI/STATECOMPOSER.1',
'ANS-C05/VI/STATECOMPOSER.1',
'ANS-C06/VI/STATECOMPOSER.1',
'ANS-C07/VI/STATECOMPOSER.1',
'ANS-C08/VI/STATECOMPOSER.1',
'ANS-C09/VI/STATECOMPOSER.1',
'ANS-C10/VI/STATECOMPOSER.1',
'ANS-C11/VI/STATECOMPOSER.1',
'ANS-C12/VI/STATECOMPOSER.1',
'ANS-C13/VI/STATECOMPOSER.1',
'ANS-C14/VI/STATECOMPOSER.1',
'ANS-C15/VI/STATECOMPOSER.1',
'ANS-C16/VI/STATECOMPOSER.1'
}


for k=1:3,
    deviceName = ['LT2/VI/JPEN.' num2str(k)];
     tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end
