function write_goldenorbit_ffb(PSBFlag)
% function write_goldenorbit_ffb
%
% This routine writes the BPM setpoints, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002
%
% 6-19-06 T.Scarvie, modified to work with new Middle Layer

if nargin < 1
    PSBFlag = 0;
end

BPMlist = [
     1     2
%     1     5
%     1     6
     1    10
     2     1
%     2     5
%     2     6
     2     9
     3     2
%     3     5
%     3     6
     3    10
     3    11
     3    12
     4     1
%     4     5
%     4     6
     4    10
     5     1
%     5     5
%     5     6
     5    10
     5    11
     5    12
     6     1
%     6     5
%     6     6
     6    10
     6    11
     6    12
     7     1
%     7     5
%     7     6
     7    10
     8     1
%     8     5
%     8     6
     8    10
     9     1
%     9     5
%     9     6
     9    10
    10     1
%    10     5
%    10     6
    10    10
    10    11
    10    12
    11     1
%    11     5
%    11     6
    11    10
    12     1
%    12     5
%    12     6
12     9
];

yKick = zeros(size(BPMlist,1),1);
if PSBFlag
    % Pseudo single bunch - scale the orbit by the voltage in the kicker
    [xKick, yKick] = getpseudosinglebunchkick(BPMlist);
end

for loop=1:size(BPMlist,1)
   paramname=getname('BPMx',BPMlist(loop,:));
   try
       changeindex=findstr(paramname,'X_AM');
       paramname(changeindex:(changeindex+3))='X_AC';
   catch
       changeindex=findstr(paramname,'XT_AM');
       paramname(changeindex:(changeindex+4))='XT_AC';
   end
   setpvonline(paramname,getgolden('BPMx',BPMlist(loop,:)));
end

for loop=1:size(BPMlist,1)
   paramname=getname('BPMy',BPMlist(loop,:));
   try
       changeindex=findstr(paramname,'Y_AM');
       paramname(changeindex:(changeindex+3))='Y_AC';
   catch
       changeindex=findstr(paramname,'YT_AM');
       paramname(changeindex:(changeindex+4))='YT_AC';
   end
   setpvonline(paramname,getgolden('BPMy',BPMlist(loop,:))+yKick(loop));
end

Dev = family2dev('BPM');
setpv('BPM', 'XGoldenSetpoint', getgolden('BPMx',Dev), Dev);
setpv('BPM', 'YGoldenSetpoint', getgolden('BPMy',Dev), Dev);

write_alarms_ffb;
