function write_alarms_ffb
% function write_alarms_ffb
%
% This routine writes the corrector magnet and IDBPM safety trip points, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002
%
% 6-19-06 T.Scarvie, modified to work with new Middle Layer
%
% Eric's routines seem to work differently than what we had assumed so far. They seem to not be
% relative to the absolute orbit (which the raw BPM channels which one sets the alarm thresholds for)
% but rather they seem to be to the difference orbit (where the golden setpoint is subtracted).

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

% changed by Christoph Steier, 2011-02-06 - set for all Bergoz BPMs, since all might be used in FOFB
BPMlist = getbpmlist('Bergoz');

% BPMlist = [
%      1     2
%      1     5
%      1     6
%      1    10
%      2     1
%      2     5
%      2     6
%      2     9
%      3     2
%      3     5
%      3     6
%      3    10
%      3    11
%      3    12
%      4     1
%      4     5
%      4     6
%      4    10
%      5     1
%      5     5
%      5     6
%      5    10
%      5    11
%      5    12
%      6     1
%      6     5
%      6     6
%      6    10
%      7     1
%      7     5
%      7     6
%      7    10
%      8     1
%      8     5
%      8     6
%      8    10
%      9     1
%      9     5
%      9     6
%      9    10
%     10     1
%     10     5
%     10     6
%     10    10
%     10    11
%     10    12
%     11     1
%     11     5
%     11     6
%     11    10
%     12     1
%     12     5
%     12     6
%     12     9];


for loop=1:size(HCMlist,1)
   paramname=getname('HCM','Trim',HCMlist(loop,:),1);
   paramname2=sprintf('%s.LOW',paramname);
   setpv(paramname2,-2);
   paramname2=sprintf('%s.HIGH',paramname);
   setpv(paramname2,2);
end
for loop=1:size(VCMlist,1)
   paramname=getname('VCM','Trim',VCMlist(loop,:),1);
   paramname2=sprintf('%s.LOW',paramname);
   setpv(paramname2,-2);
   paramname2=sprintf('%s.HIGH',paramname);
   setpv(paramname2,2);
end

for loop=1:size(BPMlist,1)
   paramname=getname('BPMx',BPMlist(loop,:));
   changeindex=findstr(paramname,'X_AM');
   if isempty(changeindex)
       changeindex=findstr(paramname,'T_AM');
   end
   paramname(changeindex+1)='R';
   paramname2=sprintf('%s.LOW',paramname);
%   setpv(paramname2,getgolden('BPMx',BPMlist(loop,:))-2);
   setpv(paramname2,-3);
   paramname2=sprintf('%s.HIGH',paramname);
%   setpv(paramname2,getgolden('BPMx',BPMlist(loop,:))+2);
   setpv(paramname2,3);
end
for loop=1:size(BPMlist,1)
   paramname=getname('BPMy',BPMlist(loop,:));
   changeindex=findstr(paramname,'Y_AM');
   if isempty(changeindex)
       changeindex=findstr(paramname,'T_AM');
   end
   paramname(changeindex+1)='R';
   paramname2=sprintf('%s.LOW',paramname);
%   setpv(paramname2,getgolden('BPMy',BPMlist(loop,:))-2);
   setpv(paramname2,-1);
   paramname2=sprintf('%s.HIGH',paramname);
%   setpv(paramname2,getgolden('BPMy',BPMlist(loop,:))+2);
   setpv(paramname2,1);
end
