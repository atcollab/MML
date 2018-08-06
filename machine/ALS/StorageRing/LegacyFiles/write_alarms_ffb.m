function write_alarms_ffb
% function write_alarms_ffb
%
% This routine writes the corrector magnet and IDBPM safety trip points, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002


HCMlist = [
    1     2
    1     7
    1     8
    2     1
    2     2
    2     7
    2     8
    3     1
    3     2
    3     7
    3     8
    4     1
    4     2
    4     7
    4     8
    5     1
    5     2
    5     7
    5     8
    6     1
    6     2
    6     7
    6     8
    7     1
    7     2
    7     7
    7     8
    8     1
    8     2
    8     7
    8     8
    9     1
    9     2
    9     7
    9     8
    10    1
    10    2
    10    7
    10    8
    11    1
    11    2
    11    7
    11    8
    12    1
    12    2
    12    7];

VCMlist = [
    1     2
    1     7
    1     8
    2     1
    2     2
    2     7
    2     8
    3     1
    3     2
    3     7
    3     8
    4     1
    4     2
    4     7
    4     8
    5     1
    5     2
    5     7
    5     8
    6     1
    6     2
    6     7
    6     8
    7     1
    7     2
    7     7
    7     8
    8     1
    8     2
    8     7
    8     8
    9     1
    9     2
    9     7
    9     8
    10    1
    10    2
    10    7
    10    8
    11    1
    11    2
    11    7
    11    8
    12    1
    12    2
    12    7];

IDBPMlist = [
     1     1
     1     2
     2     1
     2     2
     3     1
     3     2
     4     1
     4     2
     4     3
     4     4
     5     1
     5     2
     6     1
     6     2
     7     1
     7     2
     8     1
     8     2
     9     1
     9     2
    10     1
    10     2
    11     1
    11     2
    11     3
    11     4
    12     1
    12     2];


for loop=1:size(HCMlist,1)
   paramname=getname('HCM','Trim',HCMlist(loop,:),1);
   paramname2=sprintf('%s.LOW',paramname);
   scaput(paramname2,-2);
   paramname2=sprintf('%s.HIGH',paramname);
   scaput(paramname2,2);
end
for loop=1:size(VCMlist,1)
   paramname=getname('VCM','Trim',VCMlist(loop,:),1);
   paramname2=sprintf('%s.LOW',paramname);
   scaput(paramname2,-6);
   paramname2=sprintf('%s.HIGH',paramname);
   scaput(paramname2,6);
end

for loop=1:size(IDBPMlist,1)
   paramname=getname('IDBPMx',IDBPMlist(loop,:));
   changeindex=findstr(paramname,'X_AM');
   paramname(changeindex:(changeindex+3))='XRAM';
   paramname2=sprintf('%s.LOW',paramname);
   scaput(paramname2,getgolden('IDBPMx',IDBPMlist(loop,:))-2);
   paramname2=sprintf('%s.HIGH',paramname);
   scaput(paramname2,getgolden('IDBPMx',IDBPMlist(loop,:))+2);
end
for loop=1:size(IDBPMlist,1)
   paramname=getname('IDBPMy',IDBPMlist(loop,:));
   changeindex=findstr(paramname,'Y_AM');
   paramname(changeindex:(changeindex+3))='YRAM';
   paramname2=sprintf('%s.LOW',paramname);
   scaput(paramname2,getgolden('IDBPMy',IDBPMlist(loop,:))-2);
   paramname2=sprintf('%s.HIGH',paramname);
   scaput(paramname2,getgolden('IDBPMy',IDBPMlist(loop,:))+2);
end
