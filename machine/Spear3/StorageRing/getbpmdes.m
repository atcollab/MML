function orbit=getbpmdes(family)
%acquire golden orbit PV's from Des fields
%horizontal        <bpm name>:UDes
%vertical          <bpm name>:VDes

%written by J. Corbett   June 21, 2004

if strcmpi(family,'BPMx')      %horizontal

bpmpv=family2channel('BPMx');
for k=1:size(bpmpv,1);
    orbit(k)=getpv([deblank(bpmpv(k,:)) 'Des']);
end

elseif strcmpi(family,'BPMy')
bpmpv=family2channel('BPMy');  %vertical
for k=1:size(bpmpv,1);
    orbit(k)=getpv([deblank(bpmpv(k,:)) 'Des']);
end

end

orbit=orbit(:);

