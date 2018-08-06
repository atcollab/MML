function bl=response2bl(datastruct,bl)
%bl=response2bl(datastruct,bl)
%load middlelayer response matrix data format into orbit program response structure
%bl=orbit program response structure
%datastruct=middlelayer response matrix data format

temp=datastruct;
if iscell(temp)
    temp=temp{1}
end

ErrStruct=temp(4,1);

BLFamily={'BLOpen', 'BLSum', 'BLErr'};
CORFamily={'VCM' };

   nbl =size(getlist(BLFamily{1} ,0),1);
   ncor=size(getlist(CORFamily{1},0),1);
   bl(2).ib=dev2elem(BLFamily{3},ErrStruct.Monitor.DeviceList);                  %BPM index list
   bl(2).ic=dev2elem(CORFamily{1},ErrStruct.Actuator.DeviceList);                %corrector index list
   bl(2).cp=zeros(nbl,ncor);
   bl(2).cp(bl(2).ib,bl(2).ic)=ErrStruct.Data;                                   %response matrix INCLUDING zero ENTRIES
   bl(2).cur=ErrStruct.ActuatorDelta;                                            %corrector currents
   bl(2).respstruct=temp;

