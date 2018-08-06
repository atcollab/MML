Sector = input('Insertion Device Sector =');
date1=input('test date #1 (ie. ''07-06-94'', ''07-19-94'') = ');

if Sector<=9
  eval(['load ',date1,'\id0',num2str(Sector),'h.txt']);
  eval(['h=id0',num2str(Sector),'h;']);

  eval(['load ',date1,'\id0',num2str(Sector),'v.txt']);
  eval(['v=id0',num2str(Sector),'v;']);
else
  eval(['load ',date1,'\id',num2str(Sector),'h.txt']);
  eval(['h=id',num2str(Sector),'h;']);

  eval(['load ',date1,'\id',num2str(Sector),'v.txt']);
  eval(['v=id',num2str(Sector),'v;']);
end

b=fir1(25,.1);
%[vf]=filter(b,1,v(:,2));
[h1f]=filtfilt(b,1,h(:,2));
[v1f]=filtfilt(b,1,v(:,2));
[h2f]=filtfilt(b,1,h(:,3));
[v2f]=filtfilt(b,1,v(:,3));


figure(1); hold off;
plot(h(:,1),h(:,2),'-y',  h(:,1),h1f,'--m'); grid on; hold on;
plot(h(:,1),h(:,3),'-r',  h(:,1),h2f,':g'); hold off;
title(['Horizontal Dipole Correction Data (',date1,')']);
legend(['SR',num2str(Sector-1),'HCM4 (raw)'], ...
       ['SR',num2str(Sector-1),'HCM4 (filtered)'], ...
       ['SR',num2str(Sector),'HCM1 (raw)'], ...
       ['SR',num2str(Sector),'HCM1 (filtered)']);

figure(2); hold off;
plot(v(:,1),v(:,2),'-y',  v(:,1),v1f,'--m'); grid on; hold on;
plot(v(:,1),v(:,3),'-r',  v(:,1),v2f,':g'); hold off;
title(['Vertical Dipole Correction Data (',date1,')']);
legend(['SR',num2str(Sector-1),'VCM4 (raw)'], ...
       ['SR',num2str(Sector-1),'VCM4 (filtered)'], ...
       ['SR',num2str(Sector),'VCM1 (raw)'], ...
       ['SR',num2str(Sector),'VCM1 (filtered)']);


hfiltered = [h(:,1) h1f h2f];
vfiltered = [v(:,1) v1f v2f];

if Sector<=9
  eval(['save ',date1,'\id0',num2str(Sector),'hf.txt hfiltered -ascii']);
  eval(['save ',date1,'\id0',num2str(Sector),'vf.txt vfiltered -ascii']);
else
  eval(['save ',date1,'\id',num2str(Sector),'hf.txt hfiltered -ascii']);
  eval(['save ',date1,'\id',num2str(Sector),'vf.txt vfiltered -ascii']);
end


