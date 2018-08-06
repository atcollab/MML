function [BPM, t116, t132, Error] = getbpm4k(DeviceList)
%  BPM = getbpm4k(DeviceList)
%
%  Spear BPM channels
%  |   1  to  26   |   27  to    82  |    83  to   112  |
%  |[1 1] to [5 1] | [5 2] to [14 1] | [14 2] to [18 7] |

disp('')
disp('MCAGETBPM4K(beta) - on SPEARPC15 only!');
disp('Transferring 4kHz data ...');
Error = 0;
if nargin == 0
    DeviceList = family2dev('BPMx');
end


% Set mcaget timeout to 20 s
if exist('mcamain')==3
    mcamain(1002,20);
elseif exist('mca')==3
    mca(1002,20);
end

mcaput(mcacheckopen('116-BPM:history.RARM'),2);
mcaput(mcacheckopen('132-BPM:history.RARM'),2);
pause(.1);
mcaput(mcacheckopen('Spear:Event2'),1);


tic;
Event  = mcaget(mcacheckopen('Spear:Event2'));
N116 = mcaget(mcacheckopen('116-BPM:history.NORD'));
N132 = mcaget(mcacheckopen('132-BPM:history.NORD'));

% Diagnostic loop
while N132 ~= 896000 | N116 ~= 896000
    fprintf('   %f seconds after setting 116-BPM:history.RARM=2, 132-BPM:history.RARM=2, and Spear:Event2=Active\n', toc);
    disp(Event);
    fprintf('   116-BPM:history.NORD = %d\n', N116);
    fprintf('   132-BPM:history.NORD = %d\n\n', N132);
    if toc > 5
        fprintf('   BPM Timeout\n');
        error('NORD problem');
    end
    pause(.25);
    Event  = mcaget(mcacheckopen('Spear:Event2'));
    N116 = mcaget(mcacheckopen('116-BPM:history.NORD'));
    N132 = mcaget(mcacheckopen('132-BPM:history.NORD'));

end

BPM = [];
t116 = []; t132 = [];
return

% 116 East Pit

BPM1 = mcaget(mcacheckopen('116-BPM:history'));
BPM1 = reshape(BPM1, [4 56 4000]);

% 132 West Pit
BPM2 = mcaget(mcacheckopen('132-BPM:history'));
BPM2 = reshape(BPM2, [4 56 4000]);
 
%BPM = [BPM2(:,1:26,:)  BPM1(:,1:end,:) BPM2(:,27:56,:)];
BPM = [BPM2(:,31:56,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];

% BPM(12,4) and BPM(12,5) got swapped
%BPM(:,[73 74],:) = BPM(:,[74 73],:);  % Changed by Greg Portmann

i = findrowindex(DeviceList, family2dev('BPMx',0));
BPM = BPM(:,i,:);


