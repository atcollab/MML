%  test save all bpm

name='couplage1'
temp=getbpmrawdata('Struct');
X=temp.Data.X;
X=temp.Data.X;


temp=tango_read_attribute2('ANS-C01/EP/AL_K.4','voltage');
K4=temp.value(2);

bpm.Volt_K4=K4;
bpm.XposDD=X;
bpm.ZposDD=Z;


file=strcat(name,'.mat');
save(file, 'bpm');