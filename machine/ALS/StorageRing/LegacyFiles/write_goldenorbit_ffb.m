function write_goldenorbit_ffb
% function write_goldenorbit_ffb
%
% This routine writes the BPM setpoints, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002


IDBPMlist = [
    1   1
    1   2
    2   1
    2   2
    3   1
    3   2
    4   1
    4   2
    4   3
    4   4
    5   1
    5   2
    6   1
    6   2
    7   1
    7   2
    8   1
    8   2
    9   1
    9   2
    10  1
    10  2
    11  1
    11  2
    11  3
    11  4
    12  1
    12  2
];

BBPMlist = [
%     4   4
%     4   5
%    7   4
%    7   5
%     8   4
%     8   5
%    9   4
%    9   5
%    10  4
%    10  5
%     12  4
%     12  5
];

for loop=1:size(IDBPMlist,1)
   paramname=getname('IDBPMx',IDBPMlist(loop,:));
   changeindex=findstr(paramname,'X_AM');
   paramname(changeindex:(changeindex+3))='X_AC'
   scaput(paramname,getgolden('IDBPMx',IDBPMlist(loop,:)))
end
for loop=1:size(IDBPMlist,1)
   paramname=getname('IDBPMy',IDBPMlist(loop,:));
   changeindex=findstr(paramname,'Y_AM');
   paramname(changeindex:(changeindex+3))='Y_AC'
   scaput(paramname,getgolden('IDBPMy',IDBPMlist(loop,:)));
end
for loop=1:size(BBPMlist,1)
   paramname=getname('BBPMx',BBPMlist(loop,:));
   changeindex=findstr(paramname,'XT_AM');
   paramname(changeindex:(changeindex+4))='XT_AC'
   scaput(paramname,getgolden('BBPMx',BBPMlist(loop,:)));
end
for loop=1:size(BBPMlist,1)
   paramname=getname('BBPMy',BBPMlist(loop,:));
   changeindex=findstr(paramname,'YT_AM');
   paramname(changeindex:(changeindex+4))='YT_AC'
   scaput(paramname,getgolden('BBPMy',BBPMlist(loop,:)));
end

write_alarms_ffb;

% for loop=1:size(IDBPMlist,1)
%   paramname=getname('IDBPMx',IDBPMlist(loop,:));
%   changeindex=findstr(paramname,'X_AM');
%   paramname(changeindex:(changeindex+3))='XRAM';
%   paramname2=sprintf('%s.LOW',paramname);
%   scaput(paramname2,getgoldenorbit('IDBPMx',IDBPMlist(loop,:))-2);
%   paramname2=sprintf('%s.HIGH',paramname);
%   scaput(paramname2,getgoldenorbit('IDBPMx',IDBPMlist(loop,:))+2);
% end
% for loop=1:size(IDBPMlist,1)
%   paramname=getname('IDBPMy',IDBPMlist(loop,:));
%   changeindex=findstr(paramname,'Y_AM');
%   paramname(changeindex:(changeindex+3))='YRAM';
%   paramname2=sprintf('%s.LOW',paramname);
%   scaput(paramname2,getgoldenorbit('IDBPMy',IDBPMlist(loop,:))-2);
%   paramname2=sprintf('%s.HIGH',paramname);
%   scaput(paramname2,getgoldenorbit('IDBPMy',IDBPMlist(loop,:))+2);
% end
