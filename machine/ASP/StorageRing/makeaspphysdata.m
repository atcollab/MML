t=getphysdata

b=getx('struct');

t.BPMx.Golden=b;
t.BPMx.Golden.Data=zeros(98,1);
t.BPMx.Gain=b;
t.BPMx.Gain.Data=ones(98,1);
t.BPMx.Offset=b;
t.BPMx.Offset.Data=zeros(98,1);
t.BPMx.Coupling=b;
t.BPMx.Coupling.Data=zeros(98,1);

b=gety('struct');
t.BPMy.Golden=b;
t.BPMy.Golden.Data=zeros(98,1);
t.BPMy.Gain=b;
t.BPMy.Gain.Data=ones(98,1);
t.BPMy.Offset=b;
t.BPMy.Offset.Data=zeros(98,1);
t.BPMy.Coupling=b;
t.BPMy.Coupling.Data=zeros(98,1);

cd '/scratch/jeffsept2006/ASP/StorageRingOpsData/'

save 'ASPphysdata' t