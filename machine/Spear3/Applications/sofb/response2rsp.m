function rsp=response2rsp(datastruct,rsp,plane)
%load middlelayer response matrix data format into orbit program response structure
%rsp=orbit program response structure
%datastruct=middlelayer response matrix data format

temp=datastruct;
if iscell(temp)
    temp=temp{1}
end

BPMFamily={'BPMx', 'BPMy'};
CORFamily={'HCM' , 'VCM' };

if ~exist('plane','var')  %check if variable
  for ip=1:2
   nbpm=length(getfamilydata(BPMFamily{ip},'Status'));
   ncor=length(getfamilydata(CORFamily{ip},'Status'));
   rsp(ip).ib=dev2elem(BPMFamily{ip}, temp(ip,ip).Monitor.DeviceList);      %BPM index list
   rsp(ip).ic=dev2elem(CORFamily{ip}, temp(ip,ip).Actuator.DeviceList);     %corrector index list
   rsp(ip).c=zeros(nbpm,ncor);
   rsp(ip).c(rsp(ip).ib,rsp(ip).ic)=temp(ip,ip).Data;                       %response matrix INCLUDING NaN ENTRIES
   rsp(ip).cur=temp(ip,ip).ActuatorDelta;                                   %corrector currents
   nbl=length(getfamilydata('BLOpen','ElementList'));                       %number of beamlines
   rsp(ip).ibl=zeros(1,nbl);                                                %photon bpms
   rsp(ip).cp=zeros(nbl,length(rsp(ip).ic));                                %response matrix to pbpms
   rsp(ip).respstruct=temp(ip,ip);
  end
else
   ip=plane;
   nbpm=length(getfamilydata(BPMFamily{ip},'Status'));
   ncor=length(getfamilydata(CORFamily{ip},'Status'));
   rsp.ib=dev2elem(BPMFamily{ip},temp.Monitor.DeviceList);                  %BPM index list
   rsp.ic=dev2elem(CORFamily{ip},temp.Actuator.DeviceList);                 %corrector index list
   rsp.c=zeros(nbpm,ncor);
   rsp.c(rsp.ib,rsp.ic)=temp.Data;                                          %response matrix INCLUDING NaN ENTRIES
   rsp.cur=temp.ActuatorDelta;                                              %corrector currents
   nbl=length(getfamilydata('BLOpen','ElementList'));                       %number of beamlines
   rsp.ibl=zeros(1,nbl);                                                    %photon bpms
   rsp.cp=zeros(nbl,length(rsp.ic));                                         %response matrix to pbpms
   rsp.respstruct=temp;
end

