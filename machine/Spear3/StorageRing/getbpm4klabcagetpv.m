function [BPM, t116, t132, Error] = getbpm4k(DeviceList, varargin)
%  BPM = getbpm4k(DeviceList)
%  BPM = getbpm4k(DeviceList, 'read')
%  BPM = getbpm4k(DeviceList, 'arm')
%  BPM = getbpm4k(DeviceList, 'trigger')
%
%  Spear BPM channels
%  |  West pit 132 |    East pit 116 |    West pit 132  |
%  |   1  to  26   |   27  to    82  |    83  to   112  |
%  |[1 1] to [5 1] | [5 2] to [14 1] | [14 2] to [18 7] |


Error = 0;
if nargin == 0
    DeviceList = family2dev('BPMx');
end

if isempty(DeviceList)
    DeviceList = family2dev('BPMx');
end

if nargin > 1
    error('Function input greater than 2 under development');
    if strcmpi(varargin{1},'read')
    end
else
    % Trigger on event timer 2
    setpv('116-BPM:history.RARM',2);
    setpv('132-BPM:history.RARM',2);
    pause(.1);

    % Set Event (Software Trigger
    setpv('Spear:Event1',1);
    pause(1.5);

end

tic;
Event  = getpv('Spear:Event2');
NELM116 = getpv('116-BPM:history.NELM');
NELM132 = getpv('132-BPM:history.NELM');

N116 = getpv('116-BPM:history.NORD');
N132 = getpv('132-BPM:history.NORD');



% Diagnostic loop
while N132 ~= NELM132 | N116 ~= NELM116
    fprintf('   %f seconds after setting 116-BPM:history.RARM=2, 132-BPM:history.RARM=2, and Spear:Event2=Active\n', toc);
    fprintf('   Spear:Event2 = %s\n', int2str(Event));
    fprintf('   116-BPM:history.NORD = %d\n', N116);
    fprintf('   132-BPM:history.NORD = %d\n\n', N132);
    if toc > 10
        fprintf('   BPM Timeout\n');
        error('NORD problem');
    end
    pause(.25);
    Event  = getpv('Spear:Event2');
    N116 = getpv('116-BPM:history.NORD');
    N132 = getpv('132-BPM:history.NORD');
    NELM116 = getpv('116-BPM:history.NELM');
    NELM132 = getpv('132-BPM:history.NELM');
end



%tmp = lcaGet('116-BPM:history.RARM');
%if tmp ~= 0
%    error('116-BPM:history.RARM = 0');
%end

% tmp = lcaGet('132-BPM:history.RARM'); 
% if tmp ~= 0
%     error('132-BPM:history.RARM = 0');
% end


% 116 East Pit
%BPM1 = NaN * ones(1,896000);
%t116 = NaN * NaN*sqrt(-1);
%[BPM1, t116] = lcaGet('116-BPM:history');
[BPM1, tmp, t132] = getpv('116-BPM:history');
BPM1 = reshape(BPM1, [4 56 4000]);

% 132 West Pit
%[BPM2, t132] = lcaGet('132-BPM:history');
[BPM2, tmp, t132] = getpv('132-BPM:history');
BPM2 = reshape(BPM2, [4 56 4000]);
 
%BPM = [BPM2(:,1:26,:)  BPM1(:,1:end,:) BPM2(:,27:56,:)];
BPM = [BPM2(:,31:56,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];

% % BPM(12,4) and BPM(12,5) got swapped (change back 2-11-2004)
% BPM(:,[73 74],:) = BPM(:,[74 73],:);

i = findrowindex(DeviceList, family2dev('BPMx',0));
BPM = BPM(:,i,:);



