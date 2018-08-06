function setBPMAttenuator(att1,att2,groupID)
%groupID = tango_group_create('BPM'); 
%tango_group_add(groupID,family2tangodev('BPMx')');

tango_group_write_attribute(groupID,'Attenuator1',0,int16(att1));
tango_group_write_attribute(groupID,'Attenuator2',0,int16(att2));