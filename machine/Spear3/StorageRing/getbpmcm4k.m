function [BPM, CMam, t116, t132, tcm, Error] = corrstepspear(CMFamily, CMDeviceList, BPMDeviceList)
%  [BPM, CMam, t116, t132, tcm, Error] = corrstepspear(CMFamily, CMDeviceList, BPMDeviceList)
%
%  Spear BPM channels
%  |   West pit    |     East pit    |     West pit     |
%  |   1  to  26   |   27  to    82  |    83  to   112  |
%  |[1 1] to [5 1] | [5 2] to [14 1] | [14 2] to [18 7] |


Error = 0;
if nargin < 1
    CMFamily = 'HCM';
end
if nargin < 2
    CMDeviceList = [1 1];
end
CMDeviceList = CMDeviceList(1,:);
if nargin < 3
    BPMDeviceList = family2dev('BPMx');
end


ChannelStr = family2channel(CMFamily, CMDeviceList);
i = findstr(ChannelStr,':');
ChannelStr = ChannelStr(1:i(end));

            
TimeOut = lcaGetTimeOut;
RetryCount = lcaGetRetryCount;



tmp = lcaGet('116-BPM:history.RARM');
if tmp ~= 2
    error('116-BPM:history.RARM = 2');
end
tmp = lcaGet('132-BPM:history.RARM'); 
if tmp ~= 2
    error('132-BPM:history.RARM = 2');
end


lcaPut('Spear:Event2',1);

tic;
N116 = lcaGet('116-BPM:history.NORD');
N132 = lcaGet('132-BPM:history.NORD');
while N116 ~= 896000 | N132 ~= 896000
    pause(.25);
    N116 = lcaGet('116-BPM:history.NORD');
    N132 = lcaGet('132-BPM:history.NORD');
    fprintf('   %f seconds after setting 116-BPM:history.RARM = 2 and Spear:Event2=1\n', toc);
    fprintf('   116-BPM:history.NORD = %d\n', N116);
    fprintf('   132-BPM:history.NORD = %d\n\n', N132);
    if toc > 10
        fprintf('   BPM Timeout\n');
        error('NORD problem');
    end
end

lcaSetTimeOut(.05);
lcaSetRetryCount(100);

tmp = lcaGet('116-BPM:history.RARM');
if tmp ~= 0
    error('116-BPM:history.RARM = 0');
end
tmp = lcaGet('132-BPM:history.RARM'); 
if tmp ~= 0
    error('132-BPM:history.RARM = 0');
end


%CMam = lcaGet('18G-COR1V:Curr1MuxADCTbl');
[CMam, tcm] = lcaGet([ChannelStr,'Curr1MuxADCTbl']);

    
% 116 East Pit
[BPM1, t116] = lcaGet('116-BPM:history');
%BPM1 = getpv('116-BPM:history');
BPM1 = reshape(BPM1, [4 56 4000]);

% 132 West Pit
[BPM2, t132] = lcaGet('132-BPM:history');
%BPM2 = getpv('132-BPM:history');
BPM2 = reshape(BPM2, [4 56 4000]);

%BPM = [BPM2(:,1:26,:)  BPM1(:,1:end,:) BPM2(:,27:56,:)];
BPM = [BPM2(:,31:56,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];

% % BPM(12,4) and BPM(12,5) got swapped (change back 2-11-2004)
% BPM(:,[73 74],:) = BPM(:,[74 73],:);

i = findrowindex(BPMDeviceList, family2dev('BPMx',0));
BPM = BPM(:,i,:);


lcaSetTimeOut(TimeOut);
lcaSetRetryCount(RetryCount)

