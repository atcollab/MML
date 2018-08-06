function bpm_clear_latch(varargin)
%BPM_CLEAR_LATCH- This function clears the AFE PLL latch


% Operational BPMs
Prefix = getfamilydata('BPM','BaseName');
% Status = getpv('BPM','Status');
% Prefix([17])=[];

% Clear the Sync latch
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':faultClear'], 1);
end



% Clear the test BPM too
Prefix = getfamilydata('BPMTest','BaseName');

% Clear the Sync latch
for i = 1:length(Prefix)
    % Arm
    setpvonline([Prefix{i},':faultClear'], 1);
end

