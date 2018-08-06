function varargout=getbldata(bl,navg,dwell)
%=============================================================
%function varargout=GetblData(bl,navg,dwell)
%acquire photon BPM signals for SPEAR for all beamlines
%values returned in bl structure
%varargout=GetblData(bl,navg,dwell)
navg=1;
dwell=1;

bl(2).iopen=getam('blOpen');  
bl(2).open=find(bl(2).iopen);  
bl(2).iauto=getam('blOpen');  
bl(2).open=find(bl(2).iauto);  
bl(2).sum=getam('blOpen');  
bl(2).err=getam('blOpen');  
bl(2).cur=getam('blOpen');  

%protect against divide by zero in normalization loop
for ii=1:size(bl(2).name,1)
  if bl(2).sum(ii)==0
  bl(2).norm(ii)=0.0;
  else
  bl(2).norm(ii)=bl(2).err(ii)/bl(2).sum(ii);
  end
end

varargout{1}=bl(2);
