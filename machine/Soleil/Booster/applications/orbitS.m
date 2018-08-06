% Returns beam signals at BPM location 
%   Usefull to determine where the beam is lost if beam does make a turn.
%
% affichage des vecteur Sum
% 
% TODO
 
%
% Written by A. Loulergue

n=28;
nbpm=22;
clear visu s
for i=2:nbpm,
   ss = getbpmrawdata(i,'NoDisplay','Struct','NoGroup');
   j=0;
   k1=((i-1)*n)+1;
   k2=(i*n);
   for k=k1:k2
       j=j+1; 
       visu(k)=ss.Data.Sum(j);
       s(k)=k/n+1;
   end
end   

figure(12)
plot(s,visu); xlim([1 (nbpm+1)])