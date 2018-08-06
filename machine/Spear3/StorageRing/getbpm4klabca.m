function [BPM, t116, t132, Error] = getbpm4klabca(DeviceList)
%  BPM = getbpm4k(DeviceList)
%
%  Spear BPM channels
%  |  West pit 132 |    East pit 116 |    West pit 132  |
%  |   1  to  26   |   27  to    82  |    83  to   112  |
%  |[1 1] to [5 1] | [5 2] to [14 1] | [14 2] to [18 7] |

nBpms = 61;
nData = 4*nBpms*4000;

Error = 0;
if nargin == 0
    DeviceList = family2dev('BPMx');
end

TimeOut = lcaGetTimeout;
RetryCount = lcaGetRetryCount;


% Trigger on event timer 2
lcaPutNoWait('116-BPM:history.RARM', 2);
lcaPutNoWait('132-BPM:history.RARM', 2);
% lcaPutNoWait('116-BPM:history.RARM', 7);
% lcaPutNoWait('132-BPM:history.RARM', 7);
pause(.1);
lcaPut('Spear:Event2',1);
% lcaPut('Spear:Event7',1);

% pause to let event acquire 1 second of data
pause(1);
tic;
Event  = lcaGet('Spear:Event2',0,'Char');
% Event  = lcaGet('Spear:Event7',0,'Char');
N116 = lcaGet('116-BPM:history.NORD');
N132 = lcaGet('132-BPM:history.NORD');

% Diagnostic loop
while N132 ~= nData | N116 ~= nData
    fprintf('   %f seconds after setting 116-BPM:history.RARM=2, 132-BPM:history.RARM=2, and Spear:Event2=Active\n', toc);
    fprintf('   Spear:Event2 = %s\n', Event{1});
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

lcaSetTimeout(.05);
lcaSetRetryCount(100);

tmp = lcaGet('116-BPM:history.RARM');
if tmp ~= 0
   error(['116-BPM:history.RARM = ', num2str(tmp)]);
end
tmp = lcaGet('132-BPM:history.RARM'); 
if tmp ~= 0
    error(['132-BPM:history.RARM = ', num2str(tmp)]);
end


% 116 East Pit
[BPM1, t116] = lcaGet('116-BPM:history');
BPM1 = reshape(BPM1, [4 nBpms 4000]);

% 132 West Pit
[BPM2, t132] = lcaGet('132-BPM:history');
BPM2 = reshape(BPM2, [4 nBpms 4000]);
 
%BPM = [BPM2(:,1:26,:)  BPM1(:,1:end,:) BPM2(:,27:56,:)];
BPM = [BPM2(:,31:nBpms,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];

% % BPM(12,4) and BPM(12,5) got swapped (change back 2-11-2004)
% BPM(:,[73 74],:) = BPM(:,[74 73],:);

if nargin == 0
    i = findrowindex(DeviceList, family2dev('BPMx',0));
    BPM = BPM(:,i,:);
end


lcaSetTimeout(TimeOut);
lcaSetRetryCount(RetryCount);

return