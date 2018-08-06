function bpminit_fa(varargin)
%BPMINIT_FA - This function initializes the new BPM FA recorder
%  
%  bpminit_fa
%
%  INPUTS
%  1. 
%
%  OUTPUTS
%  1. 
%
%  NOTE
%  1. 
%
%  EXAMPLE
%  1. bpminit_fa;
%
%  See also bpminit, hwinit, cellcontrollerinit, bpm_setenv

%  Written by Greg Portmann

% To do:
% Should exclude [5 9], [7 2] since they are used elsewhere
%

Prefix = getfamilydata('BPM','BaseName');
Dev = family2dev('BPM');
irm = findrowindex([5 9; 7 2], Dev);
Prefix(irm) = [];

% Status = getpv('BPM','Status');
% Prefix([17])=[];

% Clear the Sync latch
% for i = 1:length(Prefix)
%     % Arm
%     setpvonline([Prefix{i},':faultClear'], 1);
% end

for i = 1:length(Prefix)
    % Unarm
    setpvonline([Prefix{i},':wfr:FA:arm'],  0);
end
pause(.1);


% Beam dump threshold level
%for i = 1:length(Prefix)
%    setpvonline([Prefix{i},':lossOfBeamThreshold'], 4000);
%end


for i = 1:length(Prefix)
    % Buffer size
    setpvonline([Prefix{i},':wfr:FA:acqCount'],     50000);
    setpvonline([Prefix{i},':wfr:FA:pretrigCount'], 40000);
end

% Software trigger and beam dump
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':wfr:FA:triggerMask'],  bin2dec('00000011'));
end

% Arm
pause(.3);
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':wfr:FA:arm'],  1);
end



% Manually trigger
% for i = 1:length(Prefix)
%     setpvonline([Prefix{i},':wfr:softTrigger'], 1);
% end
% pause(6);

