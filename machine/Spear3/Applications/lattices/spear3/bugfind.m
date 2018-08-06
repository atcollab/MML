format
sp3v81cor;
s1=findspos(THERING,1:length(THERING)+1);
disp(['length of sp3v81cor: ' num2str(s1(end))]);
s1(end)
%s1=s1(end);

sp3v81newcor;
s2=findspos(THERING,1:length(THERING)+1);
disp(['length of sp3v81newcor: ' num2str(s2(end))]);
s2(end)
%s2=s2(end);

disp(' ')
disp(['difference :' num2str(s1(end)-s2(end))]); 
