function [BPM, CMam, t116, t132, Error] = corrstepspear(CMFamily, CMDeviceList, BPMDeviceList)
%  [BPM, CMam, t116, t132, Error] = corrstepspear(CMFamily, CMDeviceList, BPMDeviceList)
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

% Reset the setpoint so that the first point is the buffer is the setpoint
sp0=getsp(CMFamily, CMDeviceList);
setsp(CMFamily, sp0, CMDeviceList);

ChannelStr = family2channel(CMFamily, CMDeviceList);
i = findstr(ChannelStr,':');
ChannelStr = ChannelStr(1:i(end));

            
TimeOut = lcaGetTimeOut;
RetryCount = lcaGetRetryCount;


% lcaPut('18G-COR1V:ControlState','HALT');
%lcaPut({[ChannelStr, 'ControlState']},'HALT');
lcaPut([ChannelStr, 'ControlState'],0);            % 'HALT'=0, 'ARM'=1
%setpv(CMFamily, 'ControlState', 'HALT', CMDeviceList);


% SP = lcaGet('18G-COR1V:CurrSetpt');
SP = lcaGet([ChannelStr, 'CurrSetpt']);
Delta = .05 * [ones(1,1999) 0];
%Delta = [zeros(1,500) .4*ones(1,1500)];
%Delta = [zeros(1,1000) .4*ones(1,1000)];
%Delta = .4 * sin(2*pi*(1:2000)/2000);
%Delta = [.1 * sin(2*pi*(1:400)/400) zeros(1,1600)];
 
% lcaPut('18G-COR1V:CurrSetpt', SP(1)+Delta);
% lcaPut('18G-COR1V:CurrInterSteps', 0);
% lcaPut('18G-COR1V:LoopIter', 1);
% lcaPut('18G-COR1V:ControlState', 'EVENT2');
% lcaPut('18G-COR1V:Curr1MuxADCTbl.RARM',2);

lcaPut([ChannelStr,'CurrSetpt'], SP(1)+Delta);
lcaPut([ChannelStr,'CurrInterSteps'], 0);
lcaPut([ChannelStr,'LoopIter'], 1);
%lcaPut([ChannelStr,'ControlState'], 'EVENT2');
lcaPut([ChannelStr,'ControlState'], 5);         % 'EVENT2'=5, 'EVENT1'=4
lcaPut([ChannelStr,'Curr1MuxADCTbl.RARM'],2);


% Trigger on event timer 2
lcaPutNoWait('116-BPM:history.RARM', 0+2);
lcaPutNoWait('132-BPM:history.RARM', 0+2);
pause(.1);


tmp = lcaGet('116-BPM:history.RARM');
if tmp ~= 2
    error('116-BPM:history.RARM = 2');
end
tmp = lcaGet('132-BPM:history.RARM'); 
if tmp ~= 2
    error('132-BPM:history.RARM = 2');
end


% Trigger on event timer 2
lcaPut('Spear:Event2',1);

tic;
Event  = lcaGet('Spear:Event2',0,'Char');
N116 = lcaGet('116-BPM:history.NORD');
N132 = lcaGet('132-BPM:history.NORD');
while N116 ~= 896000 | N132 ~= 896000
    fprintf('   %f seconds after setting 116-BPM:history.RARM = 2 and Spear:Event2=%s\n', toc, Event{1});
    fprintf('   116-BPM:history.NORD = %d\n', N116);
    fprintf('   132-BPM:history.NORD = %d\n\n', N132);
    if toc > 5
        fprintf('   BPM Timeout\n');
        error('NORD problem');
    end
    pause(.25);
    Event  = lcaGet('Spear:Event2',0,'Char');
    N116 = lcaGet('116-BPM:history.NORD');
    N132 = lcaGet('132-BPM:history.NORD');
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
CMam = lcaGet([ChannelStr,'Curr1MuxADCTbl']);

    
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

