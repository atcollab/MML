switch2online;

setfamilydata('Simulator','BPMx','Setpoint','Mode')
setfamilydata('Simulator','BPMx','Monitor','Mode')
setfamilydata('Simulator','BPMy','Monitor','Mode')
setfamilydata('Simulator','BPMy','Setpoint','Mode')
setfamilydata('Simulator','RF','Setpoint','Mode')
setfamilydata('Simulator','RF','Monitor','Mode')

setradiation off;
setcavity off;

configonline = getmachineconfig({'VCM','HCM'},'Online');
setmachineconfig(configonline,'Simulator');
