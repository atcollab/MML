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

if nargin>1
    if strcmpi(varargin{1},'read')
    end
else
    % Trigger on event timer 2
    mcaput(mcacheckopen({'116-BPM:history.RARM','132-BPM:history.RARM'}),[1 1]);
    pause(.1);

    % Set Event (Software Trigger
    mcaput(mcacheckopen('Spear:Event1'),1);
    pause(5);

end

tic;
Event  = mcaget(mcacheckopen('Spear:Event1'));
NELM116 = mcaget(mcacheckopen('116-BPM:history.NELM'));
NELM132 = mcaget(mcacheckopen('132-BPM:history.NELM'));

N116 = mcaget(mcacheckopen('116-BPM:history.NORD'));
N132 = mcaget(mcacheckopen('132-BPM:history.NORD'));



% Diagnostic loop
while N132 ~= NELM132 | N116 ~= NELM116
    fprintf('   %f seconds after setting 116-BPM:history.RARM=2, 132-BPM:history.RARM=2, and Spear:Event1=Active\n', toc);
    fprintf('   Spear:Event1 = %s\n', int2str(Event));
    fprintf('   116-BPM:history.NORD = %d\n', N116);
    fprintf('   132-BPM:history.NORD = %d\n\n', N132);
    if toc > 10
        fprintf('   BPM Timeout\n');
        error('NORD problem');
    end
    pause(.25);
    Event  = mcaget(mcacheckopen('Spear:Event1'));
    N116 = mcaget(mcacheckopen('116-BPM:history.NORD'));
    N132 = mcaget(mcacheckopen('132-BPM:history.NORD'));
    NELM116 = mcaget(mcacheckopen('116-BPM:history.NELM'));
    NELM132 = mcaget(mcacheckopen('132-BPM:history.NELM'));
end




BPM1=mcaget(mcacheckopen('116-BPM:history'));
BPM1 = reshape(BPM1, [4 61 4000]);

% 132 West Pit
BPM2=mcaget(mcacheckopen('132-BPM:history'));
BPM2 = reshape(BPM2, [4 61 4000]);
 

%BPM = [BPM2(:,31:59,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];
BPM = [BPM2(:,36:61,:)  BPM1(:,1:end,:) BPM2(:,1:30,:)];


i = findrowindex(DeviceList, family2dev('BPMx',0));
BPM = BPM(:,i,:);



