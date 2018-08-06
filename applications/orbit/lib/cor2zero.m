function cor2zero
%set horizontal and vertical correctors to zero
COR=getappdata(0,'COR');

status=COR(1).status;
z=zeros(length(status),1);
setsp('HCM',z,status);


status=COR(2).status;
z=zeros(length(status),1);
setsp('VCM',z,status);
