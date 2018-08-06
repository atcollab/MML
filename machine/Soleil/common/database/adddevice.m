dbserver = 'sys/database/dbds';

%% Creation des dserveur cyclage des aimants LT1
classname  = 'AttributeSequenceWriter';
devnameroot = 'LT1/AE/cycle';
servername = 'ds_AttributesequenceWriter/LT1';

magnet = {'CH.1', 'CH.2', 'CH.3', 'CV.1', 'CV.2', 'CV.3', 'D.1', ...
    'Q.1', 'Q.2', 'Q.3', 'Q.4', 'Q.5', 'Q.6', 'Q7'};

for k = 1:length(magnet),
    devname  = [devnameroot magnet{k}]    
    tango_command_inout2(dbserver,'DbAddDevice',{servername,devname,classname});
%      tango_command_inout(dbserver,'DbDeleteDevice',devname)
end
