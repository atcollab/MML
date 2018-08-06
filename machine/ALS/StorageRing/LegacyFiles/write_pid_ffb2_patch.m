function write_pid_ffb2_patch(PH,IH,DH,PV,IV,DV);
% function write_pid_ffb2_patch(PH,IH,DH,PV,IV,DV)
%
% This routine writes the PID gains, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002

HCMlist = [
   1   2
   1   8
   2   1
   2   8
   3   1
   3   7
   3   8
   4   1
   	4   2 
   4   7 % added for testing as work-around of even-number corrector test in ffb code (12-1-03)
   4   8
   5   1
   5   8
   6   1
   6   8
   7   1
   7   8
   8   1
   8   8
   9   1
   9   8
   10  1
   10  8
   11  1
   11  2
   11  7
   11  8
   12  1
   12  7
];

VCMlist = [
   1   2 
   1   8
   2   1
   2   8
   3   1
   3   7
   3   8
   4   1
   4   7
   4   8
   5   1
   5   8
   6   1
   6   8
   7   1
   7   8
   8   1
   8   8
   9   1
   9   8
   10  1
   10  8
   11  1
   11  2
   11  7
   11  8
   12  1
   12  7
];

% HCMCHICANElist = [
%     4   2
%     11  2
% ];

% VCMCHICANElist = [
%     4   2
%     11  2
% ];

for loop=1:size(HCMlist,1)
   paramname=getname('HCM','Trim',HCMlist(loop,:),1);
   changeindex=findstr(paramname,'T__');
   paramname(changeindex:(changeindex+2))='PID';
   paramname1=[paramname '.KP'];
   scaput(paramname1,PH);
   paramname1=[paramname '.KI'];
   scaput(paramname1,IH);
   paramname1=[paramname '.KD'];
   scaput(paramname1,DH);
end
for loop=1:size(VCMlist,1)
   paramname=getname('VCM','Trim',VCMlist(loop,:),1);
   changeindex=findstr(paramname,'T__');
   paramname(changeindex:(changeindex+2))='PID';
   paramname1=[paramname '.KP'];
   scaput(paramname1,PV);
   paramname1=[paramname '.KI'];
   scaput(paramname1,IV);
   paramname1=[paramname '.KD'];
   scaput(paramname1,DV);
end
