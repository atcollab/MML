% tables synchro


clear bunch
paquet=1;
bunch(1)=1;
p=0;
tab=[0 0];
for i=1:52
    
   paquet=paquet+184;
   if (paquet>416)
       paquet=paquet-416;
       p=p+1;
   end    
   bunch(i+1)=paquet;
   tab=[tab ; i p ]
end
bunch
tab