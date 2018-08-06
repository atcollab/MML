load albaphysdata

%make x orbit sructure
x=getx('struct');  %orbit structure
x.Data=0*x.Data;

PhysData.BPMx.Offset=x;   %load structure into offset field
PhysData.BPMx.Golden=x;   %load structure into offset field
x.Data=1+x.Data;
PhysData.BPMx.Gain=x;     %load structure into offset field


%make y orbit sructure
y=gety('struct');  %orbit structure
y.Data=0*y.Data;

PhysData.BPMy.Offset=y;     %load structure into offset field
PhysData.BPMy.Golden=y;     %load structure into golden field
y.Data=1+y.Data;
PhysData.BPMy.Gain=y;       %load structure into gain field

%get dispersion data

dx=measdisp('struct');
PhysData.BPMx.Dispersion=dx;
% no vertical dispersion
dy=dx;
dy.Data=0*dy.Data;
PhysData.BPMy.Dispersion=dy; 
%make hcm sructure
hcm=getsp('HCM','struct');  %corrector structure
hcm.Data=0*hcm.Data;
PhysData.HCM.Offset=hcm;    %load structure into offset field
hcm.Data=1+hcm.Data;
PhysData.HCM.Gain=hcm;      %load structure into gain field

%make vcm sructure
vcm=getsp('VCM','struct');  %corrector structure
vcm.Data=0*vcm.Data;
PhysData.VCM.Offset=vcm;    %load structure into offset field
vcm.Data=1+vcm.Data;
PhysData.VCM.Gain=vcm;      %load structure into gain field

save albaphysdata PhysData



